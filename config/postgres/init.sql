--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64)
);


ALTER TABLE public.admin_event_entity OWNER TO postgres;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO postgres;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO postgres;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO postgres;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO postgres;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO postgres;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO postgres;

--
-- Name: client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO postgres;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.client_attributes OWNER TO postgres;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO postgres;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO postgres;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO postgres;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO postgres;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO postgres;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO postgres;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO postgres;

--
-- Name: client_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_session (
    id character varying(36) NOT NULL,
    client_id character varying(36),
    redirect_uri character varying(255),
    state character varying(255),
    "timestamp" integer,
    session_id character varying(36),
    auth_method character varying(255),
    realm_id character varying(255),
    auth_user_id character varying(36),
    current_action character varying(36)
);


ALTER TABLE public.client_session OWNER TO postgres;

--
-- Name: client_session_auth_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_session_auth_status (
    authenticator character varying(36) NOT NULL,
    status integer,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_auth_status OWNER TO postgres;

--
-- Name: client_session_note; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_session_note (
    name character varying(255) NOT NULL,
    value character varying(255),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_note OWNER TO postgres;

--
-- Name: client_session_prot_mapper; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_session_prot_mapper (
    protocol_mapper_id character varying(36) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_prot_mapper OWNER TO postgres;

--
-- Name: client_session_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_session_role (
    role_id character varying(255) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_role OWNER TO postgres;

--
-- Name: client_user_session_note; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_user_session_note (
    name character varying(255) NOT NULL,
    value character varying(2048),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_user_session_note OWNER TO postgres;

--
-- Name: component; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO postgres;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(4000)
);


ALTER TABLE public.component_config OWNER TO postgres;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO postgres;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.credential OWNER TO postgres;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO postgres;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO postgres;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO postgres;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255)
);


ALTER TABLE public.event_entity OWNER TO postgres;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024)
);


ALTER TABLE public.fed_user_attribute OWNER TO postgres;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO postgres;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO postgres;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO postgres;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO postgres;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO postgres;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO postgres;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO postgres;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO postgres;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO postgres;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO postgres;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL
);


ALTER TABLE public.identity_provider OWNER TO postgres;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO postgres;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO postgres;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO postgres;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36)
);


ALTER TABLE public.keycloak_group OWNER TO postgres;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO postgres;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO postgres;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL
);


ALTER TABLE public.offline_client_session OWNER TO postgres;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.offline_user_session OWNER TO postgres;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO postgres;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO postgres;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO postgres;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


ALTER TABLE public.realm OWNER TO postgres;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO postgres;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO postgres;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO postgres;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO postgres;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO postgres;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO postgres;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO postgres;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO postgres;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO postgres;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO postgres;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO postgres;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO postgres;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO postgres;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO postgres;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode smallint NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO postgres;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO postgres;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy smallint,
    logic smallint,
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO postgres;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO postgres;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO postgres;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO postgres;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO postgres;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO postgres;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO postgres;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL
);


ALTER TABLE public.user_attribute OWNER TO postgres;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO postgres;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO postgres;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO postgres;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO postgres;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO postgres;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO postgres;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO postgres;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO postgres;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO postgres;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO postgres;

--
-- Name: user_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_session (
    id character varying(36) NOT NULL,
    auth_method character varying(255),
    ip_address character varying(255),
    last_session_refresh integer,
    login_username character varying(255),
    realm_id character varying(255),
    remember_me boolean DEFAULT false NOT NULL,
    started integer,
    user_id character varying(255),
    user_session_state integer,
    broker_session_id character varying(255),
    broker_user_id character varying(255)
);


ALTER TABLE public.user_session OWNER TO postgres;

--
-- Name: user_session_note; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_session_note (
    user_session character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(2048)
);


ALTER TABLE public.user_session_note OWNER TO postgres;

--
-- Name: username_login_failure; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.username_login_failure (
    realm_id character varying(36) NOT NULL,
    username character varying(255) NOT NULL,
    failed_login_not_before integer,
    last_failure bigint,
    last_ip_failure character varying(255),
    num_failures integer
);


