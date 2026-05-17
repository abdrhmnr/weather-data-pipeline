--
-- PostgreSQL database dump
--

\restrict QVx0VEPee7lgr0HKxv4bTq8pi9QdjyhkxNVr4jvgfH9hfMZBS4DVoTzg1yaV4jQ

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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


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
-- Name: locations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locations (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    city character varying(100) NOT NULL,
    country character varying(10) NOT NULL,
    latitude numeric(9,6),
    longitude numeric(9,6),
    timezone character varying(50),
    elevation numeric(10,2),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.locations OWNER TO postgres;

--
-- Name: pipeline_runs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pipeline_runs (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    started_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    finished_at timestamp with time zone,
    status character varying(20) DEFAULT 'RUNNING'::character varying,
    records_extracted integer DEFAULT 0,
    records_loaded integer DEFAULT 0,
    records_rejected integer DEFAULT 0,
    error_message text,
    api_request_params jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pipeline_runs_status_check CHECK (((status)::text = ANY ((ARRAY['RUNNING'::character varying, 'SUCCESS'::character varying, 'FAILED'::character varying, 'PARTIAL'::character varying])::text[])))
);


ALTER TABLE public.pipeline_runs OWNER TO postgres;

--
-- Name: weather_readings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.weather_readings (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    location_id uuid NOT NULL,
    pipeline_run_id uuid NOT NULL,
    temp_avg_c numeric(5,2),
    temp_min_c numeric(5,2),
    temp_max_c numeric(5,2),
    humidity_pct integer,
    pressure_hpa integer,
    wind_speed_kmh numeric(5,2),
    wind_direction_deg integer,
    wind_direction public.wind_direction_enum,
    wind_gust_kmh numeric(5,2),
    rain_tomorrow boolean,
    precipitation_mm numeric(7,2),
    weather_description text,
    observation_timestamp timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.weather_readings OWNER TO postgres;

--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locations (id, city, country, latitude, longitude, timezone, elevation, created_at) FROM stdin;
467c145d-f635-4cb3-9813-63f4d28b8780	Cairo	EG	30.062600	31.249700	10800	\N	2026-05-02 17:08:28.338493+00
f2df8134-8994-487c-8a25-272606e8f953	Riyadh	SA	24.687700	46.721900	10800	\N	2026-05-02 17:08:28.661641+00
3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	Dubai	AE	25.258200	55.304700	14400	\N	2026-05-02 17:08:28.984783+00
6411b387-fc37-4b47-878b-8f89fd8e08d9	Baghdad	IQ	33.340600	44.400900	10800	\N	2026-05-02 17:08:29.327226+00
05546df7-881e-438f-96b9-be0148283901	Beirut	LB	33.888900	35.494400	10800	\N	2026-05-02 17:08:29.67933+00
054b54c2-e6d1-4534-a9de-58bf2831479a	Amman	JO	31.955200	35.945000	10800	\N	2026-05-02 17:08:30.016732+00
9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	Kuwait City	KW	29.369700	47.978300	10800	\N	2026-05-02 17:08:30.354804+00
f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	Doha	QA	25.286700	51.533300	10800	\N	2026-05-02 17:08:30.687768+00
72829d11-3ace-445b-9f4b-5c3c72c3521f	Casablanca	MA	33.592800	-7.619200	3600	\N	2026-05-02 17:08:31.047698+00
5bd52475-ffa2-40f6-82e4-3d0491b7e246	Tunisia	TN	34.000000	9.000000	3600	\N	2026-05-02 17:08:31.370911+00
\.


--
-- Data for Name: pipeline_runs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pipeline_runs (id, started_at, finished_at, status, records_extracted, records_loaded, records_rejected, error_message, api_request_params, created_at) FROM stdin;
ad24079f-b7f1-4a89-846e-4dbd14a49281	2026-05-02 17:23:55.869379+00	2026-05-02 17:23:59.9363+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-02 17:23:55.869379+00
9eecb7b9-101b-48ce-82e3-e0f9c5b7ad06	2026-05-02 17:34:06.219816+00	2026-05-02 17:34:10.18055+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-02 17:34:06.219816+00
e4699519-dc93-4696-9440-1806be8d738e	2026-05-02 18:00:10.282407+00	2026-05-02 18:00:14.986038+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-02 18:00:10.282407+00
722e01b5-33d5-47c7-b819-a309b5e7ce3f	2026-05-02 19:00:00.286022+00	2026-05-02 19:00:03.914067+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-02 19:00:00.286022+00
f0729683-fd30-461d-8035-1ac2da9fa2e4	2026-05-02 20:00:04.189904+00	2026-05-02 20:00:07.549917+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-02 20:00:04.189904+00
42c221f5-e373-44dc-b878-4579860ac8f4	2026-05-02 21:00:07.843593+00	2026-05-02 21:00:12.07331+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-02 21:00:07.843593+00
a57dd1f4-daa7-48c8-b58f-ab97c8932f84	2026-05-02 22:00:12.504857+00	2026-05-02 22:00:19.631046+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-02 22:00:12.504857+00
9a9676b3-300c-4d23-a3d9-703dc6bb95d1	2026-05-02 23:00:19.719277+00	2026-05-02 23:00:27.120326+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-02 23:00:19.719277+00
3084dc06-7e64-40ad-99c0-b9455b490b6f	2026-05-03 00:00:27.447636+00	2026-05-03 00:00:33.536676+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 00:00:27.447636+00
1ac1a2f2-279e-4b84-87a9-52071acec917	2026-05-03 01:00:33.940764+00	2026-05-03 01:00:37.409538+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 01:00:33.940764+00
e2d77a45-6201-4141-a2e6-d53fbef1e392	2026-05-03 02:00:37.699892+00	2026-05-03 02:00:41.281439+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 02:00:37.699892+00
76515786-a47b-4fc4-b231-5039858072b7	2026-05-03 03:00:41.567035+00	2026-05-03 03:00:44.892935+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 03:00:41.567035+00
56aeb987-8d56-47cd-8220-f22623c39b68	2026-05-03 04:00:45.296212+00	2026-05-03 04:00:48.650034+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 04:00:45.296212+00
120eab04-0aef-4324-b106-0622b0dd2fc6	2026-05-03 05:00:48.947628+00	2026-05-03 05:00:52.453982+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 05:00:48.947628+00
3c1f8ea6-ac01-46d4-a809-c122a2975703	2026-05-03 06:08:25.359195+00	2026-05-03 06:09:16.98914+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 06:08:25.359195+00
730ab2b5-5e02-4c6a-a69f-d827d3b8e22a	2026-05-03 07:00:17.193762+00	2026-05-03 07:00:27.43344+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 07:00:17.193762+00
6b142f5f-380b-4c38-8bfd-982afff92912	2026-05-03 08:00:27.628427+00	2026-05-03 08:00:33.074014+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 08:00:27.628427+00
209bf07a-7d00-4b61-8fa1-26d6d51aca2b	2026-05-03 09:00:33.573696+00	2026-05-03 09:00:37.847371+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 09:00:33.573696+00
7f5bb1f7-10a5-4723-bf68-cba459b84c5d	2026-05-03 10:00:38.078865+00	2026-05-03 10:00:48.505328+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 10:00:38.078865+00
4a3bcb54-a1b8-43ae-8478-eef58799f984	2026-05-03 11:00:48.762283+00	2026-05-03 11:00:55.903356+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 11:00:48.762283+00
bde90614-18e9-4541-8ad3-4c1c90a753c2	2026-05-03 12:00:41.593857+00	2026-05-03 12:00:48.746072+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 12:00:41.593857+00
dc1b56ea-1b63-4038-83ba-fd9a93db2e63	2026-05-03 13:00:49.079588+00	2026-05-03 13:00:56.399965+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 13:00:49.079588+00
d3305cdb-a7d4-4f93-ae39-d9c73f2143cb	2026-05-03 14:10:25.349507+00	2026-05-03 14:10:29.636092+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 14:10:25.349507+00
e0c4180d-bb23-4605-a5e3-55f5edf06f53	2026-05-03 15:00:30.009231+00	2026-05-03 15:00:33.391956+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 15:00:30.009231+00
d59ddbc1-2d97-496c-b517-55544394054e	2026-05-03 16:00:33.805064+00	2026-05-03 16:00:37.367993+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 16:00:33.805064+00
2979ea03-f0f5-4ad9-bbfb-c8d9423dfb7a	2026-05-03 17:24:32.962688+00	2026-05-03 17:24:40.234961+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 17:24:32.962688+00
91a8f882-1022-4f06-bc68-8ce49f0879f2	2026-05-03 18:00:20.481697+00	2026-05-03 18:00:25.623601+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 18:00:20.481697+00
f36d3aba-63c7-401b-bfec-c34fae47011a	2026-05-03 19:00:46.425314+00	2026-05-03 19:00:49.921346+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 19:00:46.425314+00
12e18d46-61e4-419b-8857-3b9484c01738	2026-05-03 20:00:50.233294+00	2026-05-03 20:00:53.875542+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 20:00:50.233294+00
e70346eb-7648-402c-b3b4-adc98d1d78e7	2026-05-03 21:27:39.761875+00	2026-05-03 21:27:43.289934+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 21:27:39.761875+00
4edb035e-dd00-468c-b227-544e1fe98cda	2026-05-03 22:00:29.443789+00	2026-05-03 22:00:40.758314+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 22:00:29.443789+00
38b2df80-d454-4d22-9665-338bfe70f2f3	2026-05-03 23:00:17.941824+00	2026-05-03 23:00:21.643172+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-03 23:00:17.941824+00
1150dfb2-9183-43ee-b116-f4fbd0afa328	2026-05-04 00:00:22.096339+00	2026-05-04 00:00:25.493164+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 00:00:22.096339+00
19834361-b1ee-4125-8fe3-caf402f7dd36	2026-05-04 01:00:25.917372+00	2026-05-04 01:00:29.283086+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 01:00:25.917372+00
165564d6-ff65-4bc4-8787-3ca5827012de	2026-05-04 02:00:29.736913+00	2026-05-04 02:00:33.12048+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 02:00:29.736913+00
cc1e4408-d6a4-48e5-ad24-cf828b430a3f	2026-05-05 03:00:42.27422+00	2026-05-05 03:00:45.387565+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 03:00:42.27422+00
1b8947ea-2c93-40ba-992c-3e4700be8cda	2026-05-04 03:00:33.518767+00	2026-05-04 03:00:36.972101+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 03:00:33.518767+00
f604a38f-fb5c-4de3-8e84-a3255650193a	2026-05-04 04:00:37.343177+00	2026-05-04 04:00:40.896436+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 04:00:37.343177+00
8bc5742b-ceb1-4ee7-95fc-4ac203f5c4de	2026-05-05 04:00:45.825135+00	2026-05-05 04:00:48.783571+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 04:00:45.825135+00
b2a78c5c-4542-4ce8-a445-2ce36b49da91	2026-05-04 05:00:41.212331+00	2026-05-04 05:00:46.13121+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 05:00:41.212331+00
c8b8ac5e-3e24-4ad7-84b0-574837be327f	2026-05-04 06:00:46.440518+00	2026-05-04 06:00:49.82483+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 06:00:46.440518+00
90a4fb95-c393-440c-9e10-bc8214ebd7c1	2026-05-05 05:00:49.089299+00	2026-05-05 05:00:52.23416+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 05:00:49.089299+00
1b5595c2-c422-441b-be07-e8907f23cc9a	2026-05-04 07:00:50.272542+00	2026-05-04 07:00:53.641019+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 07:00:50.272542+00
3609467d-1cb7-4cd8-b1c6-bbbaabf65ee2	2026-05-04 08:00:54.075294+00	2026-05-04 08:00:57.434432+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 08:00:54.075294+00
39320244-9c80-42b9-9a6d-51265f3229b7	2026-05-05 06:00:52.699509+00	2026-05-05 06:00:55.818609+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 06:00:52.699509+00
4418f6fb-8c68-467d-94f1-5356b8db3980	2026-05-04 09:00:20.4914+00	2026-05-04 09:00:23.950169+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 09:00:20.4914+00
1997aea2-805d-488a-8516-183edc4e2f2e	2026-05-04 10:26:20.307394+00	2026-05-04 10:26:24.004913+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 10:26:20.307394+00
fe99bc1c-f2c7-4243-a0cc-3c136e6edbb9	2026-05-05 07:12:00.154101+00	2026-05-05 07:15:48.439716+00	FAILED	0	0	10	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 07:12:00.154101+00
bb78c448-eb25-4d0f-b764-7d5c466a47be	2026-05-04 11:07:10.336008+00	2026-05-04 11:07:14.217098+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 11:07:10.336008+00
4010fb51-8485-4dcc-a244-69c169143765	2026-05-04 12:00:22.980511+00	2026-05-04 12:00:26.442013+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 12:00:22.980511+00
9126962d-da92-4930-9fe6-67db523f6879	2026-05-05 08:10:24.766864+00	2026-05-05 08:16:50.523929+00	FAILED	0	0	10	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 08:10:24.766864+00
f7804272-978b-4ed2-9a70-48bc20c9912d	2026-05-04 13:21:19.179781+00	2026-05-04 13:39:33.738669+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 13:21:19.179781+00
f08866ec-ef27-4c86-ae63-0c3a6328c0f4	2026-05-04 14:05:18.613943+00	2026-05-04 14:05:23.940067+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 14:05:18.613943+00
1e44d3ac-14a8-47ab-8420-dd770ffc75fc	2026-05-05 09:45:45.725267+00	2026-05-05 10:12:21.829122+00	FAILED	0	0	10	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 09:45:45.725267+00
1c3144d2-3aaf-425b-9982-a4e1fdcdf61b	2026-05-04 15:00:24.205225+00	2026-05-04 15:00:28.570444+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 15:00:24.205225+00
489989c5-d19e-4df2-a796-21e37f774dc0	2026-05-04 16:00:28.882404+00	2026-05-04 16:00:38.503568+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 16:00:28.882404+00
b29ad42f-202e-4d65-b667-9b7e9c2dd576	2026-05-05 11:13:28.296638+00	2026-05-05 11:14:03.097155+00	PARTIAL	7	7	3	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 11:13:28.296638+00
721b909e-93bd-4af9-8cc4-e08681260ba2	2026-05-04 17:00:16.635598+00	2026-05-04 17:00:21.180581+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 17:00:16.635598+00
0166f3b7-b108-4c2f-afa1-42558146f84d	2026-05-04 18:00:21.353868+00	2026-05-04 18:00:25.112546+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 18:00:21.353868+00
ecceacd2-c947-4a76-bcdb-805ce9f26beb	2026-05-05 12:01:29.859935+00	2026-05-05 12:01:33.105689+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 12:01:29.859935+00
3730c242-6153-4b55-ab6e-2821dae46254	2026-05-04 19:00:25.356898+00	2026-05-04 19:00:28.483836+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 19:00:25.356898+00
9ef67250-9faa-40af-8c46-dc636c0cd19f	2026-05-04 20:00:28.904228+00	2026-05-04 20:00:33.117931+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 20:00:28.904228+00
c897b609-a493-433a-8817-d13de46072af	2026-05-05 13:00:06.879834+00	2026-05-05 13:00:10.431326+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 13:00:06.879834+00
c3398661-2227-4481-8b19-0e438c598a46	2026-05-04 21:00:33.410503+00	2026-05-04 21:01:01.16668+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 21:00:33.410503+00
7f1dea62-fb00-4a0d-b38f-e0768676a75b	2026-05-04 22:00:01.575493+00	2026-05-04 22:00:05.254993+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 22:00:01.575493+00
01f4010d-e366-4a3c-a6ac-67e9181fa6c9	2026-05-05 14:00:10.967013+00	2026-05-05 14:00:14.01107+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 14:00:10.967013+00
2997f0b2-99a5-430f-980c-a7a5a0962b28	2026-05-04 23:00:05.627441+00	2026-05-04 23:00:10.342908+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-04 23:00:05.627441+00
962ab9f2-0674-464a-a523-2679e4be87a7	2026-05-05 00:00:31.083888+00	2026-05-05 00:00:34.31049+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 00:00:31.083888+00
bad3bc0b-9d34-4610-900b-1122a0320965	2026-05-05 01:00:34.728369+00	2026-05-05 01:00:37.943509+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 01:00:34.728369+00
2d22d148-d147-410e-8838-60e6190ca591	2026-05-05 02:00:38.308968+00	2026-05-05 02:00:41.864476+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 02:00:38.308968+00
540ce0e4-5f03-48e9-ae4a-4c95c986da64	2026-05-05 15:00:14.428549+00	2026-05-05 15:00:17.598085+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 15:00:14.428549+00
b4bd2ff5-3750-4c7a-8cc8-ff0e2ef92219	2026-05-05 16:00:17.818402+00	2026-05-05 16:00:21.62657+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 16:00:17.818402+00
59371d65-369a-4e9e-bee4-9f19989249f4	2026-05-05 17:00:22.031128+00	2026-05-05 17:00:26.806233+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 17:00:22.031128+00
85034e04-85b6-4c13-a486-aff20e35ad59	2026-05-05 18:00:27.006167+00	2026-05-05 18:00:32.553889+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 18:00:27.006167+00
deb4fd2c-5226-4299-8402-e97a24286b61	2026-05-05 19:00:32.906471+00	2026-05-05 19:00:36.776474+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 19:00:32.906471+00
7700374f-cb81-424d-93d0-0bcc5e46bb60	2026-05-05 20:00:37.115371+00	2026-05-05 20:00:58.460851+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 20:00:37.115371+00
460ba0a7-f582-4df6-9cf9-e820679df9a6	2026-05-05 21:00:25.751196+00	2026-05-05 21:00:50.452639+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 21:00:25.751196+00
7b0b2641-e6d6-4507-b364-98fe10a38169	2026-05-05 22:00:50.880873+00	2026-05-05 22:01:03.345628+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 22:00:50.880873+00
ea0e6bd3-f842-4c10-87d8-2a8e76d6e6c2	2026-05-05 23:00:03.580509+00	2026-05-05 23:00:09.62183+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-05 23:00:03.580509+00
1c061f66-7446-4081-ad5e-a0e4ec295c83	2026-05-13 22:00:16.090208+00	2026-05-13 22:00:19.96107+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-13 22:00:16.090208+00
f5573206-0789-45e1-8974-a3b45b94ad91	2026-05-13 23:00:20.254638+00	2026-05-13 23:00:23.425484+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-13 23:00:20.254638+00
02158370-f247-40ac-9fba-d350ec1d3bad	2026-05-14 00:00:23.699479+00	2026-05-14 00:00:27.374226+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-14 00:00:23.699479+00
1e758198-0db2-483a-9b07-7c049503bb6b	2026-05-14 01:00:27.773791+00	2026-05-14 01:00:30.719248+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-14 01:00:27.773791+00
7012d403-5e48-41b3-9e20-dfab87d613b3	2026-05-14 02:00:31.11872+00	2026-05-14 02:00:34.072807+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-14 02:00:31.11872+00
d803f557-ba48-474e-833c-c6042b7662de	2026-05-16 12:00:39.511845+00	2026-05-16 12:00:45.928807+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-16 12:00:39.511845+00
2c175f12-51f1-4bbd-adf2-0067a9ba75f1	2026-05-16 13:00:31.702082+00	2026-05-16 13:00:56.306347+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-16 13:00:31.702082+00
4cdef1f9-df68-45a0-9ead-b5f1f0569d53	2026-05-16 14:00:56.636181+00	2026-05-16 14:00:59.996251+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-16 14:00:56.636181+00
460c6b3b-ea8d-425f-b05f-d5605e9f6415	2026-05-16 15:00:17.755882+00	2026-05-16 15:00:21.017027+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-16 15:00:17.755882+00
3eb9f79c-b19d-4a02-a70d-1c6557a5125b	2026-05-16 16:00:21.33459+00	2026-05-16 16:00:24.153357+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-16 16:00:21.33459+00
a710fe2f-f770-4e7b-be7e-0833b6d7dca9	2026-05-16 17:00:24.492338+00	2026-05-16 17:00:27.61714+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-16 17:00:24.492338+00
ad07997a-0709-45e7-9563-72fb246624f7	2026-05-16 18:00:27.908322+00	2026-05-16 18:00:31.064719+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-16 18:00:27.908322+00
0325735a-ee33-482f-a385-0b4fc3faa8a7	2026-05-16 19:00:31.380265+00	2026-05-16 19:00:34.914099+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-16 19:00:31.380265+00
210f81a1-077f-49f6-873c-fdde63274b42	2026-05-16 20:00:35.390453+00	2026-05-16 20:00:38.515594+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-16 20:00:35.390453+00
1dccc4aa-0847-47bd-888d-955a7c53fe4d	2026-05-16 21:00:38.869285+00	2026-05-16 21:00:41.640099+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-16 21:00:38.869285+00
8ff101e1-6de4-4dd8-8ce9-bb655057d91c	2026-05-16 22:00:41.928865+00	2026-05-16 22:00:44.813248+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-16 22:00:41.928865+00
16fdda74-c5b2-4a35-8fd4-51a601487be1	2026-05-16 23:02:34.468011+00	2026-05-16 23:02:41.902797+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-16 23:02:34.468011+00
9b593afe-2c31-4998-ae13-ed7d8821af49	2026-05-17 00:00:42.280394+00	2026-05-17 00:00:45.065616+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-17 00:00:42.280394+00
aad3bfbc-2a1b-41b4-b202-286e82adeafe	2026-05-17 01:00:45.46225+00	2026-05-17 01:00:48.582187+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-17 01:00:45.46225+00
f80f5d24-ea2b-42cd-89fb-bf56f015ddcb	2026-05-17 02:00:49.073746+00	2026-05-17 02:01:17.187136+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-17 02:00:49.073746+00
9dbb553d-8ad2-46c8-b3e6-4679bd70f2f5	2026-05-17 03:00:17.587552+00	2026-05-17 03:00:49.321769+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-17 03:00:17.587552+00
70993b60-1918-4809-8566-1f12b1f33663	2026-05-17 04:00:49.707403+00	2026-05-17 04:00:54.517769+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-17 04:00:49.707403+00
de1007e1-3336-4ccb-80da-c877079be2de	2026-05-17 05:00:54.954527+00	2026-05-17 05:01:13.690471+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-17 05:00:54.954527+00
4725cf66-0d91-49d9-ac88-f00012e5b980	2026-05-17 06:00:14.020539+00	2026-05-17 06:00:20.788636+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-17 06:00:14.020539+00
51239726-c35d-4a7d-93eb-c8a200e2e92d	2026-05-17 07:00:21.039496+00	2026-05-17 07:00:50.766952+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-17 07:00:21.039496+00
ac5da302-aa4b-4a2c-b8b4-f04132f997ff	2026-05-17 08:00:50.886402+00	2026-05-17 08:01:18.063987+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-17 08:00:50.886402+00
135ce9dd-2c82-4ccf-9788-6d0adc4ddede	2026-05-17 09:00:18.808482+00	2026-05-17 09:00:22.231708+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-17 09:00:18.808482+00
0e744756-230a-4898-8c5f-062a3eddb30e	2026-05-17 10:00:22.70143+00	2026-05-17 10:00:25.761667+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-17 10:00:22.70143+00
16e98453-6a24-4d79-a318-c6db635c4b20	2026-05-17 11:00:26.159237+00	2026-05-17 11:00:29.366251+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-17 11:00:26.159237+00
80725464-f494-41df-a92e-653e09485598	2026-05-17 12:00:09.483312+00	2026-05-17 12:00:12.826648+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-17 12:00:09.483312+00
2438f090-3463-496c-993a-08b0b8443bae	2026-05-17 13:00:13.138133+00	2026-05-17 13:00:16.131502+00	SUCCESS	10	10	0	\N	{"cities": ["Cairo", "Riyadh", "Dubai", "Baghdad", "Beirut", "Amman", "Kuwait", "Doha", "Casablanca", "Tunis"]}	2026-05-17 13:00:13.138133+00
\.


--
-- Data for Name: weather_readings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.weather_readings (id, location_id, pipeline_run_id, temp_avg_c, temp_min_c, temp_max_c, humidity_pct, pressure_hpa, wind_speed_kmh, wind_direction_deg, wind_direction, wind_gust_kmh, rain_tomorrow, precipitation_mm, weather_description, observation_timestamp, created_at) FROM stdin;
5c24411e-411c-49e6-a154-4835eb652da8	467c145d-f635-4cb3-9813-63f4d28b8780	ad24079f-b7f1-4a89-846e-4dbd14a49281	27.42	27.42	27.42	36	1007	31.50	10	N	0.00	t	0.00	sand	2026-05-02 17:00:00+00	2026-05-02 17:23:56.27298+00
70b981ac-8521-433b-9e6f-1ecfe45b2a04	f2df8134-8994-487c-8a25-272606e8f953	ad24079f-b7f1-4a89-846e-4dbd14a49281	33.05	33.05	33.05	11	1008	14.90	309	NW	19.91	f	0.00	clear sky	2026-05-02 17:00:00+00	2026-05-02 17:23:56.705616+00
eae32fdd-f60c-48a8-a613-e58a54354883	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	ad24079f-b7f1-4a89-846e-4dbd14a49281	34.96	34.96	35.14	20	1006	5.54	270	W	0.00	f	0.00	clear sky	2026-05-02 17:00:00+00	2026-05-02 17:23:57.11393+00
995966c4-be86-4caf-84bc-5a1dbc914cdf	6411b387-fc37-4b47-878b-8f89fd8e08d9	ad24079f-b7f1-4a89-846e-4dbd14a49281	29.95	29.95	29.95	35	1007	12.96	20	NNE	0.00	t	0.00	clear sky	2026-05-02 17:00:00+00	2026-05-02 17:23:57.52438+00
a91d7179-6fc0-46be-a8c0-2b636ba4b7b5	05546df7-881e-438f-96b9-be0148283901	ad24079f-b7f1-4a89-846e-4dbd14a49281	21.88	21.88	21.88	68	1009	21.31	21	NNE	25.88	t	0.10	overcast clouds	2026-05-02 17:00:00+00	2026-05-02 17:23:57.988838+00
5eafaee9-1791-46b0-8bc5-bc89f93812fd	054b54c2-e6d1-4534-a9de-58bf2831479a	ad24079f-b7f1-4a89-846e-4dbd14a49281	23.05	22.75	23.05	27	1008	0.00	0	N	0.00	t	0.00	broken clouds	2026-05-02 17:00:00+00	2026-05-02 17:23:58.362769+00
399564c5-cbc7-42f6-a0c2-16fcd44cebc1	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	ad24079f-b7f1-4a89-846e-4dbd14a49281	27.10	27.10	27.10	56	1006	17.50	109	ESE	23.94	t	0.00	clear sky	2026-05-02 17:00:00+00	2026-05-02 17:23:58.764506+00
084f9e67-1883-4299-b7ba-c59da4c8f885	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	ad24079f-b7f1-4a89-846e-4dbd14a49281	30.97	30.94	32.17	32	1006	9.25	100	E	0.00	f	0.00	clear sky	2026-05-02 17:00:00+00	2026-05-02 17:23:59.100528+00
71f02bae-468f-4dd4-b941-85040e3e8215	72829d11-3ace-445b-9f4b-5c3c72c3521f	ad24079f-b7f1-4a89-846e-4dbd14a49281	19.13	19.07	21.12	63	1017	12.96	20	NNE	0.00	t	0.00	scattered clouds	2026-05-02 17:00:00+00	2026-05-02 17:23:59.459559+00
c5f02fae-1796-4c60-a145-0e9ef5600fe0	5bd52475-ffa2-40f6-82e4-3d0491b7e246	ad24079f-b7f1-4a89-846e-4dbd14a49281	23.38	23.38	23.38	28	1019	30.96	87	E	29.45	f	0.00	clear sky	2026-05-02 17:00:00+00	2026-05-02 17:23:59.931277+00
e9e1a435-442b-4258-af38-d7f2aee21f61	467c145d-f635-4cb3-9813-63f4d28b8780	e4699519-dc93-4696-9440-1806be8d738e	24.42	24.12	24.42	38	1007	38.88	0	N	0.00	t	0.00	sand	2026-05-02 18:00:00+00	2026-05-02 18:00:11.256509+00
0c02fb49-c0ed-4617-a47b-b4e5883748a5	f2df8134-8994-487c-8a25-272606e8f953	e4699519-dc93-4696-9440-1806be8d738e	32.06	32.06	32.06	12	1009	14.72	326	NW	19.80	f	0.00	clear sky	2026-05-02 18:00:00+00	2026-05-02 18:00:12.014005+00
56aba25c-1bcc-47fd-8110-d106a17fe1e9	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	e4699519-dc93-4696-9440-1806be8d738e	34.96	34.96	35.14	21	1007	9.25	260	W	0.00	f	0.00	clear sky	2026-05-02 18:00:00+00	2026-05-02 18:00:12.405019+00
43afd30c-30e0-499a-abfd-203e03553e7c	6411b387-fc37-4b47-878b-8f89fd8e08d9	e4699519-dc93-4696-9440-1806be8d738e	29.95	29.95	29.95	35	1007	12.96	20	NNE	0.00	t	0.00	clear sky	2026-05-02 18:00:00+00	2026-05-02 18:00:12.855703+00
c5427f3b-be98-4636-8759-92bc8b0b3e25	05546df7-881e-438f-96b9-be0148283901	e4699519-dc93-4696-9440-1806be8d738e	21.88	21.88	21.88	71	1009	20.59	9	N	24.52	t	0.00	overcast clouds	2026-05-02 18:00:00+00	2026-05-02 18:00:13.194419+00
a1b280b9-ffba-4dd2-9801-bcc60162fb2f	054b54c2-e6d1-4534-a9de-58bf2831479a	e4699519-dc93-4696-9440-1806be8d738e	23.05	22.75	23.05	27	1009	0.00	0	N	0.00	t	0.00	broken clouds	2026-05-02 18:00:00+00	2026-05-02 18:00:13.624477+00
e1a7b7a0-c286-40d8-8ddb-72926a137533	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	e4699519-dc93-4696-9440-1806be8d738e	27.10	27.10	27.10	58	1007	15.30	131	SE	19.62	t	0.00	clear sky	2026-05-02 18:00:00+00	2026-05-02 18:00:13.956088+00
f9602991-b1ec-4a6e-baa0-f816d4a5a41a	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	e4699519-dc93-4696-9440-1806be8d738e	30.97	30.94	32.17	30	1007	9.25	100	E	0.00	f	0.00	clear sky	2026-05-02 18:00:00+00	2026-05-02 18:00:14.292466+00
062035d5-9e69-4d0b-a774-a7f32a1c94da	72829d11-3ace-445b-9f4b-5c3c72c3521f	e4699519-dc93-4696-9440-1806be8d738e	19.13	19.07	20.12	63	1017	12.96	20	NNE	0.00	t	0.00	scattered clouds	2026-05-02 18:00:00+00	2026-05-02 18:00:14.635038+00
0cb9e652-cd15-4b75-9fd5-0c384754e122	5bd52475-ffa2-40f6-82e4-3d0491b7e246	e4699519-dc93-4696-9440-1806be8d738e	20.63	20.63	20.63	44	1020	31.61	95	E	31.90	f	0.00	clear sky	2026-05-02 18:00:00+00	2026-05-02 18:00:14.982041+00
77a92cef-4027-4781-9163-1db7e9323d58	467c145d-f635-4cb3-9813-63f4d28b8780	722e01b5-33d5-47c7-b819-a309b5e7ce3f	23.42	23.01	23.42	46	1008	35.17	0	N	0.00	t	0.00	overcast clouds	2026-05-02 19:00:00+00	2026-05-02 19:00:00.755035+00
f886d5ea-e9b5-4867-a578-f0d1a128473d	f2df8134-8994-487c-8a25-272606e8f953	722e01b5-33d5-47c7-b819-a309b5e7ce3f	31.19	31.19	31.19	12	1009	12.78	326	NW	15.26	f	0.00	clear sky	2026-05-02 19:00:00+00	2026-05-02 19:00:01.102001+00
f9564a63-f59f-4676-a131-02c25de80494	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	722e01b5-33d5-47c7-b819-a309b5e7ce3f	33.96	33.14	33.96	26	1007	11.12	270	W	0.00	f	0.00	clear sky	2026-05-02 19:00:00+00	2026-05-02 19:00:01.505546+00
b79198b1-859c-45d4-ba74-833cf90cbf43	6411b387-fc37-4b47-878b-8f89fd8e08d9	722e01b5-33d5-47c7-b819-a309b5e7ce3f	29.95	29.95	29.95	32	1007	12.96	40	NE	0.00	t	0.00	clear sky	2026-05-02 19:00:00+00	2026-05-02 19:00:01.837146+00
0e73f772-086a-43a5-a9cf-1db95fd6cd92	05546df7-881e-438f-96b9-be0148283901	722e01b5-33d5-47c7-b819-a309b5e7ce3f	21.88	21.88	21.88	73	1009	20.59	348	NNW	21.46	t	0.00	overcast clouds	2026-05-02 19:00:00+00	2026-05-02 19:00:02.180317+00
af860ef0-7c8a-4615-9bcf-4ad0d5df516f	054b54c2-e6d1-4534-a9de-58bf2831479a	722e01b5-33d5-47c7-b819-a309b5e7ce3f	22.05	21.75	22.05	30	1008	0.00	0	N	0.00	t	0.00	overcast clouds	2026-05-02 19:00:00+00	2026-05-02 19:00:02.541764+00
588f04e1-1856-47ec-88dd-52f0103cc7fc	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	722e01b5-33d5-47c7-b819-a309b5e7ce3f	26.55	26.55	26.55	61	1007	14.26	138	SE	18.14	t	0.00	clear sky	2026-05-02 19:00:00+00	2026-05-02 19:00:02.893066+00
5f5fb6f1-1fa5-48b5-a501-2d37974245fc	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	722e01b5-33d5-47c7-b819-a309b5e7ce3f	30.97	30.94	31.17	36	1007	11.12	90	E	0.00	f	0.00	clear sky	2026-05-02 19:00:00+00	2026-05-02 19:00:03.230801+00
8c469be6-2fe4-4f0a-9d9f-1a42d9bae0de	72829d11-3ace-445b-9f4b-5c3c72c3521f	722e01b5-33d5-47c7-b819-a309b5e7ce3f	19.13	19.07	19.19	63	1017	9.25	50	NE	0.00	t	0.00	few clouds	2026-05-02 19:00:00+00	2026-05-02 19:00:03.586395+00
d55f6fba-51d4-4b78-8f1d-cb332fe6efcf	5bd52475-ffa2-40f6-82e4-3d0491b7e246	722e01b5-33d5-47c7-b819-a309b5e7ce3f	19.77	19.77	19.77	47	1022	29.74	91	E	33.01	f	0.00	clear sky	2026-05-02 19:00:00+00	2026-05-02 19:00:03.909275+00
5abbd522-17cb-4b20-be61-be2e8fde491d	467c145d-f635-4cb3-9813-63f4d28b8780	f0729683-fd30-461d-8035-1ac2da9fa2e4	22.42	21.90	22.42	49	1008	33.34	10	N	0.00	t	0.00	clear sky	2026-05-02 20:00:00+00	2026-05-02 20:00:04.618792+00
e009bbce-8c91-4818-97ec-fea50324b38d	f2df8134-8994-487c-8a25-272606e8f953	f0729683-fd30-461d-8035-1ac2da9fa2e4	30.30	30.30	30.30	13	1010	12.02	332	NNW	14.04	f	0.00	clear sky	2026-05-02 20:00:00+00	2026-05-02 20:00:04.929935+00
03c91796-ed5a-4c89-b2e8-2260debd3bb7	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	f0729683-fd30-461d-8035-1ac2da9fa2e4	32.96	32.14	32.96	27	1007	11.12	270	W	0.00	f	0.00	clear sky	2026-05-02 20:00:00+00	2026-05-02 20:00:05.259499+00
463dd3ab-8f38-46ac-b08e-1c7598580fe1	6411b387-fc37-4b47-878b-8f89fd8e08d9	f0729683-fd30-461d-8035-1ac2da9fa2e4	28.95	28.95	28.95	34	1008	16.67	50	NE	0.00	t	0.00	clear sky	2026-05-02 20:00:00+00	2026-05-02 20:00:05.578235+00
b4ce00a1-358c-4f95-93bc-4a62345128a4	05546df7-881e-438f-96b9-be0148283901	f0729683-fd30-461d-8035-1ac2da9fa2e4	22.43	22.43	22.43	73	1009	23.08	2	N	27.47	t	0.00	overcast clouds	2026-05-02 20:00:00+00	2026-05-02 20:00:05.899317+00
c35baf8d-156f-47e3-b66c-6657cdf10061	054b54c2-e6d1-4534-a9de-58bf2831479a	f0729683-fd30-461d-8035-1ac2da9fa2e4	21.05	20.75	21.05	35	1008	7.42	90	E	0.00	t	0.00	overcast clouds	2026-05-02 20:00:00+00	2026-05-02 20:00:06.236786+00
a941e025-591f-4d6b-8b1d-7d3561660e2f	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	f0729683-fd30-461d-8035-1ac2da9fa2e4	27.10	27.10	27.10	56	1007	15.95	145	SE	21.96	t	0.00	clear sky	2026-05-02 20:00:00+00	2026-05-02 20:00:06.562202+00
90822628-8091-4151-a19b-573e5a63b724	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	f0729683-fd30-461d-8035-1ac2da9fa2e4	30.38	29.99	31.17	36	1007	5.54	100	E	0.00	t	0.00	clear sky	2026-05-02 20:00:00+00	2026-05-02 20:00:06.884916+00
21f5f649-13c2-4687-8276-88c600e38bbc	72829d11-3ace-445b-9f4b-5c3c72c3521f	f0729683-fd30-461d-8035-1ac2da9fa2e4	18.07	17.12	18.19	72	1018	7.42	50	NE	0.00	f	0.00	clear sky	2026-05-02 20:00:00+00	2026-05-02 20:00:07.226119+00
30632601-9586-4f97-87ad-e857fcad5130	5bd52475-ffa2-40f6-82e4-3d0491b7e246	f0729683-fd30-461d-8035-1ac2da9fa2e4	18.88	18.88	18.88	54	1022	29.84	91	E	36.83	f	0.00	clear sky	2026-05-02 20:00:00+00	2026-05-02 20:00:07.545693+00
dc57cdc7-8316-4ad7-b921-9ed4fb958f26	467c145d-f635-4cb3-9813-63f4d28b8780	42c221f5-e373-44dc-b878-4579860ac8f4	22.42	21.90	22.42	53	1008	31.50	20	NNE	0.00	t	0.00	clear sky	2026-05-02 21:00:00+00	2026-05-02 21:00:08.411625+00
0855ba16-ad83-4a07-82de-b90d8fe3ee57	f2df8134-8994-487c-8a25-272606e8f953	42c221f5-e373-44dc-b878-4579860ac8f4	29.59	29.59	29.59	13	1010	11.16	335	NNW	12.28	t	0.00	clear sky	2026-05-02 21:00:00+00	2026-05-02 21:00:08.787825+00
81c55b9a-54ce-4328-bade-9d62805d61a2	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	42c221f5-e373-44dc-b878-4579860ac8f4	32.96	32.14	32.96	29	1006	11.12	270	W	0.00	f	0.00	clear sky	2026-05-02 21:00:00+00	2026-05-02 21:00:09.13711+00
8a4cea43-a2a5-4439-bf21-1b47b5cd59ba	6411b387-fc37-4b47-878b-8f89fd8e08d9	42c221f5-e373-44dc-b878-4579860ac8f4	28.95	28.95	28.95	32	1007	16.67	60	ENE	0.00	t	0.00	clear sky	2026-05-02 21:00:00+00	2026-05-02 21:00:09.4878+00
d1e49e6f-6142-4b01-91a8-d6c680c707c4	05546df7-881e-438f-96b9-be0148283901	42c221f5-e373-44dc-b878-4579860ac8f4	22.99	22.99	22.99	71	1007	31.00	18	NNE	36.47	t	0.00	overcast clouds	2026-05-02 21:00:00+00	2026-05-02 21:00:09.850797+00
0017c13e-230b-4e26-a9c3-3582a9859b75	054b54c2-e6d1-4534-a9de-58bf2831479a	42c221f5-e373-44dc-b878-4579860ac8f4	20.05	19.75	20.05	28	1008	7.42	70	ENE	0.00	t	0.00	overcast clouds	2026-05-02 21:00:00+00	2026-05-02 21:00:10.194475+00
715f3db6-172b-4ff3-abd6-bb22d1a69f61	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	42c221f5-e373-44dc-b878-4579860ac8f4	27.66	27.66	27.66	51	1006	14.51	160	SSE	19.30	t	0.00	clear sky	2026-05-02 21:00:00+00	2026-05-02 21:00:11.001444+00
009866a7-c32a-4460-a280-9fcc9cca6fbd	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	42c221f5-e373-44dc-b878-4579860ac8f4	29.97	29.94	30.17	36	1006	3.71	0	N	0.00	t	0.00	clear sky	2026-05-02 21:00:00+00	2026-05-02 21:00:11.360791+00
0ba9f2f0-6d93-40a2-b0a5-a157309c5d5a	72829d11-3ace-445b-9f4b-5c3c72c3521f	42c221f5-e373-44dc-b878-4579860ac8f4	18.07	17.12	18.19	72	1019	7.42	10	N	0.00	f	0.00	broken clouds	2026-05-02 21:00:00+00	2026-05-02 21:00:11.734629+00
9a03d4d2-bd9e-4952-929a-cc3acd32638b	5bd52475-ffa2-40f6-82e4-3d0491b7e246	42c221f5-e373-44dc-b878-4579860ac8f4	18.27	18.27	18.27	59	1023	27.76	91	E	37.48	f	0.00	clear sky	2026-05-02 21:00:00+00	2026-05-02 21:00:12.068611+00
fd003812-d13d-4d16-ac75-e5f00488c4f5	467c145d-f635-4cb3-9813-63f4d28b8780	a57dd1f4-daa7-48c8-b58f-ab97c8932f84	21.42	20.79	21.42	56	1008	29.63	40	NE	0.00	t	0.00	clear sky	2026-05-02 22:00:00+00	2026-05-02 22:00:13.725747+00
8b518fd1-1f2f-4f4d-a418-aae7db0a24cc	f2df8134-8994-487c-8a25-272606e8f953	a57dd1f4-daa7-48c8-b58f-ab97c8932f84	28.87	28.87	28.87	14	1010	12.92	335	NNW	14.65	t	0.00	clear sky	2026-05-02 22:00:00+00	2026-05-02 22:00:14.695384+00
aa7ca7dc-ab55-47bf-8846-469c9ec45235	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	a57dd1f4-daa7-48c8-b58f-ab97c8932f84	32.96	32.14	32.96	31	1006	12.96	260	W	0.00	f	0.00	clear sky	2026-05-02 22:00:00+00	2026-05-02 22:00:15.564969+00
f44939c5-11d2-44af-aba4-38c7e966de58	6411b387-fc37-4b47-878b-8f89fd8e08d9	a57dd1f4-daa7-48c8-b58f-ab97c8932f84	27.95	27.95	27.95	36	1006	16.67	70	ENE	0.00	t	0.00	clear sky	2026-05-02 22:00:00+00	2026-05-02 22:00:16.538364+00
91a9c6db-1d45-4034-945a-1188cfffca24	05546df7-881e-438f-96b9-be0148283901	a57dd1f4-daa7-48c8-b58f-ab97c8932f84	24.10	24.10	24.10	69	1006	27.94	17	NNE	34.24	t	0.00	overcast clouds	2026-05-02 22:00:00+00	2026-05-02 22:00:17.030851+00
3f35a8cd-7a05-4992-bd13-4ae4274cdf0c	054b54c2-e6d1-4534-a9de-58bf2831479a	a57dd1f4-daa7-48c8-b58f-ab97c8932f84	20.05	19.75	20.05	30	1008	5.54	100	E	0.00	t	0.00	overcast clouds	2026-05-02 22:00:00+00	2026-05-02 22:00:17.435642+00
f56d7cc2-68f6-4eeb-9357-2ce712b0d06e	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	a57dd1f4-daa7-48c8-b58f-ab97c8932f84	27.66	27.66	27.66	42	1006	13.28	172	S	18.76	t	0.00	clear sky	2026-05-02 22:00:00+00	2026-05-02 22:00:17.807734+00
f7a13b89-a917-4434-9399-c1c6c7950232	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	a57dd1f4-daa7-48c8-b58f-ab97c8932f84	29.97	29.94	30.17	38	1006	7.42	160	SSE	0.00	t	0.00	clear sky	2026-05-02 22:00:00+00	2026-05-02 22:00:18.340277+00
30696bb9-99d5-4ea9-a702-856b9044c924	72829d11-3ace-445b-9f4b-5c3c72c3521f	a57dd1f4-daa7-48c8-b58f-ab97c8932f84	18.07	16.12	18.19	72	1018	5.54	40	NE	0.00	f	0.00	broken clouds	2026-05-02 22:00:00+00	2026-05-02 22:00:18.973805+00
81c40588-576c-4e5b-932b-8773da27e900	5bd52475-ffa2-40f6-82e4-3d0491b7e246	a57dd1f4-daa7-48c8-b58f-ab97c8932f84	17.83	17.83	17.83	65	1023	23.83	89	E	35.28	f	0.00	clear sky	2026-05-02 22:00:00+00	2026-05-02 22:00:19.623804+00
e593f540-58b6-46a2-ab45-2c0050885297	467c145d-f635-4cb3-9813-63f4d28b8780	9a9676b3-300c-4d23-a3d9-703dc6bb95d1	20.42	20.23	20.42	64	1008	20.38	20	NNE	0.00	t	0.00	clear sky	2026-05-02 23:00:00+00	2026-05-02 23:00:20.784992+00
7827f66c-2cc4-43b9-9b4d-4b9fa6e75a51	f2df8134-8994-487c-8a25-272606e8f953	9a9676b3-300c-4d23-a3d9-703dc6bb95d1	28.03	28.03	28.03	17	1009	13.72	336	NNW	16.74	f	0.00	clear sky	2026-05-02 23:00:00+00	2026-05-02 23:00:21.558464+00
c86bf2e7-0986-4c99-be30-c23c0a67f3c0	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	9a9676b3-300c-4d23-a3d9-703dc6bb95d1	31.96	31.14	31.96	35	1006	5.54	190	S	0.00	f	0.00	clear sky	2026-05-02 23:00:00+00	2026-05-02 23:00:22.312061+00
82648a4f-d451-4803-9b06-49a6e82be355	6411b387-fc37-4b47-878b-8f89fd8e08d9	9a9676b3-300c-4d23-a3d9-703dc6bb95d1	26.95	26.95	26.95	41	1006	11.12	80	E	0.00	t	0.00	clear sky	2026-05-02 23:00:00+00	2026-05-02 23:00:23.065079+00
a87909ea-b573-4731-a5bb-bc183658df92	05546df7-881e-438f-96b9-be0148283901	9a9676b3-300c-4d23-a3d9-703dc6bb95d1	20.37	20.37	20.37	66	1005	27.11	13	NNE	32.40	t	0.00	overcast clouds	2026-05-02 23:00:00+00	2026-05-02 23:00:23.771509+00
dbdeb672-6e5a-4a87-a52b-ca3b171b3c6a	054b54c2-e6d1-4534-a9de-58bf2831479a	9a9676b3-300c-4d23-a3d9-703dc6bb95d1	19.05	18.75	19.05	34	1007	0.00	0	N	0.00	t	0.00	overcast clouds	2026-05-02 23:00:00+00	2026-05-02 23:00:24.493909+00
f29f13a4-0cb8-4e86-9b14-c44037c0ccd0	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	9a9676b3-300c-4d23-a3d9-703dc6bb95d1	27.66	27.66	27.66	44	1006	12.85	190	S	18.72	t	0.00	clear sky	2026-05-02 23:00:00+00	2026-05-02 23:00:25.171769+00
d5311fff-60d5-4646-aa65-11aa41e3ac12	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	9a9676b3-300c-4d23-a3d9-703dc6bb95d1	29.97	29.94	30.17	40	1006	7.42	130	SE	0.00	t	0.00	clear sky	2026-05-02 23:00:00+00	2026-05-02 23:00:25.832577+00
3853f33e-0610-4620-862b-49f3fe73b9b6	72829d11-3ace-445b-9f4b-5c3c72c3521f	9a9676b3-300c-4d23-a3d9-703dc6bb95d1	18.07	16.12	18.19	72	1018	5.54	20	NNE	0.00	f	0.00	broken clouds	2026-05-02 23:00:00+00	2026-05-02 23:00:26.508966+00
8b6767ab-d1c9-495f-ab7e-c5da69aad3d6	5bd52475-ffa2-40f6-82e4-3d0491b7e246	9a9676b3-300c-4d23-a3d9-703dc6bb95d1	17.42	17.42	17.42	70	1023	22.46	87	E	33.66	f	0.00	clear sky	2026-05-02 23:00:00+00	2026-05-02 23:00:27.115744+00
250e3c0d-6f84-4680-8012-927a9e0d5a1f	467c145d-f635-4cb3-9813-63f4d28b8780	3084dc06-7e64-40ad-99c0-b9455b490b6f	20.42	20.23	20.42	64	1008	18.50	50	NE	0.00	t	0.00	clear sky	2026-05-03 00:00:00+00	2026-05-03 00:00:28.102815+00
50fc0e6c-da6d-4dba-bba2-5f5005761986	f2df8134-8994-487c-8a25-272606e8f953	3084dc06-7e64-40ad-99c0-b9455b490b6f	27.46	27.46	27.46	19	1010	7.56	332	NNW	8.46	f	0.00	clear sky	2026-05-03 00:00:00+00	2026-05-03 00:00:28.457362+00
126aac21-885e-42d6-85f0-a70563574244	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	3084dc06-7e64-40ad-99c0-b9455b490b6f	31.96	31.14	31.96	35	1006	9.25	250	WSW	0.00	f	0.00	clear sky	2026-05-03 00:00:00+00	2026-05-03 00:00:28.880054+00
8a2fbfd8-ec5b-4ea7-b1fd-81fe4ef27a04	6411b387-fc37-4b47-878b-8f89fd8e08d9	3084dc06-7e64-40ad-99c0-b9455b490b6f	26.95	26.95	26.95	41	1006	14.83	80	E	0.00	t	0.00	clear sky	2026-05-03 00:00:00+00	2026-05-03 00:00:29.365874+00
e9a70a73-f01c-4ee3-a5e6-d84f105b0239	05546df7-881e-438f-96b9-be0148283901	3084dc06-7e64-40ad-99c0-b9455b490b6f	19.81	19.81	19.81	72	1005	29.74	0	N	32.76	t	0.00	overcast clouds	2026-05-03 00:00:00+00	2026-05-03 00:00:29.985162+00
27443b9f-d00f-41a8-a6c2-2fcf7ed6489d	054b54c2-e6d1-4534-a9de-58bf2831479a	3084dc06-7e64-40ad-99c0-b9455b490b6f	19.05	18.75	19.05	32	1007	7.42	240	WSW	0.00	t	0.00	overcast clouds	2026-05-03 00:00:00+00	2026-05-03 00:00:30.626538+00
38379eca-7442-4b7d-8fe3-0dd6aa870941	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	3084dc06-7e64-40ad-99c0-b9455b490b6f	27.66	27.66	27.66	45	1007	12.24	189	S	18.18	t	0.00	clear sky	2026-05-03 00:00:00+00	2026-05-03 00:00:31.356982+00
d93a397b-1718-4bc0-a0fe-4e6b893d7d23	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	3084dc06-7e64-40ad-99c0-b9455b490b6f	28.57	27.94	29.17	46	1006	1.84	0	N	0.00	t	0.00	clear sky	2026-05-03 00:00:00+00	2026-05-03 00:00:32.149075+00
7080306b-fab3-426b-a88c-e52df4d6fae9	72829d11-3ace-445b-9f4b-5c3c72c3521f	3084dc06-7e64-40ad-99c0-b9455b490b6f	17.02	16.12	17.19	77	1018	3.71	0	N	0.00	f	0.00	broken clouds	2026-05-03 00:00:00+00	2026-05-03 00:00:32.873099+00
26d32d75-b2c6-4fd4-96fc-45d357da1954	5bd52475-ffa2-40f6-82e4-3d0491b7e246	3084dc06-7e64-40ad-99c0-b9455b490b6f	16.89	16.89	16.89	75	1022	20.70	84	E	31.75	f	0.00	few clouds	2026-05-03 00:00:00+00	2026-05-03 00:00:33.532087+00
4c72d2f5-040d-4a72-8e35-db78659cda0b	467c145d-f635-4cb3-9813-63f4d28b8780	1ac1a2f2-279e-4b84-87a9-52071acec917	19.42	19.12	19.42	68	1008	14.83	50	NE	0.00	t	0.00	clear sky	2026-05-03 01:00:00+00	2026-05-03 01:00:34.37771+00
4d46df39-02ee-4e61-9678-9926ba6d6266	f2df8134-8994-487c-8a25-272606e8f953	1ac1a2f2-279e-4b84-87a9-52071acec917	26.78	26.78	26.78	19	1010	6.52	334	NNW	7.13	f	0.00	clear sky	2026-05-03 01:00:00+00	2026-05-03 01:00:34.703394+00
ca4d4ecd-49ec-48e1-8028-e4e30f62a12f	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	1ac1a2f2-279e-4b84-87a9-52071acec917	31.96	31.14	31.96	40	1006	11.12	270	W	0.00	f	0.00	clear sky	2026-05-03 01:00:00+00	2026-05-03 01:00:35.021011+00
05b47c96-d3b3-4c2b-84af-34650f5ac033	6411b387-fc37-4b47-878b-8f89fd8e08d9	1ac1a2f2-279e-4b84-87a9-52071acec917	26.95	26.95	26.95	36	1007	12.96	100	E	0.00	t	0.00	clear sky	2026-05-03 01:00:00+00	2026-05-03 01:00:35.345714+00
f450a348-4d71-4647-b6d9-3f403ee2ac59	05546df7-881e-438f-96b9-be0148283901	1ac1a2f2-279e-4b84-87a9-52071acec917	19.62	19.62	19.62	80	1007	30.64	9	N	33.80	t	0.00	overcast clouds	2026-05-03 01:00:00+00	2026-05-03 01:00:35.703076+00
2e13e6dc-f9ce-4ca8-a9e7-0fe262a32cfe	054b54c2-e6d1-4534-a9de-58bf2831479a	1ac1a2f2-279e-4b84-87a9-52071acec917	21.05	17.75	21.05	26	1007	7.42	120	ESE	0.00	f	0.00	broken clouds	2026-05-03 01:00:00+00	2026-05-03 01:00:36.026794+00
648fe3ae-2f35-4900-8901-a4f7378041af	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	1ac1a2f2-279e-4b84-87a9-52071acec917	27.66	27.66	27.66	46	1007	12.92	195	SSW	18.04	f	0.00	clear sky	2026-05-03 01:00:00+00	2026-05-03 01:00:36.344511+00
a1c8e827-1194-4d86-8a35-3f45594f0fb5	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	1ac1a2f2-279e-4b84-87a9-52071acec917	28.97	28.94	30.17	41	1006	5.54	110	ESE	0.00	t	0.00	clear sky	2026-05-03 01:00:00+00	2026-05-03 01:00:36.715705+00
95b1ed65-f3bc-4419-b401-934f53a27a06	72829d11-3ace-445b-9f4b-5c3c72c3521f	1ac1a2f2-279e-4b84-87a9-52071acec917	17.02	15.12	17.19	77	1017	5.54	40	NE	0.00	f	0.00	overcast clouds	2026-05-03 01:00:00+00	2026-05-03 01:00:37.063912+00
7e675be5-c784-4d38-b1ef-cebde5d70fb5	5bd52475-ffa2-40f6-82e4-3d0491b7e246	1ac1a2f2-279e-4b84-87a9-52071acec917	16.62	16.62	16.62	78	1022	16.81	75	ENE	27.29	f	0.00	overcast clouds	2026-05-03 01:00:00+00	2026-05-03 01:00:37.405643+00
cdec052f-bd1d-4090-8b42-5fa04b82a214	467c145d-f635-4cb3-9813-63f4d28b8780	e2d77a45-6201-4141-a2e6-d53fbef1e392	19.42	19.12	19.42	72	1008	12.96	30	NNE	0.00	t	0.00	clear sky	2026-05-03 02:00:00+00	2026-05-03 02:00:38.134929+00
20491bf9-b647-4917-82a4-60f0bee923a6	f2df8134-8994-487c-8a25-272606e8f953	e2d77a45-6201-4141-a2e6-d53fbef1e392	26.82	26.82	26.82	18	1011	7.24	342	NNW	7.78	f	0.00	clear sky	2026-05-03 02:00:00+00	2026-05-03 02:00:38.475093+00
0eed9b64-873a-493a-a35f-99f35537035d	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	e2d77a45-6201-4141-a2e6-d53fbef1e392	31.96	27.14	31.96	40	1007	7.42	250	WSW	0.00	f	0.00	clear sky	2026-05-03 02:00:00+00	2026-05-03 02:00:38.848527+00
3dadb82e-bcda-4321-b71c-f333704fa0b4	6411b387-fc37-4b47-878b-8f89fd8e08d9	e2d77a45-6201-4141-a2e6-d53fbef1e392	24.95	24.95	24.95	44	1007	12.96	140	SE	0.00	t	0.00	clear sky	2026-05-03 02:00:00+00	2026-05-03 02:00:39.192498+00
10a208a9-254a-41c3-897e-90ef8b09b801	05546df7-881e-438f-96b9-be0148283901	e2d77a45-6201-4141-a2e6-d53fbef1e392	19.65	19.65	19.65	81	1006	34.85	357	N	35.17	t	0.00	overcast clouds	2026-05-03 02:00:00+00	2026-05-03 02:00:39.556696+00
a4c17401-1807-47c6-af19-e679b58bc311	054b54c2-e6d1-4534-a9de-58bf2831479a	e2d77a45-6201-4141-a2e6-d53fbef1e392	21.05	16.75	21.05	19	1006	11.12	140	SE	0.00	f	0.00	broken clouds	2026-05-03 02:00:00+00	2026-05-03 02:00:39.915748+00
b97fcad9-bb81-4f37-a97a-93cbfd3a0276	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	e2d77a45-6201-4141-a2e6-d53fbef1e392	26.55	26.55	26.55	47	1008	13.75	205	SSW	18.50	t	0.00	clear sky	2026-05-03 02:00:00+00	2026-05-03 02:00:40.25864+00
6b608af1-143c-4132-92b5-0dea37852d38	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	e2d77a45-6201-4141-a2e6-d53fbef1e392	28.16	26.94	29.17	47	1007	3.71	340	NNW	0.00	t	0.00	clear sky	2026-05-03 02:00:00+00	2026-05-03 02:00:40.606883+00
d5cc0e4e-bff4-43b3-aa7b-478875fdc69c	72829d11-3ace-445b-9f4b-5c3c72c3521f	e2d77a45-6201-4141-a2e6-d53fbef1e392	17.02	15.12	17.19	82	1016	3.71	0	N	0.00	f	0.00	broken clouds	2026-05-03 02:00:00+00	2026-05-03 02:00:40.925638+00
ad703688-9efe-4480-95ac-131a6f53713c	5bd52475-ffa2-40f6-82e4-3d0491b7e246	e2d77a45-6201-4141-a2e6-d53fbef1e392	16.37	16.37	16.37	78	1022	13.61	65	ENE	22.25	f	0.00	broken clouds	2026-05-03 02:00:00+00	2026-05-03 02:00:41.277053+00
d8730bb0-6ca7-479d-b562-38fcc2919e7b	467c145d-f635-4cb3-9813-63f4d28b8780	76515786-a47b-4fc4-b231-5039858072b7	19.42	19.12	19.42	72	1008	9.25	50	NE	0.00	t	0.00	clear sky	2026-05-03 03:00:00+00	2026-05-03 03:00:41.984682+00
8bdb3eda-7423-4034-9dea-28df1088838d	f2df8134-8994-487c-8a25-272606e8f953	76515786-a47b-4fc4-b231-5039858072b7	27.10	27.10	27.10	20	1012	11.41	330	NNW	12.38	t	0.00	clear sky	2026-05-03 03:00:00+00	2026-05-03 03:00:42.307888+00
192eea35-317f-4b53-a407-a93b35b8c536	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	76515786-a47b-4fc4-b231-5039858072b7	29.96	27.14	29.96	42	1008	7.42	170	S	0.00	t	0.00	clear sky	2026-05-03 03:00:00+00	2026-05-03 03:00:42.6587+00
151d4248-e044-4863-b159-b8850bdda4fb	6411b387-fc37-4b47-878b-8f89fd8e08d9	76515786-a47b-4fc4-b231-5039858072b7	23.95	23.95	23.95	46	1007	14.83	120	ESE	0.00	t	0.00	clear sky	2026-05-03 03:00:00+00	2026-05-03 03:00:42.977334+00
2b91dd84-2b85-406b-b270-38dfe101014b	05546df7-881e-438f-96b9-be0148283901	76515786-a47b-4fc4-b231-5039858072b7	18.54	18.54	18.54	85	1005	38.56	8	N	40.21	t	0.00	overcast clouds	2026-05-03 03:00:00+00	2026-05-03 03:00:43.293135+00
f85034d6-e006-4bcd-901e-0d98b4e4c13b	054b54c2-e6d1-4534-a9de-58bf2831479a	76515786-a47b-4fc4-b231-5039858072b7	19.05	16.75	19.05	27	1006	9.25	230	SW	0.00	f	0.00	scattered clouds	2026-05-03 03:00:00+00	2026-05-03 03:00:43.608519+00
f0e641b2-09c0-47da-9422-56589c04e811	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	76515786-a47b-4fc4-b231-5039858072b7	26.55	26.55	26.55	56	1008	11.45	200	SSW	15.26	t	0.00	clear sky	2026-05-03 03:00:00+00	2026-05-03 03:00:43.918113+00
b5dab872-7b0d-4687-8854-c06a761c24f9	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	76515786-a47b-4fc4-b231-5039858072b7	27.97	27.94	28.17	54	1007	5.54	20	NNE	0.00	t	0.00	clear sky	2026-05-03 03:00:00+00	2026-05-03 03:00:44.229708+00
cf7b56c4-7bb0-4fe0-8b5d-dcc6c36aed4f	72829d11-3ace-445b-9f4b-5c3c72c3521f	76515786-a47b-4fc4-b231-5039858072b7	16.85	16.85	17.19	77	1016	3.71	0	N	0.00	t	0.00	broken clouds	2026-05-03 03:00:00+00	2026-05-03 03:00:44.565554+00
5edbc5a3-2cd4-4b05-8827-34a21a9de080	5bd52475-ffa2-40f6-82e4-3d0491b7e246	76515786-a47b-4fc4-b231-5039858072b7	15.97	15.97	15.97	78	1021	11.92	65	ENE	19.98	f	0.00	scattered clouds	2026-05-03 03:00:00+00	2026-05-03 03:00:44.888558+00
51327418-c8ca-403b-a7d4-8e4d74b7473d	467c145d-f635-4cb3-9813-63f4d28b8780	56aeb987-8d56-47cd-8220-f22623c39b68	19.42	19.12	19.42	72	1009	3.71	50	NE	0.00	t	0.00	clear sky	2026-05-03 04:00:00+00	2026-05-03 04:00:45.725959+00
0a13ac15-ddd4-48d6-be83-b046eeb4424e	f2df8134-8994-487c-8a25-272606e8f953	56aeb987-8d56-47cd-8220-f22623c39b68	28.41	28.41	28.41	18	1012	15.91	332	NNW	22.72	t	0.00	clear sky	2026-05-03 04:00:00+00	2026-05-03 04:00:46.037065+00
33fcccb6-8666-4a4e-9512-3775f44c30c3	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	56aeb987-8d56-47cd-8220-f22623c39b68	30.96	29.14	30.96	40	1008	9.25	170	S	0.00	f	0.00	clear sky	2026-05-03 04:00:00+00	2026-05-03 04:00:46.359809+00
3ed70003-713a-493f-8f46-ee91d838608d	6411b387-fc37-4b47-878b-8f89fd8e08d9	56aeb987-8d56-47cd-8220-f22623c39b68	24.95	24.95	24.95	41	1007	18.50	130	SE	0.00	t	0.00	clear sky	2026-05-03 04:00:00+00	2026-05-03 04:00:46.673387+00
2b6acec1-0292-48c2-b9e8-f6bf4d25aa12	05546df7-881e-438f-96b9-be0148283901	56aeb987-8d56-47cd-8220-f22623c39b68	21.88	21.88	21.88	83	1005	38.23	3	N	37.44	t	0.00	overcast clouds	2026-05-03 04:00:00+00	2026-05-03 04:00:47.016942+00
33a1beaa-6ca9-46da-a0be-3e554fb3aadb	054b54c2-e6d1-4534-a9de-58bf2831479a	56aeb987-8d56-47cd-8220-f22623c39b68	19.05	15.75	19.05	24	1007	11.12	260	W	0.00	f	0.00	scattered clouds	2026-05-03 04:00:00+00	2026-05-03 04:00:47.331363+00
7096a630-87ff-4538-b700-debe9b52a77b	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	56aeb987-8d56-47cd-8220-f22623c39b68	27.66	27.66	27.66	62	1009	11.92	217	SW	13.57	t	0.00	clear sky	2026-05-03 04:00:00+00	2026-05-03 04:00:47.654194+00
0e21b343-e073-4340-a3df-c3e1380b212c	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	56aeb987-8d56-47cd-8220-f22623c39b68	27.94	27.94	28.17	57	1008	3.71	0	N	0.00	t	0.00	clear sky	2026-05-03 04:00:00+00	2026-05-03 04:00:47.967415+00
fc7eeeb2-70e9-45af-9ef8-fe55f655abd0	72829d11-3ace-445b-9f4b-5c3c72c3521f	56aeb987-8d56-47cd-8220-f22623c39b68	17.02	15.12	17.19	82	1016	1.84	0	N	0.00	f	0.00	broken clouds	2026-05-03 04:00:00+00	2026-05-03 04:00:48.310987+00
0fc3633c-7996-440d-a567-03acc59dfbef	5bd52475-ffa2-40f6-82e4-3d0491b7e246	56aeb987-8d56-47cd-8220-f22623c39b68	15.37	15.37	15.37	82	1021	13.43	78	ENE	22.72	f	0.00	scattered clouds	2026-05-03 04:00:00+00	2026-05-03 04:00:48.645498+00
1a8a9761-4e21-4968-95d8-3375cd6defbe	467c145d-f635-4cb3-9813-63f4d28b8780	120eab04-0aef-4324-b106-0622b0dd2fc6	19.42	19.12	19.42	63	1009	11.12	320	NW	0.00	t	0.00	clear sky	2026-05-03 05:00:00+00	2026-05-03 05:00:49.378889+00
6da3a4f5-d590-4e71-b2c3-fbbd2dde0d09	f2df8134-8994-487c-8a25-272606e8f953	120eab04-0aef-4324-b106-0622b0dd2fc6	30.48	30.48	30.48	16	1013	17.28	340	NNW	20.27	t	0.00	clear sky	2026-05-03 05:00:00+00	2026-05-03 05:00:49.714583+00
470c4123-76cf-45fc-8377-7fea5a563afa	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	120eab04-0aef-4324-b106-0622b0dd2fc6	31.96	31.14	31.96	37	1008	9.25	160	SSE	0.00	f	0.00	clear sky	2026-05-03 05:00:00+00	2026-05-03 05:00:50.04889+00
eb1b0a9e-4199-49bd-b7cc-014ab4156be1	6411b387-fc37-4b47-878b-8f89fd8e08d9	120eab04-0aef-4324-b106-0622b0dd2fc6	23.95	23.95	23.95	46	1007	12.96	140	SE	0.00	t	0.00	clear sky	2026-05-03 05:00:00+00	2026-05-03 05:00:50.377454+00
f18dbcd3-b5a5-44ff-aa24-01b22de07a56	05546df7-881e-438f-96b9-be0148283901	120eab04-0aef-4324-b106-0622b0dd2fc6	20.17	20.17	20.17	84	1006	33.73	348	NNW	30.78	t	0.00	overcast clouds	2026-05-03 05:00:00+00	2026-05-03 05:00:50.733509+00
186abe00-5311-4a68-96b8-22897640cf07	054b54c2-e6d1-4534-a9de-58bf2831479a	120eab04-0aef-4324-b106-0622b0dd2fc6	20.05	16.75	20.05	26	1007	9.25	240	WSW	0.00	f	0.00	haze	2026-05-03 05:00:00+00	2026-05-03 05:00:51.054655+00
9c69ce0f-641b-4a91-82ba-8c263df2da19	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	120eab04-0aef-4324-b106-0622b0dd2fc6	29.88	29.88	29.88	53	1009	8.32	234	SW	9.11	t	0.00	clear sky	2026-05-03 05:00:00+00	2026-05-03 05:00:51.378137+00
335d3575-cbaa-4488-a2be-c9c663704271	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	120eab04-0aef-4324-b106-0622b0dd2fc6	32.16	30.17	32.99	32	1008	12.96	180	S	0.00	f	0.00	clear sky	2026-05-03 05:00:00+00	2026-05-03 05:00:51.731646+00
8890f459-fd3e-477a-b3b5-54a4c5c8cdfb	72829d11-3ace-445b-9f4b-5c3c72c3521f	120eab04-0aef-4324-b106-0622b0dd2fc6	17.02	15.12	17.19	82	1016	1.84	0	N	0.00	f	0.00	broken clouds	2026-05-03 05:00:00+00	2026-05-03 05:00:52.075999+00
d1afc9d2-9404-43c3-aa1d-d9e22689eedb	5bd52475-ffa2-40f6-82e4-3d0491b7e246	120eab04-0aef-4324-b106-0622b0dd2fc6	15.36	15.36	15.36	79	1021	10.84	82	E	20.45	f	0.00	scattered clouds	2026-05-03 05:00:00+00	2026-05-03 05:00:52.449002+00
efeb9045-ec81-4265-aa0f-52ff0b876124	467c145d-f635-4cb3-9813-63f4d28b8780	3c1f8ea6-ac01-46d4-a809-c122a2975703	21.42	20.79	21.42	52	1009	9.25	280	W	0.00	t	0.00	clear sky	2026-05-03 06:00:00+00	2026-05-03 06:08:33.523423+00
5ee66a14-c275-42c6-b36f-3fc5039c6a10	f2df8134-8994-487c-8a25-272606e8f953	3c1f8ea6-ac01-46d4-a809-c122a2975703	32.14	32.14	32.14	14	1013	18.54	344	NNW	19.08	f	0.00	few clouds	2026-05-03 06:00:00+00	2026-05-03 06:08:36.356651+00
47200d93-ddb2-4998-9176-c89a7b2ff450	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	3c1f8ea6-ac01-46d4-a809-c122a2975703	35.96	35.96	36.14	28	1008	3.71	0	N	0.00	t	0.00	clear sky	2026-05-03 06:00:00+00	2026-05-03 06:08:43.460462+00
40af0f22-8e99-4760-bad0-2a25a367d9f0	6411b387-fc37-4b47-878b-8f89fd8e08d9	3c1f8ea6-ac01-46d4-a809-c122a2975703	27.95	27.95	27.95	36	1007	20.38	150	SSE	0.00	t	0.00	clear sky	2026-05-03 06:00:00+00	2026-05-03 06:08:49.76018+00
f59db41c-91d4-453c-8446-22c231b25f7f	05546df7-881e-438f-96b9-be0148283901	3c1f8ea6-ac01-46d4-a809-c122a2975703	20.61	20.61	20.61	82	1006	27.65	8	N	24.12	t	0.00	overcast clouds	2026-05-03 06:00:00+00	2026-05-03 06:08:52.101331+00
cabd4fea-d6aa-4454-beb0-7daed7ee295d	054b54c2-e6d1-4534-a9de-58bf2831479a	3c1f8ea6-ac01-46d4-a809-c122a2975703	22.86	22.86	22.86	26	1007	31.00	235	SW	48.28	f	0.00	few clouds	2026-05-03 06:00:00+00	2026-05-03 06:09:04.79781+00
fcb7fd15-1929-4725-9429-1451faa42e03	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	3c1f8ea6-ac01-46d4-a809-c122a2975703	28.21	28.21	28.21	60	1008	4.50	236	SW	5.36	t	0.00	clear sky	2026-05-03 06:00:00+00	2026-05-03 06:09:06.476415+00
3ab674de-200a-44e4-875f-98e0e5f3cdc9	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	3c1f8ea6-ac01-46d4-a809-c122a2975703	34.57	33.17	34.99	26	1008	9.25	220	SW	0.00	f	0.00	clear sky	2026-05-03 06:00:00+00	2026-05-03 06:09:08.879133+00
026858a2-aa96-4bc0-953c-aa95e7bf79a4	72829d11-3ace-445b-9f4b-5c3c72c3521f	3c1f8ea6-ac01-46d4-a809-c122a2975703	17.02	15.12	17.19	82	1017	1.84	0	N	0.00	f	0.00	scattered clouds	2026-05-03 06:00:00+00	2026-05-03 06:09:12.94394+00
7238bfe2-5639-448d-ad44-57793777fe24	5bd52475-ffa2-40f6-82e4-3d0491b7e246	3c1f8ea6-ac01-46d4-a809-c122a2975703	15.69	15.69	15.69	79	1022	12.56	88	E	17.42	f	0.00	broken clouds	2026-05-03 06:00:00+00	2026-05-03 06:09:16.984026+00
2f19b0a2-33d9-475f-911e-36f1c6988e76	467c145d-f635-4cb3-9813-63f4d28b8780	730ab2b5-5e02-4c6a-a69f-d827d3b8e22a	21.42	20.79	21.42	52	1010	9.25	280	W	0.00	t	0.00	clear sky	2026-05-03 07:00:00+00	2026-05-03 07:00:18.554587+00
071f9512-57b1-4dbb-afe2-247f5b28e0ee	f2df8134-8994-487c-8a25-272606e8f953	730ab2b5-5e02-4c6a-a69f-d827d3b8e22a	34.14	34.14	34.14	12	1012	18.22	347	NNW	16.81	t	0.00	clear sky	2026-05-03 07:00:00+00	2026-05-03 07:00:19.519905+00
effafbae-77d7-4be3-a30d-2ff6692a9412	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	730ab2b5-5e02-4c6a-a69f-d827d3b8e22a	36.96	36.96	37.14	26	1008	5.54	0	N	0.00	f	0.00	clear sky	2026-05-03 07:00:00+00	2026-05-03 07:00:20.580119+00
ab0dd7be-466d-4906-aefe-64e0409d37d1	6411b387-fc37-4b47-878b-8f89fd8e08d9	730ab2b5-5e02-4c6a-a69f-d827d3b8e22a	30.95	30.95	30.95	30	1007	16.67	170	S	0.00	f	0.00	clear sky	2026-05-03 07:00:00+00	2026-05-03 07:00:21.338841+00
6d4eb73f-5de5-4ef0-a3ba-8dc943a55d92	05546df7-881e-438f-96b9-be0148283901	730ab2b5-5e02-4c6a-a69f-d827d3b8e22a	21.16	21.16	21.16	78	1006	21.60	17	NNE	17.68	t	0.00	overcast clouds	2026-05-03 07:00:00+00	2026-05-03 07:00:21.730259+00
614440f7-9c7f-41da-89e3-f7d7bab28589	054b54c2-e6d1-4534-a9de-58bf2831479a	730ab2b5-5e02-4c6a-a69f-d827d3b8e22a	24.05	24.05	24.75	23	1007	18.50	210	SSW	0.00	f	0.00	dust	2026-05-03 07:00:00+00	2026-05-03 07:00:22.398758+00
7f5d5c77-cbf4-492d-8c09-6f466e39f7f4	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	730ab2b5-5e02-4c6a-a69f-d827d3b8e22a	30.44	30.44	30.44	49	1009	4.46	243	WSW	6.66	t	0.00	clear sky	2026-05-03 07:00:00+00	2026-05-03 07:00:24.301804+00
13b59e73-5125-4c6d-8804-c46a38dd6adb	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	730ab2b5-5e02-4c6a-a69f-d827d3b8e22a	36.16	34.94	36.99	21	1008	7.42	190	S	0.00	f	0.00	clear sky	2026-05-03 07:00:00+00	2026-05-03 07:00:25.351861+00
599def77-f8bb-4505-ab1a-08850a0a438a	72829d11-3ace-445b-9f4b-5c3c72c3521f	730ab2b5-5e02-4c6a-a69f-d827d3b8e22a	17.02	16.12	17.19	82	1017	3.71	0	N	0.00	f	0.00	scattered clouds	2026-05-03 07:00:00+00	2026-05-03 07:00:26.361353+00
87770129-578f-4a0d-a555-5dcd9d45c660	5bd52475-ffa2-40f6-82e4-3d0491b7e246	730ab2b5-5e02-4c6a-a69f-d827d3b8e22a	17.02	17.02	17.02	69	1022	11.63	104	ESE	13.82	f	0.00	broken clouds	2026-05-03 07:00:00+00	2026-05-03 07:00:27.428668+00
2e778469-7b6c-4304-967c-851a5a018a51	467c145d-f635-4cb3-9813-63f4d28b8780	6b142f5f-380b-4c38-8bfd-982afff92912	23.42	23.01	23.42	43	1010	20.38	250	WSW	0.00	f	0.00	clear sky	2026-05-03 08:00:00+00	2026-05-03 08:00:28.387377+00
28af60c8-286e-47ec-976d-14fcd8a21276	f2df8134-8994-487c-8a25-272606e8f953	6b142f5f-380b-4c38-8bfd-982afff92912	35.84	35.84	35.84	10	1012	16.96	346	NNW	16.06	f	0.00	clear sky	2026-05-03 08:00:00+00	2026-05-03 08:00:28.95718+00
9fa33f3e-2fff-4938-9599-a7dfa1cecb05	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	6b142f5f-380b-4c38-8bfd-982afff92912	39.96	39.96	40.14	15	1008	11.12	320	NW	0.00	f	0.00	clear sky	2026-05-03 08:00:00+00	2026-05-03 08:00:29.552269+00
f43997d0-1652-46bd-9234-09e7af13b159	6411b387-fc37-4b47-878b-8f89fd8e08d9	6b142f5f-380b-4c38-8bfd-982afff92912	30.95	30.95	30.95	33	1007	16.67	190	S	0.00	f	0.00	clear sky	2026-05-03 08:00:00+00	2026-05-03 08:00:30.138284+00
4f42158b-0e0f-4462-9a95-3c5f512aac9d	05546df7-881e-438f-96b9-be0148283901	6b142f5f-380b-4c38-8bfd-982afff92912	24.10	24.10	24.10	72	1006	12.17	17	NNE	11.16	t	0.00	overcast clouds	2026-05-03 08:00:00+00	2026-05-03 08:00:30.470282+00
89aa5c5f-be4f-4094-ba3b-d9a912fb24d7	054b54c2-e6d1-4534-a9de-58bf2831479a	6b142f5f-380b-4c38-8bfd-982afff92912	25.05	25.05	25.75	22	1007	22.21	240	WSW	0.00	f	0.00	dust	2026-05-03 08:00:00+00	2026-05-03 08:00:30.909048+00
435b1c15-373f-48b6-831d-129ae2d02bd9	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	6b142f5f-380b-4c38-8bfd-982afff92912	29.32	29.32	29.32	57	1009	3.35	245	WSW	6.59	t	0.00	clear sky	2026-05-03 08:00:00+00	2026-05-03 08:00:31.477702+00
bbc3544e-4fad-466f-8d55-18303c68065e	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	6b142f5f-380b-4c38-8bfd-982afff92912	33.99	32.94	33.99	36	1008	16.67	20	NNE	0.00	f	0.00	clear sky	2026-05-03 08:00:00+00	2026-05-03 08:00:32.048916+00
10b77dc1-20b6-4708-9b3d-85cb0cd6641a	72829d11-3ace-445b-9f4b-5c3c72c3521f	6b142f5f-380b-4c38-8bfd-982afff92912	18.07	17.96	18.19	77	1017	3.71	0	N	0.00	t	0.00	broken clouds	2026-05-03 08:00:00+00	2026-05-03 08:00:32.555527+00
00bd3a95-189d-4e45-a568-9b416e35ed8a	5bd52475-ffa2-40f6-82e4-3d0491b7e246	6b142f5f-380b-4c38-8bfd-982afff92912	18.34	18.34	18.34	62	1022	11.12	119	ESE	12.13	f	0.00	scattered clouds	2026-05-03 08:00:00+00	2026-05-03 08:00:33.069362+00
9fe5dfb4-0d96-46ed-a9e6-5bcc14c1d1db	467c145d-f635-4cb3-9813-63f4d28b8780	209bf07a-7d00-4b61-8fa1-26d6d51aca2b	24.42	24.42	24.42	35	1010	22.21	280	W	0.00	t	0.00	clear sky	2026-05-03 09:00:00+00	2026-05-03 09:00:34.135743+00
f4ee8701-a8f7-45b7-abfc-2e35ccf43458	f2df8134-8994-487c-8a25-272606e8f953	209bf07a-7d00-4b61-8fa1-26d6d51aca2b	36.84	36.84	36.84	9	1011	15.95	343	NNW	15.66	f	0.00	clear sky	2026-05-03 09:00:00+00	2026-05-03 09:00:34.560801+00
b535b68c-ee8f-454c-b2d9-5a6f7c1d5f09	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	209bf07a-7d00-4b61-8fa1-26d6d51aca2b	40.96	40.96	41.14	12	1007	16.67	340	NNW	0.00	f	0.00	clear sky	2026-05-03 09:00:00+00	2026-05-03 09:00:34.972977+00
01e66724-26e9-4712-8048-3d2ddeee7157	6411b387-fc37-4b47-878b-8f89fd8e08d9	209bf07a-7d00-4b61-8fa1-26d6d51aca2b	32.95	32.95	32.95	27	1007	18.50	210	SSW	0.00	f	0.00	clear sky	2026-05-03 09:00:00+00	2026-05-03 09:00:35.402568+00
ed08587a-4730-40c7-a3e5-c82c2a340528	05546df7-881e-438f-96b9-be0148283901	209bf07a-7d00-4b61-8fa1-26d6d51aca2b	23.54	23.54	23.54	70	1006	14.90	333	NNW	11.99	t	0.00	overcast clouds	2026-05-03 09:00:00+00	2026-05-03 09:00:35.858099+00
35625b64-dffc-42a1-b72a-4e72174d4b0e	054b54c2-e6d1-4534-a9de-58bf2831479a	209bf07a-7d00-4b61-8fa1-26d6d51aca2b	25.05	25.05	25.75	27	1007	24.08	220	SW	0.00	t	0.00	dust	2026-05-03 09:00:00+00	2026-05-03 09:00:36.242995+00
0f207048-8698-46f6-bc7c-6abeb2c5e19f	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	209bf07a-7d00-4b61-8fa1-26d6d51aca2b	30.99	30.99	30.99	51	1008	0.86	253	WSW	9.54	t	0.00	clear sky	2026-05-03 09:00:00+00	2026-05-03 09:00:36.626698+00
f81ac139-9c76-4881-b7fd-49f93a5ae166	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	209bf07a-7d00-4b61-8fa1-26d6d51aca2b	34.99	34.94	34.99	29	1008	18.50	20	NNE	0.00	t	0.00	clear sky	2026-05-03 09:00:00+00	2026-05-03 09:00:37.010854+00
5097de2e-d3fa-4e7a-aaf1-f99dd9c20e9c	72829d11-3ace-445b-9f4b-5c3c72c3521f	209bf07a-7d00-4b61-8fa1-26d6d51aca2b	19.04	17.96	20.19	75	1017	3.71	0	N	0.00	t	0.00	scattered clouds	2026-05-03 09:00:00+00	2026-05-03 09:00:37.411455+00
619127fc-10ab-4c5d-9cdd-fe9cebafb7e0	5bd52475-ffa2-40f6-82e4-3d0491b7e246	209bf07a-7d00-4b61-8fa1-26d6d51aca2b	19.84	19.84	19.84	53	1022	10.44	127	SE	10.91	f	0.00	scattered clouds	2026-05-03 09:00:00+00	2026-05-03 09:00:37.842117+00
82ad3c8b-f4c9-4ead-9431-ffd7d9d69a7c	467c145d-f635-4cb3-9813-63f4d28b8780	7f5bb1f7-10a5-4723-bf68-cba459b84c5d	26.42	25.79	26.42	34	1010	22.21	270	W	0.00	f	0.00	few clouds	2026-05-03 10:00:00+00	2026-05-03 10:00:39.319025+00
8c6839a9-bb9f-48e1-9af9-c5da36ffa489	f2df8134-8994-487c-8a25-272606e8f953	7f5bb1f7-10a5-4723-bf68-cba459b84c5d	37.51	37.51	37.51	8	1010	15.80	341	NNW	16.24	f	0.00	clear sky	2026-05-03 10:00:00+00	2026-05-03 10:00:40.293556+00
4e5b873e-d573-4ea5-97ce-992fe837d3cd	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	7f5bb1f7-10a5-4723-bf68-cba459b84c5d	41.96	41.96	42.14	12	1007	20.38	330	NNW	0.00	f	0.00	clear sky	2026-05-03 10:00:00+00	2026-05-03 10:00:41.215449+00
14c22a9e-c95d-49ad-ba4e-089f37498908	6411b387-fc37-4b47-878b-8f89fd8e08d9	7f5bb1f7-10a5-4723-bf68-cba459b84c5d	35.95	35.95	35.95	15	1006	22.21	200	SSW	0.00	f	0.00	clear sky	2026-05-03 10:00:00+00	2026-05-03 10:00:42.184902+00
639c4975-26a1-482d-9064-cf94c1e14222	05546df7-881e-438f-96b9-be0148283901	7f5bb1f7-10a5-4723-bf68-cba459b84c5d	21.32	21.32	21.32	72	1007	12.42	335	NNW	10.73	t	0.00	broken clouds	2026-05-03 10:00:00+00	2026-05-03 10:00:43.191153+00
1628b88f-e53d-483a-884c-8aa183fc8a51	054b54c2-e6d1-4534-a9de-58bf2831479a	7f5bb1f7-10a5-4723-bf68-cba459b84c5d	25.05	25.05	25.75	31	1007	29.63	240	WSW	0.00	t	0.00	dust	2026-05-03 10:00:00+00	2026-05-03 10:00:44.071472+00
95fb56fb-ffe5-40c0-a8e2-ab0dcddd68ca	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	7f5bb1f7-10a5-4723-bf68-cba459b84c5d	30.44	30.44	30.44	61	1008	3.17	66	ENE	15.19	t	0.00	clear sky	2026-05-03 10:00:00+00	2026-05-03 10:00:44.514425+00
63435ccc-5f5e-40a6-89dd-73dae1da918d	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	7f5bb1f7-10a5-4723-bf68-cba459b84c5d	36.99	35.94	36.99	26	1007	14.83	40	NE	0.00	f	0.00	clear sky	2026-05-03 10:00:00+00	2026-05-03 10:00:45.975217+00
a4883d33-7202-49d1-9846-ce8416e15f96	72829d11-3ace-445b-9f4b-5c3c72c3521f	7f5bb1f7-10a5-4723-bf68-cba459b84c5d	20.96	20.12	21.19	64	1017	3.71	0	N	0.00	t	0.00	broken clouds	2026-05-03 10:00:00+00	2026-05-03 10:00:47.673351+00
df81d9c2-f1b9-4182-bef7-bfa88e5379e4	5bd52475-ffa2-40f6-82e4-3d0491b7e246	7f5bb1f7-10a5-4723-bf68-cba459b84c5d	21.26	21.26	21.26	45	1021	8.60	138	SE	9.04	f	0.00	scattered clouds	2026-05-03 10:00:00+00	2026-05-03 10:00:48.498339+00
78a66939-3767-409d-8fff-b45571521cec	467c145d-f635-4cb3-9813-63f4d28b8780	4a3bcb54-a1b8-43ae-8478-eef58799f984	26.42	25.79	26.42	36	1011	27.79	280	W	0.00	t	0.00	scattered clouds	2026-05-03 11:00:00+00	2026-05-03 11:00:49.578869+00
bd18e599-7dc7-41aa-8134-5775cae0dd18	f2df8134-8994-487c-8a25-272606e8f953	4a3bcb54-a1b8-43ae-8478-eef58799f984	37.91	37.91	37.91	8	1009	16.27	344	NNW	20.02	f	0.00	clear sky	2026-05-03 11:00:00+00	2026-05-03 11:00:49.932336+00
ec1d7f06-6d43-4980-b754-4538869f96eb	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	4a3bcb54-a1b8-43ae-8478-eef58799f984	40.96	40.96	41.14	14	1006	18.50	310	NW	0.00	f	0.00	clear sky	2026-05-03 11:00:00+00	2026-05-03 11:00:50.424223+00
a0c1e033-b7cc-457e-a6a4-fd2a01a59f94	6411b387-fc37-4b47-878b-8f89fd8e08d9	4a3bcb54-a1b8-43ae-8478-eef58799f984	35.95	35.95	35.95	14	1006	16.67	210	SSW	0.00	f	0.00	clear sky	2026-05-03 11:00:00+00	2026-05-03 11:00:50.948656+00
b81334d4-218a-4756-86b4-1ebcef791d38	05546df7-881e-438f-96b9-be0148283901	4a3bcb54-a1b8-43ae-8478-eef58799f984	20.21	20.21	20.21	72	1007	10.30	317	NW	9.25	t	0.00	broken clouds	2026-05-03 11:00:00+00	2026-05-03 11:00:51.642335+00
d85e1a36-32c9-4e6d-bfb2-baaf797c8df1	054b54c2-e6d1-4534-a9de-58bf2831479a	4a3bcb54-a1b8-43ae-8478-eef58799f984	25.05	25.05	25.75	29	1007	35.17	240	WSW	0.00	t	0.00	dust	2026-05-03 11:00:00+00	2026-05-03 11:00:52.480634+00
a1aab904-da35-4594-8795-54cd84e3a386	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	4a3bcb54-a1b8-43ae-8478-eef58799f984	30.44	30.44	30.44	63	1007	2.84	61	ENE	15.52	t	0.00	clear sky	2026-05-03 11:00:00+00	2026-05-03 11:00:53.401938+00
137db146-bf03-472a-949d-0d861575c9f6	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	4a3bcb54-a1b8-43ae-8478-eef58799f984	37.99	36.94	37.99	25	1006	12.96	60	ENE	0.00	f	0.00	clear sky	2026-05-03 11:00:00+00	2026-05-03 11:00:54.263639+00
665dfb95-42c8-47b9-960c-4ac0719cfc52	72829d11-3ace-445b-9f4b-5c3c72c3521f	4a3bcb54-a1b8-43ae-8478-eef58799f984	20.19	20.18	22.12	68	1017	7.42	20	NNE	0.00	t	0.00	broken clouds	2026-05-03 11:00:00+00	2026-05-03 11:00:55.085586+00
1426f7ae-7151-4cd0-ba39-8d57825181a8	5bd52475-ffa2-40f6-82e4-3d0491b7e246	4a3bcb54-a1b8-43ae-8478-eef58799f984	22.64	22.64	22.64	39	1021	6.34	161	SSE	7.24	f	0.00	few clouds	2026-05-03 11:00:00+00	2026-05-03 11:00:55.898208+00
7523f5fe-6487-489f-b9ab-7358560c86fa	467c145d-f635-4cb3-9813-63f4d28b8780	bde90614-18e9-4541-8ad3-4c1c90a753c2	24.42	24.12	24.42	46	1012	35.17	290	WNW	0.00	t	0.00	sand	2026-05-03 12:00:00+00	2026-05-03 12:00:42.59992+00
a36e2459-f96e-4d3e-9b11-5fe210240009	f2df8134-8994-487c-8a25-272606e8f953	bde90614-18e9-4541-8ad3-4c1c90a753c2	37.96	37.96	37.96	8	1008	17.60	352	N	23.33	f	0.00	clear sky	2026-05-03 12:00:00+00	2026-05-03 12:00:43.312755+00
b20aa4b5-16aa-4204-885c-0c42fe0838e9	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	bde90614-18e9-4541-8ad3-4c1c90a753c2	37.96	37.96	40.14	28	1006	20.38	290	WNW	0.00	f	0.00	clear sky	2026-05-03 12:00:00+00	2026-05-03 12:00:44.010437+00
d22cb79b-9c19-42bc-96a2-84c67bfe0d36	6411b387-fc37-4b47-878b-8f89fd8e08d9	bde90614-18e9-4541-8ad3-4c1c90a753c2	36.95	36.95	36.95	13	1005	14.83	210	SSW	0.00	f	0.00	clear sky	2026-05-03 12:00:00+00	2026-05-03 12:00:44.706365+00
ee91440c-a7af-4ff2-a87c-686e662a158c	05546df7-881e-438f-96b9-be0148283901	bde90614-18e9-4541-8ad3-4c1c90a753c2	19.10	19.10	19.10	78	1008	18.58	275	W	18.40	t	0.00	broken clouds	2026-05-03 12:00:00+00	2026-05-03 12:00:45.378285+00
7167b46e-3000-424d-bc02-5e3ba4ce6e68	054b54c2-e6d1-4534-a9de-58bf2831479a	bde90614-18e9-4541-8ad3-4c1c90a753c2	25.05	25.05	25.75	29	1008	42.59	260	W	0.00	t	0.00	dust	2026-05-03 12:00:00+00	2026-05-03 12:00:46.055423+00
05e08709-bce2-49fe-89b7-6060c46fb0aa	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	bde90614-18e9-4541-8ad3-4c1c90a753c2	30.44	30.44	30.44	62	1006	0.54	20	NNE	13.57	t	0.00	clear sky	2026-05-03 12:00:00+00	2026-05-03 12:00:46.722952+00
a30d7f51-e856-462c-8d32-264b0b87588f	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	bde90614-18e9-4541-8ad3-4c1c90a753c2	37.99	35.94	37.99	25	1006	16.67	90	E	0.00	f	0.00	clear sky	2026-05-03 12:00:00+00	2026-05-03 12:00:47.439967+00
535f5d42-5800-4fb9-9676-1ef89a69d801	72829d11-3ace-445b-9f4b-5c3c72c3521f	bde90614-18e9-4541-8ad3-4c1c90a753c2	22.02	21.85	24.12	60	1017	7.42	20	NNE	0.00	f	0.00	scattered clouds	2026-05-03 12:00:00+00	2026-05-03 12:00:48.093359+00
760be33c-9432-4c89-9821-8ff38d195d71	5bd52475-ffa2-40f6-82e4-3d0491b7e246	bde90614-18e9-4541-8ad3-4c1c90a753c2	23.99	23.99	23.99	34	1020	6.62	155	SSE	7.34	f	0.00	few clouds	2026-05-03 12:00:00+00	2026-05-03 12:00:48.741034+00
bbe95419-9e38-4e0c-9465-0edc16ffb5ba	467c145d-f635-4cb3-9813-63f4d28b8780	dc1b56ea-1b63-4038-83ba-fd9a93db2e63	23.42	23.01	23.42	49	1012	31.50	310	NW	0.00	t	0.00	sand	2026-05-03 13:00:00+00	2026-05-03 13:00:49.890298+00
fe3aec87-2728-48a4-ab17-a32f164c9a6c	f2df8134-8994-487c-8a25-272606e8f953	dc1b56ea-1b63-4038-83ba-fd9a93db2e63	37.77	37.77	37.77	8	1008	17.35	356	N	21.56	f	0.00	clear sky	2026-05-03 13:00:00+00	2026-05-03 13:00:50.310243+00
1ee2dceb-64fe-4507-8d24-eef4b5748405	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	dc1b56ea-1b63-4038-83ba-fd9a93db2e63	35.96	35.96	36.14	28	1005	24.08	270	W	0.00	f	0.00	clear sky	2026-05-03 13:00:00+00	2026-05-03 13:00:50.932506+00
fc284eac-d4f1-4881-b2f9-f5f585a9591a	6411b387-fc37-4b47-878b-8f89fd8e08d9	dc1b56ea-1b63-4038-83ba-fd9a93db2e63	37.95	37.95	37.95	13	1005	18.50	190	S	0.00	f	0.00	clear sky	2026-05-03 13:00:00+00	2026-05-03 13:00:51.677365+00
0a20ec7f-25a2-4175-9738-1f4e10afa0f5	05546df7-881e-438f-96b9-be0148283901	dc1b56ea-1b63-4038-83ba-fd9a93db2e63	16.88	16.88	16.88	84	1009	27.58	266	W	27.72	t	0.00	overcast clouds	2026-05-03 13:00:00+00	2026-05-03 13:00:52.444892+00
465799f1-44b3-4917-b96f-76e31db2fea1	054b54c2-e6d1-4534-a9de-58bf2831479a	dc1b56ea-1b63-4038-83ba-fd9a93db2e63	24.05	24.05	25.75	41	1008	38.88	270	W	0.00	t	0.00	dust	2026-05-03 13:00:00+00	2026-05-03 13:00:53.292767+00
6ddb6dee-7856-4842-8aa7-6cca8c933c33	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	dc1b56ea-1b63-4038-83ba-fd9a93db2e63	31.55	31.55	31.55	52	1006	0.68	133	SE	11.45	t	0.00	clear sky	2026-05-03 13:00:00+00	2026-05-03 13:00:53.770302+00
ab9c11f4-fcea-4f04-b0ae-351026cfdca5	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	dc1b56ea-1b63-4038-83ba-fd9a93db2e63	33.99	31.94	33.99	31	1006	22.21	30	NNE	0.00	f	0.00	clear sky	2026-05-03 13:00:00+00	2026-05-03 13:00:55.200115+00
cfffacec-79ce-4ee3-8a54-2778c3bfce02	72829d11-3ace-445b-9f4b-5c3c72c3521f	dc1b56ea-1b63-4038-83ba-fd9a93db2e63	22.02	21.85	24.12	64	1016	12.96	350	N	0.00	t	0.00	scattered clouds	2026-05-03 13:00:00+00	2026-05-03 13:00:55.728277+00
5f006d21-1e00-4db2-b014-c37be51507da	5bd52475-ffa2-40f6-82e4-3d0491b7e246	dc1b56ea-1b63-4038-83ba-fd9a93db2e63	25.05	25.05	25.05	31	1019	6.98	164	SSE	7.24	f	0.00	overcast clouds	2026-05-03 13:00:00+00	2026-05-03 13:00:56.396285+00
5ec5a47b-633f-45ba-b7f4-511114f456e6	467c145d-f635-4cb3-9813-63f4d28b8780	d3305cdb-a7d4-4f93-ae39-d9c73f2143cb	23.42	23.01	23.42	46	1012	29.63	310	NW	0.00	t	0.00	scattered clouds	2026-05-03 14:00:00+00	2026-05-03 14:10:26.020441+00
e647b601-ce39-4ddd-95c4-cd0c0b69137e	f2df8134-8994-487c-8a25-272606e8f953	d3305cdb-a7d4-4f93-ae39-d9c73f2143cb	37.11	37.11	37.11	9	1008	19.58	3	N	19.87	f	0.00	clear sky	2026-05-03 14:00:00+00	2026-05-03 14:10:26.427069+00
4ad7561e-be22-49fd-99dd-eea31871dc3d	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	d3305cdb-a7d4-4f93-ae39-d9c73f2143cb	34.96	34.96	35.14	34	1005	24.08	270	W	0.00	f	0.00	clear sky	2026-05-03 14:00:00+00	2026-05-03 14:10:26.847019+00
f8d46b5c-b58d-4f4c-b163-294c74b9f6b9	6411b387-fc37-4b47-878b-8f89fd8e08d9	d3305cdb-a7d4-4f93-ae39-d9c73f2143cb	37.95	37.95	37.95	14	1004	22.21	150	SSE	0.00	f	0.00	clear sky	2026-05-03 14:00:00+00	2026-05-03 14:10:27.297414+00
233947e8-25ee-4407-b197-94b34e89d326	05546df7-881e-438f-96b9-be0148283901	d3305cdb-a7d4-4f93-ae39-d9c73f2143cb	16.88	16.88	16.88	93	1009	28.19	263	W	31.25	t	0.00	overcast clouds	2026-05-03 14:00:00+00	2026-05-03 14:10:27.749887+00
dd1a6dff-09ec-4518-a270-114da4b1261e	054b54c2-e6d1-4534-a9de-58bf2831479a	d3305cdb-a7d4-4f93-ae39-d9c73f2143cb	22.05	22.05	22.75	43	1009	38.88	260	W	0.00	f	0.00	dust	2026-05-03 14:00:00+00	2026-05-03 14:10:28.162933+00
7bd4bda2-fdba-4327-ab42-f9a54b570bb7	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	d3305cdb-a7d4-4f93-ae39-d9c73f2143cb	30.44	30.44	30.44	49	1005	0.83	220	SW	11.02	t	0.00	clear sky	2026-05-03 14:00:00+00	2026-05-03 14:10:28.498164+00
60278feb-e13d-43b4-b7cf-ec2deffb827f	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	d3305cdb-a7d4-4f93-ae39-d9c73f2143cb	33.99	33.99	33.99	33	1006	16.67	40	NE	0.00	f	0.00	clear sky	2026-05-03 14:00:00+00	2026-05-03 14:10:28.921393+00
0fc05df3-f01f-44b4-8765-c20b8a0639ca	72829d11-3ace-445b-9f4b-5c3c72c3521f	d3305cdb-a7d4-4f93-ae39-d9c73f2143cb	20.74	20.74	24.12	68	1016	14.47	0	N	0.00	t	0.00	overcast clouds	2026-05-03 14:00:00+00	2026-05-03 14:10:29.263326+00
15b2db76-f561-49ce-b50d-ce48cdca8d1c	5bd52475-ffa2-40f6-82e4-3d0491b7e246	d3305cdb-a7d4-4f93-ae39-d9c73f2143cb	25.73	25.73	25.73	29	1018	6.26	174	S	6.52	f	0.00	broken clouds	2026-05-03 14:00:00+00	2026-05-03 14:10:29.631119+00
1b2dea53-4e0d-4da5-bb76-d9b536f522ea	467c145d-f635-4cb3-9813-63f4d28b8780	e0c4180d-bb23-4605-a5e3-55f5edf06f53	23.42	23.01	23.42	43	1013	31.50	290	WNW	0.00	t	0.00	scattered clouds	2026-05-03 15:00:00+00	2026-05-03 15:00:30.441317+00
d4d34089-efd6-4e7d-87f1-8f806c533e65	f2df8134-8994-487c-8a25-272606e8f953	e0c4180d-bb23-4605-a5e3-55f5edf06f53	36.03	36.03	36.03	10	1009	19.87	5	N	24.44	f	0.00	clear sky	2026-05-03 15:00:00+00	2026-05-03 15:00:30.806031+00
16b9da7a-da30-4f60-9681-25efd783b2dd	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	e0c4180d-bb23-4605-a5e3-55f5edf06f53	34.96	34.14	34.96	29	1005	27.79	290	WNW	0.00	f	0.00	clear sky	2026-05-03 15:00:00+00	2026-05-03 15:00:31.11611+00
5c8235a8-ea45-49ad-b9a0-1675fa696d24	6411b387-fc37-4b47-878b-8f89fd8e08d9	e0c4180d-bb23-4605-a5e3-55f5edf06f53	34.95	34.95	34.95	16	1004	16.67	140	SE	0.00	f	0.00	broken clouds	2026-05-03 15:00:00+00	2026-05-03 15:00:31.441538+00
063578f9-e9ec-47c1-aff8-8396bcc3fffe	05546df7-881e-438f-96b9-be0148283901	e0c4180d-bb23-4605-a5e3-55f5edf06f53	16.32	16.32	16.32	88	1010	23.98	245	WSW	29.09	t	0.00	overcast clouds	2026-05-03 15:00:00+00	2026-05-03 15:00:31.754716+00
1d2faa7c-e1d0-4744-9257-e09a8da8567a	054b54c2-e6d1-4534-a9de-58bf2831479a	e0c4180d-bb23-4605-a5e3-55f5edf06f53	19.05	19.05	20.75	52	1009	44.46	260	W	0.00	t	0.00	dust	2026-05-03 15:00:00+00	2026-05-03 15:00:32.078083+00
c5a28bd8-cbf6-4d67-a6b6-bb32fb99ee64	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	e0c4180d-bb23-4605-a5e3-55f5edf06f53	29.88	29.88	29.88	53	1006	0.54	191	S	14.33	t	0.00	clear sky	2026-05-03 15:00:00+00	2026-05-03 15:00:32.404803+00
61e24f10-4b73-4ae2-a7e7-edc53d9af311	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	e0c4180d-bb23-4605-a5e3-55f5edf06f53	32.99	31.94	32.99	35	1006	14.83	50	NE	0.00	f	0.00	clear sky	2026-05-03 15:00:00+00	2026-05-03 15:00:32.72966+00
01e25881-9b5a-4467-a0c5-80abc35705aa	72829d11-3ace-445b-9f4b-5c3c72c3521f	e0c4180d-bb23-4605-a5e3-55f5edf06f53	20.74	20.74	21.19	64	1015	12.96	0	N	0.00	t	0.00	scattered clouds	2026-05-03 15:00:00+00	2026-05-03 15:00:33.066485+00
ab3631fa-1c0b-4362-86e0-5ba31c54cc07	5bd52475-ffa2-40f6-82e4-3d0491b7e246	e0c4180d-bb23-4605-a5e3-55f5edf06f53	26.00	26.00	26.00	26	1017	5.29	175	S	5.40	f	0.00	overcast clouds	2026-05-03 15:00:00+00	2026-05-03 15:00:33.386308+00
ec05374d-e915-45d2-9dfb-8fe533230dd2	467c145d-f635-4cb3-9813-63f4d28b8780	d59ddbc1-2d97-496c-b517-55544394054e	22.42	21.90	22.42	43	1014	29.63	320	NW	0.00	t	0.00	scattered clouds	2026-05-03 16:00:00+00	2026-05-03 16:00:34.257955+00
1b50f943-0aff-4d44-a878-33492a04b455	f2df8134-8994-487c-8a25-272606e8f953	d59ddbc1-2d97-496c-b517-55544394054e	34.45	34.45	34.45	11	1009	16.63	9	N	21.82	f	0.00	clear sky	2026-05-03 16:00:00+00	2026-05-03 16:00:34.584724+00
3d5f84e8-2a7a-4a02-90d0-7e6e284ffee0	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	d59ddbc1-2d97-496c-b517-55544394054e	33.96	33.96	34.14	27	1006	24.08	300	WNW	0.00	f	0.00	clear sky	2026-05-03 16:00:00+00	2026-05-03 16:00:34.921913+00
91f683e0-a944-4138-8dcf-788b02df548d	6411b387-fc37-4b47-878b-8f89fd8e08d9	d59ddbc1-2d97-496c-b517-55544394054e	34.95	34.95	34.95	16	1004	14.83	140	SE	0.00	f	0.00	broken clouds	2026-05-03 16:00:00+00	2026-05-03 16:00:35.249332+00
246b7fb4-fbf2-487c-8ca9-d7a230678f68	05546df7-881e-438f-96b9-be0148283901	d59ddbc1-2d97-496c-b517-55544394054e	16.32	16.32	16.32	90	1009	24.52	237	WSW	27.90	t	0.00	overcast clouds	2026-05-03 16:00:00+00	2026-05-03 16:00:35.5747+00
0707a5a4-ccdc-41a8-8c45-3ea311683f5a	054b54c2-e6d1-4534-a9de-58bf2831479a	d59ddbc1-2d97-496c-b517-55544394054e	19.05	18.75	19.05	48	1010	35.17	260	W	0.00	t	0.00	dust	2026-05-03 16:00:00+00	2026-05-03 16:00:35.935276+00
afd3e100-3926-45fc-8320-910559293b58	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	d59ddbc1-2d97-496c-b517-55544394054e	31.96	31.96	31.96	44	1007	2.09	154	SSE	15.66	f	0.00	clear sky	2026-05-03 16:00:00+00	2026-05-03 16:00:36.280313+00
c673dfa5-4d60-4791-801f-9335f92bf0a8	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	d59ddbc1-2d97-496c-b517-55544394054e	30.99	30.94	30.99	42	1006	12.96	10	N	0.00	t	0.00	clear sky	2026-05-03 16:00:00+00	2026-05-03 16:00:36.621292+00
b862a533-8c18-4dee-bf39-40ce08a7be43	72829d11-3ace-445b-9f4b-5c3c72c3521f	d59ddbc1-2d97-496c-b517-55544394054e	20.74	20.74	21.19	64	1015	12.96	20	NNE	0.00	t	0.00	scattered clouds	2026-05-03 16:00:00+00	2026-05-03 16:00:36.956655+00
fdfeb421-1081-4b67-8714-7bbb98cbc1d9	5bd52475-ffa2-40f6-82e4-3d0491b7e246	d59ddbc1-2d97-496c-b517-55544394054e	26.26	26.26	26.26	24	1017	6.34	155	SSE	6.62	f	0.00	overcast clouds	2026-05-03 16:00:00+00	2026-05-03 16:00:37.362857+00
6a3a9492-3037-4d70-babe-aad2eae75b96	467c145d-f635-4cb3-9813-63f4d28b8780	2979ea03-f0f5-4ad9-bbfb-c8d9423dfb7a	20.42	20.23	20.42	45	1014	27.79	310	NW	0.00	t	0.00	scattered clouds	2026-05-03 17:00:00+00	2026-05-03 17:24:35.145257+00
f48e8826-b19a-4c95-bd1e-0bcbc7b91fe4	f2df8134-8994-487c-8a25-272606e8f953	2979ea03-f0f5-4ad9-bbfb-c8d9423dfb7a	33.51	33.51	33.51	10	1011	15.91	6	N	23.44	f	0.00	clear sky	2026-05-03 17:00:00+00	2026-05-03 17:24:37.144881+00
b2362efd-5ee7-46d6-9457-ad69190db081	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	2979ea03-f0f5-4ad9-bbfb-c8d9423dfb7a	33.96	33.14	33.96	31	1006	11.12	260	W	0.00	f	0.00	clear sky	2026-05-03 17:00:00+00	2026-05-03 17:24:37.472701+00
abe045e5-8065-4515-a814-00b30bb38b69	6411b387-fc37-4b47-878b-8f89fd8e08d9	2979ea03-f0f5-4ad9-bbfb-c8d9423dfb7a	32.95	32.95	32.95	19	1004	14.83	150	SSE	0.00	f	0.00	broken clouds	2026-05-03 17:00:00+00	2026-05-03 17:24:37.781072+00
f32a7651-75e2-4755-843f-12d2dfde2229	05546df7-881e-438f-96b9-be0148283901	2979ea03-f0f5-4ad9-bbfb-c8d9423dfb7a	15.21	15.21	15.21	92	1010	28.22	238	WSW	34.92	t	0.00	overcast clouds	2026-05-03 17:00:00+00	2026-05-03 17:24:38.28319+00
bf25002c-3017-48ee-a689-6f80929da5eb	054b54c2-e6d1-4534-a9de-58bf2831479a	2979ea03-f0f5-4ad9-bbfb-c8d9423dfb7a	15.75	15.75	15.75	75	1012	27.65	283	WNW	43.85	t	0.00	clear sky	2026-05-03 17:00:00+00	2026-05-03 17:24:38.598142+00
518c3d02-21de-4841-984b-317474489dfe	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	2979ea03-f0f5-4ad9-bbfb-c8d9423dfb7a	31.86	31.86	31.86	60	1006	4.03	165	SSE	11.66	t	0.00	clear sky	2026-05-03 17:00:00+00	2026-05-03 17:24:39.281302+00
d91235c2-2898-47c9-a028-5236d0fe961e	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	2979ea03-f0f5-4ad9-bbfb-c8d9423dfb7a	29.99	29.99	34.17	51	1006	9.25	20	NNE	0.00	t	0.00	clear sky	2026-05-03 17:00:00+00	2026-05-03 17:24:39.599257+00
af3a9302-6d06-417f-aab2-ef4513b8f8b1	72829d11-3ace-445b-9f4b-5c3c72c3521f	2979ea03-f0f5-4ad9-bbfb-c8d9423dfb7a	20.18	20.18	20.19	60	1015	11.12	10	N	0.00	t	0.00	scattered clouds	2026-05-03 17:00:00+00	2026-05-03 17:24:39.910588+00
61702d7c-b3a1-4330-b770-ddb274bd9b91	5bd52475-ffa2-40f6-82e4-3d0491b7e246	2979ea03-f0f5-4ad9-bbfb-c8d9423dfb7a	26.19	26.19	26.19	21	1016	6.05	162	SSE	6.55	f	0.00	overcast clouds	2026-05-03 17:00:00+00	2026-05-03 17:24:40.231475+00
d3ae22e5-2608-423e-a10c-eef6db1ad4f1	467c145d-f635-4cb3-9813-63f4d28b8780	91a8f882-1022-4f06-bc68-8ce49f0879f2	20.42	20.23	20.42	42	1015	25.92	310	NW	0.00	t	0.00	scattered clouds	2026-05-03 18:00:00+00	2026-05-03 18:00:20.907827+00
885c8bef-1970-4a0f-b589-77e47a685c8d	f2df8134-8994-487c-8a25-272606e8f953	91a8f882-1022-4f06-bc68-8ce49f0879f2	32.10	32.10	32.10	11	1011	16.24	11	N	24.23	f	0.00	clear sky	2026-05-03 18:00:00+00	2026-05-03 18:00:21.279371+00
4e3a37dd-faf0-4675-8805-fdef4d25dcf2	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	91a8f882-1022-4f06-bc68-8ce49f0879f2	32.96	32.96	33.14	35	1006	11.12	250	WSW	0.00	f	0.00	clear sky	2026-05-03 18:00:00+00	2026-05-03 18:00:21.840884+00
6ff2aa7c-eac8-43c7-aa6d-be918f21bed8	6411b387-fc37-4b47-878b-8f89fd8e08d9	91a8f882-1022-4f06-bc68-8ce49f0879f2	32.95	32.95	32.95	19	1004	14.83	150	SSE	0.00	f	0.00	broken clouds	2026-05-03 18:00:00+00	2026-05-03 18:00:22.287051+00
7b77e780-763f-4d8c-b66b-7df131839b23	05546df7-881e-438f-96b9-be0148283901	91a8f882-1022-4f06-bc68-8ce49f0879f2	15.21	15.21	15.21	82	1011	32.83	225	SW	36.61	t	0.00	overcast clouds	2026-05-03 18:00:00+00	2026-05-03 18:00:22.903896+00
763f6dde-7995-4f86-b5a8-d3d5ddacca48	054b54c2-e6d1-4534-a9de-58bf2831479a	91a8f882-1022-4f06-bc68-8ce49f0879f2	15.75	15.75	15.75	79	1012	26.10	276	W	42.77	t	0.00	few clouds	2026-05-03 18:00:00+00	2026-05-03 18:00:23.991473+00
8fe15341-a760-400e-92da-b4f79134cd16	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	91a8f882-1022-4f06-bc68-8ce49f0879f2	30.98	30.98	30.98	51	1007	3.53	192	SSW	9.76	t	0.00	clear sky	2026-05-03 18:00:00+00	2026-05-03 18:00:24.330638+00
60f74291-c28b-40b5-b5b0-ec6837f5d35a	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	91a8f882-1022-4f06-bc68-8ce49f0879f2	29.99	28.94	29.99	48	1007	7.42	0	N	0.00	t	0.00	clear sky	2026-05-03 18:00:00+00	2026-05-03 18:00:24.75797+00
92893e3c-3a91-4c8b-85db-babf840072f9	72829d11-3ace-445b-9f4b-5c3c72c3521f	91a8f882-1022-4f06-bc68-8ce49f0879f2	20.19	20.18	21.12	60	1015	11.12	10	N	0.00	t	0.00	scattered clouds	2026-05-03 18:00:00+00	2026-05-03 18:00:25.131592+00
ef7ba5e0-45aa-483f-9d0c-6e6eb7a9a8f1	5bd52475-ffa2-40f6-82e4-3d0491b7e246	91a8f882-1022-4f06-bc68-8ce49f0879f2	25.98	25.98	25.98	21	1017	4.43	160	SSE	5.62	f	0.00	overcast clouds	2026-05-03 18:00:00+00	2026-05-03 18:00:25.617869+00
e617ab83-aae5-4405-b00e-15aeb4b2f23b	467c145d-f635-4cb3-9813-63f4d28b8780	f36d3aba-63c7-401b-bfec-c34fae47011a	19.42	19.12	19.42	42	1016	22.21	320	NW	0.00	t	0.00	clear sky	2026-05-03 19:00:00+00	2026-05-03 19:00:46.843818+00
9df2e83a-086d-402c-b02c-9fc6fdff7314	f2df8134-8994-487c-8a25-272606e8f953	f36d3aba-63c7-401b-bfec-c34fae47011a	30.01	30.01	30.01	12	1012	14.87	30	NNE	25.42	t	0.00	clear sky	2026-05-03 19:00:00+00	2026-05-03 19:00:47.176459+00
45ab186f-0964-4bd9-a323-d4e81ffd0880	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	f36d3aba-63c7-401b-bfec-c34fae47011a	32.96	30.14	32.96	38	1006	12.96	260	W	0.00	f	0.00	clear sky	2026-05-03 19:00:00+00	2026-05-03 19:00:47.622405+00
acd49c7c-f1e7-4532-b0f3-278bb62c6ece	6411b387-fc37-4b47-878b-8f89fd8e08d9	f36d3aba-63c7-401b-bfec-c34fae47011a	34.95	34.95	34.95	18	1005	29.63	170	S	53.71	f	0.00	dust	2026-05-03 19:00:00+00	2026-05-03 19:00:47.949734+00
3f95caf4-149c-49cc-9f3d-fb25fa3ed10b	05546df7-881e-438f-96b9-be0148283901	f36d3aba-63c7-401b-bfec-c34fae47011a	14.65	14.65	14.65	79	1012	34.74	225	SW	39.20	t	0.00	overcast clouds	2026-05-03 19:00:00+00	2026-05-03 19:00:48.266804+00
638805ba-125d-457a-9c7f-7b4bc73681e8	054b54c2-e6d1-4534-a9de-58bf2831479a	f36d3aba-63c7-401b-bfec-c34fae47011a	15.05	15.05	15.75	72	1013	20.38	250	WSW	0.00	t	0.16	light rain	2026-05-03 19:00:00+00	2026-05-03 19:00:48.597425+00
c79ec2f0-359f-422e-a837-71b92d8d22b4	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	f36d3aba-63c7-401b-bfec-c34fae47011a	28.21	28.21	28.21	66	1008	4.25	228	SW	8.86	t	0.00	clear sky	2026-05-03 19:00:00+00	2026-05-03 19:00:48.927709+00
42cc1ba5-8ed3-4910-8277-560383110166	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	f36d3aba-63c7-401b-bfec-c34fae47011a	29.99	29.94	29.99	51	1008	9.25	10	N	0.00	t	0.00	clear sky	2026-05-03 19:00:00+00	2026-05-03 19:00:49.26543+00
72389473-0abc-4f4d-9eb6-77ef3e805157	72829d11-3ace-445b-9f4b-5c3c72c3521f	f36d3aba-63c7-401b-bfec-c34fae47011a	19.13	19.07	19.19	68	1016	9.25	30	NNE	0.00	t	0.00	scattered clouds	2026-05-03 19:00:00+00	2026-05-03 19:00:49.590041+00
6876210c-44e4-4b51-84f2-1beb5d76dbee	5bd52475-ffa2-40f6-82e4-3d0491b7e246	f36d3aba-63c7-401b-bfec-c34fae47011a	24.98	24.98	24.98	23	1018	7.52	145	SE	8.71	f	0.00	scattered clouds	2026-05-03 19:00:00+00	2026-05-03 19:00:49.915307+00
9f69df3f-c834-4a65-931e-b6502486c2c3	467c145d-f635-4cb3-9813-63f4d28b8780	12e18d46-61e4-419b-8857-3b9484c01738	18.42	18.01	18.42	45	1017	24.08	320	NW	0.00	f	0.00	clear sky	2026-05-03 20:00:00+00	2026-05-03 20:00:50.682817+00
dabde1d4-0044-467c-862b-7e83cb644757	f2df8134-8994-487c-8a25-272606e8f953	12e18d46-61e4-419b-8857-3b9484c01738	29.53	29.53	29.53	12	1012	11.48	39	NE	13.14	t	0.00	clear sky	2026-05-03 20:00:00+00	2026-05-03 20:00:51.014837+00
1080e1cb-6267-47f2-855c-10e4fbbccff1	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	12e18d46-61e4-419b-8857-3b9484c01738	32.96	32.14	32.96	35	1006	5.54	180	S	0.00	f	0.00	clear sky	2026-05-03 20:00:00+00	2026-05-03 20:00:51.383612+00
da636447-ff2c-4e56-88a1-ac2557a7cd75	6411b387-fc37-4b47-878b-8f89fd8e08d9	12e18d46-61e4-419b-8857-3b9484c01738	34.95	34.95	34.95	17	1005	44.46	170	S	0.00	f	0.00	dust	2026-05-03 20:00:00+00	2026-05-03 20:00:51.730222+00
61ed0283-a093-4467-b41d-5af8f148cc8d	05546df7-881e-438f-96b9-be0148283901	12e18d46-61e4-419b-8857-3b9484c01738	14.65	14.65	14.65	79	1013	35.21	221	SW	40.93	t	0.00	overcast clouds	2026-05-03 20:00:00+00	2026-05-03 20:00:52.069256+00
17763b53-0778-409a-9adb-ce50fd73e7f8	054b54c2-e6d1-4534-a9de-58bf2831479a	12e18d46-61e4-419b-8857-3b9484c01738	15.05	14.75	15.05	72	1015	22.21	260	W	0.00	f	0.00	scattered clouds	2026-05-03 20:00:00+00	2026-05-03 20:00:52.423823+00
17cbf08e-a4d5-4afc-a78d-655e2f04b50c	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	12e18d46-61e4-419b-8857-3b9484c01738	30.78	30.78	30.78	51	1008	6.19	295	WNW	7.24	t	0.00	clear sky	2026-05-03 20:00:00+00	2026-05-03 20:00:52.797838+00
9b085ef2-905e-4ab7-b105-a324f54c61ea	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	12e18d46-61e4-419b-8857-3b9484c01738	29.99	29.99	32.17	45	1007	7.42	350	N	0.00	t	0.00	clear sky	2026-05-03 20:00:00+00	2026-05-03 20:00:53.167637+00
81a63aeb-616c-4dfb-9699-fa39b51ef3ef	72829d11-3ace-445b-9f4b-5c3c72c3521f	12e18d46-61e4-419b-8857-3b9484c01738	19.13	18.12	19.19	70	1017	9.25	10	N	0.00	t	0.00	scattered clouds	2026-05-03 20:00:00+00	2026-05-03 20:00:53.503106+00
5132de22-f7de-46a5-822d-95f838be0ebe	5bd52475-ffa2-40f6-82e4-3d0491b7e246	12e18d46-61e4-419b-8857-3b9484c01738	22.61	22.61	22.61	33	1019	18.18	95	E	20.95	f	0.00	broken clouds	2026-05-03 20:00:00+00	2026-05-03 20:00:53.870777+00
a42936de-967e-498c-9c32-c7223f753629	467c145d-f635-4cb3-9813-63f4d28b8780	e70346eb-7648-402c-b3b4-adc98d1d78e7	17.42	16.90	17.42	51	1016	16.67	320	NW	0.00	f	0.00	clear sky	2026-05-03 21:00:00+00	2026-05-03 21:27:40.207489+00
fdf51017-6ba3-44b1-86ba-b7ec10a7cdcb	f2df8134-8994-487c-8a25-272606e8f953	e70346eb-7648-402c-b3b4-adc98d1d78e7	27.60	27.60	27.60	16	1013	9.14	37	NE	11.05	t	0.00	clear sky	2026-05-03 21:00:00+00	2026-05-03 21:27:40.530335+00
02866c0c-8e93-4277-9986-3c7c6f2ca062	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	e70346eb-7648-402c-b3b4-adc98d1d78e7	31.96	31.14	31.96	37	1006	9.25	170	S	0.00	f	0.00	clear sky	2026-05-03 21:00:00+00	2026-05-03 21:27:40.882721+00
3e8da99d-c7ad-4545-bad5-00c7dbc7aee6	6411b387-fc37-4b47-878b-8f89fd8e08d9	e70346eb-7648-402c-b3b4-adc98d1d78e7	33.95	33.95	33.95	20	1005	24.08	260	W	0.00	f	0.00	dust	2026-05-03 21:00:00+00	2026-05-03 21:27:41.217682+00
245d0dd2-eb02-4c61-a324-4e3309517238	05546df7-881e-438f-96b9-be0148283901	e70346eb-7648-402c-b3b4-adc98d1d78e7	13.54	13.54	13.54	82	1012	33.70	226	SW	39.31	t	0.00	overcast clouds	2026-05-03 21:00:00+00	2026-05-03 21:27:41.570567+00
e1f847c9-9be9-4565-96ce-ffc474a55173	054b54c2-e6d1-4534-a9de-58bf2831479a	e70346eb-7648-402c-b3b4-adc98d1d78e7	13.05	12.75	13.05	71	1015	29.63	270	W	0.00	f	0.00	dust	2026-05-03 21:00:00+00	2026-05-03 21:27:41.915731+00
a02b2735-476f-455a-997c-05c5c049d904	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	e70346eb-7648-402c-b3b4-adc98d1d78e7	30.99	30.99	30.99	36	1008	6.77	318	NW	7.13	t	0.00	clear sky	2026-05-03 21:00:00+00	2026-05-03 21:27:42.252981+00
09d1c94b-bc97-45b0-b472-fd0cdbbccac1	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	e70346eb-7648-402c-b3b4-adc98d1d78e7	28.76	26.94	29.99	47	1006	9.25	330	NNW	0.00	t	0.00	clear sky	2026-05-03 21:00:00+00	2026-05-03 21:27:42.589416+00
e057ac77-10aa-4aac-baee-3dd67ae98599	72829d11-3ace-445b-9f4b-5c3c72c3521f	e70346eb-7648-402c-b3b4-adc98d1d78e7	18.07	17.12	18.19	77	1017	7.42	30	NNE	0.00	t	0.00	scattered clouds	2026-05-03 21:00:00+00	2026-05-03 21:27:42.940487+00
164a8ab5-e0ad-404e-97d5-8b49b1bd2bbc	5bd52475-ffa2-40f6-82e4-3d0491b7e246	e70346eb-7648-402c-b3b4-adc98d1d78e7	21.47	21.47	21.47	40	1019	18.32	66	ENE	22.75	f	0.00	scattered clouds	2026-05-03 21:00:00+00	2026-05-03 21:27:43.285595+00
d5f7111f-2041-484b-bdd1-2762b70f53ba	467c145d-f635-4cb3-9813-63f4d28b8780	4edb035e-dd00-468c-b227-544e1fe98cda	17.42	16.90	17.42	55	1017	16.67	330	NNW	0.00	f	0.00	clear sky	2026-05-03 22:00:00+00	2026-05-03 22:00:30.206111+00
f5974182-c0a0-48d0-b86e-e85b797a8b3e	f2df8134-8994-487c-8a25-272606e8f953	4edb035e-dd00-468c-b227-544e1fe98cda	26.14	26.14	26.14	16	1011	8.53	29	NNE	9.68	t	0.00	clear sky	2026-05-03 22:00:00+00	2026-05-03 22:00:31.024448+00
1bd293e1-de9c-4f90-b116-2e283ed42f32	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	4edb035e-dd00-468c-b227-544e1fe98cda	31.96	30.14	31.96	35	1005	9.25	160	SSE	0.00	f	0.00	clear sky	2026-05-03 22:00:00+00	2026-05-03 22:00:32.158719+00
9c6ed3c6-36a9-4827-9281-c6662789d770	6411b387-fc37-4b47-878b-8f89fd8e08d9	4edb035e-dd00-468c-b227-544e1fe98cda	33.95	33.95	33.95	17	1005	22.21	290	WNW	0.00	f	0.00	dust	2026-05-03 22:00:00+00	2026-05-03 22:00:33.09756+00
9a703d7c-5e79-435f-b1ca-61e22e317292	05546df7-881e-438f-96b9-be0148283901	4edb035e-dd00-468c-b227-544e1fe98cda	12.99	12.99	12.99	70	1013	37.80	234	SW	39.85	f	0.00	overcast clouds	2026-05-03 22:00:00+00	2026-05-03 22:00:33.985204+00
2492de75-40b6-4765-8a77-2b92a4a2f058	054b54c2-e6d1-4534-a9de-58bf2831479a	4edb035e-dd00-468c-b227-544e1fe98cda	13.05	12.75	13.05	71	1015	29.63	270	W	0.00	f	0.00	dust	2026-05-03 22:00:00+00	2026-05-03 22:00:34.894658+00
6c513a99-1644-48bb-91d5-6b60bb980394	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	4edb035e-dd00-468c-b227-544e1fe98cda	31.55	31.55	31.55	36	1007	2.16	331	NNW	2.92	f	0.00	clear sky	2026-05-03 22:00:00+00	2026-05-03 22:00:36.139002+00
18a37824-cdba-4ac1-9f48-535b361c42ca	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	4edb035e-dd00-468c-b227-544e1fe98cda	29.35	26.94	30.99	42	1007	9.25	330	NNW	0.00	t	0.00	clear sky	2026-05-03 22:00:00+00	2026-05-03 22:00:37.793017+00
7775e5f2-09a8-4f4b-b3ae-eeb716e38e9f	72829d11-3ace-445b-9f4b-5c3c72c3521f	4edb035e-dd00-468c-b227-544e1fe98cda	18.07	17.96	18.19	77	1017	7.42	30	NNE	0.00	t	0.00	broken clouds	2026-05-03 22:00:00+00	2026-05-03 22:00:39.42784+00
26b1d44c-4467-41ec-a80c-271fc24c6664	5bd52475-ffa2-40f6-82e4-3d0491b7e246	4edb035e-dd00-468c-b227-544e1fe98cda	20.82	20.82	20.82	43	1019	18.40	59	ENE	23.29	f	0.00	broken clouds	2026-05-03 22:00:00+00	2026-05-03 22:00:40.753749+00
f533a25a-77ee-4b82-90f4-618601991aa1	467c145d-f635-4cb3-9813-63f4d28b8780	38b2df80-d454-4d22-9665-338bfe70f2f3	17.42	16.90	17.42	51	1017	18.50	310	NW	0.00	f	0.00	clear sky	2026-05-03 23:00:00+00	2026-05-03 23:00:18.403748+00
accd4b91-9e58-4b46-a6cb-d8fce34f8353	f2df8134-8994-487c-8a25-272606e8f953	38b2df80-d454-4d22-9665-338bfe70f2f3	25.39	25.39	25.39	17	1011	9.29	26	NNE	10.12	t	0.00	clear sky	2026-05-03 23:00:00+00	2026-05-03 23:00:18.729951+00
382d7104-c34f-449f-8620-40e48faf8b7a	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	38b2df80-d454-4d22-9665-338bfe70f2f3	30.96	30.14	30.96	37	1005	7.42	180	S	0.00	t	0.00	clear sky	2026-05-03 23:00:00+00	2026-05-03 23:00:19.069936+00
b7c5fead-9fe3-41e3-b53c-be9d3b2a5fcf	6411b387-fc37-4b47-878b-8f89fd8e08d9	38b2df80-d454-4d22-9665-338bfe70f2f3	32.95	32.95	32.95	19	1007	29.63	290	WNW	51.84	f	0.00	dust	2026-05-03 23:00:00+00	2026-05-03 23:00:19.438202+00
9690431c-2014-400b-b2c6-42c0696a9617	05546df7-881e-438f-96b9-be0148283901	38b2df80-d454-4d22-9665-338bfe70f2f3	13.54	13.54	13.54	70	1012	35.57	217	SW	39.02	f	0.00	overcast clouds	2026-05-03 23:00:00+00	2026-05-03 23:00:19.807176+00
0ab12e62-b6fe-4cab-9533-e577939e2c6f	054b54c2-e6d1-4534-a9de-58bf2831479a	38b2df80-d454-4d22-9665-338bfe70f2f3	12.05	12.05	12.75	71	1015	18.50	260	W	0.00	f	0.00	scattered clouds	2026-05-03 23:00:00+00	2026-05-03 23:00:20.226961+00
f68e27e2-5b7a-43c5-9b2b-b14f41f7dd08	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	38b2df80-d454-4d22-9665-338bfe70f2f3	30.44	30.44	30.44	37	1007	4.00	285	WNW	4.36	f	0.00	clear sky	2026-05-03 23:00:00+00	2026-05-03 23:00:20.579517+00
0cc11951-2a0b-4d8d-b024-ce0b630700eb	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	38b2df80-d454-4d22-9665-338bfe70f2f3	29.57	28.94	29.99	36	1006	16.67	320	NW	0.00	t	0.00	clear sky	2026-05-03 23:00:00+00	2026-05-03 23:00:20.937416+00
ef74fe42-7778-4ef0-b452-35044e6ad908	72829d11-3ace-445b-9f4b-5c3c72c3521f	38b2df80-d454-4d22-9665-338bfe70f2f3	18.07	17.96	18.19	82	1017	7.42	40	NE	0.00	t	0.00	broken clouds	2026-05-03 23:00:00+00	2026-05-03 23:00:21.291285+00
624992f7-c3d2-4a4a-b083-988b4d97db46	5bd52475-ffa2-40f6-82e4-3d0491b7e246	38b2df80-d454-4d22-9665-338bfe70f2f3	20.20	20.20	20.20	45	1019	17.75	54	NE	23.62	f	0.00	scattered clouds	2026-05-03 23:00:00+00	2026-05-03 23:00:21.638373+00
af2db36e-3c89-468a-bb5b-2bb5fb0809bd	467c145d-f635-4cb3-9813-63f4d28b8780	1150dfb2-9183-43ee-b116-f4fbd0afa328	16.42	15.79	16.42	51	1017	18.50	300	WNW	0.00	f	0.00	clear sky	2026-05-04 00:00:00+00	2026-05-04 00:00:22.542741+00
2fc92051-895c-4805-8701-db4d30cda61f	f2df8134-8994-487c-8a25-272606e8f953	1150dfb2-9183-43ee-b116-f4fbd0afa328	25.12	25.12	25.12	17	1011	8.86	23	NNE	9.68	t	0.00	clear sky	2026-05-04 00:00:00+00	2026-05-04 00:00:22.859898+00
0ca4a032-1878-4fef-8f8a-0198c5510d85	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	1150dfb2-9183-43ee-b116-f4fbd0afa328	29.96	28.14	29.96	39	1005	7.42	200	SSW	0.00	t	0.00	clear sky	2026-05-04 00:00:00+00	2026-05-04 00:00:23.182295+00
60802e4b-9df3-42a1-8758-14be38249605	6411b387-fc37-4b47-878b-8f89fd8e08d9	1150dfb2-9183-43ee-b116-f4fbd0afa328	30.95	30.95	30.95	27	1007	40.75	310	NW	0.00	f	0.00	dust	2026-05-04 00:00:00+00	2026-05-04 00:00:23.49839+00
58eb70c8-55f2-4e6d-9c4b-aec5e6372401	05546df7-881e-438f-96b9-be0148283901	1150dfb2-9183-43ee-b116-f4fbd0afa328	12.99	12.99	12.99	70	1012	36.43	226	SW	40.43	f	0.00	overcast clouds	2026-05-04 00:00:00+00	2026-05-04 00:00:23.842177+00
791c40a6-94b3-4a7c-8a53-24b05dffab40	054b54c2-e6d1-4534-a9de-58bf2831479a	1150dfb2-9183-43ee-b116-f4fbd0afa328	12.05	11.75	12.05	71	1015	22.21	260	W	0.00	f	0.00	scattered clouds	2026-05-04 00:00:00+00	2026-05-04 00:00:24.161303+00
45835d78-cb87-473c-b9d3-e6c80d24881c	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	1150dfb2-9183-43ee-b116-f4fbd0afa328	29.88	29.88	29.88	35	1007	4.50	304	NW	4.86	t	0.00	clear sky	2026-05-04 00:00:00+00	2026-05-04 00:00:24.493184+00
bef707a2-d04c-4a7b-85fc-fd0d8231fe54	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	1150dfb2-9183-43ee-b116-f4fbd0afa328	28.76	26.94	29.99	36	1006	16.67	330	NNW	0.00	t	0.00	clear sky	2026-05-04 00:00:00+00	2026-05-04 00:00:24.845598+00
46d999db-3266-4753-8782-f803970cc21a	72829d11-3ace-445b-9f4b-5c3c72c3521f	1150dfb2-9183-43ee-b116-f4fbd0afa328	18.07	17.96	18.19	77	1017	9.25	20	NNE	0.00	t	0.00	broken clouds	2026-05-04 00:00:00+00	2026-05-04 00:00:25.159845+00
47186001-275b-41e2-94f8-c2afe8566a87	5bd52475-ffa2-40f6-82e4-3d0491b7e246	1150dfb2-9183-43ee-b116-f4fbd0afa328	19.50	19.50	19.50	48	1019	14.26	53	NE	21.35	f	0.00	scattered clouds	2026-05-04 00:00:00+00	2026-05-04 00:00:25.48824+00
cfd04794-d4a9-42d9-9521-d7e3b2884299	467c145d-f635-4cb3-9813-63f4d28b8780	19834361-b1ee-4125-8fe3-caf402f7dd36	16.42	15.79	16.42	48	1017	20.38	300	WNW	0.00	f	0.00	clear sky	2026-05-04 01:00:00+00	2026-05-04 01:00:26.345704+00
ed045d7c-e403-44fc-b122-c12c1a1627d4	f2df8134-8994-487c-8a25-272606e8f953	19834361-b1ee-4125-8fe3-caf402f7dd36	24.97	24.97	24.97	18	1011	6.05	23	NNE	6.59	t	0.00	clear sky	2026-05-04 01:00:00+00	2026-05-04 01:00:26.673303+00
b0e1431e-bb0d-48ce-9467-8cde081ae5a3	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	19834361-b1ee-4125-8fe3-caf402f7dd36	29.96	29.14	29.96	39	1005	9.25	200	SSW	0.00	t	0.00	clear sky	2026-05-04 01:00:00+00	2026-05-04 01:00:26.998948+00
884df9e8-1394-458d-8121-0b40301f70b6	6411b387-fc37-4b47-878b-8f89fd8e08d9	19834361-b1ee-4125-8fe3-caf402f7dd36	28.95	28.95	28.95	30	1008	33.34	300	WNW	0.00	t	0.00	dust	2026-05-04 01:00:00+00	2026-05-04 01:00:27.335604+00
150170c0-59bb-41c9-aae0-b775647d5f06	05546df7-881e-438f-96b9-be0148283901	19834361-b1ee-4125-8fe3-caf402f7dd36	12.43	12.43	12.43	62	1012	31.43	223	SW	35.21	f	0.00	overcast clouds	2026-05-04 01:00:00+00	2026-05-04 01:00:27.654516+00
fa50c008-34d3-40c8-8158-a8a0628b31e7	054b54c2-e6d1-4534-a9de-58bf2831479a	19834361-b1ee-4125-8fe3-caf402f7dd36	12.05	11.75	12.05	71	1015	18.50	250	WSW	0.00	f	0.00	scattered clouds	2026-05-04 01:00:00+00	2026-05-04 01:00:27.979556+00
bb0c22d7-dda8-491b-9454-95f4ebf028b9	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	19834361-b1ee-4125-8fe3-caf402f7dd36	28.21	28.21	28.21	36	1007	4.43	346	NNW	4.75	t	0.00	clear sky	2026-05-04 01:00:00+00	2026-05-04 01:00:28.297112+00
813775d8-9ab1-4bd8-8c1f-061142a382c0	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	19834361-b1ee-4125-8fe3-caf402f7dd36	29.16	27.17	29.99	33	1007	9.25	320	NW	0.00	t	0.00	clear sky	2026-05-04 01:00:00+00	2026-05-04 01:00:28.638557+00
0f6065cf-836b-4463-b412-9c5f11806548	72829d11-3ace-445b-9f4b-5c3c72c3521f	19834361-b1ee-4125-8fe3-caf402f7dd36	18.07	17.96	18.19	77	1017	9.25	20	NNE	0.00	t	0.00	overcast clouds	2026-05-04 01:00:00+00	2026-05-04 01:00:28.962482+00
eaaa9c25-da2f-4456-9d39-fb6f1d2c3e0a	5bd52475-ffa2-40f6-82e4-3d0491b7e246	19834361-b1ee-4125-8fe3-caf402f7dd36	19.01	19.01	19.01	51	1018	13.86	66	ENE	19.12	f	0.00	few clouds	2026-05-04 01:00:00+00	2026-05-04 01:00:29.277906+00
70947e73-26c0-4514-99d8-a3d995389862	467c145d-f635-4cb3-9813-63f4d28b8780	165564d6-ff65-4bc4-8787-3ca5827012de	16.42	15.79	16.42	48	1017	18.50	300	WNW	0.00	f	0.00	clear sky	2026-05-04 02:00:00+00	2026-05-04 02:00:30.154426+00
ba1bd632-5968-40ff-a653-54010b38f2fc	f2df8134-8994-487c-8a25-272606e8f953	165564d6-ff65-4bc4-8787-3ca5827012de	24.16	24.16	24.16	18	1011	3.85	42	NE	4.46	t	0.00	clear sky	2026-05-04 02:00:00+00	2026-05-04 02:00:30.50445+00
e0dd5a83-803c-49a1-8c04-942018d23596	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	165564d6-ff65-4bc4-8787-3ca5827012de	28.96	28.14	28.96	42	1006	12.96	200	SSW	0.00	t	0.00	clear sky	2026-05-04 02:00:00+00	2026-05-04 02:00:30.818559+00
aa1d3898-987a-498e-95a8-588f2d4f388e	6411b387-fc37-4b47-878b-8f89fd8e08d9	165564d6-ff65-4bc4-8787-3ca5827012de	26.95	26.95	26.95	36	1010	29.63	320	NW	0.00	t	0.00	dust	2026-05-04 02:00:00+00	2026-05-04 02:00:31.144255+00
de756bee-9110-4773-9b3a-2274801939ee	05546df7-881e-438f-96b9-be0148283901	165564d6-ff65-4bc4-8787-3ca5827012de	12.43	12.43	12.43	54	1012	33.34	214	SW	36.58	f	0.00	overcast clouds	2026-05-04 02:00:00+00	2026-05-04 02:00:31.462+00
447cbdf2-f550-4fd3-ab91-5bc985303a41	054b54c2-e6d1-4534-a9de-58bf2831479a	165564d6-ff65-4bc4-8787-3ca5827012de	11.05	11.05	11.75	76	1015	25.92	270	W	0.00	f	0.00	scattered clouds	2026-05-04 02:00:00+00	2026-05-04 02:00:31.799889+00
ef0d3724-b39a-4ab8-b886-1d23c7155522	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	165564d6-ff65-4bc4-8787-3ca5827012de	28.21	28.21	28.21	35	1007	1.66	318	NW	1.33	t	0.00	clear sky	2026-05-04 02:00:00+00	2026-05-04 02:00:32.126732+00
4d68d2c4-8ff1-434d-92e1-3d1a183fcc3a	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	165564d6-ff65-4bc4-8787-3ca5827012de	25.94	25.94	26.17	44	1007	5.54	310	NW	0.00	t	0.00	clear sky	2026-05-04 02:00:00+00	2026-05-04 02:00:32.454898+00
5033ab04-d17b-430f-b111-9ae72285912d	72829d11-3ace-445b-9f4b-5c3c72c3521f	165564d6-ff65-4bc4-8787-3ca5827012de	17.02	16.85	17.19	77	1016	7.42	30	NNE	0.00	t	0.00	overcast clouds	2026-05-04 02:00:00+00	2026-05-04 02:00:32.799426+00
1f1b4105-7302-44cd-8231-b63a5faf6b84	5bd52475-ffa2-40f6-82e4-3d0491b7e246	165564d6-ff65-4bc4-8787-3ca5827012de	18.64	18.64	18.64	48	1018	10.55	81	E	10.84	f	0.00	scattered clouds	2026-05-04 02:00:00+00	2026-05-04 02:00:33.11555+00
958dd480-0613-43d3-a2af-a7a439e953fa	467c145d-f635-4cb3-9813-63f4d28b8780	1b8947ea-2c93-40ba-992c-3e4700be8cda	15.42	15.23	15.42	47	1017	16.67	290	WNW	0.00	f	0.00	clear sky	2026-05-04 03:00:00+00	2026-05-04 03:00:34.008432+00
b6e3b4d4-5645-4d2b-b798-488ddebe8e9e	f2df8134-8994-487c-8a25-272606e8f953	1b8947ea-2c93-40ba-992c-3e4700be8cda	24.50	24.50	24.50	19	1011	3.53	75	ENE	3.92	t	0.00	clear sky	2026-05-04 03:00:00+00	2026-05-04 03:00:34.3395+00
39e991d3-daac-46b7-857e-7c134dc71b34	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	1b8947ea-2c93-40ba-992c-3e4700be8cda	28.96	28.14	28.96	42	1006	12.96	190	S	0.00	t	0.00	clear sky	2026-05-04 03:00:00+00	2026-05-04 03:00:34.667329+00
bd6c2bd4-59b1-45c7-acaf-73e068a162fe	6411b387-fc37-4b47-878b-8f89fd8e08d9	1b8947ea-2c93-40ba-992c-3e4700be8cda	25.95	25.95	25.95	41	1010	29.63	330	NNW	0.00	t	0.00	dust	2026-05-04 03:00:00+00	2026-05-04 03:00:34.980621+00
57094f82-0de5-4511-8090-e6976ee44bed	05546df7-881e-438f-96b9-be0148283901	1b8947ea-2c93-40ba-992c-3e4700be8cda	11.88	11.88	11.88	56	1012	37.69	207	SSW	42.59	f	0.00	overcast clouds	2026-05-04 03:00:00+00	2026-05-04 03:00:35.29785+00
7d40b73d-ebef-4b2d-862b-0dd134342c93	054b54c2-e6d1-4534-a9de-58bf2831479a	1b8947ea-2c93-40ba-992c-3e4700be8cda	11.05	10.75	11.05	66	1015	18.50	260	W	0.00	f	0.00	scattered clouds	2026-05-04 03:00:00+00	2026-05-04 03:00:35.597724+00
290cdbea-2647-4cb5-a92e-50efecd43111	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	1b8947ea-2c93-40ba-992c-3e4700be8cda	29.32	29.32	29.32	33	1008	8.42	237	WSW	8.64	t	0.00	clear sky	2026-05-04 03:00:00+00	2026-05-04 03:00:35.922451+00
a2d0f756-5c56-4416-801c-58b6a5d019de	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	1b8947ea-2c93-40ba-992c-3e4700be8cda	28.16	26.17	28.99	35	1007	5.54	270	W	0.00	t	0.00	clear sky	2026-05-04 03:00:00+00	2026-05-04 03:00:36.246929+00
f4b20afc-a8f8-495f-8e4c-80965824d48e	72829d11-3ace-445b-9f4b-5c3c72c3521f	1b8947ea-2c93-40ba-992c-3e4700be8cda	17.02	16.12	17.19	77	1016	7.42	40	NE	0.00	t	0.00	overcast clouds	2026-05-04 03:00:00+00	2026-05-04 03:00:36.571445+00
78a84f62-b0a8-42f0-bf1f-64e4bac3aa15	5bd52475-ffa2-40f6-82e4-3d0491b7e246	1b8947ea-2c93-40ba-992c-3e4700be8cda	17.15	17.15	17.15	48	1018	9.94	70	ENE	10.15	f	0.00	scattered clouds	2026-05-04 03:00:00+00	2026-05-04 03:00:36.966945+00
6715da5f-150e-447d-9389-8420d4fb00ff	467c145d-f635-4cb3-9813-63f4d28b8780	f604a38f-fb5c-4de3-8e84-a3255650193a	15.42	15.42	15.42	51	1017	14.83	260	W	0.00	f	0.00	clear sky	2026-05-04 04:00:00+00	2026-05-04 04:00:37.778245+00
83c7e61f-d608-4863-8999-1a2c71df69f7	f2df8134-8994-487c-8a25-272606e8f953	f604a38f-fb5c-4de3-8e84-a3255650193a	27.29	27.29	27.29	18	1012	2.56	96	E	3.49	t	0.00	clear sky	2026-05-04 04:00:00+00	2026-05-04 04:00:38.089304+00
b0ee1d70-96fd-45f9-a5c2-f97273c7aa03	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	f604a38f-fb5c-4de3-8e84-a3255650193a	28.96	28.96	29.14	45	1007	14.83	180	S	0.00	t	0.00	clear sky	2026-05-04 04:00:00+00	2026-05-04 04:00:38.435457+00
900a865c-1c6d-47cf-98ac-7110446e7efc	6411b387-fc37-4b47-878b-8f89fd8e08d9	f604a38f-fb5c-4de3-8e84-a3255650193a	23.95	23.95	23.95	46	1011	24.08	320	NW	0.00	t	0.00	broken clouds	2026-05-04 04:00:00+00	2026-05-04 04:00:38.767929+00
72ded7a1-a9e4-4601-83c2-449f90421ce3	05546df7-881e-438f-96b9-be0148283901	f604a38f-fb5c-4de3-8e84-a3255650193a	12.43	12.43	12.43	60	1012	39.17	214	SW	46.01	f	0.00	overcast clouds	2026-05-04 04:00:00+00	2026-05-04 04:00:39.096566+00
3b777ce1-9c63-4278-907d-ac141d07f189	054b54c2-e6d1-4534-a9de-58bf2831479a	f604a38f-fb5c-4de3-8e84-a3255650193a	10.05	8.75	10.05	71	1015	16.67	250	WSW	0.00	f	0.00	haze	2026-05-04 04:00:00+00	2026-05-04 04:00:39.43022+00
7e480a40-d5f8-42d6-a829-da6c51175de0	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	f604a38f-fb5c-4de3-8e84-a3255650193a	30.99	30.99	30.99	34	1008	7.49	225	SW	7.92	f	0.00	clear sky	2026-05-04 04:00:00+00	2026-05-04 04:00:39.770332+00
81ca14b1-5f96-4e31-afbc-d34345a73830	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	f604a38f-fb5c-4de3-8e84-a3255650193a	27.94	26.17	27.94	34	1008	7.42	300	WNW	0.00	t	0.00	clear sky	2026-05-04 04:00:00+00	2026-05-04 04:00:40.090644+00
097a2400-03ae-4a9a-9036-3f107f3f7244	72829d11-3ace-445b-9f4b-5c3c72c3521f	f604a38f-fb5c-4de3-8e84-a3255650193a	17.02	16.12	17.19	77	1016	7.42	40	NE	0.00	t	0.00	overcast clouds	2026-05-04 04:00:00+00	2026-05-04 04:00:40.564543+00
176fa349-9209-40ff-b5c2-c81948b89319	5bd52475-ffa2-40f6-82e4-3d0491b7e246	f604a38f-fb5c-4de3-8e84-a3255650193a	17.23	17.23	17.23	51	1018	7.92	67	ENE	8.46	f	0.00	few clouds	2026-05-04 04:00:00+00	2026-05-04 04:00:40.889974+00
4147ba3d-44e9-434e-8cbe-babea84d3109	467c145d-f635-4cb3-9813-63f4d28b8780	b2a78c5c-4542-4ce8-a445-2ce36b49da91	16.42	15.79	16.42	48	1017	16.67	250	WSW	0.00	f	0.00	clear sky	2026-05-04 05:00:00+00	2026-05-04 05:00:41.823651+00
a4b44452-8bba-42ab-b01a-2d0953b91c7e	f2df8134-8994-487c-8a25-272606e8f953	b2a78c5c-4542-4ce8-a445-2ce36b49da91	30.00	30.00	30.00	15	1012	4.72	98	E	6.52	f	0.00	clear sky	2026-05-04 05:00:00+00	2026-05-04 05:00:42.317673+00
e9ff0fb8-f284-4785-9f8d-357f99e95eb5	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	b2a78c5c-4542-4ce8-a445-2ce36b49da91	30.96	30.96	31.14	42	1007	11.12	190	S	0.00	f	0.00	clear sky	2026-05-04 05:00:00+00	2026-05-04 05:00:42.682932+00
c1f1e9c3-a371-4910-b53d-c48b2f9ea484	6411b387-fc37-4b47-878b-8f89fd8e08d9	b2a78c5c-4542-4ce8-a445-2ce36b49da91	25.79	25.79	25.79	42	1011	25.56	328	NNW	31.32	t	0.00	broken clouds	2026-05-04 05:00:00+00	2026-05-04 05:00:43.176112+00
3d38cadf-da61-4f12-be67-1362a73adfd3	05546df7-881e-438f-96b9-be0148283901	b2a78c5c-4542-4ce8-a445-2ce36b49da91	13.54	13.54	13.54	67	1013	41.54	214	SW	48.17	f	0.00	overcast clouds	2026-05-04 05:00:00+00	2026-05-04 05:00:43.70874+00
1c80f18f-639e-4e75-a697-745a776e488a	054b54c2-e6d1-4534-a9de-58bf2831479a	b2a78c5c-4542-4ce8-a445-2ce36b49da91	11.05	11.05	11.75	62	1015	20.38	250	WSW	0.00	f	0.00	haze	2026-05-04 05:00:00+00	2026-05-04 05:00:44.226781+00
ef4dd37f-0fa5-4d2f-8da5-884bc68d54e9	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	b2a78c5c-4542-4ce8-a445-2ce36b49da91	34.32	34.32	34.32	30	1009	6.30	232	SW	6.88	f	0.00	clear sky	2026-05-04 05:00:00+00	2026-05-04 05:00:44.754911+00
026549b9-b293-4479-93b7-611d188558ad	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	b2a78c5c-4542-4ce8-a445-2ce36b49da91	30.94	29.17	30.94	30	1008	11.12	300	WNW	0.00	f	0.00	clear sky	2026-05-04 05:00:00+00	2026-05-04 05:00:45.253357+00
9c9288a3-b67e-4b5d-9151-8be10c3d5202	72829d11-3ace-445b-9f4b-5c3c72c3521f	b2a78c5c-4542-4ce8-a445-2ce36b49da91	17.02	16.12	17.19	77	1016	5.54	40	NE	0.00	t	0.00	overcast clouds	2026-05-04 05:00:00+00	2026-05-04 05:00:45.707188+00
d23189ca-fdcc-4cc4-93ca-75b18edfa00d	5bd52475-ffa2-40f6-82e4-3d0491b7e246	b2a78c5c-4542-4ce8-a445-2ce36b49da91	16.74	16.74	16.74	53	1018	7.09	88	E	7.45	f	0.00	few clouds	2026-05-04 05:00:00+00	2026-05-04 05:00:46.125816+00
615b62d7-5ff8-4dc9-9f85-c250dc45c382	467c145d-f635-4cb3-9813-63f4d28b8780	c8b8ac5e-3e24-4ad7-84b0-574837be327f	17.42	16.90	17.42	45	1018	18.50	250	WSW	0.00	f	0.00	clear sky	2026-05-04 06:00:00+00	2026-05-04 06:00:46.8926+00
07d9d246-ad35-4b5d-92f0-fb9c23a5339e	f2df8134-8994-487c-8a25-272606e8f953	c8b8ac5e-3e24-4ad7-84b0-574837be327f	32.37	32.37	32.37	12	1012	8.39	134	SE	9.04	f	0.00	clear sky	2026-05-04 06:00:00+00	2026-05-04 06:00:47.208573+00
d31eb4d7-87d1-4c0c-9955-867faefb8bfd	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	c8b8ac5e-3e24-4ad7-84b0-574837be327f	33.96	33.96	34.14	33	1007	11.12	200	SSW	0.00	f	0.00	clear sky	2026-05-04 06:00:00+00	2026-05-04 06:00:47.523389+00
aced99a8-be5d-4e55-abba-3b8f30b1a4af	6411b387-fc37-4b47-878b-8f89fd8e08d9	c8b8ac5e-3e24-4ad7-84b0-574837be327f	23.95	23.95	23.95	50	1011	20.38	330	NNW	0.00	t	0.00	scattered clouds	2026-05-04 06:00:00+00	2026-05-04 06:00:47.837889+00
793725bd-b6f8-40d6-98fd-6d01aaca7483	05546df7-881e-438f-96b9-be0148283901	c8b8ac5e-3e24-4ad7-84b0-574837be327f	13.54	13.54	13.54	67	1013	42.88	207	SSW	49.68	f	0.00	overcast clouds	2026-05-04 06:00:00+00	2026-05-04 06:00:48.18984+00
48bb5ea8-5005-47d9-9181-54271906c6fc	054b54c2-e6d1-4534-a9de-58bf2831479a	c8b8ac5e-3e24-4ad7-84b0-574837be327f	12.05	12.05	12.75	62	1015	24.08	240	WSW	0.00	f	0.00	scattered clouds	2026-05-04 06:00:00+00	2026-05-04 06:00:48.503938+00
fcc3da0e-9d98-4cb4-a1b7-dfcbd1d3bd4e	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	c8b8ac5e-3e24-4ad7-84b0-574837be327f	32.81	32.81	32.81	27	1009	5.26	263	W	5.83	f	0.00	clear sky	2026-05-04 06:00:00+00	2026-05-04 06:00:48.823392+00
03629239-5145-4128-97bb-49cdfcf35657	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	c8b8ac5e-3e24-4ad7-84b0-574837be327f	34.16	32.17	34.99	25	1008	12.96	310	NW	0.00	f	0.00	clear sky	2026-05-04 06:00:00+00	2026-05-04 06:00:49.14373+00
e6296f94-56aa-454f-a71f-220df27a1806	72829d11-3ace-445b-9f4b-5c3c72c3521f	c8b8ac5e-3e24-4ad7-84b0-574837be327f	17.02	15.12	17.19	77	1017	5.54	30	NNE	0.00	f	0.00	overcast clouds	2026-05-04 06:00:00+00	2026-05-04 06:00:49.495017+00
fdad1026-bd9f-4cdb-92fa-af635ef29872	5bd52475-ffa2-40f6-82e4-3d0491b7e246	c8b8ac5e-3e24-4ad7-84b0-574837be327f	19.24	19.24	19.24	52	1018	6.23	111	ESE	7.27	t	0.00	scattered clouds	2026-05-04 06:00:00+00	2026-05-04 06:00:49.819543+00
2c31f7eb-97a1-49a5-b357-435be9384f93	467c145d-f635-4cb3-9813-63f4d28b8780	1b5595c2-c422-441b-be07-e8907f23cc9a	18.42	18.01	18.42	42	1018	22.21	250	WSW	0.00	f	0.00	clear sky	2026-05-04 07:00:00+00	2026-05-04 07:00:50.689239+00
f405ba32-f6d8-47d6-bb51-b50dcd9791ef	f2df8134-8994-487c-8a25-272606e8f953	1b5595c2-c422-441b-be07-e8907f23cc9a	35.30	35.30	35.30	9	1012	9.54	132	SE	9.22	f	0.00	clear sky	2026-05-04 07:00:00+00	2026-05-04 07:00:51.007534+00
f8432ffa-fe76-4924-aa1f-a4b43402d145	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	1b5595c2-c422-441b-be07-e8907f23cc9a	35.96	35.96	37.14	24	1007	12.96	0	N	0.00	f	0.00	clear sky	2026-05-04 07:00:00+00	2026-05-04 07:00:51.331206+00
b3db2c59-e7f5-41f0-9a0c-2cd8d4ff2eba	6411b387-fc37-4b47-878b-8f89fd8e08d9	1b5595c2-c422-441b-be07-e8907f23cc9a	25.95	25.95	25.95	41	1011	14.83	330	NNW	0.00	t	0.00	overcast clouds	2026-05-04 07:00:00+00	2026-05-04 07:00:51.656478+00
464a655e-7051-4479-a734-b20927b35e09	05546df7-881e-438f-96b9-be0148283901	1b5595c2-c422-441b-be07-e8907f23cc9a	13.54	13.54	13.54	70	1013	40.79	195	SSW	48.53	f	0.00	overcast clouds	2026-05-04 07:00:00+00	2026-05-04 07:00:52.006852+00
b0455444-6226-4c57-8c82-8acedb3713a9	054b54c2-e6d1-4534-a9de-58bf2831479a	1b5595c2-c422-441b-be07-e8907f23cc9a	13.05	13.05	13.75	58	1015	24.08	260	W	0.00	f	0.00	haze	2026-05-04 07:00:00+00	2026-05-04 07:00:52.328596+00
e2c983c5-e15e-460a-94cb-78c02c55a1b2	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	1b5595c2-c422-441b-be07-e8907f23cc9a	34.32	34.32	34.32	39	1009	5.36	275	W	6.77	f	0.00	clear sky	2026-05-04 07:00:00+00	2026-05-04 07:00:52.657264+00
dd16a68e-13fa-4f72-8940-9caf21047511	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	1b5595c2-c422-441b-be07-e8907f23cc9a	36.16	34.94	36.99	22	1008	16.67	320	NW	0.00	f	0.00	clear sky	2026-05-04 07:00:00+00	2026-05-04 07:00:52.973795+00
0e28b254-7433-4a9e-917c-20536b92d3b5	72829d11-3ace-445b-9f4b-5c3c72c3521f	1b5595c2-c422-441b-be07-e8907f23cc9a	17.02	15.12	17.19	72	1017	1.84	0	N	0.00	f	0.00	overcast clouds	2026-05-04 07:00:00+00	2026-05-04 07:00:53.309883+00
ad9b2be7-f026-4a79-a5cd-a7fd8a328a2b	5bd52475-ffa2-40f6-82e4-3d0491b7e246	1b5595c2-c422-441b-be07-e8907f23cc9a	21.30	21.30	21.30	43	1019	4.68	161	SSE	6.34	f	0.00	overcast clouds	2026-05-04 07:00:00+00	2026-05-04 07:00:53.63615+00
401fa734-c34c-43c9-af9a-95feaecb697f	467c145d-f635-4cb3-9813-63f4d28b8780	3609467d-1cb7-4cd8-b1c6-bbbaabf65ee2	20.42	20.23	20.42	37	1018	22.21	250	WSW	0.00	f	0.00	clear sky	2026-05-04 08:00:00+00	2026-05-04 08:00:54.506703+00
affac8ae-6d3e-4afe-9ac7-598f2f28fd1f	f2df8134-8994-487c-8a25-272606e8f953	3609467d-1cb7-4cd8-b1c6-bbbaabf65ee2	37.05	37.05	37.05	8	1010	10.30	122	ESE	8.68	f	0.00	clear sky	2026-05-04 08:00:00+00	2026-05-04 08:00:54.827615+00
d52c3239-fc90-4d7a-a978-a178e0731f59	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	3609467d-1cb7-4cd8-b1c6-bbbaabf65ee2	35.96	35.96	36.14	28	1006	18.50	280	W	0.00	f	0.00	clear sky	2026-05-04 08:00:00+00	2026-05-04 08:00:55.142718+00
81d99f78-58c4-4641-9601-030aaa146a27	6411b387-fc37-4b47-878b-8f89fd8e08d9	3609467d-1cb7-4cd8-b1c6-bbbaabf65ee2	26.95	26.95	26.95	32	1011	20.38	330	NNW	0.00	t	0.00	overcast clouds	2026-05-04 08:00:00+00	2026-05-04 08:00:55.46438+00
5cf10011-750f-46fc-a85f-823df19789a6	05546df7-881e-438f-96b9-be0148283901	3609467d-1cb7-4cd8-b1c6-bbbaabf65ee2	12.43	12.43	12.43	78	1014	50.26	218	SW	57.64	f	0.00	overcast clouds	2026-05-04 08:00:00+00	2026-05-04 08:00:55.809805+00
c1549264-0f12-4aac-87a3-b02286d73c79	054b54c2-e6d1-4534-a9de-58bf2831479a	3609467d-1cb7-4cd8-b1c6-bbbaabf65ee2	13.05	13.05	13.75	62	1016	25.92	260	W	0.00	f	0.00	haze	2026-05-04 08:00:00+00	2026-05-04 08:00:56.132071+00
f63442a8-6332-4766-8301-884fc6fc4848	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	3609467d-1cb7-4cd8-b1c6-bbbaabf65ee2	32.66	32.66	32.66	42	1009	4.68	318	NW	6.23	f	0.00	clear sky	2026-05-04 08:00:00+00	2026-05-04 08:00:56.455901+00
55dbfd95-9cd1-48c8-bfe6-1fefb0131d70	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	3609467d-1cb7-4cd8-b1c6-bbbaabf65ee2	37.16	35.94	37.99	19	1007	18.50	10	N	0.00	f	0.00	clear sky	2026-05-04 08:00:00+00	2026-05-04 08:00:56.774709+00
e13c63ce-f0bb-4481-bdc5-68c031d6c747	72829d11-3ace-445b-9f4b-5c3c72c3521f	3609467d-1cb7-4cd8-b1c6-bbbaabf65ee2	18.07	17.96	19.12	72	1017	3.71	50	NE	0.00	t	0.00	broken clouds	2026-05-04 08:00:00+00	2026-05-04 08:00:57.11446+00
19d55a67-be41-423e-a00a-2f79ab8a9f8d	5bd52475-ffa2-40f6-82e4-3d0491b7e246	3609467d-1cb7-4cd8-b1c6-bbbaabf65ee2	22.98	22.98	22.98	34	1019	6.30	176	S	8.50	f	0.00	overcast clouds	2026-05-04 08:00:00+00	2026-05-04 08:00:57.429575+00
cdca280d-2180-4679-a477-a8c97dd46482	467c145d-f635-4cb3-9813-63f4d28b8780	4418f6fb-8c68-467d-94f1-5356b8db3980	20.42	20.23	20.42	37	1018	24.08	260	W	0.00	f	0.00	clear sky	2026-05-04 09:00:00+00	2026-05-04 09:00:20.893522+00
9c6683e1-75a7-4091-9a72-74df687baa83	f2df8134-8994-487c-8a25-272606e8f953	4418f6fb-8c68-467d-94f1-5356b8db3980	37.32	37.32	37.32	7	1010	7.81	132	SE	6.26	f	0.00	clear sky	2026-05-04 09:00:00+00	2026-05-04 09:00:21.209323+00
61367266-349f-46fa-9f9c-a0155e030107	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	4418f6fb-8c68-467d-94f1-5356b8db3980	34.96	34.96	36.14	36	1006	20.38	270	W	0.00	f	0.00	clear sky	2026-05-04 09:00:00+00	2026-05-04 09:00:21.513488+00
5efbf0be-87ef-4f73-9d00-a81c4abd6f9e	6411b387-fc37-4b47-878b-8f89fd8e08d9	4418f6fb-8c68-467d-94f1-5356b8db3980	27.95	27.95	27.95	30	1011	16.67	340	NNW	0.00	t	0.00	clear sky	2026-05-04 09:00:00+00	2026-05-04 09:00:21.831045+00
b0c7fae9-49ac-4372-8b8c-bbc6a23275b8	05546df7-881e-438f-96b9-be0148283901	4418f6fb-8c68-467d-94f1-5356b8db3980	12.43	12.43	12.43	69	1014	46.98	215	SW	55.69	f	0.00	overcast clouds	2026-05-04 09:00:00+00	2026-05-04 09:00:22.1525+00
793850e4-385f-4563-ba04-0b394319241c	054b54c2-e6d1-4534-a9de-58bf2831479a	4418f6fb-8c68-467d-94f1-5356b8db3980	14.05	14.05	15.75	58	1015	22.21	250	WSW	0.00	f	0.00	haze	2026-05-04 09:00:00+00	2026-05-04 09:00:22.505435+00
c98d157a-71c5-48ea-95f1-2c5727fe8f0a	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	4418f6fb-8c68-467d-94f1-5356b8db3980	33.21	33.21	33.21	45	1008	4.25	8	N	6.30	f	0.00	clear sky	2026-05-04 09:00:00+00	2026-05-04 09:00:22.861374+00
d50a3c56-6b23-4794-a24e-1d715abef08c	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	4418f6fb-8c68-467d-94f1-5356b8db3980	38.16	36.94	39.17	18	1007	18.50	10	N	0.00	f	0.00	clear sky	2026-05-04 09:00:00+00	2026-05-04 09:00:23.310805+00
6b832931-d471-47ca-820d-4f5d614844c8	72829d11-3ace-445b-9f4b-5c3c72c3521f	4418f6fb-8c68-467d-94f1-5356b8db3980	19.13	19.07	21.12	68	1017	5.54	40	NE	0.00	t	0.00	scattered clouds	2026-05-04 09:00:00+00	2026-05-04 09:00:23.63048+00
d7034a50-13b2-48e3-9006-124de522522a	5bd52475-ffa2-40f6-82e4-3d0491b7e246	4418f6fb-8c68-467d-94f1-5356b8db3980	24.86	24.86	24.86	29	1019	7.56	184	S	10.19	f	0.00	overcast clouds	2026-05-04 09:00:00+00	2026-05-04 09:00:23.94523+00
574f8de0-eeb0-47d5-8639-aa1b8f330442	467c145d-f635-4cb3-9813-63f4d28b8780	1997aea2-805d-488a-8516-183edc4e2f2e	21.42	20.79	21.42	35	1017	24.08	280	W	0.00	f	0.00	scattered clouds	2026-05-04 10:00:00+00	2026-05-04 10:26:20.750787+00
df9238f6-960e-41e2-a704-babfb088f821	f2df8134-8994-487c-8a25-272606e8f953	1997aea2-805d-488a-8516-183edc4e2f2e	38.01	38.01	38.01	7	1009	6.23	146	SE	12.20	f	0.00	clear sky	2026-05-04 10:00:00+00	2026-05-04 10:26:21.124444+00
29509464-89f5-40d4-aa7b-e9af7b8d59b4	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	1997aea2-805d-488a-8516-183edc4e2f2e	34.96	34.96	35.14	34	1005	20.38	270	W	0.00	f	0.00	clear sky	2026-05-04 10:00:00+00	2026-05-04 10:26:21.535814+00
18fa7086-6e3c-48d2-8332-57730ac8e9f5	6411b387-fc37-4b47-878b-8f89fd8e08d9	1997aea2-805d-488a-8516-183edc4e2f2e	29.95	29.95	29.95	25	1010	16.67	310	NW	0.00	f	0.00	clear sky	2026-05-04 10:00:00+00	2026-05-04 10:26:21.976857+00
d587913b-985d-4d3b-a263-c1b107783773	05546df7-881e-438f-96b9-be0148283901	1997aea2-805d-488a-8516-183edc4e2f2e	14.65	14.65	14.65	68	1014	46.91	209	SSW	53.24	f	0.00	overcast clouds	2026-05-04 10:00:00+00	2026-05-04 10:26:22.325652+00
a4e97376-6f42-4574-804d-099f2f0dfbc3	054b54c2-e6d1-4534-a9de-58bf2831479a	1997aea2-805d-488a-8516-183edc4e2f2e	17.05	17.05	17.75	39	1016	31.50	260	W	0.00	f	0.00	dust	2026-05-04 10:00:00+00	2026-05-04 10:26:22.650556+00
d02e2860-1a6a-404e-9482-e1614be44311	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	1997aea2-805d-488a-8516-183edc4e2f2e	33.77	33.77	33.77	43	1006	2.74	19	NNE	8.50	f	0.00	clear sky	2026-05-04 10:00:00+00	2026-05-04 10:26:22.982163+00
b2e1ea1d-635f-448c-866e-aed135ad7795	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	1997aea2-805d-488a-8516-183edc4e2f2e	36.99	34.94	36.99	34	1006	22.21	50	NE	0.00	f	0.00	clear sky	2026-05-04 10:00:00+00	2026-05-04 10:26:23.332585+00
c5367bfa-42d4-44f5-899b-901cc46048df	72829d11-3ace-445b-9f4b-5c3c72c3521f	1997aea2-805d-488a-8516-183edc4e2f2e	20.19	20.18	21.12	64	1018	9.25	30	NNE	0.00	t	0.00	scattered clouds	2026-05-04 10:00:00+00	2026-05-04 10:26:23.660182+00
e9130761-b33d-4e2c-80be-e523ded1b3b1	5bd52475-ffa2-40f6-82e4-3d0491b7e246	1997aea2-805d-488a-8516-183edc4e2f2e	26.23	26.23	26.23	23	1018	8.57	187	S	10.48	f	0.00	overcast clouds	2026-05-04 10:00:00+00	2026-05-04 10:26:24.001444+00
0667f0db-76be-4d7b-b0c6-359b01bdf8d4	467c145d-f635-4cb3-9813-63f4d28b8780	bb78c448-eb25-4d0f-b764-7d5c466a47be	21.42	21.42	21.90	35	1017	25.92	300	WNW	0.00	f	0.00	scattered clouds	2026-05-04 11:00:00+00	2026-05-04 11:07:10.8035+00
9ea72bf0-17d3-4a24-ba4b-c1b6ca53f631	f2df8134-8994-487c-8a25-272606e8f953	bb78c448-eb25-4d0f-b764-7d5c466a47be	38.39	38.39	38.39	7	1008	4.86	160	SSE	16.06	f	0.00	clear sky	2026-05-04 11:00:00+00	2026-05-04 11:07:11.138881+00
1c682d83-f822-4ecf-a512-57e7a572cf51	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	bb78c448-eb25-4d0f-b764-7d5c466a47be	35.96	35.14	35.96	32	1005	24.08	280	W	0.00	f	0.00	clear sky	2026-05-04 11:00:00+00	2026-05-04 11:07:11.477141+00
a3410496-49e6-476a-89c3-70983443f57f	6411b387-fc37-4b47-878b-8f89fd8e08d9	bb78c448-eb25-4d0f-b764-7d5c466a47be	29.95	29.95	29.95	25	1009	16.67	310	NW	0.00	f	0.00	clear sky	2026-05-04 11:00:00+00	2026-05-04 11:07:11.838502+00
722b2bac-aa15-4557-bfad-ef23aa03fc26	05546df7-881e-438f-96b9-be0148283901	bb78c448-eb25-4d0f-b764-7d5c466a47be	14.10	14.10	14.10	63	1013	48.60	217	SW	56.16	f	0.00	overcast clouds	2026-05-04 11:00:00+00	2026-05-04 11:07:12.17649+00
abc3be07-7faf-45b3-b116-5f2618518e37	054b54c2-e6d1-4534-a9de-58bf2831479a	bb78c448-eb25-4d0f-b764-7d5c466a47be	17.05	17.05	17.75	39	1016	31.50	260	W	0.00	f	0.00	dust	2026-05-04 11:00:00+00	2026-05-04 11:07:12.495685+00
e49499d8-2277-4802-93af-d456fe938b9b	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	bb78c448-eb25-4d0f-b764-7d5c466a47be	33.77	33.77	33.77	47	1007	2.52	89	E	7.96	f	0.00	clear sky	2026-05-04 11:00:00+00	2026-05-04 11:07:12.816087+00
3df46923-3898-49b0-b4a9-61d8c5112698	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	bb78c448-eb25-4d0f-b764-7d5c466a47be	35.99	34.94	35.99	30	1006	22.21	50	NE	0.00	f	0.00	clear sky	2026-05-04 11:00:00+00	2026-05-04 11:07:13.136292+00
65613ea2-7347-436d-a952-5840f40337c3	72829d11-3ace-445b-9f4b-5c3c72c3521f	bb78c448-eb25-4d0f-b764-7d5c466a47be	20.18	20.18	20.19	64	1017	9.25	30	NNE	0.00	t	0.00	scattered clouds	2026-05-04 11:00:00+00	2026-05-04 11:07:13.459659+00
b173fb4e-1ef2-4deb-b266-770032b896d6	5bd52475-ffa2-40f6-82e4-3d0491b7e246	bb78c448-eb25-4d0f-b764-7d5c466a47be	27.31	27.31	27.31	20	1017	9.90	195	SSW	10.94	f	0.00	overcast clouds	2026-05-04 11:00:00+00	2026-05-04 11:07:14.212344+00
d2b8a721-8ed7-46d3-a51c-e5b4d87b4c79	467c145d-f635-4cb3-9813-63f4d28b8780	4010fb51-8485-4dcc-a244-69c169143765	22.42	21.90	22.42	35	1016	24.08	300	WNW	0.00	f	0.00	scattered clouds	2026-05-04 12:00:00+00	2026-05-04 12:00:23.429195+00
1f184d4a-479c-4be3-8441-e910a68e94b1	f2df8134-8994-487c-8a25-272606e8f953	4010fb51-8485-4dcc-a244-69c169143765	38.54	38.54	38.54	6	1007	3.92	132	SE	15.37	f	0.00	clear sky	2026-05-04 12:00:00+00	2026-05-04 12:00:23.757354+00
db923ac9-4d27-470f-b545-0b783ed71b0b	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	4010fb51-8485-4dcc-a244-69c169143765	34.96	34.96	35.14	34	1004	22.21	280	W	0.00	f	0.00	clear sky	2026-05-04 12:00:00+00	2026-05-04 12:00:24.074091+00
22dcb816-e0ed-47fe-bfb5-e4e02e0149c8	6411b387-fc37-4b47-878b-8f89fd8e08d9	4010fb51-8485-4dcc-a244-69c169143765	29.95	29.95	29.95	25	1009	24.08	310	NW	0.00	f	0.00	clear sky	2026-05-04 12:00:00+00	2026-05-04 12:00:24.461337+00
62671be8-dccf-4246-a013-41c5f8dafdea	05546df7-881e-438f-96b9-be0148283901	4010fb51-8485-4dcc-a244-69c169143765	14.65	14.65	14.65	64	1013	49.03	220	SW	56.23	t	0.00	overcast clouds	2026-05-04 12:00:00+00	2026-05-04 12:00:24.794963+00
afd49637-54d4-4a3d-b25c-aa21a9a13053	054b54c2-e6d1-4534-a9de-58bf2831479a	4010fb51-8485-4dcc-a244-69c169143765	18.05	17.75	18.05	32	1015	35.17	260	W	0.00	t	0.00	dust	2026-05-04 12:00:00+00	2026-05-04 12:00:25.128035+00
1cd94bab-7f88-4bfc-a8e9-977fa6ed6c18	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	4010fb51-8485-4dcc-a244-69c169143765	32.66	32.66	32.66	51	1006	5.15	97	E	7.42	t	0.00	clear sky	2026-05-04 12:00:00+00	2026-05-04 12:00:25.44025+00
5cc84993-ec68-4f96-9a9d-3238bf8d6999	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	4010fb51-8485-4dcc-a244-69c169143765	35.99	32.94	35.99	34	1005	20.38	30	NNE	0.00	f	0.00	clear sky	2026-05-04 12:00:00+00	2026-05-04 12:00:25.78225+00
2c965d76-2f3f-4428-9747-1008bd598495	72829d11-3ace-445b-9f4b-5c3c72c3521f	4010fb51-8485-4dcc-a244-69c169143765	20.19	20.18	22.12	64	1017	12.96	40	NE	0.00	t	0.00	scattered clouds	2026-05-04 12:00:00+00	2026-05-04 12:00:26.108645+00
fa588d30-8b67-4fec-a6f1-3c24661de302	5bd52475-ffa2-40f6-82e4-3d0491b7e246	4010fb51-8485-4dcc-a244-69c169143765	27.93	27.93	27.93	16	1017	9.58	201	SSW	10.08	f	0.00	overcast clouds	2026-05-04 12:00:00+00	2026-05-04 12:00:26.436544+00
30ed67c2-4880-4948-bd8c-2b5fac482b49	467c145d-f635-4cb3-9813-63f4d28b8780	f7804272-978b-4ed2-9a70-48bc20c9912d	22.42	21.90	22.42	33	1016	22.21	310	NW	42.59	f	0.00	broken clouds	2026-05-04 13:00:00+00	2026-05-04 13:21:38.292606+00
12438a9b-de4c-4cde-b630-f64640f752f9	f2df8134-8994-487c-8a25-272606e8f953	f7804272-978b-4ed2-9a70-48bc20c9912d	38.33	38.33	38.33	7	1006	3.20	152	SSE	14.69	f	0.00	clear sky	2026-05-04 13:00:00+00	2026-05-04 13:21:39.041657+00
28f0d9ae-39a7-4cd8-99c5-68111f5b081b	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	f7804272-978b-4ed2-9a70-48bc20c9912d	32.96	32.96	33.14	40	1004	18.50	290	WNW	0.00	f	0.00	clear sky	2026-05-04 13:00:00+00	2026-05-04 13:21:39.403317+00
0a01030c-d6d5-40b1-98d5-9b80302af31d	6411b387-fc37-4b47-878b-8f89fd8e08d9	f7804272-978b-4ed2-9a70-48bc20c9912d	29.95	29.95	29.95	26	1008	14.83	300	WNW	0.00	f	0.00	clear sky	2026-05-04 13:00:00+00	2026-05-04 13:21:39.754708+00
e0173e43-873c-4496-b5c7-4151fabce5b1	05546df7-881e-438f-96b9-be0148283901	f7804272-978b-4ed2-9a70-48bc20c9912d	14.10	14.10	14.10	65	1013	46.76	228	SW	52.52	t	0.00	overcast clouds	2026-05-04 13:00:00+00	2026-05-04 13:21:40.136621+00
6e86e5f7-ddc5-4d5d-a8e3-0b02b4970dc4	054b54c2-e6d1-4534-a9de-58bf2831479a	f7804272-978b-4ed2-9a70-48bc20c9912d	17.05	17.05	17.75	36	1014	35.17	250	WSW	0.00	f	0.00	dust	2026-05-04 13:00:00+00	2026-05-04 13:39:32.304072+00
35c5b068-102e-4b7e-b060-022adcc0e779	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	f7804272-978b-4ed2-9a70-48bc20c9912d	32.66	32.66	32.66	50	1005	17.86	106	ESE	15.08	t	0.00	clear sky	2026-05-04 13:00:00+00	2026-05-04 13:39:32.651579+00
1cfab387-e214-428f-ab75-b90f0213d9ed	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	f7804272-978b-4ed2-9a70-48bc20c9912d	36.99	36.99	36.99	32	1004	12.96	10	N	0.00	t	0.00	clear sky	2026-05-04 13:00:00+00	2026-05-04 13:39:33.001527+00
f0136486-8460-4194-b41b-18a7dae798d6	72829d11-3ace-445b-9f4b-5c3c72c3521f	f7804272-978b-4ed2-9a70-48bc20c9912d	20.74	20.74	21.19	60	1017	11.12	20	NNE	0.00	t	0.00	scattered clouds	2026-05-04 13:00:00+00	2026-05-04 13:39:33.346023+00
c4b830df-f125-4a22-81e0-56dd0d0662b8	5bd52475-ffa2-40f6-82e4-3d0491b7e246	f7804272-978b-4ed2-9a70-48bc20c9912d	29.28	29.28	29.28	14	1015	7.20	176	S	7.99	f	0.00	broken clouds	2026-05-04 13:00:00+00	2026-05-04 13:39:33.73485+00
17dce7c3-12e6-43f9-bb35-06782a5ef32b	467c145d-f635-4cb3-9813-63f4d28b8780	f08866ec-ef27-4c86-ae63-0c3a6328c0f4	22.42	21.90	22.42	33	1016	22.21	320	NW	0.00	f	0.00	scattered clouds	2026-05-04 14:00:00+00	2026-05-04 14:05:19.325972+00
10999441-0841-4501-955f-b5b5ad49c42f	f2df8134-8994-487c-8a25-272606e8f953	f08866ec-ef27-4c86-ae63-0c3a6328c0f4	38.33	38.33	38.33	7	1006	3.20	152	SSE	14.69	f	0.00	clear sky	2026-05-04 14:00:00+00	2026-05-04 14:05:19.766879+00
9ab1a870-66af-408c-a12f-d0ad111cc3ed	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	f08866ec-ef27-4c86-ae63-0c3a6328c0f4	31.96	31.96	33.14	45	1003	16.67	260	W	0.00	f	0.00	clear sky	2026-05-04 14:00:00+00	2026-05-04 14:05:21.050569+00
cf4c4a21-68ef-44bf-a53f-a486c55876fd	6411b387-fc37-4b47-878b-8f89fd8e08d9	f08866ec-ef27-4c86-ae63-0c3a6328c0f4	29.95	29.95	29.95	26	1008	14.83	300	WNW	0.00	f	0.00	clear sky	2026-05-04 14:00:00+00	2026-05-04 14:05:21.384117+00
6b8d4f8a-b256-403f-ac1c-351482b43632	05546df7-881e-438f-96b9-be0148283901	f08866ec-ef27-4c86-ae63-0c3a6328c0f4	14.10	14.10	14.10	65	1013	42.01	228	SW	47.92	t	0.00	overcast clouds	2026-05-04 14:00:00+00	2026-05-04 14:05:21.705384+00
e07f6e4a-2047-4327-99ec-beb660c0d8c3	054b54c2-e6d1-4534-a9de-58bf2831479a	f08866ec-ef27-4c86-ae63-0c3a6328c0f4	17.05	17.05	17.75	36	1015	35.17	250	WSW	0.00	f	0.00	dust	2026-05-04 14:00:00+00	2026-05-04 14:05:22.202152+00
5923e523-d621-4561-b213-3a7469ce262f	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	f08866ec-ef27-4c86-ae63-0c3a6328c0f4	32.10	32.10	32.10	50	1004	17.86	106	ESE	15.08	t	0.00	clear sky	2026-05-04 14:00:00+00	2026-05-04 14:05:22.617692+00
dac5a507-fc2e-4419-9414-c3f41a8e61f2	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	f08866ec-ef27-4c86-ae63-0c3a6328c0f4	36.99	36.99	36.99	30	1004	12.96	0	N	0.00	t	0.00	clear sky	2026-05-04 14:00:00+00	2026-05-04 14:05:23.110433+00
807cc02f-6729-47b0-a0f0-1b6d97f11d29	72829d11-3ace-445b-9f4b-5c3c72c3521f	f08866ec-ef27-4c86-ae63-0c3a6328c0f4	20.96	20.74	23.12	60	1017	11.12	20	NNE	0.00	t	0.00	scattered clouds	2026-05-04 14:00:00+00	2026-05-04 14:05:23.51874+00
52f8ef33-25b7-468a-99a4-cf056f3fb596	5bd52475-ffa2-40f6-82e4-3d0491b7e246	f08866ec-ef27-4c86-ae63-0c3a6328c0f4	29.28	29.28	29.28	14	1015	7.20	176	S	7.99	f	0.00	broken clouds	2026-05-04 14:00:00+00	2026-05-04 14:05:23.934625+00
16052f45-f453-4f9a-857a-8d356c10f44c	467c145d-f635-4cb3-9813-63f4d28b8780	1c3144d2-3aaf-425b-9982-a4e1fdcdf61b	22.42	21.90	22.42	30	1015	20.38	0	N	0.00	t	0.00	scattered clouds	2026-05-04 15:00:00+00	2026-05-04 15:00:24.732427+00
947abd45-d772-43e6-9f7a-5b100aaf87bb	f2df8134-8994-487c-8a25-272606e8f953	1c3144d2-3aaf-425b-9982-a4e1fdcdf61b	37.38	37.38	37.38	8	1006	3.49	129	SE	6.52	f	0.00	clear sky	2026-05-04 15:00:00+00	2026-05-04 15:00:25.04538+00
36bb2363-dd2c-45d0-8f47-de256da3dba5	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	1c3144d2-3aaf-425b-9982-a4e1fdcdf61b	31.96	31.96	32.14	48	1004	14.83	250	WSW	0.00	f	0.00	clear sky	2026-05-04 15:00:00+00	2026-05-04 15:00:25.37114+00
4f5e39c3-b74c-4f54-aabd-52cd79e62def	6411b387-fc37-4b47-878b-8f89fd8e08d9	1c3144d2-3aaf-425b-9982-a4e1fdcdf61b	29.95	29.95	29.95	26	1009	12.96	310	NW	0.00	f	0.00	clear sky	2026-05-04 15:00:00+00	2026-05-04 15:00:25.692434+00
b038732c-eb65-430e-96b1-854b7b78737f	05546df7-881e-438f-96b9-be0148283901	1c3144d2-3aaf-425b-9982-a4e1fdcdf61b	14.10	14.10	14.10	65	1013	38.77	229	SW	44.53	t	0.00	overcast clouds	2026-05-04 15:00:00+00	2026-05-04 15:00:26.041878+00
36ba3cae-ad91-48c4-b4e8-8f56cc44b673	054b54c2-e6d1-4534-a9de-58bf2831479a	1c3144d2-3aaf-425b-9982-a4e1fdcdf61b	17.05	16.75	17.05	45	1015	33.34	260	W	0.00	f	0.00	dust	2026-05-04 15:00:00+00	2026-05-04 15:00:26.371722+00
50e4f7b1-c9e9-423f-831a-6d5b392219db	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	1c3144d2-3aaf-425b-9982-a4e1fdcdf61b	31.55	31.55	31.55	49	1005	17.68	118	ESE	17.46	t	0.00	clear sky	2026-05-04 15:00:00+00	2026-05-04 15:00:26.698279+00
1dad37a2-15b0-4a47-a80d-7e5bd74708f8	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	1c3144d2-3aaf-425b-9982-a4e1fdcdf61b	35.99	32.94	35.99	32	1005	11.12	0	N	0.00	t	0.00	clear sky	2026-05-04 15:00:00+00	2026-05-04 15:00:27.039223+00
2fa9b9bc-fb9d-4164-b401-f89e02acc547	72829d11-3ace-445b-9f4b-5c3c72c3521f	1c3144d2-3aaf-425b-9982-a4e1fdcdf61b	20.96	20.74	23.12	60	1016	12.96	20	NNE	0.00	t	0.00	scattered clouds	2026-05-04 15:00:00+00	2026-05-04 15:00:28.242755+00
aa041b96-b595-4952-bf41-cec07decceb9	5bd52475-ffa2-40f6-82e4-3d0491b7e246	1c3144d2-3aaf-425b-9982-a4e1fdcdf61b	29.52	29.52	29.52	13	1014	7.09	170	S	7.96	f	0.00	broken clouds	2026-05-04 15:00:00+00	2026-05-04 15:00:28.565129+00
44556ed0-e850-4f63-9204-5637609e9ced	467c145d-f635-4cb3-9813-63f4d28b8780	489989c5-d19e-4df2-a796-21e37f774dc0	22.42	21.90	22.42	28	1016	24.08	320	NW	0.00	f	0.00	few clouds	2026-05-04 16:00:00+00	2026-05-04 16:00:31.316145+00
591c3148-fd81-4da7-a8c7-42808bf79eb3	f2df8134-8994-487c-8a25-272606e8f953	489989c5-d19e-4df2-a796-21e37f774dc0	35.93	35.93	35.93	9	1007	8.42	118	ESE	9.40	f	0.00	clear sky	2026-05-04 16:00:00+00	2026-05-04 16:00:31.852151+00
66c1bc3d-84d2-41ee-a40f-91d27cd45cef	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	489989c5-d19e-4df2-a796-21e37f774dc0	30.96	30.96	31.14	48	1004	12.96	260	W	0.00	f	0.00	clear sky	2026-05-04 16:00:00+00	2026-05-04 16:00:33.173018+00
7b942f50-a5ae-4735-9f5c-fe85b4431ce8	6411b387-fc37-4b47-878b-8f89fd8e08d9	489989c5-d19e-4df2-a796-21e37f774dc0	28.95	28.95	28.95	30	1009	14.83	350	N	0.00	t	0.00	clear sky	2026-05-04 16:00:00+00	2026-05-04 16:00:33.56757+00
0bf327a8-f433-4a21-8d38-d9b597618663	05546df7-881e-438f-96b9-be0148283901	489989c5-d19e-4df2-a796-21e37f774dc0	13.54	13.54	13.54	66	1013	35.46	223	SW	40.10	f	0.00	overcast clouds	2026-05-04 16:00:00+00	2026-05-04 16:00:34.496384+00
f26c105d-7c81-4250-bfa3-26a9b65e16a2	054b54c2-e6d1-4534-a9de-58bf2831479a	489989c5-d19e-4df2-a796-21e37f774dc0	15.05	15.05	15.75	55	1015	27.79	260	W	0.00	f	0.00	dust	2026-05-04 16:00:00+00	2026-05-04 16:00:35.130668+00
625bb598-4634-46fb-bd81-6164bd0619b4	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	489989c5-d19e-4df2-a796-21e37f774dc0	31.55	31.55	31.55	47	1004	17.39	130	SE	18.29	f	0.00	clear sky	2026-05-04 16:00:00+00	2026-05-04 16:00:35.559438+00
404b968a-0281-4016-9db8-1da2c262e33b	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	489989c5-d19e-4df2-a796-21e37f774dc0	33.99	32.94	33.99	40	1005	9.25	30	NNE	0.00	f	0.00	clear sky	2026-05-04 16:00:00+00	2026-05-04 16:00:35.976347+00
630daaad-2985-4feb-a986-819bf82978fc	72829d11-3ace-445b-9f4b-5c3c72c3521f	489989c5-d19e-4df2-a796-21e37f774dc0	20.18	20.18	20.19	64	1016	12.96	30	NNE	0.00	t	0.00	scattered clouds	2026-05-04 16:00:00+00	2026-05-04 16:00:36.644783+00
5ee7eabc-814f-4dd2-9175-238162fb5070	5bd52475-ffa2-40f6-82e4-3d0491b7e246	489989c5-d19e-4df2-a796-21e37f774dc0	29.67	29.67	29.67	13	1014	8.35	156	SSE	9.79	f	0.00	broken clouds	2026-05-04 16:00:00+00	2026-05-04 16:00:38.497798+00
608e8888-040f-4b1c-8141-21b2c3fe339f	467c145d-f635-4cb3-9813-63f4d28b8780	721b909e-93bd-4af9-8cc4-e08681260ba2	20.42	20.23	20.42	34	1017	27.79	310	NW	0.00	f	0.00	clear sky	2026-05-04 17:00:00+00	2026-05-04 17:00:17.124028+00
a5bc3797-9197-4353-93ba-1bf465f5f41c	f2df8134-8994-487c-8a25-272606e8f953	721b909e-93bd-4af9-8cc4-e08681260ba2	35.28	35.28	35.28	9	1007	15.01	136	SE	17.78	f	0.00	clear sky	2026-05-04 17:00:00+00	2026-05-04 17:00:17.541534+00
619c2af8-0a8d-410c-a1ec-2a14214a2d19	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	721b909e-93bd-4af9-8cc4-e08681260ba2	30.96	30.96	31.14	51	1005	11.12	250	WSW	0.00	f	0.00	clear sky	2026-05-04 17:00:00+00	2026-05-04 17:00:17.924511+00
4f1186bd-7d8e-4d50-8323-0c4337334fde	6411b387-fc37-4b47-878b-8f89fd8e08d9	721b909e-93bd-4af9-8cc4-e08681260ba2	26.95	26.95	26.95	32	1009	14.83	340	NNW	0.00	t	0.00	clear sky	2026-05-04 17:00:00+00	2026-05-04 17:00:18.568099+00
45ff0a5b-3175-4075-96d7-f7f71f8bc2f6	05546df7-881e-438f-96b9-be0148283901	721b909e-93bd-4af9-8cc4-e08681260ba2	14.10	14.10	14.10	68	1014	33.52	217	SW	38.20	f	0.00	overcast clouds	2026-05-04 17:00:00+00	2026-05-04 17:00:18.925169+00
ee4698f4-44ae-41ad-8b80-268c73f151ab	054b54c2-e6d1-4534-a9de-58bf2831479a	721b909e-93bd-4af9-8cc4-e08681260ba2	14.05	13.75	14.05	54	1015	27.79	260	W	0.00	f	0.00	dust	2026-05-04 17:00:00+00	2026-05-04 17:00:19.303567+00
d81dd108-922d-43ef-b2e9-52f2b2a0c90f	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	721b909e-93bd-4af9-8cc4-e08681260ba2	31.55	31.55	31.55	45	1005	17.53	141	SE	20.12	f	0.00	clear sky	2026-05-04 17:00:00+00	2026-05-04 17:00:19.664808+00
b458be06-a4b6-4722-b6d0-25d763c5565d	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	721b909e-93bd-4af9-8cc4-e08681260ba2	33.57	32.94	36.17	38	1006	11.12	350	N	0.00	t	0.00	clear sky	2026-05-04 17:00:00+00	2026-05-04 17:00:20.03448+00
61f3d522-118f-4c6e-a63c-e7cda6aeafaa	72829d11-3ace-445b-9f4b-5c3c72c3521f	721b909e-93bd-4af9-8cc4-e08681260ba2	20.19	20.18	22.12	60	1016	12.96	10	N	0.00	t	0.00	scattered clouds	2026-05-04 17:00:00+00	2026-05-04 17:00:20.797297+00
bafb3b5f-6f8c-44d0-93f8-f41b8a97bf19	5bd52475-ffa2-40f6-82e4-3d0491b7e246	721b909e-93bd-4af9-8cc4-e08681260ba2	29.57	29.57	29.57	12	1014	9.25	155	SSE	11.63	f	0.00	broken clouds	2026-05-04 17:00:00+00	2026-05-04 17:00:21.175995+00
5548bf32-c806-45b8-abb8-e7831f021c6c	467c145d-f635-4cb3-9813-63f4d28b8780	0166f3b7-b108-4c2f-afa1-42558146f84d	19.42	19.12	19.42	39	1017	27.79	330	NNW	0.00	t	0.00	clear sky	2026-05-04 18:00:00+00	2026-05-04 18:00:21.833776+00
e667d380-a42f-4f44-afdd-d1bc3141fbfd	f2df8134-8994-487c-8a25-272606e8f953	0166f3b7-b108-4c2f-afa1-42558146f84d	34.00	34.00	34.00	9	1008	15.05	152	SSE	19.22	f	0.00	clear sky	2026-05-04 18:00:00+00	2026-05-04 18:00:22.199431+00
ff71ab52-caad-4224-8702-0714d1f4fc69	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	0166f3b7-b108-4c2f-afa1-42558146f84d	29.96	29.96	31.14	51	1005	7.42	220	SW	0.00	t	0.00	clear sky	2026-05-04 18:00:00+00	2026-05-04 18:00:22.583955+00
42d94a6b-be89-4363-b0e8-12cacebc1a61	6411b387-fc37-4b47-878b-8f89fd8e08d9	0166f3b7-b108-4c2f-afa1-42558146f84d	25.95	25.95	25.95	31	1009	12.96	340	NNW	0.00	t	0.00	clear sky	2026-05-04 18:00:00+00	2026-05-04 18:00:22.952927+00
469200f4-984e-479c-8248-aa9b112646c8	05546df7-881e-438f-96b9-be0148283901	0166f3b7-b108-4c2f-afa1-42558146f84d	13.54	13.54	13.54	66	1014	33.80	216	SW	38.88	f	0.00	broken clouds	2026-05-04 18:00:00+00	2026-05-04 18:00:23.315+00
7193d38e-7509-4200-83a5-3df6c406460f	054b54c2-e6d1-4534-a9de-58bf2831479a	0166f3b7-b108-4c2f-afa1-42558146f84d	13.05	12.75	13.05	58	1016	24.08	270	W	0.00	f	0.00	haze	2026-05-04 18:00:00+00	2026-05-04 18:00:23.682931+00
b31e5d75-8333-4745-b190-1fabad104dc3	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	0166f3b7-b108-4c2f-afa1-42558146f84d	31.55	31.55	31.55	44	1005	17.82	157	SSE	21.67	f	0.00	clear sky	2026-05-04 18:00:00+00	2026-05-04 18:00:24.03476+00
5b70304f-792d-4df1-8927-75342bf33411	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	0166f3b7-b108-4c2f-afa1-42558146f84d	33.76	31.94	34.99	22	1006	18.50	330	NNW	0.00	f	0.00	clear sky	2026-05-04 18:00:00+00	2026-05-04 18:00:24.387233+00
b0f3b335-37e8-425c-a26d-5897cd51bf6b	72829d11-3ace-445b-9f4b-5c3c72c3521f	0166f3b7-b108-4c2f-afa1-42558146f84d	20.19	20.12	20.19	64	1016	11.12	50	NE	0.00	t	0.00	scattered clouds	2026-05-04 18:00:00+00	2026-05-04 18:00:24.753692+00
36e9a132-10ac-4b8d-aab6-6ec9f7f8a0f9	5bd52475-ffa2-40f6-82e4-3d0491b7e246	0166f3b7-b108-4c2f-afa1-42558146f84d	29.31	29.31	29.31	13	1014	7.81	140	SE	9.79	f	0.00	overcast clouds	2026-05-04 18:00:00+00	2026-05-04 18:00:25.108858+00
83ee9460-304e-4dd9-8615-1348d3e5299a	467c145d-f635-4cb3-9813-63f4d28b8780	3730c242-6153-4b55-ab6e-2821dae46254	19.42	19.12	19.42	39	1018	24.08	320	NW	0.00	f	0.00	clear sky	2026-05-04 19:00:00+00	2026-05-04 19:00:25.763346+00
7e54e84e-bf64-4dd7-a63a-badf91562446	f2df8134-8994-487c-8a25-272606e8f953	3730c242-6153-4b55-ab6e-2821dae46254	33.07	33.07	33.07	10	1007	11.41	158	SSE	13.43	f	0.00	scattered clouds	2026-05-04 19:00:00+00	2026-05-04 19:00:26.068657+00
27f42d08-c2d9-49e2-8bf8-83c1d7eb6aef	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	3730c242-6153-4b55-ab6e-2821dae46254	29.96	27.14	29.96	51	1005	5.54	200	SSW	0.00	t	0.00	clear sky	2026-05-04 19:00:00+00	2026-05-04 19:00:26.359766+00
fbc9df91-5cfb-4ae0-8366-9fe678b02390	6411b387-fc37-4b47-878b-8f89fd8e08d9	3730c242-6153-4b55-ab6e-2821dae46254	24.95	24.95	24.95	31	1009	11.12	10	N	0.00	t	0.00	clear sky	2026-05-04 19:00:00+00	2026-05-04 19:00:26.65717+00
db9e41c4-364a-4e35-a04d-9020796c91ff	05546df7-881e-438f-96b9-be0148283901	3730c242-6153-4b55-ab6e-2821dae46254	12.99	12.99	12.99	63	1014	36.90	215	SW	40.86	f	0.00	broken clouds	2026-05-04 19:00:00+00	2026-05-04 19:00:26.947657+00
509ce30d-7df8-4d63-97bc-04ed22c855ed	054b54c2-e6d1-4534-a9de-58bf2831479a	3730c242-6153-4b55-ab6e-2821dae46254	12.05	11.75	12.05	58	1016	24.08	270	W	0.00	f	0.00	haze	2026-05-04 19:00:00+00	2026-05-04 19:00:27.24611+00
1db22f39-5bee-4875-8fcd-1a00843f6378	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	3730c242-6153-4b55-ab6e-2821dae46254	32.66	32.66	32.66	34	1005	16.02	163	SSE	20.95	f	0.00	clear sky	2026-05-04 19:00:00+00	2026-05-04 19:00:27.561528+00
c6566cd8-39ce-4817-ae6a-6fb70eb6c1c3	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	3730c242-6153-4b55-ab6e-2821dae46254	33.16	31.94	33.99	24	1006	14.83	310	NW	0.00	f	0.00	clear sky	2026-05-04 19:00:00+00	2026-05-04 19:00:27.888678+00
34f083ff-f82a-46dd-b039-aaa1c673d446	72829d11-3ace-445b-9f4b-5c3c72c3521f	3730c242-6153-4b55-ab6e-2821dae46254	19.13	19.07	19.19	68	1017	12.96	40	NE	0.00	t	0.00	scattered clouds	2026-05-04 19:00:00+00	2026-05-04 19:00:28.180132+00
16367278-37e7-4519-8abb-38ad6f0a81eb	5bd52475-ffa2-40f6-82e4-3d0491b7e246	3730c242-6153-4b55-ab6e-2821dae46254	27.08	27.08	27.08	19	1015	20.38	105	ESE	26.82	f	0.00	overcast clouds	2026-05-04 19:00:00+00	2026-05-04 19:00:28.478803+00
701b328c-d058-478c-abff-957d6a82767b	467c145d-f635-4cb3-9813-63f4d28b8780	9ef67250-9faa-40af-8c46-dc636c0cd19f	17.42	16.90	17.42	48	1018	25.92	320	NW	0.00	f	0.00	clear sky	2026-05-04 20:00:00+00	2026-05-04 20:00:29.366865+00
056f0d65-8aad-412a-bcaf-d21b90a55f78	f2df8134-8994-487c-8a25-272606e8f953	9ef67250-9faa-40af-8c46-dc636c0cd19f	32.92	32.92	32.92	10	1007	13.43	166	SSE	13.79	f	0.00	broken clouds	2026-05-04 20:00:00+00	2026-05-04 20:00:30.153403+00
c0c73e0f-ab2d-4e05-929c-6a8c1746ec16	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	9ef67250-9faa-40af-8c46-dc636c0cd19f	29.96	29.96	30.14	51	1005	7.42	0	N	0.00	t	0.00	clear sky	2026-05-04 20:00:00+00	2026-05-04 20:00:30.528953+00
5084dd73-de1e-450d-ba41-42c5d63053ba	6411b387-fc37-4b47-878b-8f89fd8e08d9	9ef67250-9faa-40af-8c46-dc636c0cd19f	24.95	24.95	24.95	31	1009	11.12	0	N	0.00	t	0.00	clear sky	2026-05-04 20:00:00+00	2026-05-04 20:00:30.882891+00
5d541daf-870c-4dad-8905-2904047c619a	05546df7-881e-438f-96b9-be0148283901	9ef67250-9faa-40af-8c46-dc636c0cd19f	12.99	12.99	12.99	66	1014	39.10	211	SSW	42.34	f	0.00	scattered clouds	2026-05-04 20:00:00+00	2026-05-04 20:00:31.26031+00
5a82ab08-0d20-4675-9e38-4bd86a3ee27f	054b54c2-e6d1-4534-a9de-58bf2831479a	9ef67250-9faa-40af-8c46-dc636c0cd19f	12.05	11.75	12.05	62	1016	20.38	250	WSW	0.00	f	0.00	haze	2026-05-04 20:00:00+00	2026-05-04 20:00:31.61391+00
c1e6d89f-4fcd-4c36-8a53-119919880f37	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	9ef67250-9faa-40af-8c46-dc636c0cd19f	32.10	32.10	32.10	39	1005	12.17	166	SSE	17.42	f	0.00	clear sky	2026-05-04 20:00:00+00	2026-05-04 20:00:31.980239+00
c75c3b38-0680-437e-a233-798ed27c3d46	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	9ef67250-9faa-40af-8c46-dc636c0cd19f	32.16	30.94	32.99	23	1006	9.25	300	WNW	0.00	f	0.00	clear sky	2026-05-04 20:00:00+00	2026-05-04 20:00:32.35155+00
8110aae3-b8f6-4f8d-9ce1-f6d917bc70f7	72829d11-3ace-445b-9f4b-5c3c72c3521f	9ef67250-9faa-40af-8c46-dc636c0cd19f	19.07	18.12	19.07	68	1018	12.89	40	NE	0.00	t	0.00	broken clouds	2026-05-04 20:00:00+00	2026-05-04 20:00:32.750164+00
afac80ad-8ec5-4782-95ee-4b547ee70990	5bd52475-ffa2-40f6-82e4-3d0491b7e246	9ef67250-9faa-40af-8c46-dc636c0cd19f	24.98	24.98	24.98	25	1016	22.39	79	E	31.79	f	0.00	overcast clouds	2026-05-04 20:00:00+00	2026-05-04 20:00:33.11165+00
b88f304e-99e4-4788-8e5e-37816967e42e	467c145d-f635-4cb3-9813-63f4d28b8780	c3398661-2227-4481-8b19-0e438c598a46	17.42	16.90	17.42	51	1018	24.08	320	NW	0.00	f	0.00	clear sky	2026-05-04 21:00:00+00	2026-05-04 21:00:33.887329+00
c3cd160e-57e1-45c2-9107-b5c377b64087	f2df8134-8994-487c-8a25-272606e8f953	c3398661-2227-4481-8b19-0e438c598a46	30.18	30.18	30.18	10	1008	15.01	147	SSE	20.30	f	0.00	broken clouds	2026-05-04 21:00:00+00	2026-05-04 21:00:34.293062+00
168ef573-9a08-434d-b442-aa6d2cbd229f	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	c3398661-2227-4481-8b19-0e438c598a46	29.96	29.14	29.96	51	1004	7.42	190	S	0.00	t	0.00	clear sky	2026-05-04 21:00:00+00	2026-05-04 21:00:34.659327+00
b30dba6b-2d1d-43c2-b82c-6be482af894a	6411b387-fc37-4b47-878b-8f89fd8e08d9	c3398661-2227-4481-8b19-0e438c598a46	22.95	22.95	22.95	31	1009	18.50	350	N	0.00	t	0.00	clear sky	2026-05-04 21:00:00+00	2026-05-04 21:00:35.054479+00
8fe70143-5056-4de2-9cc1-12f230f15413	05546df7-881e-438f-96b9-be0148283901	c3398661-2227-4481-8b19-0e438c598a46	12.99	12.99	12.99	67	1013	38.30	213	SSW	43.13	f	0.00	scattered clouds	2026-05-04 21:00:00+00	2026-05-04 21:00:35.452796+00
844d163d-f7a0-4773-b2ff-bcc2b26f517f	054b54c2-e6d1-4534-a9de-58bf2831479a	c3398661-2227-4481-8b19-0e438c598a46	11.05	11.05	11.75	58	1016	24.08	270	W	0.00	f	0.00	broken clouds	2026-05-04 21:00:00+00	2026-05-04 21:00:36.995173+00
5488480c-97b3-4616-bf07-6e8c801e9b01	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	c3398661-2227-4481-8b19-0e438c598a46	29.88	29.88	29.88	50	1005	5.98	238	WSW	12.20	t	0.00	clear sky	2026-05-04 21:00:00+00	2026-05-04 21:00:43.722843+00
b3543f3d-8730-4235-9cf4-0f373994c87f	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	c3398661-2227-4481-8b19-0e438c598a46	32.16	30.17	32.99	22	1006	11.12	300	WNW	0.00	f	0.00	clear sky	2026-05-04 21:00:00+00	2026-05-04 21:00:50.170416+00
56eafd38-c98f-4bc8-923f-4f981882b08c	72829d11-3ace-445b-9f4b-5c3c72c3521f	c3398661-2227-4481-8b19-0e438c598a46	18.07	17.12	18.19	67	1018	11.12	50	NE	0.00	t	0.00	broken clouds	2026-05-04 21:00:00+00	2026-05-04 21:00:54.878598+00
ee8a4187-d537-4156-9e35-dfbe45d17977	5bd52475-ffa2-40f6-82e4-3d0491b7e246	c3398661-2227-4481-8b19-0e438c598a46	24.23	24.23	24.23	29	1016	23.22	70	ENE	33.77	f	0.00	overcast clouds	2026-05-04 21:00:00+00	2026-05-04 21:01:01.160938+00
c58d397b-d0f9-4092-83b4-7d6a711851d9	467c145d-f635-4cb3-9813-63f4d28b8780	7f1dea62-fb00-4a0d-b38f-e0768676a75b	16.42	15.79	16.42	55	1018	18.50	320	NW	0.00	f	0.00	clear sky	2026-05-04 22:00:00+00	2026-05-04 22:00:02.025944+00
ea3d423c-e830-41cf-82a7-33887aa263cb	f2df8134-8994-487c-8a25-272606e8f953	7f1dea62-fb00-4a0d-b38f-e0768676a75b	29.04	29.04	29.04	11	1007	20.12	153	SSE	34.96	t	0.00	broken clouds	2026-05-04 22:00:00+00	2026-05-04 22:00:02.369423+00
d8d38850-4797-43b0-b562-333088eda9d8	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	7f1dea62-fb00-4a0d-b38f-e0768676a75b	27.96	27.96	28.14	57	1004	11.12	190	S	0.00	t	0.00	clear sky	2026-05-04 22:00:00+00	2026-05-04 22:00:02.731383+00
730339ba-f3e4-47cf-8d65-62ed0f0123fa	6411b387-fc37-4b47-878b-8f89fd8e08d9	7f1dea62-fb00-4a0d-b38f-e0768676a75b	22.95	22.95	22.95	31	1009	11.12	0	N	0.00	t	0.00	clear sky	2026-05-04 22:00:00+00	2026-05-04 22:00:03.104646+00
7a7b8329-2b3a-4f31-a9e2-d14807bb5491	05546df7-881e-438f-96b9-be0148283901	7f1dea62-fb00-4a0d-b38f-e0768676a75b	13.54	13.54	13.54	69	1013	37.30	213	SSW	41.65	f	0.00	scattered clouds	2026-05-04 22:00:00+00	2026-05-04 22:00:03.465121+00
8d485a26-b604-45f7-bd11-f79aaa0939a8	054b54c2-e6d1-4534-a9de-58bf2831479a	7f1dea62-fb00-4a0d-b38f-e0768676a75b	11.05	10.75	11.05	66	1016	20.38	260	W	0.00	f	0.00	broken clouds	2026-05-04 22:00:00+00	2026-05-04 22:00:03.825463+00
18bc5a82-d703-4e74-a615-0081979809ac	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	7f1dea62-fb00-4a0d-b38f-e0768676a75b	31.55	31.55	31.55	34	1006	19.15	308	NW	27.65	f	0.00	clear sky	2026-05-04 22:00:00+00	2026-05-04 22:00:04.172561+00
13735db0-6300-4b0a-91f8-3bfd5c9b18bd	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	7f1dea62-fb00-4a0d-b38f-e0768676a75b	32.99	30.94	32.99	24	1005	12.96	330	NNW	0.00	f	0.00	clear sky	2026-05-04 22:00:00+00	2026-05-04 22:00:04.531752+00
e94e718b-3ad5-4d4c-818e-e8b2396d3cdc	72829d11-3ace-445b-9f4b-5c3c72c3521f	7f1dea62-fb00-4a0d-b38f-e0768676a75b	18.07	17.12	18.19	67	1018	9.25	50	NE	0.00	t	0.00	broken clouds	2026-05-04 22:00:00+00	2026-05-04 22:00:04.890398+00
9fa0551c-b2c4-4323-ab9c-38140169739d	5bd52475-ffa2-40f6-82e4-3d0491b7e246	7f1dea62-fb00-4a0d-b38f-e0768676a75b	23.35	23.35	23.35	34	1016	25.02	64	ENE	35.89	f	0.00	overcast clouds	2026-05-04 22:00:00+00	2026-05-04 22:00:05.249507+00
0a31fa18-f9b5-4f9b-999a-264b57470bb9	467c145d-f635-4cb3-9813-63f4d28b8780	2997f0b2-99a5-430f-980c-a7a5a0962b28	16.42	15.79	16.42	59	1018	11.12	330	NNW	0.00	f	0.00	clear sky	2026-05-04 23:00:00+00	2026-05-04 23:00:06.07173+00
cc72c723-ef0e-4d1f-84be-6f4a362797ae	f2df8134-8994-487c-8a25-272606e8f953	2997f0b2-99a5-430f-980c-a7a5a0962b28	28.46	28.46	28.46	11	1007	18.94	149	SSE	31.03	f	0.00	scattered clouds	2026-05-04 23:00:00+00	2026-05-04 23:00:06.471229+00
5737c173-a06d-4e18-89ca-99d6826042a5	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	2997f0b2-99a5-430f-980c-a7a5a0962b28	27.96	27.14	27.96	57	1004	11.12	190	S	0.00	t	0.00	clear sky	2026-05-04 23:00:00+00	2026-05-04 23:00:06.850573+00
a4151504-6cbc-4137-9f9c-750ae085ca06	6411b387-fc37-4b47-878b-8f89fd8e08d9	2997f0b2-99a5-430f-980c-a7a5a0962b28	21.95	21.95	21.95	33	1009	16.67	350	N	0.00	t	0.00	clear sky	2026-05-04 23:00:00+00	2026-05-04 23:00:07.524358+00
54f71ab5-4024-45e2-9f18-97793d5e8ca8	05546df7-881e-438f-96b9-be0148283901	2997f0b2-99a5-430f-980c-a7a5a0962b28	12.99	12.99	12.99	69	1013	38.20	215	SW	41.72	f	0.00	broken clouds	2026-05-04 23:00:00+00	2026-05-04 23:00:08.214754+00
a557e7e0-4161-4125-9326-6e75f8e47a78	054b54c2-e6d1-4534-a9de-58bf2831479a	2997f0b2-99a5-430f-980c-a7a5a0962b28	11.05	9.75	11.05	66	1016	18.50	250	WSW	0.00	f	0.00	haze	2026-05-04 23:00:00+00	2026-05-04 23:00:08.89299+00
482611c2-9c15-4a53-bfa8-8ea057366e36	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	2997f0b2-99a5-430f-980c-a7a5a0962b28	32.10	32.10	32.10	37	1005	21.53	350	N	32.65	t	0.00	clear sky	2026-05-04 23:00:00+00	2026-05-04 23:00:09.219846+00
4a1b1118-b748-4e7b-8544-907e7eed59df	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	2997f0b2-99a5-430f-980c-a7a5a0962b28	27.94	27.94	28.17	39	1005	14.83	330	NNW	0.00	t	0.00	clear sky	2026-05-04 23:00:00+00	2026-05-04 23:00:09.543974+00
1c57f9db-cde5-4563-9a76-7178049d1e19	72829d11-3ace-445b-9f4b-5c3c72c3521f	2997f0b2-99a5-430f-980c-a7a5a0962b28	17.02	16.12	17.19	72	1018	5.54	60	ENE	0.00	f	0.00	broken clouds	2026-05-04 23:00:00+00	2026-05-04 23:00:09.947714+00
d0c49507-1894-48d3-ae3a-152504132999	5bd52475-ffa2-40f6-82e4-3d0491b7e246	2997f0b2-99a5-430f-980c-a7a5a0962b28	21.99	21.99	21.99	37	1016	23.72	62	ENE	33.48	f	0.00	broken clouds	2026-05-04 23:00:00+00	2026-05-04 23:00:10.338597+00
baceb329-ad76-4d94-a708-7f89b2dd6ff1	467c145d-f635-4cb3-9813-63f4d28b8780	962ab9f2-0674-464a-a523-2679e4be87a7	16.42	15.79	16.42	55	1018	11.12	330	NNW	0.00	f	0.00	clear sky	2026-05-05 00:00:00+00	2026-05-05 00:00:31.509398+00
65ef02e0-3933-4f5d-b3ae-ad27bfd613bd	f2df8134-8994-487c-8a25-272606e8f953	962ab9f2-0674-464a-a523-2679e4be87a7	27.03	27.03	27.03	12	1006	19.58	143	SE	32.83	f	0.00	scattered clouds	2026-05-05 00:00:00+00	2026-05-05 00:00:31.802443+00
38f623af-46d6-4c9f-8ead-651ac225431e	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	962ab9f2-0674-464a-a523-2679e4be87a7	26.96	26.14	26.96	61	1004	9.25	200	SSW	0.00	t	0.00	clear sky	2026-05-05 00:00:00+00	2026-05-05 00:00:32.094632+00
f28b7a30-d027-4d5b-bb88-b8d186ba4dc4	6411b387-fc37-4b47-878b-8f89fd8e08d9	962ab9f2-0674-464a-a523-2679e4be87a7	20.95	20.95	20.95	35	1008	16.67	350	N	0.00	t	0.00	clear sky	2026-05-05 00:00:00+00	2026-05-05 00:00:32.389673+00
b8f71128-fd01-4877-b65d-9c4e2be169a3	05546df7-881e-438f-96b9-be0148283901	962ab9f2-0674-464a-a523-2679e4be87a7	12.99	12.99	12.99	68	1012	37.08	214	SW	40.93	f	0.00	broken clouds	2026-05-05 00:00:00+00	2026-05-05 00:00:32.702475+00
0b8ade29-5718-45d3-beb9-fb800353fb81	054b54c2-e6d1-4534-a9de-58bf2831479a	962ab9f2-0674-464a-a523-2679e4be87a7	10.05	9.75	10.05	71	1015	20.38	250	WSW	0.00	f	0.00	broken clouds	2026-05-05 00:00:00+00	2026-05-05 00:00:33.000364+00
c25ca792-a362-4511-b102-410db01edf06	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	962ab9f2-0674-464a-a523-2679e4be87a7	30.99	30.99	30.99	42	1005	17.82	15	NNE	24.52	f	0.00	clear sky	2026-05-05 00:00:00+00	2026-05-05 00:00:33.318848+00
0483967d-5495-4feb-ba81-e1b827149da6	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	962ab9f2-0674-464a-a523-2679e4be87a7	31.99	30.94	31.99	25	1004	14.83	320	NW	0.00	f	0.00	clear sky	2026-05-05 00:00:00+00	2026-05-05 00:00:33.689572+00
5413de2e-87fb-447d-aadb-7d32653d8833	72829d11-3ace-445b-9f4b-5c3c72c3521f	962ab9f2-0674-464a-a523-2679e4be87a7	17.02	16.12	17.19	63	1017	9.25	50	NE	0.00	t	0.00	broken clouds	2026-05-05 00:00:00+00	2026-05-05 00:00:33.99014+00
1a480a3a-1a5b-4fb6-9a10-d1c690bdc5d4	5bd52475-ffa2-40f6-82e4-3d0491b7e246	962ab9f2-0674-464a-a523-2679e4be87a7	20.99	20.99	20.99	41	1015	21.82	63	ENE	31.79	f	0.00	broken clouds	2026-05-05 00:00:00+00	2026-05-05 00:00:34.305091+00
382e171c-f93c-4fef-a26e-4fc7537e5fe7	467c145d-f635-4cb3-9813-63f4d28b8780	bad3bc0b-9d34-4610-900b-1122a0320965	16.42	15.79	16.42	48	1017	9.25	300	WNW	0.00	f	0.00	clear sky	2026-05-05 01:00:00+00	2026-05-05 01:00:35.143514+00
437240b2-0af5-42c6-9e7e-e203ae0ac457	f2df8134-8994-487c-8a25-272606e8f953	bad3bc0b-9d34-4610-900b-1122a0320965	26.73	26.73	26.73	13	1007	16.06	153	SSE	27.76	f	0.00	few clouds	2026-05-05 01:00:00+00	2026-05-05 01:00:35.436579+00
c47a28c3-bed3-45f2-b04b-c91864ff0f15	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	bad3bc0b-9d34-4610-900b-1122a0320965	25.96	25.96	26.14	61	1004	9.25	180	S	0.00	t	0.00	clear sky	2026-05-05 01:00:00+00	2026-05-05 01:00:35.730395+00
f917421c-cea3-4f1f-b58b-5c88fce2dd59	6411b387-fc37-4b47-878b-8f89fd8e08d9	bad3bc0b-9d34-4610-900b-1122a0320965	20.95	20.95	20.95	35	1009	14.83	330	NNW	0.00	t	0.00	broken clouds	2026-05-05 01:00:00+00	2026-05-05 01:00:36.049264+00
796ffa13-0fe1-4ef0-9135-b309281eb241	05546df7-881e-438f-96b9-be0148283901	bad3bc0b-9d34-4610-900b-1122a0320965	12.99	12.99	12.99	68	1012	36.61	215	SW	39.96	f	0.00	scattered clouds	2026-05-05 01:00:00+00	2026-05-05 01:00:36.362957+00
dca09f0c-1c6f-4761-b7dc-88ad0a1a6216	054b54c2-e6d1-4534-a9de-58bf2831479a	bad3bc0b-9d34-4610-900b-1122a0320965	10.05	10.05	10.75	71	1015	20.38	240	WSW	0.00	f	0.00	haze	2026-05-05 01:00:00+00	2026-05-05 01:00:36.687651+00
e88183a2-ce55-41ab-8023-71066c2f4a2b	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	bad3bc0b-9d34-4610-900b-1122a0320965	30.44	30.44	30.44	45	1006	14.00	4	N	20.09	t	0.00	clear sky	2026-05-05 01:00:00+00	2026-05-05 01:00:37.008623+00
4b2bc5db-30ca-44b4-91b3-f75d746e0d74	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	bad3bc0b-9d34-4610-900b-1122a0320965	29.16	27.17	29.99	31	1004	12.96	340	NNW	0.00	t	0.00	clear sky	2026-05-05 01:00:00+00	2026-05-05 01:00:37.330296+00
b297cb98-0837-4d66-b022-b1a46fd9207f	72829d11-3ace-445b-9f4b-5c3c72c3521f	bad3bc0b-9d34-4610-900b-1122a0320965	17.02	15.12	17.19	63	1017	9.25	70	ENE	0.00	f	0.00	broken clouds	2026-05-05 01:00:00+00	2026-05-05 01:00:37.620021+00
8ae17708-b167-4ec4-a876-13a28b13d7b7	5bd52475-ffa2-40f6-82e4-3d0491b7e246	bad3bc0b-9d34-4610-900b-1122a0320965	20.81	20.81	20.81	44	1015	18.90	59	ENE	29.66	f	0.00	overcast clouds	2026-05-05 01:00:00+00	2026-05-05 01:00:37.938425+00
cae834f0-338a-4c93-a4b7-7e21b146ff06	467c145d-f635-4cb3-9813-63f4d28b8780	2d22d148-d147-410e-8838-60e6190ca591	16.42	15.79	16.42	48	1017	12.96	320	NW	0.00	f	0.00	clear sky	2026-05-05 02:00:00+00	2026-05-05 02:00:38.796651+00
92a28a37-1407-4e75-9053-5f79442bb0f4	f2df8134-8994-487c-8a25-272606e8f953	2d22d148-d147-410e-8838-60e6190ca591	26.00	26.00	26.00	14	1007	14.33	157	SSE	20.41	f	0.00	clear sky	2026-05-05 02:00:00+00	2026-05-05 02:00:39.124279+00
74db2766-90fc-496b-9cf2-d021f8ba91d1	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	2d22d148-d147-410e-8838-60e6190ca591	25.96	25.14	25.96	57	1005	9.25	180	S	0.00	t	0.00	clear sky	2026-05-05 02:00:00+00	2026-05-05 02:00:39.549438+00
7f092891-300b-44cb-9bc6-eaaa08ff9277	6411b387-fc37-4b47-878b-8f89fd8e08d9	2d22d148-d147-410e-8838-60e6190ca591	19.95	19.95	19.95	37	1009	18.50	330	NNW	0.00	t	0.00	broken clouds	2026-05-05 02:00:00+00	2026-05-05 02:00:39.89286+00
57ce99de-67f8-49b5-8cb2-a8a3ccbb84bb	05546df7-881e-438f-96b9-be0148283901	2d22d148-d147-410e-8838-60e6190ca591	12.43	12.43	12.43	70	1012	36.00	218	SW	39.31	f	0.00	broken clouds	2026-05-05 02:00:00+00	2026-05-05 02:00:40.251225+00
dbeb2939-7a2a-4661-a2f4-023f3ca7d96e	054b54c2-e6d1-4534-a9de-58bf2831479a	2d22d148-d147-410e-8838-60e6190ca591	10.05	10.05	10.75	71	1015	18.50	250	WSW	0.00	f	0.00	haze	2026-05-05 02:00:00+00	2026-05-05 02:00:40.602235+00
abb62faa-7b13-4f3f-8879-2ea980c5e219	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	2d22d148-d147-410e-8838-60e6190ca591	29.88	29.88	29.88	45	1006	11.41	350	N	15.70	t	0.00	clear sky	2026-05-05 02:00:00+00	2026-05-05 02:00:40.945778+00
49b70bb2-2c44-4658-9e16-61053c0529f4	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	2d22d148-d147-410e-8838-60e6190ca591	29.16	27.17	29.99	32	1004	5.54	330	NNW	0.00	t	0.00	clear sky	2026-05-05 02:00:00+00	2026-05-05 02:00:41.254047+00
e27cdea5-eca0-41a1-ba3c-55331cac6a4e	72829d11-3ace-445b-9f4b-5c3c72c3521f	2d22d148-d147-410e-8838-60e6190ca591	16.85	16.85	17.19	63	1016	9.25	70	ENE	0.00	t	0.00	broken clouds	2026-05-05 02:00:00+00	2026-05-05 02:00:41.559594+00
1db706a9-921f-4ee4-bdaa-565193ab638d	5bd52475-ffa2-40f6-82e4-3d0491b7e246	2d22d148-d147-410e-8838-60e6190ca591	19.35	19.35	19.35	48	1015	18.65	59	ENE	29.95	t	0.00	overcast clouds	2026-05-05 02:00:00+00	2026-05-05 02:00:41.858763+00
9d292541-4bf5-40f0-851b-ea403d495a48	467c145d-f635-4cb3-9813-63f4d28b8780	cc1e4408-d6a4-48e5-ad24-cf828b430a3f	16.42	15.79	16.42	48	1017	12.96	300	WNW	0.00	f	0.00	clear sky	2026-05-05 03:00:00+00	2026-05-05 03:00:42.668983+00
fbd7895d-a46c-460c-a17b-87b0a37790de	f2df8134-8994-487c-8a25-272606e8f953	cc1e4408-d6a4-48e5-ad24-cf828b430a3f	25.87	25.87	25.87	14	1008	8.89	160	SSE	13.18	t	0.00	clear sky	2026-05-05 03:00:00+00	2026-05-05 03:00:42.992599+00
e5cba657-e2b9-41ae-813a-3b3e235154a4	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	cc1e4408-d6a4-48e5-ad24-cf828b430a3f	25.96	25.14	25.96	61	1005	11.12	190	S	0.00	t	0.00	clear sky	2026-05-05 03:00:00+00	2026-05-05 03:00:43.284592+00
f9cd0057-53e1-4171-aaf3-c16fcadad102	6411b387-fc37-4b47-878b-8f89fd8e08d9	cc1e4408-d6a4-48e5-ad24-cf828b430a3f	19.95	19.95	19.95	45	1009	20.38	320	NW	0.00	t	0.00	few clouds	2026-05-05 03:00:00+00	2026-05-05 03:00:43.579665+00
2ddc69df-7da9-40bf-a208-7f697db1e360	05546df7-881e-438f-96b9-be0148283901	cc1e4408-d6a4-48e5-ad24-cf828b430a3f	13.54	13.54	13.54	72	1012	35.42	218	SW	38.95	f	0.00	broken clouds	2026-05-05 03:00:00+00	2026-05-05 03:00:43.879878+00
d388422a-4028-4e9f-af39-a54184854c6a	054b54c2-e6d1-4534-a9de-58bf2831479a	cc1e4408-d6a4-48e5-ad24-cf828b430a3f	10.05	10.05	10.75	71	1015	18.50	250	WSW	0.00	f	0.00	haze	2026-05-05 03:00:00+00	2026-05-05 03:00:44.182098+00
10c87a04-6cf8-4182-b4bd-d8b55bb90b5c	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	cc1e4408-d6a4-48e5-ad24-cf828b430a3f	29.32	29.32	29.32	46	1006	8.32	15	NNE	11.20	t	0.00	clear sky	2026-05-05 03:00:00+00	2026-05-05 03:00:44.481422+00
55d61d48-f693-4ff1-8768-6032b2695046	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	cc1e4408-d6a4-48e5-ad24-cf828b430a3f	26.94	26.94	27.17	34	1005	7.42	270	W	0.00	f	0.00	clear sky	2026-05-05 03:00:00+00	2026-05-05 03:00:44.780005+00
ddcd57fc-bbe3-4b12-a79d-a251fc73ac4e	72829d11-3ace-445b-9f4b-5c3c72c3521f	cc1e4408-d6a4-48e5-ad24-cf828b430a3f	16.19	14.12	16.19	63	1016	7.42	80	E	0.00	t	0.00	broken clouds	2026-05-05 03:00:00+00	2026-05-05 03:00:45.079373+00
1a28fc00-6691-4d54-885d-b309bc26dcea	5bd52475-ffa2-40f6-82e4-3d0491b7e246	cc1e4408-d6a4-48e5-ad24-cf828b430a3f	18.02	18.02	18.02	52	1014	18.86	61	ENE	31.36	t	0.00	overcast clouds	2026-05-05 03:00:00+00	2026-05-05 03:00:45.382021+00
aa52bd9d-bedd-49d2-888b-f275f051b1f8	467c145d-f635-4cb3-9813-63f4d28b8780	8bc5742b-ceb1-4ee7-95fc-4ac203f5c4de	16.42	15.79	16.42	51	1017	12.96	290	WNW	0.00	f	0.00	scattered clouds	2026-05-05 04:00:00+00	2026-05-05 04:00:46.20953+00
297cff36-d409-41e7-8324-5b63df2c359f	f2df8134-8994-487c-8a25-272606e8f953	8bc5742b-ceb1-4ee7-95fc-4ac203f5c4de	29.08	29.08	29.08	12	1009	14.65	175	S	33.55	t	0.00	clear sky	2026-05-05 04:00:00+00	2026-05-05 04:00:46.494205+00
bdaa328f-b752-43b1-9575-96c5c1bd31d7	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	8bc5742b-ceb1-4ee7-95fc-4ac203f5c4de	26.96	26.96	27.14	57	1006	9.25	160	SSE	0.00	t	0.00	clear sky	2026-05-05 04:00:00+00	2026-05-05 04:00:46.789575+00
0ad4e7da-174f-4c14-91ee-f1f0332f4a92	6411b387-fc37-4b47-878b-8f89fd8e08d9	8bc5742b-ceb1-4ee7-95fc-4ac203f5c4de	19.95	19.95	19.95	45	1009	24.08	320	NW	0.00	t	0.00	clear sky	2026-05-05 04:00:00+00	2026-05-05 04:00:47.064919+00
4fc904b6-a978-49d0-8ff4-cdc41f97106a	05546df7-881e-438f-96b9-be0148283901	8bc5742b-ceb1-4ee7-95fc-4ac203f5c4de	12.99	12.99	12.99	72	1013	33.80	215	SW	37.62	f	0.00	broken clouds	2026-05-05 04:00:00+00	2026-05-05 04:00:47.345829+00
963181d4-b069-49b2-8b18-b51dc9d26eee	054b54c2-e6d1-4534-a9de-58bf2831479a	8bc5742b-ceb1-4ee7-95fc-4ac203f5c4de	10.05	9.75	10.05	71	1015	16.67	250	WSW	0.00	f	0.00	haze	2026-05-05 04:00:00+00	2026-05-05 04:00:47.63081+00
7698c359-30d3-4760-bd0f-663333263829	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	8bc5742b-ceb1-4ee7-95fc-4ac203f5c4de	30.99	30.99	30.99	46	1006	7.13	49	NE	8.78	f	0.00	clear sky	2026-05-05 04:00:00+00	2026-05-05 04:00:47.931691+00
4b47283e-5ed9-474d-85dd-0c773b166404	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	8bc5742b-ceb1-4ee7-95fc-4ac203f5c4de	27.94	25.17	27.94	30	1005	3.71	200	SSW	0.00	t	0.00	clear sky	2026-05-05 04:00:00+00	2026-05-05 04:00:48.218145+00
e83c3320-f18c-416d-8057-126b57b310e5	72829d11-3ace-445b-9f4b-5c3c72c3521f	8bc5742b-ceb1-4ee7-95fc-4ac203f5c4de	16.19	14.12	16.19	63	1016	5.54	60	ENE	0.00	t	0.00	broken clouds	2026-05-05 04:00:00+00	2026-05-05 04:00:48.494528+00
2f5f11c6-482f-405d-aa3a-ed02fbf14a9d	5bd52475-ffa2-40f6-82e4-3d0491b7e246	8bc5742b-ceb1-4ee7-95fc-4ac203f5c4de	16.92	16.92	16.92	56	1014	19.19	63	ENE	31.61	f	0.00	overcast clouds	2026-05-05 04:00:00+00	2026-05-05 04:00:48.778421+00
959549ba-4d99-4b23-9fa1-0fcd8e323cc6	467c145d-f635-4cb3-9813-63f4d28b8780	90a4fb95-c393-440c-9e10-bc8214ebd7c1	16.42	15.79	16.42	55	1017	14.83	290	WNW	0.00	f	0.00	scattered clouds	2026-05-05 05:00:00+00	2026-05-05 05:00:49.505944+00
7ac303f5-373f-4377-927d-9aef4484b725	f2df8134-8994-487c-8a25-272606e8f953	90a4fb95-c393-440c-9e10-bc8214ebd7c1	32.87	32.87	32.87	11	1009	17.68	183	S	25.60	f	0.00	clear sky	2026-05-05 05:00:00+00	2026-05-05 05:00:49.794804+00
bb58cf99-8c35-4a4b-b408-f8f0a003a49b	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	90a4fb95-c393-440c-9e10-bc8214ebd7c1	28.96	28.96	30.14	54	1006	5.54	220	SW	0.00	t	0.00	clear sky	2026-05-05 05:00:00+00	2026-05-05 05:00:50.081259+00
b4d8b531-3f04-4edb-b196-bf2c7dde21fc	6411b387-fc37-4b47-878b-8f89fd8e08d9	90a4fb95-c393-440c-9e10-bc8214ebd7c1	20.95	20.95	20.95	46	1010	27.79	310	NW	0.00	t	0.00	dust	2026-05-05 05:00:00+00	2026-05-05 05:00:50.372222+00
3602fe57-be5e-469c-8a27-9acefdd2b15a	05546df7-881e-438f-96b9-be0148283901	90a4fb95-c393-440c-9e10-bc8214ebd7c1	12.99	12.99	12.99	74	1013	33.77	213	SSW	36.58	f	0.00	broken clouds	2026-05-05 05:00:00+00	2026-05-05 05:00:50.673801+00
c1bb7bec-a3d9-4d10-af74-c6bd4e71850a	054b54c2-e6d1-4534-a9de-58bf2831479a	90a4fb95-c393-440c-9e10-bc8214ebd7c1	11.05	10.75	11.05	71	1015	22.21	250	WSW	0.00	f	0.00	haze	2026-05-05 05:00:00+00	2026-05-05 05:00:50.967446+00
f788abc7-fec0-412b-a343-3215f657e15f	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	90a4fb95-c393-440c-9e10-bc8214ebd7c1	31.55	31.55	31.55	47	1007	5.47	86	E	6.59	f	0.00	clear sky	2026-05-05 05:00:00+00	2026-05-05 05:00:51.239972+00
146833d3-7ee4-4992-b7e2-bc97f87c5b0a	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	90a4fb95-c393-440c-9e10-bc8214ebd7c1	30.94	30.17	30.94	29	1006	3.71	330	NNW	0.00	f	0.00	clear sky	2026-05-05 05:00:00+00	2026-05-05 05:00:51.657855+00
29c542c5-e4c1-4f9a-9e6a-56b82fcce059	72829d11-3ace-445b-9f4b-5c3c72c3521f	90a4fb95-c393-440c-9e10-bc8214ebd7c1	16.19	14.12	16.19	63	1016	7.42	100	E	0.00	t	0.00	overcast clouds	2026-05-05 05:00:00+00	2026-05-05 05:00:51.941596+00
9b4b612a-5cb8-4cd7-8042-7b8c412c2bb2	5bd52475-ffa2-40f6-82e4-3d0491b7e246	90a4fb95-c393-440c-9e10-bc8214ebd7c1	15.96	15.96	15.96	58	1015	18.90	62	ENE	31.72	t	0.00	overcast clouds	2026-05-05 05:00:00+00	2026-05-05 05:00:52.228418+00
d3e02210-7f27-4732-b58a-07084475e802	467c145d-f635-4cb3-9813-63f4d28b8780	39320244-9c80-42b9-9a6d-51265f3229b7	17.42	16.90	17.42	48	1017	12.96	300	WNW	0.00	f	0.00	few clouds	2026-05-05 06:00:00+00	2026-05-05 06:00:53.115369+00
54f92a2a-4d18-4183-b052-aeabcc4f27ec	f2df8134-8994-487c-8a25-272606e8f953	39320244-9c80-42b9-9a6d-51265f3229b7	35.67	35.67	35.67	10	1009	18.83	203	SSW	21.67	f	0.00	clear sky	2026-05-05 06:00:00+00	2026-05-05 06:00:53.41405+00
11ced8be-2af8-4971-986c-9fbf2e35fd4b	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	39320244-9c80-42b9-9a6d-51265f3229b7	31.96	31.96	33.14	37	1006	11.12	250	WSW	0.00	f	0.00	clear sky	2026-05-05 06:00:00+00	2026-05-05 06:00:53.697609+00
ce81b12b-14bb-4ad8-883b-65f992757560	6411b387-fc37-4b47-878b-8f89fd8e08d9	39320244-9c80-42b9-9a6d-51265f3229b7	20.95	20.95	20.95	46	1010	27.79	310	NW	0.00	t	0.00	clear sky	2026-05-05 06:00:00+00	2026-05-05 06:00:54.009948+00
1384fd25-d2b1-44cc-b176-180a1bc822be	05546df7-881e-438f-96b9-be0148283901	39320244-9c80-42b9-9a6d-51265f3229b7	12.99	12.99	12.99	75	1013	30.82	210	SSW	34.34	f	0.00	overcast clouds	2026-05-05 06:00:00+00	2026-05-05 06:00:54.312861+00
40b7a0e2-eb15-4ecb-8ead-a5ace985eaa2	054b54c2-e6d1-4534-a9de-58bf2831479a	39320244-9c80-42b9-9a6d-51265f3229b7	12.05	10.75	12.05	62	1016	24.08	260	W	0.00	f	0.00	haze	2026-05-05 06:00:00+00	2026-05-05 06:00:54.615285+00
79e3883d-d3c1-4703-bed5-1b79c93750f4	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	39320244-9c80-42b9-9a6d-51265f3229b7	31.55	31.55	31.55	49	1007	4.64	115	ESE	5.36	t	0.00	clear sky	2026-05-05 06:00:00+00	2026-05-05 06:00:54.913573+00
25b1b31d-6f29-4168-be98-40eace1e186e	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	39320244-9c80-42b9-9a6d-51265f3229b7	35.57	33.17	35.99	23	1006	12.96	300	WNW	0.00	f	0.00	clear sky	2026-05-05 06:00:00+00	2026-05-05 06:00:55.204877+00
846fa468-a57a-4fae-9e66-8d4e369c0c3f	72829d11-3ace-445b-9f4b-5c3c72c3521f	39320244-9c80-42b9-9a6d-51265f3229b7	15.96	14.12	16.19	67	1016	5.54	100	E	0.00	t	0.00	overcast clouds	2026-05-05 06:00:00+00	2026-05-05 06:00:55.510579+00
54bc6920-77d8-4374-ab50-8a0ba2521d1c	5bd52475-ffa2-40f6-82e4-3d0491b7e246	39320244-9c80-42b9-9a6d-51265f3229b7	18.48	18.48	18.48	56	1015	22.18	67	ENE	31.93	t	0.00	overcast clouds	2026-05-05 06:00:00+00	2026-05-05 06:00:55.813433+00
b6a53b5e-9b18-4b6c-b5a3-fa09b474f9c5	6411b387-fc37-4b47-878b-8f89fd8e08d9	b29ad42f-202e-4d65-b667-9b7e9c2dd576	27.95	27.95	27.95	24	1008	20.38	300	WNW	0.00	f	0.00	clear sky	2026-05-05 11:00:00+00	2026-05-05 11:13:57.933714+00
836be959-6f32-414d-b9ed-e910ae6a5229	05546df7-881e-438f-96b9-be0148283901	b29ad42f-202e-4d65-b667-9b7e9c2dd576	13.54	13.54	13.54	65	1013	20.88	247	WSW	24.23	f	0.00	overcast clouds	2026-05-05 11:00:00+00	2026-05-05 11:13:58.806536+00
7714808c-6a9e-44d0-a35b-13454d4a235a	054b54c2-e6d1-4534-a9de-58bf2831479a	b29ad42f-202e-4d65-b667-9b7e9c2dd576	16.05	15.75	16.05	41	1014	27.79	250	WSW	0.00	f	0.00	dust	2026-05-05 11:00:00+00	2026-05-05 11:14:00.826391+00
0b1e6a2e-4e7b-4445-84f2-f72b1d4a859b	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	b29ad42f-202e-4d65-b667-9b7e9c2dd576	32.66	32.66	32.66	54	1004	19.48	107	ESE	19.37	t	0.00	clear sky	2026-05-05 11:00:00+00	2026-05-05 11:14:01.39214+00
e87af24c-42c9-40d4-b17e-5a40656a73dd	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	b29ad42f-202e-4d65-b667-9b7e9c2dd576	37.99	37.94	37.99	27	1004	18.50	50	NE	0.00	f	0.00	clear sky	2026-05-05 11:00:00+00	2026-05-05 11:14:01.834926+00
6046e73f-0b9f-4bd9-816b-14aafe9a3d00	72829d11-3ace-445b-9f4b-5c3c72c3521f	b29ad42f-202e-4d65-b667-9b7e9c2dd576	20.19	20.18	22.12	52	1016	12.96	30	NNE	0.00	t	0.00	scattered clouds	2026-05-05 11:00:00+00	2026-05-05 11:14:02.354345+00
c71ef90e-40b7-4076-a104-517a8bf75f41	5bd52475-ffa2-40f6-82e4-3d0491b7e246	b29ad42f-202e-4d65-b667-9b7e9c2dd576	30.10	30.10	30.10	21	1012	21.24	83	E	22.82	f	0.00	broken clouds	2026-05-05 11:00:00+00	2026-05-05 11:14:02.865025+00
cd1d72e7-e90b-4ff9-ba4a-1d8c3417729f	467c145d-f635-4cb3-9813-63f4d28b8780	ecceacd2-c947-4a76-bcdb-805ce9f26beb	22.42	22.42	22.42	26	1016	16.67	280	W	0.00	f	0.00	scattered clouds	2026-05-05 12:00:00+00	2026-05-05 12:01:30.272212+00
dedc41d2-c760-4ded-9bde-6b577665a0a7	f2df8134-8994-487c-8a25-272606e8f953	ecceacd2-c947-4a76-bcdb-805ce9f26beb	40.76	40.76	40.76	8	1005	19.30	241	WSW	28.33	f	0.00	clear sky	2026-05-05 12:00:00+00	2026-05-05 12:01:30.58422+00
b2c7b416-a8e9-4340-91ea-6f2ea8bb790f	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	ecceacd2-c947-4a76-bcdb-805ce9f26beb	34.96	34.96	35.14	46	1004	20.38	330	NNW	0.00	t	0.00	clear sky	2026-05-05 12:00:00+00	2026-05-05 12:01:30.897163+00
0d9d3305-6a7c-4913-a260-2ad51425ba8a	6411b387-fc37-4b47-878b-8f89fd8e08d9	ecceacd2-c947-4a76-bcdb-805ce9f26beb	27.95	27.95	27.95	24	1008	20.38	300	WNW	0.00	f	0.00	clear sky	2026-05-05 12:00:00+00	2026-05-05 12:01:31.215757+00
c6554050-38bc-4e36-b60c-4a6565424b95	05546df7-881e-438f-96b9-be0148283901	ecceacd2-c947-4a76-bcdb-805ce9f26beb	13.54	13.54	13.54	65	1013	20.88	247	WSW	24.23	f	0.00	overcast clouds	2026-05-05 12:00:00+00	2026-05-05 12:01:31.504062+00
d74b41f2-4402-4620-bc57-40f1516c2735	054b54c2-e6d1-4534-a9de-58bf2831479a	ecceacd2-c947-4a76-bcdb-805ce9f26beb	16.05	15.75	16.05	41	1014	27.79	250	WSW	0.00	f	0.00	dust	2026-05-05 12:00:00+00	2026-05-05 12:01:31.845034+00
de228958-938f-4626-8dd1-b0b4ccab0a97	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	ecceacd2-c947-4a76-bcdb-805ce9f26beb	31.55	31.55	31.55	59	1004	19.48	107	ESE	19.37	t	0.00	clear sky	2026-05-05 12:00:00+00	2026-05-05 12:01:32.152685+00
c60d01a8-0b00-47e7-9163-b23c32f2a36e	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	ecceacd2-c947-4a76-bcdb-805ce9f26beb	37.99	37.94	37.99	27	1004	18.50	50	NE	0.00	f	0.00	clear sky	2026-05-05 12:00:00+00	2026-05-05 12:01:32.465129+00
c1f3f26f-c36f-4e6e-9ae1-f38b1e451354	72829d11-3ace-445b-9f4b-5c3c72c3521f	ecceacd2-c947-4a76-bcdb-805ce9f26beb	20.18	20.18	20.19	52	1016	12.96	30	NNE	0.00	t	0.00	scattered clouds	2026-05-05 12:00:00+00	2026-05-05 12:01:32.789155+00
87dd74e6-2bd1-42f2-8bc8-38d2e8b43685	5bd52475-ffa2-40f6-82e4-3d0491b7e246	ecceacd2-c947-4a76-bcdb-805ce9f26beb	30.10	30.10	30.10	21	1012	21.24	83	E	22.82	f	0.00	broken clouds	2026-05-05 12:00:00+00	2026-05-05 12:01:33.100642+00
731f6dfe-dd94-4276-a13d-ecc817196a30	467c145d-f635-4cb3-9813-63f4d28b8780	c897b609-a493-433a-8817-d13de46072af	22.42	22.42	22.42	30	1015	22.21	330	NNW	0.00	t	0.00	scattered clouds	2026-05-05 13:00:00+00	2026-05-05 13:00:07.292773+00
53337873-4958-49e0-89ca-92718e7c1130	f2df8134-8994-487c-8a25-272606e8f953	c897b609-a493-433a-8817-d13de46072af	40.52	40.52	40.52	9	1004	21.78	262	W	26.42	f	0.00	scattered clouds	2026-05-05 13:00:00+00	2026-05-05 13:00:07.592622+00
5b8a931e-8842-49dc-bd96-35e456c93c35	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	c897b609-a493-433a-8817-d13de46072af	33.96	33.96	34.14	46	1003	24.08	320	NW	0.00	t	0.00	clear sky	2026-05-05 13:00:00+00	2026-05-05 13:00:07.930781+00
b16984a3-f779-4593-85cb-a1b3aa4bec02	6411b387-fc37-4b47-878b-8f89fd8e08d9	c897b609-a493-433a-8817-d13de46072af	27.95	27.95	27.95	26	1008	18.50	310	NW	0.00	t	0.00	clear sky	2026-05-05 13:00:00+00	2026-05-05 13:00:08.223223+00
ce3e8e51-8464-4611-ba6c-d09258880f16	05546df7-881e-438f-96b9-be0148283901	c897b609-a493-433a-8817-d13de46072af	13.54	13.54	13.54	63	1014	20.30	242	WSW	23.90	f	0.00	overcast clouds	2026-05-05 13:00:00+00	2026-05-05 13:00:08.579524+00
6031f13a-dcfa-4a61-828a-988fe805e258	054b54c2-e6d1-4534-a9de-58bf2831479a	c897b609-a493-433a-8817-d13de46072af	16.05	16.05	16.75	41	1014	27.79	250	WSW	0.00	f	0.00	dust	2026-05-05 13:00:00+00	2026-05-05 13:00:08.952835+00
0a2ee989-bc0b-4e9f-8eb3-14b1d4a4cd2d	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	c897b609-a493-433a-8817-d13de46072af	30.99	30.99	30.99	61	1004	24.95	115	ESE	27.14	t	0.00	clear sky	2026-05-05 13:00:00+00	2026-05-05 13:00:09.343528+00
4aab25ae-f612-4b38-9c46-460517fc59aa	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	c897b609-a493-433a-8817-d13de46072af	37.99	36.94	37.99	22	1004	24.08	40	NE	0.00	f	0.00	clear sky	2026-05-05 13:00:00+00	2026-05-05 13:00:09.680538+00
c97b0b46-54f0-4f6b-94f9-bbe35a4f1cd9	72829d11-3ace-445b-9f4b-5c3c72c3521f	c897b609-a493-433a-8817-d13de46072af	20.18	20.18	20.19	52	1016	14.83	10	N	0.00	t	0.00	scattered clouds	2026-05-05 13:00:00+00	2026-05-05 13:00:10.016344+00
9626dca7-f802-4116-8543-aba388ad1dc9	5bd52475-ffa2-40f6-82e4-3d0491b7e246	c897b609-a493-433a-8817-d13de46072af	31.09	31.09	31.09	20	1011	21.28	77	ENE	23.72	f	0.00	broken clouds	2026-05-05 13:00:00+00	2026-05-05 13:00:10.425959+00
c9dc03ee-a0f1-4602-8743-77704dfe2f10	467c145d-f635-4cb3-9813-63f4d28b8780	01f4010d-e366-4a3c-a6ac-67e9181fa6c9	23.42	23.01	23.42	25	1015	22.21	300	WNW	0.00	f	0.00	scattered clouds	2026-05-05 14:00:00+00	2026-05-05 14:00:11.335581+00
9e4ac9ad-880f-4ac1-a600-1b9918c17b7b	f2df8134-8994-487c-8a25-272606e8f953	01f4010d-e366-4a3c-a6ac-67e9181fa6c9	39.48	39.48	39.48	10	1005	23.40	282	WNW	23.54	f	0.00	broken clouds	2026-05-05 14:00:00+00	2026-05-05 14:00:11.614022+00
e8ef10e9-9ef4-4fe9-b28e-3d9bca7987a1	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	01f4010d-e366-4a3c-a6ac-67e9181fa6c9	32.96	32.96	34.14	49	1004	20.38	320	NW	0.00	t	0.00	clear sky	2026-05-05 14:00:00+00	2026-05-05 14:00:11.92193+00
1953cdd6-19d5-4084-81a9-064e545cadbb	6411b387-fc37-4b47-878b-8f89fd8e08d9	01f4010d-e366-4a3c-a6ac-67e9181fa6c9	27.95	27.95	27.95	26	1009	20.38	310	NW	0.00	f	0.00	clear sky	2026-05-05 14:00:00+00	2026-05-05 14:00:12.224524+00
b07f1b7c-5e0f-4d9f-a41d-b08ca2aaa550	05546df7-881e-438f-96b9-be0148283901	01f4010d-e366-4a3c-a6ac-67e9181fa6c9	13.54	13.54	13.54	65	1014	16.09	229	SW	19.33	f	0.00	overcast clouds	2026-05-05 14:00:00+00	2026-05-05 14:00:12.518307+00
e72d475d-cd87-4338-8b06-ae761be53e0b	054b54c2-e6d1-4534-a9de-58bf2831479a	01f4010d-e366-4a3c-a6ac-67e9181fa6c9	15.05	15.05	16.75	47	1014	31.50	260	W	0.00	f	0.00	dust	2026-05-05 14:00:00+00	2026-05-05 14:00:12.810362+00
55ea6dc1-b2fa-4ac0-8e9c-0dead28d3b7c	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	01f4010d-e366-4a3c-a6ac-67e9181fa6c9	30.99	30.99	30.99	53	1003	25.27	115	ESE	30.28	t	0.00	clear sky	2026-05-05 14:00:00+00	2026-05-05 14:00:13.132073+00
8c8a28bc-1d21-42cd-8c2c-1d982339435a	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	01f4010d-e366-4a3c-a6ac-67e9181fa6c9	33.99	32.94	33.99	40	1004	22.21	20	NNE	0.00	f	0.00	clear sky	2026-05-05 14:00:00+00	2026-05-05 14:00:13.415732+00
7252e12b-d252-4f7c-90c2-fdfcbcfef817	72829d11-3ace-445b-9f4b-5c3c72c3521f	01f4010d-e366-4a3c-a6ac-67e9181fa6c9	20.18	20.18	20.19	49	1015	11.12	50	NE	0.00	t	0.00	scattered clouds	2026-05-05 14:00:00+00	2026-05-05 14:00:13.714795+00
4ff65680-171c-47d8-890d-222b0a6e2535	5bd52475-ffa2-40f6-82e4-3d0491b7e246	01f4010d-e366-4a3c-a6ac-67e9181fa6c9	31.01	31.01	31.01	20	1010	23.11	74	ENE	23.18	f	0.00	broken clouds	2026-05-05 14:00:00+00	2026-05-05 14:00:14.006858+00
2bd014e4-322b-4e7d-a727-b8eb287fb9c1	467c145d-f635-4cb3-9813-63f4d28b8780	540ce0e4-5f03-48e9-ae4a-4c95c986da64	23.42	23.01	23.42	27	1015	20.38	330	NNW	0.00	f	0.00	scattered clouds	2026-05-05 15:00:00+00	2026-05-05 15:00:14.845042+00
b1e7fe68-65a2-474a-b9b9-d99e4961b672	f2df8134-8994-487c-8a25-272606e8f953	540ce0e4-5f03-48e9-ae4a-4c95c986da64	38.42	38.42	38.42	9	1005	23.11	291	WNW	29.38	f	0.00	broken clouds	2026-05-05 15:00:00+00	2026-05-05 15:00:15.145604+00
80d2a23d-0d40-40f5-a272-8648691ef328	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	540ce0e4-5f03-48e9-ae4a-4c95c986da64	30.96	30.96	32.14	62	1004	18.50	320	NW	0.00	t	0.00	clear sky	2026-05-05 15:00:00+00	2026-05-05 15:00:15.456242+00
4ff0338c-e624-4245-ab38-33b5d06deaf7	6411b387-fc37-4b47-878b-8f89fd8e08d9	540ce0e4-5f03-48e9-ae4a-4c95c986da64	27.95	27.95	27.95	26	1009	18.50	310	NW	0.00	f	0.00	clear sky	2026-05-05 15:00:00+00	2026-05-05 15:00:15.764133+00
bc2b1cba-073a-4475-826f-87fb000076df	05546df7-881e-438f-96b9-be0148283901	540ce0e4-5f03-48e9-ae4a-4c95c986da64	13.54	13.54	13.54	66	1014	10.01	231	SW	12.67	f	0.00	broken clouds	2026-05-05 15:00:00+00	2026-05-05 15:00:16.070367+00
74c12dbd-e5de-49d5-b855-fa41f2358275	054b54c2-e6d1-4534-a9de-58bf2831479a	540ce0e4-5f03-48e9-ae4a-4c95c986da64	16.05	16.05	16.75	39	1015	24.08	260	W	0.00	f	0.00	scattered clouds	2026-05-05 15:00:00+00	2026-05-05 15:00:16.409293+00
89d932c7-d65d-4a9c-8b6c-27bfae329c9b	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	540ce0e4-5f03-48e9-ae4a-4c95c986da64	30.44	30.44	30.44	54	1003	17.89	125	SE	23.22	t	0.00	clear sky	2026-05-05 15:00:00+00	2026-05-05 15:00:16.703419+00
284fb9cd-1502-4673-b1a4-0d0d352260fe	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	540ce0e4-5f03-48e9-ae4a-4c95c986da64	31.99	30.94	31.99	48	1005	18.50	20	NNE	0.00	t	0.00	clear sky	2026-05-05 15:00:00+00	2026-05-05 15:00:16.98266+00
4268d74a-5a36-49a0-a1d8-add673a266e1	72829d11-3ace-445b-9f4b-5c3c72c3521f	540ce0e4-5f03-48e9-ae4a-4c95c986da64	20.19	20.18	22.12	49	1015	12.96	20	NNE	35.17	t	0.00	broken clouds	2026-05-05 15:00:00+00	2026-05-05 15:00:17.298545+00
97f82bbd-f332-459c-bfbc-aee7c7937c4f	5bd52475-ffa2-40f6-82e4-3d0491b7e246	540ce0e4-5f03-48e9-ae4a-4c95c986da64	31.24	31.24	31.24	20	1009	27.47	73	ENE	24.48	f	0.00	scattered clouds	2026-05-05 15:00:00+00	2026-05-05 15:00:17.592686+00
8957544a-4d0d-48b2-bf2b-f6d2e9c5acc1	467c145d-f635-4cb3-9813-63f4d28b8780	b4bd2ff5-3750-4c7a-8cc8-ff0e2ef92219	22.42	21.90	22.42	30	1015	24.08	330	NNW	0.00	t	0.00	scattered clouds	2026-05-05 16:00:00+00	2026-05-05 16:00:18.322853+00
0e80fdfa-1dce-40f0-92e1-5042f737d77c	f2df8134-8994-487c-8a25-272606e8f953	b4bd2ff5-3750-4c7a-8cc8-ff0e2ef92219	36.42	36.42	36.42	11	1006	16.31	288	WNW	23.87	f	0.00	scattered clouds	2026-05-05 16:00:00+00	2026-05-05 16:00:18.736324+00
082a07e9-ca5b-4e32-ba31-f71d345b848c	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	b4bd2ff5-3750-4c7a-8cc8-ff0e2ef92219	30.96	30.14	30.96	66	1005	16.67	320	NW	0.00	t	0.00	clear sky	2026-05-05 16:00:00+00	2026-05-05 16:00:19.234181+00
7fa98778-1c89-4a81-9a56-32c8a2b60581	6411b387-fc37-4b47-878b-8f89fd8e08d9	b4bd2ff5-3750-4c7a-8cc8-ff0e2ef92219	27.95	27.95	27.95	24	1010	18.50	290	WNW	0.00	f	0.00	clear sky	2026-05-05 16:00:00+00	2026-05-05 16:00:19.550516+00
cbef07fd-7c1e-4643-9357-359c0ae7d917	05546df7-881e-438f-96b9-be0148283901	b4bd2ff5-3750-4c7a-8cc8-ff0e2ef92219	13.54	13.54	13.54	66	1014	8.17	209	SSW	10.19	f	0.00	scattered clouds	2026-05-05 16:00:00+00	2026-05-05 16:00:19.965904+00
c42128c3-38f3-446a-8cc8-54e26b31e40b	054b54c2-e6d1-4534-a9de-58bf2831479a	b4bd2ff5-3750-4c7a-8cc8-ff0e2ef92219	15.05	14.75	15.05	41	1015	29.63	270	W	0.00	f	0.00	dust	2026-05-05 16:00:00+00	2026-05-05 16:00:20.287993+00
a67edce6-9987-4f93-b32e-a90378ab7c91	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	b4bd2ff5-3750-4c7a-8cc8-ff0e2ef92219	33.77	33.77	33.77	41	1004	5.65	306	NW	17.50	f	0.00	clear sky	2026-05-05 16:00:00+00	2026-05-05 16:00:20.644003+00
fad4fd38-befd-4f82-be0c-9e4259abe937	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	b4bd2ff5-3750-4c7a-8cc8-ff0e2ef92219	30.99	30.94	30.99	51	1005	18.50	10	N	0.00	t	0.00	clear sky	2026-05-05 16:00:00+00	2026-05-05 16:00:20.977295+00
412e69ee-e716-49de-8d90-7e15134efd25	72829d11-3ace-445b-9f4b-5c3c72c3521f	b4bd2ff5-3750-4c7a-8cc8-ff0e2ef92219	19.13	19.07	21.12	48	1015	14.83	30	NNE	0.00	t	0.00	broken clouds	2026-05-05 16:00:00+00	2026-05-05 16:00:21.309857+00
27f1ff85-44ec-4b0b-ac2e-01f54eb10586	5bd52475-ffa2-40f6-82e4-3d0491b7e246	b4bd2ff5-3750-4c7a-8cc8-ff0e2ef92219	30.20	30.20	30.20	23	1009	33.84	73	ENE	30.17	t	0.00	scattered clouds	2026-05-05 16:00:00+00	2026-05-05 16:00:21.621425+00
5318ec79-157d-44aa-91e4-99dfb5de7e31	467c145d-f635-4cb3-9813-63f4d28b8780	59371d65-369a-4e9e-bee4-9f19989249f4	21.42	20.79	21.42	32	1016	22.21	320	NW	0.00	f	0.00	scattered clouds	2026-05-05 17:00:00+00	2026-05-05 17:00:22.614891+00
323024a5-9a4a-4adc-8484-2134655a0cbc	f2df8134-8994-487c-8a25-272606e8f953	59371d65-369a-4e9e-bee4-9f19989249f4	35.80	35.80	35.80	11	1007	9.58	356	N	9.40	f	0.00	scattered clouds	2026-05-05 17:00:00+00	2026-05-05 17:00:23.075357+00
292a0ed3-712b-485c-b956-8ba29a18f21a	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	59371d65-369a-4e9e-bee4-9f19989249f4	30.96	30.14	30.96	58	1006	5.54	0	N	0.00	t	0.00	clear sky	2026-05-05 17:00:00+00	2026-05-05 17:00:23.438134+00
a31e7121-01a0-4ded-bf16-52862f6292f3	6411b387-fc37-4b47-878b-8f89fd8e08d9	59371d65-369a-4e9e-bee4-9f19989249f4	25.95	25.95	25.95	25	1011	12.96	290	WNW	0.00	t	0.00	clear sky	2026-05-05 17:00:00+00	2026-05-05 17:00:23.851671+00
c7699ea5-72c5-46ed-98cd-bac4950eb33b	05546df7-881e-438f-96b9-be0148283901	59371d65-369a-4e9e-bee4-9f19989249f4	13.54	13.54	13.54	67	1015	8.68	176	S	10.58	f	0.00	scattered clouds	2026-05-05 17:00:00+00	2026-05-05 17:00:24.217681+00
7c5039ec-3ca6-4a2e-9e0e-cbcb324c711d	054b54c2-e6d1-4534-a9de-58bf2831479a	59371d65-369a-4e9e-bee4-9f19989249f4	14.05	13.75	14.05	44	1015	25.92	260	W	0.00	f	0.00	scattered clouds	2026-05-05 17:00:00+00	2026-05-05 17:00:24.63817+00
bc0cdb9f-4292-496b-b3a3-ede456cb23a3	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	59371d65-369a-4e9e-bee4-9f19989249f4	32.94	32.94	32.94	36	1006	26.24	337	NNW	30.96	f	0.00	clear sky	2026-05-05 17:00:00+00	2026-05-05 17:00:25.139792+00
dcef5983-e4c5-4852-9b84-c1d744be45c1	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	59371d65-369a-4e9e-bee4-9f19989249f4	29.99	29.94	29.99	58	1006	14.83	20	NNE	0.00	t	0.00	clear sky	2026-05-05 17:00:00+00	2026-05-05 17:00:25.757388+00
03b7024e-7ac1-4653-8774-f4d8228a471b	72829d11-3ace-445b-9f4b-5c3c72c3521f	59371d65-369a-4e9e-bee4-9f19989249f4	19.13	19.07	19.19	52	1015	12.96	30	NNE	0.00	t	0.00	scattered clouds	2026-05-05 17:00:00+00	2026-05-05 17:00:26.344575+00
29ffd959-890e-424a-9ae3-71d87dcde1c6	5bd52475-ffa2-40f6-82e4-3d0491b7e246	59371d65-369a-4e9e-bee4-9f19989249f4	28.05	28.05	28.05	28	1009	38.30	77	ENE	40.00	t	0.00	scattered clouds	2026-05-05 17:00:00+00	2026-05-05 17:00:26.800439+00
e9f45258-0c5a-4b97-94c1-b2a4b4c4cae2	467c145d-f635-4cb3-9813-63f4d28b8780	85034e04-85b6-4c13-a486-aff20e35ad59	20.42	20.23	20.42	40	1017	24.08	340	NNW	0.00	t	0.00	clear sky	2026-05-05 18:00:00+00	2026-05-05 18:00:27.49628+00
91e394f3-ef47-45db-8b24-80f7ddbb8acf	f2df8134-8994-487c-8a25-272606e8f953	85034e04-85b6-4c13-a486-aff20e35ad59	35.28	35.28	35.28	11	1008	12.82	326	NW	14.69	f	0.00	scattered clouds	2026-05-05 18:00:00+00	2026-05-05 18:00:27.985879+00
21bc1b90-bf83-4505-8c0f-5f5bd54a81ba	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	85034e04-85b6-4c13-a486-aff20e35ad59	30.96	29.14	30.96	58	1006	9.25	50	NE	0.00	t	0.00	clear sky	2026-05-05 18:00:00+00	2026-05-05 18:00:28.408406+00
70df501f-da8d-434b-aea7-b42bac7bebcb	6411b387-fc37-4b47-878b-8f89fd8e08d9	85034e04-85b6-4c13-a486-aff20e35ad59	24.95	24.95	24.95	27	1011	9.25	270	W	0.00	t	0.00	clear sky	2026-05-05 18:00:00+00	2026-05-05 18:00:28.783131+00
4710bffd-0be8-4752-b935-6855ed8ea85f	05546df7-881e-438f-96b9-be0148283901	85034e04-85b6-4c13-a486-aff20e35ad59	12.99	12.99	12.99	68	1015	9.72	156	SSE	10.04	f	0.00	scattered clouds	2026-05-05 18:00:00+00	2026-05-05 18:00:29.241501+00
c9e8356b-4234-4c08-bc6d-1be83c7d4b78	054b54c2-e6d1-4534-a9de-58bf2831479a	85034e04-85b6-4c13-a486-aff20e35ad59	13.05	12.75	13.05	58	1016	18.50	290	WNW	0.00	f	0.00	scattered clouds	2026-05-05 18:00:00+00	2026-05-05 18:00:29.692095+00
4f5ff506-b280-459c-a56f-653dbc75fc26	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	85034e04-85b6-4c13-a486-aff20e35ad59	33.77	33.77	33.77	34	1007	29.74	333	NNW	40.54	f	0.00	clear sky	2026-05-05 18:00:00+00	2026-05-05 18:00:30.231143+00
e679b1ba-bfe3-4379-bad7-487dc69f3f22	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	85034e04-85b6-4c13-a486-aff20e35ad59	29.99	29.94	29.99	58	1006	12.96	10	N	0.00	t	0.00	clear sky	2026-05-05 18:00:00+00	2026-05-05 18:00:30.693076+00
5b309e63-e07b-44f5-a117-2c91615d0d2d	72829d11-3ace-445b-9f4b-5c3c72c3521f	85034e04-85b6-4c13-a486-aff20e35ad59	18.65	18.19	20.12	53	1015	14.83	30	NNE	0.00	t	0.00	scattered clouds	2026-05-05 18:00:00+00	2026-05-05 18:00:31.166603+00
a865255c-8133-4eba-b483-2d96d57c1576	5bd52475-ffa2-40f6-82e4-3d0491b7e246	85034e04-85b6-4c13-a486-aff20e35ad59	25.98	25.98	25.98	31	1009	35.71	75	ENE	48.35	t	0.00	scattered clouds	2026-05-05 18:00:00+00	2026-05-05 18:00:32.54848+00
a798dba3-8a71-4dca-a93d-5f05746f0a40	467c145d-f635-4cb3-9813-63f4d28b8780	deb4fd2c-5226-4299-8402-e97a24286b61	19.42	19.12	19.42	45	1017	24.08	0	N	0.00	f	0.00	clear sky	2026-05-05 19:00:00+00	2026-05-05 19:00:33.406771+00
34fc8df8-58ce-4e5f-ab33-156f719d4ffa	f2df8134-8994-487c-8a25-272606e8f953	deb4fd2c-5226-4299-8402-e97a24286b61	34.25	34.25	34.25	12	1008	7.45	334	NNW	5.94	f	0.00	broken clouds	2026-05-05 19:00:00+00	2026-05-05 19:00:33.774439+00
ec0f7249-0202-4f1f-a388-d0898a1141d9	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	deb4fd2c-5226-4299-8402-e97a24286b61	30.96	28.14	30.96	55	1006	11.12	50	NE	0.00	t	0.00	clear sky	2026-05-05 19:00:00+00	2026-05-05 19:00:34.139915+00
c2adaa61-37c9-4b6c-a7dd-63f4db8ff67b	6411b387-fc37-4b47-878b-8f89fd8e08d9	deb4fd2c-5226-4299-8402-e97a24286b61	21.95	21.95	21.95	30	1011	1.84	310	NW	0.00	f	0.00	clear sky	2026-05-05 19:00:00+00	2026-05-05 19:00:34.52721+00
329b1c39-115b-4605-95d2-b363c510bc2d	05546df7-881e-438f-96b9-be0148283901	deb4fd2c-5226-4299-8402-e97a24286b61	12.99	12.99	12.99	69	1016	9.18	156	SSE	10.12	f	0.00	scattered clouds	2026-05-05 19:00:00+00	2026-05-05 19:00:34.907743+00
acbc75c6-29b5-4a4c-a7c2-483798abae68	054b54c2-e6d1-4534-a9de-58bf2831479a	deb4fd2c-5226-4299-8402-e97a24286b61	12.05	10.75	12.05	62	1017	18.50	280	W	0.00	f	0.00	broken clouds	2026-05-05 19:00:00+00	2026-05-05 19:00:35.266787+00
5e864344-7682-4489-847e-050827e6683a	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	deb4fd2c-5226-4299-8402-e97a24286b61	32.10	32.10	32.10	37	1007	30.74	333	NNW	42.62	f	0.00	clear sky	2026-05-05 19:00:00+00	2026-05-05 19:00:35.635082+00
d19c2a43-9335-454d-a037-5a1a9c832b4b	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	deb4fd2c-5226-4299-8402-e97a24286b61	28.97	28.94	31.17	63	1006	9.25	40	NE	0.00	t	0.00	clear sky	2026-05-05 19:00:00+00	2026-05-05 19:00:36.037669+00
b4c85788-198b-4417-9b51-add5c929a8af	72829d11-3ace-445b-9f4b-5c3c72c3521f	deb4fd2c-5226-4299-8402-e97a24286b61	18.19	18.12	18.19	55	1016	14.83	20	NNE	0.00	t	0.00	scattered clouds	2026-05-05 19:00:00+00	2026-05-05 19:00:36.403961+00
90550d52-7d39-41f8-b254-d5d71d12b4f8	5bd52475-ffa2-40f6-82e4-3d0491b7e246	deb4fd2c-5226-4299-8402-e97a24286b61	24.27	24.27	24.27	37	1009	34.81	67	ENE	52.13	t	0.00	scattered clouds	2026-05-05 19:00:00+00	2026-05-05 19:00:36.770484+00
3da1c12d-c730-4c1b-90da-6ee90e9379a9	467c145d-f635-4cb3-9813-63f4d28b8780	7700374f-cb81-424d-93d0-0bcc5e46bb60	18.42	18.01	18.42	45	1018	22.21	0	N	0.00	f	0.00	clear sky	2026-05-05 20:00:00+00	2026-05-05 20:00:40.802743+00
38cdf01b-ad0a-48db-894d-cf9c7a4a7066	f2df8134-8994-487c-8a25-272606e8f953	7700374f-cb81-424d-93d0-0bcc5e46bb60	33.88	33.88	33.88	14	1008	3.53	14	NNE	4.72	f	0.00	broken clouds	2026-05-05 20:00:00+00	2026-05-05 20:00:41.223877+00
2705f495-87d4-47a6-9bd6-5f30f2f7c82e	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	7700374f-cb81-424d-93d0-0bcc5e46bb60	30.96	28.14	30.96	55	1006	11.12	40	NE	0.00	t	0.00	clear sky	2026-05-05 20:00:00+00	2026-05-05 20:00:42.75077+00
ec5f5844-1efc-4391-9cb2-fdd608e7c292	6411b387-fc37-4b47-878b-8f89fd8e08d9	7700374f-cb81-424d-93d0-0bcc5e46bb60	20.95	20.95	20.95	35	1011	3.71	30	NNE	0.00	t	0.00	clear sky	2026-05-05 20:00:00+00	2026-05-05 20:00:44.934602+00
5f91be35-f331-4725-9ff7-3c60d3030797	05546df7-881e-438f-96b9-be0148283901	7700374f-cb81-424d-93d0-0bcc5e46bb60	12.99	12.99	12.99	68	1016	9.43	148	SSE	9.79	f	0.00	scattered clouds	2026-05-05 20:00:00+00	2026-05-05 20:00:46.439686+00
7d468d64-0913-4d94-8f99-a838f3d76fd0	054b54c2-e6d1-4534-a9de-58bf2831479a	7700374f-cb81-424d-93d0-0bcc5e46bb60	11.05	9.75	11.05	71	1017	12.96	310	NW	0.00	f	0.00	broken clouds	2026-05-05 20:00:00+00	2026-05-05 20:00:51.490263+00
7aaae7c4-03dc-4211-9b6d-4831434814aa	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	7700374f-cb81-424d-93d0-0bcc5e46bb60	31.55	31.55	31.55	39	1007	33.55	342	NNW	46.37	f	0.00	clear sky	2026-05-05 20:00:00+00	2026-05-05 20:00:52.917911+00
f1b889f1-f42e-48f0-98a9-578a0e4685f1	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	7700374f-cb81-424d-93d0-0bcc5e46bb60	28.97	28.94	31.17	68	1005	5.54	20	NNE	0.00	t	0.00	clear sky	2026-05-05 20:00:00+00	2026-05-05 20:00:54.415237+00
3db60c1f-f8e7-4f2e-a195-22cedb2258f8	72829d11-3ace-445b-9f4b-5c3c72c3521f	7700374f-cb81-424d-93d0-0bcc5e46bb60	18.07	17.12	18.19	63	1016	11.12	20	NNE	0.00	t	0.00	scattered clouds	2026-05-05 20:00:00+00	2026-05-05 20:00:56.364374+00
2ca8c3fb-1802-4974-8df5-8d1a0354dc6e	5bd52475-ffa2-40f6-82e4-3d0491b7e246	7700374f-cb81-424d-93d0-0bcc5e46bb60	23.81	23.81	23.81	34	1011	37.04	66	ENE	54.86	t	0.23	light rain	2026-05-05 20:00:00+00	2026-05-05 20:00:58.454998+00
1d5fcbe8-9a9c-46cb-ae9e-ffd6ee29f54c	467c145d-f635-4cb3-9813-63f4d28b8780	460ba0a7-f582-4df6-9cf9-e820679df9a6	17.42	16.90	17.42	48	1018	20.38	350	N	0.00	f	0.00	clear sky	2026-05-05 21:00:00+00	2026-05-05 21:00:31.184061+00
d67146d1-58e8-43cf-86e3-5b793366cc19	f2df8134-8994-487c-8a25-272606e8f953	460ba0a7-f582-4df6-9cf9-e820679df9a6	33.53	33.53	33.53	14	1008	9.97	338	NNW	11.12	f	0.00	broken clouds	2026-05-05 21:00:00+00	2026-05-05 21:00:33.779726+00
4ce442dc-5e7e-41aa-8c5f-ba495a154426	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	460ba0a7-f582-4df6-9cf9-e820679df9a6	30.96	27.14	30.96	51	1005	7.42	60	ENE	0.00	t	0.00	clear sky	2026-05-05 21:00:00+00	2026-05-05 21:00:34.567541+00
21651fda-2d96-4313-adce-98bf486b7466	6411b387-fc37-4b47-878b-8f89fd8e08d9	460ba0a7-f582-4df6-9cf9-e820679df9a6	18.95	18.95	18.95	42	1011	3.71	40	NE	0.00	t	0.00	clear sky	2026-05-05 21:00:00+00	2026-05-05 21:00:35.333791+00
6084de67-054f-4e82-b70c-204871b466db	05546df7-881e-438f-96b9-be0148283901	460ba0a7-f582-4df6-9cf9-e820679df9a6	12.99	12.99	12.99	67	1016	8.46	138	SE	8.28	f	0.00	scattered clouds	2026-05-05 21:00:00+00	2026-05-05 21:00:37.882843+00
06ea48aa-28d1-4288-998f-da2352c7ad66	054b54c2-e6d1-4534-a9de-58bf2831479a	460ba0a7-f582-4df6-9cf9-e820679df9a6	11.05	9.75	11.05	71	1017	11.12	310	NW	0.00	f	0.00	broken clouds	2026-05-05 21:00:00+00	2026-05-05 21:00:40.611146+00
8c4af9e8-dc2b-4bd2-88d9-6cf287d90c5a	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	460ba0a7-f582-4df6-9cf9-e820679df9a6	30.44	30.44	30.44	41	1007	35.89	345	NNW	48.78	f	0.00	clear sky	2026-05-05 21:00:00+00	2026-05-05 21:00:41.779591+00
8ef08223-ad96-4ddd-9769-88a602425287	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	460ba0a7-f582-4df6-9cf9-e820679df9a6	28.97	28.94	30.17	70	1005	7.42	80	E	0.00	t	0.00	clear sky	2026-05-05 21:00:00+00	2026-05-05 21:00:43.876071+00
ea6b08ae-5297-4d37-8477-08ecf721b7a0	72829d11-3ace-445b-9f4b-5c3c72c3521f	460ba0a7-f582-4df6-9cf9-e820679df9a6	17.02	16.85	17.19	67	1016	11.12	30	NNE	0.00	t	0.00	broken clouds	2026-05-05 21:00:00+00	2026-05-05 21:00:47.321118+00
b42cf8d1-7c68-4344-94b3-93f00937229a	5bd52475-ffa2-40f6-82e4-3d0491b7e246	460ba0a7-f582-4df6-9cf9-e820679df9a6	23.29	23.29	23.29	36	1011	37.15	67	ENE	55.73	t	0.39	light rain	2026-05-05 21:00:00+00	2026-05-05 21:00:50.44746+00
c6415985-d845-4979-b709-88b1da4bb480	467c145d-f635-4cb3-9813-63f4d28b8780	7b0b2641-e6d6-4507-b364-98fe10a38169	17.42	16.90	17.42	48	1017	16.67	350	N	0.00	f	0.00	clear sky	2026-05-05 22:00:00+00	2026-05-05 22:00:53.6678+00
45b67395-ef29-42b6-b50b-81b1c1450107	f2df8134-8994-487c-8a25-272606e8f953	7b0b2641-e6d6-4507-b364-98fe10a38169	32.86	32.86	32.86	15	1007	16.56	359	N	20.92	f	0.00	broken clouds	2026-05-05 22:00:00+00	2026-05-05 22:00:54.405842+00
c56557b7-9176-4244-aef6-0975d83bfb95	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	7b0b2641-e6d6-4507-b364-98fe10a38169	30.96	25.14	30.96	48	1005	5.54	50	NE	0.00	t	0.00	clear sky	2026-05-05 22:00:00+00	2026-05-05 22:00:55.13738+00
b58bbfb3-a236-4c93-86fd-bcb56c77037e	6411b387-fc37-4b47-878b-8f89fd8e08d9	7b0b2641-e6d6-4507-b364-98fe10a38169	18.95	18.95	18.95	45	1011	3.71	330	NNW	0.00	t	0.00	clear sky	2026-05-05 22:00:00+00	2026-05-05 22:00:56.125601+00
86a9b61e-9a95-4867-a4ce-a193aab9227e	05546df7-881e-438f-96b9-be0148283901	7b0b2641-e6d6-4507-b364-98fe10a38169	12.43	12.43	12.43	67	1015	7.99	141	SE	7.81	f	0.00	scattered clouds	2026-05-05 22:00:00+00	2026-05-05 22:00:57.657493+00
be682420-17a3-470f-aa8c-b18e80ef85eb	054b54c2-e6d1-4534-a9de-58bf2831479a	7b0b2641-e6d6-4507-b364-98fe10a38169	11.05	8.75	11.05	76	1017	12.96	320	NW	0.00	f	0.00	broken clouds	2026-05-05 22:00:00+00	2026-05-05 22:00:58.405249+00
65e0e6bc-df2d-4095-b679-8bef257e2df7	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	7b0b2641-e6d6-4507-b364-98fe10a38169	29.32	29.32	29.32	44	1007	36.43	346	NNW	49.46	t	0.00	clear sky	2026-05-05 22:00:00+00	2026-05-05 22:00:59.093113+00
e3c372c9-0a4a-480a-afa3-c52c67c2654b	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	7b0b2641-e6d6-4507-b364-98fe10a38169	28.38	27.99	29.17	70	1004	7.42	100	E	0.00	t	0.00	clear sky	2026-05-05 22:00:00+00	2026-05-05 22:01:00.116864+00
1729d77d-22fd-4347-b813-60864ef7aeaf	72829d11-3ace-445b-9f4b-5c3c72c3521f	7b0b2641-e6d6-4507-b364-98fe10a38169	17.02	16.12	17.19	67	1016	9.25	30	NNE	0.00	t	0.00	broken clouds	2026-05-05 22:00:00+00	2026-05-05 22:01:00.868505+00
7463e139-8add-4700-abd4-923fa3f7c409	5bd52475-ffa2-40f6-82e4-3d0491b7e246	7b0b2641-e6d6-4507-b364-98fe10a38169	22.61	22.61	22.61	40	1011	36.29	65	ENE	56.45	t	0.42	light rain	2026-05-05 22:00:00+00	2026-05-05 22:01:03.340442+00
363e77e2-6ea9-421d-8829-f650a017de78	467c145d-f635-4cb3-9813-63f4d28b8780	ea0e6bd3-f842-4c10-87d8-2a8e76d6e6c2	16.42	15.79	16.42	51	1017	12.96	10	N	0.00	f	0.00	clear sky	2026-05-05 23:00:00+00	2026-05-05 23:00:04.473584+00
e5f9e9c9-8ed5-4dff-a7ad-349315417944	f2df8134-8994-487c-8a25-272606e8f953	ea0e6bd3-f842-4c10-87d8-2a8e76d6e6c2	31.65	31.65	31.65	16	1007	16.78	17	NNE	27.94	f	0.00	broken clouds	2026-05-05 23:00:00+00	2026-05-05 23:00:04.817046+00
d35f3a08-4e0e-4b34-bee3-325a33f2c752	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	ea0e6bd3-f842-4c10-87d8-2a8e76d6e6c2	30.96	24.14	30.96	48	1005	7.42	40	NE	0.00	t	0.00	clear sky	2026-05-05 23:00:00+00	2026-05-05 23:00:05.751446+00
f82f3965-f74f-44e1-989b-f0369fea3847	6411b387-fc37-4b47-878b-8f89fd8e08d9	ea0e6bd3-f842-4c10-87d8-2a8e76d6e6c2	17.95	17.95	17.95	45	1011	7.42	350	N	0.00	t	0.00	clear sky	2026-05-05 23:00:00+00	2026-05-05 23:00:06.676886+00
2bd05a4f-be18-43e7-afa2-413e409dfd7b	05546df7-881e-438f-96b9-be0148283901	ea0e6bd3-f842-4c10-87d8-2a8e76d6e6c2	11.88	11.88	11.88	67	1014	7.81	175	S	8.42	f	0.00	few clouds	2026-05-05 23:00:00+00	2026-05-05 23:00:07.701938+00
3301e664-480b-401e-b961-1e2c024c1e8c	054b54c2-e6d1-4534-a9de-58bf2831479a	ea0e6bd3-f842-4c10-87d8-2a8e76d6e6c2	11.05	8.75	11.05	76	1016	9.25	0	N	0.00	f	0.00	broken clouds	2026-05-05 23:00:00+00	2026-05-05 23:00:08.17055+00
82c52086-1a24-4f01-adaa-1b97cfb3f5ba	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	ea0e6bd3-f842-4c10-87d8-2a8e76d6e6c2	28.77	28.77	28.77	45	1007	35.21	344	NNW	47.09	t	0.00	clear sky	2026-05-05 23:00:00+00	2026-05-05 23:00:08.527449+00
dc9281cf-1832-44e5-ae50-6ace16582b84	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	ea0e6bd3-f842-4c10-87d8-2a8e76d6e6c2	28.97	28.17	28.99	65	1004	7.42	120	ESE	0.00	t	0.00	clear sky	2026-05-05 23:00:00+00	2026-05-05 23:00:08.876422+00
49fe4ae3-dfd2-47a6-8939-53717c899fc2	72829d11-3ace-445b-9f4b-5c3c72c3521f	ea0e6bd3-f842-4c10-87d8-2a8e76d6e6c2	17.02	16.12	17.19	63	1016	9.25	40	NE	0.00	t	0.00	broken clouds	2026-05-05 23:00:00+00	2026-05-05 23:00:09.242701+00
d2283c9e-2b3f-4aed-ac70-92caae1dd347	5bd52475-ffa2-40f6-82e4-3d0491b7e246	ea0e6bd3-f842-4c10-87d8-2a8e76d6e6c2	22.02	22.02	22.02	45	1010	39.35	65	ENE	60.73	t	0.00	overcast clouds	2026-05-05 23:00:00+00	2026-05-05 23:00:09.616204+00
50ab0852-09b2-4643-8cef-88089fbe18c2	467c145d-f635-4cb3-9813-63f4d28b8780	1c061f66-7446-4081-ad5e-a0e4ec295c83	27.42	26.90	27.42	36	1012	14.83	40	NE	0.00	t	0.00	broken clouds	2026-05-13 22:00:00+00	2026-05-13 22:00:16.558563+00
96cde5ac-9f68-4835-8fad-75b7c363f124	f2df8134-8994-487c-8a25-272606e8f953	1c061f66-7446-4081-ad5e-a0e4ec295c83	29.59	29.59	29.59	14	1008	15.80	30	NNE	25.56	t	0.00	clear sky	2026-05-13 22:00:00+00	2026-05-13 22:00:16.956031+00
f97bd450-c75f-4dfe-a52e-fbf6fe97b1af	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	1c061f66-7446-4081-ad5e-a0e4ec295c83	28.96	28.96	29.14	54	1002	11.12	210	SSW	0.00	t	0.00	clear sky	2026-05-13 22:00:00+00	2026-05-13 22:00:17.292683+00
a036234a-b6fe-4b06-813c-98edb09c3a84	6411b387-fc37-4b47-878b-8f89fd8e08d9	1c061f66-7446-4081-ad5e-a0e4ec295c83	25.95	25.95	25.95	25	1005	14.83	320	NW	0.00	f	0.00	clear sky	2026-05-13 22:00:00+00	2026-05-13 22:00:17.629399+00
70339c5d-8751-4aea-a0e7-f412567599c9	05546df7-881e-438f-96b9-be0148283901	1c061f66-7446-4081-ad5e-a0e4ec295c83	21.32	21.32	21.32	55	1011	16.88	205	SSW	21.31	t	0.00	clear sky	2026-05-13 22:00:00+00	2026-05-13 22:00:18.015062+00
44e4148f-d82f-4a14-8d03-023615fa7e10	054b54c2-e6d1-4534-a9de-58bf2831479a	1c061f66-7446-4081-ad5e-a0e4ec295c83	20.05	17.75	20.05	40	1014	0.00	0	N	0.00	t	0.00	dust	2026-05-13 22:00:00+00	2026-05-13 22:00:18.426783+00
1148bc6f-759b-424b-98a0-ee63a546e12f	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	1c061f66-7446-4081-ad5e-a0e4ec295c83	34.32	34.32	34.32	26	1004	13.10	224	SW	14.90	f	0.00	clear sky	2026-05-13 22:00:00+00	2026-05-13 22:00:18.788585+00
338d10f2-b3c7-475a-b365-4d6bad03b3a9	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	1c061f66-7446-4081-ad5e-a0e4ec295c83	29.94	29.17	29.94	37	1004	14.83	330	NNW	0.00	t	0.00	clear sky	2026-05-13 22:00:00+00	2026-05-13 22:00:19.195761+00
94a7fa6c-5258-4ac3-b139-ce8152fef5c7	72829d11-3ace-445b-9f4b-5c3c72c3521f	1c061f66-7446-4081-ad5e-a0e4ec295c83	18.07	17.12	18.19	72	1018	9.25	70	ENE	0.00	f	0.00	clear sky	2026-05-13 22:00:00+00	2026-05-13 22:00:19.557339+00
e3438604-c5fe-47e6-929b-ba5c1d1f0db4	5bd52475-ffa2-40f6-82e4-3d0491b7e246	1c061f66-7446-4081-ad5e-a0e4ec295c83	26.52	26.52	26.52	19	1014	16.02	295	WNW	22.72	f	0.00	broken clouds	2026-05-13 22:00:00+00	2026-05-13 22:00:19.9553+00
6ec9b53a-42a3-407c-9334-c14cb0a8723e	467c145d-f635-4cb3-9813-63f4d28b8780	f5573206-0789-45e1-8974-a3b45b94ad91	26.42	25.79	26.42	41	1011	12.96	50	NE	0.00	t	0.00	broken clouds	2026-05-13 23:00:00+00	2026-05-13 23:00:20.665259+00
b52f4988-62b8-4722-93d3-b69762f7fbf7	f2df8134-8994-487c-8a25-272606e8f953	f5573206-0789-45e1-8974-a3b45b94ad91	28.76	28.76	28.76	14	1008	14.18	30	NNE	21.64	t	0.00	clear sky	2026-05-13 23:00:00+00	2026-05-13 23:00:20.982961+00
4a6db094-c8dd-439e-927a-f3a735be3a3b	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	f5573206-0789-45e1-8974-a3b45b94ad91	28.96	28.14	28.96	48	1001	9.25	210	SSW	0.00	t	0.00	clear sky	2026-05-13 23:00:00+00	2026-05-13 23:00:21.299199+00
31ff7bf0-95a7-496f-bbae-2a9afb1ea325	6411b387-fc37-4b47-878b-8f89fd8e08d9	f5573206-0789-45e1-8974-a3b45b94ad91	25.95	25.95	25.95	29	1005	11.12	310	NW	0.00	t	0.00	clear sky	2026-05-13 23:00:00+00	2026-05-13 23:00:21.627254+00
2bc99de2-a620-4f20-8a6a-9265ecda0dc3	05546df7-881e-438f-96b9-be0148283901	f5573206-0789-45e1-8974-a3b45b94ad91	21.32	21.32	21.32	52	1010	15.62	208	SSW	19.58	t	0.00	clear sky	2026-05-13 23:00:00+00	2026-05-13 23:00:21.936544+00
b74c0dc0-1c76-448f-9acb-14f8c1215790	054b54c2-e6d1-4534-a9de-58bf2831479a	f5573206-0789-45e1-8974-a3b45b94ad91	19.05	17.75	19.05	39	1013	3.71	80	E	0.00	f	0.00	dust	2026-05-13 23:00:00+00	2026-05-13 23:00:22.259435+00
d43b300c-9dcc-4cc5-afb8-1f6183f353e2	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	f5573206-0789-45e1-8974-a3b45b94ad91	33.21	33.21	33.21	25	1004	15.98	227	SW	20.70	f	0.00	clear sky	2026-05-13 23:00:00+00	2026-05-13 23:00:22.566658+00
e862e57f-b1ad-4f06-8c96-5aef60b594e8	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	f5573206-0789-45e1-8974-a3b45b94ad91	30.94	29.17	30.94	30	1003	18.50	330	NNW	0.00	t	0.00	clear sky	2026-05-13 23:00:00+00	2026-05-13 23:00:22.845995+00
e8917d07-f483-4d59-958a-cb0f69ac1896	72829d11-3ace-445b-9f4b-5c3c72c3521f	f5573206-0789-45e1-8974-a3b45b94ad91	18.07	16.12	18.19	72	1018	11.12	90	E	0.00	f	0.00	clear sky	2026-05-13 23:00:00+00	2026-05-13 23:00:23.132361+00
7222074b-7031-4988-b514-3d4a4a66fda7	5bd52475-ffa2-40f6-82e4-3d0491b7e246	f5573206-0789-45e1-8974-a3b45b94ad91	22.41	22.41	22.41	41	1015	31.03	61	ENE	43.81	f	0.00	broken clouds	2026-05-13 23:00:00+00	2026-05-13 23:00:23.419718+00
0229eddf-903a-433a-bd47-b66e330b7b92	467c145d-f635-4cb3-9813-63f4d28b8780	02158370-f247-40ac-9fba-d350ec1d3bad	25.42	25.23	25.42	47	1011	9.25	70	ENE	0.00	t	0.00	clear sky	2026-05-14 00:00:00+00	2026-05-14 00:00:24.289999+00
7ce12659-8270-40ce-9156-3027cd8b852c	f2df8134-8994-487c-8a25-272606e8f953	02158370-f247-40ac-9fba-d350ec1d3bad	27.88	27.88	27.88	15	1007	12.71	32	NNE	17.50	f	0.00	clear sky	2026-05-14 00:00:00+00	2026-05-14 00:00:24.710259+00
31d814f5-99cc-477e-b382-66f96c09f360	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	02158370-f247-40ac-9fba-d350ec1d3bad	27.96	27.96	28.14	51	1001	14.83	200	SSW	0.00	t	0.00	clear sky	2026-05-14 00:00:00+00	2026-05-14 00:00:25.070572+00
21e07ab3-56ad-4bf1-be00-9ca0a2f6c22c	6411b387-fc37-4b47-878b-8f89fd8e08d9	02158370-f247-40ac-9fba-d350ec1d3bad	22.95	22.95	22.95	38	1005	1.84	0	N	0.00	t	0.00	clear sky	2026-05-14 00:00:00+00	2026-05-14 00:00:25.418606+00
4697336c-c63d-4a82-9764-37667d24ee91	05546df7-881e-438f-96b9-be0148283901	02158370-f247-40ac-9fba-d350ec1d3bad	20.77	20.77	20.77	53	1010	18.86	217	SW	23.72	t	0.00	clear sky	2026-05-14 00:00:00+00	2026-05-14 00:00:25.823219+00
c0eeb010-cdd6-4aa1-b3a1-3e9cfb62b6a6	054b54c2-e6d1-4534-a9de-58bf2831479a	02158370-f247-40ac-9fba-d350ec1d3bad	19.05	14.75	19.05	32	1013	12.96	270	W	0.00	f	0.00	dust	2026-05-14 00:00:00+00	2026-05-14 00:00:26.136145+00
7bdedca5-5c2a-49a3-a5f2-54f52373b268	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	02158370-f247-40ac-9fba-d350ec1d3bad	33.77	33.77	33.77	25	1003	13.79	226	SW	20.23	f	0.00	clear sky	2026-05-14 00:00:00+00	2026-05-14 00:00:26.442229+00
1f6d8dd8-b25b-49a4-b5ed-a160250bb133	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	02158370-f247-40ac-9fba-d350ec1d3bad	32.99	30.94	32.99	21	1003	18.50	330	NNW	0.00	f	0.00	clear sky	2026-05-14 00:00:00+00	2026-05-14 00:00:26.74808+00
d94f88d7-183a-41d0-a0ab-38703af6d47e	72829d11-3ace-445b-9f4b-5c3c72c3521f	02158370-f247-40ac-9fba-d350ec1d3bad	17.02	16.12	17.19	72	1017	11.12	70	ENE	0.00	f	0.00	clear sky	2026-05-14 00:00:00+00	2026-05-14 00:00:27.034454+00
34eabc40-271f-4847-adad-73d275e43d18	5bd52475-ffa2-40f6-82e4-3d0491b7e246	02158370-f247-40ac-9fba-d350ec1d3bad	21.85	21.85	21.85	44	1014	33.84	59	ENE	47.38	f	0.00	broken clouds	2026-05-14 00:00:00+00	2026-05-14 00:00:27.369907+00
4d0cf33b-efb2-4221-b8a0-313d7be83124	467c145d-f635-4cb3-9813-63f4d28b8780	1e758198-0db2-483a-9b07-7c049503bb6b	25.42	25.23	25.42	50	1010	9.25	110	ESE	0.00	t	0.00	clear sky	2026-05-14 01:00:00+00	2026-05-14 01:00:28.141025+00
d11b82ad-e029-4c95-a10c-364b29e49bb1	f2df8134-8994-487c-8a25-272606e8f953	1e758198-0db2-483a-9b07-7c049503bb6b	25.60	25.60	25.60	14	1008	10.19	48	NE	12.96	t	0.00	clear sky	2026-05-14 01:00:00+00	2026-05-14 01:00:28.417477+00
10d782db-11ae-4733-98a0-79ce2bee2b27	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	1e758198-0db2-483a-9b07-7c049503bb6b	27.96	27.14	27.96	51	1002	11.12	200	SSW	0.00	t	0.00	clear sky	2026-05-14 01:00:00+00	2026-05-14 01:00:28.713423+00
ba9c7c6b-8971-455b-85d7-e1832d17555c	6411b387-fc37-4b47-878b-8f89fd8e08d9	1e758198-0db2-483a-9b07-7c049503bb6b	23.95	23.95	23.95	35	1005	7.42	290	WNW	0.00	f	0.00	clear sky	2026-05-14 01:00:00+00	2026-05-14 01:00:29.001346+00
3b61170d-9b43-4817-b0f0-a74a644aec5e	05546df7-881e-438f-96b9-be0148283901	1e758198-0db2-483a-9b07-7c049503bb6b	20.21	20.21	20.21	53	1009	16.52	206	SSW	21.06	t	0.00	clear sky	2026-05-14 01:00:00+00	2026-05-14 01:00:29.309194+00
abc9adf3-f9dc-4933-a287-a64baf38e123	054b54c2-e6d1-4534-a9de-58bf2831479a	1e758198-0db2-483a-9b07-7c049503bb6b	20.05	13.75	20.05	28	1013	0.00	0	N	0.00	f	0.00	clear sky	2026-05-14 01:00:00+00	2026-05-14 01:00:29.600534+00
94ec07ba-f0d8-4763-82b8-d51ccab08240	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	1e758198-0db2-483a-9b07-7c049503bb6b	32.10	32.10	32.10	27	1003	14.22	234	SW	20.74	f	0.00	clear sky	2026-05-14 01:00:00+00	2026-05-14 01:00:29.892113+00
70ca128d-2b00-480c-bd34-33678f40abfa	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	1e758198-0db2-483a-9b07-7c049503bb6b	32.99	30.94	32.99	21	1003	18.50	330	NNW	0.00	f	0.00	clear sky	2026-05-14 01:00:00+00	2026-05-14 01:00:30.167215+00
01ac4e6c-1375-47a1-a060-87f5295463bc	72829d11-3ace-445b-9f4b-5c3c72c3521f	1e758198-0db2-483a-9b07-7c049503bb6b	17.02	16.12	17.19	72	1017	11.12	80	E	0.00	f	0.00	clear sky	2026-05-14 01:00:00+00	2026-05-14 01:00:30.447177+00
8fc35df2-bb2f-46e9-80be-5882b2a8f8fe	5bd52475-ffa2-40f6-82e4-3d0491b7e246	1e758198-0db2-483a-9b07-7c049503bb6b	21.06	21.06	21.06	46	1014	32.26	68	ENE	49.25	t	0.00	clear sky	2026-05-14 01:00:00+00	2026-05-14 01:00:30.714241+00
093626a9-37fc-4d0c-b092-137d7eb6e652	467c145d-f635-4cb3-9813-63f4d28b8780	7012d403-5e48-41b3-9e20-dfab87d613b3	25.42	25.23	25.42	47	1010	11.12	130	SE	0.00	t	0.00	clear sky	2026-05-14 02:00:00+00	2026-05-14 02:00:31.488371+00
d28a3e41-fc8f-4f99-bc32-04825fa1a890	f2df8134-8994-487c-8a25-272606e8f953	7012d403-5e48-41b3-9e20-dfab87d613b3	25.39	25.39	25.39	15	1008	7.27	52	NE	8.21	t	0.00	clear sky	2026-05-14 02:00:00+00	2026-05-14 02:00:31.754408+00
e32cd864-e09b-4838-bc5d-7e48d0029865	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	7012d403-5e48-41b3-9e20-dfab87d613b3	26.96	26.96	27.14	54	1002	12.96	200	SSW	0.00	t	0.00	clear sky	2026-05-14 02:00:00+00	2026-05-14 02:00:32.038921+00
48ceb004-f484-496e-a134-4a9acd888fee	6411b387-fc37-4b47-878b-8f89fd8e08d9	7012d403-5e48-41b3-9e20-dfab87d613b3	21.95	21.95	21.95	43	1006	12.96	320	NW	0.00	t	0.00	clear sky	2026-05-14 02:00:00+00	2026-05-14 02:00:32.31108+00
02075fb9-c983-41ef-aa75-e4977e07b7e7	05546df7-881e-438f-96b9-be0148283901	7012d403-5e48-41b3-9e20-dfab87d613b3	20.77	20.77	20.77	53	1009	17.68	206	SSW	22.21	t	0.00	clear sky	2026-05-14 02:00:00+00	2026-05-14 02:00:32.5859+00
354e62c0-5ba4-40dc-958a-d189c306e77b	054b54c2-e6d1-4534-a9de-58bf2831479a	7012d403-5e48-41b3-9e20-dfab87d613b3	19.05	13.75	19.05	30	1012	11.12	240	WSW	0.00	f	0.00	clear sky	2026-05-14 02:00:00+00	2026-05-14 02:00:32.904826+00
a9579dd6-3d70-41e9-a2c4-dfa76dfd28b0	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	7012d403-5e48-41b3-9e20-dfab87d613b3	30.44	30.44	30.44	29	1004	18.14	276	W	28.84	f	0.00	clear sky	2026-05-14 02:00:00+00	2026-05-14 02:00:33.188616+00
818f4ca0-2924-4225-b544-b834639f7fbf	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	7012d403-5e48-41b3-9e20-dfab87d613b3	29.94	27.17	29.94	30	1003	18.50	330	NNW	0.00	t	0.00	clear sky	2026-05-14 02:00:00+00	2026-05-14 02:00:33.467673+00
1a960921-673d-40ce-8b22-9bfbeba10f3d	72829d11-3ace-445b-9f4b-5c3c72c3521f	7012d403-5e48-41b3-9e20-dfab87d613b3	17.02	15.12	17.19	77	1016	9.25	80	E	0.00	f	0.00	clear sky	2026-05-14 02:00:00+00	2026-05-14 02:00:33.774941+00
52230e93-e945-47d2-9d44-dab7acc563b5	5bd52475-ffa2-40f6-82e4-3d0491b7e246	7012d403-5e48-41b3-9e20-dfab87d613b3	20.33	20.33	20.33	49	1014	29.45	72	ENE	44.60	t	0.00	broken clouds	2026-05-14 02:00:00+00	2026-05-14 02:00:34.067636+00
d73a349c-300c-4282-8846-be52c945f5fb	467c145d-f635-4cb3-9813-63f4d28b8780	d803f557-ba48-474e-833c-c6042b7662de	28.42	28.42	28.42	30	1011	9.25	350	N	0.00	t	0.00	clear sky	2026-05-16 12:00:00+00	2026-05-16 12:00:40.437447+00
5558c517-d155-48e1-86e5-15a283e0bef8	f2df8134-8994-487c-8a25-272606e8f953	d803f557-ba48-474e-833c-c6042b7662de	41.28	41.28	41.28	5	1001	24.23	274	W	27.61	f	0.00	clear sky	2026-05-16 12:00:00+00	2026-05-16 12:00:41.167571+00
d7167542-e547-4aa2-af5d-2820d41f11e3	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	d803f557-ba48-474e-833c-c6042b7662de	34.96	34.14	34.96	46	1001	18.50	310	NW	0.00	t	0.00	clear sky	2026-05-16 12:00:00+00	2026-05-16 12:00:41.492745+00
7efcfcb6-6529-4653-8980-9bd5388300f5	6411b387-fc37-4b47-878b-8f89fd8e08d9	d803f557-ba48-474e-833c-c6042b7662de	28.95	28.95	28.95	26	1002	33.34	280	W	0.00	t	0.00	clear sky	2026-05-16 12:00:00+00	2026-05-16 12:00:41.877319+00
fa4000fb-281f-4d33-b428-b65e9b97a6ae	05546df7-881e-438f-96b9-be0148283901	d803f557-ba48-474e-833c-c6042b7662de	20.21	20.21	20.21	81	1011	26.89	221	SW	26.17	t	0.00	clear sky	2026-05-16 12:00:00+00	2026-05-16 12:00:42.431466+00
a62ac220-a956-43c9-ac5e-4407896a7bf1	054b54c2-e6d1-4534-a9de-58bf2831479a	d803f557-ba48-474e-833c-c6042b7662de	22.05	20.75	22.05	40	1011	25.92	270	W	0.00	t	0.00	haze	2026-05-16 12:00:00+00	2026-05-16 12:00:43.150492+00
2aefbe96-ab6e-44c7-9545-bd15adbebab0	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	d803f557-ba48-474e-833c-c6042b7662de	38.21	38.21	38.21	18	1000	14.69	285	WNW	19.66	f	0.00	scattered clouds	2026-05-16 12:00:00+00	2026-05-16 12:00:43.864159+00
060114fd-e88f-45ff-ba74-85f5c41d3c36	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	d803f557-ba48-474e-833c-c6042b7662de	34.99	34.99	36.94	31	1001	18.50	110	ESE	0.00	t	0.00	clear sky	2026-05-16 12:00:00+00	2026-05-16 12:00:44.555639+00
cdd450bf-7f18-4da1-a79a-9e820115fbab	72829d11-3ace-445b-9f4b-5c3c72c3521f	d803f557-ba48-474e-833c-c6042b7662de	17.19	17.12	17.19	88	1016	5.54	270	W	0.00	t	0.00	moderate rain	2026-05-16 12:00:00+00	2026-05-16 12:00:45.250688+00
b642f2fb-f48d-490b-b6cc-e22863c6499a	5bd52475-ffa2-40f6-82e4-3d0491b7e246	d803f557-ba48-474e-833c-c6042b7662de	28.30	28.30	28.30	31	1010	26.17	72	ENE	23.69	t	0.00	overcast clouds	2026-05-16 12:00:00+00	2026-05-16 12:00:45.923325+00
c78e7793-9efd-4d7c-9e60-4e075f33bad0	467c145d-f635-4cb3-9813-63f4d28b8780	2c175f12-51f1-4bbd-adf2-0067a9ba75f1	29.42	29.42	29.42	28	1010	11.12	320	NW	0.00	t	0.00	clear sky	2026-05-16 13:00:00+00	2026-05-16 13:00:35.507431+00
4b8219ae-2441-417b-b58c-bef8a7566cf0	f2df8134-8994-487c-8a25-272606e8f953	2c175f12-51f1-4bbd-adf2-0067a9ba75f1	41.30	41.30	41.30	5	1001	27.90	281	W	29.34	f	0.00	clear sky	2026-05-16 13:00:00+00	2026-05-16 13:00:38.090442+00
6b32aacd-ae46-4b58-80c6-9157f738dc22	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	2c175f12-51f1-4bbd-adf2-0067a9ba75f1	33.96	33.14	33.96	49	1001	16.67	330	NNW	0.00	t	0.00	clear sky	2026-05-16 13:00:00+00	2026-05-16 13:00:40.625814+00
5737a327-b239-418d-849a-3d060e65f0a1	6411b387-fc37-4b47-878b-8f89fd8e08d9	2c175f12-51f1-4bbd-adf2-0067a9ba75f1	29.95	29.95	29.95	23	1002	33.34	260	W	0.00	f	0.00	few clouds	2026-05-16 13:00:00+00	2026-05-16 13:00:43.823014+00
80965abb-f14a-461d-b02f-f8cce241ad2f	05546df7-881e-438f-96b9-be0148283901	2c175f12-51f1-4bbd-adf2-0067a9ba75f1	21.32	21.32	21.32	81	1011	26.39	219	SW	26.03	t	0.00	clear sky	2026-05-16 13:00:00+00	2026-05-16 13:00:45.352737+00
49b92047-3b8e-459c-8b4f-c2779c96511b	054b54c2-e6d1-4534-a9de-58bf2831479a	2c175f12-51f1-4bbd-adf2-0067a9ba75f1	22.05	22.05	22.75	43	1011	27.79	280	W	0.00	f	0.00	scattered clouds	2026-05-16 13:00:00+00	2026-05-16 13:00:46.948781+00
c60a23ab-7d24-40a1-b126-ba208d0e65a3	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	2c175f12-51f1-4bbd-adf2-0067a9ba75f1	33.05	33.05	33.05	22	1000	28.80	293	WNW	31.82	f	0.00	clear sky	2026-05-16 13:00:00+00	2026-05-16 13:00:48.626089+00
b2bee4ff-d9cd-4be6-8556-73a13306f7f8	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	2c175f12-51f1-4bbd-adf2-0067a9ba75f1	34.99	34.99	35.94	28	1000	20.38	100	E	0.00	t	0.00	clear sky	2026-05-16 13:00:00+00	2026-05-16 13:00:50.322252+00
c70e982e-be57-4eaf-939b-4f26683f6193	72829d11-3ace-445b-9f4b-5c3c72c3521f	2c175f12-51f1-4bbd-adf2-0067a9ba75f1	18.19	18.19	19.12	88	1016	3.71	0	N	0.00	t	0.00	broken clouds	2026-05-16 13:00:00+00	2026-05-16 13:00:52.727163+00
09e66201-e156-4208-b433-4ed1b2c507c1	5bd52475-ffa2-40f6-82e4-3d0491b7e246	2c175f12-51f1-4bbd-adf2-0067a9ba75f1	28.46	28.46	28.46	31	1009	32.44	77	ENE	25.96	t	0.00	overcast clouds	2026-05-16 13:00:00+00	2026-05-16 13:00:56.301189+00
5891ade4-b90b-45ed-8f68-48c1f83d06ff	467c145d-f635-4cb3-9813-63f4d28b8780	4cdef1f9-df68-45a0-9ead-b5f1f0569d53	30.42	30.42	30.42	26	1009	11.12	340	NNW	0.00	f	0.00	clear sky	2026-05-16 14:00:00+00	2026-05-16 14:00:57.047381+00
f566c062-3c2c-4301-81f8-531b83420517	f2df8134-8994-487c-8a25-272606e8f953	4cdef1f9-df68-45a0-9ead-b5f1f0569d53	40.60	40.60	40.60	5	1001	26.96	289	WNW	27.65	f	0.00	clear sky	2026-05-16 14:00:00+00	2026-05-16 14:00:57.367647+00
cdc89380-3d68-4224-b106-ff2d3af5aa52	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	4cdef1f9-df68-45a0-9ead-b5f1f0569d53	32.96	32.96	33.14	52	1001	18.50	320	NW	0.00	t	0.00	clear sky	2026-05-16 14:00:00+00	2026-05-16 14:00:57.694149+00
d8838488-2109-4b5a-a041-a4d0c6ecdb92	6411b387-fc37-4b47-878b-8f89fd8e08d9	4cdef1f9-df68-45a0-9ead-b5f1f0569d53	29.95	29.95	29.95	23	1002	29.63	270	W	0.00	f	0.00	scattered clouds	2026-05-16 14:00:00+00	2026-05-16 14:00:58.01727+00
71e2d47c-5573-43cd-9d80-884575f0c352	05546df7-881e-438f-96b9-be0148283901	4cdef1f9-df68-45a0-9ead-b5f1f0569d53	21.32	21.32	21.32	79	1011	24.77	215	SW	24.16	t	0.00	clear sky	2026-05-16 14:00:00+00	2026-05-16 14:00:58.324453+00
6a14754f-5b3f-4ded-ba54-ea0e4e8198ff	054b54c2-e6d1-4534-a9de-58bf2831479a	4cdef1f9-df68-45a0-9ead-b5f1f0569d53	22.05	21.75	22.05	43	1011	27.79	280	W	0.00	t	0.00	scattered clouds	2026-05-16 14:00:00+00	2026-05-16 14:00:58.712592+00
8b379c51-dda2-40d6-ad62-ac46990b7eb6	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	4cdef1f9-df68-45a0-9ead-b5f1f0569d53	37.10	37.10	37.10	16	1000	31.54	290	WNW	34.06	f	0.00	few clouds	2026-05-16 14:00:00+00	2026-05-16 14:00:59.02492+00
295d08b7-3534-44e6-915a-192277e733c9	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	4cdef1f9-df68-45a0-9ead-b5f1f0569d53	33.99	33.99	34.94	36	1000	20.38	130	SE	0.00	t	0.00	clear sky	2026-05-16 14:00:00+00	2026-05-16 14:00:59.353701+00
2f44b898-052d-444a-977d-5a0e6bb98407	72829d11-3ace-445b-9f4b-5c3c72c3521f	4cdef1f9-df68-45a0-9ead-b5f1f0569d53	19.19	19.19	21.12	77	1016	5.54	350	N	0.00	t	0.00	broken clouds	2026-05-16 14:00:00+00	2026-05-16 14:00:59.66245+00
acd5ce5b-25cc-46b0-b359-167920f97837	5bd52475-ffa2-40f6-82e4-3d0491b7e246	4cdef1f9-df68-45a0-9ead-b5f1f0569d53	28.95	28.95	28.95	31	1008	35.89	74	ENE	27.97	t	0.00	overcast clouds	2026-05-16 14:00:00+00	2026-05-16 14:00:59.991028+00
a2319e83-82d1-4bbf-9c2c-5577736ebf01	467c145d-f635-4cb3-9813-63f4d28b8780	460c6b3b-ea8d-425f-b05f-d5605e9f6415	30.42	30.42	30.42	25	1009	11.12	320	NW	0.00	f	0.00	clear sky	2026-05-16 15:00:00+00	2026-05-16 15:00:18.177595+00
8b0d0ae9-2149-4804-8b6a-92a1987c3b6f	f2df8134-8994-487c-8a25-272606e8f953	460c6b3b-ea8d-425f-b05f-d5605e9f6415	39.07	39.07	39.07	6	1001	30.60	293	WNW	38.95	f	0.00	clear sky	2026-05-16 15:00:00+00	2026-05-16 15:00:18.513805+00
6c5de7f9-7f2c-4617-8e3d-210753ca1ae6	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	460c6b3b-ea8d-425f-b05f-d5605e9f6415	31.96	31.96	32.14	58	1001	11.12	310	NW	0.00	t	0.00	clear sky	2026-05-16 15:00:00+00	2026-05-16 15:00:18.846134+00
c9d75fa2-3e58-4182-8b57-46c8c4164b1e	6411b387-fc37-4b47-878b-8f89fd8e08d9	460c6b3b-ea8d-425f-b05f-d5605e9f6415	29.95	29.95	29.95	21	1002	29.63	280	W	0.00	f	0.00	few clouds	2026-05-16 15:00:00+00	2026-05-16 15:00:19.165225+00
eb5c4d39-ac8d-4837-a2bc-f9c17793fb05	05546df7-881e-438f-96b9-be0148283901	460c6b3b-ea8d-425f-b05f-d5605e9f6415	20.77	20.77	20.77	81	1011	24.52	212	SSW	24.70	t	0.00	clear sky	2026-05-16 15:00:00+00	2026-05-16 15:00:19.472939+00
b7f0e13a-ee7b-4e43-9794-5748c26a226c	054b54c2-e6d1-4534-a9de-58bf2831479a	460c6b3b-ea8d-425f-b05f-d5605e9f6415	22.05	21.75	22.05	40	1011	27.79	280	W	0.00	t	0.00	scattered clouds	2026-05-16 15:00:00+00	2026-05-16 15:00:19.773846+00
6c5a477f-99f3-46cf-9ffd-fdc8d3af76cf	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	460c6b3b-ea8d-425f-b05f-d5605e9f6415	35.99	35.99	35.99	19	1000	33.80	294	WNW	36.58	f	0.00	few clouds	2026-05-16 15:00:00+00	2026-05-16 15:00:20.080739+00
f686bb5b-057f-4020-b776-947fcd7b72c6	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	460c6b3b-ea8d-425f-b05f-d5605e9f6415	33.99	33.94	33.99	24	1000	20.38	140	SE	0.00	f	0.00	clear sky	2026-05-16 15:00:00+00	2026-05-16 15:00:20.384464+00
e5b801eb-d7cf-4aad-9189-8f3eb2cfdb94	72829d11-3ace-445b-9f4b-5c3c72c3521f	460c6b3b-ea8d-425f-b05f-d5605e9f6415	19.19	19.19	22.12	77	1016	11.12	330	NNW	0.00	t	0.00	broken clouds	2026-05-16 15:00:00+00	2026-05-16 15:00:20.707062+00
8f0f2732-6fd4-4639-b869-c49903cd931a	5bd52475-ffa2-40f6-82e4-3d0491b7e246	460c6b3b-ea8d-425f-b05f-d5605e9f6415	28.52	28.52	28.52	32	1009	30.49	84	E	26.82	t	0.00	overcast clouds	2026-05-16 15:00:00+00	2026-05-16 15:00:21.01195+00
b5f31861-32fe-47bd-b7b5-c55e8faa7024	467c145d-f635-4cb3-9813-63f4d28b8780	3eb9f79c-b19d-4a02-a70d-1c6557a5125b	30.42	30.23	30.42	26	1010	18.50	330	NNW	0.00	f	0.00	clear sky	2026-05-16 16:00:00+00	2026-05-16 16:00:21.693869+00
2d48b112-77eb-4e25-b253-9c31af4d0c64	f2df8134-8994-487c-8a25-272606e8f953	3eb9f79c-b19d-4a02-a70d-1c6557a5125b	36.81	36.81	36.81	7	1003	31.82	322	NW	47.16	f	0.00	clear sky	2026-05-16 16:00:00+00	2026-05-16 16:00:21.961975+00
be5e44c6-576c-4edf-8abd-94c81bfa4c00	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	3eb9f79c-b19d-4a02-a70d-1c6557a5125b	30.96	30.96	31.14	62	1002	9.25	300	WNW	0.00	t	0.00	clear sky	2026-05-16 16:00:00+00	2026-05-16 16:00:22.229849+00
4b066557-a8dc-47fc-9aa2-0608d843f062	6411b387-fc37-4b47-878b-8f89fd8e08d9	3eb9f79c-b19d-4a02-a70d-1c6557a5125b	29.95	29.95	29.95	20	1002	22.21	290	WNW	0.00	f	0.00	few clouds	2026-05-16 16:00:00+00	2026-05-16 16:00:22.523478+00
0aec2caf-aba8-4c6b-b161-a22342eb49f4	05546df7-881e-438f-96b9-be0148283901	3eb9f79c-b19d-4a02-a70d-1c6557a5125b	20.21	20.21	20.21	81	1011	22.54	207	SSW	23.18	t	0.00	clear sky	2026-05-16 16:00:00+00	2026-05-16 16:00:22.794927+00
fe29ec91-709c-4024-923f-266f2bd85a1b	054b54c2-e6d1-4534-a9de-58bf2831479a	3eb9f79c-b19d-4a02-a70d-1c6557a5125b	21.05	20.75	21.05	40	1011	22.21	280	W	0.00	t	0.00	few clouds	2026-05-16 16:00:00+00	2026-05-16 16:00:23.059231+00
79f695de-ba80-4b8c-a6aa-30f6e88ec645	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	3eb9f79c-b19d-4a02-a70d-1c6557a5125b	33.77	33.77	33.77	26	1001	32.83	300	WNW	36.79	f	0.00	clear sky	2026-05-16 16:00:00+00	2026-05-16 16:00:23.342317+00
7806bfde-ee87-4122-a221-e8fd5b475840	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	3eb9f79c-b19d-4a02-a70d-1c6557a5125b	32.99	32.94	32.99	31	1001	14.83	160	SSE	0.00	f	0.00	clear sky	2026-05-16 16:00:00+00	2026-05-16 16:00:23.609683+00
8d33193f-0aed-4037-bf2b-7bd8b02e4d95	72829d11-3ace-445b-9f4b-5c3c72c3521f	3eb9f79c-b19d-4a02-a70d-1c6557a5125b	20.19	20.19	21.12	73	1016	11.12	340	NNW	0.00	t	0.00	broken clouds	2026-05-16 16:00:00+00	2026-05-16 16:00:23.877434+00
bea07c32-aa96-49ed-9e7f-4592e2ce2903	5bd52475-ffa2-40f6-82e4-3d0491b7e246	3eb9f79c-b19d-4a02-a70d-1c6557a5125b	27.06	27.06	27.06	35	1010	31.00	93	E	30.38	t	0.00	overcast clouds	2026-05-16 16:00:00+00	2026-05-16 16:00:24.150475+00
1b71e663-0bdd-4bbf-b278-a65d5913dcc4	467c145d-f635-4cb3-9813-63f4d28b8780	a710fe2f-f770-4e7b-be7e-0833b6d7dca9	29.42	29.12	29.42	28	1010	12.96	300	WNW	0.00	t	0.00	clear sky	2026-05-16 17:00:00+00	2026-05-16 17:00:24.899571+00
03ed62f9-6acf-4ba7-b597-fe3af2c8bc2d	f2df8134-8994-487c-8a25-272606e8f953	a710fe2f-f770-4e7b-be7e-0833b6d7dca9	34.68	34.68	34.68	9	1004	33.05	344	NNW	49.14	f	0.00	clear sky	2026-05-16 17:00:00+00	2026-05-16 17:00:25.215267+00
690d1359-4bcb-4802-a113-1b265f221542	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	a710fe2f-f770-4e7b-be7e-0833b6d7dca9	30.96	30.14	30.96	62	1002	5.54	250	WSW	0.00	t	0.00	clear sky	2026-05-16 17:00:00+00	2026-05-16 17:00:25.510019+00
59277a1b-a9d3-48af-888e-832b9cd21675	6411b387-fc37-4b47-878b-8f89fd8e08d9	a710fe2f-f770-4e7b-be7e-0833b6d7dca9	28.95	28.95	28.95	20	1003	20.38	280	W	0.00	t	0.00	few clouds	2026-05-16 17:00:00+00	2026-05-16 17:00:25.813798+00
53e3dd7c-8bea-464b-8e7a-02fb8a6512d9	05546df7-881e-438f-96b9-be0148283901	a710fe2f-f770-4e7b-be7e-0833b6d7dca9	18.54	18.54	18.54	81	1011	21.42	208	SSW	21.74	t	0.00	clear sky	2026-05-16 17:00:00+00	2026-05-16 17:00:26.121292+00
e6c5f718-d0cb-4b08-868b-e42e8d14f50c	054b54c2-e6d1-4534-a9de-58bf2831479a	a710fe2f-f770-4e7b-be7e-0833b6d7dca9	20.05	19.75	20.05	42	1012	22.21	300	WNW	0.00	t	0.00	clear sky	2026-05-16 17:00:00+00	2026-05-16 17:00:26.410576+00
7992f233-a0f8-46f5-ab33-bcfe7aa9944b	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	a710fe2f-f770-4e7b-be7e-0833b6d7dca9	32.66	32.66	32.66	30	1002	34.70	321	NW	41.94	f	0.00	few clouds	2026-05-16 17:00:00+00	2026-05-16 17:00:26.714042+00
89d66cb8-b6b8-4f93-90bf-25691149c4a4	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	a710fe2f-f770-4e7b-be7e-0833b6d7dca9	32.97	32.94	35.17	31	1001	11.12	120	ESE	0.00	t	0.00	clear sky	2026-05-16 17:00:00+00	2026-05-16 17:00:27.010602+00
28cf9f33-a73d-4b7b-bbe1-0c07d2d8133a	72829d11-3ace-445b-9f4b-5c3c72c3521f	a710fe2f-f770-4e7b-be7e-0833b6d7dca9	20.19	20.19	21.12	68	1016	9.25	350	N	0.00	t	0.00	broken clouds	2026-05-16 17:00:00+00	2026-05-16 17:00:27.306867+00
88366110-cd93-4353-b3b9-b25d1da7e065	5bd52475-ffa2-40f6-82e4-3d0491b7e246	a710fe2f-f770-4e7b-be7e-0833b6d7dca9	24.21	24.21	24.21	43	1010	35.82	89	E	37.44	t	0.00	overcast clouds	2026-05-16 17:00:00+00	2026-05-16 17:00:27.612198+00
0680f5a4-01a5-414f-bd14-66cf4add3bd3	467c145d-f635-4cb3-9813-63f4d28b8780	ad07997a-0709-45e7-9563-72fb246624f7	28.42	28.01	28.42	30	1011	11.12	330	NNW	0.00	t	0.00	clear sky	2026-05-16 18:00:00+00	2026-05-16 18:00:28.31364+00
e2ad78e2-0ebf-43b2-a747-3259f86c91e1	f2df8134-8994-487c-8a25-272606e8f953	ad07997a-0709-45e7-9563-72fb246624f7	33.38	33.38	33.38	11	1005	32.62	349	N	50.87	f	0.00	clear sky	2026-05-16 18:00:00+00	2026-05-16 18:00:28.61042+00
e99adf26-e5e7-4577-b10a-55659a390543	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	ad07997a-0709-45e7-9563-72fb246624f7	30.96	29.14	30.96	66	1003	7.42	250	WSW	0.00	t	0.00	clear sky	2026-05-16 18:00:00+00	2026-05-16 18:00:28.927981+00
fd47163f-64d8-4aeb-bccb-d3a9251dfec0	6411b387-fc37-4b47-878b-8f89fd8e08d9	ad07997a-0709-45e7-9563-72fb246624f7	26.95	26.95	26.95	24	1004	9.25	290	WNW	0.00	f	0.00	few clouds	2026-05-16 18:00:00+00	2026-05-16 18:00:29.244868+00
15e230c6-09ff-4d06-b7e5-227b25ae2949	05546df7-881e-438f-96b9-be0148283901	ad07997a-0709-45e7-9563-72fb246624f7	17.99	17.99	17.99	79	1011	19.76	207	SSW	19.48	t	0.00	clear sky	2026-05-16 18:00:00+00	2026-05-16 18:00:29.544315+00
50a9dea2-5ba0-4dc4-a73f-991d927d6c14	054b54c2-e6d1-4534-a9de-58bf2831479a	ad07997a-0709-45e7-9563-72fb246624f7	19.05	17.75	19.05	48	1013	18.50	320	NW	0.00	t	0.00	clear sky	2026-05-16 18:00:00+00	2026-05-16 18:00:29.862597+00
53963d2f-94d4-428f-b551-7facc01439a1	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	ad07997a-0709-45e7-9563-72fb246624f7	31.55	31.55	31.55	29	1003	31.93	344	NNW	40.72	t	0.00	few clouds	2026-05-16 18:00:00+00	2026-05-16 18:00:30.162401+00
2366f2ef-9453-417f-bb4a-17fed32e03b9	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	ad07997a-0709-45e7-9563-72fb246624f7	31.97	31.94	33.17	40	1001	11.12	120	ESE	0.00	f	0.00	clear sky	2026-05-16 18:00:00+00	2026-05-16 18:00:30.45921+00
5d281444-9173-4c43-a722-13722783b2e2	72829d11-3ace-445b-9f4b-5c3c72c3521f	ad07997a-0709-45e7-9563-72fb246624f7	19.19	19.19	21.12	72	1016	11.12	350	N	0.00	t	0.00	broken clouds	2026-05-16 18:00:00+00	2026-05-16 18:00:30.759396+00
930ada8e-fd77-4f9b-86f4-4fe3fe9653da	5bd52475-ffa2-40f6-82e4-3d0491b7e246	ad07997a-0709-45e7-9563-72fb246624f7	22.68	22.68	22.68	48	1011	40.50	88	E	48.67	t	0.00	overcast clouds	2026-05-16 18:00:00+00	2026-05-16 18:00:31.059674+00
2ac7dfcc-ba92-408b-883f-f87c2d4cfd3a	467c145d-f635-4cb3-9813-63f4d28b8780	0325735a-ee33-482f-a385-0b4fc3faa8a7	28.42	28.01	28.42	30	1012	11.12	0	N	0.00	t	0.00	clear sky	2026-05-16 19:00:00+00	2026-05-16 19:00:31.78991+00
7d3715bb-139b-4997-96c2-c822c7d61da5	f2df8134-8994-487c-8a25-272606e8f953	0325735a-ee33-482f-a385-0b4fc3faa8a7	32.06	32.06	32.06	11	1006	31.72	352	N	48.78	f	0.00	clear sky	2026-05-16 19:00:00+00	2026-05-16 19:00:32.088687+00
7604522f-ce86-47a6-a954-39ba667d1683	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	0325735a-ee33-482f-a385-0b4fc3faa8a7	30.96	29.14	30.96	66	1003	3.71	0	N	0.00	t	0.00	clear sky	2026-05-16 19:00:00+00	2026-05-16 19:00:32.386416+00
392b3b6b-86a1-4af5-aa0c-d6127a92e2e1	6411b387-fc37-4b47-878b-8f89fd8e08d9	0325735a-ee33-482f-a385-0b4fc3faa8a7	26.95	26.95	26.95	24	1004	9.25	290	WNW	0.00	f	0.00	few clouds	2026-05-16 19:00:00+00	2026-05-16 19:00:32.682211+00
b421cc44-066c-4e40-8071-ec4978e98feb	05546df7-881e-438f-96b9-be0148283901	0325735a-ee33-482f-a385-0b4fc3faa8a7	17.43	17.43	17.43	77	1012	23.15	208	SSW	23.11	t	0.00	clear sky	2026-05-16 19:00:00+00	2026-05-16 19:00:33.334734+00
eb9d1aee-bc93-465b-8e78-efe966fc6044	054b54c2-e6d1-4534-a9de-58bf2831479a	0325735a-ee33-482f-a385-0b4fc3faa8a7	17.05	17.05	17.75	59	1013	14.83	310	NW	0.00	t	0.00	clear sky	2026-05-16 19:00:00+00	2026-05-16 19:00:33.646822+00
3fdaee83-2d9b-4edb-bb5e-b7a2bbde6aa3	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	0325735a-ee33-482f-a385-0b4fc3faa8a7	30.99	30.99	30.99	28	1004	31.72	335	NNW	42.16	f	0.00	clear sky	2026-05-16 19:00:00+00	2026-05-16 19:00:33.942443+00
8c87489f-dc79-495f-9313-485c583c016a	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	0325735a-ee33-482f-a385-0b4fc3faa8a7	31.38	30.99	32.17	46	1001	14.83	140	SE	0.00	f	0.00	clear sky	2026-05-16 19:00:00+00	2026-05-16 19:00:34.269591+00
c68c3ffd-0460-4666-9628-c3b2fb7d0f89	72829d11-3ace-445b-9f4b-5c3c72c3521f	0325735a-ee33-482f-a385-0b4fc3faa8a7	19.19	19.12	19.19	68	1016	9.25	350	N	0.00	t	0.00	broken clouds	2026-05-16 19:00:00+00	2026-05-16 19:00:34.597339+00
d56a0264-3146-42b2-9b11-d18997116061	5bd52475-ffa2-40f6-82e4-3d0491b7e246	0325735a-ee33-482f-a385-0b4fc3faa8a7	21.29	21.29	21.29	54	1012	41.29	86	E	52.24	t	0.00	overcast clouds	2026-05-16 19:00:00+00	2026-05-16 19:00:34.909159+00
e78a3f77-1381-4e75-beff-c76c4dff08db	467c145d-f635-4cb3-9813-63f4d28b8780	210f81a1-077f-49f6-873c-fdde63274b42	28.42	28.42	28.42	32	1012	7.42	30	NNE	0.00	t	0.00	clear sky	2026-05-16 20:00:00+00	2026-05-16 20:00:35.763355+00
dc5b5814-0328-438e-bb9f-7e684c5c47f8	f2df8134-8994-487c-8a25-272606e8f953	210f81a1-077f-49f6-873c-fdde63274b42	30.61	30.61	30.61	10	1006	27.14	358	N	45.14	f	0.00	clear sky	2026-05-16 20:00:00+00	2026-05-16 20:00:36.075864+00
2f3b77c7-1211-40bf-8852-18ace1b1d994	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	210f81a1-077f-49f6-873c-fdde63274b42	30.96	28.14	30.96	66	1003	5.54	250	WSW	0.00	t	0.00	clear sky	2026-05-16 20:00:00+00	2026-05-16 20:00:36.373256+00
592e9272-6366-4290-894b-cab3d4dc9601	6411b387-fc37-4b47-878b-8f89fd8e08d9	210f81a1-077f-49f6-873c-fdde63274b42	25.95	25.95	25.95	27	1005	7.42	230	SW	0.00	t	0.00	clear sky	2026-05-16 20:00:00+00	2026-05-16 20:00:36.717318+00
19d34244-b104-4f4e-a2d2-5b28e6a1f56e	05546df7-881e-438f-96b9-be0148283901	210f81a1-077f-49f6-873c-fdde63274b42	16.88	16.88	16.88	74	1012	26.06	203	SSW	27.36	t	0.00	clear sky	2026-05-16 20:00:00+00	2026-05-16 20:00:37.03259+00
b3f08031-8b65-406c-9b82-9124dbe6bf96	054b54c2-e6d1-4534-a9de-58bf2831479a	210f81a1-077f-49f6-873c-fdde63274b42	16.05	15.75	16.05	67	1014	14.83	310	NW	0.00	t	0.00	clear sky	2026-05-16 20:00:00+00	2026-05-16 20:00:37.328309+00
b5850a85-4cff-4610-8361-2e40ab689660	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	210f81a1-077f-49f6-873c-fdde63274b42	29.88	29.88	29.88	32	1005	33.77	331	NNW	44.35	t	0.00	clear sky	2026-05-16 20:00:00+00	2026-05-16 20:00:37.626098+00
f0314ba2-e9ac-4486-9c99-0dae24c5e46f	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	210f81a1-077f-49f6-873c-fdde63274b42	30.38	29.99	32.17	55	1001	16.67	150	SSE	0.00	t	0.00	clear sky	2026-05-16 20:00:00+00	2026-05-16 20:00:37.925716+00
c71f48bb-2994-4836-804c-a378281968d0	72829d11-3ace-445b-9f4b-5c3c72c3521f	210f81a1-077f-49f6-873c-fdde63274b42	18.19	18.12	18.19	72	1017	7.42	0	N	0.00	t	0.00	broken clouds	2026-05-16 20:00:00+00	2026-05-16 20:00:38.213658+00
3ca1fd14-75ec-4be9-a0b3-4bba256f5b77	5bd52475-ffa2-40f6-82e4-3d0491b7e246	210f81a1-077f-49f6-873c-fdde63274b42	20.32	20.32	20.32	56	1013	38.74	80	E	50.83	t	0.00	broken clouds	2026-05-16 20:00:00+00	2026-05-16 20:00:38.510875+00
53655c98-7145-44c6-8b4b-c65718fa58ee	467c145d-f635-4cb3-9813-63f4d28b8780	1dccc4aa-0847-47bd-888d-955a7c53fe4d	26.42	25.79	26.42	31	1012	11.12	60	ENE	0.00	t	0.00	clear sky	2026-05-16 21:00:00+00	2026-05-16 21:00:39.230116+00
aa9ab3fd-cf3a-494c-9e05-80c2a429cb00	f2df8134-8994-487c-8a25-272606e8f953	1dccc4aa-0847-47bd-888d-955a7c53fe4d	29.23	29.23	29.23	10	1006	21.24	3	N	38.09	t	0.00	clear sky	2026-05-16 21:00:00+00	2026-05-16 21:00:39.495626+00
7b29486a-dd96-492e-8d68-8936eef27930	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	1dccc4aa-0847-47bd-888d-955a7c53fe4d	29.96	27.14	29.96	66	1002	3.71	200	SSW	0.00	t	0.00	clear sky	2026-05-16 21:00:00+00	2026-05-16 21:00:39.76233+00
87b69c65-c840-48e2-8171-1c8c6570bd57	6411b387-fc37-4b47-878b-8f89fd8e08d9	1dccc4aa-0847-47bd-888d-955a7c53fe4d	24.95	24.95	24.95	31	1004	11.12	260	W	0.00	t	0.00	clear sky	2026-05-16 21:00:00+00	2026-05-16 21:00:40.027722+00
e950cd1c-6040-4c1d-b22a-cc2488ad6581	05546df7-881e-438f-96b9-be0148283901	1dccc4aa-0847-47bd-888d-955a7c53fe4d	16.88	16.88	16.88	72	1012	23.72	201	SSW	26.28	t	0.00	clear sky	2026-05-16 21:00:00+00	2026-05-16 21:00:40.290367+00
6e396d46-218d-4e5d-bd9b-f85cd87a8618	054b54c2-e6d1-4534-a9de-58bf2831479a	1dccc4aa-0847-47bd-888d-955a7c53fe4d	16.05	14.75	16.05	55	1013	9.25	270	W	0.00	f	0.00	clear sky	2026-05-16 21:00:00+00	2026-05-16 21:00:40.555822+00
31908381-f535-4675-8ed3-ead87d3bd29d	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	1dccc4aa-0847-47bd-888d-955a7c53fe4d	29.32	29.32	29.32	35	1005	35.71	333	NNW	45.61	t	0.00	clear sky	2026-05-16 21:00:00+00	2026-05-16 21:00:40.828761+00
1e33bbf1-d258-477b-a1d5-f4a3d4c4a1a1	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	1dccc4aa-0847-47bd-888d-955a7c53fe4d	30.97	30.94	31.17	53	1000	16.67	150	SSE	0.00	t	0.00	clear sky	2026-05-16 21:00:00+00	2026-05-16 21:00:41.110644+00
49d6c951-4ac8-4de6-9406-525f3881cb16	72829d11-3ace-445b-9f4b-5c3c72c3521f	1dccc4aa-0847-47bd-888d-955a7c53fe4d	18.07	16.12	18.19	72	1017	7.42	0	N	0.00	f	0.00	clear sky	2026-05-16 21:00:00+00	2026-05-16 21:00:41.377676+00
d4c61c45-a750-470f-84f5-57fe3560d8c4	5bd52475-ffa2-40f6-82e4-3d0491b7e246	1dccc4aa-0847-47bd-888d-955a7c53fe4d	19.56	19.56	19.56	60	1012	46.73	84	E	61.09	t	0.00	scattered clouds	2026-05-16 21:00:00+00	2026-05-16 21:00:41.636737+00
920a40f0-295c-400c-83f0-b5f75b07e0de	467c145d-f635-4cb3-9813-63f4d28b8780	8ff101e1-6de4-4dd8-8ce9-bb655057d91c	25.42	25.23	25.42	33	1012	7.42	40	NE	0.00	t	0.00	clear sky	2026-05-16 22:00:00+00	2026-05-16 22:00:42.283739+00
b8b93bd9-bfef-400a-821b-95397912f9d6	f2df8134-8994-487c-8a25-272606e8f953	8ff101e1-6de4-4dd8-8ce9-bb655057d91c	28.25	28.25	28.25	11	1006	19.15	3	N	38.02	t	0.00	clear sky	2026-05-16 22:00:00+00	2026-05-16 22:00:42.544672+00
9e04c9c4-5891-4896-953f-bc2fb46eefbd	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	8ff101e1-6de4-4dd8-8ce9-bb655057d91c	29.96	27.14	29.96	66	1002	3.71	0	N	0.00	t	0.00	clear sky	2026-05-16 22:00:00+00	2026-05-16 22:00:42.822444+00
bb91d999-bef1-44f3-b71a-1ac2fee051fe	6411b387-fc37-4b47-878b-8f89fd8e08d9	8ff101e1-6de4-4dd8-8ce9-bb655057d91c	23.95	23.95	23.95	33	1004	7.42	240	WSW	0.00	f	0.00	scattered clouds	2026-05-16 22:00:00+00	2026-05-16 22:00:43.085159+00
a5b6c5f8-000a-4c79-b465-1ebbc8593731	05546df7-881e-438f-96b9-be0148283901	8ff101e1-6de4-4dd8-8ce9-bb655057d91c	15.77	15.77	15.77	71	1012	21.38	193	SSW	23.83	t	0.00	clear sky	2026-05-16 22:00:00+00	2026-05-16 22:00:43.345066+00
5488131d-9722-4d16-b5ef-255e2ce2c92a	054b54c2-e6d1-4534-a9de-58bf2831479a	8ff101e1-6de4-4dd8-8ce9-bb655057d91c	15.05	12.75	15.05	63	1013	5.54	320	NW	0.00	f	0.00	clear sky	2026-05-16 22:00:00+00	2026-05-16 22:00:43.607198+00
8da7d087-ea07-4be7-ac91-b0562afa9b03	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	8ff101e1-6de4-4dd8-8ce9-bb655057d91c	28.77	28.77	28.77	36	1005	31.50	337	NNW	41.65	t	0.00	clear sky	2026-05-16 22:00:00+00	2026-05-16 22:00:43.871912+00
f91bada8-92d1-414d-a5d5-b30780ed4993	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	8ff101e1-6de4-4dd8-8ce9-bb655057d91c	29.97	29.17	29.99	54	1000	12.96	150	SSE	0.00	t	0.00	clear sky	2026-05-16 22:00:00+00	2026-05-16 22:00:44.257756+00
1990ed04-5f82-490d-ae51-88014a053125	72829d11-3ace-445b-9f4b-5c3c72c3521f	8ff101e1-6de4-4dd8-8ce9-bb655057d91c	17.02	16.12	17.19	77	1018	9.25	10	N	0.00	f	0.00	clear sky	2026-05-16 22:00:00+00	2026-05-16 22:00:44.548221+00
a4c4c62a-46ef-49a9-92e3-6916bc074d81	5bd52475-ffa2-40f6-82e4-3d0491b7e246	8ff101e1-6de4-4dd8-8ce9-bb655057d91c	19.23	19.23	19.23	57	1012	46.19	74	ENE	59.69	t	0.00	broken clouds	2026-05-16 22:00:00+00	2026-05-16 22:00:44.80814+00
42a38184-3a25-45fa-be1f-ce3448dcf83c	467c145d-f635-4cb3-9813-63f4d28b8780	16fdda74-c5b2-4a35-8fd4-51a601487be1	24.42	24.42	25.23	50	1012	14.83	70	ENE	0.00	t	0.00	clear sky	2026-05-16 23:00:00+00	2026-05-16 23:02:35.69925+00
edea46ff-d698-48f3-9302-0cd27e07f195	f2df8134-8994-487c-8a25-272606e8f953	16fdda74-c5b2-4a35-8fd4-51a601487be1	27.35	27.35	27.35	11	1006	19.15	6	N	39.35	t	0.00	clear sky	2026-05-16 23:00:00+00	2026-05-16 23:02:36.134174+00
cf5e61dd-f637-4120-adde-767b4c02c722	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	16fdda74-c5b2-4a35-8fd4-51a601487be1	29.96	26.14	29.96	70	1002	5.54	70	ENE	0.00	t	0.00	clear sky	2026-05-16 23:00:00+00	2026-05-16 23:02:36.565651+00
f3650e9a-7f34-420a-8a9f-a3121d5e1476	6411b387-fc37-4b47-878b-8f89fd8e08d9	16fdda74-c5b2-4a35-8fd4-51a601487be1	22.95	22.95	22.95	35	1005	9.25	220	SW	0.00	f	0.00	clear sky	2026-05-16 23:00:00+00	2026-05-16 23:02:36.897611+00
1b6219af-b0ee-40dd-9eaa-f643098ea899	05546df7-881e-438f-96b9-be0148283901	16fdda74-c5b2-4a35-8fd4-51a601487be1	16.32	16.32	16.32	69	1011	18.50	205	SSW	20.20	t	0.00	clear sky	2026-05-16 23:00:00+00	2026-05-16 23:02:37.301678+00
66d18535-3541-4a5c-bc7f-018725ecc2cf	054b54c2-e6d1-4534-a9de-58bf2831479a	16fdda74-c5b2-4a35-8fd4-51a601487be1	15.05	12.75	15.05	55	1013	0.00	0	N	0.00	f	0.00	clear sky	2026-05-16 23:00:00+00	2026-05-16 23:02:38.105662+00
fc9da715-4e38-429a-b811-c873cbb104e3	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	16fdda74-c5b2-4a35-8fd4-51a601487be1	28.21	28.21	28.21	34	1006	25.67	345	NNW	37.55	t	0.00	clear sky	2026-05-16 23:00:00+00	2026-05-16 23:02:40.581189+00
3c36e541-cefd-419d-903e-8ab243240076	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	16fdda74-c5b2-4a35-8fd4-51a601487be1	29.97	28.17	29.99	58	1000	18.50	160	SSE	0.00	t	0.00	clear sky	2026-05-16 23:00:00+00	2026-05-16 23:02:41.156289+00
ba176505-852d-40a7-847c-29f7cc60796f	72829d11-3ace-445b-9f4b-5c3c72c3521f	16fdda74-c5b2-4a35-8fd4-51a601487be1	17.02	15.12	17.19	82	1018	9.25	20	NNE	0.00	f	0.00	clear sky	2026-05-16 23:00:00+00	2026-05-16 23:02:41.542517+00
b5ca3ce8-5059-4113-8b7f-c86be6e03775	5bd52475-ffa2-40f6-82e4-3d0491b7e246	16fdda74-c5b2-4a35-8fd4-51a601487be1	18.90	18.90	18.90	55	1012	42.34	74	ENE	57.46	t	0.00	broken clouds	2026-05-16 23:00:00+00	2026-05-16 23:02:41.898177+00
3838bb7c-be51-49f5-9a78-2191e916c587	467c145d-f635-4cb3-9813-63f4d28b8780	9b593afe-2c31-4998-ae13-ed7d8821af49	24.42	24.12	24.42	46	1011	9.25	80	E	0.00	t	0.00	clear sky	2026-05-17 00:00:00+00	2026-05-17 00:00:42.637376+00
56da31f6-acd2-4c37-b57b-16dc8972ca4e	f2df8134-8994-487c-8a25-272606e8f953	9b593afe-2c31-4998-ae13-ed7d8821af49	26.87	26.87	26.87	11	1007	19.87	13	NNE	38.88	f	0.00	clear sky	2026-05-17 00:00:00+00	2026-05-17 00:00:42.916024+00
68a481d5-c713-44e4-b66a-19dbe7008a14	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	9b593afe-2c31-4998-ae13-ed7d8821af49	29.96	26.14	29.96	70	1002	7.42	60	ENE	0.00	t	0.00	clear sky	2026-05-17 00:00:00+00	2026-05-17 00:00:43.1861+00
77f005bb-1f2e-4b8c-aa5b-ea900c847f06	6411b387-fc37-4b47-878b-8f89fd8e08d9	9b593afe-2c31-4998-ae13-ed7d8821af49	21.95	21.95	21.95	37	1005	12.96	250	WSW	0.00	t	0.00	clear sky	2026-05-17 00:00:00+00	2026-05-17 00:00:43.452996+00
17d76dc8-99c5-4391-b122-617d66fb9fa5	05546df7-881e-438f-96b9-be0148283901	9b593afe-2c31-4998-ae13-ed7d8821af49	15.21	15.21	15.21	69	1012	20.38	212	SSW	21.85	t	0.00	few clouds	2026-05-17 00:00:00+00	2026-05-17 00:00:43.722839+00
811a4ad4-e630-4386-a32d-cf05b78f548a	054b54c2-e6d1-4534-a9de-58bf2831479a	9b593afe-2c31-4998-ae13-ed7d8821af49	14.05	11.75	14.05	62	1013	0.00	0	N	0.00	f	0.00	clear sky	2026-05-17 00:00:00+00	2026-05-17 00:00:43.986682+00
bcbe6c01-aa04-453d-b8d8-9586df4cad0a	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	9b593afe-2c31-4998-ae13-ed7d8821af49	27.66	27.66	27.66	36	1006	19.48	356	N	30.06	t	0.00	clear sky	2026-05-17 00:00:00+00	2026-05-17 00:00:44.255161+00
22ea409c-43bd-4a56-9e8a-6499b9ea9b4b	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	9b593afe-2c31-4998-ae13-ed7d8821af49	30.57	28.17	30.99	54	1001	11.12	170	S	0.00	t	0.00	clear sky	2026-05-17 00:00:00+00	2026-05-17 00:00:44.524367+00
3842c5f6-771a-4cb5-95d9-15f3d2dcaffb	72829d11-3ace-445b-9f4b-5c3c72c3521f	9b593afe-2c31-4998-ae13-ed7d8821af49	17.02	16.12	17.19	82	1017	3.71	0	N	0.00	f	0.00	clear sky	2026-05-17 00:00:00+00	2026-05-17 00:00:44.789373+00
1d474b79-474a-43a1-a5ac-239f5c8adb04	5bd52475-ffa2-40f6-82e4-3d0491b7e246	9b593afe-2c31-4998-ae13-ed7d8821af49	18.67	18.67	18.67	53	1012	48.46	68	ENE	59.90	t	0.00	broken clouds	2026-05-17 00:00:00+00	2026-05-17 00:00:45.062976+00
f0ef954a-c15f-42b0-95fe-aadcdda5c5a9	467c145d-f635-4cb3-9813-63f4d28b8780	aad3bfbc-2a1b-41b4-b202-286e82adeafe	24.42	24.12	24.42	41	1010	11.12	140	SE	0.00	t	0.00	clear sky	2026-05-17 01:00:00+00	2026-05-17 01:00:45.860279+00
13306dd5-9a24-46a8-bfc9-9a2ac2b0dae6	f2df8134-8994-487c-8a25-272606e8f953	aad3bfbc-2a1b-41b4-b202-286e82adeafe	26.05	26.05	26.05	11	1008	20.12	16	NNE	37.84	t	0.00	clear sky	2026-05-17 01:00:00+00	2026-05-17 01:00:46.151511+00
574fb286-961c-4915-a759-d3674d0dd1de	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	aad3bfbc-2a1b-41b4-b202-286e82adeafe	28.96	25.14	28.96	74	1002	11.12	80	E	0.00	t	0.00	clear sky	2026-05-17 01:00:00+00	2026-05-17 01:00:46.449776+00
def0c9bc-ecfa-4968-a3b6-ff0c24eb9bf6	6411b387-fc37-4b47-878b-8f89fd8e08d9	aad3bfbc-2a1b-41b4-b202-286e82adeafe	21.95	21.95	21.95	37	1006	11.12	260	W	0.00	t	0.00	clear sky	2026-05-17 01:00:00+00	2026-05-17 01:00:46.750758+00
bfe9d048-84f0-4d3f-8a5f-85a47df3eb7a	05546df7-881e-438f-96b9-be0148283901	aad3bfbc-2a1b-41b4-b202-286e82adeafe	16.32	16.32	16.32	68	1011	18.25	191	S	19.98	t	0.00	few clouds	2026-05-17 01:00:00+00	2026-05-17 01:00:47.063006+00
0ffbf9e2-78dc-44ba-bdba-542712795c36	054b54c2-e6d1-4534-a9de-58bf2831479a	aad3bfbc-2a1b-41b4-b202-286e82adeafe	15.05	10.75	15.05	55	1013	14.83	240	WSW	0.00	f	0.00	clear sky	2026-05-17 01:00:00+00	2026-05-17 01:00:47.356904+00
3ab8d923-f351-4e2a-9539-6ae0bc1a020d	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	aad3bfbc-2a1b-41b4-b202-286e82adeafe	27.66	27.66	27.66	38	1007	20.59	1	N	32.58	t	0.00	clear sky	2026-05-17 01:00:00+00	2026-05-17 01:00:47.6783+00
1a6ec1c0-4a2a-45eb-8f9d-5b48cd1bf991	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	aad3bfbc-2a1b-41b4-b202-286e82adeafe	28.94	28.17	28.94	58	1002	9.25	330	NNW	0.00	t	0.00	clear sky	2026-05-17 01:00:00+00	2026-05-17 01:00:47.99397+00
6633c700-c7d1-476b-a7fc-21785ac7fc23	72829d11-3ace-445b-9f4b-5c3c72c3521f	aad3bfbc-2a1b-41b4-b202-286e82adeafe	17.02	15.12	17.19	82	1017	5.54	30	NNE	0.00	f	0.00	clear sky	2026-05-17 01:00:00+00	2026-05-17 01:00:48.290145+00
b2d77189-0933-49eb-8a47-02afe886dcc6	5bd52475-ffa2-40f6-82e4-3d0491b7e246	aad3bfbc-2a1b-41b4-b202-286e82adeafe	18.20	18.20	18.20	53	1011	48.96	77	ENE	61.42	t	0.00	overcast clouds	2026-05-17 01:00:00+00	2026-05-17 01:00:48.57731+00
40e37cea-0e3e-42d8-949c-a39824755dea	467c145d-f635-4cb3-9813-63f4d28b8780	f80f5d24-ea2b-42cd-89fb-bf56f015ddcb	24.42	24.12	24.42	38	1010	9.25	150	SSE	0.00	t	0.00	clear sky	2026-05-17 02:00:00+00	2026-05-17 02:00:52.689599+00
49d3764c-1883-41a8-9f30-fe43ce1175b1	f2df8134-8994-487c-8a25-272606e8f953	f80f5d24-ea2b-42cd-89fb-bf56f015ddcb	25.61	25.61	25.61	13	1008	20.70	12	NNE	38.02	t	0.00	clear sky	2026-05-17 02:00:00+00	2026-05-17 02:00:55.330983+00
ecad75d9-fcc2-49ac-8cda-548c48094003	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	f80f5d24-ea2b-42cd-89fb-bf56f015ddcb	27.96	25.14	27.96	78	1003	12.96	90	E	0.00	t	0.00	clear sky	2026-05-17 02:00:00+00	2026-05-17 02:00:58.187832+00
fdef8a3b-fe7a-4988-aa3b-c3071db8e3f4	6411b387-fc37-4b47-878b-8f89fd8e08d9	f80f5d24-ea2b-42cd-89fb-bf56f015ddcb	19.95	19.95	19.95	42	1006	11.12	250	WSW	0.00	t	0.00	clear sky	2026-05-17 02:00:00+00	2026-05-17 02:01:01.134206+00
d45437fa-be2c-476a-bb86-a12f330f6558	05546df7-881e-438f-96b9-be0148283901	f80f5d24-ea2b-42cd-89fb-bf56f015ddcb	17.99	17.99	17.99	64	1010	18.22	200	SSW	18.76	t	0.00	clear sky	2026-05-17 02:00:00+00	2026-05-17 02:01:03.695371+00
98fadb13-0ee1-4c15-a4f7-d3bd1b35866a	054b54c2-e6d1-4534-a9de-58bf2831479a	f80f5d24-ea2b-42cd-89fb-bf56f015ddcb	14.05	11.75	14.05	62	1013	12.96	240	WSW	0.00	f	0.00	clear sky	2026-05-17 02:00:00+00	2026-05-17 02:01:06.330897+00
05927934-2556-48b6-b579-f1d74fd877a2	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	f80f5d24-ea2b-42cd-89fb-bf56f015ddcb	27.66	27.66	27.66	38	1008	18.25	356	N	29.16	t	0.00	clear sky	2026-05-17 02:00:00+00	2026-05-17 02:01:09.46386+00
5805bd6e-d97c-4ebc-86b8-c2e13b863e5e	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	f80f5d24-ea2b-42cd-89fb-bf56f015ddcb	29.97	29.17	29.99	50	1003	31.50	340	NNW	0.00	t	0.00	clear sky	2026-05-17 02:00:00+00	2026-05-17 02:01:11.773019+00
5b9265dd-33cd-48fb-8e72-3aac6df0d929	72829d11-3ace-445b-9f4b-5c3c72c3521f	f80f5d24-ea2b-42cd-89fb-bf56f015ddcb	16.85	16.85	17.19	82	1017	3.71	0	N	0.00	f	0.00	few clouds	2026-05-17 02:00:00+00	2026-05-17 02:01:14.391751+00
836c8aa7-502f-4305-9c83-ca97ce720684	5bd52475-ffa2-40f6-82e4-3d0491b7e246	f80f5d24-ea2b-42cd-89fb-bf56f015ddcb	17.64	17.64	17.64	59	1009	59.26	82	E	74.56	t	0.00	overcast clouds	2026-05-17 02:00:00+00	2026-05-17 02:01:17.18193+00
dc002ab9-e661-415b-99a8-f85b6603a569	467c145d-f635-4cb3-9813-63f4d28b8780	9dbb553d-8ad2-46c8-b3e6-4679bd70f2f5	23.42	23.01	23.42	40	1009	5.54	200	SSW	0.00	f	0.00	clear sky	2026-05-17 03:00:00+00	2026-05-17 03:00:21.286598+00
de261f9a-bb53-4689-bde0-cc75d5014384	f2df8134-8994-487c-8a25-272606e8f953	9dbb553d-8ad2-46c8-b3e6-4679bd70f2f5	25.63	25.63	25.63	15	1009	25.56	8	N	45.79	t	0.00	clear sky	2026-05-17 03:00:00+00	2026-05-17 03:00:24.015643+00
cafd66f8-dbd5-459b-9cbe-e70b64389300	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	9dbb553d-8ad2-46c8-b3e6-4679bd70f2f5	27.96	26.14	27.96	78	1003	9.25	90	E	0.00	t	0.00	clear sky	2026-05-17 03:00:00+00	2026-05-17 03:00:26.552852+00
f4390971-e398-45b5-b451-abad5b20bef4	6411b387-fc37-4b47-878b-8f89fd8e08d9	9dbb553d-8ad2-46c8-b3e6-4679bd70f2f5	19.95	19.95	19.95	45	1007	12.96	260	W	0.00	t	0.00	clear sky	2026-05-17 03:00:00+00	2026-05-17 03:00:29.211827+00
23b06b6d-3afd-4f17-bb5c-1047ba43d70b	05546df7-881e-438f-96b9-be0148283901	9dbb553d-8ad2-46c8-b3e6-4679bd70f2f5	17.99	17.99	17.99	62	1010	19.66	202	SSW	20.16	t	0.00	clear sky	2026-05-17 03:00:00+00	2026-05-17 03:00:32.059611+00
ff87c952-1f4a-48fe-9042-70a3e03be968	054b54c2-e6d1-4534-a9de-58bf2831479a	9dbb553d-8ad2-46c8-b3e6-4679bd70f2f5	14.05	11.75	14.05	62	1013	7.42	240	WSW	0.00	f	0.00	clear sky	2026-05-17 03:00:00+00	2026-05-17 03:00:36.516811+00
1ef8919a-1aab-4f97-99c0-c532cf260a1d	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	9dbb553d-8ad2-46c8-b3e6-4679bd70f2f5	27.66	27.66	27.66	37	1008	15.48	357	N	22.82	t	0.00	clear sky	2026-05-17 03:00:00+00	2026-05-17 03:00:38.936636+00
3f894962-ed9e-4daa-ae04-ff5a2c6b44c8	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	9dbb553d-8ad2-46c8-b3e6-4679bd70f2f5	30.16	28.94	30.99	45	1004	27.79	340	NNW	0.00	t	0.00	clear sky	2026-05-17 03:00:00+00	2026-05-17 03:00:41.83864+00
f958d222-9d1a-47a3-93d8-d6bfb6c601f0	72829d11-3ace-445b-9f4b-5c3c72c3521f	9dbb553d-8ad2-46c8-b3e6-4679bd70f2f5	15.74	15.74	16.19	82	1017	1.84	0	N	0.00	f	0.00	few clouds	2026-05-17 03:00:00+00	2026-05-17 03:00:44.870014+00
e6a3b267-5f76-44f9-88d6-dc0dafda7b53	5bd52475-ffa2-40f6-82e4-3d0491b7e246	9dbb553d-8ad2-46c8-b3e6-4679bd70f2f5	17.49	17.49	17.49	55	1013	38.41	47	NE	52.31	t	0.00	overcast clouds	2026-05-17 03:00:00+00	2026-05-17 03:00:49.316612+00
5baf47ba-a50e-421c-8495-00389755c6e7	467c145d-f635-4cb3-9813-63f4d28b8780	70993b60-1918-4809-8566-1f12b1f33663	24.42	24.12	24.42	38	1009	7.42	150	SSE	0.00	t	0.00	clear sky	2026-05-17 04:00:00+00	2026-05-17 04:00:51.661631+00
c2baf6cb-7da1-4145-8c2d-8f6ff13e5838	f2df8134-8994-487c-8a25-272606e8f953	70993b60-1918-4809-8566-1f12b1f33663	25.74	25.74	25.74	15	1010	32.00	16	NNE	43.06	t	0.00	clear sky	2026-05-17 04:00:00+00	2026-05-17 04:00:51.987343+00
c493afc4-794f-464e-aba1-507e5d1e2954	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	70993b60-1918-4809-8566-1f12b1f33663	29.96	28.14	29.96	70	1004	7.42	90	E	0.00	t	0.00	clear sky	2026-05-17 04:00:00+00	2026-05-17 04:00:52.308531+00
a3759dc4-62ea-40c0-9dbb-78907dc3eedc	6411b387-fc37-4b47-878b-8f89fd8e08d9	70993b60-1918-4809-8566-1f12b1f33663	20.95	20.95	20.95	43	1008	20.38	290	WNW	0.00	f	0.00	clear sky	2026-05-17 04:00:00+00	2026-05-17 04:00:52.608188+00
d3a185b8-91e2-45f6-bbd7-6c5380bf26cc	05546df7-881e-438f-96b9-be0148283901	70993b60-1918-4809-8566-1f12b1f33663	18.54	18.54	18.54	61	1010	22.72	221	SW	21.92	t	0.00	clear sky	2026-05-17 04:00:00+00	2026-05-17 04:00:52.907017+00
bbdbc1f2-7e68-499b-afc3-be27932fb26d	054b54c2-e6d1-4534-a9de-58bf2831479a	70993b60-1918-4809-8566-1f12b1f33663	14.05	9.75	14.05	62	1013	3.71	260	W	0.00	f	0.00	clear sky	2026-05-17 04:00:00+00	2026-05-17 04:00:53.206677+00
b4449b02-22e6-4598-8155-a700c0b52310	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	70993b60-1918-4809-8566-1f12b1f33663	28.77	28.77	28.77	35	1009	8.82	7	N	11.27	t	0.00	clear sky	2026-05-17 04:00:00+00	2026-05-17 04:00:53.560214+00
c29d6412-4f38-43fe-bb4a-3fcbbfb9c0e2	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	70993b60-1918-4809-8566-1f12b1f33663	29.57	28.94	30.17	48	1004	31.50	350	N	0.00	t	0.00	clear sky	2026-05-17 04:00:00+00	2026-05-17 04:00:53.897232+00
5a6f2a3c-a4a7-404a-83d2-452171c01376	72829d11-3ace-445b-9f4b-5c3c72c3521f	70993b60-1918-4809-8566-1f12b1f33663	15.74	15.74	16.19	82	1017	1.84	0	N	0.00	f	0.00	few clouds	2026-05-17 04:00:00+00	2026-05-17 04:00:54.205198+00
b499d4e6-8fd6-4de2-b822-68ef0de3f529	5bd52475-ffa2-40f6-82e4-3d0491b7e246	70993b60-1918-4809-8566-1f12b1f33663	16.49	16.49	16.49	54	1013	39.38	47	NE	52.13	f	0.00	overcast clouds	2026-05-17 04:00:00+00	2026-05-17 04:00:54.512624+00
ff08108e-8670-458c-b3bc-60439e622547	467c145d-f635-4cb3-9813-63f4d28b8780	de1007e1-3336-4ccb-80da-c877079be2de	27.42	26.90	27.42	32	1010	3.71	340	NNW	0.00	t	0.00	clear sky	2026-05-17 05:00:00+00	2026-05-17 05:00:55.369987+00
1d358e85-920d-4e72-9f80-645872ae4cf6	f2df8134-8994-487c-8a25-272606e8f953	de1007e1-3336-4ccb-80da-c877079be2de	26.62	26.62	26.62	15	1011	29.95	25	NNE	35.17	f	0.00	clear sky	2026-05-17 05:00:00+00	2026-05-17 05:00:58.241622+00
e5af8157-83ef-48df-bcec-37674a58b4c5	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	de1007e1-3336-4ccb-80da-c877079be2de	31.96	31.96	32.14	58	1004	12.96	110	ESE	0.00	t	0.00	clear sky	2026-05-17 05:00:00+00	2026-05-17 05:01:00.699424+00
fecd06e1-aac9-44f4-a937-d5762eea11f6	6411b387-fc37-4b47-878b-8f89fd8e08d9	de1007e1-3336-4ccb-80da-c877079be2de	21.95	21.95	21.95	40	1008	20.38	300	WNW	0.00	f	0.00	clear sky	2026-05-17 05:00:00+00	2026-05-17 05:01:03.450051+00
409d2aa6-0cac-42ba-bcb2-157e11d12d7c	05546df7-881e-438f-96b9-be0148283901	de1007e1-3336-4ccb-80da-c877079be2de	21.88	21.88	21.88	63	1011	25.52	228	SW	26.46	t	0.00	clear sky	2026-05-17 05:00:00+00	2026-05-17 05:01:06.322677+00
8cd4cb54-d052-4a30-b745-be0bed7b2350	054b54c2-e6d1-4534-a9de-58bf2831479a	de1007e1-3336-4ccb-80da-c877079be2de	16.05	10.75	16.05	44	1013	7.42	250	WSW	0.00	f	0.00	clear sky	2026-05-17 05:00:00+00	2026-05-17 05:01:09.381367+00
828ac2aa-d9ec-467e-9be4-0e563abef44b	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	de1007e1-3336-4ccb-80da-c877079be2de	26.96	26.96	26.96	32	1009	7.27	16	NNE	11.23	t	0.00	clear sky	2026-05-17 05:00:00+00	2026-05-17 05:01:11.831778+00
01004733-a793-4308-bad8-86f4dc299c8a	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	de1007e1-3336-4ccb-80da-c877079be2de	30.57	29.94	31.17	48	1005	31.50	0	N	0.00	t	0.00	clear sky	2026-05-17 05:00:00+00	2026-05-17 05:01:13.067878+00
b454f7ff-56b3-4f8b-8b0c-762602aa8294	72829d11-3ace-445b-9f4b-5c3c72c3521f	de1007e1-3336-4ccb-80da-c877079be2de	15.74	15.74	16.19	87	1016	1.84	0	N	0.00	t	0.00	few clouds	2026-05-17 05:00:00+00	2026-05-17 05:01:13.371715+00
681fc3f3-501b-4093-967d-4724430d6e2d	5bd52475-ffa2-40f6-82e4-3d0491b7e246	de1007e1-3336-4ccb-80da-c877079be2de	16.31	16.31	16.31	54	1014	37.08	51	NE	52.42	t	0.00	overcast clouds	2026-05-17 05:00:00+00	2026-05-17 05:01:13.685652+00
7150bc58-97cb-488d-bc4f-e143255a5056	467c145d-f635-4cb3-9813-63f4d28b8780	4725cf66-0d91-49d9-ac88-f00012e5b980	29.42	29.12	29.42	28	1009	7.42	90	E	0.00	t	0.00	clear sky	2026-05-17 06:00:00+00	2026-05-17 06:00:15.851103+00
e4cc2935-6567-410b-abfc-59495b1039e7	f2df8134-8994-487c-8a25-272606e8f953	4725cf66-0d91-49d9-ac88-f00012e5b980	27.16	27.16	27.16	13	1011	26.28	26	NNE	27.83	f	0.00	clear sky	2026-05-17 06:00:00+00	2026-05-17 06:00:17.282725+00
967ecddc-84e1-40e0-b037-84c9fe87b29b	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	4725cf66-0d91-49d9-ac88-f00012e5b980	35.96	35.14	35.96	44	1004	11.12	130	SE	0.00	f	0.00	clear sky	2026-05-17 06:00:00+00	2026-05-17 06:00:18.722918+00
a57ec97a-443a-4636-8f9b-1615cc122670	6411b387-fc37-4b47-878b-8f89fd8e08d9	4725cf66-0d91-49d9-ac88-f00012e5b980	22.95	22.95	22.95	43	1008	20.38	300	WNW	0.00	f	0.00	clear sky	2026-05-17 06:00:00+00	2026-05-17 06:00:19.06406+00
402a57ba-e27c-4eff-8b8e-473ce27c9edb	05546df7-881e-438f-96b9-be0148283901	4725cf66-0d91-49d9-ac88-f00012e5b980	24.65	24.65	24.65	56	1011	21.35	228	SW	22.54	t	0.00	clear sky	2026-05-17 06:00:00+00	2026-05-17 06:00:19.368427+00
edbdc9ee-c85a-4dc6-9000-28c9bb9368f4	054b54c2-e6d1-4534-a9de-58bf2831479a	4725cf66-0d91-49d9-ac88-f00012e5b980	17.05	11.75	17.05	39	1013	16.67	240	WSW	0.00	f	0.00	haze	2026-05-17 06:00:00+00	2026-05-17 06:00:19.655057+00
a23dab2d-9e23-4046-9420-ff2de24c3677	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	4725cf66-0d91-49d9-ac88-f00012e5b980	28.09	28.09	28.09	29	1009	7.78	355	N	13.97	t	0.00	clear sky	2026-05-17 06:00:00+00	2026-05-17 06:00:19.930524+00
241bfd08-2ab8-4eb9-a30b-51c38d1dcda6	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	4725cf66-0d91-49d9-ac88-f00012e5b980	32.16	30.94	33.17	42	1006	29.63	350	N	0.00	f	0.00	clear sky	2026-05-17 06:00:00+00	2026-05-17 06:00:20.207409+00
7c21b8b9-0362-4460-8608-35e7b674fd10	72829d11-3ace-445b-9f4b-5c3c72c3521f	4725cf66-0d91-49d9-ac88-f00012e5b980	15.18	15.18	15.19	87	1017	3.71	0	N	0.00	t	0.00	few clouds	2026-05-17 06:00:00+00	2026-05-17 06:00:20.486633+00
fa0abddd-730b-4d55-8af8-a474a9df8f7c	5bd52475-ffa2-40f6-82e4-3d0491b7e246	4725cf66-0d91-49d9-ac88-f00012e5b980	16.82	16.82	16.82	53	1015	37.48	53	NE	50.00	t	0.00	broken clouds	2026-05-17 06:00:00+00	2026-05-17 06:00:20.783792+00
fdc17968-bc4f-45ca-aa64-55336adb22ed	467c145d-f635-4cb3-9813-63f4d28b8780	51239726-c35d-4a7d-93eb-c8a200e2e92d	32.42	31.90	32.42	19	1010	11.12	130	SE	0.00	f	0.00	clear sky	2026-05-17 07:00:00+00	2026-05-17 07:00:25.031256+00
6e48cd02-56c5-401b-8f1f-6d2283fddb27	f2df8134-8994-487c-8a25-272606e8f953	51239726-c35d-4a7d-93eb-c8a200e2e92d	29.57	29.57	29.57	11	1011	23.15	24	NNE	23.54	t	0.00	clear sky	2026-05-17 07:00:00+00	2026-05-17 07:00:27.548244+00
9bc7dc70-2dd7-493a-8aaa-eae1d3001b8d	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	51239726-c35d-4a7d-93eb-c8a200e2e92d	38.96	38.96	39.14	24	1004	11.12	130	SE	0.00	f	0.00	clear sky	2026-05-17 07:00:00+00	2026-05-17 07:00:32.400114+00
fe424561-b1f3-4ebe-9b7a-c205da47f707	6411b387-fc37-4b47-878b-8f89fd8e08d9	51239726-c35d-4a7d-93eb-c8a200e2e92d	24.95	24.95	24.95	36	1009	18.50	290	WNW	0.00	t	0.00	clear sky	2026-05-17 07:00:00+00	2026-05-17 07:00:35.27206+00
53294966-c03b-49fb-ab3f-76c6c740e8ba	05546df7-881e-438f-96b9-be0148283901	51239726-c35d-4a7d-93eb-c8a200e2e92d	26.32	26.32	26.32	59	1012	18.86	226	SW	20.09	t	0.00	clear sky	2026-05-17 07:00:00+00	2026-05-17 07:00:37.518611+00
7313da55-7c97-4f6f-951d-43c437b256b0	054b54c2-e6d1-4534-a9de-58bf2831479a	51239726-c35d-4a7d-93eb-c8a200e2e92d	20.05	17.75	20.05	30	1013	12.96	240	WSW	0.00	t	0.00	clear sky	2026-05-17 07:00:00+00	2026-05-17 07:00:42.10571+00
d39d46ff-3a74-4796-a280-dfb399da2b75	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	51239726-c35d-4a7d-93eb-c8a200e2e92d	31.55	31.55	31.55	37	1010	7.81	332	NNW	15.52	t	0.00	clear sky	2026-05-17 07:00:00+00	2026-05-17 07:00:43.791358+00
7138b131-f711-4bcf-8774-97776a45fbe2	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	51239726-c35d-4a7d-93eb-c8a200e2e92d	32.57	31.94	34.17	40	1006	38.88	350	N	0.00	f	0.00	clear sky	2026-05-17 07:00:00+00	2026-05-17 07:00:45.814171+00
f73fddc8-213d-4a35-a59e-e83787feea6c	72829d11-3ace-445b-9f4b-5c3c72c3521f	51239726-c35d-4a7d-93eb-c8a200e2e92d	15.19	15.12	15.19	87	1017	5.54	260	W	0.00	t	0.00	clear sky	2026-05-17 07:00:00+00	2026-05-17 07:00:48.574102+00
faab8dc7-ce4c-4d32-b73b-82c7d862edd8	5bd52475-ffa2-40f6-82e4-3d0491b7e246	51239726-c35d-4a7d-93eb-c8a200e2e92d	17.49	17.49	17.49	50	1015	40.97	61	ENE	48.06	f	0.00	scattered clouds	2026-05-17 07:00:00+00	2026-05-17 07:00:50.762041+00
f63a0c6e-8b1a-45ff-a67b-94f7754ad62e	467c145d-f635-4cb3-9813-63f4d28b8780	ac5da302-aa4b-4a2c-b8b4-f04132f997ff	33.42	33.01	33.42	19	1009	16.67	190	S	0.00	f	0.00	clear sky	2026-05-17 08:00:00+00	2026-05-17 08:00:55.060421+00
1059cd28-0010-4fa1-8a99-3e75b34802a6	f2df8134-8994-487c-8a25-272606e8f953	ac5da302-aa4b-4a2c-b8b4-f04132f997ff	31.97	31.97	31.97	10	1010	21.24	21	NNE	20.30	f	0.00	clear sky	2026-05-17 08:00:00+00	2026-05-17 08:00:57.027086+00
a1f211b0-322f-439c-bbf2-4afb6c4d1366	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	ac5da302-aa4b-4a2c-b8b4-f04132f997ff	36.96	36.96	37.14	47	1004	24.08	320	NW	0.00	f	0.00	clear sky	2026-05-17 08:00:00+00	2026-05-17 08:00:59.415538+00
61b2d49b-2ed3-48de-8404-94deaac64932	6411b387-fc37-4b47-878b-8f89fd8e08d9	ac5da302-aa4b-4a2c-b8b4-f04132f997ff	25.95	25.95	25.95	36	1008	16.67	280	W	0.00	t	0.00	clear sky	2026-05-17 08:00:00+00	2026-05-17 08:01:01.471437+00
0b9eecc5-3ffa-4635-9e5f-5f8e731c13c4	05546df7-881e-438f-96b9-be0148283901	ac5da302-aa4b-4a2c-b8b4-f04132f997ff	26.88	26.88	26.88	63	1011	15.44	225	SW	16.02	t	0.00	few clouds	2026-05-17 08:00:00+00	2026-05-17 08:01:03.750466+00
733ca379-a3e0-4666-b757-68eec9a98074	054b54c2-e6d1-4534-a9de-58bf2831479a	ac5da302-aa4b-4a2c-b8b4-f04132f997ff	22.05	19.75	22.05	26	1013	11.12	220	SW	0.00	t	0.00	clear sky	2026-05-17 08:00:00+00	2026-05-17 08:01:06.128099+00
56deaf2b-5059-4c66-b336-087298dc6530	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	ac5da302-aa4b-4a2c-b8b4-f04132f997ff	32.10	32.10	32.10	27	1009	8.24	307	NW	16.63	f	0.00	clear sky	2026-05-17 08:00:00+00	2026-05-17 08:01:08.602667+00
e41ae28c-f35e-456f-aa88-bafde7a44533	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	ac5da302-aa4b-4a2c-b8b4-f04132f997ff	33.57	32.94	35.17	39	1006	35.17	350	N	0.00	t	0.00	clear sky	2026-05-17 08:00:00+00	2026-05-17 08:01:11.441095+00
c2e5a74c-eb23-4f58-87b0-33a31bb8edb2	72829d11-3ace-445b-9f4b-5c3c72c3521f	ac5da302-aa4b-4a2c-b8b4-f04132f997ff	17.02	16.85	18.12	82	1018	5.54	290	WNW	0.00	f	0.00	scattered clouds	2026-05-17 08:00:00+00	2026-05-17 08:01:13.757202+00
ac6e4ca5-d1de-4a13-9701-31bce45551d0	5bd52475-ffa2-40f6-82e4-3d0491b7e246	ac5da302-aa4b-4a2c-b8b4-f04132f997ff	19.10	19.10	19.10	45	1015	40.36	61	ENE	44.60	f	0.00	broken clouds	2026-05-17 08:00:00+00	2026-05-17 08:01:18.058831+00
688fd0cc-4e0f-4627-a1e0-847f7be999fc	467c145d-f635-4cb3-9813-63f4d28b8780	135ce9dd-2c82-4ccf-9788-6d0adc4ddede	35.42	35.23	35.42	16	1009	25.92	190	S	0.00	f	0.00	clear sky	2026-05-17 09:00:00+00	2026-05-17 09:00:19.215132+00
8e91bfac-2569-4ebe-aee5-18b7afd9afad	f2df8134-8994-487c-8a25-272606e8f953	135ce9dd-2c82-4ccf-9788-6d0adc4ddede	33.41	33.41	33.41	9	1010	19.87	19	NNE	18.50	f	0.00	clear sky	2026-05-17 09:00:00+00	2026-05-17 09:00:19.591185+00
5622290a-af74-439f-8242-0b4b363b5549	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	135ce9dd-2c82-4ccf-9788-6d0adc4ddede	34.96	34.96	38.14	55	1004	22.21	320	NW	0.00	t	0.00	clear sky	2026-05-17 09:00:00+00	2026-05-17 09:00:19.913692+00
698ee54f-dfc0-4f99-8da3-2e0fe1ebc429	6411b387-fc37-4b47-878b-8f89fd8e08d9	135ce9dd-2c82-4ccf-9788-6d0adc4ddede	27.95	27.95	27.95	30	1008	16.67	260	W	0.00	t	0.00	clear sky	2026-05-17 09:00:00+00	2026-05-17 09:00:20.226445+00
bb694750-7501-48f5-a0d0-b7485cf2dbbb	05546df7-881e-438f-96b9-be0148283901	135ce9dd-2c82-4ccf-9788-6d0adc4ddede	27.99	27.99	27.99	63	1011	20.70	233	SW	22.43	t	0.00	clear sky	2026-05-17 09:00:00+00	2026-05-17 09:00:20.59831+00
4eb7a49a-07e7-4e11-a94a-5051f48b1df7	054b54c2-e6d1-4534-a9de-58bf2831479a	135ce9dd-2c82-4ccf-9788-6d0adc4ddede	24.05	22.75	24.05	22	1012	14.83	240	WSW	0.00	t	0.00	clear sky	2026-05-17 09:00:00+00	2026-05-17 09:00:20.931167+00
23ee8c32-e1a2-4bda-8c81-734d44e62be4	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	135ce9dd-2c82-4ccf-9788-6d0adc4ddede	30.48	30.48	30.48	24	1009	6.08	308	NW	15.34	f	0.00	clear sky	2026-05-17 09:00:00+00	2026-05-17 09:00:21.276263+00
6bf443f2-0ed0-430f-a225-75f60b4ebeb0	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	135ce9dd-2c82-4ccf-9788-6d0adc4ddede	33.99	32.94	33.99	33	1006	40.75	10	N	0.00	t	0.00	clear sky	2026-05-17 09:00:00+00	2026-05-17 09:00:21.610405+00
7909cb26-8924-4542-a2c9-2a67bb0df3b9	72829d11-3ace-445b-9f4b-5c3c72c3521f	135ce9dd-2c82-4ccf-9788-6d0adc4ddede	17.50	16.85	19.12	80	1018	11.12	350	N	0.00	f	0.00	broken clouds	2026-05-17 09:00:00+00	2026-05-17 09:00:21.910588+00
3e496d1f-2284-42ba-ab06-3bba03287784	5bd52475-ffa2-40f6-82e4-3d0491b7e246	135ce9dd-2c82-4ccf-9788-6d0adc4ddede	20.87	20.87	20.87	40	1015	37.62	61	ENE	39.96	f	0.00	broken clouds	2026-05-17 09:00:00+00	2026-05-17 09:00:22.22666+00
4cee3312-fd36-44ae-afba-93872b4ed8bd	467c145d-f635-4cb3-9813-63f4d28b8780	0e744756-230a-4898-8c5f-062a3eddb30e	36.42	35.79	36.42	15	1009	24.08	200	SSW	0.00	f	0.00	clear sky	2026-05-17 10:00:00+00	2026-05-17 10:00:23.093143+00
c6ccee92-a5a8-4e64-9254-15e8ba364e23	f2df8134-8994-487c-8a25-272606e8f953	0e744756-230a-4898-8c5f-062a3eddb30e	34.36	34.36	34.36	9	1009	17.75	15	NNE	15.88	f	0.00	clear sky	2026-05-17 10:00:00+00	2026-05-17 10:00:23.391299+00
c0d99dea-9ea8-4883-82e2-9aca82053eab	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	0e744756-230a-4898-8c5f-062a3eddb30e	34.96	34.96	36.14	52	1004	24.08	330	NNW	0.00	t	0.00	clear sky	2026-05-17 10:00:00+00	2026-05-17 10:00:23.697082+00
0a6b1dbf-91dc-4e20-80dd-64e683160173	6411b387-fc37-4b47-878b-8f89fd8e08d9	0e744756-230a-4898-8c5f-062a3eddb30e	29.95	29.95	29.95	25	1008	20.38	290	WNW	0.00	f	0.00	clear sky	2026-05-17 10:00:00+00	2026-05-17 10:00:23.987229+00
28d74817-90f2-4588-ab70-18a2737ac66d	05546df7-881e-438f-96b9-be0148283901	0e744756-230a-4898-8c5f-062a3eddb30e	29.10	29.10	29.10	64	1011	15.84	225	SW	19.80	t	0.00	clear sky	2026-05-17 10:00:00+00	2026-05-17 10:00:24.294728+00
d2871deb-d666-4606-ade5-5972385af9fd	054b54c2-e6d1-4534-a9de-58bf2831479a	0e744756-230a-4898-8c5f-062a3eddb30e	26.05	25.75	26.05	19	1012	16.67	250	WSW	0.00	t	0.00	clear sky	2026-05-17 10:00:00+00	2026-05-17 10:00:24.607188+00
0a7277fe-ff23-48b3-9e07-4fd7fe8179ba	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	0e744756-230a-4898-8c5f-062a3eddb30e	33.21	33.21	33.21	25	1008	7.02	311	NW	16.27	f	0.00	clear sky	2026-05-17 10:00:00+00	2026-05-17 10:00:24.902182+00
1448e558-9cfa-4283-a610-1108e1910f59	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	0e744756-230a-4898-8c5f-062a3eddb30e	34.16	32.94	37.17	31	1005	38.88	10	N	0.00	t	0.00	clear sky	2026-05-17 10:00:00+00	2026-05-17 10:00:25.196607+00
680e9c1c-a051-4645-8a01-a2119dcba774	72829d11-3ace-445b-9f4b-5c3c72c3521f	0e744756-230a-4898-8c5f-062a3eddb30e	18.19	18.19	19.12	72	1019	12.96	0	N	0.00	t	0.00	broken clouds	2026-05-17 10:00:00+00	2026-05-17 10:00:25.483667+00
5b360b7a-2ac6-454f-a649-b4cc39732c88	5bd52475-ffa2-40f6-82e4-3d0491b7e246	0e744756-230a-4898-8c5f-062a3eddb30e	22.91	22.91	22.91	36	1015	35.14	63	ENE	37.04	f	0.00	broken clouds	2026-05-17 10:00:00+00	2026-05-17 10:00:25.756754+00
a6590f19-935e-46c6-a3a5-a9ac5561ce71	467c145d-f635-4cb3-9813-63f4d28b8780	16e98453-6a24-4d79-a318-c6db635c4b20	37.42	37.42	37.42	14	1008	29.63	190	S	0.00	f	0.00	clear sky	2026-05-17 11:00:00+00	2026-05-17 11:00:26.559133+00
bc0b47c0-161c-4fe1-bbe4-9b27230f5341	f2df8134-8994-487c-8a25-272606e8f953	16e98453-6a24-4d79-a318-c6db635c4b20	35.00	35.00	35.00	8	1009	17.03	7	N	15.01	f	0.00	clear sky	2026-05-17 11:00:00+00	2026-05-17 11:00:26.863288+00
a4b61baf-be69-4e05-b98a-292e99a02d9a	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	16e98453-6a24-4d79-a318-c6db635c4b20	36.96	36.14	36.96	39	1003	18.50	320	NW	0.00	t	0.00	clear sky	2026-05-17 11:00:00+00	2026-05-17 11:00:27.197466+00
d9c26566-27b1-41bf-8d39-29ad16428c02	6411b387-fc37-4b47-878b-8f89fd8e08d9	16e98453-6a24-4d79-a318-c6db635c4b20	30.95	30.95	30.95	20	1007	24.08	260	W	0.00	f	0.00	scattered clouds	2026-05-17 11:00:00+00	2026-05-17 11:00:27.501824+00
d9c4d6a0-1c90-4e1b-9ae1-6139554e94e2	05546df7-881e-438f-96b9-be0148283901	16e98453-6a24-4d79-a318-c6db635c4b20	28.54	28.54	28.54	62	1010	13.54	207	SSW	18.72	t	0.00	clear sky	2026-05-17 11:00:00+00	2026-05-17 11:00:27.825251+00
d4b464d9-d492-493b-8133-a6af3e1ebdbd	054b54c2-e6d1-4534-a9de-58bf2831479a	16e98453-6a24-4d79-a318-c6db635c4b20	27.05	26.75	27.05	22	1011	12.96	220	SW	0.00	f	0.00	dust	2026-05-17 11:00:00+00	2026-05-17 11:00:28.137132+00
dbc5fdc6-2931-44f1-8cb7-7d8e28dd3740	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	16e98453-6a24-4d79-a318-c6db635c4b20	32.15	32.15	32.15	25	1007	9.32	310	NW	17.60	f	0.00	clear sky	2026-05-17 11:00:00+00	2026-05-17 11:00:28.442895+00
71b426e3-96f4-4b6d-ae0b-411a6648edc9	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	16e98453-6a24-4d79-a318-c6db635c4b20	34.99	33.94	34.99	28	1005	40.75	0	N	0.00	t	0.00	clear sky	2026-05-17 11:00:00+00	2026-05-17 11:00:28.748481+00
3676ebc5-d240-417c-8bef-941a7d130970	72829d11-3ace-445b-9f4b-5c3c72c3521f	16e98453-6a24-4d79-a318-c6db635c4b20	18.19	18.19	20.12	72	1019	12.96	10	N	0.00	t	0.00	broken clouds	2026-05-17 11:00:00+00	2026-05-17 11:00:29.041736+00
086b4322-5e24-4954-b292-6c06052f773c	5bd52475-ffa2-40f6-82e4-3d0491b7e246	16e98453-6a24-4d79-a318-c6db635c4b20	23.58	23.58	23.58	33	1015	34.42	66	ENE	35.50	f	0.00	scattered clouds	2026-05-17 11:00:00+00	2026-05-17 11:00:29.360927+00
ba6b8c4d-d26a-4207-a1e1-a8068ad101d6	467c145d-f635-4cb3-9813-63f4d28b8780	80725464-f494-41df-a92e-653e09485598	39.42	39.12	39.42	13	1007	33.34	190	S	0.00	f	0.00	clear sky	2026-05-17 12:00:00+00	2026-05-17 12:00:09.929052+00
afdf596b-516e-463b-800f-22b846f1f0f5	f2df8134-8994-487c-8a25-272606e8f953	80725464-f494-41df-a92e-653e09485598	35.10	35.10	35.10	8	1008	16.42	2	N	14.47	f	0.00	clear sky	2026-05-17 12:00:00+00	2026-05-17 12:00:10.254167+00
3b1e2634-6c1b-4110-9bc2-039da3b6b46f	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	80725464-f494-41df-a92e-653e09485598	36.96	36.96	37.14	36	1003	20.38	320	NW	0.00	t	0.00	clear sky	2026-05-17 12:00:00+00	2026-05-17 12:00:10.582494+00
27413bbf-1a9f-4426-89e9-7455a3b1bfb0	6411b387-fc37-4b47-878b-8f89fd8e08d9	80725464-f494-41df-a92e-653e09485598	29.95	29.95	29.95	21	1006	20.38	300	WNW	0.00	f	0.00	scattered clouds	2026-05-17 12:00:00+00	2026-05-17 12:00:10.884912+00
0a190145-6864-47ca-96e4-b9a462152ca8	05546df7-881e-438f-96b9-be0148283901	80725464-f494-41df-a92e-653e09485598	28.54	28.54	28.54	59	1010	13.36	224	SW	17.06	t	0.00	clear sky	2026-05-17 12:00:00+00	2026-05-17 12:00:11.24004+00
4a547153-5629-44e0-b08f-ae95c7081a63	054b54c2-e6d1-4534-a9de-58bf2831479a	80725464-f494-41df-a92e-653e09485598	29.05	29.05	29.75	20	1010	16.67	230	SW	0.00	t	0.00	dust	2026-05-17 12:00:00+00	2026-05-17 12:00:11.534495+00
f8fa1be2-f26a-4581-8a02-822a0b78c34e	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	80725464-f494-41df-a92e-653e09485598	33.77	33.77	33.77	34	1006	16.34	309	NW	21.24	f	0.00	clear sky	2026-05-17 12:00:00+00	2026-05-17 12:00:11.877616+00
7df3148e-3288-451d-90f4-2d27b1abd17b	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	80725464-f494-41df-a92e-653e09485598	34.16	32.94	37.17	27	1005	38.88	10	N	0.00	t	0.00	clear sky	2026-05-17 12:00:00+00	2026-05-17 12:00:12.181007+00
a170ead0-de53-4702-b411-6867bf407036	72829d11-3ace-445b-9f4b-5c3c72c3521f	80725464-f494-41df-a92e-653e09485598	18.19	18.19	21.12	68	1019	11.12	10	N	0.00	f	0.00	broken clouds	2026-05-17 12:00:00+00	2026-05-17 12:00:12.509936+00
9bfb6030-f130-467c-970f-f6a0bdf73c9c	5bd52475-ffa2-40f6-82e4-3d0491b7e246	80725464-f494-41df-a92e-653e09485598	24.89	24.89	24.89	32	1015	32.51	69	ENE	32.98	f	0.00	scattered clouds	2026-05-17 12:00:00+00	2026-05-17 12:00:12.821388+00
51700fae-99a9-48c9-980a-f2f3bd7ce68e	467c145d-f635-4cb3-9813-63f4d28b8780	2438f090-3463-496c-993a-08b0b8443bae	39.42	39.12	39.42	13	1006	31.50	200	SSW	0.00	f	0.00	clear sky	2026-05-17 13:00:00+00	2026-05-17 13:00:13.506319+00
59b2a502-0de0-4a52-a11d-507d118f54a8	f2df8134-8994-487c-8a25-272606e8f953	2438f090-3463-496c-993a-08b0b8443bae	35.11	35.11	35.11	9	1007	14.65	356	N	13.68	f	0.00	clear sky	2026-05-17 13:00:00+00	2026-05-17 13:00:13.863444+00
987fd223-572f-4bd4-841f-18c3798706fc	3a14ab28-7e01-4e2c-bf5e-28b4c80ecdfc	2438f090-3463-496c-993a-08b0b8443bae	34.96	34.96	36.14	43	1002	20.38	320	NW	0.00	f	0.00	clear sky	2026-05-17 13:00:00+00	2026-05-17 13:00:14.165931+00
31d4b342-ff8d-445c-b4c2-c25dcce210d4	6411b387-fc37-4b47-878b-8f89fd8e08d9	2438f090-3463-496c-993a-08b0b8443bae	30.95	30.95	30.95	20	1006	22.21	270	W	0.00	f	0.00	few clouds	2026-05-17 13:00:00+00	2026-05-17 13:00:14.471131+00
0c202b65-bc5f-44c4-bc4d-11613ac37550	05546df7-881e-438f-96b9-be0148283901	2438f090-3463-496c-993a-08b0b8443bae	27.99	27.99	27.99	58	1009	14.62	210	SSW	18.22	t	0.00	clear sky	2026-05-17 13:00:00+00	2026-05-17 13:00:14.72816+00
44a7944b-bb9f-4a6b-ba55-0fb5b18bf028	054b54c2-e6d1-4534-a9de-58bf2831479a	2438f090-3463-496c-993a-08b0b8443bae	29.05	29.05	29.75	20	1010	20.38	250	WSW	0.00	t	0.00	haze	2026-05-17 13:00:00+00	2026-05-17 13:00:15.003518+00
d8de074f-9b2f-44b3-8653-69d2a9f07f03	9e362fc7-2e64-4ce2-80fc-ef5ac01466fa	2438f090-3463-496c-993a-08b0b8443bae	34.88	34.88	34.88	23	1006	17.10	314	NW	21.56	f	0.00	clear sky	2026-05-17 13:00:00+00	2026-05-17 13:00:15.277564+00
363ebed7-42c9-4cd5-ae04-f089720d485d	f7af88f9-19f1-4b60-a0c8-bfbd27ffd8da	2438f090-3463-496c-993a-08b0b8443bae	33.97	33.94	36.17	24	1005	37.04	0	N	0.00	f	0.00	clear sky	2026-05-17 13:00:00+00	2026-05-17 13:00:15.553756+00
68e95a98-d122-4d91-9b99-1f6fd67dae46	72829d11-3ace-445b-9f4b-5c3c72c3521f	2438f090-3463-496c-993a-08b0b8443bae	19.13	19.07	21.12	68	1019	12.96	0	N	0.00	f	0.00	broken clouds	2026-05-17 13:00:00+00	2026-05-17 13:00:15.832179+00
924f5cd7-3f9e-41f8-943d-8f6235fc269e	5bd52475-ffa2-40f6-82e4-3d0491b7e246	2438f090-3463-496c-993a-08b0b8443bae	25.55	25.55	25.55	29	1014	30.71	67	ENE	30.78	f	0.00	few clouds	2026-05-17 13:00:00+00	2026-05-17 13:00:16.127105+00
\.


--
-- Name: locations locations_city_country_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_city_country_key UNIQUE (city, country);


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
-- Name: weather_readings weather_readings_location_id_observation_timestamp_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weather_readings
    ADD CONSTRAINT weather_readings_location_id_observation_timestamp_key UNIQUE (location_id, observation_timestamp);


--
-- Name: weather_readings weather_readings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weather_readings
    ADD CONSTRAINT weather_readings_pkey PRIMARY KEY (id);


--
-- Name: idx_locations_city; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_locations_city ON public.locations USING btree (city);


--
-- Name: idx_pipeline_runs_started; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pipeline_runs_started ON public.pipeline_runs USING btree (started_at DESC);


--
-- Name: idx_pipeline_runs_status_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pipeline_runs_status_time ON public.pipeline_runs USING btree (status, started_at DESC);


--
-- Name: idx_weather_location_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_weather_location_time ON public.weather_readings USING btree (location_id, observation_timestamp DESC);


--
-- Name: idx_weather_observation_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_weather_observation_time ON public.weather_readings USING btree (observation_timestamp DESC);


--
-- Name: idx_weather_pipeline_run; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_weather_pipeline_run ON public.weather_readings USING btree (pipeline_run_id);


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

\unrestrict QVx0VEPee7lgr0HKxv4bTq8pi9QdjyhkxNVr4jvgfH9hfMZBS4DVoTzg1yaV4jQ

