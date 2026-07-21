--
-- PostgreSQL database dump
--

\restrict YTKfnPefDwWtTWvaAKssHvOMlHyc2Y5RL8esHnwYe1ImPBF0NS8JULwxCTxahBn

-- Dumped from database version 18.4 (709c4c3)
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
    scraped_ingredients text,
    is_assorted boolean DEFAULT false,
    parent_item_id integer,
    CONSTRAINT menu_items_master_admin_review_status_check CHECK (((admin_review_status)::text = ANY (ARRAY['pending'::text, 'reviewed'::text, 'overridden'::text, 'needs_count'::text]))),
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
    name character varying(255) NOT NULL
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

INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216716, 216712, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216717, 216713, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216718, 216714, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216719, 216715, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216720, 216716, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216721, 216717, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216722, 216718, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216723, 216719, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216724, 216720, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216725, 216721, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216726, 216722, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216727, 216723, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216728, 216724, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216729, 216725, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216730, 216726, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216731, 216727, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216732, 216728, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216739, 216735, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216740, 216736, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216741, 216737, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216742, 216738, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216743, 216739, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216744, 216740, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216745, 216741, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216746, 216742, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216747, 216743, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216748, 216744, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216749, 216745, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216750, 216746, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216751, 216747, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216752, 216748, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216753, 216749, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216754, 216750, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216755, 216751, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216756, 216752, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216757, 216753, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216758, 216754, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216759, 216755, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216760, 216756, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216761, 216757, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216762, 216758, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216763, 216759, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216764, 216760, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216765, 216761, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216766, 216762, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216767, 216763, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216768, 216764, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216769, 216765, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216770, 216766, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216771, 216767, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216772, 216768, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216773, 216769, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216775, 216771, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216783, 216688, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216784, 216689, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216785, 216690, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216786, 216691, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216787, 216693, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216788, 216695, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216789, 216696, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216790, 216697, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216791, 216682, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216792, 216788, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216793, 216789, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216794, 216687, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216795, 216791, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216796, 216792, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216797, 216692, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216798, 216694, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216799, 216698, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216800, 216699, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216801, 216700, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216802, 216701, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216803, 216799, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216804, 216702, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216805, 216703, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216806, 216704, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216807, 216705, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216808, 216707, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216809, 216708, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216810, 216709, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216811, 216710, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216812, 216711, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216813, 216712, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216814, 216713, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216815, 216706, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216816, 216737, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216817, 216735, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216818, 216736, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216819, 216815, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216820, 216816, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216827, 216823, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216828, 216824, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216829, 216825, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216830, 216826, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216831, 216827, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216832, 216828, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216838, 216834, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216841, 216837, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216842, 216726, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216843, 216727, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216844, 216728, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216845, 216717, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216846, 216738, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216847, 216739, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216848, 216725, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216849, 216747, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216850, 216755, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216851, 216763, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216852, 216764, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216853, 216740, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216854, 216741, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216855, 216742, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216856, 216743, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216857, 216744, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216858, 216745, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216859, 216746, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216860, 216748, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216861, 216749, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216862, 216750, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216863, 216751, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216864, 216752, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216865, 216753, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216866, 216754, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216867, 216756, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216868, 216757, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216869, 216758, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216870, 216759, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216871, 216760, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216872, 216761, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216873, 216762, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216874, 216870, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216875, 216871, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216876, 216872, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216877, 216873, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216878, 216874, '2026-07-18');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216993, 216989, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216994, 216990, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216686, 216682, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216687, 216683, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216688, 216684, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216689, 216685, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216690, 216686, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216691, 216687, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216692, 216688, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216693, 216689, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216694, 216690, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216695, 216691, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216696, 216692, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216697, 216693, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216698, 216694, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216699, 216695, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216700, 216696, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216701, 216697, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216702, 216698, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216703, 216699, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216704, 216700, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216705, 216701, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216706, 216702, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216707, 216703, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216708, 216704, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216709, 216705, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216710, 216706, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216711, 216707, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216712, 216708, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216713, 216709, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216714, 216710, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216715, 216711, '2026-07-17');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216995, 216991, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216996, 216791, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216997, 216993, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216998, 216687, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (216999, 216698, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217000, 216688, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217001, 216689, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217002, 216690, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217003, 216691, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217004, 216692, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217005, 216693, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217006, 216694, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217007, 216695, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217008, 216696, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217009, 216697, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217010, 216699, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217011, 216700, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217012, 216701, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217013, 216799, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217014, 216702, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217015, 216703, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217016, 216704, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217017, 216705, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217018, 216706, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217019, 216707, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217020, 216708, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217021, 216709, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217022, 216710, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217023, 216711, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217024, 216712, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217025, 216713, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217028, 216721, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217031, 217027, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217032, 216718, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217041, 217037, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217042, 217038, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217048, 216834, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217051, 216837, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217052, 216717, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217053, 216726, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217054, 216727, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217055, 216728, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217056, 217052, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217057, 216740, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217058, 216725, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217059, 216741, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217060, 216742, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217061, 216743, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217062, 216744, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217063, 216745, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217064, 216746, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217065, 216747, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217066, 216748, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217067, 216749, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217068, 216750, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217069, 216735, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217070, 216751, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217071, 216752, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217072, 216753, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217073, 216754, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217074, 217070, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217075, 216755, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217076, 216756, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217077, 216757, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217078, 216758, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217079, 216759, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217080, 216760, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217081, 216761, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217082, 216762, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217083, 216763, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217084, 216738, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217085, 216764, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217086, 216739, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217087, 217083, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217088, 217084, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217089, 217085, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217090, 216771, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217091, 217087, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217092, 217088, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217093, 217089, '2026-07-19');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217102, 216688, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217103, 216689, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217104, 216690, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217105, 216691, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217106, 216693, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217107, 216695, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217108, 216696, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217109, 216697, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217110, 217106, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217111, 217107, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217112, 217108, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217113, 216792, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217114, 216682, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217115, 216685, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217116, 216687, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217117, 216692, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217118, 216694, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217119, 216698, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217120, 216699, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217121, 216700, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217122, 216701, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217123, 216799, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217124, 216703, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217125, 216834, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217126, 216704, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217127, 216705, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217128, 216707, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217129, 216708, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217130, 216709, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217131, 216710, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217132, 216711, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217133, 216712, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217134, 216713, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217135, 216706, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217136, 217132, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217137, 217133, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217138, 217134, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217139, 216720, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217140, 217136, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217141, 217137, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217142, 217138, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217143, 216721, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217144, 217140, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217145, 216726, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217146, 216727, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217147, 216728, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217154, 216735, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217155, 217070, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217156, 217152, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217157, 216717, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217158, 216738, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217159, 216739, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217160, 216725, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217161, 216747, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217162, 216755, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217163, 216763, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217164, 216764, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217165, 216740, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217166, 216741, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217167, 216742, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217168, 216743, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217169, 216744, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217170, 216745, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217171, 216746, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217172, 216748, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217173, 216749, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217174, 216750, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217175, 216751, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217176, 216752, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217177, 216753, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217178, 216754, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217179, 216756, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217180, 216757, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217181, 216758, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217182, 216759, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217183, 216760, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217184, 216761, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217185, 216762, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217186, 217182, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217187, 217183, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217188, 217184, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217189, 217185, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217190, 216769, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217193, 217189, '2026-07-20');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217200, 217196, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217201, 216686, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217202, 216791, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217203, 217199, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217204, 216687, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217205, 216698, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217206, 216688, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217207, 216689, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217208, 216690, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217209, 216691, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217210, 216692, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217211, 216693, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217212, 216694, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217213, 216695, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217214, 216696, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217215, 216697, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217216, 216699, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217217, 216700, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217218, 216701, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217219, 216799, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217220, 216702, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217221, 216703, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217222, 216704, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217223, 216705, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217224, 216706, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217225, 216707, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217226, 216708, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217227, 216709, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217228, 216710, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217229, 216711, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217230, 216712, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217231, 216713, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217232, 217228, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217233, 217229, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217234, 217230, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217235, 217231, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217236, 216718, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217237, 217233, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217238, 216725, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217239, 216726, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217240, 217236, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217241, 216727, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217245, 216728, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217250, 217246, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217251, 216735, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217252, 216736, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217253, 216721, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217254, 216737, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217255, 216717, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217256, 216738, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217257, 216739, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217258, 216740, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217259, 216741, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217260, 216742, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217261, 216743, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217262, 216744, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217263, 216745, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217264, 216746, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217265, 216748, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217266, 216749, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217267, 216750, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217268, 216747, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217269, 216751, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217270, 216752, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217271, 216753, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217272, 216754, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217273, 216756, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217274, 216757, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217275, 216758, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217276, 216759, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217277, 216760, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217278, 216761, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217279, 216762, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217280, 216755, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217281, 216763, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217282, 216764, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217283, 216872, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217284, 217280, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217285, 217281, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217287, 217283, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217289, 217285, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217291, 217287, '2026-07-21');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217298, 216688, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217299, 216689, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217300, 216690, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217301, 216691, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217302, 217298, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217303, 217299, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217304, 216682, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217305, 216993, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217306, 216687, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217307, 216698, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217308, 216692, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217309, 216693, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217310, 216694, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217311, 216695, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217312, 216696, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217313, 216697, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217314, 216699, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217315, 216700, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217316, 216701, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217317, 216799, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217318, 216702, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217319, 216703, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217320, 216704, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217321, 216705, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217322, 216706, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217323, 216707, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217324, 216708, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217325, 216709, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217326, 216710, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217327, 216711, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217328, 216712, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217329, 216713, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217330, 217326, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217331, 217327, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217332, 217328, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217333, 217329, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217334, 216718, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217335, 217331, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217336, 217332, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217337, 216726, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217338, 217334, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217339, 216721, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217340, 216725, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217341, 216727, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217342, 216728, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217350, 216717, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217351, 216735, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217352, 217070, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217353, 217152, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217354, 216738, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217355, 216739, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217356, 216740, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217357, 216741, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217358, 216742, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217359, 216743, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217360, 216744, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217361, 216745, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217362, 216746, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217363, 216748, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217364, 216749, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217365, 216750, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217366, 216751, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217367, 216747, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217368, 216752, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217369, 216753, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217370, 216754, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217371, 216756, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217372, 216757, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217373, 216758, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217374, 216759, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217375, 216760, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217376, 216761, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217377, 216762, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217378, 216755, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217379, 216763, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217380, 216764, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217381, 217377, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217382, 217378, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217383, 217379, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217386, 217382, '2026-07-22');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217394, 216688, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217395, 216689, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217396, 216690, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217397, 216691, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217398, 216693, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217399, 216695, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217400, 216696, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217401, 216697, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217402, 216686, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217403, 217399, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217404, 217400, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217405, 216991, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217406, 216687, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217407, 216698, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217408, 216699, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217409, 216692, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217410, 216694, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217411, 216700, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217412, 216701, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217413, 216799, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217414, 216702, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217415, 216703, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217416, 216834, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217417, 216704, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217418, 216705, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217419, 216706, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217420, 216707, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217421, 216708, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217422, 216709, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217423, 216710, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217424, 216711, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217425, 216712, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217426, 216713, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217427, 217423, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217428, 217424, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217429, 216726, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217430, 216727, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217433, 216728, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217438, 217434, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217439, 217435, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217440, 217436, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217441, 217437, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217442, 216717, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217443, 217439, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217444, 216735, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217445, 217441, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217446, 217442, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217447, 217443, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217448, 217444, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217449, 217445, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217450, 216736, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217451, 217447, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217452, 217448, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217453, 216721, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217454, 217450, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217455, 216722, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217456, 217452, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217457, 216725, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217458, 216747, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217459, 216763, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217460, 216740, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217461, 216741, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217462, 216742, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217463, 216743, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217464, 216744, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217465, 216745, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217466, 216746, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217467, 216748, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217468, 216749, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217469, 216750, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217470, 216751, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217471, 216752, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217472, 216753, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217473, 216754, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217474, 216756, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217475, 216757, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217476, 216758, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217477, 216737, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217478, 216759, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217479, 216760, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217480, 216761, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217481, 216762, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217482, 216755, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217483, 216738, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217484, 216764, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217485, 216739, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217486, 217482, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217487, 216872, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217488, 217484, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217489, 217485, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217490, 217486, '2026-07-23');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217499, 216683, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217500, 217496, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217501, 216682, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217502, 216685, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217503, 216993, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217504, 216687, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217505, 216698, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217506, 216688, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217507, 216689, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217508, 216690, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217509, 216691, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217510, 216692, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217511, 216693, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217512, 216694, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217513, 216695, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217514, 216696, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217515, 216697, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217516, 216699, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217517, 216700, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217518, 216701, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217519, 216799, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217520, 216702, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217521, 216703, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217522, 216704, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217523, 216705, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217524, 216706, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217525, 216707, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217526, 216708, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217527, 216709, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217528, 216710, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217529, 217525, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217530, 216711, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217531, 216712, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217532, 216713, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217533, 216769, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217534, 217530, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217535, 216715, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217536, 217532, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217537, 217533, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217538, 216726, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217539, 216718, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217540, 216721, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217541, 216722, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217542, 216723, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217543, 217539, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217544, 216727, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217552, 216728, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217553, 217052, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217554, 216717, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217555, 216735, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217556, 217070, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217557, 216738, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217558, 216739, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217559, 216740, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217560, 216741, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217561, 216742, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217562, 216725, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217563, 216743, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217564, 216744, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217565, 216745, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217566, 216746, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217567, 216748, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217568, 216749, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217569, 216750, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217570, 216751, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217571, 216752, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217572, 216753, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217573, 216754, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217574, 216747, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217575, 216756, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217576, 216757, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217577, 216758, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217578, 216759, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217579, 216760, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217580, 216761, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217581, 216762, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217582, 216755, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217583, 216763, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217584, 216764, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217585, 217581, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217586, 217582, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217587, 216816, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217590, 217328, '2026-07-24');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217597, 216682, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217598, 216788, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217599, 216789, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217600, 216791, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217601, 216686, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217602, 216792, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217603, 216687, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217604, 216688, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217605, 216689, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217606, 216690, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217607, 216691, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217608, 216692, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217609, 216693, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217610, 216694, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217611, 216695, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217612, 216696, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217613, 216697, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217614, 216698, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217615, 216699, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217616, 216700, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217617, 216701, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217618, 216799, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217619, 216702, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217620, 216703, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217621, 216704, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217622, 216705, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217623, 216706, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217624, 216707, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217625, 216708, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217626, 216709, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217627, 216710, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217628, 216711, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217629, 216712, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217630, 216713, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217640, 217636, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217641, 217444, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217642, 216718, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217647, 217643, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217648, 216815, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217651, 217647, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217659, 216834, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217662, 216837, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217663, 216726, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217664, 216727, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217665, 216728, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217666, 216725, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217667, 216740, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217668, 216741, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217669, 216742, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217670, 216743, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217671, 216717, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217672, 216744, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217673, 216745, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217674, 216735, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217675, 216747, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217676, 216736, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217677, 216737, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217678, 216755, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217679, 216763, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217680, 216738, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217681, 216764, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217682, 216739, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217683, 216746, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217684, 216748, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217685, 216749, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217686, 216750, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217687, 216751, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217688, 216752, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217689, 216753, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217690, 216754, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217691, 216756, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217692, 216757, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217693, 216758, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217694, 216759, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217695, 216760, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217696, 216761, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217697, 216762, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217698, 217694, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217699, 217695, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217700, 217696, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217701, 217697, '2026-07-25');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217711, 216989, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217712, 216991, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217713, 216990, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217714, 216791, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217715, 216687, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217716, 216698, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217717, 216699, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217718, 216700, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217719, 216688, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217720, 216689, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217721, 216690, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217722, 216691, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217723, 216701, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217724, 216799, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217725, 216702, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217726, 216703, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217727, 216713, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217728, 216711, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217729, 216710, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217730, 216709, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217731, 216707, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217732, 216708, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217733, 216712, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217734, 216704, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217735, 216706, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217736, 216692, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217737, 216693, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217738, 216694, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217739, 216695, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217740, 216696, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217741, 216697, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217742, 216721, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217753, 216718, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217755, 216816, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217758, 217038, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217761, 216705, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217762, 216834, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217764, 216837, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217765, 216726, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217766, 216727, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217767, 217647, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217775, 216728, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217776, 216717, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217777, 217052, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217778, 216735, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217779, 217070, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217780, 216738, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217781, 216739, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217782, 216740, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217783, 216741, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217784, 216725, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217785, 216742, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217786, 216743, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217787, 216744, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217788, 216745, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217789, 216746, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217790, 216748, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217791, 216749, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217792, 216750, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217793, 216751, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217794, 216752, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217795, 216747, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217796, 216755, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217797, 216763, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217798, 216764, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217799, 216753, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217800, 216754, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217801, 216756, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217802, 216757, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217803, 216758, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217804, 216759, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217805, 216760, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217806, 216761, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217807, 216762, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217808, 217183, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217809, 217805, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217810, 217444, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217811, 217089, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217812, 217808, '2026-07-26');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217821, 217817, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217822, 216792, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217823, 216682, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217824, 217820, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217825, 216685, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217826, 216687, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217827, 216698, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217828, 216699, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217829, 216700, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217830, 216693, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217831, 216688, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217832, 216689, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217833, 216690, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217834, 216691, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217835, 216692, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217836, 216695, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217837, 216694, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217838, 216696, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217839, 216697, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217840, 216701, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217841, 216799, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217842, 216702, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217843, 216703, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217844, 216834, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217845, 216704, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217846, 217842, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217847, 216706, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217848, 216707, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217849, 216708, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217850, 216709, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217851, 216710, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217852, 217525, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217853, 217849, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217854, 217850, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217855, 217851, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217856, 216711, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217857, 216712, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217858, 216713, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217859, 217855, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217860, 217856, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217861, 217857, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217862, 217858, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217863, 217859, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217864, 216726, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217865, 217861, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217866, 217862, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217867, 216727, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217868, 217864, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217869, 217865, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217870, 217189, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217871, 217867, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217872, 217868, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217873, 217869, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217874, 216718, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217875, 216721, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217876, 216722, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217877, 217873, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217878, 216723, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217879, 217875, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217880, 217876, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217881, 217877, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217882, 217878, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217883, 217879, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217884, 217880, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217885, 216717, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217886, 217882, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217887, 217883, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217888, 217884, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217889, 217885, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217890, 217886, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217891, 217887, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217892, 217888, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217893, 217889, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217894, 217890, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217895, 217891, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217896, 217892, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217897, 217893, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217898, 217894, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217899, 217895, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217900, 217896, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217901, 217897, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217902, 217898, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217903, 217899, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217904, 217900, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217905, 217901, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217906, 217902, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217907, 217903, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217908, 217904, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217909, 217905, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217910, 217906, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217911, 217907, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217912, 217908, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217913, 217909, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217914, 216738, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217915, 216739, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217916, 216725, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217917, 216740, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217918, 216741, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217919, 216742, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217920, 216743, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217921, 216744, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217922, 216745, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217923, 216746, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217924, 216748, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217925, 216749, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217926, 216750, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217927, 216751, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217928, 216752, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217929, 216753, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217930, 216754, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217931, 216756, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217932, 216757, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217933, 216747, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217934, 216755, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217935, 216763, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217936, 216764, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217937, 216758, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217938, 216759, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217939, 216760, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217940, 216761, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217941, 216762, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217942, 217938, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217943, 217939, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217944, 217940, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217945, 217088, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217948, 217944, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217951, 217947, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217987, 217983, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217993, 217989, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217994, 217990, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217995, 217991, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217996, 217196, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217997, 216791, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217998, 217199, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (217999, 216687, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218000, 216698, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218001, 216699, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218002, 216700, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218003, 216693, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218004, 216688, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218005, 216689, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218006, 216690, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218007, 216691, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218008, 216692, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218009, 216695, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218010, 216694, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218011, 216696, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218012, 216697, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218013, 216701, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218014, 216799, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218015, 216702, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218016, 216703, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218017, 216834, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218018, 216704, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218019, 216705, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218020, 217842, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218021, 216706, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218022, 216707, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218023, 216708, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218024, 216709, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218025, 216710, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218026, 217525, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218027, 217849, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218028, 217850, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218029, 217851, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218030, 216711, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218031, 216712, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218032, 216713, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218033, 218029, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218034, 218030, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218035, 218031, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218036, 218032, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218037, 218033, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218038, 217183, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218039, 216726, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218040, 217858, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218041, 216727, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218042, 217861, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218043, 217189, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218044, 217876, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218045, 217877, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218046, 217878, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218047, 217879, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218048, 217880, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218049, 216717, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218050, 217882, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218051, 217883, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218052, 217884, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218053, 217885, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218054, 217886, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218055, 217887, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218056, 217888, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218057, 217889, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218058, 217890, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218059, 217891, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218060, 217892, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218061, 217893, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218062, 217894, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218063, 217895, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218064, 217896, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218065, 217897, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218066, 217898, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218067, 217899, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218068, 217900, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218069, 217901, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218070, 217902, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218071, 217903, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218072, 217904, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218073, 217905, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218074, 217906, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218075, 217907, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218076, 217908, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218077, 217909, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218078, 216738, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218079, 216739, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218080, 216725, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218081, 216740, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218082, 216741, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218083, 216742, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218084, 216743, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218085, 216744, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218086, 216745, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218087, 216746, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218088, 216748, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218089, 216749, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218090, 216750, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218091, 216751, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218092, 216752, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218093, 216753, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218094, 216754, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218095, 216747, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218096, 216755, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218097, 216763, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218098, 216764, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218099, 216756, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218100, 216757, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218101, 216758, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218102, 216759, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218103, 216760, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218104, 216761, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218105, 216762, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218106, 218102, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218107, 218103, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218108, 218104, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218109, 218105, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218111, 216718, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218112, 218108, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218151, 217983, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218157, 216693, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218158, 216688, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218159, 216689, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218160, 216690, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218161, 216691, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218162, 218158, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218163, 217399, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218164, 217299, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218165, 218161, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218166, 216682, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218167, 216687, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218168, 216698, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218169, 216699, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218170, 216700, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218171, 216701, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218172, 216692, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218173, 216695, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218174, 216694, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218175, 216696, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218176, 216697, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218177, 216799, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218178, 216702, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218179, 216703, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218180, 216834, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218181, 216704, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218182, 216705, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218183, 217842, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218184, 216706, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218185, 216707, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218186, 216708, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218187, 216709, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218188, 216710, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218189, 217525, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218190, 217849, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218191, 217850, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218192, 217851, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218193, 216711, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218194, 216712, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218195, 216713, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218196, 218192, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218197, 216718, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218198, 217229, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218199, 218195, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218200, 218196, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218201, 217873, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218202, 216722, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218203, 216721, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218204, 216816, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218205, 216726, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218206, 217858, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218207, 216727, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218208, 217861, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218209, 217189, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218210, 217876, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218211, 217877, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218212, 217878, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218213, 217879, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218214, 217880, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218215, 217882, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218216, 216717, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218217, 217883, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218218, 217884, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218219, 217885, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218220, 217886, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218221, 217887, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218222, 217888, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218223, 217889, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218224, 217890, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218225, 217891, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218226, 217892, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218227, 217893, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218228, 217894, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218229, 217895, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218230, 217896, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218231, 217897, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218232, 217898, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218233, 217899, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218234, 217900, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218235, 217901, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218236, 217902, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218237, 217903, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218238, 217904, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218239, 217905, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218240, 217906, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218241, 217907, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218242, 217908, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218243, 217909, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218244, 216738, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218245, 216739, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218246, 216725, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218247, 216740, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218248, 216741, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218249, 216742, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218250, 216743, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218251, 216744, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218252, 216745, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218253, 216746, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218254, 216748, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218255, 216749, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218256, 216750, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218257, 216751, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218258, 216752, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218259, 216753, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218260, 216754, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218261, 216747, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218262, 216755, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218263, 216763, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218264, 216764, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218265, 216756, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218266, 216757, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218267, 216758, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218268, 216759, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218269, 216760, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218270, 216761, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218271, 216762, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218272, 218268, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218273, 218269, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218274, 218270, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218275, 218271, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218276, 216872, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218278, 217283, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218281, 218277, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218318, 217983, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218324, 216693, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218325, 216688, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218326, 216689, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218327, 216690, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218328, 216691, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218329, 216695, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218330, 216696, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218331, 216697, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218332, 217298, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218333, 216991, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218334, 218330, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218335, 216791, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218336, 218332, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218337, 216687, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218338, 216698, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218339, 216699, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218340, 216700, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218341, 216701, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218342, 216692, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218343, 216694, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218344, 216799, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218345, 216702, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218346, 216703, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218347, 216834, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218348, 216704, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218349, 216705, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218350, 216707, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218351, 216708, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218352, 216709, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218353, 216710, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218354, 217525, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218355, 217849, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218356, 217850, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218357, 217851, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218358, 216711, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218359, 216712, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218360, 216713, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218361, 217842, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218362, 216706, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218363, 217132, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218364, 218360, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218365, 218361, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218366, 217452, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218367, 218363, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218368, 218364, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218369, 218365, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218370, 216722, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218371, 216723, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218372, 216721, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218373, 218369, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218374, 216726, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218375, 216727, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218376, 217189, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218377, 217858, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218378, 217861, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218379, 217876, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218380, 217877, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218381, 217878, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218382, 217879, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218383, 217880, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218384, 217882, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218385, 217883, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218386, 217884, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218387, 217885, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218388, 217886, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218389, 217887, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218390, 217888, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218391, 217889, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218392, 217890, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218393, 217891, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218394, 217892, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218395, 217893, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218396, 217894, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218397, 217895, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218398, 217896, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218399, 217897, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218400, 217898, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218401, 217899, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218402, 217900, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218403, 217901, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218404, 217902, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218405, 217903, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218406, 217904, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218407, 217905, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218408, 217906, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218409, 217907, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218410, 217908, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218411, 217909, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218412, 216717, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218413, 216738, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218414, 216739, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218415, 216725, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218416, 216747, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218417, 216755, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218418, 216763, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218419, 216764, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218420, 216740, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218421, 216741, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218422, 216742, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218423, 216743, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218424, 216744, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218425, 216745, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218426, 216746, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218427, 216748, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218428, 216749, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218429, 216750, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218430, 216751, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218431, 216752, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218432, 216753, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218433, 216754, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218434, 216756, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218435, 216757, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218436, 216758, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218437, 216759, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218438, 216760, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218439, 216761, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218440, 216762, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218441, 218437, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218442, 218438, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218443, 218439, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218444, 218440, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218445, 218441, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218446, 218442, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218447, 218443, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218485, 217983, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218492, 216683, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218493, 216993, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218494, 216682, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218495, 218491, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218496, 216685, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218497, 216687, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218498, 216698, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218499, 216699, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218500, 216700, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218501, 216693, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218502, 216688, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218503, 216689, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218504, 216690, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218505, 216691, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218506, 216701, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218507, 216692, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218508, 216695, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218509, 216694, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218510, 216696, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218511, 216697, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218512, 216799, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218513, 216702, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218514, 216703, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218515, 216834, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218516, 216704, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218517, 216705, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218518, 217842, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218519, 216706, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218520, 216707, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218521, 216708, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218522, 216709, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218523, 216710, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218524, 217525, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218525, 217849, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218526, 217850, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218527, 217851, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218528, 216711, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218529, 216712, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218530, 216713, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218531, 218527, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218532, 218528, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218533, 218529, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218534, 216718, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218535, 218531, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218536, 218532, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218537, 216726, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218538, 217858, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218539, 218535, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218540, 216727, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218541, 217861, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218542, 218538, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218543, 216721, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218544, 218540, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218545, 218541, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218546, 218542, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218547, 217189, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218548, 217876, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218549, 217877, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218550, 217878, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218551, 217879, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218552, 217880, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218553, 217882, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218554, 217883, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218555, 217884, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218556, 216717, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218557, 217885, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218558, 217886, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218559, 217887, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218560, 217888, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218561, 217889, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218562, 217890, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218563, 217891, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218564, 217892, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218565, 217893, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218566, 217894, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218567, 217895, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218568, 217896, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218569, 217897, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218570, 217898, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218571, 217899, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218572, 217900, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218573, 217901, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218574, 217902, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218575, 217903, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218576, 217904, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218577, 217905, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218578, 217906, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218579, 217907, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218580, 217908, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218581, 217909, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218583, 216738, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218584, 216739, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218585, 216740, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218586, 216741, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218587, 216742, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218588, 216743, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218589, 216744, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218590, 216745, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218591, 216725, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218592, 216746, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218593, 216748, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218594, 216749, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218595, 216750, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218596, 216751, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218597, 216752, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218598, 216753, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218599, 216754, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218600, 216756, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218601, 216747, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218602, 216755, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218603, 216763, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218604, 216764, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218605, 216757, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218606, 216758, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218607, 216759, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218608, 216760, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218609, 216761, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218610, 216762, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218611, 218607, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218612, 218608, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218613, 218609, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218614, 217137, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218616, 218612, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218654, 217983, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218660, 216682, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218661, 216788, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218662, 216789, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218663, 216791, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218664, 216792, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218665, 216687, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218666, 216698, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218667, 216699, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218668, 216700, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218669, 216693, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218670, 218666, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218671, 216688, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218672, 216689, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218673, 216690, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218674, 216691, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218675, 216701, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218676, 216692, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218677, 216695, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218678, 216694, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218679, 216696, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218680, 216697, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218681, 216799, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218682, 216702, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218683, 216703, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218684, 216834, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218685, 216704, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218686, 216705, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218687, 217842, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218688, 216706, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218689, 216707, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218690, 216708, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218691, 216709, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218692, 216710, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218693, 217525, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218694, 217849, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218695, 217850, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218696, 217851, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218697, 218693, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218698, 216711, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218699, 216712, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218700, 216713, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218709, 218158, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218711, 216815, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218723, 216837, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218725, 217444, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218726, 217636, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218727, 216718, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218729, 217858, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218730, 217861, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218731, 218727, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218732, 216726, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218733, 217876, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218734, 216727, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218735, 217877, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218736, 217878, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218737, 217189, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218750, 218746, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218751, 217879, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218752, 217880, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218753, 217882, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218754, 217883, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218755, 216717, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218756, 217884, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218757, 217885, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218758, 217886, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218759, 217887, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218760, 217888, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218761, 217889, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218762, 217890, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218763, 217891, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218764, 217892, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218765, 217893, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218766, 217894, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218767, 217895, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218768, 217896, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218769, 217897, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218770, 217898, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218771, 217899, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218772, 217900, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218773, 217901, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218774, 218770, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218775, 217902, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218776, 217903, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218777, 217904, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218778, 217905, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218779, 217906, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218780, 217907, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218781, 217908, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218782, 217909, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218783, 216738, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218784, 216739, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218785, 216725, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218786, 218782, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218787, 216740, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218788, 216741, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218789, 216742, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218790, 216743, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218791, 216744, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218792, 216745, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218793, 216746, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218794, 216748, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218795, 216749, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218796, 216750, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218797, 216751, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218798, 216752, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218799, 216753, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218800, 216754, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218801, 216756, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218802, 216757, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218803, 216758, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218804, 216759, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218805, 216760, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218806, 216747, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218807, 216761, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218808, 216762, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218809, 216755, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218810, 218806, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218811, 216764, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218812, 218808, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218813, 218809, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218814, 218810, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218815, 218811, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218816, 218812, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218817, 218813, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218818, 217694, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218819, 218815, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218862, 217983, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218868, 218158, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218869, 216989, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218870, 216990, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218871, 216791, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218872, 216991, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218873, 216687, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218874, 216698, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218875, 216699, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218876, 216700, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218877, 216693, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218878, 218666, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218879, 216688, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218880, 216689, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218881, 216690, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218882, 216691, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218883, 216701, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218884, 216692, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218885, 216695, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218886, 216694, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218887, 216696, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218888, 216697, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218889, 216799, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218890, 216702, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218891, 216703, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218892, 216834, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218893, 216704, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218894, 216705, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218895, 217842, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218896, 216706, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218897, 216707, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218898, 216708, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218899, 216709, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218900, 216710, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218901, 217525, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218902, 217849, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218903, 217850, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218904, 217851, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218905, 218693, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218906, 216711, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218907, 216712, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218908, 216713, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218919, 217038, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218920, 218330, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218929, 216837, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218931, 216718, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218932, 218727, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218933, 216816, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218934, 216721, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218936, 217858, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218937, 217861, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218938, 216726, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218939, 217876, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218940, 216727, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218941, 217877, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218942, 217878, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218946, 217189, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218956, 218746, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218957, 217879, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218958, 217880, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218959, 217882, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218960, 217883, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218961, 217884, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218962, 216717, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218963, 217885, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218964, 217886, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218965, 217887, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218966, 217888, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218967, 217889, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218968, 217890, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218969, 217891, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218970, 217892, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218971, 217893, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218972, 217894, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218973, 217895, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218974, 217896, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218975, 217897, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218976, 217898, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218977, 217899, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218978, 217900, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218979, 217901, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218980, 218770, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218981, 217902, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218982, 217903, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218983, 217904, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218984, 217905, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218985, 217906, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218986, 217907, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218987, 217908, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218988, 217909, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218989, 216738, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218990, 216739, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218991, 216740, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218992, 216741, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218993, 216742, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218994, 216743, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218995, 216744, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218996, 216725, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218997, 216745, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218998, 216746, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (218999, 216748, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219000, 216749, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219001, 216750, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219002, 216751, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219003, 216752, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219004, 216753, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219005, 216754, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219006, 216756, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219007, 216757, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219008, 216758, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219009, 216759, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219010, 216760, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219011, 216761, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219012, 216762, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219013, 216747, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219014, 216755, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219015, 218806, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219016, 216764, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219017, 219013, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219018, 216769, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219019, 217231, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219020, 219016, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219022, 219018, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219023, 218813, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219031, 218815, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219045, 218782, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219066, 217983, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219072, 218666, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219073, 216688, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219074, 216689, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219075, 216690, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219076, 216691, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219077, 216693, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219078, 216695, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219079, 216696, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219080, 216697, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219081, 216692, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219082, 217817, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219083, 216792, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219084, 216682, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219085, 216685, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219086, 219082, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219087, 218158, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219088, 216687, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219089, 216698, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219090, 216699, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219091, 216700, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219092, 216701, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219093, 216799, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219094, 216702, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219095, 216703, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219096, 216834, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219097, 216704, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219098, 216713, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219099, 217849, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219100, 217850, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219101, 216711, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219102, 216710, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219103, 217525, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219104, 216709, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219105, 216707, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219106, 216708, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219107, 217851, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219108, 218693, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219109, 216705, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219110, 217842, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219111, 219107, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219112, 219108, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219113, 216718, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219114, 219110, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219115, 218196, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219116, 219112, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219117, 216721, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219118, 217138, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219119, 219115, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219120, 219116, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219121, 216722, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219122, 219118, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219123, 216726, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219124, 216727, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219134, 216712, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219137, 216728, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219138, 217879, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219139, 217880, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219140, 217882, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219141, 217883, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219142, 217884, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219143, 217885, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219144, 217886, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219145, 217887, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219146, 217888, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219147, 217889, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219148, 217890, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219149, 217891, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219150, 217892, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219151, 217893, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219152, 217894, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219153, 217895, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219154, 217896, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219155, 217897, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219156, 217898, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219157, 217899, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219158, 217900, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219159, 217901, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219160, 218770, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219161, 217902, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219162, 217903, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219163, 217904, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219164, 217858, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219165, 217861, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219166, 217876, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219167, 217877, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219168, 217878, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219169, 217905, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219170, 217906, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219171, 217907, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219172, 217908, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219173, 217909, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219174, 218746, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219175, 216717, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219176, 216738, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219177, 216739, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219178, 216725, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219179, 216747, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219180, 216755, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219181, 218806, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219182, 216764, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219183, 216740, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219184, 216741, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219185, 216742, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219186, 216743, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219187, 216744, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219188, 216745, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219189, 216746, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219190, 216748, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219191, 216749, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219192, 216750, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219193, 216751, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219194, 216752, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219195, 216753, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219196, 216754, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219197, 216756, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219198, 216757, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219199, 216758, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219200, 216759, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219201, 216760, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219202, 216761, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219203, 216762, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219204, 219200, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219205, 219201, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219206, 219202, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219207, 219203, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219208, 219204, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219209, 219205, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219210, 219206, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219211, 219207, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219212, 219208, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219213, 217444, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219214, 219210, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219215, 219211, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219216, 219212, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219217, 219213, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219222, 218813, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219253, 217983, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219267, 218782, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219269, 219265, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219278, 219274, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219281, 219277, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219288, 219284, '2026-08-03');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219299, 217989, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219300, 217990, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219301, 217991, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219302, 217196, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219303, 217199, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219304, 216993, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219305, 216687, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219306, 216698, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219307, 216699, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219308, 216692, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219309, 216700, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219310, 218666, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219311, 216688, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219312, 216689, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219313, 216690, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219314, 216691, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219315, 216693, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219316, 216694, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219317, 216695, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219318, 216696, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219319, 216697, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219320, 216701, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219321, 216799, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219322, 216702, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219323, 216703, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219324, 216834, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219325, 216704, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219326, 216707, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219327, 217525, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219328, 217849, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219329, 218693, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219330, 216708, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219331, 217851, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219332, 216709, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219333, 216705, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219334, 216713, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219335, 216711, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219336, 217850, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219337, 216710, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219338, 217842, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219339, 216706, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219340, 219336, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219341, 219337, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219342, 219338, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219343, 219339, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219344, 219118, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219345, 219341, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219346, 219342, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219347, 219343, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219348, 219344, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219349, 216726, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219350, 216727, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219351, 219347, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219359, 219355, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219360, 219356, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219361, 219357, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219362, 219358, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219363, 219359, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219364, 219360, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219365, 216717, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219366, 217879, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219367, 217880, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219368, 217882, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219369, 217883, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219372, 216712, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219374, 217884, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219376, 216728, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219377, 217885, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219378, 217886, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219379, 217887, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219380, 217888, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219381, 217889, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219382, 217890, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219383, 217891, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219384, 217892, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219385, 217893, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219386, 217894, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219387, 217895, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219388, 217896, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219389, 217897, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219390, 216725, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219391, 216747, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219392, 216755, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219393, 218806, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219394, 217898, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219395, 217899, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219396, 217900, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219397, 217901, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219398, 218770, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219399, 217902, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219400, 217903, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219401, 217904, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219402, 217858, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219403, 217861, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219404, 217876, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219405, 217877, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219406, 217878, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219407, 217905, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219408, 217906, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219409, 217907, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219410, 217908, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219411, 216738, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219412, 217909, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219413, 218746, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219414, 216739, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219415, 218782, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219416, 216740, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219417, 216741, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219418, 216742, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219419, 216743, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219420, 216744, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219421, 216745, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219422, 216746, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219423, 216748, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219424, 216749, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219425, 216750, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219426, 216751, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219427, 216752, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219428, 216753, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219429, 216754, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219430, 216756, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219431, 216757, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219432, 216758, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219433, 216759, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219434, 216760, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219435, 216761, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219436, 216762, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219437, 216764, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219438, 219434, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219439, 219435, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219440, 217185, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219442, 218813, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219443, 219439, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219444, 219440, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219446, 219442, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219483, 217983, '2026-08-04');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219494, 218666, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219495, 216688, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219496, 216689, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219497, 216690, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219498, 216691, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219499, 217399, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219500, 217299, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219501, 218161, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219502, 216682, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219503, 218330, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219504, 216687, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219505, 216698, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219506, 216699, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219507, 216700, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219508, 216692, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219509, 216701, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219510, 216799, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219511, 216693, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219512, 216694, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219513, 216695, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219514, 216696, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219515, 216697, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219516, 216702, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219517, 216703, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219518, 216834, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219519, 216704, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219520, 216705, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219521, 219517, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219522, 219518, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219523, 217842, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219524, 216706, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219525, 216707, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219526, 216708, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219527, 216709, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219528, 216710, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219529, 217525, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219530, 217849, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219531, 217850, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219532, 217851, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219533, 218693, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219534, 216711, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219535, 216712, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219536, 216713, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219537, 216718, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219538, 219534, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219539, 219535, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219540, 219536, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219541, 219537, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219542, 219538, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219543, 216723, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219544, 216722, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219545, 217444, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219546, 217328, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219547, 216721, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219548, 219118, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219549, 216726, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219550, 216727, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219563, 216728, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219564, 216717, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219565, 217879, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219566, 217880, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219567, 217882, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219568, 217883, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219569, 217884, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219570, 217885, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219571, 217886, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219572, 217887, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219573, 217888, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219574, 217889, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219575, 217890, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219576, 217891, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219577, 217892, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219578, 217893, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219579, 217894, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219580, 217895, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219581, 217896, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219582, 217897, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219583, 217898, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219584, 217899, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219585, 217900, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219586, 217901, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219587, 218770, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219588, 217902, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219589, 217903, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219590, 217904, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219591, 217858, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219592, 217861, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219593, 217876, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219594, 217877, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219595, 217878, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219596, 217905, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219597, 217906, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219598, 217907, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219599, 217908, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219600, 217909, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219601, 216738, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219602, 218746, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219603, 216739, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219604, 216725, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219605, 216740, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219606, 216741, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219607, 216742, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219608, 216743, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219609, 216747, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219610, 216744, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219611, 216745, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219612, 216746, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219613, 216748, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219614, 216749, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219615, 216750, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219616, 216751, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219617, 216755, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219618, 216752, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219619, 216753, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219620, 216754, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219621, 216756, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219622, 216757, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219623, 216758, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219624, 216759, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219625, 218806, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219626, 216760, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219627, 216764, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219628, 216761, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219629, 216762, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219632, 217089, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219633, 219629, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219634, 219630, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219635, 218813, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219637, 219633, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219639, 219635, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219660, 218782, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219676, 217983, '2026-08-05');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219687, 217298, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219688, 216991, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219689, 216791, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219690, 218332, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219691, 218158, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219692, 216687, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219693, 216698, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219694, 216699, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219695, 216700, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219696, 218666, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219697, 216688, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219698, 216689, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219699, 216690, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219700, 216691, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219701, 216701, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219702, 216692, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219703, 216693, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219704, 216694, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219705, 216695, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219706, 216696, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219707, 216697, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219708, 216799, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219709, 216702, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219710, 216703, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219711, 216834, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219712, 216704, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219713, 216705, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219714, 217842, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219715, 216706, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219716, 216707, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219717, 216708, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219718, 216709, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219719, 216710, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219720, 217525, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219721, 217849, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219722, 217850, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219723, 217851, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219724, 218693, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219725, 216711, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219726, 216712, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219727, 216713, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219728, 219118, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219729, 219725, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219730, 219726, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219731, 219727, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219732, 219728, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219733, 219729, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219734, 219730, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219735, 217450, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219736, 216726, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219737, 216721, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219738, 217236, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219739, 219735, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219740, 216727, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219741, 219737, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219752, 216717, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219753, 217879, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219754, 217880, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219755, 217882, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219756, 217883, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219757, 217884, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219759, 216728, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219761, 217885, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219762, 217886, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219763, 217887, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219764, 217888, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219765, 217889, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219766, 217890, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219767, 217891, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219768, 217892, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219769, 217893, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219770, 217894, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219771, 217895, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219772, 217896, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219773, 217897, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219774, 217898, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219775, 217899, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219776, 216725, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219777, 216747, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219778, 216755, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219779, 218806, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219780, 217900, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219781, 217901, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219782, 218770, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219783, 217902, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219784, 217903, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219785, 217904, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219786, 217858, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219787, 217861, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219788, 217876, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219789, 217877, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219790, 217878, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219791, 217905, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219792, 217906, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219793, 217907, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219794, 217908, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219795, 217909, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219796, 218746, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219797, 216738, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219798, 216764, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219799, 216739, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219800, 216740, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219801, 216741, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219802, 216742, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219803, 216743, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219804, 216744, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219805, 216745, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219806, 216746, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219807, 216748, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219808, 216749, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219809, 216750, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219810, 216751, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219811, 216752, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219812, 216753, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219813, 216754, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219814, 216756, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219815, 216757, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219816, 216758, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219817, 216759, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219818, 216760, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219819, 216761, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219820, 216762, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219821, 216718, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219822, 219818, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219824, 219820, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219825, 218813, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219826, 219822, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219827, 219823, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219829, 219825, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219849, 218782, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219865, 217983, '2026-08-06');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219876, 216683, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219877, 216682, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219878, 218491, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219879, 216685, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219880, 217820, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219881, 216687, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219882, 216698, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219883, 216699, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219884, 216700, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219885, 218666, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219886, 216688, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219887, 216689, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219888, 216690, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219889, 216691, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219890, 216701, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219891, 216692, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219892, 216693, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219893, 216694, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219894, 216695, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219895, 216696, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219896, 216697, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219897, 216799, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219898, 216702, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219899, 216703, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219900, 216834, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219901, 216704, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219902, 216705, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219903, 217842, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219904, 216706, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219905, 216707, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219906, 216708, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219907, 216709, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219908, 216710, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219909, 217525, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219910, 217849, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219911, 217850, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219912, 217851, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219913, 218693, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219914, 216711, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219915, 216712, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219916, 216713, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219917, 219913, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219918, 219914, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219919, 216716, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219920, 216718, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219921, 216719, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219922, 219118, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219923, 216720, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219924, 216721, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219925, 216722, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219926, 216723, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219927, 216724, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219928, 216726, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219929, 216727, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219930, 216728, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219941, 216717, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219942, 219630, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219943, 218813, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219944, 217879, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219945, 217880, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219946, 217882, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219947, 217883, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219948, 217884, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219951, 217885, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219952, 217886, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219953, 217887, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219954, 217888, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219955, 217889, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219956, 217890, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219957, 217891, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219958, 217892, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219959, 217893, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219960, 217894, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219961, 217895, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219962, 217896, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219963, 217897, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219964, 217898, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219965, 216725, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219966, 216747, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219967, 216755, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219968, 217899, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219969, 218806, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219970, 217900, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219971, 217901, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219972, 218770, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219973, 217902, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219974, 217903, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219975, 217904, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219976, 217858, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219977, 217861, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219978, 217876, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219979, 217877, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219980, 217878, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219981, 217905, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219982, 217906, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219983, 217907, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219984, 217908, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219985, 217909, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219986, 218746, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219987, 216738, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219988, 216739, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219989, 216740, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219990, 216741, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219991, 216742, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219992, 216743, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219993, 216744, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219994, 216745, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219995, 216746, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219996, 216748, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219997, 216749, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219998, 216750, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (219999, 216751, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220000, 216752, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220001, 216753, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220002, 216754, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220003, 216756, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220004, 216757, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220005, 216758, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220006, 216759, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220007, 216760, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220008, 216761, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220009, 216762, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220010, 216764, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220011, 216765, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220012, 216766, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220013, 216767, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220015, 216768, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220017, 216769, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220021, 216771, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220039, 218782, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220055, 217983, '2026-08-07');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220066, 216682, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220067, 216788, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220068, 216789, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220069, 216792, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220070, 218330, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220071, 216791, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220072, 216687, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220073, 216698, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220074, 216699, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220075, 216700, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220076, 218666, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220077, 216688, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220078, 216689, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220079, 216690, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220080, 216691, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220081, 216692, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220082, 216693, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220083, 216694, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220084, 216695, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220085, 216696, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220086, 216697, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220087, 216701, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220088, 216799, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220089, 216702, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220090, 216703, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220091, 216834, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220092, 216704, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220093, 216705, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220094, 217842, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220095, 216706, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220096, 216707, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220097, 216708, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220098, 216709, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220099, 216710, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220100, 217525, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220101, 217849, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220102, 217850, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220103, 217851, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220104, 218693, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220105, 216711, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220106, 216712, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220107, 216713, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220108, 218103, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220109, 220105, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220110, 216823, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220111, 216816, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220112, 220108, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220113, 216815, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220114, 216824, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220115, 216825, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220116, 216826, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220117, 216827, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220118, 216828, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220119, 220115, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220120, 220116, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220123, 220119, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220130, 216837, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220131, 219118, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220132, 220128, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220133, 218727, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220134, 216726, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220135, 216727, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220136, 216728, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220137, 216717, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220138, 218813, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220139, 217879, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220140, 217880, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220141, 217882, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220142, 217883, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220143, 217884, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220144, 217885, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220145, 217886, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220146, 217887, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220147, 217888, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220148, 217889, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220149, 217890, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220150, 217891, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220151, 217892, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220152, 217893, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220153, 217894, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220154, 217895, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220155, 217896, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220156, 217897, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220157, 217898, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220158, 217899, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220159, 217900, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220160, 217901, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220161, 218770, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220162, 217902, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220163, 217903, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220164, 217904, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220165, 217858, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220166, 217861, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220167, 217876, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220168, 217877, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220169, 217878, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220170, 217905, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220171, 217906, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220172, 217907, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220173, 217908, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220174, 217909, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220175, 218746, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220176, 216738, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220177, 216739, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220178, 216725, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220179, 218782, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220180, 216740, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220181, 216741, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220182, 216742, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220183, 216743, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220184, 216744, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220185, 216747, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220186, 216745, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220187, 216746, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220188, 216748, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220189, 216749, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220190, 216750, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220191, 216751, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220192, 216752, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220193, 216755, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220194, 216753, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220195, 216754, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220196, 216756, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220197, 216757, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220198, 216758, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220199, 216759, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220200, 216760, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220201, 218806, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220202, 216764, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220203, 216761, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220204, 216762, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220205, 220201, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220206, 216870, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220207, 216871, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220208, 216872, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220209, 216873, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220210, 216874, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220252, 217983, '2026-08-08');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220263, 216989, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220264, 216990, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220265, 216991, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220266, 216791, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220267, 216993, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220268, 216687, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220269, 216698, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220270, 216699, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220271, 216700, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220272, 218666, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220273, 216688, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220274, 216689, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220275, 216690, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220276, 216691, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220277, 216701, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220278, 216692, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220279, 216693, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220280, 216694, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220281, 216695, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220282, 216696, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220283, 216697, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220284, 216799, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220285, 216702, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220286, 216703, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220287, 216834, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220288, 216704, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220289, 216705, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220290, 217842, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220291, 216706, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220292, 216707, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220293, 216708, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220294, 216709, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220295, 216710, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220296, 217525, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220297, 217849, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220298, 217850, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220299, 217851, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220300, 218693, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220301, 216711, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220302, 216712, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220303, 216713, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220305, 216721, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220306, 217037, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220315, 216718, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220316, 217027, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220320, 217038, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220323, 220119, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220330, 216837, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220331, 219118, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220332, 220128, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220333, 218727, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220334, 216726, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220335, 216727, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220336, 216728, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220337, 216717, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220338, 218813, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220339, 217879, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220340, 217880, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220341, 217882, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220342, 217883, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220343, 217884, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220344, 217885, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220345, 217886, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220346, 217887, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220347, 217888, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220348, 217889, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220349, 217890, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220350, 217891, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220351, 217892, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220352, 217893, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220353, 217894, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220354, 217895, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220355, 217896, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220356, 217897, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220357, 217898, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220358, 217899, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220359, 217900, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220360, 217901, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220361, 218770, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220362, 217902, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220363, 217903, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220364, 217904, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220365, 217858, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220366, 217861, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220367, 217876, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220368, 217877, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220369, 217878, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220370, 217905, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220371, 217906, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220372, 217907, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220373, 217908, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220374, 217909, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220375, 218746, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220376, 216738, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220377, 216739, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220378, 218782, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220379, 216740, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220380, 216725, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220381, 216741, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220382, 216742, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220383, 216743, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220384, 216744, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220385, 216745, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220386, 216746, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220387, 216747, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220388, 216748, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220389, 216749, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220390, 216750, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220391, 216751, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220392, 216752, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220393, 216753, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220394, 216754, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220395, 216755, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220396, 216756, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220397, 216757, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220398, 216758, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220399, 216759, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220400, 216760, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220401, 216761, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220402, 218806, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220403, 216764, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220404, 216762, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220405, 217083, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220406, 217084, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220407, 217085, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220408, 216771, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220409, 217087, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220411, 217088, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220412, 217089, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220450, 217983, '2026-08-09');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220461, 220457, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220462, 217107, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220463, 220459, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220464, 220460, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220465, 217108, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220466, 216792, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220467, 216682, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220468, 216685, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220469, 216687, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220470, 216698, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220471, 216699, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220472, 218666, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220473, 216688, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220474, 216689, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220475, 216690, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220476, 216691, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220477, 216692, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220478, 216693, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220479, 216694, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220480, 216695, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220481, 216696, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220482, 216697, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220483, 216700, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220484, 216701, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220485, 216799, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220486, 216702, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220487, 216703, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220488, 216834, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220489, 216704, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220490, 216705, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220491, 217842, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220492, 216706, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220493, 216707, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220494, 216708, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220495, 216709, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220496, 216710, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220497, 217525, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220498, 217849, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220499, 217850, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220500, 217851, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220501, 218693, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220502, 216711, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220503, 216712, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220504, 216713, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220505, 217134, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220506, 220502, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220507, 216720, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220508, 217133, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220509, 217136, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220510, 218727, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220511, 217137, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220512, 216721, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220513, 216723, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220514, 216722, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220515, 217140, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220516, 216726, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220517, 216727, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220518, 216728, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220528, 217879, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220529, 217880, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220530, 216717, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220531, 217882, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220535, 217883, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220536, 217884, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220537, 217885, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220538, 217886, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220539, 217887, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220540, 217888, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220541, 217889, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220542, 217890, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220543, 217891, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220544, 217892, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220545, 217893, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220546, 217894, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220547, 217895, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220548, 217896, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220549, 217897, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220550, 217898, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220551, 216725, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220552, 216747, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220553, 217899, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220554, 217900, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220555, 217901, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220556, 218770, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220557, 217902, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220558, 216755, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220559, 217903, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220560, 217904, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220561, 217858, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220562, 217861, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220563, 217876, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220564, 217877, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220565, 217878, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220566, 217905, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220567, 217906, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220568, 217907, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220569, 217908, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220570, 217909, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220571, 218746, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220572, 216738, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220573, 216739, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220574, 216740, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220575, 216741, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220576, 216742, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220577, 216743, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220578, 216744, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220579, 216745, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220580, 216746, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220581, 216748, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220582, 216749, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220583, 216750, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220584, 216751, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220585, 216752, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220586, 216753, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220587, 216754, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220588, 216756, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220589, 216757, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220590, 216758, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220591, 216759, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220592, 216760, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220593, 216761, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220594, 216762, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220595, 218806, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220596, 216764, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220597, 218105, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220598, 217182, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220599, 218813, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220600, 217183, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220602, 217184, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220605, 216769, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220608, 217189, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220626, 218782, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220640, 217983, '2026-08-10');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220652, 220648, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220653, 217196, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220654, 216791, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220655, 217199, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220656, 218330, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220657, 216687, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220658, 216698, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220659, 216699, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220660, 216700, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220661, 218666, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220662, 216688, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220663, 216689, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220664, 216690, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220665, 216691, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220666, 216701, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220667, 216692, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220668, 216693, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220669, 216694, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220670, 216695, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220671, 216696, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220672, 216697, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220673, 216799, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220674, 216702, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220675, 216703, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220676, 216834, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220677, 216704, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220678, 216705, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220679, 217842, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220680, 216706, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220681, 216707, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220682, 216708, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220683, 216709, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220684, 216710, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220685, 217525, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220686, 217849, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220687, 217850, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220688, 217851, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220689, 218693, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220690, 216711, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220691, 216712, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220692, 216713, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220693, 219336, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220694, 217228, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220695, 217229, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220696, 220692, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220697, 219339, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220698, 218727, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220699, 219341, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220700, 216726, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220701, 219342, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220702, 216727, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220703, 219343, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220704, 219344, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220705, 216728, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220710, 219347, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220711, 219355, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220712, 219356, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220713, 219357, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220714, 219359, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220715, 217138, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220716, 216721, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220717, 219360, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220718, 217879, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220719, 217880, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220728, 216717, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220729, 217882, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220730, 217883, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220731, 217884, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220732, 217885, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220733, 217886, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220734, 217887, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220735, 217888, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220736, 217889, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220737, 217890, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220738, 217891, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220739, 217892, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220740, 217893, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220741, 217894, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220742, 217895, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220743, 216725, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220744, 216747, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220745, 217896, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220746, 217897, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220747, 217898, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220748, 217899, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220749, 217900, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220750, 217901, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220751, 218770, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220752, 217902, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220753, 217903, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220754, 217904, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220755, 217858, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220756, 217861, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220757, 217876, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220758, 217877, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220759, 217878, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220760, 217905, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220761, 217906, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220762, 217907, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220763, 217908, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220764, 217909, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220765, 218746, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220766, 216738, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220767, 216739, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220768, 216740, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220769, 216741, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220770, 216742, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220771, 216743, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220772, 216744, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220773, 216745, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220774, 216746, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220775, 216748, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220776, 216749, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220777, 216750, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220778, 216751, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220779, 216752, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220780, 216753, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220781, 216754, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220782, 216756, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220783, 216757, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220784, 216758, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220785, 216759, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220786, 216760, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220787, 216761, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220788, 216762, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220789, 216755, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220790, 218806, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220791, 216764, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220792, 216872, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220793, 217280, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220794, 217281, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220796, 218813, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220797, 217283, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220799, 217485, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220802, 217287, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220821, 218782, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220836, 217983, '2026-08-11');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220848, 218666, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220849, 216688, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220850, 216689, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220851, 216690, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220852, 216691, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220853, 217298, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220854, 217299, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220855, 216682, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220856, 220852, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220857, 217820, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220858, 216687, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220859, 216698, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220860, 216699, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220861, 216700, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220862, 216701, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220863, 216692, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220864, 216693, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220865, 216694, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220866, 216695, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220867, 216696, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220868, 216697, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220869, 216799, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220870, 216702, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220871, 216703, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220872, 216834, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220873, 216704, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220874, 216705, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220875, 217842, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220876, 216706, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220877, 216707, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220878, 216708, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220879, 216709, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220880, 216710, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220881, 217525, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220882, 217849, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220883, 217850, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220884, 217851, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220885, 218693, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220886, 216711, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220887, 216712, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220888, 216713, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220889, 216991, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220890, 217329, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220891, 217328, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220892, 219914, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220893, 216718, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220894, 217331, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220895, 218727, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220896, 217332, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220897, 216726, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220898, 216721, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220899, 216722, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220900, 216723, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220901, 216727, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220902, 216728, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220912, 217879, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220913, 217880, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220917, 217882, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220918, 216717, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220919, 217883, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220920, 217884, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220921, 217885, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220922, 217886, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220923, 217887, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220924, 217888, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220925, 217889, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220926, 217890, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220927, 217891, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220928, 217892, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220929, 217893, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220930, 217894, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220931, 217895, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220932, 217896, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220933, 217897, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220934, 217898, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220935, 216725, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220936, 216747, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220937, 217899, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220938, 217900, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220939, 217901, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220940, 218770, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220941, 217902, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220942, 217903, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220943, 216755, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220944, 217904, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220945, 217858, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220946, 217861, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220947, 217876, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220948, 217877, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220949, 217878, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220950, 217905, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220951, 217906, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220952, 217907, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220953, 217908, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220954, 217909, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220955, 218746, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220956, 216738, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220957, 216739, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220958, 216740, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220959, 216741, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220960, 216742, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220961, 216743, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220962, 216744, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220963, 216745, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220964, 216746, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220965, 216748, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220966, 216749, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220967, 216750, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220968, 216751, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220969, 216752, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220970, 216753, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220971, 216754, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220972, 216756, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220973, 216757, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220974, 216758, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220975, 216759, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220976, 216760, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220977, 216761, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220978, 216762, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220979, 218806, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220980, 216764, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220981, 220977, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220982, 217377, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220983, 217378, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220985, 218813, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220986, 217379, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (220988, 217382, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221010, 218782, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221024, 217983, '2026-08-12');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221036, 218666, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221037, 216688, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221038, 216689, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221039, 216690, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221040, 216691, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221041, 216693, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221042, 216695, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221043, 216696, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221044, 216697, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221045, 217399, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221046, 217400, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221047, 216791, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221048, 216991, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221049, 218158, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221050, 216687, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221051, 216698, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221052, 216699, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221053, 216700, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221054, 216701, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221055, 216692, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221056, 216694, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221057, 216799, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221058, 216702, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221059, 216703, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221060, 216834, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221061, 216704, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221062, 216705, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221063, 217842, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221064, 216706, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221065, 216707, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221066, 216708, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221067, 216709, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221068, 216710, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221069, 217525, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221070, 217849, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221071, 217850, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221072, 217851, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221073, 218693, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221074, 216711, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221075, 216712, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221076, 216713, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221077, 217423, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221078, 221074, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221079, 218727, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221080, 216726, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221081, 216727, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221082, 216728, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221086, 217434, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221087, 217435, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221088, 217436, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221089, 217437, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221090, 217439, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221091, 217441, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221092, 217442, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221093, 217443, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221094, 217444, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221095, 217445, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221096, 217447, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221097, 217448, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221098, 216721, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221099, 217138, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221100, 216722, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221101, 217452, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221111, 217879, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221112, 217880, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221113, 216717, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221114, 217882, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221115, 217883, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221116, 217884, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221117, 217885, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221118, 217886, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221119, 217887, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221120, 217888, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221121, 217889, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221122, 217890, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221123, 217891, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221124, 217892, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221125, 217893, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221126, 217894, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221127, 217895, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221128, 217896, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221129, 217897, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221130, 217898, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221131, 217899, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221132, 217900, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221133, 217901, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221134, 218770, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221135, 217902, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221136, 217903, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221137, 217904, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221138, 217858, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221139, 217861, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221140, 217876, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221141, 217877, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221142, 217878, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221143, 217905, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221144, 217906, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221145, 217907, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221146, 217908, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221147, 217909, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221148, 218746, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221149, 216738, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221150, 216739, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221151, 216725, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221152, 216747, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221153, 218806, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221154, 216740, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221155, 216741, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221156, 216742, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221157, 216743, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221158, 216744, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221159, 216745, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221160, 216746, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221161, 216748, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221162, 216749, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221163, 216750, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221164, 216751, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221165, 216752, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221166, 216753, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221167, 216754, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221168, 216756, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221169, 216757, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221170, 216758, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221171, 216759, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221172, 216760, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221173, 216761, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221174, 216755, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221175, 216764, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221176, 216762, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221177, 219213, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221178, 217482, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221179, 216872, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221180, 217484, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221181, 218270, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221182, 217486, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221187, 218813, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221219, 217983, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (221229, 218782, '2026-08-13');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226223, 218527, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226235, 216735, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226243, 217070, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226245, 217152, '2026-07-27');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226323, 226319, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226324, 226320, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226325, 217246, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226326, 226322, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226327, 226323, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226328, 217236, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226335, 216736, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226337, 216737, '2026-07-28');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226425, 217052, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226426, 216735, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226427, 217070, '2026-07-29');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226518, 216736, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226519, 216737, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226520, 216735, '2026-07-30');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226599, 226595, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226615, 216735, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226616, 217070, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226618, 217152, '2026-07-31');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226738, 216735, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226740, 216736, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226741, 216737, '2026-08-01');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226855, 217052, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226857, 216735, '2026-08-02');
INSERT INTO public.daily_schedule (id, menu_item_id, date) VALUES (226858, 217070, '2026-08-02');


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

INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216735, 23511, 'Sunbutter and Jelly Sandwich', 'lunch', 'scraped', 'overridden', 321, 4, 75, 1, 'SANDWICH', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-17 22:34:15.559859', '2026-07-21 12:20:17.403246', 21810, 'pending', 'Grape Jelly, Creamy Sunflower Butter, Sliced White Bread', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216742, 23505, 'Black Beans', 'lunch', 'scraped', 'overridden', 31, 2, 6, 0, '1.5 OZ. PORTION', NULL, NULL, NULL, NULL, '0.25 cup', false, true, '2026-07-17 22:34:16.239895', '2026-07-21 12:22:26.011901', 34557, 'pending', 'Black Beans (Low Sodium)', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216720, 23501, 'Meatballs in Marinana Sauce', 'lunch', 'scraped', 'overridden', 129, 8, 17, 4, 'SERVING', NULL, NULL, NULL, NULL, '3 meatballs', false, true, '2026-07-17 22:34:14.384165', '2026-07-21 12:21:47.407013', 14386, 'pending', 'Beef Meatball Halal, Water, Tomato Marinara Sauce', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216741, 23505, 'Balsamic Vinaigrette', 'lunch', 'scraped', 'overridden', 0, 0, 0, 0, '3.5 OZ. PORTION', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-17 22:34:16.157881', '2026-07-21 12:22:25.959845', 34580, 'pending', 'Balsamic Vinaigrette Dressing ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216736, 23511, 'Ham and Swiss on White Bread', 'lunch', 'scraped', 'overridden', 216, 16, 21, 55, 'HALF SANDWICH', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-17 22:34:15.657863', '2026-07-21 12:20:09.675391', 21799, 'pending', 'Deli Smoked Ham, Arnold Country White Sliced Bread, Local Green Leaf Lettuce, Swiss Cheese', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216752, 23505, 'Lemon & Herb Quinoa', 'lunch', 'scraped', 'overridden', 419, 8, 40, 26, 'SERVING 6 OUNCES', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-17 22:34:17.180458', '2026-07-21 12:22:26.481175', 34571, 'pending', 'Kosher Salt, Meyer Lemon Juice, Sunflower Oil, Amber Agave Nectar, Chopped Garlic, Ground Black Pepper, Golden Quinoa , Frresh Rosemary, Fresh Flat Leaf Italian Parsley, Whole Thyme, VEG PEPPERS YELLOW 11 LBS AMBROGI, VEG PEPPERS GREEN LARGE AMBROGI, Vegetable Stock Base', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216748, 23505, 'Cherry Tomatoes', 'lunch', 'scraped', 'overridden', 8, 0, 2, 0, '1.5 OZ. PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-17 22:34:16.796375', '2026-07-21 12:22:26.273144', 34555, 'pending', 'Local Cherry Tomatoes', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216746, 23505, 'Caesar Dressing', 'lunch', 'scraped', 'overridden', 65, 0, 3, 6, '3.5 OZ. PORTION', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-17 22:34:16.612533', '2026-07-21 12:22:26.221115', 34582, 'pending', 'Caesar Dressing', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216739, 23508, 'Vegetable Flatbread Pizza', 'dinner', 'scraped', 'overridden', 590, 23, 71, 22, 'PORTION', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-17 22:34:15.940022', '2026-07-21 12:22:30.189107', 30961, 'pending', 'Shredded Mozzarella & Provolone Cheese, Peeled Ground Tomatoes, 12" Flatbread', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216738, 23508, 'Neapolitan Pepperoni Flatbread', 'dinner', 'scraped', 'overridden', 469, 19, 48, 21, 'PORTION', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-17 22:34:15.844507', '2026-07-21 12:22:30.137009', 26624, 'pending', '12" Flatbread, Deli Sliced Pepperoni, Peeled Ground Tomatoes, Shredded Mozzarella & Provolone Cheese', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216724, 23501, 'Charred Asparagus', 'lunch', 'scraped', 'overridden', 36, 2, 4, 2, 'Serving', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-17 22:34:14.749951', '2026-07-21 12:21:12.361134', 17396, 'pending', 'Fresh Asparagus, Sunflower Oil, Ground Black Pepper, Kosher Salt, Italian Seasoning', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216745, 23505, 'Buttermilk Ranch', 'lunch', 'scraped', 'overridden', 83, 0, 1, 9, '3.5 OZ. PORTION', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-17 22:34:16.520405', '2026-07-21 12:22:26.169193', 34578, 'pending', 'Buttermilk Ranch Dressing', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216740, 23505, 'Asian Sesame Vinegrette', 'lunch', 'scraped', 'overridden', 23, 0, 6, 0, '3.5 OZ. PORTION', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-17 22:34:16.049882', '2026-07-21 12:22:25.907381', 34576, 'pending', 'Asian Sesame Dressing', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216751, 23505, 'Honey Mustard dressing', 'lunch', 'scraped', 'overridden', 75, 0, 2, 8, '3.5 OZ. PORTION', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-17 22:34:17.088431', '2026-07-21 12:22:26.429065', 34584, 'pending', 'Honey Mustard Dressing', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216744, 23505, 'Blue Cheese Dressing', 'lunch', 'scraped', 'overridden', 17, 0, 0, 0, '3.5 OZ. PORTION', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-17 22:34:16.423324', '2026-07-21 12:22:26.117267', 34581, 'pending', 'DRESSING BLUE CHEESE CHNKY 4/1 GL KEN''S ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216728, 23504, 'PITA CHIPS', 'dinner', 'scraped', 'overridden', 320, 5, 28, 21, 'POTION 3 OZ.', NULL, NULL, NULL, NULL, '10-12 chips (1 oz)', false, true, '2026-07-17 22:34:15.17078', '2026-07-21 12:22:27.947063', 30684, 'pending', 'Kosher Salt, Imported Olive Oil, 7" Greek Style Pita Bread', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216722, 23501, 'Hot Dog on a Bun', 'lunch', 'scraped', 'overridden', 137, 6, 2, 16, '1 HOT DOG', NULL, NULL, NULL, NULL, '1 hot dog', false, true, '2026-07-17 22:34:14.564267', '2026-07-21 12:22:22.968975', 18115, 'pending', 'Skinless Beef Hot Dog, Split Top Hot Dog Roll', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216737, 23511, 'Gluten Free Ham Sandwich', 'lunch', 'scraped', 'overridden', 215, 13, 18, 57, 'HALF SANDWICH 4 OZ', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-17 22:34:15.744427', '2026-07-21 12:20:09.727525', 20425, 'pending', 'Green Leaf Lettuce Filets, Deli Smoked Ham, Swiss Cheese, UDIs Gluten Free White Bread', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216725, 23509, 'Chewy Brownies', 'lunch', 'scraped', 'overridden', 486, 6, 84, 15, 'Brownie', NULL, NULL, NULL, NULL, '1 brownie', false, true, '2026-07-17 22:34:14.863842', '2026-07-21 12:22:25.724101', 21122, 'pending', 'Chocolate Brownie Mix', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216747, 23509, 'Chocolate Chip Cookie (Veg)', 'lunch', 'scraped', 'overridden', 236, 2, 35, 11, '2 oz.Choc. chip cook', NULL, NULL, NULL, NULL, '1 cookie', false, true, '2026-07-17 22:34:16.706719', '2026-07-21 12:22:25.77614', 34486, 'pending', 'Sweet Loren''s Chocolate Chip Cookie V GF', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216723, 23501, 'Cheese burger', 'lunch', 'scraped', 'overridden', 389, 25, 1, 31, 'BURGER', NULL, NULL, NULL, NULL, '1 cheeseburger', false, true, '2026-07-17 22:34:14.650508', '2026-07-21 12:22:11.008306', 27308, 'pending', 'Sliced Land O Lakes American Cheese, Hamburger Roll, 4 OZ Beef Patty', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216714, 23506, 'White Bean Soup', 'lunch', 'scraped', 'overridden', 22, 1, 3, 1, 'SERVING 6 OUNCE', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-17 22:34:13.772528', '2026-07-18 17:31:24.93696', 18301, 'pending', 'Fresh Thyme, Fresh Peeled Onions, Fresh Celery, Cannellini Beans, Bay Leaf, Sunflower Oil, Peeled Carrot, Kosher Salt, Ground White Pepper, Vegetable Stock Base, White Kidney Beans, Whole Thyme', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216715, 23506, 'New England Clam Chowder', 'lunch', 'scraped', 'overridden', 69, 3, 3, 5, '6 OZ BOWL', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-17 22:34:13.868632', '2026-07-21 12:19:15.924967', 13660, 'pending', 'Chopped Clams, Bay Leaf, Butter, Fresh Peeled Onions, Fish Paste Soup Base, Fresh Celery, Heavy Cream Quart, Hash Brown Cubes, Whole Thyme, Water, XXXSAUCE TABASCO MCILHENNY, Worcestershire Sauce ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216721, 23501, 'Grilled Cheese Sandwich', 'lunch', 'scraped', 'overridden', 424, 22, 32, 22, 'SANDWICH 4 OUNCES', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-17 22:34:14.471985', '2026-07-21 12:22:22.863922', 7399, 'pending', 'Butter, Cooper Sharp Cheese, Sour Dough Bread, Sliced Land O Lakes American Cheese', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216719, 23501, 'Cheese Lasagna', 'lunch', 'scraped', 'overridden', 198, 10, 26, 6, 'SERVING 6 OZ', NULL, NULL, NULL, NULL, '1.5 cups', false, true, '2026-07-17 22:34:14.287854', '2026-07-21 12:21:12.011767', 10389, 'pending', 'Grated Parmesan Cheese, Fresh Flat Leaf Italian Parsley,  Fresh Shell Eggs, Lasagna Sheet Pasta, Soprafina Whole Milk Ricotta Cheese, Spaghetti Sauce, Shredded Mozzarella Cheddar Blend Cheese, Whole Peeled Garlic, Whole Leaf Basil', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216717, 23508, 'Neapolitan Cheese Flatbread', 'dinner', 'scraped', 'overridden', 393, 16, 47, 14, 'PORTION', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-17 22:34:14.099891', '2026-07-21 12:22:29.147', 26623, 'pending', 'Shredded Mozzarella & Provolone Cheese, Peeled Ground Tomatoes, 12" Flatbread', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216750, 23505, 'Hard Boiled Egg', 'lunch', 'scraped', 'overridden', 69, 6, 0, 5, '1.5 OZ. PORTION', NULL, NULL, NULL, NULL, '1 egg', false, true, '2026-07-17 22:34:16.979859', '2026-07-21 12:22:26.377305', 34556, 'pending', 'Peeled Hard Cooked Eggs', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216743, 23505, 'Blue Cheese', 'lunch', 'scraped', 'overridden', 160, 10, 1, 13, '1.5 OZ. PORTION', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-17 22:34:16.333779', '2026-07-21 12:22:26.065261', 34574, 'pending', 'Blue Cheese Crumbles', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216713, 23504, 'Strawberry Yogurt', 'lunch', 'scraped', 'overridden', 100, 3, 19, 1, '4 OZ. PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-17 22:34:12.876426', '2026-07-21 12:22:22.158129', 34729, 'pending', 'Strawberry Yogurt ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216718, 23501, 'Grilled Chicken Breast', 'lunch', 'scraped', 'overridden', 209, 38, 0, 5, 'ONE 4 OUUNCE CHICKEN', NULL, NULL, NULL, NULL, '`1 breast (4 oz)', false, true, '2026-07-17 22:34:14.189859', '2026-07-21 12:22:10.611477', 7683, 'pending', 'Salt, Ground Black Pepper, Canola Olive Oil Blend, 4 OZ Chicken Breast Filet', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216749, 23505, 'Cucumber', 'lunch', 'scraped', 'overridden', 6, 0, 1, 0, '1.5 OZ. PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-17 22:34:16.892707', '2026-07-21 12:22:26.325183', 34553, 'pending', 'Fresh Cucumber', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216824, 23503, 'Daily Cut Fruit', 'lunch', 'scraped', 'accepted', 67, 1, 17, 0, 'PTN 3 OZ', NULL, NULL, NULL, NULL, NULL, false, true, '2026-07-17 22:34:33.873778', '2026-07-21 12:21:23.780697', 13711, 'pending', 'Diced Pineapple , Fresh Cantaloupe Chunks, FRUIT HONEYDEW CHUNKS 2/5# , Red Seedless Grapes, Orange Sections ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216825, 23503, 'NY Style Sesame Bagel', 'lunch', 'scraped', 'overridden', 280, 11, 57, 1, '5 oz. BAGEL', NULL, NULL, NULL, NULL, '1 bagel', false, true, '2026-07-17 22:34:33.917727', '2026-07-21 12:21:23.83274', 34495, 'pending', NULL, false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216762, 23505, 'Umami Bomb Tofu', 'lunch', 'scraped', 'overridden', 43, 6, 2, 2, '3 OZ. PORTION', NULL, NULL, NULL, NULL, '3 oz', false, true, '2026-07-17 22:34:18.118609', '2026-07-21 12:22:27.056987', 34546, 'pending', 'Low Sodium Tamari Sauce Gluten Free, Nappa Valley Avocado Oil, Organic Tofu, Pure Vermont Maple Syrup, Grey Poupon Mustard, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216788, 23501, 'Cheese Blintz with Berry Compote', 'breakfast', 'scraped', 'overridden', 210, 4, 27, 3, 'PORTION', NULL, NULL, NULL, NULL, '1 blintz', false, true, '2026-07-17 22:34:31.412331', '2026-07-21 12:21:20.667803', 29234, 'pending', 'BERRY COMPOTE, Cheese Blintz', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216761, 23505, 'Spring Mix Lettuce', 'lunch', 'scraped', 'overridden', 9, 1, 2, 0, 'PORTION', NULL, NULL, NULL, NULL, '2 cups', false, true, '2026-07-17 22:34:18.022563', '2026-07-21 12:22:26.900102', 34545, 'pending', 'Local Hydroponic Spring Mix', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216766, 23501, 'Barbeque Chicken', 'dinner', 'scraped', 'overridden', 277, 22, 20, 11, '6.5 oz portion', NULL, NULL, NULL, NULL, '6 oz', false, true, '2026-07-17 22:34:18.725768', '2026-07-21 12:21:17.395098', 7331, 'pending', 'Bulls Eye Barbeque Sauce, Boneless Skinless Chicken Thighs, 8.2 OZ Chicken Breast , Apple Cider Vinegar, Grey Poupon Mustard, Mesquite BBQ Spice', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216763, 23509, 'Fudge Brownie Cookie', 'lunch', 'scraped', 'overridden', 177, 1, 26, 8, '1 COOKIE', NULL, NULL, NULL, NULL, '1 cookie', false, true, '2026-07-17 22:34:18.20865', '2026-07-21 12:20:03.447059', 35287, 'pending', ' COOKIE BROWNIE BAKE SWEET LOREN''S GF', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216834, 23504, 'Roasted Shelled Sunflower Seed', 'breakfast', 'scraped', 'overridden', 1356, 101, 11, 100, 'Pound', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-17 22:34:34.401805', '2026-07-21 12:22:20.422422', 28621, 'pending', NULL, false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216826, 23503, 'NY Style Plain Bagel', 'lunch', 'scraped', 'overridden', 280, 11, 57, 1, '5 oz. BAGEL', NULL, NULL, NULL, NULL, '1 bagel', false, true, '2026-07-17 22:34:33.961829', '2026-07-21 12:21:23.886497', 34493, 'pending', NULL, false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216823, 23501, 'Grilled Chicken', 'lunch', 'scraped', 'overridden', 112, 21, 0, 3, 'ONE 4 OUUNCE CHICKEN', NULL, NULL, NULL, NULL, '1 breast (4 oz)', false, true, '2026-07-17 22:34:33.758024', '2026-07-21 12:21:23.617227', 27021, 'pending', 'Salt, Ground Black Pepper, Boneless Skinless 4 OZ Chicken Breast, Canola Olive Oil Blend', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216771, 23501, 'Seasoned Zucchini & Summer Squash', 'dinner', 'scraped', 'overridden', 17, 1, 3, 0, '1/2 CUP', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-17 22:34:19.154321', '2026-07-21 12:21:41.364551', 7267, 'pending', 'Fresh Zucchini, Ground White Pepper, Organic Yellow Squash, Salt', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216768, 23501, 'Corn O''Brien', 'dinner', 'scraped', 'overridden', 71, 2, 15, 1, 'SERVING', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-17 22:34:18.906074', '2026-07-21 12:21:17.580657', 7497, 'pending', 'Fresh Peeled Onions, Red Peppers, VEG PEPPERS GREEN LARGE AMBROGI, Whole Kernal Corn', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216827, 23503, 'NY Style Everything Bagel', 'lunch', 'scraped', 'overridden', 280, 11, 57, 1, '5 oz. BAGEL', NULL, NULL, NULL, NULL, '1 bagel', false, true, '2026-07-17 22:34:34.005791', '2026-07-21 12:21:23.942759', 34494, 'pending', NULL, false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216755, 23509, 'Vanilla Soft Serve Ice Cream', 'dinner', 'scraped', 'overridden', 514, 0, 98, 15, '5oz. PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-17 22:34:17.465904', '2026-07-21 12:22:30.349211', 34593, 'pending', 'Vanilla Frostline Ice Cream', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216769, 23501, 'Roasted Cauliflower', 'dinner', 'scraped', 'overridden', 48, 2, 5, 3, 'SERVING 4 OUNCES', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-17 22:34:18.997988', '2026-07-21 12:21:53.210948', 21897, 'pending', 'Sunflower Oil, Kosher Salt, Ground Black Pepper, Fresh Curley Parsley, Cauliflower', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216759, 23505, 'Marinated Artichokes', 'lunch', 'scraped', 'overridden', 173, 1, 5, 16, '3 OZ. PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-17 22:34:17.833921', '2026-07-21 12:22:26.795028', 34550, 'pending', 'Kosher Salt, Lemon Juice, Sunflower Oil, Course Ground Black Pepper, Crushed Red Pepper, Whole Peeled Garlic, Whole Artichoke Hearts', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216764, 23509, 'Chocolate Soft Serve Ice Cream', 'dinner', 'scraped', 'overridden', 514, 0, 98, 15, '5oz. PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-17 22:34:18.309673', '2026-07-21 12:22:30.401744', 34594, 'pending', 'Vanilla Frostline Ice Cream', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216756, 23505, 'Red Onion', 'lunch', 'scraped', 'overridden', 10, 0, 2, 0, '1.5 OZ. PORTION', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-17 22:34:17.556163', '2026-07-21 12:22:26.637901', 34554, 'pending', 'Red Onions', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218269, 23501, 'Crispy Garlic Tofu', 'dinner', 'scraped', 'overridden', 119, 11, 12, 3, 'portion', NULL, NULL, NULL, NULL, '4 oz', false, true, '2026-07-18 11:44:16.970878', '2026-07-21 12:19:51.582481', 29193, 'pending', 'Sesame Seeds, Sesame Seeds, Tamari Gold Soy Sauce Gluten Free, Jalapeno Peppers, Kosher Salt, Non GMO Firm Tofu, Amber Agave Nectar, Corn Starch, Fresh Ginger, Dole Pineapple Juice, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216760, 23505, 'Shredded Carrots', 'lunch', 'scraped', 'overridden', 13, 0, 3, 0, '1.5 OZ. PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-17 22:34:17.932346', '2026-07-21 12:22:26.848093', 34552, 'pending', 'Matchstick Carrots', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216792, 23501, 'Pork Sausage Link', 'breakfast', 'scraped', 'overridden', 121, 9, 0, 9, '2 LINKS', NULL, NULL, NULL, NULL, '1 link', false, true, '2026-07-17 22:34:31.744123', '2026-07-21 12:21:44.830794', 7595, 'pending', 'Allergen Free Vegelene, Pork Sausage Link', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216791, 23501, 'Morning Harvest Burrito', 'breakfast', 'scraped', 'overridden', 132, 6, 17, 6, 'Each', NULL, NULL, NULL, NULL, '1 burrito', false, true, '2026-07-17 22:34:31.654023', '2026-07-21 12:22:19.690505', 34201, 'pending', 'Flour Tortilla , Shredded Vegan Cheddar Cheese, Tofu Scramble', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216828, 23503, 'NY Style Cinnamon Rasin Bagel', 'lunch', 'scraped', 'overridden', 280, 11, 57, 1, '5 oz. BAGEL', NULL, NULL, NULL, NULL, '1 bagel', false, true, '2026-07-17 22:34:34.063165', '2026-07-21 12:21:23.995794', 34496, 'pending', NULL, false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216837, 23504, 'Shell Off Pumkin Seed', 'lunch', 'scraped', 'overridden', 153, 7, 5, 13, 'Ounce', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-17 22:34:34.599801', '2026-07-21 12:21:36.766153', 20407, 'pending', NULL, false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216816, 23501, 'Steamed Broccoli', 'lunch', 'scraped', 'overridden', 34, 3, 6, 0, 'SERVING 3.5 OUNCE', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-17 22:34:33.391839', '2026-07-21 12:21:23.513308', 12163, 'pending', 'Kosher Salt, Broccoli Florets, Ground Black Pepper', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216789, 23501, 'Hash Brown Triangle Patty', 'breakfast', 'scraped', 'overridden', 115, 1, 14, 5, '2 OZ PATTY', NULL, NULL, NULL, NULL, '1 patty', false, true, '2026-07-17 22:34:31.51395', '2026-07-21 12:21:20.719986', 7582, 'pending', 'Hash Brown Potato Patty', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218270, 23501, 'Vegetable Spring Rolls', 'dinner', 'scraped', 'overridden', 207, 3, 38, 5, '3 OZ PORTION', NULL, NULL, NULL, NULL, '1 spring roll', false, true, '2026-07-18 11:44:17.012223', '2026-07-21 12:22:27.66166', 8234, 'pending', 'Duck Sauce, Vegan Spring Roll', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216757, 23505, 'Red Wine Vinegar', 'lunch', 'scraped', 'overridden', 11, 0, 0, 0, '2.OZ. PORTION', NULL, NULL, NULL, NULL, '1 tbsp', false, true, '2026-07-17 22:34:17.655849', '2026-07-21 12:22:26.691359', 34589, 'pending', 'Red Wine Vinegar', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216753, 23505, 'Olive Oil', 'lunch', 'scraped', 'overridden', 78, 0, 0, 9, '2.OZ. PORTION', NULL, NULL, NULL, NULL, '1 tbsp', false, true, '2026-07-17 22:34:17.277825', '2026-07-21 12:22:26.533214', 34587, 'pending', 'Imported Olive Oil', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219336, 23501, 'Toasted Tortilla Chips & Pico De gallo', 'lunch', 'scraped', 'overridden', 413, 7, 60, 18, '1 BOWL', NULL, NULL, NULL, NULL, '10-15 chips (1 oz)', false, true, '2026-07-18 11:44:33.389905', '2026-07-21 12:21:58.600939', 20311, 'pending', 'Hot Salsa Del Sol , White Salted Tortilla Chips', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216754, 23505, 'Olives', 'lunch', 'scraped', 'overridden', 43, 0, 2, 4, '1.5 OZ. PORTION', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-17 22:34:17.369828', '2026-07-21 12:22:26.585351', 34558, 'pending', 'Pitted Black Olives', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216799, 23504, 'Organic Pumpkin Seed', 'breakfast', 'scraped', 'overridden', 1356, 101, 11, 100, 'Pound', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-17 22:34:32.173959', '2026-07-21 12:22:20.265813', 30427, 'pending', NULL, false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216758, 23505, 'Little Leaf Romaine Lettuce', 'lunch', 'scraped', 'overridden', 13, 1, 2, 0, 'Salad', NULL, NULL, NULL, NULL, '2 cups', false, true, '2026-07-17 22:34:17.74087', '2026-07-21 12:22:26.743255', 34683, 'pending', 'Little Leaf Romaine Lettuce ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216871, 23501, 'Sweet and Sour Chicken', 'dinner', 'scraped', 'overridden', 6692, 685, 405, 237, 'recipe', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-17 22:34:36.547858', '2026-07-21 12:21:29.137462', 15436, 'pending', 'La Choy Sweet & Sour Sauce, Roasted Sesame Oil, Stir Fry Mandarin Vegetables, Brown Rice, Chunk Chicken Tempora', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218361, 23501, 'Jasmine Rice', 'lunch', 'scraped', 'overridden', 408, 7, 90, 1, 'SERVING 4 OZ', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:18.595798', '2026-07-21 12:19:54.815333', 8901, 'pending', 'Eco Farmed White Basmati Rice, Water', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219212, 23501, 'Charred Asparagus', 'dinner', 'scraped', 'overridden', 99, 6, 6, 7, '3 oz Portion', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:31.567388', '2026-07-21 12:20:29.265748', 23071, 'pending', 'Alderwood Smoked Salt, Ground Black Pepper, Fresh Pencil Asparagus, Orchid Island Lemon Juice, Shredded Parmesan Cheese, Sunflower Oil', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218330, 23501, 'Breakfast Sandwich', 'breakfast', 'scraped', 'overridden', 652, 39, 42, 35, 'Sandwich', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-18 11:44:17.892378', '2026-07-21 12:21:56.24675', 23542, 'pending', 'Cooper Sharp Cheese, Pork Sausage Patty, Pasture Raised Brown Eggs, Thomas''s English Muffin', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216872, 23501, 'Sticky Rice', 'dinner', 'scraped', 'overridden', 301, 6, 66, 0, 'SERVING 4 OZ', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-17 22:34:36.657821', '2026-07-21 12:22:27.557477', 9044, 'pending', 'Kosher Salt, Sushi Rice, Water', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218441, 23501, 'Roast Turkey with Gravy', 'dinner', 'scraped', 'overridden', 176, 36, 1, 2, '5 OUNCE SERVING', NULL, NULL, NULL, NULL, '5 oz', false, true, '2026-07-18 11:44:19.886438', '2026-07-21 12:19:57.718203', 19713, 'pending', 'Turkey Breast, Turkey Gravy', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216870, 23501, 'Sweet & Sour Pork', 'dinner', 'scraped', 'overridden', 231, 7, 28, 10, '6 OZ SERVING', NULL, NULL, NULL, NULL, '6 oz', false, true, '2026-07-17 22:34:36.449859', '2026-07-21 12:21:29.085524', 7400, 'pending', 'Rice Wine Vinegar, Red Peppers, Sunflower Oil, Suntan Peppers, Tamari Gold Soy Sauce Gluten Free, Pineapple Tidbits, Pork Cubes, Ground White Pepper, Ground Ginger, Corn Starch, Clear Gel Starch, Crushed Red Pepper, Fresh Peeled Onions, Granulated Lite Brown Sugar, Dole Pineapple Juice, VEG PEPPERS YELLOW 11 LBS AMBROGI', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218527, 23506, 'Coconut Green Soup with Kale & Ginger', 'lunch', 'scraped', 'overridden', 138, 2, 8, 12, '12 oz. PORTION', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:21.251724', '2026-07-21 12:19:36.29094', 34475, 'pending', 'Cumin Powder, Coconut Milk, Chopped Green Kale, Fresh Zucchini, Fresh Peeled Shallots, Fresh Ginger, Fresh Celery, Imported Olive Oil, Ground Coriander , Lime Juice, Red Delicious Apples, Roasted Chickpeas, Vegetable Stock Base', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218363, 23501, 'Shitaki Mushrooms', 'lunch', 'scraped', 'overridden', 6, 1, 1, 0, '1 oz. PORTION', NULL, NULL, NULL, NULL, '0.25 cup', false, true, '2026-07-18 11:44:18.651637', '2026-07-21 12:19:54.919982', 35190, 'pending', 'Sliced Shitake Mushrooms ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218442, 23501, 'Cranberry Sauce', 'dinner', 'scraped', 'overridden', 144, 0, 35, 0, '1/3 CUP', NULL, NULL, NULL, NULL, '0.25 cup', false, true, '2026-07-18 11:44:19.927218', '2026-07-21 12:19:57.76986', 7379, 'pending', 'Cranberry Sauce', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218438, 23501, 'Corn on the Cob', 'dinner', 'scraped', 'overridden', 147, 5, 35, 1, 'HALF COB 5.5 OUNCES', NULL, NULL, NULL, NULL, '0.5 cob', false, true, '2026-07-18 11:44:19.75811', '2026-07-21 12:19:57.561901', 12089, 'pending', 'Kosher Salt, Corn on the Cob', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217858, 23511, 'Roasted Vegetables', 'dinner', 'scraped', 'overridden', 74, 1, 7, 5, '3 OZ PORTION', NULL, NULL, NULL, NULL, '3 oz', false, true, '2026-07-18 11:44:08.592697', '2026-07-21 12:22:29.772289', 19350, 'pending', 'Dried Oregano Leaf, Fresh Zucchini, Ground Black Pepper, Balsamic Vinegar, Kosher Salt, Red Onions, Red Peppers, Sunflower Oil, Yellow Squash', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218440, 23501, 'Country Mashed Potatoes', 'dinner', 'scraped', 'overridden', 310, 15, 51, 9, 'PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:19.845433', '2026-07-21 12:19:57.666407', 29078, 'pending', 'Hardwood Smoked Pork Bacon, Seasoned Salt, Scallions , Red Skin Wedge Potatoes, Fresh Flat Leaf Italian Parsley, Ground Black Pepper', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218364, 23501, 'Carrots', 'lunch', 'scraped', 'overridden', 10, 0, 2, 0, '1 oz. PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:18.692693', '2026-07-21 12:19:54.971823', 35196, 'pending', 'Shredded Carrots', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218491, 23501, 'Chilaquiles', 'breakfast', 'scraped', 'overridden', 245, 8, 20, 16, '6 oz. PORTION', NULL, NULL, NULL, NULL, '1.5 cups', false, true, '2026-07-18 11:44:20.662527', '2026-07-21 12:21:09.308044', 34457, 'pending', 'Imported Olive Oil, Jalapeno Peppers, Kosher Salt, Grated Cotija Cheese, Eggs to Order, Diced Avocado, Diced Petite Roasted Tomatoes, Crema Mexicana Jose Garces, Chicken Stock, Whole Peeled Garlic, White Salted Tortilla Chips', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218277, 23501, 'Asparagus Spears', 'dinner', 'scraped', 'overridden', 25, 3, 5, 0, '4 oz Portion', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:17.155251', '2026-07-21 12:19:51.843273', 7734, 'pending', 'Ground Black Pepper, Fresh Asparagus, Kosher Salt', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218365, 23501, 'VEGAN SRIRACHA MAYO', 'lunch', 'scraped', 'overridden', 10, 0, 0, 1, '1 OUNCE', NULL, NULL, NULL, NULL, '1 tbsp', false, true, '2026-07-18 11:44:18.735918', '2026-07-21 12:19:55.023815', 29381, 'pending', 'Lime Juice, Sriracha Chili Sauce, Gluten Free Veganaise, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218439, 23501, 'Wild Rice Stuffing', 'dinner', 'scraped', 'overridden', 220, 7, 21, 14, 'PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:19.802912', '2026-07-21 12:19:57.613779', 29858, 'pending', 'Cumin Powder, Cayenne Powder, Brown & Wild Rice Blend, Dried Cherries, Fresh Peeled Onions, GLUTEN FREE VEGETABLE SOUP STOCK, Scallions , Pure Vermont Maple Syrup, Orange Zest, Imported Olive Oil, Unsalted No Shell Pumpkin Seed', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218443, 23501, 'Vegetable Shepherd''s Pie', 'dinner', 'scraped', 'overridden', 131, 4, 19, 5, 'SERVING 6 OUNCES', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:19.969389', '2026-07-21 12:19:57.821646', 11930, 'pending', 'Fresh Eggplant, Diced Tomatoes, Frozen Soybean Shelled Edamame, Cumin Powder, Curry Powder, 5 Way Vegetable Blend, Ground Black Pepper, Salt, Sliced Potatoes, Spanish Onions, Sunflower Oil, Sunflower Oil, Whole Peeled Garlic, Vegan Grated Parmesan Cheese, Unsweetened Organic Soy Milk', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219211, 23501, 'Chicken Adobo', 'dinner', 'scraped', 'overridden', 346, 26, 14, 20, 'Portion', NULL, NULL, NULL, NULL, '4 oz', false, true, '2026-07-18 11:44:31.526346', '2026-07-21 12:20:29.21366', 25987, 'pending', 'Kosher Salt, Canola Oil, Boneless Skinless Chicken Thigh, Bay Leaf, Gluten Free-Wheat Free Soy Sauce, Fresh Peeled Onions, Fresh Ground Black Pepper, Whole Peeled Garlic, White Vinegar, Water', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218360, 23506, 'Black Bean Soup', 'lunch', 'scraped', 'overridden', 10, 0, 1, 1, '6 OZ PORTION', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:18.54824', '2026-07-21 12:19:54.737499', 17364, 'pending', 'Chopped Garlic, Cumin Powder, Black Beans (Low Sodium), Fresh Cilantro, Fresh Celery, Fresh Carrots, Dried Oregano Leaf, Fresh Peeled Onions, Sunflower Oil, Vegetable Stock Base, VEG PEPPERS GREEN LARGE AMBROGI', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218437, 23501, 'Fresh Vegetable Blend', 'dinner', 'scraped', 'overridden', 32, 2, 7, 0, 'SERVING 4 OZ', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:19.711264', '2026-07-21 12:19:57.509457', 18187, 'pending', 'Cauliflower, Fresh Asparagus, Ground Black Pepper, Red Peppers, Kosher Salt, Whole Baby Carrots', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216873, 23501, 'Broccoli with Red Peppers', 'dinner', 'scraped', 'overridden', 47, 3, 7, 2, 'SERVING 4 OZ', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-17 22:34:36.760233', '2026-07-21 12:21:29.242868', 13742, 'pending', 'Broccoli Florets, Ground Black Pepper, Red Peppers, Salt, Sunflower Oil', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216874, 23501, 'Seasoned Brussel Sprouts', 'dinner', 'scraped', 'overridden', 71, 4, 10, 3, '1/2 CUP', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-17 22:34:36.855881', '2026-07-21 12:21:29.295274', 7570, 'pending', 'Salt, Sunflower Oil, Brussel Sprouts', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219213, 23501, 'Garlic Green Beans', 'dinner', 'scraped', 'overridden', 239, 2, 9, 23, 'PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:31.612031', '2026-07-21 12:22:27.453219', 28111, 'pending', 'Kosher Salt, Sunflower Oil, Crushed Red Pepper, Whole Peeled Garlic, Whole Green Beans', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218369, 23501, 'Bulgogi Beef', 'lunch', 'scraped', 'overridden', 101, 4, 11, 5, 'Portion', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:18.80615', '2026-07-21 12:19:55.231425', 26211, 'pending', 'Bulgogi Sauce , Beef Stir Fry Strips', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217027, 23501, 'Grilled Vegetables', 'lunch', 'scraped', 'overridden', 158, 1, 7, 14, 'SERVING-5 OZ', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:43:51.765774', '2026-07-21 12:21:35.951553', 10755, 'pending', 'Fresh Carrots, Fresh Eggplant, Fresh Zucchini, Red Peppers, Red Onions, Sunflower Oil, VEG PEPPERS GREEN LARGE AMBROGI', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217133, 23506, 'Spicy Asian Vegetable Soup', 'lunch', 'scraped', 'overridden', 51, 2, 12, 0, 'PORTION', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:43:53.917392', '2026-07-21 12:21:47.459145', 26515, 'pending', 'GLUTEN FREE VEGETABLE SOUP STOCK, Garlic Powder, Fresh Thai Basil, Fresh Peeled Shallots, Fresh Ginger, Diced Tomatoes, Frank''s Hot Sauce, Coleman Dry Mustard, Shredded Carrots, Scallions , Spanish Paprika, Sliced Shitake Mushrooms , Onion Powder, Nappa Cabbage, Limes, Lemon Grass, Turmeric, Whole Leaf Basil, Whole Peeled Garlic, Whole Thyme', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217085, 23501, 'Roasted Baby Carrots', 'dinner', 'scraped', 'overridden', 80, 1, 8, 6, 'serving', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:43:52.80505', '2026-07-21 12:21:41.312725', 26097, 'pending', 'Sunflower Oil, Peeled Baby Carrots, Kosher Salt, Fresh Thyme', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217152, 23511, 'Summer Turkey Sandwich', 'lunch', 'scraped', 'overridden', 61, 4, 9, 1, 'Ounce', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-18 11:43:54.316464', '2026-07-21 12:20:02.065214', 7986, 'pending', 'Boar''s Head Lo Salt Turkey Breast, 23" Hoagie Roll, Fire Roasted Red Pepper, Fresh Asparagus', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216716, 23501, 'Basmati Rice and White Bean stuffed Pepp', 'lunch', 'scraped', 'overridden', 240, 6, 47, 4, '1 HALF PEPPER', NULL, NULL, NULL, NULL, '0.5 pepper', false, true, '2026-07-17 22:34:13.977999', '2026-07-21 12:21:11.899055', 7505, 'pending', 'Spaghetti Sauce, Sunflower Oil, Ground Black Pepper, Italian Seasoning, Kosher Salt, Broccoli Florets, Cannellini Beans, Chopped Garlic, Fresh Large Green Peppers, Eco Farmed White Basmati Rice, Fresh Peeled Onions, Vegetable Stock Base, V-8 Juice, Whole Peeled Plumb Tomatoes, White Mushrooms', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217136, 23501, 'Green Beans & Mushrooms', 'lunch', 'scraped', 'overridden', 66, 2, 8, 4, '1/2 CUP', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:43:54.017167', '2026-07-21 12:21:47.511175', 7598, 'pending', 'Butter, Salt, Whole Green Beans, White Mushrooms', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217140, 23501, 'Vegan Parm', 'lunch', 'scraped', 'overridden', 822, 53, 130, 9, '5.5 ounce portion', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-18 11:43:54.155444', '2026-07-21 12:21:47.852242', 29486, 'pending', 'Caibatta Roll, Course Ground Black Pepper, General Mills All Purpose Flour, Firm Tofu, EGG SUBSTITUTE VEGAN12/2 LB FRZ JUST EGG, Italian Seasoning, Kosher Salt, Shredded Vegan Mozzarella, Spaghetti Sauce', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217108, 23501, 'Huevos Rancheros', 'breakfast', 'scraped', 'overridden', 223, 13, 3, 17, 'SERVING 4 OZ', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:43:53.41393', '2026-07-21 12:21:44.778917', 13662, 'pending', 'Chili Powder, Cumin Powder, Diced Tomatoes, Diced Green Chili Peppers, Fresh Peeled Onions, Fresh Salsa, Sunflower Oil, Liquid Whole Eggs, Monteray Jack Cheese, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217088, 23501, 'Herb Baked Chicken', 'dinner', 'scraped', 'overridden', 1054, 81, 44, 61, 'PORTIONS', NULL, NULL, NULL, NULL, '1 piece', false, true, '2026-07-18 11:43:52.90331', '2026-07-21 12:21:41.546645', 7682, 'pending', '8.2 OZ Chicken Breast , Chicken Thighs Bone In Skin On, Fresh Basil, Frresh Rosemary, Fresh Tarragon, Fresh Thyme, Fresh Oregano, Salt, Sunflower Oil', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217107, 23570, 'Maple Syrup', 'breakfast', 'scraped', 'overridden', 7, 0, 2, 0, '2 oz. PORTION', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-18 11:43:53.367743', '2026-07-21 12:21:44.596528', 34011, 'pending', 'Maple Flavored Pancake Syrup', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217038, 23506, 'Tomato Soup', 'lunch', 'scraped', 'overridden', 228, 11, 33, 7, 'Portion', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:43:51.949482', '2026-07-21 12:21:36.18715', 29689, 'pending', 'Imported Olive Oil, Peeled Ground Tomatoes, Fine Grind Kosher Salt, Fresh Peeled Onions, Vegetable Stock Base', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217138, 23501, 'Philly Cheesesteak Sandwich', 'lunch', 'scraped', 'overridden', 591, 43, 26, 34, '1 STEAK', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-18 11:43:54.102008', '2026-07-21 12:22:22.916441', 7759, 'pending', 'Fried Onions , Cheese Whiz Sauce, Cooper Sharp Cheese, Liscio - Steak Roll Sliced, Sliced Beef Steak', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216989, 23501, 'Crispy Bacon', 'lunch', 'scraped', 'overridden', 377, 27, 1, 28, 'PORTION', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:43:51.038881', '2026-07-21 12:21:35.845961', 22207, 'pending', 'Applewood Smoked Bacon', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217083, 23501, 'Homemade Meatloaf', 'dinner', 'scraped', 'overridden', 288, 24, 11, 16, 'SERVING 5 OUNCES', NULL, NULL, NULL, NULL, '5 oz', false, true, '2026-07-18 11:43:52.713739', '2026-07-21 12:21:41.208367', 7484, 'pending', 'Ground Black Pepper, Kosher Salt, Meatloaf Ketchup Glaze, Liquid Whole Eggs, Fresh Peeled Onions, Ground Beef, Cayenne Powder, Bread Crumbs, 1% Milk from WAWA in 20 Qt Dispenser', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216765, 23501, 'Au Gratin Potatoes', 'dinner', 'scraped', 'overridden', 245, 9, 29, 11, '6 oz Portion', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-17 22:34:18.637888', '2026-07-21 12:21:17.342469', 7502, 'pending', 'Butter, Bread Crumbs, Bechamel Sauce, Ground Black Pepper, Salt, Sharp Yellow Cheddar Cheese Loaf, Shredded Parmesan Cheese, Sliced Potatoes', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217052, 23511, 'Turkey Sandwich on White Bread', 'lunch', 'scraped', 'overridden', 173, 16, 15, 5, 'HALF SANDWICH 3.5 OZ', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-18 11:43:52.152149', '2026-07-21 12:20:17.272772', 21808, 'pending', 'Green Leaf Lettuce Filets, Arnold Country White Sliced Bread, Provolone Grande Cheese, Turkey Breast', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217137, 23501, 'Chicken Parmesan', 'lunch', 'scraped', 'overridden', 609, 47, 53, 21, 'PORTION', NULL, NULL, NULL, NULL, '1 piece (5 oz)', false, true, '2026-07-18 11:43:54.061259', '2026-07-21 12:21:47.641873', 33748, 'pending', 'Sunflower Oil, Spaghetti Sauce, Liquid Eggs, Plain Panko Bread Crumbs, All Purpose Flour, Whole Milk Shredded Mozzarella Cheese, Tyson No Antibiotic 5 OZ Chicken Breast', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217037, 23501, 'Penne Portobella Casserole', 'lunch', 'scraped', 'overridden', 187, 6, 13, 12, 'PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:43:51.900875', '2026-07-21 12:21:35.429288', 26524, 'pending', 'Penne Pasta, Local Sliced Portabello Mushrooms, Kosher Salt, Imported Olive Oil, Tamari Gold Soy Sauce Gluten Free, Shredded Mozzarella Cheddar Blend Cheese, 2 % Milk in 20 QT Dispenser, Course Ground Black Pepper, Chopped Spinach, Whole Leaf Basil, Whole Peeled Garlic, White flour and canola roux', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217134, 23501, 'Baked Ziti', 'lunch', 'scraped', 'overridden', 461, 22, 67, 11, 'Portion 10 OUNCES', NULL, NULL, NULL, NULL, '1.5 cups', false, true, '2026-07-18 11:43:53.965657', '2026-07-21 12:21:47.276139', 7538, 'pending', 'Grated Parmesan Cheese, Salt, Shredded Mozzarella & Provolone Cheese, Soprafina Whole Milk Ricotta Cheese, Trattoria  Spaghetti Sauce, Ziti Pasta', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216991, 23501, 'Tater Tot Puffs', 'breakfast', 'scraped', 'overridden', 229, 3, 28, 11, 'SERVING 4 OZ', NULL, NULL, NULL, NULL, '10-12 pieces', false, true, '2026-07-18 11:43:51.137704', '2026-07-21 12:22:19.742432', 7534, 'pending', 'Tater Nugget', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216990, 23501, 'Nova Cinnamon Roll', 'breakfast', 'scraped', 'overridden', 506, 6, 77, 18, 'PORTION', NULL, NULL, NULL, NULL, '3 rolls', false, true, '2026-07-18 11:43:51.094926', '2026-07-21 12:21:32.633405', 29714, 'pending', 'Cinnamon Roll Dough, Vanilla Cream Icing', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217084, 23501, 'Mashed Potatoes', 'dinner', 'scraped', 'overridden', 145, 3, 21, 5, '4 OZ PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:43:52.762843', '2026-07-21 12:21:41.260649', 10193, 'pending', 'Salt, Sour Cream, Ground White Pepper, Hash Brown Cubes, Butter, 2 % Milk in 20 QT Dispenser', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217070, 23511, 'Gluten & Dairy Free Turkey Sandwich', 'lunch', 'scraped', 'overridden', 263, 23, 28, 6, 'SANDWICH 6  OZ', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:43:52.371665', '2026-07-21 12:20:17.455483', 21796, 'pending', 'Fresh Sliced Tomato, Green Leaf Lettuce Filets, Gluten Free 12" Hoagie Roll, Turkey Breast', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217087, 23501, 'Macaroni & Cheese', 'dinner', 'scraped', 'overridden', 105, 4, 13, 4, '4 oz Portion', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:43:52.86207', '2026-07-21 12:21:41.416679', 20441, 'pending', 'Elbow Macaroni, Cayenne Powder, Cheddar Cheese & Colby Sauce, Coleman Dry Mustard, Course Ground Black Pepper, Bechamel Sauce, Shredded Mild Yellow Cheddar Cheese, Kosher Salt', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217106, 23570, 'French Toast Sticks', 'breakfast', 'scraped', 'overridden', 274, 5, 39, 12, '4 Sticks', NULL, NULL, NULL, NULL, '4 sticks', false, true, '2026-07-18 11:43:53.318617', '2026-07-20 12:59:54.930683', 7364, 'pending', 'French Toast Sticks, Powdered Sugar', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217332, 23501, 'Creamy Spinach Tortellini', 'lunch', 'scraped', 'overridden', 577, 18, 89, 16, '6 OUNCE PORTION', NULL, NULL, NULL, NULL, '1.5 cups', false, true, '2026-07-18 11:43:58.408191', '2026-07-21 12:22:10.793689', 8216, 'pending', 'Fresh Spinach, Cheese Tortellini, Ground Black Pepper, Imported Grated Parmesan Cheese, Heavy Cream Quart, Sunflower Oil, Salt, Red Onions, Whole Peeled Garlic, Whole Leaf Basil, VEG TOMATO SLICED AMBROGI', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217199, 23501, 'Hashbrown Potatoes', 'breakfast', 'scraped', 'overridden', 128, 1, 21, 3, '4 oz Portion', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:43:55.408312', '2026-07-21 12:21:56.194606', 7886, 'pending', 'Sunflower Oil, Hash Brown Potatoes', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216767, 23501, 'Mushroom Bean Bourguignon', 'dinner', 'scraped', 'overridden', 170, 9, 26, 2, 'PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-17 22:34:18.816025', '2026-07-21 12:21:17.448629', 29841, 'pending', 'Peeled Carrot, Pearl Onions, Portabello Mushroom Caps, Imported Olive Oil, Fresh Thyme, Fresh Peeled Onions, GLUTEN FREE VEGETABLE SOUP STOCK, Dry Navy Beans, Course Ground Black Pepper, CORN STARCH SLURRY, Big Tatoo Red Wine, Tomato Paste, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217331, 23501, 'Cous Cous with Roasted Vegetables', 'lunch', 'scraped', 'overridden', 85, 3, 11, 4, '4 oz Serving', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:43:58.367227', '2026-07-21 12:22:10.663757', 11816, 'pending', 'Chopped Garlic, Cumin Powder, Cous Cous, Crimini Mushrooms, Fresh Cilantro, Grape tomato, Ground Black Pepper, Fresh Zucchini, Organic Yellow Squash, Meyer Lemon Juice, Kosher Salt, Sunflower Oil, Red Peppers, Red Kidney Beans, Red Onions', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217230, 23501, 'Barley with Eggplant & Sundried Tomatoes', 'lunch', 'scraped', 'overridden', 196, 6, 40, 6, '6 OUNCE PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:43:56.078268', '2026-07-21 12:18:56.018229', 8213, 'pending', 'Salt, Red Onions, Sunflower Oil, Pearl Barley, Ground Black Pepper, Jersey Tomatoes, Julienne Sundried Tomatoes, Fresh Celery, Fresh Eggplant, Green Peas, VEG PEPPERS GREEN LARGE AMBROGI', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217184, 23501, 'Steak Diane', 'dinner', 'scraped', 'overridden', 281, 21, 9, 17, 'SERVING', NULL, NULL, NULL, NULL, '4 oz', false, true, '2026-07-18 11:43:54.919808', '2026-07-21 12:21:53.052603', 29055, 'pending', 'Imported Olive Oil, Kosher Salt, Beef Stock with Soup Base, Brandy Concentrate, Butter, Course Ground Black Pepper, Crimini Mushrooms, Fresia D;Asti Italian Red, Fresh Peeled Shallots, Dijon Mustard 8 Oz OG2, Flank Steak, Whole Peeled Garlic, Worcestershire Sauce ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217246, 23501, 'Hamburger', 'lunch', 'scraped', 'overridden', 524, 43, 21, 28, 'BURGER', NULL, NULL, NULL, NULL, '1 burger', false, true, '2026-07-18 11:43:56.375004', '2026-07-21 12:19:43.027891', 27309, 'pending', '5.3 OZ Beef Burgers , Hamburger Roll', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217298, 23501, 'Pork Sausage Patties', 'breakfast', 'scraped', 'overridden', 144, 8, 0, 12, 'SERVING 1.5 OZ PATTY', NULL, NULL, NULL, NULL, '1 patty', false, true, '2026-07-18 11:43:57.651229', '2026-07-21 12:22:08.093308', 7561, 'pending', 'Pork Sausage Patty', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217281, 23501, 'Roasted Carrots', 'dinner', 'scraped', 'overridden', 96, 1, 15, 4, 'SERVING 6 OZ', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:43:56.992735', '2026-07-21 12:22:04.513607', 13678, 'pending', 'Fresh Curley Parsley, Ground Black Pepper, Peeled Carrot, Salt, Sunflower Oil', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217182, 23501, 'White Beans & Lentils in Tomato Sauce', 'dinner', 'scraped', 'overridden', 106, 7, 20, 1, '4oz Serving', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:43:54.834917', '2026-07-21 12:21:52.794326', 29096, 'pending', 'Kosher Salt, Italian Flat Leaf Parsley, Cayenne Powder, Canola Olive Oil Blend, Chopped Garlic, Ground Black Pepper, Fresh Tomatoes, Fresh Peeled Onions, Fresh Israeli Basil, Dry French Green Lentils, White Kidney Beans', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217287, 23501, 'General Tso Chicken', 'dinner', 'scraped', 'overridden', 189, 28, 4, 7, '6 OZ PORTION', NULL, NULL, NULL, NULL, '6 oz', false, true, '2026-07-18 11:43:57.297193', '2026-07-21 12:22:04.981802', 11396, 'pending', 'General Tso''s Sauce, Broccoli Florets, Crushed Red Pepper, CHICKEN CHUNK TEMPURA 2/5 LB NOVICK FRZ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217189, 23504, 'Grilled Pita', 'dinner', 'scraped', 'overridden', 53, 1, 5, 3, '4 OZ. PORTION', NULL, NULL, NULL, NULL, '1 pita', false, true, '2026-07-18 11:43:55.04245', '2026-07-21 12:21:53.366615', 34416, 'pending', 'Fresh Curley Parsley, Fresh Dill, Imported Olive Oil, Kosher Salt, Lemon Zest, White Pita Bread', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217236, 23501, 'Hot Dog', 'lunch', 'scraped', 'overridden', 304, 9, 25, 18, '1 SANDWICH', NULL, NULL, NULL, NULL, '1 hot dog', false, true, '2026-07-18 11:43:56.242621', '2026-07-21 12:21:00.957838', 7271, 'pending', 'Beverages, Beef Hot Dog, Hot Dog Roll, Kosher Pickle Spears , Yellow Mustard PC', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217196, 23501, 'Scrapple', 'breakfast', 'scraped', 'overridden', 140, 14, 4, 8, 'Each', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:43:55.343399', '2026-07-21 12:21:56.087831', 7493, 'pending', 'Allergen Free Vegelene, Pork Scrapple', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217233, 23501, 'Open Face Roasted Beef Sandwich', 'lunch', 'scraped', 'overridden', 261, 23, 17, 11, 'SANDWICH', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-18 11:43:56.173255', '2026-07-21 12:18:56.176354', 7622, 'pending', 'Challah Bread, Brown Gravy, White American Cheese Sauce, Whole Rodemary , Top Round of Beef', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217299, 23501, 'Potatoes O''Brien', 'breakfast', 'scraped', 'overridden', 118, 3, 18, 4, '4 oz Portion', NULL, NULL, NULL, NULL, '0.75 cup', false, true, '2026-07-18 11:43:57.694756', '2026-07-21 12:22:08.144927', 7588, 'pending', 'Fresh Peeled Onions, Red Peppers, Sunflower Oil, Hash Brown Cubes, VEG PEPPERS GREEN LARGE AMBROGI', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217326, 23501, 'Waffle Fries', 'lunch', 'scraped', 'overridden', 257, 3, 41, 14, 'SERVING', NULL, NULL, NULL, NULL, '10-15 pieces', false, true, '2026-07-18 11:43:58.181063', '2026-07-21 12:19:02.320051', 7808, 'pending', 'Waffle Cut Fried Potatoes', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217328, 23501, 'Steamed Carrots', 'lunch', 'scraped', 'overridden', 41, 1, 10, 0, '4 oz Serving', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:43:58.27093', '2026-07-21 12:22:10.508067', 23216, 'pending', 'Ground Black Pepper, Peeled Carrot, Kosher Salt', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217280, 23501, 'Veggie Lo Mein', 'dinner', 'scraped', 'overridden', 116, 4, 17, 4, '6 OZ SERVING', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:43:56.948256', '2026-07-21 12:22:04.461018', 7499, 'pending', 'Oriental Stir Fry Vegetables, Lo Mein Noodle, Stir Fry Sauce, Sunflower Oil, Fresh Local Organic Tofu, Fresh Carrots, Broccoli Florets, Whole Peeled Garlic, VEG PEPPERS GREEN LARGE AMBROGI', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217185, 23501, 'Crisply Roasted Potatoes', 'dinner', 'scraped', 'overridden', 127, 2, 24, 3, '4 oz Serving', NULL, NULL, NULL, NULL, '0.75 cup', false, true, '2026-07-18 11:43:54.962065', '2026-07-21 12:20:42.647634', 23276, 'pending', 'Kosher Salt, Sunflower Oil, Ground Black Pepper, Frresh Rosemary, Whole Peeled Garlic, White Potatoes', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217283, 23501, 'Asian Vegetable Blend', 'dinner', 'scraped', 'overridden', 37, 1, 6, 0, '1 SERVING', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:43:57.123787', '2026-07-21 12:22:04.722088', 7989, 'pending', 'Stir Fry Mandarin Vegetables', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217229, 23506, 'Chicken Noodle Soup', 'lunch', 'scraped', 'overridden', 59, 4, 8, 1, '8 OZ BOWL', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:43:56.029402', '2026-07-21 12:21:58.731646', 7424, 'pending', 'Chicken, Chicken Stock, Bay Leaf, Fresh Peeled Onions, Fresh Celery, Fresh Curley Parsley, Egg Noodles, Peeled Carrot, Ground White Pepper, Kosher Salt, Sage, Sunflower Oil, Whole Thyme', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217231, 23501, 'Fresh Vegetable Medley', 'dinner', 'scraped', 'overridden', 36, 3, 7, 0, '4 OZ PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:43:56.120134', '2026-07-21 12:20:19.514458', 9372, 'pending', 'Broccoli Florets, Cauliflower, Ground Black Pepper, Salt, Red Peppers, Snow Peas', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217285, 23501, 'Vegetable Spring Roll', 'dinner', 'scraped', 'overridden', 44, 1, 7, 2, '2 each', NULL, NULL, NULL, NULL, '1 spring roll', false, true, '2026-07-18 11:43:57.21847', '2026-07-21 12:18:59.477115', 21680, 'pending', NULL, false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217329, 23506, 'Vegetable Barley Soup', 'lunch', 'scraped', 'overridden', 16, 0, 3, 0, 'Bowl 6 OUNCES', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:43:58.31169', '2026-07-21 12:22:10.455776', 18307, 'pending', 'Diced Tomatoes, Fresh Celery, Fresh Zucchini, Fresh Sage, Fresh Peeled Onions, Chopped Garlic, Salt, Sunflower Oil, Peeled Carrot, Pearl Barley, Parsnip, Organic Yellow Squash, Leaf Spinach, Ground Black Pepper, Vegetable Stock Base, Yukon Gold Potatoes', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217423, 23506, 'Carrot & Red Pepper Soup', 'lunch', 'scraped', 'overridden', 117, 2, 21, 3, 'Bowl', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:00.201463', '2026-07-21 12:22:21.710288', 18300, 'pending', 'Peeled Carrot, Sunflower Oil, Spanish Onions, Salt, Red Peppers, Dole 100% Orange Juice, Eco Farrmed Brown Basmati Rice, Fresh Curley Parsley, Fresh Dill, Ground Black Pepper, Vegetable Stock Base', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217400, 23501, 'Breakfast Egg Burrito', 'breakfast', 'scraped', 'overridden', 315, 19, 15, 19, 'WRAP', NULL, NULL, NULL, NULL, '1 burrito', false, true, '2026-07-18 11:43:59.729817', '2026-07-21 12:22:19.638557', 7576, 'pending', 'Mild Tostito Salsa , Liquid Whole Eggs, Sharp Yellow Cheddar Cheese Loaf, 10" Flour Tortilla', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217482, 23501, 'Buddha''s Delight', 'dinner', 'scraped', 'overridden', 74, 4, 14, 0, 'Serving 6 OUNCES', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:01.559019', '2026-07-21 12:22:27.505335', 20581, 'pending', 'Spanish Onion, Red Peppers, Gluten Free-Wheat Free Soy Sauce, Fresh Ginger, Fresh Carrots, Chopped Garlic, Cabbage, Cauliflower, VEG PEPPERS GREEN LARGE AMBROGI', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217450, 23501, 'Cheesesteak Sandwich', 'lunch', 'scraped', 'overridden', 267, 18, 14, 15, 'STEAK', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-18 11:44:00.950523', '2026-07-21 12:21:00.795693', 10622, 'pending', 'Sliced Land O Lakes American Cheese, Sliced Beef Steak, Club Roll', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217377, 23501, 'Roasted Brussels Sprouts', 'dinner', 'scraped', 'overridden', 111, 4, 10, 8, 'SERVING 4 OUNCES', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:43:59.13344', '2026-07-21 12:22:15.846313', 19621, 'pending', 'Ground Black Pepper, Balsamic Vinegar, Brussel Sprouts, Sunflower Oil, Kosher Salt', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217486, 23501, 'Kung Pao Chicken', 'dinner', 'scraped', 'overridden', 146, 23, 2, 5, 'PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:01.70261', '2026-07-21 12:22:27.713477', 28073, 'pending', 'Fresh Ginger, Granulated Sugar, Fresno Chili Peppers, Chicken Stock, Chicken, Corn Starch, Sunflower Oil, Tamari Gold Soy Sauce Gluten Free, Regina Sherry Cooking Wine, Red Wine Vinegar, Scallions , Kosher Salt', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217436, 23501, 'Roasted Red Pepper Falafel', 'lunch', 'scraped', 'overridden', 164, 5, 27, 4, 'SERVING 4 ounces', NULL, NULL, NULL, NULL, '3 pieces', false, true, '2026-07-18 11:44:00.469899', '2026-07-21 12:22:22.341818', 15757, 'pending', 'Chick Peas, Cayenne Powder, Cumin Powder, Chopped Garlic, Coriander Powder, Gluten Free Rice Flour, Ground Black Pepper, Sunflower Oil, Roasted Sweet Red Peppers, Roasted Sesame Oil, Salt, Shredded Lettuce, Tzatziki Sauce, VEG TOMATO FRSH DICED 2/5 LB AMBROGI, White Pita Pocket', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217444, 23501, 'White Rice', 'lunch', 'scraped', 'overridden', 93, 2, 19, 1, '4 oz Serving', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:00.757912', '2026-07-21 12:22:22.654908', 7670, 'pending', 'Salt, Long Grain White Rice, Water', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217378, 23501, 'Carne Asada', 'dinner', 'scraped', 'accepted', 1238, 49, 157, 41, 'PORTION', NULL, NULL, NULL, NULL, NULL, false, true, '2026-07-18 11:43:59.178115', '2026-07-21 12:22:15.900302', 15721, 'pending', 'Salt, Salsa Fresca, Shredded Monterey Jack Cheese, Guacamole Pico De Gallo, Ground Black Pepper, Cumin Powder, 10" Flour Tortilla, Flank Steak', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217334, 23501, 'BBQ Pulled Chicken Sandwich', 'lunch', 'scraped', 'overridden', 512, 39, 63, 11, 'SANDWICH', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-18 11:43:58.467158', '2026-07-21 12:19:02.795221', 8035, 'pending', 'Bulls Eye Barbeque Sauce, Battered Onion Straws, Hamburger Roll, Pulled Cooked Pulled White Meat Chicken ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217496, 23501, 'Mainline Chick''n  Breakfast Biscuit', 'breakfast', 'scraped', 'overridden', 430, 22, 49, 13, 'PORTION', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-18 11:44:02.042885', '2026-07-21 12:19:13.679358', 29676, 'pending', 'Cheddar Cheese Slices, Crinkle Cut Dill Pickles, Main line Chicken Tenders, Southern Biscuit Dough', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217485, 23501, 'Vegetarian Egg Roll', 'dinner', 'scraped', 'overridden', 140, 4, 21, 5, '1 EGGROLL', NULL, NULL, NULL, NULL, '1 eggroll', false, true, '2026-07-18 11:44:01.658172', '2026-07-21 12:22:04.825967', 7354, 'pending', 'HORS VEGETABLE EGGROLL CKD FRZ US', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217435, 23501, 'SWEET AND SPICY KOREAN CHICKEN', 'lunch', 'scraped', 'overridden', 79, 9, 3, 3, 'PORTION', NULL, NULL, NULL, NULL, '4 oz', false, true, '2026-07-18 11:44:00.428177', '2026-07-21 12:22:22.289152', 33135, 'pending', 'Dark Brown Sugar, CHICKEN CHUNK TEMPURA 2/5 LB NOVICK FRZ, Gochujang Sauce, Imported Sesame Oil, Honey Squeeze Bottle, Low Sodium Tamari Sauce Gluten Free, Sunflower Oil, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217445, 23501, 'Shredded Romain', 'lunch', 'scraped', 'overridden', 9, 1, 2, 0, '2 Oz. PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:00.802058', '2026-07-21 12:22:22.707072', 34830, 'pending', 'Little Leaf Romaine Lettuce ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216993, 23501, 'French Toast Sticks', 'lunch', 'scraped', 'overridden', 274, 5, 39, 12, '4 Sticks', NULL, NULL, NULL, NULL, '4 sticks', false, true, '2026-07-18 11:43:51.191958', '2026-07-21 12:21:35.298748', 7364, 'pending', 'French Toast Sticks, Powdered Sugar', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217452, 23501, 'E.O.S. CUCUMBERS', 'lunch', 'scraped', 'overridden', 9, 0, 2, 0, 'PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:01.008874', '2026-07-21 12:22:23.021177', 32380, 'pending', 'Granulated Sugar, Fresh Cucumber, Kosher Salt, Lime Juice', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217424, 23506, 'Chicken Rice Soup', 'lunch', 'scraped', 'overridden', 57, 4, 8, 1, '8 oz Portion', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:00.247766', '2026-07-21 12:19:08.836323', 7425, 'pending', 'Sunflower Oil, Salt, Ground Black Pepper, Fresh Carrots, Fresh Celery, Fresh Peeled Onions, Bay Leaf, Basmati Rice, Chicken Stock, Chicken', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217441, 23501, 'Green Sauce', 'lunch', 'scraped', 'overridden', 261, 1, 2, 29, 'PORTION', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-18 11:44:00.631347', '2026-07-21 12:22:22.498733', 33139, 'pending', 'Morton Kosher Salt, Lime Juice, Imported Olive Oil, Sliced Hot Jalapeno Peppers, Ground Black Pepper, Fresh Cilantro, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217437, 23501, 'STREET CORN', 'lunch', 'scraped', 'overridden', 131, 2, 16, 8, 'Serving', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:00.514573', '2026-07-21 12:22:22.394276', 33137, 'pending', 'Shoepeg Corn, Lime Juice, Kraft Extra Heavy Mayonaise, Gluten Free Tamari Sauce, Fresh Cilantro', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217447, 23501, 'Cheddar Cheese', 'lunch', 'scraped', 'overridden', 228, 13, 2, 19, '2 Oz. PORTION', NULL, NULL, NULL, NULL, '0.25 cup', false, true, '2026-07-18 11:44:00.854326', '2026-07-21 12:22:22.759044', 34831, 'pending', 'Shredded Cheddar Cheese', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217434, 23501, 'White Sauce', 'lunch', 'scraped', 'overridden', 202, 1, 5, 20, 'PORTION', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-18 11:44:00.38385', '2026-07-21 12:22:22.236401', 33138, 'pending', 'Ground Black Pepper, Hellman''s Mayonnaise, Heavy Cultured Sour Cream, Morton Kosher Salt, White Vinegar, White Granulated Cane Sugar', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217382, 23501, 'Mexicali Corn', 'dinner', 'scraped', 'overridden', 81, 3, 16, 2, 'SERVING', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:43:59.292579', '2026-07-21 12:22:16.211524', 7481, 'pending', 'Cumin Powder, Ground Black Pepper, Fresh Peeled Onions, Kosher Salt, Red Peppers, Sunflower Oil, Whole Kernal Corn, VEG PEPPERS GREEN LARGE AMBROGI', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217439, 23501, 'KOREAN BBQ CHICKEN', 'lunch', 'scraped', 'overridden', 334, 14, 28, 19, 'PORTION', NULL, NULL, NULL, NULL, '4 oz', false, true, '2026-07-18 11:44:00.571274', '2026-07-21 12:22:22.446919', 33134, 'pending', 'KOREAN BBQ SAUCE , Boneless Skinless Chicken Thigh', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217448, 23501, 'Pico de Gallo', 'lunch', 'scraped', 'overridden', 34, 0, 4, 2, '2 OZ SERVING', NULL, NULL, NULL, NULL, '0.25 cup', false, true, '2026-07-18 11:44:00.89887', '2026-07-21 12:22:22.811616', 17838, 'pending', 'Diced Red Onions, Diced Fresh Tomatoes, Fresh Cilantro, Sunflower Oil, Lime Juice, Jalapeno Slices in Brine, Kosher Salt, Ground Black Pepper, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217525, 23504, 'Grapefruit', 'lunch', 'scraped', 'overridden', 29, 0, 8, 0, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:02.376272', '2026-07-21 12:22:23.440465', 34721, 'pending', 'Grapefruit Sections', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217442, 23501, 'BBQ Sauce', 'lunch', 'scraped', 'overridden', 98, 0, 23, 0, 'PORTION', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-18 11:44:00.672427', '2026-07-21 12:22:22.550832', 33140, 'pending', 'Bulls Eye Barbeque Sauce', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217484, 23501, 'Baby Bok Choy', 'dinner', 'scraped', 'overridden', 52, 1, 5, 3, '3 OZ PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:01.613336', '2026-07-21 12:22:27.60977', 18967, 'pending', 'Ground Black Pepper, Baby Bok Choy, Kosher Salt, Sunflower Oil, Tamari Gold Soy Sauce Gluten Free', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217805, 23501, 'Carlos'' Braised Beef', 'dinner', 'scraped', 'overridden', 258, 33, 5, 11, '6 oz Portion', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:07.192559', '2026-07-21 12:19:33.19696', 7301, 'pending', 'Peeled & Quartered Idaho Potatoes, Sunflower Oil, Tamari Gold Soy Sauce Gluten Free, Salt, Fresh Peeled Onions, Fresh Tomatoes, Ground Black Pepper, Chopped Garlic, Beef Shoulder, Bay Leaf, Tomato Puree Extra Heavy, Water', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217183, 23501, 'Zucchini, Squash and Cherry Tomatoes', 'dinner', 'scraped', 'overridden', 40, 1, 4, 3, 'SERVING 4 OUNCE', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:43:54.87589', '2026-07-21 12:21:52.923098', 7585, 'pending', 'Organic Yellow Squash, Peeled Red Onions, Kosher Salt, Ground White Pepper, Sunflower Oil, Cherry Tomatoes, Fresh Zucchini, Fresh Basil', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217856, 23506, 'Hearty Beef Vegetable Soup', 'lunch', 'scraped', 'overridden', 87, 6, 5, 6, '1 CUP', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:08.49811', '2026-07-21 12:19:36.238932', 7419, 'pending', 'Peeled Carrot, Hash Brown Cubes, Salt, Premium Deli Roast Beef, Diced Tomatoes, Fresh Celery, Fresh Peeled Onions, Ground Black Pepper, Beef Stock with Soup Base', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217851, 23504, 'Blueberries', 'lunch', 'scraped', 'overridden', 32, 0, 8, 0, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:08.197059', '2026-07-21 12:22:23.179087', 34724, 'pending', 'Blueberries', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217855, 23506, 'Butternut Squash, Coconut, & Lentil Stew', 'lunch', 'scraped', 'overridden', 268, 5, 35, 13, '12 oz. PORTION', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:08.453354', '2026-07-19 11:48:34.246619', 34477, 'pending', 'Crushed Red Pepper, Cumin Powder, Butternut Squash 1" Cubes, Black Lentil Daal Soup, Black Mustard Seed, Fresh Cilantro, Diced Fresh Tomatoes, Kosher Salt, Honey Squeeze Bottle, Lime Juice, Sunflower Oil, Shredded Coconut Sweetened , Whole Peeled Garlic, Vegetable Stock Base, Turmeric', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217859, 23501, 'RAMEN BROTH', 'lunch', 'scraped', 'overridden', 78, 3, 3, 6, 'PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:08.634448', '2026-07-21 12:19:36.503612', 29419, 'pending', 'Fresh Ginger, GLUTEN FREE VEGETABLE SOUP STOCK, Crushed Red Pepper, Imported Olive Oil, Imported Sesame Oil, Tamari Gold Soy Sauce Gluten Free, Rice Wine Vinegar, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217850, 23504, 'Raspberries', 'lunch', 'scraped', 'overridden', 29, 1, 7, 0, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:08.081387', '2026-07-21 12:22:23.074701', 34723, 'pending', 'Fresh Raspberries ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217582, 23501, 'Sesame Roasted Sweet Potatoes', 'dinner', 'scraped', 'overridden', 164, 3, 18, 9, 'portion', NULL, NULL, NULL, NULL, '0.75 cup', false, true, '2026-07-18 11:44:03.535281', '2026-07-21 12:19:18.977634', 25590, 'pending', 'Extra Virgin Olive Oil, Fresh Cilantro, Course Ground Black Pepper, Chili Powder, Cayenne Powder, Roasted Sesame Oil, Sesame Seeds, Sweet Potatoes, Tahini Paste, Kosher Salt', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217636, 23501, 'Whole Green Beans', 'lunch', 'scraped', 'overridden', 13, 1, 3, 0, '2 ounce portion', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:04.490567', '2026-07-21 12:20:08.306665', 7735, 'pending', 'Kosher Salt, Ground Black Pepper, Whole Green Beans', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217808, 23501, 'Herbed Green Beans', 'dinner', 'scraped', 'overridden', 60, 1, 6, 4, '1/2 CUP', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:07.253635', '2026-07-21 12:19:33.353176', 7597, 'pending', 'Fresh Peeled Onions, Fresh Basil, Fresh Celery, Butter, Cut Green Beans, Whole Peeled Garlic, Whole Rodemary ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217857, 23501, 'RAMEN CHICKEN', 'lunch', 'scraped', 'overridden', 120, 26, 0, 1, 'PORTION', NULL, NULL, NULL, NULL, '4 oz', false, true, '2026-07-18 11:44:08.544284', '2026-07-21 12:19:36.371261', 29420, 'pending', 'Pulled Cooked Pulled White Meat Chicken , Kosher Salt, Ground Black Pepper', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217532, 23501, 'Garlic Mashed Potatoes', 'lunch', 'scraped', 'overridden', 151, 4, 20, 6, '4 OUNCE PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:02.708031', '2026-07-21 12:19:15.977048', 9443, 'pending', 'Salt, Ground Black Pepper, Hash Brown Cubes, Butter, 2% Milk Half Gallon, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217089, 23501, 'Edamame White Bean Stew', 'dinner', 'scraped', 'overridden', 305, 10, 33, 17, 'SERVING 6 OZ', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:43:52.946894', '2026-07-21 12:21:41.598481', 13690, 'pending', 'Diced Tomatoes, Fresh Oregano, Frozen Soybean Shelled Edamame, Cannellini Beans, Sunflower Oil, Shoepeg Corn, Salt, Lemon Pepper, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217533, 23501, 'Penne Pasta with Marinara Sauce', 'lunch', 'scraped', 'overridden', 234, 8, 45, 2, '4 oz Serving', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:02.750427', '2026-07-21 12:19:16.029428', 21781, 'pending', 'Kosher Salt, Penne Rigate Pasta, Trattoria  Spaghetti Sauce', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217697, 23501, 'Roasted Fingerling Potatoes with Basil', 'dinner', 'scraped', 'overridden', 179, 3, 19, 11, 'SERVING 4 OUNCE', NULL, NULL, NULL, NULL, '0.75 cup', false, true, '2026-07-18 11:44:05.48582', '2026-07-21 12:19:26.26726', 21451, 'pending', 'Local Leigh High Gold Fingerling Potato, Kosher Salt, Purple Fingerling Potatoes, Sunflower Oil, Ground Black Pepper, Fresh Basil', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217694, 23501, 'Sauteed Yellow Squash', 'dinner', 'scraped', 'overridden', 42, 1, 3, 3, '4 oz Serving', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:05.358904', '2026-07-21 12:20:12.171207', 23868, 'pending', 'Ground Black Pepper, Fresh Curley Parsley, Organic Yellow Squash, Kosher Salt, Sunflower Oil', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217539, 23501, 'Portabella Mushroom Pizza', 'lunch', 'scraped', 'overridden', 239, 13, 11, 16, '1 MUSHROOM 6 OZ', NULL, NULL, NULL, NULL, '1 portabella mushroom pizza', false, true, '2026-07-18 11:44:02.848048', '2026-07-21 12:19:16.368933', 9001, 'pending', 'Course Ground Black Pepper, Artichoke Heart, Balsamic Vinegar, Fresh Mozzarella Cheese Balls, Fire Roasted Red Pepper, Dried Oregano Leaf, Portabello Mushroom Caps, Pesto Sauce Without Pine Nuts, Kosher Salt, Sliced Olives', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217581, 23501, 'Honey Glazed Salmon', 'dinner', 'scraped', 'overridden', 229, 23, 4, 13, 'Portion', NULL, NULL, NULL, NULL, '1 fillet (4 oz)', false, true, '2026-07-18 11:44:03.492841', '2026-07-21 12:19:18.925169', 24832, 'pending', 'Honey Squeeze Bottle, Kosher Salt, Chickien Stock, CORN STARCH SLURRY, Atlantic Salmon 4 OZ Filet, Ground Black Pepper', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217817, 23501, 'Migas', 'breakfast', 'scraped', 'overridden', 185, 9, 19, 15, '5 oz. PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:07.591334', '2026-07-21 12:20:21.151882', 34454, 'pending', 'Course Ground Black Pepper, Fresh Peeled Onions, Kosher Salt, Jalapeno Peppers, Imported Olive Oil, Plum Tomato, Liquid Eggs, Shredded Mild Yellow Cheddar Cheese, Scallions , Tri Colored Tortilla Strips', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217647, 23504, 'Vanilla Yogurt', 'lunch', 'scraped', 'overridden', 64, 6, 9, 0, '4 OZ. PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:04.67547', '2026-07-21 12:19:30.658037', 34728, 'pending', 'Vanilla Yogurt', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217695, 23501, 'Chicken Marsala', 'dinner', 'scraped', 'overridden', 155, 26, 3, 4, 'SERVING 4 OZ', NULL, NULL, NULL, NULL, '1 piece (4 oz)', false, true, '2026-07-18 11:44:05.400494', '2026-07-21 12:19:26.160804', 13327, 'pending', '4 OZ Chicken Breast Filet, MARSALA SAUCE', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217530, 23506, 'French Onion Soup', 'lunch', 'scraped', 'overridden', 96, 3, 5, 5, '8 oz Portion', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:02.652581', '2026-07-21 12:19:15.873103', 7571, 'pending', 'Fresh Peeled Onions, Fresh Thyme, Sunflower Oil, Shredded Parmesan Cheese, Regina Cooking Burgundy, Ground Black Pepper, Kosher Salt, Vegetable Stock Base', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217643, 23502, 'Housemade Jams of the Week', 'lunch', 'scraped', 'overridden', 32, 0, 7, 0, '2 oz. PORTION', NULL, NULL, NULL, NULL, '1 tbsp', false, true, '2026-07-18 11:44:04.594984', '2026-07-21 12:19:22.958552', 35125, 'pending', 'Frozen Mixed Berries', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217849, 23504, 'Strawberries', 'lunch', 'scraped', 'overridden', 27, 1, 7, 0, '3 OZ. PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:08.039777', '2026-07-21 12:22:23.335815', 34722, 'pending', 'Strawberries', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217820, 23501, 'Texas French Toast', 'breakfast', 'scraped', 'overridden', 188, 11, 17, 8, '2 SLICE', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:44:07.655049', '2026-07-21 12:22:08.301204', 7883, 'pending', 'BREAD CHALLAH TEXAS TOAST, French Toast Batter', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217696, 23501, 'Creamed Spinach (veg)', 'dinner', 'scraped', 'overridden', 29, 1, 3, 1, 'Portion', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:05.445048', '2026-07-21 12:19:26.213587', 26821, 'pending', 'GLUTEN FREE VEGETABLE SOUP STOCK, Fresh Peeled Onions, Course Ground Black Pepper, Chopped Spinach, Clear Gel Starch, Kosher Salt, Sunflower Oil, Whole Peeled Garlic, Unsweetened Organic Soy Milk', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217909, 23511, 'Multigrain Bread', 'dinner', 'scraped', 'overridden', 151, 7, 27, 2, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:44:10.548087', '2026-07-21 12:22:28.860382', 34540, 'pending', 'Arnold Mulit Grain Healthy Sliced Bread', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217901, 23511, 'Cheddar Cheese', 'dinner', 'scraped', 'overridden', 167, 11, 0, 14, '3 OZ. PORTION', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:44:10.207775', '2026-07-21 12:22:29.407161', 34525, 'pending', 'Cheddar Cheese Slices', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217902, 23511, 'Brown Spicy Mustard', 'dinner', 'scraped', 'overridden', 60, 4, 4, 4, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '1 tsp', false, true, '2026-07-18 11:44:10.251699', '2026-07-21 12:22:29.512625', 34535, 'pending', 'Guldens Spicy Brown Mustard', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217905, 23511, 'Country White Bread', 'dinner', 'scraped', 'overridden', 38, 2, 7, 0, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:44:10.377605', '2026-07-21 12:22:28.078241', 34538, 'pending', 'Arnold Country White Sliced Bread', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217886, 23511, 'Red Wine Vinegar', 'dinner', 'scraped', 'overridden', 11, 0, 0, 0, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '1 tbsp', false, true, '2026-07-18 11:44:09.57329', '2026-07-21 12:22:28.496905', 34529, 'pending', 'Red Wine Vinegar', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217862, 23501, 'Udon Noodles', 'lunch', 'scraped', 'overridden', 385, 0, 75, 2, '4 OZ. PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:08.734916', '2026-07-21 12:19:36.634527', 34793, 'pending', 'Udon Noodle', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217889, 23511, 'Dill Pickles', 'dinner', 'scraped', 'overridden', 5, 0, 1, 0, '1.5 OZ. PORTION', NULL, NULL, NULL, NULL, 'Pickle Slices', false, true, '2026-07-18 11:44:09.698115', '2026-07-21 12:22:28.653136', 34519, 'pending', 'Dill Pickle Slice', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217868, 23501, 'Red Cabbage', 'lunch', 'scraped', 'overridden', 8, 0, 2, 0, '1 oz. PORTION', NULL, NULL, NULL, NULL, '0.25 cup', false, true, '2026-07-18 11:44:08.924882', '2026-07-21 12:19:36.948906', 34794, 'pending', 'Red Cabbage', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217891, 23511, 'Pepper Jack Cheese', 'dinner', 'scraped', 'overridden', 202, 12, 2, 16, '3 OZ. PORTION', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:44:09.783058', '2026-07-21 12:22:28.757065', 34516, 'pending', 'Pepper Jack Cheese Loaf', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217893, 23511, 'Hot Sauce', 'dinner', 'scraped', 'overridden', 6, 0, 1, 0, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '1 tsp', false, true, '2026-07-18 11:44:09.86862', '2026-07-21 12:22:28.912868', 34533, 'pending', 'Frank''s Hot Sauce', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217875, 23501, 'Bok Choy', 'lunch', 'scraped', 'overridden', 3, 0, 1, 0, '1 oz. PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:09.095838', '2026-07-21 12:19:37.395375', 34795, 'pending', 'Bok Choy', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217892, 23511, 'Olive Oil', 'dinner', 'scraped', 'overridden', 2977, 0, 0, 331, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '1 tbsp', false, true, '2026-07-18 11:44:09.827132', '2026-07-21 12:22:28.808748', 34528, 'pending', 'Canola Oil & X Virgin Olive Oil Blend', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (220457, 23570, 'Texas French Toast', 'breakfast', 'scraped', 'overridden', 188, 11, 17, 8, '2 SLICE', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:44:49.532228', '2026-07-21 12:21:44.544619', 7883, 'pending', 'BREAD CHALLAH TEXAS TOAST, French Toast Batter', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217878, 23511, 'Vegan Option : Falafel', 'dinner', 'scraped', 'overridden', 53, 3, 11, 1, 'SERVING 4 ounces', NULL, NULL, NULL, NULL, '3 pieces', false, true, '2026-07-18 11:44:09.261782', '2026-07-21 12:22:29.927929', 30982, 'pending', 'Vegan Falafel', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217867, 23501, 'Scallions', 'lunch', 'scraped', 'overridden', 9, 1, 2, 0, '1 oz. PORTION', NULL, NULL, NULL, NULL, '1 tbsp', false, true, '2026-07-18 11:44:08.884127', '2026-07-21 12:19:36.896576', 34798, 'pending', 'Diced Scallions', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217895, 23511, 'Honey Mustard', 'dinner', 'scraped', 'overridden', 301, 0, 9, 30, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-18 11:44:09.953085', '2026-07-21 12:22:29.016831', 34530, 'pending', 'Honey Mustard Dressing', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217888, 23511, 'Provolone Cheese', 'dinner', 'scraped', 'overridden', 299, 22, 2, 23, '3 OZ. PORTION', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:44:09.657358', '2026-07-21 12:22:28.600747', 34513, 'pending', 'Provolone Grande Cheese', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217883, 23511, 'Sweet Peppers', 'dinner', 'scraped', 'overridden', 3, 0, 1, 0, '.5 oz. PORTION', NULL, NULL, NULL, NULL, 'sweet peppers', false, true, '2026-07-18 11:44:09.445183', '2026-07-21 12:22:28.34171', 34531, 'pending', 'Red & Green Sweet Pepper Strips', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217882, 23511, 'Domestic Swiss Cheese', 'dinner', 'scraped', 'overridden', 334, 23, 1, 26, '3 OZ. PORTION', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:44:09.404239', '2026-07-21 12:22:28.289699', 34510, 'pending', 'Swiss Cheese', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217906, 23511, 'Country Wheat Bread', 'dinner', 'scraped', 'overridden', 226, 11, 40, 3, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:44:10.421062', '2026-07-21 12:22:28.129992', 34539, 'pending', 'Arnold Country Wheat Sliced Bread', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217904, 23511, 'American Cheese', 'dinner', 'scraped', 'overridden', 152, 8, 2, 12, '3 OZ. PORTION', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:44:10.336781', '2026-07-21 12:22:29.668399', 34514, 'pending', 'Sliced Land O Lakes American Cheese', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217864, 23501, 'Shredded Carrots', 'lunch', 'scraped', 'overridden', 10, 0, 2, 0, '1 oz. PORTION', NULL, NULL, NULL, NULL, '0.25 cup', false, true, '2026-07-18 11:44:08.788064', '2026-07-21 12:19:36.73951', 34797, 'pending', 'Shredded Carrots', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217899, 23511, 'Green Leaf Lettuce', 'dinner', 'scraped', 'overridden', 2, 0, 0, 0, '.5 oz. PORTION', NULL, NULL, NULL, NULL, 'lettuce', false, true, '2026-07-18 11:44:10.121552', '2026-07-21 12:22:29.302874', 34520, 'pending', 'Local Green Leaf Lettuce', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217876, 23511, 'House Made Hummus', 'dinner', 'scraped', 'overridden', 81, 2, 7, 5, 'PORTION 2OZ.', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-18 11:44:09.137266', '2026-07-21 12:22:29.823972', 34500, 'pending', 'House Made Hummus', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217884, 23511, 'Genoa Salami', 'dinner', 'scraped', 'overridden', 222, 11, 2, 19, '3 OZ. PORTION', NULL, NULL, NULL, NULL, '3 oz', false, true, '2026-07-18 11:44:09.488192', '2026-07-21 12:22:28.393583', 34517, 'pending', 'Deli Genoa Salami', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217898, 23511, 'Dijon Mustard', 'dinner', 'scraped', 'overridden', 15, 2, 2, 2, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '1 tsp', false, true, '2026-07-18 11:44:10.080563', '2026-07-21 12:22:29.250851', 34527, 'pending', 'Grey Poupon Mustard', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217908, 23511, 'Hoagie Roll', 'dinner', 'scraped', 'overridden', 158, 6, 28, 2, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '1 roll', false, true, '2026-07-18 11:44:10.506506', '2026-07-21 12:22:30.032065', 34542, 'pending', '8" Hoagie Roll', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217885, 23511, 'Roast Beef', 'dinner', 'scraped', 'overridden', 117, 18, 0, 5, '3 OZ. PORTION', NULL, NULL, NULL, NULL, '3 oz', false, true, '2026-07-18 11:44:09.529078', '2026-07-21 12:22:28.445312', 34512, 'pending', 'Deli Beef Top Round', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217873, 23501, 'Steak Fries', 'lunch', 'scraped', 'overridden', 252, 4, 46, 6, '6 oz. PORTION', NULL, NULL, NULL, NULL, '10-15 pieces', false, true, '2026-07-18 11:44:09.04158', '2026-07-21 12:19:49.103312', 34841, 'pending', 'Steak Cut French Fried Potato', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217900, 23511, 'Fresh Mozzarella Cheese', 'dinner', 'scraped', 'overridden', 210, 15, 3, 15, '3 OZ. PORTION', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:44:10.16628', '2026-07-21 12:22:29.354984', 34524, 'pending', 'Fresh Mozzarella Log Sliced', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217887, 23511, 'Sliced Red Onion', 'dinner', 'scraped', 'overridden', 5, 0, 1, 0, '.5 oz. PORTION', NULL, NULL, NULL, NULL, 'red onion slices', false, true, '2026-07-18 11:44:09.614132', '2026-07-21 12:22:28.548577', 34521, 'pending', 'Red Onions', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217938, 23501, 'Carrot, Broccoli and Cauliflower Medley', 'dinner', 'scraped', 'overridden', 40, 2, 7, 1, '1/2 CUP', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:11.11344', '2026-07-21 12:19:39.459811', 7408, 'pending', 'Broccoli Florettes, Cauliflower, Ground Black Pepper, Fresh Carrots, Kosher Salt', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217896, 23511, 'Domestic Ham', 'dinner', 'scraped', 'overridden', 78, 13, 2, 3, '3 OZ. PORTION', NULL, NULL, NULL, NULL, '3 oz', false, true, '2026-07-18 11:44:09.996811', '2026-07-21 12:22:29.068967', 34511, 'pending', 'Lo Salt Boneless Smoked Ham', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (220459, 23570, 'Pancakes', 'breakfast', 'scraped', 'overridden', 89, 2, 17, 1, '2 PANCAKES', NULL, NULL, NULL, NULL, '1 pancake', false, true, '2026-07-18 11:44:49.552401', '2026-07-21 12:21:44.648477', 7535, 'pending', 'Allergen Free Vegelene, Robby''s Pancake Mix, Water', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217890, 23511, 'Pesto Sauce', 'dinner', 'scraped', 'overridden', 8, 0, 0, 1, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-18 11:44:09.742006', '2026-07-21 12:22:28.704923', 34534, 'pending', 'Pesto Sauce Without Pine Nuts', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217894, 23511, 'Hot Peppers', 'dinner', 'scraped', 'overridden', 3, 0, 1, 0, '.5 oz. PORTION', NULL, NULL, NULL, NULL, 'hot peppers', false, true, '2026-07-18 11:44:09.912026', '2026-07-21 12:22:28.964681', 34532, 'pending', 'Hot Red & Green Cherry Peppers', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217865, 23501, 'Shitaki Mushroom', 'lunch', 'scraped', 'overridden', 6, 1, 1, 0, '1 oz. PORTION', NULL, NULL, NULL, NULL, '0.25 cup', false, true, '2026-07-18 11:44:08.830047', '2026-07-21 12:19:36.792208', 34796, 'pending', 'Sliced Shitake Mushrooms ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217897, 23511, 'Grilled Chicken', 'dinner', 'scraped', 'overridden', 88, 17, 2, 2, '3 OZ. PORTION', NULL, NULL, NULL, NULL, '3 oz', false, true, '2026-07-18 11:44:10.037408', '2026-07-21 12:22:29.199074', 34523, 'pending', 'Rotisserie Chicken ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217869, 23501, 'Pad Thai Noodles', 'lunch', 'scraped', 'overridden', 137, 5, 23, 3, '4 OZ. PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:08.969302', '2026-07-21 12:19:37.079982', 34792, 'pending', 'Pad Thai Rice Noodles', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217903, 23511, 'Bacon', 'dinner', 'scraped', 'overridden', 51, 5, 0, 6, '.5 OZ. PORTION', NULL, NULL, NULL, NULL, '2 slices', false, true, '2026-07-18 11:44:10.293732', '2026-07-21 12:22:29.564671', 34536, 'pending', 'Hormel Crisp Bacon', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218192, 23501, 'French Dip Sandwich with Au Jus', 'lunch', 'scraped', 'overridden', 267, 35, 11, 9, '7 OZ SANDWICH', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-18 11:44:15.817072', '2026-07-21 12:19:48.947532', 7559, 'pending', 'Salt, Ground Black Pepper, Club Roll, Beef Stock with Soup Base, Beef Top Round, Whole Rodemary ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218102, 23501, 'London Broil', 'dinner', 'scraped', 'overridden', 222, 30, 0, 10, '4 OZ SERVING', NULL, NULL, NULL, NULL, '4 oz', false, true, '2026-07-18 11:44:14.268062', '2026-07-21 12:19:45.462172', 7429, 'pending', 'A1 Steak Sauce, Bay Leaf, Fresh Peeled Onions, Ground Black Pepper, Grey Poupon Mustard, Kosher Salt, London Broil Tri Tips, Red Wine Vinegar, Sunflower Oil, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217877, 23511, 'Chickpea Salad', 'dinner', 'scraped', 'overridden', 255, 6, 11, 19, 'SANDWICH', NULL, NULL, NULL, NULL, '3 oz', false, true, '2026-07-18 11:44:09.181945', '2026-07-21 12:22:29.876163', 29679, 'pending', 'Red Onions, Roasted Shelled Sunflower Seed, Meyer Lemon Juice, Organic Garbanzo Beans, Kosher Salt, Course Ground Black Pepper, California Baby Arugula, Cherry Tomatoes, Dijon Mustard, Fresh Dill, Gluten Free Veganaise', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218104, 23501, 'Capri Vegetables', 'dinner', 'scraped', 'overridden', 27, 1, 6, 0, '4 ounce', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:14.351625', '2026-07-21 12:19:45.566149', 15381, 'pending', 'Cut Green Beans, Ground Black Pepper, Steamed Julienne Carrots, Kosher Salt', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218103, 23501, 'Broccoli Rabe with Garlic', 'lunch', 'scraped', 'overridden', 35, 3, 3, 2, 'SERVING 4 OZ', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:14.309046', '2026-07-21 12:21:23.409488', 13743, 'pending', 'Sunflower Oil, Kosher Salt, Broccoli Rabe, Crushed Red Pepper, Ground Black Pepper, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218032, 23506, 'Caramelized Onion Soup', 'lunch', 'scraped', 'overridden', 56, 1, 7, 2, '8 OZ CUP', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:12.938596', '2026-07-21 12:19:42.846078', 18140, 'pending', 'Kosher Salt, Ground Black Pepper, Sunflower Oil, Regina Cooking Burgundy, Browning Sauce, Fresh Thyme, Fresh Peeled Onions, Vegetable Soup Base (vegan), Water', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217944, 23501, 'Braised Pork Loin', 'dinner', 'scraped', 'overridden', 204, 21, 1, 12, '5 oz Serving', NULL, NULL, NULL, NULL, '5 oz', false, true, '2026-07-18 11:44:11.295922', '2026-07-19 11:48:35.310024', 26217, 'pending', 'Rice Wine Vinegar, Smoked Paprika, Kosher Salt, Pork Loin, Extra Virgin Olive Oil, Cumin Powder, Coriander Powder, Chopped Garlic, Caraway Seed, Turmeric, Whole Thyme, Water', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218161, 23501, 'Spinach Feta Breakfast Wrap', 'breakfast', 'scraped', 'overridden', 328, 16, 41, 11, '6 oz. wrap', NULL, NULL, NULL, NULL, '1 wrap', false, true, '2026-07-18 11:44:15.247477', '2026-07-21 12:20:46.276917', 34455, 'pending', 'Spinach Herb Tortilla Wrap, Liquid Egg Whites, Onion Powder, Julienne Sundried Tomatoes, Kosher Salt, Garlic Powder, Greek Yogurt Cream Cheese Loaf, Feta Cheese Block, Course Ground Black Pepper, Baby Spinach, Tomato Paste', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218030, 23501, 'Hawaiian Chicken Skewers', 'lunch', 'scraped', 'overridden', 152, 15, 12, 5, '5oz. Portion', NULL, NULL, NULL, NULL, '1 skewer', false, true, '2026-07-18 11:44:12.853649', '2026-07-19 11:48:36.512814', 34445, 'pending', 'Bulls Eye Barbeque Sauce, Crushed Red Pepper, Chicken Breast, Green Bell Peppers, Fresh Ginger, Fresh Cilantro, Pineapple Chunks, Low Sodium Tamari Sauce Gluten Free, Honey Squeeze Bottle, Imported Sesame Oil, Rice Wine Vinegar, Red Onions, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218158, 23501, 'Pancakes', 'breakfast', 'scraped', 'overridden', 89, 2, 17, 1, '2 PANCAKES', NULL, NULL, NULL, NULL, '1 pancake', false, true, '2026-07-18 11:44:15.185173', '2026-07-21 12:22:19.794', 7535, 'pending', 'Allergen Free Vegelene, Robby''s Pancake Mix, Water', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218195, 23506, 'Spicy Carrot & Red Lentil Soup', 'lunch', 'scraped', 'overridden', 212, 8, 26, 10, '12 oz. PORTION', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:15.88516', '2026-07-21 12:19:48.817045', 34476, 'pending', 'Split Red Lentils, Tahini Paste, Lime Juice, Low Sodium Tamari Sauce Gluten Free, OIL SESAME IMPRTD 61 Z PACIFIC JADE US, Peeled Carrot, Imported Olive Oil, Kosher Salt, Fresh Cilantro, Fresh Peeled Onions, Coriander Powder, Cumin Powder, Crushed Red Pepper, Course Ground Black Pepper, Vegetable Stock Base, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217947, 23501, 'Lemon Roasted Potatoes', 'dinner', 'scraped', 'overridden', 106, 2, 21, 2, 'PORTION 4 OZ.', NULL, NULL, NULL, NULL, '0.75 cup', false, true, '2026-07-18 11:44:11.398511', '2026-07-21 12:19:39.879741', 30860, 'pending', 'Kosher Salt, Italian Seasoning, Imported Olive Oil, Meyer Lemon Juice, Chopped Garlic, Course Ground Black Pepper, White Potatoes', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217983, 23511, '100% Whole Grain Bread', 'dinner', 'scraped', 'overridden', 9, 0, 2, 0, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:44:11.789225', '2026-07-21 12:22:29.720185', 34541, 'pending', '100% Wheat Whole Grain Sliced Bread', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218033, 23501, 'Brown Rice', 'lunch', 'scraped', 'overridden', 126, 3, 26, 1, '4 OZ PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:13.369215', '2026-07-19 11:48:36.541409', 12088, 'pending', 'Eco Farrmed Brown Basmati Rice, Kosher Salt, Water', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218029, 23506, 'Cream of Broccoli Soup', 'lunch', 'scraped', 'overridden', 149, 5, 19, 6, '8 oz Serving', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:12.806524', '2026-07-21 12:19:42.794135', 10546, 'pending', 'Ground Black Pepper, Fresh Peeled Onions, Chicken Stock, Broccoli Florets, Butter, All Purpose Flour, 2 % Milk in 20 QT Dispenser, Kosher Salt', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218105, 23501, 'Baked Potato', 'dinner', 'scraped', 'overridden', 241, 5, 56, 0, 'POTATO 1O OUNCES', NULL, NULL, NULL, NULL, '1 potato', false, true, '2026-07-18 11:44:14.392427', '2026-07-21 12:21:52.74237', 7555, 'pending', 'Kosher Salt, Fresh Idaho Potato', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217989, 23501, 'Mushroom Quiche', 'breakfast', 'scraped', 'overridden', 149, 6, 11, 9, '1 SLICE', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:44:12.099982', '2026-07-21 12:20:34.140846', 18581, 'pending', 'Liquid Whole Eggs, Sliced Land O Lakes American Cheese, Sliced Mushrooms, 9" Pie Shell', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217940, 23501, 'Sugar Snap Peas w.Roasted Red Peppers', 'dinner', 'scraped', 'overridden', 72, 3, 9, 3, 'SERVING 4 OZ', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:11.206714', '2026-07-21 12:19:39.565999', 13591, 'pending', 'Roasted Red Pepper, Salt, Sunflower Oil, Sugar Snap Peas, Ground Black Pepper', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217990, 23501, 'Quiche Florentine', 'breakfast', 'scraped', 'overridden', 316, 12, 20, 21, 'SERVING ONE SLIC', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:44:12.142784', '2026-07-21 12:20:34.192726', 18579, 'pending', 'Swiss Cheese, Sunflower Oil, Quiche Mix, Roasted Red Pepper, 9" Pie Shell, Baby Spinach, Fresh Peeled Onions', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217399, 23501, 'Taylor Ham', 'breakfast', 'scraped', 'overridden', 166, 10, 0, 14, '2 SLICES', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:43:59.687637', '2026-07-21 12:22:19.586587', 8023, 'pending', 'Allergen Free Vegelene, Pork Roll', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218031, 23501, 'Chipotle Tofu & Pineapple Skewer', 'lunch', 'scraped', 'overridden', 112, 5, 11, 6, '5 oz. PORTION', NULL, NULL, NULL, NULL, '1 skewer', false, true, '2026-07-18 11:44:12.897911', '2026-07-19 11:48:36.522545', 34444, 'pending', 'Imported Olive Oil, Hot Chipotle Pepper, Pineapple Chunks, Dried Oregano Leaf, Fresh Peeled Onions, Achiote Paste, Whole Peeled Garlic, White Vinegar, White Granulated Cane Sugar, TOFU BULK XFIRM 12/16 OZ X FIRM SYSCO', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217939, 23501, 'Zucchini Fritter', 'dinner', 'scraped', 'overridden', 128, 4, 15, 6, 'SERVING 4 ounces', NULL, NULL, NULL, NULL, '1 fritter', false, true, '2026-07-18 11:44:11.163634', '2026-07-21 12:19:39.513345', 29840, 'pending', 'Chopped Garlic, Chick Peas, Ground Black Pepper, Gluten Free Rice Flour, Fresh Zucchini, Sunflower Oil, Salt, Old Bay Seasoning', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217991, 23501, 'Bacon and Swiss Quiche', 'breakfast', 'scraped', 'overridden', 413, 19, 18, 30, '1 SLICE', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:44:12.187351', '2026-07-21 12:20:34.245162', 18578, 'pending', 'All Purpose Flour, 2 % Milk GAL, Butter, Salt, Salt, Swiss Cheese, Pork Bacon, Pasture Raised Brown Eggs, Imported Grated Parmesan Cheese, Half & Half Creamer, Water', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218108, 23501, 'Kasha & Vegetable Ragout with Polenta', 'dinner', 'scraped', 'overridden', 107, 3, 21, 1, '8oz Serving', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:14.457098', '2026-07-21 12:19:45.881673', 24444, 'pending', 'Sunflower Oil, Red One Wine, Shitake Mushrooms , Kosher Salt, Italian Style Polenta, Kasha, Fresh Celery, Fresh Carrots, Dried Porcini Mushrooms, Diced Tomatoes, Ground Black Pepper, Fresh Peeled Onions, Frresh Rosemary, Fresh Zucchini, Chopped Garlic, Bread Crumbs, Vegetable Stock Base', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216705, 23504, 'Fresh Berries', 'breakfast', 'scraped', 'accepted', 30, 1, 7, 0, '1 PTN 2.3 OZ', NULL, NULL, NULL, NULL, NULL, false, true, '2026-07-17 22:34:12.119888', '2026-07-21 12:22:20.526366', 13587, 'pending', 'Strawberries, Blueberries, Blackberries , Fresh Raspberries ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216684, 23501, 'Western Scrambled Eggs', 'breakfast', 'scraped', 'overridden', 154, 11, 2, 10, 'SERVING', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-17 22:34:09.677832', '2026-07-17 23:14:40.343279', 18552, 'pending', 'Liquid Whole Eggs, Red Peppers, Sunflower Oil, Diced Green Peppers, Diced Onion, VEG TOMATO FRSH DICED 2/5 LB AMBROGI', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216699, 23503, 'Assorted  Cereal', 'breakfast', 'scraped', 'accepted', 243, 4, 50, 4, 'PORT', NULL, NULL, NULL, NULL, NULL, false, true, '2026-07-17 22:34:11.530386', '2026-07-21 12:22:19.975563', 13466, 'pending', 'Golden Grahams Cereal, Cheerios Cereal , Cinnamon Toast Crunch Cereal, Nature Valley Oat & Honey Granola, Kellogg''s Raisin Bran Cereal, Rice Chex Gluten Free Cereal, Rice Crispy Cereal, Special K Cereal With Berries', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216702, 23504, 'Chia Pudding', 'breakfast', 'scraped', 'overridden', 601, 18, 22, 53, '4oz Serving', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-17 22:34:11.839922', '2026-07-21 12:22:20.317967', 32507, 'pending', 'Fine Grind Kosher Salt, Chia Seed , Califia Oat Milk, McCormack Vanilla Extract', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216689, 23502, 'Guacamole', 'breakfast', 'scraped', 'overridden', 85, 0, 8, 6, '2 oz. Portion', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-17 22:34:10.163776', '2026-07-21 12:22:19.18534', 34430, 'pending', 'Mild Guacamole ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218268, 23501, 'Shoyu Chicken', 'dinner', 'scraped', 'overridden', 384, 40, 31, 10, 'PORTION', NULL, NULL, NULL, NULL, '1 piece (4 oz)', false, true, '2026-07-18 11:44:16.930086', '2026-07-21 12:19:51.530211', 29192, 'pending', 'Fresh Ginger, 4 OZ Chicken Breast Filet, Bud Light Beer, Light Unsulphured Molasses, Light Brown Granulated Sugar, Imported Olive Oil, Tamari Gold Soy Sauce Gluten Free, Rice Wine Vinegar, Scallions , Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216690, 23502, 'Whipped Butter', 'breakfast', 'scraped', 'overridden', 407, 1, 0, 46, '2 oz. Portion', NULL, NULL, NULL, NULL, '1 tbsp', false, true, '2026-07-17 22:34:10.259915', '2026-07-21 12:22:19.237778', 34429, 'pending', 'Whipped Butter', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216695, 23502, 'NY Style Everything Bagel', 'breakfast', 'scraped', 'overridden', 280, 11, 57, 1, '5 oz. BAGEL', NULL, NULL, NULL, NULL, '1 bagel', false, true, '2026-07-17 22:34:10.709915', '2026-07-21 12:22:19.396136', 34494, 'pending', 'Everything Bagel', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216707, 23504, 'Honeydew Melon', 'lunch', 'scraped', 'overridden', 20, 0, 5, 0, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-17 22:34:12.323827', '2026-07-21 12:22:23.388528', 34717, 'pending', 'FRUIT HONEYDEW CHUNKS 2/5# ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216693, 23502, 'NY Style Plain Bagel', 'breakfast', 'scraped', 'overridden', 280, 11, 57, 1, '5 oz. BAGEL', NULL, NULL, NULL, NULL, '1 bagel', false, true, '2026-07-17 22:34:10.526071', '2026-07-21 12:22:19.343988', 34493, 'pending', 'Plain Bagel', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216688, 23502, 'Whipped Cream Cheese', 'breakfast', 'scraped', 'overridden', 162, 3, 3, 16, '2 oz. Portion', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-17 22:34:10.075878', '2026-07-21 12:22:19.133536', 34428, 'pending', 'Whipped Cream Cheese', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216687, 23501, 'Tofu Scramble', 'breakfast', 'scraped', 'overridden', 94, 5, 11, 5, 'Serving', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-17 22:34:09.957937', '2026-07-21 12:22:19.846041', 21144, 'pending', 'Sunflower Oil, Sliced Mushrooms, Spanish Onions, Kosher Salt, Fresh Local Organic Tofu, Ground Black Pepper, Garlic Powder, Baby Spinach, VEG PEPPERS GREEN LARGE AMBROGI', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216697, 23502, 'NY Style Cinnamon Rasin Bagel', 'breakfast', 'scraped', 'overridden', 280, 11, 57, 1, '5 oz. BAGEL', NULL, NULL, NULL, NULL, '1 bagel', false, true, '2026-07-17 22:34:10.899864', '2026-07-21 12:22:19.506672', 34496, 'pending', 'Cinnamon Bagel', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216709, 23504, 'Pineapple', 'lunch', 'scraped', 'overridden', 29, 0, 8, 0, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-17 22:34:12.513965', '2026-07-21 12:22:23.126734', 34719, 'pending', 'Pineapple Chunks', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216698, 23503, 'Assorted Muffins & Loaf Cakes', 'breakfast', 'scraped', 'accepted', 191, 3, 25, 9, 'Each', NULL, NULL, NULL, NULL, NULL, false, true, '2026-07-17 22:34:11.445239', '2026-07-21 12:22:19.923798', 21944, 'pending', 'Blueberry Muffin Batter, Blueberry Muffin Batter, Chocolate Chip Muffin Batter', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216696, 23502, 'NY Style Sesame Bagel', 'breakfast', 'scraped', 'overridden', 280, 11, 57, 1, '5 oz. BAGEL', NULL, NULL, NULL, NULL, '1 bagel', false, true, '2026-07-17 22:34:10.809858', '2026-07-21 12:22:19.448535', 34495, 'pending', 'Sesame Bagel', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216692, 23501, 'Scrambled Eggs', 'breakfast', 'scraped', 'overridden', 177, 15, 0, 11, 'SERVING 4 OZ', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-17 22:34:10.439913', '2026-07-21 12:22:20.160348', 7884, 'pending', 'Ground Black Pepper, Canola Olive Oil Blend, Liquid Whole Eggs, Kosher Salt', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216694, 23501, 'Scrambled Egg Whites', 'breakfast', 'scraped', 'overridden', 17, 3, 0, 0, 'SERVING 4 OZ', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-17 22:34:10.621818', '2026-07-21 12:22:20.213461', 28438, 'pending', 'Allergen Free Vegelene, Liquid Egg Whites', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216704, 23504, '100% Natural Rolled Oatmeal', 'breakfast', 'scraped', 'overridden', 88, 4, 15, 1, '5 OZ BOWL', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-17 22:34:12.031833', '2026-07-21 12:22:20.474231', 7944, 'pending', 'Kosher Salt, Quaker Old Fashioned Rolled Oatmeal, Water', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216682, 23501, 'Turkey Sausage Patties', 'breakfast', 'scraped', 'overridden', 89, 6, 1, 7, '1.5 ounce patty', NULL, NULL, NULL, NULL, '1 patty', false, true, '2026-07-17 22:34:09.471894', '2026-07-21 12:22:08.197377', 19465, 'pending', 'Turkey Sausage Patty', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216708, 23504, 'Cantaloupe Melon', 'lunch', 'scraped', 'overridden', 19, 0, 5, 0, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-17 22:34:12.42022', '2026-07-21 12:22:23.231533', 34718, 'pending', 'Fresh Cantaloupe Chunks', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216711, 23504, 'Greek Yogurt', 'lunch', 'scraped', 'overridden', 71, 6, 8, 2, '4 OZ. PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-17 22:34:12.693762', '2026-07-21 12:22:22.054298', 34726, 'pending', 'Plain Greek Yogurt', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216701, 23504, 'Overnight Oats', 'breakfast', 'scraped', 'overridden', 1127, 39, 183, 28, '10 oz Serving', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-17 22:34:11.734381', '2026-07-21 12:22:20.107607', 30934, 'pending', 'Califia Oat Milk, Golden Quinoa , Kosher Salt, Quaker Quick Rolled Oats', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216691, 23502, 'Housemade Jam', 'breakfast', 'scraped', 'overridden', 32, 0, 7, 0, '2 oz. PORTION', NULL, NULL, NULL, NULL, '1 tbsp', false, true, '2026-07-17 22:34:10.345858', '2026-07-21 12:22:19.290656', 34434, 'pending', 'Frozen Mixed Berries', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218196, 23501, 'Green Goddess Reuben Sandwich', 'lunch', 'scraped', 'overridden', 175, 6, 37, 10, 'Each', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-18 11:44:15.926475', '2026-07-21 12:20:23.383003', 25613, 'pending', 'Avocado Halves, Baby Spinach, 4" Square Focaccia Roll, Crinkle Cut Dill Pickles, Red Onions, Shredded Sauerkraut, Vegan Reuben Dressing, Vegan Mozzarella Cheese Slices', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216683, 23501, 'Breakfast Ham', 'breakfast', 'scraped', 'overridden', 91, 14, 1, 3, 'SERVING 3 OZ', NULL, NULL, NULL, NULL, '3 oz', false, true, '2026-07-17 22:34:09.577939', '2026-07-21 12:21:09.203948', 13281, 'pending', 'Deli Sliced Ham', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216686, 23501, 'Belgian Wafflle', 'breakfast', 'scraped', 'overridden', 85, 2, 11, 4, 'PORTION', NULL, NULL, NULL, NULL, '1 waffle', false, true, '2026-07-17 22:34:09.865845', '2026-07-21 12:19:20.168037', 27403, 'pending', 'Fat Free Waffle Mix, Water', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216700, 23503, 'Hard Boiled Eggs', 'breakfast', 'scraped', 'overridden', 54, 7, 0, 5, '1 EGG', NULL, NULL, NULL, NULL, '1 egg', false, true, '2026-07-17 22:34:11.624258', '2026-07-21 12:22:20.027997', 7453, 'pending', 'Fresh Brown Cage Free Eggs', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216703, 23504, 'House Made Granola', 'breakfast', 'scraped', 'overridden', 105, 3, 17, 3, 'Ounce', NULL, NULL, NULL, NULL, '0.25 cup', false, true, '2026-07-17 22:34:11.933886', '2026-07-21 12:22:20.370406', 18788, 'pending', 'Maple Flavored Syrup, Sunflower Oil, Quaker Quick Rolled Oats, Dark Brown Sugar, Granulated Lite Brown Sugar, Dark Corn Syrup, Earth Balance Buttery Soy Free Sticks, Dried Organic Banana Chips', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216710, 23504, 'Grapes', 'lunch', 'scraped', 'overridden', 39, 0, 10, 0, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-17 22:34:12.612477', '2026-07-21 12:22:23.492246', 34720, 'pending', 'Red Seedless Grapes', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216712, 23504, 'Cottage Cheese', 'lunch', 'scraped', 'overridden', 111, 13, 4, 5, '4 OZ. PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-17 22:34:12.785835', '2026-07-21 12:22:22.106143', 34727, 'pending', '4% Cottage Cheese', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216685, 23501, 'Lyonnaise Potatoes', 'breakfast', 'scraped', 'overridden', 128, 2, 21, 5, '4 oz Portion', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-17 22:34:09.767884', '2026-07-21 12:21:44.939088', 7589, 'pending', 'Kosher Salt, Sunflower Oil, Sliced Potatoes, Fresh Peeled Onions, Ground Black Pepper', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218542, 23501, 'Pepperoni Stromboli', 'lunch', 'scraped', 'overridden', 295, 10, 39, 10, '5.250 oz Portion', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:44:21.712375', '2026-07-21 12:20:01.66923', 21954, 'pending', 'Peeled Ground Tomatoes, PIZZA DOUGH VILLANOVA WHITE 16 OZ, Shredded Mozzarella Cheddar Blend Cheese, Deli Sandwich Style Pepperoni', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218808, 23501, 'Stuffed Grilled Portabello with Harissa', 'dinner', 'scraped', 'overridden', 258, 8, 26, 15, 'portion', NULL, NULL, NULL, NULL, '1 stuffed mushroom', false, true, '2026-07-18 11:44:25.516212', '2026-07-21 12:20:11.898386', 25586, 'pending', 'Extra Virgin Olive Oil, Extra Virgin Olive Oil, Cayenne Powder, Cannellini Beans, Course Ground Black Pepper, Portabello Mushroom Caps, Kosher Salt, Kosher Salt, Harissa sauce, Water', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218809, 23501, 'Roasted Brussels Sprouts with Garlic', 'dinner', 'scraped', 'overridden', 71, 4, 9, 3, 'Serving', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:25.56491', '2026-07-21 12:20:11.950949', 20517, 'pending', 'Kosher Salt, Sunflower Oil, Chopped Garlic, Brussel Sprouts', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218531, 23501, 'Cauliflower with Red Peppers', 'lunch', 'scraped', 'overridden', 28, 2, 6, 0, '4 OZ SERVING', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:21.390847', '2026-07-21 12:20:01.170742', 12279, 'pending', 'Red Peppers, Cauliflower', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218608, 23501, 'Spaghetti & Meatballs', 'dinner', 'scraped', 'overridden', 734, 31, 125, 11, '1 SERVING', NULL, NULL, NULL, NULL, '1.5 cups', false, true, '2026-07-18 11:44:22.608162', '2026-07-21 12:20:03.864296', 7719, 'pending', 'Spaghetti Sauce, Spaghetti , Beef Meatball Halal', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218806, 23509, 'Sugar Cookie (Veg)', 'lunch', 'scraped', 'overridden', 236, 2, 35, 11, '2 oz.Choc. chip cook', NULL, NULL, NULL, NULL, '1 cookie', false, true, '2026-07-18 11:44:25.269058', '2026-07-21 12:22:25.828357', 34487, 'pending', ' COOKIES SUGAR BAKE WHOA GF 6/6.9 OZ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218529, 23501, 'Crabless Cakes (veg)', 'lunch', 'scraped', 'overridden', 293, 7, 37, 12, 'PORTION 6 OZ.', NULL, NULL, NULL, NULL, '3 pieces', false, true, '2026-07-18 11:44:21.339132', '2026-07-21 12:20:01.065442', 30485, 'pending', 'Fresh Curley Parsley, Fresh Celery Root, Gluten Free Veganaise, Gluten Free Rice Flour, Grey Poupon Mustard, Cayenne Powder, Artichoke Heart, Kosher Salt, Panko Bread Crumbs, Old Bay Seasoning, Lemon Juice, Low Sodium Garbanzo Beans, Red Bell Pepper, Scallions , VEG PEPPERS GREEN LARGE AMBROGI', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218811, 23501, 'Beef Gravy', 'dinner', 'scraped', 'overridden', 13, 0, 3, 1, '3 OZ', NULL, NULL, NULL, NULL, '0.25 cup', false, true, '2026-07-18 11:44:25.65136', '2026-07-21 12:20:12.06683', 17452, 'pending', 'Ground Black Pepper, Salt, Fresh Carrots, Fresh Celery, Fresh Peeled Onions, CORN STARCH SLURRY, Beef Stock with Soup Base, Browning Sauce', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218609, 23501, 'Sauteed Spinach with Roasted Red Peppers', 'dinner', 'scraped', 'overridden', 33, 3, 4, 1, '4 OZ PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:22.649164', '2026-07-21 12:20:03.916452', 16868, 'pending', 'Baby Spinach, Balsamic Vinaigrette Dressing , Ground Black Pepper, Roasted Sweet Red Peppers, Sunflower Oil, Kosher Salt', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218612, 23501, 'Italian Vegetable Blend', 'dinner', 'scraped', 'overridden', 51, 3, 10, 1, 'SERVING 4 OZ', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:22.714296', '2026-07-21 12:20:04.097718', 14467, 'pending', 'Ground Black Pepper, Lima Beans, Salt, Sunflower Oil, Cut Green Beans, Cauliflower, Fresh Zucchini, Fresh Carrots', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218535, 23501, 'Tartar Sauce', 'lunch', 'scraped', 'overridden', 35, 0, 0, 4, '1 OUNCE SERVING', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-18 11:44:21.509039', '2026-07-21 12:20:01.35637', 7522, 'pending', 'Dill Pickle Relish, Fresh Peeled Onions, Capers, Kraft Extra Heavy Mayonaise, Pimento Stuffed Olives', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218810, 23501, 'Roast Beef', 'dinner', 'scraped', 'overridden', 155, 25, 1, 5, 'SERVING 4 OUNCES', NULL, NULL, NULL, NULL, '4 oz', false, true, '2026-07-18 11:44:25.608646', '2026-07-21 12:20:12.014425', 7742, 'pending', 'Ground Black Pepper, Salt, Fresh Peeled Onions, Fresh Celery, Fresh Carrots, Whole Rodemary , Top Round of Beef', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218770, 23511, 'Buffalo Chicken Breast', 'dinner', 'scraped', 'overridden', 276, 20, 0, 21, '3 OZ. PORTION', NULL, NULL, NULL, NULL, '3 oz', false, true, '2026-07-18 11:44:24.837403', '2026-07-21 12:22:29.460594', 34522, 'pending', 'Premium Deli Roast Beef', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218693, 23504, 'Blackberries', 'lunch', 'scraped', 'overridden', 24, 1, 5, 0, '2 OZ. PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:23.777314', '2026-07-21 12:22:23.28374', 34725, 'pending', 'Blackberries ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218607, 23501, 'Vegetable & White Bean Hash', 'dinner', 'scraped', 'overridden', 87, 4, 18, 1, 'PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:22.56681', '2026-07-21 12:20:03.812251', 26653, 'pending', 'Sweet Potatoes, Red Bell Pepper, Kosher Salt, Navel Orange, Course Ground Black Pepper, Fresh Leeks, Fresh Lacinato Kale, Turnips, White Kidney Beans, Whole Peeled Garlic, Whole Rodemary ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218538, 23501, 'Cocktail Sauce', 'lunch', 'scraped', 'overridden', 80, 0, 15, 2, 'CONTAINER', NULL, NULL, NULL, NULL, '0.25 cup', false, true, '2026-07-18 11:44:21.569454', '2026-07-21 12:20:01.461157', 7523, 'pending', 'Meyer Lemon Juice, Heinz Ketchup Dispenser, Horseradish, Chili Sauce, XXXSAUCE TABASCO MCILHENNY', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217842, 23688, 'Eggs and Omelets', 'breakfast', 'scraped', 'accepted', 137, 6, 2, 15, '7 OZ SERVING', NULL, NULL, NULL, NULL, NULL, false, true, '2026-07-18 11:44:07.932253', '2026-07-21 12:22:20.612106', 22792, 'pending', 'Pasture Raised Brown Eggs, Pasturized Liquid Whole Eggs, Pepper Jack Cheese Loaf, Shredded Yellow Cheddar Cheese, Shredded Cheddar Cheese, Roasted Sweet Red Peppers, Sliced Olives, Certified Humane Liquid Egg Whites, Button Mushrooms, Baby Spinach, Applewood Smoked Bacon, Allergen Free Vegelene, Deli Smoked Ham, Diced Pork Bacon, Fresh Peeled Onions, VEG PEPPERS GREEN LARGE AMBROGI, VEG TOMATO FRSH DICED 2/5 LB AMBROGI', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218727, 23504, 'Caesar Salad', 'dinner', 'scraped', 'overridden', 679, 38, 66, 30, '14 oz Salad', NULL, NULL, NULL, NULL, '1 bowl', false, true, '2026-07-18 11:44:24.350309', '2026-07-21 12:22:27.791357', 27790, 'pending', 'Seasoned Croutons, Shredded Parmesan Cheese, Little Leaf Romaine Lettuce , Chicken, Caesar Dressing', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218540, 23501, 'Chicken Cheesesteak', 'lunch', 'scraped', 'overridden', 425, 40, 23, 19, '1 SANDWICH', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-18 11:44:21.622541', '2026-07-21 12:20:01.564702', 7762, 'pending', 'Shaved Chicken Steak, Club Roll, Fresh Peeled Onions, White Mild Cheddar Cheese', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218541, 23501, 'Stromboli', 'lunch', 'scraped', 'overridden', 143, 5, 25, 2, '5.250 oz Portion', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:44:21.670832', '2026-07-21 12:20:01.617521', 7875, 'pending', 'Shredded Mozzarella Cheddar Blend Cheese, PIZZA DOUGH VILLANOVA WHITE 8 OZ, Peeled Ground Tomatoes', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218666, 23502, 'Biscuits', 'breakfast', 'scraped', 'overridden', 163, 3, 21, 8, '1 Biscuit', NULL, NULL, NULL, NULL, '1 biscuit', false, true, '2026-07-18 11:44:23.471388', '2026-07-21 12:22:19.08137', 16080, 'pending', 'Southern Biscuit Dough', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218532, 23501, 'Remoulade Sauce', 'lunch', 'scraped', 'overridden', 1, 0, 0, 0, '1 oz Portion', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-18 11:44:21.438933', '2026-07-21 12:20:01.222524', 22532, 'pending', 'Dill Pickle Relish, Cajun Spice, Chipotle Tabasco Sauce, Meyer Lemon Juice', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218528, 23506, 'Seafood Bisque', 'lunch', 'scraped', 'overridden', 46, 3, 3, 2, '6 oz Serving', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:21.293199', '2026-07-21 12:20:00.987568', 14558, 'pending', 'Sustainable Tilapia Filet, Sustainable Shrimp, Sea Scallop Pieces, Kosher Salt, Half & Half Creamer, Fresh Flat Leaf Italian Parsley, Fresh Celery, Fish Paste Soup Base, Fresh Peeled Onions, Ground Black Pepper, Bay Leaf, Cayenne Powder, Chopped Clams, Chopped Garlic, Water, White flour and canola roux, Whole Thyme, Tomato Paste', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218812, 23501, 'Roasted Red Skin Potatoes', 'dinner', 'scraped', 'overridden', 201, 3, 22, 11, 'SERVING', NULL, NULL, NULL, NULL, '0.75 cup', false, true, '2026-07-18 11:44:25.692642', '2026-07-21 12:20:12.118682', 7789, 'pending', 'Ground Black Pepper, Salt, Red Skin Potato Wedge, Sunflower Oil', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219108, 23506, 'White Chicken Lasagna Soup', 'lunch', 'scraped', 'overridden', 503, 44, 49, 16, 'PORTION', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:29.805906', '2026-07-21 12:20:23.199936', 31552, 'pending', 'Shredded Fancy Parmesan Cheese, Imported Olive Oil, Jumbo Random Chicken Breast, Kosher Salt, Heavy Cream Quart, Lasagna Sheet Pasta, Parsley Flake, Fresh Carrots , Dried Oregano Leaf, Dried Thyme Leaf, Green Bell Peppers, Fresh Peeled Onions, Course Ground Black Pepper, Crushed Red Pepper, CORN STARCH SLURRY, Chopped Spinach, Chicken Stock, Bay Leaf, Whole Peeled Garlic, White Kidney Beans', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219116, 23501, 'Open Face Tuna Melt on Marble Rye', 'lunch', 'scraped', 'overridden', 516, 14, 56, 26, 'SANDWICH 7  OUNCE', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-18 11:44:30.015288', '2026-07-21 12:20:23.643573', 7436, 'pending', 'Fresh Sliced Tomato, Sliced Land O Lakes American Cheese, Marble Rye Bread, Tuna Salad', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219203, 23505, 'Spinach', 'dinner', 'scraped', 'overridden', 7, 1, 1, 0, 'PORTION', NULL, NULL, NULL, NULL, '2 cups', false, true, '2026-07-18 11:44:31.04024', '2026-07-21 12:20:33.703644', 27351, 'pending', 'Baby Spinach', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219013, 23501, 'Sage Dijon Chicken', 'dinner', 'scraped', 'overridden', 460, 29, 3, 37, 'Each', NULL, NULL, NULL, NULL, '1 piece (4 oz)', false, true, '2026-07-18 11:44:28.329745', '2026-07-21 12:20:19.409911', 24567, 'pending', 'Imported Olive Oil, Sage Brown Sauce , Black Pepper Ham, Boneless Skinless 4 OZ Chicken Breast, Fresh Mozzarella Ciliegne', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218746, 23511, 'Spring Harvest Sandwich', 'dinner', 'scraped', 'overridden', 442, 12, 49, 21, 'SANDWICH', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-18 11:44:24.565494', '2026-07-21 12:22:30.084383', 34341, 'pending', 'Kosher Salt, Meyer Lemon Juice, Organic Garbanzo Beans, Roasted Shelled Sunflower Seed, Red Onions, Dijon Mustard, Fresh Dill, Gluten Free Veganaise, Cherry Tomatoes, California Baby Arugula, Ciabatta Roll, Course Ground Black Pepper', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219110, 23501, 'Homemade Potato Chips (veg)', 'lunch', 'scraped', 'overridden', 271, 3, 34, 14, '5 oz Serving', NULL, NULL, NULL, NULL, '10-15 chips (1 oz)', false, true, '2026-07-18 11:44:29.861435', '2026-07-21 12:20:23.330374', 24741, 'pending', 'Non GMO Canola Oil, French Fry Flake Salt, Fresh Potato Chip', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219016, 23501, 'Roasted Yukon Gold Potatoes', 'dinner', 'scraped', 'overridden', 101, 2, 23, 0, 'SERVING 4 OUNCES', NULL, NULL, NULL, NULL, '0.75 cup', false, true, '2026-07-18 11:44:28.390195', '2026-07-21 12:20:19.567254', 20440, 'pending', 'Kosher Salt, Sunflower Oil, Chili Powder, Frresh Rosemary, Whole Peeled Garlic, Yukon Gold Potatoes', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218815, 23504, 'Buffalo & Blue Salad', 'dinner', 'scraped', 'overridden', 717, 36, 59, 42, 'Salad', NULL, NULL, NULL, NULL, '1 bowl', false, true, '2026-07-18 11:44:25.794297', '2026-07-19 11:48:49.391424', 27986, 'pending', 'Buffalo Sandwich Sauce, Blue Cheese Crumbles, Plum Tomato, Popcorn  Chicken Bites, Organic Blue Cheese Dressing, Neapolitan Flat Bread, Little Leaf Romaine Lettuce , Tri Colored Tortilla Strips', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219018, 23501, 'ZUCCHINI DIJONNAISE', 'dinner', 'scraped', 'overridden', 351, 8, 29, 24, 'Each', NULL, NULL, NULL, NULL, '1 piece', false, true, '2026-07-18 11:44:28.440042', '2026-07-21 12:20:19.671096', 29487, 'pending', 'Sunflower Oil, Kosher Salt, Nutritional Yeast Flakes, Panko Bread Crumbs, Dijon Mustard 8 Oz OG2, Ground Black Pepper, Fresh Zucchini, Califia Oat Milk', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219206, 23501, 'Baked Chicken', 'dinner', 'scraped', 'overridden', 377, 38, 13, 19, '8 oz Portion', NULL, NULL, NULL, NULL, '8 oz', false, true, '2026-07-18 11:44:31.352509', '2026-07-21 12:20:28.952243', 27020, 'pending', '8.2 OZ Chicken Breast , Boneless Skinless Chicken Thighs, Ground Black Pepper, Kosher Salt, Whole Thyme', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219207, 23501, 'Eggplant Adobo', 'dinner', 'scraped', 'overridden', 36, 1, 8, 0, '4 oz Seving', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:31.393696', '2026-07-21 12:20:29.004314', 31218, 'pending', 'Chopped Garlic, Chinese Eggplants, Canola Olive Oil Blend, Gluten Free Tamari Sauce, Ground Black Pepper, White Vinegar, White Granulated Cane Sugar', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219204, 23505, 'Mozzarella Cheese', 'dinner', 'scraped', 'overridden', 136, 10, 1, 10, '1.5 OZ. PORTION', NULL, NULL, NULL, NULL, '2 tbsp (1 oz)', false, true, '2026-07-18 11:44:31.082398', '2026-07-21 12:20:32.912875', 34575, 'pending', 'Fresh Mozzarella Cheese Small Balls', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219205, 23505, 'Blackened Chicken', 'dinner', 'scraped', 'overridden', 440, 23, 10, 34, '3 OZ. PORTION', NULL, NULL, NULL, NULL, '3 oz', false, true, '2026-07-18 11:44:31.126353', '2026-07-21 12:20:33.496173', 34563, 'pending', 'Balsamic Vinegar, Blackening Spice, Boneless Skinless Chicken Thighs, Imported Olive Oil', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219200, 23505, 'Broccoli', 'dinner', 'scraped', 'overridden', 9, 1, 2, 0, 'PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:30.918318', '2026-07-21 12:20:33.547901', 27350, 'pending', 'Broccoli Florets', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219201, 23505, 'Mushrooms', 'dinner', 'scraped', 'overridden', 8, 1, 1, 0, 'PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:30.959571', '2026-07-21 12:20:33.599554', 27357, 'pending', 'Sliced Mushrooms', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219082, 23501, 'BRK TRADITIONS MONDAY', 'breakfast', 'scraped', 'accepted', 851, 36, 91, 48, '13 OZ. portion', NULL, NULL, NULL, NULL, NULL, false, true, '2026-07-18 11:44:29.291838', '2026-07-21 12:20:21.360526', 35296, 'pending', 'Lyonnaise Potatoes, Migas , Pancakes, Pork Sausage Link', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219107, 23506, 'Mushroom Barley Soup', 'lunch', 'scraped', 'overridden', 96, 3, 19, 3, '8 oz Bowl', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:29.765105', '2026-07-21 12:20:23.147497', 12840, 'pending', 'Dried Oregano Leaf, Fresh Carrots, Assorted Dried Wild Mushrooms, Crimini Mushrooms, Celery Sticks, Salt, Sunflower Oil, Spanish Onions, Pearl Barley, Ground Black Pepper, Vegetable Soup Base (vegan), Water, Water', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219112, 23501, 'Gemelli Pasta with Marinara Sauce', 'lunch', 'scraped', 'overridden', 362, 12, 78, 1, '6 oz Serving', NULL, NULL, NULL, NULL, '1.5 cups', false, true, '2026-07-18 11:44:29.912358', '2026-07-21 12:20:23.435099', 23661, 'pending', 'Gemelli Pasta, Kosher Salt, Tomato Marinara Sauce', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219115, 23501, 'Broccoli, Yellow Squash & Red Peppers', 'lunch', 'scraped', 'overridden', 49, 2, 6, 3, 'SERVING 4 OZ', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:29.97485', '2026-07-21 12:20:23.591371', 13741, 'pending', 'Sunflower Oil, Salt, Red Peppers, Ground Black Pepper, Organic Yellow Squash, Broccoli Florets', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219208, 23501, 'Pancit - Filipino Noodles', 'dinner', 'scraped', 'overridden', 158, 6, 25, 4, '6 oz Serving', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:31.434477', '2026-07-21 12:20:29.057294', 25984, 'pending', 'Fresh Peeled Onions, Gluten Free-Wheat Free Soy Sauce, Granulated Sugar, Cellophane Noodle, Chopped Garlic, Matchstick Carrots, Scallions , Shrimp Peeled and Deveined, Roasted Sesame Oil, Sliced Shitake Mushrooms , Sunflower Oil, Whole Leaf Spinach', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219202, 23505, 'Peppers', 'dinner', 'scraped', 'overridden', 4, 0, 1, 0, 'PORTION', NULL, NULL, NULL, NULL, '0.25 cup', false, true, '2026-07-18 11:44:31.000117', '2026-07-21 12:20:33.65112', 27356, 'pending', 'Local Green Bell Peppers, Orange Bell Peppers, Red Bell Pepper', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (220460, 23570, 'Breakfast Sandwich', 'breakfast', 'scraped', 'overridden', 652, 39, 42, 35, 'Sandwich', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-18 11:44:49.562733', '2026-07-21 12:21:44.700579', 23542, 'pending', 'Cooper Sharp Cheese, Pork Sausage Patty, Pasture Raised Brown Eggs, Thomas''s English Muffin', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (220648, 23501, 'Cheesy Baked Grits', 'breakfast', 'scraped', 'overridden', 362, 10, 18, 28, '4 OZ PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:52.180635', '2026-07-21 12:21:56.035992', 11821, 'pending', 'Quick Grits, Salt, Shredded Mild Yellow Cheddar Cheese, Imported Grated Parmesan Cheese, Ground White Pepper, Butter, 1% Milk Gallon', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219439, 23501, 'Mushroom flatbread w/ tomato pepper jam', 'dinner', 'scraped', 'overridden', 70, 2, 12, 2, 'Portion', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:44:35.136748', '2026-07-21 12:20:42.85404', 25620, 'pending', 'Kosher Salt, Imported Olive Oil, Shredded Vegan Mozzarella, Sherry Vinegar, Sliced Shitake Mushrooms , Crimini Mushrooms, Course Ground Black Pepper, Granulated Sugar, Fresh Peeled Onions, Frisee Lettuce, White Pita Bread, Tomato pepper jam ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219274, 23505, 'French Catalina Dressing', 'dinner', 'scraped', 'overridden', 39, 0, 5, 2, '3.5 OZ. PORTION', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-18 11:44:32.297339', '2026-07-21 12:20:32.653193', 34583, 'pending', 'French Catalina Dressing', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217879, 23511, 'Turkey Breast', 'dinner', 'scraped', 'overridden', 88, 15, 4, 1, '3 OZ. PORTION', NULL, NULL, NULL, NULL, '3 oz', false, true, '2026-07-18 11:44:09.305221', '2026-07-21 12:22:28.186033', 34515, 'pending', 'Turkey Breast', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219440, 23501, 'Seared Cod in White Wine Tomato Sauce', 'dinner', 'scraped', 'overridden', 228, 23, 8, 11, 'PORTION', NULL, NULL, NULL, NULL, '1 fillet (4 oz)', false, true, '2026-07-18 11:44:35.17689', '2026-07-21 12:20:42.906404', 29311, 'pending', 'Lemon Zest, Meyer Lemon Juice, Imported Olive Oil, Kosher Salt, Ground Black Pepper, Granulated Sugar, Fresh Basil, Cherry Tomatoes, Crushed Red Pepper, Cod Filet , Beringer White Zinfindel, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217907, 23511, 'Assorted Wraps', 'dinner', 'scraped', 'accepted', 287, 8, 47, 7, '3 OZ. PORTION', NULL, NULL, NULL, NULL, NULL, false, true, '2026-07-18 11:44:10.462864', '2026-07-21 12:22:29.616553', 34537, 'pending', 'Spinach Herb Tortilla Wrap, 12" Whole Wheat Flour Tortilla, 10" Flour Tortilla, Tomato Basil Tortilla Wrap', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219284, 23505, 'Roasted Chickpeas', 'dinner', 'scraped', 'overridden', 27, 2, 5, 0, '1 oz Portion', NULL, NULL, NULL, NULL, '0.25 cup', false, true, '2026-07-18 11:44:32.45654', '2026-07-21 12:20:33.171894', 34559, 'pending', 'Kosher Salt, Canola Olive Oil Blend, Chick Peas, Ground Black Pepper, Zaatar Spice', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219357, 23501, 'Jalapeno Peppers', 'lunch', 'scraped', 'overridden', 5, 0, 1, 0, '1 OZ. PORTION', NULL, NULL, NULL, NULL, '0.25 cup', false, true, '2026-07-18 11:44:33.947351', '2026-07-21 12:21:59.693526', 34150, 'pending', 'Sliced Jalapeno Peppers', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219265, 23505, 'Balsamic Vinegar', 'dinner', 'scraped', 'overridden', 84, 0, 16, 0, '2.OZ. PORTION', NULL, NULL, NULL, NULL, '1 tbsp', false, true, '2026-07-18 11:44:32.175315', '2026-07-21 12:20:32.181289', 34588, 'pending', 'Balsamic Vinegar', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219355, 23501, 'Pico De Gallo', 'lunch', 'scraped', 'overridden', 34, 0, 4, 2, '2 OZ SERVING', NULL, NULL, NULL, NULL, '0.25 cup', false, true, '2026-07-18 11:44:33.866538', '2026-07-21 12:21:59.589516', 34141, 'pending', 'Kosher Salt, Jalapeno Slices in Brine, Lime Juice, Sunflower Oil, Ground Black Pepper, Fresh Cilantro, Diced Red Onions, Diced Fresh Tomatoes, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219359, 23501, 'Guacamole', 'lunch', 'scraped', 'overridden', 10, 1, 2, 0, 'Portion', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-18 11:44:34.034392', '2026-07-21 12:21:59.745228', 34145, 'pending', 'Fresh Cilantro, Chunky Avocado Pulp, Kosher Salt, Jalapeno Peppers, Lime Juice, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219358, 23501, 'SP SOUR CREAM', 'lunch', 'scraped', 'overridden', 56, 1, 1, 5, '1 OZ PORTION', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-18 11:44:33.990771', '2026-07-21 12:20:38.034143', 34971, 'pending', 'Sour Cream, Skim Milk in 20 Quart Dispenser', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217861, 23511, 'Assorted Dairy Free Cheese', 'dinner', 'scraped', 'accepted', 108, 1, 14, 14, '2 OZ. PORTION', NULL, NULL, NULL, NULL, NULL, false, true, '2026-07-18 11:44:08.693873', '2026-07-21 12:22:29.980236', 34502, 'pending', 'Sliced Vegan Cheddar Cheese, Vegan Provolone Cheese, Vegan American Cheese Slice', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219342, 23501, 'Shredded Lettuce', 'lunch', 'scraped', 'overridden', 2, 0, 0, 0, '.5 OZ. PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:33.617156', '2026-07-21 12:21:59.0701', 34149, 'pending', 'Shredded Iceberg Lettuce', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219339, 23501, 'Tortilla Chips', 'lunch', 'scraped', 'overridden', 401, 6, 58, 18, '1 BOWL', NULL, NULL, NULL, NULL, '10-15 chips (1 oz)', false, true, '2026-07-18 11:44:33.51862', '2026-07-21 12:21:58.836427', 34142, 'pending', 'White Salted Tortilla Chips', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219435, 23501, 'Pesto Baked Pork Chop', 'dinner', 'scraped', 'overridden', 331, 42, 3, 16, 'PORTION 6 OZ.', NULL, NULL, NULL, NULL, '6 oz', false, true, '2026-07-18 11:44:35.054375', '2026-07-21 12:20:42.596069', 30761, 'pending', 'Course Ground Black Pepper, Fresh Curley Parsley, Fresh Peeled Shallots, Pork Loin, Kosher Salt, Imported Olive Oil, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216726, 23504, 'House Made Hummus', 'dinner', 'scraped', 'overridden', 122, 4, 11, 8, '3 OZ', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-17 22:34:14.979805', '2026-07-21 12:22:27.843453', 19042, 'pending', 'Sunflower Oil, Kosher Salt, Meyer Lemon Juice, Coriander Powder, Cumin Powder, Chick Peas, Ground Black Pepper', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219277, 23505, 'Italian Dressing', 'dinner', 'scraped', 'overridden', 29, 0, 1, 0, '3.5 OZ. PORTION', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-18 11:44:32.358545', '2026-07-21 12:20:32.809064', 34585, 'pending', 'DRESSING ITALIAN GOLDEN 4/1 GL', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219338, 23506, 'Lentil Soup', 'lunch', 'scraped', 'overridden', 55, 2, 6, 3, '6 OZ BOWL', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:33.47786', '2026-07-21 12:20:36.957324', 17371, 'pending', 'Potatoes, Lentils, Sunflower Oil, Ground Black Pepper, Fresh Peeled Onions, Fresh Carrots, Fresh Celery, Vegetable Stock Base', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219341, 23501, 'Black Olives', 'lunch', 'scraped', 'overridden', 23, 0, 2, 2, 'PORTION', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-18 11:44:33.576406', '2026-07-21 12:21:58.966156', 34151, 'pending', 'Sliced Olives', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219347, 23501, 'Mango & Corn Salsa', 'lunch', 'scraped', 'overridden', 34, 1, 8, 0, 'SERVING 2 OZ', NULL, NULL, NULL, NULL, '0.25 cup', false, true, '2026-07-18 11:44:33.75913', '2026-07-21 12:21:59.537501', 34144, 'pending', 'Red Onions, Scallions , Lime Juice, Pineapple Chunks, Kosher Salt, Diced Mango, Fresh Cilantro, Ground Black Pepper, Whole Kernal Corn', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (220502, 23506, 'Chicken soup', 'lunch', 'scraped', 'overridden', 663, 36, 81, 23, 'PORTION', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:50.255095', '2026-07-21 12:21:47.35445', 33258, 'pending', 'Pulled Cooked Pulled White Meat Chicken , Shredded Parmesan Cheese, Small Shell Pasta, Kosher Salt, Julienne Sundried Tomatoes, Italian Seasoning, Heavy Cream Quart, Plain Cream Cheese Loaf, Chicken Stock, Crushed Red Pepper, Fresh Basil, Fresh Peeled Onions, Fresh Spinach, Garlic Powder, Whole Peeled Garlic, Tomato Paste', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219434, 23501, 'BRUSSEL SPROUTS & MAPLE BUTTERNUT SQUASH', 'dinner', 'scraped', 'overridden', 233, 3, 47, 6, 'PORTION', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:35.012964', '2026-07-21 12:20:42.543634', 29472, 'pending', 'Kosher Salt, Organic Pumpkin Seeds, Olive OIl, Pure Vermont Maple Syrup, Brussel Sprouts, Dried Craisins, VEG BUTTERNUT SQUASH DICED 5LBS', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219343, 23501, 'Cheddar Cheese', 'lunch', 'scraped', 'overridden', 228, 13, 2, 19, 'PORTION', NULL, NULL, NULL, NULL, '0.25 cup', false, true, '2026-07-18 11:44:33.657174', '2026-07-21 12:21:59.173741', 34152, 'pending', 'Shredded Cheddar Cheese', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219356, 23501, 'Cilantro Lime Rice', 'lunch', 'scraped', 'overridden', 587, 10, 120, 6, 'portion', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:33.907431', '2026-07-21 12:21:59.641271', 34146, 'pending', 'Lime Juice, Lime Zest, Kosher Salt, Canola Olive Oil Blend, Fresh Cilantro, Whole Peeled Garlic, White Basmati Rice, Vegetable Stock Base', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219344, 23501, 'Southwest Beans', 'lunch', 'scraped', 'overridden', 41, 2, 7, 1, '2oz Serving', NULL, NULL, NULL, NULL, '0.25 cup', false, true, '2026-07-18 11:44:33.69792', '2026-07-21 12:21:59.225539', 34140, 'pending', 'Fresh Cilantro, Ground Black Pepper, Black Beans (Low Sodium), Cumin Powder, Cayenne Powder, Chili Powder, Sunflower Oil, Spanish Onions, Smoked Paprika, Red Bell Pepper, Kosher Salt', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219536, 23506, 'Broccoli Cheddar Soup', 'lunch', 'scraped', 'overridden', 148, 6, 8, 10, 'SERVING 6 OZ', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:36.653468', '2026-07-21 12:20:48.774194', 13451, 'pending', 'Fresh Celery, Fresh Peeled Onions, All Purpose Flour, 2 % Milk in 20 QT Dispenser, Butter, Broccoli Florets, Chicken Stock, Salt, Shredded Yellow Cheddar Cheese, Ground Black Pepper, XXXCHEESE SPREAD GOLD VELVET ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219537, 23501, 'Chicken Briyani', 'lunch', 'scraped', 'overridden', 276, 20, 39, 4, 'PORTION', NULL, NULL, NULL, NULL, '1.5 cups', false, true, '2026-07-18 11:44:36.694229', '2026-07-21 12:20:48.827176', 32962, 'pending', 'Basmati Rice, Black Cardamom, Chicken Breast Random, Cumin Powder, Course Ground Black Pepper, Cinnamom Stick, FAT FREE PLAIN YOGURT, Fresh Ginger, Fresh Peeled Onions, Fresh Mint, Kosher Salt, Peeld Diced Tomatoes, Local Yellow Marble Potatoes, Mild Chili Powder, Sunflower Oil, Turmeric, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219633, 23501, 'Garden Zucchini & Corn Saute', 'dinner', 'scraped', 'overridden', 197, 2, 9, 18, 'PORTION 4 OZ.', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:37.963145', '2026-07-21 12:20:54.577494', 30801, 'pending', 'Fresh Zucchini, Lemon Pepper, Imported Olive Oil, Kosher Salt, Shoepeg Corn, Red Onions, Whole Peeled Garlic, White Granulated Cane Sugar', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219725, 23506, 'Roasted Corn Chowder', 'lunch', 'scraped', 'overridden', 28, 1, 6, 0, '8 OZ PORTION', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:39.332431', '2026-07-21 12:21:00.451', 17366, 'pending', 'Cumin Powder, Chopped Garlic, Coriander Powder, Fresh Celery, Fresh Carrots, Fresh Cilantro, Fresh Peeled Onions, Sliced Potatoes, Vegetable Stock Base, Whole Kernal Corn', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219635, 23501, 'Grilled Flank Steak', 'dinner', 'scraped', 'overridden', 171, 22, 1, 8, 'SERVING', NULL, NULL, NULL, NULL, '4 oz', false, true, '2026-07-18 11:44:38.013881', '2026-07-21 12:20:54.681637', 12272, 'pending', 'Golden Italian Dressing, Big Tatoo Red Wine, Beef Flank Steak', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219735, 23501, 'Tzatziki Sauce', 'lunch', 'scraped', 'overridden', 212, 8, 37, 4, 'Cup', NULL, NULL, NULL, NULL, '2 tbsp', false, true, '2026-07-18 11:44:39.594344', '2026-07-21 12:21:01.010282', 30568, 'pending', 'Plain Soy Yogurt, Meyer Lemon Juice, Kosher Salt, Knorr Chipotle Sauce, Ground White Pepper, Smoked Paprika, Fresh Cucumber, Fresh Dill, Amber Agave Nectar, Chopped Garlic, Chili Powder, White Balsamic Vinegar', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219629, 23501, 'Baked Sweet Potatoes', 'dinner', 'scraped', 'overridden', 140, 2, 33, 0, '4 oz Portion', NULL, NULL, NULL, NULL, '0.75 cup', false, true, '2026-07-18 11:44:37.850768', '2026-07-21 12:20:54.316321', 7913, 'pending', 'Organic Yams', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218332, 23501, 'Vegetable Frittatas', 'breakfast', 'scraped', 'overridden', 103, 8, 3, 6, '2.5 oz. portion', NULL, NULL, NULL, NULL, '1 frittata', false, true, '2026-07-18 11:44:17.944702', '2026-07-21 12:20:57.739373', 34456, 'pending', 'Course Ground Black Pepper, Fresh Chives, Grated Parmesan Cheese, Fresh Peeled Onions, Fresh Zucchini, Kosher Salt, Imported Olive Oil, Liquid Eggs, Red Bell Pepper, Yellow Peppers', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219518, 23688, 'Scrambled Eggs', 'breakfast', 'scraped', 'overridden', 177, 15, 0, 11, 'SERVING 4 OZ', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:36.190726', '2026-07-21 12:20:47.459118', 7884, 'pending', NULL, false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219818, 23501, 'Steamed Cabbage and Carrots', 'dinner', 'scraped', 'overridden', 38, 1, 8, 1, 'SERVING 4 OZ', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:40.646597', '2026-07-21 12:21:05.985244', 22255, 'pending', 'Chopped Garlic, Cabbage, Fresh Carrots, Ground Black Pepper, Grapeseed Oil, Fresh Peeled Onions, Kosher Salt, Red Bell Pepper', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219737, 23501, 'Vegan Option : Falafel', 'lunch', 'scraped', 'overridden', 53, 3, 11, 1, 'SERVING 4 ounces', NULL, NULL, NULL, NULL, '3 pieces', false, true, '2026-07-18 11:44:39.614623', '2026-07-21 12:21:01.137251', 30982, 'pending', 'Vegan Falafel', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219517, 23688, 'Scrambled Egg Whites', 'breakfast', 'scraped', 'overridden', 17, 3, 0, 0, 'SERVING 4 OZ', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:36.181001', '2026-07-21 12:20:47.406372', 28438, 'pending', NULL, false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219535, 23501, 'Vegetable Korma', 'lunch', 'scraped', 'overridden', 266, 6, 39, 10, 'PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:36.61212', '2026-07-21 12:20:48.721763', 26520, 'pending', 'Peeled Carrot, Jasmine Rice, Imported Olive Oil, Jalapeno Peppers, Kosher Salt, Red Bell Pepper, Sliced Potatoes, Curry Powder, Califia Oat Milk, Al Dente Tomato Sauce, Fresh Cilantro, Fresh Ginger, Green Peas, Fresh Peeled Onions, Whole Peeled Garlic, Whole Green Peppers', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217132, 23506, 'Chicken Tortilla Soup', 'lunch', 'scraped', 'overridden', 84, 4, 12, 2, 'Cup', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:43:53.876396', '2026-07-21 12:19:54.68555', 18785, 'pending', 'Fresh Cilantro, French Fry Flake Salt, Diced Tomatoes, Fresh Peeled Onions, 10" Flour Tortilla, Chicken, Chili Powder, Chicken Stock, Sunflower Oil, Pasilla Chili Pepper Powder, Hass Avocados, Whole Peeled Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219630, 23511, 'Chia Jam Sandwich with nut free spread', 'lunch', 'scraped', 'overridden', 438, 8, 38, 3, 'PORTION', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-18 11:44:37.897485', '2026-07-21 12:21:13.199919', 34364, 'pending', 'DOC CHIA SEED JAM, Banana, 100% Wheat Whole Grain Sliced Bread, Hazlnut Free Spread, Peanut Free Spread', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219534, 23506, 'Leek and Potato Soup', 'lunch', 'scraped', 'overridden', 13, 0, 2, 1, '8 OZ BOWL', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:36.571201', '2026-07-21 12:20:48.669961', 18309, 'pending', 'Fresh Leeks, Fresh Celery, Fresh Thyme, Ground Black Pepper, Califa Oat Milk, Sunflower Oil, Spanish Onions, Kosher Salt, Vegetable Stock Base, Yukon Gold Potatoes', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219728, 23501, 'Tomato, Onion , and Feta filling', 'lunch', 'scraped', 'overridden', 98, 4, 2, 8, '2 oz.  PORTION', NULL, NULL, NULL, NULL, '2 oz', false, true, '2026-07-18 11:44:39.46018', '2026-07-21 12:21:00.635569', 34409, 'pending', 'Imported Olive Oil, Kosher Salt, Red Onions, SPICE OREGANO LEAF DRIED  5 OZ MONARCH, Feta Cheese Block, Cherry Tomatoes, White Vinegar', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219729, 23501, 'Grilled Pita', 'lunch', 'scraped', 'overridden', 53, 1, 5, 3, '4 OZ. PORTION', NULL, NULL, NULL, NULL, '1 pita', false, true, '2026-07-18 11:44:39.470519', '2026-07-21 12:21:00.691138', 34416, 'pending', 'Fresh Curley Parsley, Fresh Dill, Imported Olive Oil, Kosher Salt, Lemon Zest, White Pita Bread', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217880, 23511, 'Sliced Tomato', 'dinner', 'scraped', 'overridden', 7, 0, 1, 0, '1.5 OZ. PORTION', NULL, NULL, NULL, NULL, 'tomato slices', false, true, '2026-07-18 11:44:09.346347', '2026-07-21 12:22:28.23764', 34518, 'pending', 'VEG TOMATO SLICED AMBROGI', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217327, 23506, 'Broccoli and Cheese Soup', 'lunch', 'scraped', 'overridden', 115, 7, 9, 6, '8 oz Serving', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:43:58.227098', '2026-07-21 12:19:02.398582', 23315, 'pending', 'Chicken Stock, Broccoli Florets, Butter, All Purpose Flour, 2 % Milk in 20 QT Dispenser, Fresh Peeled Onions, Ground Black Pepper, Kosher Salt, XXXCHEESE SPREAD GOLD VELVET ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219538, 23501, 'Alfredo Gnocchi', 'lunch', 'scraped', 'overridden', 722, 38, 77, 29, 'Portion', NULL, NULL, NULL, NULL, '1.5 cups', false, true, '2026-07-18 11:44:36.73545', '2026-07-21 12:20:48.879204', 28881, 'pending', 'Alfredo Sauce, Potato Gnocchi Pasta', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219727, 23501, 'Grilled Vegetable Souvlaki', 'lunch', 'scraped', 'overridden', 204, 6, 29, 8, 'serving', NULL, NULL, NULL, NULL, '1 wrap', false, true, '2026-07-18 11:44:39.419624', '2026-07-21 12:21:00.582697', 19573, 'pending', 'Chopped Garlic, Ground Black Pepper, Greek Yogurt Sauce, Fresh Zucchini, Kosher Salt, Japanese Baby Eggplant, Pita Bread, Portocolo Red Wine, Plum Tomato, Red Onions, Red Wine Vinegar, Sunflower Oil, VEG PEPPERS GREEN LARGE AMBROGI, Whole Thyme', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219442, 23501, 'End of Summer Succotash', 'dinner', 'scraped', 'overridden', 86, 3, 16, 2, '3 oz Serving', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:35.226547', '2026-07-21 12:20:43.009719', 25821, 'pending', 'Kosher Salt, Italian Flat Leaf Parsley, Olive OIl, Poblano Peppers, Peeled Red Onions, Lime Juice, Lima Beans, Sunflower Seeds, Shoepeg Corn, Fresh Israeli Basil, Fresh Cilantro, Diced Tomatoes, Ground Black Pepper, Chopped Garlic', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219730, 23501, 'Chicken Souvlaki', 'lunch', 'scraped', 'overridden', 402, 20, 12, 30, '6 OZ. PORTION', NULL, NULL, NULL, NULL, '6 oz', false, true, '2026-07-18 11:44:39.512368', '2026-07-21 12:21:00.743606', 34499, 'pending', 'Boneless Skinless Chicken Thigh, Fresh Peeled Onions, Fresh Oregano, Frresh Rosemary, Fresh Thyme, Imported Olive Oil, Kosher Salt, Honey Squeeze Bottle, Whole Peeled Garlic, White Wine Vinegar', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (220105, 23501, 'Meatball Sub', 'lunch', 'scraped', 'overridden', 340, 28, 8, 21, 'SANDWICH 6 OUNCES', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-18 11:44:44.71253', '2026-07-21 12:21:23.46158', 12625, 'pending', '1 OZ Beef Meatballs, Spaghetti Sauce, Split Top Hot Dog Roll, Provolone Grande Cheese', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (220119, 23504, 'Acai Berry Sorbet', 'lunch', 'scraped', 'overridden', 16, 0, 4, 0, 'Ounce', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:45.002085', '2026-07-21 12:21:36.395055', 32349, 'pending', NULL, false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219822, 23501, 'Carolina Gold Rice with Roasted Garlic', 'dinner', 'scraped', 'overridden', 117, 2, 16, 5, '4 oz Serving', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:40.760047', '2026-07-21 12:21:06.247072', 33409, 'pending', 'Carolina Rice, Bay Leaf, Butter, Kosher Salt, Roasted Garlic, Vegetable Stock Base', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219823, 23501, 'Braised White Beans', 'dinner', 'scraped', 'overridden', 135, 9, 24, 2, '4 oz Serving', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:40.817862', '2026-07-21 12:21:06.299243', 33408, 'pending', 'Smoked Pork Bacon, Smoked Paprika, Onion Powder, Kosher Salt, Bay Leaf, Cayenne Powder, Chopped Garlic, Garlic Powder, Grapeseed Oil, Ground Black Pepper, Green Bell Peppers, Fresh Local English Thyme, Fresh Peeled Onions, Dry Navy Beans, Fresh Celery, Vegetable Stock Base', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219825, 23501, 'Chickien Yassa', 'dinner', 'scraped', 'overridden', 242, 22, 12, 12, '6oz Serving', NULL, NULL, NULL, NULL, '6 oz', false, true, '2026-07-18 11:44:40.869222', '2026-07-21 12:21:06.403194', 33398, 'pending', 'Scotch Bonnet Peppers, Red Wine Vinegar, Low Sodium Tamari Sauce Gluten Free, Kosher Salt, 8.2 OZ Chicken Breast , Bay Leaf, Chopped Garlic, Chicken Stock, Chicken Drumsticks, Grapeseed Oil, Ground Black Pepper, Fresh Peeled Onions, Fresh Ginger, Dijon Mustard, Diced Carrots', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (220128, 23504, 'BBQ Chicken Salad', 'lunch', 'scraped', 'overridden', 580, 21, 39, 38, 'PORTION', NULL, NULL, NULL, NULL, '1 bowl', false, true, '2026-07-18 11:44:45.120815', '2026-07-21 12:21:36.869506', 32368, 'pending', 'Local Hydroponic Spring Mix, Low Sodium Black Beans, SOUTHWEST RANCH , Corn Salsa, Bulls Eye Barbeque Sauce, Fire Braised Chicken, Fried Onion Topping', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219118, 23504, 'Baja Salad', 'dinner', 'scraped', 'overridden', 498, 33, 46, 21, 'PORTION', NULL, NULL, NULL, NULL, '1 bowl', false, true, '2026-07-18 11:44:30.073637', '2026-07-21 12:21:41.676756', 32369, 'pending', 'Grape tomato, Fire Braised Chicken, Feta Cheese Block, Diced Avocado, Black Beans (Low Sodium), Corn Salsa, CILANTRO LIME BROWN RICE, QUINOA, Salsa Verde, Plain Greek Yogurt', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219914, 23506, 'Thai Noodle Soup', 'lunch', 'scraped', 'overridden', 350, 7, 19, 28, '12 oz. PORTION', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:42.209975', '2026-07-21 12:22:10.559923', 34472, 'pending', 'Red Bell Pepper, Red Curry Thai Base, Imported Olive Oil, Kosher Salt, Peanut Free Spread, Pad Thai Rice Noodles, Organic Local Cremini Mushrooms, Lime Juice, Low Sodium Tamari Sauce Gluten Free, Fresh Thai Basil, Fresh Cilantro, Fresh Ginger, Coconut Milk, Whole Peeled Garlic, Vegetable Stock Base', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219913, 23506, 'Manhattan Clam Chowder', 'lunch', 'scraped', 'overridden', 48, 4, 4, 2, 'SERVING 8 OUNCES', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:42.167785', '2026-07-21 12:21:11.767769', 7459, 'pending', 'Potatoes, Ground Black Pepper, Salt, Sunflower Oil, Chopped Clams, Fresh Peeled Onions, Fresh Carrots, Fresh Celery, Fresh Curley Parsley, Diced Tomatoes, Fish Paste Soup Base, Worcestershire Sauce , Water, Whole Thyme, Whole Leaf Basil', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (220108, 23501, 'Broccoli Rabe & Portabella Sandwich', 'lunch', 'scraped', 'overridden', 168, 6, 28, 4, 'Sandwich 5 ounces', NULL, NULL, NULL, NULL, '1 sandwich', false, true, '2026-07-18 11:44:44.773589', '2026-07-21 12:21:23.565118', 21072, 'pending', 'Sunflower Oil, Roasted Sweet Red Peppers, Kosher Salt, Portabello Mushroom Caps, Fresh Lemon, Ground Black Pepper, Chopped Garlic, 4" Square Focaccia Roll, Broccoli Rabe', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (220115, 23503, 'Lox with Capers and Onions', 'lunch', 'scraped', 'overridden', 122, 16, 2, 6, '1 SERV', NULL, NULL, NULL, NULL, '2 oz', false, true, '2026-07-18 11:44:44.888057', '2026-07-21 12:21:24.047953', 13621, 'pending', 'Nova Lox, Red Onions, Capers, Whipped Cream Cheese', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (220116, 23503, 'Guacamole Toast', 'lunch', 'scraped', 'overridden', 236, 7, 34, 7, 'PORTION', NULL, NULL, NULL, NULL, '1 slice', false, true, '2026-07-18 11:44:44.93063', '2026-07-21 12:21:24.099736', 27410, 'pending', 'Mild Guacamole , XXXBREAD WHEAT 100% 16 SL ARNOLD', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (220201, 23501, 'Chickpea & Vegetable Tangine', 'dinner', 'scraped', 'overridden', 295, 11, 49, 7, 'PORTION', NULL, NULL, NULL, NULL, '1.5 cups', false, true, '2026-07-18 11:44:46.073793', '2026-07-21 12:21:29.033813', 26539, 'pending', 'Quinoa Pilaf, Smoked Paprika, Ground Cinnamom, Meyer Lemon Juice, Locally Grown Green Bell Peppers, Peeled Carrot, Peeled Red Onions, Cayenne Powder, Button Mushrooms, Cumin Powder, GLUTEN FREE VEGETABLE SOUP STOCK, Golden Seedless Raisins, Garbonzo Beans, Fresh Cilantro, Fresh Ginger, Water, Whole Peeled Garlic, Whole Green Beans, Turmeric, Tomato Paste', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219820, 23501, 'Collard Greens', 'dinner', 'scraped', 'overridden', 25, 2, 4, 1, '3 OZ', NULL, NULL, NULL, NULL, '0.5 cup', false, true, '2026-07-18 11:44:40.703572', '2026-07-21 12:21:06.116385', 10458, 'pending', 'Salt, Ground Black Pepper, Collard Greens', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (220977, 23501, 'Vegetable Tostadas', 'dinner', 'scraped', 'overridden', 271, 11, 25, 15, 'PORTION 6 OZ.', NULL, NULL, NULL, NULL, '1 tostada', false, true, '2026-07-18 11:44:56.541574', '2026-07-21 12:22:15.792622', 32386, 'pending', '6" Corn Tortilla, Cheddar & Monterey Jack Shredded Cheese, Fresh Cilantro, Jalapeno Slices in Brine, Hot Fire Roasted Salsa, Mild Guacamole , Refried Beans, Roasted Vegetables, Sour Cream ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217379, 23501, 'Yellow Rice & Black Beans with Broccoli', 'dinner', 'scraped', 'overridden', 69, 3, 14, 1, 'portion', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:43:59.219692', '2026-07-21 12:22:16.108229', 26514, 'pending', 'Red Miso Base, Brown Rice, Broccoli Florets, Black Beans (Low Sodium), Cumin Powder, Coriander Powder, Cayenne Powder, Fresh Ginger, GLUTEN FREE VEGETABLE SOUP STOCK, Turmeric, XXXVEG SHALLOTS LARGE  PEELED FRESH', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (220692, 23501, 'Burrito Bowl', 'lunch', 'scraped', 'accepted', 754, 33, 60, 42, '1 BOWL', NULL, NULL, NULL, NULL, NULL, false, true, '2026-07-18 11:44:52.85267', '2026-07-21 12:21:58.783714', 28542, 'pending', 'Pico de Gallo, Guacamole, Shredded Lettuce, Shredded Mild Yellow Cheddar Cheese, SEASONED BLACK BEANS, Queso Blanco Sauce, Sour Cream PC, Fire Braised Chicken, Boneless Pork Roast, Beef Barbacoa , Brown Rice, Tri Color Corn Tortilla Chips', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219360, 23501, 'Adobo Chicken', 'lunch', 'scraped', 'overridden', 626, 58, 28, 30, 'PORTION', NULL, NULL, NULL, NULL, '4 oz', false, true, '2026-07-18 11:44:34.074628', '2026-07-21 12:21:59.901434', 34139, 'pending', 'Hot Chipotle Pepper, Kosher Salt, Lime Juice, Red Onions, Spanish Paprika, Sunflower Oil, Cumin Powder, Boneless Skinless Chicken Thighs, Ground Black Pepper, Dried Mexican Oregano', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (221074, 23506, 'Italian Wedding Soup', 'lunch', 'scraped', 'overridden', 5, 0, 1, 0, '1 BOWL', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:57.939885', '2026-07-21 12:22:21.76245', 7822, 'pending', 'Italian Wedding Soup with Half Baguette , Water', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216727, 23504, 'House Made Red Pepper Hummus', 'dinner', 'scraped', 'overridden', 111, 3, 10, 7, '3 OZ', NULL, NULL, NULL, 7, '2 tbsp', false, true, '2026-07-17 22:34:15.073894', '2026-07-21 12:22:27.895128', 21684, 'pending', 'Ground Black Pepper, Extra Virgin Olive Oil, Fire Roasted Red Peppers, Cumin Powder, Coriander Powder, Chick Peas, Meyer Lemon Juice, Kosher Salt', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218782, 23505, 'Fresh Salad Bar', 'dinner', 'scraped', 'accepted', 317, 10, 23, 21, 'SERVING 12 OUNCES', NULL, NULL, NULL, NULL, NULL, false, true, '2026-07-18 11:44:24.995656', '2026-07-21 12:22:30.271027', 12137, 'pending', 'Honey Mustard Dressing, Honey Mustard Dressing, Local Green Leaf Lettuce, Peeled Hard Cooked Eggs, Organic Black Beans, Oriental Sesame Dressing, Sundried Tomato, Suntan Peppers, Sliced Beets, Shredded Yellow Cheddar Cheese, Shredded Carrots, Shoepeg Corn, Red Kidney Beans, Red Peppers, Romaine Lettuce, Chick Peas, Chicken Breast Strip, Caesar Dressing, Buttermilk Ranch Dressing, Champagne Vinaigrette Dressing, Creamy Italian Dressing, Artichoke Heart, Baby Spinach, Albacore Solid Tuna in Water, Broccoli Floretts, Black Beans (Low Sodium), Blue Cheese Crumbles, Fresh Peeled Onions, Grape tomato, FF Raspberry Vinaigrette Dressing PC, Fat Free Italian Dressing, French Dressing, Dried Apricots, Fresh Lacinato Kale, Fresh Cucumber, Whole Baby Corn, VEG PEPPERS YELLOW 11 LBS AMBROGI, VEG PEPPERS GREEN LARGE AMBROGI', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (220852, 23501, 'Eggs Benedict', 'breakfast', 'scraped', 'overridden', 1000, 43, 40, 83, 'SERVING', NULL, NULL, NULL, NULL, '1 eggs benedict', false, true, '2026-07-18 11:44:54.878212', '2026-07-21 12:22:08.249149', 13773, 'pending', 'Canadian Bacon, Butter, Fresh Brown Cage Free Eggs, Hollandaise Sauce, Thomas''s English Muffin', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216815, 23506, 'Minestrone Soup', 'lunch', 'scraped', 'overridden', 58, 2, 10, 1, '8 OZ CUP', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-17 22:34:33.259863', '2026-07-21 12:21:23.694897', 7426, 'pending', 'Cabbage, Cubed Breakfast Potato, Cut Green Beans, Crushed Red Pepper, Chopped Spinach, Bay Leaf, Fresh Peeled Onions, Ground Black Pepper, Gluten Free Corn Rice Elbo Pasta, Fresh Celery, Fresh Carrots, Fresh Curley Parsley, Diced Tomatoes, Red Kidney Beans, Sunflower Oil, Whole Peeled Garlic, Vegetable Stock Base, Tomato Paste', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (216706, 23505, 'Toppings available for Oatmeal', 'breakfast', 'scraped', 'accepted', 222, 4, 41, 6, 'TOPPING', NULL, NULL, NULL, NULL, NULL, false, true, '2026-07-17 22:34:12.237898', '2026-07-21 12:22:20.690192', 29019, 'pending', 'Chia Seed, Dark Chocolate Chips , Brown Sugar PC, Amber Agave Nectar, Golden Seedless Raisins, Frozen Mango Pieces, Dried Craisins, Honey Squeeze Bottle, Organic Sunflower Kernal Seed, Unsalted No Shell Pumpkin Seed', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217443, 23501, 'GRAD YELLOW RICE', 'lunch', 'scraped', 'overridden', 78, 2, 14, 1, '3 OZ PORTION', NULL, NULL, NULL, NULL, '1 cup', false, true, '2026-07-18 11:44:00.717204', '2026-07-21 12:22:22.603079', 29325, 'pending', 'Kosher Salt, Kosher Salt, Organic Black Beans, Lime Juice, Fresh Cilantro, Diced Green Peppers, Diced Onion, Diced Celery, Diced Red Peppers, Ground Black Pepper, Fresh Thyme, Canola & Extra Virgin Olive Oil Blend, Canola Olive Oil Blend, Brown Rice, Bay Leaf, Turmeric, Water, Whole Kernal Corn', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219337, 23506, 'Texas Chicken Chowder', 'lunch', 'scraped', 'overridden', 305, 24, 28, 12, '12 oz. PORTION', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:33.436101', '2026-07-21 12:20:36.905093', 34470, 'pending', 'Pulled Cooked Pulled White Meat Chicken , Shoepeg Corn, Shredded Cheddar Cheese, Imported Olive Oil, Kosher Salt, Fresh Peeled Onions, Diced Green Chili Peppers, Crushed Red Pepper, Cumin Powder, Course Ground Black Pepper, CORN STARCH SLURRY, Chicken Stock, Ancho Chili Pepper, VEG BEANS BLACK FURMAN NOVICK, Whole Red Bliss Potatoes', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (226595, 23506, 'Black Bean Soup', 'lunch', 'scraped', 'accepted', 62, 4, 9, 1, 'SERVING 8 OUNCES', NULL, NULL, NULL, NULL, NULL, false, true, '2026-07-20 13:00:17.751786', '2026-07-21 12:20:00.935822', 7694, 'pending', 'XXXSAUCE TABASCO MCILHENNY, VEG PEPPERS GREEN LARGE AMBROGI, Vegetable Stock Base, Whole Thyme, Whole Peeled Garlic, Cumin Powder, Black Beans (Low Sodium), Fresh Peeled Onions, Fresh Curley Parsley, Diced Tomatoes, Dried Oregano Leaf, Salt, Smoked Ham Hock, Ground Black Pepper', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (226319, 23501, 'Chicken Cutlet Sandwich', 'lunch', 'scraped', 'accepted', 372, 28, 41, 11, '6 oz Serving', NULL, NULL, NULL, NULL, NULL, false, true, '2026-07-20 13:00:10.737214', '2026-07-21 12:19:42.924018', 7527, 'pending', 'Hamburger Roll, 4 OZ Boneless Skinless Chicken Breast', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (226320, 23501, 'Spaghetti & Meatballs', 'lunch', 'scraped', 'accepted', 930, 49, 125, 24, '1 SERVING', NULL, NULL, NULL, NULL, NULL, false, true, '2026-07-20 13:00:10.795573', '2026-07-21 12:19:42.976004', 27019, 'pending', 'Spaghetti Sauce, 1 OZ Beef Meatballs, 20" Spaghetti ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (226322, 23501, 'Sweet Potato Fry', 'lunch', 'scraped', 'accepted', 110, 2, 26, 0, '4 oz. SERVING', NULL, NULL, NULL, NULL, NULL, false, true, '2026-07-20 13:00:10.865001', '2026-07-21 12:19:43.079385', 30202, 'pending', 'Sweet Potato Fries', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (226323, 23501, 'Mark and Lennie''s Steak Sandwich', 'lunch', 'scraped', 'accepted', 533, 13, 66, 26, 'SANDWICH 6.5 OUNCES', NULL, NULL, NULL, NULL, NULL, false, true, '2026-07-20 13:00:11.961847', '2026-07-21 12:19:43.131224', 23374, 'pending', 'Whole Peeled Garlic, Whole Wheat Baguette , Local Portabello Mushrooms, Kraft Extra Heavy Mayonaise, Quinoa, Sunflower Oil, Spanish Onions, Sliced Plum Tomato, Balsamic Vinegar, Baby Spinach, Fresh Israeli Basil, Dijon Mustard', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219726, 23506, 'Pistou', 'lunch', 'scraped', 'overridden', 285, 12, 45, 9, '12 OZ. PORTION', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:44:39.373311', '2026-07-21 12:21:00.503939', 34469, 'pending', 'Cubed Breakfast Potato, Cut Green Beans, Fresh Basil, Diced Tomatoes, Fresh Zucchini, Grated Parmesan Cheese, Peeled Carrot, Kosher Salt, Imported Olive Oil, Gruyere Cheese, Spaghetti , Red Kidney Beans, Whole Peeled Garlic, White Kidney Beans, Vegetable Stock Base', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (217228, 23506, 'Spanish Style Mixed Vegetable Soup', 'lunch', 'scraped', 'overridden', 27, 1, 3, 2, 'SERVING 8 OUNCES', NULL, NULL, NULL, NULL, '1 bowl (1.5 cups)', false, true, '2026-07-18 11:43:55.988158', '2026-07-21 12:21:58.679708', 18302, 'pending', 'Ground Black Pepper, Potatoes, Sunflower Oil, Sacramento Tomato Juice, Salt, Cumin Powder, Fresh Eggplant, Fresh Flat Leaf Italian Parsley, Fresh Peeled Onions, Fresh Tomatoes, Fresh Zucchini, Whole Peeled Garlic, Vegetable Stock Base, Tomato Paste', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218271, 23501, 'Loco Moco', 'dinner', 'scraped', 'accepted', 834, 36, 99, 32, 'PORTION', NULL, NULL, NULL, NULL, NULL, false, true, '2026-07-18 11:44:17.054492', '2026-07-21 12:19:51.686371', 29194, 'pending', 'Granulated Sugar, Course Ground Black Pepper, Cayenne Powder, 4 OZ Beef Patty, Beef Stock with Soup Base, Pasture Raised Brown Eggs, Kosher Salt, Imported Sesame Oil, Jasmine Rice, Heinz Ketchup, Tamari Gold Soy Sauce Gluten Free, Scallions , Worcestershire Sauce ', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (219210, 23501, 'Chicken Fingers + Fries', 'dinner', 'scraped', 'overridden', 618, 31, 72, 26, 'PORTION', NULL, NULL, NULL, NULL, '1 plate', false, true, '2026-07-18 11:44:31.485168', '2026-07-21 12:20:29.161463', 28543, 'pending', 'Breaded Chicken Tender, Bulls Eye BBQ Sauce PC, Honey Mustard Dipping Sauce, Waffle Cut Fried Potatoes', false, NULL);
INSERT INTO public.menu_items_master (id, station_id, name, meal_type, nutrition_source, nutrition_status, scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size, override_calories, override_protein, override_carbs, override_fat, override_serving_size, is_customizable, is_active, created_at, updated_at, nutrislice_food_id, admin_review_status, scraped_ingredients, is_assorted, parent_item_id) VALUES (218813, 23511, 'M. T. O. Sandwiches, Wraps, + Paninis', 'dinner', 'scraped', 'accepted', 782, 26, 70, 50, 'CUSTOMER', NULL, NULL, NULL, NULL, NULL, false, true, '2026-07-18 11:44:25.739386', '2026-07-21 12:22:28.026256', 20658, 'pending', 'Local Green Leaf Lettuce, Pepper Jack Cheese Loaf, Kraft Extra Heavy Mayonaise, Guacamole Pico De Gallo, Guldens Brown Mustard, House Made Hummus, Honey Mustard Dressing, Sliced Land O Lakes American Cheese, Sliced Vegan Cheddar Cheese, Sunbutter Tub, Spinach Herb Tortilla Wrap, Sunflower Oil, Swiss Cheese, Shredded Lettuce, Roasted Vegetables, Romaine Lettuce, Red Onions, Provolone Grande Cheese, Premium Deli Roast Beef, Red & Green Sweet Pepper Strips, Chickpea Salad Pita , Crinkle Cut Bread & Butter Pickle, Black Pepper Ham, Arnold Country White Sliced Bread, 6" Hearth Hoagie Roll, Deli Hot Capicola , Deli Smoked Ham, Deli Genoa Salami, Deli Buffalo Chicken, Fresh Mozzarella Log Sliced, Fresh Sliced Tomato, Fresh Sliced Tomato, Grey Poupon Mustard, Turkey Breast, Vegan Falafel, Yellow Mustard', false, NULL);


--
-- Data for Name: option_groups; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--



--
-- Data for Name: options; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--



--
-- Data for Name: stations; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

INSERT INTO public.stations (id, dining_hall_id, name) VALUES (23502, 2, 'Spreadables Bar');
INSERT INTO public.stations (id, dining_hall_id, name) VALUES (23503, 2, 'Daily Breakfast');
INSERT INTO public.stations (id, dining_hall_id, name) VALUES (23688, 2, 'Heavenly Things');
INSERT INTO public.stations (id, dining_hall_id, name) VALUES (23506, 2, 'Soup');
INSERT INTO public.stations (id, dining_hall_id, name) VALUES (23501, 2, 'Traditions');
INSERT INTO public.stations (id, dining_hall_id, name) VALUES (23504, 2, 'Grains for Life');
INSERT INTO public.stations (id, dining_hall_id, name) VALUES (23511, 2, 'Auggies Deli');
INSERT INTO public.stations (id, dining_hall_id, name) VALUES (23508, 2, 'Padre Pizza & Pasta');
INSERT INTO public.stations (id, dining_hall_id, name) VALUES (23505, 2, 'Salad Bar');
INSERT INTO public.stations (id, dining_hall_id, name) VALUES (23509, 2, 'Desserts');
INSERT INTO public.stations (id, dining_hall_id, name) VALUES (23570, 2, 'The Fryery');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

INSERT INTO public.users (id, email, password_hash, daily_calorie_goal, created_at, updated_at, is_admin) VALUES (2, 'tmhansen16@gmail.com', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p362omNfenfR26acLdfvA2', 2000, '2026-06-18 18:13:26.502541', '2026-06-18 18:13:26.502541', true);
INSERT INTO public.users (id, email, password_hash, daily_calorie_goal, created_at, updated_at, is_admin) VALUES (3, 'trey', '$2b$10$xcFFW3ggY/Una4Kx/Ff/LOOpp.cqDK6zZ3V285f4PlRx79eDy8.o6', 2500, '2026-06-18 20:10:13.416234', '2026-06-18 20:10:13.416234', false);


--
-- Name: daily_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.daily_schedule_id_seq', 232554, true);


--
-- Name: dining_halls_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.dining_halls_id_seq', 5, true);


--
-- Name: meal_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.meal_logs_id_seq', 9, true);


--
-- Name: menu_items_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.menu_items_master_id_seq', 232550, true);


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

SELECT pg_catalog.setval('public.stations_id_seq', 25377, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


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
-- Name: idx_menu_items_parent; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_menu_items_parent ON public.menu_items_master USING btree (parent_item_id);


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
-- Name: menu_items_master menu_items_master_parent_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.menu_items_master
    ADD CONSTRAINT menu_items_master_parent_item_id_fkey FOREIGN KEY (parent_item_id) REFERENCES public.menu_items_master(id) ON DELETE CASCADE;


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

\unrestrict YTKfnPefDwWtTWvaAKssHvOMlHyc2Y5RL8esHnwYe1ImPBF0NS8JULwxCTxahBn