ALTER TABLE public.username_login_failure OWNER TO postgres;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO postgres;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
b8d5227d-c91e-4fed-b5ce-cf15a4197f45	2ea30141-5e9b-4044-b4fe-9053cfc4fc33
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
fa755c08-994f-4e08-a85d-84681dd36f93	\N	auth-cookie	e09f66b1-fa27-4fd8-affd-235a04a06fba	77c26107-84ae-477d-8004-89012c00284a	2	10	f	\N	\N
1298d09b-5cb9-497d-8b94-4b455a83dca6	\N	auth-spnego	e09f66b1-fa27-4fd8-affd-235a04a06fba	77c26107-84ae-477d-8004-89012c00284a	3	20	f	\N	\N
4e44df9d-2bb9-4d78-b303-ec0f8f0f9c15	\N	identity-provider-redirector	e09f66b1-fa27-4fd8-affd-235a04a06fba	77c26107-84ae-477d-8004-89012c00284a	2	25	f	\N	\N
ec5a752c-b33b-47d4-a6aa-9ae6efc56732	\N	\N	e09f66b1-fa27-4fd8-affd-235a04a06fba	77c26107-84ae-477d-8004-89012c00284a	2	30	t	4f978e3f-3a77-4926-935e-37757632a914	\N
b5cb227f-054c-463b-b380-e2f12ee65511	\N	auth-username-password-form	e09f66b1-fa27-4fd8-affd-235a04a06fba	4f978e3f-3a77-4926-935e-37757632a914	0	10	f	\N	\N
e51f05a2-be7a-45e2-9ecb-c221978d158f	\N	\N	e09f66b1-fa27-4fd8-affd-235a04a06fba	4f978e3f-3a77-4926-935e-37757632a914	1	20	t	e33f5f81-2bc4-46ee-b1ba-57fc342a9975	\N
6edab91f-4aee-403e-a251-51a9ba09685a	\N	conditional-user-configured	e09f66b1-fa27-4fd8-affd-235a04a06fba	e33f5f81-2bc4-46ee-b1ba-57fc342a9975	0	10	f	\N	\N
5d60b47a-f74d-4442-a163-1fed03359035	\N	auth-otp-form	e09f66b1-fa27-4fd8-affd-235a04a06fba	e33f5f81-2bc4-46ee-b1ba-57fc342a9975	0	20	f	\N	\N
7d2a7812-0e35-43ad-bd32-2150094df3a9	\N	direct-grant-validate-username	e09f66b1-fa27-4fd8-affd-235a04a06fba	887b916f-5a63-4603-b399-494d45e0afe4	0	10	f	\N	\N
647d9f7a-9574-4d62-9869-d55f3e33f273	\N	direct-grant-validate-password	e09f66b1-fa27-4fd8-affd-235a04a06fba	887b916f-5a63-4603-b399-494d45e0afe4	0	20	f	\N	\N
ae36ff15-23c0-4811-9ba5-424b178a59cf	\N	\N	e09f66b1-fa27-4fd8-affd-235a04a06fba	887b916f-5a63-4603-b399-494d45e0afe4	1	30	t	748d6690-c431-48de-9db4-d058e237fdb7	\N
4405092d-54e6-42cc-b009-a97ee91bf42f	\N	conditional-user-configured	e09f66b1-fa27-4fd8-affd-235a04a06fba	748d6690-c431-48de-9db4-d058e237fdb7	0	10	f	\N	\N
7122d04e-e3e0-4494-9e16-090c47008728	\N	direct-grant-validate-otp	e09f66b1-fa27-4fd8-affd-235a04a06fba	748d6690-c431-48de-9db4-d058e237fdb7	0	20	f	\N	\N
0ea40116-e1d0-4e8e-9f0f-0ad38841b7ba	\N	registration-page-form	e09f66b1-fa27-4fd8-affd-235a04a06fba	c80bafd1-ab88-4e34-ab7b-d6937e394379	0	10	t	2868c145-14f2-4ff9-8550-1080efbf3850	\N
7d6606c3-f12b-4b5a-bb0d-bc8931cb4c5b	\N	registration-user-creation	e09f66b1-fa27-4fd8-affd-235a04a06fba	2868c145-14f2-4ff9-8550-1080efbf3850	0	20	f	\N	\N
be9f1693-3874-404a-b925-e6fbfa3c85e9	\N	registration-profile-action	e09f66b1-fa27-4fd8-affd-235a04a06fba	2868c145-14f2-4ff9-8550-1080efbf3850	0	40	f	\N	\N
9ff56b2d-cefd-489c-bbbf-ac6328807c1a	\N	registration-password-action	e09f66b1-fa27-4fd8-affd-235a04a06fba	2868c145-14f2-4ff9-8550-1080efbf3850	0	50	f	\N	\N
e17b298c-0e1d-4378-9713-a9c07317d142	\N	registration-recaptcha-action	e09f66b1-fa27-4fd8-affd-235a04a06fba	2868c145-14f2-4ff9-8550-1080efbf3850	3	60	f	\N	\N
edefd3de-61ef-4a5d-8f96-835d9e25271c	\N	registration-terms-and-conditions	e09f66b1-fa27-4fd8-affd-235a04a06fba	2868c145-14f2-4ff9-8550-1080efbf3850	3	70	f	\N	\N
2038f9b7-ceab-4ef6-ad97-4335552733ee	\N	reset-credentials-choose-user	e09f66b1-fa27-4fd8-affd-235a04a06fba	4d1bc370-774d-4188-93c4-b8d47c5099d1	0	10	f	\N	\N
e7baf6d4-9aa7-4e4c-957e-e78a21bb4bf3	\N	reset-credential-email	e09f66b1-fa27-4fd8-affd-235a04a06fba	4d1bc370-774d-4188-93c4-b8d47c5099d1	0	20	f	\N	\N
fc4803a2-86e4-4261-a9e7-7a54f5597fb3	\N	reset-password	e09f66b1-fa27-4fd8-affd-235a04a06fba	4d1bc370-774d-4188-93c4-b8d47c5099d1	0	30	f	\N	\N
f4eb2cbd-20ff-474b-873c-4ab3721da543	\N	\N	e09f66b1-fa27-4fd8-affd-235a04a06fba	4d1bc370-774d-4188-93c4-b8d47c5099d1	1	40	t	a114bf1b-db2d-42f4-92cb-6e53bebb5aad	\N
d08bb837-446d-482a-89c5-1321c36082bd	\N	conditional-user-configured	e09f66b1-fa27-4fd8-affd-235a04a06fba	a114bf1b-db2d-42f4-92cb-6e53bebb5aad	0	10	f	\N	\N
d478e4eb-49a2-4784-af39-79e2841ef944	\N	reset-otp	e09f66b1-fa27-4fd8-affd-235a04a06fba	a114bf1b-db2d-42f4-92cb-6e53bebb5aad	0	20	f	\N	\N
7cf8b7ef-6cf5-4842-ba40-59ed5839788a	\N	client-secret	e09f66b1-fa27-4fd8-affd-235a04a06fba	c5b5ea41-299e-4d15-a047-6f5838f3e5bf	2	10	f	\N	\N
f35c86ed-7241-4c3c-98ef-9397aec38227	\N	client-jwt	e09f66b1-fa27-4fd8-affd-235a04a06fba	c5b5ea41-299e-4d15-a047-6f5838f3e5bf	2	20	f	\N	\N
2d3740d1-060f-4c54-beae-26f7197e5741	\N	client-secret-jwt	e09f66b1-fa27-4fd8-affd-235a04a06fba	c5b5ea41-299e-4d15-a047-6f5838f3e5bf	2	30	f	\N	\N
71f6a56a-f4f1-41a5-8518-1f0507783119	\N	client-x509	e09f66b1-fa27-4fd8-affd-235a04a06fba	c5b5ea41-299e-4d15-a047-6f5838f3e5bf	2	40	f	\N	\N
66b79618-bd2b-4c36-8249-9236ed38848b	\N	idp-review-profile	e09f66b1-fa27-4fd8-affd-235a04a06fba	be89f577-e977-4232-bfb6-0fc31fa1b600	0	10	f	\N	d8d33d16-e860-497e-bfd8-9144af422e39
a2a77a12-74ec-4283-b924-64f183ae1f9d	\N	\N	e09f66b1-fa27-4fd8-affd-235a04a06fba	be89f577-e977-4232-bfb6-0fc31fa1b600	0	20	t	76da5705-4e3e-4c11-9b33-c78e63272035	\N
f44c8480-8c72-4216-8df9-f7ea9092ce23	\N	idp-create-user-if-unique	e09f66b1-fa27-4fd8-affd-235a04a06fba	76da5705-4e3e-4c11-9b33-c78e63272035	2	10	f	\N	adeda56b-f550-4229-90ec-3e2cccbbd06b
8be7fe3f-ee60-4d8e-960b-133b2dd06ed1	\N	\N	e09f66b1-fa27-4fd8-affd-235a04a06fba	76da5705-4e3e-4c11-9b33-c78e63272035	2	20	t	46123f32-6548-466b-853a-5f6401629f5f	\N
f86322f4-b4d5-4cfa-ac50-ebcf2ebc4c25	\N	idp-confirm-link	e09f66b1-fa27-4fd8-affd-235a04a06fba	46123f32-6548-466b-853a-5f6401629f5f	0	10	f	\N	\N
3c9a138e-6ed8-4fda-9dcc-c336c3f2f4ed	\N	\N	e09f66b1-fa27-4fd8-affd-235a04a06fba	46123f32-6548-466b-853a-5f6401629f5f	0	20	t	67365ad6-8947-49f0-82a0-a8d30dae8beb	\N
a27f90ef-967c-4c21-9876-f6bee7e24564	\N	idp-email-verification	e09f66b1-fa27-4fd8-affd-235a04a06fba	67365ad6-8947-49f0-82a0-a8d30dae8beb	2	10	f	\N	\N
4eed34b8-6e0c-49be-b7df-56c8cb9716d5	\N	\N	e09f66b1-fa27-4fd8-affd-235a04a06fba	67365ad6-8947-49f0-82a0-a8d30dae8beb	2	20	t	3566ae37-5988-43b7-821b-6ee5f18cdfa2	\N
0dee2351-f400-42e4-bd24-d9993a578401	\N	idp-username-password-form	e09f66b1-fa27-4fd8-affd-235a04a06fba	3566ae37-5988-43b7-821b-6ee5f18cdfa2	0	10	f	\N	\N
23cc3c51-9e5f-4b7f-8eb0-d6db9190217e	\N	\N	e09f66b1-fa27-4fd8-affd-235a04a06fba	3566ae37-5988-43b7-821b-6ee5f18cdfa2	1	20	t	891df1f8-4f98-407c-b96a-7ecacf82fb97	\N
04524ae3-d94e-46df-ba07-d61e2771081f	\N	conditional-user-configured	e09f66b1-fa27-4fd8-affd-235a04a06fba	891df1f8-4f98-407c-b96a-7ecacf82fb97	0	10	f	\N	\N
4cf9693e-45a5-40ae-bf64-bde01f6f7263	\N	auth-otp-form	e09f66b1-fa27-4fd8-affd-235a04a06fba	891df1f8-4f98-407c-b96a-7ecacf82fb97	0	20	f	\N	\N
391b0c86-fbb5-48ca-b862-221c846e2c20	\N	http-basic-authenticator	e09f66b1-fa27-4fd8-affd-235a04a06fba	00a89e88-d5aa-4cd7-9596-e27f61277410	0	10	f	\N	\N
deb3bb39-a3a3-42bf-8e9a-72f12d0869dc	\N	docker-http-basic-authenticator	e09f66b1-fa27-4fd8-affd-235a04a06fba	c2b0981c-d5ee-42c3-9d8b-8502f2aee29e	0	10	f	\N	\N
825e4577-54d4-4dcf-ad7e-18c33edf805f	\N	idp-email-verification	d4932c90-8454-4b23-b96a-05444067272e	7e90823d-7d75-43f5-b4da-a162fee5d5ab	2	10	f	\N	\N
e12140fb-064c-4242-a92d-11af888c5e95	\N	\N	d4932c90-8454-4b23-b96a-05444067272e	7e90823d-7d75-43f5-b4da-a162fee5d5ab	2	20	t	18fea180-48a8-471a-865a-a02ae7e3195e	\N
171b7553-236b-482e-8e93-05d4d167df22	\N	conditional-user-configured	d4932c90-8454-4b23-b96a-05444067272e	d528834e-7db5-4ba9-8dab-273cf57a3634	0	10	f	\N	\N
56407a02-a384-4fad-b02b-f50c3a25c1f2	\N	auth-otp-form	d4932c90-8454-4b23-b96a-05444067272e	d528834e-7db5-4ba9-8dab-273cf57a3634	0	20	f	\N	\N
01c4e567-523e-4d6b-8bf3-d74e800fa353	\N	conditional-user-configured	d4932c90-8454-4b23-b96a-05444067272e	3ec749f4-c232-4070-b9da-d60efc6f4571	0	10	f	\N	\N
68927534-b778-47fc-88c5-b590942d7c1c	\N	direct-grant-validate-otp	d4932c90-8454-4b23-b96a-05444067272e	3ec749f4-c232-4070-b9da-d60efc6f4571	0	20	f	\N	\N
e5632148-ffd8-4e9b-bc5d-07ea4ee8af22	\N	conditional-user-configured	d4932c90-8454-4b23-b96a-05444067272e	8856528c-e5d3-4629-b4b9-b942b82aa20e	0	10	f	\N	\N
d03dd6d5-9d48-4ff6-b186-da333776d4cd	\N	auth-otp-form	d4932c90-8454-4b23-b96a-05444067272e	8856528c-e5d3-4629-b4b9-b942b82aa20e	0	20	f	\N	\N
fc31cef5-557c-452c-91b5-53956c4a9745	\N	idp-confirm-link	d4932c90-8454-4b23-b96a-05444067272e	9e99fc60-3f70-468d-8cfa-e5233248148b	0	10	f	\N	\N
8a5dd4a8-87f2-426e-bff5-a62d8ffbee42	\N	\N	d4932c90-8454-4b23-b96a-05444067272e	9e99fc60-3f70-468d-8cfa-e5233248148b	0	20	t	7e90823d-7d75-43f5-b4da-a162fee5d5ab	\N
9f45ea30-209f-411c-8169-22c7bd4579cd	\N	conditional-user-configured	d4932c90-8454-4b23-b96a-05444067272e	0180e439-2366-433a-966d-d11dae5552ad	0	10	f	\N	\N
595190ff-87cd-4828-8ed1-8fe9942bc510	\N	reset-otp	d4932c90-8454-4b23-b96a-05444067272e	0180e439-2366-433a-966d-d11dae5552ad	0	20	f	\N	\N
03d67551-9d36-4ee4-a288-f97574c6cb05	\N	idp-create-user-if-unique	d4932c90-8454-4b23-b96a-05444067272e	d84798af-677f-41d4-98cd-95e79c9bb11b	2	10	f	\N	e159adc4-2b95-47de-aea1-92505ec0fb17
f0f44e9d-2adb-4dc5-b19d-f9659c457fd7	\N	\N	d4932c90-8454-4b23-b96a-05444067272e	d84798af-677f-41d4-98cd-95e79c9bb11b	2	20	t	9e99fc60-3f70-468d-8cfa-e5233248148b	\N
c87a278e-f40a-40b8-9dfc-d98f085bdef8	\N	idp-username-password-form	d4932c90-8454-4b23-b96a-05444067272e	18fea180-48a8-471a-865a-a02ae7e3195e	0	10	f	\N	\N
bb50f40a-9548-4588-87de-1a720d762468	\N	\N	d4932c90-8454-4b23-b96a-05444067272e	18fea180-48a8-471a-865a-a02ae7e3195e	1	20	t	8856528c-e5d3-4629-b4b9-b942b82aa20e	\N
ffd97dc5-885b-4cb6-871a-ceebff80cfce	\N	auth-cookie	d4932c90-8454-4b23-b96a-05444067272e	e556ad24-ce3f-408e-a10c-a6a0e8f3acbe	2	10	f	\N	\N
8bcfe1ff-2cbe-4759-a237-cbbdfebf9c05	\N	auth-spnego	d4932c90-8454-4b23-b96a-05444067272e	e556ad24-ce3f-408e-a10c-a6a0e8f3acbe	3	20	f	\N	\N
8bff487d-10f0-4074-9d89-774a5e9782eb	\N	identity-provider-redirector	d4932c90-8454-4b23-b96a-05444067272e	e556ad24-ce3f-408e-a10c-a6a0e8f3acbe	2	25	f	\N	\N
2370590d-3af5-4bff-a711-00f63d917e9c	\N	\N	d4932c90-8454-4b23-b96a-05444067272e	e556ad24-ce3f-408e-a10c-a6a0e8f3acbe	2	30	t	e9752179-6442-4ae5-9c03-9359cdd210ec	\N
e8e8737d-eaf4-424a-8b6a-4b409efd036b	\N	client-secret	d4932c90-8454-4b23-b96a-05444067272e	2ea22dda-5c83-4b26-a9a8-d6a9092ef53f	2	10	f	\N	\N
6fd6c0e6-4d19-4c83-8ea4-7dd1b4b4e744	\N	client-jwt	d4932c90-8454-4b23-b96a-05444067272e	2ea22dda-5c83-4b26-a9a8-d6a9092ef53f	2	20	f	\N	\N
4f63a838-a90b-4dd7-b9d4-2e3b9a186797	\N	client-secret-jwt	d4932c90-8454-4b23-b96a-05444067272e	2ea22dda-5c83-4b26-a9a8-d6a9092ef53f	2	30	f	\N	\N
942ab443-e21f-42a0-b1d8-222924bd3f56	\N	client-x509	d4932c90-8454-4b23-b96a-05444067272e	2ea22dda-5c83-4b26-a9a8-d6a9092ef53f	2	40	f	\N	\N
ee45663d-cc51-4789-9ebb-40eb54d0429e	\N	direct-grant-validate-username	d4932c90-8454-4b23-b96a-05444067272e	0b41f0c0-1c71-412f-b3af-f7b18989f434	0	10	f	\N	\N
7dab3140-ca70-475d-b948-711dcd5cdb23	\N	direct-grant-validate-password	d4932c90-8454-4b23-b96a-05444067272e	0b41f0c0-1c71-412f-b3af-f7b18989f434	0	20	f	\N	\N
c81862e1-217e-4d03-b294-cb998af72518	\N	\N	d4932c90-8454-4b23-b96a-05444067272e	0b41f0c0-1c71-412f-b3af-f7b18989f434	1	30	t	3ec749f4-c232-4070-b9da-d60efc6f4571	\N
d1ab5fc1-ecde-4c17-a35f-9664d77d874e	\N	docker-http-basic-authenticator	d4932c90-8454-4b23-b96a-05444067272e	a98fa067-75b2-470e-a373-b2d2d0473575	0	10	f	\N	\N
ef9be19d-eeed-40d1-8bac-3baf681f9d44	\N	idp-review-profile	d4932c90-8454-4b23-b96a-05444067272e	d0781c62-8c70-4e10-b931-c3c91778a732	0	10	f	\N	f0757101-8fc6-44f8-b9bc-885279945e7d
092368c8-de85-4e63-ae06-64f0678ec0fa	\N	\N	d4932c90-8454-4b23-b96a-05444067272e	d0781c62-8c70-4e10-b931-c3c91778a732	0	20	t	d84798af-677f-41d4-98cd-95e79c9bb11b	\N
948e5e18-da30-4948-9bc3-0250b6333d19	\N	auth-username-password-form	d4932c90-8454-4b23-b96a-05444067272e	e9752179-6442-4ae5-9c03-9359cdd210ec	0	10	f	\N	\N
0b68e546-0b27-478c-9234-2def20cab21f	\N	\N	d4932c90-8454-4b23-b96a-05444067272e	e9752179-6442-4ae5-9c03-9359cdd210ec	1	20	t	d528834e-7db5-4ba9-8dab-273cf57a3634	\N
8c1e1d2f-9523-4d81-bb9e-80154a574ed7	\N	registration-page-form	d4932c90-8454-4b23-b96a-05444067272e	78fc9289-68c1-42b9-a828-494b48283703	0	10	t	8314a111-516f-4d54-8308-b3e3e6570640	\N
98875afe-e9aa-47b7-a47c-dc06c2bccbf9	\N	registration-user-creation	d4932c90-8454-4b23-b96a-05444067272e	8314a111-516f-4d54-8308-b3e3e6570640	0	20	f	\N	\N
eb2e4e40-55f3-4a94-89a4-3e56f1ec8423	\N	registration-profile-action	d4932c90-8454-4b23-b96a-05444067272e	8314a111-516f-4d54-8308-b3e3e6570640	0	40	f	\N	\N
f2e8b708-9b4d-4a26-beca-5502b6ce3123	\N	registration-password-action	d4932c90-8454-4b23-b96a-05444067272e	8314a111-516f-4d54-8308-b3e3e6570640	0	50	f	\N	\N
08b1ab75-3e90-4a84-a018-e6fec35e9cf2	\N	registration-recaptcha-action	d4932c90-8454-4b23-b96a-05444067272e	8314a111-516f-4d54-8308-b3e3e6570640	3	60	f	\N	\N
9287e220-70d5-47d7-abbd-d8185988321e	\N	reset-credentials-choose-user	d4932c90-8454-4b23-b96a-05444067272e	c19d67f3-76dc-4c23-93fa-f5acd01b4bdc	0	10	f	\N	\N
881b160d-203b-40be-9dde-a981842511ff	\N	reset-credential-email	d4932c90-8454-4b23-b96a-05444067272e	c19d67f3-76dc-4c23-93fa-f5acd01b4bdc	0	20	f	\N	\N
6ed6aaf7-ec08-440b-a46f-27c9d1a693fd	\N	reset-password	d4932c90-8454-4b23-b96a-05444067272e	c19d67f3-76dc-4c23-93fa-f5acd01b4bdc	0	30	f	\N	\N
98a967ba-21b7-4395-a8bf-a90fa1d3e844	\N	\N	d4932c90-8454-4b23-b96a-05444067272e	c19d67f3-76dc-4c23-93fa-f5acd01b4bdc	1	40	t	0180e439-2366-433a-966d-d11dae5552ad	\N
317ec784-77fd-4eab-bd7d-8e6d95e5d824	\N	http-basic-authenticator	d4932c90-8454-4b23-b96a-05444067272e	ea63de81-ea34-447b-b8c5-30c5200de8c8	0	10	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
77c26107-84ae-477d-8004-89012c00284a	browser	browser based authentication	e09f66b1-fa27-4fd8-affd-235a04a06fba	basic-flow	t	t
4f978e3f-3a77-4926-935e-37757632a914	forms	Username, password, otp and other auth forms.	e09f66b1-fa27-4fd8-affd-235a04a06fba	basic-flow	f	t
e33f5f81-2bc4-46ee-b1ba-57fc342a9975	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	e09f66b1-fa27-4fd8-affd-235a04a06fba	basic-flow	f	t
887b916f-5a63-4603-b399-494d45e0afe4	direct grant	OpenID Connect Resource Owner Grant	e09f66b1-fa27-4fd8-affd-235a04a06fba	basic-flow	t	t
748d6690-c431-48de-9db4-d058e237fdb7	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	e09f66b1-fa27-4fd8-affd-235a04a06fba	basic-flow	f	t
c80bafd1-ab88-4e34-ab7b-d6937e394379	registration	registration flow	e09f66b1-fa27-4fd8-affd-235a04a06fba	basic-flow	t	t
2868c145-14f2-4ff9-8550-1080efbf3850	registration form	registration form	e09f66b1-fa27-4fd8-affd-235a04a06fba	form-flow	f	t
4d1bc370-774d-4188-93c4-b8d47c5099d1	reset credentials	Reset credentials for a user if they forgot their password or something	e09f66b1-fa27-4fd8-affd-235a04a06fba	basic-flow	t	t
a114bf1b-db2d-42f4-92cb-6e53bebb5aad	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	e09f66b1-fa27-4fd8-affd-235a04a06fba	basic-flow	f	t
c5b5ea41-299e-4d15-a047-6f5838f3e5bf	clients	Base authentication for clients	e09f66b1-fa27-4fd8-affd-235a04a06fba	client-flow	t	t
be89f577-e977-4232-bfb6-0fc31fa1b600	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	e09f66b1-fa27-4fd8-affd-235a04a06fba	basic-flow	t	t
76da5705-4e3e-4c11-9b33-c78e63272035	User creation or linking	Flow for the existing/non-existing user alternatives	e09f66b1-fa27-4fd8-affd-235a04a06fba	basic-flow	f	t
46123f32-6548-466b-853a-5f6401629f5f	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	e09f66b1-fa27-4fd8-affd-235a04a06fba	basic-flow	f	t
67365ad6-8947-49f0-82a0-a8d30dae8beb	Account verification options	Method with which to verity the existing account	e09f66b1-fa27-4fd8-affd-235a04a06fba	basic-flow	f	t
3566ae37-5988-43b7-821b-6ee5f18cdfa2	Verify Existing Account by Re-authentication	Reauthentication of existing account	e09f66b1-fa27-4fd8-affd-235a04a06fba	basic-flow	f	t
891df1f8-4f98-407c-b96a-7ecacf82fb97	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	e09f66b1-fa27-4fd8-affd-235a04a06fba	basic-flow	f	t
00a89e88-d5aa-4cd7-9596-e27f61277410	saml ecp	SAML ECP Profile Authentication Flow	e09f66b1-fa27-4fd8-affd-235a04a06fba	basic-flow	t	t
c2b0981c-d5ee-42c3-9d8b-8502f2aee29e	docker auth	Used by Docker clients to authenticate against the IDP	e09f66b1-fa27-4fd8-affd-235a04a06fba	basic-flow	t	t
7e90823d-7d75-43f5-b4da-a162fee5d5ab	Account verification options	Method with which to verity the existing account	d4932c90-8454-4b23-b96a-05444067272e	basic-flow	f	t
d528834e-7db5-4ba9-8dab-273cf57a3634	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	d4932c90-8454-4b23-b96a-05444067272e	basic-flow	f	t
3ec749f4-c232-4070-b9da-d60efc6f4571	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	d4932c90-8454-4b23-b96a-05444067272e	basic-flow	f	t
8856528c-e5d3-4629-b4b9-b942b82aa20e	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	d4932c90-8454-4b23-b96a-05444067272e	basic-flow	f	t
9e99fc60-3f70-468d-8cfa-e5233248148b	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	d4932c90-8454-4b23-b96a-05444067272e	basic-flow	f	t
0180e439-2366-433a-966d-d11dae5552ad	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	d4932c90-8454-4b23-b96a-05444067272e	basic-flow	f	t
d84798af-677f-41d4-98cd-95e79c9bb11b	User creation or linking	Flow for the existing/non-existing user alternatives	d4932c90-8454-4b23-b96a-05444067272e	basic-flow	f	t
18fea180-48a8-471a-865a-a02ae7e3195e	Verify Existing Account by Re-authentication	Reauthentication of existing account	d4932c90-8454-4b23-b96a-05444067272e	basic-flow	f	t
e556ad24-ce3f-408e-a10c-a6a0e8f3acbe	browser	browser based authentication	d4932c90-8454-4b23-b96a-05444067272e	basic-flow	t	t
2ea22dda-5c83-4b26-a9a8-d6a9092ef53f	clients	Base authentication for clients	d4932c90-8454-4b23-b96a-05444067272e	client-flow	t	t
0b41f0c0-1c71-412f-b3af-f7b18989f434	direct grant	OpenID Connect Resource Owner Grant	d4932c90-8454-4b23-b96a-05444067272e	basic-flow	t	t
a98fa067-75b2-470e-a373-b2d2d0473575	docker auth	Used by Docker clients to authenticate against the IDP	d4932c90-8454-4b23-b96a-05444067272e	basic-flow	t	t
d0781c62-8c70-4e10-b931-c3c91778a732	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	d4932c90-8454-4b23-b96a-05444067272e	basic-flow	t	t
e9752179-6442-4ae5-9c03-9359cdd210ec	forms	Username, password, otp and other auth forms.	d4932c90-8454-4b23-b96a-05444067272e	basic-flow	f	t
78fc9289-68c1-42b9-a828-494b48283703	registration	registration flow	d4932c90-8454-4b23-b96a-05444067272e	basic-flow	t	t
8314a111-516f-4d54-8308-b3e3e6570640	registration form	registration form	d4932c90-8454-4b23-b96a-05444067272e	form-flow	f	t
c19d67f3-76dc-4c23-93fa-f5acd01b4bdc	reset credentials	Reset credentials for a user if they forgot their password or something	d4932c90-8454-4b23-b96a-05444067272e	basic-flow	t	t
ea63de81-ea34-447b-b8c5-30c5200de8c8	saml ecp	SAML ECP Profile Authentication Flow	d4932c90-8454-4b23-b96a-05444067272e	basic-flow	t	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
d8d33d16-e860-497e-bfd8-9144af422e39	review profile config	e09f66b1-fa27-4fd8-affd-235a04a06fba
adeda56b-f550-4229-90ec-3e2cccbbd06b	create unique user config	e09f66b1-fa27-4fd8-affd-235a04a06fba
e159adc4-2b95-47de-aea1-92505ec0fb17	create unique user config	d4932c90-8454-4b23-b96a-05444067272e
f0757101-8fc6-44f8-b9bc-885279945e7d	review profile config	d4932c90-8454-4b23-b96a-05444067272e
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
adeda56b-f550-4229-90ec-3e2cccbbd06b	false	require.password.update.after.registration
d8d33d16-e860-497e-bfd8-9144af422e39	missing	update.profile.on.first.login
e159adc4-2b95-47de-aea1-92505ec0fb17	false	require.password.update.after.registration
f0757101-8fc6-44f8-b9bc-885279945e7d	missing	update.profile.on.first.login
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
40c35b4b-faec-4a96-befb-88e1049653c3	t	f	master-realm	0	f	\N	\N	t	\N	f	e09f66b1-fa27-4fd8-affd-235a04a06fba	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	e09f66b1-fa27-4fd8-affd-235a04a06fba	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
b32b8e24-6c0c-415c-92de-6602b7e4d1a8	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	e09f66b1-fa27-4fd8-affd-235a04a06fba	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
c791726f-0fb3-4416-bb7b-238beb3ce15a	t	f	broker	0	f	\N	\N	t	\N	f	e09f66b1-fa27-4fd8-affd-235a04a06fba	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
b18471e0-3804-4b98-b391-bf56dd4dc923	t	f	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	e09f66b1-fa27-4fd8-affd-235a04a06fba	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
28179bb5-55b7-4946-bd1c-b41a95dc6d82	t	f	admin-cli	0	t	\N	\N	f	\N	f	e09f66b1-fa27-4fd8-affd-235a04a06fba	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
e0670881-cb89-4f1a-9b84-4d54e5efbeb1	t	f	Calendar-realm	0	f	\N	\N	t	\N	f	e09f66b1-fa27-4fd8-affd-235a04a06fba	\N	0	f	f	Calendar Realm	f	client-secret	\N	\N	\N	t	f	f	f
6eae40bd-bf2a-4118-9659-5673c2ca655e	t	f	account	0	t	\N	/realms/Calendar/account/	f	\N	f	d4932c90-8454-4b23-b96a-05444067272e	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
93709245-2824-46cb-a48c-32cc8a45d4cc	t	f	account-console	0	t	\N	/realms/Calendar/account/	f	\N	f	d4932c90-8454-4b23-b96a-05444067272e	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
f576fa8c-c2b5-4121-9936-0bbd993aa559	t	f	admin-cli	0	t	\N	\N	f	\N	f	d4932c90-8454-4b23-b96a-05444067272e	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
d9a8b9bf-ff5c-46f7-895a-f06aaae0a1dc	t	f	broker	0	f	\N	\N	t	\N	f	d4932c90-8454-4b23-b96a-05444067272e	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	t	t	calendar-client	0	f	Wo9T9nS0ebJbUpVso6wpOGgVluQaqajA		f	http://localhost:3000	f	d4932c90-8454-4b23-b96a-05444067272e	openid-connect	-1	t	f	Calendar Client	t	client-secret	http://localhost:3000		\N	t	t	t	t
0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	f	realm-management	0	f	\N	\N	t	\N	f	d4932c90-8454-4b23-b96a-05444067272e	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
a39f7d32-3924-49d0-8904-bd9e4409411c	t	f	security-admin-console	0	t	\N	/admin/Calendar/console/	f	\N	f	d4932c90-8454-4b23-b96a-05444067272e	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
77d24d30-2ec1-47f9-a758-0826b164cacd	t	t	calendar-api-swagger	0	f	hiTq3F2ALbOiray4ZH4Kq0ON3GVTkHjR		f		f	d4932c90-8454-4b23-b96a-05444067272e	openid-connect	-1	t	f	Swagger Calendar Api	t	client-secret	http://localhost:4000		\N	t	f	t	t
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	t	t	calendar-api	0	f	vTtq8mz0OKiUGLaQWpkNZdpdjLhYPsZ5		f		f	d4932c90-8454-4b23-b96a-05444067272e	openid-connect	-1	t	f	${client_calendar-api}	t	client-secret	http://localhost:4000		\N	t	f	t	t
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	post.logout.redirect.uris	+
b32b8e24-6c0c-415c-92de-6602b7e4d1a8	post.logout.redirect.uris	+
b32b8e24-6c0c-415c-92de-6602b7e4d1a8	pkce.code.challenge.method	S256
b18471e0-3804-4b98-b391-bf56dd4dc923	post.logout.redirect.uris	+
b18471e0-3804-4b98-b391-bf56dd4dc923	pkce.code.challenge.method	S256
6eae40bd-bf2a-4118-9659-5673c2ca655e	post.logout.redirect.uris	+
93709245-2824-46cb-a48c-32cc8a45d4cc	post.logout.redirect.uris	+
93709245-2824-46cb-a48c-32cc8a45d4cc	pkce.code.challenge.method	S256
f576fa8c-c2b5-4121-9936-0bbd993aa559	post.logout.redirect.uris	+
d9a8b9bf-ff5c-46f7-895a-f06aaae0a1dc	post.logout.redirect.uris	+
77d24d30-2ec1-47f9-a758-0826b164cacd	oidc.ciba.grant.enabled	false
77d24d30-2ec1-47f9-a758-0826b164cacd	oauth2.device.authorization.grant.enabled	false
77d24d30-2ec1-47f9-a758-0826b164cacd	client.secret.creation.time	1689929071
77d24d30-2ec1-47f9-a758-0826b164cacd	backchannel.logout.session.required	true
77d24d30-2ec1-47f9-a758-0826b164cacd	backchannel.logout.revoke.offline.tokens	false
77d24d30-2ec1-47f9-a758-0826b164cacd	post.logout.redirect.uris	+
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	oidc.ciba.grant.enabled	false
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	client.secret.creation.time	1689855013
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	backchannel.logout.session.required	true
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	post.logout.redirect.uris	+
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	display.on.consent.screen	false
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	oauth2.device.authorization.grant.enabled	false
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	backchannel.logout.revoke.offline.tokens	false
0df0a01c-66ef-4e56-bcd6-53211c3965b5	post.logout.redirect.uris	+
a39f7d32-3924-49d0-8904-bd9e4409411c	post.logout.redirect.uris	+
a39f7d32-3924-49d0-8904-bd9e4409411c	pkce.code.challenge.method	S256
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	client.secret.creation.time	1690447778
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	oauth2.device.authorization.grant.enabled	false
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	oidc.ciba.grant.enabled	false
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	backchannel.logout.session.required	true
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	backchannel.logout.revoke.offline.tokens	false
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	display.on.consent.screen	false
77d24d30-2ec1-47f9-a758-0826b164cacd	display.on.consent.screen	false
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
3f5ecfed-446a-4a5f-b6d6-6af6fd3a8d9c	offline_access	e09f66b1-fa27-4fd8-affd-235a04a06fba	OpenID Connect built-in scope: offline_access	openid-connect
422b07be-cb79-4b0c-8bba-d6014b71fe48	role_list	e09f66b1-fa27-4fd8-affd-235a04a06fba	SAML role list	saml
db7dde31-c3a8-4aa6-acd3-fc531b3742d6	profile	e09f66b1-fa27-4fd8-affd-235a04a06fba	OpenID Connect built-in scope: profile	openid-connect
ed8664ac-2c9a-4e49-bfe1-d5b2aa754022	email	e09f66b1-fa27-4fd8-affd-235a04a06fba	OpenID Connect built-in scope: email	openid-connect
f219789b-cb94-422d-94c7-4463bd111d9e	address	e09f66b1-fa27-4fd8-affd-235a04a06fba	OpenID Connect built-in scope: address	openid-connect
1c5436b6-bdff-48b6-83f1-765a07732981	phone	e09f66b1-fa27-4fd8-affd-235a04a06fba	OpenID Connect built-in scope: phone	openid-connect
9a4e11a6-822d-4505-8044-a0e89f80b7fb	roles	e09f66b1-fa27-4fd8-affd-235a04a06fba	OpenID Connect scope for add user roles to the access token	openid-connect
095cc82f-d2de-47c6-b73f-686d60c98e02	web-origins	e09f66b1-fa27-4fd8-affd-235a04a06fba	OpenID Connect scope for add allowed web origins to the access token	openid-connect
1e6d5d5e-2134-4fe3-81f2-52d636691235	microprofile-jwt	e09f66b1-fa27-4fd8-affd-235a04a06fba	Microprofile - JWT built-in scope	openid-connect
88ca1fa4-1955-465e-992c-d65d7270cf38	acr	e09f66b1-fa27-4fd8-affd-235a04a06fba	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
305e297a-f075-4140-b9bb-76cd6a18fc70	web-origins	d4932c90-8454-4b23-b96a-05444067272e	OpenID Connect scope for add allowed web origins to the access token	openid-connect
2fa54bc7-079f-44a4-af94-ee9a942a9d36	profile	d4932c90-8454-4b23-b96a-05444067272e	OpenID Connect built-in scope: profile	openid-connect
90129970-b394-4de3-915b-1a3f36d15fee	email	d4932c90-8454-4b23-b96a-05444067272e	OpenID Connect built-in scope: email	openid-connect
ce8950ef-7393-432d-bfec-530811975037	offline_access	d4932c90-8454-4b23-b96a-05444067272e	OpenID Connect built-in scope: offline_access	openid-connect
8f8bd907-7a70-4f0c-8301-2706005267e6	roles	d4932c90-8454-4b23-b96a-05444067272e	OpenID Connect scope for add user roles to the access token	openid-connect
0159a26c-8659-4a5f-942d-674d075adcad	microprofile-jwt	d4932c90-8454-4b23-b96a-05444067272e	Microprofile - JWT built-in scope	openid-connect
cadae9cb-c07d-4eab-bfe1-2b8ce939cd9d	acr	d4932c90-8454-4b23-b96a-05444067272e	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
34667733-3773-424d-aa8d-d23d6573eba8	address	d4932c90-8454-4b23-b96a-05444067272e	OpenID Connect built-in scope: address	openid-connect
f62f28ab-12f7-40af-89ac-54530348e79c	phone	d4932c90-8454-4b23-b96a-05444067272e	OpenID Connect built-in scope: phone	openid-connect
b7b454b7-2cf3-4336-af6e-a3ced9539c70	role_list	d4932c90-8454-4b23-b96a-05444067272e	SAML role list	saml
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
3f5ecfed-446a-4a5f-b6d6-6af6fd3a8d9c	true	display.on.consent.screen
3f5ecfed-446a-4a5f-b6d6-6af6fd3a8d9c	${offlineAccessScopeConsentText}	consent.screen.text
422b07be-cb79-4b0c-8bba-d6014b71fe48	true	display.on.consent.screen
422b07be-cb79-4b0c-8bba-d6014b71fe48	${samlRoleListScopeConsentText}	consent.screen.text
db7dde31-c3a8-4aa6-acd3-fc531b3742d6	true	display.on.consent.screen
db7dde31-c3a8-4aa6-acd3-fc531b3742d6	${profileScopeConsentText}	consent.screen.text
db7dde31-c3a8-4aa6-acd3-fc531b3742d6	true	include.in.token.scope
ed8664ac-2c9a-4e49-bfe1-d5b2aa754022	true	display.on.consent.screen
ed8664ac-2c9a-4e49-bfe1-d5b2aa754022	${emailScopeConsentText}	consent.screen.text
ed8664ac-2c9a-4e49-bfe1-d5b2aa754022	true	include.in.token.scope
f219789b-cb94-422d-94c7-4463bd111d9e	true	display.on.consent.screen
f219789b-cb94-422d-94c7-4463bd111d9e	${addressScopeConsentText}	consent.screen.text
f219789b-cb94-422d-94c7-4463bd111d9e	true	include.in.token.scope
1c5436b6-bdff-48b6-83f1-765a07732981	true	display.on.consent.screen
1c5436b6-bdff-48b6-83f1-765a07732981	${phoneScopeConsentText}	consent.screen.text
1c5436b6-bdff-48b6-83f1-765a07732981	true	include.in.token.scope
9a4e11a6-822d-4505-8044-a0e89f80b7fb	true	display.on.consent.screen
9a4e11a6-822d-4505-8044-a0e89f80b7fb	${rolesScopeConsentText}	consent.screen.text
9a4e11a6-822d-4505-8044-a0e89f80b7fb	false	include.in.token.scope
095cc82f-d2de-47c6-b73f-686d60c98e02	false	display.on.consent.screen
095cc82f-d2de-47c6-b73f-686d60c98e02		consent.screen.text
095cc82f-d2de-47c6-b73f-686d60c98e02	false	include.in.token.scope
1e6d5d5e-2134-4fe3-81f2-52d636691235	false	display.on.consent.screen
1e6d5d5e-2134-4fe3-81f2-52d636691235	true	include.in.token.scope
88ca1fa4-1955-465e-992c-d65d7270cf38	false	display.on.consent.screen
88ca1fa4-1955-465e-992c-d65d7270cf38	false	include.in.token.scope
305e297a-f075-4140-b9bb-76cd6a18fc70	false	include.in.token.scope
305e297a-f075-4140-b9bb-76cd6a18fc70	false	display.on.consent.screen
305e297a-f075-4140-b9bb-76cd6a18fc70		consent.screen.text
2fa54bc7-079f-44a4-af94-ee9a942a9d36	true	include.in.token.scope
2fa54bc7-079f-44a4-af94-ee9a942a9d36	true	display.on.consent.screen
2fa54bc7-079f-44a4-af94-ee9a942a9d36	${profileScopeConsentText}	consent.screen.text
90129970-b394-4de3-915b-1a3f36d15fee	true	include.in.token.scope
90129970-b394-4de3-915b-1a3f36d15fee	true	display.on.consent.screen
90129970-b394-4de3-915b-1a3f36d15fee	${emailScopeConsentText}	consent.screen.text
ce8950ef-7393-432d-bfec-530811975037	${offlineAccessScopeConsentText}	consent.screen.text
ce8950ef-7393-432d-bfec-530811975037	true	display.on.consent.screen
8f8bd907-7a70-4f0c-8301-2706005267e6	true	display.on.consent.screen
8f8bd907-7a70-4f0c-8301-2706005267e6	${rolesScopeConsentText}	consent.screen.text
0159a26c-8659-4a5f-942d-674d075adcad	true	include.in.token.scope
0159a26c-8659-4a5f-942d-674d075adcad	false	display.on.consent.screen
cadae9cb-c07d-4eab-bfe1-2b8ce939cd9d	false	include.in.token.scope
cadae9cb-c07d-4eab-bfe1-2b8ce939cd9d	false	display.on.consent.screen
34667733-3773-424d-aa8d-d23d6573eba8	true	include.in.token.scope
34667733-3773-424d-aa8d-d23d6573eba8	true	display.on.consent.screen
34667733-3773-424d-aa8d-d23d6573eba8	${addressScopeConsentText}	consent.screen.text
f62f28ab-12f7-40af-89ac-54530348e79c	true	include.in.token.scope
f62f28ab-12f7-40af-89ac-54530348e79c	true	display.on.consent.screen
f62f28ab-12f7-40af-89ac-54530348e79c	${phoneScopeConsentText}	consent.screen.text
b7b454b7-2cf3-4336-af6e-a3ced9539c70	${samlRoleListScopeConsentText}	consent.screen.text
b7b454b7-2cf3-4336-af6e-a3ced9539c70	true	display.on.consent.screen
8f8bd907-7a70-4f0c-8301-2706005267e6		gui.order
8f8bd907-7a70-4f0c-8301-2706005267e6	false	include.in.token.scope
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	ed8664ac-2c9a-4e49-bfe1-d5b2aa754022	t
0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	095cc82f-d2de-47c6-b73f-686d60c98e02	t
0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	9a4e11a6-822d-4505-8044-a0e89f80b7fb	t
0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	db7dde31-c3a8-4aa6-acd3-fc531b3742d6	t
0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	88ca1fa4-1955-465e-992c-d65d7270cf38	t
0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	f219789b-cb94-422d-94c7-4463bd111d9e	f
0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	3f5ecfed-446a-4a5f-b6d6-6af6fd3a8d9c	f
0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	1c5436b6-bdff-48b6-83f1-765a07732981	f
0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	1e6d5d5e-2134-4fe3-81f2-52d636691235	f
b32b8e24-6c0c-415c-92de-6602b7e4d1a8	ed8664ac-2c9a-4e49-bfe1-d5b2aa754022	t
b32b8e24-6c0c-415c-92de-6602b7e4d1a8	095cc82f-d2de-47c6-b73f-686d60c98e02	t
b32b8e24-6c0c-415c-92de-6602b7e4d1a8	9a4e11a6-822d-4505-8044-a0e89f80b7fb	t
b32b8e24-6c0c-415c-92de-6602b7e4d1a8	db7dde31-c3a8-4aa6-acd3-fc531b3742d6	t
b32b8e24-6c0c-415c-92de-6602b7e4d1a8	88ca1fa4-1955-465e-992c-d65d7270cf38	t
b32b8e24-6c0c-415c-92de-6602b7e4d1a8	f219789b-cb94-422d-94c7-4463bd111d9e	f
b32b8e24-6c0c-415c-92de-6602b7e4d1a8	3f5ecfed-446a-4a5f-b6d6-6af6fd3a8d9c	f
b32b8e24-6c0c-415c-92de-6602b7e4d1a8	1c5436b6-bdff-48b6-83f1-765a07732981	f
b32b8e24-6c0c-415c-92de-6602b7e4d1a8	1e6d5d5e-2134-4fe3-81f2-52d636691235	f
28179bb5-55b7-4946-bd1c-b41a95dc6d82	ed8664ac-2c9a-4e49-bfe1-d5b2aa754022	t
28179bb5-55b7-4946-bd1c-b41a95dc6d82	095cc82f-d2de-47c6-b73f-686d60c98e02	t
28179bb5-55b7-4946-bd1c-b41a95dc6d82	9a4e11a6-822d-4505-8044-a0e89f80b7fb	t
28179bb5-55b7-4946-bd1c-b41a95dc6d82	db7dde31-c3a8-4aa6-acd3-fc531b3742d6	t
28179bb5-55b7-4946-bd1c-b41a95dc6d82	88ca1fa4-1955-465e-992c-d65d7270cf38	t
28179bb5-55b7-4946-bd1c-b41a95dc6d82	f219789b-cb94-422d-94c7-4463bd111d9e	f
28179bb5-55b7-4946-bd1c-b41a95dc6d82	3f5ecfed-446a-4a5f-b6d6-6af6fd3a8d9c	f
28179bb5-55b7-4946-bd1c-b41a95dc6d82	1c5436b6-bdff-48b6-83f1-765a07732981	f
28179bb5-55b7-4946-bd1c-b41a95dc6d82	1e6d5d5e-2134-4fe3-81f2-52d636691235	f
c791726f-0fb3-4416-bb7b-238beb3ce15a	ed8664ac-2c9a-4e49-bfe1-d5b2aa754022	t
c791726f-0fb3-4416-bb7b-238beb3ce15a	095cc82f-d2de-47c6-b73f-686d60c98e02	t
c791726f-0fb3-4416-bb7b-238beb3ce15a	9a4e11a6-822d-4505-8044-a0e89f80b7fb	t
c791726f-0fb3-4416-bb7b-238beb3ce15a	db7dde31-c3a8-4aa6-acd3-fc531b3742d6	t
c791726f-0fb3-4416-bb7b-238beb3ce15a	88ca1fa4-1955-465e-992c-d65d7270cf38	t
c791726f-0fb3-4416-bb7b-238beb3ce15a	f219789b-cb94-422d-94c7-4463bd111d9e	f
c791726f-0fb3-4416-bb7b-238beb3ce15a	3f5ecfed-446a-4a5f-b6d6-6af6fd3a8d9c	f
c791726f-0fb3-4416-bb7b-238beb3ce15a	1c5436b6-bdff-48b6-83f1-765a07732981	f
c791726f-0fb3-4416-bb7b-238beb3ce15a	1e6d5d5e-2134-4fe3-81f2-52d636691235	f
40c35b4b-faec-4a96-befb-88e1049653c3	ed8664ac-2c9a-4e49-bfe1-d5b2aa754022	t
40c35b4b-faec-4a96-befb-88e1049653c3	095cc82f-d2de-47c6-b73f-686d60c98e02	t
40c35b4b-faec-4a96-befb-88e1049653c3	9a4e11a6-822d-4505-8044-a0e89f80b7fb	t
40c35b4b-faec-4a96-befb-88e1049653c3	db7dde31-c3a8-4aa6-acd3-fc531b3742d6	t
40c35b4b-faec-4a96-befb-88e1049653c3	88ca1fa4-1955-465e-992c-d65d7270cf38	t
40c35b4b-faec-4a96-befb-88e1049653c3	f219789b-cb94-422d-94c7-4463bd111d9e	f
40c35b4b-faec-4a96-befb-88e1049653c3	3f5ecfed-446a-4a5f-b6d6-6af6fd3a8d9c	f
40c35b4b-faec-4a96-befb-88e1049653c3	1c5436b6-bdff-48b6-83f1-765a07732981	f
40c35b4b-faec-4a96-befb-88e1049653c3	1e6d5d5e-2134-4fe3-81f2-52d636691235	f
b18471e0-3804-4b98-b391-bf56dd4dc923	ed8664ac-2c9a-4e49-bfe1-d5b2aa754022	t
b18471e0-3804-4b98-b391-bf56dd4dc923	095cc82f-d2de-47c6-b73f-686d60c98e02	t
b18471e0-3804-4b98-b391-bf56dd4dc923	9a4e11a6-822d-4505-8044-a0e89f80b7fb	t
b18471e0-3804-4b98-b391-bf56dd4dc923	db7dde31-c3a8-4aa6-acd3-fc531b3742d6	t
b18471e0-3804-4b98-b391-bf56dd4dc923	88ca1fa4-1955-465e-992c-d65d7270cf38	t
b18471e0-3804-4b98-b391-bf56dd4dc923	f219789b-cb94-422d-94c7-4463bd111d9e	f
b18471e0-3804-4b98-b391-bf56dd4dc923	3f5ecfed-446a-4a5f-b6d6-6af6fd3a8d9c	f
b18471e0-3804-4b98-b391-bf56dd4dc923	1c5436b6-bdff-48b6-83f1-765a07732981	f
b18471e0-3804-4b98-b391-bf56dd4dc923	1e6d5d5e-2134-4fe3-81f2-52d636691235	f
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	305e297a-f075-4140-b9bb-76cd6a18fc70	t
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	2fa54bc7-079f-44a4-af94-ee9a942a9d36	t
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	90129970-b394-4de3-915b-1a3f36d15fee	t
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	8f8bd907-7a70-4f0c-8301-2706005267e6	t
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	cadae9cb-c07d-4eab-bfe1-2b8ce939cd9d	t
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	ce8950ef-7393-432d-bfec-530811975037	f
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	0159a26c-8659-4a5f-942d-674d075adcad	f
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	34667733-3773-424d-aa8d-d23d6573eba8	f
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	f62f28ab-12f7-40af-89ac-54530348e79c	f
6eae40bd-bf2a-4118-9659-5673c2ca655e	305e297a-f075-4140-b9bb-76cd6a18fc70	t
6eae40bd-bf2a-4118-9659-5673c2ca655e	cadae9cb-c07d-4eab-bfe1-2b8ce939cd9d	t
6eae40bd-bf2a-4118-9659-5673c2ca655e	2fa54bc7-079f-44a4-af94-ee9a942a9d36	t
6eae40bd-bf2a-4118-9659-5673c2ca655e	8f8bd907-7a70-4f0c-8301-2706005267e6	t
6eae40bd-bf2a-4118-9659-5673c2ca655e	90129970-b394-4de3-915b-1a3f36d15fee	t
6eae40bd-bf2a-4118-9659-5673c2ca655e	34667733-3773-424d-aa8d-d23d6573eba8	f
6eae40bd-bf2a-4118-9659-5673c2ca655e	f62f28ab-12f7-40af-89ac-54530348e79c	f
6eae40bd-bf2a-4118-9659-5673c2ca655e	ce8950ef-7393-432d-bfec-530811975037	f
6eae40bd-bf2a-4118-9659-5673c2ca655e	0159a26c-8659-4a5f-942d-674d075adcad	f
93709245-2824-46cb-a48c-32cc8a45d4cc	305e297a-f075-4140-b9bb-76cd6a18fc70	t
93709245-2824-46cb-a48c-32cc8a45d4cc	cadae9cb-c07d-4eab-bfe1-2b8ce939cd9d	t
93709245-2824-46cb-a48c-32cc8a45d4cc	2fa54bc7-079f-44a4-af94-ee9a942a9d36	t
93709245-2824-46cb-a48c-32cc8a45d4cc	8f8bd907-7a70-4f0c-8301-2706005267e6	t
93709245-2824-46cb-a48c-32cc8a45d4cc	90129970-b394-4de3-915b-1a3f36d15fee	t
93709245-2824-46cb-a48c-32cc8a45d4cc	34667733-3773-424d-aa8d-d23d6573eba8	f
93709245-2824-46cb-a48c-32cc8a45d4cc	f62f28ab-12f7-40af-89ac-54530348e79c	f
93709245-2824-46cb-a48c-32cc8a45d4cc	ce8950ef-7393-432d-bfec-530811975037	f
93709245-2824-46cb-a48c-32cc8a45d4cc	0159a26c-8659-4a5f-942d-674d075adcad	f
f576fa8c-c2b5-4121-9936-0bbd993aa559	305e297a-f075-4140-b9bb-76cd6a18fc70	t
f576fa8c-c2b5-4121-9936-0bbd993aa559	cadae9cb-c07d-4eab-bfe1-2b8ce939cd9d	t
f576fa8c-c2b5-4121-9936-0bbd993aa559	2fa54bc7-079f-44a4-af94-ee9a942a9d36	t
f576fa8c-c2b5-4121-9936-0bbd993aa559	8f8bd907-7a70-4f0c-8301-2706005267e6	t
f576fa8c-c2b5-4121-9936-0bbd993aa559	90129970-b394-4de3-915b-1a3f36d15fee	t
f576fa8c-c2b5-4121-9936-0bbd993aa559	34667733-3773-424d-aa8d-d23d6573eba8	f
f576fa8c-c2b5-4121-9936-0bbd993aa559	f62f28ab-12f7-40af-89ac-54530348e79c	f
f576fa8c-c2b5-4121-9936-0bbd993aa559	ce8950ef-7393-432d-bfec-530811975037	f
f576fa8c-c2b5-4121-9936-0bbd993aa559	0159a26c-8659-4a5f-942d-674d075adcad	f
d9a8b9bf-ff5c-46f7-895a-f06aaae0a1dc	305e297a-f075-4140-b9bb-76cd6a18fc70	t
d9a8b9bf-ff5c-46f7-895a-f06aaae0a1dc	cadae9cb-c07d-4eab-bfe1-2b8ce939cd9d	t
d9a8b9bf-ff5c-46f7-895a-f06aaae0a1dc	2fa54bc7-079f-44a4-af94-ee9a942a9d36	t
d9a8b9bf-ff5c-46f7-895a-f06aaae0a1dc	8f8bd907-7a70-4f0c-8301-2706005267e6	t
d9a8b9bf-ff5c-46f7-895a-f06aaae0a1dc	90129970-b394-4de3-915b-1a3f36d15fee	t
d9a8b9bf-ff5c-46f7-895a-f06aaae0a1dc	34667733-3773-424d-aa8d-d23d6573eba8	f
d9a8b9bf-ff5c-46f7-895a-f06aaae0a1dc	f62f28ab-12f7-40af-89ac-54530348e79c	f
d9a8b9bf-ff5c-46f7-895a-f06aaae0a1dc	ce8950ef-7393-432d-bfec-530811975037	f
d9a8b9bf-ff5c-46f7-895a-f06aaae0a1dc	0159a26c-8659-4a5f-942d-674d075adcad	f
77d24d30-2ec1-47f9-a758-0826b164cacd	305e297a-f075-4140-b9bb-76cd6a18fc70	t
77d24d30-2ec1-47f9-a758-0826b164cacd	cadae9cb-c07d-4eab-bfe1-2b8ce939cd9d	t
77d24d30-2ec1-47f9-a758-0826b164cacd	2fa54bc7-079f-44a4-af94-ee9a942a9d36	t
77d24d30-2ec1-47f9-a758-0826b164cacd	8f8bd907-7a70-4f0c-8301-2706005267e6	t
77d24d30-2ec1-47f9-a758-0826b164cacd	90129970-b394-4de3-915b-1a3f36d15fee	t
77d24d30-2ec1-47f9-a758-0826b164cacd	34667733-3773-424d-aa8d-d23d6573eba8	f
77d24d30-2ec1-47f9-a758-0826b164cacd	f62f28ab-12f7-40af-89ac-54530348e79c	f
77d24d30-2ec1-47f9-a758-0826b164cacd	ce8950ef-7393-432d-bfec-530811975037	f
77d24d30-2ec1-47f9-a758-0826b164cacd	0159a26c-8659-4a5f-942d-674d075adcad	f
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	305e297a-f075-4140-b9bb-76cd6a18fc70	t
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	cadae9cb-c07d-4eab-bfe1-2b8ce939cd9d	t
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	2fa54bc7-079f-44a4-af94-ee9a942a9d36	t
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	8f8bd907-7a70-4f0c-8301-2706005267e6	t
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	90129970-b394-4de3-915b-1a3f36d15fee	t
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	34667733-3773-424d-aa8d-d23d6573eba8	f
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	f62f28ab-12f7-40af-89ac-54530348e79c	f
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	ce8950ef-7393-432d-bfec-530811975037	f
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	0159a26c-8659-4a5f-942d-674d075adcad	f
0df0a01c-66ef-4e56-bcd6-53211c3965b5	305e297a-f075-4140-b9bb-76cd6a18fc70	t
0df0a01c-66ef-4e56-bcd6-53211c3965b5	cadae9cb-c07d-4eab-bfe1-2b8ce939cd9d	t
0df0a01c-66ef-4e56-bcd6-53211c3965b5	2fa54bc7-079f-44a4-af94-ee9a942a9d36	t
0df0a01c-66ef-4e56-bcd6-53211c3965b5	8f8bd907-7a70-4f0c-8301-2706005267e6	t
0df0a01c-66ef-4e56-bcd6-53211c3965b5	90129970-b394-4de3-915b-1a3f36d15fee	t
0df0a01c-66ef-4e56-bcd6-53211c3965b5	34667733-3773-424d-aa8d-d23d6573eba8	f
0df0a01c-66ef-4e56-bcd6-53211c3965b5	f62f28ab-12f7-40af-89ac-54530348e79c	f
0df0a01c-66ef-4e56-bcd6-53211c3965b5	ce8950ef-7393-432d-bfec-530811975037	f
0df0a01c-66ef-4e56-bcd6-53211c3965b5	0159a26c-8659-4a5f-942d-674d075adcad	f
a39f7d32-3924-49d0-8904-bd9e4409411c	305e297a-f075-4140-b9bb-76cd6a18fc70	t
a39f7d32-3924-49d0-8904-bd9e4409411c	cadae9cb-c07d-4eab-bfe1-2b8ce939cd9d	t
a39f7d32-3924-49d0-8904-bd9e4409411c	2fa54bc7-079f-44a4-af94-ee9a942a9d36	t
a39f7d32-3924-49d0-8904-bd9e4409411c	8f8bd907-7a70-4f0c-8301-2706005267e6	t
a39f7d32-3924-49d0-8904-bd9e4409411c	90129970-b394-4de3-915b-1a3f36d15fee	t
a39f7d32-3924-49d0-8904-bd9e4409411c	34667733-3773-424d-aa8d-d23d6573eba8	f
a39f7d32-3924-49d0-8904-bd9e4409411c	f62f28ab-12f7-40af-89ac-54530348e79c	f
a39f7d32-3924-49d0-8904-bd9e4409411c	ce8950ef-7393-432d-bfec-530811975037	f
a39f7d32-3924-49d0-8904-bd9e4409411c	0159a26c-8659-4a5f-942d-674d075adcad	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
3f5ecfed-446a-4a5f-b6d6-6af6fd3a8d9c	f0c6944e-07ac-4402-b5c5-27e14db67e0a
ce8950ef-7393-432d-bfec-530811975037	c9c9606b-db1d-4439-b22c-10e8478a91ba
\.


