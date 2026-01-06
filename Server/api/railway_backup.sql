--
-- PostgreSQL database dump
--

\restrict nM2qPxvgLKygZoeCf9cxc2CwH6uk1ppy9G58UYRC7YuEYSENlEaNYpaYnP1bS9g

-- Dumped from database version 17.7 (Debian 17.7-3.pgdg13+1)
-- Dumped by pg_dump version 17.7 (Debian 17.7-3.pgdg13+1)

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
-- Data for Name: venue; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.venue (id, name, "sportType", "cityCode", address, lng, lat, "priceMin", "priceMax", indoor, contact, is_public, district_code) FROM stdin;
1	月欣家园篮球场	basketball	330100	\N	116.380863	39.900051	\N	\N	f	\N	t	\N
7	月欣家园篮球场（室内）	basketball	330100	临平区月欣家园	116.397428	39.90923	100	200	t	\N	t	\N
8	塘栖三中篮球馆	basketball	330100	临平区塘栖镇第三中学	116.397428	39.90923	\N	\N	t	\N	t	\N
\.


--
-- Data for Name: review; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.review (id, "venueId", "userId", rating, content, "createdAt") FROM stdin;
\.


--
-- Data for Name: venue_image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.venue_image (id, "venueId", "userId", url, sort) FROM stdin;
2	1	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1767094032783-fbf75aa59f06ea4c.jpg	0
3	7	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1767355377225-invt8lnir_large.jpg	0
4	7	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1767355378030-0eqp276k2_large.jpg	0
5	8	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1767525301727-roztm0a6p_large.jpg	0
6	8	1	https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/1767525301980-lke93uosd_large.jpg	0
\.


--
-- Name: review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.review_id_seq', 1, false);


--
-- Name: venue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.venue_id_seq', 8, true);


--
-- Name: venue_image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.venue_image_id_seq', 6, true);


--
-- PostgreSQL database dump complete
--

\unrestrict nM2qPxvgLKygZoeCf9cxc2CwH6uk1ppy9G58UYRC7YuEYSENlEaNYpaYnP1bS9g

