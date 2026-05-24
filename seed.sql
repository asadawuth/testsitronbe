--
-- PostgreSQL database dump
--

\restrict rPaP4lbMC9zARSeHMbsiMSakeqHvQG7y4GzaoCJWpMAG8vtaRXJZwCGZgQv2d8j

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-05-22 18:56:08

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

--
-- TOC entry 862 (class 1247 OID 16686)
-- Name: movie_rating; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.movie_rating AS ENUM (
    'G',
    'PG',
    'M',
    'MA',
    'R'
);


ALTER TYPE public.movie_rating OWNER TO postgres;

--
-- TOC entry 859 (class 1247 OID 16678)
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'MANAGER',
    'TEAMLEADER',
    'FLOORSTAFF'
);


ALTER TYPE public.user_role OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 224 (class 1259 OID 16740)
-- Name: history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.history (
    id integer NOT NULL,
    user_id integer,
    movie_id integer,
    action character varying(20) NOT NULL,
    old_data json,
    new_data json,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.history OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16739)
-- Name: history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.history_id_seq OWNER TO postgres;

--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 223
-- Name: history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.history_id_seq OWNED BY public.history.id;


--
-- TOC entry 222 (class 1259 OID 16721)
-- Name: movies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movies (
    id integer NOT NULL,
    user_admin integer NOT NULL,
    title character varying(200) NOT NULL,
    release_year character varying(4) NOT NULL,
    type_movie public.movie_rating NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    image_url text,
    rate integer,
    CONSTRAINT movies_rate_check CHECK (((rate >= 1) AND (rate <= 100)))
);


ALTER TABLE public.movies OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16720)
-- Name: movies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.movies_id_seq OWNER TO postgres;

--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 221
-- Name: movies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movies_id_seq OWNED BY public.movies.id;


--
-- TOC entry 226 (class 1259 OID 16763)
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refresh_tokens (
    id integer NOT NULL,
    user_id integer NOT NULL,
    token text NOT NULL,
    device character varying(100),
    is_revoked boolean DEFAULT false NOT NULL,
    expires_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.refresh_tokens OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16762)
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.refresh_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.refresh_tokens_id_seq OWNER TO postgres;

--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 225
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.refresh_tokens_id_seq OWNED BY public.refresh_tokens.id;


--
-- TOC entry 220 (class 1259 OID 16698)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    first_name character varying(60) NOT NULL,
    last_name character varying(60) NOT NULL,
    tel character varying(10) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    role public.user_role DEFAULT 'FLOORSTAFF'::public.user_role NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16697)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4883 (class 2604 OID 16743)
-- Name: history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.history ALTER COLUMN id SET DEFAULT nextval('public.history_id_seq'::regclass);


--
-- TOC entry 4881 (class 2604 OID 16724)
-- Name: movies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movies ALTER COLUMN id SET DEFAULT nextval('public.movies_id_seq'::regclass);


--
-- TOC entry 4885 (class 2604 OID 16766)
-- Name: refresh_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('public.refresh_tokens_id_seq'::regclass);


