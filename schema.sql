--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.16
-- Dumped by pg_dump version 9.5.16

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: sentry_increment_project_counter(bigint, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.sentry_increment_project_counter(project bigint, delta integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
        declare
          new_val int;
        begin
          loop
            update sentry_projectcounter set value = value + delta
             where project_id = project
               returning value into new_val;
            if found then
              return new_val;
            end if;
            begin
              insert into sentry_projectcounter(project_id, value)
                   values (project, delta)
                returning value into new_val;
              return new_val;
            exception when unique_violation then
            end;
          end loop;
        end
        $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auth_authenticator; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_authenticator (
    id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    last_used_at timestamp with time zone,
    type integer NOT NULL,
    config text NOT NULL,
    CONSTRAINT auth_authenticator_type_check CHECK ((type >= 0))
);


--
-- Name: auth_authenticator_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_authenticator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_authenticator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_authenticator_id_seq OWNED BY public.auth_authenticator.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user (
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    id integer NOT NULL,
    username character varying(128) NOT NULL,
    first_name character varying(200) NOT NULL,
    email character varying(75) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    is_superuser boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    is_managed boolean NOT NULL,
    is_password_expired boolean NOT NULL,
    last_password_change timestamp with time zone,
    session_nonce character varying(12),
    last_active timestamp with time zone,
    flags bigint
);


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    content_type_id integer,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


--
-- Name: django_site; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_site (
    id integer NOT NULL,
    domain character varying(100) NOT NULL,
    name character varying(50) NOT NULL
);


--
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.django_site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: django_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.django_site_id_seq OWNED BY public.django_site.id;


--
-- Name: jira_ac_tenant; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jira_ac_tenant (
    id bigint NOT NULL,
    organization_id bigint,
    client_key character varying(50) NOT NULL,
    secret character varying(100) NOT NULL,
    base_url character varying(60) NOT NULL,
    public_key character varying(250) NOT NULL
);


--
-- Name: jira_ac_tenant_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jira_ac_tenant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jira_ac_tenant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jira_ac_tenant_id_seq OWNED BY public.jira_ac_tenant.id;


--
-- Name: nodestore_node; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nodestore_node (
    id character varying(40) NOT NULL,
    data text NOT NULL,
    "timestamp" timestamp with time zone NOT NULL
);


--
-- Name: sentry_activity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_activity (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    group_id bigint,
    type integer NOT NULL,
    ident character varying(64),
    user_id integer,
    datetime timestamp with time zone NOT NULL,
    data text,
    CONSTRAINT sentry_activity_type_check CHECK ((type >= 0))
);


--
-- Name: sentry_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_activity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_activity_id_seq OWNED BY public.sentry_activity.id;


--
-- Name: sentry_apiapplication; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_apiapplication (
    id bigint NOT NULL,
    client_id character varying(64) NOT NULL,
    client_secret text NOT NULL,
    owner_id integer NOT NULL,
    name character varying(64) NOT NULL,
    status integer NOT NULL,
    allowed_origins text,
    redirect_uris text NOT NULL,
    homepage_url character varying(200),
    privacy_url character varying(200),
    terms_url character varying(200),
    date_added timestamp with time zone NOT NULL,
    CONSTRAINT sentry_apiapplication_status_check CHECK ((status >= 0))
);


--
-- Name: sentry_apiapplication_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_apiapplication_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_apiapplication_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_apiapplication_id_seq OWNED BY public.sentry_apiapplication.id;


--
-- Name: sentry_apiauthorization; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_apiauthorization (
    id bigint NOT NULL,
    application_id bigint,
    user_id integer NOT NULL,
    scopes bigint NOT NULL,
    date_added timestamp with time zone NOT NULL,
    scope_list text[]
);


--
-- Name: sentry_apiauthorization_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_apiauthorization_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_apiauthorization_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_apiauthorization_id_seq OWNED BY public.sentry_apiauthorization.id;


--
-- Name: sentry_apigrant; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_apigrant (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    application_id bigint NOT NULL,
    code character varying(64) NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    redirect_uri character varying(255) NOT NULL,
    scopes bigint NOT NULL,
    scope_list text[]
);


--
-- Name: sentry_apigrant_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_apigrant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_apigrant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_apigrant_id_seq OWNED BY public.sentry_apigrant.id;


--
-- Name: sentry_apikey; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_apikey (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    label character varying(64) NOT NULL,
    key character varying(32) NOT NULL,
    scopes bigint NOT NULL,
    status integer NOT NULL,
    date_added timestamp with time zone NOT NULL,
    allowed_origins text,
    scope_list text[],
    CONSTRAINT sentry_apikey_status_check CHECK ((status >= 0))
);


--
-- Name: sentry_apikey_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_apikey_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_apikey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_apikey_id_seq OWNED BY public.sentry_apikey.id;


--
-- Name: sentry_apitoken; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_apitoken (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    token character varying(64) NOT NULL,
    scopes bigint NOT NULL,
    date_added timestamp with time zone NOT NULL,
    application_id bigint,
    refresh_token character varying(64),
    expires_at timestamp with time zone,
    scope_list text[]
);


--
-- Name: sentry_apitoken_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_apitoken_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_apitoken_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_apitoken_id_seq OWNED BY public.sentry_apitoken.id;


--
-- Name: sentry_assistant_activity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_assistant_activity (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    guide_id integer NOT NULL,
    viewed_ts timestamp with time zone,
    dismissed_ts timestamp with time zone,
    useful boolean,
    CONSTRAINT sentry_assistant_activity_guide_id_check CHECK ((guide_id >= 0))
);


--
-- Name: sentry_assistant_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_assistant_activity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_assistant_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_assistant_activity_id_seq OWNED BY public.sentry_assistant_activity.id;


--
-- Name: sentry_auditlogentry; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_auditlogentry (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    actor_id integer,
    target_object integer,
    target_user_id integer,
    event integer NOT NULL,
    data text NOT NULL,
    datetime timestamp with time zone NOT NULL,
    ip_address inet,
    actor_label character varying(64),
    actor_key_id bigint,
    CONSTRAINT sentry_auditlogentry_event_check CHECK ((event >= 0)),
    CONSTRAINT sentry_auditlogentry_target_object_check CHECK ((target_object >= 0))
);


--
-- Name: sentry_auditlogentry_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_auditlogentry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_auditlogentry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_auditlogentry_id_seq OWNED BY public.sentry_auditlogentry.id;


--
-- Name: sentry_authidentity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_authidentity (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    auth_provider_id bigint NOT NULL,
    ident character varying(128) NOT NULL,
    data text NOT NULL,
    date_added timestamp with time zone NOT NULL,
    last_verified timestamp with time zone NOT NULL,
    last_synced timestamp with time zone NOT NULL
);


--
-- Name: sentry_authidentity_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_authidentity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_authidentity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_authidentity_id_seq OWNED BY public.sentry_authidentity.id;


--
-- Name: sentry_authprovider; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_authprovider (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    provider character varying(128) NOT NULL,
    config text NOT NULL,
    date_added timestamp with time zone NOT NULL,
    sync_time integer,
    last_sync timestamp with time zone,
    default_role integer NOT NULL,
    default_global_access boolean NOT NULL,
    flags bigint NOT NULL,
    CONSTRAINT sentry_authprovider_default_role_check CHECK ((default_role >= 0)),
    CONSTRAINT sentry_authprovider_sync_time_check CHECK ((sync_time >= 0))
);


--
-- Name: sentry_authprovider_default_teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_authprovider_default_teams (
    id integer NOT NULL,
    authprovider_id bigint NOT NULL,
    team_id bigint NOT NULL
);


--
-- Name: sentry_authprovider_default_teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_authprovider_default_teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_authprovider_default_teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_authprovider_default_teams_id_seq OWNED BY public.sentry_authprovider_default_teams.id;


--
-- Name: sentry_authprovider_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_authprovider_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_authprovider_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_authprovider_id_seq OWNED BY public.sentry_authprovider.id;


--
-- Name: sentry_broadcast; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_broadcast (
    id bigint NOT NULL,
    message character varying(256) NOT NULL,
    link character varying(200),
    is_active boolean NOT NULL,
    date_added timestamp with time zone NOT NULL,
    title character varying(32) NOT NULL,
    upstream_id character varying(32),
    date_expires timestamp with time zone
);


--
-- Name: sentry_broadcast_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_broadcast_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_broadcast_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_broadcast_id_seq OWNED BY public.sentry_broadcast.id;


--
-- Name: sentry_broadcastseen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_broadcastseen (
    id bigint NOT NULL,
    broadcast_id bigint NOT NULL,
    user_id integer NOT NULL,
    date_seen timestamp with time zone NOT NULL
);


--
-- Name: sentry_broadcastseen_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_broadcastseen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_broadcastseen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_broadcastseen_id_seq OWNED BY public.sentry_broadcastseen.id;


--
-- Name: sentry_commit; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_commit (
    id bigint NOT NULL,
    organization_id integer NOT NULL,
    repository_id integer NOT NULL,
    key character varying(64) NOT NULL,
    date_added timestamp with time zone NOT NULL,
    author_id bigint,
    message text,
    CONSTRAINT sentry_commit_organization_id_check CHECK ((organization_id >= 0)),
    CONSTRAINT sentry_commit_repository_id_check CHECK ((repository_id >= 0))
);


--
-- Name: sentry_commit_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_commit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_commit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_commit_id_seq OWNED BY public.sentry_commit.id;


--
-- Name: sentry_commitauthor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_commitauthor (
    id bigint NOT NULL,
    organization_id integer NOT NULL,
    name character varying(128),
    email character varying(75) NOT NULL,
    external_id character varying(164),
    CONSTRAINT sentry_commitauthor_organization_id_check CHECK ((organization_id >= 0))
);


--
-- Name: sentry_commitauthor_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_commitauthor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_commitauthor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_commitauthor_id_seq OWNED BY public.sentry_commitauthor.id;


--
-- Name: sentry_commitfilechange; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_commitfilechange (
    id bigint NOT NULL,
    organization_id integer NOT NULL,
    commit_id bigint NOT NULL,
    filename text NOT NULL,
    type character varying(1) NOT NULL,
    CONSTRAINT sentry_commitfilechange_organization_id_check CHECK ((organization_id >= 0))
);


--
-- Name: sentry_commitfilechange_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_commitfilechange_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_commitfilechange_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_commitfilechange_id_seq OWNED BY public.sentry_commitfilechange.id;


--
-- Name: sentry_deletedorganization; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_deletedorganization (
    id bigint NOT NULL,
    actor_label character varying(64),
    actor_id bigint,
    actor_key character varying(32),
    ip_address inet,
    date_deleted timestamp with time zone NOT NULL,
    date_created timestamp with time zone,
    reason text,
    name character varying(64),
    slug character varying(50)
);


--
-- Name: sentry_deletedorganization_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_deletedorganization_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_deletedorganization_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_deletedorganization_id_seq OWNED BY public.sentry_deletedorganization.id;


--
-- Name: sentry_deletedproject; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_deletedproject (
    id bigint NOT NULL,
    actor_label character varying(64),
    actor_id bigint,
    actor_key character varying(32),
    ip_address inet,
    date_deleted timestamp with time zone NOT NULL,
    date_created timestamp with time zone,
    reason text,
    slug character varying(50),
    name character varying(200),
    organization_id bigint,
    organization_name character varying(64),
    organization_slug character varying(50),
    platform character varying(64)
);


--
-- Name: sentry_deletedproject_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_deletedproject_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_deletedproject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_deletedproject_id_seq OWNED BY public.sentry_deletedproject.id;


--
-- Name: sentry_deletedteam; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_deletedteam (
    id bigint NOT NULL,
    actor_label character varying(64),
    actor_id bigint,
    actor_key character varying(32),
    ip_address inet,
    date_deleted timestamp with time zone NOT NULL,
    date_created timestamp with time zone,
    reason text,
    name character varying(64),
    slug character varying(50),
    organization_id bigint,
    organization_name character varying(64),
    organization_slug character varying(50)
);


--
-- Name: sentry_deletedteam_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_deletedteam_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_deletedteam_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_deletedteam_id_seq OWNED BY public.sentry_deletedteam.id;


--
-- Name: sentry_deploy; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_deploy (
    id bigint NOT NULL,
    organization_id integer NOT NULL,
    release_id bigint NOT NULL,
    environment_id integer NOT NULL,
    date_finished timestamp with time zone NOT NULL,
    date_started timestamp with time zone,
    name character varying(64),
    url character varying(200),
    notified boolean,
    CONSTRAINT sentry_deploy_environment_id_check CHECK ((environment_id >= 0)),
    CONSTRAINT sentry_deploy_organization_id_check CHECK ((organization_id >= 0))
);


--
-- Name: sentry_deploy_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_deploy_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_deploy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_deploy_id_seq OWNED BY public.sentry_deploy.id;


--
-- Name: sentry_distribution; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_distribution (
    id bigint NOT NULL,
    organization_id integer NOT NULL,
    release_id bigint NOT NULL,
    name character varying(64) NOT NULL,
    date_added timestamp with time zone NOT NULL,
    CONSTRAINT sentry_distribution_organization_id_check CHECK ((organization_id >= 0))
);


--
-- Name: sentry_distribution_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_distribution_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_distribution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_distribution_id_seq OWNED BY public.sentry_distribution.id;


--
-- Name: sentry_dsymapp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_dsymapp (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    app_id character varying(64) NOT NULL,
    sync_id character varying(64),
    data text NOT NULL,
    platform integer NOT NULL,
    last_synced timestamp with time zone NOT NULL,
    date_added timestamp with time zone NOT NULL,
    CONSTRAINT sentry_dsymapp_platform_check CHECK ((platform >= 0))
);


--
-- Name: sentry_dsymapp_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_dsymapp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_dsymapp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_dsymapp_id_seq OWNED BY public.sentry_dsymapp.id;


--
-- Name: sentry_email; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_email (
    id bigint NOT NULL,
    email public.citext NOT NULL,
    date_added timestamp with time zone NOT NULL
);


--
-- Name: sentry_email_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_email_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_email_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_email_id_seq OWNED BY public.sentry_email.id;


--
-- Name: sentry_environment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_environment (
    id bigint NOT NULL,
    project_id integer,
    name character varying(64) NOT NULL,
    date_added timestamp with time zone NOT NULL,
    organization_id integer NOT NULL,
    CONSTRAINT ck_organization_id_pstv_217ef821157f703 CHECK ((organization_id >= 0)),
    CONSTRAINT sentry_environment_project_id_check CHECK ((project_id >= 0))
);


--
-- Name: sentry_environment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_environment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_environment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_environment_id_seq OWNED BY public.sentry_environment.id;


--
-- Name: sentry_environmentproject; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_environmentproject (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    environment_id bigint NOT NULL,
    is_hidden boolean
);


--
-- Name: sentry_environmentproject_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_environmentproject_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_environmentproject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_environmentproject_id_seq OWNED BY public.sentry_environmentproject.id;


--
-- Name: sentry_environmentrelease; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_environmentrelease (
    id bigint NOT NULL,
    project_id integer,
    release_id integer NOT NULL,
    environment_id integer NOT NULL,
    first_seen timestamp with time zone NOT NULL,
    last_seen timestamp with time zone NOT NULL,
    organization_id integer NOT NULL,
    CONSTRAINT ck_organization_id_pstv_4f21eb33d1f59511 CHECK ((organization_id >= 0)),
    CONSTRAINT sentry_environmentrelease_environment_id_check CHECK ((environment_id >= 0)),
    CONSTRAINT sentry_environmentrelease_project_id_check CHECK ((project_id >= 0)),
    CONSTRAINT sentry_environmentrelease_release_id_check CHECK ((release_id >= 0))
);


--
-- Name: sentry_environmentrelease_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_environmentrelease_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_environmentrelease_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_environmentrelease_id_seq OWNED BY public.sentry_environmentrelease.id;


--
-- Name: sentry_eventmapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_eventmapping (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    group_id bigint NOT NULL,
    event_id character varying(32) NOT NULL,
    date_added timestamp with time zone NOT NULL
);


--
-- Name: sentry_eventmapping_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_eventmapping_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_eventmapping_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_eventmapping_id_seq OWNED BY public.sentry_eventmapping.id;


--
-- Name: sentry_eventprocessingissue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_eventprocessingissue (
    id bigint NOT NULL,
    raw_event_id bigint NOT NULL,
    processing_issue_id bigint NOT NULL
);


--
-- Name: sentry_eventprocessingissue_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_eventprocessingissue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_eventprocessingissue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_eventprocessingissue_id_seq OWNED BY public.sentry_eventprocessingissue.id;


--
-- Name: sentry_eventtag; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_eventtag (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    event_id bigint NOT NULL,
    key_id bigint NOT NULL,
    value_id bigint NOT NULL,
    date_added timestamp with time zone NOT NULL,
    group_id bigint
);


--
-- Name: sentry_eventtag_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_eventtag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_eventtag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_eventtag_id_seq OWNED BY public.sentry_eventtag.id;


--
-- Name: sentry_eventuser; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_eventuser (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    ident character varying(128),
    email character varying(75),
    username character varying(128),
    ip_address inet,
    date_added timestamp with time zone NOT NULL,
    hash character varying(32) NOT NULL,
    name character varying(128)
);


--
-- Name: sentry_eventuser_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_eventuser_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_eventuser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_eventuser_id_seq OWNED BY public.sentry_eventuser.id;


--
-- Name: sentry_externalissue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_externalissue (
    id bigint NOT NULL,
    organization_id integer NOT NULL,
    integration_id integer NOT NULL,
    key character varying(128) NOT NULL,
    date_added timestamp with time zone NOT NULL,
    title text,
    description text,
    CONSTRAINT sentry_externalissue_integration_id_check CHECK ((integration_id >= 0)),
    CONSTRAINT sentry_externalissue_organization_id_check CHECK ((organization_id >= 0))
);


--
-- Name: sentry_externalissue_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_externalissue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_externalissue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_externalissue_id_seq OWNED BY public.sentry_externalissue.id;


--
-- Name: sentry_featureadoption; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_featureadoption (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    feature_id integer NOT NULL,
    date_completed timestamp with time zone NOT NULL,
    complete boolean NOT NULL,
    applicable boolean NOT NULL,
    data text NOT NULL,
    CONSTRAINT sentry_featureadoption_feature_id_check CHECK ((feature_id >= 0))
);


--
-- Name: sentry_featureadoption_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_featureadoption_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_featureadoption_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_featureadoption_id_seq OWNED BY public.sentry_featureadoption.id;


--
-- Name: sentry_file; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_file (
    id bigint NOT NULL,
    name text NOT NULL,
    path text,
    type character varying(64) NOT NULL,
    size integer,
    "timestamp" timestamp with time zone NOT NULL,
    checksum character varying(40),
    headers text NOT NULL,
    blob_id bigint,
    CONSTRAINT sentry_file_size_check CHECK ((size >= 0))
);


--
-- Name: sentry_file_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_file_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_file_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_file_id_seq OWNED BY public.sentry_file.id;


--
-- Name: sentry_fileblob; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_fileblob (
    id bigint NOT NULL,
    path text,
    size integer,
    checksum character varying(40) NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    CONSTRAINT sentry_fileblob_size_check CHECK ((size >= 0))
);


--
-- Name: sentry_fileblob_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_fileblob_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_fileblob_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_fileblob_id_seq OWNED BY public.sentry_fileblob.id;


--
-- Name: sentry_fileblobindex; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_fileblobindex (
    id bigint NOT NULL,
    file_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    "offset" integer NOT NULL,
    CONSTRAINT sentry_fileblobindex_offset_check CHECK (("offset" >= 0))
);


--
-- Name: sentry_fileblobindex_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_fileblobindex_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_fileblobindex_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_fileblobindex_id_seq OWNED BY public.sentry_fileblobindex.id;


--
-- Name: sentry_fileblobowner; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_fileblobowner (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    organization_id bigint NOT NULL
);


--
-- Name: sentry_fileblobowner_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_fileblobowner_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_fileblobowner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_fileblobowner_id_seq OWNED BY public.sentry_fileblobowner.id;


--
-- Name: sentry_filterkey; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_filterkey (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    key character varying(32) NOT NULL,
    values_seen integer NOT NULL,
    label character varying(64),
    status integer NOT NULL,
    CONSTRAINT ck_status_pstv_56aaa5973127b013 CHECK ((status >= 0)),
    CONSTRAINT ck_values_seen_pstv_12eab0d3ff94a35c CHECK ((values_seen >= 0)),
    CONSTRAINT sentry_filterkey_status_check CHECK ((status >= 0)),
    CONSTRAINT sentry_filterkey_values_seen_check CHECK ((values_seen >= 0))
);


--
-- Name: sentry_filterkey_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_filterkey_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_filterkey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_filterkey_id_seq OWNED BY public.sentry_filterkey.id;


--
-- Name: sentry_filtervalue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_filtervalue (
    id bigint NOT NULL,
    key character varying(32) NOT NULL,
    value character varying(200) NOT NULL,
    project_id bigint,
    times_seen integer NOT NULL,
    last_seen timestamp with time zone,
    first_seen timestamp with time zone,
    data text,
    CONSTRAINT ck_times_seen_pstv_10c4372f28cef967 CHECK ((times_seen >= 0)),
    CONSTRAINT sentry_filtervalue_times_seen_check CHECK ((times_seen >= 0))
);


--
-- Name: sentry_filtervalue_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_filtervalue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_filtervalue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_filtervalue_id_seq OWNED BY public.sentry_filtervalue.id;


--
-- Name: sentry_groupasignee; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_groupasignee (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    group_id bigint NOT NULL,
    user_id integer,
    date_added timestamp with time zone NOT NULL,
    team_id bigint,
    CONSTRAINT require_team_or_user_but_not_both CHECK (((NOT ((team_id IS NOT NULL) AND (user_id IS NOT NULL))) AND (NOT ((team_id IS NULL) AND (user_id IS NULL)))))
);


--
-- Name: sentry_groupasignee_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_groupasignee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_groupasignee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_groupasignee_id_seq OWNED BY public.sentry_groupasignee.id;


--
-- Name: sentry_groupbookmark; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_groupbookmark (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    group_id bigint NOT NULL,
    user_id integer NOT NULL,
    date_added timestamp with time zone
);


--
-- Name: sentry_groupbookmark_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_groupbookmark_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_groupbookmark_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_groupbookmark_id_seq OWNED BY public.sentry_groupbookmark.id;


--
-- Name: sentry_groupcommitresolution; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_groupcommitresolution (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    commit_id integer NOT NULL,
    datetime timestamp with time zone NOT NULL,
    CONSTRAINT sentry_groupcommitresolution_commit_id_check CHECK ((commit_id >= 0)),
    CONSTRAINT sentry_groupcommitresolution_group_id_check CHECK ((group_id >= 0))
);


--
-- Name: sentry_groupcommitresolution_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_groupcommitresolution_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_groupcommitresolution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_groupcommitresolution_id_seq OWNED BY public.sentry_groupcommitresolution.id;


--
-- Name: sentry_groupedmessage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_groupedmessage (
    id bigint NOT NULL,
    logger character varying(64) NOT NULL,
    level integer NOT NULL,
    message text NOT NULL,
    view character varying(200),
    status integer NOT NULL,
    times_seen integer NOT NULL,
    last_seen timestamp with time zone NOT NULL,
    first_seen timestamp with time zone NOT NULL,
    data text,
    score integer NOT NULL,
    project_id bigint,
    time_spent_total integer NOT NULL,
    time_spent_count integer NOT NULL,
    resolved_at timestamp with time zone,
    active_at timestamp with time zone,
    is_public boolean,
    platform character varying(64),
    num_comments integer,
    first_release_id bigint,
    short_id bigint,
    CONSTRAINT ck_num_comments_pstv_44851d4d5d739eab CHECK ((num_comments >= 0)),
    CONSTRAINT sentry_groupedmessage_level_check CHECK ((level >= 0)),
    CONSTRAINT sentry_groupedmessage_num_comments_check CHECK ((num_comments >= 0)),
    CONSTRAINT sentry_groupedmessage_status_check CHECK ((status >= 0)),
    CONSTRAINT sentry_groupedmessage_times_seen_check CHECK ((times_seen >= 0))
);


--
-- Name: sentry_groupedmessage_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_groupedmessage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_groupedmessage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_groupedmessage_id_seq OWNED BY public.sentry_groupedmessage.id;


--
-- Name: sentry_groupemailthread; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_groupemailthread (
    id bigint NOT NULL,
    email character varying(75) NOT NULL,
    project_id bigint NOT NULL,
    group_id bigint NOT NULL,
    msgid character varying(100) NOT NULL,
    date timestamp with time zone NOT NULL
);


--
-- Name: sentry_groupemailthread_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_groupemailthread_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_groupemailthread_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_groupemailthread_id_seq OWNED BY public.sentry_groupemailthread.id;


--
-- Name: sentry_groupenvironment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_groupenvironment (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    environment_id integer NOT NULL,
    first_release_id integer,
    CONSTRAINT ck_first_release_id_pstv_7ff793b9446dd7b CHECK ((first_release_id >= 0)),
    CONSTRAINT sentry_groupenvironment_environment_id_check CHECK ((environment_id >= 0)),
    CONSTRAINT sentry_groupenvironment_first_release_id_check CHECK ((first_release_id >= 0)),
    CONSTRAINT sentry_groupenvironment_group_id_check CHECK ((group_id >= 0))
);


--
-- Name: sentry_groupenvironment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_groupenvironment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_groupenvironment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_groupenvironment_id_seq OWNED BY public.sentry_groupenvironment.id;


--
-- Name: sentry_grouphash; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_grouphash (
    id bigint NOT NULL,
    project_id bigint,
    hash character varying(32) NOT NULL,
    group_id bigint,
    state integer,
    group_tombstone_id integer,
    CONSTRAINT ck_group_tombstone_id_pstv_17e9b9f9962c3c62 CHECK ((group_tombstone_id >= 0)),
    CONSTRAINT ck_state_pstv_556c62431651a0b1 CHECK ((state >= 0)),
    CONSTRAINT sentry_grouphash_group_tombstone_id_check CHECK ((group_tombstone_id >= 0)),
    CONSTRAINT sentry_grouphash_state_check CHECK ((state >= 0))
);


--
-- Name: sentry_grouphash_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_grouphash_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_grouphash_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_grouphash_id_seq OWNED BY public.sentry_grouphash.id;


--
-- Name: sentry_grouphashtombstone; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_grouphashtombstone (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    hash character varying(32) NOT NULL,
    deleted_at timestamp with time zone NOT NULL
);


--
-- Name: sentry_grouphashtombstone_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_grouphashtombstone_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_grouphashtombstone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_grouphashtombstone_id_seq OWNED BY public.sentry_grouphashtombstone.id;


--
-- Name: sentry_grouplink; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_grouplink (
    id bigint NOT NULL,
    group_id bigint NOT NULL,
    project_id bigint NOT NULL,
    linked_type integer NOT NULL,
    linked_id bigint NOT NULL,
    relationship integer NOT NULL,
    data text NOT NULL,
    datetime timestamp with time zone NOT NULL,
    CONSTRAINT sentry_grouplink_linked_type_check CHECK ((linked_type >= 0)),
    CONSTRAINT sentry_grouplink_relationship_check CHECK ((relationship >= 0))
);


--
-- Name: sentry_grouplink_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_grouplink_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_grouplink_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_grouplink_id_seq OWNED BY public.sentry_grouplink.id;


--
-- Name: sentry_groupmeta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_groupmeta (
    id bigint NOT NULL,
    group_id bigint NOT NULL,
    key character varying(64) NOT NULL,
    value text NOT NULL
);


--
-- Name: sentry_groupmeta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_groupmeta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_groupmeta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_groupmeta_id_seq OWNED BY public.sentry_groupmeta.id;


--
-- Name: sentry_groupredirect; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_groupredirect (
    id bigint NOT NULL,
    group_id bigint NOT NULL,
    previous_group_id bigint NOT NULL
);


--
-- Name: sentry_groupredirect_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_groupredirect_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_groupredirect_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_groupredirect_id_seq OWNED BY public.sentry_groupredirect.id;


--
-- Name: sentry_grouprelease; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_grouprelease (
    id bigint NOT NULL,
    project_id integer NOT NULL,
    group_id integer NOT NULL,
    release_id integer NOT NULL,
    environment character varying(64) NOT NULL,
    first_seen timestamp with time zone NOT NULL,
    last_seen timestamp with time zone NOT NULL,
    CONSTRAINT sentry_grouprelease_group_id_check CHECK ((group_id >= 0)),
    CONSTRAINT sentry_grouprelease_project_id_check CHECK ((project_id >= 0)),
    CONSTRAINT sentry_grouprelease_release_id_check CHECK ((release_id >= 0))
);


--
-- Name: sentry_grouprelease_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_grouprelease_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_grouprelease_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_grouprelease_id_seq OWNED BY public.sentry_grouprelease.id;


--
-- Name: sentry_groupresolution; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_groupresolution (
    id bigint NOT NULL,
    group_id bigint NOT NULL,
    release_id bigint NOT NULL,
    datetime timestamp with time zone NOT NULL,
    status integer NOT NULL,
    type integer,
    actor_id integer,
    CONSTRAINT ck_actor_id_pstv_750a8dad4187faba CHECK ((actor_id >= 0)),
    CONSTRAINT ck_status_pstv_375a4efcf0df73b9 CHECK ((status >= 0)),
    CONSTRAINT ck_type_pstv_15c3a9fd0180fff9 CHECK ((type >= 0)),
    CONSTRAINT sentry_groupresolution_actor_id_check CHECK ((actor_id >= 0)),
    CONSTRAINT sentry_groupresolution_status_check CHECK ((status >= 0)),
    CONSTRAINT sentry_groupresolution_type_check CHECK ((type >= 0))
);


--
-- Name: sentry_groupresolution_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_groupresolution_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_groupresolution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_groupresolution_id_seq OWNED BY public.sentry_groupresolution.id;


--
-- Name: sentry_grouprulestatus; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_grouprulestatus (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    rule_id bigint NOT NULL,
    group_id bigint NOT NULL,
    status smallint NOT NULL,
    date_added timestamp with time zone NOT NULL,
    last_active timestamp with time zone,
    CONSTRAINT sentry_grouprulestatus_status_check CHECK ((status >= 0))
);


--
-- Name: sentry_grouprulestatus_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_grouprulestatus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_grouprulestatus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_grouprulestatus_id_seq OWNED BY public.sentry_grouprulestatus.id;


--
-- Name: sentry_groupseen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_groupseen (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    group_id bigint NOT NULL,
    user_id integer NOT NULL,
    last_seen timestamp with time zone NOT NULL
);


--
-- Name: sentry_groupseen_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_groupseen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_groupseen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_groupseen_id_seq OWNED BY public.sentry_groupseen.id;


--
-- Name: sentry_groupshare; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_groupshare (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    group_id bigint NOT NULL,
    uuid character varying(32) NOT NULL,
    user_id integer,
    date_added timestamp with time zone NOT NULL
);


--
-- Name: sentry_groupshare_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_groupshare_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_groupshare_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_groupshare_id_seq OWNED BY public.sentry_groupshare.id;


--
-- Name: sentry_groupsnooze; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_groupsnooze (
    id bigint NOT NULL,
    group_id bigint NOT NULL,
    until timestamp with time zone,
    count integer,
    "window" integer,
    user_count integer,
    user_window integer,
    state text,
    actor_id integer,
    CONSTRAINT ck_actor_id_pstv_1174f21750349df2 CHECK ((actor_id >= 0)),
    CONSTRAINT ck_count_pstv_2e729d18cc059d41 CHECK ((count >= 0)),
    CONSTRAINT ck_user_count_pstv_26e6359669512ec8 CHECK ((user_count >= 0)),
    CONSTRAINT ck_user_window_pstv_5621099b76ac766a CHECK ((user_window >= 0)),
    CONSTRAINT ck_window_pstv_2569b2f0095a6e41 CHECK (("window" >= 0)),
    CONSTRAINT sentry_groupsnooze_actor_id_check CHECK ((actor_id >= 0)),
    CONSTRAINT sentry_groupsnooze_count_check CHECK ((count >= 0)),
    CONSTRAINT sentry_groupsnooze_user_count_check CHECK ((user_count >= 0)),
    CONSTRAINT sentry_groupsnooze_user_window_check CHECK ((user_window >= 0)),
    CONSTRAINT sentry_groupsnooze_window_check CHECK (("window" >= 0))
);


--
-- Name: sentry_groupsnooze_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_groupsnooze_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_groupsnooze_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_groupsnooze_id_seq OWNED BY public.sentry_groupsnooze.id;


--
-- Name: sentry_groupsubscription; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_groupsubscription (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    group_id bigint NOT NULL,
    user_id integer NOT NULL,
    is_active boolean NOT NULL,
    reason integer NOT NULL,
    date_added timestamp with time zone,
    CONSTRAINT sentry_groupsubscription_reason_check CHECK ((reason >= 0))
);


--
-- Name: sentry_groupsubscription_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_groupsubscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_groupsubscription_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_groupsubscription_id_seq OWNED BY public.sentry_groupsubscription.id;


--
-- Name: sentry_grouptagkey; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_grouptagkey (
    id bigint NOT NULL,
    project_id bigint,
    group_id bigint NOT NULL,
    key character varying(32) NOT NULL,
    values_seen integer NOT NULL,
    CONSTRAINT sentry_grouptagkey_values_seen_check CHECK ((values_seen >= 0))
);


--
-- Name: sentry_grouptagkey_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_grouptagkey_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_grouptagkey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_grouptagkey_id_seq OWNED BY public.sentry_grouptagkey.id;


--
-- Name: sentry_grouptombstone; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_grouptombstone (
    id bigint NOT NULL,
    previous_group_id integer NOT NULL,
    project_id bigint NOT NULL,
    level integer NOT NULL,
    message text NOT NULL,
    culprit character varying(200),
    data text,
    actor_id integer,
    CONSTRAINT sentry_grouptombstone_actor_id_check CHECK ((actor_id >= 0)),
    CONSTRAINT sentry_grouptombstone_level_check CHECK ((level >= 0)),
    CONSTRAINT sentry_grouptombstone_previous_group_id_check CHECK ((previous_group_id >= 0))
);


--
-- Name: sentry_grouptombstone_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_grouptombstone_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_grouptombstone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_grouptombstone_id_seq OWNED BY public.sentry_grouptombstone.id;


--
-- Name: sentry_hipchat_ac_tenant; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_hipchat_ac_tenant (
    id character varying(40) NOT NULL,
    room_id character varying(40) NOT NULL,
    room_name character varying(200),
    room_owner_id character varying(40),
    room_owner_name character varying(200),
    secret character varying(120) NOT NULL,
    homepage character varying(250) NOT NULL,
    token_url character varying(250) NOT NULL,
    capabilities_url character varying(250) NOT NULL,
    api_base_url character varying(250) NOT NULL,
    installed_from character varying(250) NOT NULL,
    auth_user_id integer
);


--
-- Name: sentry_hipchat_ac_tenant_organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_hipchat_ac_tenant_organizations (
    id integer NOT NULL,
    tenant_id character varying(40) NOT NULL,
    organization_id bigint NOT NULL
);


--
-- Name: sentry_hipchat_ac_tenant_organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_hipchat_ac_tenant_organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_hipchat_ac_tenant_organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_hipchat_ac_tenant_organizations_id_seq OWNED BY public.sentry_hipchat_ac_tenant_organizations.id;


--
-- Name: sentry_hipchat_ac_tenant_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_hipchat_ac_tenant_projects (
    id integer NOT NULL,
    tenant_id character varying(40) NOT NULL,
    project_id bigint NOT NULL
);


--
-- Name: sentry_hipchat_ac_tenant_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_hipchat_ac_tenant_projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_hipchat_ac_tenant_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_hipchat_ac_tenant_projects_id_seq OWNED BY public.sentry_hipchat_ac_tenant_projects.id;


--
-- Name: sentry_identity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_identity (
    id bigint NOT NULL,
    idp_id bigint NOT NULL,
    user_id integer NOT NULL,
    external_id character varying(64) NOT NULL,
    data text NOT NULL,
    status integer NOT NULL,
    scopes text[],
    date_verified timestamp with time zone NOT NULL,
    date_added timestamp with time zone NOT NULL,
    CONSTRAINT sentry_identity_status_check CHECK ((status >= 0))
);


--
-- Name: sentry_identity_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_identity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_identity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_identity_id_seq OWNED BY public.sentry_identity.id;


--
-- Name: sentry_identityprovider; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_identityprovider (
    id bigint NOT NULL,
    type character varying(64) NOT NULL,
    config text NOT NULL,
    date_added timestamp with time zone,
    external_id character varying(64)
);


--
-- Name: sentry_identityprovider_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_identityprovider_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_identityprovider_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_identityprovider_id_seq OWNED BY public.sentry_identityprovider.id;


--
-- Name: sentry_integration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_integration (
    id bigint NOT NULL,
    provider character varying(64) NOT NULL,
    external_id character varying(64) NOT NULL,
    name character varying(200) NOT NULL,
    metadata text NOT NULL,
    date_added timestamp with time zone
);


--
-- Name: sentry_integration_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_integration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_integration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_integration_id_seq OWNED BY public.sentry_integration.id;


--
-- Name: sentry_latestrelease; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_latestrelease (
    id bigint NOT NULL,
    repository_id bigint NOT NULL,
    environment_id bigint NOT NULL,
    release_id bigint NOT NULL,
    deploy_id bigint,
    commit_id bigint
);


--
-- Name: sentry_latestrelease_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_latestrelease_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_latestrelease_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_latestrelease_id_seq OWNED BY public.sentry_latestrelease.id;


--
-- Name: sentry_lostpasswordhash; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_lostpasswordhash (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    hash character varying(32) NOT NULL,
    date_added timestamp with time zone NOT NULL
);


--
-- Name: sentry_lostpasswordhash_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_lostpasswordhash_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_lostpasswordhash_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_lostpasswordhash_id_seq OWNED BY public.sentry_lostpasswordhash.id;


--
-- Name: sentry_message; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_message (
    id bigint NOT NULL,
    message text NOT NULL,
    datetime timestamp with time zone NOT NULL,
    data text,
    group_id bigint,
    message_id character varying(32),
    project_id bigint,
    time_spent integer,
    platform character varying(64)
);


--
-- Name: sentry_message_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_message_id_seq OWNED BY public.sentry_message.id;


--
-- Name: sentry_messagefiltervalue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_messagefiltervalue (
    id bigint NOT NULL,
    group_id bigint NOT NULL,
    times_seen integer NOT NULL,
    key character varying(32) NOT NULL,
    value character varying(200) NOT NULL,
    project_id bigint,
    last_seen timestamp with time zone,
    first_seen timestamp with time zone,
    CONSTRAINT sentry_messagefiltervalue_times_seen_check CHECK ((times_seen >= 0))
);


--
-- Name: sentry_messagefiltervalue_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_messagefiltervalue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_messagefiltervalue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_messagefiltervalue_id_seq OWNED BY public.sentry_messagefiltervalue.id;


--
-- Name: sentry_messageindex; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_messageindex (
    id bigint NOT NULL,
    object_id integer NOT NULL,
    "column" character varying(32) NOT NULL,
    value character varying(128) NOT NULL,
    CONSTRAINT sentry_messageindex_object_id_check CHECK ((object_id >= 0))
);


--
-- Name: sentry_messageindex_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_messageindex_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_messageindex_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_messageindex_id_seq OWNED BY public.sentry_messageindex.id;


--
-- Name: sentry_option; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_option (
    id bigint NOT NULL,
    key character varying(64) NOT NULL,
    value text NOT NULL,
    last_updated timestamp with time zone NOT NULL
);


--
-- Name: sentry_option_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_option_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_option_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_option_id_seq OWNED BY public.sentry_option.id;


--
-- Name: sentry_organization; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_organization (
    id bigint NOT NULL,
    name character varying(64) NOT NULL,
    status integer NOT NULL,
    date_added timestamp with time zone NOT NULL,
    slug character varying(50) NOT NULL,
    flags bigint NOT NULL,
    default_role character varying(32) NOT NULL,
    CONSTRAINT sentry_organization_status_check CHECK ((status >= 0))
);


--
-- Name: sentry_organization_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_organization_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_organization_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_organization_id_seq OWNED BY public.sentry_organization.id;


--
-- Name: sentry_organizationaccessrequest; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_organizationaccessrequest (
    id bigint NOT NULL,
    team_id bigint NOT NULL,
    member_id bigint NOT NULL
);


--
-- Name: sentry_organizationaccessrequest_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_organizationaccessrequest_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_organizationaccessrequest_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_organizationaccessrequest_id_seq OWNED BY public.sentry_organizationaccessrequest.id;


--
-- Name: sentry_organizationavatar; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_organizationavatar (
    id bigint NOT NULL,
    file_id bigint,
    ident character varying(32) NOT NULL,
    organization_id bigint NOT NULL,
    avatar_type smallint NOT NULL,
    CONSTRAINT sentry_organizationavatar_avatar_type_check CHECK ((avatar_type >= 0))
);


--
-- Name: sentry_organizationavatar_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_organizationavatar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_organizationavatar_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_organizationavatar_id_seq OWNED BY public.sentry_organizationavatar.id;


--
-- Name: sentry_organizationintegration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_organizationintegration (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    integration_id bigint NOT NULL,
    config text NOT NULL,
    default_auth_id integer,
    date_added timestamp with time zone,
    CONSTRAINT ck_default_auth_id_pstv_69e09714ab85b548 CHECK ((default_auth_id >= 0)),
    CONSTRAINT sentry_organizationintegration_default_auth_id_check CHECK ((default_auth_id >= 0))
);


--
-- Name: sentry_organizationintegration_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_organizationintegration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_organizationintegration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_organizationintegration_id_seq OWNED BY public.sentry_organizationintegration.id;


--
-- Name: sentry_organizationmember; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_organizationmember (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    user_id integer,
    type integer NOT NULL,
    date_added timestamp with time zone NOT NULL,
    email character varying(75),
    has_global_access boolean NOT NULL,
    flags bigint NOT NULL,
    role character varying(32) NOT NULL,
    token character varying(64),
    CONSTRAINT sentry_organizationmember_type_check CHECK ((type >= 0))
);


--
-- Name: sentry_organizationmember_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_organizationmember_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_organizationmember_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_organizationmember_id_seq OWNED BY public.sentry_organizationmember.id;


--
-- Name: sentry_organizationmember_teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_organizationmember_teams (
    id integer NOT NULL,
    organizationmember_id bigint NOT NULL,
    team_id bigint NOT NULL,
    is_active boolean NOT NULL
);


--
-- Name: sentry_organizationmember_teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_organizationmember_teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_organizationmember_teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_organizationmember_teams_id_seq OWNED BY public.sentry_organizationmember_teams.id;


--
-- Name: sentry_organizationonboardingtask; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_organizationonboardingtask (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    user_id integer,
    task integer NOT NULL,
    status integer NOT NULL,
    date_completed timestamp with time zone NOT NULL,
    project_id bigint,
    data text NOT NULL,
    CONSTRAINT sentry_organizationonboardingtask_status_check CHECK ((status >= 0)),
    CONSTRAINT sentry_organizationonboardingtask_task_check CHECK ((task >= 0))
);


--
-- Name: sentry_organizationonboardingtask_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_organizationonboardingtask_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_organizationonboardingtask_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_organizationonboardingtask_id_seq OWNED BY public.sentry_organizationonboardingtask.id;


--
-- Name: sentry_organizationoptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_organizationoptions (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    key character varying(64) NOT NULL,
    value text NOT NULL
);


--
-- Name: sentry_organizationoptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_organizationoptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_organizationoptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_organizationoptions_id_seq OWNED BY public.sentry_organizationoptions.id;


--
-- Name: sentry_processingissue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_processingissue (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    checksum character varying(40) NOT NULL,
    type character varying(30) NOT NULL,
    data text NOT NULL,
    datetime timestamp with time zone NOT NULL
);


--
-- Name: sentry_processingissue_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_processingissue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_processingissue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_processingissue_id_seq OWNED BY public.sentry_processingissue.id;


--
-- Name: sentry_project; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_project (
    id bigint NOT NULL,
    name character varying(200) NOT NULL,
    public boolean NOT NULL,
    date_added timestamp with time zone NOT NULL,
    status integer NOT NULL,
    slug character varying(50),
    organization_id bigint NOT NULL,
    first_event timestamp with time zone,
    forced_color character varying(6),
    flags bigint,
    platform character varying(64),
    CONSTRAINT ck_status_pstv_3af8360b8a37db73 CHECK ((status >= 0)),
    CONSTRAINT sentry_project_status_check CHECK ((status >= 0))
);


--
-- Name: sentry_project_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_project_id_seq OWNED BY public.sentry_project.id;


--
-- Name: sentry_projectavatar; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_projectavatar (
    id bigint NOT NULL,
    file_id bigint,
    ident character varying(32) NOT NULL,
    project_id bigint NOT NULL,
    avatar_type smallint NOT NULL,
    CONSTRAINT sentry_projectavatar_avatar_type_check CHECK ((avatar_type >= 0))
);


--
-- Name: sentry_projectavatar_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_projectavatar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_projectavatar_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_projectavatar_id_seq OWNED BY public.sentry_projectavatar.id;


--
-- Name: sentry_projectbookmark; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_projectbookmark (
    id bigint NOT NULL,
    project_id bigint,
    user_id integer NOT NULL,
    date_added timestamp with time zone
);


--
-- Name: sentry_projectbookmark_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_projectbookmark_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_projectbookmark_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_projectbookmark_id_seq OWNED BY public.sentry_projectbookmark.id;


--
-- Name: sentry_projectcounter; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_projectcounter (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    value bigint NOT NULL
);


--
-- Name: sentry_projectcounter_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_projectcounter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_projectcounter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_projectcounter_id_seq OWNED BY public.sentry_projectcounter.id;


--
-- Name: sentry_projectdsymfile; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_projectdsymfile (
    id bigint NOT NULL,
    file_id bigint NOT NULL,
    object_name text NOT NULL,
    cpu_name character varying(40) NOT NULL,
    project_id bigint,
    uuid character varying(64) NOT NULL
);


--
-- Name: sentry_projectdsymfile_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_projectdsymfile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_projectdsymfile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_projectdsymfile_id_seq OWNED BY public.sentry_projectdsymfile.id;


--
-- Name: sentry_projectintegration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_projectintegration (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    integration_id bigint NOT NULL,
    config text NOT NULL
);


--
-- Name: sentry_projectintegration_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_projectintegration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_projectintegration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_projectintegration_id_seq OWNED BY public.sentry_projectintegration.id;


--
-- Name: sentry_projectkey; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_projectkey (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    public_key character varying(32),
    secret_key character varying(32),
    date_added timestamp with time zone,
    roles bigint NOT NULL,
    label character varying(64),
    status integer NOT NULL,
    rate_limit_count integer,
    rate_limit_window integer,
    data text NOT NULL,
    CONSTRAINT ck_rate_limit_count_pstv_3e2d8378c08cd2b5 CHECK ((rate_limit_count >= 0)),
    CONSTRAINT ck_rate_limit_window_pstv_546e3067ebba7213 CHECK ((rate_limit_window >= 0)),
    CONSTRAINT ck_status_pstv_1f17c0d00e89ed63 CHECK ((status >= 0)),
    CONSTRAINT sentry_projectkey_rate_limit_count_check CHECK ((rate_limit_count >= 0)),
    CONSTRAINT sentry_projectkey_rate_limit_window_check CHECK ((rate_limit_window >= 0)),
    CONSTRAINT sentry_projectkey_status_check CHECK ((status >= 0))
);


--
-- Name: sentry_projectkey_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_projectkey_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_projectkey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_projectkey_id_seq OWNED BY public.sentry_projectkey.id;


--
-- Name: sentry_projectoptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_projectoptions (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    key character varying(64) NOT NULL,
    value text NOT NULL
);


--
-- Name: sentry_projectoptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_projectoptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_projectoptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_projectoptions_id_seq OWNED BY public.sentry_projectoptions.id;


--
-- Name: sentry_projectownership; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_projectownership (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    raw text,
    schema text,
    fallthrough boolean NOT NULL,
    date_created timestamp with time zone NOT NULL,
    last_updated timestamp with time zone NOT NULL,
    is_active boolean NOT NULL
);


--
-- Name: sentry_projectownership_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_projectownership_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_projectownership_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_projectownership_id_seq OWNED BY public.sentry_projectownership.id;


--
-- Name: sentry_projectplatform; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_projectplatform (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    platform character varying(64) NOT NULL,
    date_added timestamp with time zone NOT NULL,
    last_seen timestamp with time zone NOT NULL
);


--
-- Name: sentry_projectplatform_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_projectplatform_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_projectplatform_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_projectplatform_id_seq OWNED BY public.sentry_projectplatform.id;


--
-- Name: sentry_projectredirect; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_projectredirect (
    id bigint NOT NULL,
    redirect_slug character varying(50) NOT NULL,
    project_id bigint NOT NULL,
    organization_id bigint NOT NULL,
    date_added timestamp with time zone NOT NULL
);


--
-- Name: sentry_projectredirect_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_projectredirect_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_projectredirect_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_projectredirect_id_seq OWNED BY public.sentry_projectredirect.id;


--
-- Name: sentry_projectsymcachefile; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_projectsymcachefile (
    id bigint NOT NULL,
    project_id bigint,
    cache_file_id bigint NOT NULL,
    dsym_file_id bigint NOT NULL,
    checksum character varying(40) NOT NULL,
    version integer NOT NULL,
    CONSTRAINT sentry_projectsymcachefile_version_check CHECK ((version >= 0))
);


--
-- Name: sentry_projectsymcachefile_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_projectsymcachefile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_projectsymcachefile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_projectsymcachefile_id_seq OWNED BY public.sentry_projectsymcachefile.id;


--
-- Name: sentry_projectteam; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_projectteam (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    team_id bigint NOT NULL
);


--
-- Name: sentry_projectteam_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_projectteam_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_projectteam_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_projectteam_id_seq OWNED BY public.sentry_projectteam.id;


--
-- Name: sentry_pull_request; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_pull_request (
    id bigint NOT NULL,
    organization_id integer NOT NULL,
    repository_id integer NOT NULL,
    key character varying(64) NOT NULL,
    date_added timestamp with time zone NOT NULL,
    title text,
    message text,
    author_id bigint,
    merge_commit_sha character varying(64),
    CONSTRAINT sentry_pull_request_organization_id_check CHECK ((organization_id >= 0)),
    CONSTRAINT sentry_pull_request_repository_id_check CHECK ((repository_id >= 0))
);


--
-- Name: sentry_pull_request_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_pull_request_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_pull_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_pull_request_id_seq OWNED BY public.sentry_pull_request.id;


--
-- Name: sentry_pullrequest_commit; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_pullrequest_commit (
    id bigint NOT NULL,
    pull_request_id bigint NOT NULL,
    commit_id bigint NOT NULL
);


--
-- Name: sentry_pullrequest_commit_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_pullrequest_commit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_pullrequest_commit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_pullrequest_commit_id_seq OWNED BY public.sentry_pullrequest_commit.id;


--
-- Name: sentry_rawevent; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_rawevent (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    event_id character varying(32),
    datetime timestamp with time zone NOT NULL,
    data text
);


--
-- Name: sentry_rawevent_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_rawevent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_rawevent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_rawevent_id_seq OWNED BY public.sentry_rawevent.id;


--
-- Name: sentry_relay; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_relay (
    id bigint NOT NULL,
    relay_id character varying(64) NOT NULL,
    public_key character varying(200) NOT NULL,
    first_seen timestamp with time zone NOT NULL,
    last_seen timestamp with time zone NOT NULL
);


--
-- Name: sentry_relay_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_relay_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_relay_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_relay_id_seq OWNED BY public.sentry_relay.id;


--
-- Name: sentry_release; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_release (
    id bigint NOT NULL,
    project_id bigint,
    version character varying(250) NOT NULL,
    date_added timestamp with time zone NOT NULL,
    date_released timestamp with time zone,
    ref character varying(250),
    url character varying(200),
    date_started timestamp with time zone,
    data text NOT NULL,
    new_groups integer NOT NULL,
    owner_id integer,
    organization_id bigint NOT NULL,
    commit_count integer,
    last_commit_id integer,
    authors text[],
    total_deploys integer,
    last_deploy_id integer,
    CONSTRAINT ck_commit_count_pstv_1e83b2bc4ee61de0 CHECK ((commit_count >= 0)),
    CONSTRAINT ck_last_commit_id_pstv_55474fbdf700412d CHECK ((last_commit_id >= 0)),
    CONSTRAINT ck_last_deploy_id_pstv_84d0c411d577507 CHECK ((last_deploy_id >= 0)),
    CONSTRAINT ck_new_groups_pstv_2cb74b3445ff4f0c CHECK ((new_groups >= 0)),
    CONSTRAINT ck_total_deploys_pstv_3619b358adfb4f75 CHECK ((total_deploys >= 0)),
    CONSTRAINT sentry_release_commit_count_check CHECK ((commit_count >= 0)),
    CONSTRAINT sentry_release_last_commit_id_check CHECK ((last_commit_id >= 0)),
    CONSTRAINT sentry_release_last_deploy_id_check CHECK ((last_deploy_id >= 0)),
    CONSTRAINT sentry_release_new_groups_check CHECK ((new_groups >= 0)),
    CONSTRAINT sentry_release_total_deploys_check CHECK ((total_deploys >= 0))
);


--
-- Name: sentry_release_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_release_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_release_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_release_id_seq OWNED BY public.sentry_release.id;


--
-- Name: sentry_release_project; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_release_project (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    release_id bigint NOT NULL,
    new_groups integer,
    CONSTRAINT ck_new_groups_pstv_35c7ce1fb5b5915e CHECK ((new_groups >= 0)),
    CONSTRAINT sentry_release_project_new_groups_check CHECK ((new_groups >= 0))
);


--
-- Name: sentry_release_project_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_release_project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_release_project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_release_project_id_seq OWNED BY public.sentry_release_project.id;


--
-- Name: sentry_releasecommit; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_releasecommit (
    id bigint NOT NULL,
    project_id integer,
    release_id bigint NOT NULL,
    commit_id bigint NOT NULL,
    "order" integer NOT NULL,
    organization_id integer NOT NULL,
    CONSTRAINT ck_organization_id_pstv_63c72b7b5009246 CHECK ((organization_id >= 0)),
    CONSTRAINT ck_project_id_pstv_559bbb746b5337db CHECK ((project_id >= 0)),
    CONSTRAINT sentry_releasecommit_order_check CHECK (("order" >= 0))
);


--
-- Name: sentry_releasecommit_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_releasecommit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_releasecommit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_releasecommit_id_seq OWNED BY public.sentry_releasecommit.id;


--
-- Name: sentry_releasefile; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_releasefile (
    id bigint NOT NULL,
    project_id bigint,
    release_id bigint NOT NULL,
    file_id bigint NOT NULL,
    ident character varying(40) NOT NULL,
    name text NOT NULL,
    organization_id bigint NOT NULL,
    dist_id bigint
);


--
-- Name: sentry_releasefile_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_releasefile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_releasefile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_releasefile_id_seq OWNED BY public.sentry_releasefile.id;


--
-- Name: sentry_releaseheadcommit; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_releaseheadcommit (
    id bigint NOT NULL,
    organization_id integer NOT NULL,
    repository_id integer NOT NULL,
    release_id bigint NOT NULL,
    commit_id bigint NOT NULL,
    CONSTRAINT sentry_releaseheadcommit_organization_id_check CHECK ((organization_id >= 0)),
    CONSTRAINT sentry_releaseheadcommit_repository_id_check CHECK ((repository_id >= 0))
);


--
-- Name: sentry_releaseheadcommit_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_releaseheadcommit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_releaseheadcommit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_releaseheadcommit_id_seq OWNED BY public.sentry_releaseheadcommit.id;


--
-- Name: sentry_releaseprojectenvironment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_releaseprojectenvironment (
    id bigint NOT NULL,
    release_id bigint NOT NULL,
    project_id bigint NOT NULL,
    environment_id bigint NOT NULL,
    new_issues_count integer NOT NULL,
    first_seen timestamp with time zone NOT NULL,
    last_seen timestamp with time zone NOT NULL,
    last_deploy_id integer,
    CONSTRAINT ck_last_deploy_id_pstv_6b9874520fa13549 CHECK ((last_deploy_id >= 0)),
    CONSTRAINT sentry_releaseprojectenvironment_last_deploy_id_check CHECK ((last_deploy_id >= 0)),
    CONSTRAINT sentry_releaseprojectenvironment_new_issues_count_check CHECK ((new_issues_count >= 0))
);


--
-- Name: sentry_releaseprojectenvironment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_releaseprojectenvironment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_releaseprojectenvironment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_releaseprojectenvironment_id_seq OWNED BY public.sentry_releaseprojectenvironment.id;


--
-- Name: sentry_repository; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_repository (
    id bigint NOT NULL,
    organization_id integer NOT NULL,
    name character varying(200) NOT NULL,
    date_added timestamp with time zone NOT NULL,
    url character varying(200),
    provider character varying(64),
    external_id character varying(64),
    config text NOT NULL,
    status integer NOT NULL,
    integration_id integer,
    CONSTRAINT ck_integration_id_pstv_4f3ef70e3e282bab CHECK ((integration_id >= 0)),
    CONSTRAINT ck_status_pstv_562b3ff4dae47f6b CHECK ((status >= 0)),
    CONSTRAINT sentry_repository_integration_id_check CHECK ((integration_id >= 0)),
    CONSTRAINT sentry_repository_organization_id_check CHECK ((organization_id >= 0)),
    CONSTRAINT sentry_repository_status_check CHECK ((status >= 0))
);


--
-- Name: sentry_repository_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_repository_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_repository_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_repository_id_seq OWNED BY public.sentry_repository.id;


--
-- Name: sentry_reprocessingreport; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_reprocessingreport (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    event_id character varying(32),
    datetime timestamp with time zone NOT NULL
);


--
-- Name: sentry_reprocessingreport_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_reprocessingreport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_reprocessingreport_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_reprocessingreport_id_seq OWNED BY public.sentry_reprocessingreport.id;


--
-- Name: sentry_rule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_rule (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    label character varying(64) NOT NULL,
    data text NOT NULL,
    date_added timestamp with time zone NOT NULL,
    status integer NOT NULL,
    environment_id integer,
    CONSTRAINT ck_environment_id_pstv_38aad0b7c980c236 CHECK ((environment_id >= 0)),
    CONSTRAINT ck_status_pstv_64efa876e92cb76d CHECK ((status >= 0)),
    CONSTRAINT sentry_rule_environment_id_check CHECK ((environment_id >= 0)),
    CONSTRAINT sentry_rule_status_check CHECK ((status >= 0))
);


--
-- Name: sentry_rule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_rule_id_seq OWNED BY public.sentry_rule.id;


--
-- Name: sentry_savedsearch; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_savedsearch (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    name character varying(128) NOT NULL,
    query text NOT NULL,
    date_added timestamp with time zone NOT NULL,
    is_default boolean NOT NULL,
    owner_id integer
);


--
-- Name: sentry_savedsearch_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_savedsearch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_savedsearch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_savedsearch_id_seq OWNED BY public.sentry_savedsearch.id;


--
-- Name: sentry_savedsearch_userdefault; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_savedsearch_userdefault (
    id bigint NOT NULL,
    savedsearch_id bigint NOT NULL,
    project_id bigint NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: sentry_savedsearch_userdefault_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_savedsearch_userdefault_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_savedsearch_userdefault_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_savedsearch_userdefault_id_seq OWNED BY public.sentry_savedsearch_userdefault.id;


--
-- Name: sentry_scheduleddeletion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_scheduleddeletion (
    id bigint NOT NULL,
    guid character varying(32) NOT NULL,
    app_label character varying(64) NOT NULL,
    model_name character varying(64) NOT NULL,
    object_id bigint NOT NULL,
    date_added timestamp with time zone NOT NULL,
    date_scheduled timestamp with time zone NOT NULL,
    actor_id bigint,
    data text NOT NULL,
    in_progress boolean NOT NULL,
    aborted boolean NOT NULL
);


--
-- Name: sentry_scheduleddeletion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_scheduleddeletion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_scheduleddeletion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_scheduleddeletion_id_seq OWNED BY public.sentry_scheduleddeletion.id;


--
-- Name: sentry_scheduledjob; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_scheduledjob (
    id bigint NOT NULL,
    name character varying(128) NOT NULL,
    payload text NOT NULL,
    date_added timestamp with time zone NOT NULL,
    date_scheduled timestamp with time zone NOT NULL
);


--
-- Name: sentry_scheduledjob_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_scheduledjob_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_scheduledjob_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_scheduledjob_id_seq OWNED BY public.sentry_scheduledjob.id;


--
-- Name: sentry_servicehook; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_servicehook (
    id bigint NOT NULL,
    guid character varying(32),
    application_id bigint,
    actor_id integer NOT NULL,
    project_id integer NOT NULL,
    url character varying(512) NOT NULL,
    secret text NOT NULL,
    events text[],
    status integer NOT NULL,
    version integer NOT NULL,
    date_added timestamp with time zone NOT NULL,
    CONSTRAINT sentry_servicehook_actor_id_check CHECK ((actor_id >= 0)),
    CONSTRAINT sentry_servicehook_project_id_check CHECK ((project_id >= 0)),
    CONSTRAINT sentry_servicehook_status_check CHECK ((status >= 0)),
    CONSTRAINT sentry_servicehook_version_check CHECK ((version >= 0))
);


--
-- Name: sentry_servicehook_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_servicehook_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_servicehook_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_servicehook_id_seq OWNED BY public.sentry_servicehook.id;


--
-- Name: sentry_team; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_team (
    id bigint NOT NULL,
    slug character varying(50) NOT NULL,
    name character varying(64) NOT NULL,
    date_added timestamp with time zone,
    status integer NOT NULL,
    organization_id bigint NOT NULL,
    CONSTRAINT ck_status_pstv_1772e42d30eba7ba CHECK ((status >= 0)),
    CONSTRAINT sentry_team_status_check CHECK ((status >= 0))
);


--
-- Name: sentry_team_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_team_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_team_id_seq OWNED BY public.sentry_team.id;


--
-- Name: sentry_teamavatar; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_teamavatar (
    id bigint NOT NULL,
    file_id bigint,
    ident character varying(32) NOT NULL,
    team_id bigint NOT NULL,
    avatar_type smallint NOT NULL,
    CONSTRAINT sentry_teamavatar_avatar_type_check CHECK ((avatar_type >= 0))
);


--
-- Name: sentry_teamavatar_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_teamavatar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_teamavatar_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_teamavatar_id_seq OWNED BY public.sentry_teamavatar.id;


--
-- Name: sentry_useravatar; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_useravatar (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    file_id bigint,
    ident character varying(32) NOT NULL,
    avatar_type smallint NOT NULL,
    CONSTRAINT sentry_useravatar_avatar_type_check CHECK ((avatar_type >= 0))
);


--
-- Name: sentry_useravatar_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_useravatar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_useravatar_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_useravatar_id_seq OWNED BY public.sentry_useravatar.id;


--
-- Name: sentry_useremail; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_useremail (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    email character varying(75) NOT NULL,
    validation_hash character varying(32) NOT NULL,
    date_hash_added timestamp with time zone NOT NULL,
    is_verified boolean NOT NULL
);


--
-- Name: sentry_useremail_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_useremail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_useremail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_useremail_id_seq OWNED BY public.sentry_useremail.id;


--
-- Name: sentry_userip; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_userip (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    ip_address inet NOT NULL,
    first_seen timestamp with time zone NOT NULL,
    last_seen timestamp with time zone NOT NULL
);


--
-- Name: sentry_userip_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_userip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_userip_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_userip_id_seq OWNED BY public.sentry_userip.id;


--
-- Name: sentry_useroption; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_useroption (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    project_id bigint,
    key character varying(64) NOT NULL,
    value text NOT NULL,
    organization_id bigint
);


--
-- Name: sentry_useroption_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_useroption_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_useroption_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_useroption_id_seq OWNED BY public.sentry_useroption.id;


--
-- Name: sentry_userpermission; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_userpermission (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission character varying(32) NOT NULL
);


--
-- Name: sentry_userpermission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_userpermission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_userpermission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_userpermission_id_seq OWNED BY public.sentry_userpermission.id;


--
-- Name: sentry_userreport; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_userreport (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    group_id bigint,
    event_id character varying(32) NOT NULL,
    name character varying(128) NOT NULL,
    email character varying(75) NOT NULL,
    comments text NOT NULL,
    date_added timestamp with time zone NOT NULL,
    event_user_id bigint,
    environment_id bigint
);


--
-- Name: sentry_userreport_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_userreport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_userreport_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_userreport_id_seq OWNED BY public.sentry_userreport.id;


--
-- Name: sentry_versiondsymfile; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sentry_versiondsymfile (
    id bigint NOT NULL,
    dsym_file_id bigint,
    dsym_app_id bigint NOT NULL,
    version character varying(32) NOT NULL,
    build character varying(32),
    date_added timestamp with time zone NOT NULL
);


--
-- Name: sentry_versiondsymfile_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sentry_versiondsymfile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentry_versiondsymfile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sentry_versiondsymfile_id_seq OWNED BY public.sentry_versiondsymfile.id;


--
-- Name: social_auth_usersocialauth; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.social_auth_usersocialauth (
    id integer NOT NULL,
    user_id integer NOT NULL,
    provider character varying(32) NOT NULL,
    uid character varying(255) NOT NULL,
    extra_data text NOT NULL
);


--
-- Name: social_auth_usersocialauth_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.social_auth_usersocialauth_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: social_auth_usersocialauth_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.social_auth_usersocialauth_id_seq OWNED BY public.social_auth_usersocialauth.id;


--
-- Name: south_migrationhistory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.south_migrationhistory (
    id integer NOT NULL,
    app_name character varying(255) NOT NULL,
    migration character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


--
-- Name: south_migrationhistory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.south_migrationhistory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: south_migrationhistory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.south_migrationhistory_id_seq OWNED BY public.south_migrationhistory.id;


--
-- Name: tagstore_eventtag; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tagstore_eventtag (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    group_id bigint NOT NULL,
    event_id bigint NOT NULL,
    key_id bigint NOT NULL,
    value_id bigint NOT NULL,
    date_added timestamp with time zone NOT NULL
);


--
-- Name: tagstore_eventtag_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tagstore_eventtag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tagstore_eventtag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tagstore_eventtag_id_seq OWNED BY public.tagstore_eventtag.id;


--
-- Name: tagstore_grouptagkey; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tagstore_grouptagkey (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    group_id bigint NOT NULL,
    key_id bigint NOT NULL,
    values_seen integer NOT NULL,
    CONSTRAINT tagstore_grouptagkey_values_seen_check CHECK ((values_seen >= 0))
);


--
-- Name: tagstore_grouptagkey_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tagstore_grouptagkey_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tagstore_grouptagkey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tagstore_grouptagkey_id_seq OWNED BY public.tagstore_grouptagkey.id;


--
-- Name: tagstore_grouptagvalue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tagstore_grouptagvalue (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    group_id bigint NOT NULL,
    times_seen integer NOT NULL,
    key_id bigint NOT NULL,
    value_id bigint NOT NULL,
    last_seen timestamp with time zone,
    first_seen timestamp with time zone,
    CONSTRAINT tagstore_grouptagvalue_times_seen_check CHECK ((times_seen >= 0))
);


--
-- Name: tagstore_grouptagvalue_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tagstore_grouptagvalue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tagstore_grouptagvalue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tagstore_grouptagvalue_id_seq OWNED BY public.tagstore_grouptagvalue.id;


--
-- Name: tagstore_tagkey; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tagstore_tagkey (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    environment_id bigint NOT NULL,
    key character varying(32) NOT NULL,
    values_seen integer NOT NULL,
    status integer NOT NULL,
    CONSTRAINT tagstore_tagkey_status_check CHECK ((status >= 0)),
    CONSTRAINT tagstore_tagkey_values_seen_check CHECK ((values_seen >= 0))
);


--
-- Name: tagstore_tagkey_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tagstore_tagkey_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tagstore_tagkey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tagstore_tagkey_id_seq OWNED BY public.tagstore_tagkey.id;


--
-- Name: tagstore_tagvalue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tagstore_tagvalue (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    key_id bigint NOT NULL,
    value character varying(200) NOT NULL,
    data text,
    times_seen integer NOT NULL,
    last_seen timestamp with time zone,
    first_seen timestamp with time zone,
    CONSTRAINT tagstore_tagvalue_times_seen_check CHECK ((times_seen >= 0))
);


--
-- Name: tagstore_tagvalue_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tagstore_tagvalue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tagstore_tagvalue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tagstore_tagvalue_id_seq OWNED BY public.tagstore_tagvalue.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_authenticator ALTER COLUMN id SET DEFAULT nextval('public.auth_authenticator_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_site ALTER COLUMN id SET DEFAULT nextval('public.django_site_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_ac_tenant ALTER COLUMN id SET DEFAULT nextval('public.jira_ac_tenant_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_activity ALTER COLUMN id SET DEFAULT nextval('public.sentry_activity_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apiapplication ALTER COLUMN id SET DEFAULT nextval('public.sentry_apiapplication_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apiauthorization ALTER COLUMN id SET DEFAULT nextval('public.sentry_apiauthorization_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apigrant ALTER COLUMN id SET DEFAULT nextval('public.sentry_apigrant_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apikey ALTER COLUMN id SET DEFAULT nextval('public.sentry_apikey_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apitoken ALTER COLUMN id SET DEFAULT nextval('public.sentry_apitoken_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_assistant_activity ALTER COLUMN id SET DEFAULT nextval('public.sentry_assistant_activity_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_auditlogentry ALTER COLUMN id SET DEFAULT nextval('public.sentry_auditlogentry_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_authidentity ALTER COLUMN id SET DEFAULT nextval('public.sentry_authidentity_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_authprovider ALTER COLUMN id SET DEFAULT nextval('public.sentry_authprovider_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_authprovider_default_teams ALTER COLUMN id SET DEFAULT nextval('public.sentry_authprovider_default_teams_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_broadcast ALTER COLUMN id SET DEFAULT nextval('public.sentry_broadcast_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_broadcastseen ALTER COLUMN id SET DEFAULT nextval('public.sentry_broadcastseen_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_commit ALTER COLUMN id SET DEFAULT nextval('public.sentry_commit_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_commitauthor ALTER COLUMN id SET DEFAULT nextval('public.sentry_commitauthor_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_commitfilechange ALTER COLUMN id SET DEFAULT nextval('public.sentry_commitfilechange_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_deletedorganization ALTER COLUMN id SET DEFAULT nextval('public.sentry_deletedorganization_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_deletedproject ALTER COLUMN id SET DEFAULT nextval('public.sentry_deletedproject_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_deletedteam ALTER COLUMN id SET DEFAULT nextval('public.sentry_deletedteam_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_deploy ALTER COLUMN id SET DEFAULT nextval('public.sentry_deploy_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_distribution ALTER COLUMN id SET DEFAULT nextval('public.sentry_distribution_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_dsymapp ALTER COLUMN id SET DEFAULT nextval('public.sentry_dsymapp_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_email ALTER COLUMN id SET DEFAULT nextval('public.sentry_email_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_environment ALTER COLUMN id SET DEFAULT nextval('public.sentry_environment_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_environmentproject ALTER COLUMN id SET DEFAULT nextval('public.sentry_environmentproject_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_environmentrelease ALTER COLUMN id SET DEFAULT nextval('public.sentry_environmentrelease_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_eventmapping ALTER COLUMN id SET DEFAULT nextval('public.sentry_eventmapping_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_eventprocessingissue ALTER COLUMN id SET DEFAULT nextval('public.sentry_eventprocessingissue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_eventtag ALTER COLUMN id SET DEFAULT nextval('public.sentry_eventtag_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_eventuser ALTER COLUMN id SET DEFAULT nextval('public.sentry_eventuser_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_externalissue ALTER COLUMN id SET DEFAULT nextval('public.sentry_externalissue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_featureadoption ALTER COLUMN id SET DEFAULT nextval('public.sentry_featureadoption_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_file ALTER COLUMN id SET DEFAULT nextval('public.sentry_file_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_fileblob ALTER COLUMN id SET DEFAULT nextval('public.sentry_fileblob_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_fileblobindex ALTER COLUMN id SET DEFAULT nextval('public.sentry_fileblobindex_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_fileblobowner ALTER COLUMN id SET DEFAULT nextval('public.sentry_fileblobowner_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_filterkey ALTER COLUMN id SET DEFAULT nextval('public.sentry_filterkey_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_filtervalue ALTER COLUMN id SET DEFAULT nextval('public.sentry_filtervalue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupasignee ALTER COLUMN id SET DEFAULT nextval('public.sentry_groupasignee_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupbookmark ALTER COLUMN id SET DEFAULT nextval('public.sentry_groupbookmark_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupcommitresolution ALTER COLUMN id SET DEFAULT nextval('public.sentry_groupcommitresolution_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupedmessage ALTER COLUMN id SET DEFAULT nextval('public.sentry_groupedmessage_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupemailthread ALTER COLUMN id SET DEFAULT nextval('public.sentry_groupemailthread_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupenvironment ALTER COLUMN id SET DEFAULT nextval('public.sentry_groupenvironment_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouphash ALTER COLUMN id SET DEFAULT nextval('public.sentry_grouphash_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouphashtombstone ALTER COLUMN id SET DEFAULT nextval('public.sentry_grouphashtombstone_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouplink ALTER COLUMN id SET DEFAULT nextval('public.sentry_grouplink_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupmeta ALTER COLUMN id SET DEFAULT nextval('public.sentry_groupmeta_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupredirect ALTER COLUMN id SET DEFAULT nextval('public.sentry_groupredirect_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouprelease ALTER COLUMN id SET DEFAULT nextval('public.sentry_grouprelease_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupresolution ALTER COLUMN id SET DEFAULT nextval('public.sentry_groupresolution_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouprulestatus ALTER COLUMN id SET DEFAULT nextval('public.sentry_grouprulestatus_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupseen ALTER COLUMN id SET DEFAULT nextval('public.sentry_groupseen_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupshare ALTER COLUMN id SET DEFAULT nextval('public.sentry_groupshare_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupsnooze ALTER COLUMN id SET DEFAULT nextval('public.sentry_groupsnooze_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupsubscription ALTER COLUMN id SET DEFAULT nextval('public.sentry_groupsubscription_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouptagkey ALTER COLUMN id SET DEFAULT nextval('public.sentry_grouptagkey_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouptombstone ALTER COLUMN id SET DEFAULT nextval('public.sentry_grouptombstone_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_hipchat_ac_tenant_organizations ALTER COLUMN id SET DEFAULT nextval('public.sentry_hipchat_ac_tenant_organizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_hipchat_ac_tenant_projects ALTER COLUMN id SET DEFAULT nextval('public.sentry_hipchat_ac_tenant_projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_identity ALTER COLUMN id SET DEFAULT nextval('public.sentry_identity_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_identityprovider ALTER COLUMN id SET DEFAULT nextval('public.sentry_identityprovider_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_integration ALTER COLUMN id SET DEFAULT nextval('public.sentry_integration_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_latestrelease ALTER COLUMN id SET DEFAULT nextval('public.sentry_latestrelease_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_lostpasswordhash ALTER COLUMN id SET DEFAULT nextval('public.sentry_lostpasswordhash_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_message ALTER COLUMN id SET DEFAULT nextval('public.sentry_message_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_messagefiltervalue ALTER COLUMN id SET DEFAULT nextval('public.sentry_messagefiltervalue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_messageindex ALTER COLUMN id SET DEFAULT nextval('public.sentry_messageindex_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_option ALTER COLUMN id SET DEFAULT nextval('public.sentry_option_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organization ALTER COLUMN id SET DEFAULT nextval('public.sentry_organization_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationaccessrequest ALTER COLUMN id SET DEFAULT nextval('public.sentry_organizationaccessrequest_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationavatar ALTER COLUMN id SET DEFAULT nextval('public.sentry_organizationavatar_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationintegration ALTER COLUMN id SET DEFAULT nextval('public.sentry_organizationintegration_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationmember ALTER COLUMN id SET DEFAULT nextval('public.sentry_organizationmember_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationmember_teams ALTER COLUMN id SET DEFAULT nextval('public.sentry_organizationmember_teams_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationonboardingtask ALTER COLUMN id SET DEFAULT nextval('public.sentry_organizationonboardingtask_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationoptions ALTER COLUMN id SET DEFAULT nextval('public.sentry_organizationoptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_processingissue ALTER COLUMN id SET DEFAULT nextval('public.sentry_processingissue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_project ALTER COLUMN id SET DEFAULT nextval('public.sentry_project_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectavatar ALTER COLUMN id SET DEFAULT nextval('public.sentry_projectavatar_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectbookmark ALTER COLUMN id SET DEFAULT nextval('public.sentry_projectbookmark_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectcounter ALTER COLUMN id SET DEFAULT nextval('public.sentry_projectcounter_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectdsymfile ALTER COLUMN id SET DEFAULT nextval('public.sentry_projectdsymfile_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectintegration ALTER COLUMN id SET DEFAULT nextval('public.sentry_projectintegration_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectkey ALTER COLUMN id SET DEFAULT nextval('public.sentry_projectkey_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectoptions ALTER COLUMN id SET DEFAULT nextval('public.sentry_projectoptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectownership ALTER COLUMN id SET DEFAULT nextval('public.sentry_projectownership_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectplatform ALTER COLUMN id SET DEFAULT nextval('public.sentry_projectplatform_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectredirect ALTER COLUMN id SET DEFAULT nextval('public.sentry_projectredirect_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectsymcachefile ALTER COLUMN id SET DEFAULT nextval('public.sentry_projectsymcachefile_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectteam ALTER COLUMN id SET DEFAULT nextval('public.sentry_projectteam_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_pull_request ALTER COLUMN id SET DEFAULT nextval('public.sentry_pull_request_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_pullrequest_commit ALTER COLUMN id SET DEFAULT nextval('public.sentry_pullrequest_commit_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_rawevent ALTER COLUMN id SET DEFAULT nextval('public.sentry_rawevent_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_relay ALTER COLUMN id SET DEFAULT nextval('public.sentry_relay_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_release ALTER COLUMN id SET DEFAULT nextval('public.sentry_release_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_release_project ALTER COLUMN id SET DEFAULT nextval('public.sentry_release_project_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releasecommit ALTER COLUMN id SET DEFAULT nextval('public.sentry_releasecommit_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releasefile ALTER COLUMN id SET DEFAULT nextval('public.sentry_releasefile_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releaseheadcommit ALTER COLUMN id SET DEFAULT nextval('public.sentry_releaseheadcommit_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releaseprojectenvironment ALTER COLUMN id SET DEFAULT nextval('public.sentry_releaseprojectenvironment_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_repository ALTER COLUMN id SET DEFAULT nextval('public.sentry_repository_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_reprocessingreport ALTER COLUMN id SET DEFAULT nextval('public.sentry_reprocessingreport_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_rule ALTER COLUMN id SET DEFAULT nextval('public.sentry_rule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_savedsearch ALTER COLUMN id SET DEFAULT nextval('public.sentry_savedsearch_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_savedsearch_userdefault ALTER COLUMN id SET DEFAULT nextval('public.sentry_savedsearch_userdefault_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_scheduleddeletion ALTER COLUMN id SET DEFAULT nextval('public.sentry_scheduleddeletion_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_scheduledjob ALTER COLUMN id SET DEFAULT nextval('public.sentry_scheduledjob_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_servicehook ALTER COLUMN id SET DEFAULT nextval('public.sentry_servicehook_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_team ALTER COLUMN id SET DEFAULT nextval('public.sentry_team_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_teamavatar ALTER COLUMN id SET DEFAULT nextval('public.sentry_teamavatar_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_useravatar ALTER COLUMN id SET DEFAULT nextval('public.sentry_useravatar_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_useremail ALTER COLUMN id SET DEFAULT nextval('public.sentry_useremail_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_userip ALTER COLUMN id SET DEFAULT nextval('public.sentry_userip_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_useroption ALTER COLUMN id SET DEFAULT nextval('public.sentry_useroption_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_userpermission ALTER COLUMN id SET DEFAULT nextval('public.sentry_userpermission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_userreport ALTER COLUMN id SET DEFAULT nextval('public.sentry_userreport_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_versiondsymfile ALTER COLUMN id SET DEFAULT nextval('public.sentry_versiondsymfile_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.social_auth_usersocialauth ALTER COLUMN id SET DEFAULT nextval('public.social_auth_usersocialauth_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.south_migrationhistory ALTER COLUMN id SET DEFAULT nextval('public.south_migrationhistory_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_eventtag ALTER COLUMN id SET DEFAULT nextval('public.tagstore_eventtag_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_grouptagkey ALTER COLUMN id SET DEFAULT nextval('public.tagstore_grouptagkey_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_grouptagvalue ALTER COLUMN id SET DEFAULT nextval('public.tagstore_grouptagvalue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_tagkey ALTER COLUMN id SET DEFAULT nextval('public.tagstore_tagkey_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_tagvalue ALTER COLUMN id SET DEFAULT nextval('public.tagstore_tagvalue_id_seq'::regclass);


--
-- Data for Name: auth_authenticator; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: auth_authenticator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_authenticator_id_seq', 1, false);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.auth_permission VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO public.auth_permission VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO public.auth_permission VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO public.auth_permission VALUES (4, 'Can add permission', 2, 'add_permission');
INSERT INTO public.auth_permission VALUES (5, 'Can change permission', 2, 'change_permission');
INSERT INTO public.auth_permission VALUES (6, 'Can delete permission', 2, 'delete_permission');
INSERT INTO public.auth_permission VALUES (7, 'Can add group', 3, 'add_group');
INSERT INTO public.auth_permission VALUES (8, 'Can change group', 3, 'change_group');
INSERT INTO public.auth_permission VALUES (9, 'Can delete group', 3, 'delete_group');
INSERT INTO public.auth_permission VALUES (10, 'Can add content type', 4, 'add_contenttype');
INSERT INTO public.auth_permission VALUES (11, 'Can change content type', 4, 'change_contenttype');
INSERT INTO public.auth_permission VALUES (12, 'Can delete content type', 4, 'delete_contenttype');
INSERT INTO public.auth_permission VALUES (13, 'Can add session', 5, 'add_session');
INSERT INTO public.auth_permission VALUES (14, 'Can change session', 5, 'change_session');
INSERT INTO public.auth_permission VALUES (15, 'Can delete session', 5, 'delete_session');
INSERT INTO public.auth_permission VALUES (16, 'Can add site', 6, 'add_site');
INSERT INTO public.auth_permission VALUES (17, 'Can change site', 6, 'change_site');
INSERT INTO public.auth_permission VALUES (18, 'Can delete site', 6, 'delete_site');
INSERT INTO public.auth_permission VALUES (19, 'Can add migration history', 7, 'add_migrationhistory');
INSERT INTO public.auth_permission VALUES (20, 'Can change migration history', 7, 'change_migrationhistory');
INSERT INTO public.auth_permission VALUES (21, 'Can delete migration history', 7, 'delete_migrationhistory');
INSERT INTO public.auth_permission VALUES (22, 'Can add activity', 8, 'add_activity');
INSERT INTO public.auth_permission VALUES (23, 'Can change activity', 8, 'change_activity');
INSERT INTO public.auth_permission VALUES (24, 'Can delete activity', 8, 'delete_activity');
INSERT INTO public.auth_permission VALUES (25, 'Can add api application', 9, 'add_apiapplication');
INSERT INTO public.auth_permission VALUES (26, 'Can change api application', 9, 'change_apiapplication');
INSERT INTO public.auth_permission VALUES (27, 'Can delete api application', 9, 'delete_apiapplication');
INSERT INTO public.auth_permission VALUES (28, 'Can add api authorization', 10, 'add_apiauthorization');
INSERT INTO public.auth_permission VALUES (29, 'Can change api authorization', 10, 'change_apiauthorization');
INSERT INTO public.auth_permission VALUES (30, 'Can delete api authorization', 10, 'delete_apiauthorization');
INSERT INTO public.auth_permission VALUES (31, 'Can add api grant', 11, 'add_apigrant');
INSERT INTO public.auth_permission VALUES (32, 'Can change api grant', 11, 'change_apigrant');
INSERT INTO public.auth_permission VALUES (33, 'Can delete api grant', 11, 'delete_apigrant');
INSERT INTO public.auth_permission VALUES (34, 'Can add api key', 12, 'add_apikey');
INSERT INTO public.auth_permission VALUES (35, 'Can change api key', 12, 'change_apikey');
INSERT INTO public.auth_permission VALUES (36, 'Can delete api key', 12, 'delete_apikey');
INSERT INTO public.auth_permission VALUES (37, 'Can add api token', 13, 'add_apitoken');
INSERT INTO public.auth_permission VALUES (38, 'Can change api token', 13, 'change_apitoken');
INSERT INTO public.auth_permission VALUES (39, 'Can delete api token', 13, 'delete_apitoken');
INSERT INTO public.auth_permission VALUES (40, 'Can add assistant activity', 14, 'add_assistantactivity');
INSERT INTO public.auth_permission VALUES (41, 'Can change assistant activity', 14, 'change_assistantactivity');
INSERT INTO public.auth_permission VALUES (42, 'Can delete assistant activity', 14, 'delete_assistantactivity');
INSERT INTO public.auth_permission VALUES (43, 'Can add audit log entry', 15, 'add_auditlogentry');
INSERT INTO public.auth_permission VALUES (44, 'Can change audit log entry', 15, 'change_auditlogentry');
INSERT INTO public.auth_permission VALUES (45, 'Can delete audit log entry', 15, 'delete_auditlogentry');
INSERT INTO public.auth_permission VALUES (46, 'Can add authenticator', 16, 'add_authenticator');
INSERT INTO public.auth_permission VALUES (47, 'Can change authenticator', 16, 'change_authenticator');
INSERT INTO public.auth_permission VALUES (48, 'Can delete authenticator', 16, 'delete_authenticator');
INSERT INTO public.auth_permission VALUES (49, 'Can add auth identity', 17, 'add_authidentity');
INSERT INTO public.auth_permission VALUES (50, 'Can change auth identity', 17, 'change_authidentity');
INSERT INTO public.auth_permission VALUES (51, 'Can delete auth identity', 17, 'delete_authidentity');
INSERT INTO public.auth_permission VALUES (52, 'Can add auth provider', 18, 'add_authprovider');
INSERT INTO public.auth_permission VALUES (53, 'Can change auth provider', 18, 'change_authprovider');
INSERT INTO public.auth_permission VALUES (54, 'Can delete auth provider', 18, 'delete_authprovider');
INSERT INTO public.auth_permission VALUES (55, 'Can add broadcast', 19, 'add_broadcast');
INSERT INTO public.auth_permission VALUES (56, 'Can change broadcast', 19, 'change_broadcast');
INSERT INTO public.auth_permission VALUES (57, 'Can delete broadcast', 19, 'delete_broadcast');
INSERT INTO public.auth_permission VALUES (58, 'Can add broadcast seen', 20, 'add_broadcastseen');
INSERT INTO public.auth_permission VALUES (59, 'Can change broadcast seen', 20, 'change_broadcastseen');
INSERT INTO public.auth_permission VALUES (60, 'Can delete broadcast seen', 20, 'delete_broadcastseen');
INSERT INTO public.auth_permission VALUES (61, 'Can add commit', 21, 'add_commit');
INSERT INTO public.auth_permission VALUES (62, 'Can change commit', 21, 'change_commit');
INSERT INTO public.auth_permission VALUES (63, 'Can delete commit', 21, 'delete_commit');
INSERT INTO public.auth_permission VALUES (64, 'Can add commit author', 22, 'add_commitauthor');
INSERT INTO public.auth_permission VALUES (65, 'Can change commit author', 22, 'change_commitauthor');
INSERT INTO public.auth_permission VALUES (66, 'Can delete commit author', 22, 'delete_commitauthor');
INSERT INTO public.auth_permission VALUES (67, 'Can add commit file change', 23, 'add_commitfilechange');
INSERT INTO public.auth_permission VALUES (68, 'Can change commit file change', 23, 'change_commitfilechange');
INSERT INTO public.auth_permission VALUES (69, 'Can delete commit file change', 23, 'delete_commitfilechange');
INSERT INTO public.auth_permission VALUES (70, 'Can add counter', 24, 'add_counter');
INSERT INTO public.auth_permission VALUES (71, 'Can change counter', 24, 'change_counter');
INSERT INTO public.auth_permission VALUES (72, 'Can delete counter', 24, 'delete_counter');
INSERT INTO public.auth_permission VALUES (73, 'Can add deleted organization', 25, 'add_deletedorganization');
INSERT INTO public.auth_permission VALUES (74, 'Can change deleted organization', 25, 'change_deletedorganization');
INSERT INTO public.auth_permission VALUES (75, 'Can delete deleted organization', 25, 'delete_deletedorganization');
INSERT INTO public.auth_permission VALUES (76, 'Can add deleted project', 26, 'add_deletedproject');
INSERT INTO public.auth_permission VALUES (77, 'Can change deleted project', 26, 'change_deletedproject');
INSERT INTO public.auth_permission VALUES (78, 'Can delete deleted project', 26, 'delete_deletedproject');
INSERT INTO public.auth_permission VALUES (79, 'Can add deleted team', 27, 'add_deletedteam');
INSERT INTO public.auth_permission VALUES (80, 'Can change deleted team', 27, 'change_deletedteam');
INSERT INTO public.auth_permission VALUES (81, 'Can delete deleted team', 27, 'delete_deletedteam');
INSERT INTO public.auth_permission VALUES (82, 'Can add deploy', 28, 'add_deploy');
INSERT INTO public.auth_permission VALUES (83, 'Can change deploy', 28, 'change_deploy');
INSERT INTO public.auth_permission VALUES (84, 'Can delete deploy', 28, 'delete_deploy');
INSERT INTO public.auth_permission VALUES (85, 'Can add distribution', 29, 'add_distribution');
INSERT INTO public.auth_permission VALUES (86, 'Can change distribution', 29, 'change_distribution');
INSERT INTO public.auth_permission VALUES (87, 'Can delete distribution', 29, 'delete_distribution');
INSERT INTO public.auth_permission VALUES (88, 'Can add file blob', 30, 'add_fileblob');
INSERT INTO public.auth_permission VALUES (89, 'Can change file blob', 30, 'change_fileblob');
INSERT INTO public.auth_permission VALUES (90, 'Can delete file blob', 30, 'delete_fileblob');
INSERT INTO public.auth_permission VALUES (91, 'Can add file', 31, 'add_file');
INSERT INTO public.auth_permission VALUES (92, 'Can change file', 31, 'change_file');
INSERT INTO public.auth_permission VALUES (93, 'Can delete file', 31, 'delete_file');
INSERT INTO public.auth_permission VALUES (94, 'Can add file blob index', 32, 'add_fileblobindex');
INSERT INTO public.auth_permission VALUES (95, 'Can change file blob index', 32, 'change_fileblobindex');
INSERT INTO public.auth_permission VALUES (96, 'Can delete file blob index', 32, 'delete_fileblobindex');
INSERT INTO public.auth_permission VALUES (97, 'Can add file blob owner', 33, 'add_fileblobowner');
INSERT INTO public.auth_permission VALUES (98, 'Can change file blob owner', 33, 'change_fileblobowner');
INSERT INTO public.auth_permission VALUES (99, 'Can delete file blob owner', 33, 'delete_fileblobowner');
INSERT INTO public.auth_permission VALUES (100, 'Can add version d sym file', 34, 'add_versiondsymfile');
INSERT INTO public.auth_permission VALUES (101, 'Can change version d sym file', 34, 'change_versiondsymfile');
INSERT INTO public.auth_permission VALUES (102, 'Can delete version d sym file', 34, 'delete_versiondsymfile');
INSERT INTO public.auth_permission VALUES (103, 'Can add d sym app', 35, 'add_dsymapp');
INSERT INTO public.auth_permission VALUES (104, 'Can change d sym app', 35, 'change_dsymapp');
INSERT INTO public.auth_permission VALUES (105, 'Can delete d sym app', 35, 'delete_dsymapp');
INSERT INTO public.auth_permission VALUES (106, 'Can add project d sym file', 36, 'add_projectdsymfile');
INSERT INTO public.auth_permission VALUES (107, 'Can change project d sym file', 36, 'change_projectdsymfile');
INSERT INTO public.auth_permission VALUES (108, 'Can delete project d sym file', 36, 'delete_projectdsymfile');
INSERT INTO public.auth_permission VALUES (109, 'Can add project sym cache file', 37, 'add_projectsymcachefile');
INSERT INTO public.auth_permission VALUES (110, 'Can change project sym cache file', 37, 'change_projectsymcachefile');
INSERT INTO public.auth_permission VALUES (111, 'Can delete project sym cache file', 37, 'delete_projectsymcachefile');
INSERT INTO public.auth_permission VALUES (112, 'Can add email', 38, 'add_email');
INSERT INTO public.auth_permission VALUES (113, 'Can change email', 38, 'change_email');
INSERT INTO public.auth_permission VALUES (114, 'Can delete email', 38, 'delete_email');
INSERT INTO public.auth_permission VALUES (115, 'Can add environment project', 39, 'add_environmentproject');
INSERT INTO public.auth_permission VALUES (116, 'Can change environment project', 39, 'change_environmentproject');
INSERT INTO public.auth_permission VALUES (117, 'Can delete environment project', 39, 'delete_environmentproject');
INSERT INTO public.auth_permission VALUES (118, 'Can add environment', 40, 'add_environment');
INSERT INTO public.auth_permission VALUES (119, 'Can change environment', 40, 'change_environment');
INSERT INTO public.auth_permission VALUES (120, 'Can delete environment', 40, 'delete_environment');
INSERT INTO public.auth_permission VALUES (121, 'Can add message', 41, 'add_event');
INSERT INTO public.auth_permission VALUES (122, 'Can change message', 41, 'change_event');
INSERT INTO public.auth_permission VALUES (123, 'Can delete message', 41, 'delete_event');
INSERT INTO public.auth_permission VALUES (124, 'Can add event mapping', 42, 'add_eventmapping');
INSERT INTO public.auth_permission VALUES (125, 'Can change event mapping', 42, 'change_eventmapping');
INSERT INTO public.auth_permission VALUES (126, 'Can delete event mapping', 42, 'delete_eventmapping');
INSERT INTO public.auth_permission VALUES (127, 'Can add event user', 43, 'add_eventuser');
INSERT INTO public.auth_permission VALUES (128, 'Can change event user', 43, 'change_eventuser');
INSERT INTO public.auth_permission VALUES (129, 'Can delete event user', 43, 'delete_eventuser');
INSERT INTO public.auth_permission VALUES (130, 'Can add external issue', 44, 'add_externalissue');
INSERT INTO public.auth_permission VALUES (131, 'Can change external issue', 44, 'change_externalissue');
INSERT INTO public.auth_permission VALUES (132, 'Can delete external issue', 44, 'delete_externalissue');
INSERT INTO public.auth_permission VALUES (133, 'Can add feature adoption', 45, 'add_featureadoption');
INSERT INTO public.auth_permission VALUES (134, 'Can change feature adoption', 45, 'change_featureadoption');
INSERT INTO public.auth_permission VALUES (135, 'Can delete feature adoption', 45, 'delete_featureadoption');
INSERT INTO public.auth_permission VALUES (136, 'Can add grouped message', 46, 'add_group');
INSERT INTO public.auth_permission VALUES (137, 'Can change grouped message', 46, 'change_group');
INSERT INTO public.auth_permission VALUES (138, 'Can delete grouped message', 46, 'delete_group');
INSERT INTO public.auth_permission VALUES (139, 'Can view', 46, 'can_view');
INSERT INTO public.auth_permission VALUES (140, 'Can add group assignee', 47, 'add_groupassignee');
INSERT INTO public.auth_permission VALUES (141, 'Can change group assignee', 47, 'change_groupassignee');
INSERT INTO public.auth_permission VALUES (142, 'Can delete group assignee', 47, 'delete_groupassignee');
INSERT INTO public.auth_permission VALUES (143, 'Can add group bookmark', 48, 'add_groupbookmark');
INSERT INTO public.auth_permission VALUES (144, 'Can change group bookmark', 48, 'change_groupbookmark');
INSERT INTO public.auth_permission VALUES (145, 'Can delete group bookmark', 48, 'delete_groupbookmark');
INSERT INTO public.auth_permission VALUES (146, 'Can add group commit resolution', 49, 'add_groupcommitresolution');
INSERT INTO public.auth_permission VALUES (147, 'Can change group commit resolution', 49, 'change_groupcommitresolution');
INSERT INTO public.auth_permission VALUES (148, 'Can delete group commit resolution', 49, 'delete_groupcommitresolution');
INSERT INTO public.auth_permission VALUES (149, 'Can add group email thread', 50, 'add_groupemailthread');
INSERT INTO public.auth_permission VALUES (150, 'Can change group email thread', 50, 'change_groupemailthread');
INSERT INTO public.auth_permission VALUES (151, 'Can delete group email thread', 50, 'delete_groupemailthread');
INSERT INTO public.auth_permission VALUES (152, 'Can add group environment', 51, 'add_groupenvironment');
INSERT INTO public.auth_permission VALUES (153, 'Can change group environment', 51, 'change_groupenvironment');
INSERT INTO public.auth_permission VALUES (154, 'Can delete group environment', 51, 'delete_groupenvironment');
INSERT INTO public.auth_permission VALUES (155, 'Can add group hash', 52, 'add_grouphash');
INSERT INTO public.auth_permission VALUES (156, 'Can change group hash', 52, 'change_grouphash');
INSERT INTO public.auth_permission VALUES (157, 'Can delete group hash', 52, 'delete_grouphash');
INSERT INTO public.auth_permission VALUES (158, 'Can add group hash tombstone', 53, 'add_grouphashtombstone');
INSERT INTO public.auth_permission VALUES (159, 'Can change group hash tombstone', 53, 'change_grouphashtombstone');
INSERT INTO public.auth_permission VALUES (160, 'Can delete group hash tombstone', 53, 'delete_grouphashtombstone');
INSERT INTO public.auth_permission VALUES (161, 'Can add group link', 54, 'add_grouplink');
INSERT INTO public.auth_permission VALUES (162, 'Can change group link', 54, 'change_grouplink');
INSERT INTO public.auth_permission VALUES (163, 'Can delete group link', 54, 'delete_grouplink');
INSERT INTO public.auth_permission VALUES (164, 'Can add group meta', 55, 'add_groupmeta');
INSERT INTO public.auth_permission VALUES (165, 'Can change group meta', 55, 'change_groupmeta');
INSERT INTO public.auth_permission VALUES (166, 'Can delete group meta', 55, 'delete_groupmeta');
INSERT INTO public.auth_permission VALUES (167, 'Can add group redirect', 56, 'add_groupredirect');
INSERT INTO public.auth_permission VALUES (168, 'Can change group redirect', 56, 'change_groupredirect');
INSERT INTO public.auth_permission VALUES (169, 'Can delete group redirect', 56, 'delete_groupredirect');
INSERT INTO public.auth_permission VALUES (170, 'Can add group release', 57, 'add_grouprelease');
INSERT INTO public.auth_permission VALUES (171, 'Can change group release', 57, 'change_grouprelease');
INSERT INTO public.auth_permission VALUES (172, 'Can delete group release', 57, 'delete_grouprelease');
INSERT INTO public.auth_permission VALUES (173, 'Can add group resolution', 58, 'add_groupresolution');
INSERT INTO public.auth_permission VALUES (174, 'Can change group resolution', 58, 'change_groupresolution');
INSERT INTO public.auth_permission VALUES (175, 'Can delete group resolution', 58, 'delete_groupresolution');
INSERT INTO public.auth_permission VALUES (176, 'Can add group rule status', 59, 'add_grouprulestatus');
INSERT INTO public.auth_permission VALUES (177, 'Can change group rule status', 59, 'change_grouprulestatus');
INSERT INTO public.auth_permission VALUES (178, 'Can delete group rule status', 59, 'delete_grouprulestatus');
INSERT INTO public.auth_permission VALUES (179, 'Can add group seen', 60, 'add_groupseen');
INSERT INTO public.auth_permission VALUES (180, 'Can change group seen', 60, 'change_groupseen');
INSERT INTO public.auth_permission VALUES (181, 'Can delete group seen', 60, 'delete_groupseen');
INSERT INTO public.auth_permission VALUES (182, 'Can add group share', 61, 'add_groupshare');
INSERT INTO public.auth_permission VALUES (183, 'Can change group share', 61, 'change_groupshare');
INSERT INTO public.auth_permission VALUES (184, 'Can delete group share', 61, 'delete_groupshare');
INSERT INTO public.auth_permission VALUES (185, 'Can add group snooze', 62, 'add_groupsnooze');
INSERT INTO public.auth_permission VALUES (186, 'Can change group snooze', 62, 'change_groupsnooze');
INSERT INTO public.auth_permission VALUES (187, 'Can delete group snooze', 62, 'delete_groupsnooze');
INSERT INTO public.auth_permission VALUES (188, 'Can add group subscription', 63, 'add_groupsubscription');
INSERT INTO public.auth_permission VALUES (189, 'Can change group subscription', 63, 'change_groupsubscription');
INSERT INTO public.auth_permission VALUES (190, 'Can delete group subscription', 63, 'delete_groupsubscription');
INSERT INTO public.auth_permission VALUES (191, 'Can add group tombstone', 64, 'add_grouptombstone');
INSERT INTO public.auth_permission VALUES (192, 'Can change group tombstone', 64, 'change_grouptombstone');
INSERT INTO public.auth_permission VALUES (193, 'Can delete group tombstone', 64, 'delete_grouptombstone');
INSERT INTO public.auth_permission VALUES (194, 'Can add identity provider', 65, 'add_identityprovider');
INSERT INTO public.auth_permission VALUES (195, 'Can change identity provider', 65, 'change_identityprovider');
INSERT INTO public.auth_permission VALUES (196, 'Can delete identity provider', 65, 'delete_identityprovider');
INSERT INTO public.auth_permission VALUES (197, 'Can add identity', 66, 'add_identity');
INSERT INTO public.auth_permission VALUES (198, 'Can change identity', 66, 'change_identity');
INSERT INTO public.auth_permission VALUES (199, 'Can delete identity', 66, 'delete_identity');
INSERT INTO public.auth_permission VALUES (200, 'Can add organization integration', 67, 'add_organizationintegration');
INSERT INTO public.auth_permission VALUES (201, 'Can change organization integration', 67, 'change_organizationintegration');
INSERT INTO public.auth_permission VALUES (202, 'Can delete organization integration', 67, 'delete_organizationintegration');
INSERT INTO public.auth_permission VALUES (203, 'Can add project integration', 68, 'add_projectintegration');
INSERT INTO public.auth_permission VALUES (204, 'Can change project integration', 68, 'change_projectintegration');
INSERT INTO public.auth_permission VALUES (205, 'Can delete project integration', 68, 'delete_projectintegration');
INSERT INTO public.auth_permission VALUES (206, 'Can add integration', 69, 'add_integration');
INSERT INTO public.auth_permission VALUES (207, 'Can change integration', 69, 'change_integration');
INSERT INTO public.auth_permission VALUES (208, 'Can delete integration', 69, 'delete_integration');
INSERT INTO public.auth_permission VALUES (209, 'Can add latest release', 70, 'add_latestrelease');
INSERT INTO public.auth_permission VALUES (210, 'Can change latest release', 70, 'change_latestrelease');
INSERT INTO public.auth_permission VALUES (211, 'Can delete latest release', 70, 'delete_latestrelease');
INSERT INTO public.auth_permission VALUES (212, 'Can add lost password hash', 71, 'add_lostpasswordhash');
INSERT INTO public.auth_permission VALUES (213, 'Can change lost password hash', 71, 'change_lostpasswordhash');
INSERT INTO public.auth_permission VALUES (214, 'Can delete lost password hash', 71, 'delete_lostpasswordhash');
INSERT INTO public.auth_permission VALUES (215, 'Can add option', 72, 'add_option');
INSERT INTO public.auth_permission VALUES (216, 'Can change option', 72, 'change_option');
INSERT INTO public.auth_permission VALUES (217, 'Can delete option', 72, 'delete_option');
INSERT INTO public.auth_permission VALUES (218, 'Can add organization', 73, 'add_organization');
INSERT INTO public.auth_permission VALUES (219, 'Can change organization', 73, 'change_organization');
INSERT INTO public.auth_permission VALUES (220, 'Can delete organization', 73, 'delete_organization');
INSERT INTO public.auth_permission VALUES (221, 'Can add organization access request', 74, 'add_organizationaccessrequest');
INSERT INTO public.auth_permission VALUES (222, 'Can change organization access request', 74, 'change_organizationaccessrequest');
INSERT INTO public.auth_permission VALUES (223, 'Can delete organization access request', 74, 'delete_organizationaccessrequest');
INSERT INTO public.auth_permission VALUES (224, 'Can add organization avatar', 75, 'add_organizationavatar');
INSERT INTO public.auth_permission VALUES (225, 'Can change organization avatar', 75, 'change_organizationavatar');
INSERT INTO public.auth_permission VALUES (226, 'Can delete organization avatar', 75, 'delete_organizationavatar');
INSERT INTO public.auth_permission VALUES (227, 'Can add organization member team', 76, 'add_organizationmemberteam');
INSERT INTO public.auth_permission VALUES (228, 'Can change organization member team', 76, 'change_organizationmemberteam');
INSERT INTO public.auth_permission VALUES (229, 'Can delete organization member team', 76, 'delete_organizationmemberteam');
INSERT INTO public.auth_permission VALUES (230, 'Can add organization member', 77, 'add_organizationmember');
INSERT INTO public.auth_permission VALUES (231, 'Can change organization member', 77, 'change_organizationmember');
INSERT INTO public.auth_permission VALUES (232, 'Can delete organization member', 77, 'delete_organizationmember');
INSERT INTO public.auth_permission VALUES (233, 'Can add organization onboarding task', 78, 'add_organizationonboardingtask');
INSERT INTO public.auth_permission VALUES (234, 'Can change organization onboarding task', 78, 'change_organizationonboardingtask');
INSERT INTO public.auth_permission VALUES (235, 'Can delete organization onboarding task', 78, 'delete_organizationonboardingtask');
INSERT INTO public.auth_permission VALUES (236, 'Can add organization option', 79, 'add_organizationoption');
INSERT INTO public.auth_permission VALUES (237, 'Can change organization option', 79, 'change_organizationoption');
INSERT INTO public.auth_permission VALUES (238, 'Can delete organization option', 79, 'delete_organizationoption');
INSERT INTO public.auth_permission VALUES (239, 'Can add processing issue', 80, 'add_processingissue');
INSERT INTO public.auth_permission VALUES (240, 'Can change processing issue', 80, 'change_processingissue');
INSERT INTO public.auth_permission VALUES (241, 'Can delete processing issue', 80, 'delete_processingissue');
INSERT INTO public.auth_permission VALUES (242, 'Can add event processing issue', 81, 'add_eventprocessingissue');
INSERT INTO public.auth_permission VALUES (243, 'Can change event processing issue', 81, 'change_eventprocessingissue');
INSERT INTO public.auth_permission VALUES (244, 'Can delete event processing issue', 81, 'delete_eventprocessingissue');
INSERT INTO public.auth_permission VALUES (245, 'Can add project team', 82, 'add_projectteam');
INSERT INTO public.auth_permission VALUES (246, 'Can change project team', 82, 'change_projectteam');
INSERT INTO public.auth_permission VALUES (247, 'Can delete project team', 82, 'delete_projectteam');
INSERT INTO public.auth_permission VALUES (248, 'Can add project', 83, 'add_project');
INSERT INTO public.auth_permission VALUES (249, 'Can change project', 83, 'change_project');
INSERT INTO public.auth_permission VALUES (250, 'Can delete project', 83, 'delete_project');
INSERT INTO public.auth_permission VALUES (251, 'Can add project avatar', 84, 'add_projectavatar');
INSERT INTO public.auth_permission VALUES (252, 'Can change project avatar', 84, 'change_projectavatar');
INSERT INTO public.auth_permission VALUES (253, 'Can delete project avatar', 84, 'delete_projectavatar');
INSERT INTO public.auth_permission VALUES (254, 'Can add project bookmark', 85, 'add_projectbookmark');
INSERT INTO public.auth_permission VALUES (255, 'Can change project bookmark', 85, 'change_projectbookmark');
INSERT INTO public.auth_permission VALUES (256, 'Can delete project bookmark', 85, 'delete_projectbookmark');
INSERT INTO public.auth_permission VALUES (257, 'Can add project key', 86, 'add_projectkey');
INSERT INTO public.auth_permission VALUES (258, 'Can change project key', 86, 'change_projectkey');
INSERT INTO public.auth_permission VALUES (259, 'Can delete project key', 86, 'delete_projectkey');
INSERT INTO public.auth_permission VALUES (260, 'Can add project option', 87, 'add_projectoption');
INSERT INTO public.auth_permission VALUES (261, 'Can change project option', 87, 'change_projectoption');
INSERT INTO public.auth_permission VALUES (262, 'Can delete project option', 87, 'delete_projectoption');
INSERT INTO public.auth_permission VALUES (263, 'Can add project ownership', 88, 'add_projectownership');
INSERT INTO public.auth_permission VALUES (264, 'Can change project ownership', 88, 'change_projectownership');
INSERT INTO public.auth_permission VALUES (265, 'Can delete project ownership', 88, 'delete_projectownership');
INSERT INTO public.auth_permission VALUES (266, 'Can add project platform', 89, 'add_projectplatform');
INSERT INTO public.auth_permission VALUES (267, 'Can change project platform', 89, 'change_projectplatform');
INSERT INTO public.auth_permission VALUES (268, 'Can delete project platform', 89, 'delete_projectplatform');
INSERT INTO public.auth_permission VALUES (269, 'Can add project redirect', 90, 'add_projectredirect');
INSERT INTO public.auth_permission VALUES (270, 'Can change project redirect', 90, 'change_projectredirect');
INSERT INTO public.auth_permission VALUES (271, 'Can delete project redirect', 90, 'delete_projectredirect');
INSERT INTO public.auth_permission VALUES (272, 'Can add pull request', 91, 'add_pullrequest');
INSERT INTO public.auth_permission VALUES (273, 'Can change pull request', 91, 'change_pullrequest');
INSERT INTO public.auth_permission VALUES (274, 'Can delete pull request', 91, 'delete_pullrequest');
INSERT INTO public.auth_permission VALUES (275, 'Can add pull request commit', 92, 'add_pullrequestcommit');
INSERT INTO public.auth_permission VALUES (276, 'Can change pull request commit', 92, 'change_pullrequestcommit');
INSERT INTO public.auth_permission VALUES (277, 'Can delete pull request commit', 92, 'delete_pullrequestcommit');
INSERT INTO public.auth_permission VALUES (278, 'Can add raw event', 93, 'add_rawevent');
INSERT INTO public.auth_permission VALUES (279, 'Can change raw event', 93, 'change_rawevent');
INSERT INTO public.auth_permission VALUES (280, 'Can delete raw event', 93, 'delete_rawevent');
INSERT INTO public.auth_permission VALUES (281, 'Can add relay', 94, 'add_relay');
INSERT INTO public.auth_permission VALUES (282, 'Can change relay', 94, 'change_relay');
INSERT INTO public.auth_permission VALUES (283, 'Can delete relay', 94, 'delete_relay');
INSERT INTO public.auth_permission VALUES (284, 'Can add release project', 95, 'add_releaseproject');
INSERT INTO public.auth_permission VALUES (285, 'Can change release project', 95, 'change_releaseproject');
INSERT INTO public.auth_permission VALUES (286, 'Can delete release project', 95, 'delete_releaseproject');
INSERT INTO public.auth_permission VALUES (287, 'Can add release', 96, 'add_release');
INSERT INTO public.auth_permission VALUES (288, 'Can change release', 96, 'change_release');
INSERT INTO public.auth_permission VALUES (289, 'Can delete release', 96, 'delete_release');
INSERT INTO public.auth_permission VALUES (290, 'Can add release commit', 97, 'add_releasecommit');
INSERT INTO public.auth_permission VALUES (291, 'Can change release commit', 97, 'change_releasecommit');
INSERT INTO public.auth_permission VALUES (292, 'Can delete release commit', 97, 'delete_releasecommit');
INSERT INTO public.auth_permission VALUES (293, 'Can add release environment', 98, 'add_releaseenvironment');
INSERT INTO public.auth_permission VALUES (294, 'Can change release environment', 98, 'change_releaseenvironment');
INSERT INTO public.auth_permission VALUES (295, 'Can delete release environment', 98, 'delete_releaseenvironment');
INSERT INTO public.auth_permission VALUES (296, 'Can add release file', 99, 'add_releasefile');
INSERT INTO public.auth_permission VALUES (297, 'Can change release file', 99, 'change_releasefile');
INSERT INTO public.auth_permission VALUES (298, 'Can delete release file', 99, 'delete_releasefile');
INSERT INTO public.auth_permission VALUES (299, 'Can add release head commit', 100, 'add_releaseheadcommit');
INSERT INTO public.auth_permission VALUES (300, 'Can change release head commit', 100, 'change_releaseheadcommit');
INSERT INTO public.auth_permission VALUES (301, 'Can delete release head commit', 100, 'delete_releaseheadcommit');
INSERT INTO public.auth_permission VALUES (302, 'Can add release project environment', 101, 'add_releaseprojectenvironment');
INSERT INTO public.auth_permission VALUES (303, 'Can change release project environment', 101, 'change_releaseprojectenvironment');
INSERT INTO public.auth_permission VALUES (304, 'Can delete release project environment', 101, 'delete_releaseprojectenvironment');
INSERT INTO public.auth_permission VALUES (305, 'Can add repository', 102, 'add_repository');
INSERT INTO public.auth_permission VALUES (306, 'Can change repository', 102, 'change_repository');
INSERT INTO public.auth_permission VALUES (307, 'Can delete repository', 102, 'delete_repository');
INSERT INTO public.auth_permission VALUES (308, 'Can add reprocessing report', 103, 'add_reprocessingreport');
INSERT INTO public.auth_permission VALUES (309, 'Can change reprocessing report', 103, 'change_reprocessingreport');
INSERT INTO public.auth_permission VALUES (310, 'Can delete reprocessing report', 103, 'delete_reprocessingreport');
INSERT INTO public.auth_permission VALUES (311, 'Can add rule', 104, 'add_rule');
INSERT INTO public.auth_permission VALUES (312, 'Can change rule', 104, 'change_rule');
INSERT INTO public.auth_permission VALUES (313, 'Can delete rule', 104, 'delete_rule');
INSERT INTO public.auth_permission VALUES (314, 'Can add saved search', 105, 'add_savedsearch');
INSERT INTO public.auth_permission VALUES (315, 'Can change saved search', 105, 'change_savedsearch');
INSERT INTO public.auth_permission VALUES (316, 'Can delete saved search', 105, 'delete_savedsearch');
INSERT INTO public.auth_permission VALUES (317, 'Can add saved search user default', 106, 'add_savedsearchuserdefault');
INSERT INTO public.auth_permission VALUES (318, 'Can change saved search user default', 106, 'change_savedsearchuserdefault');
INSERT INTO public.auth_permission VALUES (319, 'Can delete saved search user default', 106, 'delete_savedsearchuserdefault');
INSERT INTO public.auth_permission VALUES (320, 'Can add scheduled deletion', 107, 'add_scheduleddeletion');
INSERT INTO public.auth_permission VALUES (321, 'Can change scheduled deletion', 107, 'change_scheduleddeletion');
INSERT INTO public.auth_permission VALUES (322, 'Can delete scheduled deletion', 107, 'delete_scheduleddeletion');
INSERT INTO public.auth_permission VALUES (323, 'Can add scheduled job', 108, 'add_scheduledjob');
INSERT INTO public.auth_permission VALUES (324, 'Can change scheduled job', 108, 'change_scheduledjob');
INSERT INTO public.auth_permission VALUES (325, 'Can delete scheduled job', 108, 'delete_scheduledjob');
INSERT INTO public.auth_permission VALUES (326, 'Can add service hook', 109, 'add_servicehook');
INSERT INTO public.auth_permission VALUES (327, 'Can change service hook', 109, 'change_servicehook');
INSERT INTO public.auth_permission VALUES (328, 'Can delete service hook', 109, 'delete_servicehook');
INSERT INTO public.auth_permission VALUES (329, 'Can add team', 110, 'add_team');
INSERT INTO public.auth_permission VALUES (330, 'Can change team', 110, 'change_team');
INSERT INTO public.auth_permission VALUES (331, 'Can delete team', 110, 'delete_team');
INSERT INTO public.auth_permission VALUES (332, 'Can add team avatar', 111, 'add_teamavatar');
INSERT INTO public.auth_permission VALUES (333, 'Can change team avatar', 111, 'change_teamavatar');
INSERT INTO public.auth_permission VALUES (334, 'Can delete team avatar', 111, 'delete_teamavatar');
INSERT INTO public.auth_permission VALUES (335, 'Can add user', 112, 'add_user');
INSERT INTO public.auth_permission VALUES (336, 'Can change user', 112, 'change_user');
INSERT INTO public.auth_permission VALUES (337, 'Can delete user', 112, 'delete_user');
INSERT INTO public.auth_permission VALUES (338, 'Can add user avatar', 113, 'add_useravatar');
INSERT INTO public.auth_permission VALUES (339, 'Can change user avatar', 113, 'change_useravatar');
INSERT INTO public.auth_permission VALUES (340, 'Can delete user avatar', 113, 'delete_useravatar');
INSERT INTO public.auth_permission VALUES (341, 'Can add user email', 114, 'add_useremail');
INSERT INTO public.auth_permission VALUES (342, 'Can change user email', 114, 'change_useremail');
INSERT INTO public.auth_permission VALUES (343, 'Can delete user email', 114, 'delete_useremail');
INSERT INTO public.auth_permission VALUES (344, 'Can add user ip', 115, 'add_userip');
INSERT INTO public.auth_permission VALUES (345, 'Can change user ip', 115, 'change_userip');
INSERT INTO public.auth_permission VALUES (346, 'Can delete user ip', 115, 'delete_userip');
INSERT INTO public.auth_permission VALUES (347, 'Can add user option', 116, 'add_useroption');
INSERT INTO public.auth_permission VALUES (348, 'Can change user option', 116, 'change_useroption');
INSERT INTO public.auth_permission VALUES (349, 'Can delete user option', 116, 'delete_useroption');
INSERT INTO public.auth_permission VALUES (350, 'Can add user permission', 117, 'add_userpermission');
INSERT INTO public.auth_permission VALUES (351, 'Can change user permission', 117, 'change_userpermission');
INSERT INTO public.auth_permission VALUES (352, 'Can delete user permission', 117, 'delete_userpermission');
INSERT INTO public.auth_permission VALUES (353, 'Can add user report', 118, 'add_userreport');
INSERT INTO public.auth_permission VALUES (354, 'Can change user report', 118, 'change_userreport');
INSERT INTO public.auth_permission VALUES (355, 'Can delete user report', 118, 'delete_userreport');
INSERT INTO public.auth_permission VALUES (356, 'Can add event tag', 119, 'add_eventtag');
INSERT INTO public.auth_permission VALUES (357, 'Can change event tag', 119, 'change_eventtag');
INSERT INTO public.auth_permission VALUES (358, 'Can delete event tag', 119, 'delete_eventtag');
INSERT INTO public.auth_permission VALUES (359, 'Can add group tag key', 120, 'add_grouptagkey');
INSERT INTO public.auth_permission VALUES (360, 'Can change group tag key', 120, 'change_grouptagkey');
INSERT INTO public.auth_permission VALUES (361, 'Can delete group tag key', 120, 'delete_grouptagkey');
INSERT INTO public.auth_permission VALUES (362, 'Can add group tag value', 121, 'add_grouptagvalue');
INSERT INTO public.auth_permission VALUES (363, 'Can change group tag value', 121, 'change_grouptagvalue');
INSERT INTO public.auth_permission VALUES (364, 'Can delete group tag value', 121, 'delete_grouptagvalue');
INSERT INTO public.auth_permission VALUES (365, 'Can add tag key', 122, 'add_tagkey');
INSERT INTO public.auth_permission VALUES (366, 'Can change tag key', 122, 'change_tagkey');
INSERT INTO public.auth_permission VALUES (367, 'Can delete tag key', 122, 'delete_tagkey');
INSERT INTO public.auth_permission VALUES (368, 'Can add tag value', 123, 'add_tagvalue');
INSERT INTO public.auth_permission VALUES (369, 'Can change tag value', 123, 'change_tagvalue');
INSERT INTO public.auth_permission VALUES (370, 'Can delete tag value', 123, 'delete_tagvalue');
INSERT INTO public.auth_permission VALUES (371, 'Can add node', 124, 'add_node');
INSERT INTO public.auth_permission VALUES (372, 'Can change node', 124, 'change_node');
INSERT INTO public.auth_permission VALUES (373, 'Can delete node', 124, 'delete_node');
INSERT INTO public.auth_permission VALUES (374, 'Can add user social auth', 125, 'add_usersocialauth');
INSERT INTO public.auth_permission VALUES (375, 'Can change user social auth', 125, 'change_usersocialauth');
INSERT INTO public.auth_permission VALUES (376, 'Can delete user social auth', 125, 'delete_usersocialauth');
INSERT INTO public.auth_permission VALUES (377, 'Can add jira tenant', 126, 'add_jiratenant');
INSERT INTO public.auth_permission VALUES (378, 'Can change jira tenant', 126, 'change_jiratenant');
INSERT INTO public.auth_permission VALUES (379, 'Can delete jira tenant', 126, 'delete_jiratenant');
INSERT INTO public.auth_permission VALUES (380, 'Can add tenant', 127, 'add_tenant');
INSERT INTO public.auth_permission VALUES (381, 'Can change tenant', 127, 'change_tenant');
INSERT INTO public.auth_permission VALUES (382, 'Can delete tenant', 127, 'delete_tenant');


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 382, true);


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 1, false);


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.django_content_type VALUES (1, 'log entry', 'admin', 'logentry');
INSERT INTO public.django_content_type VALUES (2, 'permission', 'auth', 'permission');
INSERT INTO public.django_content_type VALUES (3, 'group', 'auth', 'group');
INSERT INTO public.django_content_type VALUES (4, 'content type', 'contenttypes', 'contenttype');
INSERT INTO public.django_content_type VALUES (5, 'session', 'sessions', 'session');
INSERT INTO public.django_content_type VALUES (6, 'site', 'sites', 'site');
INSERT INTO public.django_content_type VALUES (7, 'migration history', 'south', 'migrationhistory');
INSERT INTO public.django_content_type VALUES (8, 'activity', 'sentry', 'activity');
INSERT INTO public.django_content_type VALUES (9, 'api application', 'sentry', 'apiapplication');
INSERT INTO public.django_content_type VALUES (10, 'api authorization', 'sentry', 'apiauthorization');
INSERT INTO public.django_content_type VALUES (11, 'api grant', 'sentry', 'apigrant');
INSERT INTO public.django_content_type VALUES (12, 'api key', 'sentry', 'apikey');
INSERT INTO public.django_content_type VALUES (13, 'api token', 'sentry', 'apitoken');
INSERT INTO public.django_content_type VALUES (14, 'assistant activity', 'sentry', 'assistantactivity');
INSERT INTO public.django_content_type VALUES (15, 'audit log entry', 'sentry', 'auditlogentry');
INSERT INTO public.django_content_type VALUES (16, 'authenticator', 'sentry', 'authenticator');
INSERT INTO public.django_content_type VALUES (17, 'auth identity', 'sentry', 'authidentity');
INSERT INTO public.django_content_type VALUES (18, 'auth provider', 'sentry', 'authprovider');
INSERT INTO public.django_content_type VALUES (19, 'broadcast', 'sentry', 'broadcast');
INSERT INTO public.django_content_type VALUES (20, 'broadcast seen', 'sentry', 'broadcastseen');
INSERT INTO public.django_content_type VALUES (21, 'commit', 'sentry', 'commit');
INSERT INTO public.django_content_type VALUES (22, 'commit author', 'sentry', 'commitauthor');
INSERT INTO public.django_content_type VALUES (23, 'commit file change', 'sentry', 'commitfilechange');
INSERT INTO public.django_content_type VALUES (24, 'counter', 'sentry', 'counter');
INSERT INTO public.django_content_type VALUES (25, 'deleted organization', 'sentry', 'deletedorganization');
INSERT INTO public.django_content_type VALUES (26, 'deleted project', 'sentry', 'deletedproject');
INSERT INTO public.django_content_type VALUES (27, 'deleted team', 'sentry', 'deletedteam');
INSERT INTO public.django_content_type VALUES (28, 'deploy', 'sentry', 'deploy');
INSERT INTO public.django_content_type VALUES (29, 'distribution', 'sentry', 'distribution');
INSERT INTO public.django_content_type VALUES (30, 'file blob', 'sentry', 'fileblob');
INSERT INTO public.django_content_type VALUES (31, 'file', 'sentry', 'file');
INSERT INTO public.django_content_type VALUES (32, 'file blob index', 'sentry', 'fileblobindex');
INSERT INTO public.django_content_type VALUES (33, 'file blob owner', 'sentry', 'fileblobowner');
INSERT INTO public.django_content_type VALUES (34, 'version d sym file', 'sentry', 'versiondsymfile');
INSERT INTO public.django_content_type VALUES (35, 'd sym app', 'sentry', 'dsymapp');
INSERT INTO public.django_content_type VALUES (36, 'project d sym file', 'sentry', 'projectdsymfile');
INSERT INTO public.django_content_type VALUES (37, 'project sym cache file', 'sentry', 'projectsymcachefile');
INSERT INTO public.django_content_type VALUES (38, 'email', 'sentry', 'email');
INSERT INTO public.django_content_type VALUES (39, 'environment project', 'sentry', 'environmentproject');
INSERT INTO public.django_content_type VALUES (40, 'environment', 'sentry', 'environment');
INSERT INTO public.django_content_type VALUES (41, 'message', 'sentry', 'event');
INSERT INTO public.django_content_type VALUES (42, 'event mapping', 'sentry', 'eventmapping');
INSERT INTO public.django_content_type VALUES (43, 'event user', 'sentry', 'eventuser');
INSERT INTO public.django_content_type VALUES (44, 'external issue', 'sentry', 'externalissue');
INSERT INTO public.django_content_type VALUES (45, 'feature adoption', 'sentry', 'featureadoption');
INSERT INTO public.django_content_type VALUES (46, 'grouped message', 'sentry', 'group');
INSERT INTO public.django_content_type VALUES (47, 'group assignee', 'sentry', 'groupassignee');
INSERT INTO public.django_content_type VALUES (48, 'group bookmark', 'sentry', 'groupbookmark');
INSERT INTO public.django_content_type VALUES (49, 'group commit resolution', 'sentry', 'groupcommitresolution');
INSERT INTO public.django_content_type VALUES (50, 'group email thread', 'sentry', 'groupemailthread');
INSERT INTO public.django_content_type VALUES (51, 'group environment', 'sentry', 'groupenvironment');
INSERT INTO public.django_content_type VALUES (52, 'group hash', 'sentry', 'grouphash');
INSERT INTO public.django_content_type VALUES (53, 'group hash tombstone', 'sentry', 'grouphashtombstone');
INSERT INTO public.django_content_type VALUES (54, 'group link', 'sentry', 'grouplink');
INSERT INTO public.django_content_type VALUES (55, 'group meta', 'sentry', 'groupmeta');
INSERT INTO public.django_content_type VALUES (56, 'group redirect', 'sentry', 'groupredirect');
INSERT INTO public.django_content_type VALUES (57, 'group release', 'sentry', 'grouprelease');
INSERT INTO public.django_content_type VALUES (58, 'group resolution', 'sentry', 'groupresolution');
INSERT INTO public.django_content_type VALUES (59, 'group rule status', 'sentry', 'grouprulestatus');
INSERT INTO public.django_content_type VALUES (60, 'group seen', 'sentry', 'groupseen');
INSERT INTO public.django_content_type VALUES (61, 'group share', 'sentry', 'groupshare');
INSERT INTO public.django_content_type VALUES (62, 'group snooze', 'sentry', 'groupsnooze');
INSERT INTO public.django_content_type VALUES (63, 'group subscription', 'sentry', 'groupsubscription');
INSERT INTO public.django_content_type VALUES (64, 'group tombstone', 'sentry', 'grouptombstone');
INSERT INTO public.django_content_type VALUES (65, 'identity provider', 'sentry', 'identityprovider');
INSERT INTO public.django_content_type VALUES (66, 'identity', 'sentry', 'identity');
INSERT INTO public.django_content_type VALUES (67, 'organization integration', 'sentry', 'organizationintegration');
INSERT INTO public.django_content_type VALUES (68, 'project integration', 'sentry', 'projectintegration');
INSERT INTO public.django_content_type VALUES (69, 'integration', 'sentry', 'integration');
INSERT INTO public.django_content_type VALUES (70, 'latest release', 'sentry', 'latestrelease');
INSERT INTO public.django_content_type VALUES (71, 'lost password hash', 'sentry', 'lostpasswordhash');
INSERT INTO public.django_content_type VALUES (72, 'option', 'sentry', 'option');
INSERT INTO public.django_content_type VALUES (73, 'organization', 'sentry', 'organization');
INSERT INTO public.django_content_type VALUES (74, 'organization access request', 'sentry', 'organizationaccessrequest');
INSERT INTO public.django_content_type VALUES (75, 'organization avatar', 'sentry', 'organizationavatar');
INSERT INTO public.django_content_type VALUES (76, 'organization member team', 'sentry', 'organizationmemberteam');
INSERT INTO public.django_content_type VALUES (77, 'organization member', 'sentry', 'organizationmember');
INSERT INTO public.django_content_type VALUES (78, 'organization onboarding task', 'sentry', 'organizationonboardingtask');
INSERT INTO public.django_content_type VALUES (79, 'organization option', 'sentry', 'organizationoption');
INSERT INTO public.django_content_type VALUES (80, 'processing issue', 'sentry', 'processingissue');
INSERT INTO public.django_content_type VALUES (81, 'event processing issue', 'sentry', 'eventprocessingissue');
INSERT INTO public.django_content_type VALUES (82, 'project team', 'sentry', 'projectteam');
INSERT INTO public.django_content_type VALUES (83, 'project', 'sentry', 'project');
INSERT INTO public.django_content_type VALUES (84, 'project avatar', 'sentry', 'projectavatar');
INSERT INTO public.django_content_type VALUES (85, 'project bookmark', 'sentry', 'projectbookmark');
INSERT INTO public.django_content_type VALUES (86, 'project key', 'sentry', 'projectkey');
INSERT INTO public.django_content_type VALUES (87, 'project option', 'sentry', 'projectoption');
INSERT INTO public.django_content_type VALUES (88, 'project ownership', 'sentry', 'projectownership');
INSERT INTO public.django_content_type VALUES (89, 'project platform', 'sentry', 'projectplatform');
INSERT INTO public.django_content_type VALUES (90, 'project redirect', 'sentry', 'projectredirect');
INSERT INTO public.django_content_type VALUES (91, 'pull request', 'sentry', 'pullrequest');
INSERT INTO public.django_content_type VALUES (92, 'pull request commit', 'sentry', 'pullrequestcommit');
INSERT INTO public.django_content_type VALUES (93, 'raw event', 'sentry', 'rawevent');
INSERT INTO public.django_content_type VALUES (94, 'relay', 'sentry', 'relay');
INSERT INTO public.django_content_type VALUES (95, 'release project', 'sentry', 'releaseproject');
INSERT INTO public.django_content_type VALUES (96, 'release', 'sentry', 'release');
INSERT INTO public.django_content_type VALUES (97, 'release commit', 'sentry', 'releasecommit');
INSERT INTO public.django_content_type VALUES (98, 'release environment', 'sentry', 'releaseenvironment');
INSERT INTO public.django_content_type VALUES (99, 'release file', 'sentry', 'releasefile');
INSERT INTO public.django_content_type VALUES (100, 'release head commit', 'sentry', 'releaseheadcommit');
INSERT INTO public.django_content_type VALUES (101, 'release project environment', 'sentry', 'releaseprojectenvironment');
INSERT INTO public.django_content_type VALUES (102, 'repository', 'sentry', 'repository');
INSERT INTO public.django_content_type VALUES (103, 'reprocessing report', 'sentry', 'reprocessingreport');
INSERT INTO public.django_content_type VALUES (104, 'rule', 'sentry', 'rule');
INSERT INTO public.django_content_type VALUES (105, 'saved search', 'sentry', 'savedsearch');
INSERT INTO public.django_content_type VALUES (106, 'saved search user default', 'sentry', 'savedsearchuserdefault');
INSERT INTO public.django_content_type VALUES (107, 'scheduled deletion', 'sentry', 'scheduleddeletion');
INSERT INTO public.django_content_type VALUES (108, 'scheduled job', 'sentry', 'scheduledjob');
INSERT INTO public.django_content_type VALUES (109, 'service hook', 'sentry', 'servicehook');
INSERT INTO public.django_content_type VALUES (110, 'team', 'sentry', 'team');
INSERT INTO public.django_content_type VALUES (111, 'team avatar', 'sentry', 'teamavatar');
INSERT INTO public.django_content_type VALUES (112, 'user', 'sentry', 'user');
INSERT INTO public.django_content_type VALUES (113, 'user avatar', 'sentry', 'useravatar');
INSERT INTO public.django_content_type VALUES (114, 'user email', 'sentry', 'useremail');
INSERT INTO public.django_content_type VALUES (115, 'user ip', 'sentry', 'userip');
INSERT INTO public.django_content_type VALUES (116, 'user option', 'sentry', 'useroption');
INSERT INTO public.django_content_type VALUES (117, 'user permission', 'sentry', 'userpermission');
INSERT INTO public.django_content_type VALUES (118, 'user report', 'sentry', 'userreport');
INSERT INTO public.django_content_type VALUES (119, 'event tag', 'sentry', 'eventtag');
INSERT INTO public.django_content_type VALUES (120, 'group tag key', 'sentry', 'grouptagkey');
INSERT INTO public.django_content_type VALUES (121, 'group tag value', 'sentry', 'grouptagvalue');
INSERT INTO public.django_content_type VALUES (122, 'tag key', 'sentry', 'tagkey');
INSERT INTO public.django_content_type VALUES (123, 'tag value', 'sentry', 'tagvalue');
INSERT INTO public.django_content_type VALUES (124, 'node', 'nodestore', 'node');
INSERT INTO public.django_content_type VALUES (125, 'user social auth', 'social_auth', 'usersocialauth');
INSERT INTO public.django_content_type VALUES (126, 'jira tenant', 'jira_ac', 'jiratenant');
INSERT INTO public.django_content_type VALUES (127, 'tenant', 'hipchat_ac', 'tenant');


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 127, true);


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: django_site; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.django_site VALUES (1, 'example.com', 'example.com');


--
-- Name: django_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_site_id_seq', 1, true);


--
-- Data for Name: jira_ac_tenant; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: jira_ac_tenant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.jira_ac_tenant_id_seq', 1, false);


--
-- Data for Name: nodestore_node; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: sentry_activity; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_activity_id_seq', 1, false);


--
-- Data for Name: sentry_apiapplication; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_apiapplication_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_apiapplication_id_seq', 1, false);


--
-- Data for Name: sentry_apiauthorization; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_apiauthorization_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_apiauthorization_id_seq', 1, false);


--
-- Data for Name: sentry_apigrant; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_apigrant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_apigrant_id_seq', 1, false);


--
-- Data for Name: sentry_apikey; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_apikey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_apikey_id_seq', 1, false);


--
-- Data for Name: sentry_apitoken; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_apitoken_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_apitoken_id_seq', 1, false);


--
-- Data for Name: sentry_assistant_activity; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_assistant_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_assistant_activity_id_seq', 1, false);


--
-- Data for Name: sentry_auditlogentry; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_auditlogentry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_auditlogentry_id_seq', 1, false);


--
-- Data for Name: sentry_authidentity; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_authidentity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_authidentity_id_seq', 1, false);


--
-- Data for Name: sentry_authprovider; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: sentry_authprovider_default_teams; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_authprovider_default_teams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_authprovider_default_teams_id_seq', 1, false);


--
-- Name: sentry_authprovider_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_authprovider_id_seq', 1, false);


--
-- Data for Name: sentry_broadcast; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_broadcast_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_broadcast_id_seq', 1, false);


--
-- Data for Name: sentry_broadcastseen; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_broadcastseen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_broadcastseen_id_seq', 1, false);


--
-- Data for Name: sentry_commit; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_commit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_commit_id_seq', 1, false);


--
-- Data for Name: sentry_commitauthor; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_commitauthor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_commitauthor_id_seq', 1, false);


--
-- Data for Name: sentry_commitfilechange; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_commitfilechange_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_commitfilechange_id_seq', 1, false);


--
-- Data for Name: sentry_deletedorganization; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_deletedorganization_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_deletedorganization_id_seq', 1, false);


--
-- Data for Name: sentry_deletedproject; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_deletedproject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_deletedproject_id_seq', 1, false);


--
-- Data for Name: sentry_deletedteam; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_deletedteam_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_deletedteam_id_seq', 1, false);


--
-- Data for Name: sentry_deploy; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_deploy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_deploy_id_seq', 1, false);


--
-- Data for Name: sentry_distribution; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_distribution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_distribution_id_seq', 1, false);


--
-- Data for Name: sentry_dsymapp; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_dsymapp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_dsymapp_id_seq', 1, false);


--
-- Data for Name: sentry_email; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_email_id_seq', 1, false);


--
-- Data for Name: sentry_environment; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_environment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_environment_id_seq', 1, false);


--
-- Data for Name: sentry_environmentproject; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_environmentproject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_environmentproject_id_seq', 1, false);


--
-- Data for Name: sentry_environmentrelease; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_environmentrelease_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_environmentrelease_id_seq', 1, false);


--
-- Data for Name: sentry_eventmapping; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_eventmapping_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_eventmapping_id_seq', 1, false);


--
-- Data for Name: sentry_eventprocessingissue; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_eventprocessingissue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_eventprocessingissue_id_seq', 1, false);


--
-- Data for Name: sentry_eventtag; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_eventtag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_eventtag_id_seq', 1, false);


--
-- Data for Name: sentry_eventuser; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_eventuser_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_eventuser_id_seq', 1, false);


--
-- Data for Name: sentry_externalissue; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_externalissue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_externalissue_id_seq', 1, false);


--
-- Data for Name: sentry_featureadoption; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_featureadoption_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_featureadoption_id_seq', 1, false);


--
-- Data for Name: sentry_file; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_file_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_file_id_seq', 1, false);


--
-- Data for Name: sentry_fileblob; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_fileblob_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_fileblob_id_seq', 1, false);


--
-- Data for Name: sentry_fileblobindex; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_fileblobindex_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_fileblobindex_id_seq', 1, false);


--
-- Data for Name: sentry_fileblobowner; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_fileblobowner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_fileblobowner_id_seq', 1, false);


--
-- Data for Name: sentry_filterkey; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_filterkey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_filterkey_id_seq', 1, false);


--
-- Data for Name: sentry_filtervalue; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_filtervalue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_filtervalue_id_seq', 1, false);


--
-- Data for Name: sentry_groupasignee; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_groupasignee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_groupasignee_id_seq', 1, false);


--
-- Data for Name: sentry_groupbookmark; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_groupbookmark_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_groupbookmark_id_seq', 1, false);


--
-- Data for Name: sentry_groupcommitresolution; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_groupcommitresolution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_groupcommitresolution_id_seq', 1, false);


--
-- Data for Name: sentry_groupedmessage; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_groupedmessage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_groupedmessage_id_seq', 1, false);


--
-- Data for Name: sentry_groupemailthread; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_groupemailthread_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_groupemailthread_id_seq', 1, false);


--
-- Data for Name: sentry_groupenvironment; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_groupenvironment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_groupenvironment_id_seq', 1, false);


--
-- Data for Name: sentry_grouphash; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_grouphash_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_grouphash_id_seq', 1, false);


--
-- Data for Name: sentry_grouphashtombstone; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_grouphashtombstone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_grouphashtombstone_id_seq', 1, false);


--
-- Data for Name: sentry_grouplink; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_grouplink_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_grouplink_id_seq', 1, false);


--
-- Data for Name: sentry_groupmeta; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_groupmeta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_groupmeta_id_seq', 1, false);


--
-- Data for Name: sentry_groupredirect; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_groupredirect_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_groupredirect_id_seq', 1, false);


--
-- Data for Name: sentry_grouprelease; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_grouprelease_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_grouprelease_id_seq', 1, false);


--
-- Data for Name: sentry_groupresolution; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_groupresolution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_groupresolution_id_seq', 1, false);


--
-- Data for Name: sentry_grouprulestatus; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_grouprulestatus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_grouprulestatus_id_seq', 1, false);


--
-- Data for Name: sentry_groupseen; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_groupseen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_groupseen_id_seq', 1, false);


--
-- Data for Name: sentry_groupshare; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_groupshare_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_groupshare_id_seq', 1, false);


--
-- Data for Name: sentry_groupsnooze; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_groupsnooze_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_groupsnooze_id_seq', 1, false);


--
-- Data for Name: sentry_groupsubscription; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_groupsubscription_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_groupsubscription_id_seq', 1, false);


--
-- Data for Name: sentry_grouptagkey; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_grouptagkey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_grouptagkey_id_seq', 1, false);


--
-- Data for Name: sentry_grouptombstone; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_grouptombstone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_grouptombstone_id_seq', 1, false);


--
-- Data for Name: sentry_hipchat_ac_tenant; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: sentry_hipchat_ac_tenant_organizations; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_hipchat_ac_tenant_organizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_hipchat_ac_tenant_organizations_id_seq', 1, false);


--
-- Data for Name: sentry_hipchat_ac_tenant_projects; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_hipchat_ac_tenant_projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_hipchat_ac_tenant_projects_id_seq', 1, false);


--
-- Data for Name: sentry_identity; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_identity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_identity_id_seq', 1, false);


--
-- Data for Name: sentry_identityprovider; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_identityprovider_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_identityprovider_id_seq', 1, false);


--
-- Data for Name: sentry_integration; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_integration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_integration_id_seq', 1, false);


--
-- Data for Name: sentry_latestrelease; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_latestrelease_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_latestrelease_id_seq', 1, false);


--
-- Data for Name: sentry_lostpasswordhash; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_lostpasswordhash_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_lostpasswordhash_id_seq', 1, false);


--
-- Data for Name: sentry_message; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_message_id_seq', 1, false);


--
-- Data for Name: sentry_messagefiltervalue; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_messagefiltervalue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_messagefiltervalue_id_seq', 1, false);


--
-- Data for Name: sentry_messageindex; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_messageindex_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_messageindex_id_seq', 1, false);


--
-- Data for Name: sentry_option; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_option_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_option_id_seq', 1, false);


--
-- Data for Name: sentry_organization; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.sentry_organization VALUES (1, 'Practo', 0, '2019-03-20 08:50:00.674565+00', 'practo', 1, 'member');


--
-- Name: sentry_organization_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_organization_id_seq', 1, true);


--
-- Data for Name: sentry_organizationaccessrequest; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_organizationaccessrequest_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_organizationaccessrequest_id_seq', 1, false);


--
-- Data for Name: sentry_organizationavatar; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_organizationavatar_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_organizationavatar_id_seq', 1, false);


--
-- Data for Name: sentry_organizationintegration; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_organizationintegration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_organizationintegration_id_seq', 1, false);


--
-- Data for Name: sentry_organizationmember; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_organizationmember_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_organizationmember_id_seq', 1, false);


--
-- Data for Name: sentry_organizationmember_teams; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_organizationmember_teams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_organizationmember_teams_id_seq', 1, false);


--
-- Data for Name: sentry_organizationonboardingtask; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_organizationonboardingtask_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_organizationonboardingtask_id_seq', 1, false);


--
-- Data for Name: sentry_organizationoptions; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_organizationoptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_organizationoptions_id_seq', 1, false);


--
-- Data for Name: sentry_processingissue; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_processingissue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_processingissue_id_seq', 1, false);


--
-- Data for Name: sentry_project; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_project_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_project_id_seq', 1, true);


--
-- Data for Name: sentry_projectavatar; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_projectavatar_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_projectavatar_id_seq', 1, false);


--
-- Data for Name: sentry_projectbookmark; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_projectbookmark_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_projectbookmark_id_seq', 1, false);


--
-- Data for Name: sentry_projectcounter; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_projectcounter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_projectcounter_id_seq', 1, false);


--
-- Data for Name: sentry_projectdsymfile; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_projectdsymfile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_projectdsymfile_id_seq', 1, false);


--
-- Data for Name: sentry_projectintegration; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_projectintegration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_projectintegration_id_seq', 1, false);


--
-- Data for Name: sentry_projectkey; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_projectkey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_projectkey_id_seq', 1, true);


--
-- Data for Name: sentry_projectoptions; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_projectoptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_projectoptions_id_seq', 3, true);


--
-- Data for Name: sentry_projectownership; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_projectownership_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_projectownership_id_seq', 1, false);


--
-- Data for Name: sentry_projectplatform; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_projectplatform_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_projectplatform_id_seq', 1, false);


--
-- Data for Name: sentry_projectredirect; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_projectredirect_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_projectredirect_id_seq', 1, false);


--
-- Data for Name: sentry_projectsymcachefile; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_projectsymcachefile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_projectsymcachefile_id_seq', 1, false);


--
-- Data for Name: sentry_projectteam; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_projectteam_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_projectteam_id_seq', 1, true);


--
-- Data for Name: sentry_pull_request; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_pull_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_pull_request_id_seq', 1, false);


--
-- Data for Name: sentry_pullrequest_commit; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_pullrequest_commit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_pullrequest_commit_id_seq', 1, false);


--
-- Data for Name: sentry_rawevent; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_rawevent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_rawevent_id_seq', 1, false);


--
-- Data for Name: sentry_relay; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_relay_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_relay_id_seq', 1, false);


--
-- Data for Name: sentry_release; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_release_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_release_id_seq', 1, false);


--
-- Data for Name: sentry_release_project; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_release_project_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_release_project_id_seq', 1, false);


--
-- Data for Name: sentry_releasecommit; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_releasecommit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_releasecommit_id_seq', 1, false);


--
-- Data for Name: sentry_releasefile; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_releasefile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_releasefile_id_seq', 1, false);


--
-- Data for Name: sentry_releaseheadcommit; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_releaseheadcommit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_releaseheadcommit_id_seq', 1, false);


--
-- Data for Name: sentry_releaseprojectenvironment; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_releaseprojectenvironment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_releaseprojectenvironment_id_seq', 1, false);


--
-- Data for Name: sentry_repository; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_repository_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_repository_id_seq', 1, false);


--
-- Data for Name: sentry_reprocessingreport; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_reprocessingreport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_reprocessingreport_id_seq', 1, false);


--
-- Data for Name: sentry_rule; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_rule_id_seq', 1, true);


--
-- Data for Name: sentry_savedsearch; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_savedsearch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_savedsearch_id_seq', 5, true);


--
-- Data for Name: sentry_savedsearch_userdefault; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_savedsearch_userdefault_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_savedsearch_userdefault_id_seq', 1, false);


--
-- Data for Name: sentry_scheduleddeletion; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_scheduleddeletion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_scheduleddeletion_id_seq', 1, false);


--
-- Data for Name: sentry_scheduledjob; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_scheduledjob_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_scheduledjob_id_seq', 1, false);


--
-- Data for Name: sentry_servicehook; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_servicehook_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_servicehook_id_seq', 1, false);


--
-- Data for Name: sentry_team; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.sentry_team VALUES (1, 'sentry', 'Sentry', '2019-03-20 08:50:00.680142+00', 0, 1);


--
-- Name: sentry_team_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_team_id_seq', 1, true);


--
-- Data for Name: sentry_teamavatar; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_teamavatar_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_teamavatar_id_seq', 1, false);


--
-- Data for Name: sentry_useravatar; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_useravatar_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_useravatar_id_seq', 1, false);


--
-- Data for Name: sentry_useremail; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_useremail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_useremail_id_seq', 1, false);


--
-- Data for Name: sentry_userip; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_userip_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_userip_id_seq', 1, false);


--
-- Data for Name: sentry_useroption; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_useroption_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_useroption_id_seq', 1, false);


--
-- Data for Name: sentry_userpermission; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_userpermission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_userpermission_id_seq', 1, false);


--
-- Data for Name: sentry_userreport; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_userreport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_userreport_id_seq', 1, false);


--
-- Data for Name: sentry_versiondsymfile; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: sentry_versiondsymfile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sentry_versiondsymfile_id_seq', 1, false);


--
-- Data for Name: social_auth_usersocialauth; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: social_auth_usersocialauth_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.social_auth_usersocialauth_id_seq', 1, false);


--
-- Data for Name: south_migrationhistory; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.south_migrationhistory VALUES (1, 'sentry', '0001_initial', '2019-03-20 08:47:38.654451+00');
INSERT INTO public.south_migrationhistory VALUES (2, 'sentry', '0002_auto__del_field_groupedmessage_url__chg_field_groupedmessage_view__chg', '2019-03-20 08:47:38.721935+00');
INSERT INTO public.south_migrationhistory VALUES (3, 'sentry', '0003_auto__add_field_message_group__del_field_groupedmessage_server_name', '2019-03-20 08:47:38.755981+00');
INSERT INTO public.south_migrationhistory VALUES (4, 'sentry', '0004_auto__add_filtervalue__add_unique_filtervalue_key_value', '2019-03-20 08:47:38.778464+00');
INSERT INTO public.south_migrationhistory VALUES (5, 'sentry', '0005_auto', '2019-03-20 08:47:38.797943+00');
INSERT INTO public.south_migrationhistory VALUES (6, 'sentry', '0006_auto', '2019-03-20 08:47:38.813098+00');
INSERT INTO public.south_migrationhistory VALUES (7, 'sentry', '0007_auto__add_field_message_site', '2019-03-20 08:47:38.840883+00');
INSERT INTO public.south_migrationhistory VALUES (8, 'sentry', '0008_auto__chg_field_message_view__add_field_groupedmessage_data__chg_field', '2019-03-20 08:47:38.926822+00');
INSERT INTO public.south_migrationhistory VALUES (9, 'sentry', '0009_auto__add_field_message_message_id', '2019-03-20 08:47:38.950405+00');
INSERT INTO public.south_migrationhistory VALUES (10, 'sentry', '0010_auto__add_messageindex__add_unique_messageindex_column_value_object_id', '2019-03-20 08:47:38.971651+00');
INSERT INTO public.south_migrationhistory VALUES (11, 'sentry', '0011_auto__add_field_groupedmessage_score', '2019-03-20 08:47:39.03965+00');
INSERT INTO public.south_migrationhistory VALUES (12, 'sentry', '0012_auto', '2019-03-20 08:47:39.058914+00');
INSERT INTO public.south_migrationhistory VALUES (13, 'sentry', '0013_auto__add_messagecountbyminute__add_unique_messagecountbyminute_group_', '2019-03-20 08:47:39.110118+00');
INSERT INTO public.south_migrationhistory VALUES (14, 'sentry', '0014_auto', '2019-03-20 08:47:39.127444+00');
INSERT INTO public.south_migrationhistory VALUES (15, 'sentry', '0014_auto__add_project__add_projectmember__add_unique_projectmember_project', '2019-03-20 08:47:39.186171+00');
INSERT INTO public.south_migrationhistory VALUES (16, 'sentry', '0015_auto__add_field_message_project__add_field_messagecountbyminute_projec', '2019-03-20 08:47:39.311744+00');
INSERT INTO public.south_migrationhistory VALUES (17, 'sentry', '0016_auto__add_field_projectmember_is_superuser', '2019-03-20 08:47:39.352719+00');
INSERT INTO public.south_migrationhistory VALUES (18, 'sentry', '0017_auto__add_field_projectmember_api_key', '2019-03-20 08:47:39.396648+00');
INSERT INTO public.south_migrationhistory VALUES (19, 'sentry', '0018_auto__chg_field_project_owner', '2019-03-20 08:47:39.469344+00');
INSERT INTO public.south_migrationhistory VALUES (20, 'sentry', '0019_auto__del_field_projectmember_api_key__add_field_projectmember_public_', '2019-03-20 08:47:39.525044+00');
INSERT INTO public.south_migrationhistory VALUES (21, 'sentry', '0020_auto__add_projectdomain__add_unique_projectdomain_project_domain', '2019-03-20 08:47:39.585+00');
INSERT INTO public.south_migrationhistory VALUES (22, 'sentry', '0021_auto__del_message__del_groupedmessage__del_unique_groupedmessage_proje', '2019-03-20 08:47:39.621175+00');
INSERT INTO public.south_migrationhistory VALUES (23, 'sentry', '0022_auto__del_field_group_class_name__del_field_group_traceback__del_field', '2019-03-20 08:47:39.655778+00');
INSERT INTO public.south_migrationhistory VALUES (24, 'sentry', '0023_auto__add_field_event_time_spent', '2019-03-20 08:47:39.68382+00');
INSERT INTO public.south_migrationhistory VALUES (25, 'sentry', '0024_auto__add_field_group_time_spent_total__add_field_group_time_spent_cou', '2019-03-20 08:47:39.836324+00');
INSERT INTO public.south_migrationhistory VALUES (26, 'sentry', '0025_auto__add_field_messagecountbyminute_time_spent_total__add_field_messa', '2019-03-20 08:47:39.923948+00');
INSERT INTO public.south_migrationhistory VALUES (27, 'sentry', '0026_auto__add_field_project_status', '2019-03-20 08:47:39.974478+00');
INSERT INTO public.south_migrationhistory VALUES (28, 'sentry', '0027_auto__chg_field_event_server_name', '2019-03-20 08:47:40.023016+00');
INSERT INTO public.south_migrationhistory VALUES (29, 'sentry', '0028_auto__add_projectoptions__add_unique_projectoptions_project_key_value', '2019-03-20 08:47:40.07289+00');
INSERT INTO public.south_migrationhistory VALUES (30, 'sentry', '0029_auto__del_field_projectmember_is_superuser__del_field_projectmember_pe', '2019-03-20 08:47:40.129393+00');
INSERT INTO public.south_migrationhistory VALUES (31, 'sentry', '0030_auto__add_view__chg_field_event_group', '2019-03-20 08:47:40.191842+00');
INSERT INTO public.south_migrationhistory VALUES (32, 'sentry', '0031_auto__add_field_view_verbose_name__add_field_view_verbose_name_plural_', '2019-03-20 08:47:40.237315+00');
INSERT INTO public.south_migrationhistory VALUES (33, 'sentry', '0032_auto__add_eventmeta', '2019-03-20 08:47:40.303467+00');
INSERT INTO public.south_migrationhistory VALUES (34, 'sentry', '0033_auto__add_option__add_unique_option_key_value', '2019-03-20 08:47:40.341401+00');
INSERT INTO public.south_migrationhistory VALUES (35, 'sentry', '0034_auto__add_groupbookmark__add_unique_groupbookmark_project_user_group', '2019-03-20 08:47:40.404237+00');
INSERT INTO public.south_migrationhistory VALUES (36, 'sentry', '0034_auto__add_unique_option_key__del_unique_option_value_key__del_unique_g', '2019-03-20 08:47:40.486742+00');
INSERT INTO public.south_migrationhistory VALUES (37, 'sentry', '0036_auto__chg_field_option_value__chg_field_projectoption_value', '2019-03-20 08:47:40.57695+00');
INSERT INTO public.south_migrationhistory VALUES (38, 'sentry', '0037_auto__add_unique_option_key__del_unique_option_value_key__del_unique_g', '2019-03-20 08:47:40.648203+00');
INSERT INTO public.south_migrationhistory VALUES (39, 'sentry', '0038_auto__add_searchtoken__add_unique_searchtoken_document_field_token__ad', '2019-03-20 08:47:40.728957+00');
INSERT INTO public.south_migrationhistory VALUES (40, 'sentry', '0039_auto__add_field_searchdocument_status', '2019-03-20 08:47:40.789481+00');
INSERT INTO public.south_migrationhistory VALUES (41, 'sentry', '0040_auto__del_unique_event_event_id__add_unique_event_project_event_id', '2019-03-20 08:47:40.864269+00');
INSERT INTO public.south_migrationhistory VALUES (42, 'sentry', '0041_auto__add_field_messagefiltervalue_last_seen__add_field_messagefilterv', '2019-03-20 08:47:40.926952+00');
INSERT INTO public.south_migrationhistory VALUES (43, 'sentry', '0042_auto__add_projectcountbyminute__add_unique_projectcountbyminute_projec', '2019-03-20 08:47:40.993098+00');
INSERT INTO public.south_migrationhistory VALUES (44, 'sentry', '0043_auto__chg_field_option_value__chg_field_projectoption_value', '2019-03-20 08:47:41.076195+00');
INSERT INTO public.south_migrationhistory VALUES (45, 'sentry', '0044_auto__add_field_projectmember_is_active', '2019-03-20 08:47:41.149271+00');
INSERT INTO public.south_migrationhistory VALUES (46, 'sentry', '0045_auto__add_pendingprojectmember__add_unique_pendingprojectmember_projec', '2019-03-20 08:47:41.220617+00');
INSERT INTO public.south_migrationhistory VALUES (47, 'sentry', '0046_auto__add_teammember__add_unique_teammember_team_user__add_team__add_p', '2019-03-20 08:47:41.355766+00');
INSERT INTO public.south_migrationhistory VALUES (48, 'sentry', '0047_migrate_project_slugs', '2019-03-20 08:47:41.583981+00');
INSERT INTO public.south_migrationhistory VALUES (49, 'sentry', '0048_migrate_project_keys', '2019-03-20 08:47:41.62591+00');
INSERT INTO public.south_migrationhistory VALUES (50, 'sentry', '0049_create_default_project_keys', '2019-03-20 08:47:41.678128+00');
INSERT INTO public.south_migrationhistory VALUES (51, 'sentry', '0050_remove_project_keys_from_members', '2019-03-20 08:47:41.729222+00');
INSERT INTO public.south_migrationhistory VALUES (52, 'sentry', '0051_auto__del_pendingprojectmember__del_unique_pendingprojectmember_projec', '2019-03-20 08:47:41.809942+00');
INSERT INTO public.south_migrationhistory VALUES (53, 'sentry', '0052_migrate_project_members', '2019-03-20 08:47:41.865723+00');
INSERT INTO public.south_migrationhistory VALUES (54, 'sentry', '0053_auto__del_projectmember__del_unique_projectmember_project_user', '2019-03-20 08:47:41.934671+00');
INSERT INTO public.south_migrationhistory VALUES (55, 'sentry', '0054_fix_project_keys', '2019-03-20 08:47:41.982482+00');
INSERT INTO public.south_migrationhistory VALUES (56, 'sentry', '0055_auto__del_projectdomain__del_unique_projectdomain_project_domain', '2019-03-20 08:47:42.046591+00');
INSERT INTO public.south_migrationhistory VALUES (57, 'sentry', '0056_auto__add_field_group_resolved_at', '2019-03-20 08:47:42.098602+00');
INSERT INTO public.south_migrationhistory VALUES (58, 'sentry', '0057_auto__add_field_group_active_at', '2019-03-20 08:47:42.171276+00');
INSERT INTO public.south_migrationhistory VALUES (59, 'sentry', '0058_auto__add_useroption__add_unique_useroption_user_project_key', '2019-03-20 08:47:42.244808+00');
INSERT INTO public.south_migrationhistory VALUES (60, 'sentry', '0059_auto__add_filterkey__add_unique_filterkey_project_key', '2019-03-20 08:47:42.317513+00');
INSERT INTO public.south_migrationhistory VALUES (61, 'sentry', '0060_fill_filter_key', '2019-03-20 08:47:42.366691+00');
INSERT INTO public.south_migrationhistory VALUES (62, 'sentry', '0061_auto__add_field_group_group_id__add_field_group_is_public', '2019-03-20 08:47:42.471088+00');
INSERT INTO public.south_migrationhistory VALUES (63, 'sentry', '0062_correct_del_index_sentry_groupedmessage_logger__view__checksum', '2019-03-20 08:47:42.521636+00');
INSERT INTO public.south_migrationhistory VALUES (64, 'sentry', '0063_auto', '2019-03-20 08:47:42.57388+00');
INSERT INTO public.south_migrationhistory VALUES (65, 'sentry', '0064_index_checksum', '2019-03-20 08:47:42.63788+00');
INSERT INTO public.south_migrationhistory VALUES (66, 'sentry', '0065_create_default_project_key', '2019-03-20 08:47:42.697102+00');
INSERT INTO public.south_migrationhistory VALUES (67, 'sentry', '0066_auto__del_view', '2019-03-20 08:47:42.753696+00');
INSERT INTO public.south_migrationhistory VALUES (68, 'sentry', '0067_auto__add_field_group_platform__add_field_event_platform', '2019-03-20 08:47:42.810413+00');
INSERT INTO public.south_migrationhistory VALUES (69, 'sentry', '0068_auto__add_field_projectkey_user_added__add_field_projectkey_date_added', '2019-03-20 08:47:42.865383+00');
INSERT INTO public.south_migrationhistory VALUES (70, 'sentry', '0069_auto__add_lostpasswordhash', '2019-03-20 08:47:42.941081+00');
INSERT INTO public.south_migrationhistory VALUES (71, 'sentry', '0070_projectoption_key_length', '2019-03-20 08:47:43.018057+00');
INSERT INTO public.south_migrationhistory VALUES (72, 'sentry', '0071_auto__add_field_group_users_seen', '2019-03-20 08:47:43.134224+00');
INSERT INTO public.south_migrationhistory VALUES (73, 'sentry', '0072_auto__add_affecteduserbygroup__add_unique_affecteduserbygroup_project_', '2019-03-20 08:47:43.237986+00');
INSERT INTO public.south_migrationhistory VALUES (74, 'sentry', '0073_auto__add_field_project_platform', '2019-03-20 08:47:43.306516+00');
INSERT INTO public.south_migrationhistory VALUES (75, 'sentry', '0074_correct_filtervalue_index', '2019-03-20 08:47:43.384131+00');
INSERT INTO public.south_migrationhistory VALUES (76, 'sentry', '0075_add_groupbookmark_index', '2019-03-20 08:47:43.446182+00');
INSERT INTO public.south_migrationhistory VALUES (77, 'sentry', '0076_add_groupmeta_index', '2019-03-20 08:47:43.528642+00');
INSERT INTO public.south_migrationhistory VALUES (78, 'sentry', '0077_auto__add_trackeduser__add_unique_trackeduser_project_ident', '2019-03-20 08:47:43.618125+00');
INSERT INTO public.south_migrationhistory VALUES (79, 'sentry', '0078_auto__add_field_affecteduserbygroup_tuser', '2019-03-20 08:47:43.690448+00');
INSERT INTO public.south_migrationhistory VALUES (80, 'sentry', '0079_auto__del_unique_affecteduserbygroup_project_ident_group__add_unique_a', '2019-03-20 08:47:43.783941+00');
INSERT INTO public.south_migrationhistory VALUES (81, 'sentry', '0080_auto__chg_field_affecteduserbygroup_ident', '2019-03-20 08:47:43.867363+00');
INSERT INTO public.south_migrationhistory VALUES (82, 'sentry', '0081_fill_trackeduser', '2019-03-20 08:47:43.93534+00');
INSERT INTO public.south_migrationhistory VALUES (83, 'sentry', '0082_auto__add_activity__add_field_group_num_comments__add_field_event_num_', '2019-03-20 08:47:44.121065+00');
INSERT INTO public.south_migrationhistory VALUES (84, 'sentry', '0083_migrate_dupe_groups', '2019-03-20 08:47:44.200609+00');
INSERT INTO public.south_migrationhistory VALUES (85, 'sentry', '0084_auto__del_unique_group_project_checksum_logger_culprit__add_unique_gro', '2019-03-20 08:47:44.282416+00');
INSERT INTO public.south_migrationhistory VALUES (86, 'sentry', '0085_auto__del_unique_project_slug__add_unique_project_slug_team', '2019-03-20 08:47:44.363708+00');
INSERT INTO public.south_migrationhistory VALUES (87, 'sentry', '0086_auto__add_field_team_date_added', '2019-03-20 08:47:44.446177+00');
INSERT INTO public.south_migrationhistory VALUES (88, 'sentry', '0087_auto__del_messagefiltervalue__del_unique_messagefiltervalue_project_ke', '2019-03-20 08:47:44.505629+00');
INSERT INTO public.south_migrationhistory VALUES (89, 'sentry', '0088_auto__del_messagecountbyminute__del_unique_messagecountbyminute_projec', '2019-03-20 08:47:44.580678+00');
INSERT INTO public.south_migrationhistory VALUES (90, 'sentry', '0089_auto__add_accessgroup__add_unique_accessgroup_team_name', '2019-03-20 08:47:44.713295+00');
INSERT INTO public.south_migrationhistory VALUES (91, 'sentry', '0090_auto__add_grouptagkey__add_unique_grouptagkey_project_group_key__add_f', '2019-03-20 08:47:45.061469+00');
INSERT INTO public.south_migrationhistory VALUES (92, 'sentry', '0091_auto__add_alert', '2019-03-20 08:47:45.18146+00');
INSERT INTO public.south_migrationhistory VALUES (93, 'sentry', '0092_auto__add_alertrelatedgroup__add_unique_alertrelatedgroup_group_alert', '2019-03-20 08:47:45.296398+00');
INSERT INTO public.south_migrationhistory VALUES (94, 'sentry', '0093_auto__add_field_alert_status', '2019-03-20 08:47:45.399066+00');
INSERT INTO public.south_migrationhistory VALUES (95, 'sentry', '0094_auto__add_eventmapping__add_unique_eventmapping_project_event_id', '2019-03-20 08:47:45.50306+00');
INSERT INTO public.south_migrationhistory VALUES (96, 'sentry', '0095_rebase', '2019-03-20 08:47:45.599728+00');
INSERT INTO public.south_migrationhistory VALUES (97, 'sentry', '0096_auto__add_field_tagvalue_data', '2019-03-20 08:47:45.685129+00');
INSERT INTO public.south_migrationhistory VALUES (98, 'sentry', '0097_auto__del_affecteduserbygroup__del_unique_affecteduserbygroup_project_', '2019-03-20 08:47:45.801438+00');
INSERT INTO public.south_migrationhistory VALUES (99, 'sentry', '0098_auto__add_user__chg_field_team_owner__chg_field_activity_user__chg_fie', '2019-03-20 08:47:45.886393+00');
INSERT INTO public.south_migrationhistory VALUES (100, 'sentry', '0099_auto__del_field_teammember_is_active', '2019-03-20 08:47:45.97921+00');
INSERT INTO public.south_migrationhistory VALUES (101, 'sentry', '0100_auto__add_field_tagkey_label', '2019-03-20 08:47:46.073158+00');
INSERT INTO public.south_migrationhistory VALUES (102, 'sentry', '0101_ensure_teams', '2019-03-20 08:47:46.155938+00');
INSERT INTO public.south_migrationhistory VALUES (103, 'sentry', '0102_ensure_slugs', '2019-03-20 08:47:46.250785+00');
INSERT INTO public.south_migrationhistory VALUES (104, 'sentry', '0103_ensure_non_empty_slugs', '2019-03-20 08:47:46.341516+00');
INSERT INTO public.south_migrationhistory VALUES (105, 'sentry', '0104_auto__add_groupseen__add_unique_groupseen_group_user', '2019-03-20 08:47:46.452916+00');
INSERT INTO public.south_migrationhistory VALUES (106, 'sentry', '0105_auto__chg_field_projectcountbyminute_time_spent_total__chg_field_group', '2019-03-20 08:47:46.732977+00');
INSERT INTO public.south_migrationhistory VALUES (107, 'sentry', '0106_auto__del_searchtoken__del_unique_searchtoken_document_field_token__de', '2019-03-20 08:47:46.815513+00');
INSERT INTO public.south_migrationhistory VALUES (108, 'sentry', '0107_expand_user', '2019-03-20 08:47:46.917507+00');
INSERT INTO public.south_migrationhistory VALUES (109, 'sentry', '0108_fix_user', '2019-03-20 08:47:46.99603+00');
INSERT INTO public.south_migrationhistory VALUES (110, 'sentry', '0109_index_filtervalue_times_seen', '2019-03-20 08:47:47.086727+00');
INSERT INTO public.south_migrationhistory VALUES (111, 'sentry', '0110_index_filtervalue_last_seen', '2019-03-20 08:47:47.164642+00');
INSERT INTO public.south_migrationhistory VALUES (112, 'sentry', '0111_index_filtervalue_first_seen', '2019-03-20 08:47:47.241874+00');
INSERT INTO public.south_migrationhistory VALUES (113, 'sentry', '0112_auto__chg_field_option_value__chg_field_useroption_value__chg_field_pr', '2019-03-20 08:47:47.322346+00');
INSERT INTO public.south_migrationhistory VALUES (114, 'sentry', '0113_auto__add_field_team_status', '2019-03-20 08:47:47.416811+00');
INSERT INTO public.south_migrationhistory VALUES (115, 'sentry', '0114_auto__add_field_projectkey_roles', '2019-03-20 08:47:47.524037+00');
INSERT INTO public.south_migrationhistory VALUES (116, 'sentry', '0115_auto__del_projectcountbyminute__del_unique_projectcountbyminute_projec', '2019-03-20 08:47:47.612267+00');
INSERT INTO public.south_migrationhistory VALUES (117, 'sentry', '0116_auto__del_field_event_server_name__del_field_event_culprit__del_field_', '2019-03-20 08:47:47.685165+00');
INSERT INTO public.south_migrationhistory VALUES (118, 'sentry', '0117_auto__add_rule', '2019-03-20 08:47:47.784226+00');
INSERT INTO public.south_migrationhistory VALUES (119, 'sentry', '0118_create_default_rules', '2019-03-20 08:47:47.852372+00');
INSERT INTO public.south_migrationhistory VALUES (120, 'sentry', '0119_auto__add_field_projectkey_label', '2019-03-20 08:47:47.966128+00');
INSERT INTO public.south_migrationhistory VALUES (121, 'sentry', '0120_auto__add_grouprulestatus', '2019-03-20 08:47:48.089848+00');
INSERT INTO public.south_migrationhistory VALUES (122, 'sentry', '0121_auto__add_unique_grouprulestatus_rule_group', '2019-03-20 08:47:48.179745+00');
INSERT INTO public.south_migrationhistory VALUES (123, 'sentry', '0122_add_event_group_id_datetime_index', '2019-03-20 08:47:48.268977+00');
INSERT INTO public.south_migrationhistory VALUES (124, 'sentry', '0123_auto__add_groupassignee__add_index_event_group_datetime', '2019-03-20 08:47:48.382069+00');
INSERT INTO public.south_migrationhistory VALUES (125, 'sentry', '0124_auto__add_grouphash__add_unique_grouphash_project_hash', '2019-03-20 08:47:48.499766+00');
INSERT INTO public.south_migrationhistory VALUES (126, 'sentry', '0125_auto__add_field_user_is_managed', '2019-03-20 08:47:48.604558+00');
INSERT INTO public.south_migrationhistory VALUES (127, 'sentry', '0126_auto__add_field_option_last_updated', '2019-03-20 08:47:48.705586+00');
INSERT INTO public.south_migrationhistory VALUES (128, 'sentry', '0127_auto__add_release__add_unique_release_project_version', '2019-03-20 08:47:48.809628+00');
INSERT INTO public.south_migrationhistory VALUES (129, 'sentry', '0128_auto__add_broadcast', '2019-03-20 08:47:48.906784+00');
INSERT INTO public.south_migrationhistory VALUES (130, 'sentry', '0129_auto__chg_field_release_id__chg_field_pendingteammember_id__chg_field_', '2019-03-20 08:47:48.996893+00');
INSERT INTO public.south_migrationhistory VALUES (131, 'sentry', '0130_auto__del_field_project_owner', '2019-03-20 08:47:49.367605+00');
INSERT INTO public.south_migrationhistory VALUES (132, 'sentry', '0131_auto__add_organizationmember__add_unique_organizationmember_organizati', '2019-03-20 08:47:49.494845+00');
INSERT INTO public.south_migrationhistory VALUES (133, 'sentry', '0132_add_default_orgs', '2019-03-20 08:47:49.595376+00');
INSERT INTO public.south_migrationhistory VALUES (134, 'sentry', '0133_add_org_members', '2019-03-20 08:47:49.687179+00');
INSERT INTO public.south_migrationhistory VALUES (135, 'sentry', '0134_auto__chg_field_team_organization', '2019-03-20 08:47:49.827097+00');
INSERT INTO public.south_migrationhistory VALUES (136, 'sentry', '0135_auto__chg_field_project_team', '2019-03-20 08:47:49.964461+00');
INSERT INTO public.south_migrationhistory VALUES (137, 'sentry', '0136_auto__add_field_organizationmember_email__chg_field_organizationmember', '2019-03-20 08:47:50.090198+00');
INSERT INTO public.south_migrationhistory VALUES (138, 'sentry', '0137_auto__add_field_organizationmember_has_global_access', '2019-03-20 08:47:50.215886+00');
INSERT INTO public.south_migrationhistory VALUES (139, 'sentry', '0138_migrate_team_members', '2019-03-20 08:47:50.316584+00');
INSERT INTO public.south_migrationhistory VALUES (140, 'sentry', '0139_auto__add_auditlogentry', '2019-03-20 08:47:50.443663+00');
INSERT INTO public.south_migrationhistory VALUES (141, 'sentry', '0140_auto__add_field_organization_slug', '2019-03-20 08:47:50.548232+00');
INSERT INTO public.south_migrationhistory VALUES (142, 'sentry', '0141_fill_org_slugs', '2019-03-20 08:47:50.708457+00');
INSERT INTO public.south_migrationhistory VALUES (143, 'sentry', '0142_auto__add_field_project_organization__add_unique_project_organization_', '2019-03-20 08:47:50.851764+00');
INSERT INTO public.south_migrationhistory VALUES (144, 'sentry', '0143_fill_project_orgs', '2019-03-20 08:47:50.965406+00');
INSERT INTO public.south_migrationhistory VALUES (145, 'sentry', '0144_auto__chg_field_project_organization', '2019-03-20 08:47:51.111465+00');
INSERT INTO public.south_migrationhistory VALUES (146, 'sentry', '0145_auto__chg_field_organization_slug', '2019-03-20 08:47:51.255775+00');
INSERT INTO public.south_migrationhistory VALUES (147, 'sentry', '0146_auto__add_field_auditlogentry_ip_address', '2019-03-20 08:47:51.392468+00');
INSERT INTO public.south_migrationhistory VALUES (148, 'sentry', '0147_auto__del_unique_team_slug__add_unique_team_organization_slug', '2019-03-20 08:47:51.518228+00');
INSERT INTO public.south_migrationhistory VALUES (149, 'sentry', '0148_auto__add_helppage', '2019-03-20 08:47:51.65776+00');
INSERT INTO public.south_migrationhistory VALUES (150, 'sentry', '0149_auto__chg_field_groupseen_project__chg_field_groupseen_user__chg_field', '2019-03-20 08:47:51.776693+00');
INSERT INTO public.south_migrationhistory VALUES (151, 'sentry', '0150_fix_broken_rules', '2019-03-20 08:47:51.901555+00');
INSERT INTO public.south_migrationhistory VALUES (152, 'sentry', '0151_auto__add_file', '2019-03-20 08:47:52.043688+00');
INSERT INTO public.south_migrationhistory VALUES (153, 'sentry', '0152_auto__add_field_file_checksum__chg_field_file_name__add_unique_file_na', '2019-03-20 08:47:52.206441+00');
INSERT INTO public.south_migrationhistory VALUES (154, 'sentry', '0153_auto__add_field_grouprulestatus_last_active', '2019-03-20 08:47:52.335481+00');
INSERT INTO public.south_migrationhistory VALUES (155, 'sentry', '0154_auto__add_field_tagkey_status', '2019-03-20 08:47:52.479787+00');
INSERT INTO public.south_migrationhistory VALUES (156, 'sentry', '0155_auto__add_field_projectkey_status', '2019-03-20 08:47:52.636141+00');
INSERT INTO public.south_migrationhistory VALUES (157, 'sentry', '0156_auto__add_apikey', '2019-03-20 08:47:52.767175+00');
INSERT INTO public.south_migrationhistory VALUES (158, 'sentry', '0157_auto__add_authidentity__add_unique_authidentity_auth_provider_ident__a', '2019-03-20 08:47:52.921716+00');
INSERT INTO public.south_migrationhistory VALUES (159, 'sentry', '0158_auto__add_unique_authidentity_auth_provider_user', '2019-03-20 08:47:53.054621+00');
INSERT INTO public.south_migrationhistory VALUES (160, 'sentry', '0159_auto__add_field_authidentity_last_verified__add_field_organizationmemb', '2019-03-20 08:47:53.201107+00');
INSERT INTO public.south_migrationhistory VALUES (161, 'sentry', '0160_auto__add_field_authprovider_default_global_access', '2019-03-20 08:47:53.429243+00');
INSERT INTO public.south_migrationhistory VALUES (162, 'sentry', '0161_auto__chg_field_authprovider_config', '2019-03-20 08:47:53.597057+00');
INSERT INTO public.south_migrationhistory VALUES (163, 'sentry', '0162_auto__chg_field_authidentity_data', '2019-03-20 08:47:53.757484+00');
INSERT INTO public.south_migrationhistory VALUES (164, 'sentry', '0163_auto__add_field_authidentity_last_synced', '2019-03-20 08:47:53.902442+00');
INSERT INTO public.south_migrationhistory VALUES (165, 'sentry', '0164_auto__add_releasefile__add_unique_releasefile_release_ident__add_field', '2019-03-20 08:47:54.153218+00');
INSERT INTO public.south_migrationhistory VALUES (166, 'sentry', '0165_auto__del_unique_file_name_checksum', '2019-03-20 08:47:54.36729+00');
INSERT INTO public.south_migrationhistory VALUES (167, 'sentry', '0166_auto__chg_field_user_id__add_field_apikey_allowed_origins', '2019-03-20 08:47:54.517424+00');
INSERT INTO public.south_migrationhistory VALUES (168, 'sentry', '0167_auto__add_field_authprovider_flags', '2019-03-20 08:47:54.663146+00');
INSERT INTO public.south_migrationhistory VALUES (169, 'sentry', '0168_unfill_projectkey_user', '2019-03-20 08:47:54.802397+00');
INSERT INTO public.south_migrationhistory VALUES (170, 'sentry', '0169_auto__del_field_projectkey_user', '2019-03-20 08:47:55.589629+00');
INSERT INTO public.south_migrationhistory VALUES (171, 'sentry', '0170_auto__add_organizationmemberteam__add_unique_organizationmemberteam_te', '2019-03-20 08:47:55.789284+00');
INSERT INTO public.south_migrationhistory VALUES (172, 'sentry', '0171_auto__chg_field_team_owner', '2019-03-20 08:47:55.969154+00');
INSERT INTO public.south_migrationhistory VALUES (173, 'sentry', '0172_auto__del_field_team_owner', '2019-03-20 08:47:56.116019+00');
INSERT INTO public.south_migrationhistory VALUES (174, 'sentry', '0173_auto__del_teammember__del_unique_teammember_team_user', '2019-03-20 08:47:56.317569+00');
INSERT INTO public.south_migrationhistory VALUES (175, 'sentry', '0174_auto__del_field_projectkey_user_added', '2019-03-20 08:47:56.488266+00');
INSERT INTO public.south_migrationhistory VALUES (176, 'sentry', '0175_auto__del_pendingteammember__del_unique_pendingteammember_team_email', '2019-03-20 08:47:56.677976+00');
INSERT INTO public.south_migrationhistory VALUES (177, 'sentry', '0176_auto__add_field_organizationmember_counter__add_unique_organizationmem', '2019-03-20 08:47:56.845897+00');
INSERT INTO public.south_migrationhistory VALUES (178, 'sentry', '0177_fill_member_counters', '2019-03-20 08:47:57.005929+00');
INSERT INTO public.south_migrationhistory VALUES (179, 'sentry', '0178_auto__del_unique_organizationmember_organization_counter', '2019-03-20 08:47:57.20261+00');
INSERT INTO public.south_migrationhistory VALUES (180, 'sentry', '0179_auto__add_field_release_date_released', '2019-03-20 08:47:57.421778+00');
INSERT INTO public.south_migrationhistory VALUES (181, 'sentry', '0180_auto__add_field_release_environment__add_field_release_ref__add_field_', '2019-03-20 08:47:57.672821+00');
INSERT INTO public.south_migrationhistory VALUES (182, 'sentry', '0181_auto__del_field_release_environment__del_unique_release_project_versio', '2019-03-20 08:47:57.855023+00');
INSERT INTO public.south_migrationhistory VALUES (183, 'sentry', '0182_auto__add_field_auditlogentry_actor_label__add_field_auditlogentry_act', '2019-03-20 08:47:58.04617+00');
INSERT INTO public.south_migrationhistory VALUES (184, 'sentry', '0183_auto__del_index_grouphash_hash', '2019-03-20 08:47:58.207951+00');
INSERT INTO public.south_migrationhistory VALUES (185, 'sentry', '0184_auto__del_field_group_checksum__del_unique_group_project_checksum__del', '2019-03-20 08:47:58.381661+00');
INSERT INTO public.south_migrationhistory VALUES (186, 'sentry', '0185_auto__add_savedsearch__add_unique_savedsearch_project_name', '2019-03-20 08:47:58.551282+00');
INSERT INTO public.south_migrationhistory VALUES (187, 'sentry', '0186_auto__add_field_group_first_release', '2019-03-20 08:47:58.712475+00');
INSERT INTO public.south_migrationhistory VALUES (188, 'sentry', '0187_auto__add_index_group_project_first_release', '2019-03-20 08:47:58.861339+00');
INSERT INTO public.south_migrationhistory VALUES (189, 'sentry', '0188_auto__add_userreport', '2019-03-20 08:47:59.0274+00');
INSERT INTO public.south_migrationhistory VALUES (190, 'sentry', '0189_auto__add_index_userreport_project_event_id', '2019-03-20 08:47:59.181048+00');
INSERT INTO public.south_migrationhistory VALUES (191, 'sentry', '0190_auto__add_field_release_new_groups', '2019-03-20 08:47:59.347742+00');
INSERT INTO public.south_migrationhistory VALUES (192, 'sentry', '0191_auto__del_alert__del_alertrelatedgroup__del_unique_alertrelatedgroup_g', '2019-03-20 08:47:59.499955+00');
INSERT INTO public.south_migrationhistory VALUES (193, 'sentry', '0192_add_model_groupemailthread', '2019-03-20 08:47:59.667905+00');
INSERT INTO public.south_migrationhistory VALUES (194, 'sentry', '0193_auto__del_unique_groupemailthread_msgid__add_unique_groupemailthread_e', '2019-03-20 08:47:59.860146+00');
INSERT INTO public.south_migrationhistory VALUES (195, 'sentry', '0194_auto__del_field_project_platform', '2019-03-20 08:48:00.009459+00');
INSERT INTO public.south_migrationhistory VALUES (196, 'sentry', '0195_auto__chg_field_organization_owner', '2019-03-20 08:48:00.1908+00');
INSERT INTO public.south_migrationhistory VALUES (197, 'sentry', '0196_auto__del_field_organization_owner', '2019-03-20 08:48:00.351482+00');
INSERT INTO public.south_migrationhistory VALUES (198, 'sentry', '0197_auto__del_accessgroup__del_unique_accessgroup_team_name', '2019-03-20 08:48:00.526807+00');
INSERT INTO public.south_migrationhistory VALUES (199, 'sentry', '0198_auto__add_field_release_primary_owner', '2019-03-20 08:48:00.680837+00');
INSERT INTO public.south_migrationhistory VALUES (200, 'sentry', '0199_auto__add_field_project_first_event', '2019-03-20 08:48:00.831186+00');
INSERT INTO public.south_migrationhistory VALUES (201, 'sentry', '0200_backfill_first_event', '2019-03-20 08:48:00.981456+00');
INSERT INTO public.south_migrationhistory VALUES (202, 'sentry', '0201_auto__add_eventuser__add_unique_eventuser_project_ident__add_index_eve', '2019-03-20 08:48:01.156522+00');
INSERT INTO public.south_migrationhistory VALUES (203, 'sentry', '0202_auto__add_field_eventuser_hash__add_unique_eventuser_project_hash', '2019-03-20 08:48:01.32076+00');
INSERT INTO public.south_migrationhistory VALUES (204, 'sentry', '0203_auto__chg_field_eventuser_username__chg_field_eventuser_ident', '2019-03-20 08:48:01.523383+00');
INSERT INTO public.south_migrationhistory VALUES (205, 'sentry', '0204_backfill_team_membership', '2019-03-20 08:48:01.665694+00');
INSERT INTO public.south_migrationhistory VALUES (206, 'sentry', '0205_auto__add_field_organizationmember_role', '2019-03-20 08:48:01.830731+00');
INSERT INTO public.south_migrationhistory VALUES (207, 'sentry', '0206_backfill_member_role', '2019-03-20 08:48:01.974989+00');
INSERT INTO public.south_migrationhistory VALUES (208, 'sentry', '0207_auto__add_field_organization_default_role', '2019-03-20 08:48:02.140307+00');
INSERT INTO public.south_migrationhistory VALUES (209, 'sentry', '0208_backfill_default_role', '2019-03-20 08:48:02.308694+00');
INSERT INTO public.south_migrationhistory VALUES (210, 'sentry', '0209_auto__add_broadcastseen__add_unique_broadcastseen_broadcast_user', '2019-03-20 08:48:02.489957+00');
INSERT INTO public.south_migrationhistory VALUES (211, 'sentry', '0210_auto__del_field_broadcast_badge', '2019-03-20 08:48:02.652858+00');
INSERT INTO public.south_migrationhistory VALUES (212, 'sentry', '0211_auto__add_field_broadcast_title', '2019-03-20 08:48:02.819556+00');
INSERT INTO public.south_migrationhistory VALUES (213, 'sentry', '0212_auto__add_fileblob__add_field_file_blob', '2019-03-20 08:48:03.462568+00');
INSERT INTO public.south_migrationhistory VALUES (214, 'sentry', '0212_auto__add_organizationoption__add_unique_organizationoption_organizati', '2019-03-20 08:48:03.634986+00');
INSERT INTO public.south_migrationhistory VALUES (215, 'sentry', '0213_migrate_file_blobs', '2019-03-20 08:48:03.795652+00');
INSERT INTO public.south_migrationhistory VALUES (216, 'sentry', '0214_auto__add_field_broadcast_upstream_id', '2019-03-20 08:48:03.960303+00');
INSERT INTO public.south_migrationhistory VALUES (217, 'sentry', '0215_auto__add_field_broadcast_date_expires', '2019-03-20 08:48:04.11921+00');
INSERT INTO public.south_migrationhistory VALUES (218, 'sentry', '0216_auto__add_groupsnooze', '2019-03-20 08:48:04.299842+00');
INSERT INTO public.south_migrationhistory VALUES (219, 'sentry', '0217_auto__add_groupresolution', '2019-03-20 08:48:04.495941+00');
INSERT INTO public.south_migrationhistory VALUES (220, 'sentry', '0218_auto__add_field_groupresolution_status', '2019-03-20 08:48:04.693586+00');
INSERT INTO public.south_migrationhistory VALUES (221, 'sentry', '0219_auto__add_field_groupbookmark_date_added', '2019-03-20 08:48:04.89921+00');
INSERT INTO public.south_migrationhistory VALUES (222, 'sentry', '0220_auto__del_field_fileblob_storage_options__del_field_fileblob_storage__', '2019-03-20 08:48:05.088632+00');
INSERT INTO public.south_migrationhistory VALUES (223, 'sentry', '0221_auto__chg_field_user_first_name', '2019-03-20 08:48:05.29255+00');
INSERT INTO public.south_migrationhistory VALUES (224, 'sentry', '0222_auto__del_field_user_last_name__del_field_user_first_name__add_field_u', '2019-03-20 08:48:05.483479+00');
INSERT INTO public.south_migrationhistory VALUES (225, 'sentry', '0223_delete_old_sentry_docs_options', '2019-03-20 08:48:05.677118+00');
INSERT INTO public.south_migrationhistory VALUES (226, 'sentry', '0224_auto__add_index_userreport_project_date_added', '2019-03-20 08:48:05.84541+00');
INSERT INTO public.south_migrationhistory VALUES (227, 'sentry', '0225_auto__add_fileblobindex__add_unique_fileblobindex_file_blob_offset', '2019-03-20 08:48:06.029276+00');
INSERT INTO public.south_migrationhistory VALUES (228, 'sentry', '0226_backfill_file_size', '2019-03-20 08:48:06.215222+00');
INSERT INTO public.south_migrationhistory VALUES (229, 'sentry', '0227_auto__del_field_activity_event', '2019-03-20 08:48:06.406723+00');
INSERT INTO public.south_migrationhistory VALUES (230, 'sentry', '0228_auto__del_field_event_num_comments', '2019-03-20 08:48:06.589705+00');
INSERT INTO public.south_migrationhistory VALUES (231, 'sentry', '0229_drop_event_constraints', '2019-03-20 08:48:06.814177+00');
INSERT INTO public.south_migrationhistory VALUES (232, 'sentry', '0230_auto__del_field_eventmapping_group__del_field_eventmapping_project__ad', '2019-03-20 08:48:07.01756+00');
INSERT INTO public.south_migrationhistory VALUES (233, 'sentry', '0231_auto__add_field_savedsearch_is_default', '2019-03-20 08:48:07.213142+00');
INSERT INTO public.south_migrationhistory VALUES (234, 'sentry', '0232_default_savedsearch', '2019-03-20 08:48:07.396911+00');
INSERT INTO public.south_migrationhistory VALUES (235, 'sentry', '0233_add_new_savedsearch', '2019-03-20 08:48:07.574158+00');
INSERT INTO public.south_migrationhistory VALUES (236, 'sentry', '0234_auto__add_savedsearchuserdefault__add_unique_savedsearchuserdefault_pr', '2019-03-20 08:48:07.788264+00');
INSERT INTO public.south_migrationhistory VALUES (237, 'sentry', '0235_auto__add_projectbookmark__add_unique_projectbookmark_project_id_user_', '2019-03-20 08:48:07.987645+00');
INSERT INTO public.south_migrationhistory VALUES (238, 'sentry', '0236_auto__add_organizationonboardingtask__add_unique_organizationonboardin', '2019-03-20 08:48:08.196804+00');
INSERT INTO public.south_migrationhistory VALUES (239, 'sentry', '0237_auto__add_eventtag__add_unique_eventtag_event_id_key_id_value_id', '2019-03-20 08:48:08.407031+00');
INSERT INTO public.south_migrationhistory VALUES (240, 'sentry', '0238_fill_org_onboarding_tasks', '2019-03-20 08:48:08.603112+00');
INSERT INTO public.south_migrationhistory VALUES (241, 'sentry', '0239_auto__add_projectdsymfile__add_unique_projectdsymfile_project_uuid__ad', '2019-03-20 08:48:08.836596+00');
INSERT INTO public.south_migrationhistory VALUES (242, 'sentry', '0240_fill_onboarding_option', '2019-03-20 08:48:09.046625+00');
INSERT INTO public.south_migrationhistory VALUES (243, 'sentry', '0241_auto__add_counter__add_unique_counter_project_ident__add_field_group_s', '2019-03-20 08:48:09.278929+00');
INSERT INTO public.south_migrationhistory VALUES (244, 'sentry', '0242_auto__add_field_project_forced_color', '2019-03-20 08:48:09.502702+00');
INSERT INTO public.south_migrationhistory VALUES (245, 'sentry', '0243_remove_inactive_members', '2019-03-20 08:48:09.731286+00');
INSERT INTO public.south_migrationhistory VALUES (246, 'sentry', '0244_auto__add_groupredirect', '2019-03-20 08:48:10.018891+00');
INSERT INTO public.south_migrationhistory VALUES (247, 'sentry', '0245_auto__del_field_project_callsign__del_unique_project_organization_call', '2019-03-20 08:48:10.2255+00');
INSERT INTO public.south_migrationhistory VALUES (248, 'sentry', '0246_auto__add_dsymsymbol__add_unique_dsymsymbol_object_address__add_dsymsd', '2019-03-20 08:48:10.52403+00');
INSERT INTO public.south_migrationhistory VALUES (249, 'sentry', '0247_migrate_file_blobs', '2019-03-20 08:48:10.75996+00');
INSERT INTO public.south_migrationhistory VALUES (250, 'sentry', '0248_auto__add_projectplatform__add_unique_projectplatform_project_id_platf', '2019-03-20 08:48:11.023794+00');
INSERT INTO public.south_migrationhistory VALUES (251, 'sentry', '0249_auto__add_index_eventtag_project_id_key_id_value_id', '2019-03-20 08:48:11.266172+00');
INSERT INTO public.south_migrationhistory VALUES (252, 'sentry', '0250_auto__add_unique_userreport_project_event_id', '2019-03-20 08:48:11.557151+00');
INSERT INTO public.south_migrationhistory VALUES (253, 'sentry', '0251_auto__add_useravatar', '2019-03-20 08:48:11.848929+00');
INSERT INTO public.south_migrationhistory VALUES (254, 'sentry', '0252_default_users_to_gravatar', '2019-03-20 08:48:12.092159+00');
INSERT INTO public.south_migrationhistory VALUES (255, 'sentry', '0253_auto__add_field_eventtag_group_id', '2019-03-20 08:48:12.347124+00');
INSERT INTO public.south_migrationhistory VALUES (256, 'sentry', '0254_auto__add_index_eventtag_group_id_key_id_value_id', '2019-03-20 08:48:12.622685+00');
INSERT INTO public.south_migrationhistory VALUES (257, 'sentry', '0255_auto__add_apitoken', '2019-03-20 08:48:12.956284+00');
INSERT INTO public.south_migrationhistory VALUES (258, 'sentry', '0256_auto__add_authenticator', '2019-03-20 08:48:13.23248+00');
INSERT INTO public.south_migrationhistory VALUES (259, 'sentry', '0257_repair_activity', '2019-03-20 08:48:14.128931+00');
INSERT INTO public.south_migrationhistory VALUES (260, 'sentry', '0258_auto__add_field_user_is_password_expired__add_field_user_last_password', '2019-03-20 08:48:14.43543+00');
INSERT INTO public.south_migrationhistory VALUES (261, 'sentry', '0259_auto__add_useremail__add_unique_useremail_user_email', '2019-03-20 08:48:14.737985+00');
INSERT INTO public.south_migrationhistory VALUES (262, 'sentry', '0260_populate_email_addresses', '2019-03-20 08:48:15.029733+00');
INSERT INTO public.south_migrationhistory VALUES (263, 'sentry', '0261_auto__add_groupsubscription__add_unique_groupsubscription_group_user', '2019-03-20 08:48:15.343933+00');
INSERT INTO public.south_migrationhistory VALUES (264, 'sentry', '0262_fix_tag_indexes', '2019-03-20 08:48:15.643089+00');
INSERT INTO public.south_migrationhistory VALUES (265, 'sentry', '0263_remove_default_regression_rule', '2019-03-20 08:48:15.901597+00');
INSERT INTO public.south_migrationhistory VALUES (266, 'sentry', '0264_drop_grouptagvalue_project_index', '2019-03-20 08:48:16.223659+00');
INSERT INTO public.south_migrationhistory VALUES (267, 'sentry', '0265_auto__add_field_rule_status', '2019-03-20 08:48:16.675534+00');
INSERT INTO public.south_migrationhistory VALUES (268, 'sentry', '0266_auto__add_grouprelease__add_unique_grouprelease_group_id_release_id_en', '2019-03-20 08:48:17.143698+00');
INSERT INTO public.south_migrationhistory VALUES (269, 'sentry', '0267_auto__add_environment__add_unique_environment_project_id_name__add_rel', '2019-03-20 08:48:17.508831+00');
INSERT INTO public.south_migrationhistory VALUES (270, 'sentry', '0268_fill_environment', '2019-03-20 08:48:17.83294+00');
INSERT INTO public.south_migrationhistory VALUES (271, 'sentry', '0269_auto__del_helppage', '2019-03-20 08:48:18.127874+00');
INSERT INTO public.south_migrationhistory VALUES (272, 'sentry', '0270_auto__add_field_organizationmember_token', '2019-03-20 08:48:18.463751+00');
INSERT INTO public.south_migrationhistory VALUES (273, 'sentry', '0271_auto__del_field_organizationmember_counter', '2019-03-20 08:48:18.761297+00');
INSERT INTO public.south_migrationhistory VALUES (274, 'sentry', '0272_auto__add_unique_authenticator_user_type', '2019-03-20 08:48:19.06451+00');
INSERT INTO public.south_migrationhistory VALUES (275, 'sentry', '0273_auto__add_repository__add_unique_repository_organization_id_name__add_', '2019-03-20 08:48:19.44458+00');
INSERT INTO public.south_migrationhistory VALUES (276, 'sentry', '0274_auto__add_index_commit_repository_id_date_added', '2019-03-20 08:48:19.782045+00');
INSERT INTO public.south_migrationhistory VALUES (277, 'sentry', '0275_auto__del_index_grouptagvalue_project_key_value__add_index_grouptagval', '2019-03-20 08:48:20.17242+00');
INSERT INTO public.south_migrationhistory VALUES (278, 'sentry', '0276_auto__add_field_user_session_nonce', '2019-03-20 08:48:20.532209+00');
INSERT INTO public.south_migrationhistory VALUES (279, 'sentry', '0277_auto__add_commitfilechange__add_unique_commitfilechange_commit_filenam', '2019-03-20 08:48:20.957973+00');
INSERT INTO public.south_migrationhistory VALUES (280, 'sentry', '0278_auto__add_releaseproject__add_unique_releaseproject_project_release__a', '2019-03-20 08:48:21.335703+00');
INSERT INTO public.south_migrationhistory VALUES (281, 'sentry', '0279_populate_release_orgs_and_projects', '2019-03-20 08:48:21.717998+00');
INSERT INTO public.south_migrationhistory VALUES (282, 'sentry', '0280_auto__add_field_releasecommit_organization_id', '2019-03-20 08:48:22.051185+00');
INSERT INTO public.south_migrationhistory VALUES (283, 'sentry', '0281_populate_release_commit_organization_id', '2019-03-20 08:48:22.369648+00');
INSERT INTO public.south_migrationhistory VALUES (284, 'sentry', '0282_auto__add_field_releasefile_organization__add_field_releaseenvironment', '2019-03-20 08:48:22.708749+00');
INSERT INTO public.south_migrationhistory VALUES (285, 'sentry', '0283_populate_release_environment_and_release_file_organization', '2019-03-20 08:48:23.052911+00');
INSERT INTO public.south_migrationhistory VALUES (286, 'sentry', '0284_auto__del_field_release_project__add_field_release_project_id__chg_fie', '2019-03-20 08:48:23.588634+00');
INSERT INTO public.south_migrationhistory VALUES (287, 'sentry', '0285_auto__chg_field_release_project_id__chg_field_releasefile_project_id', '2019-03-20 08:48:23.957076+00');
INSERT INTO public.south_migrationhistory VALUES (288, 'sentry', '0286_drop_project_fk_release_release_file', '2019-03-20 08:48:24.307341+00');
INSERT INTO public.south_migrationhistory VALUES (289, 'sentry', '0287_auto__add_field_releaseproject_new_groups', '2019-03-20 08:48:24.658219+00');
INSERT INTO public.south_migrationhistory VALUES (290, 'sentry', '0288_set_release_project_new_groups_to_zero', '2019-03-20 08:48:25.038925+00');
INSERT INTO public.south_migrationhistory VALUES (291, 'sentry', '0289_auto__add_organizationavatar', '2019-03-20 08:48:25.431718+00');
INSERT INTO public.south_migrationhistory VALUES (292, 'sentry', '0290_populate_release_project_new_groups', '2019-03-20 08:48:25.867909+00');
INSERT INTO public.south_migrationhistory VALUES (293, 'sentry', '0291_merge_legacy_releases', '2019-03-20 08:48:26.215948+00');
INSERT INTO public.south_migrationhistory VALUES (294, 'sentry', '0292_auto__add_unique_release_organization_version', '2019-03-20 08:48:26.536274+00');
INSERT INTO public.south_migrationhistory VALUES (295, 'sentry', '0293_auto__del_unique_release_project_id_version', '2019-03-20 08:48:26.968785+00');
INSERT INTO public.south_migrationhistory VALUES (296, 'sentry', '0294_auto__add_groupcommitresolution__add_unique_groupcommitresolution_grou', '2019-03-20 08:48:27.341957+00');
INSERT INTO public.south_migrationhistory VALUES (297, 'sentry', '0295_auto__add_environmentproject__add_unique_environmentproject_project_en', '2019-03-20 08:48:27.717275+00');
INSERT INTO public.south_migrationhistory VALUES (298, 'sentry', '0296_populate_environment_organization_and_projects', '2019-03-20 08:48:28.097939+00');
INSERT INTO public.south_migrationhistory VALUES (299, 'sentry', '0297_auto__add_field_project_flags', '2019-03-20 08:48:28.488031+00');
INSERT INTO public.south_migrationhistory VALUES (300, 'sentry', '0298_backfill_project_has_releases', '2019-03-20 08:48:28.839003+00');
INSERT INTO public.south_migrationhistory VALUES (301, 'sentry', '0299_auto__chg_field_environment_organization_id', '2019-03-20 08:48:29.239151+00');
INSERT INTO public.south_migrationhistory VALUES (302, 'sentry', '0300_auto__add_processingissue__add_unique_processingissue_project_checksum', '2019-03-20 08:48:30.455459+00');
INSERT INTO public.south_migrationhistory VALUES (303, 'sentry', '0301_auto__chg_field_environment_project_id__chg_field_releaseenvironment_p', '2019-03-20 08:48:30.862419+00');
INSERT INTO public.south_migrationhistory VALUES (304, 'sentry', '0302_merge_environments', '2019-03-20 08:48:31.273297+00');
INSERT INTO public.south_migrationhistory VALUES (305, 'sentry', '0303_fix_release_new_group_counts', '2019-03-20 08:48:31.660319+00');
INSERT INTO public.south_migrationhistory VALUES (306, 'sentry', '0304_auto__add_deploy', '2019-03-20 08:48:32.099073+00');
INSERT INTO public.south_migrationhistory VALUES (307, 'sentry', '0305_auto__chg_field_authidentity_data__chg_field_useroption_value__chg_fie', '2019-03-20 08:48:32.506358+00');
INSERT INTO public.south_migrationhistory VALUES (308, 'sentry', '0306_auto__add_apigrant__add_apiauthorization__add_unique_apiauthorization_', '2019-03-20 08:48:33.005486+00');
INSERT INTO public.south_migrationhistory VALUES (309, 'sentry', '0307_auto__add_field_apigrant_scope_list__add_field_apitoken_scope_list__ad', '2019-03-20 08:48:33.472628+00');
INSERT INTO public.south_migrationhistory VALUES (310, 'sentry', '0308_auto__add_versiondsymfile__add_unique_versiondsymfile_dsym_file_versio', '2019-03-20 08:48:33.989934+00');
INSERT INTO public.south_migrationhistory VALUES (311, 'sentry', '0308_backfill_scopes_list', '2019-03-20 08:48:34.453574+00');
INSERT INTO public.south_migrationhistory VALUES (312, 'sentry', '0309_fix_application_state', '2019-03-20 08:48:34.93516+00');
INSERT INTO public.south_migrationhistory VALUES (313, 'sentry', '0310_auto__add_field_savedsearch_owner', '2019-03-20 08:48:35.390807+00');
INSERT INTO public.south_migrationhistory VALUES (314, 'sentry', '0311_auto__add_releaseheadcommit__add_unique_releaseheadcommit_repository_i', '2019-03-20 08:48:35.871485+00');
INSERT INTO public.south_migrationhistory VALUES (315, 'sentry', '0312_create_missing_emails', '2019-03-20 08:48:36.411352+00');
INSERT INTO public.south_migrationhistory VALUES (316, 'sentry', '0313_auto__add_field_commitauthor_external_id__add_unique_commitauthor_orga', '2019-03-20 08:48:36.909058+00');
INSERT INTO public.south_migrationhistory VALUES (317, 'sentry', '0314_auto__add_distribution__add_unique_distribution_release_name__add_fiel', '2019-03-20 08:48:37.469924+00');
INSERT INTO public.south_migrationhistory VALUES (318, 'sentry', '0315_auto__add_field_useroption_organization__add_unique_useroption_user_or', '2019-03-20 08:48:37.953189+00');
INSERT INTO public.south_migrationhistory VALUES (319, 'sentry', '0316_auto__del_field_grouptagvalue_project__del_field_grouptagvalue_group__', '2019-03-20 08:48:38.433697+00');
INSERT INTO public.south_migrationhistory VALUES (320, 'sentry', '0317_drop_grouptagvalue_constraints', '2019-03-20 08:48:38.956553+00');
INSERT INTO public.south_migrationhistory VALUES (321, 'sentry', '0318_auto__add_field_deploy_notified', '2019-03-20 08:48:39.46274+00');
INSERT INTO public.south_migrationhistory VALUES (322, 'sentry', '0319_auto__add_index_deploy_notified', '2019-03-20 08:48:40.013432+00');
INSERT INTO public.south_migrationhistory VALUES (323, 'sentry', '0320_auto__add_index_eventtag_date_added', '2019-03-20 08:48:40.518569+00');
INSERT INTO public.south_migrationhistory VALUES (324, 'sentry', '0321_auto__add_field_projectkey_rate_limit_count__add_field_projectkey_rate', '2019-03-20 08:48:41.028779+00');
INSERT INTO public.south_migrationhistory VALUES (325, 'sentry', '0321_auto__add_unique_environment_organization_id_name', '2019-03-20 08:48:41.530514+00');
INSERT INTO public.south_migrationhistory VALUES (326, 'sentry', '0322_merge_0321_migrations', '2019-03-20 08:48:42.003688+00');
INSERT INTO public.south_migrationhistory VALUES (327, 'sentry', '0323_auto__add_unique_releaseenvironment_organization_id_release_id_environ', '2019-03-20 08:48:42.543459+00');
INSERT INTO public.south_migrationhistory VALUES (328, 'sentry', '0324_auto__add_field_eventuser_name__add_field_userreport_event_user_id', '2019-03-20 08:48:43.048817+00');
INSERT INTO public.south_migrationhistory VALUES (329, 'sentry', '0325_auto__add_scheduleddeletion__add_unique_scheduleddeletion_app_label_mo', '2019-03-20 08:48:43.566641+00');
INSERT INTO public.south_migrationhistory VALUES (330, 'sentry', '0326_auto__add_field_groupsnooze_count__add_field_groupsnooze_window__add_f', '2019-03-20 08:48:44.118815+00');
INSERT INTO public.south_migrationhistory VALUES (331, 'sentry', '0327_auto__add_field_release_commit_count__add_field_release_last_commit_id', '2019-03-20 08:48:44.664077+00');
INSERT INTO public.south_migrationhistory VALUES (332, 'sentry', '0328_backfill_release_stats', '2019-03-20 08:48:45.181322+00');
INSERT INTO public.south_migrationhistory VALUES (333, 'sentry', '0329_auto__del_dsymsymbol__del_unique_dsymsymbol_object_address__del_global', '2019-03-20 08:48:45.675616+00');
INSERT INTO public.south_migrationhistory VALUES (334, 'sentry', '0330_auto__add_field_grouphash_state', '2019-03-20 08:48:46.147083+00');
INSERT INTO public.south_migrationhistory VALUES (335, 'sentry', '0331_auto__del_index_releasecommit_project_id__del_index_releaseenvironment', '2019-03-20 08:48:46.650939+00');
INSERT INTO public.south_migrationhistory VALUES (336, 'sentry', '0332_auto__add_featureadoption__add_unique_featureadoption_organization_fea', '2019-03-20 08:48:47.171348+00');
INSERT INTO public.south_migrationhistory VALUES (337, 'sentry', '0333_auto__add_field_groupresolution_type__add_field_groupresolution_actor_', '2019-03-20 08:48:47.673575+00');
INSERT INTO public.south_migrationhistory VALUES (338, 'sentry', '0334_auto__add_field_project_platform', '2019-03-20 08:48:48.220813+00');
INSERT INTO public.south_migrationhistory VALUES (339, 'sentry', '0334_auto__add_scheduledjob', '2019-03-20 08:48:48.748486+00');
INSERT INTO public.south_migrationhistory VALUES (340, 'sentry', '0335_auto__add_field_groupsnooze_actor_id', '2019-03-20 08:48:49.242323+00');
INSERT INTO public.south_migrationhistory VALUES (341, 'sentry', '0336_auto__add_field_user_last_active', '2019-03-20 08:48:49.720626+00');
INSERT INTO public.south_migrationhistory VALUES (342, 'sentry', '0337_fix_out_of_order_migrations', '2019-03-20 08:48:50.398756+00');
INSERT INTO public.south_migrationhistory VALUES (343, 'sentry', '0338_fix_null_user_last_active', '2019-03-20 08:48:50.928727+00');
INSERT INTO public.south_migrationhistory VALUES (344, 'sentry', '0339_backfill_first_project_feature', '2019-03-20 08:48:51.443826+00');
INSERT INTO public.south_migrationhistory VALUES (345, 'sentry', '0340_auto__add_grouptombstone__add_field_grouphash_group_tombstone_id', '2019-03-20 08:48:52.927656+00');
INSERT INTO public.south_migrationhistory VALUES (346, 'sentry', '0341_auto__add_organizationintegration__add_unique_organizationintegration_', '2019-03-20 08:48:53.556869+00');
INSERT INTO public.south_migrationhistory VALUES (347, 'sentry', '0342_projectplatform', '2019-03-20 08:48:54.093147+00');
INSERT INTO public.south_migrationhistory VALUES (348, 'sentry', '0343_auto__add_index_groupcommitresolution_commit_id', '2019-03-20 08:48:54.659738+00');
INSERT INTO public.south_migrationhistory VALUES (349, 'sentry', '0344_add_index_ProjectPlatform_last_seen', '2019-03-20 08:48:55.221127+00');
INSERT INTO public.south_migrationhistory VALUES (350, 'sentry', '0345_add_citext', '2019-03-20 08:48:55.752314+00');
INSERT INTO public.south_migrationhistory VALUES (351, 'sentry', '0346_auto__del_field_tagkey_project__add_field_tagkey_project_id__del_uniqu', '2019-03-20 08:48:56.337044+00');
INSERT INTO public.south_migrationhistory VALUES (352, 'sentry', '0347_auto__add_index_grouptagvalue_project_id__add_index_grouptagvalue_grou', '2019-03-20 08:48:57.092685+00');
INSERT INTO public.south_migrationhistory VALUES (353, 'sentry', '0348_fix_project_key_rate_limit_window_unit', '2019-03-20 08:48:57.733538+00');
INSERT INTO public.south_migrationhistory VALUES (354, 'sentry', '0349_drop_constraints_filterkey_filtervalue_grouptagkey', '2019-03-20 08:48:58.370747+00');
INSERT INTO public.south_migrationhistory VALUES (355, 'sentry', '0350_auto__add_email', '2019-03-20 08:48:58.95633+00');
INSERT INTO public.south_migrationhistory VALUES (356, 'sentry', '0351_backfillemail', '2019-03-20 08:48:59.548563+00');
INSERT INTO public.south_migrationhistory VALUES (357, 'sentry', '0352_add_index_release_coalesce_date_released_date_added', '2019-03-20 08:49:00.141476+00');
INSERT INTO public.south_migrationhistory VALUES (358, 'sentry', '0353_auto__del_field_eventuser_project__add_field_eventuser_project_id__del', '2019-03-20 08:49:00.782027+00');
INSERT INTO public.south_migrationhistory VALUES (359, 'sentry', '0354_auto__chg_field_commitfilechange_filename', '2019-03-20 08:49:01.354137+00');
INSERT INTO public.south_migrationhistory VALUES (360, 'sentry', '0355_auto__add_field_organizationintegration_config__add_field_organization', '2019-03-20 08:49:01.984145+00');
INSERT INTO public.south_migrationhistory VALUES (361, 'sentry', '0356_auto__add_useridentity__add_unique_useridentity_user_identity__add_ide', '2019-03-20 08:49:02.6293+00');
INSERT INTO public.south_migrationhistory VALUES (362, 'sentry', '0357_auto__add_projectteam__add_unique_projectteam_project_team', '2019-03-20 08:49:03.302608+00');
INSERT INTO public.south_migrationhistory VALUES (363, 'sentry', '0358_auto__add_projectsymcachefile__add_unique_projectsymcachefile_project_', '2019-03-20 08:49:03.955073+00');
INSERT INTO public.south_migrationhistory VALUES (364, 'sentry', '0359_auto__add_index_tagvalue_project_id_key_last_seen', '2019-03-20 08:49:04.61765+00');
INSERT INTO public.south_migrationhistory VALUES (365, 'sentry', '0360_auto__add_groupshare', '2019-03-20 08:49:05.334231+00');
INSERT INTO public.south_migrationhistory VALUES (366, 'sentry', '0361_auto__add_minidumpfile', '2019-03-20 08:49:05.973696+00');
INSERT INTO public.south_migrationhistory VALUES (367, 'sentry', '0362_auto__add_userip__add_unique_userip_user_ip_address', '2019-03-20 08:49:06.623305+00');
INSERT INTO public.south_migrationhistory VALUES (368, 'sentry', '0363_auto__add_grouplink__add_unique_grouplink_group_id_linked_type_linked_', '2019-03-20 08:49:07.285672+00');
INSERT INTO public.south_migrationhistory VALUES (369, 'sentry', '0364_backfill_grouplink_from_groupcommitresolution', '2019-03-20 08:49:07.914854+00');
INSERT INTO public.south_migrationhistory VALUES (370, 'sentry', '0365_auto__del_index_eventtag_project_id_key_id_value_id', '2019-03-20 08:49:08.55321+00');
INSERT INTO public.south_migrationhistory VALUES (371, 'sentry', '0366_backfill_first_project_heroku', '2019-03-20 08:49:09.212076+00');
INSERT INTO public.south_migrationhistory VALUES (372, 'sentry', '0367_auto__chg_field_release_ref__chg_field_release_version', '2019-03-20 08:49:09.9758+00');
INSERT INTO public.south_migrationhistory VALUES (373, 'sentry', '0368_auto__add_deletedorganization__add_deletedteam__add_deletedproject', '2019-03-20 08:49:10.706165+00');
INSERT INTO public.south_migrationhistory VALUES (374, 'sentry', '0369_remove_old_grouphash_last_processed_event_data', '2019-03-20 08:49:11.414807+00');
INSERT INTO public.south_migrationhistory VALUES (375, 'sentry', '0370_correct_groupsnooze_windows', '2019-03-20 08:49:12.109627+00');
INSERT INTO public.south_migrationhistory VALUES (376, 'sentry', '0371_auto__add_servicehook', '2019-03-20 08:49:12.861299+00');
INSERT INTO public.south_migrationhistory VALUES (377, 'sentry', '0371_auto__del_minidumpfile', '2019-03-20 08:49:13.539653+00');
INSERT INTO public.south_migrationhistory VALUES (378, 'sentry', '0372_resolve_migration_conflict', '2019-03-20 08:49:14.203136+00');
INSERT INTO public.south_migrationhistory VALUES (379, 'sentry', '0373_backfill_projectteam', '2019-03-20 08:49:14.902964+00');
INSERT INTO public.south_migrationhistory VALUES (380, 'sentry', '0374_auto__del_useridentity__del_unique_useridentity_user_identity__del_ide', '2019-03-20 08:49:15.613017+00');
INSERT INTO public.south_migrationhistory VALUES (381, 'sentry', '0375_auto__add_identityprovider__add_unique_identityprovider_type_organizat', '2019-03-20 08:49:16.516997+00');
INSERT INTO public.south_migrationhistory VALUES (382, 'sentry', '0376_auto__add_userpermission__add_unique_userpermission_user_permission', '2019-03-20 08:49:17.48409+00');
INSERT INTO public.south_migrationhistory VALUES (383, 'sentry', '0377_auto__add_pullrequest__add_unique_pullrequest_repository_id_key__add_i', '2019-03-20 08:49:18.23792+00');
INSERT INTO public.south_migrationhistory VALUES (384, 'sentry', '0378_delete_outdated_projectteam', '2019-03-20 08:49:18.942975+00');
INSERT INTO public.south_migrationhistory VALUES (385, 'sentry', '0379_auto__add_unique_projectteam_project', '2019-03-20 08:49:19.639762+00');
INSERT INTO public.south_migrationhistory VALUES (386, 'sentry', '0380_auto__chg_field_servicehook_url', '2019-03-20 08:49:20.38343+00');
INSERT INTO public.south_migrationhistory VALUES (387, 'sentry', '0381_auto__del_field_deletedproject_team_name__del_field_deletedproject_tea', '2019-03-20 08:49:21.136181+00');
INSERT INTO public.south_migrationhistory VALUES (388, 'sentry', '0382_auto__add_groupenvironment__add_unique_groupenvironment_group_id_envir', '2019-03-20 08:49:21.948666+00');
INSERT INTO public.south_migrationhistory VALUES (389, 'sentry', '0383_auto__chg_field_project_team', '2019-03-20 08:49:22.694176+00');
INSERT INTO public.south_migrationhistory VALUES (390, 'sentry', '0384_auto__del_unique_projectteam_project', '2019-03-20 08:49:23.438153+00');
INSERT INTO public.south_migrationhistory VALUES (391, 'sentry', '0385_auto__add_field_rule_environment_id', '2019-03-20 08:49:25.600648+00');
INSERT INTO public.south_migrationhistory VALUES (392, 'sentry', '0386_auto__del_unique_project_team_slug', '2019-03-20 08:49:26.37335+00');
INSERT INTO public.south_migrationhistory VALUES (393, 'sentry', '0387_auto__add_field_groupassignee_team__chg_field_groupassignee_user', '2019-03-20 08:49:27.128558+00');
INSERT INTO public.south_migrationhistory VALUES (394, 'sentry', '0388_auto__add_field_environmentproject_is_hidden', '2019-03-20 08:49:27.884975+00');
INSERT INTO public.south_migrationhistory VALUES (395, 'sentry', '0389_auto__add_field_groupenvironment_first_release_id__add_index_groupenvi', '2019-03-20 08:49:28.640605+00');
INSERT INTO public.south_migrationhistory VALUES (396, 'sentry', '0390_auto__add_field_userreport_environment', '2019-03-20 08:49:29.399832+00');
INSERT INTO public.south_migrationhistory VALUES (397, 'sentry', '0391_auto__add_fileblobowner__add_unique_fileblobowner_blob_organization__a', '2019-03-20 08:49:30.182514+00');
INSERT INTO public.south_migrationhistory VALUES (398, 'sentry', '0392_auto__add_projectownership', '2019-03-20 08:49:30.992779+00');
INSERT INTO public.south_migrationhistory VALUES (399, 'sentry', '0393_auto__add_assistantactivity__add_unique_assistantactivity_user_guide_i', '2019-03-20 08:49:31.858836+00');
INSERT INTO public.south_migrationhistory VALUES (400, 'sentry', '0394_auto__chg_field_project_team', '2019-03-20 08:49:32.755155+00');
INSERT INTO public.south_migrationhistory VALUES (401, 'sentry', '0395_auto__add_releaseprojectenvironment__add_unique_releaseprojectenvironm', '2019-03-20 08:49:33.613174+00');
INSERT INTO public.south_migrationhistory VALUES (402, 'sentry', '0396_auto__del_field_project_team', '2019-03-20 08:49:34.436985+00');
INSERT INTO public.south_migrationhistory VALUES (403, 'sentry', '0397_auto__add_latestrelease__add_unique_latestrelease_repository_id_enviro', '2019-03-20 08:49:35.310066+00');
INSERT INTO public.south_migrationhistory VALUES (404, 'sentry', '0397_auto__add_unique_identity_idp_user', '2019-03-20 08:49:36.192621+00');
INSERT INTO public.south_migrationhistory VALUES (405, 'sentry', '0398_auto__add_pullrequestcommit__add_unique_pullrequestcommit_pull_request', '2019-03-20 08:49:37.260753+00');
INSERT INTO public.south_migrationhistory VALUES (406, 'sentry', '0399_auto__chg_field_user_last_login__add_unique_identity_idp_user', '2019-03-20 08:49:38.23595+00');
INSERT INTO public.south_migrationhistory VALUES (407, 'sentry', '0400_auto__add_projectredirect__add_unique_projectredirect_organization_red', '2019-03-20 08:49:39.083963+00');
INSERT INTO public.south_migrationhistory VALUES (408, 'sentry', '0401_auto__chg_field_projectdsymfile_uuid', '2019-03-20 08:49:40.033442+00');
INSERT INTO public.south_migrationhistory VALUES (409, 'sentry', '0402_auto__add_field_organizationintegration_date_added__add_field_identity', '2019-03-20 08:49:41.045838+00');
INSERT INTO public.south_migrationhistory VALUES (410, 'sentry', '0403_auto__add_teamavatar', '2019-03-20 08:49:41.949755+00');
INSERT INTO public.south_migrationhistory VALUES (411, 'sentry', '0404_auto__del_unique_environment_project_id_name', '2019-03-20 08:49:42.811988+00');
INSERT INTO public.south_migrationhistory VALUES (412, 'sentry', '0405_auto__add_field_user_flags', '2019-03-20 08:49:43.669407+00');
INSERT INTO public.south_migrationhistory VALUES (413, 'sentry', '0406_auto__add_projectavatar', '2019-03-20 08:49:44.713565+00');
INSERT INTO public.south_migrationhistory VALUES (414, 'sentry', '0407_auto__add_field_identityprovider_external_id__add_unique_identityprovi', '2019-03-20 08:49:45.593807+00');
INSERT INTO public.south_migrationhistory VALUES (415, 'sentry', '0408_identity_provider_external_id', '2019-03-20 08:49:46.454283+00');
INSERT INTO public.south_migrationhistory VALUES (416, 'sentry', '0409_auto__add_field_releaseprojectenvironment_last_deploy_id', '2019-03-20 08:49:47.351696+00');
INSERT INTO public.south_migrationhistory VALUES (417, 'sentry', '0410_auto__del_unique_identityprovider_type_organization', '2019-03-20 08:49:48.311747+00');
INSERT INTO public.south_migrationhistory VALUES (418, 'sentry', '0411_auto__add_field_projectkey_data', '2019-03-20 08:49:49.234119+00');
INSERT INTO public.south_migrationhistory VALUES (419, 'sentry', '0412_auto__chg_field_file_name', '2019-03-20 08:49:50.117704+00');
INSERT INTO public.south_migrationhistory VALUES (420, 'sentry', '0413_auto__add_externalissue__add_unique_externalissue_organization_id_inte', '2019-03-20 08:49:51.013685+00');
INSERT INTO public.south_migrationhistory VALUES (421, 'sentry', '0414_backfill_release_project_environment_last_deploy_id', '2019-03-20 08:49:51.910223+00');
INSERT INTO public.south_migrationhistory VALUES (422, 'sentry', '0415_auto__add_relay', '2019-03-20 08:49:52.932387+00');
INSERT INTO public.south_migrationhistory VALUES (423, 'sentry', '0416_auto__del_field_identityprovider_organization__add_field_identityprovi', '2019-03-20 08:49:53.862771+00');
INSERT INTO public.south_migrationhistory VALUES (424, 'sentry', '0417_migrate_identities', '2019-03-20 08:49:54.754152+00');
INSERT INTO public.south_migrationhistory VALUES (425, 'sentry', '0418_delete_old_idps', '2019-03-20 08:49:55.658034+00');
INSERT INTO public.south_migrationhistory VALUES (426, 'sentry', '0419_auto__add_unique_identityprovider_type_external_id', '2019-03-20 08:49:56.662185+00');
INSERT INTO public.south_migrationhistory VALUES (427, 'sentry', '0420_auto__chg_field_identityprovider_organization_id', '2019-03-20 08:49:57.722933+00');
INSERT INTO public.south_migrationhistory VALUES (428, 'sentry', '0421_auto__del_field_identityprovider_organization_id__del_unique_identityp', '2019-03-20 08:49:58.649273+00');
INSERT INTO public.south_migrationhistory VALUES (429, 'sentry', '0422_auto__add_grouphashtombstone__add_unique_grouphashtombstone_project_ha', '2019-03-20 08:49:59.608835+00');
INSERT INTO public.south_migrationhistory VALUES (430, 'sentry', '0423_auto__add_index_grouphashtombstone_deleted_at', '2019-03-20 08:50:00.663292+00');
INSERT INTO public.south_migrationhistory VALUES (431, 'nodestore', '0001_initial', '2019-03-20 08:50:12.155928+00');
INSERT INTO public.south_migrationhistory VALUES (432, 'search', '0001_initial', '2019-03-20 08:50:12.978759+00');
INSERT INTO public.south_migrationhistory VALUES (433, 'search', '0002_auto__del_searchtoken__del_unique_searchtoken_document_field_token__de', '2019-03-20 08:50:13.016586+00');
INSERT INTO public.south_migrationhistory VALUES (434, 'social_auth', '0001_initial', '2019-03-20 08:50:13.969731+00');
INSERT INTO public.south_migrationhistory VALUES (435, 'social_auth', '0002_auto__add_unique_nonce_timestamp_salt_server_url__add_unique_associati', '2019-03-20 08:50:14.370337+00');
INSERT INTO public.south_migrationhistory VALUES (436, 'social_auth', '0003_auto__del_nonce__del_unique_nonce_server_url_timestamp_salt__del_assoc', '2019-03-20 08:50:14.437437+00');
INSERT INTO public.south_migrationhistory VALUES (437, 'social_auth', '0004_auto__del_unique_usersocialauth_provider_uid__add_unique_usersocialaut', '2019-03-20 08:50:14.475054+00');
INSERT INTO public.south_migrationhistory VALUES (438, 'tagstore', '0001_initial', '2019-03-20 08:50:17.013036+00');
INSERT INTO public.south_migrationhistory VALUES (439, 'tagstore', '0002_auto__del_tagkey__del_unique_tagkey_project_id_environment_id_key__del', '2019-03-20 08:50:17.109664+00');
INSERT INTO public.south_migrationhistory VALUES (440, 'tagstore', '0003_auto__add_tagkey__add_unique_tagkey_project_id_environment_id_key__add', '2019-03-20 08:50:17.360997+00');
INSERT INTO public.south_migrationhistory VALUES (441, 'tagstore', '0004_auto__del_tagkey__del_unique_tagkey_project_id_environment_id_key__del', '2019-03-20 08:50:17.516484+00');
INSERT INTO public.south_migrationhistory VALUES (442, 'tagstore', '0005_auto__add_tagvalue__add_unique_tagvalue_project_id__key_value__add_ind', '2019-03-20 08:50:17.706891+00');
INSERT INTO public.south_migrationhistory VALUES (443, 'tagstore', '0006_auto__del_unique_eventtag_event_id_key_value__add_unique_eventtag_proj', '2019-03-20 08:50:17.760258+00');
INSERT INTO public.south_migrationhistory VALUES (444, 'tagstore', '0007_auto__chg_field_tagkey_environment_id__chg_field_tagkey_project_id__ch', '2019-03-20 08:50:18.234403+00');
INSERT INTO public.south_migrationhistory VALUES (445, 'tagstore', '0008_auto__chg_field_tagkey_environment_id', '2019-03-20 08:50:18.317127+00');
INSERT INTO public.south_migrationhistory VALUES (446, 'jira_ac', '0001_initial', '2019-03-20 08:50:18.744803+00');
INSERT INTO public.south_migrationhistory VALUES (447, 'hipchat_ac', '0001_initial', '2019-03-20 08:50:19.395008+00');
INSERT INTO public.south_migrationhistory VALUES (448, 'hipchat_ac', '0002_auto__del_mentionedevent', '2019-03-20 08:50:19.594899+00');


--
-- Name: south_migrationhistory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.south_migrationhistory_id_seq', 448, true);


--
-- Data for Name: tagstore_eventtag; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: tagstore_eventtag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tagstore_eventtag_id_seq', 1, false);


--
-- Data for Name: tagstore_grouptagkey; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: tagstore_grouptagkey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tagstore_grouptagkey_id_seq', 1, false);


--
-- Data for Name: tagstore_grouptagvalue; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: tagstore_grouptagvalue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tagstore_grouptagvalue_id_seq', 1, false);


--
-- Data for Name: tagstore_tagkey; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: tagstore_tagkey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tagstore_tagkey_id_seq', 1, false);


--
-- Data for Name: tagstore_tagvalue; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: tagstore_tagvalue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tagstore_tagvalue_id_seq', 1, false);


--
-- Name: auth_authenticator_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_authenticator
    ADD CONSTRAINT auth_authenticator_pkey PRIMARY KEY (id);


--
-- Name: auth_authenticator_user_id_5774ed51577668d4_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_authenticator
    ADD CONSTRAINT auth_authenticator_user_id_5774ed51577668d4_uniq UNIQUE (user_id, type);


--
-- Name: auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions_group_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_key UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission_content_type_id_codename_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_key UNIQUE (content_type_id, codename);


--
-- Name: auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type_app_label_model_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_key UNIQUE (app_label, model);


--
-- Name: django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- Name: jira_ac_tenant_client_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_ac_tenant
    ADD CONSTRAINT jira_ac_tenant_client_key_key UNIQUE (client_key);


--
-- Name: jira_ac_tenant_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_ac_tenant
    ADD CONSTRAINT jira_ac_tenant_pkey PRIMARY KEY (id);


--
-- Name: nodestore_node_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nodestore_node
    ADD CONSTRAINT nodestore_node_pkey PRIMARY KEY (id);


--
-- Name: sentry_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_activity
    ADD CONSTRAINT sentry_activity_pkey PRIMARY KEY (id);


--
-- Name: sentry_apiapplication_client_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apiapplication
    ADD CONSTRAINT sentry_apiapplication_client_id_key UNIQUE (client_id);


--
-- Name: sentry_apiapplication_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apiapplication
    ADD CONSTRAINT sentry_apiapplication_pkey PRIMARY KEY (id);


--
-- Name: sentry_apiauthorization_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apiauthorization
    ADD CONSTRAINT sentry_apiauthorization_pkey PRIMARY KEY (id);


--
-- Name: sentry_apiauthorization_user_id_eb16c64a7b6db1c_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apiauthorization
    ADD CONSTRAINT sentry_apiauthorization_user_id_eb16c64a7b6db1c_uniq UNIQUE (user_id, application_id);


--
-- Name: sentry_apigrant_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apigrant
    ADD CONSTRAINT sentry_apigrant_pkey PRIMARY KEY (id);


--
-- Name: sentry_apikey_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apikey
    ADD CONSTRAINT sentry_apikey_key_key UNIQUE (key);


--
-- Name: sentry_apikey_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apikey
    ADD CONSTRAINT sentry_apikey_pkey PRIMARY KEY (id);


--
-- Name: sentry_apitoken_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apitoken
    ADD CONSTRAINT sentry_apitoken_pkey PRIMARY KEY (id);


--
-- Name: sentry_apitoken_refresh_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apitoken
    ADD CONSTRAINT sentry_apitoken_refresh_token_key UNIQUE (refresh_token);


--
-- Name: sentry_apitoken_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apitoken
    ADD CONSTRAINT sentry_apitoken_token_key UNIQUE (token);


--
-- Name: sentry_assistant_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_assistant_activity
    ADD CONSTRAINT sentry_assistant_activity_pkey PRIMARY KEY (id);


--
-- Name: sentry_assistant_activity_user_id_63ff4731f0f1d7f9_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_assistant_activity
    ADD CONSTRAINT sentry_assistant_activity_user_id_63ff4731f0f1d7f9_uniq UNIQUE (user_id, guide_id);


--
-- Name: sentry_auditlogentry_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_auditlogentry
    ADD CONSTRAINT sentry_auditlogentry_pkey PRIMARY KEY (id);


--
-- Name: sentry_authidentity_auth_provider_id_2ac89deececdc9d7_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_authidentity
    ADD CONSTRAINT sentry_authidentity_auth_provider_id_2ac89deececdc9d7_uniq UNIQUE (auth_provider_id, user_id);


--
-- Name: sentry_authidentity_auth_provider_id_72ab4375ecd728ba_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_authidentity
    ADD CONSTRAINT sentry_authidentity_auth_provider_id_72ab4375ecd728ba_uniq UNIQUE (auth_provider_id, ident);


--
-- Name: sentry_authidentity_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_authidentity
    ADD CONSTRAINT sentry_authidentity_pkey PRIMARY KEY (id);


--
-- Name: sentry_authprovider_defau_authprovider_id_352ee7f2584f4caf_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_authprovider_default_teams
    ADD CONSTRAINT sentry_authprovider_defau_authprovider_id_352ee7f2584f4caf_uniq UNIQUE (authprovider_id, team_id);


--
-- Name: sentry_authprovider_default_teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_authprovider_default_teams
    ADD CONSTRAINT sentry_authprovider_default_teams_pkey PRIMARY KEY (id);


--
-- Name: sentry_authprovider_organization_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_authprovider
    ADD CONSTRAINT sentry_authprovider_organization_id_key UNIQUE (organization_id);


--
-- Name: sentry_authprovider_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_authprovider
    ADD CONSTRAINT sentry_authprovider_pkey PRIMARY KEY (id);


--
-- Name: sentry_broadcast_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_broadcast
    ADD CONSTRAINT sentry_broadcast_pkey PRIMARY KEY (id);


--
-- Name: sentry_broadcastseen_broadcast_id_352c833420c70bd9_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_broadcastseen
    ADD CONSTRAINT sentry_broadcastseen_broadcast_id_352c833420c70bd9_uniq UNIQUE (broadcast_id, user_id);


--
-- Name: sentry_broadcastseen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_broadcastseen
    ADD CONSTRAINT sentry_broadcastseen_pkey PRIMARY KEY (id);


--
-- Name: sentry_commit_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_commit
    ADD CONSTRAINT sentry_commit_pkey PRIMARY KEY (id);


--
-- Name: sentry_commit_repository_id_2d25b4d8949fca93_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_commit
    ADD CONSTRAINT sentry_commit_repository_id_2d25b4d8949fca93_uniq UNIQUE (repository_id, key);


--
-- Name: sentry_commitauthor_organization_id_3cdc85e9f09bf3f3_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_commitauthor
    ADD CONSTRAINT sentry_commitauthor_organization_id_3cdc85e9f09bf3f3_uniq UNIQUE (organization_id, external_id);


--
-- Name: sentry_commitauthor_organization_id_5656e6a6baa5f6c_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_commitauthor
    ADD CONSTRAINT sentry_commitauthor_organization_id_5656e6a6baa5f6c_uniq UNIQUE (organization_id, email);


--
-- Name: sentry_commitauthor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_commitauthor
    ADD CONSTRAINT sentry_commitauthor_pkey PRIMARY KEY (id);


--
-- Name: sentry_commitfilechange_commit_id_4c6f7ec25af34227_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_commitfilechange
    ADD CONSTRAINT sentry_commitfilechange_commit_id_4c6f7ec25af34227_uniq UNIQUE (commit_id, filename);


--
-- Name: sentry_commitfilechange_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_commitfilechange
    ADD CONSTRAINT sentry_commitfilechange_pkey PRIMARY KEY (id);


--
-- Name: sentry_deletedorganization_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_deletedorganization
    ADD CONSTRAINT sentry_deletedorganization_pkey PRIMARY KEY (id);


--
-- Name: sentry_deletedproject_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_deletedproject
    ADD CONSTRAINT sentry_deletedproject_pkey PRIMARY KEY (id);


--
-- Name: sentry_deletedteam_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_deletedteam
    ADD CONSTRAINT sentry_deletedteam_pkey PRIMARY KEY (id);


--
-- Name: sentry_deploy_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_deploy
    ADD CONSTRAINT sentry_deploy_pkey PRIMARY KEY (id);


--
-- Name: sentry_distribution_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_distribution
    ADD CONSTRAINT sentry_distribution_pkey PRIMARY KEY (id);


--
-- Name: sentry_distribution_release_id_42bfea790c978c1b_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_distribution
    ADD CONSTRAINT sentry_distribution_release_id_42bfea790c978c1b_uniq UNIQUE (release_id, name);


--
-- Name: sentry_dsymapp_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_dsymapp
    ADD CONSTRAINT sentry_dsymapp_pkey PRIMARY KEY (id);


--
-- Name: sentry_dsymapp_project_id_decebaf381e09fe_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_dsymapp
    ADD CONSTRAINT sentry_dsymapp_project_id_decebaf381e09fe_uniq UNIQUE (project_id, platform, app_id);


--
-- Name: sentry_email_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_email
    ADD CONSTRAINT sentry_email_email_key UNIQUE (email);


--
-- Name: sentry_email_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_email
    ADD CONSTRAINT sentry_email_pkey PRIMARY KEY (id);


--
-- Name: sentry_environment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_environment
    ADD CONSTRAINT sentry_environment_pkey PRIMARY KEY (id);


--
-- Name: sentry_environmentproject_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_environmentproject
    ADD CONSTRAINT sentry_environmentproject_pkey PRIMARY KEY (id);


--
-- Name: sentry_environmentproject_project_id_29250c1307d3722b_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_environmentproject
    ADD CONSTRAINT sentry_environmentproject_project_id_29250c1307d3722b_uniq UNIQUE (project_id, environment_id);


--
-- Name: sentry_environmentrelease_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_environmentrelease
    ADD CONSTRAINT sentry_environmentrelease_pkey PRIMARY KEY (id);


--
-- Name: sentry_eventmapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_eventmapping
    ADD CONSTRAINT sentry_eventmapping_pkey PRIMARY KEY (id);


--
-- Name: sentry_eventmapping_project_id_eb6c54bf8930ba6_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_eventmapping
    ADD CONSTRAINT sentry_eventmapping_project_id_eb6c54bf8930ba6_uniq UNIQUE (project_id, event_id);


--
-- Name: sentry_eventprocessingissue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_eventprocessingissue
    ADD CONSTRAINT sentry_eventprocessingissue_pkey PRIMARY KEY (id);


--
-- Name: sentry_eventprocessingissue_raw_event_id_7751571083fd0f14_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_eventprocessingissue
    ADD CONSTRAINT sentry_eventprocessingissue_raw_event_id_7751571083fd0f14_uniq UNIQUE (raw_event_id, processing_issue_id);


--
-- Name: sentry_eventtag_event_id_430cef8ef4186908_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_eventtag
    ADD CONSTRAINT sentry_eventtag_event_id_430cef8ef4186908_uniq UNIQUE (event_id, key_id, value_id);


--
-- Name: sentry_eventtag_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_eventtag
    ADD CONSTRAINT sentry_eventtag_pkey PRIMARY KEY (id);


--
-- Name: sentry_eventuser_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_eventuser
    ADD CONSTRAINT sentry_eventuser_pkey PRIMARY KEY (id);


--
-- Name: sentry_eventuser_project_id_1a96e3b719e55f9a_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_eventuser
    ADD CONSTRAINT sentry_eventuser_project_id_1a96e3b719e55f9a_uniq UNIQUE (project_id, hash);


--
-- Name: sentry_eventuser_project_id_1dcb94833e2de5cf_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_eventuser
    ADD CONSTRAINT sentry_eventuser_project_id_1dcb94833e2de5cf_uniq UNIQUE (project_id, ident);


--
-- Name: sentry_externalissue_organization_id_3e15847c42683d85_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_externalissue
    ADD CONSTRAINT sentry_externalissue_organization_id_3e15847c42683d85_uniq UNIQUE (organization_id, integration_id, key);


--
-- Name: sentry_externalissue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_externalissue
    ADD CONSTRAINT sentry_externalissue_pkey PRIMARY KEY (id);


--
-- Name: sentry_featureadoption_organization_id_78451b8747a9e638_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_featureadoption
    ADD CONSTRAINT sentry_featureadoption_organization_id_78451b8747a9e638_uniq UNIQUE (organization_id, feature_id);


--
-- Name: sentry_featureadoption_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_featureadoption
    ADD CONSTRAINT sentry_featureadoption_pkey PRIMARY KEY (id);


--
-- Name: sentry_file_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_file
    ADD CONSTRAINT sentry_file_pkey PRIMARY KEY (id);


--
-- Name: sentry_fileblob_checksum_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_fileblob
    ADD CONSTRAINT sentry_fileblob_checksum_key UNIQUE (checksum);


--
-- Name: sentry_fileblob_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_fileblob
    ADD CONSTRAINT sentry_fileblob_pkey PRIMARY KEY (id);


--
-- Name: sentry_fileblobindex_file_id_56d11844195e33b2_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_fileblobindex
    ADD CONSTRAINT sentry_fileblobindex_file_id_56d11844195e33b2_uniq UNIQUE (file_id, blob_id, "offset");


--
-- Name: sentry_fileblobindex_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_fileblobindex
    ADD CONSTRAINT sentry_fileblobindex_pkey PRIMARY KEY (id);


--
-- Name: sentry_fileblobowner_blob_id_78037767e8554f2_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_fileblobowner
    ADD CONSTRAINT sentry_fileblobowner_blob_id_78037767e8554f2_uniq UNIQUE (blob_id, organization_id);


--
-- Name: sentry_fileblobowner_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_fileblobowner
    ADD CONSTRAINT sentry_fileblobowner_pkey PRIMARY KEY (id);


--
-- Name: sentry_filterkey_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_filterkey
    ADD CONSTRAINT sentry_filterkey_pkey PRIMARY KEY (id);


--
-- Name: sentry_filterkey_project_id_67551b8e28dda5a_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_filterkey
    ADD CONSTRAINT sentry_filterkey_project_id_67551b8e28dda5a_uniq UNIQUE (project_id, key);


--
-- Name: sentry_filtervalue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_filtervalue
    ADD CONSTRAINT sentry_filtervalue_pkey PRIMARY KEY (id);


--
-- Name: sentry_filtervalue_project_id_201b156195347397_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_filtervalue
    ADD CONSTRAINT sentry_filtervalue_project_id_201b156195347397_uniq UNIQUE (project_id, key, value);


--
-- Name: sentry_groupasignee_group_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupasignee
    ADD CONSTRAINT sentry_groupasignee_group_id_key UNIQUE (group_id);


--
-- Name: sentry_groupasignee_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupasignee
    ADD CONSTRAINT sentry_groupasignee_pkey PRIMARY KEY (id);


--
-- Name: sentry_groupbookmark_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupbookmark
    ADD CONSTRAINT sentry_groupbookmark_pkey PRIMARY KEY (id);


--
-- Name: sentry_groupbookmark_project_id_6d2bb88ad3832208_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupbookmark
    ADD CONSTRAINT sentry_groupbookmark_project_id_6d2bb88ad3832208_uniq UNIQUE (project_id, user_id, group_id);


--
-- Name: sentry_groupcommitresolution_group_id_c46e4845d76b4f_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupcommitresolution
    ADD CONSTRAINT sentry_groupcommitresolution_group_id_c46e4845d76b4f_uniq UNIQUE (group_id, commit_id);


--
-- Name: sentry_groupcommitresolution_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupcommitresolution
    ADD CONSTRAINT sentry_groupcommitresolution_pkey PRIMARY KEY (id);


--
-- Name: sentry_groupedmessage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupedmessage
    ADD CONSTRAINT sentry_groupedmessage_pkey PRIMARY KEY (id);


--
-- Name: sentry_groupedmessage_project_id_680bfe5607002523_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupedmessage
    ADD CONSTRAINT sentry_groupedmessage_project_id_680bfe5607002523_uniq UNIQUE (project_id, short_id);


--
-- Name: sentry_groupemailthread_email_456f4d17524b316_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupemailthread
    ADD CONSTRAINT sentry_groupemailthread_email_456f4d17524b316_uniq UNIQUE (email, msgid);


--
-- Name: sentry_groupemailthread_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupemailthread
    ADD CONSTRAINT sentry_groupemailthread_pkey PRIMARY KEY (id);


--
-- Name: sentry_groupenvironment_group_id_6b391aea0c56f32f_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupenvironment
    ADD CONSTRAINT sentry_groupenvironment_group_id_6b391aea0c56f32f_uniq UNIQUE (group_id, environment_id);


--
-- Name: sentry_groupenvironment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupenvironment
    ADD CONSTRAINT sentry_groupenvironment_pkey PRIMARY KEY (id);


--
-- Name: sentry_grouphash_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouphash
    ADD CONSTRAINT sentry_grouphash_pkey PRIMARY KEY (id);


--
-- Name: sentry_grouphash_project_id_4a293f96a363c9a2_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouphash
    ADD CONSTRAINT sentry_grouphash_project_id_4a293f96a363c9a2_uniq UNIQUE (project_id, hash);


--
-- Name: sentry_grouphashtombstone_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouphashtombstone
    ADD CONSTRAINT sentry_grouphashtombstone_pkey PRIMARY KEY (id);


--
-- Name: sentry_grouphashtombstone_project_id_11f16fdd42fd1944_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouphashtombstone
    ADD CONSTRAINT sentry_grouphashtombstone_project_id_11f16fdd42fd1944_uniq UNIQUE (project_id, hash);


--
-- Name: sentry_grouplink_group_id_73ee52490ebedd34_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouplink
    ADD CONSTRAINT sentry_grouplink_group_id_73ee52490ebedd34_uniq UNIQUE (group_id, linked_type, linked_id);


--
-- Name: sentry_grouplink_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouplink
    ADD CONSTRAINT sentry_grouplink_pkey PRIMARY KEY (id);


--
-- Name: sentry_groupmeta_key_5d9d7a3c6538b14d_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupmeta
    ADD CONSTRAINT sentry_groupmeta_key_5d9d7a3c6538b14d_uniq UNIQUE (key, group_id);


--
-- Name: sentry_groupmeta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupmeta
    ADD CONSTRAINT sentry_groupmeta_pkey PRIMARY KEY (id);


--
-- Name: sentry_groupredirect_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupredirect
    ADD CONSTRAINT sentry_groupredirect_pkey PRIMARY KEY (id);


--
-- Name: sentry_groupredirect_previous_group_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupredirect
    ADD CONSTRAINT sentry_groupredirect_previous_group_id_key UNIQUE (previous_group_id);


--
-- Name: sentry_grouprelease_group_id_46ba6e430d088d04_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouprelease
    ADD CONSTRAINT sentry_grouprelease_group_id_46ba6e430d088d04_uniq UNIQUE (group_id, release_id, environment);


--
-- Name: sentry_grouprelease_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouprelease
    ADD CONSTRAINT sentry_grouprelease_pkey PRIMARY KEY (id);


--
-- Name: sentry_groupresolution_group_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupresolution
    ADD CONSTRAINT sentry_groupresolution_group_id_key UNIQUE (group_id);


--
-- Name: sentry_groupresolution_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupresolution
    ADD CONSTRAINT sentry_groupresolution_pkey PRIMARY KEY (id);


--
-- Name: sentry_grouprulestatus_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouprulestatus
    ADD CONSTRAINT sentry_grouprulestatus_pkey PRIMARY KEY (id);


--
-- Name: sentry_grouprulestatus_rule_id_329bb0edaad3880f_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouprulestatus
    ADD CONSTRAINT sentry_grouprulestatus_rule_id_329bb0edaad3880f_uniq UNIQUE (rule_id, group_id);


--
-- Name: sentry_groupseen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupseen
    ADD CONSTRAINT sentry_groupseen_pkey PRIMARY KEY (id);


--
-- Name: sentry_groupseen_user_id_179917bc9974d91b_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupseen
    ADD CONSTRAINT sentry_groupseen_user_id_179917bc9974d91b_uniq UNIQUE (user_id, group_id);


--
-- Name: sentry_groupshare_group_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupshare
    ADD CONSTRAINT sentry_groupshare_group_id_key UNIQUE (group_id);


--
-- Name: sentry_groupshare_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupshare
    ADD CONSTRAINT sentry_groupshare_pkey PRIMARY KEY (id);


--
-- Name: sentry_groupshare_uuid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupshare
    ADD CONSTRAINT sentry_groupshare_uuid_key UNIQUE (uuid);


--
-- Name: sentry_groupsnooze_group_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupsnooze
    ADD CONSTRAINT sentry_groupsnooze_group_id_key UNIQUE (group_id);


--
-- Name: sentry_groupsnooze_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupsnooze
    ADD CONSTRAINT sentry_groupsnooze_pkey PRIMARY KEY (id);


--
-- Name: sentry_groupsubscription_group_id_7e18bedd5058ccc3_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupsubscription
    ADD CONSTRAINT sentry_groupsubscription_group_id_7e18bedd5058ccc3_uniq UNIQUE (group_id, user_id);


--
-- Name: sentry_groupsubscription_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupsubscription
    ADD CONSTRAINT sentry_groupsubscription_pkey PRIMARY KEY (id);


--
-- Name: sentry_grouptagkey_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouptagkey
    ADD CONSTRAINT sentry_grouptagkey_pkey PRIMARY KEY (id);


--
-- Name: sentry_grouptagkey_project_id_7b0c8092f47b509f_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouptagkey
    ADD CONSTRAINT sentry_grouptagkey_project_id_7b0c8092f47b509f_uniq UNIQUE (project_id, group_id, key);


--
-- Name: sentry_grouptombstone_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouptombstone
    ADD CONSTRAINT sentry_grouptombstone_pkey PRIMARY KEY (id);


--
-- Name: sentry_grouptombstone_previous_group_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouptombstone
    ADD CONSTRAINT sentry_grouptombstone_previous_group_id_key UNIQUE (previous_group_id);


--
-- Name: sentry_hipchat_ac_tenant_organi_tenant_id_277f40009a2aa417_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_hipchat_ac_tenant_organizations
    ADD CONSTRAINT sentry_hipchat_ac_tenant_organi_tenant_id_277f40009a2aa417_uniq UNIQUE (tenant_id, organization_id);


--
-- Name: sentry_hipchat_ac_tenant_organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_hipchat_ac_tenant_organizations
    ADD CONSTRAINT sentry_hipchat_ac_tenant_organizations_pkey PRIMARY KEY (id);


--
-- Name: sentry_hipchat_ac_tenant_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_hipchat_ac_tenant
    ADD CONSTRAINT sentry_hipchat_ac_tenant_pkey PRIMARY KEY (id);


--
-- Name: sentry_hipchat_ac_tenant_projec_tenant_id_5308544b484f49a9_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_hipchat_ac_tenant_projects
    ADD CONSTRAINT sentry_hipchat_ac_tenant_projec_tenant_id_5308544b484f49a9_uniq UNIQUE (tenant_id, project_id);


--
-- Name: sentry_hipchat_ac_tenant_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_hipchat_ac_tenant_projects
    ADD CONSTRAINT sentry_hipchat_ac_tenant_projects_pkey PRIMARY KEY (id);


--
-- Name: sentry_identity_idp_id_2355d6c6ee4f8b24_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_identity
    ADD CONSTRAINT sentry_identity_idp_id_2355d6c6ee4f8b24_uniq UNIQUE (idp_id, user_id);


--
-- Name: sentry_identity_idp_id_47d379630426f630_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_identity
    ADD CONSTRAINT sentry_identity_idp_id_47d379630426f630_uniq UNIQUE (idp_id, external_id);


--
-- Name: sentry_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_identity
    ADD CONSTRAINT sentry_identity_pkey PRIMARY KEY (id);


--
-- Name: sentry_identityprovider_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_identityprovider
    ADD CONSTRAINT sentry_identityprovider_pkey PRIMARY KEY (id);


--
-- Name: sentry_identityprovider_type_244d1ca4a8bc0cec_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_identityprovider
    ADD CONSTRAINT sentry_identityprovider_type_244d1ca4a8bc0cec_uniq UNIQUE (type, external_id);


--
-- Name: sentry_integration_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_integration
    ADD CONSTRAINT sentry_integration_pkey PRIMARY KEY (id);


--
-- Name: sentry_integration_provider_e9944c77818d5f5_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_integration
    ADD CONSTRAINT sentry_integration_provider_e9944c77818d5f5_uniq UNIQUE (provider, external_id);


--
-- Name: sentry_latestrelease_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_latestrelease
    ADD CONSTRAINT sentry_latestrelease_pkey PRIMARY KEY (id);


--
-- Name: sentry_latestrelease_repository_id_72410a59af97f654_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_latestrelease
    ADD CONSTRAINT sentry_latestrelease_repository_id_72410a59af97f654_uniq UNIQUE (repository_id, environment_id);


--
-- Name: sentry_lostpasswordhash_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_lostpasswordhash
    ADD CONSTRAINT sentry_lostpasswordhash_pkey PRIMARY KEY (id);


--
-- Name: sentry_lostpasswordhash_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_lostpasswordhash
    ADD CONSTRAINT sentry_lostpasswordhash_user_id_key UNIQUE (user_id);


--
-- Name: sentry_message_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_message
    ADD CONSTRAINT sentry_message_pkey PRIMARY KEY (id);


--
-- Name: sentry_message_project_id_b6b4e75e438ca83_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_message
    ADD CONSTRAINT sentry_message_project_id_b6b4e75e438ca83_uniq UNIQUE (project_id, message_id);


--
-- Name: sentry_messagefiltervalue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_messagefiltervalue
    ADD CONSTRAINT sentry_messagefiltervalue_pkey PRIMARY KEY (id);


--
-- Name: sentry_messageindex_column_23431fca14e385c1_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_messageindex
    ADD CONSTRAINT sentry_messageindex_column_23431fca14e385c1_uniq UNIQUE ("column", value, object_id);


--
-- Name: sentry_messageindex_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_messageindex
    ADD CONSTRAINT sentry_messageindex_pkey PRIMARY KEY (id);


--
-- Name: sentry_option_key_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_option
    ADD CONSTRAINT sentry_option_key_uniq UNIQUE (key);


--
-- Name: sentry_option_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_option
    ADD CONSTRAINT sentry_option_pkey PRIMARY KEY (id);


--
-- Name: sentry_organization_organizationmember_id_1634015042409685_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationmember_teams
    ADD CONSTRAINT sentry_organization_organizationmember_id_1634015042409685_uniq UNIQUE (organizationmember_id, team_id);


--
-- Name: sentry_organization_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organization
    ADD CONSTRAINT sentry_organization_pkey PRIMARY KEY (id);


--
-- Name: sentry_organization_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organization
    ADD CONSTRAINT sentry_organization_slug_key UNIQUE (slug);


--
-- Name: sentry_organizationaccessrequest_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationaccessrequest
    ADD CONSTRAINT sentry_organizationaccessrequest_pkey PRIMARY KEY (id);


--
-- Name: sentry_organizationaccessrequest_team_id_2a38219fe738f1d7_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationaccessrequest
    ADD CONSTRAINT sentry_organizationaccessrequest_team_id_2a38219fe738f1d7_uniq UNIQUE (team_id, member_id);


--
-- Name: sentry_organizationavatar_file_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationavatar
    ADD CONSTRAINT sentry_organizationavatar_file_id_key UNIQUE (file_id);


--
-- Name: sentry_organizationavatar_ident_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationavatar
    ADD CONSTRAINT sentry_organizationavatar_ident_key UNIQUE (ident);


--
-- Name: sentry_organizationavatar_organization_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationavatar
    ADD CONSTRAINT sentry_organizationavatar_organization_id_key UNIQUE (organization_id);


--
-- Name: sentry_organizationavatar_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationavatar
    ADD CONSTRAINT sentry_organizationavatar_pkey PRIMARY KEY (id);


--
-- Name: sentry_organizationintegr_organization_id_77bd763ea752b4b7_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationintegration
    ADD CONSTRAINT sentry_organizationintegr_organization_id_77bd763ea752b4b7_uniq UNIQUE (organization_id, integration_id);


--
-- Name: sentry_organizationintegration_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationintegration
    ADD CONSTRAINT sentry_organizationintegration_pkey PRIMARY KEY (id);


--
-- Name: sentry_organizationmember_organization_id_404770fc5e3a794_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationmember
    ADD CONSTRAINT sentry_organizationmember_organization_id_404770fc5e3a794_uniq UNIQUE (organization_id, user_id);


--
-- Name: sentry_organizationmember_organization_id_59ee8d99c683b0e7_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationmember
    ADD CONSTRAINT sentry_organizationmember_organization_id_59ee8d99c683b0e7_uniq UNIQUE (organization_id, email);


--
-- Name: sentry_organizationmember_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationmember
    ADD CONSTRAINT sentry_organizationmember_pkey PRIMARY KEY (id);


--
-- Name: sentry_organizationmember_teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationmember_teams
    ADD CONSTRAINT sentry_organizationmember_teams_pkey PRIMARY KEY (id);


--
-- Name: sentry_organizationmember_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationmember
    ADD CONSTRAINT sentry_organizationmember_token_key UNIQUE (token);


--
-- Name: sentry_organizationonboar_organization_id_47e98e05cae29cf3_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationonboardingtask
    ADD CONSTRAINT sentry_organizationonboar_organization_id_47e98e05cae29cf3_uniq UNIQUE (organization_id, task);


--
-- Name: sentry_organizationonboardingtask_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationonboardingtask
    ADD CONSTRAINT sentry_organizationonboardingtask_pkey PRIMARY KEY (id);


--
-- Name: sentry_organizationoption_organization_id_613ac9b501bd6e71_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationoptions
    ADD CONSTRAINT sentry_organizationoption_organization_id_613ac9b501bd6e71_uniq UNIQUE (organization_id, key);


--
-- Name: sentry_organizationoptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationoptions
    ADD CONSTRAINT sentry_organizationoptions_pkey PRIMARY KEY (id);


--
-- Name: sentry_processingissue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_processingissue
    ADD CONSTRAINT sentry_processingissue_pkey PRIMARY KEY (id);


--
-- Name: sentry_processingissue_project_id_4cf2c364095eb2b9_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_processingissue
    ADD CONSTRAINT sentry_processingissue_project_id_4cf2c364095eb2b9_uniq UNIQUE (project_id, checksum, type);


--
-- Name: sentry_project_organization_id_3017a54aeb676236_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_project
    ADD CONSTRAINT sentry_project_organization_id_3017a54aeb676236_uniq UNIQUE (organization_id, slug);


--
-- Name: sentry_project_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_project
    ADD CONSTRAINT sentry_project_pkey PRIMARY KEY (id);


--
-- Name: sentry_projectavatar_file_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectavatar
    ADD CONSTRAINT sentry_projectavatar_file_id_key UNIQUE (file_id);


--
-- Name: sentry_projectavatar_ident_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectavatar
    ADD CONSTRAINT sentry_projectavatar_ident_key UNIQUE (ident);


--
-- Name: sentry_projectavatar_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectavatar
    ADD CONSTRAINT sentry_projectavatar_pkey PRIMARY KEY (id);


--
-- Name: sentry_projectavatar_project_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectavatar
    ADD CONSTRAINT sentry_projectavatar_project_id_key UNIQUE (project_id);


--
-- Name: sentry_projectbookmark_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectbookmark
    ADD CONSTRAINT sentry_projectbookmark_pkey PRIMARY KEY (id);


--
-- Name: sentry_projectbookmark_project_id_450321e77adb9106_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectbookmark
    ADD CONSTRAINT sentry_projectbookmark_project_id_450321e77adb9106_uniq UNIQUE (project_id, user_id);


--
-- Name: sentry_projectcounter_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectcounter
    ADD CONSTRAINT sentry_projectcounter_pkey PRIMARY KEY (id);


--
-- Name: sentry_projectcounter_project_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectcounter
    ADD CONSTRAINT sentry_projectcounter_project_id_key UNIQUE (project_id);


--
-- Name: sentry_projectdsymfile_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectdsymfile
    ADD CONSTRAINT sentry_projectdsymfile_pkey PRIMARY KEY (id);


--
-- Name: sentry_projectdsymfile_project_id_52cf645985146f12_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectdsymfile
    ADD CONSTRAINT sentry_projectdsymfile_project_id_52cf645985146f12_uniq UNIQUE (project_id, uuid);


--
-- Name: sentry_projectintegration_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectintegration
    ADD CONSTRAINT sentry_projectintegration_pkey PRIMARY KEY (id);


--
-- Name: sentry_projectintegration_project_id_b772982487a62fd_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectintegration
    ADD CONSTRAINT sentry_projectintegration_project_id_b772982487a62fd_uniq UNIQUE (project_id, integration_id);


--
-- Name: sentry_projectkey_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectkey
    ADD CONSTRAINT sentry_projectkey_pkey PRIMARY KEY (id);


--
-- Name: sentry_projectkey_public_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectkey
    ADD CONSTRAINT sentry_projectkey_public_key_key UNIQUE (public_key);


--
-- Name: sentry_projectkey_secret_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectkey
    ADD CONSTRAINT sentry_projectkey_secret_key_key UNIQUE (secret_key);


--
-- Name: sentry_projectoptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectoptions
    ADD CONSTRAINT sentry_projectoptions_pkey PRIMARY KEY (id);


--
-- Name: sentry_projectoptions_project_id_2d0b5c5d84cdbe8f_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectoptions
    ADD CONSTRAINT sentry_projectoptions_project_id_2d0b5c5d84cdbe8f_uniq UNIQUE (project_id, key);


--
-- Name: sentry_projectownership_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectownership
    ADD CONSTRAINT sentry_projectownership_pkey PRIMARY KEY (id);


--
-- Name: sentry_projectownership_project_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectownership
    ADD CONSTRAINT sentry_projectownership_project_id_key UNIQUE (project_id);


--
-- Name: sentry_projectplatform_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectplatform
    ADD CONSTRAINT sentry_projectplatform_pkey PRIMARY KEY (id);


--
-- Name: sentry_projectplatform_project_id_4750cc420a30bf84_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectplatform
    ADD CONSTRAINT sentry_projectplatform_project_id_4750cc420a30bf84_uniq UNIQUE (project_id, platform);


--
-- Name: sentry_projectredirect_organization_id_4af3204682f7beca_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectredirect
    ADD CONSTRAINT sentry_projectredirect_organization_id_4af3204682f7beca_uniq UNIQUE (organization_id, redirect_slug);


--
-- Name: sentry_projectredirect_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectredirect
    ADD CONSTRAINT sentry_projectredirect_pkey PRIMARY KEY (id);


--
-- Name: sentry_projectsymcachefile_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectsymcachefile
    ADD CONSTRAINT sentry_projectsymcachefile_pkey PRIMARY KEY (id);


--
-- Name: sentry_projectsymcachefile_project_id_1d82672e636477c9_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectsymcachefile
    ADD CONSTRAINT sentry_projectsymcachefile_project_id_1d82672e636477c9_uniq UNIQUE (project_id, dsym_file_id);


--
-- Name: sentry_projectteam_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectteam
    ADD CONSTRAINT sentry_projectteam_pkey PRIMARY KEY (id);


--
-- Name: sentry_projectteam_project_id_4b99b03421a3c6e9_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectteam
    ADD CONSTRAINT sentry_projectteam_project_id_4b99b03421a3c6e9_uniq UNIQUE (project_id, team_id);


--
-- Name: sentry_pull_request_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_pull_request
    ADD CONSTRAINT sentry_pull_request_pkey PRIMARY KEY (id);


--
-- Name: sentry_pull_request_repository_id_281e60c02c27ae91_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_pull_request
    ADD CONSTRAINT sentry_pull_request_repository_id_281e60c02c27ae91_uniq UNIQUE (repository_id, key);


--
-- Name: sentry_pullrequest_commit_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_pullrequest_commit
    ADD CONSTRAINT sentry_pullrequest_commit_pkey PRIMARY KEY (id);


--
-- Name: sentry_pullrequest_commit_pull_request_id_2247e8c7140cbd07_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_pullrequest_commit
    ADD CONSTRAINT sentry_pullrequest_commit_pull_request_id_2247e8c7140cbd07_uniq UNIQUE (pull_request_id, commit_id);


--
-- Name: sentry_rawevent_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_rawevent
    ADD CONSTRAINT sentry_rawevent_pkey PRIMARY KEY (id);


--
-- Name: sentry_rawevent_project_id_67074d89f7075a2e_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_rawevent
    ADD CONSTRAINT sentry_rawevent_project_id_67074d89f7075a2e_uniq UNIQUE (project_id, event_id);


--
-- Name: sentry_relay_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_relay
    ADD CONSTRAINT sentry_relay_pkey PRIMARY KEY (id);


--
-- Name: sentry_relay_relay_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_relay
    ADD CONSTRAINT sentry_relay_relay_id_key UNIQUE (relay_id);


--
-- Name: sentry_release_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_release
    ADD CONSTRAINT sentry_release_pkey PRIMARY KEY (id);


--
-- Name: sentry_release_project_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_release_project
    ADD CONSTRAINT sentry_release_project_pkey PRIMARY KEY (id);


--
-- Name: sentry_release_project_project_id_35add08b8e678ec7_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_release_project
    ADD CONSTRAINT sentry_release_project_project_id_35add08b8e678ec7_uniq UNIQUE (project_id, release_id);


--
-- Name: sentry_releasecommit_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releasecommit
    ADD CONSTRAINT sentry_releasecommit_pkey PRIMARY KEY (id);


--
-- Name: sentry_releasecommit_release_id_4394bda1d741e954_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releasecommit
    ADD CONSTRAINT sentry_releasecommit_release_id_4394bda1d741e954_uniq UNIQUE (release_id, "order");


--
-- Name: sentry_releasecommit_release_id_4ce87699e8e032b3_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releasecommit
    ADD CONSTRAINT sentry_releasecommit_release_id_4ce87699e8e032b3_uniq UNIQUE (release_id, commit_id);


--
-- Name: sentry_releasefile_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releasefile
    ADD CONSTRAINT sentry_releasefile_pkey PRIMARY KEY (id);


--
-- Name: sentry_releasefile_release_id_7809ae7ca24c9589_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releasefile
    ADD CONSTRAINT sentry_releasefile_release_id_7809ae7ca24c9589_uniq UNIQUE (release_id, ident);


--
-- Name: sentry_releaseheadcommit_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releaseheadcommit
    ADD CONSTRAINT sentry_releaseheadcommit_pkey PRIMARY KEY (id);


--
-- Name: sentry_releaseheadcommit_repository_id_401c869de623265e_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releaseheadcommit
    ADD CONSTRAINT sentry_releaseheadcommit_repository_id_401c869de623265e_uniq UNIQUE (repository_id, release_id);


--
-- Name: sentry_releaseprojectenvironmen_project_id_d2be2f28c78caf7_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releaseprojectenvironment
    ADD CONSTRAINT sentry_releaseprojectenvironmen_project_id_d2be2f28c78caf7_uniq UNIQUE (project_id, release_id, environment_id);


--
-- Name: sentry_releaseprojectenvironment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releaseprojectenvironment
    ADD CONSTRAINT sentry_releaseprojectenvironment_pkey PRIMARY KEY (id);


--
-- Name: sentry_repository_organization_id_2bbb7c67744745b6_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_repository
    ADD CONSTRAINT sentry_repository_organization_id_2bbb7c67744745b6_uniq UNIQUE (organization_id, name);


--
-- Name: sentry_repository_organization_id_6369691ee795aeaf_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_repository
    ADD CONSTRAINT sentry_repository_organization_id_6369691ee795aeaf_uniq UNIQUE (organization_id, provider, external_id);


--
-- Name: sentry_repository_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_repository
    ADD CONSTRAINT sentry_repository_pkey PRIMARY KEY (id);


--
-- Name: sentry_reprocessingreport_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_reprocessingreport
    ADD CONSTRAINT sentry_reprocessingreport_pkey PRIMARY KEY (id);


--
-- Name: sentry_reprocessingreport_project_id_1b8c4565a54fb40e_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_reprocessingreport
    ADD CONSTRAINT sentry_reprocessingreport_project_id_1b8c4565a54fb40e_uniq UNIQUE (project_id, event_id);


--
-- Name: sentry_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_rule
    ADD CONSTRAINT sentry_rule_pkey PRIMARY KEY (id);


--
-- Name: sentry_savedsearch_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_savedsearch
    ADD CONSTRAINT sentry_savedsearch_pkey PRIMARY KEY (id);


--
-- Name: sentry_savedsearch_project_id_4a2cf58e27d0cc59_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_savedsearch
    ADD CONSTRAINT sentry_savedsearch_project_id_4a2cf58e27d0cc59_uniq UNIQUE (project_id, name);


--
-- Name: sentry_savedsearch_userdefault_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_savedsearch_userdefault
    ADD CONSTRAINT sentry_savedsearch_userdefault_pkey PRIMARY KEY (id);


--
-- Name: sentry_savedsearch_userdefault_project_id_19fbb9813d6a20ef_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_savedsearch_userdefault
    ADD CONSTRAINT sentry_savedsearch_userdefault_project_id_19fbb9813d6a20ef_uniq UNIQUE (project_id, user_id);


--
-- Name: sentry_scheduleddeletion_app_label_740edc97d666ad4_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_scheduleddeletion
    ADD CONSTRAINT sentry_scheduleddeletion_app_label_740edc97d666ad4_uniq UNIQUE (app_label, model_name, object_id);


--
-- Name: sentry_scheduleddeletion_guid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_scheduleddeletion
    ADD CONSTRAINT sentry_scheduleddeletion_guid_key UNIQUE (guid);


--
-- Name: sentry_scheduleddeletion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_scheduleddeletion
    ADD CONSTRAINT sentry_scheduleddeletion_pkey PRIMARY KEY (id);


--
-- Name: sentry_scheduledjob_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_scheduledjob
    ADD CONSTRAINT sentry_scheduledjob_pkey PRIMARY KEY (id);


--
-- Name: sentry_servicehook_guid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_servicehook
    ADD CONSTRAINT sentry_servicehook_guid_key UNIQUE (guid);


--
-- Name: sentry_servicehook_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_servicehook
    ADD CONSTRAINT sentry_servicehook_pkey PRIMARY KEY (id);


--
-- Name: sentry_team_organization_id_1e0ece47434a2ed_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_team
    ADD CONSTRAINT sentry_team_organization_id_1e0ece47434a2ed_uniq UNIQUE (organization_id, slug);


--
-- Name: sentry_team_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_team
    ADD CONSTRAINT sentry_team_pkey PRIMARY KEY (id);


--
-- Name: sentry_teamavatar_file_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_teamavatar
    ADD CONSTRAINT sentry_teamavatar_file_id_key UNIQUE (file_id);


--
-- Name: sentry_teamavatar_ident_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_teamavatar
    ADD CONSTRAINT sentry_teamavatar_ident_key UNIQUE (ident);


--
-- Name: sentry_teamavatar_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_teamavatar
    ADD CONSTRAINT sentry_teamavatar_pkey PRIMARY KEY (id);


--
-- Name: sentry_teamavatar_team_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_teamavatar
    ADD CONSTRAINT sentry_teamavatar_team_id_key UNIQUE (team_id);


--
-- Name: sentry_useravatar_file_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_useravatar
    ADD CONSTRAINT sentry_useravatar_file_id_key UNIQUE (file_id);


--
-- Name: sentry_useravatar_ident_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_useravatar
    ADD CONSTRAINT sentry_useravatar_ident_key UNIQUE (ident);


--
-- Name: sentry_useravatar_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_useravatar
    ADD CONSTRAINT sentry_useravatar_pkey PRIMARY KEY (id);


--
-- Name: sentry_useravatar_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_useravatar
    ADD CONSTRAINT sentry_useravatar_user_id_key UNIQUE (user_id);


--
-- Name: sentry_useremail_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_useremail
    ADD CONSTRAINT sentry_useremail_pkey PRIMARY KEY (id);


--
-- Name: sentry_useremail_user_id_469ffbb142507df2_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_useremail
    ADD CONSTRAINT sentry_useremail_user_id_469ffbb142507df2_uniq UNIQUE (user_id, email);


--
-- Name: sentry_userip_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_userip
    ADD CONSTRAINT sentry_userip_pkey PRIMARY KEY (id);


--
-- Name: sentry_userip_user_id_5e5a95a35f9f6063_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_userip
    ADD CONSTRAINT sentry_userip_user_id_5e5a95a35f9f6063_uniq UNIQUE (user_id, ip_address);


--
-- Name: sentry_useroption_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_useroption
    ADD CONSTRAINT sentry_useroption_pkey PRIMARY KEY (id);


--
-- Name: sentry_useroption_user_id_4d4ce0b1f7bb578b_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_useroption
    ADD CONSTRAINT sentry_useroption_user_id_4d4ce0b1f7bb578b_uniq UNIQUE (user_id, project_id, key);


--
-- Name: sentry_useroption_user_id_7d51ec93e4fc570e_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_useroption
    ADD CONSTRAINT sentry_useroption_user_id_7d51ec93e4fc570e_uniq UNIQUE (user_id, organization_id, key);


--
-- Name: sentry_userpermission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_userpermission
    ADD CONSTRAINT sentry_userpermission_pkey PRIMARY KEY (id);


--
-- Name: sentry_userpermission_user_id_2617e7a04f784a10_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_userpermission
    ADD CONSTRAINT sentry_userpermission_user_id_2617e7a04f784a10_uniq UNIQUE (user_id, permission);


--
-- Name: sentry_userreport_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_userreport
    ADD CONSTRAINT sentry_userreport_pkey PRIMARY KEY (id);


--
-- Name: sentry_userreport_project_id_1ac377e052723c91_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_userreport
    ADD CONSTRAINT sentry_userreport_project_id_1ac377e052723c91_uniq UNIQUE (project_id, event_id);


--
-- Name: sentry_versiondsymfile_dsym_file_id_208187f6f9f8d2a6_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_versiondsymfile
    ADD CONSTRAINT sentry_versiondsymfile_dsym_file_id_208187f6f9f8d2a6_uniq UNIQUE (dsym_file_id, version, build);


--
-- Name: sentry_versiondsymfile_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_versiondsymfile
    ADD CONSTRAINT sentry_versiondsymfile_pkey PRIMARY KEY (id);


--
-- Name: social_auth_usersocialauth_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.social_auth_usersocialauth
    ADD CONSTRAINT social_auth_usersocialauth_pkey PRIMARY KEY (id);


--
-- Name: social_auth_usersocialauth_provider_69933d2ea493fc8c_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.social_auth_usersocialauth
    ADD CONSTRAINT social_auth_usersocialauth_provider_69933d2ea493fc8c_uniq UNIQUE (provider, uid, user_id);


--
-- Name: south_migrationhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.south_migrationhistory
    ADD CONSTRAINT south_migrationhistory_pkey PRIMARY KEY (id);


--
-- Name: tagstore_eventtag_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_eventtag
    ADD CONSTRAINT tagstore_eventtag_pkey PRIMARY KEY (id);


--
-- Name: tagstore_eventtag_project_id_be033ea3de90db0_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_eventtag
    ADD CONSTRAINT tagstore_eventtag_project_id_be033ea3de90db0_uniq UNIQUE (project_id, event_id, key_id, value_id);


--
-- Name: tagstore_grouptagkey_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_grouptagkey
    ADD CONSTRAINT tagstore_grouptagkey_pkey PRIMARY KEY (id);


--
-- Name: tagstore_grouptagkey_project_id_704698b8620b6fd2_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_grouptagkey
    ADD CONSTRAINT tagstore_grouptagkey_project_id_704698b8620b6fd2_uniq UNIQUE (project_id, group_id, key_id);


--
-- Name: tagstore_grouptagvalue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_grouptagvalue
    ADD CONSTRAINT tagstore_grouptagvalue_pkey PRIMARY KEY (id);


--
-- Name: tagstore_grouptagvalue_project_id_54aadd1ff1633928_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_grouptagvalue
    ADD CONSTRAINT tagstore_grouptagvalue_project_id_54aadd1ff1633928_uniq UNIQUE (project_id, group_id, key_id, value_id);


--
-- Name: tagstore_tagkey_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_tagkey
    ADD CONSTRAINT tagstore_tagkey_pkey PRIMARY KEY (id);


--
-- Name: tagstore_tagkey_project_id_91aff351fd9ee2b_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_tagkey
    ADD CONSTRAINT tagstore_tagkey_project_id_91aff351fd9ee2b_uniq UNIQUE (project_id, environment_id, key);


--
-- Name: tagstore_tagvalue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_tagvalue
    ADD CONSTRAINT tagstore_tagvalue_pkey PRIMARY KEY (id);


--
-- Name: tagstore_tagvalue_project_id_90bbcbdf6a46fc1_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_tagvalue
    ADD CONSTRAINT tagstore_tagvalue_project_id_90bbcbdf6a46fc1_uniq UNIQUE (project_id, key_id, value);


--
-- Name: auth_authenticator_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_authenticator_user_id ON public.auth_authenticator USING btree (user_id);


--
-- Name: auth_group_name_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_name_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_group_id ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_permission_id ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_permission_content_type_id ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_username_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_username_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_content_type_id ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_user_id ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_expire_date ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_session_key_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: jira_ac_tenant_client_key_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX jira_ac_tenant_client_key_like ON public.jira_ac_tenant USING btree (client_key varchar_pattern_ops);


--
-- Name: jira_ac_tenant_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX jira_ac_tenant_organization_id ON public.jira_ac_tenant USING btree (organization_id);


--
-- Name: nodestore_node_id_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX nodestore_node_id_like ON public.nodestore_node USING btree (id varchar_pattern_ops);


--
-- Name: nodestore_node_timestamp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX nodestore_node_timestamp ON public.nodestore_node USING btree ("timestamp");


--
-- Name: sentry_activity_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_activity_group_id ON public.sentry_activity USING btree (group_id);


--
-- Name: sentry_activity_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_activity_project_id ON public.sentry_activity USING btree (project_id);


--
-- Name: sentry_activity_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_activity_user_id ON public.sentry_activity USING btree (user_id);


--
-- Name: sentry_apiapplication_client_id_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_apiapplication_client_id_like ON public.sentry_apiapplication USING btree (client_id varchar_pattern_ops);


--
-- Name: sentry_apiapplication_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_apiapplication_owner_id ON public.sentry_apiapplication USING btree (owner_id);


--
-- Name: sentry_apiapplication_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_apiapplication_status ON public.sentry_apiapplication USING btree (status);


--
-- Name: sentry_apiauthorization_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_apiauthorization_application_id ON public.sentry_apiauthorization USING btree (application_id);


--
-- Name: sentry_apiauthorization_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_apiauthorization_user_id ON public.sentry_apiauthorization USING btree (user_id);


--
-- Name: sentry_apigrant_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_apigrant_application_id ON public.sentry_apigrant USING btree (application_id);


--
-- Name: sentry_apigrant_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_apigrant_code ON public.sentry_apigrant USING btree (code);


--
-- Name: sentry_apigrant_code_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_apigrant_code_like ON public.sentry_apigrant USING btree (code varchar_pattern_ops);


--
-- Name: sentry_apigrant_expires_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_apigrant_expires_at ON public.sentry_apigrant USING btree (expires_at);


--
-- Name: sentry_apigrant_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_apigrant_user_id ON public.sentry_apigrant USING btree (user_id);


--
-- Name: sentry_apikey_key_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_apikey_key_like ON public.sentry_apikey USING btree (key varchar_pattern_ops);


--
-- Name: sentry_apikey_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_apikey_organization_id ON public.sentry_apikey USING btree (organization_id);


--
-- Name: sentry_apikey_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_apikey_status ON public.sentry_apikey USING btree (status);


--
-- Name: sentry_apitoken_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_apitoken_application_id ON public.sentry_apitoken USING btree (application_id);


--
-- Name: sentry_apitoken_refresh_token_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_apitoken_refresh_token_like ON public.sentry_apitoken USING btree (refresh_token varchar_pattern_ops);


--
-- Name: sentry_apitoken_token_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_apitoken_token_like ON public.sentry_apitoken USING btree (token varchar_pattern_ops);


--
-- Name: sentry_apitoken_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_apitoken_user_id ON public.sentry_apitoken USING btree (user_id);


--
-- Name: sentry_assistant_activity_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_assistant_activity_user_id ON public.sentry_assistant_activity USING btree (user_id);


--
-- Name: sentry_auditlogentry_actor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_auditlogentry_actor_id ON public.sentry_auditlogentry USING btree (actor_id);


--
-- Name: sentry_auditlogentry_actor_key_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_auditlogentry_actor_key_id ON public.sentry_auditlogentry USING btree (actor_key_id);


--
-- Name: sentry_auditlogentry_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_auditlogentry_organization_id ON public.sentry_auditlogentry USING btree (organization_id);


--
-- Name: sentry_auditlogentry_target_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_auditlogentry_target_user_id ON public.sentry_auditlogentry USING btree (target_user_id);


--
-- Name: sentry_authidentity_auth_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_authidentity_auth_provider_id ON public.sentry_authidentity USING btree (auth_provider_id);


--
-- Name: sentry_authidentity_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_authidentity_user_id ON public.sentry_authidentity USING btree (user_id);


--
-- Name: sentry_authprovider_default_teams_authprovider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_authprovider_default_teams_authprovider_id ON public.sentry_authprovider_default_teams USING btree (authprovider_id);


--
-- Name: sentry_authprovider_default_teams_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_authprovider_default_teams_team_id ON public.sentry_authprovider_default_teams USING btree (team_id);


--
-- Name: sentry_broadcast_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_broadcast_is_active ON public.sentry_broadcast USING btree (is_active);


--
-- Name: sentry_broadcastseen_broadcast_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_broadcastseen_broadcast_id ON public.sentry_broadcastseen USING btree (broadcast_id);


--
-- Name: sentry_broadcastseen_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_broadcastseen_user_id ON public.sentry_broadcastseen USING btree (user_id);


--
-- Name: sentry_commit_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_commit_author_id ON public.sentry_commit USING btree (author_id);


--
-- Name: sentry_commit_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_commit_organization_id ON public.sentry_commit USING btree (organization_id);


--
-- Name: sentry_commit_repository_id_5b0d06238a42bbfc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_commit_repository_id_5b0d06238a42bbfc ON public.sentry_commit USING btree (repository_id, date_added);


--
-- Name: sentry_commitauthor_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_commitauthor_organization_id ON public.sentry_commitauthor USING btree (organization_id);


--
-- Name: sentry_commitfilechange_commit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_commitfilechange_commit_id ON public.sentry_commitfilechange USING btree (commit_id);


--
-- Name: sentry_commitfilechange_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_commitfilechange_organization_id ON public.sentry_commitfilechange USING btree (organization_id);


--
-- Name: sentry_deploy_environment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_deploy_environment_id ON public.sentry_deploy USING btree (environment_id);


--
-- Name: sentry_deploy_notified; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_deploy_notified ON public.sentry_deploy USING btree (notified);


--
-- Name: sentry_deploy_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_deploy_organization_id ON public.sentry_deploy USING btree (organization_id);


--
-- Name: sentry_deploy_release_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_deploy_release_id ON public.sentry_deploy USING btree (release_id);


--
-- Name: sentry_distribution_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_distribution_organization_id ON public.sentry_distribution USING btree (organization_id);


--
-- Name: sentry_distribution_release_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_distribution_release_id ON public.sentry_distribution USING btree (release_id);


--
-- Name: sentry_dsymapp_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_dsymapp_project_id ON public.sentry_dsymapp USING btree (project_id);


--
-- Name: sentry_environment_organization_id_6c9098a3d53d6a9a; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX sentry_environment_organization_id_6c9098a3d53d6a9a ON public.sentry_environment USING btree (organization_id, name);


--
-- Name: sentry_environmentproject_environment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_environmentproject_environment_id ON public.sentry_environmentproject USING btree (environment_id);


--
-- Name: sentry_environmentproject_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_environmentproject_project_id ON public.sentry_environmentproject USING btree (project_id);


--
-- Name: sentry_environmentrelease_environment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_environmentrelease_environment_id ON public.sentry_environmentrelease USING btree (environment_id);


--
-- Name: sentry_environmentrelease_last_seen; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_environmentrelease_last_seen ON public.sentry_environmentrelease USING btree (last_seen);


--
-- Name: sentry_environmentrelease_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_environmentrelease_organization_id ON public.sentry_environmentrelease USING btree (organization_id);


--
-- Name: sentry_environmentrelease_organization_id_394c1c5e67253784; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX sentry_environmentrelease_organization_id_394c1c5e67253784 ON public.sentry_environmentrelease USING btree (organization_id, release_id, environment_id);


--
-- Name: sentry_environmentrelease_release_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_environmentrelease_release_id ON public.sentry_environmentrelease USING btree (release_id);


--
-- Name: sentry_eventmapping_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_eventmapping_group_id ON public.sentry_eventmapping USING btree (group_id);


--
-- Name: sentry_eventmapping_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_eventmapping_project_id ON public.sentry_eventmapping USING btree (project_id);


--
-- Name: sentry_eventprocessingissue_processing_issue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_eventprocessingissue_processing_issue_id ON public.sentry_eventprocessingissue USING btree (processing_issue_id);


--
-- Name: sentry_eventprocessingissue_raw_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_eventprocessingissue_raw_event_id ON public.sentry_eventprocessingissue USING btree (raw_event_id);


--
-- Name: sentry_eventtag_date_added; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_eventtag_date_added ON public.sentry_eventtag USING btree (date_added);


--
-- Name: sentry_eventtag_group_id_5ad9abfe8e1fa62b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_eventtag_group_id_5ad9abfe8e1fa62b ON public.sentry_eventtag USING btree (group_id, key_id, value_id);


--
-- Name: sentry_eventuser_date_added; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_eventuser_date_added ON public.sentry_eventuser USING btree (date_added);


--
-- Name: sentry_eventuser_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_eventuser_project_id ON public.sentry_eventuser USING btree (project_id);


--
-- Name: sentry_eventuser_project_id_58b4a7f2595290e6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_eventuser_project_id_58b4a7f2595290e6 ON public.sentry_eventuser USING btree (project_id, ip_address);


--
-- Name: sentry_eventuser_project_id_7684267daffc292f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_eventuser_project_id_7684267daffc292f ON public.sentry_eventuser USING btree (project_id, email);


--
-- Name: sentry_eventuser_project_id_8868307f60b6a92; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_eventuser_project_id_8868307f60b6a92 ON public.sentry_eventuser USING btree (project_id, username);


--
-- Name: sentry_featureadoption_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_featureadoption_organization_id ON public.sentry_featureadoption USING btree (organization_id);


--
-- Name: sentry_file_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_file_blob_id ON public.sentry_file USING btree (blob_id);


--
-- Name: sentry_file_checksum; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_file_checksum ON public.sentry_file USING btree (checksum);


--
-- Name: sentry_file_timestamp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_file_timestamp ON public.sentry_file USING btree ("timestamp");


--
-- Name: sentry_fileblob_checksum_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_fileblob_checksum_like ON public.sentry_fileblob USING btree (checksum varchar_pattern_ops);


--
-- Name: sentry_fileblob_timestamp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_fileblob_timestamp ON public.sentry_fileblob USING btree ("timestamp");


--
-- Name: sentry_fileblobindex_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_fileblobindex_blob_id ON public.sentry_fileblobindex USING btree (blob_id);


--
-- Name: sentry_fileblobindex_file_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_fileblobindex_file_id ON public.sentry_fileblobindex USING btree (file_id);


--
-- Name: sentry_fileblobowner_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_fileblobowner_blob_id ON public.sentry_fileblobowner USING btree (blob_id);


--
-- Name: sentry_fileblobowner_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_fileblobowner_organization_id ON public.sentry_fileblobowner USING btree (organization_id);


--
-- Name: sentry_filterkey_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_filterkey_project_id ON public.sentry_filterkey USING btree (project_id);


--
-- Name: sentry_filtervalue_first_seen; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_filtervalue_first_seen ON public.sentry_filtervalue USING btree (first_seen);


--
-- Name: sentry_filtervalue_last_seen; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_filtervalue_last_seen ON public.sentry_filtervalue USING btree (last_seen);


--
-- Name: sentry_filtervalue_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_filtervalue_project_id ON public.sentry_filtervalue USING btree (project_id);


--
-- Name: sentry_filtervalue_project_id_20cb80e47b504ee6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_filtervalue_project_id_20cb80e47b504ee6 ON public.sentry_filtervalue USING btree (project_id, key, last_seen);


--
-- Name: sentry_filtervalue_project_id_27377f6151fcab56; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_filtervalue_project_id_27377f6151fcab56 ON public.sentry_filtervalue USING btree (project_id, value, last_seen);


--
-- Name: sentry_filtervalue_project_id_2b3fdfeac62987c7; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_filtervalue_project_id_2b3fdfeac62987c7 ON public.sentry_filtervalue USING btree (project_id, value, first_seen);


--
-- Name: sentry_filtervalue_project_id_737632cad2909511; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_filtervalue_project_id_737632cad2909511 ON public.sentry_filtervalue USING btree (project_id, value, times_seen);


--
-- Name: sentry_groupasignee_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupasignee_project_id ON public.sentry_groupasignee USING btree (project_id);


--
-- Name: sentry_groupasignee_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupasignee_team_id ON public.sentry_groupasignee USING btree (team_id);


--
-- Name: sentry_groupasignee_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupasignee_user_id ON public.sentry_groupasignee USING btree (user_id);


--
-- Name: sentry_groupbookmark_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupbookmark_group_id ON public.sentry_groupbookmark USING btree (group_id);


--
-- Name: sentry_groupbookmark_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupbookmark_project_id ON public.sentry_groupbookmark USING btree (project_id);


--
-- Name: sentry_groupbookmark_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupbookmark_user_id ON public.sentry_groupbookmark USING btree (user_id);


--
-- Name: sentry_groupbookmark_user_id_5eedb134f529cf58; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupbookmark_user_id_5eedb134f529cf58 ON public.sentry_groupbookmark USING btree (user_id, group_id);


--
-- Name: sentry_groupcommitresolution_commit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupcommitresolution_commit_id ON public.sentry_groupcommitresolution USING btree (commit_id);


--
-- Name: sentry_groupcommitresolution_datetime; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupcommitresolution_datetime ON public.sentry_groupcommitresolution USING btree (datetime);


--
-- Name: sentry_groupedmessage_active_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupedmessage_active_at ON public.sentry_groupedmessage USING btree (active_at);


--
-- Name: sentry_groupedmessage_first_release_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupedmessage_first_release_id ON public.sentry_groupedmessage USING btree (first_release_id);


--
-- Name: sentry_groupedmessage_first_seen; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupedmessage_first_seen ON public.sentry_groupedmessage USING btree (first_seen);


--
-- Name: sentry_groupedmessage_last_seen; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupedmessage_last_seen ON public.sentry_groupedmessage USING btree (last_seen);


--
-- Name: sentry_groupedmessage_level; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupedmessage_level ON public.sentry_groupedmessage USING btree (level);


--
-- Name: sentry_groupedmessage_logger; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupedmessage_logger ON public.sentry_groupedmessage USING btree (logger);


--
-- Name: sentry_groupedmessage_logger_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupedmessage_logger_like ON public.sentry_groupedmessage USING btree (logger varchar_pattern_ops);


--
-- Name: sentry_groupedmessage_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupedmessage_project_id ON public.sentry_groupedmessage USING btree (project_id);


--
-- Name: sentry_groupedmessage_project_id_31335ae34c8ef983; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupedmessage_project_id_31335ae34c8ef983 ON public.sentry_groupedmessage USING btree (project_id, first_release_id);


--
-- Name: sentry_groupedmessage_resolved_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupedmessage_resolved_at ON public.sentry_groupedmessage USING btree (resolved_at);


--
-- Name: sentry_groupedmessage_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupedmessage_status ON public.sentry_groupedmessage USING btree (status);


--
-- Name: sentry_groupedmessage_times_seen; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupedmessage_times_seen ON public.sentry_groupedmessage USING btree (times_seen);


--
-- Name: sentry_groupedmessage_view; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupedmessage_view ON public.sentry_groupedmessage USING btree (view);


--
-- Name: sentry_groupedmessage_view_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupedmessage_view_like ON public.sentry_groupedmessage USING btree (view varchar_pattern_ops);


--
-- Name: sentry_groupemailthread_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupemailthread_date ON public.sentry_groupemailthread USING btree (date);


--
-- Name: sentry_groupemailthread_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupemailthread_group_id ON public.sentry_groupemailthread USING btree (group_id);


--
-- Name: sentry_groupemailthread_msgid_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupemailthread_msgid_like ON public.sentry_groupemailthread USING btree (msgid varchar_pattern_ops);


--
-- Name: sentry_groupemailthread_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupemailthread_project_id ON public.sentry_groupemailthread USING btree (project_id);


--
-- Name: sentry_groupenvironment_environment_id_602c33c133ccdf18; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupenvironment_environment_id_602c33c133ccdf18 ON public.sentry_groupenvironment USING btree (environment_id, first_release_id);


--
-- Name: sentry_grouphash_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_grouphash_group_id ON public.sentry_grouphash USING btree (group_id);


--
-- Name: sentry_grouphash_group_tombstone_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_grouphash_group_tombstone_id ON public.sentry_grouphash USING btree (group_tombstone_id);


--
-- Name: sentry_grouphash_hash_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_grouphash_hash_like ON public.sentry_grouphash USING btree (hash varchar_pattern_ops);


--
-- Name: sentry_grouphash_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_grouphash_project_id ON public.sentry_grouphash USING btree (project_id);


--
-- Name: sentry_grouphashtombstone_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_grouphashtombstone_deleted_at ON public.sentry_grouphashtombstone USING btree (deleted_at);


--
-- Name: sentry_grouphashtombstone_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_grouphashtombstone_project_id ON public.sentry_grouphashtombstone USING btree (project_id);


--
-- Name: sentry_grouplink_datetime; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_grouplink_datetime ON public.sentry_grouplink USING btree (datetime);


--
-- Name: sentry_grouplink_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_grouplink_project_id ON public.sentry_grouplink USING btree (project_id);


--
-- Name: sentry_groupmeta_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupmeta_group_id ON public.sentry_groupmeta USING btree (group_id);


--
-- Name: sentry_groupredirect_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupredirect_group_id ON public.sentry_groupredirect USING btree (group_id);


--
-- Name: sentry_grouprelease_last_seen; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_grouprelease_last_seen ON public.sentry_grouprelease USING btree (last_seen);


--
-- Name: sentry_grouprelease_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_grouprelease_project_id ON public.sentry_grouprelease USING btree (project_id);


--
-- Name: sentry_grouprelease_release_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_grouprelease_release_id ON public.sentry_grouprelease USING btree (release_id);


--
-- Name: sentry_groupresolution_datetime; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupresolution_datetime ON public.sentry_groupresolution USING btree (datetime);


--
-- Name: sentry_groupresolution_release_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupresolution_release_id ON public.sentry_groupresolution USING btree (release_id);


--
-- Name: sentry_grouprulestatus_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_grouprulestatus_group_id ON public.sentry_grouprulestatus USING btree (group_id);


--
-- Name: sentry_grouprulestatus_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_grouprulestatus_project_id ON public.sentry_grouprulestatus USING btree (project_id);


--
-- Name: sentry_grouprulestatus_rule_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_grouprulestatus_rule_id ON public.sentry_grouprulestatus USING btree (rule_id);


--
-- Name: sentry_groupseen_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupseen_group_id ON public.sentry_groupseen USING btree (group_id);


--
-- Name: sentry_groupseen_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupseen_project_id ON public.sentry_groupseen USING btree (project_id);


--
-- Name: sentry_groupshare_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupshare_project_id ON public.sentry_groupshare USING btree (project_id);


--
-- Name: sentry_groupshare_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupshare_user_id ON public.sentry_groupshare USING btree (user_id);


--
-- Name: sentry_groupshare_uuid_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupshare_uuid_like ON public.sentry_groupshare USING btree (uuid varchar_pattern_ops);


--
-- Name: sentry_groupsubscription_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupsubscription_group_id ON public.sentry_groupsubscription USING btree (group_id);


--
-- Name: sentry_groupsubscription_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupsubscription_project_id ON public.sentry_groupsubscription USING btree (project_id);


--
-- Name: sentry_groupsubscription_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_groupsubscription_user_id ON public.sentry_groupsubscription USING btree (user_id);


--
-- Name: sentry_grouptagkey_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_grouptagkey_group_id ON public.sentry_grouptagkey USING btree (group_id);


--
-- Name: sentry_grouptagkey_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_grouptagkey_project_id ON public.sentry_grouptagkey USING btree (project_id);


--
-- Name: sentry_grouptombstone_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_grouptombstone_project_id ON public.sentry_grouptombstone USING btree (project_id);


--
-- Name: sentry_hipchat_ac_tenant_auth_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_hipchat_ac_tenant_auth_user_id ON public.sentry_hipchat_ac_tenant USING btree (auth_user_id);


--
-- Name: sentry_hipchat_ac_tenant_id_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_hipchat_ac_tenant_id_like ON public.sentry_hipchat_ac_tenant USING btree (id varchar_pattern_ops);


--
-- Name: sentry_hipchat_ac_tenant_organizations_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_hipchat_ac_tenant_organizations_organization_id ON public.sentry_hipchat_ac_tenant_organizations USING btree (organization_id);


--
-- Name: sentry_hipchat_ac_tenant_organizations_tenant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_hipchat_ac_tenant_organizations_tenant_id ON public.sentry_hipchat_ac_tenant_organizations USING btree (tenant_id);


--
-- Name: sentry_hipchat_ac_tenant_organizations_tenant_id_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_hipchat_ac_tenant_organizations_tenant_id_like ON public.sentry_hipchat_ac_tenant_organizations USING btree (tenant_id varchar_pattern_ops);


--
-- Name: sentry_hipchat_ac_tenant_projects_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_hipchat_ac_tenant_projects_project_id ON public.sentry_hipchat_ac_tenant_projects USING btree (project_id);


--
-- Name: sentry_hipchat_ac_tenant_projects_tenant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_hipchat_ac_tenant_projects_tenant_id ON public.sentry_hipchat_ac_tenant_projects USING btree (tenant_id);


--
-- Name: sentry_hipchat_ac_tenant_projects_tenant_id_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_hipchat_ac_tenant_projects_tenant_id_like ON public.sentry_hipchat_ac_tenant_projects USING btree (tenant_id varchar_pattern_ops);


--
-- Name: sentry_identity_idp_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_identity_idp_id ON public.sentry_identity USING btree (idp_id);


--
-- Name: sentry_identity_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_identity_user_id ON public.sentry_identity USING btree (user_id);


--
-- Name: sentry_message_datetime; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_message_datetime ON public.sentry_message USING btree (datetime);


--
-- Name: sentry_message_group_id_5f63ffbd9aac1141; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_message_group_id_5f63ffbd9aac1141 ON public.sentry_message USING btree (group_id, datetime);


--
-- Name: sentry_message_message_id_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_message_message_id_like ON public.sentry_message USING btree (message_id varchar_pattern_ops);


--
-- Name: sentry_message_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_message_project_id ON public.sentry_message USING btree (project_id);


--
-- Name: sentry_messagefiltervalue_first_seen; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_messagefiltervalue_first_seen ON public.sentry_messagefiltervalue USING btree (first_seen);


--
-- Name: sentry_messagefiltervalue_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_messagefiltervalue_group_id ON public.sentry_messagefiltervalue USING btree (group_id);


--
-- Name: sentry_messagefiltervalue_group_id_59490523e6ee451f; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX sentry_messagefiltervalue_group_id_59490523e6ee451f ON public.sentry_messagefiltervalue USING btree (group_id, key, value);


--
-- Name: sentry_messagefiltervalue_last_seen; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_messagefiltervalue_last_seen ON public.sentry_messagefiltervalue USING btree (last_seen);


--
-- Name: sentry_messagefiltervalue_project_id_6852dd47401b2d7d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_messagefiltervalue_project_id_6852dd47401b2d7d ON public.sentry_messagefiltervalue USING btree (project_id, key, value, last_seen);


--
-- Name: sentry_organization_slug_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_organization_slug_like ON public.sentry_organization USING btree (slug varchar_pattern_ops);


--
-- Name: sentry_organizationaccessrequest_member_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_organizationaccessrequest_member_id ON public.sentry_organizationaccessrequest USING btree (member_id);


--
-- Name: sentry_organizationaccessrequest_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_organizationaccessrequest_team_id ON public.sentry_organizationaccessrequest USING btree (team_id);


--
-- Name: sentry_organizationavatar_ident_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_organizationavatar_ident_like ON public.sentry_organizationavatar USING btree (ident varchar_pattern_ops);


--
-- Name: sentry_organizationintegration_default_auth_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_organizationintegration_default_auth_id ON public.sentry_organizationintegration USING btree (default_auth_id);


--
-- Name: sentry_organizationintegration_integration_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_organizationintegration_integration_id ON public.sentry_organizationintegration USING btree (integration_id);


--
-- Name: sentry_organizationintegration_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_organizationintegration_organization_id ON public.sentry_organizationintegration USING btree (organization_id);


--
-- Name: sentry_organizationmember_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_organizationmember_organization_id ON public.sentry_organizationmember USING btree (organization_id);


--
-- Name: sentry_organizationmember_teams_organizationmember_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_organizationmember_teams_organizationmember_id ON public.sentry_organizationmember_teams USING btree (organizationmember_id);


--
-- Name: sentry_organizationmember_teams_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_organizationmember_teams_team_id ON public.sentry_organizationmember_teams USING btree (team_id);


--
-- Name: sentry_organizationmember_token_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_organizationmember_token_like ON public.sentry_organizationmember USING btree (token varchar_pattern_ops);


--
-- Name: sentry_organizationmember_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_organizationmember_user_id ON public.sentry_organizationmember USING btree (user_id);


--
-- Name: sentry_organizationonboardingtask_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_organizationonboardingtask_organization_id ON public.sentry_organizationonboardingtask USING btree (organization_id);


--
-- Name: sentry_organizationonboardingtask_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_organizationonboardingtask_user_id ON public.sentry_organizationonboardingtask USING btree (user_id);


--
-- Name: sentry_organizationoptions_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_organizationoptions_organization_id ON public.sentry_organizationoptions USING btree (organization_id);


--
-- Name: sentry_processingissue_checksum; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_processingissue_checksum ON public.sentry_processingissue USING btree (checksum);


--
-- Name: sentry_processingissue_checksum_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_processingissue_checksum_like ON public.sentry_processingissue USING btree (checksum varchar_pattern_ops);


--
-- Name: sentry_processingissue_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_processingissue_project_id ON public.sentry_processingissue USING btree (project_id);


--
-- Name: sentry_project_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_project_organization_id ON public.sentry_project USING btree (organization_id);


--
-- Name: sentry_project_slug_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_project_slug_like ON public.sentry_project USING btree (slug varchar_pattern_ops);


--
-- Name: sentry_project_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_project_status ON public.sentry_project USING btree (status);


--
-- Name: sentry_projectavatar_ident_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectavatar_ident_like ON public.sentry_projectavatar USING btree (ident varchar_pattern_ops);


--
-- Name: sentry_projectbookmark_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectbookmark_user_id ON public.sentry_projectbookmark USING btree (user_id);


--
-- Name: sentry_projectdsymfile_file_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectdsymfile_file_id ON public.sentry_projectdsymfile USING btree (file_id);


--
-- Name: sentry_projectdsymfile_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectdsymfile_project_id ON public.sentry_projectdsymfile USING btree (project_id);


--
-- Name: sentry_projectintegration_integration_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectintegration_integration_id ON public.sentry_projectintegration USING btree (integration_id);


--
-- Name: sentry_projectintegration_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectintegration_project_id ON public.sentry_projectintegration USING btree (project_id);


--
-- Name: sentry_projectkey_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectkey_project_id ON public.sentry_projectkey USING btree (project_id);


--
-- Name: sentry_projectkey_public_key_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectkey_public_key_like ON public.sentry_projectkey USING btree (public_key varchar_pattern_ops);


--
-- Name: sentry_projectkey_secret_key_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectkey_secret_key_like ON public.sentry_projectkey USING btree (secret_key varchar_pattern_ops);


--
-- Name: sentry_projectkey_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectkey_status ON public.sentry_projectkey USING btree (status);


--
-- Name: sentry_projectoptions_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectoptions_project_id ON public.sentry_projectoptions USING btree (project_id);


--
-- Name: sentry_projectplatform_last_seen; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectplatform_last_seen ON public.sentry_projectplatform USING btree (last_seen);


--
-- Name: sentry_projectredirect_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectredirect_organization_id ON public.sentry_projectredirect USING btree (organization_id);


--
-- Name: sentry_projectredirect_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectredirect_project_id ON public.sentry_projectredirect USING btree (project_id);


--
-- Name: sentry_projectredirect_redirect_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectredirect_redirect_slug ON public.sentry_projectredirect USING btree (redirect_slug);


--
-- Name: sentry_projectredirect_redirect_slug_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectredirect_redirect_slug_like ON public.sentry_projectredirect USING btree (redirect_slug varchar_pattern_ops);


--
-- Name: sentry_projectsymcachefile_cache_file_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectsymcachefile_cache_file_id ON public.sentry_projectsymcachefile USING btree (cache_file_id);


--
-- Name: sentry_projectsymcachefile_dsym_file_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectsymcachefile_dsym_file_id ON public.sentry_projectsymcachefile USING btree (dsym_file_id);


--
-- Name: sentry_projectsymcachefile_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectsymcachefile_project_id ON public.sentry_projectsymcachefile USING btree (project_id);


--
-- Name: sentry_projectteam_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectteam_project_id ON public.sentry_projectteam USING btree (project_id);


--
-- Name: sentry_projectteam_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_projectteam_team_id ON public.sentry_projectteam USING btree (team_id);


--
-- Name: sentry_pull_request_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_pull_request_author_id ON public.sentry_pull_request USING btree (author_id);


--
-- Name: sentry_pull_request_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_pull_request_organization_id ON public.sentry_pull_request USING btree (organization_id);


--
-- Name: sentry_pull_request_repository_id_38520c7bdded6f5a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_pull_request_repository_id_38520c7bdded6f5a ON public.sentry_pull_request USING btree (repository_id, date_added);


--
-- Name: sentry_pullrequest_commit_commit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_pullrequest_commit_commit_id ON public.sentry_pullrequest_commit USING btree (commit_id);


--
-- Name: sentry_pullrequest_commit_pull_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_pullrequest_commit_pull_request_id ON public.sentry_pullrequest_commit USING btree (pull_request_id);


--
-- Name: sentry_rawevent_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_rawevent_project_id ON public.sentry_rawevent USING btree (project_id);


--
-- Name: sentry_relay_relay_id_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_relay_relay_id_like ON public.sentry_relay USING btree (relay_id varchar_pattern_ops);


--
-- Name: sentry_release_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_release_organization_id ON public.sentry_release USING btree (organization_id);


--
-- Name: sentry_release_organization_id_b3241759a1649e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_release_organization_id_b3241759a1649e ON public.sentry_release USING btree (organization_id, (COALESCE(date_released, date_added)));


--
-- Name: sentry_release_organization_id_f0a7ec9ba96de76; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX sentry_release_organization_id_f0a7ec9ba96de76 ON public.sentry_release USING btree (organization_id, version);


--
-- Name: sentry_release_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_release_owner_id ON public.sentry_release USING btree (owner_id);


--
-- Name: sentry_release_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_release_project_id ON public.sentry_release USING btree (project_id);


--
-- Name: sentry_release_project_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_release_project_project_id ON public.sentry_release_project USING btree (project_id);


--
-- Name: sentry_release_project_release_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_release_project_release_id ON public.sentry_release_project USING btree (release_id);


--
-- Name: sentry_releasecommit_commit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_releasecommit_commit_id ON public.sentry_releasecommit USING btree (commit_id);


--
-- Name: sentry_releasecommit_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_releasecommit_organization_id ON public.sentry_releasecommit USING btree (organization_id);


--
-- Name: sentry_releasecommit_release_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_releasecommit_release_id ON public.sentry_releasecommit USING btree (release_id);


--
-- Name: sentry_releasefile_dist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_releasefile_dist_id ON public.sentry_releasefile USING btree (dist_id);


--
-- Name: sentry_releasefile_file_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_releasefile_file_id ON public.sentry_releasefile USING btree (file_id);


--
-- Name: sentry_releasefile_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_releasefile_organization_id ON public.sentry_releasefile USING btree (organization_id);


--
-- Name: sentry_releasefile_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_releasefile_project_id ON public.sentry_releasefile USING btree (project_id);


--
-- Name: sentry_releasefile_release_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_releasefile_release_id ON public.sentry_releasefile USING btree (release_id);


--
-- Name: sentry_releaseheadcommit_commit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_releaseheadcommit_commit_id ON public.sentry_releaseheadcommit USING btree (commit_id);


--
-- Name: sentry_releaseheadcommit_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_releaseheadcommit_organization_id ON public.sentry_releaseheadcommit USING btree (organization_id);


--
-- Name: sentry_releaseheadcommit_release_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_releaseheadcommit_release_id ON public.sentry_releaseheadcommit USING btree (release_id);


--
-- Name: sentry_releaseprojectenvironment_environment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_releaseprojectenvironment_environment_id ON public.sentry_releaseprojectenvironment USING btree (environment_id);


--
-- Name: sentry_releaseprojectenvironment_last_deploy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_releaseprojectenvironment_last_deploy_id ON public.sentry_releaseprojectenvironment USING btree (last_deploy_id);


--
-- Name: sentry_releaseprojectenvironment_last_seen; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_releaseprojectenvironment_last_seen ON public.sentry_releaseprojectenvironment USING btree (last_seen);


--
-- Name: sentry_releaseprojectenvironment_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_releaseprojectenvironment_project_id ON public.sentry_releaseprojectenvironment USING btree (project_id);


--
-- Name: sentry_releaseprojectenvironment_release_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_releaseprojectenvironment_release_id ON public.sentry_releaseprojectenvironment USING btree (release_id);


--
-- Name: sentry_repository_integration_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_repository_integration_id ON public.sentry_repository USING btree (integration_id);


--
-- Name: sentry_repository_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_repository_organization_id ON public.sentry_repository USING btree (organization_id);


--
-- Name: sentry_repository_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_repository_status ON public.sentry_repository USING btree (status);


--
-- Name: sentry_reprocessingreport_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_reprocessingreport_project_id ON public.sentry_reprocessingreport USING btree (project_id);


--
-- Name: sentry_rule_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_rule_project_id ON public.sentry_rule USING btree (project_id);


--
-- Name: sentry_rule_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_rule_status ON public.sentry_rule USING btree (status);


--
-- Name: sentry_savedsearch_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_savedsearch_owner_id ON public.sentry_savedsearch USING btree (owner_id);


--
-- Name: sentry_savedsearch_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_savedsearch_project_id ON public.sentry_savedsearch USING btree (project_id);


--
-- Name: sentry_savedsearch_userdefault_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_savedsearch_userdefault_project_id ON public.sentry_savedsearch_userdefault USING btree (project_id);


--
-- Name: sentry_savedsearch_userdefault_savedsearch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_savedsearch_userdefault_savedsearch_id ON public.sentry_savedsearch_userdefault USING btree (savedsearch_id);


--
-- Name: sentry_savedsearch_userdefault_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_savedsearch_userdefault_user_id ON public.sentry_savedsearch_userdefault USING btree (user_id);


--
-- Name: sentry_scheduleddeletion_guid_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_scheduleddeletion_guid_like ON public.sentry_scheduleddeletion USING btree (guid varchar_pattern_ops);


--
-- Name: sentry_servicehook_actor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_servicehook_actor_id ON public.sentry_servicehook USING btree (actor_id);


--
-- Name: sentry_servicehook_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_servicehook_application_id ON public.sentry_servicehook USING btree (application_id);


--
-- Name: sentry_servicehook_guid_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_servicehook_guid_like ON public.sentry_servicehook USING btree (guid varchar_pattern_ops);


--
-- Name: sentry_servicehook_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_servicehook_project_id ON public.sentry_servicehook USING btree (project_id);


--
-- Name: sentry_servicehook_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_servicehook_status ON public.sentry_servicehook USING btree (status);


--
-- Name: sentry_team_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_team_organization_id ON public.sentry_team USING btree (organization_id);


--
-- Name: sentry_team_slug_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_team_slug_like ON public.sentry_team USING btree (slug varchar_pattern_ops);


--
-- Name: sentry_teamavatar_ident_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_teamavatar_ident_like ON public.sentry_teamavatar USING btree (ident varchar_pattern_ops);


--
-- Name: sentry_useravatar_ident_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_useravatar_ident_like ON public.sentry_useravatar USING btree (ident varchar_pattern_ops);


--
-- Name: sentry_useremail_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_useremail_user_id ON public.sentry_useremail USING btree (user_id);


--
-- Name: sentry_userip_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_userip_user_id ON public.sentry_userip USING btree (user_id);


--
-- Name: sentry_useroption_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_useroption_organization_id ON public.sentry_useroption USING btree (organization_id);


--
-- Name: sentry_useroption_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_useroption_project_id ON public.sentry_useroption USING btree (project_id);


--
-- Name: sentry_useroption_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_useroption_user_id ON public.sentry_useroption USING btree (user_id);


--
-- Name: sentry_userpermission_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_userpermission_user_id ON public.sentry_userpermission USING btree (user_id);


--
-- Name: sentry_userreport_environment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_userreport_environment_id ON public.sentry_userreport USING btree (environment_id);


--
-- Name: sentry_userreport_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_userreport_group_id ON public.sentry_userreport USING btree (group_id);


--
-- Name: sentry_userreport_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_userreport_project_id ON public.sentry_userreport USING btree (project_id);


--
-- Name: sentry_userreport_project_id_1ac377e052723c91; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_userreport_project_id_1ac377e052723c91 ON public.sentry_userreport USING btree (project_id, event_id);


--
-- Name: sentry_userreport_project_id_1c06c9ecc190b2e6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_userreport_project_id_1c06c9ecc190b2e6 ON public.sentry_userreport USING btree (project_id, date_added);


--
-- Name: sentry_versiondsymfile_dsym_app_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_versiondsymfile_dsym_app_id ON public.sentry_versiondsymfile USING btree (dsym_app_id);


--
-- Name: sentry_versiondsymfile_dsym_file_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sentry_versiondsymfile_dsym_file_id ON public.sentry_versiondsymfile USING btree (dsym_file_id);


--
-- Name: social_auth_usersocialauth_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX social_auth_usersocialauth_user_id ON public.social_auth_usersocialauth USING btree (user_id);


--
-- Name: tagstore_eventtag_date_added; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_eventtag_date_added ON public.tagstore_eventtag USING btree (date_added);


--
-- Name: tagstore_eventtag_group_id_49cb2edc39d902d9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_eventtag_group_id_49cb2edc39d902d9 ON public.tagstore_eventtag USING btree (group_id, key_id, value_id);


--
-- Name: tagstore_eventtag_key_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_eventtag_key_id ON public.tagstore_eventtag USING btree (key_id);


--
-- Name: tagstore_eventtag_project_id_3479ea564384cd3f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_eventtag_project_id_3479ea564384cd3f ON public.tagstore_eventtag USING btree (project_id, key_id, value_id);


--
-- Name: tagstore_eventtag_value_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_eventtag_value_id ON public.tagstore_eventtag USING btree (value_id);


--
-- Name: tagstore_grouptagkey_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_grouptagkey_group_id ON public.tagstore_grouptagkey USING btree (group_id);


--
-- Name: tagstore_grouptagkey_key_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_grouptagkey_key_id ON public.tagstore_grouptagkey USING btree (key_id);


--
-- Name: tagstore_grouptagkey_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_grouptagkey_project_id ON public.tagstore_grouptagkey USING btree (project_id);


--
-- Name: tagstore_grouptagvalue_first_seen; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_grouptagvalue_first_seen ON public.tagstore_grouptagvalue USING btree (first_seen);


--
-- Name: tagstore_grouptagvalue_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_grouptagvalue_group_id ON public.tagstore_grouptagvalue USING btree (group_id);


--
-- Name: tagstore_grouptagvalue_key_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_grouptagvalue_key_id ON public.tagstore_grouptagvalue USING btree (key_id);


--
-- Name: tagstore_grouptagvalue_last_seen; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_grouptagvalue_last_seen ON public.tagstore_grouptagvalue USING btree (last_seen);


--
-- Name: tagstore_grouptagvalue_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_grouptagvalue_project_id ON public.tagstore_grouptagvalue USING btree (project_id);


--
-- Name: tagstore_grouptagvalue_project_id_7b2704754ded7e70; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_grouptagvalue_project_id_7b2704754ded7e70 ON public.tagstore_grouptagvalue USING btree (project_id, key_id, value_id, last_seen);


--
-- Name: tagstore_grouptagvalue_value_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_grouptagvalue_value_id ON public.tagstore_grouptagvalue USING btree (value_id);


--
-- Name: tagstore_tagkey_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_tagkey_project_id ON public.tagstore_tagkey USING btree (project_id);


--
-- Name: tagstore_tagvalue_first_seen; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_tagvalue_first_seen ON public.tagstore_tagvalue USING btree (first_seen);


--
-- Name: tagstore_tagvalue_key_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_tagvalue_key_id ON public.tagstore_tagvalue USING btree (key_id);


--
-- Name: tagstore_tagvalue_last_seen; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_tagvalue_last_seen ON public.tagstore_tagvalue USING btree (last_seen);


--
-- Name: tagstore_tagvalue_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_tagvalue_project_id ON public.tagstore_tagvalue USING btree (project_id);


--
-- Name: tagstore_tagvalue_project_id_407ef2b73029a6bc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tagstore_tagvalue_project_id_407ef2b73029a6bc ON public.tagstore_tagvalue USING btree (project_id, key_id, last_seen);


--
-- Name: actor_id_refs_id_cac0f7f5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_auditlogentry
    ADD CONSTRAINT actor_id_refs_id_cac0f7f5 FOREIGN KEY (actor_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: actor_key_id_refs_id_cc2fc30c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_auditlogentry
    ADD CONSTRAINT actor_key_id_refs_id_cc2fc30c FOREIGN KEY (actor_key_id) REFERENCES public.sentry_apikey(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: application_id_refs_id_153d42f0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apitoken
    ADD CONSTRAINT application_id_refs_id_153d42f0 FOREIGN KEY (application_id) REFERENCES public.sentry_apiapplication(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: application_id_refs_id_4607bb14; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apiauthorization
    ADD CONSTRAINT application_id_refs_id_4607bb14 FOREIGN KEY (application_id) REFERENCES public.sentry_apiapplication(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: application_id_refs_id_6d783834; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_servicehook
    ADD CONSTRAINT application_id_refs_id_6d783834 FOREIGN KEY (application_id) REFERENCES public.sentry_apiapplication(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: application_id_refs_id_fe5530d5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apigrant
    ADD CONSTRAINT application_id_refs_id_fe5530d5 FOREIGN KEY (application_id) REFERENCES public.sentry_apiapplication(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_provider_id_refs_id_d9990f1d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_authidentity
    ADD CONSTRAINT auth_provider_id_refs_id_d9990f1d FOREIGN KEY (auth_provider_id) REFERENCES public.sentry_authprovider(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_id_refs_id_615fc607; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_hipchat_ac_tenant
    ADD CONSTRAINT auth_user_id_refs_id_615fc607 FOREIGN KEY (auth_user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: author_id_refs_id_2f962e87; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_commit
    ADD CONSTRAINT author_id_refs_id_2f962e87 FOREIGN KEY (author_id) REFERENCES public.sentry_commitauthor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: author_id_refs_id_532d908e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_pull_request
    ADD CONSTRAINT author_id_refs_id_532d908e FOREIGN KEY (author_id) REFERENCES public.sentry_commitauthor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: authprovider_id_refs_id_9e7068be; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_authprovider_default_teams
    ADD CONSTRAINT authprovider_id_refs_id_9e7068be FOREIGN KEY (authprovider_id) REFERENCES public.sentry_authprovider(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: blob_id_refs_id_5732bcfb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_fileblobindex
    ADD CONSTRAINT blob_id_refs_id_5732bcfb FOREIGN KEY (blob_id) REFERENCES public.sentry_fileblob(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: blob_id_refs_id_912b0028; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_file
    ADD CONSTRAINT blob_id_refs_id_912b0028 FOREIGN KEY (blob_id) REFERENCES public.sentry_fileblob(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: blob_id_refs_id_9196b9eb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_fileblobowner
    ADD CONSTRAINT blob_id_refs_id_9196b9eb FOREIGN KEY (blob_id) REFERENCES public.sentry_fileblob(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: broadcast_id_refs_id_e214087a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_broadcastseen
    ADD CONSTRAINT broadcast_id_refs_id_e214087a FOREIGN KEY (broadcast_id) REFERENCES public.sentry_broadcast(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: cache_file_id_refs_id_7cf3a92b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectsymcachefile
    ADD CONSTRAINT cache_file_id_refs_id_7cf3a92b FOREIGN KEY (cache_file_id) REFERENCES public.sentry_file(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: commit_id_refs_id_2c2583d4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_pullrequest_commit
    ADD CONSTRAINT commit_id_refs_id_2c2583d4 FOREIGN KEY (commit_id) REFERENCES public.sentry_commit(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: commit_id_refs_id_66ff0ace; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releaseheadcommit
    ADD CONSTRAINT commit_id_refs_id_66ff0ace FOREIGN KEY (commit_id) REFERENCES public.sentry_commit(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: commit_id_refs_id_a0857449; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releasecommit
    ADD CONSTRAINT commit_id_refs_id_a0857449 FOREIGN KEY (commit_id) REFERENCES public.sentry_commit(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: commit_id_refs_id_f9a55f94; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_commitfilechange
    ADD CONSTRAINT commit_id_refs_id_f9a55f94 FOREIGN KEY (commit_id) REFERENCES public.sentry_commit(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: content_type_id_refs_id_93d2d1f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT content_type_id_refs_id_93d2d1f8 FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: content_type_id_refs_id_d043b34a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT content_type_id_refs_id_d043b34a FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: dist_id_refs_id_13fab125; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releasefile
    ADD CONSTRAINT dist_id_refs_id_13fab125 FOREIGN KEY (dist_id) REFERENCES public.sentry_distribution(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: dsym_app_id_refs_id_2e9c299e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_versiondsymfile
    ADD CONSTRAINT dsym_app_id_refs_id_2e9c299e FOREIGN KEY (dsym_app_id) REFERENCES public.sentry_dsymapp(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: dsym_file_id_refs_id_a38d7c87; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_versiondsymfile
    ADD CONSTRAINT dsym_file_id_refs_id_a38d7c87 FOREIGN KEY (dsym_file_id) REFERENCES public.sentry_projectdsymfile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: dsym_file_id_refs_id_f03d3b01; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectsymcachefile
    ADD CONSTRAINT dsym_file_id_refs_id_f03d3b01 FOREIGN KEY (dsym_file_id) REFERENCES public.sentry_projectdsymfile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: environment_id_refs_id_29efc909; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releaseprojectenvironment
    ADD CONSTRAINT environment_id_refs_id_29efc909 FOREIGN KEY (environment_id) REFERENCES public.sentry_environment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: environment_id_refs_id_5e0c6443; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_userreport
    ADD CONSTRAINT environment_id_refs_id_5e0c6443 FOREIGN KEY (environment_id) REFERENCES public.sentry_environment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: environment_id_refs_id_ab2491b4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_environmentproject
    ADD CONSTRAINT environment_id_refs_id_ab2491b4 FOREIGN KEY (environment_id) REFERENCES public.sentry_environment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: file_id_refs_id_0c8678bd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_useravatar
    ADD CONSTRAINT file_id_refs_id_0c8678bd FOREIGN KEY (file_id) REFERENCES public.sentry_file(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: file_id_refs_id_2ced8ba5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationavatar
    ADD CONSTRAINT file_id_refs_id_2ced8ba5 FOREIGN KEY (file_id) REFERENCES public.sentry_file(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: file_id_refs_id_3cb3b313; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectavatar
    ADD CONSTRAINT file_id_refs_id_3cb3b313 FOREIGN KEY (file_id) REFERENCES public.sentry_file(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: file_id_refs_id_82747ec9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_fileblobindex
    ADD CONSTRAINT file_id_refs_id_82747ec9 FOREIGN KEY (file_id) REFERENCES public.sentry_file(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: file_id_refs_id_cc76204b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectdsymfile
    ADD CONSTRAINT file_id_refs_id_cc76204b FOREIGN KEY (file_id) REFERENCES public.sentry_file(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: file_id_refs_id_f2752739; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_teamavatar
    ADD CONSTRAINT file_id_refs_id_f2752739 FOREIGN KEY (file_id) REFERENCES public.sentry_file(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: file_id_refs_id_fb71e922; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releasefile
    ADD CONSTRAINT file_id_refs_id_fb71e922 FOREIGN KEY (file_id) REFERENCES public.sentry_file(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: first_release_id_refs_id_d035a570; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupedmessage
    ADD CONSTRAINT first_release_id_refs_id_d035a570 FOREIGN KEY (first_release_id) REFERENCES public.sentry_release(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_09b2694a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupseen
    ADD CONSTRAINT group_id_refs_id_09b2694a FOREIGN KEY (group_id) REFERENCES public.sentry_groupedmessage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_3738447a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupbookmark
    ADD CONSTRAINT group_id_refs_id_3738447a FOREIGN KEY (group_id) REFERENCES public.sentry_groupedmessage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_3c3dd283; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupemailthread
    ADD CONSTRAINT group_id_refs_id_3c3dd283 FOREIGN KEY (group_id) REFERENCES public.sentry_groupedmessage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_45b11130; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupshare
    ADD CONSTRAINT group_id_refs_id_45b11130 FOREIGN KEY (group_id) REFERENCES public.sentry_groupedmessage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_47b32b76; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupasignee
    ADD CONSTRAINT group_id_refs_id_47b32b76 FOREIGN KEY (group_id) REFERENCES public.sentry_groupedmessage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_66981850; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouprulestatus
    ADD CONSTRAINT group_id_refs_id_66981850 FOREIGN KEY (group_id) REFERENCES public.sentry_groupedmessage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_6b3d43d4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_userreport
    ADD CONSTRAINT group_id_refs_id_6b3d43d4 FOREIGN KEY (group_id) REFERENCES public.sentry_groupedmessage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_6dc57728; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupmeta
    ADD CONSTRAINT group_id_refs_id_6dc57728 FOREIGN KEY (group_id) REFERENCES public.sentry_groupedmessage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_7d70660e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupsnooze
    ADD CONSTRAINT group_id_refs_id_7d70660e FOREIGN KEY (group_id) REFERENCES public.sentry_groupedmessage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_901a3390; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupsubscription
    ADD CONSTRAINT group_id_refs_id_901a3390 FOREIGN KEY (group_id) REFERENCES public.sentry_groupedmessage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_9603f6ba; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouphash
    ADD CONSTRAINT group_id_refs_id_9603f6ba FOREIGN KEY (group_id) REFERENCES public.sentry_groupedmessage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_b84d67ec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_activity
    ADD CONSTRAINT group_id_refs_id_b84d67ec FOREIGN KEY (group_id) REFERENCES public.sentry_groupedmessage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_ed32932f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupresolution
    ADD CONSTRAINT group_id_refs_id_ed32932f FOREIGN KEY (group_id) REFERENCES public.sentry_groupedmessage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_f4b32aac; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT group_id_refs_id_f4b32aac FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: idp_id_refs_id_f0c91862; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_identity
    ADD CONSTRAINT idp_id_refs_id_f0c91862 FOREIGN KEY (idp_id) REFERENCES public.sentry_identityprovider(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: integration_id_refs_id_13d343b7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectintegration
    ADD CONSTRAINT integration_id_refs_id_13d343b7 FOREIGN KEY (integration_id) REFERENCES public.sentry_integration(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: integration_id_refs_id_fdcbef56; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationintegration
    ADD CONSTRAINT integration_id_refs_id_fdcbef56 FOREIGN KEY (integration_id) REFERENCES public.sentry_integration(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: key_id_refs_id_06d0d786; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_grouptagvalue
    ADD CONSTRAINT key_id_refs_id_06d0d786 FOREIGN KEY (key_id) REFERENCES public.tagstore_tagkey(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: key_id_refs_id_18e8ae17; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_eventtag
    ADD CONSTRAINT key_id_refs_id_18e8ae17 FOREIGN KEY (key_id) REFERENCES public.tagstore_tagkey(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: key_id_refs_id_3744a25a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_grouptagkey
    ADD CONSTRAINT key_id_refs_id_3744a25a FOREIGN KEY (key_id) REFERENCES public.tagstore_tagkey(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: key_id_refs_id_67de5ca2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_tagvalue
    ADD CONSTRAINT key_id_refs_id_67de5ca2 FOREIGN KEY (key_id) REFERENCES public.tagstore_tagkey(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: member_id_refs_id_7c8ccc01; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationaccessrequest
    ADD CONSTRAINT member_id_refs_id_7c8ccc01 FOREIGN KEY (member_id) REFERENCES public.sentry_organizationmember(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_id_refs_id_2203c68b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationonboardingtask
    ADD CONSTRAINT organization_id_refs_id_2203c68b FOREIGN KEY (organization_id) REFERENCES public.sentry_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_id_refs_id_42dc8e8f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationmember
    ADD CONSTRAINT organization_id_refs_id_42dc8e8f FOREIGN KEY (organization_id) REFERENCES public.sentry_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_id_refs_id_49689eb3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_ac_tenant
    ADD CONSTRAINT organization_id_refs_id_49689eb3 FOREIGN KEY (organization_id) REFERENCES public.sentry_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_id_refs_id_56961afd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_useroption
    ADD CONSTRAINT organization_id_refs_id_56961afd FOREIGN KEY (organization_id) REFERENCES public.sentry_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_id_refs_id_61038a42; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_team
    ADD CONSTRAINT organization_id_refs_id_61038a42 FOREIGN KEY (organization_id) REFERENCES public.sentry_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_id_refs_id_686aff6a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectredirect
    ADD CONSTRAINT organization_id_refs_id_686aff6a FOREIGN KEY (organization_id) REFERENCES public.sentry_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_id_refs_id_6874e5b7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_project
    ADD CONSTRAINT organization_id_refs_id_6874e5b7 FOREIGN KEY (organization_id) REFERENCES public.sentry_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_id_refs_id_6a37632f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_authprovider
    ADD CONSTRAINT organization_id_refs_id_6a37632f FOREIGN KEY (organization_id) REFERENCES public.sentry_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_id_refs_id_83d34346; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationoptions
    ADD CONSTRAINT organization_id_refs_id_83d34346 FOREIGN KEY (organization_id) REFERENCES public.sentry_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_id_refs_id_8fd8a7b0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_fileblobowner
    ADD CONSTRAINT organization_id_refs_id_8fd8a7b0 FOREIGN KEY (organization_id) REFERENCES public.sentry_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_id_refs_id_961ec303; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apikey
    ADD CONSTRAINT organization_id_refs_id_961ec303 FOREIGN KEY (organization_id) REFERENCES public.sentry_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_id_refs_id_ac0fa6a7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationavatar
    ADD CONSTRAINT organization_id_refs_id_ac0fa6a7 FOREIGN KEY (organization_id) REFERENCES public.sentry_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_id_refs_id_af26d69f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_hipchat_ac_tenant_organizations
    ADD CONSTRAINT organization_id_refs_id_af26d69f FOREIGN KEY (organization_id) REFERENCES public.sentry_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_id_refs_id_af8cad03; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationintegration
    ADD CONSTRAINT organization_id_refs_id_af8cad03 FOREIGN KEY (organization_id) REFERENCES public.sentry_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_id_refs_id_ba7f8e42; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_release
    ADD CONSTRAINT organization_id_refs_id_ba7f8e42 FOREIGN KEY (organization_id) REFERENCES public.sentry_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_id_refs_id_e6c64c1d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_featureadoption
    ADD CONSTRAINT organization_id_refs_id_e6c64c1d FOREIGN KEY (organization_id) REFERENCES public.sentry_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_id_refs_id_ef2843cb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releasefile
    ADD CONSTRAINT organization_id_refs_id_ef2843cb FOREIGN KEY (organization_id) REFERENCES public.sentry_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_id_refs_id_f5b1844e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_auditlogentry
    ADD CONSTRAINT organization_id_refs_id_f5b1844e FOREIGN KEY (organization_id) REFERENCES public.sentry_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organizationmember_id_refs_id_878802f4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationmember_teams
    ADD CONSTRAINT organizationmember_id_refs_id_878802f4 FOREIGN KEY (organizationmember_id) REFERENCES public.sentry_organizationmember(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: owner_id_refs_id_65604067; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_release
    ADD CONSTRAINT owner_id_refs_id_65604067 FOREIGN KEY (owner_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: owner_id_refs_id_865787fc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_savedsearch
    ADD CONSTRAINT owner_id_refs_id_865787fc FOREIGN KEY (owner_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: owner_id_refs_id_f68b4574; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apiapplication
    ADD CONSTRAINT owner_id_refs_id_f68b4574 FOREIGN KEY (owner_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: processing_issue_id_refs_id_0df012da; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_eventprocessingissue
    ADD CONSTRAINT processing_issue_id_refs_id_0df012da FOREIGN KEY (processing_issue_id) REFERENCES public.sentry_processingissue(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_09c5b95d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouprulestatus
    ADD CONSTRAINT project_id_refs_id_09c5b95d FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_0c94d99e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_activity
    ADD CONSTRAINT project_id_refs_id_0c94d99e FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_11918af3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_reprocessingreport
    ADD CONSTRAINT project_id_refs_id_11918af3 FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_18390fbc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupbookmark
    ADD CONSTRAINT project_id_refs_id_18390fbc FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_1b5200f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupasignee
    ADD CONSTRAINT project_id_refs_id_1b5200f8 FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_1f17528a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouphashtombstone
    ADD CONSTRAINT project_id_refs_id_1f17528a FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_3a95c5b5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectsymcachefile
    ADD CONSTRAINT project_id_refs_id_3a95c5b5 FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_41efed36; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectintegration
    ADD CONSTRAINT project_id_refs_id_41efed36 FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_4bc1c005; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_savedsearch_userdefault
    ADD CONSTRAINT project_id_refs_id_4bc1c005 FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_58200d0a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectcounter
    ADD CONSTRAINT project_id_refs_id_58200d0a FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_67db0efd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupseen
    ADD CONSTRAINT project_id_refs_id_67db0efd FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_6f0a9434; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouphash
    ADD CONSTRAINT project_id_refs_id_6f0a9434 FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_723e0b3c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_userreport
    ADD CONSTRAINT project_id_refs_id_723e0b3c FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_77344b57; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupedmessage
    ADD CONSTRAINT project_id_refs_id_77344b57 FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_80275d85; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectavatar
    ADD CONSTRAINT project_id_refs_id_80275d85 FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_80894a1c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_release_project
    ADD CONSTRAINT project_id_refs_id_80894a1c FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_8419ea36; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupemailthread
    ADD CONSTRAINT project_id_refs_id_8419ea36 FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_8e12ecf7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouptombstone
    ADD CONSTRAINT project_id_refs_id_8e12ecf7 FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_94d40917; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectdsymfile
    ADD CONSTRAINT project_id_refs_id_94d40917 FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_9b845024; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectoptions
    ADD CONSTRAINT project_id_refs_id_9b845024 FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_a564d25b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupsubscription
    ADD CONSTRAINT project_id_refs_id_a564d25b FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_a7eeaf92; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_hipchat_ac_tenant_projects
    ADD CONSTRAINT project_id_refs_id_a7eeaf92 FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_b18120e7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_savedsearch
    ADD CONSTRAINT project_id_refs_id_b18120e7 FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_bdc0d6eb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_dsymapp
    ADD CONSTRAINT project_id_refs_id_bdc0d6eb FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_c05b2172; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectredirect
    ADD CONSTRAINT project_id_refs_id_c05b2172 FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_c96b69eb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_rule
    ADD CONSTRAINT project_id_refs_id_c96b69eb FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_cf2e01df; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_environmentproject
    ADD CONSTRAINT project_id_refs_id_cf2e01df FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_d3771efc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupshare
    ADD CONSTRAINT project_id_refs_id_d3771efc FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_d849fb4d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_rawevent
    ADD CONSTRAINT project_id_refs_id_d849fb4d FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_dc770857; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releaseprojectenvironment
    ADD CONSTRAINT project_id_refs_id_dc770857 FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_e4d8a857; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectkey
    ADD CONSTRAINT project_id_refs_id_e4d8a857 FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_eb596317; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_useroption
    ADD CONSTRAINT project_id_refs_id_eb596317 FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_f04dda9c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_processingissue
    ADD CONSTRAINT project_id_refs_id_f04dda9c FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_f45bf622; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectownership
    ADD CONSTRAINT project_id_refs_id_f45bf622 FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: project_id_refs_id_f5d7021b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectteam
    ADD CONSTRAINT project_id_refs_id_f5d7021b FOREIGN KEY (project_id) REFERENCES public.sentry_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pull_request_id_refs_id_103d7ab7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_pullrequest_commit
    ADD CONSTRAINT pull_request_id_refs_id_103d7ab7 FOREIGN KEY (pull_request_id) REFERENCES public.sentry_pull_request(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: raw_event_id_refs_id_c533ed8a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_eventprocessingissue
    ADD CONSTRAINT raw_event_id_refs_id_c533ed8a FOREIGN KEY (raw_event_id) REFERENCES public.sentry_rawevent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: release_id_refs_id_056a8a23; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_deploy
    ADD CONSTRAINT release_id_refs_id_056a8a23 FOREIGN KEY (release_id) REFERENCES public.sentry_release(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: release_id_refs_id_0599bf90; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupresolution
    ADD CONSTRAINT release_id_refs_id_0599bf90 FOREIGN KEY (release_id) REFERENCES public.sentry_release(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: release_id_refs_id_26c8c7a0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releasecommit
    ADD CONSTRAINT release_id_refs_id_26c8c7a0 FOREIGN KEY (release_id) REFERENCES public.sentry_release(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: release_id_refs_id_8c214aaf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releasefile
    ADD CONSTRAINT release_id_refs_id_8c214aaf FOREIGN KEY (release_id) REFERENCES public.sentry_release(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: release_id_refs_id_9c5c15c9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releaseprojectenvironment
    ADD CONSTRAINT release_id_refs_id_9c5c15c9 FOREIGN KEY (release_id) REFERENCES public.sentry_release(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: release_id_refs_id_a8524557; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_distribution
    ADD CONSTRAINT release_id_refs_id_a8524557 FOREIGN KEY (release_id) REFERENCES public.sentry_release(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: release_id_refs_id_add4a457; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_release_project
    ADD CONSTRAINT release_id_refs_id_add4a457 FOREIGN KEY (release_id) REFERENCES public.sentry_release(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: release_id_refs_id_b02d8da1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_releaseheadcommit
    ADD CONSTRAINT release_id_refs_id_b02d8da1 FOREIGN KEY (release_id) REFERENCES public.sentry_release(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rule_id_refs_id_39ff91f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_grouprulestatus
    ADD CONSTRAINT rule_id_refs_id_39ff91f8 FOREIGN KEY (rule_id) REFERENCES public.sentry_rule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: savedsearch_id_refs_id_8d85995b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_savedsearch_userdefault
    ADD CONSTRAINT savedsearch_id_refs_id_8d85995b FOREIGN KEY (savedsearch_id) REFERENCES public.sentry_savedsearch(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: target_user_id_refs_id_cac0f7f5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_auditlogentry
    ADD CONSTRAINT target_user_id_refs_id_cac0f7f5 FOREIGN KEY (target_user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: team_id_refs_id_10a85f7b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_authprovider_default_teams
    ADD CONSTRAINT team_id_refs_id_10a85f7b FOREIGN KEY (team_id) REFERENCES public.sentry_team(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: team_id_refs_id_1d6cecd2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectteam
    ADD CONSTRAINT team_id_refs_id_1d6cecd2 FOREIGN KEY (team_id) REFERENCES public.sentry_team(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: team_id_refs_id_25346e15; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_teamavatar
    ADD CONSTRAINT team_id_refs_id_25346e15 FOREIGN KEY (team_id) REFERENCES public.sentry_team(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: team_id_refs_id_5b32ca44; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupasignee
    ADD CONSTRAINT team_id_refs_id_5b32ca44 FOREIGN KEY (team_id) REFERENCES public.sentry_team(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: team_id_refs_id_d98f2858; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationmember_teams
    ADD CONSTRAINT team_id_refs_id_d98f2858 FOREIGN KEY (team_id) REFERENCES public.sentry_team(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: team_id_refs_id_ea6e538b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationaccessrequest
    ADD CONSTRAINT team_id_refs_id_ea6e538b FOREIGN KEY (team_id) REFERENCES public.sentry_team(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tenant_id_refs_id_6c1ae0ea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_hipchat_ac_tenant_projects
    ADD CONSTRAINT tenant_id_refs_id_6c1ae0ea FOREIGN KEY (tenant_id) REFERENCES public.sentry_hipchat_ac_tenant(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tenant_id_refs_id_f26e0c12; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_hipchat_ac_tenant_organizations
    ADD CONSTRAINT tenant_id_refs_id_f26e0c12 FOREIGN KEY (tenant_id) REFERENCES public.sentry_hipchat_ac_tenant(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_05ac45cc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupbookmark
    ADD CONSTRAINT user_id_refs_id_05ac45cc FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_1a689f2e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_useravatar
    ADD CONSTRAINT user_id_refs_id_1a689f2e FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_21a4e278; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_assistant_activity
    ADD CONSTRAINT user_id_refs_id_21a4e278 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_22c181a4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationonboardingtask
    ADD CONSTRAINT user_id_refs_id_22c181a4 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_270b7315; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupseen
    ADD CONSTRAINT user_id_refs_id_270b7315 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_291a5251; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_identity
    ADD CONSTRAINT user_id_refs_id_291a5251 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_32679665; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_projectbookmark
    ADD CONSTRAINT user_id_refs_id_32679665 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_3f7101ca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_savedsearch_userdefault
    ADD CONSTRAINT user_id_refs_id_3f7101ca FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_49d60dc2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_userpermission
    ADD CONSTRAINT user_id_refs_id_49d60dc2 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_5368c652; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apigrant
    ADD CONSTRAINT user_id_refs_id_5368c652 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_55597d94; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apiauthorization
    ADD CONSTRAINT user_id_refs_id_55597d94 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_5d9e5ad9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_broadcastseen
    ADD CONSTRAINT user_id_refs_id_5d9e5ad9 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_6caec40e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_activity
    ADD CONSTRAINT user_id_refs_id_6caec40e FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_73734413; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_useroption
    ADD CONSTRAINT user_id_refs_id_73734413 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_78163ab5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_authidentity
    ADD CONSTRAINT user_id_refs_id_78163ab5 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_78c75ee2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_apitoken
    ADD CONSTRAINT user_id_refs_id_78c75ee2 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_8e85b45f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_authenticator
    ADD CONSTRAINT user_id_refs_id_8e85b45f FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_96273ab1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_userip
    ADD CONSTRAINT user_id_refs_id_96273ab1 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_ae956867; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_useremail
    ADD CONSTRAINT user_id_refs_id_ae956867 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_be455e60; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_organizationmember
    ADD CONSTRAINT user_id_refs_id_be455e60 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_c60bdf9b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_lostpasswordhash
    ADD CONSTRAINT user_id_refs_id_c60bdf9b FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_e6cbdf29; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.social_auth_usersocialauth
    ADD CONSTRAINT user_id_refs_id_e6cbdf29 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_e7ef4954; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupshare
    ADD CONSTRAINT user_id_refs_id_e7ef4954 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_efb4b379; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupsubscription
    ADD CONSTRAINT user_id_refs_id_efb4b379 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_f4dcb8d1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sentry_groupasignee
    ADD CONSTRAINT user_id_refs_id_f4dcb8d1 FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: value_id_refs_id_1e1ecec9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_eventtag
    ADD CONSTRAINT value_id_refs_id_1e1ecec9 FOREIGN KEY (value_id) REFERENCES public.tagstore_tagvalue(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: value_id_refs_id_7d6cb4ac; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tagstore_grouptagvalue
    ADD CONSTRAINT value_id_refs_id_7d6cb4ac FOREIGN KEY (value_id) REFERENCES public.tagstore_tagvalue(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

