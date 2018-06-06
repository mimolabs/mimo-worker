SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: audiences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audiences (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    location_id integer,
    name character varying(50),
    predicates jsonb,
    predicate_type character varying(10)
);


--
-- Name: audiences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audiences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audiences_id_seq OWNED BY public.audiences.id;


--
-- Name: boxes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.boxes (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    location_id integer,
    mac_address character varying(18),
    state character varying(10),
    machine_type character varying(26),
    description text,
    last_heartbeat timestamp without time zone
);


--
-- Name: boxes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.boxes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: boxes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.boxes_id_seq OWNED BY public.boxes.id;


--
-- Name: emails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.emails (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    location_id integer,
    person_id integer,
    station_id integer,
    email character varying(100),
    comments character varying(50),
    splash_id character varying(50),
    list_id character varying(50),
    list_type character varying(50),
    added boolean DEFAULT false,
    active boolean DEFAULT true,
    blocked boolean,
    bounced boolean,
    spam boolean,
    unsubscribed boolean,
    consented boolean DEFAULT false,
    macs text[],
    lists text[]
);


--
-- Name: emails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.emails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.emails_id_seq OWNED BY public.emails.id;


--
-- Name: event_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_logs (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    location_id integer,
    resource_id character varying(10),
    meta json,
    data json,
    response json,
    event_type character varying(12)
);


--
-- Name: event_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_logs_id_seq OWNED BY public.event_logs.id;


--
-- Name: location_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.location_users (
    id bigint NOT NULL,
    unique_id character varying(64),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    role_id integer,
    user_id integer,
    location_id integer
);


--
-- Name: location_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.location_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: location_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.location_users_id_seq OWNED BY public.location_users.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id bigint NOT NULL,
    unique_id character varying(64),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    location_name character varying(255),
    location_address character varying(255),
    town character varying(255),
    street character varying(255),
    postcode character varying(255),
    country character varying(255) DEFAULT 'United Kingdom'::character varying,
    owner character varying(255),
    website character varying(255),
    geocode character varying(255),
    phone1 character varying(255),
    user_id integer,
    api_token character varying(255),
    slug character varying(255),
    latitude real,
    longitude real,
    has_devices boolean DEFAULT false,
    timezone character varying(255) DEFAULT 'Europe/London'::character varying,
    lucky_dip integer,
    category character varying(50),
    demo boolean DEFAULT true,
    eu boolean DEFAULT true,
    paid boolean DEFAULT false
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: oauth_access_grants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_access_grants (
    id bigint NOT NULL,
    resource_owner_id integer NOT NULL,
    application_id bigint NOT NULL,
    token character varying NOT NULL,
    expires_in integer NOT NULL,
    redirect_uri text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    revoked_at timestamp without time zone,
    scopes character varying
);


--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oauth_access_grants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oauth_access_grants_id_seq OWNED BY public.oauth_access_grants.id;


