--
-- PostgreSQL database dump
--

\restrict ezxdCGM3EWNrMdlPiJ1An1MxCWTslwgc7GhZVi1KskpOG8mjMPeiGdA2Y3qWuGr

-- Dumped from database version 18.4 (48c2093)
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: daily_schedule; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.daily_schedule (
    id integer NOT NULL,
    menu_item_id integer NOT NULL,
    date date NOT NULL
);


ALTER TABLE public.daily_schedule OWNER TO neondb_owner;

--
-- Name: daily_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.daily_schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.daily_schedule_id_seq OWNER TO neondb_owner;

--
-- Name: daily_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.daily_schedule_id_seq OWNED BY public.daily_schedule.id;


--
-- Name: dining_halls; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.dining_halls (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT dining_halls_type_check CHECK (((type)::text = ANY ((ARRAY['fixed'::character varying, 'variable'::character varying])::text[])))
);


ALTER TABLE public.dining_halls OWNER TO neondb_owner;

--
-- Name: dining_halls_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.dining_halls_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dining_halls_id_seq OWNER TO neondb_owner;

--
-- Name: dining_halls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.dining_halls_id_seq OWNED BY public.dining_halls.id;


--
-- Name: meal_logs; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.meal_logs (
    id integer NOT NULL,
    user_id integer NOT NULL,
    menu_item_id integer,
    log_date date NOT NULL,
    meal_type character varying(50),
    servings numeric DEFAULT 1,
    calories integer,
    protein integer,
    carbs integer,
    fat integer,
    options_text text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.meal_logs OWNER TO neondb_owner;

--
-- Name: meal_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.meal_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.meal_logs_id_seq OWNER TO neondb_owner;

--
-- Name: meal_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.meal_logs_id_seq OWNED BY public.meal_logs.id;


--
-- Name: menu_items_master; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.menu_items_master (
    id integer NOT NULL,
    station_id integer NOT NULL,
    name character varying(255) NOT NULL,
    meal_type character varying(50),
    nutrition_source character varying(50) NOT NULL,
    nutrition_status character varying(50) NOT NULL,
    scraped_calories integer,
    scraped_protein integer,
    scraped_carbs integer,
    scraped_fat integer,
    scraped_serving_size text,
    override_calories integer,
    override_protein integer,
    override_carbs integer,
    override_fat integer,
    override_serving_size text,
    is_customizable boolean DEFAULT false,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    nutrislice_food_id integer,
    admin_review_status character varying(50) DEFAULT 'pending'::character varying,
    CONSTRAINT menu_items_master_admin_review_status_check CHECK (((admin_review_status)::text = ANY ((ARRAY['pending'::character varying, 'reviewed'::character varying, 'overridden'::character varying])::text[]))),
    CONSTRAINT menu_items_master_meal_type_check CHECK (((meal_type)::text = ANY ((ARRAY['breakfast'::character varying, 'lunch'::character varying, 'dinner'::character varying, 'all'::character varying])::text[]))),
    CONSTRAINT menu_items_master_nutrition_source_check CHECK (((nutrition_source)::text = ANY ((ARRAY['scraped'::character varying, 'manual'::character varying])::text[]))),
    CONSTRAINT menu_items_master_nutrition_status_check CHECK (((nutrition_status)::text = ANY ((ARRAY['accepted'::character varying, 'overridden'::character varying])::text[])))
);


ALTER TABLE public.menu_items_master OWNER TO neondb_owner;

--
-- Name: menu_items_master_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.menu_items_master_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.menu_items_master_id_seq OWNER TO neondb_owner;

--
-- Name: menu_items_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.menu_items_master_id_seq OWNED BY public.menu_items_master.id;


--
-- Name: option_groups; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.option_groups (
    id integer NOT NULL,
    menu_item_id integer NOT NULL,
    name text NOT NULL,
    required boolean DEFAULT false,
    multi_select boolean DEFAULT false
);


ALTER TABLE public.option_groups OWNER TO neondb_owner;

--
-- Name: option_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.option_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.option_groups_id_seq OWNER TO neondb_owner;

--
-- Name: option_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.option_groups_id_seq OWNED BY public.option_groups.id;


--
-- Name: options; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.options (
    id integer NOT NULL,
    group_id integer NOT NULL,
    name text NOT NULL,
    calories_delta integer DEFAULT 0,
    protein_delta integer DEFAULT 0,
    carbs_delta integer DEFAULT 0,
    fat_delta integer DEFAULT 0,
    is_default boolean DEFAULT false
);


ALTER TABLE public.options OWNER TO neondb_owner;

--
-- Name: options_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.options_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.options_id_seq OWNER TO neondb_owner;

--
-- Name: options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.options_id_seq OWNED BY public.options.id;


--
-- Name: stations; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.stations (
    id integer NOT NULL,
    dining_hall_id integer NOT NULL,
    name character varying(255) NOT NULL,
    nutrislice_station_id integer
);


ALTER TABLE public.stations OWNER TO neondb_owner;

--
-- Name: stations_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.stations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stations_id_seq OWNER TO neondb_owner;

--
-- Name: stations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.stations_id_seq OWNED BY public.stations.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    password_hash text NOT NULL,
    daily_calorie_goal integer DEFAULT 2000,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_admin boolean DEFAULT false
);


ALTER TABLE public.users OWNER TO neondb_owner;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO neondb_owner;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: daily_schedule id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.daily_schedule ALTER COLUMN id SET DEFAULT nextval('public.daily_schedule_id_seq'::regclass);


--
-- Name: dining_halls id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.dining_halls ALTER COLUMN id SET DEFAULT nextval('public.dining_halls_id_seq'::regclass);


--
-- Name: meal_logs id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.meal_logs ALTER COLUMN id SET DEFAULT nextval('public.meal_logs_id_seq'::regclass);


--
-- Name: menu_items_master id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.menu_items_master ALTER COLUMN id SET DEFAULT nextval('public.menu_items_master_id_seq'::regclass);


--
-- Name: option_groups id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.option_groups ALTER COLUMN id SET DEFAULT nextval('public.option_groups_id_seq'::regclass);


--
-- Name: options id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.options ALTER COLUMN id SET DEFAULT nextval('public.options_id_seq'::regclass);