--
-- Data for Name: client_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_session (id, client_id, redirect_uri, state, "timestamp", session_id, auth_method, realm_id, auth_user_id, current_action) FROM stdin;
\.


--
-- Data for Name: client_session_auth_status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_session_auth_status (authenticator, status, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_note; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_prot_mapper; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_session_prot_mapper (protocol_mapper_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_session_role (role_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_user_session_note; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_user_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
c374860e-3179-4190-a9b9-bc56b99b3343	Trusted Hosts	e09f66b1-fa27-4fd8-affd-235a04a06fba	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e09f66b1-fa27-4fd8-affd-235a04a06fba	anonymous
0e65149d-91f1-4f97-8c12-27d1045f5cf0	Consent Required	e09f66b1-fa27-4fd8-affd-235a04a06fba	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e09f66b1-fa27-4fd8-affd-235a04a06fba	anonymous
0de8e98b-9c99-44af-8e49-90f0418c7978	Full Scope Disabled	e09f66b1-fa27-4fd8-affd-235a04a06fba	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e09f66b1-fa27-4fd8-affd-235a04a06fba	anonymous
469fbd5f-5d67-42a9-9220-16f2775eb294	Max Clients Limit	e09f66b1-fa27-4fd8-affd-235a04a06fba	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e09f66b1-fa27-4fd8-affd-235a04a06fba	anonymous
e94da2d8-fa14-4f65-b99c-729b88263d03	Allowed Protocol Mapper Types	e09f66b1-fa27-4fd8-affd-235a04a06fba	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e09f66b1-fa27-4fd8-affd-235a04a06fba	anonymous
c8ab11be-8564-417e-8686-88c5614bda37	Allowed Client Scopes	e09f66b1-fa27-4fd8-affd-235a04a06fba	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e09f66b1-fa27-4fd8-affd-235a04a06fba	anonymous
c962fe9e-dc4b-4a95-8ba7-e3c30e433231	Allowed Protocol Mapper Types	e09f66b1-fa27-4fd8-affd-235a04a06fba	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e09f66b1-fa27-4fd8-affd-235a04a06fba	authenticated
c7977147-c527-49de-882c-9a3bb34561d8	Allowed Client Scopes	e09f66b1-fa27-4fd8-affd-235a04a06fba	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e09f66b1-fa27-4fd8-affd-235a04a06fba	authenticated
a2262e41-35e6-4dc6-b575-f1f2da176fc2	rsa-generated	e09f66b1-fa27-4fd8-affd-235a04a06fba	rsa-generated	org.keycloak.keys.KeyProvider	e09f66b1-fa27-4fd8-affd-235a04a06fba	\N
757f0844-e4d4-454b-9ea3-6b6710fccce6	rsa-enc-generated	e09f66b1-fa27-4fd8-affd-235a04a06fba	rsa-enc-generated	org.keycloak.keys.KeyProvider	e09f66b1-fa27-4fd8-affd-235a04a06fba	\N
034da806-75a9-4160-9f2b-a34b24a4aa0a	hmac-generated	e09f66b1-fa27-4fd8-affd-235a04a06fba	hmac-generated	org.keycloak.keys.KeyProvider	e09f66b1-fa27-4fd8-affd-235a04a06fba	\N
566cd5f7-7208-47ea-9c2a-4147e79bb344	aes-generated	e09f66b1-fa27-4fd8-affd-235a04a06fba	aes-generated	org.keycloak.keys.KeyProvider	e09f66b1-fa27-4fd8-affd-235a04a06fba	\N
be390ce8-f991-4505-85c0-83e827ea0a96	Allowed Client Scopes	d4932c90-8454-4b23-b96a-05444067272e	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d4932c90-8454-4b23-b96a-05444067272e	authenticated
104d565a-3d08-4b34-974d-83662596bd1c	Max Clients Limit	d4932c90-8454-4b23-b96a-05444067272e	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d4932c90-8454-4b23-b96a-05444067272e	anonymous
443c2927-f149-47d1-a82f-91a2ba01e52f	Full Scope Disabled	d4932c90-8454-4b23-b96a-05444067272e	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d4932c90-8454-4b23-b96a-05444067272e	anonymous
358d5f14-cf19-4443-b22e-c948be2c2b1b	Consent Required	d4932c90-8454-4b23-b96a-05444067272e	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d4932c90-8454-4b23-b96a-05444067272e	anonymous
e571cd8e-a7e7-4e1c-bb43-fcaf3b655ef4	Trusted Hosts	d4932c90-8454-4b23-b96a-05444067272e	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d4932c90-8454-4b23-b96a-05444067272e	anonymous
7f4a14c1-32b2-40a9-8d9c-df85102ff962	Allowed Client Scopes	d4932c90-8454-4b23-b96a-05444067272e	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d4932c90-8454-4b23-b96a-05444067272e	anonymous
ac8efe49-6332-440b-9f0a-476d15d068f9	Allowed Protocol Mapper Types	d4932c90-8454-4b23-b96a-05444067272e	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d4932c90-8454-4b23-b96a-05444067272e	authenticated
5e2719e2-50ed-405d-8fa2-2104bb0106ac	Allowed Protocol Mapper Types	d4932c90-8454-4b23-b96a-05444067272e	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d4932c90-8454-4b23-b96a-05444067272e	anonymous
ce7313f0-9fa2-4948-966d-19f366995acb	rsa-generated	d4932c90-8454-4b23-b96a-05444067272e	rsa-generated	org.keycloak.keys.KeyProvider	d4932c90-8454-4b23-b96a-05444067272e	\N
e5bb2e79-8516-478d-825d-aa5f5ef659e2	hmac-generated	d4932c90-8454-4b23-b96a-05444067272e	hmac-generated	org.keycloak.keys.KeyProvider	d4932c90-8454-4b23-b96a-05444067272e	\N
74129383-7d0c-44f8-8856-ee6b803d53da	rsa-enc-generated	d4932c90-8454-4b23-b96a-05444067272e	rsa-enc-generated	org.keycloak.keys.KeyProvider	d4932c90-8454-4b23-b96a-05444067272e	\N
c17c7650-8b61-4f77-aa5d-380ed6772d57	aes-generated	d4932c90-8454-4b23-b96a-05444067272e	aes-generated	org.keycloak.keys.KeyProvider	d4932c90-8454-4b23-b96a-05444067272e	\N
1e438998-04ce-499c-8d36-57925f51c79d	\N	d4932c90-8454-4b23-b96a-05444067272e	declarative-user-profile	org.keycloak.userprofile.UserProfileProvider	d4932c90-8454-4b23-b96a-05444067272e	\N
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
8db83444-bbc1-4c4d-9331-870c184fb68a	c962fe9e-dc4b-4a95-8ba7-e3c30e433231	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
cc4f5691-4a7a-465b-83d4-d466dde5c8db	c962fe9e-dc4b-4a95-8ba7-e3c30e433231	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
f8a4e797-9fc4-4eeb-a526-6b5e440d88ec	c962fe9e-dc4b-4a95-8ba7-e3c30e433231	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
4c5b6df4-2b49-4b0c-8512-fd34d4606b94	c962fe9e-dc4b-4a95-8ba7-e3c30e433231	allowed-protocol-mapper-types	oidc-address-mapper
9fbe8933-0f4d-48ef-8453-bac27d490c84	c962fe9e-dc4b-4a95-8ba7-e3c30e433231	allowed-protocol-mapper-types	saml-role-list-mapper
ea1ce990-9deb-4448-a135-2b1c89e5eafc	c962fe9e-dc4b-4a95-8ba7-e3c30e433231	allowed-protocol-mapper-types	saml-user-attribute-mapper
7a1f264a-e29f-4122-bb53-6db0162c28b0	c962fe9e-dc4b-4a95-8ba7-e3c30e433231	allowed-protocol-mapper-types	saml-user-property-mapper
1a2fe791-94f5-4564-bfac-5560910068c0	c962fe9e-dc4b-4a95-8ba7-e3c30e433231	allowed-protocol-mapper-types	oidc-full-name-mapper
9360b944-0369-4dcc-9859-55540454ac50	c8ab11be-8564-417e-8686-88c5614bda37	allow-default-scopes	true
e18e0e18-4c3d-4b2f-863e-1ab59a617e93	469fbd5f-5d67-42a9-9220-16f2775eb294	max-clients	200
c8b4a62b-5e0b-4c45-8cfb-0f72a438074d	c374860e-3179-4190-a9b9-bc56b99b3343	host-sending-registration-request-must-match	true
1c79d830-d2c1-4422-b5f3-de33dd1f0b16	c374860e-3179-4190-a9b9-bc56b99b3343	client-uris-must-match	true
370c51b8-cdcd-4db6-aad5-ae398c808627	c7977147-c527-49de-882c-9a3bb34561d8	allow-default-scopes	true
827c92f8-4446-457b-9078-3b64828ca070	e94da2d8-fa14-4f65-b99c-729b88263d03	allowed-protocol-mapper-types	saml-user-property-mapper
8f75c10d-5230-43b8-94e5-86c87781d288	e94da2d8-fa14-4f65-b99c-729b88263d03	allowed-protocol-mapper-types	saml-role-list-mapper
76d84f19-13af-43bd-8201-1a00b671bbf1	e94da2d8-fa14-4f65-b99c-729b88263d03	allowed-protocol-mapper-types	oidc-address-mapper
ac5ce6d5-c1b1-4fad-b911-a03a0beb2762	e94da2d8-fa14-4f65-b99c-729b88263d03	allowed-protocol-mapper-types	saml-user-attribute-mapper
dffb3739-6c42-4d7d-b317-d594d329a0cd	e94da2d8-fa14-4f65-b99c-729b88263d03	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
bba3dc8f-9901-461d-9400-c47fbe591df2	e94da2d8-fa14-4f65-b99c-729b88263d03	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
7da68e36-401a-4350-bcce-1d30cee648fa	e94da2d8-fa14-4f65-b99c-729b88263d03	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
187f3aea-2671-4434-9c08-145ad72fba54	e94da2d8-fa14-4f65-b99c-729b88263d03	allowed-protocol-mapper-types	oidc-full-name-mapper
4a1e0a0a-1a71-4ead-8517-2b1ed1be0504	566cd5f7-7208-47ea-9c2a-4147e79bb344	kid	25eee005-10e3-4264-9f1b-f9a360f8377f
98f8f92e-44af-4045-a12f-6bf43cefd054	566cd5f7-7208-47ea-9c2a-4147e79bb344	priority	100
c28fab91-19c3-4c20-a0a0-64dfce88f0b4	566cd5f7-7208-47ea-9c2a-4147e79bb344	secret	wVOi758Xdr5gL5KsMNZtNw
3c634ca2-3958-44ec-8cec-03a95f07bf96	034da806-75a9-4160-9f2b-a34b24a4aa0a	priority	100
3b3a2053-961e-470a-8b93-b2d56255ae85	034da806-75a9-4160-9f2b-a34b24a4aa0a	secret	if9w1R7D70n9LYMiLuxkQxMHZOfKMQ3B1BdoLMMt5Wch_vwCtOe8RhhoWxkAGXZtt0j6ljziMLCCmxjkFeXM1A
59e995c2-2a82-4e15-9e3f-dca537ebcbf6	034da806-75a9-4160-9f2b-a34b24a4aa0a	algorithm	HS256
6bf3643c-66a6-42bb-bb63-ee78d2e73d9e	034da806-75a9-4160-9f2b-a34b24a4aa0a	kid	b80b95f2-5c33-4324-8dd1-3d60d5728890
02d3fb3e-61d3-47ee-bc9f-9c5fab0c37ec	a2262e41-35e6-4dc6-b575-f1f2da176fc2	keyUse	SIG
52b7befd-0051-4fdf-b4b5-caa7b1c61b8b	a2262e41-35e6-4dc6-b575-f1f2da176fc2	privateKey	MIIEowIBAAKCAQEAxyjshQfreNup61NlGM6tM2Aqol0Xll8IuzVxK4/pflpUWGBFLFjFPImrIF28eCCmjLcyniJBcEwDLWijPf8TPDovC6XcHC37kk+ZCJCm89ElOooYfOK3hGlXwdkhqygRiFf3CCgTjIkArlz0LGO2929SU4uOnYfpWYSgMxouoRrqhoDzL+6cqriNzq4Xh67N+WV5PxSz8L3mZe8Gi/Js2oez2S3j7V/yUjJk1FHAZIf5rPKpOa0isY56tg2u3c5uy/YcMCoxf2ixVDwZ8HZr0zvIULV5I5TfguP6t1FPxjyBGVu7J4/KMtDqKmu0xOo++1byTYBWQQrhlW949kMzxQIDAQABAoIBAEmJYE+8fWMaRLLqD4Wp5oT2SLe7xNZWj8xELt3FXRM0+jjJjzERM/6m3INuaQU4FRcXG78M6fmzb2boYIInOWx/FVjpLI1RIzdCYcCqXKLhQixLyj/unJFtLiSa7lYazOJ5jHK8DX/SJGi9VMFBLlFNjunfOVEMWoqdsGM+EyKTvUy/di2kRVxCEh5ZDUZGPU9PYnqNp14zB3M8SJGNBIJasqMUxOix4U3EwN3Oy/Cnnaan2SgMAH4EeAa57DAtQovvJNnITndWs3Z94IDlqIzo40/yJNbZ7Chphe80IWBnpt0gibztgkBtj7217mnZLEL0/vJN3j1YwdWq+9r1C48CgYEA6vU0FwbpSTXiDWnkyDL5yIuy5kg4pRgAtHxmpjp5alxBafgWoypgW802AX8LcqQ4jBhaFqAQPEdAo45Kc5EVL9eZ/a9ree/WQ2a6z0PlooVFr1DJTBbt5W3/IuloX6BwWV9TT0wiNNQY7nUV93DT+e/2LM4pj5R+W9349TAWhz8CgYEA2P7+LEUX2aBbJPrfCG0ElLkKU0HX5VtQQntRBHzPMTpkIeyQn2HWFKMwVemsE/aIf9pkXc+k8fJDPVpyrW6X5z7yPWUVhu1Gc7D9FXlNcJ5fzWcYqz+VODsObRA8Pi3hMb4BpDkq3o1TwnuU184fQBDJWlUipZHMrYLP9hvuJ/sCgYEAsm9ThuVVx6anLP6to6iq77XAQIi6lA6dgnQzVKx1xuOXPg4Nyw6ErVM0X4CHRiIXW7WmvSYEDnMiUNPgENIu3+2B4hoVqj4NX5Sl7IAo5fsGh/T3WtTTCHk32OCfxnfGuujdEQzFsY8d/AJpk0hZg6fMMgzDnWntaIEz76j8gusCgYBi2RWz2O2aZ1/doqJC1laF4R0A/Dd69XPENSSc5LYFeNHwWjEvSYQZ9pSoLkADAAUCKNwbl+FNjcxvgGpI8t4jqxryOL/rrN6xCOjhBVbvfFWr3dDxAY/aA5z4tbKbqI6y+BkLVDdhFgQXze/ptq2po3v1uF6GCbqxN6vAMsz0TQKBgAOlTM7HS9v1p+Er4SkTiOptjwcjEXk8mV5F9jSvYNNaKaqu3fMcsHEAFnO2Rib7jtuad7vveVMfiA79td4yhS9gkOltAMatWbbCfTXEkLQgUXjsDE6iulGsvruYuU7OOlCLjU1jPFSN7umFKMLjYegv4J3kW5oqwytxlgbrh9un
6e5f97a9-81ea-4064-b9cd-493a67ade924	a2262e41-35e6-4dc6-b575-f1f2da176fc2	priority	100
13a3f3d3-fa23-4572-9a95-9c00d2c2cf44	a2262e41-35e6-4dc6-b575-f1f2da176fc2	certificate	MIICmzCCAYMCBgGJliCUQzANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjMwNzI3MDY1MjQ0WhcNMzMwNzI3MDY1NDI0WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDHKOyFB+t426nrU2UYzq0zYCqiXReWXwi7NXErj+l+WlRYYEUsWMU8iasgXbx4IKaMtzKeIkFwTAMtaKM9/xM8Oi8LpdwcLfuST5kIkKbz0SU6ihh84reEaVfB2SGrKBGIV/cIKBOMiQCuXPQsY7b3b1JTi46dh+lZhKAzGi6hGuqGgPMv7pyquI3OrheHrs35ZXk/FLPwveZl7waL8mzah7PZLePtX/JSMmTUUcBkh/ms8qk5rSKxjnq2Da7dzm7L9hwwKjF/aLFUPBnwdmvTO8hQtXkjlN+C4/q3UU/GPIEZW7snj8oy0Ooqa7TE6j77VvJNgFZBCuGVb3j2QzPFAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAJ4nGEB9rNxSqEhCtV2kCDXCGvM74/32cdbQFHQaVx3oFqyy9zlgKoXcRhXDxsh1VzWu0AbYLefp2erRpnIpsbSHvAxVhIgTcJuMB6MIbRsHqwIJYBaqCt/IXMvnAcqvMG5o6yy99VA5s/shDjfdiWgLEX35wiUjJrkHTOBtxY+Qle9Jol4J5IknVkowrssMpFpf7uiZNEMlIjZYPViDMICsvdSSHwwFs7AXbQ9dOCqWdOtXAKdftp1lJ70xmBLzJFij9/dwXkVxFCadK7H7lgNGyLL8HwiZVFOVWMb51jNNFNSyUbjkyWnZHEc/cg82CNjNguZ8k/Q2cEYZwPrYZ2M=
fe6b2295-3cfa-4c5f-b709-360549157a61	757f0844-e4d4-454b-9ea3-6b6710fccce6	privateKey	MIIEowIBAAKCAQEAx3Fhy1lM239g5qPbOAmGPWsLsARe+qnqsdYcSveMzHoLBLhWVzEiwRJpqRrvYoA8EjefrtuMXtzKNiw6zXLkQPblkzrdsadStgk+EMpZ+FymSk4xmygqUfN9yrTVJUEiHQzmHuO+i3sGflX2q8nMwjdOKlRyBsRJRtCfZKJ5+slgQiGNMf9Kd/r56qtSLdbNVIZly2jBw5M1TdnUYaZr94Liqz3Orb4K3SuGQRt7h3JDm4/J9oruk4A0eYrdscThalrhqhKjijH62hRguNj7J6NuUrg8Ez9OhCDFc0B8RtRWcscZUPCO356d8knSG9tPAEuUb3oOksqfFyRoKusX+wIDAQABAoIBAAXqG1vT7J8PwnhkgJJDWgtFOuX/4y8szcxzTIh+mdrQfbYon0rbpquyF5cPuOyjX+SsaJxfX2TKyGZd3mqMTy+MAtfgZYWosB+8223VCmD+omHOutLemI6wmVjjDvUZXuEcqlBdMZ/iSJmDhBqpE9zolfVUZsNDm+axNiDeXp6sv7OVNLojYvhaVJTcTLzo7RCUOjzFDeLKpiynsj68AcuXNb8COViiOUwUX7BKq7UQ4tDg2DeDuLLakOQqm7UB1/kuqd/HDvj4TUq9s5uKQkCjsYG8k5muolrWWXZNsJ9xA0iGWnstjeEvCL3g3PPZGD2zRzAB1zkp4Wlr0/XT8f0CgYEA8PGdj1ViuJpSthXtbJgzylRrrpT2aNGFUbxMjX0PrF75HITuu+HaebXazU79KcFIYNifvye0ZkCnS12h0E8b1URoKhW33rsBxhGIvYMD81QjYtkczE+oKRD8QcXQSqMQB1j/vOqODfARWiallxcGh7KGb8UhkEiIfpBFH3iIAocCgYEA0+fgFvmkISWacWGiFzc8qvG1UIlTosunJqPxqV0UmqKdOXFT91nw4UQS6O+zOvSEZM0f+eZ9dgElNfAMG1Um+bQwWuvkYmjvwpNUutKIMti11Wmobr32HMKLJstAyLTfafeDZF1sTy3/vYRutUtLtgJsT+XyHZsv8Iplp7aMd+0CgYAWAOqzqUePtkAxcsUw8qFgK999nQr3vZKgSULwdOhWhIHZceZfcBvEm6/0qe8Cviz+8yl7ioO2BteAUXeyj1bqXgnpNfyJsahSz00eiXV15kwo/czcd7XSskNnOkpwVn3jPeR0+zKn4TGkev0KVEb7Y3lVgboz8/vLGx/E5Pv+xwKBgQC6bhQO4o7twqGAAv+SITy0wHZeZpM4dKeYLUBdWtDXwx1D/lp7EZwE89kXKlurEJix/m2VdJ0IhrVwIMLmASKLKWYpd8O0eNIHg4tV2geNhG9lVNGkrGesodO+y68xZT/xgJsOX8r8VmHbIHot8hKoDLWyDYHXXkLtAzWwOcCXeQKBgHlM2RObdW+AP/5NyazBnJkC4j/fElScbMJrWV+ih6gLWsY0aIF5Ouz17DOZ88IAl6w/RTxbwiUmCo7vFSkORxGD+YOp2GWA0GBhq+MLi6edYpAL9uD/OViLL5F7edhtNi/suYqqBesPw3tVn+DaPl0jVox4EeZsAjjRhOPfo5q4
72e9b22a-b02a-4686-be2e-b9e95f41524c	757f0844-e4d4-454b-9ea3-6b6710fccce6	certificate	MIICmzCCAYMCBgGJliCU7TANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjMwNzI3MDY1MjQ1WhcNMzMwNzI3MDY1NDI1WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDHcWHLWUzbf2Dmo9s4CYY9awuwBF76qeqx1hxK94zMegsEuFZXMSLBEmmpGu9igDwSN5+u24xe3Mo2LDrNcuRA9uWTOt2xp1K2CT4Qyln4XKZKTjGbKCpR833KtNUlQSIdDOYe476LewZ+VfaryczCN04qVHIGxElG0J9konn6yWBCIY0x/0p3+vnqq1It1s1UhmXLaMHDkzVN2dRhpmv3guKrPc6tvgrdK4ZBG3uHckObj8n2iu6TgDR5it2xxOFqWuGqEqOKMfraFGC42Psno25SuDwTP06EIMVzQHxG1FZyxxlQ8I7fnp3ySdIb208AS5Rveg6Syp8XJGgq6xf7AgMBAAEwDQYJKoZIhvcNAQELBQADggEBAKTBn+spmOyEb3b5FbojWg5gOaNyoJNvXmmDGVnsF1CVso+8wPjm3MgKcCdyD1xOsiYoiFCIhNlWC4YnLEg/G9J3n0Ka/g0eX9aXcllSMRBhTDrVbLi4rSCjedQ2xcNWZO5+nh76gQCcZI+YwQdXzK40XsZR1kcoq87/k1Tbl7appY8uq5jWxaNJ5STgGS2JhmqaknXh0uWzs4IUT3CPRwAwKhxUX8LrgQoGf9Nk+zzXDjC4XU7VhLOuMpMOmDnUtotcCi6hXSqvj5BeTSjgORWVIiFFUOwTMVsJqo2QTU/xRExh7KIfZLcJTcqWg0FxPc8zLKmTSjcFf1umEtYxoRE=
08cf6869-41ad-4ea6-a1c8-0ca68dea8be9	757f0844-e4d4-454b-9ea3-6b6710fccce6	keyUse	ENC
8b57fa5f-e5f8-41a2-a82b-a7aa63ad0aee	757f0844-e4d4-454b-9ea3-6b6710fccce6	priority	100
a7a1fb6c-4ed2-404e-a9f6-289db5338db7	757f0844-e4d4-454b-9ea3-6b6710fccce6	algorithm	RSA-OAEP
2343a24c-9da1-4b67-9ca1-cf916fd00199	e5bb2e79-8516-478d-825d-aa5f5ef659e2	kid	aaa9fe9c-f4af-44a5-8fbc-622f0ac200fd
50aa1e3f-64ea-4c25-9fb6-525ae231c364	e5bb2e79-8516-478d-825d-aa5f5ef659e2	priority	100
d76fbfb8-9dc0-4dc3-bc7b-a203b0b64b80	e5bb2e79-8516-478d-825d-aa5f5ef659e2	algorithm	HS256
9ead0466-eb23-48b0-8eb9-a62fdde3b91d	e5bb2e79-8516-478d-825d-aa5f5ef659e2	secret	2R_cs6NV0i7FuG51p_9x9Yi8fITCdQDPyAU57BISMx86cd49vZrqwx_o0_BRPbrAmhOP-mHSA2v1v0aPmG79Qw
c8795def-75e1-46fb-a722-a78a3c860824	ce7313f0-9fa2-4948-966d-19f366995acb	certificate	MIICnzCCAYcCBgGJliCeVzANBgkqhkiG9w0BAQsFADATMREwDwYDVQQDDAhDYWxlbmRhcjAeFw0yMzA3MjcwNjUyNDdaFw0zMzA3MjcwNjU0MjdaMBMxETAPBgNVBAMMCENhbGVuZGFyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxbryic/z8z70cP8WdVE30VW8v6Yv0cvELpWOMskmAaVYCy9MeVBuHUL6/I2xlTTMAFK6Our8rbps9e58b+f3amvm/ivcl4GinaBrewfDCzVpNaX2KJbFnW+/hEASvLrsNio2VFc35KswIu8ajSHfk+ZV5JwJ5YkQP3tHwwUec7Kh3A9EYrPsWC6bZR1/K9WS8dnbRjC3HDqtOEXgdCd7mPu0eem2JmEL4AmD8ZX68cqMNRAvuSx3SZP29OCuJX+cAHjY4qrzm3+mf4C263gSFaQwAzPvmwntUEi1GFBdhPOmpXUUzXUu4n73eWJ8aDQSYWRGO1Olhl+uiRSF+M+KzQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQAdsqCqetK378Nq+9+opQfefwzP5rHSf72whaavc8TyGKsnyiHra9bmCtLO5UJQx0SqMLFNMUOd+ypT2BVWy0/uSg/U4NUumHJdM5u68sUZqsSXaXaubw9LcUOasTBwjihqusJyQsy6XFjPAOosvqVpJqDZRORKmISZSPPLUISutq8gmAVGAtah7nWIrOpraHZk8A4Eiar1XMBwCPiaGlCd1k0yn7rPJtya8592p2CNtFkE9Kb7kysZO9tPe2TM7fYWBcCRP3eSIvhfFRm6X0VUqP0SnJ3QHpaUxg5HrjedRyeDVamQC73l5Tdt59clgDZkNmeWKPwucVxoqpc9Fu7v
3771bbc1-7da6-4655-b358-b0952bc1420c	ce7313f0-9fa2-4948-966d-19f366995acb	privateKey	MIIEpAIBAAKCAQEAxbryic/z8z70cP8WdVE30VW8v6Yv0cvELpWOMskmAaVYCy9MeVBuHUL6/I2xlTTMAFK6Our8rbps9e58b+f3amvm/ivcl4GinaBrewfDCzVpNaX2KJbFnW+/hEASvLrsNio2VFc35KswIu8ajSHfk+ZV5JwJ5YkQP3tHwwUec7Kh3A9EYrPsWC6bZR1/K9WS8dnbRjC3HDqtOEXgdCd7mPu0eem2JmEL4AmD8ZX68cqMNRAvuSx3SZP29OCuJX+cAHjY4qrzm3+mf4C263gSFaQwAzPvmwntUEi1GFBdhPOmpXUUzXUu4n73eWJ8aDQSYWRGO1Olhl+uiRSF+M+KzQIDAQABAoIBAAvhmeVSC5SYOdP4X/8YrEP15OuXLtRqbBVogyzmDVSX/NxfMTcw8AzuE2rNkNgoXgG+9tXHfPtrclSsyelnhORuK2kmdZDdB0p1cz/nTX8E7Jd+q3Xw6Vr2dgmaWAXjLYJrsuwKeZ9R8giHWY8Vc/vNIWglQCr8u281FzDOw++rtxtXyR7YvTbyLemXvwzdjjj0rhq5NUG+yaYbIXVeUhla10UvC4ov5CtLtwXp0hnsRKC5z2rZFkylatEK3e/XXHLmf25sLWJXkOhWmcWa3itoHvLG14fqv6fvMmPuMFtXisOmcmar9tu+Dfc//XU1Xvk5h7xuFCAyogNfkggG5cECgYEA7yyRjAbbLNhi631E7pqpp7hy4Ele/h1VygtDTndZm7Q74+S+bmIvOAV4u26fB5zz7EC2+FhGYUzM5XXaxpjAWAnT/5nVf8GVd6jrh8oDhbdNpVvNjLQIV/95bFdW+64ZJEx9vlEDzeA+AvPhumzktpmJUJ5zcidfOQbVyPWNLNkCgYEA06P94pKXmz7T0oEn9lRI+LZrEm3Y3/AzEOISEgUjuCFGeEz9d8q7fZOVs/5LVFblBU1AHTPhdfS8Lpb3aL0ojxhi6NOV4z2THxzSrJT/Sgr6uk+nPnLiaEk2oAz+0vuniUp0q1A2xcooZrhXfzS5DJALyF69lJrCbZPS/pELpRUCgYAIVOohEaAS+NrBT1TWZwbf89n0nDm16nmxlyDaG+hAN1AayT4lBECW2AHzrY/WqQ4KPdrh3dldzFoa6Dcd0fZpWrZK4iYA1FKLn5PM4CmtP8xxpTgM3byorBqjvosmK1Nu40dCGPpj8prWaX6EiwSQo9qXt11YLazwhJ9v57XqSQKBgQCSpnvyV+m9pVdZ8i0iv1yhGqYu6vbwlZyNAlnLKsyJdmVCTvcD3vL0HSQKyRahpmSju9fFZIHCHoeXMPzXEtvb6+X9tz+RasVbNbm15LjRMbJzD2awGyNPaAv184tP3xlERNd7LeYGQAKmyu22M25Wiinf+eYb5vD6xQfbZd5P0QKBgQCX+HLt8h6A+dBL28PED9g6oFYdX7Wluu43Exa9ADK4yTwruQeFdtWh8FM4eQLjHBm0I+b5vtWjKCAGxiCvamUkblYQZB3cRWz6E7cxG/R4oP5KVA2K9mvgNPELGs0mXy/HC9s6+lZrQVfoeGsAgIEFacXbXfLTJbZcpMHJCruzSQ==
7bf64eb3-f834-4d6d-b452-d1a837550e67	ce7313f0-9fa2-4948-966d-19f366995acb	priority	100
47e90352-c248-48a8-a7cd-a3a2b210bc0f	be390ce8-f991-4505-85c0-83e827ea0a96	allow-default-scopes	true
ebca7afa-1c86-4b7d-871b-f58fce796a6e	74129383-7d0c-44f8-8856-ee6b803d53da	certificate	MIICnzCCAYcCBgGJliCf3jANBgkqhkiG9w0BAQsFADATMREwDwYDVQQDDAhDYWxlbmRhcjAeFw0yMzA3MjcwNjUyNDdaFw0zMzA3MjcwNjU0MjdaMBMxETAPBgNVBAMMCENhbGVuZGFyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA283iZNqVqUxHZkeJ72Cqv5onyc9MH+efrlxbJi7YUGIdeyVQ8OTqD5RwEwCJ/Pe2jB6A/Muk4FawuweGO2wNcQ6ywUSOXnm+BYLHGDLX1W89QRLf2m79O1IpFBzU31sy4AcF9WtXQ7Sd+rrAY1GBFCB/zWMES2CDt4E0h4bi2riB8iSGScDryeSOJRqPjozcv78U9L6iY5lHmEfdhqNreXHTE30fwfUwXcc3SZh4hwW0vDo8cQgKB3dmQYgKXZt+yGnBKFyNhwTi5OvueOEWxuT6pz/uoz/Ex59F6W0NI/1jF0qY1l+v6SIAyVLXtRmNzMDHiFoLJ2sY5ScdU3bC0wIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQBQhePsQgOYQIg3qZqYlA6qqZhIdnSDCqwZ1yUndiGLAjVYE5Rw2fxyXPyYyETRMXC5iTbxIMSBGkFq+9c24DiWbWy+ALPMerEoS9fy11Nffvy4wc5CUQ2/BUq8FqasBG0exkElqcckmK1S3SWvh9/iIzDAwPZvzlqHMcbnsm9SR2ypKgIR2HwotESIp2nK7LV61jsLBfRuAk3GYBvuQu5AhcR6woSuCo21qQsHxiAfpu45K480+LsgRyBHqwVzR3fc3omU6tpcBH/B6XilO4RBQHRNyQ7YVwVDaSqb7wAvvEUoVbzhSDSVX0S+aGIy0aZPZATUiOYLkcTeO05NixC8
b6355719-98ff-4f0a-ab21-43679db4b329	74129383-7d0c-44f8-8856-ee6b803d53da	priority	100
2da7c61e-c831-42e3-aa32-c7ff540816c2	74129383-7d0c-44f8-8856-ee6b803d53da	privateKey	MIIEowIBAAKCAQEA283iZNqVqUxHZkeJ72Cqv5onyc9MH+efrlxbJi7YUGIdeyVQ8OTqD5RwEwCJ/Pe2jB6A/Muk4FawuweGO2wNcQ6ywUSOXnm+BYLHGDLX1W89QRLf2m79O1IpFBzU31sy4AcF9WtXQ7Sd+rrAY1GBFCB/zWMES2CDt4E0h4bi2riB8iSGScDryeSOJRqPjozcv78U9L6iY5lHmEfdhqNreXHTE30fwfUwXcc3SZh4hwW0vDo8cQgKB3dmQYgKXZt+yGnBKFyNhwTi5OvueOEWxuT6pz/uoz/Ex59F6W0NI/1jF0qY1l+v6SIAyVLXtRmNzMDHiFoLJ2sY5ScdU3bC0wIDAQABAoIBAAxH4FQ7Noi46ayfC1VhoDQRVqXoiemCJUJ2dYhqrlW/+1WNIIzPUNjPkURR9FFx4WHKWs0FAcLEcueF8ivNC8bth85A/Rw26mLySz+OXxieXPghcTFle6+QcRnUykTYLM/dFuDINjBQlJrCcEJXv8sABGrVXID969c0qqO/jjXsQUubkyrCA4TqCbPpb3JvAOHhraiF+bB0QXJzdPqLlWXMeNflBVtqZqL96TmTndHr6fcRlvUTu5ZMejVHgjUjrRkeA2xLq8TTJAtqWG/0fYpF1lMuGbLETDaDqqS1g0oTGl8f4V7Jk9kqVfGI9SozOMQ5DbbAGGYj6g463KFjjskCgYEA/P+J9V9seE0dB+M75x+qZo52MK5eLhB6U1JByrbNtdLd8+ZJTo/Zoke4ot8zQSzmFV21Hxg4QD3fRZk/WDCmEtADKMvIVQUIulrvtDh2nIjE+/wlBi7X6lgSxce+S0Qz/AhgIYkQsatG3JXMF3YzLdcqf3wGltI4gul39VfdHqkCgYEA3mmFg0OMJfAZNzpiYXg6AcD70ZlJEDPsVBI5Y+grpdfn8slqKaV2bz3ayc5HULQEO/Kg/53oiUolhKLpEIi+bsvaT1mPpZgE6q5iF67hS/D0Ghp5KmIEwbHANLK2l8E/MP+0+3FRYrxoTNNJZcBCOBtz+mMuttRZZj8tS7YXrxsCgYEAobE73Ztf+r7mB+19kmhVgngYJ2K5hF05oNjYfZM5g7RB8ChEv7YGFMYbxdQ6sLPeVNdv83CKOtyQPq4Dovxsl2dkLYWYAmZWPqvxuM/BVqe+pYFvtDTp/7bMQKU5BGeRhclgju5HwhVCE6aVKoV7jheO7K06lNfEED7gUOgXxQkCgYBVg6Dv/VKva4dmcq5M55r1/atUxWkQL8aX9IHYZfYSR9dIxCRratEEqHWszgEhiHVwTzOT1LUJxFZ0juapksoVc4+2nqracn7BdNcGYBkDx9szBia8Iv/NMXjDSktmQcj4H/kIDGPMYMCBeWNpGejcBcIr7WKSrUbKR1Q1HggxLQKBgHVTU0P+6phBWsYpoMih7ClPVK6r0x6xzYFHbQE7dgpdOQ9ak+d1Zz+qm487t4WnEhvifmPh+nAVUvhfXKxbPiU5Z0/Gruqv/wJ4E0S+e2iA70+lpXWPFxbD8/XfeSf++k5+ULudU9AuWPVDrzL9GkidJFnm/PLiz2fc6QibPEf7
9c098ea3-40a4-4624-8cab-809b5d5e39f8	74129383-7d0c-44f8-8856-ee6b803d53da	algorithm	RSA-OAEP
105a2747-d519-4151-85fb-a2f427e231d0	e571cd8e-a7e7-4e1c-bb43-fcaf3b655ef4	host-sending-registration-request-must-match	true
059ad7e1-1b72-49f7-8045-1cf8a22ddfb8	e571cd8e-a7e7-4e1c-bb43-fcaf3b655ef4	client-uris-must-match	true
b65538b3-c7c2-48fd-9685-219dee2f512d	104d565a-3d08-4b34-974d-83662596bd1c	max-clients	200
fc0b9390-3341-4f69-a588-414c5ca9aefa	7f4a14c1-32b2-40a9-8d9c-df85102ff962	allow-default-scopes	true
70cce1f3-5a3c-434e-ab91-9a5053636fc8	ac8efe49-6332-440b-9f0a-476d15d068f9	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
7a4dba84-0a9d-4d57-9a47-91257317d272	ac8efe49-6332-440b-9f0a-476d15d068f9	allowed-protocol-mapper-types	oidc-address-mapper
3b90327e-46e4-478c-b18a-c285b171636e	ac8efe49-6332-440b-9f0a-476d15d068f9	allowed-protocol-mapper-types	saml-role-list-mapper
6cdb1e74-708e-48be-9ddb-94e8eb6a08d7	ac8efe49-6332-440b-9f0a-476d15d068f9	allowed-protocol-mapper-types	oidc-full-name-mapper
5f2e7edf-e5f1-4e9d-a799-25c7623f78ed	ac8efe49-6332-440b-9f0a-476d15d068f9	allowed-protocol-mapper-types	saml-user-attribute-mapper
fc8d49be-81ef-46cd-91c4-f6ee7cac8503	ac8efe49-6332-440b-9f0a-476d15d068f9	allowed-protocol-mapper-types	saml-user-property-mapper
1122c66e-0124-4643-82df-fc6817af30bb	ac8efe49-6332-440b-9f0a-476d15d068f9	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
b9bfe22d-e103-4c01-b615-ed47eee5f2ee	ac8efe49-6332-440b-9f0a-476d15d068f9	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
199dd398-094f-4c21-9677-0077a4debd58	5e2719e2-50ed-405d-8fa2-2104bb0106ac	allowed-protocol-mapper-types	oidc-full-name-mapper
51ae7a42-7803-4c7a-9bfd-7cc92a8ed8c9	5e2719e2-50ed-405d-8fa2-2104bb0106ac	allowed-protocol-mapper-types	saml-user-attribute-mapper
0397a793-6062-4158-a09b-6d27140c04d7	5e2719e2-50ed-405d-8fa2-2104bb0106ac	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
be9ce330-2986-4734-8add-5e3b533306de	5e2719e2-50ed-405d-8fa2-2104bb0106ac	allowed-protocol-mapper-types	saml-role-list-mapper
878263c7-68a2-4ad7-976c-63adeb69abaa	5e2719e2-50ed-405d-8fa2-2104bb0106ac	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
469b72d9-a890-471e-9d8e-9f1b931625c8	5e2719e2-50ed-405d-8fa2-2104bb0106ac	allowed-protocol-mapper-types	saml-user-property-mapper
117917b0-b132-41ba-983e-f088932ed7ba	5e2719e2-50ed-405d-8fa2-2104bb0106ac	allowed-protocol-mapper-types	oidc-address-mapper
18c8153a-16a0-42d2-a747-95b84d9cbfc4	5e2719e2-50ed-405d-8fa2-2104bb0106ac	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
cdc0a759-1cb6-4e4d-8363-1f783a155f28	c17c7650-8b61-4f77-aa5d-380ed6772d57	secret	0FNjdrYb4DjgJtLRuGZbXw
5cc29ef4-c262-49bb-a3dc-0585f1a57de1	c17c7650-8b61-4f77-aa5d-380ed6772d57	kid	9baa822a-a04b-44fa-9b01-7c5497b022ab
1596a340-9cc3-4ccf-bd3a-13219777f9d3	c17c7650-8b61-4f77-aa5d-380ed6772d57	priority	100
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.composite_role (composite, child_role) FROM stdin;
3754d5bb-7a83-4a96-8760-53f6c39104be	52575672-a91f-4419-90b9-b3062f7925a2
3754d5bb-7a83-4a96-8760-53f6c39104be	75282bf5-d19f-4252-bc6c-273cefd1f13f
3754d5bb-7a83-4a96-8760-53f6c39104be	10aed837-6bf5-4977-8c52-ea4e78d05a10
3754d5bb-7a83-4a96-8760-53f6c39104be	09c8838f-f370-4006-9856-9a2631ec6a83
3754d5bb-7a83-4a96-8760-53f6c39104be	4bf97d24-0699-4a5c-8c7b-1613bbe79f76
3754d5bb-7a83-4a96-8760-53f6c39104be	1e7785d4-0014-4a62-8c10-8fb974b29937
3754d5bb-7a83-4a96-8760-53f6c39104be	941cf071-7571-4e6a-bbaf-41699fff7a3e
3754d5bb-7a83-4a96-8760-53f6c39104be	2edcc1ff-efc4-4153-abdf-515a3f2e58d2
3754d5bb-7a83-4a96-8760-53f6c39104be	61b5d471-2b0a-4caa-9552-94d5ac40fc55
3754d5bb-7a83-4a96-8760-53f6c39104be	fc7a44ee-ac2a-4bfe-9f9b-01b5012c0714
3754d5bb-7a83-4a96-8760-53f6c39104be	3829166e-11b3-49b6-9fb3-f02ce971d428
3754d5bb-7a83-4a96-8760-53f6c39104be	8dce5a5e-88c3-4369-a44a-340df51831b7
3754d5bb-7a83-4a96-8760-53f6c39104be	fdd88ea9-e93c-4fca-bf7c-1572e44d2452
3754d5bb-7a83-4a96-8760-53f6c39104be	57b4c734-9273-4619-a155-f85fdb6574f6
3754d5bb-7a83-4a96-8760-53f6c39104be	cfec9652-31f8-42cc-ad92-57a23d050d86
3754d5bb-7a83-4a96-8760-53f6c39104be	a9191d63-46e4-44bd-8763-2695497484cd
3754d5bb-7a83-4a96-8760-53f6c39104be	318ec530-2e63-43cc-ab6c-a2363fbcc99b
3754d5bb-7a83-4a96-8760-53f6c39104be	4dac0d2c-57fb-4575-b817-66b7c9df2aab
09c8838f-f370-4006-9856-9a2631ec6a83	cfec9652-31f8-42cc-ad92-57a23d050d86
09c8838f-f370-4006-9856-9a2631ec6a83	4dac0d2c-57fb-4575-b817-66b7c9df2aab
4bf97d24-0699-4a5c-8c7b-1613bbe79f76	a9191d63-46e4-44bd-8763-2695497484cd
95cc1bb4-86dc-4f85-a3d1-80dabefb577b	27844a2e-2d84-48e2-a7f6-4868d1edbaba
95cc1bb4-86dc-4f85-a3d1-80dabefb577b	ee1b354b-f983-46fb-9673-566aad6a4781
ee1b354b-f983-46fb-9673-566aad6a4781	0ea38bea-af73-48d1-b5a1-db4643f0a57e
e9e7a08e-72d8-4736-83af-ac6980bf97e2	e6a20f72-d631-46b8-9a69-f5bf86db76bf
3754d5bb-7a83-4a96-8760-53f6c39104be	4c3e2b66-fac2-46c1-a90c-3a85cd060f4a
95cc1bb4-86dc-4f85-a3d1-80dabefb577b	f0c6944e-07ac-4402-b5c5-27e14db67e0a
95cc1bb4-86dc-4f85-a3d1-80dabefb577b	068f1004-ab9f-43d0-9f52-eed8350dc094
3754d5bb-7a83-4a96-8760-53f6c39104be	ee93f915-60ec-413a-a897-80b358fa0535
3754d5bb-7a83-4a96-8760-53f6c39104be	89d3d5b9-ad57-4a43-a053-bf5d15440c3d
3754d5bb-7a83-4a96-8760-53f6c39104be	d2be1ded-9021-4b58-8e51-d2c59bc1bf5d
3754d5bb-7a83-4a96-8760-53f6c39104be	0d7c7a50-81a6-414d-9cf2-7e5a9239e9bd
3754d5bb-7a83-4a96-8760-53f6c39104be	e116744e-cc6c-4dd5-9f68-03bd8320c0f6
3754d5bb-7a83-4a96-8760-53f6c39104be	74265096-1c69-4907-993d-ca7c35b858c4
3754d5bb-7a83-4a96-8760-53f6c39104be	5494fe48-d0ea-45ac-8d62-c45443f791c0
3754d5bb-7a83-4a96-8760-53f6c39104be	1515908c-7e0c-4446-8e90-64d810aeb7e7
3754d5bb-7a83-4a96-8760-53f6c39104be	901127ff-3427-4974-85ab-9ba003117612
3754d5bb-7a83-4a96-8760-53f6c39104be	c45a8c2d-7671-4d99-a51b-d1f237a7c06e
3754d5bb-7a83-4a96-8760-53f6c39104be	646a4542-4a0a-45ef-955f-c93ec2f40b17
3754d5bb-7a83-4a96-8760-53f6c39104be	1fd1ddf5-2582-474a-b95d-0f439e8f2d67
3754d5bb-7a83-4a96-8760-53f6c39104be	08198f0a-9d7c-4203-9840-b7d087b2ca4b
3754d5bb-7a83-4a96-8760-53f6c39104be	1f5fc15e-656b-49db-93ff-8be5ef5c6530
3754d5bb-7a83-4a96-8760-53f6c39104be	f31b8add-2d6b-4972-b709-0f9f5551d6f6
3754d5bb-7a83-4a96-8760-53f6c39104be	62a38834-4d77-4120-a5ea-8965a2542c35
3754d5bb-7a83-4a96-8760-53f6c39104be	ceb1c6f7-436d-45ca-8b31-60082aca362f
0d7c7a50-81a6-414d-9cf2-7e5a9239e9bd	f31b8add-2d6b-4972-b709-0f9f5551d6f6
d2be1ded-9021-4b58-8e51-d2c59bc1bf5d	ceb1c6f7-436d-45ca-8b31-60082aca362f
d2be1ded-9021-4b58-8e51-d2c59bc1bf5d	1f5fc15e-656b-49db-93ff-8be5ef5c6530
2aa87626-a7a4-409d-9708-663bde4372b0	67b635d0-94d8-4f7f-98a0-fc59251dd011
2aa87626-a7a4-409d-9708-663bde4372b0	d2607bf1-c9e8-4875-aee9-de76c58da12a
2aa87626-a7a4-409d-9708-663bde4372b0	bd7bf8e5-b41f-4587-9a94-a8de44501c77
2aa87626-a7a4-409d-9708-663bde4372b0	e29aed4d-e476-448a-9d9c-2dc35fd3d4ef
2aa87626-a7a4-409d-9708-663bde4372b0	e7e5e4aa-3cf8-40b7-99d3-5876bf98910e
2aa87626-a7a4-409d-9708-663bde4372b0	eb8c00f7-e3fa-4736-ab53-601c41ac5c8f
2aa87626-a7a4-409d-9708-663bde4372b0	8b2fa041-9e42-42a4-b869-4b5b2eb1fb3a
2aa87626-a7a4-409d-9708-663bde4372b0	b5e9a1d9-d51e-4b54-9a4f-c275518b1d04
2aa87626-a7a4-409d-9708-663bde4372b0	d6038e1b-050b-4788-a85e-baf311c32c92
2aa87626-a7a4-409d-9708-663bde4372b0	0268a55a-1b1e-4767-b388-35ad2ca9e2f8
2aa87626-a7a4-409d-9708-663bde4372b0	ebebf509-5cda-41e3-8c37-de49cbd7b77d
2aa87626-a7a4-409d-9708-663bde4372b0	a9b61ab5-cad3-42d1-8013-afff516b0fdf
2aa87626-a7a4-409d-9708-663bde4372b0	5715b557-c989-45aa-9fd3-8d2183ba8be3
2aa87626-a7a4-409d-9708-663bde4372b0	66be4aef-fd18-4fe0-93aa-3c8a2ef9e93e
2aa87626-a7a4-409d-9708-663bde4372b0	b3c887b6-3018-40f8-bb86-7b1eeb323267
2aa87626-a7a4-409d-9708-663bde4372b0	92c65f7f-e0ff-4d38-8bb6-581ff22d5ea9
2aa87626-a7a4-409d-9708-663bde4372b0	b99843c8-c253-42e1-a71c-ed42ad9e6091
2aa87626-a7a4-409d-9708-663bde4372b0	a4d32cda-4aa4-4011-aca5-bc193ee374b8
3ec382b3-405c-4704-acc7-49bb89aa04f3	30cad8e8-2ce1-448d-a38e-c051d93dccf2
4f333366-de06-47da-aa37-ddbd59d39ad1	65bb73fe-43af-48c3-acc2-d0a3b9ab36bd
8b2fa041-9e42-42a4-b869-4b5b2eb1fb3a	0268a55a-1b1e-4767-b388-35ad2ca9e2f8
8b2fa041-9e42-42a4-b869-4b5b2eb1fb3a	b5e9a1d9-d51e-4b54-9a4f-c275518b1d04
b3c887b6-3018-40f8-bb86-7b1eeb323267	a4d32cda-4aa4-4011-aca5-bc193ee374b8
f8287ef9-36e5-4a8c-a160-a4f30f694375	38c2f596-c17c-443b-88c3-715973e661b2
f8287ef9-36e5-4a8c-a160-a4f30f694375	c9c9606b-db1d-4439-b22c-10e8478a91ba
f8287ef9-36e5-4a8c-a160-a4f30f694375	9abb2835-a1f0-46e7-bc7a-c2ddf3b7c32a
f8287ef9-36e5-4a8c-a160-a4f30f694375	3ec382b3-405c-4704-acc7-49bb89aa04f3
3754d5bb-7a83-4a96-8760-53f6c39104be	25182d86-79f1-4016-862a-b07db1d4f23e
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority) FROM stdin;
a31c952d-7584-4312-8b58-2567be716838	\N	password	f94b920e-9c5c-474c-904e-b75f2181f5e2	1690440868536	\N	{"value":"CpcKrFaxTGOtBb0ZSRRPFOQ43UrFlKWVpMNbxcFclWM=","salt":"a78m7ZAs4/3n7unbyKUDXA==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
d9ec84db-c10e-4faa-abf4-dc6e8d7dd9e1	\N	password	45171f94-33bb-439c-8765-7a69d0d6d79e	1690441322767	My password	{"value":"aQRKPEVNMI5YqNTFswYVo3ZuoTpe5g/G0y6yNXKtqMM=","salt":"NTD7tZQXNXFt5kv4buO0oA==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
1979473c-c882-42d9-8788-6550cd533db3	\N	password	e735b777-a13e-4f04-81ee-92edc3068449	1690441357417	My password	{"value":"aOMSe9dERr6Us9wWYrc8rYrl8D0g+/Wu06tV9rm1Rgs=","salt":"SvDAZIdWEXbcarFv/CTrjw==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
5e66fa19-e277-4259-a2e2-e61defa5d805	\N	password	4f95e562-3f21-416c-aba8-98d10d65a744	1690441421886	My password	{"value":"FzUp5JO6dTQ8xQXQKFR8iVl79CEDMyJGDHcKTlrqAOk=","salt":"DSy6/NBJ7KNKv+k2t5Aj4Q==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
4224abee-0e6f-4232-a1d2-ff6b07817d97	\N	password	ceb1ed29-4339-4fbd-bab7-ad1ac16429b6	1690442387505	My password	{"value":"qLxY+ftkXgwN4i1gNjxlb8RnyvG8OapeYY/qHNMLLVA=","salt":"vzZSECaacFpn/eKr8tyaVA==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
0b62d654-d21a-420d-80d1-6298677ce766	\N	password	6fe6034a-5015-4bf6-b0cb-d8314f38ac0b	1690444976465	My password	{"value":"zKm2mDPn0+/PibVaqXr2Y2NhEMP/X4On0F4Mw6hr+64=","salt":"5VYXap7HPIN9dPPyJ5yL4A==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
846574d2-ed85-4153-915d-7a3c987f5c1a	\N	password	3d13b017-9494-4164-9a3a-9d4d6c534614	1690810677136	My password	{"value":"/PEh29Qs2VF3BSYbaY+lGXuD1mi8dK0tTPC+siqqNgU=","salt":"8YGBDHCy9y/NtIYefo9mMw==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2023-07-27 08:54:21.256338	1	EXECUTED	8:bda77d94bf90182a1e30c24f1c155ec7	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.20.0	\N	\N	0440860807
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2023-07-27 08:54:21.263019	2	MARK_RAN	8:1ecb330f30986693d1cba9ab579fa219	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.20.0	\N	\N	0440860807
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2023-07-27 08:54:21.311688	3	EXECUTED	8:cb7ace19bc6d959f305605d255d4c843	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.20.0	\N	\N	0440860807
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2023-07-27 08:54:21.315921	4	EXECUTED	8:80230013e961310e6872e871be424a63	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.20.0	\N	\N	0440860807
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2023-07-27 08:54:21.465403	5	EXECUTED	8:67f4c20929126adc0c8e9bf48279d244	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.20.0	\N	\N	0440860807
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2023-07-27 08:54:21.467963	6	MARK_RAN	8:7311018b0b8179ce14628ab412bb6783	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.20.0	\N	\N	0440860807
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2023-07-27 08:54:21.573388	7	EXECUTED	8:037ba1216c3640f8785ee6b8e7c8e3c1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.20.0	\N	\N	0440860807
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2023-07-27 08:54:21.575899	8	MARK_RAN	8:7fe6ffe4af4df289b3157de32c624263	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.20.0	\N	\N	0440860807
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2023-07-27 08:54:21.581427	9	EXECUTED	8:9c136bc3187083a98745c7d03bc8a303	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.20.0	\N	\N	0440860807
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2023-07-27 08:54:21.750803	10	EXECUTED	8:b5f09474dca81fb56a97cf5b6553d331	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.20.0	\N	\N	0440860807
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2023-07-27 08:54:21.797968	11	EXECUTED	8:ca924f31bd2a3b219fdcfe78c82dacf4	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.20.0	\N	\N	0440860807
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2023-07-27 08:54:21.800122	12	MARK_RAN	8:8acad7483e106416bcfa6f3b824a16cd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.20.0	\N	\N	0440860807
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2023-07-27 08:54:21.81629	13	EXECUTED	8:9b1266d17f4f87c78226f5055408fd5e	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.20.0	\N	\N	0440860807
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2023-07-27 08:54:21.835172	14	EXECUTED	8:d80ec4ab6dbfe573550ff72396c7e910	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.20.0	\N	\N	0440860807
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2023-07-27 08:54:21.836965	15	MARK_RAN	8:d86eb172171e7c20b9c849b584d147b2	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.20.0	\N	\N	0440860807
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2023-07-27 08:54:21.838916	16	MARK_RAN	8:5735f46f0fa60689deb0ecdc2a0dea22	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.20.0	\N	\N	0440860807
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2023-07-27 08:54:21.841597	17	EXECUTED	8:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.20.0	\N	\N	0440860807
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2023-07-27 08:54:21.884008	18	EXECUTED	8:5c1a8fd2014ac7fc43b90a700f117b23	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.20.0	\N	\N	0440860807
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2023-07-27 08:54:21.930464	19	EXECUTED	8:1f6c2c2dfc362aff4ed75b3f0ef6b331	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.20.0	\N	\N	0440860807
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2023-07-27 08:54:21.934534	20	EXECUTED	8:dee9246280915712591f83a127665107	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.20.0	\N	\N	0440860807
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2023-07-27 08:54:21.936033	21	MARK_RAN	8:9eb2ee1fa8ad1c5e426421a6f8fdfa6a	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.20.0	\N	\N	0440860807
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2023-07-27 08:54:21.939393	22	MARK_RAN	8:dee9246280915712591f83a127665107	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.20.0	\N	\N	0440860807
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2023-07-27 08:54:21.965783	23	EXECUTED	8:d9fa18ffa355320395b86270680dd4fe	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.20.0	\N	\N	0440860807
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2023-07-27 08:54:21.971447	24	EXECUTED	8:90cff506fedb06141ffc1c71c4a1214c	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.20.0	\N	\N	0440860807
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2023-07-27 08:54:21.973522	25	MARK_RAN	8:11a788aed4961d6d29c427c063af828c	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.20.0	\N	\N	0440860807
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2023-07-27 08:54:22.009611	26	EXECUTED	8:a4218e51e1faf380518cce2af5d39b43	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.20.0	\N	\N	0440860807
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2023-07-27 08:54:22.092688	27	EXECUTED	8:d9e9a1bfaa644da9952456050f07bbdc	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.20.0	\N	\N	0440860807
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2023-07-27 08:54:22.096795	28	EXECUTED	8:d1bf991a6163c0acbfe664b615314505	update tableName=RESOURCE_SERVER_POLICY		\N	4.20.0	\N	\N	0440860807
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2023-07-27 08:54:22.168334	29	EXECUTED	8:88a743a1e87ec5e30bf603da68058a8c	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.20.0	\N	\N	0440860807
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2023-07-27 08:54:22.184237	30	EXECUTED	8:c5517863c875d325dea463d00ec26d7a	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.20.0	\N	\N	0440860807
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2023-07-27 08:54:22.205878	31	EXECUTED	8:ada8b4833b74a498f376d7136bc7d327	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.20.0	\N	\N	0440860807
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2023-07-27 08:54:22.211741	32	EXECUTED	8:b9b73c8ea7299457f99fcbb825c263ba	customChange		\N	4.20.0	\N	\N	0440860807
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2023-07-27 08:54:22.220494	33	EXECUTED	8:07724333e625ccfcfc5adc63d57314f3	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.20.0	\N	\N	0440860807
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2023-07-27 08:54:22.222816	34	MARK_RAN	8:8b6fd445958882efe55deb26fc541a7b	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.20.0	\N	\N	0440860807
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2023-07-27 08:54:22.251572	35	EXECUTED	8:29b29cfebfd12600897680147277a9d7	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.20.0	\N	\N	0440860807
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2023-07-27 08:54:22.255727	36	EXECUTED	8:73ad77ca8fd0410c7f9f15a471fa52bc	addColumn tableName=REALM		\N	4.20.0	\N	\N	0440860807
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2023-07-27 08:54:22.262368	37	EXECUTED	8:64f27a6fdcad57f6f9153210f2ec1bdb	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.20.0	\N	\N	0440860807
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2023-07-27 08:54:22.267581	38	EXECUTED	8:27180251182e6c31846c2ddab4bc5781	addColumn tableName=FED_USER_CONSENT		\N	4.20.0	\N	\N	0440860807
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2023-07-27 08:54:22.271628	39	EXECUTED	8:d56f201bfcfa7a1413eb3e9bc02978f9	addColumn tableName=IDENTITY_PROVIDER		\N	4.20.0	\N	\N	0440860807
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2023-07-27 08:54:22.273076	40	MARK_RAN	8:91f5522bf6afdc2077dfab57fbd3455c	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.20.0	\N	\N	0440860807
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2023-07-27 08:54:22.275022	41	MARK_RAN	8:0f01b554f256c22caeb7d8aee3a1cdc8	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.20.0	\N	\N	0440860807
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2023-07-27 08:54:22.281401	42	EXECUTED	8:ab91cf9cee415867ade0e2df9651a947	customChange		\N	4.20.0	\N	\N	0440860807
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2023-07-27 08:54:22.411395	43	EXECUTED	8:ceac9b1889e97d602caf373eadb0d4b7	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.20.0	\N	\N	0440860807
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2023-07-27 08:54:22.41642	44	EXECUTED	8:84b986e628fe8f7fd8fd3c275c5259f2	addColumn tableName=USER_ENTITY		\N	4.20.0	\N	\N	0440860807
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2023-07-27 08:54:22.420832	45	EXECUTED	8:a164ae073c56ffdbc98a615493609a52	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.20.0	\N	\N	0440860807
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2023-07-27 08:54:22.426346	46	EXECUTED	8:70a2b4f1f4bd4dbf487114bdb1810e64	customChange		\N	4.20.0	\N	\N	0440860807
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2023-07-27 08:54:22.428095	47	MARK_RAN	8:7be68b71d2f5b94b8df2e824f2860fa2	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.20.0	\N	\N	0440860807
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2023-07-27 08:54:22.471969	48	EXECUTED	8:bab7c631093c3861d6cf6144cd944982	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.20.0	\N	\N	0440860807
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2023-07-27 08:54:22.477176	49	EXECUTED	8:fa809ac11877d74d76fe40869916daad	addColumn tableName=REALM		\N	4.20.0	\N	\N	0440860807
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2023-07-27 08:54:22.521684	50	EXECUTED	8:fac23540a40208f5f5e326f6ceb4d291	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.20.0	\N	\N	0440860807
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2023-07-27 08:54:22.554483	51	EXECUTED	8:2612d1b8a97e2b5588c346e817307593	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.20.0	\N	\N	0440860807
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2023-07-27 08:54:22.557759	52	EXECUTED	8:9842f155c5db2206c88bcb5d1046e941	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.20.0	\N	\N	0440860807
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2023-07-27 08:54:22.561295	53	EXECUTED	8:2e12e06e45498406db72d5b3da5bbc76	update tableName=REALM		\N	4.20.0	\N	\N	0440860807
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2023-07-27 08:54:22.563756	54	EXECUTED	8:33560e7c7989250c40da3abdabdc75a4	update tableName=CLIENT		\N	4.20.0	\N	\N	0440860807
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2023-07-27 08:54:22.571004	55	EXECUTED	8:87a8d8542046817a9107c7eb9cbad1cd	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.20.0	\N	\N	0440860807
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2023-07-27 08:54:22.57783	56	EXECUTED	8:3ea08490a70215ed0088c273d776311e	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.20.0	\N	\N	0440860807
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2023-07-27 08:54:22.598275	57	EXECUTED	8:2d56697c8723d4592ab608ce14b6ed68	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.20.0	\N	\N	0440860807
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2023-07-27 08:54:22.710678	58	EXECUTED	8:3e423e249f6068ea2bbe48bf907f9d86	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.20.0	\N	\N	0440860807
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2023-07-27 08:54:22.735555	59	EXECUTED	8:15cabee5e5df0ff099510a0fc03e4103	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.20.0	\N	\N	0440860807
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2023-07-27 08:54:22.741036	60	EXECUTED	8:4b80200af916ac54d2ffbfc47918ab0e	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.20.0	\N	\N	0440860807
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2023-07-27 08:54:22.751011	61	EXECUTED	8:66564cd5e168045d52252c5027485bbb	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.20.0	\N	\N	0440860807
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2023-07-27 08:54:22.758826	62	EXECUTED	8:1c7064fafb030222be2bd16ccf690f6f	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.20.0	\N	\N	0440860807
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2023-07-27 08:54:22.762828	63	EXECUTED	8:2de18a0dce10cdda5c7e65c9b719b6e5	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.20.0	\N	\N	0440860807
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2023-07-27 08:54:22.765536	64	EXECUTED	8:03e413dd182dcbd5c57e41c34d0ef682	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.20.0	\N	\N	0440860807
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2023-07-27 08:54:22.768031	65	EXECUTED	8:d27b42bb2571c18fbe3fe4e4fb7582a7	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.20.0	\N	\N	0440860807
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2023-07-27 08:54:22.781775	66	EXECUTED	8:698baf84d9fd0027e9192717c2154fb8	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.20.0	\N	\N	0440860807
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2023-07-27 08:54:22.786898	67	EXECUTED	8:ced8822edf0f75ef26eb51582f9a821a	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.20.0	\N	\N	0440860807
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2023-07-27 08:54:22.791996	68	EXECUTED	8:f0abba004cf429e8afc43056df06487d	addColumn tableName=REALM		\N	4.20.0	\N	\N	0440860807
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2023-07-27 08:54:22.803237	69	EXECUTED	8:6662f8b0b611caa359fcf13bf63b4e24	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.20.0	\N	\N	0440860807
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2023-07-27 08:54:22.808961	70	EXECUTED	8:9e6b8009560f684250bdbdf97670d39e	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.20.0	\N	\N	0440860807
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2023-07-27 08:54:22.812514	71	EXECUTED	8:4223f561f3b8dc655846562b57bb502e	addColumn tableName=RESOURCE_SERVER		\N	4.20.0	\N	\N	0440860807
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2023-07-27 08:54:22.818701	72	EXECUTED	8:215a31c398b363ce383a2b301202f29e	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.20.0	\N	\N	0440860807
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2023-07-27 08:54:22.824549	73	EXECUTED	8:83f7a671792ca98b3cbd3a1a34862d3d	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.20.0	\N	\N	0440860807
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2023-07-27 08:54:22.826256	74	MARK_RAN	8:f58ad148698cf30707a6efbdf8061aa7	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.20.0	\N	\N	0440860807
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2023-07-27 08:54:22.844322	75	EXECUTED	8:79e4fd6c6442980e58d52ffc3ee7b19c	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.20.0	\N	\N	0440860807
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2023-07-27 08:54:22.851173	76	EXECUTED	8:87af6a1e6d241ca4b15801d1f86a297d	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.20.0	\N	\N	0440860807
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2023-07-27 08:54:22.855122	77	EXECUTED	8:b44f8d9b7b6ea455305a6d72a200ed15	addColumn tableName=CLIENT		\N	4.20.0	\N	\N	0440860807
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2023-07-27 08:54:22.856475	78	MARK_RAN	8:2d8ed5aaaeffd0cb004c046b4a903ac5	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.20.0	\N	\N	0440860807
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2023-07-27 08:54:22.877833	79	EXECUTED	8:e290c01fcbc275326c511633f6e2acde	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.20.0	\N	\N	0440860807
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2023-07-27 08:54:22.879467	80	MARK_RAN	8:c9db8784c33cea210872ac2d805439f8	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.20.0	\N	\N	0440860807
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2023-07-27 08:54:22.886017	81	EXECUTED	8:95b676ce8fc546a1fcfb4c92fae4add5	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.20.0	\N	\N	0440860807
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2023-07-27 08:54:22.887498	82	MARK_RAN	8:38a6b2a41f5651018b1aca93a41401e5	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.20.0	\N	\N	0440860807
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2023-07-27 08:54:22.891704	83	EXECUTED	8:3fb99bcad86a0229783123ac52f7609c	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.20.0	\N	\N	0440860807
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2023-07-27 08:54:22.893096	84	MARK_RAN	8:64f27a6fdcad57f6f9153210f2ec1bdb	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.20.0	\N	\N	0440860807
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2023-07-27 08:54:22.899224	85	EXECUTED	8:ab4f863f39adafd4c862f7ec01890abc	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.20.0	\N	\N	0440860807
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2023-07-27 08:54:22.906109	86	EXECUTED	8:13c419a0eb336e91ee3a3bf8fda6e2a7	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.20.0	\N	\N	0440860807
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2023-07-27 08:54:22.917147	87	EXECUTED	8:e3fb1e698e0471487f51af1ed80fe3ac	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.20.0	\N	\N	0440860807
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2023-07-27 08:54:22.926108	88	EXECUTED	8:babadb686aab7b56562817e60bf0abd0	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.20.0	\N	\N	0440860807
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2023-07-27 08:54:22.93278	89	EXECUTED	8:72d03345fda8e2f17093d08801947773	addColumn tableName=REALM; customChange		\N	4.20.0	\N	\N	0440860807
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2023-07-27 08:54:22.940708	90	EXECUTED	8:61c9233951bd96ffecd9ba75f7d978a4	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.20.0	\N	\N	0440860807
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2023-07-27 08:54:22.946561	91	EXECUTED	8:ea82e6ad945cec250af6372767b25525	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.20.0	\N	\N	0440860807
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2023-07-27 08:54:22.955944	92	EXECUTED	8:d3f4a33f41d960ddacd7e2ef30d126b3	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.20.0	\N	\N	0440860807
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2023-07-27 08:54:22.957546	93	MARK_RAN	8:1284a27fbd049d65831cb6fc07c8a783	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.20.0	\N	\N	0440860807
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2023-07-27 08:54:22.967849	94	EXECUTED	8:9d11b619db2ae27c25853b8a37cd0dea	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.20.0	\N	\N	0440860807
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2023-07-27 08:54:22.969467	95	MARK_RAN	8:3002bb3997451bb9e8bac5c5cd8d6327	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.20.0	\N	\N	0440860807
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2023-07-27 08:54:22.974977	96	EXECUTED	8:dfbee0d6237a23ef4ccbb7a4e063c163	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.20.0	\N	\N	0440860807
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2023-07-27 08:54:22.985248	97	EXECUTED	8:75f3e372df18d38c62734eebb986b960	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.20.0	\N	\N	0440860807
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2023-07-27 08:54:22.987054	98	MARK_RAN	8:7fee73eddf84a6035691512c85637eef	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.20.0	\N	\N	0440860807
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2023-07-27 08:54:22.997489	99	MARK_RAN	8:7a11134ab12820f999fbf3bb13c3adc8	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.20.0	\N	\N	0440860807
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2023-07-27 08:54:23.003873	100	EXECUTED	8:c0f6eaac1f3be773ffe54cb5b8482b70	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.20.0	\N	\N	0440860807
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2023-07-27 08:54:23.006091	101	MARK_RAN	8:18186f0008b86e0f0f49b0c4d0e842ac	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.20.0	\N	\N	0440860807
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2023-07-27 08:54:23.014411	102	EXECUTED	8:09c2780bcb23b310a7019d217dc7b433	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.20.0	\N	\N	0440860807
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2023-07-27 08:54:23.021268	103	EXECUTED	8:276a44955eab693c970a42880197fff2	customChange		\N	4.20.0	\N	\N	0440860807
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2023-07-27 08:54:23.026672	104	EXECUTED	8:ba8ee3b694d043f2bfc1a1079d0760d7	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.20.0	\N	\N	0440860807
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2023-07-27 08:54:23.032026	105	EXECUTED	8:5e06b1d75f5d17685485e610c2851b17	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.20.0	\N	\N	0440860807
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2023-07-27 08:54:23.039149	106	EXECUTED	8:4b80546c1dc550ac552ee7b24a4ab7c0	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.20.0	\N	\N	0440860807
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2023-07-27 08:54:23.046654	107	EXECUTED	8:af510cd1bb2ab6339c45372f3e491696	customChange		\N	4.20.0	\N	\N	0440860807
20.0.0-12964-supported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2023-07-27 08:54:23.053508	108	EXECUTED	8:05c99fc610845ef66ee812b7921af0ef	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.20.0	\N	\N	0440860807
20.0.0-12964-unsupported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2023-07-27 08:54:23.05551	109	MARK_RAN	8:314e803baf2f1ec315b3464e398b8247	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.20.0	\N	\N	0440860807
client-attributes-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-20.0.0.xml	2023-07-27 08:54:23.061915	110	EXECUTED	8:56e4677e7e12556f70b604c573840100	addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES		\N	4.20.0	\N	\N	0440860807
21.0.2-17277	keycloak	META-INF/jpa-changelog-21.0.2.xml	2023-07-27 08:54:23.068683	111	EXECUTED	8:8806cb33d2a546ce770384bf98cf6eac	customChange		\N	4.20.0	\N	\N	0440860807
21.1.0-19404	keycloak	META-INF/jpa-changelog-21.1.0.xml	2023-07-27 08:54:23.099019	112	EXECUTED	8:fdb2924649d30555ab3a1744faba4928	modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER		\N	4.20.0	\N	\N	0440860807
21.1.0-19404-2	keycloak	META-INF/jpa-changelog-21.1.0.xml	2023-07-27 08:54:23.100476	113	MARK_RAN	8:1c96cc2b10903bd07a03670098d67fd6	addColumn tableName=RESOURCE_SERVER_POLICY; update tableName=RESOURCE_SERVER_POLICY; dropColumn columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; renameColumn newColumnName=DECISION_STRATEGY, oldColumnName=DECISION_STRATEGY_NEW, tabl...		\N	4.20.0	\N	\N	0440860807
22.0.0-17484	keycloak	META-INF/jpa-changelog-22.0.0.xml	2023-07-27 08:54:23.105974	114	EXECUTED	8:4c3d4e8b142a66fcdf21b89a4dd33301	customChange		\N	4.20.0	\N	\N	0440860807
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
1001	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
e09f66b1-fa27-4fd8-affd-235a04a06fba	3f5ecfed-446a-4a5f-b6d6-6af6fd3a8d9c	f
e09f66b1-fa27-4fd8-affd-235a04a06fba	422b07be-cb79-4b0c-8bba-d6014b71fe48	t
e09f66b1-fa27-4fd8-affd-235a04a06fba	db7dde31-c3a8-4aa6-acd3-fc531b3742d6	t
e09f66b1-fa27-4fd8-affd-235a04a06fba	ed8664ac-2c9a-4e49-bfe1-d5b2aa754022	t
e09f66b1-fa27-4fd8-affd-235a04a06fba	f219789b-cb94-422d-94c7-4463bd111d9e	f
e09f66b1-fa27-4fd8-affd-235a04a06fba	1c5436b6-bdff-48b6-83f1-765a07732981	f
e09f66b1-fa27-4fd8-affd-235a04a06fba	9a4e11a6-822d-4505-8044-a0e89f80b7fb	t
e09f66b1-fa27-4fd8-affd-235a04a06fba	095cc82f-d2de-47c6-b73f-686d60c98e02	t
e09f66b1-fa27-4fd8-affd-235a04a06fba	1e6d5d5e-2134-4fe3-81f2-52d636691235	f
e09f66b1-fa27-4fd8-affd-235a04a06fba	88ca1fa4-1955-465e-992c-d65d7270cf38	t
d4932c90-8454-4b23-b96a-05444067272e	b7b454b7-2cf3-4336-af6e-a3ced9539c70	t
d4932c90-8454-4b23-b96a-05444067272e	2fa54bc7-079f-44a4-af94-ee9a942a9d36	t
d4932c90-8454-4b23-b96a-05444067272e	90129970-b394-4de3-915b-1a3f36d15fee	t
d4932c90-8454-4b23-b96a-05444067272e	305e297a-f075-4140-b9bb-76cd6a18fc70	t
d4932c90-8454-4b23-b96a-05444067272e	cadae9cb-c07d-4eab-bfe1-2b8ce939cd9d	t
d4932c90-8454-4b23-b96a-05444067272e	ce8950ef-7393-432d-bfec-530811975037	f
d4932c90-8454-4b23-b96a-05444067272e	34667733-3773-424d-aa8d-d23d6573eba8	f
d4932c90-8454-4b23-b96a-05444067272e	f62f28ab-12f7-40af-89ac-54530348e79c	f
d4932c90-8454-4b23-b96a-05444067272e	0159a26c-8659-4a5f-942d-674d075adcad	f
d4932c90-8454-4b23-b96a-05444067272e	8f8bd907-7a70-4f0c-8301-2706005267e6	t
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
bc41913b-12da-4c85-9fed-c71eb906d8da	IsDozent	true	a12bd244-8ddf-4220-a9f1-b530891a5ec9
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
c275580f-3be2-4fd9-bc16-c9070fa3ce9d	19bb2450-039d-4780-a347-f686e9af8769
92521f28-439b-49fd-9f69-aaad96d123d3	a12bd244-8ddf-4220-a9f1-b530891a5ec9
92521f28-439b-49fd-9f69-aaad96d123d3	623a8856-4bb3-4103-94a1-7ed974a1a14a
f8287ef9-36e5-4a8c-a160-a4f30f694375	269072d2-19a8-4ea8-a367-fc85b6af1c53
92521f28-439b-49fd-9f69-aaad96d123d3	19bb2450-039d-4780-a347-f686e9af8769
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.keycloak_group (id, name, parent_group, realm_id) FROM stdin;
19bb2450-039d-4780-a347-f686e9af8769	Verwaltung	 	d4932c90-8454-4b23-b96a-05444067272e
a12bd244-8ddf-4220-a9f1-b530891a5ec9	Instructors	 	d4932c90-8454-4b23-b96a-05444067272e
269072d2-19a8-4ea8-a367-fc85b6af1c53	TINF2021AI	623a8856-4bb3-4103-94a1-7ed974a1a14a	d4932c90-8454-4b23-b96a-05444067272e
623a8856-4bb3-4103-94a1-7ed974a1a14a	Semesters	 	d4932c90-8454-4b23-b96a-05444067272e
c9811517-c13b-4937-8c90-806418330de2	TINF2020AI	623a8856-4bb3-4103-94a1-7ed974a1a14a	d4932c90-8454-4b23-b96a-05444067272e
b91f647f-a655-458a-9965-9386e8125f85	TINF2022AI	623a8856-4bb3-4103-94a1-7ed974a1a14a	d4932c90-8454-4b23-b96a-05444067272e
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
95cc1bb4-86dc-4f85-a3d1-80dabefb577b	e09f66b1-fa27-4fd8-affd-235a04a06fba	f	${role_default-roles}	default-roles-master	e09f66b1-fa27-4fd8-affd-235a04a06fba	\N	\N
3754d5bb-7a83-4a96-8760-53f6c39104be	e09f66b1-fa27-4fd8-affd-235a04a06fba	f	${role_admin}	admin	e09f66b1-fa27-4fd8-affd-235a04a06fba	\N	\N
52575672-a91f-4419-90b9-b3062f7925a2	e09f66b1-fa27-4fd8-affd-235a04a06fba	f	${role_create-realm}	create-realm	e09f66b1-fa27-4fd8-affd-235a04a06fba	\N	\N
75282bf5-d19f-4252-bc6c-273cefd1f13f	40c35b4b-faec-4a96-befb-88e1049653c3	t	${role_create-client}	create-client	e09f66b1-fa27-4fd8-affd-235a04a06fba	40c35b4b-faec-4a96-befb-88e1049653c3	\N
10aed837-6bf5-4977-8c52-ea4e78d05a10	40c35b4b-faec-4a96-befb-88e1049653c3	t	${role_view-realm}	view-realm	e09f66b1-fa27-4fd8-affd-235a04a06fba	40c35b4b-faec-4a96-befb-88e1049653c3	\N
09c8838f-f370-4006-9856-9a2631ec6a83	40c35b4b-faec-4a96-befb-88e1049653c3	t	${role_view-users}	view-users	e09f66b1-fa27-4fd8-affd-235a04a06fba	40c35b4b-faec-4a96-befb-88e1049653c3	\N
4bf97d24-0699-4a5c-8c7b-1613bbe79f76	40c35b4b-faec-4a96-befb-88e1049653c3	t	${role_view-clients}	view-clients	e09f66b1-fa27-4fd8-affd-235a04a06fba	40c35b4b-faec-4a96-befb-88e1049653c3	\N
1e7785d4-0014-4a62-8c10-8fb974b29937	40c35b4b-faec-4a96-befb-88e1049653c3	t	${role_view-events}	view-events	e09f66b1-fa27-4fd8-affd-235a04a06fba	40c35b4b-faec-4a96-befb-88e1049653c3	\N
941cf071-7571-4e6a-bbaf-41699fff7a3e	40c35b4b-faec-4a96-befb-88e1049653c3	t	${role_view-identity-providers}	view-identity-providers	e09f66b1-fa27-4fd8-affd-235a04a06fba	40c35b4b-faec-4a96-befb-88e1049653c3	\N
2edcc1ff-efc4-4153-abdf-515a3f2e58d2	40c35b4b-faec-4a96-befb-88e1049653c3	t	${role_view-authorization}	view-authorization	e09f66b1-fa27-4fd8-affd-235a04a06fba	40c35b4b-faec-4a96-befb-88e1049653c3	\N
61b5d471-2b0a-4caa-9552-94d5ac40fc55	40c35b4b-faec-4a96-befb-88e1049653c3	t	${role_manage-realm}	manage-realm	e09f66b1-fa27-4fd8-affd-235a04a06fba	40c35b4b-faec-4a96-befb-88e1049653c3	\N
fc7a44ee-ac2a-4bfe-9f9b-01b5012c0714	40c35b4b-faec-4a96-befb-88e1049653c3	t	${role_manage-users}	manage-users	e09f66b1-fa27-4fd8-affd-235a04a06fba	40c35b4b-faec-4a96-befb-88e1049653c3	\N
3829166e-11b3-49b6-9fb3-f02ce971d428	40c35b4b-faec-4a96-befb-88e1049653c3	t	${role_manage-clients}	manage-clients	e09f66b1-fa27-4fd8-affd-235a04a06fba	40c35b4b-faec-4a96-befb-88e1049653c3	\N
8dce5a5e-88c3-4369-a44a-340df51831b7	40c35b4b-faec-4a96-befb-88e1049653c3	t	${role_manage-events}	manage-events	e09f66b1-fa27-4fd8-affd-235a04a06fba	40c35b4b-faec-4a96-befb-88e1049653c3	\N
fdd88ea9-e93c-4fca-bf7c-1572e44d2452	40c35b4b-faec-4a96-befb-88e1049653c3	t	${role_manage-identity-providers}	manage-identity-providers	e09f66b1-fa27-4fd8-affd-235a04a06fba	40c35b4b-faec-4a96-befb-88e1049653c3	\N
57b4c734-9273-4619-a155-f85fdb6574f6	40c35b4b-faec-4a96-befb-88e1049653c3	t	${role_manage-authorization}	manage-authorization	e09f66b1-fa27-4fd8-affd-235a04a06fba	40c35b4b-faec-4a96-befb-88e1049653c3	\N
cfec9652-31f8-42cc-ad92-57a23d050d86	40c35b4b-faec-4a96-befb-88e1049653c3	t	${role_query-users}	query-users	e09f66b1-fa27-4fd8-affd-235a04a06fba	40c35b4b-faec-4a96-befb-88e1049653c3	\N
a9191d63-46e4-44bd-8763-2695497484cd	40c35b4b-faec-4a96-befb-88e1049653c3	t	${role_query-clients}	query-clients	e09f66b1-fa27-4fd8-affd-235a04a06fba	40c35b4b-faec-4a96-befb-88e1049653c3	\N
318ec530-2e63-43cc-ab6c-a2363fbcc99b	40c35b4b-faec-4a96-befb-88e1049653c3	t	${role_query-realms}	query-realms	e09f66b1-fa27-4fd8-affd-235a04a06fba	40c35b4b-faec-4a96-befb-88e1049653c3	\N
4dac0d2c-57fb-4575-b817-66b7c9df2aab	40c35b4b-faec-4a96-befb-88e1049653c3	t	${role_query-groups}	query-groups	e09f66b1-fa27-4fd8-affd-235a04a06fba	40c35b4b-faec-4a96-befb-88e1049653c3	\N
27844a2e-2d84-48e2-a7f6-4868d1edbaba	0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	t	${role_view-profile}	view-profile	e09f66b1-fa27-4fd8-affd-235a04a06fba	0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	\N
ee1b354b-f983-46fb-9673-566aad6a4781	0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	t	${role_manage-account}	manage-account	e09f66b1-fa27-4fd8-affd-235a04a06fba	0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	\N
0ea38bea-af73-48d1-b5a1-db4643f0a57e	0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	t	${role_manage-account-links}	manage-account-links	e09f66b1-fa27-4fd8-affd-235a04a06fba	0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	\N
ec168c30-30e1-4bfa-b86c-b9e94b8397d3	0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	t	${role_view-applications}	view-applications	e09f66b1-fa27-4fd8-affd-235a04a06fba	0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	\N
e6a20f72-d631-46b8-9a69-f5bf86db76bf	0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	t	${role_view-consent}	view-consent	e09f66b1-fa27-4fd8-affd-235a04a06fba	0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	\N
e9e7a08e-72d8-4736-83af-ac6980bf97e2	0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	t	${role_manage-consent}	manage-consent	e09f66b1-fa27-4fd8-affd-235a04a06fba	0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	\N
572d3bb4-1e51-4fe3-ae87-7d2f1569e785	0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	t	${role_view-groups}	view-groups	e09f66b1-fa27-4fd8-affd-235a04a06fba	0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	\N
463ff4bc-2969-4f11-b78b-5e84cfcf189a	0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	t	${role_delete-account}	delete-account	e09f66b1-fa27-4fd8-affd-235a04a06fba	0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	\N
c9fa7948-bb60-419c-8964-d84ef9bf9745	c791726f-0fb3-4416-bb7b-238beb3ce15a	t	${role_read-token}	read-token	e09f66b1-fa27-4fd8-affd-235a04a06fba	c791726f-0fb3-4416-bb7b-238beb3ce15a	\N
4c3e2b66-fac2-46c1-a90c-3a85cd060f4a	40c35b4b-faec-4a96-befb-88e1049653c3	t	${role_impersonation}	impersonation	e09f66b1-fa27-4fd8-affd-235a04a06fba	40c35b4b-faec-4a96-befb-88e1049653c3	\N
f0c6944e-07ac-4402-b5c5-27e14db67e0a	e09f66b1-fa27-4fd8-affd-235a04a06fba	f	${role_offline-access}	offline_access	e09f66b1-fa27-4fd8-affd-235a04a06fba	\N	\N
068f1004-ab9f-43d0-9f52-eed8350dc094	e09f66b1-fa27-4fd8-affd-235a04a06fba	f	${role_uma_authorization}	uma_authorization	e09f66b1-fa27-4fd8-affd-235a04a06fba	\N	\N
f8287ef9-36e5-4a8c-a160-a4f30f694375	d4932c90-8454-4b23-b96a-05444067272e	f	${role_default-roles}	default-roles-calendar	d4932c90-8454-4b23-b96a-05444067272e	\N	\N
ee93f915-60ec-413a-a897-80b358fa0535	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	t	${role_create-client}	create-client	e09f66b1-fa27-4fd8-affd-235a04a06fba	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	\N
89d3d5b9-ad57-4a43-a053-bf5d15440c3d	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	t	${role_view-realm}	view-realm	e09f66b1-fa27-4fd8-affd-235a04a06fba	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	\N
d2be1ded-9021-4b58-8e51-d2c59bc1bf5d	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	t	${role_view-users}	view-users	e09f66b1-fa27-4fd8-affd-235a04a06fba	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	\N
0d7c7a50-81a6-414d-9cf2-7e5a9239e9bd	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	t	${role_view-clients}	view-clients	e09f66b1-fa27-4fd8-affd-235a04a06fba	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	\N
e116744e-cc6c-4dd5-9f68-03bd8320c0f6	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	t	${role_view-events}	view-events	e09f66b1-fa27-4fd8-affd-235a04a06fba	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	\N
74265096-1c69-4907-993d-ca7c35b858c4	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	t	${role_view-identity-providers}	view-identity-providers	e09f66b1-fa27-4fd8-affd-235a04a06fba	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	\N
5494fe48-d0ea-45ac-8d62-c45443f791c0	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	t	${role_view-authorization}	view-authorization	e09f66b1-fa27-4fd8-affd-235a04a06fba	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	\N
1515908c-7e0c-4446-8e90-64d810aeb7e7	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	t	${role_manage-realm}	manage-realm	e09f66b1-fa27-4fd8-affd-235a04a06fba	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	\N
901127ff-3427-4974-85ab-9ba003117612	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	t	${role_manage-users}	manage-users	e09f66b1-fa27-4fd8-affd-235a04a06fba	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	\N
c45a8c2d-7671-4d99-a51b-d1f237a7c06e	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	t	${role_manage-clients}	manage-clients	e09f66b1-fa27-4fd8-affd-235a04a06fba	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	\N
646a4542-4a0a-45ef-955f-c93ec2f40b17	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	t	${role_manage-events}	manage-events	e09f66b1-fa27-4fd8-affd-235a04a06fba	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	\N
1fd1ddf5-2582-474a-b95d-0f439e8f2d67	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	t	${role_manage-identity-providers}	manage-identity-providers	e09f66b1-fa27-4fd8-affd-235a04a06fba	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	\N
08198f0a-9d7c-4203-9840-b7d087b2ca4b	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	t	${role_manage-authorization}	manage-authorization	e09f66b1-fa27-4fd8-affd-235a04a06fba	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	\N
1f5fc15e-656b-49db-93ff-8be5ef5c6530	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	t	${role_query-users}	query-users	e09f66b1-fa27-4fd8-affd-235a04a06fba	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	\N
f31b8add-2d6b-4972-b709-0f9f5551d6f6	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	t	${role_query-clients}	query-clients	e09f66b1-fa27-4fd8-affd-235a04a06fba	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	\N
62a38834-4d77-4120-a5ea-8965a2542c35	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	t	${role_query-realms}	query-realms	e09f66b1-fa27-4fd8-affd-235a04a06fba	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	\N
ceb1c6f7-436d-45ca-8b31-60082aca362f	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	t	${role_query-groups}	query-groups	e09f66b1-fa27-4fd8-affd-235a04a06fba	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	\N
c9c9606b-db1d-4439-b22c-10e8478a91ba	d4932c90-8454-4b23-b96a-05444067272e	f	${role_offline-access}	offline_access	d4932c90-8454-4b23-b96a-05444067272e	\N	\N
c275580f-3be2-4fd9-bc16-c9070fa3ce9d	d4932c90-8454-4b23-b96a-05444067272e	f		calendar-editor	d4932c90-8454-4b23-b96a-05444067272e	\N	\N
9abb2835-a1f0-46e7-bc7a-c2ddf3b7c32a	d4932c90-8454-4b23-b96a-05444067272e	f	${role_uma_authorization}	uma_authorization	d4932c90-8454-4b23-b96a-05444067272e	\N	\N
92521f28-439b-49fd-9f69-aaad96d123d3	d4932c90-8454-4b23-b96a-05444067272e	f		calendar-viewer	d4932c90-8454-4b23-b96a-05444067272e	\N	\N
0f1972de-bd47-43bd-889c-987c155265ff	77d24d30-2ec1-47f9-a758-0826b164cacd	t	\N	uma_protection	d4932c90-8454-4b23-b96a-05444067272e	77d24d30-2ec1-47f9-a758-0826b164cacd	\N
67b635d0-94d8-4f7f-98a0-fc59251dd011	0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	${role_manage-realm}	manage-realm	d4932c90-8454-4b23-b96a-05444067272e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	\N
d2607bf1-c9e8-4875-aee9-de76c58da12a	0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	${role_impersonation}	impersonation	d4932c90-8454-4b23-b96a-05444067272e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	\N
bd7bf8e5-b41f-4587-9a94-a8de44501c77	0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	${role_view-events}	view-events	d4932c90-8454-4b23-b96a-05444067272e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	\N
e29aed4d-e476-448a-9d9c-2dc35fd3d4ef	0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	${role_manage-authorization}	manage-authorization	d4932c90-8454-4b23-b96a-05444067272e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	\N
e7e5e4aa-3cf8-40b7-99d3-5876bf98910e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	${role_manage-identity-providers}	manage-identity-providers	d4932c90-8454-4b23-b96a-05444067272e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	\N
eb8c00f7-e3fa-4736-ab53-601c41ac5c8f	0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	${role_view-authorization}	view-authorization	d4932c90-8454-4b23-b96a-05444067272e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	\N
8b2fa041-9e42-42a4-b869-4b5b2eb1fb3a	0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	${role_view-users}	view-users	d4932c90-8454-4b23-b96a-05444067272e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	\N
b5e9a1d9-d51e-4b54-9a4f-c275518b1d04	0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	${role_query-groups}	query-groups	d4932c90-8454-4b23-b96a-05444067272e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	\N
d6038e1b-050b-4788-a85e-baf311c32c92	0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	${role_view-identity-providers}	view-identity-providers	d4932c90-8454-4b23-b96a-05444067272e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	\N
0268a55a-1b1e-4767-b388-35ad2ca9e2f8	0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	${role_query-users}	query-users	d4932c90-8454-4b23-b96a-05444067272e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	\N
ebebf509-5cda-41e3-8c37-de49cbd7b77d	0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	${role_manage-clients}	manage-clients	d4932c90-8454-4b23-b96a-05444067272e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	\N
a9b61ab5-cad3-42d1-8013-afff516b0fdf	0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	${role_manage-users}	manage-users	d4932c90-8454-4b23-b96a-05444067272e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	\N
5715b557-c989-45aa-9fd3-8d2183ba8be3	0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	${role_query-realms}	query-realms	d4932c90-8454-4b23-b96a-05444067272e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	\N
66be4aef-fd18-4fe0-93aa-3c8a2ef9e93e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	${role_manage-events}	manage-events	d4932c90-8454-4b23-b96a-05444067272e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	\N
2aa87626-a7a4-409d-9708-663bde4372b0	0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	${role_realm-admin}	realm-admin	d4932c90-8454-4b23-b96a-05444067272e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	\N
b3c887b6-3018-40f8-bb86-7b1eeb323267	0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	${role_view-clients}	view-clients	d4932c90-8454-4b23-b96a-05444067272e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	\N
92c65f7f-e0ff-4d38-8bb6-581ff22d5ea9	0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	${role_create-client}	create-client	d4932c90-8454-4b23-b96a-05444067272e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	\N
b99843c8-c253-42e1-a71c-ed42ad9e6091	0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	${role_view-realm}	view-realm	d4932c90-8454-4b23-b96a-05444067272e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	\N
a4d32cda-4aa4-4011-aca5-bc193ee374b8	0df0a01c-66ef-4e56-bcd6-53211c3965b5	t	${role_query-clients}	query-clients	d4932c90-8454-4b23-b96a-05444067272e	0df0a01c-66ef-4e56-bcd6-53211c3965b5	\N
a7b6b17d-aaa9-4090-81f3-7db4e8b78306	d9a8b9bf-ff5c-46f7-895a-f06aaae0a1dc	t	${role_read-token}	read-token	d4932c90-8454-4b23-b96a-05444067272e	d9a8b9bf-ff5c-46f7-895a-f06aaae0a1dc	\N
f0d1ba3e-d6de-4f83-9805-814635c0551e	6eae40bd-bf2a-4118-9659-5673c2ca655e	t	${role_view-groups}	view-groups	d4932c90-8454-4b23-b96a-05444067272e	6eae40bd-bf2a-4118-9659-5673c2ca655e	\N
30cad8e8-2ce1-448d-a38e-c051d93dccf2	6eae40bd-bf2a-4118-9659-5673c2ca655e	t	${role_manage-account-links}	manage-account-links	d4932c90-8454-4b23-b96a-05444067272e	6eae40bd-bf2a-4118-9659-5673c2ca655e	\N
4f333366-de06-47da-aa37-ddbd59d39ad1	6eae40bd-bf2a-4118-9659-5673c2ca655e	t	${role_manage-consent}	manage-consent	d4932c90-8454-4b23-b96a-05444067272e	6eae40bd-bf2a-4118-9659-5673c2ca655e	\N
38c2f596-c17c-443b-88c3-715973e661b2	6eae40bd-bf2a-4118-9659-5673c2ca655e	t	${role_view-profile}	view-profile	d4932c90-8454-4b23-b96a-05444067272e	6eae40bd-bf2a-4118-9659-5673c2ca655e	\N
65bb73fe-43af-48c3-acc2-d0a3b9ab36bd	6eae40bd-bf2a-4118-9659-5673c2ca655e	t	${role_view-consent}	view-consent	d4932c90-8454-4b23-b96a-05444067272e	6eae40bd-bf2a-4118-9659-5673c2ca655e	\N
180b22aa-8316-42e7-aeda-a465c7849c22	6eae40bd-bf2a-4118-9659-5673c2ca655e	t	${role_delete-account}	delete-account	d4932c90-8454-4b23-b96a-05444067272e	6eae40bd-bf2a-4118-9659-5673c2ca655e	\N
3ec382b3-405c-4704-acc7-49bb89aa04f3	6eae40bd-bf2a-4118-9659-5673c2ca655e	t	${role_manage-account}	manage-account	d4932c90-8454-4b23-b96a-05444067272e	6eae40bd-bf2a-4118-9659-5673c2ca655e	\N
e40dffb6-47ed-482a-892e-9f561ea50c20	6eae40bd-bf2a-4118-9659-5673c2ca655e	t	${role_view-applications}	view-applications	d4932c90-8454-4b23-b96a-05444067272e	6eae40bd-bf2a-4118-9659-5673c2ca655e	\N
3d456e06-9b0c-4b40-8830-9e7fcedb570b	43022b0a-4e08-4d60-ad6c-8a872d5e2f59	t	\N	uma_protection	d4932c90-8454-4b23-b96a-05444067272e	43022b0a-4e08-4d60-ad6c-8a872d5e2f59	\N
25182d86-79f1-4016-862a-b07db1d4f23e	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	t	${role_impersonation}	impersonation	e09f66b1-fa27-4fd8-affd-235a04a06fba	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	\N
569bdab3-c50b-4188-a27e-fb1a4c685a1f	d4932c90-8454-4b23-b96a-05444067272e	f		admin	d4932c90-8454-4b23-b96a-05444067272e	\N	\N
ccdbd4ff-553d-44af-8b5d-a634908f4d9b	cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	t	\N	uma_protection	d4932c90-8454-4b23-b96a-05444067272e	cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	\N
b99b074b-753e-4bb9-81cb-17ff4b1f0b24	cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	t		admin	d4932c90-8454-4b23-b96a-05444067272e	cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	\N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migration_model (id, version, update_time) FROM stdin;
8xjiy	22.0.1	1690440863
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
2ea30141-5e9b-4044-b4fe-9053cfc4fc33	code	// by default, grants any permission associated with this policy\n$evaluation.grant();\n
b8d5227d-c91e-4fed-b5ce-cf15a4197f45	defaultResourceType	urn:calendar-api:resources:default
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
02e6c03a-da76-48fb-81e7-a552b0640a5f	audience resolve	openid-connect	oidc-audience-resolve-mapper	b32b8e24-6c0c-415c-92de-6602b7e4d1a8	\N
dcedd704-dfa1-4243-a0b2-b1d924155984	locale	openid-connect	oidc-usermodel-attribute-mapper	b18471e0-3804-4b98-b391-bf56dd4dc923	\N
858839c9-b449-456c-841e-50aa02c8cf54	role list	saml	saml-role-list-mapper	\N	422b07be-cb79-4b0c-8bba-d6014b71fe48
cafb008f-892a-4c79-81ca-f4b2f0a4831b	full name	openid-connect	oidc-full-name-mapper	\N	db7dde31-c3a8-4aa6-acd3-fc531b3742d6
bbc52a3c-4715-4805-bf15-305f17addbed	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	db7dde31-c3a8-4aa6-acd3-fc531b3742d6
99a60ae9-b2ed-498e-b73c-4fe5ca2b9f6f	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	db7dde31-c3a8-4aa6-acd3-fc531b3742d6
16a99c0f-8f08-418e-863b-02f9ec6eba87	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	db7dde31-c3a8-4aa6-acd3-fc531b3742d6
ec709733-66a6-480d-ae17-ee3b22f99a13	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	db7dde31-c3a8-4aa6-acd3-fc531b3742d6
d9e5860b-503a-4f3a-a891-b92f9f571a51	username	openid-connect	oidc-usermodel-attribute-mapper	\N	db7dde31-c3a8-4aa6-acd3-fc531b3742d6
ff42cbee-5022-4033-9aa3-94364edcd1ae	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	db7dde31-c3a8-4aa6-acd3-fc531b3742d6
def3ea8c-0e46-426e-a2d9-9666d3c0a17f	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	db7dde31-c3a8-4aa6-acd3-fc531b3742d6
1f8ef6f9-da86-44fa-a93d-62f22a78f44b	website	openid-connect	oidc-usermodel-attribute-mapper	\N	db7dde31-c3a8-4aa6-acd3-fc531b3742d6
e5051a4a-c9ba-4065-87bd-df543780c474	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	db7dde31-c3a8-4aa6-acd3-fc531b3742d6
3d5ea5dd-27ed-4432-8d0f-e150da53d265	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	db7dde31-c3a8-4aa6-acd3-fc531b3742d6
b2d543d1-b544-425a-abf9-10a350db7f06	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	db7dde31-c3a8-4aa6-acd3-fc531b3742d6
1ada3ab6-4b16-40bb-b6b9-a06a2d832aa8	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	db7dde31-c3a8-4aa6-acd3-fc531b3742d6
3c41e0aa-2e44-4299-9606-32ff1b3f8334	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	db7dde31-c3a8-4aa6-acd3-fc531b3742d6
a1e04133-a0f1-4150-8787-39476f2db8c9	email	openid-connect	oidc-usermodel-attribute-mapper	\N	ed8664ac-2c9a-4e49-bfe1-d5b2aa754022
4c1d0a69-c43f-47ab-b01e-7bd29138800d	email verified	openid-connect	oidc-usermodel-property-mapper	\N	ed8664ac-2c9a-4e49-bfe1-d5b2aa754022
3e00ffcc-1e99-4850-ae1d-dd50645ce2b2	address	openid-connect	oidc-address-mapper	\N	f219789b-cb94-422d-94c7-4463bd111d9e
5a825469-ce5b-43ca-89b9-7f281f7c80ba	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	1c5436b6-bdff-48b6-83f1-765a07732981
78f57455-14d8-4533-a184-cf5e6b4ee7fc	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	1c5436b6-bdff-48b6-83f1-765a07732981
2f178412-498b-45fa-b379-1033cb2a41df	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	9a4e11a6-822d-4505-8044-a0e89f80b7fb
4d11ff97-a8ac-4cb8-9873-d6651f1d72d6	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	9a4e11a6-822d-4505-8044-a0e89f80b7fb
cb135c92-1267-4af5-b9ea-63aa646b1baf	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	9a4e11a6-822d-4505-8044-a0e89f80b7fb
a83ab681-b82b-4a26-9830-797a834a3b36	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	095cc82f-d2de-47c6-b73f-686d60c98e02
36c9e285-f190-44b2-9786-954ed016c269	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	1e6d5d5e-2134-4fe3-81f2-52d636691235
341e4240-54a4-4cfd-93a5-bbd905fe26d0	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	1e6d5d5e-2134-4fe3-81f2-52d636691235
18ea6b5d-2680-4d9e-af66-6319728314d2	acr loa level	openid-connect	oidc-acr-mapper	\N	88ca1fa4-1955-465e-992c-d65d7270cf38
1d4afb82-646d-47e3-9cdc-b17978a23292	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	305e297a-f075-4140-b9bb-76cd6a18fc70
fbd37ab2-43c7-444f-abad-a412d70af6a9	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	2fa54bc7-079f-44a4-af94-ee9a942a9d36
6e2304ca-d22d-45ec-9071-fa72011bbb2d	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	2fa54bc7-079f-44a4-af94-ee9a942a9d36
612798aa-3a92-4ac1-927c-23073feca615	username	openid-connect	oidc-usermodel-attribute-mapper	\N	2fa54bc7-079f-44a4-af94-ee9a942a9d36
1383d000-e259-484b-9856-b0a761c9822f	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	2fa54bc7-079f-44a4-af94-ee9a942a9d36
fbc8c2d7-d541-4d78-83a2-a7f0eb13a20b	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	2fa54bc7-079f-44a4-af94-ee9a942a9d36
7ffa039e-90c2-4515-9da5-825d5c45249b	full name	openid-connect	oidc-full-name-mapper	\N	2fa54bc7-079f-44a4-af94-ee9a942a9d36
2952c5df-5f81-4a25-b9af-b766eaebe1e0	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	2fa54bc7-079f-44a4-af94-ee9a942a9d36
b654f49d-9feb-411d-8369-a70f41a285c7	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	2fa54bc7-079f-44a4-af94-ee9a942a9d36
38d43dd5-82ca-4d9f-8de5-ba03dc970aad	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	2fa54bc7-079f-44a4-af94-ee9a942a9d36
f30a32e4-cc68-4333-8816-5095ddb0201a	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	2fa54bc7-079f-44a4-af94-ee9a942a9d36
3625434b-c6da-4abf-8264-c8673fc63496	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	2fa54bc7-079f-44a4-af94-ee9a942a9d36
00f69cc8-2f82-404f-b8fa-39ad26affdff	website	openid-connect	oidc-usermodel-attribute-mapper	\N	2fa54bc7-079f-44a4-af94-ee9a942a9d36
c3899b48-3daf-4fb9-b1ed-e36fc4539286	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	2fa54bc7-079f-44a4-af94-ee9a942a9d36
642c6766-baba-4290-bad2-1caf980c53ca	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	2fa54bc7-079f-44a4-af94-ee9a942a9d36
4592a8d4-d279-40ee-b04e-5bfea6c96031	email verified	openid-connect	oidc-usermodel-property-mapper	\N	90129970-b394-4de3-915b-1a3f36d15fee
247b496a-a908-4a10-9079-b0f57c6ca142	email	openid-connect	oidc-usermodel-attribute-mapper	\N	90129970-b394-4de3-915b-1a3f36d15fee
1518e926-6909-47cc-b908-5a310b46c0df	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	8f8bd907-7a70-4f0c-8301-2706005267e6
d9fd6056-c26b-4367-b63c-f8e6d658e7ab	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	8f8bd907-7a70-4f0c-8301-2706005267e6
e74fb1ad-5dce-464d-a8f5-87478f631eba	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	8f8bd907-7a70-4f0c-8301-2706005267e6
96b218a3-409c-4cbf-a128-b7338d144a14	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	0159a26c-8659-4a5f-942d-674d075adcad
b6b1a20c-d109-46e7-8f03-6b9f38a82b84	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	0159a26c-8659-4a5f-942d-674d075adcad
20fc4ce1-99f5-4595-ac7e-2eb6d0b150fd	acr loa level	openid-connect	oidc-acr-mapper	\N	cadae9cb-c07d-4eab-bfe1-2b8ce939cd9d
8547d1ae-4664-4dd3-adae-d121c7be2ab1	address	openid-connect	oidc-address-mapper	\N	34667733-3773-424d-aa8d-d23d6573eba8
21bbc90c-7344-46df-808d-50d22b780202	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	f62f28ab-12f7-40af-89ac-54530348e79c
a42b0a97-a8b3-400f-b98b-0e9770eca376	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	f62f28ab-12f7-40af-89ac-54530348e79c
36ad2ea5-7ade-4819-b227-c941b0af1e8a	role list	saml	saml-role-list-mapper	\N	b7b454b7-2cf3-4336-af6e-a3ced9539c70
a9a7bbf3-529c-452e-880f-4b6f76efa416	audience resolve	openid-connect	oidc-audience-resolve-mapper	93709245-2824-46cb-a48c-32cc8a45d4cc	\N
e7760def-e79e-4472-afb6-ac7da6d52112	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	77d24d30-2ec1-47f9-a758-0826b164cacd	\N
d338ef80-868b-4dc7-bc0d-3894efae7ccf	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	77d24d30-2ec1-47f9-a758-0826b164cacd	\N
8620f390-0d12-426c-9874-8d1c531d7165	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	77d24d30-2ec1-47f9-a758-0826b164cacd	\N
4e789733-a6f1-4707-b895-7ebfeb450b4b	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	43022b0a-4e08-4d60-ad6c-8a872d5e2f59	\N
daf9bff2-ffe3-4765-aa02-11fdc0f7b30b	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	43022b0a-4e08-4d60-ad6c-8a872d5e2f59	\N
8e3563cd-ef1e-4c06-8baa-8b7700c2b957	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	43022b0a-4e08-4d60-ad6c-8a872d5e2f59	\N
1da6a0a3-522f-4a5d-aec5-b23f8a2b5382	locale	openid-connect	oidc-usermodel-attribute-mapper	a39f7d32-3924-49d0-8904-bd9e4409411c	\N
27716c8f-cabb-49d3-b821-c24f6650cbd0	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	\N
f9e1b117-22de-4107-ad0f-585be5351262	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	\N
2a75c508-cd7f-4536-bb72-22b333cfade7	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	\N
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
dcedd704-dfa1-4243-a0b2-b1d924155984	true	userinfo.token.claim
dcedd704-dfa1-4243-a0b2-b1d924155984	locale	user.attribute
dcedd704-dfa1-4243-a0b2-b1d924155984	true	id.token.claim
dcedd704-dfa1-4243-a0b2-b1d924155984	true	access.token.claim
dcedd704-dfa1-4243-a0b2-b1d924155984	locale	claim.name
dcedd704-dfa1-4243-a0b2-b1d924155984	String	jsonType.label
858839c9-b449-456c-841e-50aa02c8cf54	false	single
858839c9-b449-456c-841e-50aa02c8cf54	Basic	attribute.nameformat
858839c9-b449-456c-841e-50aa02c8cf54	Role	attribute.name
16a99c0f-8f08-418e-863b-02f9ec6eba87	true	userinfo.token.claim
16a99c0f-8f08-418e-863b-02f9ec6eba87	middleName	user.attribute
16a99c0f-8f08-418e-863b-02f9ec6eba87	true	id.token.claim
16a99c0f-8f08-418e-863b-02f9ec6eba87	true	access.token.claim
16a99c0f-8f08-418e-863b-02f9ec6eba87	middle_name	claim.name
16a99c0f-8f08-418e-863b-02f9ec6eba87	String	jsonType.label
1ada3ab6-4b16-40bb-b6b9-a06a2d832aa8	true	userinfo.token.claim
1ada3ab6-4b16-40bb-b6b9-a06a2d832aa8	locale	user.attribute
1ada3ab6-4b16-40bb-b6b9-a06a2d832aa8	true	id.token.claim
1ada3ab6-4b16-40bb-b6b9-a06a2d832aa8	true	access.token.claim
1ada3ab6-4b16-40bb-b6b9-a06a2d832aa8	locale	claim.name
1ada3ab6-4b16-40bb-b6b9-a06a2d832aa8	String	jsonType.label
1f8ef6f9-da86-44fa-a93d-62f22a78f44b	true	userinfo.token.claim
1f8ef6f9-da86-44fa-a93d-62f22a78f44b	website	user.attribute
1f8ef6f9-da86-44fa-a93d-62f22a78f44b	true	id.token.claim
1f8ef6f9-da86-44fa-a93d-62f22a78f44b	true	access.token.claim
1f8ef6f9-da86-44fa-a93d-62f22a78f44b	website	claim.name
1f8ef6f9-da86-44fa-a93d-62f22a78f44b	String	jsonType.label
3c41e0aa-2e44-4299-9606-32ff1b3f8334	true	userinfo.token.claim
3c41e0aa-2e44-4299-9606-32ff1b3f8334	updatedAt	user.attribute
3c41e0aa-2e44-4299-9606-32ff1b3f8334	true	id.token.claim
3c41e0aa-2e44-4299-9606-32ff1b3f8334	true	access.token.claim
3c41e0aa-2e44-4299-9606-32ff1b3f8334	updated_at	claim.name
3c41e0aa-2e44-4299-9606-32ff1b3f8334	long	jsonType.label
3d5ea5dd-27ed-4432-8d0f-e150da53d265	true	userinfo.token.claim
3d5ea5dd-27ed-4432-8d0f-e150da53d265	birthdate	user.attribute
3d5ea5dd-27ed-4432-8d0f-e150da53d265	true	id.token.claim
3d5ea5dd-27ed-4432-8d0f-e150da53d265	true	access.token.claim
3d5ea5dd-27ed-4432-8d0f-e150da53d265	birthdate	claim.name
3d5ea5dd-27ed-4432-8d0f-e150da53d265	String	jsonType.label
99a60ae9-b2ed-498e-b73c-4fe5ca2b9f6f	true	userinfo.token.claim
99a60ae9-b2ed-498e-b73c-4fe5ca2b9f6f	firstName	user.attribute
99a60ae9-b2ed-498e-b73c-4fe5ca2b9f6f	true	id.token.claim
99a60ae9-b2ed-498e-b73c-4fe5ca2b9f6f	true	access.token.claim
99a60ae9-b2ed-498e-b73c-4fe5ca2b9f6f	given_name	claim.name
99a60ae9-b2ed-498e-b73c-4fe5ca2b9f6f	String	jsonType.label
b2d543d1-b544-425a-abf9-10a350db7f06	true	userinfo.token.claim
b2d543d1-b544-425a-abf9-10a350db7f06	zoneinfo	user.attribute
b2d543d1-b544-425a-abf9-10a350db7f06	true	id.token.claim
b2d543d1-b544-425a-abf9-10a350db7f06	true	access.token.claim
b2d543d1-b544-425a-abf9-10a350db7f06	zoneinfo	claim.name
b2d543d1-b544-425a-abf9-10a350db7f06	String	jsonType.label
bbc52a3c-4715-4805-bf15-305f17addbed	true	userinfo.token.claim
bbc52a3c-4715-4805-bf15-305f17addbed	lastName	user.attribute
bbc52a3c-4715-4805-bf15-305f17addbed	true	id.token.claim
bbc52a3c-4715-4805-bf15-305f17addbed	true	access.token.claim
bbc52a3c-4715-4805-bf15-305f17addbed	family_name	claim.name
bbc52a3c-4715-4805-bf15-305f17addbed	String	jsonType.label
cafb008f-892a-4c79-81ca-f4b2f0a4831b	true	userinfo.token.claim
cafb008f-892a-4c79-81ca-f4b2f0a4831b	true	id.token.claim
cafb008f-892a-4c79-81ca-f4b2f0a4831b	true	access.token.claim
d9e5860b-503a-4f3a-a891-b92f9f571a51	true	userinfo.token.claim
d9e5860b-503a-4f3a-a891-b92f9f571a51	username	user.attribute
d9e5860b-503a-4f3a-a891-b92f9f571a51	true	id.token.claim
d9e5860b-503a-4f3a-a891-b92f9f571a51	true	access.token.claim
d9e5860b-503a-4f3a-a891-b92f9f571a51	preferred_username	claim.name
d9e5860b-503a-4f3a-a891-b92f9f571a51	String	jsonType.label
def3ea8c-0e46-426e-a2d9-9666d3c0a17f	true	userinfo.token.claim
def3ea8c-0e46-426e-a2d9-9666d3c0a17f	picture	user.attribute
def3ea8c-0e46-426e-a2d9-9666d3c0a17f	true	id.token.claim
def3ea8c-0e46-426e-a2d9-9666d3c0a17f	true	access.token.claim
def3ea8c-0e46-426e-a2d9-9666d3c0a17f	picture	claim.name
def3ea8c-0e46-426e-a2d9-9666d3c0a17f	String	jsonType.label
e5051a4a-c9ba-4065-87bd-df543780c474	true	userinfo.token.claim
e5051a4a-c9ba-4065-87bd-df543780c474	gender	user.attribute
e5051a4a-c9ba-4065-87bd-df543780c474	true	id.token.claim
e5051a4a-c9ba-4065-87bd-df543780c474	true	access.token.claim
e5051a4a-c9ba-4065-87bd-df543780c474	gender	claim.name
e5051a4a-c9ba-4065-87bd-df543780c474	String	jsonType.label
ec709733-66a6-480d-ae17-ee3b22f99a13	true	userinfo.token.claim
ec709733-66a6-480d-ae17-ee3b22f99a13	nickname	user.attribute
ec709733-66a6-480d-ae17-ee3b22f99a13	true	id.token.claim
ec709733-66a6-480d-ae17-ee3b22f99a13	true	access.token.claim
ec709733-66a6-480d-ae17-ee3b22f99a13	nickname	claim.name
ec709733-66a6-480d-ae17-ee3b22f99a13	String	jsonType.label
ff42cbee-5022-4033-9aa3-94364edcd1ae	true	userinfo.token.claim
ff42cbee-5022-4033-9aa3-94364edcd1ae	profile	user.attribute
ff42cbee-5022-4033-9aa3-94364edcd1ae	true	id.token.claim
ff42cbee-5022-4033-9aa3-94364edcd1ae	true	access.token.claim
ff42cbee-5022-4033-9aa3-94364edcd1ae	profile	claim.name
ff42cbee-5022-4033-9aa3-94364edcd1ae	String	jsonType.label
4c1d0a69-c43f-47ab-b01e-7bd29138800d	true	userinfo.token.claim
4c1d0a69-c43f-47ab-b01e-7bd29138800d	emailVerified	user.attribute
4c1d0a69-c43f-47ab-b01e-7bd29138800d	true	id.token.claim
4c1d0a69-c43f-47ab-b01e-7bd29138800d	true	access.token.claim
4c1d0a69-c43f-47ab-b01e-7bd29138800d	email_verified	claim.name
4c1d0a69-c43f-47ab-b01e-7bd29138800d	boolean	jsonType.label
a1e04133-a0f1-4150-8787-39476f2db8c9	true	userinfo.token.claim
a1e04133-a0f1-4150-8787-39476f2db8c9	email	user.attribute
a1e04133-a0f1-4150-8787-39476f2db8c9	true	id.token.claim
a1e04133-a0f1-4150-8787-39476f2db8c9	true	access.token.claim
a1e04133-a0f1-4150-8787-39476f2db8c9	email	claim.name
a1e04133-a0f1-4150-8787-39476f2db8c9	String	jsonType.label
3e00ffcc-1e99-4850-ae1d-dd50645ce2b2	formatted	user.attribute.formatted
3e00ffcc-1e99-4850-ae1d-dd50645ce2b2	country	user.attribute.country
3e00ffcc-1e99-4850-ae1d-dd50645ce2b2	postal_code	user.attribute.postal_code
3e00ffcc-1e99-4850-ae1d-dd50645ce2b2	true	userinfo.token.claim
3e00ffcc-1e99-4850-ae1d-dd50645ce2b2	street	user.attribute.street
3e00ffcc-1e99-4850-ae1d-dd50645ce2b2	true	id.token.claim
3e00ffcc-1e99-4850-ae1d-dd50645ce2b2	region	user.attribute.region
3e00ffcc-1e99-4850-ae1d-dd50645ce2b2	true	access.token.claim
3e00ffcc-1e99-4850-ae1d-dd50645ce2b2	locality	user.attribute.locality
5a825469-ce5b-43ca-89b9-7f281f7c80ba	true	userinfo.token.claim
5a825469-ce5b-43ca-89b9-7f281f7c80ba	phoneNumber	user.attribute
5a825469-ce5b-43ca-89b9-7f281f7c80ba	true	id.token.claim
5a825469-ce5b-43ca-89b9-7f281f7c80ba	true	access.token.claim
5a825469-ce5b-43ca-89b9-7f281f7c80ba	phone_number	claim.name
5a825469-ce5b-43ca-89b9-7f281f7c80ba	String	jsonType.label
78f57455-14d8-4533-a184-cf5e6b4ee7fc	true	userinfo.token.claim
78f57455-14d8-4533-a184-cf5e6b4ee7fc	phoneNumberVerified	user.attribute
78f57455-14d8-4533-a184-cf5e6b4ee7fc	true	id.token.claim
78f57455-14d8-4533-a184-cf5e6b4ee7fc	true	access.token.claim
78f57455-14d8-4533-a184-cf5e6b4ee7fc	phone_number_verified	claim.name
78f57455-14d8-4533-a184-cf5e6b4ee7fc	boolean	jsonType.label
2f178412-498b-45fa-b379-1033cb2a41df	true	multivalued
2f178412-498b-45fa-b379-1033cb2a41df	foo	user.attribute
2f178412-498b-45fa-b379-1033cb2a41df	true	access.token.claim
2f178412-498b-45fa-b379-1033cb2a41df	realm_access.roles	claim.name
2f178412-498b-45fa-b379-1033cb2a41df	String	jsonType.label
4d11ff97-a8ac-4cb8-9873-d6651f1d72d6	true	multivalued
4d11ff97-a8ac-4cb8-9873-d6651f1d72d6	foo	user.attribute
4d11ff97-a8ac-4cb8-9873-d6651f1d72d6	true	access.token.claim
4d11ff97-a8ac-4cb8-9873-d6651f1d72d6	resource_access.${client_id}.roles	claim.name
4d11ff97-a8ac-4cb8-9873-d6651f1d72d6	String	jsonType.label
341e4240-54a4-4cfd-93a5-bbd905fe26d0	true	multivalued
341e4240-54a4-4cfd-93a5-bbd905fe26d0	foo	user.attribute
341e4240-54a4-4cfd-93a5-bbd905fe26d0	true	id.token.claim
341e4240-54a4-4cfd-93a5-bbd905fe26d0	true	access.token.claim
341e4240-54a4-4cfd-93a5-bbd905fe26d0	groups	claim.name
341e4240-54a4-4cfd-93a5-bbd905fe26d0	String	jsonType.label
36c9e285-f190-44b2-9786-954ed016c269	true	userinfo.token.claim
36c9e285-f190-44b2-9786-954ed016c269	username	user.attribute
36c9e285-f190-44b2-9786-954ed016c269	true	id.token.claim
36c9e285-f190-44b2-9786-954ed016c269	true	access.token.claim
36c9e285-f190-44b2-9786-954ed016c269	upn	claim.name
36c9e285-f190-44b2-9786-954ed016c269	String	jsonType.label
18ea6b5d-2680-4d9e-af66-6319728314d2	true	id.token.claim
18ea6b5d-2680-4d9e-af66-6319728314d2	true	access.token.claim
00f69cc8-2f82-404f-b8fa-39ad26affdff	true	userinfo.token.claim
00f69cc8-2f82-404f-b8fa-39ad26affdff	website	user.attribute
00f69cc8-2f82-404f-b8fa-39ad26affdff	true	id.token.claim
00f69cc8-2f82-404f-b8fa-39ad26affdff	true	access.token.claim
00f69cc8-2f82-404f-b8fa-39ad26affdff	website	claim.name
00f69cc8-2f82-404f-b8fa-39ad26affdff	String	jsonType.label
1383d000-e259-484b-9856-b0a761c9822f	true	userinfo.token.claim
1383d000-e259-484b-9856-b0a761c9822f	picture	user.attribute
1383d000-e259-484b-9856-b0a761c9822f	true	id.token.claim
1383d000-e259-484b-9856-b0a761c9822f	true	access.token.claim
1383d000-e259-484b-9856-b0a761c9822f	picture	claim.name
1383d000-e259-484b-9856-b0a761c9822f	String	jsonType.label
2952c5df-5f81-4a25-b9af-b766eaebe1e0	true	userinfo.token.claim
2952c5df-5f81-4a25-b9af-b766eaebe1e0	nickname	user.attribute
2952c5df-5f81-4a25-b9af-b766eaebe1e0	true	id.token.claim
2952c5df-5f81-4a25-b9af-b766eaebe1e0	true	access.token.claim
2952c5df-5f81-4a25-b9af-b766eaebe1e0	nickname	claim.name
2952c5df-5f81-4a25-b9af-b766eaebe1e0	String	jsonType.label
3625434b-c6da-4abf-8264-c8673fc63496	true	userinfo.token.claim
3625434b-c6da-4abf-8264-c8673fc63496	locale	user.attribute
3625434b-c6da-4abf-8264-c8673fc63496	true	id.token.claim
3625434b-c6da-4abf-8264-c8673fc63496	true	access.token.claim
3625434b-c6da-4abf-8264-c8673fc63496	locale	claim.name
3625434b-c6da-4abf-8264-c8673fc63496	String	jsonType.label
38d43dd5-82ca-4d9f-8de5-ba03dc970aad	true	userinfo.token.claim
38d43dd5-82ca-4d9f-8de5-ba03dc970aad	lastName	user.attribute
38d43dd5-82ca-4d9f-8de5-ba03dc970aad	true	id.token.claim
38d43dd5-82ca-4d9f-8de5-ba03dc970aad	true	access.token.claim
38d43dd5-82ca-4d9f-8de5-ba03dc970aad	family_name	claim.name
38d43dd5-82ca-4d9f-8de5-ba03dc970aad	String	jsonType.label
612798aa-3a92-4ac1-927c-23073feca615	true	userinfo.token.claim
612798aa-3a92-4ac1-927c-23073feca615	username	user.attribute
612798aa-3a92-4ac1-927c-23073feca615	true	id.token.claim
612798aa-3a92-4ac1-927c-23073feca615	true	access.token.claim
612798aa-3a92-4ac1-927c-23073feca615	preferred_username	claim.name
612798aa-3a92-4ac1-927c-23073feca615	String	jsonType.label
642c6766-baba-4290-bad2-1caf980c53ca	true	userinfo.token.claim
642c6766-baba-4290-bad2-1caf980c53ca	zoneinfo	user.attribute
642c6766-baba-4290-bad2-1caf980c53ca	true	id.token.claim
642c6766-baba-4290-bad2-1caf980c53ca	true	access.token.claim
642c6766-baba-4290-bad2-1caf980c53ca	zoneinfo	claim.name
642c6766-baba-4290-bad2-1caf980c53ca	String	jsonType.label
6e2304ca-d22d-45ec-9071-fa72011bbb2d	true	userinfo.token.claim
6e2304ca-d22d-45ec-9071-fa72011bbb2d	updatedAt	user.attribute
6e2304ca-d22d-45ec-9071-fa72011bbb2d	true	id.token.claim
6e2304ca-d22d-45ec-9071-fa72011bbb2d	true	access.token.claim
6e2304ca-d22d-45ec-9071-fa72011bbb2d	updated_at	claim.name
6e2304ca-d22d-45ec-9071-fa72011bbb2d	long	jsonType.label
7ffa039e-90c2-4515-9da5-825d5c45249b	true	id.token.claim
7ffa039e-90c2-4515-9da5-825d5c45249b	true	access.token.claim
7ffa039e-90c2-4515-9da5-825d5c45249b	true	userinfo.token.claim
b654f49d-9feb-411d-8369-a70f41a285c7	true	userinfo.token.claim
b654f49d-9feb-411d-8369-a70f41a285c7	profile	user.attribute
b654f49d-9feb-411d-8369-a70f41a285c7	true	id.token.claim
b654f49d-9feb-411d-8369-a70f41a285c7	true	access.token.claim
b654f49d-9feb-411d-8369-a70f41a285c7	profile	claim.name
b654f49d-9feb-411d-8369-a70f41a285c7	String	jsonType.label
c3899b48-3daf-4fb9-b1ed-e36fc4539286	true	userinfo.token.claim
c3899b48-3daf-4fb9-b1ed-e36fc4539286	gender	user.attribute
c3899b48-3daf-4fb9-b1ed-e36fc4539286	true	id.token.claim
c3899b48-3daf-4fb9-b1ed-e36fc4539286	true	access.token.claim
c3899b48-3daf-4fb9-b1ed-e36fc4539286	gender	claim.name
c3899b48-3daf-4fb9-b1ed-e36fc4539286	String	jsonType.label
f30a32e4-cc68-4333-8816-5095ddb0201a	true	userinfo.token.claim
f30a32e4-cc68-4333-8816-5095ddb0201a	birthdate	user.attribute
f30a32e4-cc68-4333-8816-5095ddb0201a	true	id.token.claim
f30a32e4-cc68-4333-8816-5095ddb0201a	true	access.token.claim
f30a32e4-cc68-4333-8816-5095ddb0201a	birthdate	claim.name
f30a32e4-cc68-4333-8816-5095ddb0201a	String	jsonType.label
fbc8c2d7-d541-4d78-83a2-a7f0eb13a20b	true	userinfo.token.claim
fbc8c2d7-d541-4d78-83a2-a7f0eb13a20b	middleName	user.attribute
fbc8c2d7-d541-4d78-83a2-a7f0eb13a20b	true	id.token.claim
fbc8c2d7-d541-4d78-83a2-a7f0eb13a20b	true	access.token.claim
fbc8c2d7-d541-4d78-83a2-a7f0eb13a20b	middle_name	claim.name
fbc8c2d7-d541-4d78-83a2-a7f0eb13a20b	String	jsonType.label
fbd37ab2-43c7-444f-abad-a412d70af6a9	true	userinfo.token.claim
fbd37ab2-43c7-444f-abad-a412d70af6a9	firstName	user.attribute
fbd37ab2-43c7-444f-abad-a412d70af6a9	true	id.token.claim
fbd37ab2-43c7-444f-abad-a412d70af6a9	true	access.token.claim
fbd37ab2-43c7-444f-abad-a412d70af6a9	given_name	claim.name
fbd37ab2-43c7-444f-abad-a412d70af6a9	String	jsonType.label
247b496a-a908-4a10-9079-b0f57c6ca142	true	userinfo.token.claim
247b496a-a908-4a10-9079-b0f57c6ca142	email	user.attribute
247b496a-a908-4a10-9079-b0f57c6ca142	true	id.token.claim
247b496a-a908-4a10-9079-b0f57c6ca142	true	access.token.claim
247b496a-a908-4a10-9079-b0f57c6ca142	email	claim.name
247b496a-a908-4a10-9079-b0f57c6ca142	String	jsonType.label
4592a8d4-d279-40ee-b04e-5bfea6c96031	true	userinfo.token.claim
4592a8d4-d279-40ee-b04e-5bfea6c96031	emailVerified	user.attribute
4592a8d4-d279-40ee-b04e-5bfea6c96031	true	id.token.claim
4592a8d4-d279-40ee-b04e-5bfea6c96031	true	access.token.claim
4592a8d4-d279-40ee-b04e-5bfea6c96031	email_verified	claim.name
4592a8d4-d279-40ee-b04e-5bfea6c96031	boolean	jsonType.label
1518e926-6909-47cc-b908-5a310b46c0df	foo	user.attribute
1518e926-6909-47cc-b908-5a310b46c0df	true	access.token.claim
1518e926-6909-47cc-b908-5a310b46c0df	realm_access.roles	claim.name
1518e926-6909-47cc-b908-5a310b46c0df	String	jsonType.label
1518e926-6909-47cc-b908-5a310b46c0df	true	multivalued
d9fd6056-c26b-4367-b63c-f8e6d658e7ab	foo	user.attribute
d9fd6056-c26b-4367-b63c-f8e6d658e7ab	true	access.token.claim
d9fd6056-c26b-4367-b63c-f8e6d658e7ab	resource_access.${client_id}.roles	claim.name
d9fd6056-c26b-4367-b63c-f8e6d658e7ab	String	jsonType.label
d9fd6056-c26b-4367-b63c-f8e6d658e7ab	true	multivalued
96b218a3-409c-4cbf-a128-b7338d144a14	true	userinfo.token.claim
96b218a3-409c-4cbf-a128-b7338d144a14	username	user.attribute
96b218a3-409c-4cbf-a128-b7338d144a14	true	id.token.claim
96b218a3-409c-4cbf-a128-b7338d144a14	true	access.token.claim
96b218a3-409c-4cbf-a128-b7338d144a14	upn	claim.name
96b218a3-409c-4cbf-a128-b7338d144a14	String	jsonType.label
b6b1a20c-d109-46e7-8f03-6b9f38a82b84	true	multivalued
b6b1a20c-d109-46e7-8f03-6b9f38a82b84	true	userinfo.token.claim
b6b1a20c-d109-46e7-8f03-6b9f38a82b84	foo	user.attribute
b6b1a20c-d109-46e7-8f03-6b9f38a82b84	true	id.token.claim
b6b1a20c-d109-46e7-8f03-6b9f38a82b84	true	access.token.claim
b6b1a20c-d109-46e7-8f03-6b9f38a82b84	groups	claim.name
b6b1a20c-d109-46e7-8f03-6b9f38a82b84	String	jsonType.label
20fc4ce1-99f5-4595-ac7e-2eb6d0b150fd	true	id.token.claim
20fc4ce1-99f5-4595-ac7e-2eb6d0b150fd	true	access.token.claim
20fc4ce1-99f5-4595-ac7e-2eb6d0b150fd	true	userinfo.token.claim
8547d1ae-4664-4dd3-adae-d121c7be2ab1	formatted	user.attribute.formatted
8547d1ae-4664-4dd3-adae-d121c7be2ab1	country	user.attribute.country
8547d1ae-4664-4dd3-adae-d121c7be2ab1	postal_code	user.attribute.postal_code
8547d1ae-4664-4dd3-adae-d121c7be2ab1	true	userinfo.token.claim
8547d1ae-4664-4dd3-adae-d121c7be2ab1	street	user.attribute.street
8547d1ae-4664-4dd3-adae-d121c7be2ab1	true	id.token.claim
8547d1ae-4664-4dd3-adae-d121c7be2ab1	region	user.attribute.region
8547d1ae-4664-4dd3-adae-d121c7be2ab1	true	access.token.claim
8547d1ae-4664-4dd3-adae-d121c7be2ab1	locality	user.attribute.locality
21bbc90c-7344-46df-808d-50d22b780202	true	userinfo.token.claim
21bbc90c-7344-46df-808d-50d22b780202	phoneNumber	user.attribute
21bbc90c-7344-46df-808d-50d22b780202	true	id.token.claim
21bbc90c-7344-46df-808d-50d22b780202	true	access.token.claim
21bbc90c-7344-46df-808d-50d22b780202	phone_number	claim.name
21bbc90c-7344-46df-808d-50d22b780202	String	jsonType.label
a42b0a97-a8b3-400f-b98b-0e9770eca376	true	userinfo.token.claim
a42b0a97-a8b3-400f-b98b-0e9770eca376	phoneNumberVerified	user.attribute
a42b0a97-a8b3-400f-b98b-0e9770eca376	true	id.token.claim
a42b0a97-a8b3-400f-b98b-0e9770eca376	true	access.token.claim
a42b0a97-a8b3-400f-b98b-0e9770eca376	phone_number_verified	claim.name
a42b0a97-a8b3-400f-b98b-0e9770eca376	boolean	jsonType.label
36ad2ea5-7ade-4819-b227-c941b0af1e8a	false	single
36ad2ea5-7ade-4819-b227-c941b0af1e8a	Basic	attribute.nameformat
36ad2ea5-7ade-4819-b227-c941b0af1e8a	Role	attribute.name
8620f390-0d12-426c-9874-8d1c531d7165	clientHost	user.session.note
8620f390-0d12-426c-9874-8d1c531d7165	true	id.token.claim
8620f390-0d12-426c-9874-8d1c531d7165	true	access.token.claim
8620f390-0d12-426c-9874-8d1c531d7165	clientHost	claim.name
8620f390-0d12-426c-9874-8d1c531d7165	String	jsonType.label
d338ef80-868b-4dc7-bc0d-3894efae7ccf	client_id	user.session.note
d338ef80-868b-4dc7-bc0d-3894efae7ccf	true	id.token.claim
d338ef80-868b-4dc7-bc0d-3894efae7ccf	true	access.token.claim
d338ef80-868b-4dc7-bc0d-3894efae7ccf	client_id	claim.name
d338ef80-868b-4dc7-bc0d-3894efae7ccf	String	jsonType.label
e7760def-e79e-4472-afb6-ac7da6d52112	clientAddress	user.session.note
e7760def-e79e-4472-afb6-ac7da6d52112	true	id.token.claim
e7760def-e79e-4472-afb6-ac7da6d52112	true	access.token.claim
e7760def-e79e-4472-afb6-ac7da6d52112	clientAddress	claim.name
e7760def-e79e-4472-afb6-ac7da6d52112	String	jsonType.label
e7760def-e79e-4472-afb6-ac7da6d52112	true	userinfo.token.claim
d338ef80-868b-4dc7-bc0d-3894efae7ccf	true	userinfo.token.claim
8620f390-0d12-426c-9874-8d1c531d7165	true	userinfo.token.claim
4e789733-a6f1-4707-b895-7ebfeb450b4b	clientAddress	user.session.note
4e789733-a6f1-4707-b895-7ebfeb450b4b	true	userinfo.token.claim
4e789733-a6f1-4707-b895-7ebfeb450b4b	true	id.token.claim
4e789733-a6f1-4707-b895-7ebfeb450b4b	true	access.token.claim
4e789733-a6f1-4707-b895-7ebfeb450b4b	clientAddress	claim.name
4e789733-a6f1-4707-b895-7ebfeb450b4b	String	jsonType.label
8e3563cd-ef1e-4c06-8baa-8b7700c2b957	clientHost	user.session.note
8e3563cd-ef1e-4c06-8baa-8b7700c2b957	true	userinfo.token.claim
8e3563cd-ef1e-4c06-8baa-8b7700c2b957	true	id.token.claim
8e3563cd-ef1e-4c06-8baa-8b7700c2b957	true	access.token.claim
8e3563cd-ef1e-4c06-8baa-8b7700c2b957	clientHost	claim.name
8e3563cd-ef1e-4c06-8baa-8b7700c2b957	String	jsonType.label
daf9bff2-ffe3-4765-aa02-11fdc0f7b30b	client_id	user.session.note
daf9bff2-ffe3-4765-aa02-11fdc0f7b30b	true	userinfo.token.claim
daf9bff2-ffe3-4765-aa02-11fdc0f7b30b	true	id.token.claim
daf9bff2-ffe3-4765-aa02-11fdc0f7b30b	true	access.token.claim
daf9bff2-ffe3-4765-aa02-11fdc0f7b30b	client_id	claim.name
daf9bff2-ffe3-4765-aa02-11fdc0f7b30b	String	jsonType.label
1da6a0a3-522f-4a5d-aec5-b23f8a2b5382	true	userinfo.token.claim
1da6a0a3-522f-4a5d-aec5-b23f8a2b5382	locale	user.attribute
1da6a0a3-522f-4a5d-aec5-b23f8a2b5382	true	id.token.claim
1da6a0a3-522f-4a5d-aec5-b23f8a2b5382	true	access.token.claim
1da6a0a3-522f-4a5d-aec5-b23f8a2b5382	locale	claim.name
1da6a0a3-522f-4a5d-aec5-b23f8a2b5382	String	jsonType.label
1518e926-6909-47cc-b908-5a310b46c0df	true	id.token.claim
d9fd6056-c26b-4367-b63c-f8e6d658e7ab	true	userinfo.token.claim
d9fd6056-c26b-4367-b63c-f8e6d658e7ab	true	id.token.claim
27716c8f-cabb-49d3-b821-c24f6650cbd0	client_id	user.session.note
27716c8f-cabb-49d3-b821-c24f6650cbd0	true	id.token.claim
27716c8f-cabb-49d3-b821-c24f6650cbd0	true	access.token.claim
27716c8f-cabb-49d3-b821-c24f6650cbd0	client_id	claim.name
27716c8f-cabb-49d3-b821-c24f6650cbd0	String	jsonType.label
2a75c508-cd7f-4536-bb72-22b333cfade7	clientAddress	user.session.note
2a75c508-cd7f-4536-bb72-22b333cfade7	true	id.token.claim
2a75c508-cd7f-4536-bb72-22b333cfade7	true	access.token.claim
2a75c508-cd7f-4536-bb72-22b333cfade7	clientAddress	claim.name
2a75c508-cd7f-4536-bb72-22b333cfade7	String	jsonType.label
f9e1b117-22de-4107-ad0f-585be5351262	clientHost	user.session.note
f9e1b117-22de-4107-ad0f-585be5351262	true	id.token.claim
f9e1b117-22de-4107-ad0f-585be5351262	true	access.token.claim
f9e1b117-22de-4107-ad0f-585be5351262	clientHost	claim.name
f9e1b117-22de-4107-ad0f-585be5351262	String	jsonType.label
1518e926-6909-47cc-b908-5a310b46c0df	true	userinfo.token.claim
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
e09f66b1-fa27-4fd8-affd-235a04a06fba	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	40c35b4b-faec-4a96-befb-88e1049653c3	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	77c26107-84ae-477d-8004-89012c00284a	c80bafd1-ab88-4e34-ab7b-d6937e394379	887b916f-5a63-4603-b399-494d45e0afe4	4d1bc370-774d-4188-93c4-b8d47c5099d1	c5b5ea41-299e-4d15-a047-6f5838f3e5bf	2592000	f	900	t	f	c2b0981c-d5ee-42c3-9d8b-8502f2aee29e	0	f	0	0	95cc1bb4-86dc-4f85-a3d1-80dabefb577b
d4932c90-8454-4b23-b96a-05444067272e	60	300	18000	\N	\N	\N	t	t	0	\N	Calendar	0	\N	t	t	f	f	EXTERNAL	1800	36000	f	f	e0670881-cb89-4f1a-9b84-4d54e5efbeb1	1800	t	en	f	t	t	f	0	1	30	6	HmacSHA1	totp	e556ad24-ce3f-408e-a10c-a6a0e8f3acbe	78fc9289-68c1-42b9-a828-494b48283703	0b41f0c0-1c71-412f-b3af-f7b18989f434	c19d67f3-76dc-4c23-93fa-f5acd01b4bdc	2ea22dda-5c83-4b26-a9a8-d6a9092ef53f	2592000	t	54000	t	f	a98fa067-75b2-470e-a373-b2d2d0473575	1	f	0	0	f8287ef9-36e5-4a8c-a160-a4f30f694375
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	e09f66b1-fa27-4fd8-affd-235a04a06fba	
_browser_header.xContentTypeOptions	e09f66b1-fa27-4fd8-affd-235a04a06fba	nosniff
_browser_header.referrerPolicy	e09f66b1-fa27-4fd8-affd-235a04a06fba	no-referrer
_browser_header.xRobotsTag	e09f66b1-fa27-4fd8-affd-235a04a06fba	none
_browser_header.xFrameOptions	e09f66b1-fa27-4fd8-affd-235a04a06fba	SAMEORIGIN
_browser_header.contentSecurityPolicy	e09f66b1-fa27-4fd8-affd-235a04a06fba	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	e09f66b1-fa27-4fd8-affd-235a04a06fba	1; mode=block
_browser_header.strictTransportSecurity	e09f66b1-fa27-4fd8-affd-235a04a06fba	max-age=31536000; includeSubDomains
bruteForceProtected	e09f66b1-fa27-4fd8-affd-235a04a06fba	false
permanentLockout	e09f66b1-fa27-4fd8-affd-235a04a06fba	false
maxFailureWaitSeconds	e09f66b1-fa27-4fd8-affd-235a04a06fba	900
minimumQuickLoginWaitSeconds	e09f66b1-fa27-4fd8-affd-235a04a06fba	60
waitIncrementSeconds	e09f66b1-fa27-4fd8-affd-235a04a06fba	60
quickLoginCheckMilliSeconds	e09f66b1-fa27-4fd8-affd-235a04a06fba	1000
maxDeltaTimeSeconds	e09f66b1-fa27-4fd8-affd-235a04a06fba	43200
failureFactor	e09f66b1-fa27-4fd8-affd-235a04a06fba	30
realmReusableOtpCode	e09f66b1-fa27-4fd8-affd-235a04a06fba	false
displayName	e09f66b1-fa27-4fd8-affd-235a04a06fba	Keycloak
displayNameHtml	e09f66b1-fa27-4fd8-affd-235a04a06fba	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	e09f66b1-fa27-4fd8-affd-235a04a06fba	RS256
offlineSessionMaxLifespanEnabled	e09f66b1-fa27-4fd8-affd-235a04a06fba	false
offlineSessionMaxLifespan	e09f66b1-fa27-4fd8-affd-235a04a06fba	5184000
displayName	d4932c90-8454-4b23-b96a-05444067272e	Calendar realm
displayNameHtml	d4932c90-8454-4b23-b96a-05444067272e	<div class="kc-logo-text"><span>Lecture Calendar</span></div>
bruteForceProtected	d4932c90-8454-4b23-b96a-05444067272e	false
permanentLockout	d4932c90-8454-4b23-b96a-05444067272e	false
maxFailureWaitSeconds	d4932c90-8454-4b23-b96a-05444067272e	900
minimumQuickLoginWaitSeconds	d4932c90-8454-4b23-b96a-05444067272e	60
waitIncrementSeconds	d4932c90-8454-4b23-b96a-05444067272e	60
quickLoginCheckMilliSeconds	d4932c90-8454-4b23-b96a-05444067272e	1000
maxDeltaTimeSeconds	d4932c90-8454-4b23-b96a-05444067272e	43200
failureFactor	d4932c90-8454-4b23-b96a-05444067272e	30
actionTokenGeneratedByAdminLifespan	d4932c90-8454-4b23-b96a-05444067272e	43200
actionTokenGeneratedByUserLifespan	d4932c90-8454-4b23-b96a-05444067272e	300
defaultSignatureAlgorithm	d4932c90-8454-4b23-b96a-05444067272e	RS256
offlineSessionMaxLifespanEnabled	d4932c90-8454-4b23-b96a-05444067272e	false
offlineSessionMaxLifespan	d4932c90-8454-4b23-b96a-05444067272e	5184000
webAuthnPolicyRpEntityName	d4932c90-8454-4b23-b96a-05444067272e	keycloak
realmReusableOtpCode	d4932c90-8454-4b23-b96a-05444067272e	false
webAuthnPolicySignatureAlgorithms	d4932c90-8454-4b23-b96a-05444067272e	ES256
webAuthnPolicyRpId	d4932c90-8454-4b23-b96a-05444067272e	
webAuthnPolicyAttestationConveyancePreference	d4932c90-8454-4b23-b96a-05444067272e	not specified
webAuthnPolicyAuthenticatorAttachment	d4932c90-8454-4b23-b96a-05444067272e	not specified
webAuthnPolicyRequireResidentKey	d4932c90-8454-4b23-b96a-05444067272e	not specified
clientSessionIdleTimeout	d4932c90-8454-4b23-b96a-05444067272e	0
clientSessionMaxLifespan	d4932c90-8454-4b23-b96a-05444067272e	0
clientOfflineSessionIdleTimeout	d4932c90-8454-4b23-b96a-05444067272e	0
clientOfflineSessionMaxLifespan	d4932c90-8454-4b23-b96a-05444067272e	0
webAuthnPolicyUserVerificationRequirement	d4932c90-8454-4b23-b96a-05444067272e	not specified
webAuthnPolicyCreateTimeout	d4932c90-8454-4b23-b96a-05444067272e	0
oauth2DeviceCodeLifespan	d4932c90-8454-4b23-b96a-05444067272e	600
oauth2DevicePollingInterval	d4932c90-8454-4b23-b96a-05444067272e	5
webAuthnPolicyAvoidSameAuthenticatorRegister	d4932c90-8454-4b23-b96a-05444067272e	false
webAuthnPolicyRpEntityNamePasswordless	d4932c90-8454-4b23-b96a-05444067272e	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	d4932c90-8454-4b23-b96a-05444067272e	ES256
webAuthnPolicyRpIdPasswordless	d4932c90-8454-4b23-b96a-05444067272e	
webAuthnPolicyAttestationConveyancePreferencePasswordless	d4932c90-8454-4b23-b96a-05444067272e	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	d4932c90-8454-4b23-b96a-05444067272e	not specified
webAuthnPolicyRequireResidentKeyPasswordless	d4932c90-8454-4b23-b96a-05444067272e	not specified
webAuthnPolicyUserVerificationRequirementPasswordless	d4932c90-8454-4b23-b96a-05444067272e	not specified
webAuthnPolicyCreateTimeoutPasswordless	d4932c90-8454-4b23-b96a-05444067272e	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	d4932c90-8454-4b23-b96a-05444067272e	false
client-policies.profiles	d4932c90-8454-4b23-b96a-05444067272e	{"profiles":[]}
client-policies.policies	d4932c90-8454-4b23-b96a-05444067272e	{"policies":[]}
_browser_header.contentSecurityPolicyReportOnly	d4932c90-8454-4b23-b96a-05444067272e	
_browser_header.xContentTypeOptions	d4932c90-8454-4b23-b96a-05444067272e	nosniff
_browser_header.referrerPolicy	d4932c90-8454-4b23-b96a-05444067272e	no-referrer
_browser_header.xRobotsTag	d4932c90-8454-4b23-b96a-05444067272e	none
_browser_header.xFrameOptions	d4932c90-8454-4b23-b96a-05444067272e	SAMEORIGIN
_browser_header.contentSecurityPolicy	d4932c90-8454-4b23-b96a-05444067272e	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
cibaBackchannelTokenDeliveryMode	d4932c90-8454-4b23-b96a-05444067272e	poll
cibaExpiresIn	d4932c90-8454-4b23-b96a-05444067272e	120
cibaInterval	d4932c90-8454-4b23-b96a-05444067272e	5
cibaAuthRequestedUserHint	d4932c90-8454-4b23-b96a-05444067272e	login_hint
parRequestUriLifespan	d4932c90-8454-4b23-b96a-05444067272e	60
actionTokenGeneratedByUserLifespan-execute-actions	d4932c90-8454-4b23-b96a-05444067272e	
actionTokenGeneratedByUserLifespan-verify-email	d4932c90-8454-4b23-b96a-05444067272e	
actionTokenGeneratedByUserLifespan-reset-credentials	d4932c90-8454-4b23-b96a-05444067272e	
actionTokenGeneratedByUserLifespan-idp-verify-account-via-email	d4932c90-8454-4b23-b96a-05444067272e	
frontendUrl	d4932c90-8454-4b23-b96a-05444067272e	
acr.loa.map	d4932c90-8454-4b23-b96a-05444067272e	{}
adminEventsExpiration	d4932c90-8454-4b23-b96a-05444067272e	
shortVerificationUri	d4932c90-8454-4b23-b96a-05444067272e	
_browser_header.xXSSProtection	d4932c90-8454-4b23-b96a-05444067272e	1; mode=block
_browser_header.strictTransportSecurity	d4932c90-8454-4b23-b96a-05444067272e	max-age=31536000; includeSubDomains
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
d4932c90-8454-4b23-b96a-05444067272e	SEND_RESET_PASSWORD
d4932c90-8454-4b23-b96a-05444067272e	UPDATE_CONSENT_ERROR
d4932c90-8454-4b23-b96a-05444067272e	GRANT_CONSENT
d4932c90-8454-4b23-b96a-05444067272e	VERIFY_PROFILE_ERROR
d4932c90-8454-4b23-b96a-05444067272e	REMOVE_TOTP
d4932c90-8454-4b23-b96a-05444067272e	REVOKE_GRANT
d4932c90-8454-4b23-b96a-05444067272e	UPDATE_TOTP
d4932c90-8454-4b23-b96a-05444067272e	LOGIN_ERROR
d4932c90-8454-4b23-b96a-05444067272e	CLIENT_LOGIN
d4932c90-8454-4b23-b96a-05444067272e	RESET_PASSWORD_ERROR
d4932c90-8454-4b23-b96a-05444067272e	IMPERSONATE_ERROR
d4932c90-8454-4b23-b96a-05444067272e	CODE_TO_TOKEN_ERROR
d4932c90-8454-4b23-b96a-05444067272e	CUSTOM_REQUIRED_ACTION
d4932c90-8454-4b23-b96a-05444067272e	OAUTH2_DEVICE_CODE_TO_TOKEN_ERROR
d4932c90-8454-4b23-b96a-05444067272e	RESTART_AUTHENTICATION
d4932c90-8454-4b23-b96a-05444067272e	IMPERSONATE
d4932c90-8454-4b23-b96a-05444067272e	UPDATE_PROFILE_ERROR
d4932c90-8454-4b23-b96a-05444067272e	LOGIN
d4932c90-8454-4b23-b96a-05444067272e	OAUTH2_DEVICE_VERIFY_USER_CODE
d4932c90-8454-4b23-b96a-05444067272e	UPDATE_PASSWORD_ERROR
d4932c90-8454-4b23-b96a-05444067272e	CLIENT_INITIATED_ACCOUNT_LINKING
d4932c90-8454-4b23-b96a-05444067272e	TOKEN_EXCHANGE
d4932c90-8454-4b23-b96a-05444067272e	AUTHREQID_TO_TOKEN
d4932c90-8454-4b23-b96a-05444067272e	LOGOUT
d4932c90-8454-4b23-b96a-05444067272e	REGISTER
d4932c90-8454-4b23-b96a-05444067272e	DELETE_ACCOUNT_ERROR
d4932c90-8454-4b23-b96a-05444067272e	CLIENT_REGISTER
d4932c90-8454-4b23-b96a-05444067272e	IDENTITY_PROVIDER_LINK_ACCOUNT
d4932c90-8454-4b23-b96a-05444067272e	DELETE_ACCOUNT
d4932c90-8454-4b23-b96a-05444067272e	UPDATE_PASSWORD
d4932c90-8454-4b23-b96a-05444067272e	CLIENT_DELETE
d4932c90-8454-4b23-b96a-05444067272e	FEDERATED_IDENTITY_LINK_ERROR
d4932c90-8454-4b23-b96a-05444067272e	IDENTITY_PROVIDER_FIRST_LOGIN
d4932c90-8454-4b23-b96a-05444067272e	CLIENT_DELETE_ERROR
d4932c90-8454-4b23-b96a-05444067272e	VERIFY_EMAIL
d4932c90-8454-4b23-b96a-05444067272e	CLIENT_LOGIN_ERROR
d4932c90-8454-4b23-b96a-05444067272e	RESTART_AUTHENTICATION_ERROR
d4932c90-8454-4b23-b96a-05444067272e	EXECUTE_ACTIONS
d4932c90-8454-4b23-b96a-05444067272e	REMOVE_FEDERATED_IDENTITY_ERROR
d4932c90-8454-4b23-b96a-05444067272e	TOKEN_EXCHANGE_ERROR
d4932c90-8454-4b23-b96a-05444067272e	PERMISSION_TOKEN
d4932c90-8454-4b23-b96a-05444067272e	SEND_IDENTITY_PROVIDER_LINK_ERROR
d4932c90-8454-4b23-b96a-05444067272e	EXECUTE_ACTION_TOKEN_ERROR
d4932c90-8454-4b23-b96a-05444067272e	SEND_VERIFY_EMAIL
d4932c90-8454-4b23-b96a-05444067272e	OAUTH2_DEVICE_AUTH
d4932c90-8454-4b23-b96a-05444067272e	EXECUTE_ACTIONS_ERROR
d4932c90-8454-4b23-b96a-05444067272e	REMOVE_FEDERATED_IDENTITY
d4932c90-8454-4b23-b96a-05444067272e	OAUTH2_DEVICE_CODE_TO_TOKEN
d4932c90-8454-4b23-b96a-05444067272e	IDENTITY_PROVIDER_POST_LOGIN
d4932c90-8454-4b23-b96a-05444067272e	IDENTITY_PROVIDER_LINK_ACCOUNT_ERROR
d4932c90-8454-4b23-b96a-05444067272e	OAUTH2_DEVICE_VERIFY_USER_CODE_ERROR
d4932c90-8454-4b23-b96a-05444067272e	UPDATE_EMAIL
d4932c90-8454-4b23-b96a-05444067272e	REGISTER_ERROR
d4932c90-8454-4b23-b96a-05444067272e	REVOKE_GRANT_ERROR
d4932c90-8454-4b23-b96a-05444067272e	EXECUTE_ACTION_TOKEN
d4932c90-8454-4b23-b96a-05444067272e	LOGOUT_ERROR
d4932c90-8454-4b23-b96a-05444067272e	UPDATE_EMAIL_ERROR
d4932c90-8454-4b23-b96a-05444067272e	CLIENT_UPDATE_ERROR
d4932c90-8454-4b23-b96a-05444067272e	AUTHREQID_TO_TOKEN_ERROR
d4932c90-8454-4b23-b96a-05444067272e	UPDATE_PROFILE
d4932c90-8454-4b23-b96a-05444067272e	CLIENT_REGISTER_ERROR
d4932c90-8454-4b23-b96a-05444067272e	FEDERATED_IDENTITY_LINK
d4932c90-8454-4b23-b96a-05444067272e	SEND_IDENTITY_PROVIDER_LINK
d4932c90-8454-4b23-b96a-05444067272e	SEND_VERIFY_EMAIL_ERROR
d4932c90-8454-4b23-b96a-05444067272e	RESET_PASSWORD
d4932c90-8454-4b23-b96a-05444067272e	CLIENT_INITIATED_ACCOUNT_LINKING_ERROR
d4932c90-8454-4b23-b96a-05444067272e	OAUTH2_DEVICE_AUTH_ERROR
d4932c90-8454-4b23-b96a-05444067272e	UPDATE_CONSENT
d4932c90-8454-4b23-b96a-05444067272e	REMOVE_TOTP_ERROR
d4932c90-8454-4b23-b96a-05444067272e	VERIFY_EMAIL_ERROR
d4932c90-8454-4b23-b96a-05444067272e	SEND_RESET_PASSWORD_ERROR
d4932c90-8454-4b23-b96a-05444067272e	CLIENT_UPDATE
d4932c90-8454-4b23-b96a-05444067272e	CUSTOM_REQUIRED_ACTION_ERROR
d4932c90-8454-4b23-b96a-05444067272e	IDENTITY_PROVIDER_POST_LOGIN_ERROR
d4932c90-8454-4b23-b96a-05444067272e	UPDATE_TOTP_ERROR
d4932c90-8454-4b23-b96a-05444067272e	CODE_TO_TOKEN
d4932c90-8454-4b23-b96a-05444067272e	VERIFY_PROFILE
d4932c90-8454-4b23-b96a-05444067272e	GRANT_CONSENT_ERROR
d4932c90-8454-4b23-b96a-05444067272e	IDENTITY_PROVIDER_FIRST_LOGIN_ERROR
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
e09f66b1-fa27-4fd8-affd-235a04a06fba	jboss-logging
d4932c90-8454-4b23-b96a-05444067272e	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	e09f66b1-fa27-4fd8-affd-235a04a06fba
password	password	t	t	d4932c90-8454-4b23-b96a-05444067272e
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
d4932c90-8454-4b23-b96a-05444067272e	de
d4932c90-8454-4b23-b96a-05444067272e	en
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.redirect_uris (client_id, value) FROM stdin;
0cb13d7a-7575-4c5a-bf6d-7e5c5f5fb42a	/realms/master/account/*
b32b8e24-6c0c-415c-92de-6602b7e4d1a8	/realms/master/account/*
b18471e0-3804-4b98-b391-bf56dd4dc923	/admin/master/console/*
6eae40bd-bf2a-4118-9659-5673c2ca655e	/realms/Calendar/account/*
93709245-2824-46cb-a48c-32cc8a45d4cc	/realms/Calendar/account/*
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	/*
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	http://localhost:3000
a39f7d32-3924-49d0-8904-bd9e4409411c	/admin/Calendar/console/*
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	http://localhost:4000
77d24d30-2ec1-47f9-a758-0826b164cacd	/swagger
77d24d30-2ec1-47f9-a758-0826b164cacd	/swagger/index.html
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
70242d43-8e6d-461c-830b-b68befca7c8f	VERIFY_EMAIL	Verify Email	e09f66b1-fa27-4fd8-affd-235a04a06fba	t	f	VERIFY_EMAIL	50
377a91ee-c7fe-4e6a-9a98-542b088e59d5	UPDATE_PROFILE	Update Profile	e09f66b1-fa27-4fd8-affd-235a04a06fba	t	f	UPDATE_PROFILE	40
21fbc378-8ff9-425a-8596-e4438426c0f1	CONFIGURE_TOTP	Configure OTP	e09f66b1-fa27-4fd8-affd-235a04a06fba	t	f	CONFIGURE_TOTP	10
14877134-9bd4-4e76-8860-186012a8199e	UPDATE_PASSWORD	Update Password	e09f66b1-fa27-4fd8-affd-235a04a06fba	t	f	UPDATE_PASSWORD	30
ad0a3635-99d1-41b2-bbb8-8216b7be867f	TERMS_AND_CONDITIONS	Terms and Conditions	e09f66b1-fa27-4fd8-affd-235a04a06fba	f	f	TERMS_AND_CONDITIONS	20
a84c5a17-0973-406e-a8b2-18c5cc449713	delete_account	Delete Account	e09f66b1-fa27-4fd8-affd-235a04a06fba	f	f	delete_account	60
fb0f1028-7784-4f1b-a67b-c891c17c7758	update_user_locale	Update User Locale	e09f66b1-fa27-4fd8-affd-235a04a06fba	t	f	update_user_locale	1000
1e3bfc77-7d7e-4fc2-aad1-fe1a3ed3995f	webauthn-register	Webauthn Register	e09f66b1-fa27-4fd8-affd-235a04a06fba	t	f	webauthn-register	70
4304041d-595f-4ddd-973a-121ac885e529	webauthn-register-passwordless	Webauthn Register Passwordless	e09f66b1-fa27-4fd8-affd-235a04a06fba	t	f	webauthn-register-passwordless	80
ad02243a-ee52-4546-8b8b-435802084245	CONFIGURE_TOTP	Configure OTP	d4932c90-8454-4b23-b96a-05444067272e	t	f	CONFIGURE_TOTP	10
500477e5-a490-4cc9-9b61-f547a00ab491	TERMS_AND_CONDITIONS	Terms and Conditions	d4932c90-8454-4b23-b96a-05444067272e	f	f	TERMS_AND_CONDITIONS	20
691c52b0-4d70-43c9-af1e-0122ae332e38	UPDATE_PASSWORD	Update Password	d4932c90-8454-4b23-b96a-05444067272e	t	f	UPDATE_PASSWORD	30
d7f5c4d8-74a5-4c1e-a950-34b1a594ae92	UPDATE_PROFILE	Update Profile	d4932c90-8454-4b23-b96a-05444067272e	t	f	UPDATE_PROFILE	40
f0a2f63e-9c72-4471-ab3a-a432d1cc35ca	VERIFY_EMAIL	Verify Email	d4932c90-8454-4b23-b96a-05444067272e	t	f	VERIFY_EMAIL	50
0859d414-c34a-4f5a-ac7c-86b323fe9353	delete_account	Delete Account	d4932c90-8454-4b23-b96a-05444067272e	f	f	delete_account	60
8bda664d-5575-4440-8964-c61c5b77b8be	webauthn-register	Webauthn Register	d4932c90-8454-4b23-b96a-05444067272e	t	f	webauthn-register	70
28f15104-932c-4685-a83f-8f0ef66a8218	webauthn-register-passwordless	Webauthn Register Passwordless	d4932c90-8454-4b23-b96a-05444067272e	t	f	webauthn-register-passwordless	80
ebf92f61-f0f4-4cb1-89b0-491ef8f4106b	update_user_locale	Update User Locale	d4932c90-8454-4b23-b96a-05444067272e	t	f	update_user_locale	1000
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	t	0	1
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	t	0	1
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
2ea30141-5e9b-4044-b4fe-9053cfc4fc33	Default Policy	A policy that grants access only for users within this realm	js	0	0	cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	\N
b8d5227d-c91e-4fed-b5ce-cf15a4197f45	Default Permission	A permission that applies to the default resource type	resource	1	0	cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	\N
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
3ed3f0a1-65c2-409e-91f5-5a99f4dc0f6e	Default Resource	urn:calendar-api:resources:default	\N	cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	f	\N
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_uris (resource_id, value) FROM stdin;
3ed3f0a1-65c2-409e-91f5-5a99f4dc0f6e	/*
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
b32b8e24-6c0c-415c-92de-6602b7e4d1a8	ee1b354b-f983-46fb-9673-566aad6a4781
b32b8e24-6c0c-415c-92de-6602b7e4d1a8	572d3bb4-1e51-4fe3-ae87-7d2f1569e785
93709245-2824-46cb-a48c-32cc8a45d4cc	f0d1ba3e-d6de-4f83-9805-814635c0551e
93709245-2824-46cb-a48c-32cc8a45d4cc	3ec382b3-405c-4704-acc7-49bb89aa04f3
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_attribute (name, value, user_id, id) FROM stdin;
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
50d7e638-8a7d-4f54-b637-5fe4891913b1	\N	ce9e68c3-fbe1-4a8a-a0d7-f2e009957858	f	t	\N	\N	\N	d4932c90-8454-4b23-b96a-05444067272e	service-account-calendar-api-swagger	1689929071630	77d24d30-2ec1-47f9-a758-0826b164cacd	0
243110e7-5530-4610-b040-51a5f543423d	\N	54cab0d0-02ab-4e5a-9efc-4f0e697da1ec	f	t	\N	\N	\N	d4932c90-8454-4b23-b96a-05444067272e	service-account-calendar-client	1689855013517	43022b0a-4e08-4d60-ad6c-8a872d5e2f59	0
f94b920e-9c5c-474c-904e-b75f2181f5e2	\N	284227a0-f8dd-4ef8-900d-fd2436883724	f	t	\N	\N	\N	e09f66b1-fa27-4fd8-affd-235a04a06fba	admin	1690440868421	\N	0
e735b777-a13e-4f04-81ee-92edc3068449	dozent@test.com	dozent@test.com	t	t	\N	Dozent		d4932c90-8454-4b23-b96a-05444067272e	dozent	1690441246760	\N	0
45171f94-33bb-439c-8765-7a69d0d6d79e	student@test.test	student@test.test	t	t	\N	Test	Student	d4932c90-8454-4b23-b96a-05444067272e	student1	1690441299386	\N	0
4f95e562-3f21-416c-aba8-98d10d65a744	ske@test.test	ske@test.test	t	t	\N	Sekreteriat		d4932c90-8454-4b23-b96a-05444067272e	sekreteriat	1690441399786	\N	0
ceb1ed29-4339-4fbd-bab7-ad1ac16429b6	student2@test.test	student2@test.test	t	t	\N	Student	1	d4932c90-8454-4b23-b96a-05444067272e	student2	1690442280867	\N	0
6fe6034a-5015-4bf6-b0cb-d8314f38ac0b	\N	1306dfcd-fc65-4371-ba69-65e870321228	f	t	\N	Admin	Admin	d4932c90-8454-4b23-b96a-05444067272e	admin	1690444964015	\N	0
2826dab2-8cc4-482d-9e20-f3309ea1e19a	\N	3f298ce7-4f1d-4750-bd59-b47d84b88488	f	t	\N	\N	\N	d4932c90-8454-4b23-b96a-05444067272e	service-account-calendar-api	1690810018508	cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	0
3d13b017-9494-4164-9a3a-9d4d6c534614	\N	0002ba22-00df-4e97-b3a8-465d94b98206	t	t	\N	Dev	dev	d4932c90-8454-4b23-b96a-05444067272e	dev	1690810616537	\N	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_group_membership (group_id, user_id) FROM stdin;
a12bd244-8ddf-4220-a9f1-b530891a5ec9	e735b777-a13e-4f04-81ee-92edc3068449
269072d2-19a8-4ea8-a367-fc85b6af1c53	45171f94-33bb-439c-8765-7a69d0d6d79e
19bb2450-039d-4780-a347-f686e9af8769	4f95e562-3f21-416c-aba8-98d10d65a744
269072d2-19a8-4ea8-a367-fc85b6af1c53	ceb1ed29-4339-4fbd-bab7-ad1ac16429b6
a12bd244-8ddf-4220-a9f1-b530891a5ec9	3d13b017-9494-4164-9a3a-9d4d6c534614
19bb2450-039d-4780-a347-f686e9af8769	3d13b017-9494-4164-9a3a-9d4d6c534614
269072d2-19a8-4ea8-a367-fc85b6af1c53	3d13b017-9494-4164-9a3a-9d4d6c534614
269072d2-19a8-4ea8-a367-fc85b6af1c53	e735b777-a13e-4f04-81ee-92edc3068449
b91f647f-a655-458a-9965-9386e8125f85	e735b777-a13e-4f04-81ee-92edc3068449
c9811517-c13b-4937-8c90-806418330de2	3d13b017-9494-4164-9a3a-9d4d6c534614
c9811517-c13b-4937-8c90-806418330de2	e735b777-a13e-4f04-81ee-92edc3068449
b91f647f-a655-458a-9965-9386e8125f85	3d13b017-9494-4164-9a3a-9d4d6c534614
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
45171f94-33bb-439c-8765-7a69d0d6d79e	UPDATE_PASSWORD
e735b777-a13e-4f04-81ee-92edc3068449	UPDATE_PASSWORD
4f95e562-3f21-416c-aba8-98d10d65a744	UPDATE_PASSWORD
ceb1ed29-4339-4fbd-bab7-ad1ac16429b6	UPDATE_PASSWORD
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
f8287ef9-36e5-4a8c-a160-a4f30f694375	50d7e638-8a7d-4f54-b637-5fe4891913b1
c275580f-3be2-4fd9-bc16-c9070fa3ce9d	50d7e638-8a7d-4f54-b637-5fe4891913b1
92521f28-439b-49fd-9f69-aaad96d123d3	50d7e638-8a7d-4f54-b637-5fe4891913b1
0f1972de-bd47-43bd-889c-987c155265ff	50d7e638-8a7d-4f54-b637-5fe4891913b1
f8287ef9-36e5-4a8c-a160-a4f30f694375	243110e7-5530-4610-b040-51a5f543423d
c275580f-3be2-4fd9-bc16-c9070fa3ce9d	243110e7-5530-4610-b040-51a5f543423d
92521f28-439b-49fd-9f69-aaad96d123d3	243110e7-5530-4610-b040-51a5f543423d
3d456e06-9b0c-4b40-8830-9e7fcedb570b	243110e7-5530-4610-b040-51a5f543423d
95cc1bb4-86dc-4f85-a3d1-80dabefb577b	f94b920e-9c5c-474c-904e-b75f2181f5e2
3754d5bb-7a83-4a96-8760-53f6c39104be	f94b920e-9c5c-474c-904e-b75f2181f5e2
f8287ef9-36e5-4a8c-a160-a4f30f694375	e735b777-a13e-4f04-81ee-92edc3068449
f8287ef9-36e5-4a8c-a160-a4f30f694375	45171f94-33bb-439c-8765-7a69d0d6d79e
f8287ef9-36e5-4a8c-a160-a4f30f694375	4f95e562-3f21-416c-aba8-98d10d65a744
f8287ef9-36e5-4a8c-a160-a4f30f694375	ceb1ed29-4339-4fbd-bab7-ad1ac16429b6
f8287ef9-36e5-4a8c-a160-a4f30f694375	6fe6034a-5015-4bf6-b0cb-d8314f38ac0b
569bdab3-c50b-4188-a27e-fb1a4c685a1f	6fe6034a-5015-4bf6-b0cb-d8314f38ac0b
f8287ef9-36e5-4a8c-a160-a4f30f694375	2826dab2-8cc4-482d-9e20-f3309ea1e19a
ccdbd4ff-553d-44af-8b5d-a634908f4d9b	2826dab2-8cc4-482d-9e20-f3309ea1e19a
f8287ef9-36e5-4a8c-a160-a4f30f694375	3d13b017-9494-4164-9a3a-9d4d6c534614
\.


--
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_session (id, auth_method, ip_address, last_session_refresh, login_username, realm_id, remember_me, started, user_id, user_session_state, broker_session_id, broker_user_id) FROM stdin;
\.


--
-- Data for Name: user_session_note; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_session_note (user_session, name, value) FROM stdin;
\.


--
-- Data for Name: username_login_failure; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.username_login_failure (realm_id, username, failed_login_not_before, last_failure, last_ip_failure, num_failures) FROM stdin;
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.web_origins (client_id, value) FROM stdin;
b18471e0-3804-4b98-b391-bf56dd4dc923	+
43022b0a-4e08-4d60-ad6c-8a872d5e2f59	http://localhost:3000
a39f7d32-3924-49d0-8904-bd9e4409411c	+
cbb7d230-1ef8-4158-86a9-8ee950ecd6ae	http://localhost:4000
77d24d30-2ec1-47f9-a758-0826b164cacd	http://localhost:4000
\.


--
-- Name: username_login_failure CONSTRAINT_17-2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.username_login_failure
    ADD CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: client_user_session_note constr_cl_usr_ses_note; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT constr_cl_usr_ses_note PRIMARY KEY (client_session, name);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: client_session_role constraint_5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT constraint_5 PRIMARY KEY (client_session, role_id);


--
-- Name: user_session constraint_57; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_session
    ADD CONSTRAINT constraint_57 PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client_session_note constraint_5e; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT constraint_5e PRIMARY KEY (client_session, name);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: client_session constraint_8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT constraint_8 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: client_session_auth_status constraint_auth_status_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT constraint_auth_status_pk PRIMARY KEY (client_session, authenticator);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: client_session_prot_mapper constraint_cs_pmp_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT constraint_cs_pmp_pk PRIMARY KEY (client_session, protocol_mapper_id);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: user_session_note constraint_usn_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT constraint_usn_pk PRIMARY KEY (user_session, name);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_consent uk_jkuwuvd56ontgsuhogm8uewrt; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_jkuwuvd56ontgsuhogm8uewrt UNIQUE (client_id, client_storage_provider, external_client_id, user_id);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_client_session_session; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_client_session_session ON public.client_session USING btree (session_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_att_by_name_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_group_att_by_name_value ON public.group_attribute USING btree (name, ((value)::character varying(250)));


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_css_preload; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_offline_css_preload ON public.offline_client_session USING btree (client_id, offline_flag);


--
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- Name: idx_offline_uss_by_usersess; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_offline_uss_by_usersess ON public.offline_user_session USING btree (realm_id, offline_flag, user_session_id);


--
-- Name: idx_offline_uss_createdon; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_offline_uss_createdon ON public.offline_user_session USING btree (created_on);


--
-- Name: idx_offline_uss_preload; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_offline_uss_preload ON public.offline_user_session USING btree (offline_flag, created_on, user_session_id);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_us_sess_id_on_cl_sess; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_us_sess_id_on_cl_sess ON public.offline_client_session USING btree (user_session_id);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: client_session_auth_status auth_status_constraint; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT auth_status_constraint FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_session_note fk5edfb00ff51c2736; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT fk5edfb00ff51c2736 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: user_session_note fk5edfb00ff51d3472; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT fk5edfb00ff51d3472 FOREIGN KEY (user_session) REFERENCES public.user_session(id);


--
-- Name: client_session_role fk_11b7sgqw18i532811v7o2dv76; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT fk_11b7sgqw18i532811v7o2dv76 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session_prot_mapper fk_33a8sgqw18i532811v7o2dk89; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT fk_33a8sgqw18i532811v7o2dk89 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session fk_b4ao2vcvat6ukau74wbwtfqo1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT fk_b4ao2vcvat6ukau74wbwtfqo1 FOREIGN KEY (session_id) REFERENCES public.user_session(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_user_session_note fk_cl_usr_ses_note; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT fk_cl_usr_ses_note FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- PostgreSQL database dump complete
--

