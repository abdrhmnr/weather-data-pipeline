--
-- PostgreSQL database dump
--

\restrict VwBml24blGxQIiK8A3QvUOflttyw7md1BAI5czSXK9TbFNpMNsBK6dFxHBHGPfu

-- Dumped from database version 15.17 (Debian 15.17-1.pgdg13+1)
-- Dumped by pg_dump version 15.17 (Debian 15.17-1.pgdg13+1)

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

--
-- Name: wind_direction_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.wind_direction_enum AS ENUM (
    'N',
    'NNE',
    'NE',
    'ENE',
    'E',
    'ESE',
    'SE',
    'SSE',
    'S',
    'SSW',
    'SW',
    'WSW',
    'W',
    'WNW',
    'NW',
    'NNW'
);


ALTER TYPE public.wind_direction_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: locations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locations (
    id uuid NOT NULL,
    city character varying(100) NOT NULL,
    country character varying(10) NOT NULL,
    latitude double precision,
    longitude double precision,
    timezone character varying(50),
    elevation double precision,
    created_at timestamp with time zone
);


ALTER TABLE public.locations OWNER TO postgres;

--
-- Name: pipeline_runs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pipeline_runs (
    id uuid NOT NULL,
    started_at timestamp with time zone,
    finished_at timestamp with time zone,
    status character varying(20),
    records_extracted integer,
    records_loaded integer,
    records_rejected integer,
    error_message character varying,
    api_request_params jsonb,
    created_at timestamp with time zone
);


ALTER TABLE public.pipeline_runs OWNER TO postgres;

--
-- Name: weather_readings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.weather_readings (
    id uuid NOT NULL,
    location_id uuid NOT NULL,
    pipeline_run_id uuid NOT NULL,
    temp_avg_c double precision,
    temp_min_c double precision,
    temp_max_c double precision,
    humidity_pct integer,
    pressure_hpa integer,
    wind_speed_kmh double precision,
    wind_direction_deg integer,
    wind_direction public.wind_direction_enum,
    wind_gust_kmh double precision,
    rain_tomorrow boolean,
    precipitation_mm double precision,
    weather_description character varying,
    observation_timestamp timestamp with time zone NOT NULL,
    created_at timestamp with time zone
);


ALTER TABLE public.weather_readings OWNER TO postgres;

--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
6592e8625224
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locations (id, city, country, latitude, longitude, timezone, elevation, created_at) FROM stdin;
231ce7ad-5cc1-48fb-83cb-74190d77a7ab	Cairo	EG	30.0626	31.2497	10800	\N	2026-05-21 18:08:49.054622+00
fc248375-8ec4-4683-9613-c149579eb366	Riyadh	SA	24.6877	46.7219	10800	\N	2026-05-21 18:08:49.403547+00
6432350e-9525-49a7-9965-65ace30857c2	Dubai	AE	25.2582	55.3047	14400	\N	2026-05-21 18:08:49.680113+00
1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	Baghdad	IQ	33.3406	44.4009	10800	\N	2026-05-21 18:08:49.955125+00
1e806627-87ea-4c01-aad4-9f05ce90c257	Beirut	LB	33.8889	35.4944	10800	\N	2026-05-21 18:08:50.231924+00
0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	Amman	JO	31.9552	35.945	10800	\N	2026-05-21 18:08:50.515229+00
527f8a7d-5101-47fc-9889-f2e961c2b7e4	Kuwait City	KW	29.3697	47.9783	10800	\N	2026-05-21 18:08:50.837814+00
11058438-9274-473f-bd2c-115fdb27b414	Doha	QA	25.2867	51.5333	10800	\N	2026-05-21 18:08:51.129467+00
3febc9d0-6443-496c-9ba6-55af7a506145	Casablanca	MA	33.5928	-7.6192	3600	\N	2026-05-21 18:08:51.411679+00
d981da53-c316-48f1-8e7f-b9f42d74afa0	Tunisia	TN	34	9	3600	\N	2026-05-21 18:08:51.75235+00
\.


--
-- Data for Name: pipeline_runs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pipeline_runs (id, started_at, finished_at, status, records_extracted, records_loaded, records_rejected, error_message, api_request_params, created_at) FROM stdin;
d90f3152-7537-43b5-9445-988990d236d7	2026-05-21 18:08:48.739176+00	2026-05-21 18:08:51.758522+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-21 18:08:48.739179+00
79b7d329-a550-45b5-aecc-4e72af1cab94	2026-05-21 18:30:56.674001+00	2026-05-21 18:30:59.876894+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-21 18:30:56.674006+00
e4fb20bc-c3ae-4707-bcad-d6875006e472	2026-05-21 18:41:58.445833+00	2026-05-21 18:42:03.005162+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-21 18:41:58.445836+00
\.


