--
-- PostgreSQL database dump
--

\restrict izsv8sEGf2SWUpLo4vgicovc5i3TpLUEDMkwUr1E3YSBolsIviuS2n5iIyzrIbZ

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
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
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

INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (24, 6, 'Overnight Oats', 'breakfast', 'scraped', 'accepted', 1127, 39, 183, 28, '10 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.915018', '2026-06-18 17:16:22.669299', 1995539);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (49, 13, 'Multigrain Bread', 'dinner', 'scraped', 'accepted', 151, 7, 27, 2, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.594717', '2026-06-18 17:16:29.0713', 2059456);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (50, 13, 'Country Wheat Bread', 'dinner', 'scraped', 'accepted', 226, 11, 40, 3, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.642758', '2026-06-18 17:16:29.113265', 2059474);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (51, 13, 'Country White Bread', 'dinner', 'scraped', 'accepted', 38, 2, 7, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.688753', '2026-06-18 17:16:29.159229', 2059467);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (52, 14, 'American Cheese', 'dinner', 'scraped', 'accepted', 152, 8, 2, 12, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.761018', '2026-06-18 17:16:29.22542', 2059451);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (53, 14, 'Cheddar Cheese', 'dinner', 'scraped', 'accepted', 167, 11, 0, 14, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.808769', '2026-06-18 17:16:29.269239', 2059450);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (54, 14, 'Fresh Mozzarella Cheese', 'dinner', 'scraped', 'accepted', 210, 15, 3, 15, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.852829', '2026-06-18 17:16:29.313359', 2059457);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (55, 14, 'Pepper Jack Cheese', 'dinner', 'scraped', 'accepted', 202, 12, 2, 16, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.901048', '2026-06-18 17:16:29.357324', 2059461);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (56, 14, 'Provolone Cheese', 'dinner', 'scraped', 'accepted', 299, 22, 2, 23, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.946876', '2026-06-18 17:16:29.402762', 2059459);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (57, 14, 'Domestic Swiss Cheese', 'dinner', 'scraped', 'accepted', 334, 23, 1, 26, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.990697', '2026-06-18 17:16:29.447378', 2059469);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (58, 14, 'Assorted Dairy Free Cheese', 'dinner', 'scraped', 'accepted', 108, 1, 14, 14, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.03892', '2026-06-18 17:16:29.497943', 2059477);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (59, 15, 'Brown Spicy Mustard', 'dinner', 'scraped', 'accepted', 314, 20, 20, 20, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.108792', '2026-06-18 17:16:29.565561', 2059523);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (60, 15, 'Dijon Mustard', 'dinner', 'scraped', 'accepted', 52, 7, 7, 7, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.155184', '2026-06-18 17:16:29.609664', 2059531);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (61, 15, 'Honey Mustard', 'dinner', 'scraped', 'accepted', 301, 0, 9, 30, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.198725', '2026-06-18 17:16:29.653789', 2059535);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (62, 15, 'Hot Sauce', 'dinner', 'scraped', 'accepted', 6, 0, 1, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.244659', '2026-06-18 17:16:29.699569', 2059526);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (2, 2, 'House Made Hummus', 'dinner', 'scraped', 'accepted', 81, 2, 7, 5, '1 2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:53:08.453445', '2026-06-18 17:16:28.825177', 2059479);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (6, 1, 'NY Style Everything Bagel', 'breakfast', 'scraped', 'accepted', 280, 11, 57, 1, '5 oz bagel', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.032709', '2026-06-18 17:16:21.789189', 1995534);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (47, 13, 'Assorted Wraps', 'dinner', 'scraped', 'accepted', 287, 8, 47, 7, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.502999', '2026-06-18 17:16:28.985462', 2059449);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (7, 1, 'NY Style Plain Bagel', 'breakfast', 'scraped', 'accepted', 280, 11, 57, 1, '5 oz bagel', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.084823', '2026-06-18 17:16:21.835143', 1995535);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (8, 1, 'NY Style Sesame Bagel', 'breakfast', 'scraped', 'accepted', 280, 11, 57, 1, '5 oz bagel', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.12873', '2026-06-18 17:16:21.881283', 1995536);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (9, 5, 'Assorted Muffins & Loaf Cakes', 'breakfast', 'scraped', 'accepted', 191, 3, 25, 9, '1 each', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.198714', '2026-06-18 17:16:21.949224', 1995540);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (10, 5, 'Hard Boiled Eggs', 'breakfast', 'scraped', 'accepted', 54, 7, 0, 5, '1 egg', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.243524', '2026-06-18 17:16:21.995351', 1995512);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (11, 6, 'Blueberries', 'breakfast', 'scraped', 'accepted', 32, 0, 8, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.312783', '2026-06-18 17:16:22.063594', 2085966);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (12, 6, 'Cottage Cheese', 'breakfast', 'scraped', 'accepted', 111, 13, 4, 5, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.3607', '2026-06-18 17:16:22.109506', 2085967);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (13, 6, 'Cantaloupe Melon', 'breakfast', 'scraped', 'accepted', 19, 0, 5, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.40876', '2026-06-18 17:16:22.155693', 2085968);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (14, 6, 'Honeydew Melon', 'breakfast', 'scraped', 'accepted', 20, 0, 5, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.454788', '2026-06-18 17:16:22.201596', 2085969);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (15, 6, 'Pineapple', 'breakfast', 'scraped', 'accepted', 29, 0, 8, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.500942', '2026-06-18 17:16:22.249594', 2085970);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (16, 6, 'Grapefruit', 'breakfast', 'scraped', 'accepted', 29, 0, 8, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.546764', '2026-06-18 17:16:22.294497', 2085971);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (18, 6, 'Greek Yogurt', 'breakfast', 'scraped', 'accepted', 71, 6, 8, 2, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.637126', '2026-06-18 17:16:22.387703', 2085973);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (19, 6, 'Hard Boiled Egg', 'breakfast', 'scraped', 'accepted', 69, 6, 1, 5, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.68059', '2026-06-18 17:16:22.433557', 2059509);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (20, 6, 'Strawberries', 'breakfast', 'scraped', 'accepted', 27, 1, 7, 0, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.724935', '2026-06-18 17:16:22.478003', 2085975);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (21, 6, 'Strawberry Yogurt', 'breakfast', 'scraped', 'accepted', 100, 4, 19, 1, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.768742', '2026-06-18 17:16:22.531306', 2086206);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (27, 6, 'Organic Pumpkin Seed', 'breakfast', 'scraped', 'accepted', 1356, 101, 11, 100, '1 lbs', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.053079', '2026-06-18 17:16:22.803189', 1995548);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (23, 6, 'Chia Pudding', 'breakfast', 'scraped', 'accepted', 601, 18, 22, 53, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.866875', '2026-06-18 17:16:22.623307', 1995538);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (28, 6, 'Roasted Shelled Sunflower Seed', 'breakfast', 'scraped', 'accepted', 1356, 101, 11, 100, '1 lbs', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.105917', '2026-06-18 17:16:22.849152', 1995549);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (25, 6, 'Fresh Berries', 'breakfast', 'scraped', 'accepted', 30, 1, 7, 0, '1 ptn 2.3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.959034', '2026-06-18 17:16:22.713333', 1995508);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (22, 6, 'House Made Granola', 'breakfast', 'scraped', 'accepted', 105, 3, 17, 3, '1 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.823409', '2026-06-18 17:16:22.757166', 1995544);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (29, 7, 'Eggs and Omelets', 'breakfast', 'scraped', 'accepted', 137, 6, 2, 15, '7 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.189742', '2026-06-18 17:16:22.939258', 1995543);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (30, 7, 'Scrambled Eggs', 'breakfast', 'scraped', 'accepted', 177, 15, 0, 11, '1 4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.240611', '2026-06-18 17:16:22.981213', 1995516);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (31, 7, 'Scrambled Egg Whites', 'breakfast', 'scraped', 'accepted', 17, 3, 0, 0, '1 4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.291525', '2026-06-18 17:16:23.027309', 1995518);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (32, 8, 'Toppings available for Oatmeal', 'breakfast', 'scraped', 'accepted', 232, 4, 44, 6, '1 topping', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.361983', '2026-06-18 17:16:23.09527', 1995510);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (33, 9, 'Housemade Jam', 'breakfast', 'scraped', 'accepted', 32, 0, 7, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.433014', '2026-06-18 17:16:23.165179', 1995537);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (34, 9, 'Guacamole', 'breakfast', 'scraped', 'accepted', 85, 0, 8, 6, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.478884', '2026-06-18 17:16:23.209127', 1995550);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (35, 9, 'Whipped Butter', 'breakfast', 'scraped', 'accepted', 407, 1, 0, 46, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.526822', '2026-06-18 17:16:23.255169', 1995553);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (36, 9, 'Whipped Cream Cheese', 'breakfast', 'scraped', 'accepted', 162, 3, 3, 16, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.596815', '2026-06-18 17:16:23.299252', 1995554);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (39, 11, '100% Natural Rolled Oatmeal', 'breakfast', 'scraped', 'accepted', 88, 4, 15, 1, '5 oz bowl', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.806846', '2026-06-18 17:16:23.426505', 1995504);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (42, 11, 'Tofu Scramble', 'breakfast', 'scraped', 'accepted', 94, 5, 11, 5, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.944693', '2026-06-18 17:16:23.569281', 1995519);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (37, 10, 'Pancakes', 'breakfast', 'scraped', 'accepted', 89, 2, 17, 1, '2 pancakes', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.688729', '2026-06-17 22:03:48.609976', 1995524);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (38, 11, 'Spinach Feta Breakfast Wrap', 'breakfast', 'scraped', 'accepted', 328, 16, 41, 11, '6 oz wrap', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.762835', '2026-06-17 22:03:48.677528', 1997713);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (46, 2, 'Vegan Option : Falafel', 'dinner', 'scraped', 'accepted', 53, 3, 11, 1, '1 4 ounces', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.436865', '2026-06-18 17:16:28.869231', 2059476);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (40, 11, 'Potatoes O''Brien', 'breakfast', 'scraped', 'accepted', 118, 3, 18, 4, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.852776', '2026-06-17 22:03:48.75754', 1997714);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (41, 11, 'Taylor Ham', 'breakfast', 'scraped', 'accepted', 166, 10, 0, 14, '2 slices', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.900728', '2026-06-17 22:03:48.797958', 1997715);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (48, 13, 'Hoagie Roll', 'dinner', 'scraped', 'accepted', 158, 6, 28, 2, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:37.546814', '2026-06-18 17:16:29.029256', 2059460);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (43, 11, 'Turkey Sausage Patties', 'breakfast', 'scraped', 'accepted', 89, 6, 1, 7, '1.5 ounce patty', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:35.988655', '2026-06-17 22:03:48.897636', 1995527);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (68, 16, 'Grilled Chicken', 'dinner', 'scraped', 'accepted', 88, 17, 2, 2, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.554932', '2026-06-18 17:16:30.009575', 2059455);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (69, 16, 'Domestic Ham', 'dinner', 'scraped', 'accepted', 78, 13, 2, 3, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.598846', '2026-06-18 17:16:30.055395', 2059462);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (70, 16, 'Roast Beef', 'dinner', 'scraped', 'accepted', 117, 18, 0, 5, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.644711', '2026-06-18 17:16:30.101169', 2059471);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (71, 16, 'Genoa Salami', 'dinner', 'scraped', 'accepted', 222, 11, 2, 19, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.688679', '2026-06-18 17:16:30.155342', 2059464);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (72, 16, 'Turkey Breast', 'dinner', 'scraped', 'accepted', 88, 15, 4, 1, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.732744', '2026-06-18 17:16:30.199218', 2059470);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (73, 16, 'Roasted Vegetables', 'dinner', 'scraped', 'accepted', 74, 1, 7, 5, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.778696', '2026-06-18 17:16:30.243211', 2059473);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (74, 17, 'Bacon', 'dinner', 'scraped', 'accepted', 51, 5, 0, 6, '0.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.844745', '2026-06-18 17:16:30.311205', 2059454);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (75, 17, 'Green Leaf Lettuce', 'dinner', 'scraped', 'accepted', 2, 0, 0, 0, '0.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.888892', '2026-06-18 17:16:30.363183', 2059458);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (76, 17, 'Hot Peppers', 'dinner', 'scraped', 'accepted', 3, 0, 1, 0, '0.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.934882', '2026-06-18 17:16:30.407182', 2059453);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (78, 17, 'Sliced Red Onion', 'dinner', 'scraped', 'accepted', 5, 0, 1, 0, '0.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.0228', '2026-06-18 17:16:30.501262', 2059465);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (79, 17, 'Sweet Peppers', 'dinner', 'scraped', 'accepted', 3, 0, 1, 0, '0.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.068799', '2026-06-18 17:16:30.547141', 2059472);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (80, 17, 'Sliced Tomato', 'dinner', 'scraped', 'accepted', 7, 0, 1, 0, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.112798', '2026-06-18 17:16:30.595222', 2059463);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (83, 18, 'Chocolate Soft Serve Ice Cream', 'dinner', 'scraped', 'accepted', 514, 0, 98, 15, '5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.282773', '2026-06-18 17:16:30.661358', 2059481);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (81, 18, 'Chocolate Chip Cookie (Veg)', 'lunch', 'scraped', 'accepted', 236, 2, 35, 11, '2 ozchoc chip cook', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.190747', '2026-06-18 17:16:26.249554', 2010794);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (86, 6, 'Grilled Pita', 'dinner', 'scraped', 'accepted', 248, 7, 35, 10, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.440727', '2026-06-18 17:16:30.779252', 2040798);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (82, 18, 'Fudge Brownie Cookie', 'lunch', 'scraped', 'accepted', 177, 1, 26, 8, '1 cookie', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.234718', '2026-06-18 17:16:26.293225', 2207784);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (87, 6, 'House Made Red Pepper Hummus', 'dinner', 'scraped', 'accepted', 111, 3, 10, 7, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.484817', '2026-06-18 17:16:30.823213', 2059490);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (88, 6, 'House Made Hummus', 'dinner', 'scraped', 'accepted', 122, 4, 11, 8, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.529232', '2026-06-18 17:16:30.86926', 2059493);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (89, 20, 'Neapolitan Cheese Flatbread', 'dinner', 'scraped', 'accepted', 393, 16, 47, 14, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.597098', '2026-06-18 17:16:30.935693', 2010810);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (90, 20, 'Neapolitan Pepperoni Flatbread', 'dinner', 'scraped', 'accepted', 469, 19, 48, 21, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.644783', '2026-06-18 17:16:30.979299', 2010811);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (91, 20, 'Vegetable Flatbread Pizza', 'dinner', 'scraped', 'accepted', 613, 24, 75, 22, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.690749', '2026-06-18 17:16:31.029545', 2010812);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (92, 21, 'Little Leaf Romaine Lettuce', 'lunch', 'scraped', 'accepted', 13, 1, 2, 0, '1 salad', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.761227', '2026-06-18 17:16:26.813274', 2059513);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (65, 15, 'Red Wine Vinegar', 'dinner', 'scraped', 'accepted', 11, 0, 0, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.388728', '2026-06-18 17:16:29.841825', 2059537);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (93, 21, 'Spring Mix Lettuce', 'lunch', 'scraped', 'accepted', 9, 1, 2, 0, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.807166', '2026-06-18 17:16:26.8612', 2059497);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (67, 15, 'Vegan Option : Just Mayo', 'dinner', 'scraped', 'accepted', 0, 0, 0, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.486841', '2026-06-18 17:16:29.933537', 2059478);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (84, 18, 'Vanilla Soft Serve Ice Cream', 'dinner', 'scraped', 'accepted', 514, 0, 98, 15, '5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.328828', '2026-06-18 17:16:30.705327', 2059480);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (85, 18, 'Chewy Brownies', 'lunch', 'scraped', 'accepted', 486, 6, 84, 15, '1 brownie', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.372745', '2026-06-18 17:16:26.42932', 2010798);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (94, 22, 'Asian Sesame Vinegrette', 'lunch', 'scraped', 'accepted', 23, 0, 6, 0, '3.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.910776', '2026-06-18 17:16:26.927149', 2059520);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (95, 22, 'Balsamic Vinaigrette', 'lunch', 'scraped', 'accepted', NULL, NULL, NULL, NULL, '3.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:39.956746', '2026-06-18 17:16:26.971179', 2059525);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (96, 22, 'Blue Cheese Dressing', 'lunch', 'scraped', 'accepted', 17, 0, 0, 0, '3.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.002987', '2026-06-18 17:16:27.017289', 2059516);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (97, 22, 'Buttermilk Ranch', 'lunch', 'scraped', 'accepted', 83, 0, 1, 9, '3.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.047149', '2026-06-18 17:16:27.06124', 2232260);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (98, 22, 'Caesar Dressing', 'lunch', 'scraped', 'accepted', 65, 0, 3, 6, '3.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.09083', '2026-06-18 17:16:27.107287', 2232261);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (99, 22, 'Honey Mustard dressing', 'lunch', 'scraped', 'accepted', 75, 0, 2, 8, '3.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.134827', '2026-06-18 17:16:27.151275', 2059517);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (100, 22, 'Olive Oil', 'lunch', 'scraped', 'accepted', 78, 0, 0, 9, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.180776', '2026-06-18 17:16:27.195278', 2059521);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (101, 22, 'Red Wine Vinegar', 'lunch', 'scraped', 'accepted', 11, 0, 0, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.226928', '2026-06-18 17:16:27.239215', 2059533);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (102, 8, 'Black Beans', 'lunch', 'scraped', 'accepted', 31, 2, 6, 0, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.298643', '2026-06-18 17:16:27.305493', 2059506);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (103, 8, 'Blue Cheese', 'lunch', 'scraped', 'accepted', 160, 10, 1, 13, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.344789', '2026-06-18 17:16:27.349238', 2059484);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (104, 8, 'Cherry Tomatoes', 'lunch', 'scraped', 'accepted', 8, 0, 2, 0, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.390736', '2026-06-18 17:16:27.393322', 2059488);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (105, 8, 'Cucumber', 'lunch', 'scraped', 'accepted', 6, 0, 1, 0, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.438727', '2026-06-18 17:16:27.441271', 2059489);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (106, 8, 'Hard Boiled Egg', 'lunch', 'scraped', 'accepted', 69, 6, 1, 5, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.482721', '2026-06-18 17:16:27.486112', 2059509);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (107, 8, 'Lemon & Herb Quinoa', 'lunch', 'scraped', 'accepted', 586, 14, 70, 29, '1 6 ounces', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.528703', '2026-06-18 17:16:27.531238', 2059507);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (108, 8, 'Olives', 'lunch', 'scraped', 'accepted', 43, 0, 3, 4, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.5746', '2026-06-18 17:16:27.575255', 2059512);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (109, 8, 'Red Onion', 'lunch', 'scraped', 'accepted', 10, 0, 2, 0, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.620953', '2026-06-18 17:16:27.619329', 2059518);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (110, 8, 'Marinated Artichokes', 'lunch', 'scraped', 'accepted', 173, 1, 5, 16, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.668823', '2026-06-18 17:16:27.665166', 2059515);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (111, 8, 'Shredded Carrots', 'lunch', 'scraped', 'accepted', 13, 0, 3, 0, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.719249', '2026-06-18 17:16:27.713297', 2059519);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (112, 8, 'Umami Bomb Tofu', 'lunch', 'scraped', 'accepted', 43, 6, 2, 2, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.764882', '2026-06-18 17:16:27.76317', 2059504);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (116, 10, 'Grilled Cheese Sandwich', 'lunch', 'scraped', 'accepted', 424, 22, 32, 22, '1 sandwich 4 ounces', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.998863', '2026-06-18 17:16:27.99525', 1995569);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (114, 24, 'Chicken Noodle Soup', 'lunch', 'scraped', 'accepted', 59, 4, 8, 1, '8 oz bowl', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.878971', '2026-06-17 22:03:52.875927', 1995580);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (115, 10, 'Steak Fries', 'lunch', 'scraped', 'accepted', 252, 4, 46, 6, '6 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.951122', '2026-06-17 22:03:52.945947', 2145182);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (120, 11, 'Hot Dog on a Bun', 'lunch', 'scraped', 'accepted', 137, 6, 2, 16, '1 hot dog', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:41.20468', '2026-06-18 17:16:28.347846', 1995574);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (117, 11, 'Steamed Broccoli', 'lunch', 'scraped', 'accepted', 34, 3, 6, 0, '1 3.5 ounce', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:41.066735', '2026-06-17 22:03:53.055544', 1995561);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (118, 11, 'Green Goddess Reuben Sandwich', 'lunch', 'scraped', 'accepted', 175, 6, 37, 10, '1 each', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:41.114789', '2026-06-17 22:03:53.097692', 2056139);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (119, 11, 'French Dip Sandwich with Au Jus', 'lunch', 'scraped', 'accepted', 267, 35, 11, 9, '7 oz sandwich', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:41.160703', '2026-06-17 22:03:53.139483', 2024574);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (64, 15, 'Pesto Sauce', 'dinner', 'scraped', 'accepted', 238, 5, 3, 23, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.344797', '2026-06-18 17:16:29.796458', 2059534);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (66, 15, 'Yellow Mustard', 'dinner', 'scraped', 'accepted', 0, 0, 0, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.433692', '2026-06-18 17:16:29.889482', 2059536);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (513, 11, 'Corn on the Cob', 'dinner', 'scraped', 'accepted', 147, 5, 35, 1, '0.5 cob 5.5 ounces', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:31.189673', '2026-06-18 17:16:31.189673', 1995624);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (514, 11, 'Fresh Vegetable Blend', 'dinner', 'scraped', 'accepted', 32, 2, 7, 0, '1 4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:31.23568', '2026-06-18 17:16:31.23568', 1995625);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (515, 11, 'Vegetable Shepherd''s Pie', 'dinner', 'scraped', 'accepted', 131, 4, 19, 5, '1 6 ounces', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:31.279574', '2026-06-18 17:16:31.279574', 1995626);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (113, 24, 'Spicy Carrot & Red Lentil Soup', 'lunch', 'scraped', 'accepted', 212, 8, 26, 10, '12 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:40.83089', '2026-06-17 22:03:52.835018', 2056140);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (516, 11, 'Roast Turkey with Gravy', 'dinner', 'scraped', 'accepted', 176, 36, 1, 3, '5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:31.327626', '2026-06-18 17:16:31.327626', 1995628);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (517, 11, 'Wild Rice Stuffing', 'dinner', 'scraped', 'accepted', 220, 7, 21, 14, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:31.373514', '2026-06-18 17:16:31.373514', 2015871);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (168, 11, 'Asian Vegetable Blend', 'dinner', 'scraped', 'accepted', 37, 1, 6, 0, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:44.20075', '2026-06-17 22:03:55.894911', 1995615);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (169, 11, 'Crispy Garlic Tofu', 'dinner', 'scraped', 'accepted', 119, 11, 12, 3, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:44.244784', '2026-06-17 22:03:55.936416', 1995618);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (170, 11, 'Loco Moco', 'dinner', 'scraped', 'accepted', 834, 36, 99, 32, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:44.288723', '2026-06-17 22:03:55.979618', 2125500);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (171, 11, 'Shoyu Chicken', 'dinner', 'scraped', 'accepted', 384, 40, 31, 10, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:44.334829', '2026-06-17 22:03:56.019707', 2054313);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (172, 11, 'Sticky Rice', 'dinner', 'scraped', 'accepted', 301, 6, 66, 0, '1 4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:44.380831', '2026-06-17 22:03:56.061477', 1995622);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (173, 11, 'Asparagus Spears', 'dinner', 'scraped', 'accepted', 25, 3, 5, 0, '4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:44.42476', '2026-06-17 22:03:56.101568', 1995623);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (174, 11, 'Vegetable Spring Rolls', 'dinner', 'scraped', 'accepted', 207, 3, 38, 5, '3 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:44.468792', '2026-06-17 22:03:56.144053', 2010804);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (5, 1, 'NY Style Cinnamon Rasin Bagel', 'breakfast', 'scraped', 'accepted', 280, 11, 57, 1, '5 oz bagel', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:33.987194', '2026-06-18 17:16:21.693206', 1995533);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (17, 6, 'Grapes', 'breakfast', 'scraped', 'accepted', 39, 0, 10, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:34.590795', '2026-06-18 17:16:22.340416', 2085972);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (377, 11, 'Vegetable Frittatas', 'breakfast', 'scraped', 'accepted', 103, 8, 3, 6, '2.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:23.373291', '2026-06-18 17:16:23.373291', 1999232);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (379, 11, 'Morning Harvest Burrito', 'breakfast', 'scraped', 'accepted', 132, 6, 17, 6, '1 each', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:23.47158', '2026-06-18 17:16:23.47158', 1999233);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (380, 11, 'Pork Sausage Patties', 'breakfast', 'scraped', 'accepted', 144, 8, 0, 12, '1 1.5 oz patty', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:23.523927', '2026-06-18 17:16:23.523927', 1995525);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (382, 11, 'Turkey Sausage Link', 'breakfast', 'scraped', 'accepted', 0, 0, 0, 0, '2 links', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:23.617502', '2026-06-18 17:16:23.617502', 1995522);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (383, 11, 'Tater Tot Puffs', 'breakfast', 'scraped', 'accepted', 229, 3, 28, 11, '1 4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:23.675244', '2026-06-18 17:16:23.675244', 1995529);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (453, 24, 'Chicken Tortilla Soup', 'lunch', 'scraped', 'accepted', 84, 4, 12, 2, '1 cups', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:27.829208', '2026-06-18 17:16:27.829208', 2054310);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (454, 24, 'Black Bean Soup', 'lunch', 'scraped', 'accepted', 10, 0, 1, 1, '6 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:27.873177', '2026-06-18 17:16:27.873177', 2054311);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (455, 10, 'Cheese burger', 'lunch', 'scraped', 'accepted', 389, 25, 1, 31, '1 burger', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:27.943764', '2026-06-18 17:16:27.943764', 1995603);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (457, 11, 'Bulgogi Beef', 'lunch', 'scraped', 'accepted', 101, 4, 11, 5, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:28.065557', '2026-06-18 17:16:28.065557', 2240048);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (458, 11, 'Shitaki Mushrooms', 'lunch', 'scraped', 'accepted', 6, 1, 1, 0, '1 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:28.111547', '2026-06-18 17:16:28.111547', 2240049);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (459, 11, 'Carrots', 'lunch', 'scraped', 'accepted', 10, 0, 2, 0, '1 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:28.167589', '2026-06-18 17:16:28.167589', 2240050);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (460, 11, 'Gooey Egg', 'lunch', 'scraped', 'accepted', NULL, NULL, NULL, NULL, '1 egg', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:28.211753', '2026-06-18 17:16:28.211753', 2125486);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (461, 11, 'E.O.S. CUCUMBERS', 'lunch', 'scraped', 'accepted', 9, 0, 2, 0, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:28.255602', '2026-06-18 17:16:28.255602', 2134803);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (462, 11, 'Jasmine Rice', 'lunch', 'scraped', 'accepted', 408, 8, 90, 1, '1 4 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:28.303551', '2026-06-18 17:16:28.303551', 2194962);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (464, 11, 'VEGAN SRIRACHA MAYO', 'lunch', 'scraped', 'accepted', 10, 0, 0, 1, '1 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:28.395882', '2026-06-18 17:16:28.395882', 2240051);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (1, 2, 'Chickpea Salad', 'dinner', 'scraped', 'accepted', 255, 6, 11, 19, '1 sandwich', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:53:08.370785', '2026-06-18 17:16:28.781235', 2059475);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (124, 13, '100% Whole Grain Bread', 'dinner', 'scraped', 'accepted', 9, 0, 2, 0, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:41.982739', '2026-06-18 17:16:28.935274', 2059542);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (63, 15, 'Olive Oil', 'dinner', 'scraped', 'accepted', 2977, 0, 0, 331, '2 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.290808', '2026-06-18 17:16:29.746108', 2059530);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (77, 17, 'Dill Pickles', 'dinner', 'scraped', 'accepted', 5, 0, 1, 0, '1.5 oz', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-17 21:54:38.978688', '2026-06-18 17:16:30.455345', 2059466);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (511, 11, 'Country Mashed Potatoes', 'dinner', 'scraped', 'accepted', 310, 15, 51, 9, '1 serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:31.099726', '2026-06-18 17:16:31.099726', 2015866);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id) VALUES (512, 11, 'Cranberry Sauce', 'dinner', 'scraped', 'accepted', 143, 0, 35, 0, '0.33 cups', NULL, NULL, NULL, NULL, NULL, false, true, '2026-06-18 17:16:31.14565', '2026-06-18 17:16:31.14565', 2015869);


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
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (9, 2, 'Spreadables Bar', 70478);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (21, 2, 'Salad Bar Bases', 72273);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (22, 2, 'Salad Bar Dressings', 71106);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (8, 2, 'Salad Bar Toppings', 71101);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (24, 2, 'Soup', 70484);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (10, 2, 'The Fryery', 70479);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (2, 2, 'Auggies Deli', 70857);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (13, 2, 'Auggies Deli Breads', 71102);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (14, 2, 'Auggies Deli Cheeses', 71735);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (15, 2, 'Auggies Deli Condiments', 71103);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (16, 2, 'Auggies Deli Meats / Proteins', 71736);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (17, 2, 'Auggies Deli Toppings', 71105);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (18, 2, 'Desserts', 70482);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (6, 2, 'Grains for Life', 70475);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (20, 2, 'Padre Pizza and Pasta', 70481);
INSERT INTO public.stations (id, dining_hall_id, name, nutrislice_station_id) VALUES (11, 2, 'Traditions', 70480);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

INSERT INTO public.users (id, email, password_hash, daily_calorie_goal, created_at, updated_at) VALUES (1, 'tmhansen16@gmail.com', '$2b$10$FdCiVAS.c7vneS1j9Sj0OemzDkv2PffzFau7rpNT9kISH8u89Cp66', 2500, '2026-06-17 18:20:40.840872', '2026-06-17 18:20:40.840872');


--
-- Name: daily_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.daily_schedule_id_seq', 517, true);


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

SELECT pg_catalog.setval('public.menu_items_master_id_seq', 517, true);


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

SELECT pg_catalog.setval('public.stations_id_seq', 101, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


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

\unrestrict izsv8sEGf2SWUpLo4vgicovc5i3TpLUEDMkwUr1E3YSBolsIviuS2n5iIyzrIbZ

