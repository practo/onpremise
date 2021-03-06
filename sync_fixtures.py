from urlparse import urlsplit
from django.db import connection
from django.db.models import get_app, get_models
from django.core.management.color import no_style

import sys
import yaml

if not settings.SENTRY_URL_PREFIX:
    print('Exiting as system.url-prefix is not set in config.yml')
    sys.exit(1)

ORGANIZATION_NAME = 'Practo'
SCHEME = urlsplit(settings.SENTRY_URL_PREFIX).scheme
HOST = urlsplit(settings.SENTRY_URL_PREFIX).hostname


def get_user(username, email, password):
    existing = User.objects.filter(email=email)
    if not existing:
        user = User.objects.create_superuser(username=username, email=email, password=password)
    else:
        user = existing[0]
        user.set_password(password)
        user.is_superuser = True
        user.save()
    return user


def get_organization():
    return Organization.objects.get(name=ORGANIZATION_NAME)


def get_team(organization, team_name):
    existing = Team.objects.filter(organization=organization, name=team_name)
    team_slug = team_name.lower()
    if not existing:
        team = Team.objects.create(organization=organization, name=team_name, slug=team_slug)
    else:
        team = existing[0]
        team.slug = team_slug
        team.save()
    return team


def assign_team_permissions(user, organization, team):
    user_oragnization = OrganizationMember.objects.get_or_create(organization=organization, user=user, role='owner')[0]
    OrganizationMemberTeam.objects.get_or_create(organizationmember=user_oragnization, team=team)


def get_project(organization, project_name, project_id, platform):
    existing_by_name = Project.objects.filter(organization=organization, name=project_name)
    existing_by_id = Project.objects.filter(id=project_id)
    project_slug = project_name.lower()
    if not existing_by_name and existing_by_id:
        project = existing_by_id[0]
        project.name = project_name
        project.organization = organization
        project.slug = project_slug
        project.platform = platform
        project.save()
    elif existing_by_name and not existing_by_id:
        print('Deleting previous project with project id: {}'.format(project_id))
        project = existing_by_name[0]
        project.delete()
        project = Project.objects.create(
            organization=organization,
            name=project_name,
            slug=project_slug,
            id=project_id,
            platform=platform
        )
    elif not existing_by_name and not existing_by_id:
        project = Project.objects.create(
            organization=organization,
            name=project_name,
            slug=project_slug,
            id=project_id,
            platform=platform
        )
    elif existing_by_name[0] == existing_by_id[0]:
        project = existing_by_name[0]
        project.platform = platform
        project.save()
    else:
        raise ValueError(
            'Different project with name {} and id {} already exists, can\'t merge'.format(project_name, project_id)
        )
    return project


def sync_project_key(public_key, private_key, project_id):
    existing = ProjectKey.objects.filter(project_id=project_id)
    if not existing:
        ProjectKey.create(project_id=project_id, public_key=public_key, secret_key=private_key)
    else:
        project_key = existing[0]
        project_key.public_key = public_key
        if private_key is not None:
            project_key.secret_key = private_key
        project_key.save()


class MalformedUrlException(Exception):
    def __init__(self, url, key, message=None):
        super(MalformedUrlException, self).__init__(message or 'unable to parse `{}` - {}'.format(key, url))
        self.url = url
        self.key = key


# TODO: check host
def parse_dsn(url):
    try:
        url_split = urlsplit(url)
        path_split = url_split.path.split('/')
        if url_split.hostname != HOST:
            raise MalformedUrlException(url, 'host', 'hostname should be equal to {} - {}'.format(HOST, url))
        if url_split.scheme != SCHEME:
            raise MalformedUrlException(url, 'scheme', 'scheme should be equal to {} - {}'.format(SCHEME, url))
        if len(path_split) != 2 or not path_split[1]:
            raise MalformedUrlException(url, 'project id')
        if not url_split.username:
            raise MalformedUrlException(url, 'public key')
        return url_split.username, url_split.password, path_split[1]
    except not MalformedUrlException:
        raise MalformedUrlException(url, 'url')


def parse(filename):
    with open(filename) as fixture_file:
        fixtures = yaml.load(fixture_file, Loader=yaml.BaseLoader)
    admin_details = dict(
        username=fixtures['admin']['username'],
        email=fixtures['admin']['email'],
        password=fixtures['admin']['password']
    )
    projects = dict()
    projects_by_name = dict()
    without_errors = True
    for team in fixtures['teams']:
        team_name = team['name']
        for project in team['projects']:
            try:
                project_name = project['name']
                dsn = project['dsn']
                platform = project.get('platform', None)
                public_key, private_key, project_id = parse_dsn(dsn)
                if project_id in projects:
                    raise ValueError(
                        "project {} and {} have same project_id".format(
                            projects[project_id]['name'],
                            project_name
                        )
                    )
                if project_name in projects_by_name:
                    raise ValueError(
                        "project name {} already exists in team {}".format(
                            projects_by_name[project_name]['team'],
                            project_name
                        )
                    )
                project_info = dict(
                    id=project_id,
                    name=project_name,
                    public_key=public_key,
                    private_key=private_key,
                    team=team_name,
                    platform=platform
                )
                projects[project_id] = project_info
                projects_by_name[project_name] = project_info
            except Exception as error:
                without_errors = False
                print('Error in team: {}, project: {} - {}'.format(team_name, project_name, error))
    return admin_details, projects, without_errors

def update_sequences():
    app = get_app('sentry')
    models = get_models(app, include_auto_created=True)
    statements = connection.ops.sequence_reset_sql(no_style(), models)
    cursor = connection.cursor()
    try:
        for sql in statements:
            cursor.execute(sql)
        connection.commit()
    finally:
        cursor.close()

def main():
    print('Loading Fixtures...')
    admin, projects, without_errors = parse("fixtures.yml")

    if not without_errors:
        print('Exiting as there are errors in configuration')
        sys.exit(1)

    print('Syncing User...')
    user = get_user(admin['username'], admin['email'], admin['password'])

    print('Fetching Organization...')
    organization = get_organization()

    teams = dict()
    for project_id, project_info in projects.items():
        project_name = project_info['name']
        team_name = project_info['team']
        try:
            print('Syncing team: {}, project: {}'.format(team_name, project_name))
            project = get_project(organization, project_name, project_id, project_info['platform'])
            if team_name not in teams:
                team = get_team(organization, team_name)
                assign_team_permissions(user, organization, team)
                teams[team_name] = team
            else:
                team = teams[team_name]
            project.add_team(team)
            sync_project_key(project_info['public_key'], project_info['private_key'], project_id)
        except Exception as error:
            print('Skipping team: {}, project: {} - {}'.format(team_name, project_name, error))

    print('Updating sequences...')
    update_sequences()

    print('Sync completed')


if __name__ == '__main__':
    main()
