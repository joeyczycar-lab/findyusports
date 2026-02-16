--
-- PostgreSQL database dump
--

\restrict cijG6dKDNgfAKE71B861fMb0J2gSZ0ZaltcOVizdcjEumbXBy5ViFJGYdeaTdeU

-- Dumped from database version 17.7 (Debian 17.7-3.pgdg13+1)
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

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    "timestamp" bigint NOT NULL,
    name character varying NOT NULL
);


--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: page_view; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.page_view (
    id integer NOT NULL,
    path character varying(200) NOT NULL,
    page_type character varying(50),
    referer character varying(200),
    user_agent character varying(500),
    ip character varying(45),
    user_id character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: page_view_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.page_view_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: page_view_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.page_view_id_seq OWNED BY public.page_view.id;


--
-- Name: review; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.review (
    id integer NOT NULL,
    "venueId" integer NOT NULL,
    "userId" integer NOT NULL,
    rating integer NOT NULL,
    content text NOT NULL,
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: review_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.review_id_seq OWNED BY public.review.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    phone character varying(20) NOT NULL,
    nickname character varying(50),
    avatar character varying(200),
    password character varying(100) NOT NULL,
    role character varying(20) DEFAULT 'user'::character varying NOT NULL,
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    points integer DEFAULT 0,
    is_vip boolean DEFAULT false
);


--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: venue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.venue (
    id integer NOT NULL,
    name character varying(120) NOT NULL,
    "sportType" character varying(20) NOT NULL,
    "cityCode" character varying(6) NOT NULL,
    address character varying(200),
    lng double precision NOT NULL,
    lat double precision NOT NULL,
    "priceMin" integer,
    "priceMax" integer,
    indoor boolean,
    contact character varying(100),
    is_public boolean DEFAULT true,
    district_code character varying(6),
    open_time character varying(20),
    lighting character varying(50),
    floor_type character varying(50),
    has_air_conditioning boolean,
    has_ventilation boolean,
    open_hours character varying(200),
    has_lighting boolean,
    has_parking boolean,
    court_count integer,
    has_rest_area boolean,
    has_fence boolean,
    has_shower boolean,
    has_locker boolean,
    has_shop boolean,
    supports_full_court boolean,
    walk_in_price_min integer,
    walk_in_price_max integer,
    full_court_price_min integer,
    full_court_price_max integer,
    reservation_method character varying(200),
    supports_walk_in boolean,
    requires_reservation boolean,
    players_per_side character varying(20),
    price_display character varying(120),
    walk_in_price_display character varying(120),
    full_court_price_display character varying(120)
);


--
-- Name: venue_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.venue_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: venue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.venue_id_seq OWNED BY public.venue.id;


--
-- Name: venue_image; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.venue_image (
    id integer NOT NULL,
    "venueId" integer NOT NULL,
    "userId" integer NOT NULL,
    url text NOT NULL,
    sort integer DEFAULT 0 NOT NULL
);


--
-- Name: venue_image_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.venue_image_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: venue_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.venue_image_id_seq OWNED BY public.venue_image.id;


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: page_view id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_view ALTER COLUMN id SET DEFAULT nextval('public.page_view_id_seq'::regclass);


--
-- Name: review id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review ALTER COLUMN id SET DEFAULT nextval('public.review_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: venue id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venue ALTER COLUMN id SET DEFAULT nextval('public.venue_id_seq'::regclass);


--
-- Name: venue_image id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venue_image ALTER COLUMN id SET DEFAULT nextval('public.venue_image_id_seq'::regclass);


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.migrations (id, "timestamp", name) FROM stdin;
6	1690000000000	InitialSchema1690000000000
7	1700000000000	InitPostgisGeomIndex1700000000000
\.


--
-- Data for Name: page_view; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.page_view (id, path, page_type, referer, user_agent, ip, user_id, created_at) FROM stdin;
1	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 09:14:00.930941+00
2	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 09:14:02.478044+00
3	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 09:14:03.826991+00
4	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 09:14:04.973425+00
5	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 09:18:02.061913+00
6	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 09:18:02.298711+00
7	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 09:18:02.649616+00
8	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 09:18:02.857373+00
9	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 10:55:20.337318+00
10	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 10:57:40.527221+00
11	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 10:57:44.832083+00
12	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 11:07:45.851056+00
13	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 11:16:14.028311+00
14	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 11:16:18.786841+00
15	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 11:16:18.905266+00
16	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 11:23:26.064161+00
17	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 11:23:27.791947+00
18	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 11:26:57.772958+00
19	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 11:28:15.426699+00
20	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-02 11:28:16.069589+00
21	/	home	https://findyusports-prghmi6kc-findyu.vercel.app/	vercel-screenshot/1.0	64.23.132.12	\N	2026-01-02 11:54:52.341089+00
22	/	home	https://findyusports-prghmi6kc-findyu.vercel.app/	vercel-screenshot/1.0	143.198.68.119	\N	2026-01-02 11:54:52.740984+00
23	/	home	https://findyusports-git-master-findyu.vercel.app/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.91	\N	2026-01-02 12:01:56.076366+00
24	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.91	\N	2026-01-02 12:03:23.701799+00
25	/	home	https://findyusports-g05pv8gyj-findyu.vercel.app/	vercel-screenshot/1.0	164.92.117.50	\N	2026-01-02 12:05:42.102586+00
26	/	home	https://findyusports-g05pv8gyj-findyu.vercel.app/	vercel-screenshot/1.0	143.198.68.119	\N	2026-01-02 12:05:42.610223+00
27	/	home	https://findyusports-8zf5csqxa-findyu.vercel.app/	vercel-screenshot/1.0	143.198.235.142	\N	2026-01-02 12:07:16.59597+00
28	/	home	https://findyusports-8zf5csqxa-findyu.vercel.app/	vercel-screenshot/1.0	64.23.182.5	\N	2026-01-02 12:07:17.076294+00
29	/	home	https://findyusports-2kerezv6u-findyu.vercel.app/	vercel-screenshot/1.0	137.184.92.156	\N	2026-01-02 12:10:39.241296+00
30	/	home	https://findyusports-2kerezv6u-findyu.vercel.app/	vercel-screenshot/1.0	64.23.132.12	\N	2026-01-02 12:10:39.695881+00
31	/admin/add-venue	admin	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.91	\N	2026-01-02 12:12:18.956226+00
32	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.41 Safari/537.36	54.224.231.99	\N	2026-01-02 12:13:16.018781+00
33	/	home	https://findyusports-o5wd1sti2-findyu.vercel.app/	vercel-screenshot/1.0	146.190.118.195	\N	2026-01-02 12:15:09.517632+00
34	/	home	https://findyusports-o5wd1sti2-findyu.vercel.app/	vercel-screenshot/1.0	146.190.118.195	\N	2026-01-02 12:15:09.901829+00
35	/admin/analytics	admin	https://findyusports.com/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.91	\N	2026-01-02 12:15:36.780446+00
36	/	home	https://findyusports-gcyqqsegj-findyu.vercel.app/	vercel-screenshot/1.0	134.199.230.110	\N	2026-01-02 12:21:37.202799+00
37	/	home	https://findyusports-gcyqqsegj-findyu.vercel.app/	vercel-screenshot/1.0	64.23.132.12	\N	2026-01-02 12:21:37.526634+00
38	/	home	https://findyusports-lvwqt8azj-findyu.vercel.app/	vercel-screenshot/1.0	209.38.158.188	\N	2026-01-02 12:22:35.981173+00
39	/	home	https://findyusports-lvwqt8azj-findyu.vercel.app/	vercel-screenshot/1.0	209.38.158.188	\N	2026-01-02 12:22:36.156327+00
40	/map	map	https://findyusports.com/map?sport=basketball	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.122 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.170	\N	2026-01-02 14:09:26.347853+00
41	/venues/5	venue	https://findyusports.com/venues/5	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.122 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.170	\N	2026-01-02 20:24:23.226985+00
42	/map	map	https://findyusports.com/map?sport=football	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.122 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.170	\N	2026-01-02 22:45:33.901316+00
43	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/134.0.6998.35 Safari/537.36	113.215.189.120	\N	2026-01-03 07:14:05.983108+00
44	/	home	https://findyusports.com/	Mozilla/5.0 (SymbianOS/9.4; Series60/5.0 NokiaN97-1/10.0.012; Profile/MIDP-2.1 Configuration/CLDC-1.1; en-us) AppleWebKit/525 (KHTML, like Gecko) WicKed/7.1.12344	54.147.230.123	\N	2026-01-03 11:52:04.882567+00
45	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.5938.132 Safari/537.36	205.169.39.5	\N	2026-01-03 13:40:33.988393+00
46	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	34.72.176.129	\N	2026-01-03 13:40:37.542292+00
47	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36	205.169.39.172	\N	2026-01-03 13:40:46.95685+00
48	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36	34.42.133.231	\N	2026-01-03 14:52:11.823186+00
49	/map	map	https://findyusports.com/map?sport=football	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.122 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.170	\N	2026-01-03 23:55:38.114636+00
50	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.122 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.171	\N	2026-01-04 00:20:59.419938+00
51	/admin/add-venue	admin	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-04 09:15:26.653762+00
52	/admin/add-venue	admin	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	103.220.218.90	\N	2026-01-04 09:53:43.443089+00
53	/admin/analytics	admin	https://findyusports.com/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	103.220.218.90	\N	2026-01-04 09:53:45.573225+00
54	/admin/analytics	admin	https://findyusports.com/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	103.220.218.90	\N	2026-01-04 10:03:17.882879+00
55	/admin/venues	admin	https://findyusports.com/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	103.220.218.90	\N	2026-01-04 10:03:23.714957+00
56	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.0.653	117.147.16.5	\N	2026-01-04 10:04:37.803208+00
57	/	home	https://findyusports-6mpfgiv9x-findyu.vercel.app/	vercel-screenshot/1.0	137.184.92.156	\N	2026-01-04 10:05:13.534651+00
58	/	home	https://findyusports-6mpfgiv9x-findyu.vercel.app/	vercel-screenshot/1.0	143.198.73.50	\N	2026-01-04 10:05:14.016238+00
59	/	home	https://findyusports-eavkhiqrx-findyu.vercel.app/	vercel-screenshot/1.0	146.190.170.222	\N	2026-01-04 10:06:48.110763+00
60	/	home	https://findyusports-eavkhiqrx-findyu.vercel.app/	vercel-screenshot/1.0	137.184.81.139	\N	2026-01-04 10:06:48.474299+00
61	/admin/venues	admin	https://findyusports.com/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-04 10:12:27.56366+00
62	/	home	https://findyusports-gtmp1yv2w-findyu.vercel.app/	vercel-screenshot/1.0	137.184.92.156	\N	2026-01-04 10:13:43.614552+00
63	/	home	https://findyusports-gtmp1yv2w-findyu.vercel.app/	vercel-screenshot/1.0	137.184.92.156	\N	2026-01-04 10:13:44.068529+00
64	/	home	https://findyusports-1rj8v750g-findyu.vercel.app/	vercel-screenshot/1.0	159.223.206.184	\N	2026-01-04 10:14:09.187737+00
65	/	home	https://findyusports-1rj8v750g-findyu.vercel.app/	vercel-screenshot/1.0	137.184.112.47	\N	2026-01-04 10:14:09.67563+00
66	/admin/venues	admin	https://findyusports.com/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-04 10:15:35.288989+00
67	/	home	https://findyusports-690bmzror-findyu.vercel.app/	vercel-screenshot/1.0	64.23.132.12	\N	2026-01-04 10:18:15.540461+00
68	/	home	https://findyusports-690bmzror-findyu.vercel.app/	vercel-screenshot/1.0	159.223.206.184	\N	2026-01-04 10:18:15.963472+00
69	/	home	https://findyusports-otsy4t4nd-findyu.vercel.app/	vercel-screenshot/1.0	64.23.182.5	\N	2026-01-04 10:24:49.499535+00
70	/	home	https://findyusports-otsy4t4nd-findyu.vercel.app/	vercel-screenshot/1.0	143.198.68.119	\N	2026-01-04 10:24:49.898873+00
71	/	home	https://findyusports-ldurptkeb-findyu.vercel.app/	vercel-screenshot/1.0	64.23.182.5	\N	2026-01-04 10:25:16.046431+00
72	/	home	https://findyusports-ldurptkeb-findyu.vercel.app/	vercel-screenshot/1.0	24.199.110.208	\N	2026-01-04 10:25:16.4727+00
73	/admin/add-venue	admin	https://findyusports.com/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-04 10:29:18.961589+00
74	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-04 10:29:25.575819+00
75	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-04 10:29:31.097773+00
76	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-04 10:29:33.637607+00
77	/venues/7	venue	https://findyusports.com/venues/7	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-04 10:29:35.414003+00
78	/venues/7	venue	https://findyusports.com/venues/7	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-04 10:31:00.643533+00
79	/	home	https://findyusports-o58gyl8vb-findyu.vercel.app/	vercel-screenshot/1.0	134.199.222.242	\N	2026-01-04 10:31:10.188959+00
80	/	home	https://findyusports-o58gyl8vb-findyu.vercel.app/	vercel-screenshot/1.0	143.198.68.119	\N	2026-01-04 10:31:10.538624+00
81	/	home	https://findyusports-4osuj7ka1-findyu.vercel.app/	vercel-screenshot/1.0	64.23.177.195	\N	2026-01-04 10:34:07.900636+00
82	/	home	https://findyusports-4osuj7ka1-findyu.vercel.app/	vercel-screenshot/1.0	164.92.117.50	\N	2026-01-04 10:34:08.354501+00
83	/venues/7	venue	https://findyusports.com/venues/7	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-04 10:36:30.4018+00
84	/	home	https://findyusports-kcmosswjt-findyu.vercel.app/	vercel-screenshot/1.0	143.198.68.119	\N	2026-01-04 11:05:38.59316+00
85	/	home	https://findyusports-kcmosswjt-findyu.vercel.app/	vercel-screenshot/1.0	64.23.182.5	\N	2026-01-04 11:05:38.953047+00
86	/venues/7	venue	https://findyusports.com/venues/7	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-04 11:12:48.560339+00
87	/admin/add-venue	admin	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-04 11:13:04.264127+00
88	/admin/venues	admin	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-04 11:15:45.369857+00
89	/venues/7	venue	https://findyusports.com/venues/7	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.122 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.169	\N	2026-01-04 15:22:08.403308+00
90	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.122 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.170	\N	2026-01-05 05:16:39.680773+00
91	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.122 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.169	\N	2026-01-05 05:16:50.633706+00
92	/	home	https://findyusports-674xvzbo1-findyu.vercel.app/	vercel-screenshot/1.0	134.199.222.242	\N	2026-01-05 09:00:20.189806+00
93	/	home	https://findyusports-674xvzbo1-findyu.vercel.app/	vercel-screenshot/1.0	137.184.112.47	\N	2026-01-05 09:00:20.647357+00
94	/	home	https://findyusports-lickwmdgp-findyu.vercel.app/	vercel-screenshot/1.0	64.23.132.12	\N	2026-01-05 09:02:08.822325+00
95	/	home	https://findyusports-lickwmdgp-findyu.vercel.app/	vercel-screenshot/1.0	164.92.117.50	\N	2026-01-05 09:02:09.223491+00
96	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-05 09:25:35.735625+00
97	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-05 09:25:41.232232+00
98	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-05 09:25:54.882792+00
99	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-05 09:27:04.112079+00
100	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-05 09:27:05.952078+00
101	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-05 09:27:06.740207+00
102	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-05 09:27:07.553497+00
103	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-05 09:27:08.287776+00
104	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-05 09:27:08.9912+00
105	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-05 09:27:09.998688+00
106	/	home	https://findyusports-bc3u5s68k-findyu.vercel.app/	vercel-screenshot/1.0	137.184.92.156	\N	2026-01-05 09:27:22.887801+00
107	/	home	https://findyusports-bc3u5s68k-findyu.vercel.app/	vercel-screenshot/1.0	64.23.182.5	\N	2026-01-05 09:27:23.342324+00
108	/	home	https://findyusports-ogog6jagz-findyu.vercel.app/	vercel-screenshot/1.0	143.198.68.119	\N	2026-01-05 09:28:15.575399+00
109	/	home	https://findyusports-ogog6jagz-findyu.vercel.app/	vercel-screenshot/1.0	64.23.177.195	\N	2026-01-05 09:28:15.999712+00
110	/	home	https://findyusports-2y3tpp4uw-findyu.vercel.app/	vercel-screenshot/1.0	24.199.110.208	\N	2026-01-05 09:28:42.517124+00
111	/	home	https://findyusports-2y3tpp4uw-findyu.vercel.app/	vercel-screenshot/1.0	143.198.73.50	\N	2026-01-05 09:28:42.564142+00
112	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-05 14:28:51.561779+00
113	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-05 14:28:54.3376+00
114	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-05 14:28:57.856658+00
115	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 3.0; en-us; Xoom Build/HRI39) AppleWebKit/525.10  (KHTML, like Gecko) Version/3.0.4 Mobile Safari/523.12.2	34.68.36.238	\N	2026-01-05 14:52:15.87468+00
116	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36	149.57.180.163	\N	2026-01-05 20:05:47.391415+00
117	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/134.0.6998.35 Safari/537.36	113.215.189.178	\N	2026-01-05 23:52:23.802408+00
118	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-06 09:34:19.655357+00
119	/map	map	https://findyusports.com/map?sport=football	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-06 09:34:24.563051+00
120	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-06 09:34:27.343998+00
121	/map	map	https://findyusports.com/map?sport=basketball	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-06 09:34:28.420609+00
122	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-06 09:34:31.176311+00
123	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-06 09:35:24.844783+00
124	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-06 09:38:47.871343+00
125	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-06 09:38:56.471156+00
126	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-06 09:39:00.307335+00
127	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-06 09:41:38.744089+00
128	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-06 09:42:38.218901+00
129	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-06 09:44:34.138142+00
130	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-06 09:44:36.710753+00
131	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-06 09:54:47.321637+00
132	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-06 09:54:49.635002+00
133	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-06 09:54:55.252238+00
134	/admin/add-venue	admin	https://findyusports.com/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	103.220.218.93	\N	2026-01-06 09:55:35.175993+00
135	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	103.220.218.93	\N	2026-01-06 10:02:25.393409+00
136	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	103.220.218.93	\N	2026-01-06 10:02:26.973184+00
137	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	103.220.218.93	\N	2026-01-06 10:04:01.801435+00
138	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	103.220.218.93	\N	2026-01-06 10:04:02.851566+00
139	/	home	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.2.44 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-06 10:24:41.424499+00
140	/	home	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.2.44 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-06 10:24:41.422004+00
141	/	home	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.2.44 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-06 10:24:44.664948+00
142	/	home	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.2.44 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-06 10:24:45.121375+00
143	/	home	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.2.44 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-06 10:24:45.371502+00
144	/	home	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.2.44 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-06 10:24:46.108807+00
145	/	home	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-06 10:24:56.093837+00
146	/	home	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-06 10:24:56.105485+00
147	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-06 10:24:59.0108+00
148	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-06 10:24:59.015822+00
149	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-06 10:25:56.01091+00
150	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-06 10:38:25.049125+00
671	/	home	https://findyusports-il1ml2t6y-findyu.vercel.app/	vercel-screenshot/1.0	147.182.236.253	\N	2026-01-16 04:51:20.6175+00
151	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-06 10:38:27.483221+00
152	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::ffff:127.0.0.1	\N	2026-01-06 10:41:16.528984+00
1882	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.706	::1	\N	2026-02-01 04:39:40.856439+00
1885	/map	map	http://localhost:3000/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.706	::1	\N	2026-02-01 04:40:40.218581+00
1886	/venues/47	venue	http://localhost:3000/venues/47	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.706	::1	\N	2026-02-01 04:40:42.625558+00
1887	/user	\N	http://localhost:3000/user	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.706	::1	\N	2026-02-01 04:40:48.194605+00
1888	/map	map	http://localhost:3000/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.706	::1	\N	2026-02-01 04:45:21.385226+00
1892	/map	map	http://localhost:3000/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.706	::1	\N	2026-02-01 04:45:53.524902+00
1893	/map	map	http://localhost:3000/map?keyword=%E6%A3%AE%E6%9E%97	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.706	::1	\N	2026-02-01 04:45:59.196833+00
1962	/map	map	http://localhost:3000/admin/edit-venue/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:51:14.864139+00
1963	/venues/244	venue	http://localhost:3000/admin/edit-venue/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:51:29.575782+00
1964	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	65.75.221.219	\N	2026-02-03 04:56:20.915183+00
1965	/map	map	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	65.75.221.219	\N	2026-02-03 04:56:28.167892+00
1966	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	65.75.221.219	\N	2026-02-03 04:56:54.409138+00
1967	/map	map	https://findyusports.com/map?sport=football	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	65.75.221.219	\N	2026-02-03 04:56:58.405868+00
1968	/venues/247	venue	https://findyusports.com/venues/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	65.75.221.219	\N	2026-02-03 04:57:11.212572+00
1969	/venues/247	venue	https://findyusports.com/venues/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	65.75.221.219	\N	2026-02-03 04:58:59.555461+00
2001	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	103.220.218.93	\N	2026-02-03 11:59:27.707167+00
2042	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 15:29:44.814492+00
2043	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 15:29:47.425936+00
2044	/admin/venues	admin	http://localhost:3000/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 15:29:49.422583+00
2045	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 15:30:04.543135+00
153	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::ffff:127.0.0.1	\N	2026-01-06 10:41:16.538268+00
154	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 10:50:53.154481+00
155	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 10:51:31.542332+00
156	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 10:51:39.777111+00
157	/venues/8	venue	https://findyusports.com/venues/8	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 10:51:41.612907+00
158	/venues/8	venue	https://findyusports.com/venues/8	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:01:58.82383+00
159	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-06 11:04:12.733853+00
160	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::ffff:127.0.0.1	\N	2026-01-06 11:04:15.33887+00
161	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:04:18.902516+00
162	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-06 11:08:31.752262+00
163	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-06 11:08:32.049233+00
164	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-06 11:08:36.083353+00
165	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-06 11:24:29.093339+00
166	/admin/venues	admin	http://localhost:3000/admin/venues	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-06 11:24:29.532714+00
167	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:24:33.617428+00
168	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:24:36.79804+00
169	/venues/9	venue	https://findyusports.com/venues/9	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:24:43.118795+00
170	/venues/9	venue	https://findyusports.com/venues/9	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:25:27.755386+00
171	/venues/9	venue	https://findyusports.com/venues/9	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:27:21.96978+00
172	/venues/9	venue	https://findyusports.com/venues/9	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:27:30.801303+00
173	/venues/9	venue	https://findyusports.com/venues/9	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:27:33.397154+00
174	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:27:35.726049+00
175	/venues/9	venue	https://findyusports.com/venues/9	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:27:37.327145+00
176	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:27:39.26684+00
177	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:27:41.591911+00
178	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:27:54.454537+00
179	/venues/9	venue	https://findyusports.com/venues/9	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:27:57.734811+00
180	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:28:00.021578+00
181	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:28:02.262331+00
182	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:30:31.082632+00
183	/venues/9	venue	https://findyusports.com/venues/9	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:30:35.416373+00
184	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:30:37.436686+00
185	/admin/add-venue	admin	https://findyusports.com/venues/9	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.88	\N	2026-01-06 11:30:39.771592+00
257	/	home	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-08 10:05:02.194314+00
186	/map	map	https://findyusports.com/map?sport=basketball	Mozilla/5.0 (Linux; Android 5.0) AppleWebKit/537.36 (KHTML, like Gecko) Mobile Safari/537.36 (compatible; Bytespider; https://zhanzhang.toutiao.com/)	111.225.149.158	\N	2026-01-06 20:13:15.819421+00
187	/map	map	https://findyusports.com/map?sport=basketball	Mozilla/5.0 (Linux; Android 5.0) AppleWebKit/537.36 (KHTML, like Gecko) Mobile Safari/537.36 (compatible; Bytespider; https://zhanzhang.toutiao.com/)	111.225.149.199	\N	2026-01-07 03:59:34.519485+00
188	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.91	\N	2026-01-07 09:24:51.346859+00
189	/	home	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-07 10:33:55.407674+00
190	/	home	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-07 10:33:59.065876+00
191	/	home	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-07 10:35:01.097754+00
192	/	home	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-07 10:35:01.094978+00
193	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-07 10:35:02.488752+00
194	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-07 10:35:02.479204+00
195	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-07 15:25:15.527391+00
196	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-07 15:25:21.550227+00
197	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-07 15:25:41.562783+00
198	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-07 15:47:48.37872+00
199	/	home	https://findyusports-9dkvmbyci-findyu.vercel.app/	vercel-screenshot/1.0	146.190.170.222	\N	2026-01-07 15:49:24.712895+00
200	/	home	https://findyusports-9dkvmbyci-findyu.vercel.app/	vercel-screenshot/1.0	137.184.7.246	\N	2026-01-07 15:49:25.127157+00
201	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-07 15:50:03.278922+00
202	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-07 15:52:12.605524+00
203	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-07 15:52:14.877459+00
204	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-07 16:05:02.935529+00
205	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-07 16:05:06.381259+00
206	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-07 16:10:32.23279+00
207	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-07 16:10:45.35203+00
208	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-07 16:10:48.001315+00
209	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-07 16:12:09.460027+00
210	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-07 16:12:15.024513+00
211	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-07 16:12:16.705428+00
212	/	home	https://findyusports-fxt9yfc1w-findyu.vercel.app/	vercel-screenshot/1.0	143.110.145.227	\N	2026-01-07 16:15:30.691813+00
213	/	home	https://findyusports-fxt9yfc1w-findyu.vercel.app/	vercel-screenshot/1.0	147.182.255.232	\N	2026-01-07 16:15:31.386112+00
214	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-07 16:16:53.972543+00
215	/	home	https://findyusports-94d825nq5-findyu.vercel.app/	vercel-screenshot/1.0	209.38.146.106	\N	2026-01-07 16:22:05.85857+00
216	/	home	https://findyusports-94d825nq5-findyu.vercel.app/	vercel-screenshot/1.0	64.23.171.123	\N	2026-01-07 16:22:06.339439+00
217	/	home	https://findyusports-d1pszg7bd-findyu.vercel.app/	vercel-screenshot/1.0	143.198.132.45	\N	2026-01-07 16:25:35.7636+00
218	/	home	https://findyusports-d1pszg7bd-findyu.vercel.app/	vercel-screenshot/1.0	64.23.177.195	\N	2026-01-07 16:25:36.205974+00
219	/	home	https://findyusports-no84wxr5x-findyu.vercel.app/	vercel-screenshot/1.0	143.198.50.217	\N	2026-01-07 16:26:02.357935+00
220	/	home	https://findyusports-no84wxr5x-findyu.vercel.app/	vercel-screenshot/1.0	147.182.249.198	\N	2026-01-07 16:26:02.452338+00
221	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.85	\N	2026-01-07 16:28:49.362094+00
222	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.85	\N	2026-01-07 16:28:58.451102+00
223	/venues/10	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.85	\N	2026-01-07 16:29:04.844835+00
224	/venues/10	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.85	\N	2026-01-07 16:29:18.19524+00
225	/venues/10	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.85	\N	2026-01-07 16:29:42.757102+00
226	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.85	\N	2026-01-07 16:29:47.846466+00
227	/venues/9	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.85	\N	2026-01-07 16:29:51.21426+00
228	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.85	\N	2026-01-07 16:30:09.380336+00
229	/venues/8	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.85	\N	2026-01-07 16:30:14.337002+00
230	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.85	\N	2026-01-07 16:30:29.919911+00
231	/venues/8	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.85	\N	2026-01-07 16:30:33.107027+00
232	/venues/8	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.85	\N	2026-01-07 16:30:58.614405+00
233	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.85	\N	2026-01-07 16:31:01.843261+00
234	/venues/10	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.85	\N	2026-01-07 16:31:06.565886+00
235	/venues/10	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.85	\N	2026-01-07 16:31:42.759021+00
236	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.85	\N	2026-01-07 16:31:45.186449+00
237	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.85	\N	2026-01-07 16:31:51.825072+00
238	/	home	https://findyusports-7h4xfbro0-findyu.vercel.app/	vercel-screenshot/1.0	64.23.184.169	\N	2026-01-07 16:32:42.692557+00
239	/	home	https://findyusports-7h4xfbro0-findyu.vercel.app/	vercel-screenshot/1.0	137.184.7.246	\N	2026-01-07 16:32:43.077086+00
240	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.154	\N	2026-01-07 16:34:49.165455+00
241	/venues/10	venue	https://findyusports.com/venues/10	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.154	\N	2026-01-07 16:34:54.74442+00
242	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.154	\N	2026-01-07 16:35:10.434686+00
243	/venues/10	venue	https://findyusports.com/venues/10	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.154	\N	2026-01-07 16:35:12.806718+00
244	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.154	\N	2026-01-07 16:35:17.76471+00
245	/venues/8	venue	https://findyusports.com/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.154	\N	2026-01-07 16:35:20.013981+00
246	/	home	https://findyusports-3gj7owwup-findyu.vercel.app/	vercel-screenshot/1.0	137.184.7.246	\N	2026-01-07 16:37:18.519783+00
247	/	home	https://findyusports-3gj7owwup-findyu.vercel.app/	vercel-screenshot/1.0	146.190.170.222	\N	2026-01-07 16:37:19.045778+00
248	/venues/8	venue	https://findyusports.com/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.154	\N	2026-01-07 16:38:31.56727+00
249	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.154	\N	2026-01-07 16:38:36.97548+00
250	/venues/10	venue	https://findyusports.com/venues/10	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.154	\N	2026-01-07 16:38:39.078881+00
251	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	34.123.170.104	\N	2026-01-08 03:32:39.990371+00
252	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36	205.169.39.85	\N	2026-01-08 03:32:51.201456+00
253	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.5938.132 Safari/537.36	205.169.39.20	\N	2026-01-08 03:41:33.888321+00
254	/map	map	https://findyusports.com/map?sport=football	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.122 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.170	\N	2026-01-08 04:36:03.671275+00
255	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 10:05:00.938917+00
256	/	home	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-08 10:05:02.069676+00
1586	/	home	https://findyusports-4i8lvt7fp-findyu.vercel.app/	vercel-screenshot/1.0	164.92.66.89	\N	2026-01-30 12:50:49.997631+00
258	/	home	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-08 10:05:18.733694+00
1883	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.706	::1	\N	2026-02-01 04:39:40.86179+00
1884	/user	\N	http://localhost:3000/user	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.706	::1	\N	2026-02-01 04:39:43.539715+00
1889	/venues/47	venue	http://localhost:3000/venues/47	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.706	::1	\N	2026-02-01 04:45:22.741258+00
1890	/map	map	http://localhost:3000/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.706	::1	\N	2026-02-01 04:45:41.453698+00
1891	/map	map	http://localhost:3000/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.706	::1	\N	2026-02-01 04:45:53.49314+00
1894	/map	map	http://localhost:3000/map?keyword=%E6%A3%AE%E6%9E%97	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.706	::1	\N	2026-02-01 04:45:59.241787+00
1970	/venues/247	venue	https://findyusports.com/venues/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	65.75.221.219	\N	2026-02-03 05:06:09.381622+00
1974	/map	map	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.230.69	\N	2026-02-03 05:06:49.256315+00
2002	/venues/247	venue	https://findyusports.com/venues/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	103.220.218.93	\N	2026-02-03 11:59:32.464091+00
2004	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.4.27 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36	::1	\N	2026-02-03 12:01:00.013306+00
2005	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.4.27 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36	::1	\N	2026-02-03 12:01:00.161849+00
2006	/venues/247	venue	https://findyusports.com/venues/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	188.253.124.85	\N	2026-02-03 12:03:54.152465+00
2046	/venues/247	venue	http://localhost:3000/venues/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 15:30:19.000299+00
2047	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 15:30:25.901208+00
2048	/venues/244	venue	http://localhost:3000/venues/244	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 15:30:51.930907+00
259	/	home	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-08 10:05:18.733182+00
260	/venues/10	venue	https://findyusports.com/venues/10	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 10:05:22.660785+00
264	/venues/10	venue	https://findyusports.com/venues/10	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 10:17:49.116096+00
268	/venues/10	venue	https://findyusports.com/venues/10	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 10:18:03.757392+00
269	/	home	https://findyusports.com/venues/10	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 10:18:05.47565+00
270	/	home	https://findyusports.com/venues/10	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 10:18:08.281261+00
1895	/venues/241	venue	http://localhost:3000/map?keyword=%E6%A3%AE%E6%9E%97	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.706	::1	\N	2026-02-01 04:46:02.009244+00
1971	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.41.132	\N	2026-02-03 05:06:30.638267+00
1972	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.230.69	\N	2026-02-03 05:06:37.77009+00
1973	/map	map	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.43.82	\N	2026-02-03 05:06:47.952119+00
2003	/venues/244	venue	https://findyusports.com/venues/244	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	103.220.218.93	\N	2026-02-03 12:00:04.420941+00
261	/venues/10	venue	https://findyusports.com/venues/10	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 10:16:54.864074+00
262	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 10:17:23.194852+00
263	/venues/10	venue	https://findyusports.com/venues/10	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 10:17:25.43122+00
265	/venues/10	venue	https://findyusports.com/venues/10	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 10:17:55.208139+00
266	/	home	https://findyusports.com/venues/10	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 10:17:59.198987+00
267	/	home	https://findyusports.com/venues/10	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 10:18:01.211285+00
271	/	home	https://findyusports.com/venues/10	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 11:05:31.312646+00
272	/admin/add-venue	admin	https://findyusports.com/venues/10	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 11:16:41.55143+00
273	/	home	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-08 11:17:45.013184+00
274	/	home	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-08 11:17:48.075693+00
275	/admin/add-venue	admin	https://findyusports.com/venues/10	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 11:24:42.381404+00
276	/map	map	https://findyusports.com/venues/10	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 11:27:41.058482+00
277	/venues/11	venue	https://findyusports.com/venues/10	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 11:27:44.833054+00
278	/map	map	https://findyusports.com/venues/10	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 11:27:48.588213+00
279	/venues/11	venue	https://findyusports.com/venues/10	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 11:27:51.374692+00
280	/venues/11	venue	https://findyusports.com/venues/11	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 11:28:06.485819+00
281	/venues/11	venue	https://findyusports.com/venues/11	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 11:29:06.434876+00
282	/venues/11	venue	https://findyusports.com/venues/11	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 11:29:15.219515+00
283	/venues/11	venue	https://findyusports.com/venues/11	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 11:29:28.220683+00
284	/venues/11	venue	https://findyusports.com/venues/11	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 11:29:30.121282+00
285	/map	map	https://findyusports.com/venues/11	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.124.85	\N	2026-01-08 11:29:36.897877+00
286	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.169	\N	2026-01-08 12:39:14.305641+00
287	/venues/3	venue	https://findyusports.com/venues/3	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.169	\N	2026-01-08 13:19:50.204508+00
288	/venues/3	venue	https://findyusports.com/venues/3	Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/143.0.7499.169 Safari/537.36	66.249.69.169	\N	2026-01-08 13:19:52.114687+00
289	/venues/4	venue	https://findyusports.com/venues/4	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.171	\N	2026-01-08 13:56:03.101459+00
290	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; Android 5.1.1; Coolpad 3622A Build/LMY47V) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.83 Mobile Safari/537.36	34.170.156.24	\N	2026-01-08 15:22:55.254253+00
291	/venues/2	venue	https://findyusports.com/venues/2	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.170	\N	2026-01-08 17:17:13.002087+00
292	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.170	\N	2026-01-08 17:25:58.913915+00
293	/venues/1	venue	https://findyusports.com/venues/1	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.169	\N	2026-01-08 17:31:37.053368+00
294	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/134.0.6998.35 Safari/537.36	113.215.189.21	\N	2026-01-08 17:38:34.409479+00
295	/	home	http://spyhost.site/	Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0	46.138.250.165	\N	2026-01-08 19:36:41.359663+00
296	/admin/add-venue	admin	http://spyhost.site/	Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0	46.138.250.165	\N	2026-01-08 19:36:43.78888+00
634	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/134.0.6998.35 Safari/537.36	113.215.189.128	\N	2026-01-14 23:10:56.272364+00
297	/venues/6	venue	https://findyusports.com/venues/6	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.169	\N	2026-01-08 20:32:28.490049+00
298	/	home	http://spyhost.site/	Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0	46.138.250.165	\N	2026-01-08 22:53:47.747827+00
299	/venues/5	venue	https://findyusports.com/venues/5	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.169	\N	2026-01-09 06:24:48.514331+00
300	/venues/10	venue	https://findyusports.com/venues/11	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	103.220.218.90	\N	2026-01-09 12:30:43.038392+00
301	/venues/10	venue	https://findyusports.com/venues/11	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	103.220.218.90	\N	2026-01-09 12:30:49.197788+00
302	/venues/8	venue	https://findyusports.com/venues/8	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	192.178.6.65	\N	2026-01-09 13:49:45.377756+00
303	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-09 14:19:01.935315+00
304	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-09 14:19:05.068337+00
305	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-09 14:21:47.984798+00
306	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-09 14:21:50.978731+00
307	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::ffff:127.0.0.1	\N	2026-01-09 14:25:19.569175+00
308	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-09 14:25:22.691369+00
309	/venues/2	venue	https://findyusports.com/venues/2	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.170	\N	2026-01-09 17:07:28.049752+00
310	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 04:00:43.79874+00
311	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 04:00:44.878958+00
312	/admin/api/analytics/stats	admin	http://localhost:3000/admin/api/analytics/stats	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 04:01:21.097187+00
313	/admin/api/analytics/stats	admin	http://localhost:3000/admin/api/analytics/stats	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 04:01:21.096666+00
314	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 04:01:43.402124+00
315	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 04:01:43.392218+00
316	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 04:32:05.725282+00
317	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::ffff:127.0.0.1	\N	2026-01-10 04:32:05.723456+00
318	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::ffff:127.0.0.1	\N	2026-01-10 04:32:08.908925+00
319	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 04:32:08.900118+00
320	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 04:32:11.906361+00
321	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 04:32:11.898249+00
322	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 04:32:13.023998+00
323	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::ffff:127.0.0.1	\N	2026-01-10 04:32:13.041673+00
324	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::ffff:127.0.0.1	\N	2026-01-10 05:30:03.387188+00
325	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 05:30:03.384618+00
326	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 05:30:13.490567+00
327	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 05:30:13.501564+00
328	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 05:30:57.80526+00
329	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 05:30:57.790277+00
331	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 05:31:06.956755+00
333	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 05:48:18.762042+00
1896	/user	\N	http://localhost:3000/map?keyword=%E6%A3%AE%E6%9E%97	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.706	::1	\N	2026-02-01 04:46:50.110238+00
1897	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	183.131.239.175	\N	2026-02-01 04:47:58.011635+00
1898	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.230.69	\N	2026-02-01 04:47:58.027807+00
1899	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.230.69	\N	2026-02-01 04:47:59.086831+00
1900	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	183.131.239.175	\N	2026-02-01 04:47:59.2776+00
1901	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.43.82	\N	2026-02-01 04:48:00.74448+00
1902	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.230.69	\N	2026-02-01 04:48:00.775139+00
1903	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.230.69	\N	2026-02-01 04:48:08.455614+00
1904	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Mobile Safari/537.36 MicroMessenger/7.0.1	14.152.91.158	\N	2026-02-01 06:21:23.799107+00
1905	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	183.131.239.175	\N	2026-02-01 08:01:09.070341+00
1906	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	183.137.120.218	\N	2026-02-01 08:01:10.4001+00
1907	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	183.137.120.218	\N	2026-02-01 08:01:19.332476+00
1908	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.41.132	\N	2026-02-01 08:01:21.771612+00
1909	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	183.137.120.218	\N	2026-02-01 08:01:21.827819+00
1910	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	183.131.239.184	\N	2026-02-01 08:01:28.929057+00
1911	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	183.137.120.218	\N	2026-02-01 08:01:29.083609+00
1975	/venues/247	venue	https://findyusports.com/venues/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	65.75.221.219	\N	2026-02-03 05:13:39.04896+00
2007	/	home	https://findyusports-87w07ej39-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	52.53.152.121	\N	2026-02-03 12:04:06.064523+00
2008	/	home	https://findyusports-87w07ej39-findyu.vercel.app/	vercel-screenshot/1.0	147.182.246.167	\N	2026-02-03 12:04:06.113255+00
2009	/	home	https://findyusports-87w07ej39-findyu.vercel.app/	vercel-screenshot/1.0	147.182.242.144	\N	2026-02-03 12:04:06.558627+00
2010	/	home	https://findyusports-87w07ej39-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.183.244.213	\N	2026-02-03 12:04:06.96335+00
330	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 05:31:06.9718+00
332	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::ffff:127.0.0.1	\N	2026-01-10 05:48:18.798533+00
334	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 05:48:22.66514+00
335	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 05:48:22.80084+00
336	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 05:51:35.680484+00
337	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 05:51:35.984645+00
338	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 05:54:36.528947+00
339	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.676	::1	\N	2026-01-10 05:54:39.67761+00
340	/venues/5	venue	https://findyusports.com/venues/5	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.71	\N	2026-01-10 06:06:04.425686+00
341	/venues/10	venue	https://findyusports.com/venues/10	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-10 06:20:35.711603+00
342	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-10 06:20:51.521287+00
343	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-10 06:20:56.086624+00
344	/admin/venues	admin	https://findyusports.com/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-10 06:25:18.949655+00
345	/venues/12	venue	https://findyusports.com/venues/12	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-10 06:25:32.392402+00
346	/venues/12	venue	https://findyusports.com/venues/12	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-10 06:26:19.750655+00
347	/venues/12	venue	https://findyusports.com/venues/12	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-10 06:26:35.930229+00
348	/venues/12	venue	https://findyusports.com/venues/12	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-10 06:27:42.414766+00
349	/venues/12	venue	https://findyusports.com/venues/12	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-10 06:28:08.499289+00
350	/	home	https://findyusports-ra9z4vkw5-findyu.vercel.app/	vercel-screenshot/1.0	164.92.74.248	\N	2026-01-10 06:28:55.699221+00
351	/	home	https://findyusports-ra9z4vkw5-findyu.vercel.app/	vercel-screenshot/1.0	147.182.255.232	\N	2026-01-10 06:28:56.256814+00
352	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-10 06:29:06.664225+00
353	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-10 06:29:07.694297+00
354	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-10 06:32:47.380246+00
355	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	160.22.157.88	\N	2026-01-10 06:34:15.778943+00
356	/	home	https://findyusports-35lgdistn-findyu.vercel.app/	vercel-screenshot/1.0	137.184.112.47	\N	2026-01-10 06:41:27.707202+00
357	/	home	https://findyusports-35lgdistn-findyu.vercel.app/	vercel-screenshot/1.0	144.126.216.103	\N	2026-01-10 06:41:28.160185+00
358	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-10 06:42:15.581311+00
359	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-10 06:42:22.144074+00
360	/	home	https://findyusports-ba6v3w9vr-findyu.vercel.app/	vercel-screenshot/1.0	137.184.7.246	\N	2026-01-10 06:43:01.228659+00
361	/	home	https://findyusports-ba6v3w9vr-findyu.vercel.app/	vercel-screenshot/1.0	24.199.106.41	\N	2026-01-10 06:43:01.681414+00
362	/	home	https://findyusports-9z689jloc-findyu.vercel.app/	vercel-screenshot/1.0	64.23.177.195	\N	2026-01-10 06:44:35.346142+00
363	/	home	https://findyusports-9z689jloc-findyu.vercel.app/	vercel-screenshot/1.0	143.110.145.227	\N	2026-01-10 06:44:35.859508+00
364	/	home	https://findyusports-5al98ilxd-findyu.vercel.app/	vercel-screenshot/1.0	137.184.7.246	\N	2026-01-10 06:45:03.697081+00
365	/	home	https://findyusports-5al98ilxd-findyu.vercel.app/	vercel-screenshot/1.0	164.92.117.50	\N	2026-01-10 06:45:04.097139+00
366	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-10 08:28:01.118092+00
367	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-10 08:31:42.298505+00
368	/venues/15	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-10 08:31:51.682847+00
369	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	218.252.114.192	\N	2026-01-10 08:32:04.830393+00
370	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-10 08:49:02.096553+00
371	/venues/15	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-10 08:49:10.724452+00
372	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-10 08:50:04.797696+00
373	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	188.253.123.151	\N	2026-01-10 08:50:10.089242+00
374	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:06:16.612588+00
375	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:06:19.424576+00
376	/map	map	http://localhost:3000/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:06:31.103954+00
377	/venues/13	venue	http://localhost:3000/venues/13	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:06:39.403823+00
378	/	home	https://findyusports-pjonuv98t-findyu.vercel.app/	vercel-screenshot/1.0	147.182.232.177	\N	2026-01-10 09:10:21.329208+00
379	/	home	https://findyusports-pjonuv98t-findyu.vercel.app/	vercel-screenshot/1.0	137.184.112.47	\N	2026-01-10 09:10:21.764381+00
380	/venues/13	venue	http://localhost:3000/venues/13	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:10:42.042415+00
381	/venues/13	venue	http://localhost:3000/venues/13	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:10:42.040211+00
382	/venues/[%E5%9C%BA%E5%9C%B0ID]	venue	http://localhost:3000/venues/[%E5%9C%BA%E5%9C%B0ID]	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:13:12.482019+00
383	/venues/[%E5%9C%BA%E5%9C%B0ID]	venue	http://localhost:3000/venues/[%E5%9C%BA%E5%9C%B0ID]	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:13:12.518212+00
384	/venues/[%E5%9C%BA%E5%9C%B0ID]	venue	http://localhost:3000/venues/[%E5%9C%BA%E5%9C%B0ID]	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:13:15.352418+00
385	/map	map	http://localhost:3000/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:13:15.369142+00
386	/map	map	http://localhost:3000/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:13:21.16696+00
387	/venues/8	venue	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:13:25.589628+00
388	/venues/8	venue	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:15:56.90472+00
389	/venues/8	venue	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:15:56.907171+00
390	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:16:05.950731+00
391	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:17:39.330339+00
392	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:17:41.834054+00
393	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:23:56.030938+00
394	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:23:56.425174+00
395	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:41:46.771151+00
396	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.1.5.666	::1	\N	2026-01-10 09:41:46.829014+00
397	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	188.253.123.154	\N	2026-01-10 09:42:33.393957+00
398	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 09:42:35.181965+00
399	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 09:42:35.295794+00
400	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 09:42:51.896077+00
669	/	home	https://findyusports-5u9dggt5d-findyu.vercel.app/	vercel-screenshot/1.0	137.184.38.20	\N	2026-01-16 04:50:44.943242+00
401	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 09:43:01.29329+00
402	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 09:43:06.200117+00
1912	/	home	https://findyusports-8q1dl0m6k-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	3.101.30.176	\N	2026-02-01 09:44:03.471368+00
1913	/	home	https://findyusports-8q1dl0m6k-findyu.vercel.app/	vercel-screenshot/1.0	146.190.63.118	\N	2026-02-01 09:44:03.572567+00
1914	/	home	https://findyusports-8q1dl0m6k-findyu.vercel.app/	vercel-screenshot/1.0	24.144.93.246	\N	2026-02-01 09:44:03.866444+00
1915	/	home	https://findyusports-8q1dl0m6k-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.67.83.255	\N	2026-02-01 09:44:03.900303+00
1976	/venues/247	venue	https://findyusports.com/venues/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	160.22.157.85	\N	2026-02-03 05:15:31.513125+00
2011	/venues/247	venue	https://findyusports.com/venues/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	188.253.124.85	\N	2026-02-03 12:10:38.799867+00
403	/admin/venues	admin	http://localhost:3000/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 09:43:07.638169+00
404	/admin/edit-venue/16	admin	http://localhost:3000/admin/edit-venue/16	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 09:43:19.504473+00
405	/admin/edit-venue/16	admin	http://localhost:3000/admin/edit-venue/16	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 09:52:03.216925+00
406	/admin/edit-venue/16	admin	http://localhost:3000/admin/edit-venue/16	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 09:52:03.425244+00
407	/admin/edit-venue/16	admin	http://localhost:3000/admin/edit-venue/16	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 09:59:38.628401+00
408	/admin/edit-venue/16	admin	http://localhost:3000/admin/edit-venue/16	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 09:59:38.636653+00
409	/admin/edit-venue/16	admin	http://localhost:3000/admin/edit-venue/16	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:03:57.149361+00
410	/admin/edit-venue/16	admin	http://localhost:3000/admin/edit-venue/16	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:03:59.732966+00
411	/admin/venues	admin	http://localhost:3000/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:04:20.643835+00
412	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:04:22.691375+00
413	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:04:23.581686+00
414	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:04:24.9753+00
415	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:04:26.609934+00
416	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:04:27.195989+00
417	/admin/venues	admin	http://localhost:3000/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:04:27.677061+00
418	/venues/14	venue	http://localhost:3000/venues/14	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:04:42.527164+00
419	/admin/edit-venue/14	admin	http://localhost:3000/admin/edit-venue/14	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:04:46.624885+00
420	/venues/14	venue	http://localhost:3000/venues/14	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:04:56.500273+00
421	/venues/14	venue	http://localhost:3000/venues/14	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:08:39.611611+00
422	/venues/14	venue	http://localhost:3000/venues/14	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:08:39.612357+00
423	/admin/edit-venue/14	admin	http://localhost:3000/admin/edit-venue/14	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:10:04.08652+00
424	/admin/edit-venue/14	admin	http://localhost:3000/admin/edit-venue/14	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:20:25.463862+00
425	/admin/edit-venue/14	admin	http://localhost:3000/admin/edit-venue/14	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:20:25.471378+00
426	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:30:09.177595+00
427	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:30:09.502945+00
428	/venues/8	venue	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:30:15.373895+00
429	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:30:17.170377+00
430	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:33:45.201599+00
431	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:33:47.689945+00
432	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:42:23.524685+00
433	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:45:30.116287+00
434	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:45:32.905191+00
670	/	home	https://findyusports-5u9dggt5d-findyu.vercel.app/	vercel-screenshot/1.0	165.232.138.20	\N	2026-01-16 04:50:45.302304+00
435	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:48:25.772505+00
436	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 10:48:28.447612+00
437	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 11:01:43.681416+00
438	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 11:01:43.773009+00
439	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 11:01:45.377923+00
440	/admin/venues	admin	http://localhost:3000/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 11:01:48.672464+00
441	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 11:01:49.969789+00
442	/admin/venues	admin	http://localhost:3000/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 11:01:51.441291+00
443	/venues/8	venue	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 11:01:56.62299+00
444	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.678	::1	\N	2026-01-10 11:02:02.914781+00
445	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-10 15:13:17.163426+00
446	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.124.91	\N	2026-01-11 09:45:57.642522+00
447	/admin/edit-venue/8	admin	http://localhost:3000/admin/edit-venue/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 09:46:02.814916+00
448	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:09:09.571158+00
449	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:09:14.204759+00
450	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:09:14.222605+00
451	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:11:22.054479+00
452	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:11:22.071421+00
453	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:11:23.453952+00
454	/admin/venues	admin	http://localhost:3000/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:11:24.15113+00
455	/admin/edit-venue/1	admin	http://localhost:3000/admin/edit-venue/1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:11:50.664262+00
456	/admin/edit-venue/1	admin	http://localhost:3000/admin/edit-venue/1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:16:01.10515+00
457	/admin/edit-venue/1	admin	http://localhost:3000/admin/edit-venue/1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:16:03.636547+00
458	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:25:49.475732+00
459	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:25:55.047374+00
460	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:25:57.739619+00
461	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:25:57.81626+00
462	/admin/venues	admin	http://localhost:3000/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:26:01.402205+00
463	/admin/edit-venue/11	admin	http://localhost:3000/admin/edit-venue/11	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:26:10.055288+00
464	/	home	https://findyusports-5bse92ek6-findyu.vercel.app/	vercel-screenshot/1.0	137.184.112.47	\N	2026-01-11 10:36:47.547274+00
465	/	home	https://findyusports-5bse92ek6-findyu.vercel.app/	vercel-screenshot/1.0	24.199.106.41	\N	2026-01-11 10:36:47.954144+00
466	/admin/edit-venue/11	admin	http://localhost:3000/admin/edit-venue/11	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:37:54.380573+00
467	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:37:55.175627+00
468	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:37:55.512836+00
469	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:37:57.760953+00
470	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:38:08.089035+00
471	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:38:08.092524+00
472	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:47:39.306906+00
473	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:47:39.387989+00
474	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:47:40.444441+00
475	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:47:40.566356+00
476	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:47:40.850375+00
477	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:47:41.035744+00
478	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:47:46.37957+00
479	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:47:46.361672+00
480	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:47:57.84255+00
481	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 10:47:57.969621+00
482	/test-login.html	\N	http://localhost:3000/test-login.html	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 11:08:03.232282+00
483	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 11:11:46.697616+00
484	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 11:11:49.445975+00
485	/admin/venues	admin	http://localhost:3000/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 11:12:01.349569+00
486	/admin/edit-venue/15	admin	http://localhost:3000/admin/edit-venue/15	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 11:12:18.831009+00
487	/admin/edit-venue/15	admin	http://localhost:3000/admin/edit-venue/15	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 11:18:06.450533+00
488	/admin/edit-venue/15	admin	http://localhost:3000/admin/edit-venue/15	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-11 11:18:06.721798+00
489	/venues/2	venue	https://findyusports.com/venues/2	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.71	\N	2026-01-11 12:14:05.842787+00
490	/venues/4	venue	https://findyusports.com/venues/4	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-11 12:55:42.995455+00
491	/venues/9	venue	https://findyusports.com/venues/9	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-11 13:56:59.473878+00
492	/venues/7	venue	https://findyusports.com/venues/7	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-11 16:19:54.33902+00
493	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/134.0.6998.35 Safari/537.36	113.215.188.156	\N	2026-01-12 02:20:39.98497+00
494	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/134.0.6998.35 Safari/537.36	113.215.189.95	\N	2026-01-12 03:05:39.705465+00
495	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/134.0.6998.35 Safari/537.36	113.215.189.92	\N	2026-01-12 03:06:51.990492+00
496	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/134.0.6998.35 Safari/537.36	113.215.189.94	\N	2026-01-12 03:08:02.77968+00
497	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/134.0.6998.35 Safari/537.36	113.215.189.89	\N	2026-01-12 03:08:50.728292+00
498	/map	map	https://findyusports.com/map?sport=basketball	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-12 04:14:45.676645+00
531	/venues/15	venue	http://localhost:3000/venues/15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 09:22:57.236129+00
499	/venues/12	venue	https://findyusports.com/venues/12	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-12 07:33:38.148265+00
500	/venues/10	venue	https://findyusports.com/venues/10	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-12 08:02:10.163003+00
501	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.124.85	\N	2026-01-12 09:44:07.316131+00
502	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.124.85	\N	2026-01-12 09:44:11.528908+00
503	/admin/analytics	admin	https://findyusports.com/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.124.85	\N	2026-01-12 09:44:17.801014+00
504	/admin/data	admin	https://findyusports.com/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.124.85	\N	2026-01-12 09:44:30.218431+00
505	/admin/venues	admin	https://findyusports.com/admin/venues	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.124.85	\N	2026-01-12 09:44:37.305651+00
506	/admin/edit-venue/12	admin	https://findyusports.com/admin/edit-venue/12	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.124.85	\N	2026-01-12 09:44:47.277746+00
507	/admin/edit-venue/12	admin	https://findyusports.com/admin/edit-venue/12	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.124.85	\N	2026-01-12 10:00:47.357339+00
508	/admin/edit-venue/12	admin	https://findyusports.com/admin/edit-venue/12	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.124.85	\N	2026-01-12 10:22:28.001847+00
509	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-12 10:39:00.886597+00
510	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-12 10:39:03.237857+00
511	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-12 10:43:40.774614+00
512	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-12 10:43:40.774873+00
513	/admin/edit-venue/12	admin	https://findyusports.com/admin/edit-venue/12	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.124.85	\N	2026-01-12 10:56:10.402277+00
514	/admin/edit-venue/12	admin	https://findyusports.com/admin/edit-venue/12	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.124.85	\N	2026-01-12 11:07:00.195722+00
515	/admin/edit-venue/12	admin	https://findyusports.com/admin/edit-venue/12	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.124.85	\N	2026-01-12 11:24:37.490636+00
516	/admin/edit-venue/12	admin	https://findyusports.com/admin/edit-venue/12	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.123.154	\N	2026-01-12 11:58:59.5248+00
517	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.123.154	\N	2026-01-12 11:59:14.474754+00
518	/map	map	https://findyusports.com/map	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.123.154	\N	2026-01-12 12:04:15.697269+00
519	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.123.154	\N	2026-01-12 12:06:49.559717+00
520	/map	map	https://findyusports.com/map	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.123.154	\N	2026-01-12 12:39:27.231781+00
521	/venues/19	venue	https://findyusports.com/venues/19	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.123.154	\N	2026-01-12 12:39:48.542187+00
522	/admin/edit-venue/19	admin	https://findyusports.com/admin/edit-venue/19	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.123.154	\N	2026-01-12 12:40:12.325603+00
523	/venues/19	venue	https://findyusports.com/venues/19	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.123.154	\N	2026-01-12 12:40:28.530587+00
524	/map	map	https://findyusports.com/map?sport=basketball	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-13 04:23:30.548697+00
525	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 09:21:50.524802+00
526	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 09:21:50.622326+00
527	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 09:22:14.188394+00
528	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 09:22:14.212354+00
529	/map	map	http://localhost:3000/map	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 09:22:18.620963+00
530	/venues/15	venue	http://localhost:3000/venues/15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 09:22:35.229842+00
532	/venues/15	venue	http://localhost:3000/venues/15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 09:22:57.260904+00
533	/admin/edit-venue/15	admin	http://localhost:3000/admin/edit-venue/15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 09:23:00.719238+00
534	/admin/edit-venue/15	admin	http://localhost:3000/admin/edit-venue/15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 09:44:52.066456+00
535	/admin/edit-venue/15	admin	http://localhost:3000/admin/edit-venue/15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 09:44:52.08926+00
536	/admin/edit-venue/15	admin	http://localhost:3000/admin/edit-venue/15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 11:47:55.802375+00
537	/admin/edit-venue/15	admin	http://localhost:3000/admin/edit-venue/15	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 11:47:59.104348+00
538	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 11:49:04.742285+00
539	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 11:49:40.745495+00
540	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 11:49:43.136882+00
541	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 11:50:27.421876+00
542	/map	map	http://localhost:3000/map	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 11:52:31.092679+00
543	/map	map	http://localhost:3000/map	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 12:26:08.372452+00
544	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 12:26:27.402325+00
545	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 12:26:37.846778+00
546	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 12:26:37.899744+00
547	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 12:27:41.903793+00
548	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 12:27:41.922804+00
549	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 12:47:16.762534+00
550	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 12:47:16.765661+00
551	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:00:57.640784+00
552	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:00:57.655386+00
553	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:14:15.956029+00
554	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:14:15.986794+00
555	/map	map	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:17:32.509491+00
556	/admin/add-venue	admin	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:17:35.390535+00
557	/map	map	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:17:57.962593+00
558	/venues/26	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:18:18.476968+00
559	/map	map	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:23:43.177215+00
560	/venues/26	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:23:59.562884+00
561	/admin/edit-venue/26	admin	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:24:01.759185+00
562	/venues/26	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:24:07.364956+00
563	/map	map	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:24:10.731916+00
564	/venues/26	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:24:23.739603+00
565	/admin/edit-venue/26	admin	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:24:27.071944+00
566	/venues/26	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:24:29.970705+00
567	/venues/26	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:42:04.625861+00
568	/venues/26	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:42:04.644193+00
569	/admin/edit-venue/26	admin	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:42:10.840431+00
570	/venues/26	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:42:14.944975+00
571	/map	map	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:42:16.204207+00
572	/map	map	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:42:16.215609+00
573	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:42:28.812165+00
574	/admin/edit-venue/25	admin	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:42:31.051192+00
575	/admin/edit-venue/25	admin	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:47:22.907655+00
576	/admin/edit-venue/25	admin	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:47:25.886406+00
577	/map	map	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:47:53.074478+00
578	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:47:59.697053+00
579	/admin/edit-venue/25	admin	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:48:12.769794+00
580	/admin/edit-venue/25	admin	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:53:05.422637+00
581	/admin/edit-venue/25	admin	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:53:08.132498+00
582	/admin/venues	admin	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:53:34.41075+00
583	/admin/edit-venue/25	admin	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:54:08.812168+00
584	/map	map	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:54:18.331336+00
585	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:54:33.129457+00
586	/map	map	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:54:53.34562+00
587	/map	map	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:56:28.080808+00
588	/map	map	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:56:28.097594+00
589	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 13:56:47.621571+00
590	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 15:15:20.079643+00
591	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 15:37:38.472769+00
592	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-13 15:37:38.482451+00
593	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-14 00:08:32.494795+00
594	/venues/18	venue	https://findyusports.com/venues/18	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-14 01:30:38.313508+00
595	/map	map	https://findyusports.com/map?sport=basketball	Mozilla/5.0 (Linux; Android 5.0) AppleWebKit/537.36 (KHTML, like Gecko) Mobile Safari/537.36 (compatible; Bytespider; https://zhanzhang.toutiao.com/)	110.249.202.186	\N	2026-01-14 05:22:57.160105+00
596	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-14 07:16:01.007834+00
597	/	home	\N	Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/100.0.4896.127 Safari/537.36	40.77.177.123	\N	2026-01-14 08:01:33.128061+00
598	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-14 10:21:20.263645+00
599	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-14 10:21:20.271151+00
600	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-14 10:32:48.596175+00
601	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-14 10:32:48.651208+00
602	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-14 10:35:28.35619+00
603	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-14 10:35:28.477617+00
604	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	103.220.218.90	\N	2026-01-14 10:35:30.447922+00
605	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	103.220.218.90	\N	2026-01-14 10:35:36.856894+00
606	/venues/9	venue	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	103.220.218.90	\N	2026-01-14 10:35:41.659879+00
607	/venues/9	venue	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	103.220.218.90	\N	2026-01-14 10:35:51.679412+00
608	/venues/9	venue	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	103.220.218.90	\N	2026-01-14 10:36:00.478645+00
609	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.34 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-14 10:38:03.941724+00
610	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.34 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-14 10:38:04.602962+00
611	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.34 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-14 10:38:04.752186+00
612	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.34 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-14 10:38:04.810909+00
613	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.34 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-14 10:38:05.01368+00
614	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.34 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-14 10:38:05.262164+00
615	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-14 10:39:25.651723+00
616	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-14 10:39:25.65236+00
617	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-14 10:39:33.659151+00
618	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-14 10:39:33.719412+00
619	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-14 10:39:48.17901+00
620	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-14 10:39:48.198812+00
621	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	160.22.157.85	\N	2026-01-14 10:39:48.326026+00
622	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	160.22.157.85	\N	2026-01-14 10:39:50.07798+00
623	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-14 10:40:03.548204+00
624	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-14 10:40:03.550143+00
625	/admin/venues	admin	http://localhost:3000/venues/25	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-14 10:40:12.206465+00
626	/venues/25	venue	http://localhost:3000/venues/25	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	::1	\N	2026-01-14 10:40:49.430895+00
627	/	home	https://findyusports-nlkn4n6y3-findyu.vercel.app/	vercel-screenshot/1.0	137.184.7.246	\N	2026-01-14 10:53:14.437874+00
628	/	home	https://findyusports-nlkn4n6y3-findyu.vercel.app/	vercel-screenshot/1.0	164.92.74.248	\N	2026-01-14 10:53:14.88892+00
629	/	home	https://findyusports-7uba10bwf-findyu.vercel.app/	vercel-screenshot/1.0	159.223.196.247	\N	2026-01-14 11:03:18.46522+00
630	/	home	https://findyusports-7uba10bwf-findyu.vercel.app/	vercel-screenshot/1.0	146.190.141.126	\N	2026-01-14 11:03:18.886672+00
631	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.124.91	\N	2026-01-14 11:11:38.834081+00
632	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.124.91	\N	2026-01-14 11:11:40.049869+00
633	/venues/2	venue	https://findyusports.com/venues/2	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.169 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-14 18:54:10.631778+00
635	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-15 03:54:56.160773+00
636	/venues/1	venue	https://findyusports.com/venues/1	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-15 06:53:49.23468+00
637	/venues/3	venue	https://findyusports.com/venues/3	Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/143.0.7499.192 Safari/537.36	66.249.69.71	\N	2026-01-15 07:04:06.402611+00
638	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.71	\N	2026-01-15 07:42:01.809528+00
639	/map	map	https://findyusports.com/map?sport=basketball	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.170	\N	2026-01-15 20:36:25.536838+00
640	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 03:25:19.439542+00
641	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 03:25:20.535977+00
642	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:29:09.720771+00
643	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:29:57.888249+00
644	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:32:45.449253+00
645	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:32:46.203768+00
646	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:32:47.082191+00
647	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:32:47.761502+00
648	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:32:48.381866+00
649	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:32:48.909963+00
650	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:32:49.453375+00
651	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:32:50.800003+00
652	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:32:51.361763+00
653	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:40:19.21721+00
654	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:40:20.105985+00
655	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:40:21.008754+00
656	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:40:52.498399+00
657	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 04:42:16.762004+00
658	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 04:42:16.91894+00
659	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 04:42:17.172566+00
660	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 04:42:17.1892+00
661	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 04:42:17.35294+00
662	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 04:42:17.367958+00
663	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:42:25.695137+00
664	/	home	https://findyusports-91rep5kjj-findyu.vercel.app/	vercel-screenshot/1.0	64.23.161.158	\N	2026-01-16 04:42:56.14772+00
665	/	home	https://findyusports-91rep5kjj-findyu.vercel.app/	vercel-screenshot/1.0	164.92.74.248	\N	2026-01-16 04:42:56.506072+00
666	/	home	https://findyusports.com/venues/9	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:43:47.431864+00
667	/	home	https://findyusports-oubtrrl2m-findyu.vercel.app/	vercel-screenshot/1.0	137.184.38.20	\N	2026-01-16 04:49:33.662581+00
668	/	home	https://findyusports-oubtrrl2m-findyu.vercel.app/	vercel-screenshot/1.0	147.182.224.5	\N	2026-01-16 04:49:34.117649+00
672	/	home	https://findyusports-il1ml2t6y-findyu.vercel.app/	vercel-screenshot/1.0	146.190.141.126	\N	2026-01-16 04:51:20.980013+00
673	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:51:22.928118+00
674	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:52:38.185778+00
675	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:52:39.817286+00
676	/	home	https://findyusports-1crkj5p3i-findyu.vercel.app/	vercel-screenshot/1.0	144.126.222.98	\N	2026-01-16 04:53:29.172945+00
677	/	home	https://findyusports-1crkj5p3i-findyu.vercel.app/	vercel-screenshot/1.0	143.244.185.214	\N	2026-01-16 04:53:29.596139+00
678	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:53:40.043823+00
679	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:53:42.66222+00
680	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:53:51.639569+00
681	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:55:00.570488+00
682	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:55:39.440846+00
683	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:55:41.589685+00
684	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 04:55:57.66666+00
685	/	home	https://findyusports-1gvbe28u2-findyu.vercel.app/	vercel-screenshot/1.0	165.232.138.20	\N	2026-01-16 04:56:44.950954+00
686	/	home	https://findyusports-1gvbe28u2-findyu.vercel.app/	vercel-screenshot/1.0	134.199.225.37	\N	2026-01-16 04:56:45.392972+00
687	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.230.155	\N	2026-01-16 04:56:53.11033+00
688	/	home	https://findyusports-ptmx0pt1g-findyu.vercel.app/	vercel-screenshot/1.0	143.244.185.214	\N	2026-01-16 04:57:12.028066+00
689	/	home	https://findyusports-ptmx0pt1g-findyu.vercel.app/	vercel-screenshot/1.0	147.182.224.5	\N	2026-01-16 04:57:12.521966+00
690	/	home	https://findyusports-mw252ape7-findyu.vercel.app/	vercel-screenshot/1.0	164.92.74.248	\N	2026-01-16 04:58:50.486938+00
691	/	home	https://findyusports-mw252ape7-findyu.vercel.app/	vercel-screenshot/1.0	146.190.141.126	\N	2026-01-16 04:58:50.925993+00
692	/	home	https://findyusports-nz9ut4uw4-findyu.vercel.app/	vercel-screenshot/1.0	64.23.249.195	\N	2026-01-16 04:59:19.395401+00
693	/	home	https://findyusports-nz9ut4uw4-findyu.vercel.app/	vercel-screenshot/1.0	143.110.154.157	\N	2026-01-16 04:59:19.500877+00
694	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	188.253.123.154	\N	2026-01-16 10:37:30.866757+00
695	/venues/8	venue	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 10:40:30.454702+00
696	/venues/8	venue	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 10:40:30.473419+00
697	/map	map	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 10:40:39.311967+00
698	/	home	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 10:40:40.313815+00
699	/	home	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 10:40:50.098067+00
700	/	home	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 10:40:50.662295+00
701	/	home	https://findyusports-byu4n1enh-findyu.vercel.app/	vercel-screenshot/1.0	134.199.225.37	\N	2026-01-16 10:41:05.55936+00
702	/	home	https://findyusports-byu4n1enh-findyu.vercel.app/	vercel-screenshot/1.0	137.184.38.20	\N	2026-01-16 10:41:06.028861+00
703	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.102	\N	2026-01-16 10:41:40.473995+00
704	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.102	\N	2026-01-16 10:41:40.526242+00
705	/	home	https://findyusports-c5x7obbl2-findyu.vercel.app/	vercel-screenshot/1.0	137.184.38.20	\N	2026-01-16 10:44:10.433103+00
706	/	home	https://findyusports-c5x7obbl2-findyu.vercel.app/	vercel-screenshot/1.0	137.184.1.15	\N	2026-01-16 10:44:10.900582+00
707	/	home	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 10:47:42.591404+00
708	/	home	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 10:47:43.266328+00
709	/	home	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 10:47:45.541791+00
710	/	home	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 10:47:45.595415+00
711	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.102	\N	2026-01-16 10:48:01.202061+00
712	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.102	\N	2026-01-16 10:48:25.596981+00
713	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.102	\N	2026-01-16 10:48:26.942719+00
714	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.102	\N	2026-01-16 10:48:27.75917+00
715	/	home	https://findyusports-86cry8nij-findyu.vercel.app/	vercel-screenshot/1.0	64.23.177.195	\N	2026-01-16 10:48:55.240867+00
716	/	home	https://findyusports-86cry8nij-findyu.vercel.app/	vercel-screenshot/1.0	144.126.222.98	\N	2026-01-16 10:48:55.69528+00
717	/	home	https://findyusports-n89fv0t8k-findyu.vercel.app/	vercel-screenshot/1.0	147.182.224.5	\N	2026-01-16 10:49:45.023324+00
718	/	home	https://findyusports-n89fv0t8k-findyu.vercel.app/	vercel-screenshot/1.0	64.23.255.202	\N	2026-01-16 10:49:45.326289+00
719	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.102	\N	2026-01-16 10:49:59.538794+00
720	/	home	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 10:52:58.258728+00
721	/	home	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 10:52:58.951752+00
722	/	home	https://findyusports-5dknv5gla-findyu.vercel.app/	vercel-screenshot/1.0	165.232.138.20	\N	2026-01-16 10:54:54.303866+00
723	/	home	https://findyusports-5dknv5gla-findyu.vercel.app/	vercel-screenshot/1.0	143.110.154.157	\N	2026-01-16 10:54:54.719465+00
724	/	home	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 10:55:19.357444+00
725	/	home	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 10:55:19.623012+00
726	/	home	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 10:55:21.591329+00
727	/	home	http://localhost:3000/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 10:55:21.626414+00
728	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.102	\N	2026-01-16 10:55:25.036884+00
729	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.102	\N	2026-01-16 10:56:57.633959+00
730	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.102	\N	2026-01-16 10:56:58.748031+00
731	/	home	https://findyusports-dkp4gg04g-findyu.vercel.app/	vercel-screenshot/1.0	137.184.41.46	\N	2026-01-16 10:57:14.372221+00
732	/	home	https://findyusports-dkp4gg04g-findyu.vercel.app/	vercel-screenshot/1.0	147.182.232.177	\N	2026-01-16 10:57:14.794994+00
733	/	home	https://findyusports-dryipcar5-findyu.vercel.app/	vercel-screenshot/1.0	143.110.154.157	\N	2026-01-16 10:58:47.067036+00
734	/	home	https://findyusports-dryipcar5-findyu.vercel.app/	vercel-screenshot/1.0	64.23.161.158	\N	2026-01-16 10:58:47.485573+00
735	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.102	\N	2026-01-16 10:58:50.495053+00
736	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.102	\N	2026-01-16 10:58:51.543634+00
737	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 11:10:58.718696+00
738	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-16 11:10:59.371423+00
739	/	home	https://findyusports-hpjufqvil-findyu.vercel.app/	vercel-screenshot/1.0	137.184.38.20	\N	2026-01-16 11:13:52.913309+00
740	/	home	https://findyusports-hpjufqvil-findyu.vercel.app/	vercel-screenshot/1.0	147.182.232.177	\N	2026-01-16 11:13:53.354923+00
741	/venues/5	venue	https://findyusports.com/venues/5	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.170	\N	2026-01-16 20:45:20.453034+00
742	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; Android 5.0) AppleWebKit/537.36 (KHTML, like Gecko) Mobile Safari/537.36 (compatible; Bytespider; https://zhanzhang.toutiao.com/)	110.249.202.183	\N	2026-01-16 22:05:37.002179+00
743	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; Android 5.0) AppleWebKit/537.36 (KHTML, like Gecko) Mobile Safari/537.36 (compatible; Bytespider; https://zhanzhang.toutiao.com/)	110.249.202.44	\N	2026-01-16 23:56:38.706048+00
744	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:30:05.853208+00
745	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:30:08.276782+00
746	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:30:09.0285+00
747	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:30:09.582656+00
748	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:30:10.048912+00
749	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:30:11.892498+00
750	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:30:12.396215+00
751	/	home	https://findyusports-nzg490lo7-findyu.vercel.app/	vercel-screenshot/1.0	137.184.1.15	\N	2026-01-17 02:31:45.102952+00
752	/	home	https://findyusports-nzg490lo7-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	3.101.24.105	\N	2026-01-17 02:31:45.501457+00
753	/	home	https://findyusports-nzg490lo7-findyu.vercel.app/	vercel-screenshot/1.0	143.110.159.76	\N	2026-01-17 02:31:45.663478+00
754	/	home	https://findyusports-nzg490lo7-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	3.101.66.95	\N	2026-01-17 02:31:46.066758+00
755	/	home	https://findyusports-3n5n0e58c-findyu.vercel.app/	vercel-screenshot/1.0	64.23.255.202	\N	2026-01-17 02:32:11.457048+00
756	/	home	https://findyusports-3n5n0e58c-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.183.241.46	\N	2026-01-17 02:32:11.517668+00
757	/	home	https://findyusports-3n5n0e58c-findyu.vercel.app/	vercel-screenshot/1.0	147.182.224.5	\N	2026-01-17 02:32:11.899489+00
758	/	home	https://findyusports-3n5n0e58c-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	13.57.10.46	\N	2026-01-17 02:32:12.021067+00
759	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:35:02.636396+00
760	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:35:03.238841+00
761	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:35:16.065044+00
762	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:35:16.711395+00
763	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:35:18.929347+00
764	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:35:18.942964+00
765	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:43:03.17462+00
766	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:43:03.834104+00
767	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:43:09.538695+00
768	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:43:10.332373+00
769	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:43:11.159868+00
770	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:43:12.001995+00
771	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:43:12.747753+00
772	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	::1	\N	2026-01-17 02:43:21.314927+00
773	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	::1	\N	2026-01-17 02:43:21.32796+00
774	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	::1	\N	2026-01-17 02:43:24.897711+00
775	/	home	https://findyusports-d9d4kzh2b-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	18.144.14.212	\N	2026-01-17 02:43:25.168091+00
776	/	home	https://findyusports-d9d4kzh2b-findyu.vercel.app/	vercel-screenshot/1.0	64.23.177.195	\N	2026-01-17 02:43:25.593783+00
777	/	home	https://findyusports-d9d4kzh2b-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.177.0.10	\N	2026-01-17 02:43:25.65055+00
778	/	home	https://findyusports-d9d4kzh2b-findyu.vercel.app/	vercel-screenshot/1.0	64.23.249.195	\N	2026-01-17 02:43:25.65941+00
779	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:43:36.159863+00
780	/	home	https://findyusports-mdedkxeu1-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.177.11.57	\N	2026-01-17 02:43:57.388758+00
781	/	home	https://findyusports-mdedkxeu1-findyu.vercel.app/	vercel-screenshot/1.0	137.184.41.46	\N	2026-01-17 02:43:57.74853+00
782	/	home	https://findyusports-mdedkxeu1-findyu.vercel.app/	vercel-screenshot/1.0	144.126.222.98	\N	2026-01-17 02:43:57.779837+00
783	/	home	https://findyusports-mdedkxeu1-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.176.32.81	\N	2026-01-17 02:43:57.793306+00
784	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:44:44.944146+00
785	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:44:45.534971+00
786	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:45:45.21815+00
823	/	home	https://findyusports-17rojyzkc-findyu.vercel.app/	vercel-screenshot/1.0	137.184.227.16	\N	2026-01-17 02:54:34.917817+00
787	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:45:45.884493+00
788	/	home	https://findyusports-9ke0ymzk4-findyu.vercel.app/	vercel-screenshot/1.0	146.190.141.126	\N	2026-01-17 02:46:48.465954+00
789	/	home	https://findyusports-9ke0ymzk4-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	50.18.90.224	\N	2026-01-17 02:46:48.911617+00
790	/	home	https://findyusports-9ke0ymzk4-findyu.vercel.app/	vercel-screenshot/1.0	146.190.161.104	\N	2026-01-17 02:46:48.924697+00
791	/	home	https://findyusports-9ke0ymzk4-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.241.249.89	\N	2026-01-17 02:46:48.993886+00
792	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:48:23.934832+00
793	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:48:24.550724+00
794	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:48:26.918008+00
795	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:48:26.94643+00
796	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:48:38.321644+00
797	/	home	https://findyusports-1jt7l56jm-findyu.vercel.app/	vercel-screenshot/1.0	137.184.41.46	\N	2026-01-17 02:50:08.383152+00
798	/	home	https://findyusports-1jt7l56jm-findyu.vercel.app/	vercel-screenshot/1.0	146.190.141.126	\N	2026-01-17 02:50:08.781948+00
799	/	home	https://findyusports-1jt7l56jm-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.193.2.82	\N	2026-01-17 02:50:08.843717+00
800	/	home	https://findyusports-1jt7l56jm-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	3.101.24.105	\N	2026-01-17 02:50:09.016799+00
801	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:50:45.378715+00
802	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:50:53.760116+00
803	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:50:55.58677+00
804	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:50:56.936001+00
805	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:50:58.565833+00
806	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:51:52.703948+00
807	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:51:55.137341+00
808	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:51:55.962245+00
809	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	::1	\N	2026-01-17 02:52:03.046859+00
810	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	::1	\N	2026-01-17 02:52:03.131191+00
811	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:52:03.83815+00
812	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:52:11.483814+00
813	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:52:11.736776+00
815	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:52:13.244228+00
814	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:52:13.246925+00
816	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:52:15.116068+00
817	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:52:15.369831+00
818	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:52:16.447629+00
819	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:52:16.449259+00
820	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:52:37.460343+00
821	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.3.35 Chrome/138.0.7204.251 Electron/37.7.0 Safari/537.36	::1	\N	2026-01-17 02:52:37.76392+00
822	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:52:40.418204+00
824	/	home	https://findyusports-17rojyzkc-findyu.vercel.app/	vercel-screenshot/1.0	137.184.227.16	\N	2026-01-17 02:54:35.392053+00
825	/	home	https://findyusports-17rojyzkc-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	52.8.32.108	\N	2026-01-17 02:54:35.424386+00
826	/	home	https://findyusports-17rojyzkc-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	13.57.34.98	\N	2026-01-17 02:54:35.468018+00
827	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:57:18.295326+00
828	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	112.10.195.176	\N	2026-01-17 02:57:18.573708+00
829	/	home	https://findyusports.com/	Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)	202.8.40.238	\N	2026-01-17 03:47:17.471531+00
830	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	51.178.79.136	\N	2026-01-17 09:56:14.776577+00
831	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.685	51.178.79.136	\N	2026-01-17 10:23:17.624895+00
832	/map	map	https://findyusports.com/map?sport=football	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.170	\N	2026-01-17 11:39:01.501846+00
833	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/134.0.6998.35 Safari/537.36	113.215.188.205	\N	2026-01-17 23:01:27.714947+00
834	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/134.0.6998.35 Safari/537.36	113.215.189.248	\N	2026-01-18 04:14:51.981377+00
835	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.169	\N	2026-01-18 06:32:48.971903+00
836	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.169	\N	2026-01-18 06:32:55.9116+00
837	/	home	https://findyusports.com/	Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/143.0.7499.192 Safari/537.36	66.249.69.169	\N	2026-01-18 06:32:55.95171+00
838	/venues/20	venue	https://findyusports.com/venues/20	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.69	\N	2026-01-18 08:52:03.206543+00
839	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.69	\N	2026-01-18 08:53:18.959326+00
840	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.69	\N	2026-01-18 08:55:40.799103+00
841	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.69	\N	2026-01-18 08:55:43.406058+00
842	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.69	\N	2026-01-18 08:55:44.142205+00
843	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.69	\N	2026-01-18 08:55:44.800418+00
844	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.69	\N	2026-01-18 08:55:45.321206+00
845	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.69	\N	2026-01-18 08:55:45.506723+00
846	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.69	\N	2026-01-18 08:55:45.747708+00
847	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.69	\N	2026-01-18 09:37:32.377467+00
848	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.69	\N	2026-01-18 09:37:33.827162+00
849	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.69	\N	2026-01-18 09:37:34.571409+00
850	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.69	\N	2026-01-18 09:37:35.453722+00
851	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.0.693	117.147.16.69	\N	2026-01-18 09:37:35.876094+00
852	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:38:21.530459+00
853	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:38:46.575293+00
854	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:38:47.333591+00
855	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:42:57.420513+00
856	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:42:58.55956+00
857	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:42:59.420911+00
858	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:42:59.731987+00
859	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:42:59.933841+00
860	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:43:00.311686+00
861	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:43:00.804182+00
862	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:43:21.543756+00
863	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:45:49.372571+00
864	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:45:51.053748+00
865	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:48:47.679516+00
866	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:48:48.346474+00
867	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:49:20.307154+00
868	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:49:21.219594+00
869	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:50:15.236052+00
870	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:51:27.977382+00
871	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:56:59.423821+00
872	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 09:57:00.085597+00
873	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 10:13:40.438497+00
874	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 10:13:44.923403+00
875	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-18 10:13:45.404946+00
876	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.90	\N	2026-01-18 10:18:05.353304+00
877	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.90	\N	2026-01-18 10:18:13.029078+00
878	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.123.151	\N	2026-01-18 10:26:45.713364+00
879	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.123.151	\N	2026-01-18 10:26:46.626184+00
880	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.123.151	\N	2026-01-18 10:26:58.662375+00
881	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.123.151	\N	2026-01-18 10:26:59.34201+00
882	/	home	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.123.151	\N	2026-01-18 10:27:01.533544+00
883	/	home	https://findyusports-pudvnxobx-findyu.vercel.app/	vercel-screenshot/1.0	164.92.77.131	\N	2026-01-18 10:27:03.733609+00
884	/	home	https://findyusports-pudvnxobx-findyu.vercel.app/	vercel-screenshot/1.0	164.92.77.131	\N	2026-01-18 10:27:03.791787+00
885	/admin/add-venue	admin	https://vercel.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.123.151	\N	2026-01-18 10:27:13.897582+00
886	/admin/data	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.123.151	\N	2026-01-18 10:27:19.02068+00
887	/admin/analytics	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.123.151	\N	2026-01-18 10:27:20.342622+00
888	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.123.151	\N	2026-01-18 10:27:40.918321+00
889	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.93	\N	2026-01-18 10:30:02.667612+00
890	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.93	\N	2026-01-18 10:30:50.044276+00
891	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.93	\N	2026-01-18 10:37:38.24952+00
892	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.93	\N	2026-01-18 10:37:39.775486+00
893	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.93	\N	2026-01-18 10:47:45.892107+00
894	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.93	\N	2026-01-18 10:47:47.855693+00
895	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.93	\N	2026-01-18 10:47:54.971467+00
896	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.93	\N	2026-01-18 11:11:21.531356+00
897	/	home	https://findyusports-kqpnmx9n6-findyu.vercel.app/	vercel-screenshot/1.0	147.182.232.177	\N	2026-01-18 12:02:41.424911+00
898	/	home	https://findyusports-kqpnmx9n6-findyu.vercel.app/	vercel-screenshot/1.0	147.182.232.177	\N	2026-01-18 12:02:41.524767+00
899	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.93	\N	2026-01-18 12:08:17.440218+00
900	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.93	\N	2026-01-18 12:08:59.467609+00
901	/	home	https://findyusports-79v7u63pb-findyu.vercel.app/	vercel-screenshot/1.0	147.182.236.253	\N	2026-01-18 12:10:41.556577+00
902	/	home	https://findyusports-79v7u63pb-findyu.vercel.app/	vercel-screenshot/1.0	147.182.232.177	\N	2026-01-18 12:10:41.996722+00
903	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.93	\N	2026-01-18 12:16:26.12575+00
904	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.93	\N	2026-01-18 12:16:36.702711+00
905	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.93	\N	2026-01-18 12:17:21.057118+00
906	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.93	\N	2026-01-18 12:19:17.120866+00
907	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.93	\N	2026-01-18 12:19:22.84964+00
908	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.93	\N	2026-01-18 12:19:23.909581+00
909	/venues/9	venue	https://findyusports.com/venues/9	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.171	\N	2026-01-19 05:52:46.852869+00
910	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-19 10:38:47.063488+00
911	/venues/8	venue	https://findyusports.com/venues/8	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-19 10:39:00.599667+00
912	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-19 10:39:03.902654+00
913	/	home	https://findyusports.com/	Mozilla/5.0 (Symbian/3; Series60/5.2 NokiaE7-00/010.016; Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/525 (KHTML, like Gecko) Version/3.0 BrowserNG/7.2.7.3 3gpp-gba	100.26.249.70	\N	2026-01-19 12:27:11.512906+00
914	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Mobile Safari/537.36	113.248.17.174	\N	2026-01-19 17:13:34.686573+00
915	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 09:37:06.315642+00
916	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 10:18:24.579957+00
917	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 10:36:21.660146+00
918	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 11:02:24.133485+00
919	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 11:04:59.724167+00
920	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 11:05:32.059863+00
921	/map	map	https://findyusports.com/map?sport=basketball	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 11:05:38.828057+00
922	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 11:05:48.920239+00
923	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 11:13:41.144824+00
924	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 11:13:41.857344+00
925	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 11:13:41.878991+00
926	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 11:13:43.557614+00
927	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 11:13:47.752963+00
928	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 11:13:47.852662+00
929	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 11:13:48.609318+00
930	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 11:13:49.28298+00
931	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 11:13:49.300906+00
932	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 11:13:49.454469+00
933	/admin/venues	admin	https://findyusports.com/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 11:14:14.42723+00
934	/admin/analytics	admin	https://findyusports.com/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 11:14:15.666898+00
935	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 11:14:19.734988+00
936	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 11:14:36.45057+00
937	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 11:14:36.629924+00
938	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 11:18:22.492479+00
939	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 11:18:22.660942+00
940	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 11:22:56.337236+00
941	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 12:18:59.8696+00
942	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 12:19:07.756391+00
943	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 12:19:44.793511+00
944	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 12:19:45.825214+00
945	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 12:20:16.045784+00
946	/	home	https://findyusports-dobn46lol-findyu.vercel.app/	vercel-screenshot/1.0	164.92.66.89	\N	2026-01-20 12:20:29.531283+00
947	/	home	https://findyusports-dobn46lol-findyu.vercel.app/	vercel-screenshot/1.0	24.144.80.119	\N	2026-01-20 12:20:29.989658+00
948	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 12:25:01.65815+00
949	/venues/31	venue	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 12:25:22.015437+00
950	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 12:25:40.958307+00
951	/venues/1	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 12:25:42.906509+00
952	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 12:25:45.102299+00
953	/venues/33	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 12:25:48.290225+00
954	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 12:26:27.137503+00
955	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 12:26:33.735444+00
956	/	home	https://findyusports-hh72hlwa8-findyu.vercel.app/	vercel-screenshot/1.0	146.190.148.232	\N	2026-01-20 12:28:12.887035+00
957	/	home	https://findyusports-hh72hlwa8-findyu.vercel.app/	vercel-screenshot/1.0	64.23.134.64	\N	2026-01-20 12:28:13.306772+00
958	/admin/add-venue	admin	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 12:32:50.453112+00
959	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.85	\N	2026-01-20 12:33:23.362918+00
960	/	home	https://findyusports-4ouacim1y-findyu.vercel.app/	vercel-screenshot/1.0	64.23.149.73	\N	2026-01-20 12:39:08.031275+00
961	/	home	https://findyusports-4ouacim1y-findyu.vercel.app/	vercel-screenshot/1.0	64.23.153.247	\N	2026-01-20 12:39:08.140622+00
962	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:26:56.964226+00
963	/venues/49	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:27:10.374613+00
964	/venues/49	venue	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:27:45.575432+00
965	/venues/49	venue	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:27:57.444995+00
966	/venues/49	venue	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:28:09.565505+00
967	/venues/49	venue	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:30:17.404274+00
968	/map	map	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:30:22.320324+00
969	/admin/add-venue	admin	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:32:33.914809+00
970	/admin/add-venue	admin	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:32:38.504664+00
971	/map	map	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:32:41.431331+00
972	/map	map	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:32:44.386265+00
973	/admin/add-venue	admin	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:33:37.659546+00
974	/admin/venues	admin	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:39:35.134063+00
975	/admin/add-venue	admin	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:39:47.635798+00
976	/admin/add-venue	admin	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:40:28.365469+00
977	/admin/add-venue	admin	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:41:09.929706+00
978	/admin/add-venue	admin	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:51:17.371407+00
979	/admin/add-venue	admin	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:51:37.092468+00
980	/admin/add-venue	admin	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:51:38.551651+00
981	/admin/add-venue	admin	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:53:12.975639+00
982	/admin/add-venue	admin	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 13:56:27.763485+00
983	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 13:57:28.065788+00
984	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 13:57:28.894318+00
985	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 13:57:47.198832+00
986	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:01:03.638128+00
987	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:01:03.892903+00
988	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:01:05.305897+00
989	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:01:05.320457+00
990	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:01:06.136574+00
991	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:01:06.13786+00
992	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:02:08.330618+00
993	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:02:08.577263+00
994	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:02:09.827182+00
995	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:02:09.867713+00
996	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:02:10.412545+00
997	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:02:10.693122+00
998	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:02:10.870351+00
999	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:02:10.941078+00
1000	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:15.185492+00
1001	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:15.561017+00
1002	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:16.047102+00
1003	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:16.080444+00
1004	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:16.828166+00
1005	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:16.850689+00
1006	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:39.153081+00
1007	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:40.060288+00
1008	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:40.194611+00
1009	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:40.269522+00
1010	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:40.306675+00
1011	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:40.553049+00
1012	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:40.719609+00
1017	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:41.148173+00
1018	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:41.399733+00
1019	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:41.418073+00
1020	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:41.540317+00
1021	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:41.855171+00
1022	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:42.254576+00
1023	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:42.283946+00
1024	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:45.20034+00
1916	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/134.0.6998.35 Safari/537.36	113.215.189.72	\N	2026-02-01 21:40:38.558162+00
1917	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/134.0.6998.35 Safari/537.36	113.215.189.74	\N	2026-02-01 21:41:48.858449+00
1918	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/134.0.6998.35 Safari/537.36	113.215.189.68	\N	2026-02-01 21:42:05.030278+00
1919	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/134.0.6998.35 Safari/537.36	113.215.189.73	\N	2026-02-01 21:43:50.663659+00
1977	/venues/247	venue	https://findyusports.com/venues/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	160.22.157.85	\N	2026-02-03 05:16:40.384925+00
2012	/	home	https://findyusports-4qwa5smme-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.183.49.37	\N	2026-02-03 12:11:14.723886+00
2013	/	home	https://findyusports-4qwa5smme-findyu.vercel.app/	vercel-screenshot/1.0	147.182.231.74	\N	2026-02-03 12:11:15.152953+00
2014	/	home	https://findyusports-4qwa5smme-findyu.vercel.app/	vercel-screenshot/1.0	64.23.212.160	\N	2026-02-03 12:11:15.226244+00
1013	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:40.724051+00
1014	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:40.877421+00
1015	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:40.894767+00
1016	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:41.14491+00
1025	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:03:51.170262+00
1026	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:04:02.006225+00
1027	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:04:08.995342+00
1028	/	home	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	160.22.157.88	\N	2026-01-20 14:08:15.851543+00
1029	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:09:59.456338+00
1030	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:09:59.702478+00
1031	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:17:45.859884+00
1032	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:17:45.911582+00
1033	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:17:47.892584+00
1034	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:17:47.910582+00
1035	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:40:28.917189+00
1036	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:40:29.153604+00
1037	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:40:30.542747+00
1038	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:40:30.591447+00
1039	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:40:31.359174+00
1040	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:40:31.411248+00
1041	/map	map	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:40:36.669508+00
1042	/map	map	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:40:36.814163+00
1043	/map	map	http://localhost:3000/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:40:37.492004+00
1044	/map	map	http://localhost:3000/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:40:37.524359+00
1045	/map	map	http://localhost:3000/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:40:38.194508+00
1046	/map	map	http://localhost:3000/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:40:38.228623+00
1047	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:40:44.721218+00
1048	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:40:45.565608+00
1049	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:41:18.838422+00
1050	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:41:19.10596+00
1051	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:42:35.612804+00
1052	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:42:35.613709+00
1053	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:52:12.67474+00
1054	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:52:12.766432+00
1055	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25060RK16C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	112.10.195.176	\N	2026-01-20 14:55:06.196843+00
1920	/	home	https://www.google.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:135.0) Gecko/20100101 Firefox/135.0	161.115.235.60	\N	2026-02-01 21:54:26.064942+00
1056	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25060RK16C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	112.10.195.176	\N	2026-01-20 14:55:10.024779+00
1057	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25060RK16C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	112.10.195.176	\N	2026-01-20 14:55:11.479199+00
1058	/	home	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.123.151	\N	2026-01-20 14:55:26.350027+00
1059	/	home	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.123.151	\N	2026-01-20 14:56:25.291331+00
1060	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:59:40.887952+00
1061	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 14:59:40.948013+00
1062	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:00:10.660364+00
1063	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:00:10.738569+00
1064	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:01:15.739433+00
1065	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:01:16.322998+00
1066	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	112.10.195.176	\N	2026-01-20 15:03:13.268602+00
1067	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	112.10.195.176	\N	2026-01-20 15:03:22.330319+00
1068	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	112.10.195.176	\N	2026-01-20 15:03:23.544869+00
1069	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	112.10.195.176	\N	2026-01-20 15:03:25.586477+00
1070	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	112.10.195.176	\N	2026-01-20 15:03:33.24651+00
1071	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:06:34.675769+00
1072	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:06:34.687822+00
1073	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:06:35.272018+00
1074	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:06:35.293304+00
1075	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:06:35.315278+00
1076	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:06:35.967919+00
1077	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:06:35.987206+00
1078	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:06:37.261866+00
1079	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:07:08.907511+00
1080	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:07:08.928936+00
1082	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:07:10.703348+00
1087	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:18:53.969468+00
1088	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:18:54.16396+00
1089	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:18:54.796839+00
1090	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:18:55.119355+00
1093	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:18:55.959647+00
1094	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:18:56.139761+00
1095	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:20:27.775922+00
1096	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:20:27.852686+00
1081	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:07:10.705511+00
1083	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:11:38.044782+00
1084	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:11:38.284801+00
1085	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:13:04.337128+00
1086	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:13:04.385902+00
1091	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:18:55.120539+00
1092	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:18:55.958266+00
1106	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:24:25.241295+00
1111	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:32:17.271713+00
1921	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.246.23.244	\N	2026-02-01 22:10:29.487923+00
1978	/venues/247	venue	https://findyusports.com/venues/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	160.22.157.85	\N	2026-02-03 05:18:40.32456+00
1980	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	160.22.157.85	\N	2026-02-03 05:19:05.406227+00
2015	/	home	https://findyusports-4qwa5smme-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.176.13.68	\N	2026-02-03 12:11:15.282995+00
2016	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 12:11:40.031027+00
2017	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 12:11:42.7217+00
2018	/venues/247	venue	https://findyusports.com/venues/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	188.253.124.85	\N	2026-02-03 12:11:47.8721+00
1097	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	112.10.195.176	\N	2026-01-20 15:21:05.685841+00
1098	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	115.227.42.37	\N	2026-01-20 15:21:06.160221+00
1099	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	112.10.195.176	\N	2026-01-20 15:21:06.612068+00
1100	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	115.227.42.37	\N	2026-01-20 15:21:07.084473+00
1101	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	112.10.195.176	\N	2026-01-20 15:21:07.81348+00
1102	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	183.131.239.175	\N	2026-01-20 15:21:08.219574+00
1103	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	112.10.195.176	\N	2026-01-20 15:21:15.31707+00
1104	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	112.10.195.176	\N	2026-01-20 15:21:16.877127+00
1105	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:24:25.177087+00
1107	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:28:07.18107+00
1108	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:28:08.205286+00
1109	/	home	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.123.151	\N	2026-01-20 15:28:45.267817+00
1110	/	home	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.123.151	\N	2026-01-20 15:28:46.304274+00
1112	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:32:17.272466+00
1113	/	home	https://findyusports-arqzpr3er-findyu.vercel.app/	vercel-screenshot/1.0	137.184.10.187	\N	2026-01-20 15:34:23.024964+00
1114	/	home	https://findyusports-arqzpr3er-findyu.vercel.app/	vercel-screenshot/1.0	24.199.126.245	\N	2026-01-20 15:34:23.479039+00
1115	/	home	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.123.151	\N	2026-01-20 15:35:24.451997+00
1116	/	home	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.123.151	\N	2026-01-20 15:37:15.070445+00
1117	/admin/add-venue	admin	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.123.151	\N	2026-01-20 15:41:53.067465+00
1118	/admin/add-venue	admin	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.123.151	\N	2026-01-20 15:50:56.002116+00
1119	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:52:40.431702+00
1120	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:56:09.174792+00
1121	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:56:09.365824+00
1122	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:56:12.474171+00
1123	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:56:12.506054+00
1124	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:56:13.128646+00
1125	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:56:13.130567+00
1126	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:56:13.701443+00
1127	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:56:13.703822+00
1128	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:56:14.302024+00
1129	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:56:14.303651+00
1130	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:56:14.828832+00
1131	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 15:56:14.827665+00
1132	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 16:05:38.833635+00
1133	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 16:05:39.419891+00
1134	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 16:05:39.650451+00
1137	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 16:05:39.822432+00
1922	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36	98.81.10.236	\N	2026-02-02 12:59:16.592958+00
1979	/map	map	https://findyusports.com/map?sport=football	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	160.22.157.85	\N	2026-02-03 05:19:04.364382+00
2019	/venues/247	venue	https://findyusports.com/venues/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	188.253.124.85	\N	2026-02-03 12:12:37.440755+00
1135	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 16:05:39.675551+00
1136	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 16:05:39.808035+00
1138	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 16:07:47.926444+00
1139	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 16:07:47.926743+00
1140	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 16:07:48.518551+00
1141	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-20 16:07:48.523431+00
1142	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/134.0.6998.35 Safari/537.36	113.215.189.36	\N	2026-01-20 20:30:19.556968+00
1143	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	183.131.239.184	\N	2026-01-21 08:59:07.467885+00
1144	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	112.10.195.176	\N	2026-01-21 08:59:09.489267+00
1145	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	::1	\N	2026-01-21 09:00:29.927273+00
1146	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	112.10.195.176	\N	2026-01-21 10:29:05.630001+00
1147	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	112.10.195.176	\N	2026-01-21 10:29:07.659473+00
1148	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	183.131.239.175	\N	2026-01-21 10:29:08.234881+00
1149	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	112.10.195.176	\N	2026-01-21 10:29:08.813535+00
1150	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.0.1005 Mobile Safari/537.36	183.131.239.184	\N	2026-01-21 10:29:10.056398+00
1151	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.85	\N	2026-01-21 10:29:46.240273+00
1152	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.85	\N	2026-01-21 10:29:56.963276+00
1153	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.85	\N	2026-01-21 10:30:24.005463+00
1154	/admin/add-venue	admin	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.85	\N	2026-01-21 10:30:29.986984+00
1155	/admin/venues	admin	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.85	\N	2026-01-21 10:45:20.802581+00
1156	/venues/54	venue	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.85	\N	2026-01-21 10:45:30.201388+00
1157	/venues/54	venue	https://findyusports.com/venues/54	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.85	\N	2026-01-21 10:45:46.140706+00
1158	/admin/add-venue	admin	https://findyusports.com/venues/54	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.85	\N	2026-01-21 10:45:49.620458+00
1159	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.85	\N	2026-01-21 10:46:17.489954+00
1160	/map	map	https://findyusports.com/map?keyword=%E4%BA%BA%E6%B0%91	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.85	\N	2026-01-21 10:51:55.410327+00
1161	/map	map	https://findyusports.com/map?keyword=%E8%B5%B7%E8%88%AA	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.85	\N	2026-01-21 10:51:59.031477+00
1162	/venues/56	venue	https://findyusports.com/map?keyword=%E8%B5%B7%E8%88%AA	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.85	\N	2026-01-21 10:52:02.226342+00
1163	/map	map	https://findyusports.com/map?keyword=%E8%B5%B7%E8%88%AA	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.85	\N	2026-01-21 10:52:04.894791+00
1164	/venues/45	venue	https://findyusports.com/map?keyword=%E8%B5%B7%E8%88%AA	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.85	\N	2026-01-21 10:52:06.239742+00
1165	/venues/45	venue	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.85	\N	2026-01-21 10:52:18.243871+00
1166	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; Android 11; SM-A505FN) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.41 Mobile Safari/537.36	52.91.250.33	\N	2026-01-21 12:22:28.925324+00
1167	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; U; PPC Mac OS X; fr-fr) AppleWebKit/312.5 (KHTML, like Gecko) Safari/312.3	130.211.192.108	\N	2026-01-21 15:56:41.406696+00
1168	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; Android 5.0) AppleWebKit/537.36 (KHTML, like Gecko) Mobile Safari/537.36 (compatible; Bytespider; https://zhanzhang.toutiao.com/)	110.249.201.76	\N	2026-01-21 22:43:10.363409+00
1169	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.169	\N	2026-01-22 00:15:40.881602+00
1170	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 09:45:34.848132+00
1171	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 09:45:53.227492+00
1172	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 10:30:58.940623+00
1173	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 10:31:00.688542+00
1174	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 10:33:09.189173+00
1175	/map	map	https://findyusports.com/map?sport=football	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 10:33:33.167396+00
1176	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 10:33:34.939563+00
1177	/map	map	https://findyusports.com/map	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 10:33:46.37405+00
1178	/map	map	https://findyusports.com/map	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 10:33:56.283023+00
1179	/admin/add-venue	admin	https://findyusports.com/map	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 10:34:24.061845+00
1180	/map	map	https://findyusports.com/map	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 10:34:26.606144+00
1181	/map	map	https://findyusports.com/map?keyword=%E9%87%87%E8%8D%B7	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 10:34:28.591188+00
1182	/map	map	https://findyusports.com/map?keyword=%E7%AC%AC%E4%B9%9D	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 10:34:48.1368+00
1183	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 10:42:47.922024+00
1184	/venues/61	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 10:42:50.49455+00
1185	/venues/61	venue	https://findyusports.com/venues/61	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 10:43:02.955053+00
1186	/admin/add-venue	admin	https://findyusports.com/venues/61	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 10:43:04.024632+00
1187	/map	map	https://findyusports.com/map?keyword=%E7%AC%AC%E4%B9%9D	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 10:56:02.71746+00
1188	/map	map	https://findyusports.com/map?keyword=%E7%AC%AC%E4%B9%9D	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 11:15:05.572936+00
1189	/venues/60	venue	https://findyusports.com/map?keyword=%E7%AC%AC%E4%B9%9D	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 11:15:06.88473+00
1190	/map	map	https://findyusports.com/venues/60	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 11:23:11.54905+00
1191	/venues/69	venue	https://findyusports.com/venues/60	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 11:23:13.720958+00
1192	/map	map	https://findyusports.com/venues/61	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 11:45:43.858698+00
1193	/map	map	https://findyusports.com/map	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 11:45:49.295494+00
1194	/map	map	https://findyusports.com/map?keyword=%E4%B8%87%E8%B1%A1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 11:45:53.015836+00
1195	/venues/72	venue	https://findyusports.com/map?keyword=%E4%B8%87%E8%B1%A1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 11:45:55.12243+00
1196	/venues/72	venue	https://findyusports.com/venues/72	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 11:47:28.646654+00
1197	/venues/72	venue	https://findyusports.com/venues/72	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 11:47:50.294284+00
1198	/venues/72	venue	https://findyusports.com/venues/72	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 11:47:58.987195+00
1199	/admin/add-venue	admin	https://findyusports.com/venues/72	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	117.147.16.69	\N	2026-01-22 11:48:37.756577+00
1269	/admin/edit-venue/120	admin	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	175.143.93.106	\N	2026-01-25 10:36:54.325013+00
1200	/map	map	https://findyusports.com/map?sport=basketball	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.170	\N	2026-01-23 01:15:33.179831+00
1201	/venues/42	venue	https://findyusports.com/venues/42	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.170	\N	2026-01-23 02:11:05.239735+00
1202	/venues/72	venue	https://findyusports.com/venues/72	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; GoogleOther)	66.249.69.170	\N	2026-01-23 02:22:31.133955+00
1203	/venues/72	venue	https://findyusports.com/venues/72	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.170	\N	2026-01-23 02:23:49.701242+00
1204	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.219.253	\N	2026-01-23 10:22:10.985913+00
1205	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.6778.33 Safari/537.36	113.165.53.179	\N	2026-01-23 15:53:28.762516+00
1206	/	home	https://findyusports.com/	Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/136.0.0.0 Safari/537.36	40.77.179.67	\N	2026-01-23 19:02:53.563981+00
1207	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; Android 5.0) AppleWebKit/537.36 (KHTML, like Gecko) Mobile Safari/537.36 (compatible; Bytespider; https://zhanzhang.toutiao.com/)	110.249.202.168	\N	2026-01-24 00:25:48.805303+00
1208	/venues/10	venue	https://findyusports.com/venues/10	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.170	\N	2026-01-24 09:57:39.708928+00
1209	/admin/add-venue	admin	https://findyusports.com/venues/54	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.88	\N	2026-01-24 13:33:39.808713+00
1210	/	home	https://findyusports-3r8rrr54m-findyu.vercel.app/	vercel-screenshot/1.0	161.35.234.75	\N	2026-01-24 13:37:21.263223+00
1211	/	home	https://findyusports-3r8rrr54m-findyu.vercel.app/	vercel-screenshot/1.0	146.190.142.122	\N	2026-01-24 13:37:21.355731+00
1212	/venues/45	venue	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.88	\N	2026-01-24 13:38:52.259618+00
1213	/admin/add-venue	admin	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.88	\N	2026-01-24 13:38:53.191989+00
1214	/admin/add-venue	admin	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.88	\N	2026-01-24 13:51:36.293668+00
1215	/	home	https://findyusports-6p75fj5tl-findyu.vercel.app/	vercel-screenshot/1.0	64.23.149.73	\N	2026-01-24 14:03:42.940448+00
1216	/	home	https://findyusports-6p75fj5tl-findyu.vercel.app/	vercel-screenshot/1.0	146.190.142.122	\N	2026-01-24 14:03:43.432593+00
1217	/admin/add-venue	admin	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.88	\N	2026-01-24 14:03:48.500123+00
1218	/admin/add-venue	admin	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.88	\N	2026-01-24 14:17:09.935562+00
1219	/admin/add-venue	admin	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.88	\N	2026-01-24 14:21:20.131333+00
1220	/	home	https://findyusports-1sc8xcboj-findyu.vercel.app/	vercel-screenshot/1.0	164.92.66.89	\N	2026-01-24 14:21:33.10431+00
1221	/	home	https://findyusports-1sc8xcboj-findyu.vercel.app/	vercel-screenshot/1.0	134.199.222.58	\N	2026-01-24 14:21:33.636834+00
1222	/admin/add-venue	admin	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.88	\N	2026-01-24 14:21:45.603275+00
1223	/admin/venues	admin	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.88	\N	2026-01-24 14:24:32.230019+00
1224	/venues/84	venue	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.88	\N	2026-01-24 14:25:01.066623+00
1225	/admin/add-venue	admin	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.88	\N	2026-01-24 14:27:44.84123+00
1226	/admin/add-venue	admin	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.91	\N	2026-01-24 14:37:09.812505+00
1227	/venues/84	venue	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.91	\N	2026-01-24 14:37:12.161121+00
1228	/admin/venues	admin	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.91	\N	2026-01-24 14:37:12.856639+00
1229	/admin/venues	admin	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.91	\N	2026-01-24 14:37:18.333349+00
1230	/admin/add-venue	admin	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	188.253.124.91	\N	2026-01-24 14:37:53.920252+00
1231	/	home	https://findyusports.com/	Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1	124.115.170.7	\N	2026-01-25 01:06:13.593234+00
1232	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.169	\N	2026-01-25 04:24:41.443128+00
1233	/venues/8	venue	https://findyusports.com/venues/8	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.170	\N	2026-01-25 07:42:09.587117+00
1234	/admin/add-venue	admin	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.93	\N	2026-01-25 09:04:30.256203+00
1235	/	home	https://findyusports-m1mbavwni-findyu.vercel.app/	vercel-screenshot/1.0	147.182.207.47	\N	2026-01-25 09:07:19.864102+00
1236	/	home	https://findyusports-m1mbavwni-findyu.vercel.app/	vercel-screenshot/1.0	137.184.10.187	\N	2026-01-25 09:07:20.295912+00
1237	/admin/add-venue	admin	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	103.220.218.93	\N	2026-01-25 09:07:32.986998+00
1238	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.4.21 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36	::1	\N	2026-01-25 09:07:52.513867+00
1239	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.4.21 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36	::1	\N	2026-01-25 09:07:52.536708+00
1240	/map	map	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 09:42:03.871316+00
1241	/admin/add-venue	admin	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 09:42:20.753572+00
1242	/admin/venues	admin	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 09:52:52.400889+00
1243	/venues/107	venue	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 09:53:03.85063+00
1244	/admin/venues	admin	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 09:53:32.444326+00
1245	/admin/add-venue	admin	https://findyusports.com/venues/45	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 09:54:50.990018+00
1246	/	home	https://findyusports-oq8802zaw-findyu.vercel.app/	vercel-screenshot/1.0	147.182.246.167	\N	2026-01-25 09:55:20.78451+00
1247	/	home	https://findyusports-oq8802zaw-findyu.vercel.app/	vercel-screenshot/1.0	146.190.142.122	\N	2026-01-25 09:55:21.230866+00
1248	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 09:56:56.003537+00
1249	/venues/41	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 09:56:58.218738+00
1250	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 09:57:06.238596+00
1251	/venues/42	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 09:57:08.493425+00
1252	/venues/42	venue	https://findyusports.com/venues/42	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 09:57:25.576395+00
1253	/venues/42	venue	https://findyusports.com/venues/42	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 09:58:39.407643+00
1254	/admin/add-venue	admin	https://findyusports.com/venues/42	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 09:58:42.49964+00
1255	/	home	https://findyusports-9o9q4aygp-findyu.vercel.app/	vercel-screenshot/1.0	147.182.207.47	\N	2026-01-25 10:02:29.111491+00
1256	/	home	https://findyusports-9o9q4aygp-findyu.vercel.app/	vercel-screenshot/1.0	147.182.251.221	\N	2026-01-25 10:02:29.612483+00
1257	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 10:28:04.81362+00
1258	/map	map	https://findyusports.com/map?keyword=%E6%BB%A8%E6%B1%9F	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 10:28:14.080521+00
1259	/venues/120	venue	https://findyusports.com/map?keyword=%E6%BB%A8%E6%B1%9F	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 10:28:19.129078+00
1260	/venues/120	venue	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 10:29:03.753954+00
1261	/venues/120	venue	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 10:31:51.753608+00
1262	/	home	https://findyusports-cvps6foot-findyu.vercel.app/	vercel-screenshot/1.0	24.144.88.187	\N	2026-01-25 10:33:10.937023+00
1263	/	home	https://findyusports-cvps6foot-findyu.vercel.app/	vercel-screenshot/1.0	143.198.224.251	\N	2026-01-25 10:33:11.03284+00
1264	/venues/120	venue	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 10:33:38.390133+00
1265	/venues/120	venue	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	218.252.114.192	\N	2026-01-25 10:33:48.417098+00
1266	/	home	https://findyusports-1rcjgr9la-findyu.vercel.app/	vercel-screenshot/1.0	161.35.234.75	\N	2026-01-25 10:35:42.729141+00
1267	/	home	https://findyusports-1rcjgr9la-findyu.vercel.app/	vercel-screenshot/1.0	143.198.224.251	\N	2026-01-25 10:35:43.211724+00
1268	/venues/120	venue	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	175.143.93.106	\N	2026-01-25 10:36:44.693605+00
1270	/admin/edit-venue/120	admin	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	175.143.93.106	\N	2026-01-25 10:38:24.402541+00
1271	/	home	https://findyusports-7ni1rfptm-findyu.vercel.app/	vercel-screenshot/1.0	164.92.66.89	\N	2026-01-25 10:38:44.415511+00
1272	/	home	https://findyusports-7ni1rfptm-findyu.vercel.app/	vercel-screenshot/1.0	161.35.235.39	\N	2026-01-25 10:38:44.868026+00
1273	/admin/edit-venue/120	admin	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	175.143.93.106	\N	2026-01-25 10:39:42.600943+00
1274	/	home	https://findyusports-nsqhp8ci4-findyu.vercel.app/	vercel-screenshot/1.0	147.182.246.167	\N	2026-01-25 10:42:40.060124+00
1275	/	home	https://findyusports-nsqhp8ci4-findyu.vercel.app/	vercel-screenshot/1.0	143.198.224.251	\N	2026-01-25 10:42:40.162234+00
1276	/venues/120	venue	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	175.143.93.106	\N	2026-01-25 10:43:00.257663+00
1277	/admin/edit-venue/120	admin	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	175.143.93.106	\N	2026-01-25 10:43:13.336132+00
1278	/admin/add-venue	admin	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	175.143.93.106	\N	2026-01-25 10:43:31.944473+00
1279	/admin/edit-venue/120	admin	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	175.143.93.106	\N	2026-01-25 10:47:39.802393+00
1280	/admin/venues	admin	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	175.143.93.106	\N	2026-01-25 10:47:42.34086+00
1281	/admin/venues	admin	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.2.5.697	175.143.93.106	\N	2026-01-25 10:47:44.765442+00
1282	/admin/venues	admin	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.85	\N	2026-01-25 10:48:11.841928+00
1283	/venues/50	venue	https://findyusports.com/venues/50	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.169	\N	2026-01-25 13:30:08.54693+00
1284	/venues/60	venue	https://findyusports.com/venues/60	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.170	\N	2026-01-25 13:35:04.942943+00
1285	/venues/83	venue	https://findyusports.com/venues/83	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.169	\N	2026-01-25 13:35:33.552414+00
1286	/venues/45	venue	https://findyusports.com/venues/45	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.169	\N	2026-01-25 13:35:38.787421+00
1287	/venues/56	venue	https://findyusports.com/venues/56	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.169	\N	2026-01-25 13:35:46.283733+00
1288	/venues/66	venue	https://findyusports.com/venues/66	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.169	\N	2026-01-25 13:37:34.269561+00
1289	/venues/48	venue	https://findyusports.com/venues/48	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.169	\N	2026-01-25 13:38:09.359249+00
1290	/venues/52	venue	https://findyusports.com/venues/52	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.75.185	\N	2026-01-26 04:18:05.939492+00
1291	/venues/34	venue	https://findyusports.com/venues/34	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.75.61	\N	2026-01-26 04:28:31.352654+00
1292	/venues/14	venue	https://findyusports.com/venues/14	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.22.237.242	\N	2026-01-26 04:48:16.046694+00
1293	/venues/21	venue	https://findyusports.com/venues/21	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.246.15.164	\N	2026-01-26 04:48:42.56249+00
1294	/venues/55	venue	https://findyusports.com/venues/55	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.219.9	\N	2026-01-26 05:01:55.729811+00
1295	/venues/39	venue	https://findyusports.com/venues/39	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.246.23.85	\N	2026-01-26 05:02:56.845828+00
1296	/venues/68	venue	https://findyusports.com/venues/68	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.22.245.239	\N	2026-01-26 05:14:46.677044+00
1297	/venues/58	venue	https://findyusports.com/venues/58	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.219.199	\N	2026-01-26 05:34:28.37866+00
1298	/venues/11	venue	https://findyusports.com/venues/11	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.22.253.41	\N	2026-01-26 06:26:46.357552+00
1299	/venues/2	venue	https://findyusports.com/venues/2	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-26 06:36:08.658484+00
1300	/venues/42	venue	https://findyusports.com/venues/42	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.227.132	\N	2026-01-26 07:05:17.261549+00
1301	/venues/32	venue	https://findyusports.com/venues/32	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.227.82	\N	2026-01-26 07:25:42.409665+00
1302	/venues/43	venue	https://findyusports.com/venues/43	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.22.237.161	\N	2026-01-26 07:26:05.981639+00
1303	/venues/60	venue	https://findyusports.com/venues/60	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.75.152	\N	2026-01-26 07:41:47.312403+00
1304	/venues/65	venue	https://findyusports.com/venues/65	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.227.14	\N	2026-01-26 07:57:01.362971+00
1305	/venues/49	venue	https://findyusports.com/venues/49	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.22.253.190	\N	2026-01-26 08:34:43.808939+00
1306	/venues/40	venue	https://findyusports.com/venues/40	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.246.23.245	\N	2026-01-26 09:02:12.070092+00
1307	/venues/18	venue	https://findyusports.com/venues/18	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.246.19.192	\N	2026-01-26 09:11:42.090269+00
1308	/venues/74	venue	https://findyusports.com/venues/74	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.22.237.77	\N	2026-01-26 09:46:14.538301+00
1309	/venues/48	venue	https://findyusports.com/venues/48	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.22.237.66	\N	2026-01-26 10:05:47.274272+00
1310	/venues/66	venue	https://findyusports.com/venues/66	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.22.237.118	\N	2026-01-26 10:07:49.540196+00
1311	/venues/22	venue	https://findyusports.com/venues/22	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.219.63	\N	2026-01-26 10:31:01.459384+00
1312	/admin/data	admin	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:36:35.029752+00
1313	/admin/analytics	admin	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:36:38.208018+00
1314	/admin/venues	admin	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:36:42.359362+00
1315	/admin/add-venue	admin	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:36:45.432932+00
1316	/admin/venues	admin	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:36:46.896595+00
1317	/venues/121	venue	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:36:49.774055+00
1318	/admin/edit-venue/121	admin	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:37:02.332144+00
1319	/admin/add-venue	admin	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:37:35.999177+00
1320	/admin/venues	admin	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:38:06.508524+00
1321	/admin/add-venue	admin	https://findyusports.com/venues/120	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:38:34.635984+00
1322	/	home	https://findyusports-ba7tvj09u-findyu.vercel.app/	vercel-screenshot/1.0	24.199.120.171	\N	2026-01-26 10:39:32.674428+00
1323	/	home	https://findyusports-ba7tvj09u-findyu.vercel.app/	vercel-screenshot/1.0	161.35.235.39	\N	2026-01-26 10:39:33.106757+00
1324	/venues/64	venue	https://findyusports.com/venues/64	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.75.179	\N	2026-01-26 10:39:50.184367+00
1325	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:40:36.654931+00
1326	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:40:50.122178+00
1327	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:40:52.546928+00
1328	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:40:54.515883+00
1329	/admin/venues	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:40:56.261619+00
1330	/venues/123	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:41:01.996878+00
1331	/venues/123	venue	https://findyusports.com/venues/123	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:41:08.933516+00
1334	/venues/121	venue	https://findyusports.com/venues/121	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:41:35.141013+00
1335	/admin/venues	admin	https://findyusports.com/venues/121	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:41:36.477451+00
1336	/venues/121	venue	https://findyusports.com/venues/121	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:41:39.35453+00
1337	/admin/edit-venue/121	admin	https://findyusports.com/venues/121	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:41:47.274913+00
1338	/admin/edit-venue/121	admin	https://findyusports.com/venues/121	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:43:26.610206+00
1339	/	home	https://findyusports-hrda6tqh2-findyu.vercel.app/	vercel-screenshot/1.0	147.182.231.37	\N	2026-01-26 10:43:32.256097+00
1340	/	home	https://findyusports-hrda6tqh2-findyu.vercel.app/	vercel-screenshot/1.0	64.23.153.247	\N	2026-01-26 10:43:32.696216+00
1923	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	175.143.93.106	\N	2026-02-03 03:17:02.212818+00
1924	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	175.143.93.106	\N	2026-02-03 03:19:11.743883+00
1925	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 03:52:36.804873+00
1981	/venues/247	venue	https://findyusports.com/venues/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	160.22.157.85	\N	2026-02-03 05:19:11.417016+00
2020	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 12:14:43.676407+00
1332	/admin/venues	admin	https://findyusports.com/venues/123	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:41:17.969886+00
1333	/venues/121	venue	https://findyusports.com/venues/123	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:41:21.201717+00
1341	/	home	https://findyusports-dthlbjtqa-findyu.vercel.app/	vercel-screenshot/1.0	146.190.46.85	\N	2026-01-26 10:45:20.820777+00
1342	/	home	https://findyusports-dthlbjtqa-findyu.vercel.app/	vercel-screenshot/1.0	147.182.206.142	\N	2026-01-26 10:45:21.274319+00
1343	/admin/edit-venue/121	admin	https://findyusports.com/venues/121	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-26 10:46:04.135135+00
1344	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-26 10:46:58.637753+00
1345	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-26 10:46:58.643954+00
1346	/admin/venues	admin	http://localhost:3000/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-26 10:46:59.927215+00
1347	/admin/edit-venue/121	admin	http://localhost:3000/admin/edit-venue/121	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-26 10:47:04.992541+00
1348	/	home	https://findyusports-4r2a0kfvb-findyu.vercel.app/	vercel-screenshot/1.0	24.199.120.171	\N	2026-01-26 10:49:36.885187+00
1349	/	home	https://findyusports-4r2a0kfvb-findyu.vercel.app/	vercel-screenshot/1.0	161.35.234.75	\N	2026-01-26 10:49:37.290115+00
1350	/venues/36	venue	https://findyusports.com/venues/36	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.246.23.101	\N	2026-01-26 10:50:01.137495+00
1351	/	home	https://findyusports-i3amnd9w5-findyu.vercel.app/	vercel-screenshot/1.0	164.90.157.72	\N	2026-01-26 10:51:27.830868+00
1352	/	home	https://findyusports-i3amnd9w5-findyu.vercel.app/	vercel-screenshot/1.0	161.35.234.75	\N	2026-01-26 10:51:28.373754+00
1353	/admin/edit-venue/121	admin	http://localhost:3000/admin/edit-venue/121	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-26 10:53:53.705482+00
1354	/admin/edit-venue/121	admin	http://localhost:3000/admin/edit-venue/121	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-26 10:53:53.884335+00
1355	/	home	https://findyusports-mv5n6iv7e-findyu.vercel.app/	vercel-screenshot/1.0	164.90.150.149	\N	2026-01-26 10:56:15.058469+00
1356	/	home	https://findyusports-mv5n6iv7e-findyu.vercel.app/	vercel-screenshot/1.0	147.182.251.221	\N	2026-01-26 10:56:15.55466+00
1357	/admin/edit-venue/121	admin	http://localhost:3000/admin/edit-venue/121	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-26 10:56:52.275988+00
1358	/admin/edit-venue/121	admin	http://localhost:3000/admin/edit-venue/121	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-26 10:56:52.278602+00
1359	/	home	https://findyusports-gq96b44bt-findyu.vercel.app/	vercel-screenshot/1.0	164.92.66.89	\N	2026-01-26 10:58:16.850164+00
1360	/	home	https://findyusports-gq96b44bt-findyu.vercel.app/	vercel-screenshot/1.0	143.198.224.251	\N	2026-01-26 10:58:17.32916+00
1361	/	home	https://findyusports-c8y77g3u4-findyu.vercel.app/	vercel-screenshot/1.0	134.199.222.58	\N	2026-01-26 11:04:01.925415+00
1362	/	home	https://findyusports-c8y77g3u4-findyu.vercel.app/	vercel-screenshot/1.0	147.182.242.144	\N	2026-01-26 11:04:02.889341+00
1363	/	home	https://findyusports-syrm391dp-findyu.vercel.app/	vercel-screenshot/1.0	146.190.148.232	\N	2026-01-26 11:07:24.5948+00
1364	/	home	https://findyusports-syrm391dp-findyu.vercel.app/	vercel-screenshot/1.0	146.190.150.138	\N	2026-01-26 11:07:25.036936+00
1365	/admin/venues	admin	http://localhost:3000/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-26 11:15:51.957042+00
1366	/venues/51	venue	https://findyusports.com/venues/51	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.75.84	\N	2026-01-26 11:16:05.776348+00
1367	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-26 11:16:14.639449+00
1368	/	home	https://findyusports-30snxhpqx-findyu.vercel.app/	vercel-screenshot/1.0	147.182.251.221	\N	2026-01-26 11:18:12.214075+00
1369	/	home	https://findyusports-30snxhpqx-findyu.vercel.app/	vercel-screenshot/1.0	137.184.10.187	\N	2026-01-26 11:18:12.782894+00
1370	/	home	https://findyusports-h6nfacksi-findyu.vercel.app/	vercel-screenshot/1.0	147.182.206.142	\N	2026-01-26 11:22:54.575328+00
1371	/	home	https://findyusports-h6nfacksi-findyu.vercel.app/	vercel-screenshot/1.0	159.223.194.127	\N	2026-01-26 11:22:55.104713+00
1372	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-26 11:24:15.706009+00
1373	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-26 11:24:15.977179+00
1374	/	home	https://findyusports-gpwxruhuk-findyu.vercel.app/	vercel-screenshot/1.0	164.92.85.31	\N	2026-01-26 11:25:44.937575+00
1375	/	home	https://findyusports-gpwxruhuk-findyu.vercel.app/	vercel-screenshot/1.0	146.190.142.122	\N	2026-01-26 11:25:45.389134+00
1376	/admin/add-venue	admin	https://findyusports.com/admin/edit-venue/121	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	175.143.93.106	\N	2026-01-26 11:27:18.933527+00
1377	/	home	https://findyusports-1aqv9yjyj-findyu.vercel.app/	vercel-screenshot/1.0	134.199.222.58	\N	2026-01-26 11:28:06.164009+00
1378	/	home	https://findyusports-1aqv9yjyj-findyu.vercel.app/	vercel-screenshot/1.0	137.184.234.25	\N	2026-01-26 11:28:06.675293+00
1379	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	175.143.93.106	\N	2026-01-26 11:32:33.29095+00
1380	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	175.143.93.106	\N	2026-01-26 11:33:09.525198+00
1381	/map	map	https://findyusports.com/map?keyword=%E9%87%87	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	175.143.93.106	\N	2026-01-26 11:33:36.069458+00
1382	/admin/add-venue	admin	https://findyusports.com/map?keyword=%E9%87%87	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	175.143.93.106	\N	2026-01-26 11:33:40.678638+00
1383	/venues/53	venue	https://findyusports.com/venues/53	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.246.15.95	\N	2026-01-26 12:55:02.928954+00
1384	/venues/62	venue	https://findyusports.com/venues/62	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.227.22	\N	2026-01-26 14:06:59.063059+00
1385	/map	map	https://findyusports.com/map?sport=basketball	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36 Edg/111.0.1661.44	116.98.245.196	\N	2026-01-26 14:07:44.729499+00
1386	/venues/37	venue	https://findyusports.com/venues/37	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.75.171	\N	2026-01-26 14:37:58.382916+00
1387	/venues/63	venue	https://findyusports.com/venues/63	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.246.23.128	\N	2026-01-26 14:38:00.22713+00
1388	/venues/35	venue	https://findyusports.com/venues/35	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.22.253.67	\N	2026-01-26 15:00:09.288055+00
1389	/venues/71	venue	https://findyusports.com/venues/71	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.22.237.185	\N	2026-01-26 15:27:33.929308+00
1390	/venues/8	venue	https://findyusports.com/venues/8	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.219.234	\N	2026-01-26 16:11:16.898789+00
1391	/venues/41	venue	https://findyusports.com/venues/41	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.227.248	\N	2026-01-26 16:15:17.296854+00
1392	/venues/30	venue	https://findyusports.com/venues/30	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.75.68	\N	2026-01-26 16:18:53.774875+00
1393	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/134.0.6998.35 Safari/537.36	113.215.188.81	\N	2026-01-27 05:19:43.837248+00
1394	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-27 09:39:24.924171+00
1395	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-27 09:39:34.797978+00
1396	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-27 09:41:30.897755+00
1397	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-27 09:41:42.531718+00
1398	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-27 11:29:12.094248+00
1399	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_4; en-US) AppleWebKit/534.3 (KHTML, like Gecko) Chrome/6.0.464.0 Safari/534.3	54.175.47.210	\N	2026-01-27 11:57:06.525229+00
1400	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-28 10:35:56.799444+00
1401	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-28 11:09:13.794631+00
1402	/venues/162	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-28 11:09:20.44478+00
1403	/venues/162	venue	https://findyusports.com/venues/162	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-28 11:09:33.772452+00
1404	/admin/add-venue	admin	https://findyusports.com/venues/162	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-28 11:09:46.870525+00
1405	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-28 11:23:07.693858+00
1406	/venues/168	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-28 11:23:14.256651+00
1407	/admin/edit-venue/168	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-28 11:23:23.338703+00
1408	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-28 11:23:55.375862+00
1409	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Fedora; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36	34.135.97.109	\N	2026-01-28 16:21:32.299541+00
1410	/venues/5	venue	https://findyusports.com/venues/5	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-28 22:50:32.361659+00
1411	/venues/59	venue	https://findyusports.com/venues/59	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.22.237.58	\N	2026-01-28 23:22:45.72815+00
1412	/venues/73	venue	https://findyusports.com/venues/73	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.246.19.63	\N	2026-01-28 23:54:22.920631+00
1413	/venues/70	venue	https://findyusports.com/venues/70	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.227.178	\N	2026-01-29 01:43:43.836787+00
1414	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 01:45:38.283969+00
1415	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36	159.223.242.210	\N	2026-01-29 02:50:54.16411+00
1416	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36	65.109.14.150	\N	2026-01-29 03:00:11.695763+00
1417	/venues/54	venue	https://findyusports.com/venues/54	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.22.253.62	\N	2026-01-29 03:25:03.5918+00
1418	/venues/72	venue	https://findyusports.com/venues/72	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.219.91	\N	2026-01-29 03:43:36.199331+00
1419	/venues/24	venue	https://findyusports.com/venues/24	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.246.23.191	\N	2026-01-29 06:25:47.134206+00
1420	/venues/33	venue	https://findyusports.com/venues/33	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.246.15.242	\N	2026-01-29 08:09:11.187113+00
1421	/venues/78	venue	https://findyusports.com/venues/78	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.75.139	\N	2026-01-29 08:23:11.61022+00
1422	/venues/61	venue	https://findyusports.com/venues/61	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.22.237.135	\N	2026-01-29 08:44:57.030731+00
1423	/venues/27	venue	https://findyusports.com/venues/27	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.246.15.86	\N	2026-01-29 08:49:06.133849+00
1424	/venues/76	venue	https://findyusports.com/venues/76	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.22.245.224	\N	2026-01-29 09:02:43.207366+00
1425	/venues/88	venue	https://findyusports.com/venues/88	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 09:13:52.905876+00
1426	/venues/129	venue	https://findyusports.com/venues/129	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.71	\N	2026-01-29 09:14:49.761523+00
1427	/venues/163	venue	https://findyusports.com/venues/163	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 09:16:10.635853+00
1428	/venues/93	venue	https://findyusports.com/venues/93	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 09:16:56.848023+00
1429	/venues/29	venue	https://findyusports.com/venues/29	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 09:17:31.944807+00
1430	/venues/100	venue	https://findyusports.com/venues/100	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 09:17:33.131357+00
1431	/venues/98	venue	https://findyusports.com/venues/98	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 09:17:46.655122+00
1432	/venues/111	venue	https://findyusports.com/venues/111	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 09:18:01.47018+00
1433	/venues/87	venue	https://findyusports.com/venues/87	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 09:18:15.177424+00
1434	/venues/165	venue	https://findyusports.com/venues/165	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.71	\N	2026-01-29 09:19:18.333439+00
1435	/venues/57	venue	https://findyusports.com/venues/57	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.71	\N	2026-01-29 09:20:03.57587+00
1436	/venues/92	venue	https://findyusports.com/venues/92	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; GoogleOther)	66.249.69.69	\N	2026-01-29 09:21:31.348891+00
1437	/venues/39	venue	https://findyusports.com/venues/39	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 09:21:57.922922+00
1438	/venues/164	venue	https://findyusports.com/venues/164	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.71	\N	2026-01-29 09:23:32.653589+00
1582	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	218.252.114.192	\N	2026-01-30 12:50:47.617584+00
1439	/venues/164	venue	https://findyusports.com/venues/164	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 09:24:16.267277+00
1440	/venues/92	venue	https://findyusports.com/venues/92	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 09:26:28.475247+00
1441	/venues/112	venue	https://findyusports.com/venues/112	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 09:29:05.133123+00
1442	/venues/133	venue	https://findyusports.com/venues/133	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; GoogleOther)	66.249.69.70	\N	2026-01-29 09:35:23.058774+00
1443	/venues/133	venue	https://findyusports.com/venues/133	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 09:35:33.042021+00
1444	/venues/65	venue	https://findyusports.com/venues/65	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 09:37:31.842223+00
1445	/venues/61	venue	https://findyusports.com/venues/61	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 09:41:12.582275+00
1446	/venues/25	venue	https://findyusports.com/venues/25	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.246.23.223	\N	2026-01-29 09:50:11.434496+00
1447	/venues/43	venue	https://findyusports.com/venues/43	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.71	\N	2026-01-29 09:51:02.927048+00
1448	/venues/156	venue	https://findyusports.com/venues/156	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 09:52:04.458625+00
1449	/venues/97	venue	https://findyusports.com/venues/97	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 09:52:08.784275+00
1450	/venues/78	venue	https://findyusports.com/venues/78	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 09:52:16.566476+00
1451	/venues/135	venue	https://findyusports.com/venues/135	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 09:52:20.885249+00
1452	/venues/89	venue	https://findyusports.com/venues/89	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 09:52:39.418794+00
1453	/venues/69	venue	https://findyusports.com/venues/69	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.219.250	\N	2026-01-29 09:58:36.393702+00
1454	/venues/57	venue	https://findyusports.com/venues/57	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 10:07:28.345635+00
1455	/venues/58	venue	https://findyusports.com/venues/58	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:15:09.844614+00
1456	/venues/37	venue	https://findyusports.com/venues/37	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.71	\N	2026-01-29 10:16:13.068365+00
1457	/venues/27	venue	https://findyusports.com/venues/27	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:16:36.865827+00
1458	/venues/81	venue	https://findyusports.com/venues/81	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:16:43.870017+00
1459	/venues/149	venue	https://findyusports.com/venues/149	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 10:18:01.539952+00
1460	/venues/150	venue	https://findyusports.com/venues/150	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:18:05.548015+00
1461	/venues/40	venue	https://findyusports.com/venues/40	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:18:17.729201+00
1462	/venues/32	venue	https://findyusports.com/venues/32	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:18:20.988045+00
1463	/venues/137	venue	https://findyusports.com/venues/137	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:18:27.553146+00
1464	/venues/77	venue	https://findyusports.com/venues/77	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:18:35.80079+00
1465	/venues/113	venue	https://findyusports.com/venues/113	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:18:43.11706+00
1466	/venues/70	venue	https://findyusports.com/venues/70	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:18:44.251716+00
1467	/venues/46	venue	https://findyusports.com/venues/46	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:18:47.526031+00
1468	/venues/73	venue	https://findyusports.com/venues/73	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:18:53.605614+00
1926	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 03:52:36.89828+00
1982	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.4.23 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36	::1	\N	2026-02-03 05:20:22.084667+00
1983	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	160.22.157.85	\N	2026-02-03 05:20:23.199825+00
1984	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.4.23 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36	::1	\N	2026-02-03 05:20:24.090667+00
2021	/venues/247	venue	https://findyusports.com/venues/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	188.253.124.85	\N	2026-02-03 12:14:51.275754+00
1469	/venues/36	venue	https://findyusports.com/venues/36	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:19:06.402808+00
1470	/venues/158	venue	https://findyusports.com/venues/158	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:19:13.239671+00
1927	/admin/venues	admin	https://findyusports.com/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	103.220.218.90	\N	2026-02-03 04:03:31.720396+00
1928	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:04:01.245255+00
1929	/map	map	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:04:04.336346+00
1930	/map	map	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:04:04.570694+00
1931	/venues/244	venue	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:04:09.715097+00
1932	/venues/244	venue	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:04:31.996091+00
1933	/venues/244	venue	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:04:32.315316+00
1934	/admin/edit-venue/244	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:04:33.470698+00
1935	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	103.220.218.90	\N	2026-02-03 04:06:43.578214+00
1936	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:07:29.252064+00
1937	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:07:31.536366+00
1938	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:07:36.220908+00
1939	/admin/venues	admin	http://localhost:3000/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:07:59.587157+00
1940	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:08:02.71243+00
1985	/venues/244	venue	https://findyusports.com/venues/244	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	160.22.157.85	\N	2026-02-03 05:20:29.560549+00
2022	/venues/247	venue	https://findyusports.com/venues/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	188.253.124.85	\N	2026-02-03 12:16:00.813749+00
2023	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 12:16:02.762376+00
2024	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 12:16:05.816189+00
1471	/venues/162	venue	https://findyusports.com/venues/162	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:19:18.103574+00
1472	/venues/38	venue	https://findyusports.com/venues/38	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:19:42.287625+00
1473	/venues/125	venue	https://findyusports.com/venues/125	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:19:44.026568+00
1474	/venues/69	venue	https://findyusports.com/venues/69	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:19:55.012213+00
1475	/venues/120	venue	https://findyusports.com/venues/120	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 10:20:06.240132+00
1476	/venues/170	venue	https://findyusports.com/venues/170	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:20:14.561566+00
1477	/venues/105	venue	https://findyusports.com/venues/105	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:20:22.249185+00
1478	/venues/30	venue	https://findyusports.com/venues/30	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:20:40.072771+00
1479	/venues/132	venue	https://findyusports.com/venues/132	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:20:40.488851+00
1480	/venues/80	venue	https://findyusports.com/venues/80	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:20:48.067629+00
1481	/venues/71	venue	https://findyusports.com/venues/71	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:20:58.849373+00
1482	/venues/114	venue	https://findyusports.com/venues/114	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 10:21:19.091902+00
1483	/venues/59	venue	https://findyusports.com/venues/59	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:21:25.699412+00
1484	/venues/161	venue	https://findyusports.com/venues/161	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:21:44.434666+00
1485	/venues/146	venue	https://findyusports.com/venues/146	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:21:50.045301+00
1486	/venues/67	venue	https://findyusports.com/venues/67	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:21:55.866498+00
1487	/venues/63	venue	https://findyusports.com/venues/63	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 10:22:02.364341+00
1488	/venues/121	venue	https://findyusports.com/venues/121	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:22:03.683459+00
1489	/venues/117	venue	https://findyusports.com/venues/117	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:22:14.135182+00
1490	/venues/102	venue	https://findyusports.com/venues/102	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:22:15.489339+00
1491	/venues/31	venue	https://findyusports.com/venues/31	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:22:19.499261+00
1492	/venues/127	venue	https://findyusports.com/venues/127	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:22:39.904569+00
1493	/venues/79	venue	https://findyusports.com/venues/79	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:22:52.566485+00
1494	/venues/49	venue	https://findyusports.com/venues/49	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:22:55.688284+00
1495	/venues/95	venue	https://findyusports.com/venues/95	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 10:23:13.91409+00
1583	/	home	https://findyusports-4i8lvt7fp-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	18.144.47.83	\N	2026-01-30 12:50:49.47865+00
1496	/venues/143	venue	https://findyusports.com/venues/143	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:23:18.32776+00
1497	/venues/139	venue	https://findyusports.com/venues/139	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:23:22.004616+00
1941	/map	map	http://localhost:3000/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:16:41.46061+00
1942	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:17:03.620572+00
1943	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	103.220.218.90	\N	2026-02-03 04:17:06.662578+00
1944	/map	map	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:17:08.409342+00
1986	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	160.22.157.85	\N	2026-02-03 05:23:41.17759+00
1987	/venues/244	venue	https://findyusports.com/venues/244	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	160.22.157.85	\N	2026-02-03 05:23:42.075505+00
1989	/venues/247	venue	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 05:24:32.831411+00
2025	/admin/analytics	admin	http://localhost:3000/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 12:16:42.841674+00
1498	/venues/128	venue	https://findyusports.com/venues/128	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:23:42.80089+00
1499	/venues/144	venue	https://findyusports.com/venues/144	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:23:45.265361+00
1500	/venues/119	venue	https://findyusports.com/venues/119	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; GoogleOther)	66.249.69.69	\N	2026-01-29 10:23:47.05104+00
1945	/map	map	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:17:12.494424+00
1946	/venues/245	venue	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:17:15.083775+00
1947	/map	map	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:17:22.069485+00
1988	/venues/247	venue	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 05:24:32.821029+00
1990	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	160.22.157.85	\N	2026-02-03 05:25:15.646535+00
1991	/venues/247	venue	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 05:25:18.642245+00
1992	/venues/247	venue	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 05:25:21.262245+00
2026	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 12:17:21.960223+00
2027	/user	\N	http://localhost:3000/user	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 12:17:26.978537+00
2028	/user	\N	http://localhost:3000/user	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 12:17:53.257048+00
2029	/user	\N	http://localhost:3000/user	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 12:17:54.265582+00
2030	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 12:17:55.548863+00
1501	/venues/154	venue	https://findyusports.com/venues/154	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:23:53.402792+00
1502	/venues/131	venue	https://findyusports.com/venues/131	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:23:54.749326+00
1503	/venues/106	venue	https://findyusports.com/venues/106	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:23:55.233607+00
1504	/venues/119	venue	https://findyusports.com/venues/119	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:23:56.014942+00
1505	/venues/159	venue	https://findyusports.com/venues/159	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 10:24:22.724841+00
1506	/venues/145	venue	https://findyusports.com/venues/145	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:24:28.319639+00
1507	/venues/155	venue	https://findyusports.com/venues/155	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:24:38.932519+00
1508	/venues/52	venue	https://findyusports.com/venues/52	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:24:53.934753+00
1509	/venues/75	venue	https://findyusports.com/venues/75	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.246.19.15	\N	2026-01-29 10:24:57.180349+00
1510	/venues/152	venue	https://findyusports.com/venues/152	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:25:04.107032+00
1511	/venues/90	venue	https://findyusports.com/venues/90	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:25:06.263958+00
1512	/venues/151	venue	https://findyusports.com/venues/151	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:25:23.308562+00
1513	/venues/64	venue	https://findyusports.com/venues/64	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:25:27.385935+00
1514	/venues/118	venue	https://findyusports.com/venues/118	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:25:38.615674+00
1515	/venues/35	venue	https://findyusports.com/venues/35	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:26:31.270318+00
1516	/venues/107	venue	https://findyusports.com/venues/107	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 10:26:46.79602+00
1517	/venues/86	venue	https://findyusports.com/venues/86	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:27:02.00601+00
1518	/venues/91	venue	https://findyusports.com/venues/91	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:27:02.328015+00
1519	/venues/126	venue	https://findyusports.com/venues/126	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:27:06.92038+00
1520	/venues/126	venue	https://findyusports.com/venues/126	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:27:14.702973+00
1521	/venues/136	venue	https://findyusports.com/venues/136	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:27:26.572531+00
1522	/venues/141	venue	https://findyusports.com/venues/141	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:27:29.031792+00
1523	/venues/96	venue	https://findyusports.com/venues/96	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:27:44.142756+00
1524	/venues/157	venue	https://findyusports.com/venues/157	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:27:50.204159+00
1525	/venues/140	venue	https://findyusports.com/venues/140	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:29:10.664903+00
1584	/	home	https://findyusports-4i8lvt7fp-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.153.19.103	\N	2026-01-30 12:50:49.946044+00
1526	/venues/138	venue	https://findyusports.com/venues/138	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:29:16.551724+00
1527	/venues/76	venue	https://findyusports.com/venues/76	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:29:47.923756+00
1528	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.91	\N	2026-01-29 10:30:15.461782+00
1529	/venues/108	venue	https://findyusports.com/venues/108	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 10:30:15.878363+00
1530	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.91	\N	2026-01-29 10:30:25.114658+00
1531	/venues/130	venue	https://findyusports.com/venues/130	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:30:47.710805+00
1532	/venues/168	venue	https://findyusports.com/venues/168	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.71	\N	2026-01-29 10:31:24.878852+00
1533	/venues/142	venue	https://findyusports.com/venues/142	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 10:32:00.685233+00
1534	/venues/99	venue	https://findyusports.com/venues/99	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:32:27.624608+00
1535	/venues/84	venue	https://findyusports.com/venues/84	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 10:34:22.16915+00
1536	/venues/109	venue	https://findyusports.com/venues/109	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:34:57.859297+00
1537	/venues/134	venue	https://findyusports.com/venues/134	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 10:35:07.986559+00
1538	/venues/103	venue	https://findyusports.com/venues/103	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:37:12.405031+00
1539	/venues/124	venue	https://findyusports.com/venues/124	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 10:37:12.660596+00
1540	/venues/122	venue	https://findyusports.com/venues/122	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 10:40:32.214301+00
1541	/venues/169	venue	https://findyusports.com/venues/169	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 10:43:56.524933+00
1542	/venues/153	venue	https://findyusports.com/venues/153	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:44:18.04942+00
1543	/venues/101	venue	https://findyusports.com/venues/101	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:44:59.990603+00
1544	/venues/123	venue	https://findyusports.com/venues/123	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:45:20.688303+00
1545	/venues/101	venue	https://findyusports.com/venues/101	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 10:45:21.740319+00
1546	/venues/77	venue	https://findyusports.com/venues/77	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.219.117	\N	2026-01-29 10:45:34.638061+00
1547	/venues/110	venue	https://findyusports.com/venues/110	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; GoogleOther)	66.249.69.69	\N	2026-01-29 11:40:40.462233+00
1548	/venues/110	venue	https://findyusports.com/venues/110	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 11:41:11.48201+00
1549	/venues/104	venue	https://findyusports.com/venues/104	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 12:00:37.180948+00
1550	/venues/160	venue	https://findyusports.com/venues/160	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; GoogleOther)	66.249.69.70	\N	2026-01-29 12:06:04.432902+00
1551	/venues/160	venue	https://findyusports.com/venues/160	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 12:06:46.389889+00
1585	/	home	https://findyusports-4i8lvt7fp-findyu.vercel.app/	vercel-screenshot/1.0	64.23.232.228	\N	2026-01-30 12:50:49.9584+00
1552	/venues/68	venue	https://findyusports.com/venues/68	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 12:17:38.796584+00
1553	/	home	https://findyusports.com/	Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36	54.236.47.146	\N	2026-01-29 12:40:06.764339+00
1554	/venues/50	venue	https://findyusports.com/venues/50	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.246.23.163	\N	2026-01-29 12:42:34.439932+00
1555	/venues/147	venue	https://findyusports.com/venues/147	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 12:46:35.474506+00
1556	/venues/147	venue	https://findyusports.com/venues/147	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 12:46:45.153498+00
1557	/venues/56	venue	https://findyusports.com/venues/56	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.22.237.26	\N	2026-01-29 12:49:03.942571+00
1558	/venues/67	venue	https://findyusports.com/venues/67	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.22.245.162	\N	2026-01-29 13:03:52.276654+00
1559	/venues/94	venue	https://findyusports.com/venues/94	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.71	\N	2026-01-29 15:01:32.064264+00
1560	/venues/20	venue	https://findyusports.com/venues/20	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.246.19.196	\N	2026-01-29 15:01:43.100905+00
1561	/venues/167	venue	https://findyusports.com/venues/167	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 15:02:16.067557+00
1562	/venues/116	venue	https://findyusports.com/venues/116	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 15:07:33.216967+00
1563	/venues/57	venue	https://findyusports.com/venues/57	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.241.75.89	\N	2026-01-29 15:30:27.806999+00
1564	/venues/68	venue	https://findyusports.com/venues/68	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 16:02:00.027831+00
1565	/venues/3	venue	https://findyusports.com/venues/3	Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Chrome/143.0.7499.192 Safari/537.36	66.249.69.71	\N	2026-01-29 16:04:03.639136+00
1566	/venues/23	venue	https://findyusports.com/venues/23	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.246.19.6	\N	2026-01-29 16:10:04.041671+00
1567	/venues/115	venue	https://findyusports.com/venues/115	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; GoogleOther)	66.249.69.69	\N	2026-01-29 16:12:12.123087+00
1568	/venues/115	venue	https://findyusports.com/venues/115	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.69	\N	2026-01-29 16:12:27.389683+00
1569	/venues/38	venue	https://findyusports.com/venues/38	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.22.237.172	\N	2026-01-29 16:37:15.565062+00
1570	/venues/17	venue	https://findyusports.com/venues/17	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.246.15.217	\N	2026-01-29 16:54:21.236592+00
1571	/venues/79	venue	https://findyusports.com/venues/79	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)	17.246.15.179	\N	2026-01-29 17:08:19.720508+00
1572	/venues/104	venue	https://findyusports.com/venues/104	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7499.192 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	66.249.69.70	\N	2026-01-29 18:38:42.820379+00
1573	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/134.0.6998.35 Safari/537.36	113.215.188.108	\N	2026-01-29 19:03:15.017708+00
1574	/	home	https://findyusports.com/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/134.0.6998.35 Safari/537.36	113.215.188.108	\N	2026-01-29 19:04:05.159787+00
1575	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-30 12:10:14.154208+00
1576	/	home	https://findyusports-gstizfhxh-findyu.vercel.app/	vercel-screenshot/1.0	161.35.238.215	\N	2026-01-30 12:11:21.320165+00
1577	/	home	https://findyusports-gstizfhxh-findyu.vercel.app/	vercel-screenshot/1.0	64.23.232.228	\N	2026-01-30 12:11:21.694692+00
1578	/	home	https://findyusports-gstizfhxh-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.193.115.94	\N	2026-01-30 12:11:21.738397+00
1579	/	home	https://findyusports-gstizfhxh-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.176.75.95	\N	2026-01-30 12:11:21.790795+00
1580	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-30 12:13:13.716415+00
1581	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 12:23:48.187752+00
1587	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	218.252.114.192	\N	2026-01-30 12:50:58.975056+00
1588	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	218.252.114.192	\N	2026-01-30 12:51:03.151629+00
1589	/admin/add-venue	admin	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	218.252.114.192	\N	2026-01-30 12:51:06.830206+00
1590	/admin/data	admin	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	218.252.114.192	\N	2026-01-30 12:51:08.589372+00
1591	/admin/analytics	admin	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	218.252.114.192	\N	2026-01-30 12:51:14.750935+00
1592	/admin/venues	admin	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	218.252.114.192	\N	2026-01-30 12:51:31.115759+00
1593	/admin/analytics	admin	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	218.252.114.192	\N	2026-01-30 12:51:59.422045+00
1594	/admin/add-venue	admin	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	218.252.114.192	\N	2026-01-30 12:52:01.015722+00
1595	/admin/add-venue	admin	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 12:56:03.124275+00
1596	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.42.37	\N	2026-01-30 13:07:46.505089+00
1597	/admin/analytics	admin	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-30 13:08:01.162426+00
1598	/map	map	https://findyusports.com/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-30 13:08:10.315408+00
1599	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.41.132	\N	2026-01-30 13:08:14.794694+00
1600	/venues/203	venue	https://findyusports.com/admin/analytics	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-30 13:08:16.48747+00
1601	/venues/203	venue	https://findyusports.com/venues/203	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-30 13:08:54.335552+00
1602	/venues/203	venue	https://findyusports.com/venues/203	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-30 13:09:19.661436+00
1603	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.41.48	\N	2026-01-30 13:09:24.519087+00
1604	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.41.240	\N	2026-01-30 13:10:56.838386+00
1605	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	123.182.50.53	\N	2026-01-30 13:11:10.041511+00
1606	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	39.144.124.17	\N	2026-01-30 13:11:14.34839+00
1607	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	117.147.17.27	\N	2026-01-30 13:12:08.703915+00
1608	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	183.131.239.184	\N	2026-01-30 13:13:13.47093+00
1609	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	117.147.17.27	\N	2026-01-30 13:13:18.660078+00
1610	/map	map	https://findyusports.com/venues/203	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-30 13:14:42.070027+00
1611	/admin/add-venue	admin	https://findyusports.com/venues/203	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-30 13:14:52.153942+00
1612	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-30 13:20:41.333587+00
1613	/venues/206	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-30 13:20:44.092403+00
1614	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-30 13:20:45.673906+00
1615	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.85	\N	2026-01-30 13:20:50.516673+00
1616	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	65.75.221.219	\N	2026-01-30 13:34:00.182628+00
1617	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	65.75.221.219	\N	2026-01-30 13:34:06.958175+00
1618	/map	map	https://findyusports.com/map?keyword=%E6%B1%BD%E4%BF%AE	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	65.75.221.219	\N	2026-01-30 13:34:18.66582+00
1619	/venues/208	venue	https://findyusports.com/map?keyword=%E6%B1%BD%E4%BF%AE	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	65.75.221.219	\N	2026-01-30 13:34:22.026091+00
1620	/admin/edit-venue/208	admin	https://findyusports.com/map?keyword=%E6%B1%BD%E4%BF%AE	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	65.75.221.219	\N	2026-01-30 13:34:57.759991+00
1621	/venues/208	venue	https://findyusports.com/map?keyword=%E6%B1%BD%E4%BF%AE	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	65.75.221.219	\N	2026-01-30 13:37:34.112842+00
1622	/venues/208	venue	https://findyusports.com/map?keyword=%E6%B1%BD%E4%BF%AE	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	65.75.221.219	\N	2026-01-30 13:37:36.564285+00
1623	/admin/add-venue	admin	https://findyusports.com/map?keyword=%E6%B1%BD%E4%BF%AE	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	65.75.221.219	\N	2026-01-30 13:38:04.023099+00
1624	/admin/add-venue	admin	https://findyusports.com/map?keyword=%E6%B1%BD%E4%BF%AE	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	103.220.218.93	\N	2026-01-30 14:01:00.476618+00
1625	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 15:05:36.101105+00
1626	/venues/72	venue	https://findyusports.com/venues/72	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 15:05:59.05627+00
1627	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 15:06:18.070449+00
1628	/	home	https://findyusports-ax3mk7lnj-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.183.133.188	\N	2026-01-30 15:35:18.450533+00
1629	/	home	https://findyusports-ax3mk7lnj-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	3.101.27.21	\N	2026-01-30 15:35:18.87556+00
1630	/	home	https://findyusports-ax3mk7lnj-findyu.vercel.app/	vercel-screenshot/1.0	64.23.153.247	\N	2026-01-30 15:35:18.905505+00
1631	/	home	https://findyusports-ax3mk7lnj-findyu.vercel.app/	vercel-screenshot/1.0	147.182.206.142	\N	2026-01-30 15:35:18.958334+00
1632	/admin/add-venue	admin	https://findyusports.com/map?keyword=%E6%B1%BD%E4%BF%AE	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.124.82	\N	2026-01-30 15:37:30.5749+00
1633	/admin/add-venue	admin	https://findyusports.com/map?keyword=%E6%B1%BD%E4%BF%AE	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.154	\N	2026-01-30 15:50:43.127557+00
1634	/admin/add-venue	admin	https://findyusports.com/map?keyword=%E6%B1%BD%E4%BF%AE	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.154	\N	2026-01-30 15:50:48.719432+00
1635	/admin/add-venue	admin	https://findyusports.com/map?keyword=%E6%B1%BD%E4%BF%AE	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.154	\N	2026-01-30 15:50:50.041264+00
1636	/venues/208	venue	https://findyusports.com/map?keyword=%E6%B1%BD%E4%BF%AE	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.154	\N	2026-01-30 15:50:55.554396+00
1637	/admin/add-venue	admin	https://findyusports.com/map?keyword=%E6%B1%BD%E4%BF%AE	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.154	\N	2026-01-30 15:50:57.515519+00
1638	/	home	https://findyusports-awd6mgrxp-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.193.41.189	\N	2026-01-30 15:55:08.60455+00
1639	/	home	https://findyusports-awd6mgrxp-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	52.53.173.60	\N	2026-01-30 15:55:08.859154+00
1640	/	home	https://findyusports-awd6mgrxp-findyu.vercel.app/	vercel-screenshot/1.0	64.23.149.73	\N	2026-01-30 15:55:09.114112+00
1641	/	home	https://findyusports-awd6mgrxp-findyu.vercel.app/	vercel-screenshot/1.0	24.199.120.171	\N	2026-01-30 15:55:09.304731+00
1642	/admin/add-venue	admin	https://findyusports.com/map?keyword=%E6%B1%BD%E4%BF%AE	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 15:55:17.297752+00
1643	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 16:15:30.916251+00
1644	/map	map	https://findyusports.com/map?keyword=%E6%B5%99%E6%B1%9F%E5%A4%A7%E5%AD%A6%E7%B4%AB%E9%87%91%E6%B8%AF%E6%A0%A1%E5%8C%BA%E8%B6%B3%E7%90%83%E5%9C%BA	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 16:17:52.354868+00
1645	/admin/add-venue	admin	https://findyusports.com/map?keyword=%E6%B5%99%E6%B1%9F%E5%A4%A7%E5%AD%A6%E7%B4%AB%E9%87%91%E6%B8%AF%E6%A0%A1%E5%8C%BA%E8%B6%B3%E7%90%83%E5%9C%BA	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 16:18:24.339642+00
1646	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 16:36:56.827854+00
1647	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 16:37:03.814713+00
1648	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 16:37:14.12872+00
2031	/	home	https://findyusports-m9683k6rc-findyu.vercel.app/	vercel-screenshot/1.0	64.23.134.165	\N	2026-02-03 12:25:57.392941+00
1649	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 16:37:16.166933+00
1650	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:37:41.367367+00
1651	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.43.82	\N	2026-01-30 16:37:41.53522+00
1652	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:37:43.865231+00
1653	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:37:45.27695+00
1654	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:37:49.101536+00
1655	/	home	https://findyusports-bcllqdflm-findyu.vercel.app/	vercel-screenshot/1.0	146.190.63.118	\N	2026-01-30 16:38:18.908791+00
1656	/	home	https://findyusports-bcllqdflm-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	3.101.33.115	\N	2026-01-30 16:38:19.45046+00
1657	/	home	https://findyusports-bcllqdflm-findyu.vercel.app/	vercel-screenshot/1.0	164.92.66.89	\N	2026-01-30 16:38:19.478013+00
1658	/	home	https://findyusports-bcllqdflm-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	13.56.252.231	\N	2026-01-30 16:38:19.598022+00
1659	/map	map	https://findyusports.com/map?keyword=%E6%B5%99%E5%A4%A7	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 16:39:08.51782+00
1660	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:39:25.527227+00
1661	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:39:27.774471+00
1662	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:39:30.988154+00
1663	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.42.37	\N	2026-01-30 16:39:31.755996+00
1664	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:39:47.624062+00
1665	/map	map	https://findyusports.com/map?sport=basketball	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:42:11.492878+00
1666	/map	map	https://findyusports.com/map?sport=basketball	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	183.131.239.184	\N	2026-01-30 16:42:12.264975+00
1667	/map	map	https://findyusports.com/map?sport=basketball	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:42:12.744801+00
1668	/map	map	https://findyusports.com/map?sport=basketball	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.42.24	\N	2026-01-30 16:42:12.946208+00
1669	/map	map	https://findyusports.com/map?sport=basketball	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:42:13.711678+00
1670	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:42:16.004927+00
1671	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:43:09.253232+00
1672	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:43:10.495265+00
1673	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:43:11.643601+00
1674	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:43:12.659758+00
1675	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:43:14.850541+00
1676	/	home	https://findyusports-w77ms7jkx-findyu.vercel.app/	vercel-screenshot/1.0	137.184.10.187	\N	2026-01-30 16:43:23.685834+00
1677	/	home	https://findyusports-w77ms7jkx-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.215.225.151	\N	2026-01-30 16:43:24.179194+00
1678	/	home	https://findyusports-w77ms7jkx-findyu.vercel.app/	vercel-screenshot/1.0	147.182.251.221	\N	2026-01-30 16:43:24.221502+00
1679	/	home	https://findyusports-w77ms7jkx-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	13.57.27.217	\N	2026-01-30 16:43:24.317685+00
1680	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:44:02.20111+00
1681	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:44:02.29288+00
1682	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:44:19.701896+00
1683	/map	map	https://findyusports.com/map?keyword=%E6%B5%99%E5%A4%A7	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 16:44:45.164045+00
1684	/	home	https://findyusports.com/map?keyword=%E6%B5%99%E5%A4%A7	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 16:44:45.837501+00
1685	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:44:55.255047+00
1686	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:44:58.536704+00
1687	/	home	https://findyusports.com/map?keyword=%E6%B5%99%E5%A4%A7	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 16:48:04.857723+00
1688	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:48:11.699948+00
1689	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:48:13.406807+00
1690	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:48:17.949699+00
1691	/	home	https://findyusports.com/map?keyword=%E6%B5%99%E5%A4%A7	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 16:51:10.892339+00
1692	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:51:26.32567+00
1693	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:51:28.474301+00
1694	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:51:32.524048+00
1695	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:51:38.297231+00
1696	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:51:42.707304+00
1697	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:51:49.744381+00
1698	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:51:52.612251+00
1699	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:51:55.919017+00
1700	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-30 16:51:56.752685+00
1701	/	home	https://findyusports.com/map?keyword=%E6%B5%99%E5%A4%A7	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 16:54:28.962944+00
1702	/	home	https://findyusports.com/map?keyword=%E6%B5%99%E5%A4%A7	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 16:56:31.393765+00
1703	/	home	https://findyusports.com/map?keyword=%E6%B5%99%E5%A4%A7	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 16:58:20.197214+00
1704	/	home	https://findyusports.com/map?keyword=%E6%B5%99%E5%A4%A7	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 16:58:21.211386+00
1705	/	home	https://findyusports.com/map?keyword=%E6%B5%99%E5%A4%A7	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	160.22.157.88	\N	2026-01-30 16:59:43.783787+00
1706	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; Android 5.0) AppleWebKit/537.36 (KHTML, like Gecko) Mobile Safari/537.36 (compatible; Bytespider; https://zhanzhang.toutiao.com/)	110.249.201.6	\N	2026-01-31 00:56:18.977361+00
1707	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25060RK16C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.5.1010 Mobile Safari/537.36	115.227.41.132	\N	2026-01-31 01:30:13.960478+00
1708	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25060RK16C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.5.1010 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 01:30:36.782855+00
1709	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25060RK16C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.5.1010 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 01:31:20.559497+00
1710	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25060RK16C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.5.1010 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 01:31:48.533492+00
1711	/venues/45	venue	https://findyusports.com/venues/45	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25060RK16C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.5.1010 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 01:31:55.176214+00
1712	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25060RK16C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.3.5.1010 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 01:32:34.178583+00
1713	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 07:58:23.306876+00
1714	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.41.240	\N	2026-01-31 07:58:23.463904+00
1715	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 07:58:26.084488+00
1716	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 07:58:30.945151+00
1717	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 07:58:34.315943+00
1718	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.40.180	\N	2026-01-31 08:00:14.067305+00
1719	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:00:15.647631+00
1720	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:00:24.291826+00
1721	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:00:54.309104+00
1722	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:00:57.431757+00
1723	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:01:07.813365+00
1724	/map	map	https://findyusports.com/map?keyword=%E6%B5%99%E5%A4%A7	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:01:54.474333+00
1725	/admin/add-venue	admin	https://findyusports.com/map?keyword=%E6%B5%99%E5%A4%A7	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:02:08.435534+00
1726	/map	map	https://findyusports.com/map?keyword=%E6%B5%99%E5%A4%A7	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:02:10.756964+00
1727	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:02:12.676468+00
1728	/	home	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:02:19.442859+00
1729	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:02:23.782796+00
1730	/admin/add-venue	admin	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:02:48.15729+00
1731	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:06:34.223637+00
1732	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:06:43.8943+00
1733	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:06:47.615808+00
1734	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:10:32.194753+00
1735	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:10:35.481297+00
1736	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:16:20.90838+00
1737	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:16:26.805503+00
1738	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:16:32.08782+00
2032	/	home	https://findyusports-m9683k6rc-findyu.vercel.app/	vercel-screenshot/1.0	134.199.225.139	\N	2026-02-03 12:25:57.818944+00
1739	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:18:47.131967+00
1740	/	home	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:18:53.201037+00
1741	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.4.23 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36	::1	\N	2026-01-31 08:18:54.67694+00
1742	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.4.23 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36	::1	\N	2026-01-31 08:18:54.920356+00
1743	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:18:56.682303+00
1744	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-31 08:21:12.221751+00
1745	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-31 08:21:12.272831+00
1746	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-31 08:21:14.340677+00
1747	/map	map	http://localhost:3000/map?keyword=%E6%B5%99%E6%B1%9F	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-31 08:21:18.633165+00
1748	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:26:27.66875+00
1749	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.43.48	\N	2026-01-31 08:26:27.803475+00
1750	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:26:30.852734+00
1751	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:26:36.551927+00
1752	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:26:39.556175+00
1753	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:26:44.446364+00
1754	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-31 08:26:49.811459+00
1755	/map	map	http://localhost:3000/map?keyword=%E6%B5%99%E6%B1%9F	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-31 08:26:54.378492+00
1756	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:27:17.867678+00
1757	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:27:19.70201+00
1758	/map	map	https://findyusports.com/map?sport=basketball	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:27:20.803114+00
1759	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:27:21.918528+00
1760	/map	map	https://findyusports.com/map?sport=football	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:27:22.337668+00
1761	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:27:23.098365+00
1762	/map	map	https://findyusports.com/map?sport=basketball	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:27:26.526276+00
1763	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:27:27.194406+00
1764	/map	map	https://findyusports.com/map?sport=football	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:27:27.803404+00
1765	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:27:28.476379+00
1766	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:27:34.697644+00
1767	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:27:36.515667+00
1768	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:27:38.87216+00
1769	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.42.24	\N	2026-01-31 08:27:38.974308+00
1774	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.42.24	\N	2026-01-31 08:29:34.472456+00
1775	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-31 08:29:57.500401+00
1948	/venues/244	venue	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:17:24.67485+00
1949	/admin/edit-venue/244	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:17:26.716669+00
1993	/venues/244	venue	https://findyusports.com/venues/244	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	103.220.218.93	\N	2026-02-03 05:26:11.319007+00
2033	/	home	https://findyusports-m9683k6rc-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.183.49.37	\N	2026-02-03 12:25:57.893485+00
2034	/	home	https://findyusports-m9683k6rc-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.193.1.107	\N	2026-02-03 12:25:58.129722+00
1770	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:29:10.994051+00
1771	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:29:18.96231+00
1772	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:29:22.35877+00
1773	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 08:29:34.202659+00
1776	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:35:33.878472+00
1777	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:35:44.526294+00
1778	/map	map	https://findyusports.com/map?keyword=gong%20yuan	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:35:52.54915+00
1779	/venues/220	venue	https://findyusports.com/map?keyword=gong%20yuan	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:35:54.679436+00
1780	/admin/edit-venue/220	admin	https://findyusports.com/map?keyword=gong%20yuan	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:35:58.177657+00
1781	/venues/220	venue	https://findyusports.com/map?keyword=gong%20yuan	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:36:57.312282+00
1782	/admin/edit-venue/220	admin	https://findyusports.com/map?keyword=gong%20yuan	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:36:59.531446+00
1783	/venues/220	venue	https://findyusports.com/map?keyword=gong%20yuan	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:37:02.938231+00
1784	/map	map	https://findyusports.com/map?keyword=gong%20yuan	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:37:04.513471+00
1785	/venues/220	venue	https://findyusports.com/map?keyword=gong%20yuan	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:37:09.850443+00
1786	/admin/edit-venue/220	admin	https://findyusports.com/map?keyword=gong%20yuan	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 08:37:17.577516+00
1787	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-01-31 08:40:51.317699+00
1788	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.42.24	\N	2026-01-31 09:08:04.118642+00
1789	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 09:08:04.153479+00
1790	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 09:08:06.079795+00
1791	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 09:08:09.232374+00
1792	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.231.220	\N	2026-01-31 09:08:48.743958+00
1793	/venues/220	venue	https://findyusports.com/map?keyword=gong%20yuan	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 09:10:11.043865+00
1794	/admin/add-venue	admin	https://findyusports.com/map?keyword=gong%20yuan	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-01-31 09:10:23.994621+00
1795	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.41.48	\N	2026-02-01 02:50:05.943728+00
1796	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.230.69	\N	2026-02-01 02:50:06.133195+00
1797	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.230.69	\N	2026-02-01 02:50:11.598839+00
1798	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.41.240	\N	2026-02-01 02:50:59.920037+00
1799	/map	map	https://findyusports.com/map?keyword=gong%20yuan	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 02:58:00.509148+00
1800	/map	map	https://findyusports.com/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 02:58:08.344787+00
1801	/map	map	https://findyusports.com/map?keyword=%E6%B1%A4%E5%AE%B6	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 02:58:22.490434+00
1802	/venues/230	venue	https://findyusports.com/map?keyword=%E6%B1%A4%E5%AE%B6	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 02:58:30.622421+00
1803	/admin/edit-venue/230	admin	https://findyusports.com/map?keyword=%E6%B1%A4%E5%AE%B6	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 02:58:32.707442+00
1804	/venues/230	venue	https://findyusports.com/map?keyword=%E6%B1%A4%E5%AE%B6	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 02:58:38.459706+00
1805	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.230.69	\N	2026-02-01 02:58:53.413378+00
1806	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.230.69	\N	2026-02-01 02:58:55.804807+00
1807	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.230.69	\N	2026-02-01 02:58:59.390707+00
1808	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.230.69	\N	2026-02-01 02:59:19.85243+00
1809	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.230.69	\N	2026-02-01 02:59:22.289306+00
1810	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.230.69	\N	2026-02-01 02:59:27.6025+00
1811	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:02:19.851796+00
1812	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:02:59.204132+00
1813	/venues/230	venue	https://findyusports.com/map?keyword=%E6%B1%A4%E5%AE%B6	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:05:54.303636+00
1814	/admin/edit-venue/230	admin	https://findyusports.com/map?keyword=%E6%B1%A4%E5%AE%B6	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:05:57.795938+00
1815	/venues/230	venue	https://findyusports.com/map?keyword=%E6%B1%A4%E5%AE%B6	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:06:02.522381+00
1816	/admin/edit-venue/230	admin	https://findyusports.com/map?keyword=%E6%B1%A4%E5%AE%B6	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:06:21.752556+00
1817	/admin/edit-venue/230	admin	https://findyusports.com/map?keyword=%E6%B1%A4%E5%AE%B6	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:06:27.581993+00
1818	/admin/edit-venue/230	admin	https://findyusports.com/map?keyword=%E6%B1%A4%E5%AE%B6	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:08:32.15111+00
1819	/admin/edit-venue/230	admin	https://findyusports.com/map?keyword=%E6%B1%A4%E5%AE%B6	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:08:58.090174+00
1820	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:09:07.620725+00
1821	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:09:07.621485+00
1822	/admin/venues	admin	http://localhost:3000/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:09:10.177459+00
1823	/map	map	http://localhost:3000/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:09:23.771095+00
1824	/map	map	http://localhost:3000/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:09:24.175169+00
1825	/venues/230	venue	http://localhost:3000/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:09:25.75591+00
1826	/admin/edit-venue/230	admin	http://localhost:3000/admin/venues	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:09:31.784331+00
1827	/admin/edit-venue/230	admin	http://localhost:3000/admin/edit-venue/230	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:12:01.775897+00
1828	/admin/edit-venue/230	admin	http://localhost:3000/admin/edit-venue/230	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:12:01.900172+00
1829	/map	map	http://localhost:3000/admin/edit-venue/230	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:12:10.126122+00
1830	/map	map	http://localhost:3000/map?keyword=%E6%96%BD	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:12:14.966697+00
1831	/map	map	http://localhost:3000/map?keyword=%E6%96%BD	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:12:15.024978+00
1832	/venues/230	venue	http://localhost:3000/map?keyword=%E6%96%BD	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:12:21.030819+00
1833	/admin/edit-venue/230	admin	http://localhost:3000/map?keyword=%E6%96%BD	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:12:23.645549+00
1834	/map	map	https://findyusports.com/map?keyword=%E6%B1%A4%E5%AE%B6	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:12:39.123344+00
1836	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:12:44.567298+00
1950	/admin/add-venue	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:21:33.419037+00
1951	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	103.220.218.90	\N	2026-02-03 04:21:37.639163+00
1952	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:22:37.822431+00
1953	/admin/add-venue	admin	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:22:37.837533+00
1954	/	home	http://localhost:3000/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:33:31.307608+00
1955	/map	map	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:33:31.627938+00
1956	/map	map	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:33:31.8581+00
1959	/admin/edit-venue/247	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:43:27.844961+00
1994	/venues/244	venue	https://findyusports.com/venues/244	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	160.22.157.88	\N	2026-02-03 11:22:41.948518+00
2035	/venues/247	venue	https://findyusports.com/venues/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	218.252.114.192	\N	2026-02-03 12:27:24.501273+00
1835	/admin/add-venue	admin	https://findyusports.com/map?keyword=%E6%B1%A4%E5%AE%B6	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:12:42.139249+00
1837	/venues/230	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:12:50.29306+00
1838	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:16:11.101477+00
1839	/venues/230	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:16:26.06073+00
1840	/admin/edit-venue/230	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:16:27.801537+00
1841	/admin/edit-venue/230	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:16:35.664582+00
1842	/venues/230	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:16:36.862015+00
1843	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:16:37.378457+00
1844	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:19:40.526297+00
1845	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.230.69	\N	2026-02-01 03:23:16.785537+00
1846	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:27:34.153743+00
1847	/venues/236	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:27:36.116024+00
1848	/admin/edit-venue/236	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:27:38.951122+00
1849	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:28:07.960189+00
1850	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:35:24.95877+00
1851	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:37:41.938758+00
1852	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:37:55.41718+00
1853	/	home	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	188.253.123.151	\N	2026-02-01 03:37:56.348828+00
1854	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:38:01.85206+00
1855	/admin/data	admin	http://localhost:3000/admin/data	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:38:01.88392+00
1856	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:38:05.122874+00
1857	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:46:28.762277+00
1858	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:46:28.767529+00
1859	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:49:02.323678+00
1860	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:49:02.345608+00
1861	/map	map	http://localhost:3000/map?sport=basketball	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 03:49:11.983667+00
1862	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.230.69	\N	2026-02-01 04:11:56.414484+00
1863	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	183.131.239.184	\N	2026-02-01 04:11:56.72543+00
1864	/map	map	https://findyusports.com/map	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.230.69	\N	2026-02-01 04:11:59.295695+00
1865	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.230.69	\N	2026-02-01 04:12:03.954267+00
1866	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	112.10.230.69	\N	2026-02-01 04:12:04.971894+00
1869	/map	map	http://localhost:3000/map?sport=basketball	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 04:12:18.870923+00
1867	/	home	https://findyusports.com/	Mozilla/5.0 (Linux; U; Android 16; zh-CN; 25019PNF3C Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.80 Quark/10.4.0.1015 Mobile Safari/537.36	115.227.43.48	\N	2026-02-01 04:12:05.258781+00
1868	/map	map	http://localhost:3000/map?sport=basketball	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 04:12:18.842493+00
1870	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 04:12:21.854091+00
1957	/admin/edit-venue/247	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:33:51.930642+00
1958	/venues/247	venue	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:33:52.230136+00
1960	/admin/edit-venue/247	admin	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:43:27.844539+00
1995	/	home	https://findyusports-paqt2lyjj-findyu.vercel.app/	vercel-screenshot/1.0	64.23.212.160	\N	2026-02-03 11:57:36.679738+00
1996	/	home	https://findyusports-paqt2lyjj-findyu.vercel.app/	vercel-screenshot/1.0	24.199.113.117	\N	2026-02-03 11:57:36.741694+00
2036	/	home	https://findyusports.com/venues/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	218.252.114.192	\N	2026-02-03 12:28:08.470612+00
2038	/	home	https://findyusports-b2twbae2h-findyu.vercel.app/	vercel-screenshot/1.0	64.23.225.138	\N	2026-02-03 12:33:47.403005+00
2039	/	home	https://findyusports-b2twbae2h-findyu.vercel.app/	vercel-screenshot/1.0	143.198.59.23	\N	2026-02-03 12:33:47.510837+00
2040	/	home	https://findyusports-b2twbae2h-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.183.49.37	\N	2026-02-03 12:33:47.820103+00
2041	/	home	https://findyusports-b2twbae2h-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.215.72.229	\N	2026-02-03 12:33:47.857726+00
1871	/venues/191	venue	http://localhost:3000/venues/191	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 04:12:29.473097+00
1872	/	home	http://localhost:3000/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 04:12:39.290539+00
1873	/user	\N	http://localhost:3000/user	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 04:12:43.133229+00
1874	/map	map	http://localhost:3000/map	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 04:13:17.660683+00
1875	/user	\N	http://localhost:3000/user	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 04:17:42.214235+00
1876	/user	\N	http://localhost:3000/user	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 04:21:29.476299+00
1877	/user	\N	http://localhost:3000/user	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	::1	\N	2026-02-01 04:21:29.491819+00
1878	/map	map	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	65.75.221.219	\N	2026-02-01 04:21:31.906135+00
1879	/venues/241	venue	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.701	65.75.221.219	\N	2026-02-01 04:21:45.122246+00
1880	/	home	https://findyusports.com/	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.706	65.75.221.219	\N	2026-02-01 04:31:37.520981+00
1881	/admin/add-venue	admin	https://findyusports.com/admin/add-venue	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.0.706	65.75.221.219	\N	2026-02-01 04:31:43.987627+00
1961	/map	map	http://localhost:3000/admin/edit-venue/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	::1	\N	2026-02-03 04:51:09.676307+00
1997	/	home	https://findyusports-7tm60mbwf-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	18.144.166.163	\N	2026-02-03 11:58:22.341369+00
1998	/	home	https://findyusports-7tm60mbwf-findyu.vercel.app/	vercel-screenshot/1.0	64.23.160.201	\N	2026-02-03 11:58:22.677032+00
1999	/	home	https://findyusports-7tm60mbwf-findyu.vercel.app/	vercel-screenshot/1.0	147.182.229.229	\N	2026-02-03 11:58:22.873553+00
2000	/	home	https://findyusports-7tm60mbwf-findyu.vercel.app/	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/141.0.7390.0 Safari/537.36	54.219.185.151	\N	2026-02-03 11:58:22.985343+00
2037	/venues/244	venue	https://findyusports.com/venues/247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 QuarkPC/6.3.5.718	218.252.114.192	\N	2026-02-03 12:28:11.823573+00
\.


--
-- Data for Name: review; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.review (id, "venueId", "userId", rating, content, "createdAt") FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."user" (id, phone, nickname, avatar, password, role, status, "createdAt", "updatedAt", points, is_vip) FROM stdin;
1	15224051588	陈mo	\N	$2b$10$dhXqm/idz7f3.jkUJZ/WKuDrtazlY7h08eyx.QU0DC7lck7fgTNs6	admin	active	2025-12-23 05:50:15.415227+00	2026-02-03 04:31:40.981734+00	3	f
\.


--
-- Data for Name: venue; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.venue (id, name, "sportType", "cityCode", address, lng, lat, "priceMin", "priceMax", indoor, contact, is_public, district_code, open_time, lighting, floor_type, has_air_conditioning, has_ventilation, open_hours, has_lighting, has_parking, court_count, has_rest_area, has_fence, has_shower, has_locker, has_shop, supports_full_court, walk_in_price_min, walk_in_price_max, full_court_price_min, full_court_price_max, reservation_method, supports_walk_in, requires_reservation, players_per_side, price_display, walk_in_price_display, full_court_price_display) FROM stdin;
1	月欣家园篮球场	basketball	330100	\N	116.380863	39.900051	\N	\N	f	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
7	月欣家园篮球场（室内）	basketball	330100	临平区月欣家园	116.397428	39.90923	100	200	t	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
8	塘栖三中篮球馆	basketball	330100	临平区塘栖镇第三中学	116.397428	39.90923	\N	\N	t	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
9	杭州东方郡篮球场	basketball	330100	东方郡东区背面8幢后面	116.397428	39.90923	15	30	f	物业	f	330108	both	\N	塑胶	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
10	杭州天歆文体中心篮球场	basketball	330100	杭州市滨江区江晖路 40 号	116.397428	39.90923	25	\N	t	\N	t	330108	\N	\N	木地板	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
11	杭州市滨江职业高级中学篮球场	basketball	330100	钱塘江一桥南岸滨江高教园区内	116.397428	39.90923	\N	\N	f	\N	f	330108	\N	\N	塑胶	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
12	杭州市滨文小学篮球场	basketball	330100	浦沿街道滨文路 670 号	116.397428	39.90923	\N	\N	f	0571-56696601	t	330108	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
13	杭州市博文小学篮球场	basketball	330100	立业路 298 号	116.397428	39.90923	\N	\N	t	0571-87799616	t	330108	\N	\N	塑胶	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
14	杭州市第二中学篮球场（滨江校区）	basketball	330100	东信大道 76 号	116.397428	39.90923	\N	\N	t	\N	f	330108	\N	\N	塑胶	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
16	杭州市浦沿中学篮球场	basketball	330100	滨江区东冠路 550 号	116.397428	39.90923	\N	\N	t	\N	f	330108	\N	\N	木地板、塑胶	f	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
17	杭州市柒号球馆（白马湖店）	basketball	330100	杭州市滨江区白马湖路 7 号 1 层	116.397428	39.90923	30	360	t	4007789772	t	330108	\N	\N	木地板	t	\N	\N	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
18	杭州市前哨体育篮球馆	basketball	330100	杭州市滨江区江南大道新城路智汇领地 A 栋 3 楼	116.397428	39.90923	15	150	t	\N	t	330108	\N	\N	木地板	t	\N	周一到周三 13：00-22：00；周四到周日只开展篮球夜场 20：00-22：30	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
19	杭州市闻涛小学篮球场	basketball	330100	杭州市滨江区浦沿路 3 号	116.397428	39.90923	\N	\N	\N	86622175	t	330108	\N	\N	塑胶	f	\N	周一至周五，冬令时开放时间为早 5：30-7：00、晚 17：30-20：00，夏令时为早 5：00-6：30、晚 17：30-20：00；周六、周日及节假日开放时间为早 6：00 - 晚 19：00	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
20	杭州市西兴实验小学篮球场	basketball	330100	杭州市滨江区西兴街道官河路 9 号	116.397428	39.90923	\N	\N	\N	戴斌荣，13588760631	t	330108	\N	\N	\N	f	\N	周一至周五，夏令时为早 5：00-6：30、晚 18：00-20：30，冬令时为早 5：30-7：00、晚 17：00-20：30；周六、周日及节假日为早 5：00-10：00、晚 15：00-19：00	f	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
21	杭州市西兴中学篮球场	basketball	330100	杭州市滨江区西兴街道钱纳巷 139 号	116.397428	39.90923	\N	\N	\N	持杭州市民卡到社区开通健身功能，刷卡 / 刷脸入校；团体需通过 “浙里办” APP “校园开放” 预约，审核通过后入校	t	330108	\N	\N	木地板、塑胶	f	\N	室外（篮球场）：工作日早 5:30-7:00、晚 17:30-20:00（冬令时）；早 5:00-6:30、晚 17:30-，周三 18:00-21:00 可预约篮球半场20:00（夏令时）；节假日早 6:00-19:00	f	t	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
22	杭州市长河高级中学篮球场	basketball	330100	滨文路 227 号	116.397428	39.90923	\N	\N	\N	\N	t	330108	\N	\N	木地板、塑胶	f	\N	冬令时\t早 5：30-7：00、晚 17：30-20：00\t 夏令时\t早 5：00-6：30、晚 17：30-20：00\t 节假日\t全天\t早 6：00-19：00，室内周三 18：00-21：00（可预约篮球半场）	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
15	杭州市江南实验学校篮球场（月明校区）	basketball	330100	西兴街道启智街 516 号	116.397428	39.90923	0	0	t	\N	t	330108	\N	\N	塑胶、木地板	f	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
23	杭州市长河小学篮球场（白马湖校区)	basketball	330100	滨江	116.397428	39.90923	\N	\N	\N	\N	t	330108	\N	\N	\N	f	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
24	杭州市长河小学篮球场	basketball	330100	长河小学	116.397428	39.90923	\N	\N	\N	\N	t	330108	\N	\N	\N	f	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
25	杭州柒号主场(东联馆)	basketball	330100	中南国际商城（东联馆）	116.397428	39.90923	10	29	t	4007789772，微信公众号 / 小程序「柒号主场」	t	330108	\N	\N	木地板	t	\N	8:30–20:30，16:00 前免费，每人每天限 4 小时	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
27	浙江省劳动和社会保障干部学校篮球场	basketball	330100	浙江省劳动和社会保障干部学校	116.397428	39.90923	\N	\N	\N	\N	t	330108	\N	\N	\N	f	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
28	浙江艺术学校篮球场	basketball	330100	滨文路 518 号	116.397428	39.90923	\N	\N	t	\N	f	330108	\N	\N	木地板、塑胶	f	\N	校内师生：工作日 15:30-21:30（周四 17:30 开始）；周六、周日 13:00-20:00	f	f	9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
29	杭州海外海篮球馆	basketball	330100	海外海杭州汽车城 D 馆 2 楼（杭州市拱墅区石祥路 589 号）	116.397428	39.90923	30	50	t	\t0571-88175999	t	330105	\N	\N	木地板	t	\N	日常 10:00-22:00，具体以场馆实际运营为准，建议前往前电话确认	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
30	杭州第十一中学篮球场	basketball	330100	新塘街道品文街 158 号校内	116.397428	39.90923	\N	\N	\N	\N	f	330109	\N	\N	塑胶	f	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
31	杭州钢苑小学篮球场	basketball	330100	半山镇杭钢北苑 43 号（钢苑校区）	116.397428	39.90923	\N	\N	\N	浙里办扫码免费，0571-88121215	t	330105	\N	\N	塑胶	f	\N	工作日 18:00-21:00、周末 8:00-20:00	f	f	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
32	杭州花园篮球馆	basketball	330100	滨河南路（花园体育园区内，可导航 “花园体育篮球馆”）	116.397428	39.90923	199	399	t	\N	t	330108	\N	\N	木地板	f	\N	日常 10:00-22:00，以场馆实际运营为准，建议前往前电话确认	f	f	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
33	杭州市半山实验小学篮球场	basketball	330100	半山路 2-1 号校内	116.397428	39.90923	\N	\N	\N	\N	f	330105	\N	\N	塑胶	f	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
34	杭州市北秀小学	basketball	330100	青城路 9 号	116.397428	39.90923	\N	\N	\N	0571-56261819，通过 “杭州市民卡” 或 “浙里办” App 的 “校园健身” 登记	t	330105	\N	\N	\N	f	\N	工作日 18:00-21:00、周末 8:00-20:00	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
35	杭州市大关中学篮球场（董家校区）	basketball	330100	小河街道莫干山路 386 号	116.397428	39.90923	\N	\N	\N	0571-56878127，校内师生免费；校外通过市民卡 / 浙里办扫码免费，无额外收费	t	330105	\N	\N	塑胶、木地板	f	\N	工作日 18:00-21:00、周末 8:00-20:00（遇教学 / 赛事暂停）	f	f	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
36	杭州市拱宸桥小学教育集团篮球场（左岸校区）	basketball	330100	拱北小区永庆路 88 号	116.397428	39.90923	\N	\N	f	\t0571-88012345，校外通过市民卡 / 浙里办 App “校园健身” 登记后，扫码入校免费使用	t	330105	\N	\N	塑胶	f	\N	工作日 18:00-21:00、周末 8:00-20:00	f	f	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
37	杭州市拱宸中学篮球场	basketball	330100	拱北蚕花园永庆坊 6 号	116.397428	39.90923	\N	\N	\N	0571-88281385，校外需提前在 “杭州市民卡” 或 “浙里办” 完成 “校园健身” 登记，开通后扫码入校；场地先到先得，不接受包场预约	t	330105	\N	\N	木地板、塑胶	f	\N	工作日 18:00-21:00、周末 8:00-20:00	f	f	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
38	杭州市拱宸中学篮球场	basketball	330100	拱北蚕花园永庆坊 6 号	116.397428	39.90923	\N	\N	\N	0571-88281385，校外人员需在 “杭州市民卡” 或 “浙里办” App 完成 “校园健身” 登记，开通后扫码入校；场地先到先得，不接受包场预约	t	330105	\N	\N	木地板、塑胶	f	\N	工作日 18:00-21:00、周末 8:00-20:00（	f	f	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
39	杭州市拱墅区教师进修学校附属学校篮球场	basketball	330100	赵伍路 111 号	116.397428	39.90923	\N	\N	f	0571-88092026，校外需在 “杭州市民卡” 或 “浙里办” App 完成 “校园健身” 登记，开通后扫码入校；场地先到先得，不接受包场预约	t	330105	\N	\N	木地板、塑胶	f	\N	校外人员：工作日 18:00-21:00、周末 8:00-20:00	f	t	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
40	杭州市建新小学篮球场	basketball	330100	古河巷 19 号	116.397428	39.90923	\N	\N	f	0571-88313809	t	330105	\N	\N	塑胶	f	\N	工作日 18:00-21:00、周末 8:00-20:00	f	t	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
41	杭州市交通职业高级中学篮球场	basketball	330100	笕桥街道明石路	116.397428	39.90923	\N	\N	f	0571-88333788	t	330102	\N	\N	塑胶	f	\N	工作日 18:00-21:00、周末 8:00-20:00	f	f	8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
42	杭州市交通职业高级中学篮球场	basketball	330100	笕桥街道明石路（德胜老校区已搬迁）	116.397428	39.90923	\N	\N	f	0571-88333788	t	330102	\N	\N	塑胶	f	\N	工作日 18:00-21:00、周末 8:00-20:00	f	t	8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
43	杭州市康桥中学篮球场	basketball	330100	康桥街道学前路 158 号	116.397428	39.90923	\N	\N	f	0571-88046274	t	330105	\N	\N	塑胶	f	\N	工作日 18:00-21:00、周末 8:00-20:00	f	f	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
44	杭州市卖鱼桥小学教育集团篮球场（湖墅校区）	basketball	330100	湖墅街道湖墅新村 16 号	116.397428	39.90923	\N	\N	f	0571-88380257	t	330105	\N	\N	塑胶	f	\N	工作日 18:00-21:00、周末 8:00-20:00	f	f	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
45	杭州市启航中学篮球场	basketball	330100	和睦新村 46 号	116.397428	39.90923	\N	\N	f	0571-88091694	t	330105	\N	\N	塑胶	f	\N	工作日 18:00-21:00、周末 8:00-20:00	f	t	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
46	浙大城市学院篮球场	basketball	330100	上塘街道湖州街 51 号浙大城市学院内（分南、北校区室外场，另有体育馆内场）	116.397428	39.90923	50	800	\N	校内场地管理：0571-88018551（学校总机转接体育教学部）；体育馆前台：0571-88018666	t	330105	\N	\N	木地板、塑胶	f	\N	1. 室外：工作日 16:00-22:00，周末及节假日 9:00-22:00（教学活动优先，寒暑假以校内通知为准）。 2. 室内：工作日 18:00-21:00，周末及节假日 9:00-21:00（需提前预约）	f	f	12	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
47	ET.Beat篮球运动中心	basketball	330100	江南大道 588 号恒鑫大厦 4 楼（近地铁 1 号线江陵路站 C 口，步行约 600 米）	116.397428	39.90923	40	420	t	前台电话：15356150606；客服微信：ET_Basketball（预约 / 咨询）	t	330108	\N	\N	木地板	t	\N	工作日：10:00-22:00；周末及节假日：9:00-22:00（培训时段优先，需提前预约）	t	t	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
48	杭州市中策职业学校（霞湾校区）篮球场	basketball	330100	湖墅街道霞湾巷 65 号杭州市中策职业学校霞湾校区内（室外场位于食堂附近，室内场在体育馆内）	116.397428	39.90923	\N	\N	\N	学生处：0571-88351366（咨询场地开放与入校健身）；总务处：0571-88317315（场地管理），校外市民：免费开放，需在保安室刷市民卡登记，无额外收费。	t	330105	\N	\N	木地板、塑胶	t	\N	校外市民：双休日、节假日、寒暑假 9:00-12:00、13:00-16:00（需刷市民卡入校，开放容量 300 人）	t	t	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
49	杭州市长征中学篮球场	basketball	330100	莫干山路 536 号杭州市长征中学内（室外场位于塑胶田径场旁，室内场在体育馆内），无需预约，开放时段内持市民卡刷卡入校使用即可。	116.397428	39.90923	\N	\N	\N	总务处：0571-28997033（场地管理、开放咨询）；安保处：0571-28997006（入校登记咨询）	t	330105	\N	\N	木地板、塑胶	f	\N	双休日、节假日、寒暑假 9:00-11:30、13:30-17:00（需刷市民卡入校，开放容量约 200 人）	f	f	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
50	杭州市源清中学篮球场	basketball	330100	湖州街 69 号杭州	116.397428	39.90923	\N	\N	\N	总务处：0571-88022888-8021（场地管理、开放咨询）持市民卡在保安室登记 / 刷脸入校即可，无额外收费。	t	330105	\N	\N	木地板、塑胶	f	\N	\N	f	f	11	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
51	杭州市行知中学篮球场	basketball	330100	大关苑路 58 号杭州市行知中学内（室外场位于田径场旁，室内场在风雨运动场 / 体育馆内）	116.397428	39.90923	\N	\N	\N	学校总机：0571-88316673（转总务处 / 安保处咨询场地管理、入校登记）	t	330105	\N	\N	木地板、塑胶	f	\N	免费开放，持市民卡在保安室登记 / 刷卡入校即可，无额外收费。	f	f	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
52	杭州市文渊小学篮球场	basketball	330100	康桥街道学前路 8 号（主校区）	116.397428	39.90923	\N	\N	\N	0571-88041119，无需预约，开放时段内持市民卡刷卡入校使用即可。	t	330105	\N	\N	塑胶	f	\N	双休日、节假日、寒暑假 9:00-11:30、13:00-16:00	f	f	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
53	杭州市外国语实验小学篮球场	basketball	330100	大关街道大关小区东四苑 1 幢（篮球场位于校内 200 米环形跑道旁）	116.397428	39.90923	\N	\N	\N	0571-88312250，免费开放，持市民卡在保安室登记 / 刷卡入校即可	t	330105	\N	\N	塑胶	f	\N	双休日、节假日、寒暑假 9:00-11:30、13:00-16:00	f	f	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
54	杭州市十四中学（康桥分校）篮球场	basketball	330100	运河新城中心（龙腾街 500 号，近丽水北路），室外场位于 400 米塑胶跑道标准运动场旁	116.397428	39.90923	\N	\N	\N	0571-56079888，免费开放，持市民卡在保安室登记 / 刷卡入校即可	t	330105	\N	\N	木地板、塑胶	t	\N	双休日、节假日、寒暑假 9:00-11:30、13:30-17:00	t	t	9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
55	杭州市人民小学篮球场	basketball	330100	新昌路 100 号，篮球场位于校内 200 米环形塑胶跑道旁的操场区域	116.397428	39.90923	\N	\N	t	0571-88885048，免费开放，持市民卡在保安室登记 / 刷卡入校即可	t	330105	\N	\N	塑胶	f	\N	双休日、节假日、寒暑假 9:00-11:30、13:00-16:00	f	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
56	杭州市启航中学篮球场	basketball	330100	和睦街道和睦新村 46 号，篮球场位于校内 400 米塑胶跑道旁，体育馆西侧区域	116.397428	39.90923	\N	\N	\N	0571-88191182，免费开放，持市民卡在保安室登记 / 刷卡入校即可	t	330105	\N	\N	木地板、塑胶	f	\N	双休日、节假日、寒暑假 9:00-11:30、13:00-16:00	f	f	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
57	杭师院篮球场	basketball	330100	余杭塘路 2318 号杭州师范大学仓前校区内。风雨篮球场位于良睦路西门入口北侧；学生生活区室外场位于东区东环路南侧；教师公寓室外场位于东体育场东侧；东北区块室外场位于常二路东 2 门入口北侧	116.397428	39.90923	\N	\N	\N	0571-28865151，寒暑假开放时段免费，登记入校即可，无额外收费	t	330110	\N	\N	木地板、塑胶	t	\N	寒暑假 8:00-18:00（春节 2 月 15-23 日暂停），需持身份证 / 市民卡在保安室登记入校，开放容量约 100 人	t	t	14	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
58	杭州采荷中学教育集团濮家校区篮球场	basketball	330100	闸弄口街道天运社区天运路 1-1 号，篮球场位于校内操场区域，室内篮球馆在校园中部运动馆内	116.397428	39.90923	\N	\N	\N	0571-81639459，免费开放，持开通健身功能的市民卡刷卡入校即可，无额外收费	t	330102	\N	\N	木地板、塑胶、水泥	t	\N	6:00-10:00、17:00-21:00	t	t	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
59	杭州第九中学篮球场	basketball	330100	清江路 156 号	116.397428	39.90923	\N	\N	\N	0571-86587188，免费开放，持市民卡在保安室登记 / 刷卡入校即可，无额外收费	t	330102	\N	\N	木地板、塑胶	t	\N	双休日、节假日、寒暑假 9:00-11:30、13:00-16:00	t	f	6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
160	杭州市胜利小学足球场	football	330100	银鼓路 169 号	116.397428	39.90923	\N	\N	f	\N	t	330102	\N	\N	人工草皮	f	\N	\N	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
60	杭州第四中学教育集团篮球场（下沙校区）	basketball	330100	下沙 6 号大街 436 号	116.397428	39.90923	\N	\N	\N	0571-87018755，免费开放，持开通健身功能的市民卡刷卡入校即可，无额外收费	t	330114	\N	\N	塑胶、木地板	t	\N	6:00-10:00、17:00-21:00（需持市民卡开通健身功能刷卡入校，开放容量约 80 人）	t	f	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
61	杭州市采实教育集团采荷实验学校篮球场	basketball	330100	采东路 99 号	116.397428	39.90923	\N	\N	\N	0571-86951675，免费开放，持市民卡在保安室登记 / 刷卡入校即可，无额外收费	t	330102	\N	\N	木地板、塑胶、水泥	t	\N	双休日、节假日、寒暑假 9:00-11:30、13:00-16:00	t	t	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
62	杭州市东赞篮球管（东赞国际会议中心）	basketball	330100	东宁路 553 号东溪德必易园 2 层 238 室（火车东站附近，东宁路与天城路交叉口附近）	116.397428	39.90923	\N	\N	\N	18058739330	t	330102	\N	\N	木地板	t	\N	周一至周日 09:00-22:00（无特殊节假日闭馆安排，赛事包场需提前沟通调整）	t	t	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
63	杭州市多蓝水岸篮球场	basketball	330100	白杨街道多蓝水岸小区中心绿地旁	116.397428	39.90923	\N	\N	\N	0571-86913511，仅限小区业主免费使用，非业主需经业主陪同或物业登记许可，无额外收费	t	330114	\N	\N	塑胶	f	\N	全天开放（21:00 后建议降低音量，避免扰民，无特殊关闭安排，以物业通知为准）	f	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
64	杭州市宏优体育篮球场（南落马营店）	basketball	330100	秋涛路 213 号南落马营体育文化公园 4 幢宏优体育馆	116.397428	39.90923	\N	\N	t	校区电话：0571-86098666；全国统一咨询热线：400-601-6869（可咨询场地、课程、预约等）	t	330102	\N	\N	木地板	t	\N	工作日 13:00-15:00、20:30-22:00，周末 18:00-22:00	t	t	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
65	杭州市华润万家社区灯光球场	basketball	330100	闸弄口街道机场路一巷与董家桥路交叉口北 100 米（近三里亭社区，靠近顾家畈路、惠兰街）	116.397428	39.90923	\N	\N	f	0571-86467324	t	330102	\N	\N	塑胶	f	\N	全天开放，灯光开放时段通常为 18:00-21:00（夏季可能延长至 21:30，以社区通知为准，雨雪天气可能关闭）	t	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
66	杭州市江干区职业高级中学篮球场	basketball	330100	上城区笕桥街道机场路 383 号	116.397428	39.90923	\N	\N	f	0571-85042281	t	330102	\N	\N	塑胶	f	\N	通常仅限特定时段（如寒暑假），需提前咨询学校，以官方通知为准，雨雪天气或校园活动可能临时关闭	t	f	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
67	浙江江南理工专修学院篮球场	basketball	330100	浦沿街道东冠路与明德路交叉口	116.397428	39.90923	\N	\N	\N	18057105220	t	\N	\N	\N	木地板、塑胶	f	\N	通常为周末 9:00-12:00、14:00-17:00，寒暑假可能延长，雨雪天气或校内活动可能临时关闭	t	t	10	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
68	杭州市江湾小学篮球场	basketball	330100	白杨街道 24 号大街 498 号	116.397428	39.90923	\N	\N	f	0571-28101808	t	330114	\N	\N	塑胶	f	\N	通常仅限特定时段（如寒暑假），需提前咨询学校，以官方通知为准，雨雪天气或校园活动可能临时关闭	t	f	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
69	杭州市景苑小学篮球场	basketball	330100	下沙街道海通街 60 号景苑小学内	116.397428	39.90923	\N	\N	f	 0571-56070733	t	330114	\N	\N	塑胶	f	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
70	杭州市师大东城实验学校篮球场	basketball	330100	九堡街道九堡家园 42 号	116.397428	39.90923	\N	\N	\N	0571-28112171	t	330102	\N	\N	塑胶	f	\N	按上城区中小学场地开放规定，工作日 18:00-21:00、周末 9:00-17:00（寒暑假延长），雨雪天气或校园活动可能临时关闭	t	f	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
71	杭州市四季青小学篮球场	basketball	330100	四季青街道景昙路 98 号	116.397428	39.90923	\N	\N	f	0571-56927718	t	330102	\N	\N	塑胶	f	\N	工作日 18:00-21:00、周末 9:00-17:00（寒暑假延长），雨雪天气或校园活动可能临时关闭	t	t	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
72	杭州市万向职业技术学院蓝球场	basketball	330100	西溪路 896 号	116.397428	39.90923	\N	\N	f	0571-87771888 转 8206	t	330106	\N	\N	塑胶、木地板	f	\N	按西湖区高校场地开放规定，工作日 18:00-21:00、周末 9:00-17:00（寒暑假延长，雨雪天气或校园活动可能临时关闭）	f	f	10	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
73	杭州市文海实验学校篮球场	basketball	330100	白杨街道文瀚路 585 号	116.397428	39.90923	\N	\N	f	0571-81605960	t	330114	\N	\N	木地板	f	\N	按钱塘区中小学场地开放规定，工作日 18:00-21:00、周末 9:00-17:00（寒暑假延长），雨雪天气或校园活动可能临时关闭杭州市钱塘区人民政府	f	f	8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
74	下沙第二小学篮球场	basketball	330100	下沙街道东方村福城路 199 号	116.397428	39.90923	\N	\N	f	 0571-86935101	t	330114	\N	\N	塑胶	f	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
75	杭州市下沙中学篮球场	basketball	330100	海达南路 555 号	116.397428	39.90923	\N	\N	f	0571-56230506，居民持杭州市民卡开通校园健身功能刷卡入校，无市民卡凭有效证件到社区登记，无需额外预约，先到先得	t	330114	\N	\N	塑胶	f	\N	工作日 18:00-21:00、周末 9:00-17:00（寒暑假延长，雨雪天气或校园活动可能临时关闭）	f	f	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
76	杭州市夏衍小学篮球场	basketball	330100	彭埠街道莲花桥路 2 号	116.397428	39.90923	\N	\N	\N	0571-86494683	t	330102	\N	\N	木地板、塑胶	f	\N	按上城区中小学场地开放规定，工作日 18:00-21:00、周末 9:00-17:00（寒暑假延长），雨雪天气或校园活动可能临时关闭	f	f	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
77	杭州市学林街小学篮球场	basketball	330100	学林街 1500 号	116.397428	39.90923	\N	\N	\N	0571-86871716	t	330114	\N	\N	塑胶	f	\N	工作日 18:00-21:00、周末 9:00-17:00（寒暑假延长，雨雪天气或校园活动可能临时关闭）	f	f	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
78	杭州市学正小学篮球场	basketball	330100	学林街 1500 号	116.397428	39.90923	\N	\N	\N	0571-86871716	t	330114	\N	\N	塑胶、木地板	f	\N	工作日 18:00-21:00、周末 9:00-17:00（寒暑假延长，雨雪天气或校园活动可能临时关闭）	f	f	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
79	杭州市御道学校篮球场	basketball	330100	九堡街道三村三区 99 号	116.397428	39.90923	\N	\N	\N	0571-56979765	t	330114	\N	\N	木地板、塑胶	f	\N	工作日 18:00-21:00、周末 9:00-17:00（寒暑假延长），雨雪天气或校园活动可能临时关闭	f	f	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
80	浙江大学华家池校区篮球场	basketball	330100	区凯旋路 268 号	116.397428	39.90923	\N	\N	\N	篮球场管理处：0571-86971046；校园服务中心前台：0571-87572114；逸夫体育馆咨询可拨打此电话	t	330102	\N	\N	木地板、塑胶	t	\N	1. 室外场地：工作日 6:00-22:00，周末及节假日全天开放（以校内通知、场地维护情况为准） 2. 室内场馆（逸夫体育馆，正常学期）：工作日 16:30-22:00，周末 13:00-22:00（寒暑假开放时间调整，以学校通知为准）	t	t	6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
81	杭州市滨虹学校足球场	football	330100	长河街道楚天路 123 号	116.397428	39.90923	\N	\N	t	0571-56690606，寒暑假开放时段按杭州滨江区校园开放政策执行，免费，需刷脸 / 刷市民卡登记进入	t	330108	\N	\N	人工草皮	f	\N	寒暑假：按滨江区统一开放时段，一般为工作日 14:00-21:00，周末 9:00-21:00（以 “浙里办”【校园开放】应用公告为准）	t	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
82	杭州市滨文小学足球场	football	330100	浦沿街道滨文路 670 号	116.397428	39.90923	\N	\N	\N	学校总机：0571-56696688	t	330108	\N	\N	人工草皮	t	\N	寒暑假：工作日 14:00-21:00，周末 9:00-21:00（以 “浙里办”【校园开放】应用公告为准）	t	t	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
83	杭州市博文小学足球场	football	330100	浦沿街道立业路 298 号	116.397428	39.90923	\N	\N	f	学校总机：0571-87799615、0571-87799616；场地咨询（体育组）：蒋老师 13957122284；对外预约需提前联系此电话，按学校流程申请电话邦	t	330108	\N	\N	人工草皮	f	\N	工作日 14:00-21:00，周末 9:00-21:00（以 “浙里办”【校园开放】应用公告为准）	t	t	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
84	杭州市彩虹城小学足球场	football	330100	浦沿街道伟业路 628 号	116.397428	39.90923	\N	\N	f	学校总机：0571-86685680；体育组（场地咨询）：13588456789（赵老师）；对外预约需提前联系此电话，按学校流程申请	t	330108	\N	\N	人工草皮	f	\N	日常不对外开放，寒暑假按滨江区校园开放政策免费开放，需刷市民卡 / 刷脸登记，提前联系学校预约	f	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
85	杭州市高新实验学校足球场	football	330100	滨盛路 5666 号	116.397428	39.90923	\N	\N	f	学校总机：0571-87683579；场地咨询（体育组）：李老师 13588456789；对外预约需提前联系此电话，按学校流程申请	t	330108	\N	\N	\N	f	\N	周一至周五冬令时早 5:30-7:00、晚 18:00-20:30；夏令时早 5:00-6:30、晚 18:00-20:30；周六、周日及节假日 6:00-19:00（以校内通知、场地维护为准）	f	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
86	杭州市江南实验学校足球场（月明校区） 	football	330100	长河街道风荷路 516 号	116.397428	39.90923	\N	\N	f	学校总机：0571-86628112；场地咨询（体育组）：袁坚利老师 18058199128；对外预约需提前联系此电话，按学校流程申请	t	330108	\N	\N	人工草皮	f	\N	周一至周五早 5:00-6:30、晚 18:00-20:30；周六、周日及节假日 6:00-20:30（以校内通知、场地维护为准）	t	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
87	杭州市江南实验学校足球场	football	330100	滨和路 958 号	116.397428	39.90923	\N	\N	f	首次进校锻炼需出示身份证完成人脸采集，后续可直接刷脸进校。	t	330108	\N	\N	人工草皮	f	\N	\N	f	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
88	杭州市浦沿小学教育集团足球场（东冠校区）	football	330100	浦沿街道东冠社区 431 号	116.397428	39.90923	\N	\N	f	学校总机：0571-56131830；体育组（场地咨询）：13588456789（陈老师）；对外预约需提前联系此电话，按学校流程申请杭州高新区(滨江)	t	330108	\N	\N	人工草皮	f	\N	\N	f	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
89	杭州市浦沿小学教育集团足球场（东冠校区）	football	330100	浦沿街道东冠社区 431 号	116.397428	39.90923	\N	\N	f	学校总机：0571-56131830；体育组（场地咨询）：13588456789（陈老师）；对外预约需提前联系此电话，按学校流程申请	t	330108	\N	\N	\N	f	\N	工作日 14:00-21:00，周末 9:00-21:00（以 “浙里办”【校园开放】应用公告为准）	f	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
90	杭州市浦沿小学教育集团足球场（东冠校区）	football	330100	浦沿街道东冠社区 431 号	116.397428	39.90923	\N	\N	f	学校总机：0571-56131830；体育组（场地咨询）：13588456789（陈老师）；对外预约需提前联系此电话，按学校流程申请	t	330108	\N	\N	\N	f	\N	工作日 14:00-21:00，周末 9:00-21:00（以 “浙里办”【校园开放】应用公告为准）	f	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
91	杭州市浦沿小学教育集团足球场（山二校区）	football	330100	山二村村民委员会斜对面	116.397428	39.90923	\N	\N	f	0571-86617006	t	330108	\N	\N	人工草皮	f	\N	\N	f	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
92	杭州市浦沿中学足球场	football	330100	浦沿街道东冠路 550 号	116.397428	39.90923	\N	\N	\N	学校总机：0571-88268326；场地咨询（体育组）：建议拨打总机转接，对外预约需提前联系学校按流程申请	t	330108	\N	\N	人工草皮	f	\N	周一至周五早 5:00-6:30、晚 18:00-20:30；周六、周日及节假日 6:00-20:30（以校内通知、场地维护为准）	f	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
93	杭州市闻涛小学足球场	football	330100	新月路 570 号	116.397428	39.90923	\N	\N	f	0571-86622175（孙老师）	t	330108	\N	\N	人工草皮	f	\N	- 周一至周五：夏令时 5:00-6:30、17:30-20:00；冬令时 5:30-7:00、17:30-20:00 - 周六、周日及节假日：6:00-19:00（以校内通知、场地维护为准）	t	t	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
94	杭州市西兴小学足球场	football	330100	西兴街道官河路 9 号	116.397428	39.90923	\N	\N	f	0571-86685015	t	330108	\N	\N	人工草皮	f	\N	周一至周五早 5:00-6:30、晚 18:00-20:30；周六、周日及节假日 6:00-20:30（以校内通知、场地维护为准）	t	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
95	杭州市西兴中学足球场	football	330100	西兴街道钱纳巷 139 号	116.397428	39.90923	\N	\N	f	0571-88268368	t	330108	\N	\N	人工草皮	f	\N	周一至周五：夏令时 5:00-6:30、17:30-20:00；冬令时 5:30-7:00、17:30-20:00 - 周六、周日及节假日：6:00-20:00（以校内通知、场地维护为准）	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
96	杭州市长河高级中学足球场	football	330100	滨文路 227 号	116.397428	39.90923	\N	\N	f	0571-86604788	t	330108	\N	\N	\N	f	\N	周一至周五：夏令时 5:00-6:30、17:30-20:00；冬令时 5:30-7:00、17:30-20:00 - 周六、周日及节假日：6:00-20:00（以校内通知、场地维护为准）	t	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
97	杭州市长河小学足球场	football	330100	长河街道双庙路 23 号	116.397428	39.90923	\N	\N	f	0571-86601168	t	330108	\N	\N	\N	f	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
98	杭州市长河小学足球场（白马湖校区)	football	330100	长河街道天马路 500 号	116.397428	39.90923	\N	\N	f	\N	t	330108	\N	\N	人工草皮	f	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
99	杭州市长河小学足球场	football	330100	无	116.397428	39.90923	\N	\N	f	0571-87779568	t	330108	\N	\N	\N	f	\N	\N	f	f	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
100	杭州第十一中学足球场（大关校区）	football	330100	八丈井东路 150 号	116.397428	39.90923	\N	\N	f	0571-88030928	t	330105	\N	\N	\N	f	\N	通常仅在周末、节假日及寒暑假对社会开放，具体需提前咨询学校 3. 特殊情况：遇学校大型活动、赛事等，可能临时调整开放时间	t	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
101	杭州第十一中学足球场（德胜校区）	football	330100	德苑路 97 号	116.397428	39.90923	\N	\N	f	0571-88317292	t	330105	\N	\N	塑胶	f	\N	通常仅在周末、节假日及寒暑假对社会开放，具体需提前咨询学校 3. 特殊情况：遇学校大型活动、赛事等，可能临时调整开放时间	t	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
102	杭州市北秀小学足球场	football	330100	半山街道青城路 9 号	116.397428	39.90923	\N	\N	f	\N	f	330105	\N	\N	\N	f	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
103	杭州市大关苑第一小学足球场	football	330100	大关西四苑 22 号	116.397428	39.90923	\N	\N	f	\N	t	330105	\N	\N	人工草皮	f	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
104	杭州市大关中学（文澜校区）足球场	football	330100	通益路与湖州街交汇处（拱宸桥西）	116.397428	39.90923	\N	\N	f	0571-56878123（集团总机，可转接文澜校区）	t	330105	\N	\N	人工草皮	f	\N	通常仅周末、节假日及寒暑假对社会开放，具体需提前与学校沟通预约 3. 特殊调整：遇学校大型活动、赛事等，可能临时关闭或调整开放时段	t	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
105	杭州市德胜小学教育集团足球场（德胜新村校区）	football	330100	德胜新村德苑路 96 号	116.397428	39.90923	\N	\N	f	0571-88232919；0571-88232935；0571-88232958	t	330105	\N	\N	人工草皮	f	\N	社会开放时段：周末、节假日及寒暑假可能有限开放，具体需提前咨询学校预约 3. 特殊调整：遇学校大型活动、赛事等，开放时间可能临时变更	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
144	杭州市夏衍小学足球场	basketball	330100	彭埠街道新塘路与莲花桥路交叉口	116.397428	39.90923	\N	\N	f	\N	t	330102	\N	\N	人工草皮	f	\N	\N	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	11人制	\N	\N	\N
106	杭州市湖州街足球场	football	330100	湖州街 61 号（湖州街与东教路交叉口东北角）	116.397428	39.90923	\N	\N	f	0571-88319921（聚动体育城北办事处）	t	330105	\N	\N	人工草皮	f	\N	全天候 24 小时对市民开放，灯光照明夜间正常启用，满足晚间运动需求	t	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
107	杭州市建新小学足球场	football	330100	古河巷 19 号	116.397428	39.90923	\N	\N	f	0571-88080272（学校总机）	t	330105	\N	\N	\N	f	\N	社会开放时段：工作日 18:00-21:00，公休日、法定节假日及寒暑假 7:00-11:00、17:00-21:00（以学校最新公示为准） 3. 特殊调整：遇学校大型活动、赛事等，可能临时关闭或调整开放时段	t	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
108	杭州市交通职业高级中学足球场	football	330100	笕桥开创街 246 号（笕桥新校区）	116.397428	39.90923	\N	\N	f	0571-88333768（学校总机）	t	330102	\N	\N	人工草皮	f	\N	通常周末、节假日及寒暑假开放，需提前与学校沟通预约 3. 特殊调整：遇学校大型活动、赛事等，可能临时关闭或调整时段	t	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
109	杭州市交通职业高级中学足球场	football	330100	笕桥开创街 246 号	116.397428	39.90923	\N	\N	f	0571-88333768（学校总机）；0571-88032500；0571-88032299	t	330102	\N	\N	人工草皮	f	\N	通常仅周末、节假日及寒暑假对社会开放，具体需提前与学校沟通预约 3. 特殊调整：遇学校大型活动、赛事等，可能临时关闭或调整开放时段	t	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
110	杭州市科教院附小（钢苑小学）足球场	football	330100	无	116.397428	39.90923	\N	\N	\N	\N	f	\N	\N	\N	人工草皮	f	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
111	杭州市明德小学足球场	football	330100	半山街道半山路 5 号	116.397428	39.90923	\N	\N	\N	\N	f	330105	\N	\N	\N	f	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
112	杭州市莫干山路小学篮球场（北站校区）	football	330100	祥符街道莫干山路 752 弄 9 号（北站校区）	116.397428	39.90923	\N	\N	f	0571-88184530（学校总机，可转体育组咨询场地）	t	330105	\N	\N	人工草皮	f	\N	工作日 18:00-21:00，公休日、法定节假日及寒暑假 7:00-11:00、17:00-21:00（以学校最新公示及 “杭州市学校体育场地开放” 平台信息为准） 3. 特殊调整：遇学校大型活动、场地维护等，可能临时关闭或调整时段	t	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
113	杭州市启航中学足球场	football	330100	和睦新村 45 号	116.397428	39.90923	\N	\N	f	0571-88196185（学校总机）	t	330105	\N	\N	\N	f	\N	通常周末、节假日及寒暑假开放，需提前与学校沟通预约 3. 特殊调整：遇学校大型活动、赛事等，可能临时关闭或调整时段	t	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
114	杭州市十四中学（康桥分校）	football	330100	龙腾街 500 号	116.397428	39.90923	\N	\N	f	0571-88467690（学校总机，可转接体育组咨询足球场相关事宜）	t	330105	\N	\N	人工草皮	f	\N	通常仅周末、节假日及寒暑假对社会开放，具体需提前与学校沟通预约 3. 特殊调整：遇学校大型活动、赛事、场地维护等情况，可能临时关闭或调整开放时段	t	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
115	杭州市树人大学足球场	football	330100	树人街 8 号	116.397428	39.90923	\N	\N	\N	\N	f	330105	\N	\N	\N	f	\N	\N	f	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
116	杭州市外语实验小学足球场	football	330100	苑中路 12 号	116.397428	39.90923	\N	\N	\N	\N	f	330105	\N	\N	人工草皮	f	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
117	杭州市行知中学足球场	football	330100	大关苑路 58 号	116.397428	39.90923	\N	\N	f	0571-88013167（学校总机，可转接体育组咨询足球场相关事宜）	t	330105	\N	\N	人工草皮	f	\N	通常周末、节假日及寒暑假开放，需提前与学校沟通预约 3. 特殊调整：遇学校大型活动、赛事等，可能临时关闭或调整时段	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
118	杭州市源清中学	football	330100	湖州街 69 号	116.397428	39.90923	\N	\N	f	0571-88012668（学校总机，可转接体育组咨询足球场相关事宜）	t	330105	\N	\N	天然草皮	f	\N	通常仅周末、节假日及寒暑假对社会开放，具体需提前与学校沟通预约 3. 特殊调整：遇学校大型活动、赛事、场地维护等情况，可能临时关闭或调整开放时段	t	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
119	杭州市长征中学足球场	football	330100	莫干山路 536 号（北大桥地铁站 D 口步行 320 米）电话邦	116.397428	39.90923	\N	\N	f	0571-88195705（学校总机，可转接体育组咨询足球场相关事宜）	t	330105	\N	\N	人工草皮	f	\N	通常周末、节假日及寒暑假对社会开放，需提前与学校沟通预约 3. 特殊调整：遇学校大型活动、赛事、场地维护等情况，可能临时关闭或调整时段	t	f	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
120	天空足球场（滨江龙湖天街店）	football	330100	长河路 475 号龙湖滨江天街 7F - C01	116.397428	39.90923	480	680	f	18667045533	t	330108	\N	\N	人工草皮	t	\N	10:00-22:00（节假日正常开放，特殊活动可能调整）\t	t	t	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
122	纵贯天空足球公园（滨江）	football	330100	南环路 3276 号 B 号楼	116.397428	39.90923	\N	\N	\N	18758886939	t	330108	\N	\N	\N	f	\N	10:00-22:00（全年开放，雨雪天可能临时关闭）	t	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
123	杭州采实教育集团钱江新城实验学校足球场	football	330100	四季青街道庆和路 59 号	116.397428	39.90923	\N	\N	f	0571-56979960（学校总机）；0571-56979800（可咨询体育场馆相关事宜）	t	330102	\N	\N	人工草皮	t	\N	校外人员需持杭州市民卡或实名杭州通卡开通健身功能，在周末、节假日及寒暑假开放，开放时段为 7:00-11:00、16:00-20:00 3. 特殊调整：遇学校大型活动、赛事等，可能临时关闭或调整时段	t	t	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
128	杭州市丁兰实验中学足球场	football	330100	丁兰街道丁群街 799 号	116.397428	39.90923	\N	\N	f	总机：0571-28297100；体育组咨询：0571-28297106（可咨询足球场使用与开放）	t	330102	\N	\N	人工草皮	f	\N	非教学时段开放，工作日一般为 18:00-21:00，周末及节假日开放时间更长，雷雨雪等恶劣天气或学校重大活动时暂停开放（以学校公告为准）	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	1. 线上：浙里办 APP / 支付宝搜索 “校园健身”，选择该校开通健身功能并预约 2. 线下：携带市民卡 / 杭州通卡到校区现场办理，支持人脸识别、市民卡、二维码核验入校	f	t	11人制	\N	\N	\N
121	启杭天空足球场（余杭）	football	330100	通运街 370 号良渚生命科技小镇 1 号楼楼顶	116.397428	39.90923	\N	\N	f	13738600609	t	330110	\N	\N	\N	f	\N	 14:00-22:00，周末及节假日 9:00-22:00（以预订确认为准）	t	t	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
124	杭州第九中学足球场	football	330100	上城区双菱路 152 号	116.397428	39.90923	\N	\N	f	0571-86040178（学校总机，可转接体育组咨询足球场相关事宜）	t	330102	\N	\N	人工草皮	f	\N	通常仅周末、节假日及寒暑假对社会开放，具体需提前与学校沟通预约	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	对外为低收费或公益开放，具体价格以学校公示为准，需提前咨询	f	t	\N	\N	\N	\N
125	杭州市采荷三小采荷校区足球场	football	330100	采荷街道经纬路 1 号	116.397428	39.90923	\N	\N	\N	\N	t	330102	\N	\N	\N	f	\N	\N	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
126	杭州市采荷三小江锦校区足球场	football	330100	四季青街道百安路 1 号	116.397428	39.90923	\N	\N	f	0571-85631102	t	330102	\N	\N	\N	f	\N	\N	t	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
127	杭州市采实教育集团采荷实验学校足球场	football	330100	采东路 99 号	116.397428	39.90923	\N	\N	f	\N	t	330102	\N	\N	\N	f	\N	\N	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
145	杭州市学林街小学足球场	football	330100	学林街 1500 号	116.397428	39.90923	\N	\N	f	0571-86912115	t	330114	\N	\N	人工草皮	f	\N	1. 工作日：18:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	7人制	\N	\N	\N
129	杭州市笕桥实验中学足球场	basketball	330100	学风直弄 2 号	116.397428	39.90923	\N	\N	f	总机：0571-86452330（可转接体育组咨询足球场事宜）	t	330102	\N	\N	人工草皮	f	\N	1. 工作日：17:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	1. 线上：浙里办 APP / 支付宝搜索 “校园健身”，选择该校开通健身功能并预约 2. 线下：携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	7人制	\N	\N	\N
130	杭州市景芳中学足球场	football	330100	凯旋街道景芳三区，东接新塘路，西临秋涛路	116.397428	39.90923	\N	\N	f	0571-86033042	t	330102	\N	\N	人工草皮	f	\N	1. 工作日：17:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	社会开放免费（需遵守校园场地管理规定，禁止携带危险物品入场）	f	t	5人制	\N	\N	\N
131	杭州市茅以升实验学校足球场	football	330100	景芳二区 35 幢	116.397428	39.90923	\N	\N	f	0571-56970231	t	330102	\N	\N	人工草皮	f	\N	1. 工作日：17:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	社会开放免费，1. 线上：浙里办 APP / 支付宝搜索 “校园健身”，选择该校开通健身功能并预约 2. 线下：携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	\N	\N	\N	\N
132	杭州市茅以升实验学校足球场	football	330100	景芳二区 35 幢	116.397428	39.90923	\N	\N	f	0571-56970231	t	330102	\N	\N	人工草皮	f	\N	1. 工作日：17:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	\N	\N	\N	\N
133	杭州市师大东城实验学校足球场（东昌校区）	football	330100	九堡街道士安路 111 号（九环路 42 号）	116.397428	39.90923	\N	\N	f	0571-28112180	t	330102	\N	\N	人工草皮	f	\N	1. 工作日：17:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	\N	\N	\N	\N
134	杭州市师大东城实验学校足球场（东盛校区）	football	330100	九堡街道胜康路 378 号	116.397428	39.90923	\N	\N	f	0571-28112180	t	330102	\N	\N	人工草皮	f	\N	1. 工作日：17:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	\N	\N	\N	\N
135	杭州师范大学东城实验学校（东润校区）	football	330100	杭州市上城区九堡街道三胜街 409 号	116.397428	39.90923	\N	\N	f	0571-28112180	t	330102	\N	\N	人工草皮	f	\N	1. 工作日：17:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	\N	\N	\N	\N
136	杭州市师范大学东城第二小学足球场	football	330100	九堡街道杭乔路 38 号	116.397428	39.90923	\N	\N	\N	0571-28254010	t	330102	\N	\N	\N	f	\N	\N	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
137	杭州市四季青小学足球场	football	330100	景昙路 98 号（近凤起东路）	116.397428	39.90923	\N	\N	f	0571-56927716	t	330102	\N	\N	人工草皮	f	\N	1. 工作日：17:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	\N	\N	\N	\N
138	杭州市天杭教育集团足球场（天杭校区）	football	330100	闸弄口街道顾家畈路 20 号	116.397428	39.90923	\N	\N	f	0571-86400012	t	330102	\N	\N	人工草皮	f	\N	1. 工作日：17:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	\N	\N	\N	\N
139	杭州市文海实验学校足球场	football	330100	白杨街道学正街 809 号	116.397428	39.90923	\N	\N	f	0571-81605901	t	330114	\N	\N	人工草皮	f	\N	1. 工作日：6:00-7:00，18:30-21:30 2. 周末 / 节假日：7:00-10:30，18:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	\N	\N	\N	\N
140	杭州市文海实验学校足球场（小学文清校区）	football	330100	白杨街道学府街 115 号	116.397428	39.90923	\N	\N	f	0571-81605901	t	330114	\N	\N	人工草皮	f	\N	1. 工作日：6:00-7:00，18:30-21:30 2. 周末 / 节假日：7:00-10:30，18:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校1	f	t	\N	\N	\N	\N
141	杭州市文海实验学校小学部（含文清校区）	football	330100	白杨街道学正街 809 号	116.397428	39.90923	\N	\N	f	0571-81605901	t	330114	\N	\N	人工草皮	t	\N	1. 工作日：6:00-7:00，18:30-21:30 2. 周末 / 节假日：7:00-10:30，18:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	f	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	\N	\N	\N	\N
142	杭州市下沙第二小学足球场	football	330100	下沙街道福城路 199 号	116.397428	39.90923	\N	\N	f	0571-86911728	t	330114	\N	\N	人工草皮	f	\N	1. 工作日：17:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	\N	\N	\N	\N
143	杭州市下沙中学足球场	football	330100	下沙街道海达南路 555 号	116.397428	39.90923	\N	\N	f	0571-86912328	t	330114	\N	\N	人工草皮	f	\N	1. 线上：浙里办 APP / 支付宝搜索 “校园健身”，选择该校开通健身功能并预约 2. 线下：携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	\N	\N	\N	\N
146	杭州市学正小学足球场	football	330100	学正街道学正路 18 号	116.397428	39.90923	\N	\N	f	0571-86871766	t	330114	\N	\N	人工草皮	f	\N	1. 工作日：18:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	7人制	\N	\N	\N
147	朝晖中学足球场	football	330100	朝晖街道朝晖三区 3 号	116.397428	39.90923	\N	\N	f	0571-85337357	t	330105	\N	\N	人工草皮	f	\N	1. 工作日：18:00-21:00 2. 周末 / 节假日：7:00-11:00，14:00-17:00，18:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	4	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	7人制	\N	\N	\N
148	杭州第二中学足球场	football	330100	东信大道 76 号	116.397428	39.90923	\N	\N	f	0571-86698506	t	330108	\N	\N	人工草皮	f	\N	1. 工作日：18:30-21:00（避开晚自修与校队训练） 2. 周末 / 节假日：8:00-11:30，14:00-17:30，18:30-21:00 3. 特殊情况：恶劣天气或重大活动暂停，以浙里办 “校园健身” 公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带市民卡 / 杭州通卡到学校或社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	11人制	\N	\N	\N
149	杭州第四中学足球场（吴山校区）	football	330100	清波街道延安路 19 号	116.397428	39.90923	\N	\N	f	校办：0571-87013753；总机：0571-87032790（可转接体育组咨询足球场事宜）	t	330102	\N	\N	人工草皮	f	\N	1. 工作日：18:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	5人制、8人制	\N	\N	\N
150	杭州市北京师范大学杭州附属中学(勇进中学）足球场	football	330100	南星街道钱江路与姚江路交叉口西南角	116.397428	39.90923	\N	\N	f	总机：0571-86871098；校办：0571-86871006（可转接体育组咨询足球场相关事宜）	t	330102	\N	\N	人工草皮	t	\N	1. 工作日：18:00-21:00（避开晚自修与校队训练时段） 2. 周末 / 节假日：7:00-11:30，14:00-17:30，18:00-21:00 3. 特殊情况：恶劣天气或学校重大活动暂停，以浙里办 “校园健身” 平台公告为准杭州市教育局	t	t	1	t	f	\N	\N	\N	f	\N	\N	\N	\N	携带市民卡 / 杭州通卡到学校或社区办理，支持刷卡 / 扫码 / 人脸识别入校	f	t	11人制	\N	\N	\N
151	给我杭州市第二中学足球场（东河校区）	football	330100	建国中路 36 号	116.397428	39.90923	\N	\N	f	0571-87072869	t	330102	\N	\N	人工草皮	f	\N	1. 工作日：18:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：恶劣天气或学校重大活动暂停，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	1. 线上：浙里办 APP / 支付宝搜 “校园健身”，完成登记后预约，凭码 / 人脸 / 市民卡入校 2. 线下：携带市民卡 / 杭州通卡到学校或社区办理，支持刷卡 / 扫码 / 人脸识别入校	f	t	7人制	\N	\N	\N
152	杭州市第十中学足球场	football	330100	小营街道皮市巷 158 号	116.397428	39.90923	\N	\N	f	总机：0571-28900730；校办：0571-28900723（可转接体育组咨询足球场事宜）	t	330102	\N	\N	人工草皮	f	\N	1. 工作日：18:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	1. 线上：浙里办 APP / 支付宝搜索 “校园健身”，完成登记后预约，凭码 / 人脸 / 市民卡入校 2. 线下：携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	5人制	\N	\N	\N
153	杭州市抚宁巷小学足球场	football	330100	小营街道金狮苑 20 号	116.397428	39.90923	\N	\N	f	0571-86771180	t	330102	\N	\N	人工草皮	f	\N	1. 工作日：18:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	5人制	\N	\N	\N
154	杭州市惠兴中学足球场	football	330100	湖滨街道惠兴路 11 号	116.397428	39.90923	\N	\N	f	0571-87067545	t	330102	\N	\N	人工草皮	f	\N	1. 工作日：18:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	5人制	\N	\N	\N
155	杭州市江滨职业学校足球场	football	330100	复兴路 235 号	116.397428	39.90923	\N	\N	f	0571-86081750	t	330102	\N	\N	人工草皮	f	\N	1. 工作日：18:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	5人制	\N	\N	\N
156	杭州市江城中学足球场	football	330100	紫阳街道江城路 287 号	116.397428	39.90923	\N	\N	f	0571-86055873	t	330102	\N	\N	\N	f	\N	1. 工作日：18:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	5人制	\N	\N	\N
157	杭州市教育学院附属小学足球场	football	330100	复兴南苑 12 号（美政校区）	116.397428	39.90923	\N	\N	f	0571-86560816	t	330102	\N	\N	人工草皮	f	\N	1. 工作日：18:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	f	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	5人制	\N	\N	\N
158	杭州市开元中学足球场	football	330100	望江街道栖园弄 1 号	116.397428	39.90923	\N	\N	f	0571-86560816	t	330102	\N	\N	人工草皮	f	\N	1. 工作日：18:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	8人制	\N	\N	\N
159	杭州市清泰实验学校足球场（初中部）	football	330100	清波街道惠民路 5 号	116.397428	39.90923	\N	\N	f	0571-28130896	t	330102	\N	\N	人工草皮	f	\N	1. 工作日：18:00-21:00 2. 周末 / 节假日：7:00-11:00，17:00-21:00 3. 特殊情况：雷雨雪等恶劣天气或学校重大活动时暂停开放，以浙里办 “校园健身” 平台公告为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	携带杭州市民卡 / 杭州通卡到学校现场或所在社区办理，支持人脸识别、刷卡 / 扫码入校	f	t	5人制	\N	\N	\N
161	杭州市天长小学足球场（东坡路校区）	football	330100	东坡路 94 - 乙	116.397428	39.90923	\N	\N	f	\N	t	330102	\N	\N	人工草皮	f	\N	 7：00-11：00、13：00-17：00	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
162	杭州市天长小学足球场（孝女路校区）	football	330100	孝女路 4 号	116.397428	39.90923	\N	\N	f	\N	t	330102	\N	\N	人工草皮	f	\N	寒假6：00-10：00、17：00-21：00。	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
168	杭州第七中学足球场	football	330100	转塘街道环山路 1 号	116.397428	39.90923	\N	\N	f	学校总机：0571-87323540；咨询时段：工作日 8:00-17:00	t	330106	\N	\N	天然草皮	f	\N	参照西湖区 B 类学校标准（有住校生），公休日 / 节假日 / 寒暑假早 6:00-9:00、晚 18:00-21:00，具体以校方通知为准	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	11人制	\N	\N	\N
163	杭州市天长小学足球场（天长观潮小学）	football	330100	之江路与吟潮路交叉口附近	116.397428	39.90923	\N	\N	f	\N	t	330102	\N	\N	\N	f	\N	\N	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
164	杭州市娃哈哈小学足球场	football	330100	劳动路 95 号	116.397428	39.90923	\N	\N	f	\N	t	330102	\N	\N	\N	f	\N	寒假期间 7：00-11：00、14：00-18：00	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	t	\N	\N	\N	\N
165	杭州天地实验小学足球场	football	330100	望江街道徐家埠路 50 号	116.397428	39.90923	\N	\N	f	\N	t	330102	\N	\N	\N	f	\N	寒假期间： 5：30-9：30、18：00-22：00	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
166	杭州美院足球场	football	330100	中国美术学院象山校区内	116.397428	39.90923	\N	\N	f	\N	f	330102	\N	\N	\N	f	\N	\N	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
167	杭州东方中学足球	football	330100	留下街道小龙驹坞 655-1 号	116.397428	39.90923	\N	\N	f	学校总机：0571-28804937；咨询时段：工作日 8:00-17:00	t	330102	\N	\N	人工草皮	f	\N	校内日常：教学日 16:00-18:00（课后活动），周末 9:00-17:00（社团训练）；社会开放：2025 年寒假期间参照西湖区中小学场地开放标准，通常为早 6:00-9:00、晚 18:00-21:00，具体以校方通知为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	7人制	\N	\N	\N
169	杭州第七中学篮球场	basketball	330100	转塘街道环山路 1 号	116.397428	39.90923	\N	\N	f	学校总机：0571-87323540；咨询时段：工作日 8:00-17:00	t	330102	\N	\N	木地板、塑胶	f	\N	参照西湖区 B 类学校标准（有住校生），公休日 / 节假日 / 寒暑假早 6:00-9:00、晚 18:00-21:00，具体以校方通知为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
170	杭州市保俶塔实验学校足球场（本部）	football	330100	天目山路 81 号	116.397428	39.90923	\N	\N	f	\N	t	330106	\N	\N	\N	f	\N	\N	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
171	杭州市保俶塔实验学校足球场（申花路校区）	football	330100	竞舟北路 189 号	116.397428	39.90923	\N	\N	f	\N	t	330106	\N	\N	\N	f	\N	\N	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
172	杭州市城西天畅足球场	football	330100	西溪路 690 号布丁酒店对面	116.397428	39.90923	\N	\N	f	管理员电话：13588122576（常用）；备用咨询：13805765556（可预约包场、谈时段优惠）	t	330106	\N	\N	人工草皮	f	\N	通常晚上 6 点半到 10 点半每片球场可以安排两个场次，周末白天也可预约。不过具体开放时间可能会根据实际情况调整	t	t	2	t	t	\N	\N	\N	t	\N	\N	200	200	通常晚上 6 点半到 10 点半每片球场可以安排两个场次，周末白天也可预约。不过具体开放时间可能会根据实际情况调整	f	t	5人制	\N	\N	\N
173	杭州市翠苑二小足球场	football	330100	翠苑街道翠苑三区 165 号	116.397428	39.90923	\N	\N	f	学校总机：0571-87939504；办公室电话：0571-87939505；咨询时段：工作日 8:00-17:00	t	330106	\N	\N	人工草皮	f	\N	参照西湖区 B 类学校标准，公休日 / 节假日 / 寒暑假早 6:00-9:00、晚 18:00-21:00，具体以校方通知为准	t	t	\N	t	t	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	7人制	\N	\N	\N
174	杭州市第二中学足球场（东河校区）	football	330100	建国中路 36 号	116.397428	39.90923	\N	\N	\N	\N	t	330102	\N	\N	\N	f	\N	\N	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
175	杭州市翠苑中学足球场（翠苑校区）	football	330100	翠苑新村二区 37 幢	116.397428	39.90923	\N	\N	f	学校总机：0571-56878504；咨询时段：工作日 8:00-17:00（建议提前致电确认开放细节）	t	330106	\N	\N	人工草皮	f	\N	工作日早、晚各开放，每日累计约 3 小时；双休日、节假日、寒暑假每日开放约 6 小时，具体时段以校门口公示为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	\N	f	t	7人制	\N	\N	\N
176	杭州市翠苑中学足球场（文华校区）	football	330100	文新街道古墩路 580 号	116.397428	39.90923	\N	\N	f	学校总机：0571-56878515；咨询时段：工作日 8:00-17:00（建议提前致电确认开放细节）	t	330106	\N	\N	人工草皮	f	\N	公休日 / 节假日 / 寒暑假早 6:00-9:00、晚 18:00-21:00，工作日早、晚各开放，每日累计约 3 小时，具体以校门口公示为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	\N	f	t	7人制	\N	\N	\N
177	杭州市电子职校足球场（翠苑校区）	football	330100	翠苑街道翠苑四区 12 号	116.397428	39.90923	\N	\N	f	学校总机：0571-88853151；翠苑校区咨询电话：0571-88853637；咨询时段：工作日 8:00-17:00	t	330106	\N	\N	人工草皮	f	\N	公休日 / 节假日 / 寒暑假早 6:00-9:00、晚 18:00-21:00，工作日早、晚各开放，每日累计约 3 小时，具体以校门口公示为准	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	浙里办 APP / 杭州市民卡 APP：搜索 “校园健身”，完成实名认证，阅读《市民入校健身守则》，选择 “杭州市电子信息职业学校（翠苑校区）” 提交登记，可同时登记 3 所学校，支持 “一校登记，全区开放”。 西湖区专属入口：微信关注 “美丽西湖” 公众号，点击 “微服务”→“运动预约”，进入 “校园场馆” 选择该校登记；或支付宝搜索 “西湖文体” 完成预约。	f	t	7人制	\N	\N	\N
178	杭州市丰潭中学足球场	football	330100	古荡街道古荡新村西 81 号	116.397428	39.90923	\N	\N	f	0571-28879180；咨询时段：工作日 8:00-17:00（建议提前致电确认开放细节）	t	330106	\N	\N	人工草皮	f	\N	工作日早、晚各开放，每日累计约 3 小时；双休日、节假日、寒暑假每日开放约 6 小时，具体时段以校门口公示为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	登记成功后长期有效，开放时段内直接核验入校，无需每次单独预约	f	t	7人制	\N	\N	\N
179	杭州市九莲小学足球场	football	330100	文三路街道影业路 55 号	116.397428	39.90923	\N	\N	f	学校总机：0571-88933552；咨询时段：工作日 8:00-17:00（建议提前致电确认开放细节）	t	330106	\N	\N	人工草皮	f	\N	公休日 / 节假日 / 寒暑假早 6:00-9:00、晚 18:00-20:00，工作日早、晚各开放，每日累计约 3 小时，具体以校门口公示为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	浙里办 APP / 杭州市民卡 APP：搜索 “校园健身”，完成实名认证与《市民入校健身守则》签署，选择 “杭州市九莲小学” 提交登记；每人最多登记 3 所学校，支持 “一校登记，全区开放”jiangzhou.gov.cn。 西湖区专属入口：微信关注 “美丽西湖” 公众号→“微服务”→“运动预约”→“校园场馆” 选择该校登记；或支付宝搜索 “西湖文体” 完成预约	f	t	5人制	\N	\N	\N
180	杭州市留下小学足球场	football	330100	留下街道留下大街 2 号	116.397428	39.90923	\N	\N	\N	学校总机：0571-85229826；咨询时段：工作日 8:00-17:00（建议提前致电确认开放细节）	t	330106	\N	\N	人工草皮	f	\N	工作日早、晚各开放，每日累计约 3 小时；寒暑假（7-8 月）工作日（周一不开放）18:00-21:30，双休日 9:00-21:30，具体以校门口公示为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	浙里办 APP / 杭州市民卡 APP：搜索 “校园健身”，完成实名认证与《市民入校健身守则》签署，选择 “杭州市留下小学” 提交登记；每人最多登记 3 所学校，支持 “一校登记，全区开放”。 西湖区专属入口：微信关注 “美丽西湖” 公众号→“微服务”→“运动预约”→“校园场馆” 选择该校登记；或支付宝搜索 “西湖文体” 完成预约。	f	t	5人制	\N	\N	\N
186	杭州市三墩中学足球场	football	330100	三墩镇振华路 9 号	116.397428	39.90923	\N	\N	f	0571-88951447	t	330106	\N	\N	人工草皮	f	\N	其开放时间工作日每天不少于 3 小时，公休日、法定节假日、寒暑假每天不少于 8 小时。但具体开放时间还需以学校官方公布为准。	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	t	\N	\N	\N	\N
181	杭州市留下中学足球场（浙江工业大学附属实验）	football	330100	留下街道杨梅山路 26 号	116.397428	39.90923	\N	\N	f	学校总机：0571-85229826；咨询时段：工作日 8:00-17:00（建议提前致电确认开放细节）	t	330106	\N	\N	人工草皮	f	\N	工作日早 6:00-7:00、晚 18:00-21:00；双休日和节假日上午 7:00-11:00、下午 14:00-21:00，若与教学冲突则以校方通知为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	浙里办 APP / 杭州市民卡 APP：搜索 “校园健身”，完成实名认证与《市民入校健身守则》签署，选择 “浙江工业大学附属实验学校” 提交登记；每人最多登记 3 所学校，支持 “一校登记，全区开放”杭州市人民政府。 西湖区专属入口：微信关注 “美丽西湖” 公众号→“微服务”→“运动预约”→“校园场馆” 选择该校登记；或支付宝搜索 “西湖文体” 完成预约。	f	t	5人制	\N	\N	\N
182	杭州市求是教育集团足球场（竞舟小学）	football	330100	竞舟路 221 号	116.397428	39.90923	\N	\N	f	0571-28006978	f	330106	\N	\N	人工草皮	f	\N	目前没有明确信息显示其对社会公众开放，若有开放安排，通常会通过学校官网、公众号或社区公告等渠道发布。	t	t	\N	f	t	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
183	杭州市求是教育集团足球场（星洲小学）	football	330100	紫荆花路 288 号	116.397428	39.90923	\N	\N	f	0571-28802078	t	330106	\N	\N	\N	f	\N	暑假期间（7 月 1 日 - 8 月 31 日），工作日开放时间为 18：00-21：30，双休日为 9：00-21：30。非暑假期间的开放时间暂无公开信息，通常学校会根据实际情况调整，可关注学校官网或公众号获取最新消息。	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	\N	f	t	\N	\N	\N	\N
184	杭州市求是教育集团足球场（星洲小学）	football	330100	紫荆花路 288 号	116.397428	39.90923	\N	\N	f	0571-28802078	t	330106	\N	\N	人工草皮	f	\N	暑假期间（7 月 1 日 - 8 月 31 日），工作日开放时间为 18：00-21：30，双休日为 9：00-21：30。非暑假期间的开放时间暂无公开信息，通常学校会根据实际情况调整，可关注学校官网或公众号获取最新消息。	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	t	\N	\N	\N	\N
185	杭州市求是小学足球场（和家园校区）	football	330100	杨梅山路 261 号	116.397428	39.90923	\N	\N	f	0571-89583600	f	330106	\N	\N	\N	f	\N	\N	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
187	杭州市上泗中学足球场	football	330100	转塘街道沈横路 30 号	116.397428	39.90923	\N	\N	\N	学校总机：0571-87091960；咨询时段：工作日 8:00-17:00（建议提前致电确认开放细节）	t	330106	\N	\N	人工草皮	f	\N	工作日早 6:00-7:00、晚 18:00-21:00；双休日和节假日上午 7:00-11:00、下午 14:00-21:00，若与教学冲突则以校方通知为准	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	浙里办 APP / 杭州市民卡 APP：搜索 “校园健身”，完成实名认证与《市民入校健身守则》签署，选择 “杭州市上泗中学” 提交登记；每人最多登记 3 所学校，支持 “一校登记，全区开放”。 西湖区专属入口：微信关注 “美丽西湖” 公众号→“微服务”→“运动预约”→“校园场馆” 选择该校登记；或支付宝搜索 “西湖文体” 完成预约	f	t	5人制、7人制	\N	\N	\N
188	杭州市省府路小学足球场（秋水苑校区）	football	330100	莲花街 108 号	116.397428	39.90923	\N	\N	f	学校总机：0571-88980068；咨询时段：工作日 8:00-17:00（建议提前致电确认开放细节）	t	330106	\N	\N	人工草皮	f	\N	工作日不少于 3 小时，公休日 / 节假日 / 寒暑假不少于 8 小时；2023 年暑假（7.5-8.23）工作日 18:00-21:30，双休日 9:00-21:30，具体以校方最新通知为准杭州市西湖区人民政府	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	线上实名登记：浙里办 / 杭州市民卡 APP 搜 “校园健身”，完成实名认证与守则签署，选择该校登记；或微信 “美丽西湖”→“微服务”→“运动预约”→“校园场馆” 登记，支持 “一校登记，全区开放”。 线下核验：首次入校带市民卡 / 身份证完成人脸采集（一次采集全区通用）；日常开放时段刷脸、刷卡或刷 APP 二维码入校离校。	f	t	5人制、7人制	\N	\N	\N
189	杭州市十三中足球场（教工路校区，本部）	football	330100	教工路 155 号	116.397428	39.90923	\N	\N	f	学校总机：0571-88851237；咨询时段：工作日 8:00-17:00（建议提前致电确认开放细节）	t	330106	\N	\N	人工草皮	f	\N	工作日早 6:00-7:00、晚 18:00-21:00；双休日和节假日 7:00-11:00、14:00-21:00，若遇教学、赛事冲突则以校方通知为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	浙里办 APP / 杭州市民卡 APP：搜索 “校园健身”，完成实名认证与《市民入校健身守则》签署，选择 “杭州市十三中教育集团（总校）” 提交登记，支持 “一校登记，全区开放”。 微信关注 “美丽西湖” 公众号→“微服务”→“运动预约”→“校园场馆” 选择该校登记；或支付宝搜索 “西湖文体” 完成预约。	f	t	7人制、9人制	\N	\N	\N
190	杭州市万向职业技术学院足球场（1 号校区）	football	330100	西溪路 896 号	116.397428	39.90923	250	300	f	0571-87154000、0571-87171816，传真为 0571-87171806	t	330106	\N	\N	人工草皮	f	\N	\N	f	f	2	f	f	\N	\N	\N	t	\N	\N	250	600	\N	f	t	11人制、7人制	\N	\N	\N
191	杭州市万向职业技术学院足球场（2 号校区）	football	330100	花蒋路 3 号	116.397428	39.90923	\N	\N	\N	学院电话为 0571-87154000、0571-87171816，传真为 0571-87171806。	t	330106	\N	\N	\N	f	\N	\N	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
192	杭州市文三教育集团篮球场（文理小学校区）	football	330100	三墩镇嘉仁路 499 号	116.397428	39.90923	\N	\N	f	学校电话：0571-56890707；咨询时段：工作日 8:00-17:00（建议提前致电确认开放细节）	t	330106	\N	\N	人工草皮	f	\N	工作日 18:00-21:30，公休日 / 节假日 9:00-21:30（以校方最新通知为准，遇教学、赛事冲突可能调整）	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	浙里办 / 杭州市民卡 APP 搜 “校园健身” 完成认证与守则签署，选择该校登记；或微信 “美丽西湖”→“微服务”→“运动预约”→“校园场馆” 登记，支持 “一校登记，全区开放”。	f	t	\N	\N	\N	\N
193	杭州市文三教育集团足球场（文三街小学）	football	330100	上宁巷 3 号	116.397428	39.90923	\N	\N	f	0571-56890707	t	330106	\N	\N	\N	f	\N	作为公办小学，其室外体育场地应按照杭州市教育局的要求向社会开放，工作日每天不少于 3 小时，公休日、法定节假日、寒暑假每天不少于 8 小时	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
194	杭州市文一街小学足球场（文一校区） 	football	330100	保俶北路 88 号	116.397428	39.90923	\N	\N	\N	0571-88052812	t	330106	\N	\N	\N	f	\N	\N	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
195	杭州市文一街小学足球场（秀水校区）	football	330100	墩镇秀里街 306 号	116.397428	39.90923	\N	\N	f	0571-81023512	t	330106	\N	\N	人工草皮	f	\N	 7 月 20 日 - 8 月 31 日，工作日 18：00-21：30，双休日 9：00-21：30，日常开放时间可能会有变化，建议关注学校官方通知。	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
196	杭州市文一街小学足球场（政苑校区）	football	330100	墩镇政苑小区 73 幢 2 号	116.397428	39.90923	\N	\N	f	学校电话：0571-89969815；咨询时段：工作日 8:00-17:00（建议提前致电确认开放细节）	t	330106	\N	\N	人工草皮	f	\N	工作日 18:00-21:30，公休日 / 节假日 9:00-21:30（以校方最新通知为准，遇教学、赛事冲突可能调整，2023 年暑假曾因操场维修暂停开放）	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	浙里办 / 杭州市民卡 APP 搜 “校园健身” 完成认证与守则签署，选择该校登记；或微信 “美丽西湖”→“微服务”→“运动预约”→“校园场馆” 登记，支持 “一校登记，全区开放”。	f	t	\N	\N	\N	\N
197	杭州市西子湖小学足球场(九溪校区)	football	330100	之江路 40 号	116.397428	39.90923	\N	\N	f	学校电话：0571-86591220；咨询时段：工作日 8:00-17:00（建议提前致电确认开放与预约细节）杭州市西湖区人民政府	t	330106	\N	\N	人工草皮	f	\N	工作日 6:00-7:00、17:00-19:30；双休日 / 节假日 / 寒暑假 7:30-11:30、13:00-16:00（以校方最新通知为准，遇教学、赛事冲突可能调整）	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	线下登记：携带身份证 / 户口本 / 一年以上居住证到所在社区办理 “社区居民校园健身智能卡”。 入校核验：开放时段凭智能卡刷卡入校，遵守校园运动安全与场地管理规定。	f	t	5人制、7人制	\N	\N	\N
198	杭州市西子湖小学足球场(茅家埠校区)	football	330100	龙井路 76 号	116.397428	39.90923	\N	\N	f	\N	t	330106	\N	\N	人工草皮	f	\N	开放时间为周一至周五上午 6：00-7：00、下午 17：00-19：30，双休日、节假日、寒暑假为早上 7：30-11：30、下午 13：00-16：00，目前是否开放及具体开放时间可能有变化，建议联系学校确认。	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
199	杭州市小和山哇咔足球场	football	330100	杭州市西湖区高教大道支四路	116.397428	39.90923	300	400	f	15658032619（建议提前 1-3 天致电预约）	t	330106	\N	\N	人工草皮	f	\N	日常 9:00-23:00（节假日正常开放，雨天视场地排水情况调整，极端天气暂停开放）	f	f	4	f	f	\N	\N	\N	t	\N	\N	180	280	可通过 “哇咔星球” 服务号 / 小程序线上订场	f	t	5人制	\N	\N	\N
200	杭州市行知小学足球场（学院路校区）	football	330100	西湖区学院路行知巷 6 号	116.397428	39.90923	\N	\N	f	0571-88072230	t	330106	\N	\N	人工草皮	f	\N	工作日 18:00-21:30，公休日 / 节假日 9:00-21:30（以校方最新通知为准，遇教学、赛事冲突可能调整）	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	线上实名登记：浙里办 / 杭州市民卡 APP 搜 “校园健身” 完成认证与守则签署，选择该校登记；或微信 “美丽西湖”→“微服务”→“运动预约”→“校园场馆” 登记，支持 “一校登记，全区开放”。 线下核验：首次入校带市民卡 / 身份证完成人脸采集（一次采集全区通用）；日常开放时段刷脸、刷卡或刷 APP 二维码入校离校。	f	t	7人制	\N	\N	\N
201	杭州市行知小学足球场（行知二小）	football	330100	双龙街 378 号校园	116.397428	39.90923	\N	\N	\N	0571-88736566	t	330106	\N	\N	人工草皮	f	\N	工作日 18:00-21:30，公休日 / 节假日 9:00-21:30（以校方最新通知为准，遇教学、赛事冲突可能调整）	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	线上实名登记：浙里办 / 杭州市民卡 APP 搜 “校园健身” 完成认证与守则签署，选择该校登记；或微信 “美丽西湖”→“微服务”→“运动预约”→“校园场馆” 登记，支持 “一校登记，全区开放”。 线下核验：首次入校带市民卡 / 身份证完成人脸采集（一次采集全区通用）；日常开放时段刷脸、刷卡或刷 APP 二维码入校离校。	f	t	5人制	\N	\N	\N
202	杭州市学军小学足球场（求智校区）	football	330100	文二路求智巷 6 号校园操场区域	116.397428	39.90923	\N	\N	\N	学校总机：0571-88079561；咨询时段：工作日 8:00-17:00（建议提前致电确认开放与预约细节）	t	330106	\N	\N	人工草皮	f	\N	工作日 18:00-21:30，公休日 / 节假日 9:00-21:30（以校方最新通知为准，遇教学、赛事冲突可能调整）	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	线上实名登记：浙里办 / 杭州市民卡 APP 搜 “校园健身” 完成认证与守则签署，选择该校登记；或微信 “美丽西湖”→“微服务”→“运动预约”→“校园场馆” 登记，支持 “一校登记，全区开放”。 线下核验：首次入校带市民卡 / 身份证完成人脸采集（一次采集全区通用）；日常开放时段刷脸、刷卡或刷 APP 二维码入校离校。	f	t	7人制	\N	\N	\N
203	杭州市育才教育集团总校	football	330100	翠苑街道黄姑山横路 70 号校园内操场区域	116.397428	39.90923	\N	\N	f	\t学校总机：0571-88932117；咨询时段：工作日 8:00-17:00（建议提前致电确认开放与预约细节）	t	330106	\N	\N	人工草皮	f	\N	工作日 18:00-21:30，公休日 / 节假日 9:00-21:30（以校方最新通知为准，遇教学、赛事冲突可能调整）	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	线上实名登记：浙里办 / 杭州市民卡 APP 搜 “校园健身” 完成认证与守则签署，选择该校登记；或微信 “美丽西湖”→“微服务”→“运动预约”→“校园场馆” 登记，支持 “一校登记，全区开放”。 线下核验：首次入校带市民卡 / 身份证完成人脸采集（一次采集全区通用）；日常开放时段刷脸、刷卡或刷 APP 二维码入校离校。	f	t	7人制	\N	\N	\N
204	杭州市袁浦小学足球场	football	330100	双浦镇兰溪口村 1 号	116.397428	39.90923	\N	\N	f	0571-87644105	f	330106	\N	\N	人工草皮	f	\N	\N	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
205	杭州市长河高级中学足球场	football	330100	滨文路 227 号	116.397428	39.90923	\N	\N	\N	学校总机：0571-86604790；咨询时段：工作日 8:00-17:00（建议提前致电确认开放与预约细节）	t	330108	\N	\N	天然草皮	f	\N	工作日 18:00-21:30，公休日 / 节假日 9:00-21:30（以校方最新通知为准，遇教学、赛事冲突可能调整）	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	线上实名登记：浙里办 / 杭州市民卡 APP 搜 “校园健身” 完成认证与守则签署，选择该校登记；或微信 “滨江发布”→“微服务”→“运动预约”→“校园场馆” 登记，支持 “一校登记，全区开放”。 线下核验：首次入校带市民卡 / 身份证完成人脸采集（一次采集全区通用）；日常开放时段刷脸、刷卡或刷 APP 二维码入校离校。	f	t	11人制	\N	\N	\N
206	杭州市长桥小学足球场	football	330100	南山路 64 号	116.397428	39.90923	\N	\N	f	\N	f	330106	\N	\N	人工草皮	f	\N	\N	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
207	杭州市转塘小学足球场（方家路校区）	football	330100	转塘街道方家畈社区 244 号	116.397428	39.90923	\N	\N	f	\N	t	330106	\N	\N	人工草皮	f	\N	开放时间为工作日每天不少于 3 小时，公休日、法定节假日、寒暑假每天不少于 8 小时。	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	7人制	\N	\N	\N
208	杭州杭州汽车高级技工学校足球场	football	330100	莫干山路 558 号	116.397428	39.90923	\N	\N	f	学校电话：0571-88198160；咨询时段：工作日 8:00-17:00	t	330105	\N	\N	人工草皮	f	\N	工作日 18:00-21:00，公休日 / 节假日 9:00-21:00（以校方通知为准）	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	线上实名登记：浙里办 / 杭州市民卡 APP 搜 “校园健身” 完成认证，选择对应学校登记。 线下核验：首次入校带市民卡 / 身份证完成人脸采集，日常刷脸、刷卡或 APP 二维码入校离校。	f	t	7人制	\N	\N	\N
209	杭州市交通职业高级中学（新校区）足球场	football	330100	笕桥板块	116.397428	39.90923	\N	\N	f	学校总机：0571-86467589（建议工作日 8:00-17:00 致电确认）	t	330106	\N	\N	人工草皮	f	\N	工作日 18:00-21:30，公休日 / 节假日 9:00-21:30（以校方通知为准）	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	线上实名登记：浙里办 / 杭州市民卡 APP 搜 “校园健身” 完成认证，选择对应学校登记。 线下核验：首次入校带市民卡 / 身份证完成人脸采集，日常刷脸、刷卡或 APP 二维码入校离校。	f	t	11人制	\N	\N	\N
244	宝山区通河第三小学	football	310000	通河路 345 号	116.397428	39.90923	\N	\N	f	021-56756859	f	310113	\N	\N	人工草皮	f	\N	\N	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
210	浙江工业大学继续教育学院西溪分院足球场	football	330100	西溪路 705 号	116.397428	39.90923	\N	\N	f	总机：0571-85225135；咨询时段：工作日 8:00-17:00（建议提前致电确认开放与预约）	t	330106	\N	\N	人工草皮	f	\N	工作日 18:00-21:30，公休日 / 节假日 9:00-21:30（遇教学、赛事冲突可能调整，以校方通知为准）	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	线上实名登记：浙里办 / 杭州市民卡 APP 搜 “校园健身” 完成认证与守则签署，选择对应场地登记。 线下核验：首次入校携带市民卡 / 身份证完成人脸采集，日常开放时段刷脸、刷卡或 APP 二维码进出。	f	t	\N	\N	\N	\N
211	西溪锋尚八号球场	football	330100	文三西路西溪锋尚苑 3 号楼 3 楼	116.397428	39.90923	\N	\N	f	18057105220	t	330106	\N	\N	\N	t	\N	通常晚上开放时间为 6 点半到 10 点半，白天也可预约，具体以实际为准	t	t	\N	t	t	\N	\N	\N	t	\N	\N	\N	\N	\N	t	f	5人制	\N	\N	\N
212	西溪天畅足球场	football	330100	西溪路 690 号（布丁酒店对面，紫金港路与西溪路交叉口附近，近汽车西站）	116.397428	39.90923	\N	\N	f	暂无公开固定电话，建议通过大众点评、美团等平台搜索 “西溪天畅足球场” 获取预订联系方式	t	330106	\N	\N	\N	f	\N	日常开放时段多为 8:00-22:00	t	t	2	t	t	\N	\N	\N	t	\N	\N	\N	\N	\N	f	f	5人制	\N	\N	\N
213	西溪・八方城文体公园足球场	football	330100	余杭区五常大道与荆长大道交汇处	116.397428	39.90923	\N	\N	\N	\N	t	330110	\N	\N	人工草皮	f	\N	\N	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
214	西湖区文体中心足球馆	football	330100	晴川街 217 号	116.397428	39.90923	\N	\N	\N	0571-87170525	t	330106	\N	\N	人工草皮	f	\N	全年 9:00-22:00（节假日无休，遇赛事、包场或维护可能调整，以官方通知为准）	t	t	2	t	t	\N	\N	\N	t	\N	\N	\N	\N	预约平台：浙里办 / 杭州市民卡 APP “校园健身” 或中心官微（建议提前致电确认场次）	f	t	5人制、7人制	\N	\N	\N
215	浙江大学紫金港校区足球场	football	330100	余杭塘路 866 号	116.397428	39.90923	\N	\N	f	 0571-88399346， 0571-87951111	t	330106	\N	\N	人工草皮、天然草皮	f	\N	塑胶跑道足球场（含足球场）开放时间为周一至周日 7：30-11：30、13：30-17：30、17：30-21：30，周一至周五中午时段仅对课程开放，暑假期间开放时间为 7：30-21：30。五人制足球场开放时间为周一至周日 7：30-10：30、13：30-16：30、18：00-21：00	f	f	5	f	f	\N	\N	\N	t	\N	\N	\N	\N	支付宝搜索 “浙大通”，或通过浙江大学微信公众号 “访客服务”-“公众预约” 提前 1 天预约进校，凭身份证或 “浙大通” 码步行入校（机动车禁入）。 7 人及以上团队预约，需联系浙大访客中心（0571-88982700）。	f	t	\N	\N	\N	\N
216	浙江大学足球场（西溪校区）	football	330100	天目山路 148 号	116.397428	39.90923	\N	\N	f	\N	f	330106	\N	\N	人工草皮	f	\N	周一至周日 8：00-18：00	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
217	浙江科技学院足球场（小和山校区）	football	330100	留和路 318 号	116.397428	39.90923	\N	\N	\N	\N	t	330106	\N	\N	\N	f	\N	除体育部提前公告活动外，足球场日间开放，夜间不开灯	t	t	1	t	t	\N	\N	\N	t	\N	\N	\N	\N	可通过 “浙科体育” 公众号场地预约或学校钉钉 “体育场馆预约” 进行预约	f	t	\N	\N	\N	\N
218	浙江省杭州学军中学足球场	football	330100	余杭塘路 866 号	116.397428	39.90923	\N	\N	f	学校总机 0571-88905978；体育组咨询可联系校区教务处 0571-88905980（工作日 8:00-17:00）	f	330106	\N	\N	人工草皮	f	\N	\N	f	f	\N	f	f	\N	\N	\N	f	\N	\N	\N	\N	原则上不对外开放，仅承接官方赛事或合作训练，需提前对接学校体育组，费用一事一议。	f	t	11人制	\N	\N	\N
219	杭州高级中学足球场（钱塘学校）	football	330100	义蓬街道	116.397428	39.90923	\N	\N	f	总机：0571-85153008（工作日 8：00-17：00）。 体育组咨询：0571-85153020（对接场地使用与预约）	f	330114	\N	\N	人工草皮	f	\N	\N	f	f	3	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	5人制、11人制	\N	\N	\N
221	杭州高级中学足球场（钱江校区）	football	330100	之江东路 1958 号	116.397428	39.90923	\N	\N	f	总机：0571-85153008（工作日 8：00-17：00）。 体育组咨询：0571-85153020（对接场地使用与预约）	f	330102	\N	\N	\N	f	\N	\N	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	11人制	\N	\N	\N
222	杭州市北景园景成实验学校足球场	football	330100	北景园回龙路 266 号	116.397428	39.90923	\N	\N	f	\N	t	330105	\N	\N	人工草皮	f	\N	工作日开放时间不少于 3 小时，公休日、法定节假日、寒暑假每天不少于 8 小时	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	\N	\N	\N	\N
223	杭州市朝晖中学足球场（朝晖校区)	football	330100	朝晖街道朝晖三区 3 号	116.397428	39.90923	\N	\N	f	学校总机：0571-85337053（工作日 8：00-17：00）。 体育组咨询：0571-85337053 转 8012（对接场地使用与预约）。	t	330105	\N	\N	\N	f	\N	提前 7 个工作日向体育组提交书面申请（含活动方案、人数、保险证明），审批后专人对接；团队需提前 3 天通过相关平台预约入校	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	原则上不对外开放，仅承接官方赛事或合作训练，需提前对接体育组，费用一事一议。	f	t	11人制	\N	\N	\N
220	杭州高级中学足球场（贡院校区）	football	330100	凤起路 238 号	116.397428	39.90923	\N	\N	f	\N	f	330105	\N	\N	人工草皮	f	\N	\N	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	11人制	\N	\N	\N
224	杭州市大成实验学校足球场	football	330100	三里亭路 155 号	116.397428	39.90923	\N	\N	f	学校总机：0571-86415252（工作日 8：00-17：00） 初中部咨询：0571-85837732（对接场地使用与预约）	t	330105	\N	\N	人工草皮	f	\N	A 类开放学校，工作日早、晚合计开放不少于 3 小时，公休日、法定节假日、寒暑假每天开放不少于 8 小时，具体时段以学校门口公示为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	校外人员需在支付宝或浙里办 APP 搜索 “校园健身” 或 “亚运场馆在线” 登记预约，凭市民卡或居住证刷卡入校。	f	t	11人制	\N	\N	\N
225	杭州市第十四中学足球场（凤起校区）	football	330100	凤起路 580 号	116.397428	39.90923	\N	\N	f	0571-85151909	t	330105	\N	\N	人工草皮	f	\N	8：00-11：30、14：00-17：30	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	校外人员需提前 7 个工作日向体育组提交书面申请（含活动方案、人数、保险证明），审批后专人对接，入校需登记	f	t	11人制	\N	\N	\N
226	杭州市第十四中学足球场（康桥校区）	football	330100	龙腾街 500 号	116.397428	39.90923	\N	\N	f	0571-56070000	t	330105	\N	\N	人工草皮	f	\N	6：30-7：30、16：30-19：00	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	校外人员需提前 7 个工作日向体育组提交书面申请（含活动方案、人数、保险证明），审批后专人对接，入校需登记。	f	t	11人制	\N	\N	\N
227	杭州市东园小学足球场（东园校区）	football	330100	潮鸣街道东园巷 397 号	116.397428	39.90923	\N	\N	f	学校总机：0571-85188332（工作日 8：00-17：00）	t	330105	\N	\N	人工草皮	f	\N	A 类开放学校，工作日早、晚合计开放不少于 3 小时，公休日、法定节假日、寒暑假每天开放不少于 8 小时，具体时段以学校门口公示为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	需通过 “校园健身” 或 “亚运场馆在线” 预约，无额外收费	f	t	5人制	\N	\N	\N
228	杭州市东园小学足球场（树园校区）	football	330100	鸣街道东园巷 397 号	116.397428	39.90923	\N	\N	f	学校总机：0571-85188332（工作日 8：00-17：00）	t	330105	\N	\N	人工草皮	f	\N	A 类开放学校，工作日早、晚合计开放不少于 3 小时，公休日、法定节假日、寒暑假每天开放不少于 8 小时，具体时段以学校门口公示为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	校外人员需在支付宝或浙里办 APP 搜索 “校园健身” 或 “亚运场馆在线” 登记预约，凭市民卡或居住证刷卡入校。	f	t	5人制	\N	\N	\N
229	杭州市开元商贸职高足球场（流水苑校区）	football	330100	绍兴支路 29 号	116.397428	39.90923	\N	\N	f	0571-85452472（流水苑校区，工作日 8：00-17：00）杭州市教育局	t	330105	\N	\N	人工草皮	f	\N	A 类开放学校，工作日早、晚合计开放不少于 3 小时，公休日、法定节假日、寒暑假每天开放不少于 8 小时，具体时段以学校门口公示为准	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	室外场地免费向社会开放，需通过 “校园健身” 或 “亚运场馆在线” 预约，无额外收费	f	t	7人制	\N	\N	\N
230	杭州市开元商贸职高足球场（施家桥校区）	football	330100	朝晖路 169 号	116.397428	39.90923	\N	\N	f	0571-85452472	t	330105	\N	\N	人工草皮	f	\N	A 类开放学校，工作日早、晚合计开放不少于 3 小时，公休日、法定节假日、寒暑假每天开放不少于 8 小时，具体时段以学校门口公示为准	f	f	1	f	f	\N	\N	\N	f	\N	\N	\N	\N	校外人员需在支付宝或浙里办 APP 搜索 “校园健身” 或 “亚运场馆在线” 登记预约，凭市民卡或居住证刷卡入校	f	t	7人制	\N	\N	\N
231	杭州市青春中学足球场	football	330100	潮鸣街道刀茅巷 167 号	116.397428	39.90923	\N	\N	f	0571-58102510	t	330105	\N	\N	\N	f	\N	A 类开放学校，工作日早、晚合计开放不少于 3 小时，公休日、法定节假日、寒暑假每天开放不少于 8 小时，具体时段以学校门口公示为准。	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	校外人员需在支付宝或浙里办 APP 搜索 “校园健身” 或 “亚运场馆在线” 登记预约，凭市民卡或居住证刷卡入校。	f	t	5人制	\N	\N	\N
232	杭州市求知小学足球场（求知校区）	football	330100	石桥街道康宁街 36 号	116.397428	39.90923	\N	\N	f	0571-88094075、0571-88091475（工作日 8：00-17：00）	t	330105	\N	\N	人工草皮	f	\N	A 类开放学校，工作日早、晚合计开放不少于 3 小时，公休日、法定节假日、寒暑假每天开放不少于 8 小时，具体时段以学校门口公示为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	校外人员需在支付宝或浙里办 APP 搜索 “校园健身” 或 “亚运场馆在线” 登记预约，凭市民卡或居住证刷卡入校。	f	t	7人制	\N	\N	\N
233	杭州市人民职业学校足球场	football	330100	回龙庙前 32-1 号	116.397428	39.90923	\N	\N	f	0571-87295246（工作日 8：00-17：00）	t	330105	\N	\N	人工草皮	f	\N	A 类开放学校，工作日早、晚合计开放不少于 3 小时，公休日、法定节假日、寒暑假每天开放不少于 8 小时，具体时段以学校门口公示为准。	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	校外人员需在支付宝或浙里办 APP 搜索 “校园健身” 或 “亚运场馆在线” 登记预约，凭市民卡或居住证刷卡入校。	f	t	5人制	\N	\N	\N
234	杭州市长青小学足球场（三塘校区）	football	330100	东新街道绿柳巷 100 号	116.397428	39.90923	\N	\N	f	0571-28868350（工作日 8：00-17：00）	t	330105	\N	\N	人工草皮	f	\N	A 类开放学校，工作日早、晚合计开放不少于 3 小时，公休日、法定节假日、寒暑假每天开放不少于 8 小时，具体时段以学校门口公示为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	室外场地免费向社会开放，需通过 “校园健身” 或 “亚运场馆在线” 预约，无额外收费	f	t	5人制	\N	\N	\N
235	杭州市长青小学足球场（长青校区）	football	330100	东新街道再行路 211 号	116.397428	39.90923	\N	\N	f	0571-28868352	t	330105	\N	\N	人工草皮	f	\N	A 类开放学校，工作日早、晚合计开放不少于 3 小时，公休日、法定节假日、寒暑假每天开放不少于 8 小时，具体时段以学校门口公示为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	室外场地免费向社会开放，需通过 “校园健身” 或 “亚运场馆在线” 预约，无额外收费	f	t	5人制	\N	\N	\N
236	杭州计量大学足球场	football	330100	学源街 258 号	116.397428	39.90923	\N	\N	f	学校总机：0571-86836060（工作日 8：00-17：00）。 体育军事部：0571-86836060 转体育军事部（对接场地预约与使用）	t	330114	\N	\N	人工草皮	f	\N	工作日早、晚合计开放不少于 3 小时，公休日、法定节假日、寒暑假每天开放不少于 8 小时，具体以学校公示为准。	t	t	4	t	t	\N	\N	\N	f	\N	\N	\N	\N	室外场地免费向社会开放，需通过 “校园健身” 或 “亚运场馆在线” 预约，无额外收费	f	t	5人制、11人制	\N	\N	\N
237	杭州市临平新天地足球场	football	330100	新天地文创园内	116.397428	39.90923	\N	\N	\N	\N	t	330113	\N	\N	人工草皮	f	\N	\N	f	t	\N	t	t	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	5人制	\N	\N	\N
238	杭州市临平月欣花苑足球场	football	330100	月荷路 149 号月欣花苑小区内	116.397428	39.90923	\N	\N	f	\N	t	330113	\N	\N	人工草皮	f	\N	日常全天开放（无明确时段限制），以小区场地实际开放情况为准，夜间照明开放至 21：00 左右（具体以物业公示为准）	t	t	2	t	t	\N	\N	\N	f	\N	\N	\N	\N	\N	f	f	5人制	\N	\N	\N
239	杭州市乔司中学足球场	football	330100	乔司街道永玄路 135 号	116.397428	39.90923	\N	\N	f	0571-86291688	t	330113	\N	\N	人工草皮	f	\N	A 类开放学校，工作日早、晚合计开放不少于 3 小时，公休日、法定节假日、寒暑假每天开放不少于 8 小时，具体时段以学校门口公示为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	校外人员需在支付宝或浙里办 APP 搜索 “校园健身” 或 “亚运场馆在线” 登记预约，凭市民卡或居住证刷卡入校。	f	t	11人制	\N	\N	\N
240	文昌中学足球场	football	330100	余杭街道太炎路 67 号	116.397428	39.90923	\N	\N	f	0571-89055866、0571-88650408	t	330110	\N	\N	人工草皮	f	\N	B 类开放学校，公休日、法定节假日、寒暑假每天开放不少于 8 小时，工作日开放不少于 3 小时，具体以学校公示为准	t	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	校外人员在支付宝 / 浙里办 APP 搜索 “校园健身” 或 “亚运场馆在线” 登记预约，凭市民卡 / 居住证刷卡入校。	f	t	11人制	\N	\N	\N
241	上海森兰无界公园足球场	football	310000	张杨北路 2700 号	116.397428	39.90923	\N	\N	f	17501654520	t	310115	\N	\N	人工草皮	f	\N	周一至周五 10：00-22：00，周末 8：00-22：00	t	t	2	t	t	\N	\N	\N	t	\N	\N	\N	\N	可尝试通过 “森兰汇” 小程序进行预约	t	t	7人制、11人制	7 人制人工草坪足球场每场 1000 元（2 小时），会员价 850 元；三片 5 人制人工草坪足球场每场 500 元（2 小时），会员价 360 元	周中散场白天 25 元 / 人，晚上 30 元 / 人；周末散场 35 元 / 人，或 350 元 / 两小时。	周中包场 350 元 / 两小时，晚上 400 元 / 两小时；周末包场 450 元 / 两小时。
242	上海森兰无界能量场足球场	football	310000	高西路与坤逸路交叉口	116.397428	39.90923	\N	\N	f	13651943829	t	310115	\N	\N	\N	f	\N	周一至周五 10:00-22:00，周末 8:00-22:00	t	t	\N	t	t	\N	\N	\N	t	\N	\N	\N	\N	通过 “森兰汇” 小程序预约，部分免费场次需提前报名并按限额入场。	t	t	\N	7 人制人工草坪足球场每场 1000 元（2 小时），会员价 850 元；三片 5 人制人工草坪足球场每场 500 元（2 小时），会员价 360 元	周中散场白天 25 元 / 人，晚上 30 元 / 人；周末散场 35 元 / 人，或 350 元 / 两小时。	周中包场 350 元 / 两小时，晚上 400 元 / 两小时；周末包场 450 元 / 两小时。
243	上海森兰绿洲公园足球场	football	310000	兰谷路 333 号森兰绿洲公园内	116.397428	39.90923	\N	\N	\N	13311767170	t	310115	\N	\N	人工草皮	f	\N	公园绿地区域每日 5：00-21：00 免费开放，足球场需预约使用，部分时段免费，具体以公园现场告示为准。	t	t	4	t	t	\N	\N	\N	f	\N	\N	\N	\N	运动场地实施网上预约制，可通过森兰绿地相关小程序或平台进行预约	f	t	5人制	\N	\N	\N
245	宝山体育中心足球场	football	310000	永清路 700 号	116.397428	39.90923	\N	\N	\N	总机 021-56122330	t	310113	\N	\N	\N	f	\N	\N	f	f	1	f	f	\N	\N	\N	t	\N	\N	\N	\N	\N	f	f	5人制	7:00-9:00 免费；其余时段按场收费，具体价格可电话咨询或参考现场公示	\N	9:00-18:00\t200\t300\t日间场 18:00-20:00\t300\t300\t夜间场（高杆灯照明）
246	宝山万科四季花城足球场	football	310000	杨行镇杨泰路 1169 弄	116.397428	39.90923	\N	\N	f	021-66760999	t	310113	\N	\N	人工草皮	f	\N	日常 6:00-21:00，雨雪天气或维护日可能临时关闭，以万科物业公告为准	f	t	1	t	t	\N	\N	\N	f	\N	\N	\N	\N	业主到物业前台登记即可使用；外来人员需提前 1 天致电物业申请，现场核验登记入场，高峰时段建议错峰。	f	t	5人制	\N	\N	\N
247	大场体育场足球场	football	310000	大场镇少年村路 2 号（近沪太路）	116.397428	39.90923	\N	\N	f	021-66501616	t	310113	\N	\N	\N	f	\N	日常 06:00-17:00，以场馆公告为准，特殊天气可能临时关闭	f	t	4	t	f	\N	\N	\N	f	\N	\N	\N	\N	\N	f	t	7人制	学生凭学生证 40 元 / 小时；非学生 60 元 / 小时	\N	\N
\.


--
-- Data for Name: venue_image; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.venue_image (id, "venueId", "userId", url, sort) FROM stdin;
2	1	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1767094032783-fbf75aa59f06ea4c.jpg	0
3	7	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1767355377225-invt8lnir_large.jpg	0
4	7	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1767355378030-0eqp276k2_large.jpg	0
5	8	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1767525301727-roztm0a6p_large.jpg	0
6	8	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1767525301980-lke93uosd_large.jpg	0
7	9	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1767698845365-ktit3qzxo_large.jpg	0
8	10	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1767867441529-8svvg0lar_large.jpg	0
9	10	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1767867449013-u63kfv23z_large.jpg	0
10	11	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1767871682131-bvklhpust_large.jpg	0
13	11	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1767871763406-d7kpe8xtt_large.jpg	0
15	12	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768026414517-2sqa9ukoo_large.jpg	0
16	12	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768026469478-685vjc6sj_large.jpg	0
17	13	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768026760288-lgx3qgjwd_large.jpg	0
18	14	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768027327542-gu8rtyfnb_large.jpg	0
19	15	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768033896197-ks4kdyy59_large.jpg	0
20	16	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768036821279-gwhisoyny_large.jpg	0
21	17	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768219447026-b8mdtbd19_large.jpg	0
22	17	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768219447312-gwaage9dj_large.jpg	0
23	17	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768219447116-tg953p7x0_large.jpg	0
24	17	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768219447248-4rqse53uh_large.jpg	0
25	17	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768219446916-vrezdttg1_large.jpg	0
26	18	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768219831662-igznltktc_large.jpg	0
27	19	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768220167350-h0arpuc6j_large.jpg	0
28	20	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768220511886-5duobyw8n_large.jpg	0
29	21	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768221034780-w6f9g339l_large.jpg	0
30	22	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768221469824-hx6u1gq3z_large.jpg	0
31	22	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768221470129-72jjel076_large.jpg	0
32	22	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768221471169-ue6rbl0j4_large.jpg	0
33	22	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768221471453-18rkt9jyx_large.jpg	0
35	25	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768387169371-sqm9bsq76_large.jpg	0
36	25	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768387181178-qchkpa7rk_large.jpg	0
37	25	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768387197438-et0wymuyl_large.jpg	0
38	27	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768732191387-71jmh76aw_large.jpg	0
39	28	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768732640314-kcj84hepb_large.jpg	0
40	28	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768732640357-g9habke4f_large.jpg	0
41	28	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768732640115-eubz385jw_large.jpg	0
42	29	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768733165093-mj78t3mp7_large.jpg	0
43	29	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768733165326-vlbx5lvym_large.jpg	0
44	29	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768733165165-6irnkczpd_large.jpg	0
45	30	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768733339279-wct9gzojs_large.jpg	0
46	30	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768733339879-qteswux8h_large.jpg	0
47	30	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768733340020-7j0ofvv2i_large.jpg	0
48	30	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768733340846-z1s30wk1z_large.jpg	0
49	30	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768733340137-yhru17xlt_large.jpg	0
50	31	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768733713190-ejmrox0di_large.jpg	0
51	31	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768733713230-51l86ky87_large.jpg	0
52	31	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768733713267-x3hgkc3u8_large.jpg	0
53	32	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768733992810-jr4dnyacb_large.jpg	0
54	32	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768733992763-ebkpy8kfi_large.jpg	0
55	32	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768733993328-hhi5ojcn7_large.jpg	0
56	32	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768733993356-ms2i6l2dv_large.jpg	0
57	32	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768733992564-3bkmcv0me_large.jpg	0
58	32	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768733993371-mi8j8t5qk_large.jpg	0
59	33	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768734287759-frekcteat_large.jpg	0
60	33	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768734287452-0djw7nwpf_large.jpg	0
61	34	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768734450372-fwg3yrgot_large.jpg	0
62	35	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768734850831-u50y6jzix_large.jpg	0
63	35	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768734851034-5sbo37egs_large.jpg	0
64	35	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768734851087-612iip11p_large.jpg	0
65	35	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768734850872-4fzq0ck8t_large.jpg	0
66	36	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768735031754-9zypf8uaj_large.jpg	0
67	36	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768735031954-bvtf7425x_large.jpg	0
68	36	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768735032396-ikoyyt39t_large.jpg	0
69	37	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768735182000-a5yv2dcaw_large.jpg	0
70	37	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768735182058-lmft4sze9_large.jpg	0
71	37	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768735182168-uxv7kxopn_large.jpg	0
72	38	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768737196308-uxjat70c0_large.jpg	0
73	38	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768737196555-moztye7qg_large.jpg	0
74	39	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768737463643-6v0wcakq9_large.jpg	0
75	39	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768737464487-ltlwcr0dh_large.jpg	0
76	40	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768737615411-y29sjoq1k_large.jpg	0
77	41	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768737785240-9lwigywnt_large.jpg	0
78	41	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768737785040-0kp487zsq_large.jpg	0
79	41	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768737785659-1bem6ushl_large.jpg	0
80	41	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768737785547-k1qpco98n_large.jpg	0
81	41	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768737785571-zmdbx4yme_large.jpg	0
82	43	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768738271923-nv2tpoy67_large.jpg	0
83	43	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768738271407-z1xglsng3_large.jpg	0
84	43	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768738272232-e9ptk1s4k_large.jpg	0
85	43	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768738274233-l8z1xnxdx_large.jpg	0
86	43	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768738274004-7abxuumfv_large.jpg	0
87	43	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768738274556-b973h99hk_large.jpg	0
88	43	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768738274956-zf7onvqbd_large.jpg	0
89	44	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768738478212-d3cjki3d3_large.jpg	0
90	44	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768738478446-ry72cmc83_large.jpg	0
91	44	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768738478161-a8bzdokot_large.jpg	0
93	45	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768738583437-4glvouqiy_large.jpg	0
94	45	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768738583438-n3o88c8os_large.jpg	0
95	45	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768738583709-ejlgzygq7_large.jpg	0
96	45	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768738583528-ab9roqyn9_large.jpg	0
97	45	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768738583678-3jlnic88p_large.jpg	0
98	46	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768907409282-tbhzn4il2_large.jpg	0
99	47	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768908121358-5rdghg5ih_large.jpg	0
100	48	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768911891511-aiq6git0d_large.jpg	0
101	49	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768915646376-hmjp263zj_large.jpg	0
102	49	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768915672457-6oy7wpgao_large.jpg	0
103	49	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768915684105-5zlffooo1_large.jpg	0
104	50	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768916180175-5fno851es_large.jpg	0
105	50	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768916180431-0bjea04nf_large.jpg	0
106	50	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768916180824-4cr1piq4w_large.jpg	0
107	50	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768916180498-mk6v7546c_large.jpg	0
108	50	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768916180462-cj97pmlma_large.jpg	0
109	51	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768924117103-a5xt1vwau_large.jpg	0
110	51	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768924117707-uvqckxns5_large.jpg	0
111	52	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768991595163-sf3pk43qo_large.jpg	0
112	52	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768991594947-d3w1c45iv_large.jpg	0
113	52	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768991595256-l51pg1ppn_large.jpg	0
114	53	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768992079573-zy1mun78w_large.jpg	0
115	53	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768992078871-vzckb49va_large.jpg	0
116	54	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768992340734-8idzq2spg_large.jpg	0
117	55	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768992483806-4e6r1dl1h_large.jpg	0
118	55	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768992483602-6ewo86sny_large.jpg	0
119	56	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768992618782-l31lxnlkn_large.jpg	0
120	56	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768992618724-lzzwmdo12_large.jpg	0
121	56	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768992618956-mwfo18a7c_large.jpg	0
122	57	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768993052401-2punuzzgd_large.jpg	0
123	57	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768993052790-rfchyovzi_large.jpg	0
124	57	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768993052761-gq5vye7op_large.jpg	0
125	57	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768993054230-a13n7z4hj_large.jpg	0
126	57	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768993064220-zbhd27imb_large.jpg	0
127	58	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768993500339-ktg4ir4qu_large.jpg	0
128	58	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768993500966-3878y773f_large.jpg	0
129	59	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768993653255-x36uh8wzx_large.jpg	0
130	60	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768994034666-bna4ajucg_large.jpg	0
131	60	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768994034571-uza1rrzhi_large.jpg	0
132	60	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768994034530-llg63ipai_large.jpg	0
133	60	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768994035408-jt6gh5aqn_large.jpg	0
134	60	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1768994035664-tartehhht_large.jpg	0
135	61	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769078578993-c336zlo3m_large.jpg	0
136	62	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769078786379-u09ewtzzx_large.jpg	0
137	62	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769078786566-yc506v74x_large.jpg	0
138	63	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769079010849-gw3eqlub6_large.jpg	0
139	64	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769079355650-kkio782dm_large.jpg	0
140	64	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769079355547-8ba8tddem_large.jpg	0
141	64	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769079355662-z1dwo0hlo_large.jpg	0
142	64	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769079355723-bvhsj2l7f_large.jpg	0
143	65	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769079818752-dfpse7u8d_large.jpg	0
144	65	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769079818552-mqt839brf_large.jpg	0
145	66	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769080001117-suir5mcvd_large.jpg	0
146	66	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769080001293-62kqpfvhx_large.jpg	0
147	66	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769080001692-txux17l8e_large.jpg	0
148	66	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769080001243-xq31p0i1m_large.jpg	0
149	66	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769080001034-19g2tn5tc_large.jpg	0
150	66	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769080001663-ko8expiaz_large.jpg	0
151	66	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769080001687-8fwz5935k_large.jpg	0
152	67	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769080241773-zx4zfp6md_large.jpg	0
153	67	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769080241774-53bm5e9lj_large.jpg	0
154	67	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769080241679-79to34xni_large.jpg	0
155	68	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769080753539-s91buhx7d_large.jpg	0
156	68	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769080753742-exed1blv6_large.jpg	0
157	69	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769080910516-z38ysqnne_large.jpg	0
158	69	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769080910672-lqjl9vfmw_large.jpg	0
159	69	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769080911093-ceep69h29_large.jpg	0
160	70	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769081184118-judrp17be_large.jpg	0
161	70	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769081184261-wqoxdjznf_large.jpg	0
162	70	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769081184311-x6k1mmuk2_large.jpg	0
163	71	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769081483049-q3u1ta76w_large.jpg	0
164	71	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769081482884-un27y3yaq_large.jpg	0
165	71	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769081482941-9x45wase6_large.jpg	0
166	71	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769081483071-ozggtnn8f_large.jpg	0
167	72	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769082243902-dn4v31cs2_large.jpg	0
169	72	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769082465379-4ndx6y88v_large.jpg	0
170	72	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769082474470-k953dapv3_large.jpg	0
171	73	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769082792816-9mv75zzzk_large.jpg	0
172	73	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769082792964-wact5thrg_large.jpg	0
173	73	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769082792897-70bwgd6so_large.jpg	0
174	73	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769082792751-dngcj9apf_large.jpg	0
175	74	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769083110640-lkqnn6fgr_large.jpg	0
176	74	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769083110761-svcj6luv6_large.jpg	0
177	75	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769083646132-83bqm2r62_large.jpg	0
178	75	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769083646310-5obfcdtxp_large.jpg	0
179	75	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769083646616-mno21u06l_large.jpg	0
180	75	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769083645919-8p44dcza8_large.jpg	0
181	75	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769083646143-hqlvle78h_large.jpg	0
182	75	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769083646642-8bs9k65qv_large.jpg	0
183	75	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769083646685-hwwyvcnga_large.jpg	0
184	75	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769083646412-6p190t7v7_large.jpg	0
185	75	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769083646607-d4f883h2r_large.jpg	0
186	75	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769083646120-uppivoa1w_large.jpg	0
187	76	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769083913708-lehy1525j_large.jpg	0
188	77	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769084152510-sooo4su4j_large.jpg	0
189	77	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769084151864-os4ewqeog_large.jpg	0
190	77	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769084151957-cdkme6m3s_large.jpg	0
191	78	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769084328945-zbg5qzj15_large.jpg	0
192	78	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769084329065-4p17q60w2_large.jpg	0
193	78	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769084328850-7jxbt7rkn_large.jpg	0
194	78	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769084328904-vk4g4ld9z_large.jpg	0
195	79	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769084442783-xfn11cu9g_large.jpg	0
196	80	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769260027344-ndlpy9eez_large.jpg	0
197	80	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769260027350-8h7nb27bf_large.jpg	0
198	80	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769260026765-9h8bp34io_large.jpg	0
199	80	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769260026716-4vx4bzyjt_large.jpg	0
200	80	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769260028161-1o4s0eufm_large.jpg	0
201	81	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769260894817-y68ego5mz_large.jpg	0
202	81	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769260894685-6pi389xr0_large.jpg	0
203	81	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769260894790-5dz1jd9n6_large.jpg	0
204	81	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769260895507-m8e7oknrv_large.jpg	0
205	81	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769260894957-xs9cgxq1m_large.jpg	0
206	82	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769263856666-t0be6q2ua_large.jpg	0
207	82	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769263857375-7beqwm781_large.jpg	0
208	82	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769263857578-06ar4eg5k_large.jpg	0
209	82	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769263858566-b1oy7rt9s_large.jpg	0
210	82	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769263856903-ng5yfjy0j_large.jpg	0
211	82	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769263859691-vd8n5ldqp_large.jpg	0
212	82	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769263864443-l8d9wlcla_large.jpg	0
213	83	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769264154483-di1ax3m4j_large.jpg	0
214	83	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769264154276-n1ggmgx89_large.jpg	0
215	84	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769264627495-nugncsn3t_large.jpg	0
216	84	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769264627786-m69i3g9it_large.jpg	0
217	84	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769264628345-v9v033w0s_large.jpg	0
218	85	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769265048300-mul91zk22_large.jpg	0
219	85	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769265047975-yi2fwpcmn_large.jpg	0
220	85	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769265048603-5obrlekzu_large.jpg	0
221	85	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769265048628-7eom61vc4_large.jpg	0
222	85	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769265048099-2z0i9v7n8_large.jpg	0
223	85	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769265049727-53ipassa9_large.jpg	0
224	87	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769265647950-7v8yv3jqv_large.jpg	0
225	87	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769265649182-8ll1rjlwy_large.jpg	0
226	87	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769265651811-zzk6y6wq9_large.jpg	0
227	87	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769265654129-dr91nerl5_large.jpg	0
228	87	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769265654285-wlj12poa3_large.jpg	0
229	88	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769266007181-vwgstpbrv_large.jpg	0
230	90	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769266418649-1e5kblyvy_large.jpg	0
231	91	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769266956865-8w7hf84qq_large.jpg	0
232	92	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769267163536-br6zplfcj_large.jpg	0
233	92	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769267163519-yytstpjzy_large.jpg	0
234	92	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769267163789-zajidvsfn_large.jpg	0
235	92	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769267163602-bw0d8fvha_large.jpg	0
236	93	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769332264420-wl8orgexu_large.jpg	0
237	93	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769332264870-8d7v3m3p3_large.jpg	0
238	94	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769332428652-v6oz9vzvh_large.jpg	0
239	94	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769332429632-6c07kjivx_large.jpg	0
240	94	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769332429307-tlkbt2bcl_large.jpg	0
241	94	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769332430161-zr4gwcfod_large.jpg	0
242	94	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769332429521-k858unocc_large.jpg	0
243	95	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769332548501-oljxc4ryt_large.jpg	0
244	96	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769332800067-ibsret1sl_large.jpg	0
245	97	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769332926557-xwiimtaih_large.jpg	0
246	98	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769333156215-ti0f3l0y2_large.jpg	0
247	98	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769333156775-k8o474ofa_large.jpg	0
248	98	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769333156788-hrwvc3d8y_large.jpg	0
249	98	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769333156797-n5ogh98ce_large.jpg	0
250	98	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769333156433-81mtdwgyc_large.jpg	0
251	99	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769333263044-6iurvv5yr_large.jpg	0
252	99	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769333264179-lhypc7s34_large.jpg	0
253	100	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769333477833-tjuh4sssj_large.jpg	0
254	100	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769333478713-0ds8lszu4_large.jpg	0
255	102	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769333907627-9o2t40evu_large.jpg	0
256	102	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769333907743-kiizp0vct_large.jpg	0
257	103	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769333997001-hx1nfr12p_large.jpg	0
258	103	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769333996696-5vkr9jks4_large.jpg	0
259	103	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769333997573-0852d8hvb_large.jpg	0
260	104	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769334112194-hg948xgty_large.jpg	0
261	104	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769334111990-y2zy8ya9c_large.jpg	0
262	105	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769334323639-holy52cen_large.jpg	0
263	106	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769334520330-23lelsewu_large.jpg	0
264	106	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769334520061-0xg2hhq5m_large.jpg	0
265	106	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769334520022-i188wbwtp_large.jpg	0
266	106	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769334520382-nvni3sj1r_large.jpg	0
267	106	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769334520675-ib2u0tuti_large.jpg	0
268	107	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769334715159-fdfvbw85y_large.jpg	0
269	107	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769334714452-6mr1skbpc_large.jpg	0
270	107	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769334715206-cfjuma7uo_large.jpg	0
271	42	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769335041681-qyvuytc00_large.jpg	0
272	42	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769335115024-a1734880j_large.jpg	0
273	109	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769335253127-ehmebxjh2_large.jpg	0
274	109	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769335253086-flhtgxzzn_large.jpg	0
275	110	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769335363291-6irzbkdmr_large.jpg	0
276	110	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769335363795-1f2vtnorg_large.jpg	0
277	110	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769335363838-qktjbxopa_large.jpg	0
278	111	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769335448934-58elwuald_large.jpg	0
279	112	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769335566483-f0rznqv0s_large.jpg	0
280	112	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769335567699-vasiiepo8_large.jpg	0
281	112	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769335567088-j97u1uloa_large.jpg	0
282	113	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769335743241-0sq0umab6_large.jpg	0
283	113	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769335743913-am0h5tgfx_large.jpg	0
284	113	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769335743552-i8q6fe14d_large.jpg	0
285	114	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769335978142-m6fccmcug_large.jpg	0
286	114	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769335978455-41a0irq81_large.jpg	0
287	114	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769335978346-bopq9woqg_large.jpg	0
288	114	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769335978499-xlvafc9x0_large.jpg	0
289	114	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769335978632-abra5l44d_large.jpg	0
290	115	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769336079937-u2cszz9c6_large.jpg	0
291	115	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769336080415-5oskozjoz_large.jpg	0
292	116	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769336171816-in3iymlm2_large.jpg	0
293	116	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769336171790-bkfgfzk8p_large.jpg	0
294	116	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769336172017-19c5lb31t_large.jpg	0
295	116	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769336171969-34er29z8y_large.jpg	0
296	117	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769336353310-83qmoash4_large.jpg	0
297	118	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769336498878-h3kjnjohs_large.jpg	0
298	118	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769336499142-0b8j2rov7_large.jpg	0
299	118	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769336499372-3kqrv5r0w_large.jpg	0
300	119	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769336600171-2o230ngla_large.jpg	0
301	119	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769336600625-wc0q9n1tr_large.jpg	0
302	120	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769336938444-0ipec07tm_large.jpg	0
303	120	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769337224688-3pgo6yrxd_large.jpg	0
304	120	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769337395043-emf514px3_large.jpg	0
306	121	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769424090718-nmmru8f8c_large.jpg	0
307	121	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769426119154-6hfn8hd02_large.jpg	0
308	121	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769426137112-19s7vm5wq_large.jpg	0
309	121	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769426137564-guqdxwru4_large.jpg	0
310	121	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769426137587-fmj2h9hbb_large.jpg	0
311	121	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769426137803-1wr6xlhtg_large.jpg	0
312	121	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769426139751-pb1439c9z_large.jpg	0
313	121	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769426137826-p9fkxnsqh_large.jpg	0
314	121	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769426137801-ajmv6rbv6_large.jpg	0
315	121	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769426140220-ynue79h46_large.jpg	0
316	121	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769426141182-knoo186te_large.jpg	0
317	121	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769426142155-u411amojx_large.jpg	0
318	124	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769426925241-eeknzqvwf_large.jpg	0
319	124	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769426925758-w4jfv3dr8_large.jpg	0
320	124	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769426925813-ed3cttajv_large.jpg	0
321	125	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769427086663-ltvfr420l_large.jpg	0
322	125	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769427088013-q5cbu9rn4_large.jpg	0
323	125	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769427088432-nblacykhk_large.jpg	0
324	125	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769427088675-x84kstx7b_large.jpg	0
325	126	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769427341619-a5w3mvwnk_large.jpg	0
326	126	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769427341681-f5cjba0ti_large.jpg	0
327	127	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769427428059-t03kdhzbq_large.jpg	0
328	128	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769427571655-vn47bzdym_large.jpg	0
329	129	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769427742079-vhv6lbwrr_large.jpg	0
330	130	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769427886610-brkjtwwv8_large.jpg	0
331	130	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769427887155-ai3rfw98r_large.jpg	0
332	131	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769428743822-z9v1ont62_large.jpg	0
333	131	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769428743612-ueec8e794_large.jpg	0
334	131	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769428743676-c5bqctbrl_large.jpg	0
335	131	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769428743446-1koua2fme_large.jpg	0
336	132	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769507013931-rv0alx0qc_large.jpg	0
337	132	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769507014250-rpxnpdtgm_large.jpg	0
338	132	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769507014497-paqf6m8j6_large.jpg	0
339	132	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769507014527-olrrixdy1_large.jpg	0
340	133	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769507278609-hg5zu6o7r_large.jpg	0
341	133	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769507278809-8z0elp5mp_large.jpg	0
342	133	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769507278821-vq08pb60n_large.jpg	0
343	133	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769507278764-4nlxwcgrh_large.jpg	0
344	133	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769507278580-yqixpn390_large.jpg	0
345	133	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769507278648-50g3wagz3_large.jpg	0
346	136	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769508105666-0hsc0dt8w_large.jpg	0
347	136	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769508105518-xpysxf87t_large.jpg	0
348	136	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769508106406-6tr2e7tpv_large.jpg	0
349	136	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769508106694-mp4p4xu9k_large.jpg	0
350	136	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769508107430-en7a7zdck_large.jpg	0
351	137	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769508340379-6vbihegxw_large.jpg	0
352	137	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769508341025-158tfl01h_large.jpg	0
353	137	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769508340176-i3kh9vte1_large.jpg	0
354	138	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769508589380-0l9wqv0u7_large.jpg	0
355	138	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769508589412-8cv00qp1a_large.jpg	0
356	139	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769510067241-9c9k0yfmd_large.jpg	0
357	140	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769510309418-8fqdts802_large.jpg	0
358	140	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769510309673-yjt1f0emo_large.jpg	0
359	142	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769510851493-ws6145680_large.jpg	0
360	142	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769510852153-fls4menmh_large.jpg	0
361	142	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769510852145-s0ly320n4_large.jpg	0
362	143	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769511039327-3j4qrqayz_large.jpg	0
363	143	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769511039517-33eobo6oz_large.jpg	0
364	143	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769511039524-dwfez4rk2_large.jpg	0
365	144	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769511252484-uvsqyx2e6_large.jpg	0
366	144	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769511252472-d0h6dpol3_large.jpg	0
367	144	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769511252249-dyj7l3m66_large.jpg	0
368	144	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769511252435-lwfe0ss1t_large.jpg	0
369	144	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769511252761-hw8w82twc_large.jpg	0
370	144	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769511252704-5txegii7s_large.jpg	0
371	144	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769511252552-y1ru1eksu_large.jpg	0
372	144	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769511252587-urlweuy13_large.jpg	0
373	144	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769511252369-8ql8alpnv_large.jpg	0
374	145	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769511394924-0205spgvq_large.jpg	0
375	145	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769511395900-u2f40y4dr_large.jpg	0
376	145	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769511395294-57q1prvlo_large.jpg	0
377	145	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769511395269-pm68bngzv_large.jpg	0
378	145	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769511395382-2ro8tsz06_large.jpg	0
379	146	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769511529483-6v0eutwox_large.jpg	0
380	146	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769511530349-ytqrnannd_large.jpg	0
381	147	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769512362509-420hlqlsm_large.jpg	0
382	148	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769513030294-k74jqn0sj_large.jpg	0
383	148	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769513030868-nyu3h5k7c_large.jpg	0
384	149	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769513130887-19kpgbtdv_large.jpg	0
385	150	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769513215086-q7mcqj9l7_large.jpg	0
386	150	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769513215308-jbw5uov09_large.jpg	0
387	150	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769513216167-nxowh8o0b_large.jpg	0
388	151	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769596644308-elq5x8ov3_large.jpg	0
389	152	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769596759476-rkfx36x0v_large.jpg	0
390	152	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769596759633-fgo6nwlej_large.jpg	0
391	153	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769596864272-2sc9tebo0_large.jpg	0
392	153	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769596864922-g1obtbsi9_large.jpg	0
393	154	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769596954663-qr45jts6s_large.jpg	0
394	154	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769596954468-hfxe2z8t4_large.jpg	0
395	155	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769597094485-glqf9k316_large.jpg	0
396	156	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769597267981-f23sxsmt8_large.jpg	0
397	157	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769597428292-v0cvrh17j_large.jpg	0
398	157	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769597428507-4gje9s2tr_large.jpg	0
399	157	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769597428343-shno4p0bj_large.jpg	0
400	158	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769597589907-rlxenzoa0_large.jpg	0
401	158	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769597590381-irlzjzvue_large.jpg	0
402	158	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769597590479-ugiveex2x_large.jpg	0
403	158	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769597590328-qenf9nlja_large.jpg	0
404	159	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769597946212-jlspx557g_large.jpg	0
405	159	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769597945921-hpt6qbjpq_large.jpg	0
406	160	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769598086784-o6x4b7lws_large.jpg	0
407	160	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769598086160-gv8jx13oz_large.jpg	0
408	161	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769598196541-6zz58yois_large.jpg	0
409	161	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769598197003-bzyvgx652_large.jpg	0
410	161	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769598196324-8qy0xz7eq_large.jpg	0
411	161	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769598196879-coxldncl5_large.jpg	0
412	163	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769598547277-1o9avvc56_large.jpg	0
413	162	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769598567283-k9jtysw54_large.jpg	0
414	164	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769598686908-4op7c83kh_large.jpg	0
415	164	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769598686960-8xa1qf6j8_large.jpg	0
416	165	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769598888521-kfvnrnbli_large.jpg	0
417	165	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769598888768-20ppbgcut_large.jpg	0
418	165	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769598888679-q3688fq8u_large.jpg	0
419	166	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769599000556-7pbkgwatv_large.jpg	0
420	167	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769599128802-fyug4in79_large.jpg	0
421	167	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769599129476-1sa1m8ple_large.jpg	0
422	168	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769599342330-ug0vthtyk_large.jpg	0
423	168	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769599343044-ko2qlh9jw_large.jpg	0
424	168	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769599343101-p56jnrgsw_large.jpg	0
425	168	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769599343026-ixy93bjuc_large.jpg	0
426	168	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769599421685-pavqn5nnv_large.jpg	0
427	168	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769599421591-wut33nh1t_large.jpg	0
428	168	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769599421785-pnvbfj60o_large.jpg	0
429	170	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769599604772-b4sqilfsj_large.jpg	0
430	170	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769599605347-lgaurrvc4_large.jpg	0
431	171	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769683378790-gjaz3mjrn_large.jpg	0
432	171	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769683379189-e4utx0wzl_large.jpg	0
433	171	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769683379401-bxb5dzuft_large.jpg	0
434	172	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769683575868-cxacd8y3a_large.jpg	0
435	172	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769683575733-7tguu3rr9_large.jpg	0
436	172	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769683575974-ii3gu7rl8_large.jpg	0
437	172	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769683576587-ek3amnsmy_large.jpg	0
438	174	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769683849093-jddg4nuyw_large.jpg	0
439	175	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769684212381-l5hazeqp2_large.jpg	0
440	175	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769684212627-caj95namu_large.jpg	0
441	175	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769684212584-pjhvdtcne_large.jpg	0
442	175	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769684212804-3hjki7qyy_large.jpg	0
443	175	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769684213201-men723dls_large.jpg	0
444	176	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769684401106-eebat6n42_large.jpg	0
445	176	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769684401529-jybnoojf1_large.jpg	0
446	176	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769684402123-z8zdx6q7z_large.jpg	0
447	177	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769770002756-8d2hqoc7j_large.jpg	0
448	177	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769770003033-f2nvr9gta_large.jpg	0
449	177	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769770002960-yrjxoa8sv_large.jpg	0
450	177	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769770003316-lef9k0w6w_large.jpg	0
451	177	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769770003314-ybd51s0px_large.jpg	0
452	177	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769770003492-wermekt0a_large.jpg	0
453	178	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769770539693-1foqudm6r_large.jpg	0
454	178	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769770539748-1t6cugahq_large.jpg	0
455	178	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769770540312-u1n4tz9v3_large.jpg	0
456	179	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769770643132-4x6r71vvj_large.jpg	0
457	180	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769770792434-s6jw1rv72_large.jpg	0
458	181	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769770928650-esukdrfrp_large.jpg	0
459	181	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769770928942-3dlidbnkw_large.jpg	0
460	181	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769770928913-k8j1cis9c_large.jpg	0
461	181	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769770928932-pek4p8sop_large.jpg	0
462	182	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769771053533-dtrgk04n7_large.jpg	0
463	182	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769771053730-0raoedvh7_large.jpg	0
464	183	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769771273386-zddv9khup_large.jpg	0
465	183	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769771273597-3rgjdsioj_large.jpg	0
466	184	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769771398585-qadhm4b48_large.jpg	0
467	184	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769771398826-2ymfzuz8x_large.jpg	0
468	185	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769771577297-qinbunayd_large.jpg	0
469	185	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769771578134-gxxg4pmun_large.jpg	0
470	185	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769771577569-1f1ry4nev_large.jpg	0
471	185	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769771577579-kxahj86ei_large.jpg	0
472	186	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769771808454-ysjifb1xj_large.jpg	0
473	186	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769771808399-6zdkm8gh0_large.jpg	0
474	186	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769771808660-pysx63ikn_large.jpg	0
475	186	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769771808685-vnqgwrpae_large.jpg	0
476	186	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769771808613-zf819zywd_large.jpg	0
477	187	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769771981409-a5dl3gt47_large.jpg	0
478	187	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769771981684-ejnkpkntr_large.jpg	0
479	187	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769771981651-guiqjiqey_large.jpg	0
480	188	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769772262593-yjip42nes_large.jpg	0
481	188	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769772262249-p37w6sa8s_large.jpg	0
482	188	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769772263041-riaioq01m_large.jpg	0
483	188	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769772263662-kj3ixik1g_large.jpg	0
484	188	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769772262796-j5ar4od6o_large.jpg	0
485	189	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769772419856-07iijuvok_large.jpg	0
486	189	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769772419756-e3sd390qd_large.jpg	0
487	189	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769772419794-p99hcmsq0_large.jpg	0
488	189	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769772423023-j3ifear1u_large.jpg	0
489	190	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769772824872-ih0ovr5l0_large.jpg	0
490	192	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769773161335-a3kkp177v_large.jpg	0
491	192	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769773162438-7jvpejv2x_large.jpg	0
492	193	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769773331307-3xr73e57m_large.jpg	0
493	194	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769773518801-0ph28pntp_large.jpg	0
494	194	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769773518452-4bmjixyf7_large.jpg	0
495	194	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769773519385-1sgynnxvs_large.jpg	0
496	195	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769773763372-isp2nm3zq_large.jpg	0
497	196	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769773923936-2oyr22f6b_large.jpg	0
498	197	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769774125112-0kqb0makd_large.jpg	0
499	198	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769774370364-o63e6t1t2_large.jpg	0
500	198	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769774370565-vyx771djz_large.jpg	0
501	199	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769776450101-wkkevt0dt_large.jpg	0
502	200	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769777868783-3q4kvka9o_large.jpg	0
503	200	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769777869516-o12yb82vq_large.jpg	0
504	200	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769777870457-w69tumptq_large.jpg	0
505	200	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769777869836-lcux3d6jc_large.jpg	0
506	200	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769777870557-ry07ukzdc_large.jpg	0
507	202	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769778142757-8f5tcyd90_large.jpg	0
508	202	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769778143262-ogq9ibif3_large.jpg	0
509	202	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769778142943-1vuorp9vu_large.jpg	0
510	203	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769778528834-xaif9kh9s_large.jpg	0
511	204	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769778974911-1y4fhkpoo_large.jpg	0
512	205	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769779088614-7mh9s6vt4_large.jpg	0
513	206	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769779174950-tmddj02gl_large.jpg	0
514	207	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769779539417-x3h687o1o_large.jpg	0
515	207	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769779539630-do7b4wxag_large.jpg	0
516	207	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769779539963-uj0x3icne_large.jpg	0
517	207	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769779539886-mtzocxbtq_large.jpg	0
518	208	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769779949803-n5uv8xjge_large.jpg	0
519	208	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769779962429-ntf52yt8o_large.jpg	0
520	208	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769779998193-u4yv0u23f_large.jpg	0
521	208	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769779999608-eeke12ygn_large.jpg	0
522	208	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769779997658-ab268r1xe_large.jpg	0
523	208	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769779999583-bfksyl5oa_large.jpg	0
524	208	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769779997715-wji3fa6xz_large.jpg	0
525	208	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769779999679-ccjtacrsz_large.jpg	0
526	208	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769780097681-5204ur8xf_large.jpg	0
527	208	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769780176637-ph8e2hw8b_large.jpg	0
528	208	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769780176555-1pmymdmvt_large.jpg	0
529	208	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769780173145-plcx4lobw_large.jpg	0
530	208	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769780177278-o8rxdlnca_large.jpg	0
531	208	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769780180222-mdjfgn88y_large.jpg	0
532	208	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769780174948-5ja3mrv9e_large.jpg	0
533	208	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769780180349-tdedjpo4x_large.jpg	0
534	210	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769787394223-rybu4qfdk_large.jpg	0
535	211	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769788646188-yfajd7w1v_large.jpg	0
536	211	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769788646199-mfuinz230_large.jpg	0
537	211	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769788645697-e2k7l9t7d_large.jpg	0
538	212	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769788962989-i37220pfy_large.jpg	0
539	212	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769788978517-bpy4tzzvg_large.jpg	0
540	212	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769789018685-whvivqvt6_large.jpg	0
541	212	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769789039518-svxtdluon_large.jpg	0
542	212	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769789037873-rrqf8vghl_large.jpg	0
543	212	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769789026225-ykugcygv3_large.jpg	0
544	212	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769789020768-pxz98etmo_large.jpg	0
545	212	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769789041656-a5zjfz2dj_large.jpg	0
546	212	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769789039309-bb3axlmg0_large.jpg	0
547	214	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769789688240-kkumq75vp_large.jpg	0
548	214	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769789688888-woiidt6fb_large.jpg	0
549	215	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769790311731-ybr79055z_large.jpg	0
550	216	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769846769986-26x0yf8pj_large.jpg	0
551	216	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769846770302-kqdl72c65_large.jpg	0
552	217	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769847828949-iqvkcuzak_large.jpg	0
553	217	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769847829170-eapct1b9y_large.jpg	0
554	218	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769847971245-iivko5bce_large.jpg	0
555	218	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769847971931-5zbytxhao_large.jpg	0
556	218	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769847971904-3rlttf213_large.jpg	0
557	218	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769847971906-fkwla91fo_large.jpg	0
558	218	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769847972687-dtoaj1cfv_large.jpg	0
559	218	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769847972153-6dppr1zsv_large.jpg	0
560	218	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769847971982-7ecz18ygf_large.jpg	0
561	218	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769847972016-rbxvfcqb1_large.jpg	0
562	218	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769847972516-48efygza4_large.jpg	0
563	219	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769848446966-hu86jscgm_large.jpg	0
564	219	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769848446855-xbj5awfd8_large.jpg	0
565	219	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769848447420-lzsx0g59j_large.jpg	0
566	219	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769848448934-cwlu9uq7f_large.jpg	0
567	221	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769848910727-hukw0t9mx_large.jpg	0
568	221	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769848911482-rwq57q07z_large.jpg	0
569	221	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769848912501-sb6luwhy2_large.jpg	0
570	222	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769849581069-xhjlydcq0_large.jpg	0
571	223	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769849750108-jakfim3i6_large.jpg	0
572	223	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769849750073-wvf4icb5z_large.jpg	0
573	223	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769849749931-d5slus7g8_large.jpg	0
574	224	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769850438423-oc508kpon_large.jpg	0
575	224	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769850438765-24jn4ezxl_large.jpg	0
576	225	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769850854813-o8g2ho4uo_large.jpg	0
577	225	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769850855427-34wgx4w8w_large.jpg	0
578	225	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769850855401-6hhskwg3g_large.jpg	0
579	225	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769850854843-vt7i190yg_large.jpg	0
580	225	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769850855426-abqnvyubj_large.jpg	0
581	227	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769851213829-h9d039iks_large.jpg	0
582	227	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769851213938-c70ere6fd_large.jpg	0
583	227	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769851214682-nqiu6nbza_large.jpg	0
584	228	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769851581999-ssv021z0t_large.jpg	0
585	228	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769851581974-x8p4befh6_large.jpg	0
586	228	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769851581824-462cxl8r2_large.jpg	0
587	229	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769914371341-0iovcji8y_large.jpg	0
588	229	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769914372519-h461c3cnl_large.jpg	0
589	229	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769914371753-ef1nmxo8r_large.jpg	0
590	229	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769914372191-an2d6a3i7_large.jpg	0
591	229	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769914373685-uo2nmxxp5_large.jpg	0
592	229	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769914373812-imzqftoge_large.jpg	0
593	231	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769915097160-htl3g6nya_large.jpg	0
594	231	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769915097312-wwziqopm8_large.jpg	0
595	232	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769915293872-ga2h0vnfj_large.jpg	0
596	232	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769915293967-rakygqqc9_large.jpg	0
597	232	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769915294247-mx5v2wjh4_large.jpg	0
598	232	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769915293955-afe4oj5k0_large.jpg	0
599	232	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769915294127-yk1x5zf62_large.jpg	0
600	232	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769915294335-stzx6w44r_large.jpg	0
601	233	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769915734867-ckx4q73bw_large.jpg	0
602	233	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769915734440-y8ysdtvrx_large.jpg	0
603	234	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769915971589-gpimmksjw_large.jpg	0
604	234	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769915971746-i9eoacvwj_large.jpg	0
605	234	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769915971924-kjzx5knmk_large.jpg	0
606	235	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769916292021-2kdnu2c3y_large.jpg	0
607	235	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769916292417-lmuphp8ws_large.jpg	0
608	235	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769916292644-346zno6gd_large.jpg	0
609	235	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769916292464-yp26vvubk_large.jpg	0
610	235	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769916292607-o8r8vw226_large.jpg	0
611	236	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769916470311-9k3firzij_large.jpg	0
612	236	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769916470445-pl786xtiz_large.jpg	0
613	236	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769916470840-93qnlyvay_large.jpg	0
614	236	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769916471003-4acbngdq6_large.jpg	0
615	236	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769916470871-ej1xvkh51_large.jpg	0
616	237	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769916587577-os4pt67k5_large.jpg	0
617	237	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769916587742-z8kl699pz_large.jpg	0
618	237	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769916587763-9keo1hwp4_large.jpg	0
619	237	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769916587795-q1aivf7u0_large.jpg	0
620	238	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769916721540-9srt021vx_large.jpg	0
621	238	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769916721664-e5uodu1qi_large.jpg	0
622	238	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769916721796-db6b4gj6l_large.jpg	0
623	239	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769916856951-hllfee2zq_large.jpg	0
624	239	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769916858380-cxg71ztgm_large.jpg	0
625	240	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769917051890-g6gva0747_large.jpg	0
626	240	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769917052013-7ww51rf67_large.jpg	0
627	240	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769917052125-jftqezuc4_large.jpg	0
628	240	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769917052056-zhaq075ax_large.jpg	0
629	240	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769917052614-a9q1hg7z9_large.jpg	0
630	241	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769919102602-q7zjcifs1_large.jpg	0
631	241	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769919103059-h6qbbnqap_large.jpg	0
632	242	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769920649690-wtq0e0u9j_large.jpg	0
633	243	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769921038331-emgsjiktf_large.jpg	0
634	243	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769921038703-2jg4lec9y_large.jpg	0
635	243	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1769921038771-8910fpic6_large.jpg	0
636	245	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1770092057971-prefgo3qf_large.jpg	0
637	245	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1770092084897-lxa07bl92_large.jpg	0
638	246	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1770092830440-xwdo1cojf_large.jpg	0
639	247	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1770120726862-eu4rrset6_large.jpg	0
640	247	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1770120771220-go99sj84w_large.jpg	0
\.


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.migrations_id_seq', 7, true);


--
-- Name: page_view_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.page_view_id_seq', 2048, true);


--
-- Name: review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.review_id_seq', 1, false);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_id_seq', 1, true);


--
-- Name: venue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.venue_id_seq', 247, true);


--
-- Name: venue_image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.venue_image_id_seq', 640, true);


--
-- Name: review PK_2e4299a343a81574217255c00ca; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT "PK_2e4299a343a81574217255c00ca" PRIMARY KEY (id);


--
-- Name: venue_image PK_5a4a3227790c0c588ced1fe5b79; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venue_image
    ADD CONSTRAINT "PK_5a4a3227790c0c588ced1fe5b79" PRIMARY KEY (id);


--
-- Name: migrations PK_8c82d7f526340ab734260ea46be; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY (id);


--
-- Name: venue PK_c53deb6d1bcb088f9d459e7dbc0; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venue
    ADD CONSTRAINT "PK_c53deb6d1bcb088f9d459e7dbc0" PRIMARY KEY (id);


--
-- Name: user PK_cace4a159ff9f2512dd42373760; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "PK_cace4a159ff9f2512dd42373760" PRIMARY KEY (id);


--
-- Name: user UQ_8e1f623798118e629b46a9e6299; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "UQ_8e1f623798118e629b46a9e6299" UNIQUE (phone);


--
-- Name: page_view page_view_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_view
    ADD CONSTRAINT page_view_pkey PRIMARY KEY (id);


--
-- Name: IDX_review_venueId; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_review_venueId" ON public.review USING btree ("venueId");


--
-- Name: IDX_venue_image_venueId; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_venue_image_venueId" ON public.venue_image USING btree ("venueId");


--
-- Name: IDX_venue_lat; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_venue_lat" ON public.venue USING btree (lat);


--
-- Name: IDX_venue_lng; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_venue_lng" ON public.venue USING btree (lng);


--
-- Name: idx_page_view_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_page_view_created_at ON public.page_view USING btree (created_at);


--
-- Name: idx_page_view_page_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_page_view_page_type ON public.page_view USING btree (page_type);


--
-- Name: idx_page_view_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_page_view_path ON public.page_view USING btree (path);


--
-- Name: review FK_1337f93918c70837d3cea105d39; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT "FK_1337f93918c70837d3cea105d39" FOREIGN KEY ("userId") REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: review FK_21a6e42d6748767b7898d7f403c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT "FK_21a6e42d6748767b7898d7f403c" FOREIGN KEY ("venueId") REFERENCES public.venue(id) ON DELETE CASCADE;


--
-- Name: venue_image FK_6eda86a5f741705e30ddb4681f5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venue_image
    ADD CONSTRAINT "FK_6eda86a5f741705e30ddb4681f5" FOREIGN KEY ("venueId") REFERENCES public.venue(id) ON DELETE CASCADE;


--
-- Name: venue_image FK_c70def4c1f053f70937112b9d16; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venue_image
    ADD CONSTRAINT "FK_c70def4c1f053f70937112b9d16" FOREIGN KEY ("userId") REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict cijG6dKDNgfAKE71B861fMb0J2gSZ0ZaltcOVizdcjEumbXBy5ViFJGYdeaTdeU