--
-- Name: oauth_access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_access_tokens (
    id bigint NOT NULL,
    resource_owner_id integer,
    application_id bigint,
    token character varying NOT NULL,
    refresh_token character varying,
    expires_in integer,
    revoked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    scopes character varying,
    previous_refresh_token character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oauth_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oauth_access_tokens_id_seq OWNED BY public.oauth_access_tokens.id;


--
-- Name: oauth_applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_applications (
    id bigint NOT NULL,
    name character varying NOT NULL,
    uid character varying NOT NULL,
    secret character varying NOT NULL,
    redirect_uri text NOT NULL,
    scopes character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: oauth_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oauth_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oauth_applications_id_seq OWNED BY public.oauth_applications.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.people (
    id bigint NOT NULL,
    unique_id character varying(64),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    location_id integer,
    login_count integer,
    campaign_id character varying(26),
    client_mac character varying(26),
    username character varying(26),
    email character varying(50),
    first_name character varying(50),
    last_name character varying(50),
    google_id character varying(26),
    consented boolean DEFAULT true,
    unsubscribed boolean DEFAULT false,
    campaign_ids text[],
    last_seen timestamp without time zone,
    facebook boolean DEFAULT false,
    google boolean DEFAULT false,
    twitter boolean DEFAULT false
);


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.people_id_seq OWNED BY public.people.id;


--
-- Name: person_timelines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.person_timelines (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    location_id integer,
    person_id integer,
    event character varying(20),
    meta json
);


--
-- Name: person_timelines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.person_timelines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_timelines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.person_timelines_id_seq OWNED BY public.person_timelines.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: senders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.senders (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    location_id integer,
    user_id integer,
    sender_name character varying(50),
    sender_type character varying(50),
    from_name character varying(50),
    from_email character varying(50),
    from_sms character varying(50),
    from_twitter character varying(50),
    twitter_token character varying(50),
    twitter_secret character varying(50),
    reply_email character varying(50),
    address character varying(50),
    town character varying(50),
    postcode character varying(50),
    country character varying(50),
    token character varying(50),
    is_validated boolean
);


--
-- Name: senders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.senders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: senders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.senders_id_seq OWNED BY public.senders.id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.settings (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    unique_id character varying(64),
    business_name character varying,
    locale character varying(4) DEFAULT 'en'::character varying,
    docs_url character varying,
    contact_url character varying,
    terms_url character varying,
    from_email character varying,
    logo character varying,
    favicon character varying,
    intercom_id character varying(16),
    drift_id character varying(16),
    invite_admins boolean DEFAULT false,
    invite_users boolean DEFAULT false,
    integration_unifi boolean DEFAULT true,
    integration_openmesh boolean DEFAULT false,
    integration_vsz boolean DEFAULT false,
    integration_meraki boolean DEFAULT false,
    integration_ct boolean DEFAULT false
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- Name: sms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sms (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    location_id integer,
    number character varying(15),
    person_id integer,
    client_mac character varying(18)
);


--
-- Name: sms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sms_id_seq OWNED BY public.sms.id;


--
-- Name: socials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.socials (
    id bigint NOT NULL,
    unique_id character varying(64),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    location_id integer,
    facebook_id character varying(24),
    google_id character varying(24),
    email character varying(50),
    first_name character varying(24),
    last_name character varying(24),
    gender character varying(6),
    current_location character varying(24),
    twitter_id character varying(24),
    person_id integer,
    checkins integer,
    location_ids text[],
    splash_ids text[],
    emails text[],
    client_ids text[],
    networks text[],
    lonlat text[],
    newsletter boolean DEFAULT false,
    meta json
);


--
-- Name: socials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.socials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: socials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.socials_id_seq OWNED BY public.socials.id;


--
-- Name: splash_integrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.splash_integrations (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    location_id integer,
    api_token character varying,
    host character varying,
    integration_type character varying(10),
    port character varying(5),
    username character varying(26),
    password character varying(26),
    metadata json DEFAULT '{}'::json,
    active boolean
);


--
-- Name: splash_integrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.splash_integrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: splash_integrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.splash_integrations_id_seq OWNED BY public.splash_integrations.id;


--
-- Name: splash_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.splash_pages (
    id bigint NOT NULL,
    unique_id character varying(24),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    location_id integer,
    registered_access_id integer,
    primary_access_id integer,
    access_period integer,
    max_all_session integer,
    container_transparency integer DEFAULT 1,
    header_image_type integer DEFAULT 1,
    weight integer DEFAULT 100,
    newsletter_type integer DEFAULT 0,
    access_restrict_mins integer DEFAULT 60,
    access_restrict_down integer DEFAULT 2048,
    access_restrict_up integer DEFAULT 1024,
    download_speed integer DEFAULT 2048,
    upload_speed integer DEFAULT 1024,
    session_timeout integer DEFAULT 60,
    idle_timeout integer DEFAULT 60,
    simultaneous_use integer DEFAULT 25,
    welcome_timeout integer,
    info text,
    info_two text,
    address text,
    splash_name text,
    description text,
    header_text text,
    error_message_text text,
    gdpr_email_field text DEFAULT 'I''d like to receive updates by Email'::text,
    gdpr_sms_field text DEFAULT 'I''d like to receive updates by SMS'::text,
    gdpr_contact_message text DEFAULT 'Occasionally we''d like to give you updates about products & services, promotions, special offers, news & events.'::text,
    font_family text DEFAULT '''Helvetica Neue'', Arial, Helvetica, sans-serif'::text,
    fb_checkin_msg text,
    whitelisted text,
    blacklisted text,
    welcome_text text,
    no_login_message text,
    quota_message text,
    walled_gardens text,
    passwd_change_email character varying(50),
    logo_file_name character varying(25),
    background_image_name character varying(25),
    location_image_name character varying(25),
    header_image_name character varying(25),
    words_position character varying(6) DEFAULT 'right'::character varying,
    logo_position character varying(6) DEFAULT 'left'::character varying,
    container_float character varying(6) DEFAULT 'center'::character varying,
    container_text_align character varying(6) DEFAULT 'center'::character varying,
    container_inner_width character varying(6) DEFAULT '100%'::character varying,
    container_inner_padding character varying(6) DEFAULT '20px'::character varying,
    container_inner_radius character varying(6) DEFAULT '4px'::character varying,
    bg_dimension character varying(6) DEFAULT 'full'::character varying,
    header_colour character varying(22) DEFAULT '#FFFFFF'::character varying,
    button_colour character varying(22) DEFAULT '#FFFFFF'::character varying,
    button_radius character varying(6) DEFAULT '4px'::character varying,
    button_border_colour character varying(22) DEFAULT '#000'::character varying,
    button_padding character varying(10) DEFAULT '0px 16px'::character varying,
    button_height character varying(6) DEFAULT '50px'::character varying,
    container_colour character varying(22) DEFAULT '#FFFFFF'::character varying,
    container_width character varying(6) DEFAULT '850px'::character varying,
    body_background_colour character varying(22) DEFAULT '#FFFFFF'::character varying,
    body_font_size character varying(6) DEFAULT '14px'::character varying,
    heading_text_size character varying(6) DEFAULT '22px'::character varying,
    heading_text_colour character varying(22) DEFAULT '#000000'::character varying,
    heading_2_text_size character varying(6) DEFAULT '16px'::character varying,
    heading_2_text_colour character varying(22) DEFAULT '#000000'::character varying,
    heading_3_text_size character varying(6) DEFAULT '14px'::character varying,
    heading_3_text_colour character varying(22) DEFAULT '#000000'::character varying,
    body_text_colour character varying(22) DEFAULT '#333333'::character varying,
    border_colour character varying(22) DEFAULT '#CCCCCC'::character varying,
    btn_text character varying(25) DEFAULT 'Login Now'::character varying,
    reg_btn_text character varying(25) DEFAULT 'Register'::character varying,
    btn_font_size character varying(6) DEFAULT '18px'::character varying,
    btn_font_colour character varying(22) DEFAULT '#000000'::character varying,
    link_colour character varying(22) DEFAULT '#2B68B6'::character varying,
    error_colour character varying(22) DEFAULT '#ED561B'::character varying,
    email_button_colour character varying(22) DEFAULT 'rgb(255, 255, 255)'::character varying,
    email_button_border_colour character varying(22) DEFAULT 'rgb(204, 204, 204)'::character varying,
    email_btn_font_colour character varying(22) DEFAULT 'rgb(0, 0, 0)'::character varying,
    sms_button_colour character varying(22) DEFAULT 'rgb(239, 83, 80)'::character varying,
    sms_button_border_colour character varying(22) DEFAULT 'rgba(239, 83, 80, 0)'::character varying,
    sms_btn_font_colour character varying(22) DEFAULT 'rgb(255, 255, 255)'::character varying,
    voucher_button_colour character varying(22) DEFAULT 'rgb(255, 255, 255)'::character varying,
    voucher_button_border_colour character varying(22) DEFAULT 'rgb(204, 204, 204)'::character varying,
    voucher_btn_font_colour character varying(22) DEFAULT 'rgb(0, 0, 0)'::character varying,
    codes_button_colour character varying(22) DEFAULT 'rgb(255, 255, 255)'::character varying,
    codes_button_border_colour character varying(22) DEFAULT 'rgb(204, 204, 204)'::character varying,
    codes_btn_font_colour character varying(22) DEFAULT 'rgb(0, 0, 0)'::character varying,
    password_button_colour character varying(22) DEFAULT 'rgb(255, 255, 255)'::character varying,
    password_button_border_colour character varying(22) DEFAULT 'rgb(204, 204, 204)'::character varying,
    password_btn_font_colour character varying(22) DEFAULT 'rgb(0, 0, 0)'::character varying,
    access_restrict character varying(10) DEFAULT 'none'::character varying,
    access_restrict_period character varying(10) DEFAULT 'daily'::character varying,
    available_start character varying(2) DEFAULT '00'::character varying,
    available_end character varying(2) DEFAULT '00'::character varying,
    input_padding character varying(10) DEFAULT '10px 15px'::character varying,
    input_height character varying(10) DEFAULT '40px'::character varying,
    input_border_colour character varying(22) DEFAULT '#d0d0d0'::character varying,
    input_border_width character varying(6) DEFAULT '1px'::character varying,
    input_border_radius character varying(6) DEFAULT '0px'::character varying,
    input_required_colour character varying(10) DEFAULT '#CCC'::character varying,
    input_required_size character varying(10) DEFAULT '10px'::character varying,
    input_background character varying(22) DEFAULT '#FFFFFF'::character varying,
    input_text_colour character varying(22) DEFAULT '#3D3D3D'::character varying,
    input_max_width character varying(6) DEFAULT '400px'::character varying,
    footer_text_colour character varying(22) DEFAULT '#CCC'::character varying,
    timezone character varying(32) DEFAULT 'Europe/London'::character varying,
    popup_background_colour character varying(22) DEFAULT 'rgb(255,255,255)'::character varying,
    password character varying(25),
    fb_page_id character varying(25),
    fb_app_id character varying(25),
    fb_link character varying(255),
    success_url character varying(255),
    terms_url character varying(255),
    website character varying(255),
    external_css character varying(255),
    newsletter_api_token character varying(255),
    newsletter_list_id character varying(32),
    facebook_name character varying(32),
    google_name character varying(32),
    twitter_name character varying(32),
    g_api_key character varying(10),
    g_page_id character varying(10),
    splash_integration_id character varying(24),
    tw_handle character varying(32),
    vsg_host character varying(255),
    vsg_pass character varying(50),
    uamsecret character varying(32),
    default_password character varying(32),
    popup_image character varying(10),
    backup_sms boolean DEFAULT false,
    backup_email boolean DEFAULT true,
    backup_vouchers boolean DEFAULT false,
    backup_password boolean DEFAULT false,
    backup_quick_codes boolean DEFAULT false,
    active boolean DEFAULT true,
    fb_checkin boolean DEFAULT false,
    fb_msg boolean DEFAULT true,
    fb_use_ps boolean DEFAULT true,
    g_use_ps boolean DEFAULT true,
    fb_login_on boolean DEFAULT false,
    secondary_access boolean DEFAULT false,
    passwd_auto_gen boolean DEFAULT false,
    newsletter_active boolean DEFAULT false,
    skip_user_registration boolean DEFAULT false,
    g_redirect_to_page boolean DEFAULT false,
    g_login_on boolean DEFAULT false,
    tw_send_tweet boolean DEFAULT false,
    tw_login_on boolean DEFAULT false,
    allow_registration boolean DEFAULT false,
    show_welcome boolean DEFAULT false,
    fb_redirect_to_page boolean DEFAULT false,
    powered_by boolean DEFAULT true,
    email_required boolean DEFAULT false,
    newsletter_consent boolean DEFAULT false,
    vsg_enabled boolean,
    no_login boolean,
    hide_terms boolean DEFAULT false,
    single_opt_in boolean DEFAULT false,
    double_opt_in boolean DEFAULT true,
    merge_fields boolean DEFAULT false,
    debug boolean DEFAULT false,
    vsg_async boolean DEFAULT true,
    display_console boolean DEFAULT false,
    bypass_popup_android boolean DEFAULT false,
    bypass_popup_ios boolean DEFAULT false,
    popup_ad boolean DEFAULT false,
    gdpr_form boolean DEFAULT true,
    email_button_icon boolean DEFAULT true,
    codes_button_icon boolean DEFAULT true,
    password_button_icon boolean DEFAULT true,
    voucher_button_icon boolean DEFAULT true,
    sms_button_icon boolean DEFAULT false,
    meraki_enabled boolean,
    unifi_enabled boolean,
    cloudtrax_enabled boolean,
    button_shadow boolean DEFAULT true,
    container_shadow boolean DEFAULT true,
    available_days text[],
    passwd_change_day text[],
    tags text[],
    networks text[],
    twilio_user character varying(50),
    twilio_pass character varying(50),
    twilio_from character varying(15)
);


--
-- Name: splash_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.splash_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: splash_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.splash_pages_id_seq OWNED BY public.splash_pages.id;


--
-- Name: stations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stations (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    location_id integer,
    ssid character varying,
    "36" character varying,
    client_mac character varying,
    "18" character varying,
    person_id integer
);


--
-- Name: stations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stations_id_seq OWNED BY public.stations.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    admin boolean,
    role integer,
    locked_at time without time zone,
    failed_attempts integer,
    username character varying(50),
    timezone character varying(26),
    country character varying(26),
    account_id character varying(10),
    slug character varying,
    locale character varying(2),
    radius_secret character varying,
    alerts_window_start character varying(5),
    alerts_window_end character varying(5),
    alerts_window_days text[],
    alerts boolean DEFAULT true
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: audiences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audiences ALTER COLUMN id SET DEFAULT nextval('public.audiences_id_seq'::regclass);


--
-- Name: boxes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boxes ALTER COLUMN id SET DEFAULT nextval('public.boxes_id_seq'::regclass);


--
-- Name: emails id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emails ALTER COLUMN id SET DEFAULT nextval('public.emails_id_seq'::regclass);


--
-- Name: event_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_logs ALTER COLUMN id SET DEFAULT nextval('public.event_logs_id_seq'::regclass);


--
-- Name: location_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_users ALTER COLUMN id SET DEFAULT nextval('public.location_users_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: oauth_access_grants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_grants ALTER COLUMN id SET DEFAULT nextval('public.oauth_access_grants_id_seq'::regclass);


--
-- Name: oauth_access_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.oauth_access_tokens_id_seq'::regclass);


--
-- Name: oauth_applications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_applications ALTER COLUMN id SET DEFAULT nextval('public.oauth_applications_id_seq'::regclass);


--
-- Name: people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people ALTER COLUMN id SET DEFAULT nextval('public.people_id_seq'::regclass);


--
-- Name: person_timelines id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_timelines ALTER COLUMN id SET DEFAULT nextval('public.person_timelines_id_seq'::regclass);


--
-- Name: senders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.senders ALTER COLUMN id SET DEFAULT nextval('public.senders_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- Name: sms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sms ALTER COLUMN id SET DEFAULT nextval('public.sms_id_seq'::regclass);


--
-- Name: socials id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.socials ALTER COLUMN id SET DEFAULT nextval('public.socials_id_seq'::regclass);


--
-- Name: splash_integrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.splash_integrations ALTER COLUMN id SET DEFAULT nextval('public.splash_integrations_id_seq'::regclass);


--
-- Name: splash_pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.splash_pages ALTER COLUMN id SET DEFAULT nextval('public.splash_pages_id_seq'::regclass);


--
-- Name: stations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stations ALTER COLUMN id SET DEFAULT nextval('public.stations_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: audiences audiences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audiences
    ADD CONSTRAINT audiences_pkey PRIMARY KEY (id);


--
-- Name: boxes boxes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boxes
    ADD CONSTRAINT boxes_pkey PRIMARY KEY (id);


--
-- Name: emails emails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT emails_pkey PRIMARY KEY (id);


--
-- Name: event_logs event_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_logs
    ADD CONSTRAINT event_logs_pkey PRIMARY KEY (id);


--
-- Name: location_users location_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_users
    ADD CONSTRAINT location_users_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_grants oauth_access_grants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_grants
    ADD CONSTRAINT oauth_access_grants_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_tokens oauth_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: oauth_applications oauth_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_applications
    ADD CONSTRAINT oauth_applications_pkey PRIMARY KEY (id);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: person_timelines person_timelines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_timelines
    ADD CONSTRAINT person_timelines_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: senders senders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.senders
    ADD CONSTRAINT senders_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: sms sms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sms
    ADD CONSTRAINT sms_pkey PRIMARY KEY (id);


--
-- Name: socials socials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.socials
    ADD CONSTRAINT socials_pkey PRIMARY KEY (id);


--
-- Name: splash_integrations splash_integrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.splash_integrations
    ADD CONSTRAINT splash_integrations_pkey PRIMARY KEY (id);


--
-- Name: splash_pages splash_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.splash_pages
    ADD CONSTRAINT splash_pages_pkey PRIMARY KEY (id);


--
-- Name: stations stations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_locations_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_locations_on_slug ON public.locations USING btree (slug);


--
-- Name: index_oauth_access_grants_on_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_oauth_access_grants_on_application_id ON public.oauth_access_grants USING btree (application_id);


--
-- Name: index_oauth_access_grants_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_access_grants_on_token ON public.oauth_access_grants USING btree (token);


--
-- Name: index_oauth_access_tokens_on_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_oauth_access_tokens_on_application_id ON public.oauth_access_tokens USING btree (application_id);


--
-- Name: index_oauth_access_tokens_on_refresh_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_access_tokens_on_refresh_token ON public.oauth_access_tokens USING btree (refresh_token);


--
-- Name: index_oauth_access_tokens_on_resource_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_oauth_access_tokens_on_resource_owner_id ON public.oauth_access_tokens USING btree (resource_owner_id);


--
-- Name: index_oauth_access_tokens_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_access_tokens_on_token ON public.oauth_access_tokens USING btree (token);


--
-- Name: index_oauth_applications_on_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_applications_on_uid ON public.oauth_applications USING btree (uid);


--
-- Name: index_splash_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_splash_on_location_id ON public.splash_pages USING btree (location_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: oauth_access_tokens fk_rails_732cb83ab7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_tokens
    ADD CONSTRAINT fk_rails_732cb83ab7 FOREIGN KEY (application_id) REFERENCES public.oauth_applications(id);


--
-- Name: oauth_access_grants fk_rails_b4b53e07b8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_grants
    ADD CONSTRAINT fk_rails_b4b53e07b8 FOREIGN KEY (application_id) REFERENCES public.oauth_applications(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20180513140551'),
('20180513141712'),
('20180513141932'),
('20180513143055'),
('20180513144442'),
('20180513151828'),
('20180514140816'),
('20180514192517'),
('20180515185505'),
('20180515225048'),
('20180516102154'),
('20180516110438'),
('20180516111400'),
('20180516115523'),
('20180516123406'),
('20180516124926'),
('20180516160443'),
('20180516170950'),
('20180516180256'),
('20180517135044'),
('20180519134903'),
('20180521192106'),
('20180522125523'),
('20180528142257'),
('20180604175221'),
('20180605132042');