--
-- Data for Name: weather_readings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.weather_readings (id, location_id, pipeline_run_id, temp_avg_c, temp_min_c, temp_max_c, humidity_pct, pressure_hpa, wind_speed_kmh, wind_direction_deg, wind_direction, wind_gust_kmh, rain_tomorrow, precipitation_mm, weather_description, observation_timestamp, created_at) FROM stdin;
4bcce1ec-7d78-4edc-9fe2-fae2e5c9bd9d	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	d90f3152-7537-43b5-9445-988990d236d7	25.42	25.23	25.42	41	1014	20.38	320	NW	0	t	0	scattered clouds	2026-05-21 18:00:00+00	2026-05-21 18:08:49.058813+00
95757196-0bdf-4eeb-807c-f80935b56820	fc248375-8ec4-4683-9613-c149579eb366	d90f3152-7537-43b5-9445-988990d236d7	37.16	37.16	37.16	9	1005	7.96	262	W	8.21	f	0	scattered clouds	2026-05-21 18:00:00+00	2026-05-21 18:08:49.406846+00
56a1c0dd-76b3-4825-bc68-a61f00ad59b8	6432350e-9525-49a7-9965-65ace30857c2	d90f3152-7537-43b5-9445-988990d236d7	31.96	31.96	32.14	43	1005	11.12	190	S	0	f	0	clear sky	2026-05-21 18:00:00+00	2026-05-21 18:08:49.683183+00
21d8e72a-b573-4a4c-8dfb-08dd016b1f47	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	d90f3152-7537-43b5-9445-988990d236d7	26.95	26.95	26.95	26	1008	18.5	310	NW	0	t	0	clear sky	2026-05-21 18:00:00+00	2026-05-21 18:08:49.95845+00
2eecae9d-6352-46d6-a3ac-16326d1be22a	1e806627-87ea-4c01-aad4-9f05ce90c257	d90f3152-7537-43b5-9445-988990d236d7	17.99	17.99	17.99	74	1012	21.6	203	SSW	23	t	0	clear sky	2026-05-21 18:00:00+00	2026-05-21 18:08:50.235162+00
d1e9d155-baa2-4047-9f28-2c11532c3637	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	d90f3152-7537-43b5-9445-988990d236d7	17.05	16.75	17.05	59	1014	18.5	270	W	0	f	0	scattered clouds	2026-05-21 18:00:00+00	2026-05-21 18:08:50.51856+00
521e3a5d-8d87-4177-ab2a-790a2ab949f6	527f8a7d-5101-47fc-9889-f2e961c2b7e4	d90f3152-7537-43b5-9445-988990d236d7	31.55	31.55	31.55	38	1004	25.56	324	NW	35.1	t	0	scattered clouds	2026-05-21 18:00:00+00	2026-05-21 18:08:50.84113+00
d4a87973-53c5-436b-98b7-7059c11bac55	11058438-9274-473f-bd2c-115fdb27b414	d90f3152-7537-43b5-9445-988990d236d7	31.99	30.94	31.99	37	1005	5.54	140	SE	0	f	0	clear sky	2026-05-21 18:00:00+00	2026-05-21 18:08:51.13218+00
a08f7fa7-602f-478e-ac6e-807a278afdca	3febc9d0-6443-496c-9ba6-55af7a506145	d90f3152-7537-43b5-9445-988990d236d7	29.07	29.07	29.19	37	1014	12.96	80	E	0	f	0	scattered clouds	2026-05-21 18:00:00+00	2026-05-21 18:08:51.415181+00
8b0744a1-6ca1-47a3-9efb-791c231743e0	d981da53-c316-48f1-8e7f-b9f42d74afa0	d90f3152-7537-43b5-9445-988990d236d7	29.08	29.08	29.08	22	1019	32.26	67	ENE	35.93	f	0	clear sky	2026-05-21 18:00:00+00	2026-05-21 18:08:51.755212+00
\.


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: pipeline_runs pipeline_runs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pipeline_runs
    ADD CONSTRAINT pipeline_runs_pkey PRIMARY KEY (id);


--
-- Name: locations uix_city_country; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT uix_city_country UNIQUE (city, country);


--
-- Name: weather_readings uix_loc_obs_time; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weather_readings
    ADD CONSTRAINT uix_loc_obs_time UNIQUE (location_id, observation_timestamp);


--
-- Name: weather_readings weather_readings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weather_readings
    ADD CONSTRAINT weather_readings_pkey PRIMARY KEY (id);


--
-- Name: ix_locations_city; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_locations_city ON public.locations USING btree (city);


--
-- Name: ix_pipeline_runs_started_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_pipeline_runs_started_at ON public.pipeline_runs USING btree (started_at);


--
-- Name: ix_weather_readings_observation_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_weather_readings_observation_timestamp ON public.weather_readings USING btree (observation_timestamp);


--
-- Name: ix_weather_readings_pipeline_run_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_weather_readings_pipeline_run_id ON public.weather_readings USING btree (pipeline_run_id);


--
-- Name: weather_readings weather_readings_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weather_readings
    ADD CONSTRAINT weather_readings_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: weather_readings weather_readings_pipeline_run_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weather_readings
    ADD CONSTRAINT weather_readings_pipeline_run_id_fkey FOREIGN KEY (pipeline_run_id) REFERENCES public.pipeline_runs(id);


--
-- PostgreSQL database dump complete
--

\unrestrict VwBml24blGxQIiK8A3QvUOflttyw7md1BAI5czSXK9TbFNpMNsBK6dFxHBHGPfu

