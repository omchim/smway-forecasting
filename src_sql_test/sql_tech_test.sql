--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Ubuntu 16.1-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.1 (Ubuntu 16.1-1.pgdg22.04+1)

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
-- Name: episode_sample; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.episode_sample (
    id integer NOT NULL,
    show_id integer NOT NULL,
    name character varying(40) NOT NULL,
    broadcast_date date
);


ALTER TABLE public.episode_sample OWNER TO postgres;

--
-- Name: tv_show; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tv_show (
    id integer NOT NULL,
    name character varying(40) NOT NULL,
    creation_year integer NOT NULL,
    season_number integer NOT NULL
);


ALTER TABLE public.tv_show OWNER TO postgres;

--
-- Data for Name: episode_sample; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.episode_sample (id, show_id, name, broadcast_date) FROM stdin;
1	1	Winter is coming	2011-12-11
2	2	In Control	2013-04-06
3	2	Trust Me	2014-03-02
4	4	Geheimnisse	2018-07-23
5	1	A Golden Crown	2012-05-01
6	1	The Pointy End	2012-08-17
7	2	Safe House	2014-10-01
8	3	Dangerous	2013-07-14
9	1	Fire and Blood	2013-07-18
10	2	Covert War	2013-12-14
11	1	Baelor	2013-12-31
12	3	Dangerous	2013-12-24
13	5	Mary and Martha	2017-04-14
\.


--
-- Data for Name: tv_show; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tv_show (id, name, creation_year, season_number) FROM stdin;
1	Game of thrones	2011	8
2	The Americans	2013	6
3	Peaky Blinders	2013	5
4	Dark	2017	3
5	Handmaids Tale	2017	3
6	The Boys	2019	4
\.


--
-- PostgreSQL database dump complete
--