--
-- TOC entry 4877 (class 2604 OID 16701)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 5055 (class 0 OID 16740)
-- Dependencies: 224
-- Data for Name: history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.history (id, user_id, movie_id, action, old_data, new_data, created_at) FROM stdin;
2	1	40	EDIT	{"title":"Insuyacha edits","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779289714360-866175616.jpg","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	{"title":"Insuyacha edits 2","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779293829639-461731047.png","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	2026-05-20 16:17:09.655
3	1	40	EDIT	{"title":"Insuyacha edits 2","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779293829639-461731047.png","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	{"title":"Insuyacha edits 3","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779294612522-44327302.png","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	2026-05-20 16:30:12.537
4	1	40	EDIT	{"title":"Insuyacha edits 3","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779294612522-44327302.png","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	{"title":"Insuyacha edits 4","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779300719744-517800029.png","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	2026-05-20 18:11:59.758
5	1	40	EDIT	{"title":"Insuyacha edits 4","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779300719744-517800029.png","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	{"title":"Insuyacha edits 6","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779300722567-835895012.png","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	2026-05-20 18:12:02.576
6	1	40	EDIT	{"title":"Insuyacha edits 6","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779300722567-835895012.png","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	{"title":"Insuyacha edits 7","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779300725677-246725849.png","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	2026-05-20 18:12:05.686
7	1	40	EDIT	{"title":"Insuyacha edits 7","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779300725677-246725849.png","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	{"title":"Insuyacha edits 8","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779300728121-980524310.png","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	2026-05-20 18:12:08.128
8	1	40	EDIT	{"title":"Insuyacha edits 8","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779300728121-980524310.png","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	{"title":"Insuyacha edits 9","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779300730866-931848069.png","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	2026-05-20 18:12:10.874
9	1	40	EDIT	{"title":"Insuyacha edits 9","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779300730866-931848069.png","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	{"title":"Insuyacha edits 10","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779300734505-526998469.png","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	2026-05-20 18:12:14.512
10	1	40	EDIT	{"title":"Insuyacha edits 10","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779300734505-526998469.png","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	{"title":"Insuyacha edits 11","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779300738002-706678136.png","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	2026-05-20 18:12:18.011
11	1	40	EDIT	{"title":"Insuyacha edits 11","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779300738002-706678136.png","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	{"title":"Insuyacha edits 12","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779332973186-680342389.jpg","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	2026-05-21 03:09:33.199
12	1	40	EDIT	{"title":"Insuyacha edits 12","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779332973186-680342389.jpg","rate":10,"created_at":"2026-05-20T14:44:58.625Z"}	{"title":"Insuyacha edits 13","release_year":"2000","type_movie":"PG","image_url":"/public/movies/1779333347966-470123439.webp","rate":100,"created_at":"2026-05-20T14:44:58.625Z"}	2026-05-21 03:15:47.989
13	1	46	EDIT	{"title":"ทดสอบModx2","release_year":"2222","type_movie":"MA","image_url":"/public/movies/1779439770699-907672779.jpg","rate":70,"created_at":"2026-05-22T08:49:30.705Z"}	{"title":"ทดสอบModx2 Edits","release_year":"2222","type_movie":"PG","image_url":"/public/movies/1779441567519-590347671.webp","rate":100,"created_at":"2026-05-22T08:49:30.705Z"}	2026-05-22 09:19:27.532
14	1	45	EDIT	{"title":"TestModx","release_year":"1111","type_movie":"MA","image_url":"/public/movies/1779439733426-306678067.webp","rate":45,"created_at":"2026-05-22T08:48:53.430Z"}	{"title":"TestModx Edits","release_year":"1111","type_movie":"MA","image_url":"/public/movies/1779439733426-306678067.webp","rate":45,"created_at":"2026-05-22T08:48:53.430Z"}	2026-05-22 09:55:04.448
15	1	46	EDIT	{"title":"ทดสอบModx2 Edits","release_year":"2222","type_movie":"PG","image_url":"/public/movies/1779441567519-590347671.webp","rate":100,"created_at":"2026-05-22T08:49:30.705Z"}	{"title":"ทดสอบModx2 Edits","release_year":"2222","type_movie":"PG","image_url":"/public/movies/1779443725809-6022632.jpg","rate":100,"created_at":"2026-05-22T08:49:30.705Z"}	2026-05-22 09:55:25.819
\.


--
-- TOC entry 5053 (class 0 OID 16721)
-- Dependencies: 222
-- Data for Name: movies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movies (id, user_admin, title, release_year, type_movie, created_at, image_url, rate) FROM stdin;
3	1	เรื่องแรก	2015	PG	2026-05-18 17:30:19.932	/public/movies/1779125419927-756857820.jpg	80
4	1	เรื่องที่สอง	2010	MA	2026-05-18 17:33:11.076	/public/movies/1779125591072-545167452.jpg	75
5	1	เรื่องที่สาม	2003	PG	2026-05-18 17:34:03.433	/public/movies/1779125643429-101517565.jpg	75
45	1	TestModx Edits	1111	MA	2026-05-22 08:48:53.43	/public/movies/1779439733426-306678067.webp	45
46	1	ทดสอบModx2 Edits	2222	PG	2026-05-22 08:49:30.705	/public/movies/1779443725809-6022632.jpg	100
6	1	ลอง Edits	2000	PG	2026-05-19 04:06:17.668	/public/movies/1779171461990-916227644.jpg	10
8	1	Naruto	2004	PG	2026-05-19 08:04:09.327	/public/movies/1779177849321-679229456.jpg	95
10	1	Demon Slayer	1888	MA	2026-05-19 08:06:34.183	/public/movies/1779177994179-869770962.jpg	100
11	1	4King	2025	R	2026-05-19 08:40:24.789	/public/movies/1779180024786-952649949.jpg	100
40	1	Insuyacha edits 13	2000	PG	2026-05-20 14:44:58.625	/public/movies/1779333347966-470123439.webp	100
43	1	TestPost	1999	MA	2026-05-21 09:51:01.578	/public/movies/1779357061574-760736994.jpg	80
\.


--
-- TOC entry 5057 (class 0 OID 16763)
-- Dependencies: 226
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refresh_tokens (id, user_id, token, device, is_revoked, expires_at, created_at) FROM stdin;
1	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTA3MzA3MywiZXhwIjoxNzc5Njc3ODczfQ.Bd9CdlM6NzI4imdU0P9ecrhCTLTP5YgmQ6QpRXzTjQc	PostmanRuntime/7.53.0	t	2026-05-25 02:57:53.013	2026-05-18 02:57:53.019
2	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTA3NTE1NywiZXhwIjoxNzc5Njc5OTU3fQ.__GoXcCafgbLnLWwC-krmyRki4JSvdm6bJLHf5RZHDU	PostmanRuntime/7.53.0	t	2026-05-25 03:32:37.733	2026-05-18 03:32:37.735
3	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTA3NTE3MiwiZXhwIjoxNzc5Njc5OTcyfQ.m-N6pFVpdWPo9lvazReKSORxA47GPMBRFgZRVp4pYjc	PostmanRuntime/7.53.0	t	2026-05-25 03:32:52.526	2026-05-18 03:32:52.528
4	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTA4ODYxNywiZXhwIjoxNzc5NjkzNDE3fQ.7rsstUZZ7OkMS9rrsB0CE4jYMcYBWbgUTEdiONGen98	PostmanRuntime/7.53.0	t	2026-05-25 07:16:57.616	2026-05-18 07:16:57.618
5	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTA5MTYyNiwiZXhwIjoxNzc5Njk2NDI2fQ.3PbppxiM9sTZ0BJ7Jq8ktTxu0Dqb-T4wtO9OjAgBhJI	PostmanRuntime/7.53.0	t	2026-05-25 08:07:06.16	2026-05-18 08:07:06.164
6	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTA5MjE2OCwiZXhwIjoxNzc5Njk2OTY4fQ.bwNUY5UzMJuWgy_m4Q43JjJVGopPgRI3Nm-x0UiLSSk	PostmanRuntime/7.53.0	t	2026-05-25 08:16:08.562	2026-05-18 08:16:08.564
7	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTA5MzcyNCwiZXhwIjoxNzc5Njk4NTI0fQ.1vpUdiC-WcyHqoLqfJ2jNB94xWUMdmAJUgUWDneAPS4	PostmanRuntime/7.53.0	t	2026-05-25 08:42:04.919	2026-05-18 08:42:04.921
8	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTA5NDYxNSwiZXhwIjoxNzc5Njk5NDE1fQ.GFBy3Y0ZHK6Ap5ybCIWOT2m9vVZVEmloqurSnY8ljoM	PostmanRuntime/7.53.0	t	2026-05-25 08:56:55.247	2026-05-18 08:56:55.248
9	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTA5NjIxNSwiZXhwIjoxNzc5NzAxMDE1fQ.F_z6FcJcq4SdnZzU9kF-avVnzyXOSQy6LvyzZZ9uGlA	PostmanRuntime/7.53.0	t	2026-05-25 09:23:35.465	2026-05-18 09:23:35.475
10	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTA5NzIyOSwiZXhwIjoxNzc5NzAyMDI5fQ.XCzl4hdyHjHrkh9liJ6c8lJwKRkkz5WLx5XL5gN6a4k	PostmanRuntime/7.53.0	t	2026-05-25 09:40:29.477	2026-05-18 09:40:29.48
11	1	test123	PostmanRuntime/7.53.0	t	2026-05-25 09:43:05.359	2026-05-18 09:43:05.362
12	1	test123	\N	t	2026-05-25 09:45:24.868	2026-05-18 09:45:24.871
13	1	test123	\N	t	2026-05-25 09:51:29.828	2026-05-18 09:51:29.831
14	1	test123	\N	t	2026-05-25 09:52:33.725	2026-05-18 09:52:33.727
15	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTA5ODY0NiwiZXhwIjoxNzc5NzAzNDQ2fQ.yE-YsIQN1oihbbJX3kq9cyoBEYfn965358B_xx0UG3k	PostmanRuntime/7.53.0	t	2026-05-25 10:04:06.999	2026-05-18 10:04:07.001
16	1	sjsjsj	\N	t	2026-05-25 10:06:30.323	2026-05-18 10:06:30.33
17	1	sjsjsj	unknown-device	t	2026-05-25 10:07:00.251	2026-05-18 10:07:00.263
18	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTA5ODk2MCwiZXhwIjoxNzc5NzAzNzYwfQ.d1QOHG1zSa42o0TSKFKUkWf3ikjrttVRluCWH-kXE_Y	PostmanRuntime/7.53.0	t	2026-05-25 10:09:20.683	2026-05-18 10:09:20.693
19	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTA5OTMxNCwiZXhwIjoxNzc5NzA0MTE0fQ.jo6XkHB2kVxJkWnydJNw3XyZ3SCW0W-MKIrVVBwGNs0	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 10:15:14.973	2026-05-18 10:15:14.975
20	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTA5OTk5NSwiZXhwIjoxNzc5NzA0Nzk1fQ.MUpQ11v6iCOeUf1-AUxKtSnC0SMdnCsVmh22h3vkBmo	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 10:26:35.871	2026-05-18 10:26:35.876
21	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEwMDg3MCwiZXhwIjoxNzc5NzA1NjcwfQ.lo43uwGdOxsV-p9bM4IhbavLU60sjm4CW7Yu6__NSfU	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 10:41:10.682	2026-05-18 10:41:10.685
22	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEwNDA5NywiZXhwIjoxNzc5NzA4ODk3fQ.tGXO7GOG7bNdEUcawQiAPLmsygZbf0beHB9bgg1Ynfw	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 11:34:57.49	2026-05-18 11:34:57.492
23	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEwNDIyNywiZXhwIjoxNzc5NzA5MDI3fQ.RUeJWdJbL_GZIhoGYq4THNyO7iqyAJmbQZIPxyIZLIw	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 11:37:07.69	2026-05-18 11:37:07.692
126	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI2NTkyNSwiZXhwIjoxNzc5ODcwNzI1fQ.rrrcWZLDxfo9r_MjwKwqNlxkBuzQXL9I12_H-bZA0wQ	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 08:32:05.141	2026-05-20 08:32:05.143
142	3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc3OTI4NTAyNiwiZXhwIjoxNzc5ODg5ODI2fQ.HLSfL8ks8zxz0H0UVyhAl210-Bw_l0_wp-Eo-p7mjas	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 13:50:26.217	2026-05-20 13:50:26.218
178	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM0OTcwOCwiZXhwIjoxNzc5OTU0NTA4fQ.fQnbSm_0qpYcrcoaTUq0pmj9BTEaTM8QDdmB0GJXz0U	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 07:48:28.616	2026-05-21 07:48:28.618
134	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI3NDUzOCwiZXhwIjoxNzc5ODc5MzM4fQ.dwB9PrWAe9JpPSXtpJEwkDDUf6VWXqu5Cu2PGYZFtuc	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 10:55:38.953	2026-05-20 10:55:38.958
199	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTQxOTQ3MCwiZXhwIjoxNzgwMDI0MjcwfQ.1QYuRVBpQKqGnwk3k6XrzhrhE3kK00s6XuInL6bSFi0	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-29 03:11:10.7	2026-05-22 03:11:10.703
127	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI2NjQyMywiZXhwIjoxNzc5ODcxMjIzfQ.-S5M5wCjVwt_7TkYBUL85FpwkAj1jHiOQ8QwSinjPt8	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 08:40:23.123	2026-05-20 08:40:23.125
135	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI3ODA0NiwiZXhwIjoxNzc5ODgyODQ2fQ.Y2pBY3lJClgCNSYswVrGOklWLJYt3-y8gQ7vRBtlwe8	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 11:54:06.782	2026-05-20 11:54:06.784
26	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTEwNDMzMiwiZXhwIjoxNzc5NzA5MTMyfQ.-oaLVDtNLeKq86ruGWQf-SuYFqStHdYmT75xHgRe_aY	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 11:38:52.554	2026-05-18 11:38:52.556
27	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTEwNDM0MiwiZXhwIjoxNzc5NzA5MTQyfQ.DwtJ0zc3BVPZKBveSBnxB9QCUZ_3ElsGtopRzkJYIOw	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 11:39:02.539	2026-05-18 11:39:02.54
29	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTEwNDQyNSwiZXhwIjoxNzc5NzA5MjI1fQ.8dBz_lGBN0MR33MVL1_4bVqa7oWgHIPGkQnhCiIqtV0	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 11:40:25.842	2026-05-18 11:40:25.843
32	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTEwNDQ1NiwiZXhwIjoxNzc5NzA5MjU2fQ.9JuPgqgPxpvWiuHD0-oNHAqz3EN6Aat3JsK9pINLfPs	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 11:40:56.443	2026-05-18 11:40:56.444
35	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTEwNDc0MiwiZXhwIjoxNzc5NzA5NTQyfQ.hwgDsrd8WWlsrceNiCEQyvV9n0ni2Odn3dP3V1ACnOc	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 11:45:42.66	2026-05-18 11:45:42.663
46	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTEwNzIzMiwiZXhwIjoxNzc5NzEyMDMyfQ.H_DPEix3nm7KpuTrCB1EyFqpo5XOvLQ7BLylsBa38mA	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 12:27:12.78	2026-05-18 12:27:12.782
48	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTEwOTI5NCwiZXhwIjoxNzc5NzE0MDk0fQ.O7fmRnLDZOguWgre_p2N8slDZcbzAK46xl7jB0rVKBI	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 13:01:34.968	2026-05-18 13:01:34.969
30	3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc3OTEwNDQzMiwiZXhwIjoxNzc5NzA5MjMyfQ.znqPs3JLpMG03CZ8LqHdmTFxHS2o4DEZ6TGORqs_MGo	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 11:40:32.07	2026-05-18 11:40:32.071
33	3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc3OTEwNDQ2MCwiZXhwIjoxNzc5NzA5MjYwfQ.J_8d3bmGrzQE_VG_ph-LILgSwvmkglZWE0V5PkSBJEg	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 11:41:00.803	2026-05-18 11:41:00.804
36	3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc3OTEwNDc0NiwiZXhwIjoxNzc5NzA5NTQ2fQ.8LEUm6O5nMp3V-LrJqOE55OTErnmDToAxmXrtkGjlzo	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 11:45:46.142	2026-05-18 11:45:46.143
49	3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc3OTEwOTc5NCwiZXhwIjoxNzc5NzE0NTk0fQ.c_qzBynKS_HRynaQsqLph1NUCUlMnQtIn2P1zcOXx2k	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 13:09:54.728	2026-05-18 13:09:54.729
151	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI5NTAzNSwiZXhwIjoxNzc5ODk5ODM1fQ.vjX86GhETqbuCVCEchyrIyWIoEodeLs88RYdhNn8tE0	PostmanRuntime/7.53.0	t	2026-05-27 16:37:15.607	2026-05-20 16:37:15.608
143	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTI4NTUwMiwiZXhwIjoxNzc5ODkwMzAyfQ.KYvrAATfCjx2zBxqQGRCfs9WxjYhgDwiOD10X9Z88u8	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 13:58:22.548	2026-05-20 13:58:22.55
24	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEwNDIzMywiZXhwIjoxNzc5NzA5MDMzfQ.uAeLFvrpuLBAaSLkqqf5v-ehIY4DpQ-AVgJJ6jGHwbs	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 11:37:13.126	2026-05-18 11:37:13.129
25	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEwNDMyMiwiZXhwIjoxNzc5NzA5MTIyfQ.cPn4zK0NSimaKu02VQZrnUFAhsdyvdl4f0gcjO9FtDM	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 11:38:42.184	2026-05-18 11:38:42.185
28	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEwNDQxOSwiZXhwIjoxNzc5NzA5MjE5fQ.incMi2MzHSapsDw3bbm9OpwczsXSsGmiSWI0Db8ZLM0	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 11:40:19.954	2026-05-18 11:40:19.955
31	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEwNDQ1MiwiZXhwIjoxNzc5NzA5MjUyfQ.jCbfW2r0pp0Q4crjo4pZHmblMJTJgT_O4JEzSb0UA_c	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 11:40:52.421	2026-05-18 11:40:52.423
34	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEwNDczOCwiZXhwIjoxNzc5NzA5NTM4fQ.CD4cUY47ZhCAn6cPUFtjXrrsokXG82JGbYrxAgvTTlo	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 11:45:38.202	2026-05-18 11:45:38.203
37	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEwNDc3OCwiZXhwIjoxNzc5NzA5NTc4fQ.ctsmIEHnwTa8oXTburudy92va_tuBpjYjpLNtw6OACY	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 11:46:18.4	2026-05-18 11:46:18.401
38	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEwNTE4NCwiZXhwIjoxNzc5NzA5OTg0fQ.LR4hjEjgGPQ9R6JqB39UYg9XvVOz6bV54nXNjOj_cRs	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 11:53:04.426	2026-05-18 11:53:04.427
39	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEwNTI5NiwiZXhwIjoxNzc5NzEwMDk2fQ.MRIO0A4NS0oxjz9BoYVkDYk_rFGvHkq4U2LC39QNXMw	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 11:54:56.803	2026-05-18 11:54:56.805
40	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEwNTYxOCwiZXhwIjoxNzc5NzEwNDE4fQ.3_CHbTxyYeE-vR_53EQSyQx9SYj4zVZ8mNZqPw4seYU	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 12:00:18.754	2026-05-18 12:00:18.755
41	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEwNTY1NSwiZXhwIjoxNzc5NzEwNDU1fQ.OFluBuBE1t6vnbwr0mEzFuTUc-8RFibcDvcgBaxL_Xk	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 12:00:55.739	2026-05-18 12:00:55.74
42	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEwNjc1MSwiZXhwIjoxNzc5NzExNTUxfQ.vUI8YRVGha0pikH8gYS0FHMufiwK54o5tobroSIeL-Q	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 12:19:11.555	2026-05-18 12:19:11.556
43	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEwNjc3MywiZXhwIjoxNzc5NzExNTczfQ.XqQ4IDQnUKVekBRvlIiZ9giFT0QjIA4F5umCdGeQh_M	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 12:19:33.063	2026-05-18 12:19:33.065
44	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEwNjgwNiwiZXhwIjoxNzc5NzExNjA2fQ.klQE3a1ybHA5iAFeuOWNpf4We-o-YWI5SMq4MCpzp9Y	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 12:20:06.784	2026-05-18 12:20:06.785
45	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEwNzIyNywiZXhwIjoxNzc5NzEyMDI3fQ.RH8DTS0I3EuUUzrw5mnSmYVVd03zaOcacFb1HmBivkc	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 12:27:07.042	2026-05-18 12:27:07.044
47	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEwODI3NCwiZXhwIjoxNzc5NzEzMDc0fQ.AETgzhbYaEdwfK3N0evOnWb91NplJE89YMUaSsah2yo	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 12:44:34.787	2026-05-18 12:44:34.788
52	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTExMDM1OCwiZXhwIjoxNzc5NzE1MTU4fQ.LRZKNXX_ioZfqBSIL2ZX7_t9AROav2D6DMKoh0Dc7cM	PostmanRuntime/7.53.0	t	2026-05-25 13:19:18.664	2026-05-18 13:19:18.665
58	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTExMjI1NywiZXhwIjoxNzc5NzE3MDU3fQ.9Kcz9QUmzp2kmFcGsB5fQsclVd6TNZ-GKyaSNfuDd1A	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 13:50:57.812	2026-05-18 13:50:57.815
59	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTExMjI3MywiZXhwIjoxNzc5NzE3MDczfQ.wFZ049ezEgWrwvLamhQ6Kspk8QFwaQg0U_TkIVOeqDE	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 13:51:13.842	2026-05-18 13:51:13.844
57	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTExMTg3MiwiZXhwIjoxNzc5NzE2NjcyfQ.5tss8_vxASDlarnZaE5uKbFetnPXw_e2dcZCfK-1Aaw	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 13:44:32.74	2026-05-18 13:44:32.742
50	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTExMDIzMywiZXhwIjoxNzc5NzE1MDMzfQ.huOMCDZDXPBqbs2YAoLSr1Wc0pFCNg1uQ0Xi7gOA0D8	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 13:17:13.117	2026-05-18 13:17:13.118
53	3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc3OTExMDQ0OCwiZXhwIjoxNzc5NzE1MjQ4fQ.-IeSjfWjXLIOz3urjm_jyMdm35oPeYRDajQl3nWICw4	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 13:20:48.007	2026-05-18 13:20:48.01
136	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTI3OTA0OSwiZXhwIjoxNzc5ODgzODQ5fQ.5FgdPpUcq5qp8J14WUpGQZ270YQ55KG80gWlJdNzVw8	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 12:10:49.292	2026-05-20 12:10:49.293
60	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTExMjI5OCwiZXhwIjoxNzc5NzE3MDk4fQ.BUkDsx1QV9RdOwuRWTXgNQ9sUQ4ItMuhgKebnQznq1Q	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 13:51:38.667	2026-05-18 13:51:38.668
61	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTExMjMzNSwiZXhwIjoxNzc5NzE3MTM1fQ.5qLFvtofxJSzhx8lBQmYU7186pLqZdujnH7b_BGMZOE	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 13:52:15.911	2026-05-18 13:52:15.912
62	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTExNDg3MCwiZXhwIjoxNzc5NzE5NjcwfQ.ZjOo0a0cW7dac1DNXHOkrtUnBaCSjV4c38BcBDiFyjY	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 14:34:30.198	2026-05-18 14:34:30.203
63	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTExNDk2NCwiZXhwIjoxNzc5NzE5NzY0fQ.wanEaB4AH3ax8tnlyXnsxaZQQI31bBFSbqKNUulZl8w	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 14:36:04.061	2026-05-18 14:36:04.072
66	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTExNjA1OCwiZXhwIjoxNzc5NzIwODU4fQ.x1jY6Hqia1725-QdEqhk-saQ_PLSMVJyh13yaVPeZfQ	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 14:54:18.232	2026-05-18 14:54:18.234
67	3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc3OTExNjEwNiwiZXhwIjoxNzc5NzIwOTA2fQ.ahZlEs3DfLiaAF29hmnbMNS-buay2Fvry-UnewJSZQs	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 14:55:06.46	2026-05-18 14:55:06.461
68	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTExNjIwNSwiZXhwIjoxNzc5NzIxMDA1fQ.KSfYZe_XlBav79UA9sV4y1FQRdM5v3IdYJLa1wrwfnk	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 14:56:45.862	2026-05-18 14:56:45.863
69	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTExNjU2OCwiZXhwIjoxNzc5NzIxMzY4fQ.sUS0Z9fIYhbOVgFkAHWvMT1ZEfhsM9mVrV-cbU3lJ2o	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 15:02:48.246	2026-05-18 15:02:48.247
51	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTExMDI5NSwiZXhwIjoxNzc5NzE1MDk1fQ.rPyM92e5NB4FpxAX-2ozR5sUmvatCBe80F-CkXKAvzM	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 13:18:15.399	2026-05-18 13:18:15.4
54	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTExMDU2NCwiZXhwIjoxNzc5NzE1MzY0fQ.kSJRl3RHL2KcEcmzqwiiykk6tpIrb-r8IB4tWatcXMU	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 13:22:44.591	2026-05-18 13:22:44.592
55	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTExMTQwNSwiZXhwIjoxNzc5NzE2MjA1fQ.UEnrrinXjOOTlxK0urR4srXNeWuHnmKmqtunPeZtIwE	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 13:36:45.349	2026-05-18 13:36:45.351
56	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTExMTQ1NCwiZXhwIjoxNzc5NzE2MjU0fQ.hVJ5wg4iBLTR8XsXhEoXAO31lkLXKsDDlIse3DZFmdE	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 13:37:34.834	2026-05-18 13:37:34.836
64	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTExNTEwNSwiZXhwIjoxNzc5NzE5OTA1fQ.uDqGaHy0Qa-VskOgBxVBudyadNhs_B-3wVpfVzwXzkQ	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 14:38:25.202	2026-05-18 14:38:25.204
65	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTExNTg2MiwiZXhwIjoxNzc5NzIwNjYyfQ.kZlvh_Rr2IGE7I1FG-YPnolt-M0ZUcODkY9yRPOK37E	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 14:51:02.883	2026-05-18 14:51:02.884
70	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTExNjU5NiwiZXhwIjoxNzc5NzIxMzk2fQ.lN1RNTVv60vqkys6yOY6J1Q5EBv2UYtD3AXFI1jvZJQ	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 15:03:16.137	2026-05-18 15:03:16.138
71	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTExNjYwMywiZXhwIjoxNzc5NzIxNDAzfQ.qAZLsdqmEWjZx6LxxRkKLXVn0dO5MxI8Lg6h1qIhtyI	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 15:03:23.587	2026-05-18 15:03:23.588
145	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTI4NjczMiwiZXhwIjoxNzc5ODkxNTMyfQ.NKvbwa5LBMK0KMujl-i3Ea6iz7gp6IZKSLL_cZRzvyY	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 14:18:52.892	2026-05-20 14:18:52.894
78	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTEzMTU5NCwiZXhwIjoxNzc5NzM2Mzk0fQ.6F6opOV7lFVUGNYA2i9FKS31L_nzsnwC03pO6begtGw	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 19:13:14.533	2026-05-18 19:13:14.535
79	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEzMTc2OSwiZXhwIjoxNzc5NzM2NTY5fQ.rAwf38u-oNvT08goq277bJdPoJoGX8zOzFRAto1a1FU	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 19:16:09.331	2026-05-18 19:16:09.332
174	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM0ODkxMSwiZXhwIjoxNzc5OTUzNzExfQ.VD18MkCyBhPGml3mwKkMWo0KAUOUg_YX-UCHtqh9ieU	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 07:35:11.784	2026-05-21 07:35:11.787
195	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM1NjY5OCwiZXhwIjoxNzc5OTYxNDk4fQ.ZamD6QQ-iYQq2OQD76y0r40N6KsBlTe9qbzqhceb-9g	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 09:44:58.829	2026-05-21 09:44:58.83
150	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI5NDU4OSwiZXhwIjoxNzc5ODk5Mzg5fQ.B5MrlltiCrSg-cHyEFEuU-4wU9qqmQaK30n__EorWns	PostmanRuntime/7.53.0	t	2026-05-27 16:29:49.05	2026-05-20 16:29:49.051
158	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTMwMDcwMSwiZXhwIjoxNzc5OTA1NTAxfQ.meBLNUT6c9UGF7YZiarX0SjYYyafnmh2zHu7rXKnlZs	PostmanRuntime/7.53.0	t	2026-05-27 18:11:41.267	2026-05-20 18:11:41.269
165	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTMzNzMxMywiZXhwIjoxNzc5OTQyMTEzfQ.fSBCaRGH8NPM8lK8V-wzCRb8b_chVhSBXQyl5qquxLY	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 04:21:53.995	2026-05-21 04:21:54
171	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM0NzEwNiwiZXhwIjoxNzc5OTUxOTA2fQ.7CNxeEssh2HCK2pWhcbctCp01BHVFqHOm4hzdcmZ0PU	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome	t	2026-05-28 07:05:06.633	2026-05-21 07:05:06.635
93	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE3MTYwMSwiZXhwIjoxNzc5Nzc2NDAxfQ.u-buBHPARLrR2GasecxZ-5Inz9-MyEXSeJRlBU5n7JQ	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-26 06:20:01.359	2026-05-19 06:20:01.363
187	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM1MDk4MywiZXhwIjoxNzc5MzUxMjgzfQ.DETUf4cnz7GzpQ7ysptk2RYY3AUh2xLpEGMr1rz15Fs	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 08:09:43.683	2026-05-21 08:09:43.685
189	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM1MTIxNSwiZXhwIjoxNzc5OTU2MDE1fQ.Mgmwa2hss3BycOXnUbTcHwYkRdQ4TVo5HIXLRdbPuss	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 08:13:35.396	2026-05-21 08:13:35.399
159	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTMwMTE2MSwiZXhwIjoxNzc5OTA1OTYxfQ.1NCmsUvkNl3KgTtMYNULTXYUtaKIpijxTYeS9m6axjA	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 18:19:21.459	2026-05-20 18:19:21.462
166	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM0MzUzMSwiZXhwIjoxNzc5OTQ4MzMxfQ.TepSNdccpyPG-OVv0x0zHcM_Ylsmgmihrp6tHpY_x8s	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 06:05:31.868	2026-05-21 06:05:31.869
172	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM0Nzg0MywiZXhwIjoxNzc5OTUyNjQzfQ.oW01s_TfuGJz1er_P8GX-RH5lOg7Tz3iFiMgRCoYInk	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 07:17:23.525	2026-05-21 07:17:23.526
80	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTEzMTk3OCwiZXhwIjoxNzc5NzM2Nzc4fQ.QCDLuPvbnwK-WPkEnkF3CYymZW2MIR3YcJSLbdwrETk	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 19:19:38.294	2026-05-18 19:19:38.295
72	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEyNDEyOCwiZXhwIjoxNzc5NzI4OTI4fQ.W0F0Ey-_lY9Lohw-wbHDCTUQKMtojSoHqpXADN69Tsw	PostmanRuntime/7.53.0	t	2026-05-25 17:08:48.485	2026-05-18 17:08:48.487
73	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEyNDU4OCwiZXhwIjoxNzc5NzI5Mzg4fQ.FmtsZM1bVjW41MeChzrSJfd_7bLCUdEuxEM47Mp1WzA	PostmanRuntime/7.53.0	t	2026-05-25 17:16:28.377	2026-05-18 17:16:28.379
74	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEyNTU3OSwiZXhwIjoxNzc5NzMwMzc5fQ.ydnI_Trb_MDvNa9pLrmH82oP81G0QMRLMtJP-d-vfug	PostmanRuntime/7.53.0	t	2026-05-25 17:32:59.357	2026-05-18 17:32:59.358
130	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI2OTE5MCwiZXhwIjoxNzc5ODczOTkwfQ.1LzPc1T2zXUOo0Yk2FmHujVZriH0Uld7Wh3nIuM7a9c	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 09:26:30.077	2026-05-20 09:26:30.078
101	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE3OTI5NiwiZXhwIjoxNzc5Nzg0MDk2fQ.qHyO4GZpeMmxMEf3A3CJ5su2oOWrXbay06Z1Rft2G1k	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-26 08:28:16.628	2026-05-19 08:28:16.63
106	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE4Mzc1NywiZXhwIjoxNzc5Nzg4NTU3fQ.PHDzHpr14PHE3KCRTKanGdDtMF0bmuCUd0BAx5B2ISg	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-26 09:42:37.177	2026-05-19 09:42:37.178
108	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE4NjI2MSwiZXhwIjoxNzc5NzkxMDYxfQ.x_7kUJUK10_DtEvE7B8LwIae2Lg0tpVfO00V8FXmwnI	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-26 10:24:21.849	2026-05-19 10:24:21.851
117	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI2MTMyMCwiZXhwIjoxNzc5ODY2MTIwfQ.MOGu0MN5Rnn1zwZHHd6j1ZzZORgawZvrF55nV8XRJoo	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 07:15:20.902	2026-05-20 07:15:20.904
100	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTE3ODk3NCwiZXhwIjoxNzc5NzgzNzc0fQ.9qLC4fEHjcQcklA6cYScGEOwT9Bm6-rbgXknF2cm-Pw	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-26 08:22:54.966	2026-05-19 08:22:54.969
118	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTI2MTM3MywiZXhwIjoxNzc5ODY2MTczfQ.7aWtYHWAZCSCVImUqzjcBr0gEubk0WQNYC-WaVwDSpg	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 07:16:13.551	2026-05-20 07:16:13.553
99	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE3ODAwMywiZXhwIjoxNzc5NzgyODAzfQ.TxiSUW8ThqiA6gs8UblEXMFREK18ICBTmSmkeEu0rTc	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-26 08:06:43.617	2026-05-19 08:06:43.618
102	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE3OTUyNCwiZXhwIjoxNzc5Nzg0MzI0fQ.rTxDjQJPGjS5CKkoUyCBnuDcwu9JoSRcou1nO974T1c	PostmanRuntime/7.53.0	t	2026-05-26 08:32:04.201	2026-05-19 08:32:04.202
103	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE4MDAwMCwiZXhwIjoxNzc5Nzg0ODAwfQ.69xozA9QQhVToVSeY6V0D0FRFJ9N6Tb3Oy10c19Vcbw	PostmanRuntime/7.53.0	t	2026-05-26 08:40:00.594	2026-05-19 08:40:00.596
104	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE4MDc4MSwiZXhwIjoxNzc5Nzg1NTgxfQ.S-sbK6kydv3ZdOBdRg45t3oexq6_J40ekpY97ygwtTs	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-26 08:53:01.5	2026-05-19 08:53:01.502
105	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE4MjYxMSwiZXhwIjoxNzc5Nzg3NDExfQ.M7R4cHe6Xufmys63IptEdWANCRUbqjWhv1oU1V8COgE	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-26 09:23:31.73	2026-05-19 09:23:31.732
107	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE4NDE4NSwiZXhwIjoxNzc5Nzg4OTg1fQ.W8NEuWFgXxdnT51xOSR6vfKNy7LFwkRiLHUrwfvSMF0	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-26 09:49:45.729	2026-05-19 09:49:45.734
193	3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc3OTM1NDE0NywiZXhwIjoxNzc5OTU4OTQ3fQ.q4LRnEWLrqGLipTuSB-b3iySUUCWh7TjUYGmnhCDjxg	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 09:02:27.934	2026-05-21 09:02:27.936
179	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM0OTc3NywiZXhwIjoxNzc5OTU0NTc3fQ.-XjkBTLL--j5p0DcDwkCEsndvahCHpPxQJTyemPTxJQ	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 07:49:37.456	2026-05-21 07:49:37.458
180	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM0OTg1NSwiZXhwIjoxNzc5OTU0NjU1fQ.INWEKODV4fryiWD4XqvfRmx1-ssGvHbSqkLXFb3r56Q	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 07:50:55.259	2026-05-21 07:50:55.261
190	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM1MjkwMiwiZXhwIjoxNzc5MzUzMjAyfQ.KJVRdsCP5JimkPrXsZjX-RYlFZ-aM8c8j4eQ4F6zaBw	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 08:41:42.943	2026-05-21 08:41:42.944
131	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI3MTczNywiZXhwIjoxNzc5ODc2NTM3fQ.vnehx3IXc2dLcpN2Pn-Ip1Uv_qIawIXUQ-8HgZvf2CQ	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 10:08:57.484	2026-05-20 10:08:57.487
120	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI2Mjg3NywiZXhwIjoxNzc5ODY3Njc3fQ.sQOQSQWc9NvD0qvMi41-QNvVKKsiQDeob4C--cMc4F8	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 07:41:17.003	2026-05-20 07:41:17.004
121	3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc3OTI2MzI1OCwiZXhwIjoxNzc5ODY4MDU4fQ.1xzLacQe0RcCIDD-9L4gC5RwBpmKpxoKE4ktk5pPCiM	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 07:47:38.168	2026-05-20 07:47:38.17
123	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI2NDMzNSwiZXhwIjoxNzc5ODY5MTM1fQ.1FpwK3Citj_5LkK-OsOFXp28eBHF_2dDNxTvwV0yZ_k	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 08:05:35.674	2026-05-20 08:05:35.678
75	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEyNzE2MCwiZXhwIjoxNzc5NzMxOTYwfQ.j3T7ULxggwb5I_Np0WPLPMstBjyusp6WgLFSIfqG2Kk	PostmanRuntime/7.53.0	t	2026-05-25 17:59:20.114	2026-05-18 17:59:20.116
76	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEyODY4NSwiZXhwIjoxNzc5NzMzNDg1fQ.I1HUI3xSXjcJ-XJoNyo8GIEe9b5N_38lLrNxI5Ny5VU	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-25 18:24:45.254	2026-05-18 18:24:45.256
77	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTEyOTc3NiwiZXhwIjoxNzc5NzM0NTc2fQ.ssFCRBjkh3HAPU7eDzEBTauaA3SsclK9907k4qbiwgQ	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome	t	2026-05-25 18:42:56.213	2026-05-18 18:42:56.215
81	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE2MzMwOCwiZXhwIjoxNzc5NzY4MTA4fQ.pz1jT_Hgwvd2VSW0JojhkYRVfkeH5EFwQ0bGrccCPnw	PostmanRuntime/7.53.0	t	2026-05-26 04:01:48.058	2026-05-19 04:01:48.059
82	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE2MzQ3OSwiZXhwIjoxNzc5NzY4Mjc5fQ.D6WJqBG3ZXG3En7_ZNi0GN32vKroXbwASXeqyV9L4mQ	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-26 04:04:39.425	2026-05-19 04:04:39.427
83	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE2MzU1MCwiZXhwIjoxNzc5NzY4MzUwfQ.3WuYYLz4kNoK_tKs7iV-uAoK1Fev-gLs1zKZxaFbt1I	PostmanRuntime/7.53.0	t	2026-05-26 04:05:50.921	2026-05-19 04:05:50.923
84	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE2MzY0MCwiZXhwIjoxNzc5NzY4NDQwfQ.UjD-CpfIz83QsJN1AVidDK60qc2c1142dUL8avJAHRU	PostmanRuntime/7.53.0	t	2026-05-26 04:07:20.069	2026-05-19 04:07:20.076
85	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE2NTIzNiwiZXhwIjoxNzc5NzcwMDM2fQ.10Ojc6P9xlA-r3e4o0ts6s4Qu-_A_PnikpcvWpFShcg	PostmanRuntime/7.53.0	t	2026-05-26 04:33:56.655	2026-05-19 04:33:56.667
86	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE2NTMwMywiZXhwIjoxNzc5NzcwMTAzfQ.k4hR6CS8OwuQ8zknVCJaKQHOH6Kadx72P7UCdPw5BPo	PostmanRuntime/7.53.0	t	2026-05-26 04:35:03.72	2026-05-19 04:35:03.722
87	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE2NzA0NywiZXhwIjoxNzc5NzcxODQ3fQ.Y_6xSu2dyf2Se0HHRVFshwX-9fhuImJKp8fJN7VsRPk	PostmanRuntime/7.53.0	t	2026-05-26 05:04:07.246	2026-05-19 05:04:07.247
88	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE2Nzc0OSwiZXhwIjoxNzc5NzcyNTQ5fQ.JunxtkpCdupol2j7U9UMhaoNDnkvLH07Ga92LfF6PGc	PostmanRuntime/7.53.0	t	2026-05-26 05:15:49.07	2026-05-19 05:15:49.071
89	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE2Nzk1MSwiZXhwIjoxNzc5NzcyNzUxfQ.mDJFLqYoR6J2_UB9Y7VuxJo5oWeO3donrkTA0BLFwzE	PostmanRuntime/7.53.0	t	2026-05-26 05:19:11.616	2026-05-19 05:19:11.618
90	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE2ODUwMiwiZXhwIjoxNzc5NzczMzAyfQ.agwk2BS_IA-z8wWLQwdf8F0w5rLs7WdD6DIVn50cUEo	PostmanRuntime/7.53.0	t	2026-05-26 05:28:22.838	2026-05-19 05:28:22.847
91	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE3MTMzOSwiZXhwIjoxNzc5Nzc2MTM5fQ.y3LksNgQr8StY3MRAvJdJXfNRoG-lOgykhyyMwnKYWY	PostmanRuntime/7.53.0	t	2026-05-26 06:15:39.193	2026-05-19 06:15:39.195
92	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE3MTM3NywiZXhwIjoxNzc5Nzc2MTc3fQ.a7sAU34mUUg6GG8qVCVFlyLspmbsK3eZrii5DA6S4rs	PostmanRuntime/7.53.0	t	2026-05-26 06:16:17.781	2026-05-19 06:16:17.782
94	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE3MjE3MCwiZXhwIjoxNzc5Nzc2OTcwfQ.uFd83GNfsV-iLjyzrYpFFGhhTTniaezLLfkqmKNI4BU	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-26 06:29:30.382	2026-05-19 06:29:30.383
95	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE3NTc2MywiZXhwIjoxNzc5NzgwNTYzfQ.HkysHlt5g5hgmdoo8Lwg_x49_hb0ImDaIppeD-_D9PE	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-26 07:29:23.245	2026-05-19 07:29:23.248
96	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE3NjczOCwiZXhwIjoxNzc5NzgxNTM4fQ.C_2TJiSiCF2OftsK9zvZAxq9LpfQgslvn3NxqKvW49M	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-26 07:45:38.831	2026-05-19 07:45:38.838
97	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE3NjkyMywiZXhwIjoxNzc5NzgxNzIzfQ.f8uzyCmq9yoDt8n6E9xOBjaNCzwlX9ieaLWLyIQX9V0	PostmanRuntime/7.53.0	t	2026-05-26 07:48:43.121	2026-05-19 07:48:43.122
98	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE3Nzc3NSwiZXhwIjoxNzc5NzgyNTc1fQ.DH5PRMke1-VtoWZfRs-qFGodRW67bJGGymgUTaHbWvA	PostmanRuntime/7.53.0	t	2026-05-26 08:02:55.539	2026-05-19 08:02:55.541
109	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE4NjI3NCwiZXhwIjoxNzc5NzkxMDc0fQ.Ix9MrkY4ZXI2wwlFiXsBcTh3I3db0DAWldYUO2O6i4A	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-26 10:24:34.061	2026-05-19 10:24:34.063
110	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE4NzUwOCwiZXhwIjoxNzc5NzkyMzA4fQ.U1HdIYofEvWIl_UBndCyTrmnxpyhNoCwsB1qJS2teak	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-26 10:45:08.822	2026-05-19 10:45:08.824
122	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI2MzI2NCwiZXhwIjoxNzc5ODY4MDY0fQ.Y1aOOh9UJS0P6D4zEYpqMEy5h3oxJxtnq9xwoZqKHA0	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 07:47:44.744	2026-05-20 07:47:44.747
124	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI2NDk0NiwiZXhwIjoxNzc5ODY5NzQ2fQ.PGm401C6slT_M68BiwcFKI9byu1oZM1lXLETIzN_Gu4	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 08:15:46.402	2026-05-20 08:15:46.408
111	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTE4ODY4MCwiZXhwIjoxNzc5NzkzNDgwfQ.WWStOB0yo0mnc7RGgXg5aqiynMaQrHCkHQUgX2vWGJM	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-26 11:04:40.632	2026-05-19 11:04:40.634
112	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI1NDY3NCwiZXhwIjoxNzc5ODU5NDc0fQ.t564mee3p6_Ji3q8wU81inyr2FAnit-Vng8UCM93r7I	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 05:24:34.928	2026-05-20 05:24:34.931
113	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI1NzIwNywiZXhwIjoxNzc5ODYyMDA3fQ.wn3c5dM49BTlUw3wP26qQEU2i8w269bZJny3YglQB0A	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 06:06:47.604	2026-05-20 06:06:47.611
114	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI1ODMwOCwiZXhwIjoxNzc5ODYzMTA4fQ.VFaH-5ybl2IBtnlDwk3TIuf7YE6_yi4fyA74ppQ05v4	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 06:25:08.392	2026-05-20 06:25:08.394
115	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI1OTI2OCwiZXhwIjoxNzc5ODY0MDY4fQ.ULo-q_xmS72Fh6GXMNXitXTVLQcFXnKrC1y-7y1zJVA	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 06:41:08.027	2026-05-20 06:41:08.03
116	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI2MDM3NCwiZXhwIjoxNzc5ODY1MTc0fQ.shMOAgb-V7MzTl0vqy3EDHa1K676Qp1G-B4WegJWVQQ	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 06:59:34.051	2026-05-20 06:59:34.053
119	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI2MTM3OCwiZXhwIjoxNzc5ODY2MTc4fQ.qclRtYJ5Qer7aXPjauLwXF6T-7HZoXjHrQs9JbUPvfw	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 07:16:18.903	2026-05-20 07:16:18.904
157	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTMwMDUyMSwiZXhwIjoxNzc5OTA1MzIxfQ.1yJ4WsVCkRMu0wvgBn4o2qyYGM29pqqh9JtuOAO-Pcg	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 18:08:41.87	2026-05-20 18:08:41.871
176	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM0OTA4MCwiZXhwIjoxNzc5OTUzODgwfQ.TpYDyV6FAtFnupxvPWrxkgaqmYtAzgkwhNUhVkPOtHI	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 07:38:00.239	2026-05-21 07:38:00.24
198	3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc3OTM1OTUyNSwiZXhwIjoxNzc5OTY0MzI1fQ.7X4QbPC6H4Ge-wvKj1J148KckoRsC8BI42YWIhMWV_Q	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 10:32:05.056	2026-05-21 10:32:05.058
196	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM1NzI0MSwiZXhwIjoxNzc5OTYyMDQxfQ.P4yHwKJ-wjcJNJgfAIebGj6k_kouH4-Occ2d6QbsAuk	PostmanRuntime/7.53.0	t	2026-05-28 09:54:01.363	2026-05-21 09:54:01.364
200	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTQzMDY1MCwiZXhwIjoxNzgwMDM1NDUwfQ.R4FBiWPZOnECSjzRrbOSylvMManV-w66xCEeNQvjyuk	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-29 06:17:30.7	2026-05-22 06:17:30.702
128	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI2NjY1NywiZXhwIjoxNzc5ODcxNDU3fQ.JpkXOh5_VCBg_xC-NIux4bw2iGzJP8iU9FwDjz4se9A	PostmanRuntime/7.53.0	t	2026-05-27 08:44:17.409	2026-05-20 08:44:17.411
144	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI4NTg4MiwiZXhwIjoxNzc5ODkwNjgyfQ.XDWIc3cAHUSv5BcLEjDmbleyTsMsycJ04yOnhxViFEM	PostmanRuntime/7.53.0	t	2026-05-27 14:04:42.213	2026-05-20 14:04:42.215
125	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI2NDk1MiwiZXhwIjoxNzc5ODY5NzUyfQ.pW8kr3f9SXhPj2CMQJGaomc4mmEiinuiHA0EDv7ucDc	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 08:15:52.594	2026-05-20 08:15:52.6
133	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI3MzU4NSwiZXhwIjoxNzc5ODc4Mzg1fQ.ufZoDhmo20DBwkbBzBW80lrs2wbJZaWsYm5VzhSPrXY	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 10:39:45.677	2026-05-20 10:39:45.68
141	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI4NDA2MywiZXhwIjoxNzc5ODg4ODYzfQ.bOgTSy5sPWhF_B4a2FwOyEUsUs9j3mHzcWzy3IslkpY	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 13:34:23.597	2026-05-20 13:34:23.612
152	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI5NTY2MiwiZXhwIjoxNzc5OTAwNDYyfQ.WadqvZUH4K3IxiQu2y0QzWT7LnWQX29dR978hbJ_qMg	PostmanRuntime/7.53.0	t	2026-05-27 16:47:42.468	2026-05-20 16:47:42.47
153	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI5NTczNSwiZXhwIjoxNzc5OTAwNTM1fQ.M_hIsU82i3IeDxBYAIy5OK9wlsSUW9S4BR0s3vt1NY0	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 16:48:55.829	2026-05-20 16:48:55.83
160	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTMzMjc0MSwiZXhwIjoxNzc5OTM3NTQxfQ.cUAOcyt1X6thurOwnCL65lIwsq7mpjgisu-VKFQM3l4	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 03:05:41.391	2026-05-21 03:05:41.395
129	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI2NzYwNSwiZXhwIjoxNzc5ODcyNDA1fQ.3CD7S_otWzihZWrwRaJHzRY4ADrADuMt7yWDVDpkjGI	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 09:00:05.657	2026-05-20 09:00:05.659
137	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI4MDI0OSwiZXhwIjoxNzc5ODg1MDQ5fQ.S5JT1t8YdZc6Qfl-goB0I03gLw_xt0pjlXeGbFDQp-Q	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 12:30:49.319	2026-05-20 12:30:49.321
154	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI5NzA4MSwiZXhwIjoxNzc5OTAxODgxfQ.QXSbNt0Dn7kGzMh9DQ9PNjMqpK5f1st90wRafx3sqxo	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 17:11:21.63	2026-05-20 17:11:21.631
161	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTMzMjkyNiwiZXhwIjoxNzc5OTM3NzI2fQ.rDbdE5ZcdeeKx6Kwoltnyh2PFZOuNcYfXo8ODTw6ODA	PostmanRuntime/7.53.0	t	2026-05-28 03:08:46.774	2026-05-21 03:08:46.775
167	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM0NTAxMCwiZXhwIjoxNzc5OTQ5ODEwfQ.sdr6uqdo4H9AoIj0PIhs5vbFNZzTlQb0TGwRY6IhBfs	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 06:30:10.156	2026-05-21 06:30:10.158
173	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM0ODI1NCwiZXhwIjoxNzc5OTUzMDU0fQ.xD8M9iYzcmoeez9Y6Us2UYqjoJjxZE8KNhUssPY-PDs	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 07:24:14.236	2026-05-21 07:24:14.238
181	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM0OTk1NCwiZXhwIjoxNzc5OTU0NzU0fQ.6vlS7GrJPqjs67ICb_cIXb6knautmVnuFHGXG4HYduE	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 07:52:34.125	2026-05-21 07:52:34.126
183	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM1MDIxNiwiZXhwIjoxNzc5OTU1MDE2fQ.ffTAOTcqCWJx1n0i55EYa3x-XQRpiElu2fQnL6GzVsQ	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 07:56:56.217	2026-05-21 07:56:56.219
191	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM1MzE0MCwiZXhwIjoxNzc5OTU3OTQwfQ.-0KS-nQj2cHDIVUIy9d2vCmIB9-BnhlUPpCKKW_r12E	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 08:45:40.908	2026-05-21 08:45:40.911
138	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI4MTY5NSwiZXhwIjoxNzc5ODg2NDk1fQ.SfhpSReiHDK00BKGKWMtpfFfJv47IilPxYp1TeLdJDI	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 12:54:55.538	2026-05-20 12:54:55.541
146	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI4NzY1NSwiZXhwIjoxNzc5ODkyNDU1fQ.mEiTy9gIMToySRBiPv1kl5q1yWlQVBprS_ykfJ36UWI	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 14:34:15.571	2026-05-20 14:34:15.572
155	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI5ODMyMiwiZXhwIjoxNzc5OTAzMTIyfQ.TRO1d2zEomoNQDT0D2dnyUlZSfMNa9kF7rB9opxc08E	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 17:32:02.017	2026-05-20 17:32:02.023
162	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTMzMzkxMCwiZXhwIjoxNzc5OTM4NzEwfQ.Zp1A_MrWnYR-1H-6aBF4fCfnR9hxf52XI1ZWnt_vTl0	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 03:25:10.91	2026-05-21 03:25:10.912
168	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM0NTU0NCwiZXhwIjoxNzc5MzQ1NjY0fQ.zwC3rDhUUv7NEOurtCCJj0c1EiVGXNn9KE9ja0RX6rI	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome	t	2026-05-28 06:39:04.366	2026-05-21 06:39:04.367
182	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM1MDA3NSwiZXhwIjoxNzc5OTU0ODc1fQ.UeimjZ_zTSy_E_Fl6RfMBW5IZRBrdpot1azcasHMliQ	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 07:54:35.275	2026-05-21 07:54:35.277
192	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM1MzIwMSwiZXhwIjoxNzc5OTU4MDAxfQ.pcDvfyMfsnP97YAIOBtm9zkZvgk7HOyzTHRw8Q-sSLE	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 08:46:41.868	2026-05-21 08:46:41.871
139	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI4MjQ2MywiZXhwIjoxNzc5ODg3MjYzfQ.ZbXS6oT-UmsvG7r5_UVMWKtLEpGEmk4pMxv2H4OyyMM	PostmanRuntime/7.53.0	t	2026-05-27 13:07:43.871	2026-05-20 13:07:43.873
147	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI4OTY4NSwiZXhwIjoxNzc5ODk0NDg1fQ.YnMOunB7yitltihxrWLLfy-JssfR6lYZ_gFHGXkqplo	PostmanRuntime/7.53.0	t	2026-05-27 15:08:05.731	2026-05-20 15:08:05.734
156	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI5OTQ3NSwiZXhwIjoxNzc5OTA0Mjc1fQ.FIg16Xnrh_u9cTXRsjfLqdJgJ0PVt3KJYyJNfUVxe10	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 17:51:15.642	2026-05-20 17:51:15.643
163	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTMzNDk3OSwiZXhwIjoxNzc5OTM5Nzc5fQ.Sw84RuAWhwxoBqoB9BPzd64AozgCkfeq2heHvDACfSE	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 03:42:59.864	2026-05-21 03:42:59.869
169	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM0NTcwNCwiZXhwIjoxNzc5OTUwNTA0fQ.xxOBPwmZpTD75i5EJjKyIKPAybtU75JuGlo4WwmXXkA	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 06:41:44.781	2026-05-21 06:41:44.784
175	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM0ODk3MSwiZXhwIjoxNzc5OTUzNzcxfQ.sqO6NBJ4G5j2-3VRLJ1cdtI87vQAuggGo1jhzgmILHo	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 07:36:11.667	2026-05-21 07:36:11.669
184	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM1MDMyNSwiZXhwIjoxNzc5OTU1MTI1fQ.Z53INBgVLrtGc8HKHpwFAe3UHKE1CzRKhQ3bJ6gPaeI	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 07:58:45.642	2026-05-21 07:58:45.644
185	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM1MDQwNiwiZXhwIjoxNzc5OTU1MjA2fQ.FdnQJxuzO6w6Ec20UbFVcX9Ddvt3vlSthPeMAz5aGqo	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 08:00:06.753	2026-05-21 08:00:06.755
197	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM1ODA4NSwiZXhwIjoxNzc5OTYyODg1fQ.XJXGD_HSOar3N8-jmNP2-wKiC2Grv57HcdR3cb6dPJM	PostmanRuntime/7.53.0	t	2026-05-28 10:08:05.069	2026-05-21 10:08:05.07
132	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI3MjY2NSwiZXhwIjoxNzc5ODc3NDY1fQ.b7_1Gy1fkqI9Txkw_sQKlQJe2u3aMICK2g64H7jQNn8	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-27 10:24:25.351	2026-05-20 10:24:25.353
140	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI4MzQ5OCwiZXhwIjoxNzc5ODg4Mjk4fQ.HftTUFLaJ6aY-wAzg8Or-ptGcqRl9vMUuyzXDzPnbXI	PostmanRuntime/7.53.0	t	2026-05-27 13:24:58.478	2026-05-20 13:24:58.491
148	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI5Mjc0NywiZXhwIjoxNzc5ODk3NTQ3fQ.b7mgDMzBOuW1KTiG3qJoFvqdZ7TbG8KITHVpnNJIQ7k	PostmanRuntime/7.53.0	t	2026-05-27 15:59:07.765	2026-05-20 15:59:07.766
149	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTI5MzgxMywiZXhwIjoxNzc5ODk4NjEzfQ.sWfFQcr4kMoCohmz9MuH2cCIseIO1uVnIDsZA75J2xc	PostmanRuntime/7.53.0	t	2026-05-27 16:16:53.067	2026-05-20 16:16:53.069
164	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTMzNjA1OCwiZXhwIjoxNzc5OTQwODU4fQ.jXsa353YHT2zNJsO-0qYA3ovm6oCWH6M-5LZxcvX4dQ	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 04:00:58.516	2026-05-21 04:00:58.521
170	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM0NjAxOSwiZXhwIjoxNzc5OTUwODE5fQ.7BLdxqOo-T9_E0sJusIIp70cx7Ed23jFaMl_uiL-npk	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 06:46:59.097	2026-05-21 06:46:59.099
177	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM0OTE0NSwiZXhwIjoxNzc5OTUzOTQ1fQ.i4-hgK5LU5mkxkeHkiFr8PhitaDKP0X8kp80s0O_uHI	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 07:39:05.673	2026-05-21 07:39:05.675
186	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM1MDkzNCwiZXhwIjoxNzc5OTU1NzM0fQ.U05D2WTNyd1xUmjtX_pjc9NDctz0XyLY3rvFB9-KCdY	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 08:08:54.344	2026-05-21 08:08:54.345
188	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM1MTEyNSwiZXhwIjoxNzc5OTU1OTI1fQ.cA5909vqM6uz5pb8FU6a8euSrBmSQuvUr6uNn3ZhIf4	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-28 08:12:05.564	2026-05-21 08:12:05.566
194	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTM1NjIwNCwiZXhwIjoxNzc5MzU2NTA0fQ.g8exJUzqs3kG8Z2_sjRQnuu3ptEhP8FUb8dAe5kdgQw	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-21 09:41:44.872	2026-05-21 09:36:44.875
201	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTQzMTA0NCwiZXhwIjoxNzgwMDM1ODQ0fQ.6eTcmPoEvEdTkqdbZsUhYZs08AQKIEEVhXvsj8dX9_M	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-29 06:24:04.412	2026-05-22 06:24:04.414
203	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTQzMjkyMCwiZXhwIjoxNzgwMDM3NzIwfQ.oeexhb_6LWgNI9Cg7k_jU3Eh652LgH1AS33kuRyeDow	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-29 06:55:20.174	2026-05-22 06:55:20.175
204	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTQzMjkyNSwiZXhwIjoxNzgwMDM3NzI1fQ.NkZ58batobhQ_ARth8lh2V708xnfTflU94TKAJPAFD8	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-29 06:55:25.307	2026-05-22 06:55:25.308
205	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTQzMzYxNCwiZXhwIjoxNzgwMDM4NDE0fQ.QIV39RRkUqq3ZuNdi0uaL1IXqoCcCYfIgUsfXg9ECTs	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-29 07:06:54.148	2026-05-22 07:06:54.15
202	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTQzMTA5MywiZXhwIjoxNzgwMDM1ODkzfQ.QAVtzbmBvcES07DoeMDuPfI2-VTDuKsEEac973L8H84	PostmanRuntime/7.53.0	t	2026-05-29 06:24:53.649	2026-05-22 06:24:53.651
206	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTQzNDgyNywiZXhwIjoxNzgwMDM5NjI3fQ.Qc6VD1T6bmtblMqLj0FZqakcM6ZV0uGYEk5kh4bTUyA	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-29 07:27:07.668	2026-05-22 07:27:07.673
207	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTQzNDgzMywiZXhwIjoxNzgwMDM5NjMzfQ.e6rVUA-NWbW1yqd1Z7Id5fZUVkWzLql2pw1WshvksgY	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-29 07:27:13.386	2026-05-22 07:27:13.39
208	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTQzNjIzNywiZXhwIjoxNzgwMDQxMDM3fQ.JvdJf92fiowK3RoLrFj58aHrud1tco3B_3Q9CYcvfUI	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-29 07:50:37.617	2026-05-22 07:50:37.618
209	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTQzNjYwMywiZXhwIjoxNzgwMDQxNDAzfQ.Y6CT9O-uu5GrcYLzfIkcbIfYenu_4BJv9eoJVtwQZck	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-29 07:56:43.269	2026-05-22 07:56:43.27
210	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTQzNzExNSwiZXhwIjoxNzgwMDQxOTE1fQ.IiXAtyLx1IUvYPMcBt6AoJJ9rX6yuSC3aRSGKAp6Inw	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-29 08:05:15.151	2026-05-22 08:05:15.152
211	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTQzNzExOSwiZXhwIjoxNzgwMDQxOTE5fQ._OgOmMO6DHxSyVKn1QPDdIYRZNzle3CkjzxlheaAISw	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-29 08:05:19.73	2026-05-22 08:05:19.732
212	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTQzOTg4NywiZXhwIjoxNzgwMDQ0Njg3fQ.9g5f7k5gaw3NSkIyoOdqssvvSngDJTVpl-IKpn8bndk	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-29 08:51:27.365	2026-05-22 08:51:27.367
213	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTQzOTkzNCwiZXhwIjoxNzgwMDQ0NzM0fQ.elIhNStZHzJ1ZccnBbv7YDayczhmY-vTlOQB6gx5nUk	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-29 08:52:14.19	2026-05-22 08:52:14.192
214	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTQ0MDI4MSwiZXhwIjoxNzgwMDQ1MDgxfQ.wOmF7hnvfYRiTBLTzwCzbm6eSUV2Hb743XuZt3UJYAU	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-29 08:58:01.468	2026-05-22 08:58:01.469
215	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTQ0MDMzMSwiZXhwIjoxNzgwMDQ1MTMxfQ.Ks5qt1M_q1psnKFS7ybeUSTFQDezyKFTjJYhSb9s9Hk	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-29 08:58:51.676	2026-05-22 08:58:51.677
216	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTQ0MDUxMiwiZXhwIjoxNzgwMDQ1MzEyfQ.tZmUvn-ALEOi0vK1uZfXM6z2NruopCpuMUs081qn9fY	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-29 09:01:52.75	2026-05-22 09:01:52.755
219	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTQ0MDU2MCwiZXhwIjoxNzgwMDQ1MzYwfQ.1F9w-yRFts2WGF72NjemHc67U_7aE_1W2PU8LHWiqYc	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	f	2026-05-29 09:02:40.27	2026-05-22 09:02:40.273
217	2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTc3OTQ0MDUyMywiZXhwIjoxNzgwMDQ1MzIzfQ.nDijNew3bWTOI1LZTlEapzqvFsQHnmVAhsvySAasKiM	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-29 09:02:03.783	2026-05-22 09:02:03.789
218	3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsImlhdCI6MTc3OTQ0MDUzNSwiZXhwIjoxNzgwMDQ1MzM1fQ.lV7dtuYcBo3kN9es9d8XM0QkA7ZhS9Xj0WJVkuwwgVY	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Sa	t	2026-05-29 09:02:15.967	2026-05-22 09:02:15.972
220	1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTc3OTQ0MTUzMCwiZXhwIjoxNzgwMDQ2MzMwfQ.kVioCcCuq29MSJIhsh3YSualmwueskiGn8GYTkcVyGc	PostmanRuntime/7.53.0	f	2026-05-29 09:18:50.209	2026-05-22 09:18:50.211
\.


--
-- TOC entry 5051 (class 0 OID 16698)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, first_name, last_name, tel, email, password, role, created_at, updated_at) FROM stdin;
1	Asadawuth	Paijit	0859300756	taodewy@gmail.com	$2b$10$Do7X4C0HnPd5w/hN7H.Mg.dgwJEwZpAwr8ShJlYy35SYPrm7leqte	MANAGER	2026-05-18 02:57:27.241	2026-05-18 02:57:27.241
2	Asadawuth	Paijit	0859300757	taodewy1@gmail.com	$2b$10$nTVk7kvWcxYruByCD09ItuSNr83piv8g0PLi57GKhFIo5TmzPyf8W	TEAMLEADER	2026-05-18 11:24:59.191	2026-05-18 11:24:59.191
3	Asadawuth	Paijit	0859300758	taodewy3@gmail.com	$2b$10$Sjqt96c30VbzAiKhg.hv0uwOG.Gsshjr7eO.IA0jNW78tjaXyM726	FLOORSTAFF	2026-05-18 11:26:16.449	2026-05-18 11:26:16.449
\.


--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 223
-- Name: history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.history_id_seq', 15, true);


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 221
-- Name: movies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movies_id_seq', 46, true);


--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 225
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.refresh_tokens_id_seq', 220, true);


--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- TOC entry 4896 (class 2606 OID 16751)
-- Name: history history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);


--
-- TOC entry 4894 (class 2606 OID 16733)
-- Name: movies movies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (id);


--
-- TOC entry 4898 (class 2606 OID 16775)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4890 (class 2606 OID 16719)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4892 (class 2606 OID 16717)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4900 (class 2606 OID 16757)
-- Name: history history_movie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id);


--
-- TOC entry 4901 (class 2606 OID 16752)
-- Name: history history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4899 (class 2606 OID 16734)
-- Name: movies movies_user_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_user_admin_fkey FOREIGN KEY (user_admin) REFERENCES public.users(id);


--
-- TOC entry 4902 (class 2606 OID 16781)
-- Name: refresh_tokens refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- Completed on 2026-05-22 18:56:08

--
-- PostgreSQL database dump complete
--

\unrestrict rPaP4lbMC9zARSeHMbsiMSakeqHvQG7y4GzaoCJWpMAG8vtaRXJZwCGZgQv2d8j