--
-- Name: stations id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.stations ALTER COLUMN id SET DEFAULT nextval('public.stations_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: daily_schedule; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1, 1, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (2, 2, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (5, 5, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (6, 6, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (7, 7, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (8, 8, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (9, 9, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (10, 10, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (11, 11, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (12, 12, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (13, 13, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (14, 14, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (15, 15, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (16, 16, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (17, 17, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (18, 18, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (19, 19, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (20, 20, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (21, 21, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (22, 22, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (23, 23, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (24, 24, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (25, 25, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (27, 27, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (28, 28, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (29, 29, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (30, 30, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (31, 31, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (32, 32, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (33, 33, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (34, 34, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (35, 35, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (36, 36, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (37, 37, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (38, 38, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (39, 39, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (40, 40, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (41, 41, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (42, 42, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (43, 43, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (46, 46, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (47, 47, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (48, 48, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (49, 49, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (50, 50, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (51, 51, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (52, 52, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (53, 53, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (54, 54, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (55, 55, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (56, 56, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (57, 57, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (58, 58, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (59, 59, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (60, 60, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (61, 61, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (62, 62, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (63, 63, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (64, 64, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (65, 65, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (66, 66, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (67, 67, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (68, 68, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (69, 69, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (70, 70, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (71, 71, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (72, 72, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (73, 73, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (74, 74, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (75, 75, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (76, 76, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (77, 77, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (78, 78, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (79, 79, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (80, 80, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (81, 81, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (82, 82, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (83, 83, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (84, 84, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (85, 85, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (86, 86, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (87, 87, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (88, 88, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (89, 89, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (90, 90, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (91, 91, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (92, 92, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (93, 93, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (94, 94, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (95, 95, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (96, 96, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (97, 97, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (98, 98, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (99, 99, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (100, 100, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (101, 101, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (102, 102, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (103, 103, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (104, 104, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (105, 105, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (106, 106, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (107, 107, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (108, 108, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (109, 109, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (110, 110, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (111, 111, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (112, 112, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (113, 113, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (114, 114, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (115, 115, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (116, 116, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (117, 117, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (118, 118, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (119, 119, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (120, 120, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (124, 124, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (168, 168, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (169, 169, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (170, 170, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (171, 171, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (172, 172, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (173, 173, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (174, 174, '2026-06-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (345, 5, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (346, 6, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (347, 7, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (348, 8, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (349, 9, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (350, 10, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (351, 11, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (352, 12, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (353, 13, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (354, 14, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (355, 15, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (356, 16, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (357, 17, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (358, 18, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (359, 19, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (360, 20, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (361, 21, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (362, 22, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (363, 23, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (364, 24, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (365, 25, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (367, 27, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (368, 28, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (369, 29, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (370, 30, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (371, 31, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (372, 32, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (373, 33, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (374, 34, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (375, 35, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (376, 36, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (377, 377, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (378, 39, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (379, 379, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (380, 380, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (381, 42, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (382, 382, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (383, 383, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (384, 1, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (385, 2, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (386, 46, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (387, 47, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (388, 48, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (389, 49, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (390, 50, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (391, 51, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (392, 52, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (393, 53, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (394, 54, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (395, 55, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (396, 56, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (397, 57, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (398, 58, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (399, 59, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (400, 60, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (401, 61, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (402, 62, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (403, 63, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (404, 64, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (405, 65, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (406, 66, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (407, 67, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (408, 68, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (409, 69, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (410, 70, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (411, 71, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (412, 72, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (413, 73, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (414, 74, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (415, 75, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (416, 76, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (417, 77, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (418, 78, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (419, 79, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (420, 80, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (421, 81, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (422, 82, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (423, 83, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (424, 84, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (425, 85, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (426, 86, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (427, 87, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (428, 88, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (429, 89, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (430, 90, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (431, 91, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (432, 92, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (433, 93, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (434, 94, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (435, 95, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (436, 96, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (437, 97, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (438, 98, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (439, 99, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (440, 100, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (441, 101, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (442, 102, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (443, 103, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (444, 104, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (445, 105, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (446, 106, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (447, 107, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (448, 108, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (449, 109, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (450, 110, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (451, 111, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (452, 112, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (453, 453, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (454, 454, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (455, 455, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (456, 116, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (457, 457, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (458, 458, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (459, 459, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (460, 460, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (461, 461, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (462, 462, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (463, 120, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (464, 464, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (468, 124, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (511, 511, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (512, 512, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (513, 513, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (514, 514, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (515, 515, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (516, 516, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (517, 517, '2026-06-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (691, 5, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (692, 6, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (693, 7, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (694, 8, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (695, 9, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (696, 10, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (697, 11, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (698, 12, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (699, 13, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (700, 14, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (701, 15, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (702, 16, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (703, 17, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (704, 18, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (705, 19, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (706, 20, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (707, 21, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (708, 22, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (709, 23, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (710, 24, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (711, 25, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (713, 27, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (714, 28, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (715, 29, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (716, 30, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (717, 31, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (718, 32, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (719, 33, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (720, 34, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (721, 35, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (722, 36, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (723, 723, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (724, 724, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (725, 39, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (726, 726, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (727, 727, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (728, 42, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (729, 43, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (730, 1, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (731, 2, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (732, 46, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (733, 47, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (734, 48, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (735, 49, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (736, 50, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (737, 51, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (738, 52, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (739, 53, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (740, 54, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (741, 55, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (742, 56, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (743, 57, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (744, 58, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (745, 59, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (746, 60, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (747, 61, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (748, 62, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (749, 63, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (750, 64, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (751, 65, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (752, 66, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (753, 67, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (754, 68, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (755, 69, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (756, 70, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (757, 71, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (758, 72, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (759, 73, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (760, 74, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (761, 75, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (762, 76, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (763, 77, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (764, 78, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (765, 79, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (766, 80, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (767, 81, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (768, 82, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (769, 83, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (770, 84, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (771, 85, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (772, 86, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (773, 87, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (774, 88, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (775, 89, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (776, 90, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (777, 91, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (778, 92, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (779, 93, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (780, 94, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (781, 95, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (782, 96, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (783, 97, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (784, 98, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (785, 99, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (786, 100, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (787, 101, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (788, 102, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (789, 103, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (790, 104, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (791, 105, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (792, 106, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (793, 107, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (794, 108, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (795, 109, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (796, 110, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (797, 111, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (798, 112, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (799, 799, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (800, 800, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (801, 116, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (802, 802, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (803, 803, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (804, 804, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (805, 805, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (806, 806, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (807, 807, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (808, 808, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (809, 809, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (810, 810, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (814, 124, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (857, 857, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (858, 858, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (859, 859, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (860, 860, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (861, 861, '2026-06-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (862, 5, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (863, 6, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (864, 7, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (865, 8, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (866, 9, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (867, 10, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (868, 11, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (869, 12, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (870, 13, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (871, 14, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (872, 15, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (873, 16, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (874, 17, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (875, 18, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (876, 19, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (877, 20, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (878, 21, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (879, 22, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (880, 23, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (881, 24, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (882, 25, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (884, 27, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (885, 28, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (886, 886, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (887, 29, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (888, 32, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (889, 33, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (890, 890, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (891, 34, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (892, 35, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (893, 36, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (894, 894, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (895, 37, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (896, 39, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (897, 379, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (898, 898, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (899, 899, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (900, 900, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (901, 901, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (902, 43, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (903, 1, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (904, 2, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (905, 46, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (906, 47, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (907, 48, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (908, 49, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (909, 50, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (910, 51, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (911, 52, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (912, 53, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (913, 54, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (914, 55, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (915, 56, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (916, 57, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (917, 58, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (918, 59, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (919, 60, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (920, 61, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (921, 62, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (922, 63, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (923, 64, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (924, 65, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (925, 66, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (926, 67, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (927, 68, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (928, 69, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (929, 70, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (930, 71, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (931, 72, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (932, 73, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (933, 74, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (934, 75, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (935, 76, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (936, 77, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (937, 78, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (938, 79, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (939, 80, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (945, 81, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (946, 82, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (947, 83, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (948, 84, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (949, 85, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (966, 86, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (967, 87, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (968, 88, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (969, 969, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (973, 89, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (975, 90, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (976, 91, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (977, 92, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (978, 93, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (979, 94, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (980, 95, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (981, 96, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (982, 97, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (983, 98, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (984, 99, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (985, 100, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (986, 101, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (987, 102, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (988, 103, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (989, 104, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (990, 105, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (991, 106, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (992, 107, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (993, 108, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (994, 109, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (995, 110, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (996, 111, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (997, 112, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (998, 998, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1011, 1011, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1013, 1013, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1017, 124, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1061, 1061, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1062, 1062, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1063, 1063, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1064, 1064, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1065, 1065, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1066, 1066, '2026-06-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1067, 5, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1068, 6, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1069, 7, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1070, 8, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1071, 9, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1072, 10, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1073, 11, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1074, 12, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1075, 13, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1076, 14, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1077, 15, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1078, 16, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1079, 17, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1080, 18, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1081, 19, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1082, 20, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1083, 21, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1084, 22, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1085, 23, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1086, 24, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1087, 25, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1089, 27, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1090, 28, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1091, 886, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1092, 29, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1093, 32, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1094, 33, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1095, 890, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1096, 34, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1097, 35, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1098, 36, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1099, 894, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1100, 1100, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1101, 1101, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1102, 39, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1103, 1103, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1104, 42, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1105, 382, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1106, 1106, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1107, 1, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1108, 2, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1109, 46, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1110, 47, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1111, 48, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1112, 49, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1113, 50, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1114, 51, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1115, 52, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1116, 53, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1117, 54, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1118, 55, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1119, 56, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1120, 57, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1121, 58, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1122, 59, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1123, 60, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1124, 61, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1125, 62, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1126, 63, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1127, 64, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1128, 65, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1129, 66, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1130, 67, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1131, 68, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1132, 69, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1133, 70, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1134, 71, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1135, 72, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1136, 73, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1137, 74, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1138, 75, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1139, 76, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1140, 77, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1141, 78, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1142, 79, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1143, 80, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1149, 81, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1150, 82, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1151, 83, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1152, 84, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1153, 85, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1169, 86, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1170, 87, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1171, 88, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1172, 969, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1175, 89, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1176, 90, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1177, 91, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1178, 92, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1179, 93, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1180, 94, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1181, 95, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1182, 96, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1183, 97, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1184, 98, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1185, 99, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1186, 100, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1187, 101, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1188, 102, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1189, 103, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1190, 104, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1191, 105, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1192, 106, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1193, 107, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1194, 108, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1195, 109, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1196, 110, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1197, 111, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1198, 112, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1206, 802, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1210, 1210, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1217, 124, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1261, 1261, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1262, 1262, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1263, 1263, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1264, 1264, '2026-06-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (1265, 1265, '2026-06-21');


--
-- Data for Name: dining_halls; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

INSERT INTO public.dining_halls (id, name, type, created_at) VALUES (1, 'Donahue Hall', 'variable', '2026-06-17 17:36:17.934442');
INSERT INTO public.dining_halls (id, name, type, created_at) VALUES (2, 'Dougherty Hall', 'variable', '2026-06-17 17:36:17.934442');
INSERT INTO public.dining_halls (id, name, type, created_at) VALUES (3, 'St. Mary''s Dining Hall', 'variable', '2026-06-17 17:36:17.934442');
INSERT INTO public.dining_halls (id, name, type, created_at) VALUES (4, 'Café Nova', 'fixed', '2026-06-17 17:36:17.934442');
INSERT INTO public.dining_halls (id, name, type, created_at) VALUES (5, 'Connelly Center', 'fixed', '2026-06-17 17:36:17.934442');


--
-- Data for Name: meal_logs; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--



--
-- Data for Name: menu_items_master; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (1062, 11, 'Beef Gravy', 'dinner', 'scraped', 'accepted', 13, 0, 3, 1, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:22.039144', '2026-06-18 19:33:22.039144', 2059600, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (68, 16, 'Grilled Chicken', 'dinner', 'scraped', 'accepted', 88, 17, 2, 2, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.554932', '2026-06-18 19:33:31.784571', 2059455, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (861, 11, 'Vegetable & White Bean Hash', 'dinner', 'scraped', 'accepted', 87, 4, 18, 1, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:09.282009', '2026-06-18 19:57:19.992286', 2010817, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (62, 15, 'Hot Sauce', 'dinner', 'scraped', 'accepted', 6, 0, 1, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.244659', '2026-06-18 19:33:31.482527', 2059526, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (10, 5, 'Hard Boiled Eggs', 'breakfast', 'scraped', 'accepted', 54, 7, 0, 5, '1 egg', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.243524', '2026-06-18 19:33:22.820023', 1995512, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (2, 2, 'House Made Hummus', 'dinner', 'scraped', 'accepted', 81, 2, 7, 5, '1 2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:53:08.453445', '2026-06-18 19:56:45.656645', 2059479, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (19, 6, 'Hard Boiled Egg', 'lunch', 'scraped', 'accepted', 69, 6, 1, 5, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.68059', '2026-06-18 19:33:27.778513', 2059509, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (20, 6, 'Strawberries', 'lunch', 'scraped', 'accepted', 27, 1, 7, 0, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.724935', '2026-06-18 19:33:27.820471', 2085975, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (21, 6, 'Strawberry Yogurt', 'lunch', 'scraped', 'accepted', 100, 4, 19, 1, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.768742', '2026-06-18 19:33:27.864323', 2086206, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (87, 6, 'House Made Red Pepper Hummus', 'dinner', 'scraped', 'accepted', 111, 3, 10, 7, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.484817', '2026-06-18 19:33:32.577978', 2059490, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (27, 6, 'Organic Pumpkin Seed', 'breakfast', 'scraped', 'accepted', 1356, 101, 11, 100, '1 lbs', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.053079', '2026-06-18 19:33:23.667388', 1995548, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (89, 20, 'Neapolitan Cheese Flatbread', 'dinner', 'scraped', 'accepted', 393, 16, 47, 14, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.597098', '2026-06-18 19:33:32.69787', 2010810, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (90, 20, 'Neapolitan Pepperoni Flatbread', 'dinner', 'scraped', 'accepted', 469, 19, 48, 21, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.644783', '2026-06-18 19:33:32.742042', 2010811, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (32, 8, 'Toppings available for Oatmeal', 'breakfast', 'scraped', 'accepted', 232, 4, 44, 6, '1 topping', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.361983', '2026-06-18 19:33:23.899856', 1995510, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (92, 21, 'Little Leaf Romaine Lettuce', 'lunch', 'scraped', 'accepted', 13, 1, 2, 0, '1 salad', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.761227', '2026-06-18 19:33:28.569941', 2059513, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (25, 6, 'Fresh Berries', 'breakfast', 'scraped', 'accepted', 30, 1, 7, 0, '1 ptn 2.3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.959034', '2026-06-18 19:33:23.567874', 1995508, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (23, 6, 'Chia Pudding', 'lunch', 'scraped', 'accepted', 601, 18, 22, 53, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.866875', '2026-06-18 19:33:27.951911', 1995538, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (22, 6, 'House Made Granola', 'lunch', 'scraped', 'accepted', 105, 3, 17, 3, '1 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.823409', '2026-06-18 19:33:28.063145', 1995544, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (34, 9, 'Guacamole', 'lunch', 'scraped', 'accepted', 85, 0, 8, 6, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.478884', '2026-06-18 19:33:29.681909', 1995550, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (30, 7, 'Scrambled Eggs', 'breakfast', 'scraped', 'accepted', 177, 15, 0, 11, '1 4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.240611', '2026-06-18 19:33:01.049952', 1995516, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (31, 7, 'Scrambled Egg Whites', 'breakfast', 'scraped', 'accepted', 17, 3, 0, 0, '1 4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.291525', '2026-06-18 19:33:01.100026', 1995518, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (36, 9, 'Whipped Cream Cheese', 'lunch', 'scraped', 'accepted', 162, 3, 3, 16, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.596815', '2026-06-18 19:33:29.772004', 1995554, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (41, 11, 'Taylor Ham', 'breakfast', 'scraped', 'accepted', 166, 10, 0, 14, '2 slices', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.900728', '2026-06-18 19:58:44.747722', 1997715, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (43, 11, 'Turkey Sausage Patties', 'lunch', 'scraped', 'accepted', 89, 6, 1, 7, '1.5 ounce patty', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.988655', '2026-06-18 19:57:52.22066', 1995527, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (37, 10, 'Pancakes', 'lunch', 'scraped', 'accepted', 89, 2, 17, 1, '2 pancakes', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.688729', '2026-06-18 19:33:18.083204', 1995524, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (42, 11, 'Tofu Scramble', 'lunch', 'scraped', 'accepted', 94, 5, 11, 5, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.944693', '2026-06-18 19:58:41.695407', 1995519, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (48, 13, 'Hoagie Roll', 'dinner', 'scraped', 'accepted', 158, 6, 28, 2, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.546814', '2026-06-18 19:33:30.792212', 2059460, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (69, 16, 'Domestic Ham', 'dinner', 'scraped', 'accepted', 78, 13, 2, 3, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.598846', '2026-06-18 19:33:31.831955', 2059462, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (73, 16, 'Roasted Vegetables', 'dinner', 'scraped', 'accepted', 74, 1, 7, 5, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.778696', '2026-06-18 19:33:32.008032', 2059473, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (74, 17, 'Bacon', 'dinner', 'scraped', 'accepted', 51, 5, 0, 6, '0.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.844745', '2026-06-18 19:33:32.077997', 2059454, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (75, 17, 'Green Leaf Lettuce', 'dinner', 'scraped', 'accepted', 2, 0, 0, 0, '0.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.888892', '2026-06-18 19:33:32.124721', 2059458, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (76, 17, 'Hot Peppers', 'dinner', 'scraped', 'accepted', 3, 0, 1, 0, '0.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.934882', '2026-06-18 19:33:32.171955', 2059453, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (78, 17, 'Sliced Red Onion', 'dinner', 'scraped', 'accepted', 5, 0, 1, 0, '0.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.0228', '2026-06-18 19:33:32.261815', 2059465, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (79, 17, 'Sweet Peppers', 'dinner', 'scraped', 'accepted', 3, 0, 1, 0, '0.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.068799', '2026-06-18 19:33:32.305922', 2059472, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (80, 17, 'Sliced Tomato', 'dinner', 'scraped', 'accepted', 7, 0, 1, 0, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.112798', '2026-06-18 19:33:32.350001', 2059463, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (83, 18, 'Chocolate Soft Serve Ice Cream', 'dinner', 'scraped', 'accepted', 514, 0, 98, 15, '5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.282773', '2026-06-18 19:33:32.417965', 2059481, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (81, 18, 'Chocolate Chip Cookie (Veg)', 'lunch', 'scraped', 'accepted', 236, 2, 35, 11, '2 ozchoc chip cook', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.190747', '2026-06-18 19:33:27.122931', 2010794, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (12, 6, 'Cottage Cheese', 'lunch', 'scraped', 'accepted', 111, 13, 4, 5, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.3607', '2026-06-18 19:33:27.432854', 2085967, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (82, 18, 'Fudge Brownie Cookie', 'lunch', 'scraped', 'accepted', 177, 1, 26, 8, '1 cookie', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.234718', '2026-06-18 19:33:27.170043', 2207784, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (14, 6, 'Honeydew Melon', 'lunch', 'scraped', 'accepted', 20, 0, 5, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.454788', '2026-06-18 19:33:27.538015', 2085969, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (86, 6, 'Grilled Pita', 'dinner', 'scraped', 'accepted', 248, 7, 35, 10, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.440727', '2026-06-18 19:33:32.528012', 2040798, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (91, 20, 'Vegetable Flatbread Pizza', 'dinner', 'scraped', 'accepted', 613, 24, 75, 22, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.690749', '2026-06-18 19:33:32.787993', 2010812, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (1103, 11, 'Nova Cinnamon Roll', 'lunch', 'scraped', 'accepted', 506, 6, 77, 18, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:24.442019', '2026-06-18 19:33:30.085969', 1995531, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (723, 11, 'Breakfast Ham', 'breakfast', 'scraped', 'accepted', 91, 14, 1, 3, '1 3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:01.427888', '2026-06-18 19:33:01.427888', 1995513, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (724, 11, 'Chilaquiles', 'breakfast', 'scraped', 'accepted', 245, 8, 20, 16, '6 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:01.476118', '2026-06-18 19:33:01.476118', 1999579, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (998, 24, 'Minestrone Soup', 'lunch', 'scraped', 'accepted', 58, 2, 10, 1, '8 oz cup', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:17.689379', '2026-06-18 19:33:17.689379', 1995605, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (726, 11, 'French Toast Sticks', 'breakfast', 'scraped', 'accepted', 274, 5, 39, 12, '4 stick', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:01.569974', '2026-06-18 19:33:01.569974', 2015863, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (727, 11, 'Lyonnaise Potatoes', 'breakfast', 'scraped', 'accepted', 128, 2, 21, 5, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:01.613928', '2026-06-18 19:33:01.613928', 1995514, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (799, 24, 'Coconut Green Soup with Kale & Ginger', 'lunch', 'scraped', 'accepted', 138, 2, 8, 12, '12 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:05.793962', '2026-06-18 19:33:05.793962', 2055493, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (800, 24, 'Seafood Bisque', 'lunch', 'scraped', 'accepted', 46, 3, 3, 3, '6 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:05.838103', '2026-06-18 19:33:05.838103', 1995593, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (116, 10, 'Grilled Cheese Sandwich', 'lunch', 'scraped', 'accepted', 424, 22, 32, 22, '1 sandwich 4 ounces', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.998863', '2026-06-18 19:33:05.903934', 1995569, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (803, 10, 'Chicken Cheesesteak', 'lunch', 'scraped', 'accepted', 425, 40, 23, 19, '1 sandwich', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:06.002312', '2026-06-18 19:33:06.002312', 1995573, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (804, 11, 'Cauliflower with Red Peppers', 'lunch', 'scraped', 'accepted', 28, 2, 6, 0, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:06.067925', '2026-06-18 19:33:06.067925', 2010805, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (805, 11, 'Crabless Cakes (veg)', 'lunch', 'scraped', 'accepted', 293, 7, 37, 12, '1 6 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:06.114074', '2026-06-18 19:33:06.114074', 2024553, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (806, 11, 'Pepperoni Stromboli', 'lunch', 'scraped', 'accepted', 295, 10, 39, 10, '5.25 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:06.160204', '2026-06-18 19:33:06.160204', 2126175, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (807, 11, 'Stromboli', 'lunch', 'scraped', 'accepted', 143, 5, 25, 2, '5.25 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:06.204548', '2026-06-18 19:33:06.204548', 2126176, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (808, 11, 'Remoulade Sauce', 'lunch', 'scraped', 'accepted', 1, 0, 0, 0, '1 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:06.247982', '2026-06-18 19:33:06.247982', 2024556, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (809, 11, 'Cocktail Sauce', 'lunch', 'scraped', 'accepted', 80, 0, 15, 3, '1 container', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:06.289947', '2026-06-18 19:33:06.289947', 2024557, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (810, 11, 'Tartar Sauce', 'lunch', 'scraped', 'accepted', 35, 0, 0, 4, '1 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:06.334031', '2026-06-18 19:33:06.334031', 2024558, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (1063, 11, 'Stuffed Grilled Portabello with Harissa', 'dinner', 'scraped', 'accepted', 258, 8, 26, 15, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:22.084056', '2026-06-18 19:33:22.084056', 2059604, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (857, 11, 'Chicken Parmesan', 'dinner', 'scraped', 'accepted', 609, 47, 53, 21, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:09.101977', '2026-06-18 19:33:09.101977', 2010809, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (858, 11, 'Italian Vegetable Blend', 'dinner', 'scraped', 'accepted', 51, 3, 10, 1, '1 4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:09.148054', '2026-06-18 19:33:09.148054', 2010813, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (859, 11, 'Spaghetti & Meatballs', 'dinner', 'scraped', 'accepted', 734, 31, 125, 11, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:09.190685', '2026-06-18 19:33:09.190685', 2010814, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (860, 11, 'Sauteed Spinach with Roasted Red Peppers', 'dinner', 'scraped', 'accepted', 33, 3, 4, 1, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:09.236444', '2026-06-18 19:33:09.236444', 2010816, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (1064, 11, 'Roasted Red Skin Potatoes', 'dinner', 'scraped', 'accepted', 201, 3, 22, 11, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:22.129992', '2026-06-18 19:33:22.129992', 2059605, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (1065, 11, 'Roasted Brussels Sprouts with Garlic', 'dinner', 'scraped', 'accepted', 71, 4, 9, 3, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:22.176031', '2026-06-18 19:33:22.176031', 2010822, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (1066, 11, 'Sauteed Yellow Squash', 'dinner', 'scraped', 'accepted', 42, 1, 3, 3, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:22.22279', '2026-06-18 19:33:22.22279', 1995612, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (11, 6, 'Blueberries', 'lunch', 'scraped', 'accepted', 32, 0, 8, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.312783', '2026-06-18 19:33:27.386238', 2085966, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (898, 11, 'Cheese Blintz with Berry Compote', 'breakfast', 'scraped', 'accepted', 210, 4, 27, 3, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:12.224209', '2026-06-18 19:33:12.224209', 1995528, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (802, 10, 'Grilled Chicken Breast', 'dinner', 'scraped', 'accepted', 209, 38, 0, 5, '0.25 ouunce chicken', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:05.947991', '2026-06-18 19:33:32.854093', 2010801, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (5, 1, 'NY Style Cinnamon Rasin Bagel', 'lunch', 'scraped', 'accepted', 280, 11, 57, 1, '5 oz bagel', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:33.987194', '2026-06-18 19:33:26.838289', 1995533, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (899, 11, 'Hash Brown Triangle Patty', 'lunch', 'scraped', 'accepted', 115, 1, 14, 5, '2 oz patty', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:12.267939', '2026-06-18 19:33:18.248165', 1999580, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (900, 11, 'Pork Sausage Link', 'lunch', 'scraped', 'accepted', 121, 9, 0, 9, '2 links', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:12.312365', '2026-06-18 19:33:18.292038', 1995515, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (901, 11, 'Spinach Quiche', 'lunch', 'scraped', 'accepted', 251, 11, 17, 15, '6 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:12.357263', '2026-06-18 19:33:18.338082', 2240263, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (1011, 11, 'White Rice', 'lunch', 'scraped', 'accepted', 93, 2, 19, 1, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:18.384051', '2026-06-18 19:33:18.384051', 1995572, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (18, 6, 'Greek Yogurt', 'lunch', 'scraped', 'accepted', 71, 6, 8, 2, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.637126', '2026-06-18 19:33:27.71596', 2085973, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (114, 24, 'Chicken Noodle Soup', 'lunch', 'scraped', 'accepted', 59, 4, 8, 1, '8 oz bowl', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.878971', '2026-06-17 22:03:52.875927', 1995580, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (77, 17, 'Dill Pickles', 'dinner', 'scraped', 'accepted', 5, 0, 1, 0, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.978688', '2026-06-18 19:33:32.215922', 2059466, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (1, 2, 'Chickpea Salad', 'dinner', 'scraped', 'accepted', 255, 6, 11, 19, '1 sandwich', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:53:08.370785', '2026-06-18 19:56:42.101289', 2059475, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (124, 13, '100% Whole Grain Bread', 'dinner', 'scraped', 'accepted', 9, 0, 2, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:41.982739', '2026-06-18 19:56:53.905015', 2059542, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (1013, 11, 'Whole Green Beans', 'lunch', 'scraped', 'accepted', 13, 1, 3, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:18.499624', '2026-06-18 19:33:18.499624', 1995600, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (24, 6, 'Overnight Oats', 'lunch', 'scraped', 'accepted', 1127, 39, 183, 28, '10 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.915018', '2026-06-18 19:33:28.013939', 1995539, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (1061, 11, 'Roast Beef', 'dinner', 'scraped', 'accepted', 155, 25, 1, 5, '1 4 ounces', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:21.992143', '2026-06-18 19:33:21.992143', 2059601, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (969, 6, 'Shell Off Pumkin Seed', 'lunch', 'scraped', 'accepted', 153, 7, 5, 13, '1 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:16.206055', '2026-06-18 19:33:28.246019', 2024544, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (886, 7, 'Maple Flavored Syrup', 'lunch', 'scraped', 'accepted', 75, 0, 20, 0, '1 fl oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:11.585982', '2026-06-18 19:33:28.349975', 2099708, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (890, 9, 'GRAD- WHIPPED FETA', 'lunch', 'scraped', 'accepted', 188, 10, 5, 15, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:11.805931', '2026-06-18 19:33:29.637905', 2240262, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (1100, 10, 'Texas French Toast', 'lunch', 'scraped', 'accepted', 188, 11, 17, 8, '2 slice', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:24.282026', '2026-06-18 19:33:29.885157', 1995517, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (1262, 11, 'Roasted Cauliflower', 'dinner', 'scraped', 'accepted', 48, 2, 6, 3, '1 4 ounces', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:32.965969', '2026-06-18 19:33:32.965969', 1995630, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (894, 10, 'BERRY COMPOTE', 'lunch', 'scraped', 'accepted', 108, 0, 27, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:12.006024', '2026-06-18 19:33:29.839923', 2072101, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (1101, 11, 'Crispy Bacon', 'lunch', 'scraped', 'accepted', 377, 27, 1, 28, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:24.348501', '2026-06-18 19:33:29.995377', 1995530, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (39, 11, '100% Natural Rolled Oatmeal', 'lunch', 'scraped', 'accepted', 88, 4, 15, 1, '5 oz bowl', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.806846', '2026-06-18 19:33:30.042311', 1995504, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (1210, 11, 'Herbed Green Beans', 'lunch', 'scraped', 'accepted', 60, 1, 6, 4, '0.5 cups', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:30.132068', '2026-06-18 19:33:30.132068', 2059657, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (1106, 11, 'Tater Barrel', 'lunch', 'scraped', 'accepted', 918, 11, 113, 43, '1 lbs', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:24.624046', '2026-06-18 19:33:30.274782', 2109610, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (49, 13, 'Multigrain Bread', 'dinner', 'scraped', 'accepted', 151, 7, 27, 2, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.594717', '2026-06-18 19:33:30.840473', 2059456, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (1261, 11, 'Sage Dijon Chicken', 'dinner', 'scraped', 'accepted', 460, 29, 3, 37, '1 each', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:32.921997', '2026-06-18 19:33:32.921997', 2024577, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (1263, 11, 'Fresh Vegetable Medley', 'dinner', 'scraped', 'accepted', 36, 3, 7, 0, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:33.010022', '2026-06-18 19:33:33.010022', 1995642, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (1264, 11, 'ZUCCHINI DIJONNAISE', 'dinner', 'scraped', 'accepted', 351, 8, 29, 24, '1 each', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:33.059421', '2026-06-18 19:33:33.059421', 2024579, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (455, 10, 'Cheese burger', 'lunch', 'scraped', 'accepted', 389, 25, 1, 31, '1 burger', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:27.943764', '2026-06-18 19:32:55.29182', 1995603, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (457, 11, 'Bulgogi Beef', 'lunch', 'scraped', 'accepted', 101, 4, 11, 5, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:28.065557', '2026-06-18 19:32:55.411895', 2240048, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (459, 11, 'Carrots', 'lunch', 'scraped', 'accepted', 10, 0, 2, 0, '1 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:28.167589', '2026-06-18 19:32:55.527942', 2240050, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (1265, 11, 'Roasted Yukon Gold Potatoes', 'dinner', 'scraped', 'accepted', 101, 2, 23, 0, '1 4 ounces', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 19:33:33.109999', '2026-06-18 19:33:33.109999', 2024580, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (6, 1, 'NY Style Everything Bagel', 'lunch', 'scraped', 'accepted', 280, 11, 57, 1, '5 oz bagel', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.032709', '2026-06-18 19:33:26.885808', 1995534, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (7, 1, 'NY Style Plain Bagel', 'lunch', 'scraped', 'accepted', 280, 11, 57, 1, '5 oz bagel', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.084823', '2026-06-18 19:33:26.932046', 1995535, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (8, 1, 'NY Style Sesame Bagel', 'lunch', 'scraped', 'accepted', 280, 11, 57, 1, '5 oz bagel', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.12873', '2026-06-18 19:33:26.97736', 1995536, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (9, 5, 'Assorted Muffins & Loaf Cakes', 'lunch', 'scraped', 'accepted', 191, 3, 25, 9, '1 each', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.198714', '2026-06-18 19:33:27.044531', 1995540, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (47, 13, 'Assorted Wraps', 'dinner', 'scraped', 'accepted', 287, 8, 47, 7, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.502999', '2026-06-18 19:33:30.750002', 2059449, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (50, 13, 'Country Wheat Bread', 'dinner', 'scraped', 'accepted', 226, 11, 40, 3, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.642758', '2026-06-18 19:33:30.89004', 2059474, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (51, 13, 'Country White Bread', 'dinner', 'scraped', 'accepted', 38, 2, 7, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.688753', '2026-06-18 19:33:30.933924', 2059467, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (52, 14, 'American Cheese', 'dinner', 'scraped', 'accepted', 152, 8, 2, 12, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.761018', '2026-06-18 19:33:31.004091', 2059451, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (53, 14, 'Cheddar Cheese', 'dinner', 'scraped', 'accepted', 167, 11, 0, 14, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.808769', '2026-06-18 19:33:31.050173', 2059450, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (54, 14, 'Fresh Mozzarella Cheese', 'dinner', 'scraped', 'accepted', 210, 15, 3, 15, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.852829', '2026-06-18 19:33:31.094251', 2059457, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (55, 14, 'Pepper Jack Cheese', 'dinner', 'scraped', 'accepted', 202, 12, 2, 16, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.901048', '2026-06-18 19:33:31.139956', 2059461, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (56, 14, 'Provolone Cheese', 'dinner', 'scraped', 'accepted', 299, 22, 2, 23, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.946876', '2026-06-18 19:33:31.183007', 2059459, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (57, 14, 'Domestic Swiss Cheese', 'dinner', 'scraped', 'accepted', 334, 23, 1, 26, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.990697', '2026-06-18 19:33:31.228016', 2059469, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (58, 14, 'Assorted Dairy Free Cheese', 'dinner', 'scraped', 'accepted', 108, 1, 14, 14, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.03892', '2026-06-18 19:33:31.271996', 2059477, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (59, 15, 'Brown Spicy Mustard', 'dinner', 'scraped', 'accepted', 314, 20, 20, 20, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.108792', '2026-06-18 19:33:31.342078', 2059523, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (60, 15, 'Dijon Mustard', 'dinner', 'scraped', 'accepted', 52, 7, 7, 7, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.155184', '2026-06-18 19:33:31.388212', 2059531, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (61, 15, 'Honey Mustard', 'dinner', 'scraped', 'accepted', 301, 0, 9, 30, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.198725', '2026-06-18 19:33:31.433896', 2059535, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (88, 6, 'House Made Hummus', 'dinner', 'scraped', 'accepted', 122, 4, 11, 8, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.529232', '2026-06-18 19:33:32.624852', 2059493, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (46, 2, 'Vegan Option : Falafel', 'dinner', 'scraped', 'accepted', 53, 3, 11, 1, '1 4 ounces', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.436865', '2026-06-18 19:56:50.083027', 2059476, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (29, 7, 'Eggs and Omelets', 'breakfast', 'scraped', 'accepted', 137, 6, 2, 15, '7 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.189742', '2026-06-18 19:33:23.832416', 1995543, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (28, 6, 'Roasted Shelled Sunflower Seed', 'lunch', 'scraped', 'accepted', 85, 6, 1, 6, '1 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.105917', '2026-06-18 19:55:30.146083', 1995549, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (13, 6, 'Cantaloupe Melon', 'lunch', 'scraped', 'accepted', 19, 0, 5, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.40876', '2026-06-18 19:33:27.484255', 2085968, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (33, 9, 'Housemade Jam', 'lunch', 'scraped', 'accepted', 32, 0, 7, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.433014', '2026-06-18 19:33:29.591942', 1995537, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (15, 6, 'Pineapple', 'lunch', 'scraped', 'accepted', 29, 0, 8, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.500942', '2026-06-18 19:33:27.58392', 2085970, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (35, 9, 'Whipped Butter', 'lunch', 'scraped', 'accepted', 407, 1, 0, 46, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.526822', '2026-06-18 19:33:29.726323', 1995553, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (16, 6, 'Grapefruit', 'lunch', 'scraped', 'accepted', 29, 0, 8, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.546764', '2026-06-18 19:33:27.628067', 2085971, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (70, 16, 'Roast Beef', 'dinner', 'scraped', 'accepted', 117, 18, 0, 5, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.644711', '2026-06-18 19:33:31.875926', 2059471, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (72, 16, 'Turkey Breast', 'dinner', 'scraped', 'accepted', 88, 15, 4, 1, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.732744', '2026-06-18 19:33:31.963923', 2059470, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (71, 16, 'Genoa Salami', 'dinner', 'scraped', 'accepted', 222, 11, 2, 19, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.688679', '2026-06-18 19:33:31.919828', 2059464, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (38, 11, 'Spinach Feta Breakfast Wrap', 'breakfast', 'scraped', 'accepted', 328, 16, 41, 11, '6 oz wrap', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.762835', '2026-06-18 19:59:02.392092', 1997713, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (40, 11, 'Potatoes O''Brien', 'breakfast', 'scraped', 'accepted', 118, 3, 18, 4, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.852776', '2026-06-18 19:59:28.957854', 1997714, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (65, 15, 'Red Wine Vinegar', 'dinner', 'scraped', 'accepted', 11, 0, 0, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.388728', '2026-06-18 20:00:00.319598', 2059537, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (115, 10, 'Steak Fries', 'lunch', 'scraped', 'accepted', 252, 4, 46, 6, '6 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.951122', '2026-06-17 22:03:52.945947', 2145182, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (118, 11, 'Green Goddess Reuben Sandwich', 'lunch', 'scraped', 'accepted', 175, 6, 37, 10, '1 each', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:41.114789', '2026-06-17 22:03:53.097692', 2056139, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (119, 11, 'French Dip Sandwich with Au Jus', 'lunch', 'scraped', 'accepted', 267, 35, 11, 9, '7 oz sandwich', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:41.160703', '2026-06-17 22:03:53.139483', 2024574, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (113, 24, 'Spicy Carrot & Red Lentil Soup', 'lunch', 'scraped', 'accepted', 212, 8, 26, 10, '12 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.83089', '2026-06-17 22:03:52.835018', 2056140, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (168, 11, 'Asian Vegetable Blend', 'dinner', 'scraped', 'accepted', 37, 1, 6, 0, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:44.20075', '2026-06-17 22:03:55.894911', 1995615, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (169, 11, 'Crispy Garlic Tofu', 'dinner', 'scraped', 'accepted', 119, 11, 12, 3, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:44.244784', '2026-06-17 22:03:55.936416', 1995618, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (173, 11, 'Asparagus Spears', 'dinner', 'scraped', 'accepted', 25, 3, 5, 0, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:44.42476', '2026-06-17 22:03:56.101568', 1995623, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (85, 18, 'Chewy Brownies', 'lunch', 'scraped', 'accepted', 486, 6, 84, 15, '1 brownie', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.372745', '2026-06-18 19:33:27.319976', 2010798, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (382, 11, 'Turkey Sausage Link', 'lunch', 'scraped', 'accepted', 0, 0, 0, 0, '2 links', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:23.617502', '2026-06-18 19:58:38.71426', 1995522, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (84, 18, 'Vanilla Soft Serve Ice Cream', 'dinner', 'scraped', 'accepted', 514, 0, 98, 15, '5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.328828', '2026-06-18 19:33:32.461895', 2059480, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (516, 11, 'Roast Turkey with Gravy', 'dinner', 'scraped', 'accepted', 176, 36, 1, 3, '5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:31.327626', '2026-06-18 19:59:31.983693', 1995628, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (66, 15, 'Yellow Mustard', 'dinner', 'scraped', 'accepted', 0, 0, 0, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.433692', '2026-06-18 19:33:31.669347', 2059536, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (172, 11, 'Sticky Rice', 'dinner', 'scraped', 'accepted', 301, 6, 66, 0, '1 4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:44.380831', '2026-06-18 19:58:53.471617', 1995622, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (93, 21, 'Spring Mix Lettuce', 'lunch', 'scraped', 'accepted', 9, 1, 2, 0, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.807166', '2026-06-18 19:33:28.611869', 2059497, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (94, 22, 'Asian Sesame Vinegrette', 'lunch', 'scraped', 'accepted', 23, 0, 6, 0, '3.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.910776', '2026-06-18 19:33:28.682369', 2059520, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (513, 11, 'Corn on the Cob', 'dinner', 'scraped', 'accepted', 147, 5, 35, 1, '0.5 cob 5.5 ounces', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:31.189673', '2026-06-18 19:37:54.297655', 1995624, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (95, 22, 'Balsamic Vinaigrette', 'lunch', 'scraped', 'accepted', NULL, NULL, NULL, NULL, '3.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.956746', '2026-06-18 19:33:28.730704', 2059525, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (96, 22, 'Blue Cheese Dressing', 'lunch', 'scraped', 'accepted', 17, 0, 0, 0, '3.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.002987', '2026-06-18 19:33:28.77542', 2059516, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (97, 22, 'Buttermilk Ranch', 'lunch', 'scraped', 'accepted', 83, 0, 1, 9, '3.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.047149', '2026-06-18 19:33:28.821219', 2232260, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (98, 22, 'Caesar Dressing', 'lunch', 'scraped', 'accepted', 65, 0, 3, 6, '3.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.09083', '2026-06-18 19:33:28.866477', 2232261, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (99, 22, 'Honey Mustard dressing', 'lunch', 'scraped', 'accepted', 75, 0, 2, 8, '3.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.134827', '2026-06-18 19:33:28.913014', 2059517, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (100, 22, 'Olive Oil', 'lunch', 'scraped', 'accepted', 78, 0, 0, 9, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.180776', '2026-06-18 19:33:28.956025', 2059521, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (101, 22, 'Red Wine Vinegar', 'lunch', 'scraped', 'accepted', 11, 0, 0, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.226928', '2026-06-18 19:33:29.003069', 2059533, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (102, 8, 'Black Beans', 'lunch', 'scraped', 'accepted', 31, 2, 6, 0, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.298643', '2026-06-18 19:33:29.070962', 2059506, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (103, 8, 'Blue Cheese', 'lunch', 'scraped', 'accepted', 160, 10, 1, 13, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.344789', '2026-06-18 19:33:29.120805', 2059484, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (104, 8, 'Cherry Tomatoes', 'lunch', 'scraped', 'accepted', 8, 0, 2, 0, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.390736', '2026-06-18 19:33:29.164538', 2059488, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (105, 8, 'Cucumber', 'lunch', 'scraped', 'accepted', 6, 0, 1, 0, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.438727', '2026-06-18 19:33:29.208531', 2059489, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (106, 8, 'Hard Boiled Egg', 'lunch', 'scraped', 'accepted', 69, 6, 1, 5, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.482721', '2026-06-18 19:33:29.25233', 2059509, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (107, 8, 'Lemon & Herb Quinoa', 'lunch', 'scraped', 'accepted', 586, 14, 70, 29, '1 6 ounces', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.528703', '2026-06-18 19:33:29.295859', 2059507, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (108, 8, 'Olives', 'lunch', 'scraped', 'accepted', 43, 0, 3, 4, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.5746', '2026-06-18 19:33:29.343876', 2059512, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (109, 8, 'Red Onion', 'lunch', 'scraped', 'accepted', 10, 0, 2, 0, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.620953', '2026-06-18 19:33:29.38796', 2059518, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (110, 8, 'Marinated Artichokes', 'lunch', 'scraped', 'accepted', 173, 1, 5, 16, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.668823', '2026-06-18 19:33:29.432436', 2059515, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (111, 8, 'Shredded Carrots', 'lunch', 'scraped', 'accepted', 13, 0, 3, 0, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.719249', '2026-06-18 19:33:29.478026', 2059519, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (112, 8, 'Umami Bomb Tofu', 'lunch', 'scraped', 'accepted', 43, 6, 2, 2, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.764882', '2026-06-18 19:33:29.525911', 2059504, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (383, 11, 'Tater Tot Puffs', 'breakfast', 'scraped', 'accepted', 229, 3, 28, 11, '1 4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:23.675244', '2026-06-18 19:58:49.740655', 1995529, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (380, 11, 'Pork Sausage Patties', 'breakfast', 'scraped', 'accepted', 144, 8, 0, 12, '1 1.5 oz patty', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:23.523927', '2026-06-18 19:59:26.113463', 1995525, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (174, 11, 'Vegetable Spring Rolls', 'dinner', 'scraped', 'accepted', 207, 3, 38, 5, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:44.468792', '2026-06-18 19:57:10.025866', 2010804, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (453, 24, 'Chicken Tortilla Soup', 'lunch', 'scraped', 'accepted', 84, 4, 12, 2, '1 cups', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:27.829208', '2026-06-18 19:32:55.18193', 2054310, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (454, 24, 'Black Bean Soup', 'lunch', 'scraped', 'accepted', 10, 0, 1, 1, '6 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:27.873177', '2026-06-18 19:32:55.22393', 2054311, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (170, 11, 'Loco Moco', 'dinner', 'scraped', 'accepted', 834, 36, 99, 32, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:44.288723', '2026-06-18 19:59:20.292174', 2125500, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (17, 6, 'Grapes', 'lunch', 'scraped', 'accepted', 39, 0, 10, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.590795', '2026-06-18 19:33:27.671944', 2085972, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (514, 11, 'Fresh Vegetable Blend', 'dinner', 'scraped', 'accepted', 32, 2, 7, 0, '1 4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:31.23568', '2026-06-18 19:32:58.625907', 1995625, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (377, 11, 'Vegetable Frittatas', 'breakfast', 'scraped', 'accepted', 103, 8, 3, 6, '2.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:23.373291', '2026-06-18 19:57:17.045939', 1999232, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (67, 15, 'Vegan Option : Just Mayo', 'dinner', 'scraped', 'accepted', 0, 0, 0, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.486841', '2026-06-18 19:59:57.946244', 2059478, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (517, 11, 'Wild Rice Stuffing', 'dinner', 'scraped', 'accepted', 220, 7, 21, 14, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:31.373514', '2026-06-18 19:56:30.311234', 2015871, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (64, 15, 'Pesto Sauce', 'dinner', 'scraped', 'accepted', 238, 5, 3, 23, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.344797', '2026-06-18 20:00:02.99919', 2059534, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (515, 11, 'Vegetable Shepherd''s Pie', 'dinner', 'scraped', 'accepted', 131, 4, 19, 5, '1 6 ounces', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:31.279574', '2026-06-18 19:57:13.972583', 1995626, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (117, 11, 'Steamed Broccoli', 'lunch', 'scraped', 'accepted', 34, 3, 6, 0, '1 3.5 ounce', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:41.066735', '2026-06-18 19:58:57.915414', 1995561, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (171, 11, 'Shoyu Chicken', 'dinner', 'scraped', 'accepted', 384, 40, 31, 10, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:44.334829', '2026-06-18 19:59:05.403858', 2054313, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (120, 11, 'Hot Dog on a Bun', 'lunch', 'scraped', 'accepted', 137, 6, 2, 16, '1 hot dog', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:41.20468', '2026-06-18 19:59:15.155948', 1995574, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (379, 11, 'Morning Harvest Burrito', 'lunch', 'scraped', 'accepted', 132, 6, 17, 6, '1 each', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:23.47158', '2026-06-18 19:59:23.433285', 1999233, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (460, 11, 'Gooey Egg', 'lunch', 'scraped', 'accepted', NULL, NULL, NULL, NULL, '1 egg', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:28.211753', '2026-06-18 19:32:55.573931', 2125486, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (461, 11, 'E.O.S. CUCUMBERS', 'lunch', 'scraped', 'accepted', 9, 0, 2, 0, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:28.255602', '2026-06-18 19:32:55.619121', 2134803, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (464, 11, 'VEGAN SRIRACHA MAYO', 'lunch', 'scraped', 'accepted', 10, 0, 0, 1, '1 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:28.395882', '2026-06-18 19:57:23.639847', 2240051, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (462, 11, 'Jasmine Rice', 'lunch', 'scraped', 'accepted', 408, 8, 90, 1, '1 4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:28.303551', '2026-06-18 19:59:17.601775', 2194962, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (458, 11, 'Shitaki Mushrooms', 'lunch', 'scraped', 'accepted', 6, 1, 1, 0, '1 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:28.111547', '2026-06-18 19:59:35.698855', 2240049, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (511, 11, 'Country Mashed Potatoes', 'dinner', 'scraped', 'accepted', 310, 15, 51, 9, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:31.099726', '2026-06-18 19:32:58.489914', 2015866, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (512, 11, 'Cranberry Sauce', 'dinner', 'scraped', 'accepted', 143, 0, 35, 0, '0.33 cups', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:31.14565', '2026-06-18 19:32:58.537413', 2015869, 'pending');
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status) VALUES (63, 15, 'Olive Oil', 'dinner', 'scraped', 'accepted', 2977, 0, 0, 331, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.290808', '2026-06-18 19:33:31.528061', 2059530, 'pending');


--
-- Data for Name: option_groups; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--



--
-- Data for Name: options; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--



--
-- Data for Name: stations; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (1, 2, 'Breakfast Breads', 78443);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (5, 2, 'Daily Breakfast', 70474);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (7, 2, 'Heavenly Things', 70476);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (21, 2, 'Salad Bar Bases', 72273);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (22, 2, 'Salad Bar Dressings', 71106);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (8, 2, 'Salad Bar Toppings', 71101);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (9, 2, 'Spreadables Bar', 70478);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (2, 2, 'Auggies Deli', 70857);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (13, 2, 'Auggies Deli Breads', 71102);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (14, 2, 'Auggies Deli Cheeses', 71735);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (15, 2, 'Auggies Deli Condiments', 71103);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (16, 2, 'Auggies Deli Meats / Proteins', 71736);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (17, 2, 'Auggies Deli Toppings', 71105);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (18, 2, 'Desserts', 70482);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (6, 2, 'Grains for Life', 70475);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (20, 2, 'Padre Pizza and Pasta', 70481);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (10, 2, 'The Fryery', 70479);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (11, 2, 'Traditions', 70480);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (24, 2, 'Soup', 70484);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

INSERT INTO public.users (id, email, password_hash, daily_calorie_goal, created_at, updated_at, is_admin) VALUES (2, 'tmhansen16@gmail.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uRpqd9i..', 2000, '2026-06-18 18:13:26.502541', '2026-06-18 18:13:26.502541', true);


--
-- Name: daily_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.daily_schedule_id_seq', 1265, true);


--
-- Name: dining_halls_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.dining_halls_id_seq', 5, true);


--
-- Name: meal_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.meal_logs_id_seq', 1, true);


--
-- Name: menu_items_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.menu_items_master_id_seq', 1265, true);


--
-- Name: option_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.option_groups_id_seq', 1, false);


--
-- Name: options_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.options_id_seq', 1, false);


--
-- Name: stations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.stations_id_seq', 239, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- Name: daily_schedule daily_schedule_menu_item_id_date_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.daily_schedule
    ADD CONSTRAINT daily_schedule_menu_item_id_date_key UNIQUE (menu_item_id, date);


--
-- Name: daily_schedule daily_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.daily_schedule
    ADD CONSTRAINT daily_schedule_pkey PRIMARY KEY (id);


--
-- Name: dining_halls dining_halls_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.dining_halls
    ADD CONSTRAINT dining_halls_pkey PRIMARY KEY (id);


--
-- Name: meal_logs meal_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.meal_logs
    ADD CONSTRAINT meal_logs_pkey PRIMARY KEY (id);


--
-- Name: menu_items_master menu_items_master_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.menu_items_master
    ADD CONSTRAINT menu_items_master_pkey PRIMARY KEY (id);


--
-- Name: menu_items_master menu_items_master_station_id_name_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.menu_items_master
    ADD CONSTRAINT menu_items_master_station_id_name_key UNIQUE (station_id, name);


--
-- Name: menu_items_master menu_items_master_station_nutrislice_food_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.menu_items_master
    ADD CONSTRAINT menu_items_master_station_nutrislice_food_key UNIQUE (station_id, nutrislice_food_id);


--
-- Name: option_groups option_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.option_groups
    ADD CONSTRAINT option_groups_pkey PRIMARY KEY (id);


--
-- Name: options options_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.options
    ADD CONSTRAINT options_pkey PRIMARY KEY (id);


--
-- Name: stations stations_dining_hall_id_name_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_dining_hall_id_name_key UNIQUE (dining_hall_id, name);


--
-- Name: stations stations_nutrislice_station_id_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_nutrislice_station_id_key UNIQUE (nutrislice_station_id);


--
-- Name: stations stations_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_daily_schedule_date; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_daily_schedule_date ON public.daily_schedule USING btree (date);


--
-- Name: idx_meal_logs_user_date; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_meal_logs_user_date ON public.meal_logs USING btree (user_id, log_date);


--
-- Name: idx_menu_items_station; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_menu_items_station ON public.menu_items_master USING btree (station_id);


--
-- Name: daily_schedule daily_schedule_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.daily_schedule
    ADD CONSTRAINT daily_schedule_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items_master(id) ON DELETE CASCADE;


--
-- Name: meal_logs meal_logs_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.meal_logs
    ADD CONSTRAINT meal_logs_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items_master(id) ON DELETE SET NULL;


--
-- Name: meal_logs meal_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.meal_logs
    ADD CONSTRAINT meal_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: menu_items_master menu_items_master_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.menu_items_master
    ADD CONSTRAINT menu_items_master_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(id) ON DELETE CASCADE;


--
-- Name: option_groups option_groups_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.option_groups
    ADD CONSTRAINT option_groups_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items_master(id) ON DELETE CASCADE;


--
-- Name: options options_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.options
    ADD CONSTRAINT options_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.option_groups(id) ON DELETE CASCADE;


--
-- Name: stations stations_dining_hall_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_dining_hall_id_fkey FOREIGN KEY (dining_hall_id) REFERENCES public.dining_halls(id) ON DELETE CASCADE;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO neon_superuser WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON TABLES TO neon_superuser WITH GRANT OPTION;


--
-- PostgreSQL database dump complete
--

\unrestrict ezxdCGM3EWNrMdlPiJ1An1MxCWTslwgc7GhZVi1KskpOG8mjMPeiGdA2Y3qWuGr

