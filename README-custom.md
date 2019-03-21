## Custom Implementation

1. The image uses `sentry:onbuild` image which automatically loads plugins and set ups the configuration files in place.
2. `initialize.py` is used to check if the connected database has any tables, if not it loads the dump of the schema. This is done to avoid higher wait times in running sentry migrations which can take up to 5 mins. It also checks if the database exists and creates if doesn't with the given credentials.
3. On next run, this won't change anything with the current database. After this file completes it jobs, a `sentry upgrade` is used to migrate latest changes after the schema dump was taken.
4. After this fixtures are loaded using `sync_fixtures.py`. A fixture file must be of format:
```yaml
# admin details
admin:

  # username for creating superuser
  username:

  # used at the time of creation and also searching for existing superuser
  # if found, password and superuser permission is updated irrespective
  # of the fact that a change is required
  email:

  # admin login password
  password:

# list of teams and their respective projects
teams:

  # team name
  - name:
    # team projects
    projects:
      project_name1: dsn1
      project_name2: dsn2
```

DSN is of format `<scheme>://<public_key>:<secret_key>@<hostname>/<project_id>`. All the parts are mandatory:
* `schema`: should match with the scheme in `system.url-prefix` config.
* `hostname`: should match with hostname in `system.url-prefix` config.
* `project_id`: database incremental id.
    * If not present but project with mapped name is already present, previous project is deleted (since we can't update all the foreign joins) and new one is created.
    * If present and no project with mapped name exists, then the values are updated directly.
    * If not present by mapped name and id, then new project is created.
    * If present both by name and id and they both represent same object, then changes are made to the same project.
    * If present both by name and id but represent two different information, then the values are skipped as this leads to illegal state.
    * If in configuration, two teams have same project name or two dsns have same project id then error is thrown and config validation fails.

If team does not exists then it is created else irrespectively the slug is always updated with lower case team name. Team is searched within static organization.
If a project key already exists then it is updated with new values else new one is created.
