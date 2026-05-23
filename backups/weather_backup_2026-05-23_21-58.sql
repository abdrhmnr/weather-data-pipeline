--
-- PostgreSQL database dump
--

\restrict G18WkbI9Rf4DBLVD5SZQyLwWaOsbcHFjr5bc5kR03NCKr6L4NU7kXyVsO7fEo6y

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
93641b2a-7272-4bef-92cc-d6df7fa64c77	2026-05-21 19:00:03.068124+00	2026-05-21 19:00:06.334397+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-21 19:00:03.068142+00
639abc26-ee55-4c5a-89b1-56fe75159318	2026-05-21 19:01:00.756794+00	2026-05-21 19:01:05.102061+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-21 19:01:00.756796+00
566e86ec-a7fe-4f44-ae46-3298b29ae3a8	2026-05-21 19:01:00.755968+00	2026-05-21 19:01:05.103503+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-21 19:01:00.755971+00
73c801a3-5350-47a3-a29d-d84e29491bf3	2026-05-21 19:28:12.129387+00	2026-05-21 19:28:16.785413+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-21 19:28:12.12939+00
44adcfb5-d939-4acb-b763-ae1633f3cc40	2026-05-21 20:00:16.879276+00	2026-05-21 20:00:20.262287+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-21 20:00:16.879288+00
de775647-224b-4ddd-9e85-5a0f39770681	2026-05-21 21:03:52.446959+00	2026-05-21 21:03:55.607355+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-21 21:03:52.446971+00
d1234221-902c-4336-97e9-5d769cbc9665	2026-05-21 22:19:39.262527+00	2026-05-21 22:19:42.55017+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-21 22:19:39.262542+00
fd498cc8-1734-46dd-b98e-1581c1f72f16	2026-05-21 23:00:19.545851+00	2026-05-21 23:00:24.011735+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-21 23:00:19.545864+00
c776432d-4c4c-4d96-9cc2-d569ca838f01	2026-05-22 00:00:24.277816+00	2026-05-22 00:00:53.639183+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 00:00:24.27783+00
849267f3-9a0d-497a-ba20-789ab155c2a3	2026-05-22 01:00:53.933892+00	2026-05-22 01:01:46.404929+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 01:00:53.933912+00
28c16a35-2259-4394-be73-b4bd9d34228a	2026-05-22 02:00:46.760464+00	2026-05-22 02:00:49.769543+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 02:00:46.760479+00
db3233a0-aed4-4b0f-ad2c-8fa6528a8bc8	2026-05-22 03:00:50.082612+00	2026-05-22 03:00:52.906476+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 03:00:50.082626+00
aa730ef6-21b3-4512-bf60-6ee9928ac719	2026-05-22 04:00:53.139796+00	2026-05-22 04:00:56.356105+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 04:00:53.139812+00
9fcf6f23-db54-4a32-8901-49a2c96b624d	2026-05-22 05:00:56.687592+00	2026-05-22 05:00:59.916188+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 05:00:56.687607+00
e819bc10-a9ba-424e-b47c-a74c751f2ba4	2026-05-22 06:00:00.222773+00	2026-05-22 06:00:03.15218+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 06:00:00.222789+00
df3f90d1-b806-4140-921b-b55fcc87e8b1	2026-05-22 07:00:03.521114+00	2026-05-22 07:00:06.632626+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 07:00:03.521127+00
c1c88882-297e-4dbb-b4be-c31fe890a705	2026-05-22 08:00:06.969961+00	2026-05-22 08:00:09.827414+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 08:00:06.969975+00
6eedb066-4d2c-441e-99af-0b8831f6680d	2026-05-22 09:12:49.936132+00	2026-05-22 09:12:52.843847+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 09:12:49.936146+00
3bb3c5f7-4972-436c-9d25-f780373a534a	2026-05-22 10:00:53.123757+00	2026-05-22 10:00:56.645376+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 10:00:53.123792+00
f964bae3-ac58-4b74-9625-606e6d6a9509	2026-05-22 11:00:56.879891+00	2026-05-22 11:00:59.803715+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 11:00:56.879904+00
d5a76912-9433-4631-9acb-90833f9fe7b4	2026-05-22 12:00:59.984477+00	2026-05-22 12:01:03.083743+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 12:00:59.98449+00
6077c16f-6873-44fb-8f23-3f4fd72d3edc	2026-05-22 13:44:42.440157+00	2026-05-22 13:44:46.754158+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 13:44:42.440173+00
54073876-63d5-4c88-adca-a5004c33af60	2026-05-22 14:58:01.46692+00	2026-05-22 14:58:07.62039+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 14:58:01.466934+00
5861ef84-3826-4375-9398-40d435406612	2026-05-22 15:00:07.651403+00	2026-05-22 15:00:14.331356+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 15:00:07.651407+00
f6cb799d-0389-4eb1-8c5a-14854379301f	2026-05-22 16:00:14.67298+00	2026-05-22 16:00:18.233751+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 16:00:14.672995+00
b6527c4b-db0d-4f5a-8f43-59027a85c796	2026-05-22 17:11:35.668076+00	2026-05-22 17:11:43.667227+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 17:11:35.66809+00
7d46fa00-7f9d-40ae-baab-473785b4ccdf	2026-05-22 18:00:26.288966+00	2026-05-22 18:00:29.816106+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 18:00:26.288984+00
4a059ab1-144e-4005-b3d8-6d2e67ae399e	2026-05-22 19:00:23.579714+00	2026-05-22 19:00:27.634344+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 19:00:23.579729+00
718f4999-0e6e-4063-b761-d23db105bcfd	2026-05-22 20:00:27.863004+00	2026-05-22 20:00:31.179074+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 20:00:27.863018+00
65f3cc48-166d-4d1c-8851-820645978551	2026-05-22 21:00:31.396416+00	2026-05-22 21:00:34.657917+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 21:00:31.396427+00
fb314f85-3070-40db-a2f3-72aba9aa7227	2026-05-22 22:00:35.003709+00	2026-05-22 22:00:38.050218+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 22:00:35.003732+00
7b9e08ca-17b9-45d5-b867-d890b86370d1	2026-05-22 23:00:38.367435+00	2026-05-22 23:00:41.605005+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-22 23:00:38.367439+00
a26c3935-7bb0-45e8-8b5a-e2b9d75a62b5	2026-05-23 00:00:41.893892+00	2026-05-23 00:00:45.178616+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 00:00:41.893907+00
25d0928d-07a0-4e2c-8a96-ab6790f9b038	2026-05-23 01:00:45.559448+00	2026-05-23 01:00:48.556494+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 01:00:45.559462+00
986a4b80-7331-46f5-9962-807089758667	2026-05-23 02:00:48.874707+00	2026-05-23 02:00:51.714781+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 02:00:48.874712+00
c77e7941-9e80-4f05-8251-9045d85db055	2026-05-23 03:00:51.905143+00	2026-05-23 03:00:54.766031+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 03:00:51.905159+00
5928324c-07e0-4ea7-a7e0-19613afd53e4	2026-05-23 04:00:55.113461+00	2026-05-23 04:00:58.127837+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 04:00:55.113476+00
7142becc-238e-4600-bc7d-2ab99f90b2bc	2026-05-23 05:00:58.396711+00	2026-05-23 05:01:01.665039+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 05:00:58.396726+00
ae92bed6-dd52-4685-b597-2f75132f5346	2026-05-23 06:00:01.989616+00	2026-05-23 06:00:04.978233+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 06:00:01.989626+00
ab700634-6421-4a46-8878-14363880cdcb	2026-05-23 07:00:05.302538+00	2026-05-23 07:00:08.345745+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 07:00:05.30254+00
bcb5d564-cf32-4484-aa39-1f645cf878c7	2026-05-23 08:00:08.645799+00	2026-05-23 08:00:12.486906+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 08:00:08.645814+00
05f8c678-1418-4810-ba43-36e1bb009e1b	2026-05-23 09:00:13.302394+00	2026-05-23 09:00:16.644573+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 09:00:13.302409+00
0ddb1370-3744-4c3d-9e40-aa48d3810b51	2026-05-23 10:00:16.892012+00	2026-05-23 10:00:22.810797+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 10:00:16.892025+00
4668b720-5df0-4a1c-b43e-58e99e3cee80	2026-05-23 11:00:54.759189+00	2026-05-23 11:00:58.21016+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 11:00:54.759202+00
6b6e2a49-0153-4cb8-916f-63abadf4f6d6	2026-05-23 12:00:58.513827+00	2026-05-23 12:01:03.157945+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 12:00:58.513847+00
f1be9439-3795-4a4c-9bbd-d6caf8ce1ef5	2026-05-23 13:00:53.100169+00	2026-05-23 13:00:56.968319+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 13:00:53.100182+00
6cc1cfce-ae9a-4bed-9ebf-8d2d23835f0e	2026-05-23 14:00:57.228745+00	2026-05-23 14:01:01.091921+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 14:00:57.228759+00
e5c371bc-ebda-48cc-816f-063595512752	2026-05-23 15:00:54.308884+00	2026-05-23 15:00:58.133576+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 15:00:54.308899+00
eb5f97da-c66c-4c1f-a6f0-10953f5b3333	2026-05-23 16:11:43.662178+00	2026-05-23 16:11:46.819083+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 16:11:43.662191+00
7a3e19f8-0dc2-417f-8f57-45f786f86ed6	2026-05-23 17:06:53.616494+00	2026-05-23 17:06:56.61567+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 17:06:53.616511+00
cc51d816-972f-40c1-a89f-17681a71db93	2026-05-23 18:00:56.89102+00	2026-05-23 18:01:00.267815+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 18:00:56.891038+00
0a87dd31-84c9-4df4-928a-53be058ab709	2026-05-23 18:33:34.077351+00	2026-05-23 18:33:38.674145+00	SUCCESS	10	10	0	\N	"{\\"cities\\": [\\"Cairo\\", \\"Riyadh\\", \\"Dubai\\", \\"Baghdad\\", \\"Beirut\\", \\"Amman\\", \\"Kuwait\\", \\"Doha\\", \\"Casablanca\\", \\"Tunis\\"]}"	2026-05-23 18:33:34.077355+00
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
31f681a4-fc21-45f4-91bf-2e69628da437	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	93641b2a-7272-4bef-92cc-d6df7fa64c77	24.42	24.12	24.42	46	1014	22.21	310	NW	0	f	0	broken clouds	2026-05-21 19:00:00+00	2026-05-21 19:00:03.431639+00
26fd2574-756d-4015-bbe5-d3dc89bdde6a	fc248375-8ec4-4683-9613-c149579eb366	93641b2a-7272-4bef-92cc-d6df7fa64c77	36.55	36.55	36.55	10	1005	12.02	206	SSW	7.2	f	0	scattered clouds	2026-05-21 19:00:00+00	2026-05-21 19:00:03.74716+00
cf90b326-8bd5-4301-bfed-2836f2ed44b9	6432350e-9525-49a7-9965-65ace30857c2	93641b2a-7272-4bef-92cc-d6df7fa64c77	31.96	31.96	32.14	40	1005	11.12	200	SSW	0	f	0	clear sky	2026-05-21 19:00:00+00	2026-05-21 19:00:04.045596+00
604f0bf1-8162-41a2-bc5b-52d0143e7e7d	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	93641b2a-7272-4bef-92cc-d6df7fa64c77	25.95	25.95	25.95	27	1008	14.83	300	WNW	0	t	0	clear sky	2026-05-21 19:00:00+00	2026-05-21 19:00:04.34989+00
af50a174-bfcd-4fca-a984-11466e509aa0	1e806627-87ea-4c01-aad4-9f05ce90c257	93641b2a-7272-4bef-92cc-d6df7fa64c77	17.43	17.43	17.43	73	1012	21.1	205	SSW	23.62	t	0	clear sky	2026-05-21 19:00:00+00	2026-05-21 19:00:04.652359+00
ce72b133-a2a6-4748-b91b-6311c44c41a0	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	93641b2a-7272-4bef-92cc-d6df7fa64c77	16.05	15.75	16.05	67	1014	18.5	280	W	0	t	0	scattered clouds	2026-05-21 19:00:00+00	2026-05-21 19:00:04.988416+00
cd95a5f1-9c14-424c-9ad0-68a0215e4d70	527f8a7d-5101-47fc-9889-f2e961c2b7e4	93641b2a-7272-4bef-92cc-d6df7fa64c77	32.66	32.66	32.66	37	1005	27.36	349	N	36.94	t	0	clear sky	2026-05-21 19:00:00+00	2026-05-21 19:00:05.340701+00
0888ed85-fdd2-4316-ad02-6366b1113d0c	11058438-9274-473f-bd2c-115fdb27b414	93641b2a-7272-4bef-92cc-d6df7fa64c77	30.99	30.99	31.94	45	1005	11.12	150	SSE	0	f	0	clear sky	2026-05-21 19:00:00+00	2026-05-21 19:00:05.647817+00
95fb0352-89b3-4657-9817-237ee9ee59a5	3febc9d0-6443-496c-9ba6-55af7a506145	93641b2a-7272-4bef-92cc-d6df7fa64c77	27.96	27.96	28.19	39	1015	14.83	70	ENE	0	f	0	few clouds	2026-05-21 19:00:00+00	2026-05-21 19:00:05.990087+00
69b6e52f-c685-470b-a84e-ba6d7dc67bf7	d981da53-c316-48f1-8e7f-b9f42d74afa0	93641b2a-7272-4bef-92cc-d6df7fa64c77	24.77	24.77	24.77	40	1020	35.93	83	E	40.03	f	0	clear sky	2026-05-21 19:00:00+00	2026-05-21 19:00:06.332103+00
4b5ea40e-ca5c-47f2-9dea-b3748dfd43ec	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	73c801a3-5350-47a3-a29d-d84e29491bf3	23.42	23.01	23.42	49	1014	22.21	340	NNW	0	t	0	broken clouds	2026-05-21 19:15:42+00	2026-05-21 19:28:13.620645+00
333f7777-d56a-4f7d-85c7-5fce4e8f169f	fc248375-8ec4-4683-9613-c149579eb366	73c801a3-5350-47a3-a29d-d84e29491bf3	36.55	36.55	36.55	10	1005	12.02	206	SSW	7.2	f	0	scattered clouds	2026-05-21 19:20:53+00	2026-05-21 19:28:13.996486+00
c9ce11b7-eb78-4338-a3e0-1ea5084d1a83	6432350e-9525-49a7-9965-65ace30857c2	73c801a3-5350-47a3-a29d-d84e29491bf3	31.96	31.96	32.14	37	1005	11.12	180	S	0	f	0	clear sky	2026-05-21 19:24:05+00	2026-05-21 19:28:14.465208+00
5a4d076b-a949-4a04-bcd5-d4dff324a978	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	73c801a3-5350-47a3-a29d-d84e29491bf3	25.95	25.95	25.95	29	1008	20.38	320	NW	0	t	0	clear sky	2026-05-21 19:15:16+00	2026-05-21 19:28:14.796546+00
9c52d5b4-73b5-4455-81e0-432c64edefca	1e806627-87ea-4c01-aad4-9f05ce90c257	73c801a3-5350-47a3-a29d-d84e29491bf3	17.43	17.43	17.43	72	1013	21.1	205	SSW	23.62	t	0	clear sky	2026-05-21 19:27:19+00	2026-05-21 19:28:15.120124+00
58d967d5-7da7-4be4-87ab-458747dec657	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	73c801a3-5350-47a3-a29d-d84e29491bf3	14.75	14.75	14.75	75	1015	13.9	261	W	22.93	t	0	scattered clouds	2026-05-21 19:27:51+00	2026-05-21 19:28:15.468761+00
601ae462-4904-4289-a670-545b8307a4f2	527f8a7d-5101-47fc-9889-f2e961c2b7e4	73c801a3-5350-47a3-a29d-d84e29491bf3	33.21	33.21	33.21	32	1005	27.36	349	N	36.94	f	0	clear sky	2026-05-21 19:28:15+00	2026-05-21 19:28:15.792676+00
7343018c-6545-4a9b-862b-b34707a10a46	11058438-9274-473f-bd2c-115fdb27b414	73c801a3-5350-47a3-a29d-d84e29491bf3	30.99	30.94	30.99	48	1005	9.25	140	SE	0	t	0	clear sky	2026-05-21 19:28:16+00	2026-05-21 19:28:16.113267+00
ac478bb6-5bc5-41b6-8188-b73212429549	3febc9d0-6443-496c-9ba6-55af7a506145	73c801a3-5350-47a3-a29d-d84e29491bf3	29.07	29.07	29.19	30	1015	12.96	80	E	0	f	0	few clouds	2026-05-21 19:20:01+00	2026-05-21 19:28:16.442139+00
7cdbecab-3420-4598-aef4-89e33c3ca330	d981da53-c316-48f1-8e7f-b9f42d74afa0	73c801a3-5350-47a3-a29d-d84e29491bf3	25.01	25.01	25.01	37	1020	35.93	83	E	40.03	f	0	clear sky	2026-05-21 19:28:16+00	2026-05-21 19:28:16.782362+00
f7655d53-8f9e-4d79-9784-8cd42d9e0c5f	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	44adcfb5-d939-4acb-b763-ae1633f3cc40	22.42	21.9	22.42	49	1015	20.38	330	NNW	0	t	0	broken clouds	2026-05-21 19:51:15+00	2026-05-21 20:00:17.222989+00
88e579d1-eec3-426c-8777-f4eb256f6605	fc248375-8ec4-4683-9613-c149579eb366	44adcfb5-d939-4acb-b763-ae1633f3cc40	34.89	34.89	34.89	11	1006	14.98	355	N	21.74	f	0	scattered clouds	2026-05-21 19:58:53+00	2026-05-21 20:00:17.594584+00
962c19d0-2ba4-405d-adf1-f4f6d5c7f557	6432350e-9525-49a7-9965-65ace30857c2	44adcfb5-d939-4acb-b763-ae1633f3cc40	30.96	30.96	32.14	42	1005	14.83	190	S	0	f	0	clear sky	2026-05-21 19:53:26+00	2026-05-21 20:00:17.90731+00
f18a1e0f-c249-4b27-984c-1a6c84cac2f9	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	44adcfb5-d939-4acb-b763-ae1633f3cc40	25.95	25.95	25.95	29	1008	20.38	320	NW	0	t	0	clear sky	2026-05-21 20:00:00+00	2026-05-21 20:00:18.234162+00
bd7fca0a-455d-455e-9988-e72975add707	1e806627-87ea-4c01-aad4-9f05ce90c257	44adcfb5-d939-4acb-b763-ae1633f3cc40	17.43	17.43	17.43	71	1013	18.94	204	SSW	20.2	t	0	clear sky	2026-05-21 19:56:53+00	2026-05-21 20:00:18.599131+00
a74b5c2e-11d2-4fd8-b854-9cc93697f555	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	44adcfb5-d939-4acb-b763-ae1633f3cc40	14.75	14.75	14.75	79	1015	11.95	257	WSW	19.58	t	0	scattered clouds	2026-05-21 19:54:44+00	2026-05-21 20:00:18.922321+00
8be3c0da-c0ba-4e73-a5a1-974032e0261d	527f8a7d-5101-47fc-9889-f2e961c2b7e4	44adcfb5-d939-4acb-b763-ae1633f3cc40	32.66	32.66	32.66	32	1006	26.1	347	NNW	38.77	f	0	clear sky	2026-05-21 19:56:28+00	2026-05-21 20:00:19.251702+00
c149fc83-8eae-4430-bf81-7cd5c6c386ad	11058438-9274-473f-bd2c-115fdb27b414	44adcfb5-d939-4acb-b763-ae1633f3cc40	30.99	30.94	30.99	48	1005	9.25	140	SE	0	t	0	clear sky	2026-05-21 19:57:10+00	2026-05-21 20:00:19.576542+00
c5c63a66-b68d-4a93-9d42-e5e6273aed10	3febc9d0-6443-496c-9ba6-55af7a506145	44adcfb5-d939-4acb-b763-ae1633f3cc40	29.07	29.07	29.19	30	1015	12.96	80	E	0	f	0	clear sky	2026-05-21 19:57:41+00	2026-05-21 20:00:19.941005+00
d7ac573c-8f76-4ad1-9f4c-284d5c7d37f3	d981da53-c316-48f1-8e7f-b9f42d74afa0	44adcfb5-d939-4acb-b763-ae1633f3cc40	23.51	23.51	23.51	48	1022	35.14	76	ENE	44.5	f	0	clear sky	2026-05-21 19:56:34+00	2026-05-21 20:00:20.259883+00
9272c587-d17e-4934-982f-c2ab66d4df65	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	de775647-224b-4ddd-9e85-5a0f39770681	22.42	21.9	22.42	49	1015	14.83	350	N	0	t	0	broken clouds	2026-05-21 20:56:42+00	2026-05-21 21:03:52.808106+00
b704f17e-0a75-49e1-a051-ed0cca498db0	fc248375-8ec4-4683-9613-c149579eb366	de775647-224b-4ddd-9e85-5a0f39770681	33.24	33.24	33.24	14	1006	26.89	57	ENE	43.92	f	0	few clouds	2026-05-21 21:02:43+00	2026-05-21 21:03:53.093013+00
0cdd1211-f37f-4256-b443-a7e6eef1a6f1	6432350e-9525-49a7-9965-65ace30857c2	de775647-224b-4ddd-9e85-5a0f39770681	29.96	29.96	30.14	48	1005	16.67	200	SSW	0	t	0	clear sky	2026-05-21 21:01:10+00	2026-05-21 21:03:53.39379+00
7d2d7e62-5696-4d09-832b-d752acc91447	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	de775647-224b-4ddd-9e85-5a0f39770681	24.95	24.95	24.95	29	1008	12.96	310	NW	0	t	0	clear sky	2026-05-21 20:56:58+00	2026-05-21 21:03:53.707616+00
86103ff4-d630-47ab-a539-c7f257634a14	1e806627-87ea-4c01-aad4-9f05ce90c257	de775647-224b-4ddd-9e85-5a0f39770681	17.43	17.43	17.43	71	1013	21.31	206	SSW	22.54	t	0	clear sky	2026-05-21 20:59:55+00	2026-05-21 21:03:54.021748+00
6654ce87-b18b-49ef-97ef-ae399807f7f3	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	de775647-224b-4ddd-9e85-5a0f39770681	15.05	13.75	15.05	67	1015	11.12	260	W	0	f	0	scattered clouds	2026-05-21 21:03:54+00	2026-05-21 21:03:54.341047+00
7c76db17-40bc-42b8-a6fe-b6ff0f020434	527f8a7d-5101-47fc-9889-f2e961c2b7e4	de775647-224b-4ddd-9e85-5a0f39770681	31.55	31.55	31.55	33	1006	23.36	339	NNW	36.65	f	0	clear sky	2026-05-21 21:03:46+00	2026-05-21 21:03:54.645455+00
843f158f-73be-49cf-a3ed-5d3e2ad5c3a2	11058438-9274-473f-bd2c-115fdb27b414	de775647-224b-4ddd-9e85-5a0f39770681	32.99	29.94	32.99	40	1004	7.42	200	SSW	0	f	0	clear sky	2026-05-21 21:00:37+00	2026-05-21 21:03:54.969325+00
11b03c8d-63c4-4c88-839e-2ca08bdb5e55	3febc9d0-6443-496c-9ba6-55af7a506145	de775647-224b-4ddd-9e85-5a0f39770681	29.13	29.07	30.12	27	1016	12.89	80	E	0	f	0	clear sky	2026-05-21 20:54:21+00	2026-05-21 21:03:55.307375+00
cbfec81b-b0fb-4e17-9c2b-c87978e72408	d981da53-c316-48f1-8e7f-b9f42d74afa0	de775647-224b-4ddd-9e85-5a0f39770681	22.7	22.7	22.7	53	1022	30.38	77	ENE	41.54	f	0	clear sky	2026-05-21 20:54:27+00	2026-05-21 21:03:55.605041+00
9331c8f9-fba1-44da-8b6d-d32371eea743	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	d1234221-902c-4336-97e9-5d769cbc9665	21.42	20.79	21.42	49	1014	12.96	10	N	0	t	0	broken clouds	2026-05-21 22:09:38+00	2026-05-21 22:19:39.609498+00
222fb4e3-ba67-448a-85aa-c70b4d2ebc49	fc248375-8ec4-4683-9613-c149579eb366	d1234221-902c-4336-97e9-5d769cbc9665	32	32	32	15	1006	17.39	63	ENE	28.15	f	0	few clouds	2026-05-21 22:12:52+00	2026-05-21 22:19:39.915096+00
434693f9-674f-4bda-bfa3-a49e430e0e5e	6432350e-9525-49a7-9965-65ace30857c2	d1234221-902c-4336-97e9-5d769cbc9665	28.96	28.96	29.14	48	1004	11.12	200	SSW	0	t	0	clear sky	2026-05-21 22:19:39+00	2026-05-21 22:19:40.239283+00
caa79dc5-86b8-43ad-9a69-e67e7c5c96f2	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	d1234221-902c-4336-97e9-5d769cbc9665	21.95	21.95	21.95	40	1008	11.12	320	NW	0	t	0	clear sky	2026-05-21 22:14:45+00	2026-05-21 22:19:40.567258+00
58cb0c44-bfa5-4935-a6e5-54a584c40e7f	1e806627-87ea-4c01-aad4-9f05ce90c257	d1234221-902c-4336-97e9-5d769cbc9665	17.99	17.99	17.99	73	1013	21.24	203	SSW	22.93	t	0	clear sky	2026-05-21 22:12:37+00	2026-05-21 22:19:40.913212+00
7a4a06de-14b8-4447-b173-d51369702f58	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	d1234221-902c-4336-97e9-5d769cbc9665	14.05	11.75	14.05	77	1015	12.96	240	WSW	0	f	0	few clouds	2026-05-21 22:19:41+00	2026-05-21 22:19:41.23213+00
1e203bd9-bfeb-42df-a0a6-bad5e99d9097	527f8a7d-5101-47fc-9889-f2e961c2b7e4	d1234221-902c-4336-97e9-5d769cbc9665	30.44	30.44	30.44	34	1007	24.95	338	NNW	39.96	f	0	clear sky	2026-05-21 22:15:54+00	2026-05-21 22:19:41.56434+00
5a7a5bfd-8780-4023-a95e-d77c66b4175c	11058438-9274-473f-bd2c-115fdb27b414	d1234221-902c-4336-97e9-5d769cbc9665	31.99	29.94	31.99	43	1004	9.25	200	SSW	0	f	0	clear sky	2026-05-21 22:19:41+00	2026-05-21 22:19:41.901527+00
e772894e-84c1-4048-ac26-b67b83dcef80	3febc9d0-6443-496c-9ba6-55af7a506145	d1234221-902c-4336-97e9-5d769cbc9665	29.19	28.12	29.19	16	1016	11.12	90	E	0	f	0	clear sky	2026-05-21 22:19:42+00	2026-05-21 22:19:42.217027+00
9e248518-0bab-4ac4-aacd-86c5a59721b0	d981da53-c316-48f1-8e7f-b9f42d74afa0	d1234221-902c-4336-97e9-5d769cbc9665	22.28	22.28	22.28	54	1023	26.46	78	ENE	37.12	f	0	clear sky	2026-05-21 22:11:29+00	2026-05-21 22:19:42.547784+00
3883fc41-db6c-44c0-b71f-d1f17f5be600	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	fd498cc8-1734-46dd-b98e-1581c1f72f16	21.42	20.79	21.42	49	1015	11.12	20	NNE	0	t	0	broken clouds	2026-05-21 22:57:08+00	2026-05-21 23:00:19.905477+00
8b213fae-08a2-47e0-b723-c505a95c197e	fc248375-8ec4-4683-9613-c149579eb366	fd498cc8-1734-46dd-b98e-1581c1f72f16	30.62	30.62	30.62	17	1007	25.42	355	N	41.44	f	0	few clouds	2026-05-21 23:00:20+00	2026-05-21 23:00:20.211324+00
8120c19a-1059-4746-9c2a-0b2132e92db8	6432350e-9525-49a7-9965-65ace30857c2	fd498cc8-1734-46dd-b98e-1581c1f72f16	28.96	28.96	29.14	48	1004	9.25	190	S	0	t	0	clear sky	2026-05-21 22:55:30+00	2026-05-21 23:00:20.530736+00
63697733-e5b3-45d9-8dee-ce174eea2b9b	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	fd498cc8-1734-46dd-b98e-1581c1f72f16	21.95	21.95	21.95	40	1009	11.12	320	NW	0	f	0	clear sky	2026-05-21 22:54:16+00	2026-05-21 23:00:20.871104+00
d0a5da1e-469f-4e0f-85b5-f98f59030f6c	1e806627-87ea-4c01-aad4-9f05ce90c257	fd498cc8-1734-46dd-b98e-1581c1f72f16	17.99	17.99	17.99	74	1013	22.25	203	SSW	24.95	t	0	clear sky	2026-05-21 22:50:49+00	2026-05-21 23:00:22.278304+00
4cffc77d-aaec-486a-ab73-61aa7b033d84	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	fd498cc8-1734-46dd-b98e-1581c1f72f16	14.05	11.75	14.05	77	1015	12.96	240	WSW	0	f	0	few clouds	2026-05-21 22:58:04+00	2026-05-21 23:00:22.670294+00
10007d34-e40d-4bd2-8326-0d5ed3a304ed	527f8a7d-5101-47fc-9889-f2e961c2b7e4	fd498cc8-1734-46dd-b98e-1581c1f72f16	29.88	29.88	29.88	36	1007	25.7	339	NNW	38.66	t	0	clear sky	2026-05-21 22:58:22+00	2026-05-21 23:00:23.032257+00
31762b9e-a7aa-4417-939d-c904ebcc3da2	11058438-9274-473f-bd2c-115fdb27b414	fd498cc8-1734-46dd-b98e-1581c1f72f16	31.99	29.94	31.99	43	1004	9.25	200	SSW	0	f	0	clear sky	2026-05-21 22:52:57+00	2026-05-21 23:00:23.358857+00
19e74f2b-33ab-4732-a3da-f470615ca91e	3febc9d0-6443-496c-9ba6-55af7a506145	fd498cc8-1734-46dd-b98e-1581c1f72f16	29.19	28.12	29.19	16	1016	11.12	90	E	0	f	0	few clouds	2026-05-21 22:58:40+00	2026-05-21 23:00:23.672428+00
4d57c431-7a48-4b65-a1c8-c3f7b27af89d	d981da53-c316-48f1-8e7f-b9f42d74afa0	fd498cc8-1734-46dd-b98e-1581c1f72f16	21.75	21.75	21.75	55	1023	20.74	84	E	32.36	f	0	clear sky	2026-05-21 22:54:13+00	2026-05-21 23:00:24.009519+00
fbe9472c-9b8a-4eda-a7ad-2f1ae1f0a82b	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	c776432d-4c4c-4d96-9cc2-d569ca838f01	20.42	20.23	20.42	52	1014	9.25	40	NE	0	t	0	broken clouds	2026-05-21 23:51:52+00	2026-05-22 00:00:34.232556+00
14c8f611-afd9-412c-b530-5006054a080a	fc248375-8ec4-4683-9613-c149579eb366	c776432d-4c4c-4d96-9cc2-d569ca838f01	29.51	29.51	29.51	20	1008	21.13	349	N	35.24	t	0	few clouds	2026-05-21 23:55:43+00	2026-05-22 00:00:35.055693+00
398c2287-3746-4f3b-949a-d5796896002e	6432350e-9525-49a7-9965-65ace30857c2	c776432d-4c4c-4d96-9cc2-d569ca838f01	28.96	28.96	29.14	48	1004	11.12	190	S	0	t	0	clear sky	2026-05-21 23:55:02+00	2026-05-22 00:00:37.768242+00
4ad2025f-8a25-4e28-a2fb-bf32cd684353	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	c776432d-4c4c-4d96-9cc2-d569ca838f01	20.95	20.95	20.95	46	1009	7.42	340	NNW	0	t	0	clear sky	2026-05-22 00:00:23+00	2026-05-22 00:00:38.980744+00
93fc6177-487a-4032-88e2-ce64f3e3a834	1e806627-87ea-4c01-aad4-9f05ce90c257	c776432d-4c4c-4d96-9cc2-d569ca838f01	17.99	17.99	17.99	73	1013	20.81	201	SSW	23.65	t	0	clear sky	2026-05-21 23:55:45+00	2026-05-22 00:00:40.228265+00
30bf7603-2cda-4274-802b-fa967882ccf7	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	c776432d-4c4c-4d96-9cc2-d569ca838f01	14.05	10.75	14.05	77	1015	12.96	240	WSW	0	f	0	scattered clouds	2026-05-21 23:57:25+00	2026-05-22 00:00:46.445341+00
694a0fe8-6fa4-4f8c-9307-4c5eafabca00	527f8a7d-5101-47fc-9889-f2e961c2b7e4	c776432d-4c4c-4d96-9cc2-d569ca838f01	28.77	28.77	28.77	38	1008	26.35	344	NNW	39.38	t	0	clear sky	2026-05-21 23:57:35+00	2026-05-22 00:00:47.979875+00
b3d93dd4-3047-4b6d-80f9-51ce17e16657	11058438-9274-473f-bd2c-115fdb27b414	c776432d-4c4c-4d96-9cc2-d569ca838f01	30.99	29.94	30.99	51	1004	11.12	200	SSW	0	t	0	clear sky	2026-05-21 23:58:30+00	2026-05-22 00:00:51.620446+00
ae3dbfb5-213a-4a1a-af4a-e65d1b5d89a9	3febc9d0-6443-496c-9ba6-55af7a506145	c776432d-4c4c-4d96-9cc2-d569ca838f01	27.19	27.19	28.12	22	1016	5.54	80	E	0	f	0	few clouds	2026-05-21 23:56:38+00	2026-05-22 00:00:52.19378+00
dbb8eb26-4c19-47c5-bbdb-4eb1659ba182	d981da53-c316-48f1-8e7f-b9f42d74afa0	c776432d-4c4c-4d96-9cc2-d569ca838f01	21.18	21.18	21.18	56	1023	14.65	89	E	26.68	f	0	clear sky	2026-05-21 23:55:57+00	2026-05-22 00:00:53.636342+00
a603fcd3-be1b-4ace-b8bf-1d3e0b1f1104	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	849267f3-9a0d-497a-ba20-789ab155c2a3	20.42	20.23	20.42	56	1014	7.42	70	ENE	0	t	0	broken clouds	2026-05-22 00:52:26+00	2026-05-22 01:00:57.836951+00
d4e3fe39-ef59-4391-b307-9aa1f46b135d	fc248375-8ec4-4683-9613-c149579eb366	849267f3-9a0d-497a-ba20-789ab155c2a3	28.71	28.71	28.71	23	1009	24.3	1	N	42.01	t	0	clear sky	2026-05-22 00:53:30+00	2026-05-22 01:01:17.319472+00
8a95e8f1-9905-47da-a0ec-4f3bdbee0df5	6432350e-9525-49a7-9965-65ace30857c2	849267f3-9a0d-497a-ba20-789ab155c2a3	28.96	27.14	28.96	48	1005	7.42	150	SSE	0	t	0	clear sky	2026-05-22 01:00:03+00	2026-05-22 01:01:18.268767+00
cc5809c4-ce62-4a73-a8c7-d8757cb2978d	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	849267f3-9a0d-497a-ba20-789ab155c2a3	19.95	19.95	19.95	45	1010	7.42	340	NNW	0	t	0	clear sky	2026-05-22 00:57:11+00	2026-05-22 01:01:20.309986+00
0c129d99-a398-4f88-955c-ad46b5c8363d	1e806627-87ea-4c01-aad4-9f05ce90c257	849267f3-9a0d-497a-ba20-789ab155c2a3	16.88	16.88	16.88	72	1013	21.28	202	SSW	23.58	t	0	clear sky	2026-05-22 01:00:09+00	2026-05-22 01:01:32.641463+00
d131ce29-d554-4800-9480-6d769a49c934	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	849267f3-9a0d-497a-ba20-789ab155c2a3	14.05	11.75	14.05	82	1015	14.83	250	WSW	0	f	0	overcast clouds	2026-05-22 00:52:23+00	2026-05-22 01:01:33.46731+00
95c415c2-72ac-4abe-aa0c-f09de9e104a5	527f8a7d-5101-47fc-9889-f2e961c2b7e4	849267f3-9a0d-497a-ba20-789ab155c2a3	28.21	28.21	28.21	40	1009	26.06	354	N	40.75	t	0	clear sky	2026-05-22 00:53:33+00	2026-05-22 01:01:34.807919+00
3498f5f2-e520-44f8-a024-4b3274af9922	11058438-9274-473f-bd2c-115fdb27b414	849267f3-9a0d-497a-ba20-789ab155c2a3	30.99	28.94	30.99	51	1005	9.25	210	SSW	0	t	0	clear sky	2026-05-22 00:57:16+00	2026-05-22 01:01:37.182207+00
a84cffc0-41b5-441a-975e-ab267f4c04a0	3febc9d0-6443-496c-9ba6-55af7a506145	849267f3-9a0d-497a-ba20-789ab155c2a3	26.19	26.19	27.12	34	1015	3.71	0	N	0	f	0	clear sky	2026-05-22 00:59:31+00	2026-05-22 01:01:39.052351+00
49cfe742-7545-46ae-9240-5000e302e78a	d981da53-c316-48f1-8e7f-b9f42d74afa0	849267f3-9a0d-497a-ba20-789ab155c2a3	20.73	20.73	20.73	58	1023	9.79	100	E	16.92	f	0	clear sky	2026-05-22 01:01:46+00	2026-05-22 01:01:46.40129+00
83312217-a0c7-45c9-991c-2b9b0a61a43b	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	28c16a35-2259-4394-be73-b4bd9d34228a	19.42	19.12	19.42	55	1014	7.42	60	ENE	0	t	0	broken clouds	2026-05-22 01:52:51+00	2026-05-22 02:00:47.143755+00
e67a59d6-a22f-4a3b-b9c6-f501080b9b77	fc248375-8ec4-4683-9613-c149579eb366	28c16a35-2259-4394-be73-b4bd9d34228a	27.9	27.9	27.9	25	1010	20.81	0	N	40.46	t	0	clear sky	2026-05-22 01:50:31+00	2026-05-22 02:00:47.413998+00
12e39fc6-c372-44e8-82b1-ebbfba2a8ea2	6432350e-9525-49a7-9965-65ace30857c2	28c16a35-2259-4394-be73-b4bd9d34228a	27.96	27.14	27.96	47	1006	7.42	160	SSE	0	t	0	clear sky	2026-05-22 01:55:29+00	2026-05-22 02:00:47.69041+00
c25b33a5-ab60-43d0-af8e-c2b55d0f371d	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	28c16a35-2259-4394-be73-b4bd9d34228a	18.95	18.95	18.95	52	1010	3.71	330	NNW	0	t	0	clear sky	2026-05-22 01:56:33+00	2026-05-22 02:00:47.982527+00
0bc89e9d-fccb-459c-9748-99215ef3ee98	1e806627-87ea-4c01-aad4-9f05ce90c257	28c16a35-2259-4394-be73-b4bd9d34228a	16.88	16.88	16.88	72	1013	21.02	200	SSW	23.4	t	0	clear sky	2026-05-22 01:48:21+00	2026-05-22 02:00:48.270198+00
c0c851d0-e2f2-4387-a2c2-2b2c5f105377	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	28c16a35-2259-4394-be73-b4bd9d34228a	14.05	9.75	14.05	77	1015	11.12	270	W	0	f	0	overcast clouds	2026-05-22 01:54:28+00	2026-05-22 02:00:48.580598+00
a98a6d76-de31-408e-8315-9a09023b48b5	527f8a7d-5101-47fc-9889-f2e961c2b7e4	28c16a35-2259-4394-be73-b4bd9d34228a	27.66	27.66	27.66	42	1010	23.22	5	N	39.35	t	0	clear sky	2026-05-22 01:58:27+00	2026-05-22 02:00:48.874657+00
79af1f31-3602-47e0-b5f9-e120c66074bd	11058438-9274-473f-bd2c-115fdb27b414	28c16a35-2259-4394-be73-b4bd9d34228a	30.99	29.94	30.99	40	1005	9.25	190	S	0	f	0	clear sky	2026-05-22 02:00:49+00	2026-05-22 02:00:49.181861+00
74f320f7-e483-402e-a836-081e1a34f022	3febc9d0-6443-496c-9ba6-55af7a506145	28c16a35-2259-4394-be73-b4bd9d34228a	24.13	23.12	24.19	47	1014	3.71	0	N	0	t	0	few clouds	2026-05-22 01:53:25+00	2026-05-22 02:00:49.472903+00
363edebe-cd83-4d28-a0ce-c3fdd73798f0	d981da53-c316-48f1-8e7f-b9f42d74afa0	28c16a35-2259-4394-be73-b4bd9d34228a	19.61	19.61	19.61	60	1023	8.6	100	E	12.53	f	0	clear sky	2026-05-22 01:55:56+00	2026-05-22 02:00:49.768391+00
4f84146e-3777-4f8d-ac06-fe34394c72ab	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	db3233a0-aed4-4b0f-ad2c-8fa6528a8bc8	19.42	19.12	19.42	55	1015	5.54	90	E	0	t	0	scattered clouds	2026-05-22 02:56:23+00	2026-05-22 03:00:50.39583+00
4221cbaa-2771-422d-aee2-e31036888242	fc248375-8ec4-4683-9613-c149579eb366	db3233a0-aed4-4b0f-ad2c-8fa6528a8bc8	27.77	27.77	27.77	23	1011	20.2	6	N	39.64	t	0	clear sky	2026-05-22 02:51:29+00	2026-05-22 03:00:50.668475+00
c0ca5190-e35d-491d-805a-ebada7c61612	6432350e-9525-49a7-9965-65ace30857c2	db3233a0-aed4-4b0f-ad2c-8fa6528a8bc8	27.96	27.14	27.96	47	1006	9.25	190	S	0	t	0	clear sky	2026-05-22 02:53:56+00	2026-05-22 03:00:50.962447+00
542a8d67-aa89-4203-9169-29db7c92e0a7	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	db3233a0-aed4-4b0f-ad2c-8fa6528a8bc8	17.95	17.95	17.95	52	1011	7.42	350	N	0	t	0	clear sky	2026-05-22 03:00:09+00	2026-05-22 03:00:51.264545+00
8f0e10f1-1e44-457a-91c4-84f47fd64107	1e806627-87ea-4c01-aad4-9f05ce90c257	db3233a0-aed4-4b0f-ad2c-8fa6528a8bc8	16.32	16.32	16.32	72	1013	22.25	203	SSW	24.88	t	0	clear sky	2026-05-22 02:59:15+00	2026-05-22 03:00:51.522109+00
a2623ddf-25d9-4b14-9cc3-4fb6b8f47127	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	db3233a0-aed4-4b0f-ad2c-8fa6528a8bc8	14.05	10.75	14.05	77	1015	7.42	230	SW	0	f	0	broken clouds	2026-05-22 02:54:36+00	2026-05-22 03:00:51.813285+00
f51062b8-69a5-4626-8568-ad8c796857b4	527f8a7d-5101-47fc-9889-f2e961c2b7e4	db3233a0-aed4-4b0f-ad2c-8fa6528a8bc8	27.1	27.1	27.1	43	1010	24.26	7	N	37.87	t	0	clear sky	2026-05-22 02:59:41+00	2026-05-22 03:00:52.108117+00
048e4923-a75d-4ad5-be46-7de38f5d8deb	11058438-9274-473f-bd2c-115fdb27b414	db3233a0-aed4-4b0f-ad2c-8fa6528a8bc8	30.99	29.94	30.99	37	1005	7.42	180	S	0	t	0	clear sky	2026-05-22 02:58:43+00	2026-05-22 03:00:52.37837+00
8665c8c6-8e45-4842-b128-e0e25ac28d17	3febc9d0-6443-496c-9ba6-55af7a506145	db3233a0-aed4-4b0f-ad2c-8fa6528a8bc8	23.07	21.12	23.19	56	1014	3.71	0	N	0	t	0	few clouds	2026-05-22 02:56:03+00	2026-05-22 03:00:52.641569+00
fd16a3ef-18de-474d-926f-0282c51e09bd	d981da53-c316-48f1-8e7f-b9f42d74afa0	db3233a0-aed4-4b0f-ad2c-8fa6528a8bc8	18.79	18.79	18.79	60	1023	8.42	93	E	10.33	f	0	clear sky	2026-05-22 03:00:10+00	2026-05-22 03:00:52.904572+00
e3913667-332c-4460-8735-76a6017d4238	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	aa730ef6-21b3-4512-bf60-6ee9928ac719	19.42	19.12	19.42	55	1015	7.42	80	E	0	t	0	scattered clouds	2026-05-22 03:58:44+00	2026-05-22 04:00:53.493904+00
addd38d6-11a2-4863-8a72-867f2c60f79c	fc248375-8ec4-4683-9613-c149579eb366	aa730ef6-21b3-4512-bf60-6ee9928ac719	28.75	28.75	28.75	21	1012	22.97	14	NNE	33.19	t	0	clear sky	2026-05-22 03:53:54+00	2026-05-22 04:00:53.800843+00
80f3aec8-1c76-4e22-a7a6-98fbf62ddc88	6432350e-9525-49a7-9965-65ace30857c2	aa730ef6-21b3-4512-bf60-6ee9928ac719	28.96	28.96	29.14	42	1007	9.25	190	S	0	t	0	clear sky	2026-05-22 03:55:04+00	2026-05-22 04:00:54.103005+00
c2643ce5-d908-4e3c-8a0f-6587c0096ed3	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	aa730ef6-21b3-4512-bf60-6ee9928ac719	18.95	18.95	18.95	52	1011	9.25	320	NW	0	t	0	clear sky	2026-05-22 03:56:47+00	2026-05-22 04:00:54.423849+00
13c7a199-a454-40e9-aefd-fb00d97ea992	1e806627-87ea-4c01-aad4-9f05ce90c257	aa730ef6-21b3-4512-bf60-6ee9928ac719	16.88	16.88	16.88	73	1014	24.77	205	SSW	28.37	t	0	clear sky	2026-05-22 03:58:37+00	2026-05-22 04:00:54.747519+00
d962c344-3920-4cd7-a955-3c234f54773b	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	aa730ef6-21b3-4512-bf60-6ee9928ac719	14.05	10.75	14.05	77	1016	11.12	250	WSW	0	f	0	overcast clouds	2026-05-22 03:58:26+00	2026-05-22 04:00:55.08986+00
b136bdb0-a507-4625-b49f-4c6a25ead504	527f8a7d-5101-47fc-9889-f2e961c2b7e4	aa730ef6-21b3-4512-bf60-6ee9928ac719	28.21	28.21	28.21	42	1011	23.83	5	N	33.84	t	0	clear sky	2026-05-22 03:54:40+00	2026-05-22 04:00:55.385483+00
3eda19cb-b8be-41a6-9bdf-a1fa1ec2d242	11058438-9274-473f-bd2c-115fdb27b414	aa730ef6-21b3-4512-bf60-6ee9928ac719	30.99	29.94	30.99	42	1007	5.54	60	ENE	0	f	0	clear sky	2026-05-22 03:58:43+00	2026-05-22 04:00:55.695094+00
46019255-38c7-4ba1-ab72-fff8bb01333e	3febc9d0-6443-496c-9ba6-55af7a506145	aa730ef6-21b3-4512-bf60-6ee9928ac719	24.07	24.07	24.19	50	1014	1.84	0	N	0	t	0	few clouds	2026-05-22 03:56:21+00	2026-05-22 04:00:56.025732+00
6be07993-a118-4105-a6f3-43d06ee5d012	d981da53-c316-48f1-8e7f-b9f42d74afa0	aa730ef6-21b3-4512-bf60-6ee9928ac719	17.82	17.82	17.82	59	1023	8.86	81	E	9.4	f	0	clear sky	2026-05-22 03:52:34+00	2026-05-22 04:00:56.353908+00
44e368ee-dd78-47b9-a48f-e0b4ecb49d4b	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	9fcf6f23-db54-4a32-8901-49a2c96b624d	20.42	20.23	20.42	56	1016	7.42	60	ENE	0	t	0	scattered clouds	2026-05-22 04:52:11+00	2026-05-22 05:00:57.05797+00
b21bbd9f-9d33-4553-ad9b-4a6079a66edf	fc248375-8ec4-4683-9613-c149579eb366	9fcf6f23-db54-4a32-8901-49a2c96b624d	30.46	30.46	30.46	19	1012	22.68	22	NNE	26.46	t	0	clear sky	2026-05-22 04:47:08+00	2026-05-22 05:00:57.376881+00
e82106c1-f300-4e1c-a970-aabf7bfc2c30	6432350e-9525-49a7-9965-65ace30857c2	9fcf6f23-db54-4a32-8901-49a2c96b624d	31.96	31.96	33.14	33	1007	9.25	190	S	0	f	0	clear sky	2026-05-22 04:52:10+00	2026-05-22 05:00:57.704385+00
d6eec94b-f06d-4d38-b006-455942139d33	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	9fcf6f23-db54-4a32-8901-49a2c96b624d	22.95	22.95	22.95	40	1012	9.25	320	NW	0	t	0	clear sky	2026-05-22 04:52:36+00	2026-05-22 05:00:58.027825+00
e6ff5b32-ed81-4ea3-a914-0b8bf737a20e	1e806627-87ea-4c01-aad4-9f05ce90c257	9fcf6f23-db54-4a32-8901-49a2c96b624d	19.1	19.1	19.1	72	1015	27.61	207	SSW	29.34	t	0	clear sky	2026-05-22 04:50:32+00	2026-05-22 05:00:58.366643+00
fb98243c-7999-4f35-86a2-389d7c6f0a78	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	9fcf6f23-db54-4a32-8901-49a2c96b624d	15.05	11.75	15.05	67	1016	7.42	260	W	0	f	0	overcast clouds	2026-05-22 05:00:23+00	2026-05-22 05:00:58.666746+00
9f1b8f1d-393f-4999-95b6-fbfa890fb046	527f8a7d-5101-47fc-9889-f2e961c2b7e4	9fcf6f23-db54-4a32-8901-49a2c96b624d	28.77	28.77	28.77	39	1011	23.18	2	N	31.03	t	0	clear sky	2026-05-22 05:00:02+00	2026-05-22 05:00:58.96695+00
f1b3be32-e98c-4bde-a183-02f131df7138	11058438-9274-473f-bd2c-115fdb27b414	9fcf6f23-db54-4a32-8901-49a2c96b624d	32.99	31.94	32.99	46	1007	7.42	160	SSE	0	f	0	clear sky	2026-05-22 05:00:01+00	2026-05-22 05:00:59.27811+00
849d0d61-77fb-405c-9af8-18dd26ccd488	3febc9d0-6443-496c-9ba6-55af7a506145	9fcf6f23-db54-4a32-8901-49a2c96b624d	21.85	21.85	22.19	60	1015	1.84	0	N	0	t	0	few clouds	2026-05-22 04:58:24+00	2026-05-22 05:00:59.596585+00
72e52ce5-5738-4115-bd94-26c4693a2d80	d981da53-c316-48f1-8e7f-b9f42d74afa0	9fcf6f23-db54-4a32-8901-49a2c96b624d	18.49	18.49	18.49	59	1024	9.25	77	ENE	12.67	f	0	clear sky	2026-05-22 04:53:57+00	2026-05-22 05:00:59.91394+00
1ffbb2d3-e377-4e17-a2ba-75bb85bfb22b	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	e819bc10-a9ba-424e-b47c-a74c751f2ba4	22.42	21.9	22.42	46	1016	5.54	90	E	0	f	0	few clouds	2026-05-22 05:58:14+00	2026-05-22 06:00:00.568726+00
2b2d404d-e9c4-4eec-a6c2-b5f9c85a1f1b	fc248375-8ec4-4683-9613-c149579eb366	e819bc10-a9ba-424e-b47c-a74c751f2ba4	32.19	32.19	32.19	17	1013	21.24	26	NNE	22.43	f	0	clear sky	2026-05-22 05:58:52+00	2026-05-22 06:00:00.843564+00
a22988c8-2f4b-4533-9ea6-f7aa2887058b	6432350e-9525-49a7-9965-65ace30857c2	e819bc10-a9ba-424e-b47c-a74c751f2ba4	34.96	34.96	36.14	26	1007	9.25	220	SW	0	f	0	clear sky	2026-05-22 05:59:03+00	2026-05-22 06:00:01.138253+00
94ef8b2c-1ce7-4a15-a465-d890c4666434	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	e819bc10-a9ba-424e-b47c-a74c751f2ba4	24.95	24.95	24.95	38	1013	9.25	340	NNW	0	t	0	clear sky	2026-05-22 05:55:06+00	2026-05-22 06:00:01.416945+00
3e80fc1d-78ff-4a34-a416-56fc2e35edd8	1e806627-87ea-4c01-aad4-9f05ce90c257	e819bc10-a9ba-424e-b47c-a74c751f2ba4	20.77	20.77	20.77	72	1015	30.2	214	SW	30.13	t	0	clear sky	2026-05-22 05:55:25+00	2026-05-22 06:00:01.687439+00
66af3c94-4b13-43dc-bf2d-c81217a799a0	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	e819bc10-a9ba-424e-b47c-a74c751f2ba4	17.05	14.75	17.05	55	1017	12.96	250	WSW	0	f	0	few clouds	2026-05-22 05:57:25+00	2026-05-22 06:00:01.958655+00
3933c959-acab-480d-901f-5d762cc5c98a	527f8a7d-5101-47fc-9889-f2e961c2b7e4	e819bc10-a9ba-424e-b47c-a74c751f2ba4	29.88	29.88	29.88	42	1011	23.51	357	N	29.92	t	0	clear sky	2026-05-22 05:55:06+00	2026-05-22 06:00:02.254073+00
56edd9e9-3e97-49c3-b41c-6a579fce9de8	11058438-9274-473f-bd2c-115fdb27b414	e819bc10-a9ba-424e-b47c-a74c751f2ba4	35.99	32.94	35.99	44	1008	11.12	340	NNW	0	f	0	clear sky	2026-05-22 05:55:08+00	2026-05-22 06:00:02.553927+00
5d76c094-bd64-4860-92fd-bca625830433	3febc9d0-6443-496c-9ba6-55af7a506145	e819bc10-a9ba-424e-b47c-a74c751f2ba4	20.96	19.12	21.19	73	1015	1.84	0	N	0	t	0	few clouds	2026-05-22 05:57:13+00	2026-05-22 06:00:02.850759+00
464a9e97-02bc-4c8a-8c0b-42dacc68ecee	d981da53-c316-48f1-8e7f-b9f42d74afa0	e819bc10-a9ba-424e-b47c-a74c751f2ba4	20.09	20.09	20.09	56	1024	9.94	84	E	13.68	f	0	clear sky	2026-05-22 05:58:05+00	2026-05-22 06:00:03.149969+00
83081c4e-1b7c-4546-b15a-0f02853a637f	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	df3f90d1-b806-4140-921b-b55fcc87e8b1	23.42	23.01	23.42	46	1016	3.71	130	SE	0	f	0	clear sky	2026-05-22 06:51:26+00	2026-05-22 07:00:03.869262+00
3478ac32-2439-46ac-bb57-a34bb801b5e9	fc248375-8ec4-4683-9613-c149579eb366	df3f90d1-b806-4140-921b-b55fcc87e8b1	34.13	34.13	34.13	15	1012	19.22	33	NNE	19.44	t	0	clear sky	2026-05-22 06:57:30+00	2026-05-22 07:00:04.187627+00
3e041342-5b09-4f79-b901-850d6a17473b	6432350e-9525-49a7-9965-65ace30857c2	df3f90d1-b806-4140-921b-b55fcc87e8b1	37.96	37.96	38.14	20	1008	7.42	0	N	0	f	0	clear sky	2026-05-22 06:56:19+00	2026-05-22 07:00:04.490355+00
e3d1f9a0-99c5-414e-b126-ba235857d080	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	df3f90d1-b806-4140-921b-b55fcc87e8b1	26.95	26.95	26.95	36	1013	12.96	330	NNW	0	t	0	clear sky	2026-05-22 06:59:52+00	2026-05-22 07:00:04.806907+00
5362e148-fe9e-47fa-9d83-05e9ea43f0eb	1e806627-87ea-4c01-aad4-9f05ce90c257	df3f90d1-b806-4140-921b-b55fcc87e8b1	21.32	21.32	21.32	73	1015	30.38	224	SW	30.64	t	0	clear sky	2026-05-22 06:53:38+00	2026-05-22 07:00:05.110852+00
588b5497-b25d-4bd1-9c06-ac1dfccd945d	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	df3f90d1-b806-4140-921b-b55fcc87e8b1	18.05	16.75	18.05	63	1017	18.5	250	WSW	0	f	0	few clouds	2026-05-22 06:48:18+00	2026-05-22 07:00:05.408697+00
6573ea14-ea16-4663-a96a-340fdaca5587	527f8a7d-5101-47fc-9889-f2e961c2b7e4	df3f90d1-b806-4140-921b-b55fcc87e8b1	30.44	30.44	30.44	39	1012	21.71	356	N	26.21	t	0	clear sky	2026-05-22 06:51:31+00	2026-05-22 07:00:05.737035+00
6fc1e996-8eee-48cd-9072-1c494895afd9	11058438-9274-473f-bd2c-115fdb27b414	df3f90d1-b806-4140-921b-b55fcc87e8b1	34.99	31.94	34.99	41	1008	16.67	20	NNE	0	t	0	clear sky	2026-05-22 07:00:06+00	2026-05-22 07:00:06.038276+00
9052665c-53f4-48fe-a2b9-7f64af6943a9	3febc9d0-6443-496c-9ba6-55af7a506145	df3f90d1-b806-4140-921b-b55fcc87e8b1	21.45	20.74	22.19	58	1016	3.71	0	N	0	t	0	scattered clouds	2026-05-22 06:59:48+00	2026-05-22 07:00:06.333738+00
264a16a6-e46d-4a21-a987-5a262a43aaf8	d981da53-c316-48f1-8e7f-b9f42d74afa0	df3f90d1-b806-4140-921b-b55fcc87e8b1	22.35	22.35	22.35	46	1024	8.46	80	E	11.38	f	0	clear sky	2026-05-22 06:58:35+00	2026-05-22 07:00:06.630667+00
c727c9c9-d473-49d1-bfca-ff600ff4b2ac	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	c1c88882-297e-4dbb-b4be-c31fe890a705	24.42	24.12	24.42	41	1016	5.54	30	NNE	0	f	0	clear sky	2026-05-22 07:52:19+00	2026-05-22 08:00:07.290422+00
108a683f-6646-4c63-9161-dd687431747f	fc248375-8ec4-4683-9613-c149579eb366	c1c88882-297e-4dbb-b4be-c31fe890a705	35.61	35.61	35.61	13	1012	15.77	37	NE	15.19	f	0	clear sky	2026-05-22 07:58:21+00	2026-05-22 08:00:07.570643+00
2bd7cc4f-0c59-4da9-8c60-0d08f8ec915a	6432350e-9525-49a7-9965-65ace30857c2	c1c88882-297e-4dbb-b4be-c31fe890a705	36.96	36.96	37.14	22	1007	18.5	310	NW	0	f	0	clear sky	2026-05-22 07:58:34+00	2026-05-22 08:00:07.850426+00
0579e8bd-142f-477c-9305-77d13b8e3eb3	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	c1c88882-297e-4dbb-b4be-c31fe890a705	27.95	27.95	27.95	34	1013	9.25	340	NNW	0	t	0	clear sky	2026-05-22 07:51:48+00	2026-05-22 08:00:08.117168+00
f81579d3-155e-4f25-b5af-535b128b9326	1e806627-87ea-4c01-aad4-9f05ce90c257	c1c88882-297e-4dbb-b4be-c31fe890a705	21.88	21.88	21.88	73	1015	29.52	225	SW	31.97	t	0	clear sky	2026-05-22 07:59:01+00	2026-05-22 08:00:08.380995+00
6ca5f135-3a4c-4421-ac73-c80853c48ab6	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	c1c88882-297e-4dbb-b4be-c31fe890a705	19.05	18.75	19.05	55	1017	14.83	290	WNW	0	t	0	few clouds	2026-05-22 08:00:08+00	2026-05-22 08:00:08.66897+00
fdb44802-0e76-4860-a860-a2f2c568cb67	527f8a7d-5101-47fc-9889-f2e961c2b7e4	c1c88882-297e-4dbb-b4be-c31fe890a705	31.55	31.55	31.55	41	1011	19.3	349	N	23.69	t	0	clear sky	2026-05-22 07:56:56+00	2026-05-22 08:00:08.973843+00
20688d91-d613-4936-b57f-65b3cb742c12	11058438-9274-473f-bd2c-115fdb27b414	c1c88882-297e-4dbb-b4be-c31fe890a705	35.99	33.94	35.99	30	1007	16.67	20	NNE	0	f	0	clear sky	2026-05-22 07:55:27+00	2026-05-22 08:00:09.266451+00
f9019bd3-a937-496b-a1e9-c3669355f8f4	3febc9d0-6443-496c-9ba6-55af7a506145	c1c88882-297e-4dbb-b4be-c31fe890a705	25.18	25.18	25.19	36	1016	3.71	300	WNW	0	f	0	clear sky	2026-05-22 08:00:09+00	2026-05-22 08:00:09.529464+00
07717ad9-5d71-49a4-b8f0-7b870d3ca0e5	d981da53-c316-48f1-8e7f-b9f42d74afa0	c1c88882-297e-4dbb-b4be-c31fe890a705	23.9	23.9	23.9	41	1024	8.86	68	ENE	14.26	f	0	clear sky	2026-05-22 08:00:09+00	2026-05-22 08:00:09.824955+00
556da4a1-50e3-4193-afe3-598b60b64fe0	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	6eedb066-4d2c-441e-99af-0b8831f6680d	26.42	25.79	26.42	31	1015	7.42	0	N	0	f	0	clear sky	2026-05-22 09:04:02+00	2026-05-22 09:12:50.278607+00
0953faaa-408c-46e5-8b15-74412f64df52	fc248375-8ec4-4683-9613-c149579eb366	6eedb066-4d2c-441e-99af-0b8831f6680d	37.38	37.38	37.38	12	1012	14.72	38	NE	13.64	f	0	clear sky	2026-05-22 09:10:19+00	2026-05-22 09:12:50.582727+00
9bb090d1-58f0-4990-9063-d09ff201516b	6432350e-9525-49a7-9965-65ace30857c2	6eedb066-4d2c-441e-99af-0b8831f6680d	37.96	37.96	38.14	22	1007	12.96	310	NW	0	f	0	clear sky	2026-05-22 09:10:00+00	2026-05-22 09:12:50.861511+00
70cb2dfd-74c9-4a8d-a396-83b506afbdaa	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	6eedb066-4d2c-441e-99af-0b8831f6680d	29.95	29.95	29.95	28	1013	14.83	320	NW	0	t	0	clear sky	2026-05-22 09:12:51+00	2026-05-22 09:12:51.131508+00
81fffaaf-129b-410c-a2dc-977e9eb65260	1e806627-87ea-4c01-aad4-9f05ce90c257	6eedb066-4d2c-441e-99af-0b8831f6680d	22.43	22.43	22.43	77	1016	28.04	226	SW	30.35	t	0	clear sky	2026-05-22 09:00:15+00	2026-05-22 09:12:51.416989+00
7c1619ec-147a-4e0b-b498-d39695b2be28	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	6eedb066-4d2c-441e-99af-0b8831f6680d	21.05	19.75	21.05	43	1017	12.96	250	WSW	0	f	0	few clouds	2026-05-22 09:05:08+00	2026-05-22 09:12:51.691096+00
bf1a7a51-e50b-46b4-8db0-83ada0ed8494	527f8a7d-5101-47fc-9889-f2e961c2b7e4	6eedb066-4d2c-441e-99af-0b8831f6680d	32.66	32.66	32.66	40	1010	19.94	342	NNW	24.88	f	0	clear sky	2026-05-22 09:12:52+00	2026-05-22 09:12:51.97776+00
48a4ecf7-0723-442f-911b-df7e76e7af7a	11058438-9274-473f-bd2c-115fdb27b414	6eedb066-4d2c-441e-99af-0b8831f6680d	36.99	36.99	42.17	34	1007	12.96	50	NE	0	f	0	clear sky	2026-05-22 09:07:58+00	2026-05-22 09:12:52.254737+00
214b71f6-9a71-4ab0-8c16-78e29ada2b56	3febc9d0-6443-496c-9ba6-55af7a506145	6eedb066-4d2c-441e-99af-0b8831f6680d	27.96	27.96	28.19	32	1016	1.84	120	ESE	0	f	0	clear sky	2026-05-22 09:05:51+00	2026-05-22 09:12:52.567122+00
30685170-d92b-4446-be93-b3ed139800bc	d981da53-c316-48f1-8e7f-b9f42d74afa0	6eedb066-4d2c-441e-99af-0b8831f6680d	25.54	25.54	25.54	36	1024	7.81	62	ENE	13.1	f	0	clear sky	2026-05-22 09:11:16+00	2026-05-22 09:12:52.842303+00
7f9f0df6-1805-4597-8e1b-b72ba36fe3b4	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	3bb3c5f7-4972-436c-9d25-f780373a534a	27.42	26.9	27.42	28	1015	11.12	330	NNW	0	f	0	clear sky	2026-05-22 09:55:14+00	2026-05-22 10:00:53.569743+00
f2279a3e-f189-4176-bac7-d69faa67e80c	fc248375-8ec4-4683-9613-c149579eb366	3bb3c5f7-4972-436c-9d25-f780373a534a	38.83	38.83	38.83	10	1011	12.74	25	NNE	14.98	f	0	clear sky	2026-05-22 09:57:04+00	2026-05-22 10:00:54.273909+00
074bc1a9-7012-413a-9a37-31049abbf057	6432350e-9525-49a7-9965-65ace30857c2	3bb3c5f7-4972-436c-9d25-f780373a534a	37.96	37.96	38.14	23	1006	14.83	310	NW	0	f	0	clear sky	2026-05-22 10:00:01+00	2026-05-22 10:00:54.571109+00
fc90a7ec-36f2-4586-864d-1776abb93935	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	3bb3c5f7-4972-436c-9d25-f780373a534a	29.95	29.95	29.95	28	1013	14.83	320	NW	0	t	0	clear sky	2026-05-22 09:47:54+00	2026-05-22 10:00:54.871544+00
7c6264c6-e8da-4b82-a953-ba89d01e6c7f	1e806627-87ea-4c01-aad4-9f05ce90c257	3bb3c5f7-4972-436c-9d25-f780373a534a	21.88	21.88	21.88	77	1016	26.28	225	SW	29.84	t	0	clear sky	2026-05-22 10:00:22+00	2026-05-22 10:00:55.173384+00
d3400c14-fdda-4c96-87a6-f0f6f108f4ce	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	3bb3c5f7-4972-436c-9d25-f780373a534a	22.05	21.75	22.05	37	1017	11.12	250	WSW	0	f	0	few clouds	2026-05-22 09:53:33+00	2026-05-22 10:00:55.463767+00
06bbacdb-9e4b-4f61-a976-99da46ababfe	527f8a7d-5101-47fc-9889-f2e961c2b7e4	3bb3c5f7-4972-436c-9d25-f780373a534a	33.77	33.77	33.77	41	1011	20.23	339	NNW	25.6	f	0	clear sky	2026-05-22 10:00:55+00	2026-05-22 10:00:55.798908+00
735155e9-2ff7-4042-9d77-155728f84388	11058438-9274-473f-bd2c-115fdb27b414	3bb3c5f7-4972-436c-9d25-f780373a534a	37.99	35.94	37.99	30	1007	14.83	60	ENE	0	f	0	clear sky	2026-05-22 09:57:36+00	2026-05-22 10:00:56.084697+00
1c22ba02-5308-436a-ac7f-a761220f2b5d	3febc9d0-6443-496c-9ba6-55af7a506145	3bb3c5f7-4972-436c-9d25-f780373a534a	30.18	30.18	30.19	35	1016	7.42	320	NW	0	f	0	clear sky	2026-05-22 09:53:27+00	2026-05-22 10:00:56.343458+00
4d0d08fe-a687-43d9-90b8-7c09a73acb6e	d981da53-c316-48f1-8e7f-b9f42d74afa0	3bb3c5f7-4972-436c-9d25-f780373a534a	27.06	27.06	27.06	28	1024	7.06	74	ENE	14.44	f	0	clear sky	2026-05-22 09:51:40+00	2026-05-22 10:00:56.642718+00
43cfea1e-b0a3-4794-be7c-407af3dba9d3	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	f964bae3-ac58-4b74-9625-606e6d6a9509	29.42	29.12	29.42	26	1015	14.83	270	W	0	f	0	clear sky	2026-05-22 10:58:21+00	2026-05-22 11:00:57.208303+00
8ba1b245-46fd-4992-a0a5-23d2b08babb9	fc248375-8ec4-4683-9613-c149579eb366	f964bae3-ac58-4b74-9625-606e6d6a9509	39.62	39.62	39.62	9	1010	13.54	9	N	15.08	f	0	clear sky	2026-05-22 10:49:59+00	2026-05-22 11:00:57.487301+00
3b596249-e400-4925-a577-fdb008e14231	6432350e-9525-49a7-9965-65ace30857c2	f964bae3-ac58-4b74-9625-606e6d6a9509	37.96	37.96	38.14	28	1006	16.67	310	NW	0	f	0	clear sky	2026-05-22 11:00:03+00	2026-05-22 11:00:57.775772+00
332637be-ca8b-45ea-9d0d-772d0ed80983	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	f964bae3-ac58-4b74-9625-606e6d6a9509	30.95	30.95	30.95	25	1012	11.12	270	W	0	f	0	few clouds	2026-05-22 10:51:46+00	2026-05-22 11:00:58.069035+00
ca2c6600-cfb9-424f-8940-af46b3c69bb4	1e806627-87ea-4c01-aad4-9f05ce90c257	f964bae3-ac58-4b74-9625-606e6d6a9509	21.32	21.32	21.32	79	1016	24.23	224	SW	28.3	t	0	few clouds	2026-05-22 10:54:02+00	2026-05-22 11:00:58.349727+00
ae476f11-3387-44eb-8b8a-f927a612f288	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	f964bae3-ac58-4b74-9625-606e6d6a9509	23.05	22.75	23.05	33	1016	18.5	250	WSW	0	f	0	few clouds	2026-05-22 11:00:58+00	2026-05-22 11:00:58.633516+00
b7513a77-5ef7-4e60-9482-97d259c861e4	527f8a7d-5101-47fc-9889-f2e961c2b7e4	f964bae3-ac58-4b74-9625-606e6d6a9509	34.32	34.32	34.32	27	1010	20.7	336	NNW	26.24	f	0	clear sky	2026-05-22 10:59:11+00	2026-05-22 11:00:58.919028+00
70a7811e-ff59-4532-9059-22a0d64cfd87	11058438-9274-473f-bd2c-115fdb27b414	f964bae3-ac58-4b74-9625-606e6d6a9509	35.99	35.94	35.99	38	1006	20.38	90	E	0	f	0	clear sky	2026-05-22 11:00:59+00	2026-05-22 11:00:59.256881+00
47077900-57d2-482b-ab8e-2dc5c43efdb5	3febc9d0-6443-496c-9ba6-55af7a506145	f964bae3-ac58-4b74-9625-606e6d6a9509	28.19	28.19	38.12	44	1016	9.25	330	NNW	0	f	0	clear sky	2026-05-22 10:58:11+00	2026-05-22 11:00:59.526067+00
da737466-a792-472e-b0e0-fdc30bf3f34b	d981da53-c316-48f1-8e7f-b9f42d74afa0	f964bae3-ac58-4b74-9625-606e6d6a9509	28.17	28.17	28.17	24	1023	8.21	94	E	16.6	f	0	clear sky	2026-05-22 10:55:51+00	2026-05-22 11:00:59.801373+00
1e4ae451-f6ab-4faa-a6ee-e4bccec1203e	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	d5a76912-9433-4631-9acb-90833f9fe7b4	28.42	28.01	28.42	28	1014	16.67	280	W	0	f	0	clear sky	2026-05-22 11:52:43+00	2026-05-22 12:01:00.331542+00
f0e7321d-d796-401e-9bec-85162abef255	fc248375-8ec4-4683-9613-c149579eb366	d5a76912-9433-4631-9acb-90833f9fe7b4	39.93	39.93	39.93	8	1010	15.19	359	N	15.12	f	0	clear sky	2026-05-22 11:59:58+00	2026-05-22 12:01:00.605682+00
a9a9bd37-0554-47a4-b0de-bb5b07a66e38	6432350e-9525-49a7-9965-65ace30857c2	d5a76912-9433-4631-9acb-90833f9fe7b4	36.96	36.96	38.14	34	1006	14.83	300	WNW	0	f	0	clear sky	2026-05-22 11:51:06+00	2026-05-22 12:01:00.89856+00
edddd22d-e4ef-43c7-8772-ba8cd7498964	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	d5a76912-9433-4631-9acb-90833f9fe7b4	31.95	31.95	31.95	23	1012	20.38	250	WSW	0	f	0	few clouds	2026-05-22 11:55:49+00	2026-05-22 12:01:01.169246+00
a516b5f7-91bc-4cd9-ab2e-1444cfd360d8	1e806627-87ea-4c01-aad4-9f05ce90c257	d5a76912-9433-4631-9acb-90833f9fe7b4	21.32	21.32	21.32	79	1016	22.9	224	SW	26.96	t	0	few clouds	2026-05-22 12:00:28+00	2026-05-22 12:01:01.470346+00
98df106b-2b88-4d31-a5fa-4ea8e99ef620	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	d5a76912-9433-4631-9acb-90833f9fe7b4	23.05	23.05	23.75	31	1016	12.96	230	SW	0	f	0	few clouds	2026-05-22 11:52:43+00	2026-05-22 12:01:01.831329+00
a4dbd883-1ecd-4dc9-8425-fb68a8c60f51	527f8a7d-5101-47fc-9889-f2e961c2b7e4	d5a76912-9433-4631-9acb-90833f9fe7b4	35.44	35.44	35.44	26	1010	22.82	337	NNW	27.32	f	0	clear sky	2026-05-22 11:58:02+00	2026-05-22 12:01:02.165074+00
8b1ec422-b90f-4d40-b8b2-9daa3f56d25e	11058438-9274-473f-bd2c-115fdb27b414	d5a76912-9433-4631-9acb-90833f9fe7b4	35.99	35.99	37.94	34	1006	16.67	100	E	0	f	0	clear sky	2026-05-22 11:59:53+00	2026-05-22 12:01:02.448197+00
39849740-27c4-4ac1-80b8-17c4c5655388	3febc9d0-6443-496c-9ba6-55af7a506145	d5a76912-9433-4631-9acb-90833f9fe7b4	30.18	30.18	30.19	30	1016	7.42	330	NNW	0	f	0	scattered clouds	2026-05-22 11:53:26+00	2026-05-22 12:01:02.725534+00
316dd2f9-cde4-47ff-b3e8-e723c63ad4a9	d981da53-c316-48f1-8e7f-b9f42d74afa0	d5a76912-9433-4631-9acb-90833f9fe7b4	29.22	29.22	29.22	21	1023	10.37	100	E	20.02	f	0	clear sky	2026-05-22 12:00:27+00	2026-05-22 12:01:03.081503+00
8d328abd-ed04-47b8-95dc-f6fcd6aac09d	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	6077c16f-6873-44fb-8f23-3f4fd72d3edc	29.42	29.12	29.42	26	1013	12.96	300	WNW	0	t	0	scattered clouds	2026-05-22 14:06:26+00	2026-05-22 13:44:43.918253+00
d7008d1d-d092-41b8-a0c4-68002a55cd4b	fc248375-8ec4-4683-9613-c149579eb366	6077c16f-6873-44fb-8f23-3f4fd72d3edc	39	39	39	8	1011	16.16	23	NNE	14.76	f	0	clear sky	2026-05-22 14:12:40+00	2026-05-22 13:44:44.21543+00
cf30e0bf-0546-4111-833e-fb28db1dcac9	6432350e-9525-49a7-9965-65ace30857c2	6077c16f-6873-44fb-8f23-3f4fd72d3edc	37.96	37.96	38.14	22	1006	9.25	330	NNW	0	f	0	clear sky	2026-05-22 14:02:52+00	2026-05-22 13:44:44.542953+00
3247bce7-45d6-4ad4-9009-b74d4899ddea	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	6077c16f-6873-44fb-8f23-3f4fd72d3edc	31.95	31.95	31.95	23	1012	11.12	300	WNW	0	f	0	few clouds	2026-05-22 14:12:54+00	2026-05-22 13:44:44.847364+00
0b6da196-f2ad-4f71-9348-543a941e5614	1e806627-87ea-4c01-aad4-9f05ce90c257	6077c16f-6873-44fb-8f23-3f4fd72d3edc	21.32	21.32	21.32	86	1015	19.58	226	SW	20.92	t	0	few clouds	2026-05-22 14:05:38+00	2026-05-22 13:44:45.175097+00
056581a4-0c73-4105-94d8-0096d3d1ca8d	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	6077c16f-6873-44fb-8f23-3f4fd72d3edc	22.46	22.46	22.46	37	1016	17.46	274	W	15.88	f	0	clear sky	2026-05-22 14:11:49+00	2026-05-22 13:44:45.488858+00
a5fa6f9a-3324-422e-b6d9-3d05f6b6d31b	527f8a7d-5101-47fc-9889-f2e961c2b7e4	6077c16f-6873-44fb-8f23-3f4fd72d3edc	33.21	33.21	33.21	43	1009	24.34	338	NNW	27.76	f	0	clear sky	2026-05-22 14:15:19+00	2026-05-22 13:44:45.825012+00
a234fb1f-b803-4bc2-bec0-31810267ca6a	11058438-9274-473f-bd2c-115fdb27b414	6077c16f-6873-44fb-8f23-3f4fd72d3edc	33.99	33.99	36.17	49	1007	27.79	10	N	0	t	0	clear sky	2026-05-22 14:09:29+00	2026-05-22 13:44:46.152208+00
ea397541-f1e7-44fa-aea0-55e2454514aa	3febc9d0-6443-496c-9ba6-55af7a506145	6077c16f-6873-44fb-8f23-3f4fd72d3edc	33.19	33.19	40.12	17	1016	12.96	330	NNW	0	f	0	scattered clouds	2026-05-22 14:12:13+00	2026-05-22 13:44:46.452396+00
f33d5d26-6f65-4dd9-b576-146b425e3c27	d981da53-c316-48f1-8e7f-b9f42d74afa0	6077c16f-6873-44fb-8f23-3f4fd72d3edc	30.23	30.23	30.23	19	1021	12.17	91	E	21.31	f	0	clear sky	2026-05-22 14:10:41+00	2026-05-22 13:44:46.752004+00
6e888ebd-383b-4605-826f-dfc1f75027af	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	54073876-63d5-4c88-adca-a5004c33af60	28.42	28.01	28.42	28	1013	18.5	330	NNW	0	t	0	scattered clouds	2026-05-22 14:46:19+00	2026-05-22 14:58:02.754959+00
695ee435-9c24-4583-a8b1-c067df9d12bd	fc248375-8ec4-4683-9613-c149579eb366	54073876-63d5-4c88-adca-a5004c33af60	38.03	38.03	38.03	9	1010	18.9	48	NE	20.41	f	0	clear sky	2026-05-22 14:52:12+00	2026-05-22 14:58:04.893994+00
6b59a887-1535-4878-8d37-81016a555873	6432350e-9525-49a7-9965-65ace30857c2	54073876-63d5-4c88-adca-a5004c33af60	37.96	37.96	38.14	18	1006	5.54	0	N	0	f	0	clear sky	2026-05-22 14:45:02+00	2026-05-22 14:58:05.546014+00
030fb759-9666-482c-a983-fc158bdfd904	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	54073876-63d5-4c88-adca-a5004c33af60	31.95	31.95	31.95	23	1012	11.12	300	WNW	0	f	0	few clouds	2026-05-22 14:55:21+00	2026-05-22 14:58:05.833193+00
836758a9-6014-4b2a-86b3-2b52367b8d1f	1e806627-87ea-4c01-aad4-9f05ce90c257	54073876-63d5-4c88-adca-a5004c33af60	21.32	21.32	21.32	80	1015	16.63	225	SW	17.35	t	0	few clouds	2026-05-22 14:58:06+00	2026-05-22 14:58:06.147135+00
5d0e9769-5d81-49e4-b785-4a84f1fc26a1	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	54073876-63d5-4c88-adca-a5004c33af60	24.05	23.75	24.05	29	1015	16.67	240	WSW	0	t	0	few clouds	2026-05-22 14:55:48+00	2026-05-22 14:58:06.463832+00
d4f2206c-2d7a-4a07-83f2-c36e18d45e2e	527f8a7d-5101-47fc-9889-f2e961c2b7e4	54073876-63d5-4c88-adca-a5004c33af60	30.99	30.99	30.99	55	1010	24.3	337	NNW	27.5	t	0	clear sky	2026-05-22 14:56:37+00	2026-05-22 14:58:06.744267+00
08dea26e-6b17-4a27-898f-32e6c2d95a4a	11058438-9274-473f-bd2c-115fdb27b414	54073876-63d5-4c88-adca-a5004c33af60	32.99	31.94	32.99	40	1008	27.79	20	NNE	0	f	0	clear sky	2026-05-22 14:50:00+00	2026-05-22 14:58:07.027723+00
7dcfd54a-9223-4c29-8e6e-46214e849f8b	3febc9d0-6443-496c-9ba6-55af7a506145	54073876-63d5-4c88-adca-a5004c33af60	33.19	33.19	39.12	17	1016	12.96	330	NNW	0	f	0	scattered clouds	2026-05-22 14:48:55+00	2026-05-22 14:58:07.313184+00
afeb21f5-36d9-4840-8095-bf3bdfa78903	d981da53-c316-48f1-8e7f-b9f42d74afa0	54073876-63d5-4c88-adca-a5004c33af60	30.93	30.93	30.93	17	1020	13.97	77	ENE	23.33	f	0	clear sky	2026-05-22 14:55:51+00	2026-05-22 14:58:07.618283+00
4ed58d87-38cf-413f-89e0-69996bcff2ca	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	5861ef84-3826-4375-9398-40d435406612	28.42	28.01	28.42	28	1013	18.5	330	NNW	0	t	0	scattered clouds	2026-05-22 14:58:09+00	2026-05-22 15:00:07.979382+00
4535bc80-620e-4db0-8148-4187c30e59c7	6432350e-9525-49a7-9965-65ace30857c2	5861ef84-3826-4375-9398-40d435406612	37.96	37.96	38.14	18	1006	5.54	0	N	0	f	0	clear sky	2026-05-22 14:59:37+00	2026-05-22 15:00:08.56974+00
8fd596ac-0150-497f-9e39-b3f6ff4a13f5	11058438-9274-473f-bd2c-115fdb27b414	5861ef84-3826-4375-9398-40d435406612	32.99	31.94	32.99	40	1008	27.79	20	NNE	0	f	0	clear sky	2026-05-22 14:56:13+00	2026-05-22 15:00:13.725485+00
e16c9b69-c544-4391-939d-60de8bd69fd3	3febc9d0-6443-496c-9ba6-55af7a506145	5861ef84-3826-4375-9398-40d435406612	33.19	33.19	39.12	17	1016	12.96	330	NNW	0	f	0	scattered clouds	2026-05-22 14:57:28+00	2026-05-22 15:00:14.034509+00
358d3efb-90eb-4b7d-be5b-ff0e28c8951e	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	f6cb799d-0389-4eb1-8c5a-14854379301f	28.42	28.01	28.42	28	1013	12.96	330	NNW	0	t	0	scattered clouds	2026-05-22 15:55:06+00	2026-05-22 16:00:15.027701+00
f4a027cc-b4d1-4581-bd0e-84658d3098d2	fc248375-8ec4-4683-9613-c149579eb366	f6cb799d-0389-4eb1-8c5a-14854379301f	35.56	35.56	35.56	10	1011	23.18	59	ENE	33.44	f	0	clear sky	2026-05-22 15:51:53+00	2026-05-22 16:00:15.322383+00
32dfd80a-348d-4dcb-8e95-402da801d695	6432350e-9525-49a7-9965-65ace30857c2	f6cb799d-0389-4eb1-8c5a-14854379301f	36.96	36.96	37.14	26	1006	7.42	230	SW	0	f	0	clear sky	2026-05-22 15:56:52+00	2026-05-22 16:00:15.607616+00
e786d301-dea9-409d-9492-ecaeda623be0	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	f6cb799d-0389-4eb1-8c5a-14854379301f	30.95	30.95	30.95	27	1012	7.42	0	N	0	t	0	few clouds	2026-05-22 15:46:59+00	2026-05-22 16:00:15.898777+00
919a94c9-34c6-4932-96f7-5236635ccb27	1e806627-87ea-4c01-aad4-9f05ce90c257	f6cb799d-0389-4eb1-8c5a-14854379301f	20.77	20.77	20.77	82	1015	14.8	221	SW	15.52	t	0	few clouds	2026-05-22 15:55:39+00	2026-05-22 16:00:16.192763+00
b906c073-398e-437d-8eee-5562e85c6464	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	f6cb799d-0389-4eb1-8c5a-14854379301f	23.05	22.75	23.05	35	1015	16.67	230	SW	0	f	0	few clouds	2026-05-22 15:53:04+00	2026-05-22 16:00:16.458733+00
5d8d02f7-691d-4b81-9bc2-5057b68822da	527f8a7d-5101-47fc-9889-f2e961c2b7e4	f6cb799d-0389-4eb1-8c5a-14854379301f	29.88	29.88	29.88	48	1010	25.31	337	NNW	27.22	t	0	clear sky	2026-05-22 15:57:19+00	2026-05-22 16:00:17.161698+00
e2c8b2ae-5c9f-451c-883b-06b704e181b6	11058438-9274-473f-bd2c-115fdb27b414	f6cb799d-0389-4eb1-8c5a-14854379301f	31.97	31.94	34.17	45	1008	31.5	0	N	0	f	0	clear sky	2026-05-22 15:55:06+00	2026-05-22 16:00:17.661519+00
5a6a3a09-d20e-4ab1-ad2b-d4b90c5a44cf	3febc9d0-6443-496c-9ba6-55af7a506145	f6cb799d-0389-4eb1-8c5a-14854379301f	32.19	32.19	37.12	25	1016	11.12	340	NNW	0	f	0	scattered clouds	2026-05-22 15:59:28+00	2026-05-22 16:00:17.957857+00
4b0af872-889e-494b-af48-4ba2e85e7d1b	d981da53-c316-48f1-8e7f-b9f42d74afa0	f6cb799d-0389-4eb1-8c5a-14854379301f	31.14	31.14	31.14	17	1020	16.31	77	ENE	26.78	f	0	clear sky	2026-05-22 15:58:41+00	2026-05-22 16:00:18.231911+00
4c98d9aa-71ea-4410-ad9b-b0cb553b6326	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	b6527c4b-db0d-4f5a-8f43-59027a85c796	28.42	28.01	28.42	26	1013	11.12	0	N	0	t	0	few clouds	2026-05-22 17:01:41+00	2026-05-22 17:11:37.615578+00
d53a57ee-bc26-40ab-a7de-c4bcdb46c631	fc248375-8ec4-4683-9613-c149579eb366	b6527c4b-db0d-4f5a-8f43-59027a85c796	34.11	34.11	34.11	12	1012	25.13	57	ENE	41.22	f	0	clear sky	2026-05-22 17:08:11+00	2026-05-22 17:11:41.347306+00
ae2d2a43-d4e0-4b71-842a-9fb9e3249f0d	6432350e-9525-49a7-9965-65ace30857c2	b6527c4b-db0d-4f5a-8f43-59027a85c796	35.96	35.96	37.14	30	1006	7.42	210	SSW	0	f	0	clear sky	2026-05-22 17:07:38+00	2026-05-22 17:11:41.6617+00
3905dfb7-95ee-4240-82ae-ce51ef08c4f2	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	b6527c4b-db0d-4f5a-8f43-59027a85c796	27.95	27.95	27.95	32	1013	5.54	330	NNW	0	t	0	clear sky	2026-05-22 17:11:42+00	2026-05-22 17:11:41.925405+00
fa1dca68-7c0a-43ef-ae5c-9885ecc15e43	1e806627-87ea-4c01-aad4-9f05ce90c257	b6527c4b-db0d-4f5a-8f43-59027a85c796	19.65	19.65	19.65	88	1015	13.61	216	SW	14.65	t	0	few clouds	2026-05-22 17:11:42+00	2026-05-22 17:11:42.203404+00
75762ebe-1f52-4a1c-ac41-b00d434ae7f1	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	b6527c4b-db0d-4f5a-8f43-59027a85c796	23.05	21.75	23.05	38	1015	12.96	260	W	0	f	0	scattered clouds	2026-05-22 17:06:26+00	2026-05-22 17:11:42.480799+00
0e43bf9a-88cb-4e04-8a41-8d53829615e7	527f8a7d-5101-47fc-9889-f2e961c2b7e4	b6527c4b-db0d-4f5a-8f43-59027a85c796	30.99	30.99	30.99	42	1010	24.05	340	NNW	26.28	f	0	clear sky	2026-05-22 17:09:19+00	2026-05-22 17:11:42.757823+00
0343c8c7-105e-4446-8738-5d65c74ab150	11058438-9274-473f-bd2c-115fdb27b414	b6527c4b-db0d-4f5a-8f43-59027a85c796	31.99	30.17	31.99	37	1008	25.92	350	N	0	t	0	clear sky	2026-05-22 17:09:58+00	2026-05-22 17:11:43.057092+00
0964aeb7-c6a4-42eb-9894-c729227c571a	3febc9d0-6443-496c-9ba6-55af7a506145	b6527c4b-db0d-4f5a-8f43-59027a85c796	31.19	31.19	35.12	27	1017	11.12	340	NNW	0	f	0	scattered clouds	2026-05-22 17:06:22+00	2026-05-22 17:11:43.346012+00
fb5e41e4-9725-441c-865e-7ee3f5ee2b4b	d981da53-c316-48f1-8e7f-b9f42d74afa0	b6527c4b-db0d-4f5a-8f43-59027a85c796	31.03	31.03	31.03	18	1019	17.46	76	ENE	25.34	f	0	clear sky	2026-05-22 17:01:50+00	2026-05-22 17:11:43.665114+00
5aa3742c-70ff-493a-8b9a-985e901c59e4	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	7d46fa00-7f9d-40ae-baab-473785b4ccdf	27.42	27.42	27.42	28	1015	12.96	0	N	0	f	0	few clouds	2026-05-22 17:50:48+00	2026-05-22 18:00:26.680692+00
c25c9819-d6b3-41c4-a8ab-dc0056c0626f	fc248375-8ec4-4683-9613-c149579eb366	7d46fa00-7f9d-40ae-baab-473785b4ccdf	32.62	32.62	32.62	14	1013	27.9	69	ENE	45.97	f	0	clear sky	2026-05-22 17:51:43+00	2026-05-22 18:00:27.023633+00
6ca35238-2db8-46cf-a118-376464903463	6432350e-9525-49a7-9965-65ace30857c2	7d46fa00-7f9d-40ae-baab-473785b4ccdf	35.96	35.14	35.96	30	1007	9.25	260	W	0	f	0	clear sky	2026-05-22 17:45:43+00	2026-05-22 18:00:27.31053+00
bfc00de5-a0b7-4dab-9872-62fd66b572da	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	7d46fa00-7f9d-40ae-baab-473785b4ccdf	27.95	27.95	27.95	32	1013	5.54	330	NNW	0	t	0	clear sky	2026-05-22 17:57:04+00	2026-05-22 18:00:27.585562+00
7c3a3e13-9b25-4f8f-8e54-06e0f07592bd	1e806627-87ea-4c01-aad4-9f05ce90c257	7d46fa00-7f9d-40ae-baab-473785b4ccdf	19.1	19.1	19.1	83	1015	12.89	212	SSW	13.68	t	0	few clouds	2026-05-22 17:56:35+00	2026-05-22 18:00:27.890357+00
06fd090d-2b3d-4bcd-b418-72f1a03ab730	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	7d46fa00-7f9d-40ae-baab-473785b4ccdf	20.05	20.05	20.75	49	1016	12.96	260	W	0	t	0	few clouds	2026-05-22 17:55:17+00	2026-05-22 18:00:28.291732+00
d603a177-9d61-4b24-ad1c-045a523d79d3	527f8a7d-5101-47fc-9889-f2e961c2b7e4	7d46fa00-7f9d-40ae-baab-473785b4ccdf	32.66	32.66	32.66	32	1011	22.5	340	NNW	26.24	t	0	clear sky	2026-05-22 17:59:54+00	2026-05-22 18:00:28.663435+00
d6672dc0-e036-4b2c-bf09-a4d1877dcfa6	11058438-9274-473f-bd2c-115fdb27b414	7d46fa00-7f9d-40ae-baab-473785b4ccdf	30.57	29.94	30.99	42	1009	22.21	340	NNW	0	f	0	clear sky	2026-05-22 17:50:13+00	2026-05-22 18:00:29.089018+00
bb0ece16-144e-4a04-82f5-42b8d7cdc3e0	3febc9d0-6443-496c-9ba6-55af7a506145	7d46fa00-7f9d-40ae-baab-473785b4ccdf	27.96	27.96	28.19	45	1017	9.25	300	WNW	0	f	0	broken clouds	2026-05-22 18:00:25+00	2026-05-22 18:00:29.433387+00
4911e1df-c3a9-4dc2-a713-1773293ce148	d981da53-c316-48f1-8e7f-b9f42d74afa0	7d46fa00-7f9d-40ae-baab-473785b4ccdf	30.3	30.3	30.3	18	1019	17.93	94	E	20.45	f	0	clear sky	2026-05-22 17:59:14+00	2026-05-22 18:00:29.813705+00
44bc9747-e4e5-4225-a3fd-0b2f519b499a	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	4a059ab1-144e-4005-b3d8-6d2e67ae399e	24.42	24.12	24.42	46	1015	33.34	30	NNE	0	f	0	clear sky	2026-05-22 18:50:32+00	2026-05-22 19:00:23.905169+00
0efd0c5f-c38a-41b9-934d-7beeeee6916f	fc248375-8ec4-4683-9613-c149579eb366	4a059ab1-144e-4005-b3d8-6d2e67ae399e	31.25	31.25	31.25	15	1013	27.14	81	E	44.53	f	0	clear sky	2026-05-22 18:50:00+00	2026-05-22 19:00:24.191017+00
e54337dd-bcc7-441b-84a6-c092938f3039	6432350e-9525-49a7-9965-65ace30857c2	4a059ab1-144e-4005-b3d8-6d2e67ae399e	35.96	35.14	35.96	21	1007	12.96	290	WNW	0	f	0	clear sky	2026-05-22 18:52:45+00	2026-05-22 19:00:24.458294+00
946967c4-d19f-4a8b-87a9-8f9407988709	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	4a059ab1-144e-4005-b3d8-6d2e67ae399e	25.95	25.95	25.95	36	1013	9.25	340	NNW	0	t	0	clear sky	2026-05-22 18:55:52+00	2026-05-22 19:00:24.73828+00
e8e995ec-0eaa-412d-b57a-64f14d21ada2	1e806627-87ea-4c01-aad4-9f05ce90c257	4a059ab1-144e-4005-b3d8-6d2e67ae399e	18.54	18.54	18.54	81	1015	14.4	220	SW	14.54	t	0	clear sky	2026-05-22 19:00:09+00	2026-05-22 19:00:25.029536+00
29a4f6da-fb4b-467e-950e-4255623865ab	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	4a059ab1-144e-4005-b3d8-6d2e67ae399e	19.05	18.75	19.05	55	1016	9.25	310	NW	0	t	0	broken clouds	2026-05-22 18:51:02+00	2026-05-22 19:00:25.304536+00
d8510ba0-1b4e-47b2-9284-851add5a1f25	527f8a7d-5101-47fc-9889-f2e961c2b7e4	4a059ab1-144e-4005-b3d8-6d2e67ae399e	32.66	32.66	32.66	33	1012	21.78	330	NNW	27.04	t	0	clear sky	2026-05-22 18:57:38+00	2026-05-22 19:00:25.59064+00
14e37669-64fd-4013-a144-af2dc99c65a8	11058438-9274-473f-bd2c-115fdb27b414	4a059ab1-144e-4005-b3d8-6d2e67ae399e	30.16	28.94	30.99	44	1009	20.38	330	NNW	0	t	0	clear sky	2026-05-22 19:00:00+00	2026-05-22 19:00:26.402128+00
254e9997-2beb-42d6-bac6-54f3d08e3662	3febc9d0-6443-496c-9ba6-55af7a506145	4a059ab1-144e-4005-b3d8-6d2e67ae399e	27.96	27.96	28.19	42	1017	9.25	330	NNW	0	f	0	scattered clouds	2026-05-22 18:57:29+00	2026-05-22 19:00:26.68705+00
a9c102da-b1d4-4f14-8add-7b912dfc899d	d981da53-c316-48f1-8e7f-b9f42d74afa0	4a059ab1-144e-4005-b3d8-6d2e67ae399e	28.23	28.23	28.23	21	1020	16.56	134	SE	19.84	f	0	clear sky	2026-05-22 18:50:24+00	2026-05-22 19:00:27.632088+00
63229f2e-d745-4a71-83ef-46a0c34ae770	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	718f4999-0e6e-4063-b761-d23db105bcfd	23.42	23.01	23.42	49	1016	29.63	40	NE	0	t	0	clear sky	2026-05-22 19:58:02+00	2026-05-22 20:00:28.210607+00
6ef01e0c-c0f8-43c2-9ac9-e4a4e0397420	fc248375-8ec4-4683-9613-c149579eb366	718f4999-0e6e-4063-b761-d23db105bcfd	29.76	29.76	29.76	17	1014	19.84	80	E	34.6	f	0	clear sky	2026-05-22 19:58:52+00	2026-05-22 20:00:28.550294+00
f4789445-8b78-4181-a476-7c13deaeadba	6432350e-9525-49a7-9965-65ace30857c2	718f4999-0e6e-4063-b761-d23db105bcfd	34.96	34.14	34.96	23	1007	9.25	260	W	0	f	0	clear sky	2026-05-22 19:58:49+00	2026-05-22 20:00:28.86535+00
28cb88c0-a12b-4334-af15-bfe79ff2e109	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	718f4999-0e6e-4063-b761-d23db105bcfd	25.95	25.95	25.95	36	1013	7.42	0	N	0	t	0	clear sky	2026-05-22 19:50:17+00	2026-05-22 20:00:29.177199+00
8277f2d5-7fbb-4d3a-acfd-d104e9d68214	1e806627-87ea-4c01-aad4-9f05ce90c257	718f4999-0e6e-4063-b761-d23db105bcfd	17.99	17.99	17.99	82	1016	15.12	226	SW	15.48	t	0	clear sky	2026-05-22 20:00:29+00	2026-05-22 20:00:29.508494+00
4d58f365-f483-47e7-a2c4-ff0c7c911531	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	718f4999-0e6e-4063-b761-d23db105bcfd	18.05	17.75	18.05	59	1017	11.12	250	WSW	0	t	0	clear sky	2026-05-22 19:49:50+00	2026-05-22 20:00:29.816284+00
ad729a72-221e-4e86-ab5b-ad24f4c5a10d	527f8a7d-5101-47fc-9889-f2e961c2b7e4	718f4999-0e6e-4063-b761-d23db105bcfd	32.1	32.1	32.1	31	1012	20.7	330	NNW	26.78	t	0	clear sky	2026-05-22 19:59:02+00	2026-05-22 20:00:30.219627+00
4d8e69b8-c173-4903-bac4-c6c3a57d3148	11058438-9274-473f-bd2c-115fdb27b414	718f4999-0e6e-4063-b761-d23db105bcfd	29.57	28.94	29.99	43	1010	20.38	330	NNW	0	t	0	clear sky	2026-05-22 19:57:07+00	2026-05-22 20:00:30.532528+00
0c59e6f1-c5b4-42f1-81b0-01f9a0f2e8d7	3febc9d0-6443-496c-9ba6-55af7a506145	718f4999-0e6e-4063-b761-d23db105bcfd	25.18	25.18	25.19	65	1017	9.25	310	NW	0	f	0	clear sky	2026-05-22 19:57:39+00	2026-05-22 20:00:30.846161+00
a9f33e2e-68d2-48d0-a180-13e741acd1a4	d981da53-c316-48f1-8e7f-b9f42d74afa0	718f4999-0e6e-4063-b761-d23db105bcfd	27.02	27.02	27.02	23	1022	19.37	97	E	21.1	f	0	clear sky	2026-05-22 19:57:17+00	2026-05-22 20:00:31.176717+00
d8d7f7e4-0c77-4f02-a190-08bdd74df907	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	65f3cc48-166d-4d1c-8851-820645978551	22.42	21.9	22.42	53	1016	22.21	50	NE	0	t	0	clear sky	2026-05-22 20:50:46+00	2026-05-22 21:00:31.762747+00
443f9208-eea3-478f-9750-72c8cde33506	fc248375-8ec4-4683-9613-c149579eb366	65f3cc48-166d-4d1c-8851-820645978551	28.66	28.66	28.66	19	1013	16.2	77	ENE	28.84	f	0	clear sky	2026-05-22 20:56:54+00	2026-05-22 21:00:32.083048+00
86ab25a5-ce59-43f7-9633-dee41d4ff7b7	6432350e-9525-49a7-9965-65ace30857c2	65f3cc48-166d-4d1c-8851-820645978551	33.96	33.96	34.14	27	1007	11.12	260	W	0	f	0	clear sky	2026-05-22 20:56:01+00	2026-05-22 21:00:32.392903+00
05ac132b-182a-4257-a9a0-1d43854fc9c2	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	65f3cc48-166d-4d1c-8851-820645978551	25.95	25.95	25.95	34	1013	11.12	10	N	0	t	0	clear sky	2026-05-22 20:58:34+00	2026-05-22 21:00:32.740896+00
fb03917b-2e11-4f3b-b90a-f6cb58fd30d6	1e806627-87ea-4c01-aad4-9f05ce90c257	65f3cc48-166d-4d1c-8851-820645978551	17.99	17.99	17.99	79	1016	14.69	217	SW	15.98	t	0	clear sky	2026-05-22 20:53:26+00	2026-05-22 21:00:33.101174+00
acbf9dd1-f695-4e24-a223-dde14078c1b1	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	65f3cc48-166d-4d1c-8851-820645978551	18.05	16.75	18.05	63	1017	11.12	250	WSW	0	f	0	clear sky	2026-05-22 20:51:47+00	2026-05-22 21:00:33.42905+00
62a6bb98-6db9-4c2b-ba86-ece5e05d27c4	527f8a7d-5101-47fc-9889-f2e961c2b7e4	65f3cc48-166d-4d1c-8851-820645978551	31.55	31.55	31.55	34	1012	18.86	335	NNW	26.35	t	0	clear sky	2026-05-22 20:54:26+00	2026-05-22 21:00:33.744684+00
541c9250-1a5e-4f76-b9f3-f91786eda0a0	11058438-9274-473f-bd2c-115fdb27b414	65f3cc48-166d-4d1c-8851-820645978551	28.57	27.94	28.99	49	1010	29.63	320	NW	0	t	0	clear sky	2026-05-22 20:47:25+00	2026-05-22 21:00:34.050708+00
885d8697-4cf6-418c-866a-a055e2c2e897	3febc9d0-6443-496c-9ba6-55af7a506145	65f3cc48-166d-4d1c-8851-820645978551	24.13	24.07	26.12	64	1018	5.54	300	WNW	0	f	0	clear sky	2026-05-22 21:00:13+00	2026-05-22 21:00:34.3534+00
8c3870fe-68d1-47b1-aa10-878414fe6f32	d981da53-c316-48f1-8e7f-b9f42d74afa0	65f3cc48-166d-4d1c-8851-820645978551	23.69	23.69	23.69	39	1023	29.02	80	E	35.17	f	0	clear sky	2026-05-22 20:54:00+00	2026-05-22 21:00:34.655695+00
92b759dd-1b05-4bd4-9ae1-0b1735824725	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	fb314f85-3070-40db-a2f3-72aba9aa7227	22.42	21.9	22.42	53	1016	22.21	80	E	0	f	0	clear sky	2026-05-22 22:00:35+00	2026-05-22 22:00:35.383884+00
29945588-28ac-4572-b701-273e1a947981	fc248375-8ec4-4683-9613-c149579eb366	fb314f85-3070-40db-a2f3-72aba9aa7227	27.58	27.58	27.58	19	1013	12.53	67	ENE	22.32	f	0	clear sky	2026-05-22 21:58:44+00	2026-05-22 22:00:35.764856+00
0294a4ce-bff8-47ae-9aec-010eb4ae8695	6432350e-9525-49a7-9965-65ace30857c2	fb314f85-3070-40db-a2f3-72aba9aa7227	32.96	32.14	32.96	35	1007	11.12	260	W	0	f	0	clear sky	2026-05-22 21:58:22+00	2026-05-22 22:00:36.046516+00
bac0f33b-0768-478d-90fd-a538f9e376ad	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	fb314f85-3070-40db-a2f3-72aba9aa7227	24.95	24.95	24.95	36	1013	11.12	0	N	0	t	0	clear sky	2026-05-22 21:50:34+00	2026-05-22 22:00:36.325722+00
967eeca5-07b4-4142-bef2-4393fd7b8f13	1e806627-87ea-4c01-aad4-9f05ce90c257	fb314f85-3070-40db-a2f3-72aba9aa7227	16.88	16.88	16.88	78	1016	12.6	206	SSW	13.75	t	0	clear sky	2026-05-22 21:59:53+00	2026-05-22 22:00:36.614935+00
94c798bb-98f4-446c-943b-3eb7dcc45cc5	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	fb314f85-3070-40db-a2f3-72aba9aa7227	18.05	15.75	18.05	59	1017	11.12	260	W	0	f	0	clear sky	2026-05-22 21:58:01+00	2026-05-22 22:00:36.902064+00
c6b35bbd-cbf1-4342-9813-dcad1303f22c	527f8a7d-5101-47fc-9889-f2e961c2b7e4	fb314f85-3070-40db-a2f3-72aba9aa7227	30.99	30.99	30.99	36	1012	17.39	344	NNW	25.49	t	0	clear sky	2026-05-22 21:51:16+00	2026-05-22 22:00:37.170523+00
126d4c83-331b-45e5-99cd-31fb10ab1737	11058438-9274-473f-bd2c-115fdb27b414	fb314f85-3070-40db-a2f3-72aba9aa7227	28.57	27.94	28.99	49	1009	24.08	320	NW	0	t	0	clear sky	2026-05-22 21:59:53+00	2026-05-22 22:00:37.441766+00
6abff4c1-1644-4807-ab39-faee680a4809	3febc9d0-6443-496c-9ba6-55af7a506145	fb314f85-3070-40db-a2f3-72aba9aa7227	24.13	24.07	24.19	69	1018	5.54	310	NW	0	f	0	clear sky	2026-05-22 21:58:28+00	2026-05-22 22:00:37.777789+00
3d0395fa-9b77-4567-9eac-fe18f0ad6369	d981da53-c316-48f1-8e7f-b9f42d74afa0	fb314f85-3070-40db-a2f3-72aba9aa7227	23.19	23.19	23.19	39	1023	25.78	78	ENE	34.7	f	0	clear sky	2026-05-22 21:56:43+00	2026-05-22 22:00:38.048059+00
6cbac7b0-8861-435f-b99a-317a67b34dd6	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	7b9e08ca-17b9-45d5-b867-d890b86370d1	22.42	21.9	22.42	53	1015	18.5	80	E	0	t	0	clear sky	2026-05-22 22:56:52+00	2026-05-22 23:00:38.725315+00
a30bbc64-82e0-4349-a82c-c638b55f1060	fc248375-8ec4-4683-9613-c149579eb366	7b9e08ca-17b9-45d5-b867-d890b86370d1	26.79	26.79	26.79	20	1013	10.26	66	ENE	16.09	f	0	clear sky	2026-05-22 22:56:35+00	2026-05-22 23:00:39.026582+00
e337870c-dc55-4f8a-a882-07d2b24cd4a2	6432350e-9525-49a7-9965-65ace30857c2	7b9e08ca-17b9-45d5-b867-d890b86370d1	32.96	32.14	32.96	38	1007	9.25	290	WNW	0	f	0	clear sky	2026-05-22 22:58:20+00	2026-05-22 23:00:39.353786+00
53628f6a-0570-4703-bd1b-33e4c211c42f	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	7b9e08ca-17b9-45d5-b867-d890b86370d1	24.95	24.95	24.95	38	1013	12.96	0	N	0	t	0	clear sky	2026-05-22 22:51:06+00	2026-05-22 23:00:39.670332+00
07dc8fcb-47c9-4271-a652-32a51dda4e60	1e806627-87ea-4c01-aad4-9f05ce90c257	7b9e08ca-17b9-45d5-b867-d890b86370d1	15.77	15.77	15.77	78	1015	11.88	209	SSW	12.56	t	0	clear sky	2026-05-22 22:56:03+00	2026-05-22 23:00:40.000952+00
311bf168-1180-493c-8b6e-bc4e13c2e91d	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	7b9e08ca-17b9-45d5-b867-d890b86370d1	16.05	14.75	16.05	63	1016	5.54	320	NW	0	t	0	clear sky	2026-05-22 22:55:08+00	2026-05-22 23:00:40.315418+00
6b6f82c1-e525-4ef8-a896-bb232f856ab3	527f8a7d-5101-47fc-9889-f2e961c2b7e4	7b9e08ca-17b9-45d5-b867-d890b86370d1	30.99	30.99	30.99	35	1012	16.27	351	N	24.26	t	0	clear sky	2026-05-22 22:57:29+00	2026-05-22 23:00:40.625595+00
d75809c5-5ee6-4aa7-8fca-80162e2fe3e2	11058438-9274-473f-bd2c-115fdb27b414	7b9e08ca-17b9-45d5-b867-d890b86370d1	28.57	27.94	28.99	49	1009	33.34	320	NW	0	t	0	clear sky	2026-05-22 22:56:39+00	2026-05-22 23:00:40.961027+00
1e67fb15-749b-41f7-b146-2f070bbe6313	3febc9d0-6443-496c-9ba6-55af7a506145	7b9e08ca-17b9-45d5-b867-d890b86370d1	24.13	23.12	24.19	64	1018	3.71	0	N	0	f	0	clear sky	2026-05-22 23:00:01+00	2026-05-22 23:00:41.268976+00
cabc1f67-d805-44fe-99cc-595ca13ac8ff	d981da53-c316-48f1-8e7f-b9f42d74afa0	7b9e08ca-17b9-45d5-b867-d890b86370d1	22.26	22.26	22.26	40	1023	22.43	77	ENE	33.16	f	0	clear sky	2026-05-22 23:00:41+00	2026-05-22 23:00:41.603384+00
568c6969-aa26-4d57-a92f-70e6efe3c49b	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	a26c3935-7bb0-45e8-8b5a-e2b9d75a62b5	21.42	20.79	21.42	52	1015	16.67	80	E	0	t	0	clear sky	2026-05-22 23:54:47+00	2026-05-23 00:00:42.265309+00
f02c0588-139f-4245-99e6-546bfeb2a556	fc248375-8ec4-4683-9613-c149579eb366	a26c3935-7bb0-45e8-8b5a-e2b9d75a62b5	26.27	26.27	26.27	20	1013	7.67	69	ENE	8.89	f	0	clear sky	2026-05-22 23:51:41+00	2026-05-23 00:00:42.555776+00
da495c1c-97a9-4679-9653-0db903774739	6432350e-9525-49a7-9965-65ace30857c2	a26c3935-7bb0-45e8-8b5a-e2b9d75a62b5	31.96	31.96	32.14	43	1007	9.25	230	SW	0	f	0	clear sky	2026-05-22 23:56:27+00	2026-05-23 00:00:42.865029+00
8f7567b8-95fd-49e1-a604-d1edd35730fe	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	a26c3935-7bb0-45e8-8b5a-e2b9d75a62b5	23.95	23.95	23.95	38	1013	11.12	10	N	0	t	0	clear sky	2026-05-23 00:00:43+00	2026-05-23 00:00:43.196766+00
6e7ab794-2621-4372-89ff-48fed6231c1f	1e806627-87ea-4c01-aad4-9f05ce90c257	a26c3935-7bb0-45e8-8b5a-e2b9d75a62b5	16.32	16.32	16.32	78	1016	14.18	211	SSW	14.76	t	0	clear sky	2026-05-22 23:59:05+00	2026-05-23 00:00:43.52375+00
f504a2bc-5221-4535-bede-873d478c7fa4	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	a26c3935-7bb0-45e8-8b5a-e2b9d75a62b5	16.05	13.75	16.05	59	1016	5.54	110	ESE	0	t	0	clear sky	2026-05-22 23:53:15+00	2026-05-23 00:00:43.81981+00
352ca6cf-7203-4135-92c4-3f5921b6f1eb	527f8a7d-5101-47fc-9889-f2e961c2b7e4	a26c3935-7bb0-45e8-8b5a-e2b9d75a62b5	29.88	29.88	29.88	39	1012	15.8	356	N	22.57	t	0	clear sky	2026-05-23 00:00:44+00	2026-05-23 00:00:44.179168+00
2524f078-00a2-44ac-8780-7f28b0361f2c	11058438-9274-473f-bd2c-115fdb27b414	a26c3935-7bb0-45e8-8b5a-e2b9d75a62b5	28.57	27.94	28.99	49	1009	33.34	320	NW	0	t	0	clear sky	2026-05-22 23:53:38+00	2026-05-23 00:00:44.511822+00
038e5610-136a-4f43-9de7-5b45074b41df	3febc9d0-6443-496c-9ba6-55af7a506145	a26c3935-7bb0-45e8-8b5a-e2b9d75a62b5	24.13	22.12	24.19	64	1018	3.71	0	N	0	f	0	clear sky	2026-05-23 00:00:03+00	2026-05-23 00:00:44.832026+00
500a8898-f186-4efa-84d1-f79f6f2449d1	d981da53-c316-48f1-8e7f-b9f42d74afa0	a26c3935-7bb0-45e8-8b5a-e2b9d75a62b5	21.79	21.79	21.79	42	1022	17.75	83	E	27.79	f	0	clear sky	2026-05-22 23:57:24+00	2026-05-23 00:00:45.176294+00
72cf9e6c-faf0-423f-b2cb-b79f13f38834	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	25d0928d-07a0-4e2c-8a96-ab6790f9b038	22.42	21.9	22.42	46	1015	16.67	100	E	0	f	0	clear sky	2026-05-23 00:54:38+00	2026-05-23 01:00:45.900893+00
db2985c9-6c13-4238-9328-7c0d5edd3fb8	fc248375-8ec4-4683-9613-c149579eb366	25d0928d-07a0-4e2c-8a96-ab6790f9b038	25.7	25.7	25.7	22	1014	6.05	92	E	7.24	f	0	clear sky	2026-05-23 00:58:06+00	2026-05-23 01:00:46.178215+00
800786d3-70c1-46c9-b09e-c0ed9b6cf2ed	6432350e-9525-49a7-9965-65ace30857c2	25d0928d-07a0-4e2c-8a96-ab6790f9b038	30.96	30.96	31.14	48	1007	11.12	170	S	0	t	0	clear sky	2026-05-23 01:00:08+00	2026-05-23 01:00:46.452876+00
9f220498-2a95-4221-bcdd-8301c8b4c6f0	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	25d0928d-07a0-4e2c-8a96-ab6790f9b038	21.95	21.95	21.95	43	1013	3.71	340	NNW	0	t	0	clear sky	2026-05-23 00:58:36+00	2026-05-23 01:00:46.763263+00
e68e594b-9f6d-42d5-9b7c-47a8d91193f7	1e806627-87ea-4c01-aad4-9f05ce90c257	25d0928d-07a0-4e2c-8a96-ab6790f9b038	15.77	15.77	15.77	77	1016	14.65	195	SSW	16.06	t	0	clear sky	2026-05-23 01:00:02+00	2026-05-23 01:00:47.044423+00
0ebcebd8-9c1a-42b0-8d80-68176483161d	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	25d0928d-07a0-4e2c-8a96-ab6790f9b038	15.05	12.75	15.05	63	1017	0	0	N	0	f	0	clear sky	2026-05-23 00:56:42+00	2026-05-23 01:00:47.351496+00
5f3ceeca-14b5-45dc-ad59-ffa7abae8487	527f8a7d-5101-47fc-9889-f2e961c2b7e4	25d0928d-07a0-4e2c-8a96-ab6790f9b038	29.32	29.32	29.32	42	1012	16.09	355	N	22.54	t	0	clear sky	2026-05-23 00:58:59+00	2026-05-23 01:00:47.640224+00
9fcbb711-8b8a-43df-80ed-7ec82044f074	11058438-9274-473f-bd2c-115fdb27b414	25d0928d-07a0-4e2c-8a96-ab6790f9b038	28.57	27.17	28.99	48	1009	22.21	340	NNW	40.75	t	0	clear sky	2026-05-23 00:57:25+00	2026-05-23 01:00:47.943351+00
3df861cf-b128-4772-b8db-1184476cd312	3febc9d0-6443-496c-9ba6-55af7a506145	25d0928d-07a0-4e2c-8a96-ab6790f9b038	23.07	21.12	23.19	69	1017	5.54	320	NW	0	t	0	overcast clouds	2026-05-23 00:57:38+00	2026-05-23 01:00:48.243178+00
0ebbdd02-75b5-4c81-ac64-727b5f136c4d	d981da53-c316-48f1-8e7f-b9f42d74afa0	25d0928d-07a0-4e2c-8a96-ab6790f9b038	21.21	21.21	21.21	44	1022	13.57	89	E	21.1	f	0	clear sky	2026-05-23 00:50:28+00	2026-05-23 01:00:48.554403+00
95a2b65b-9312-4380-82cd-7dd13126d4c6	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	986a4b80-7331-46f5-9962-807089758667	21.42	20.79	21.42	49	1015	9.25	110	ESE	0	t	0	clear sky	2026-05-23 01:56:07+00	2026-05-23 02:00:49.218363+00
bef73f84-67d7-4d6e-b456-135a6cc3cc2f	fc248375-8ec4-4683-9613-c149579eb366	986a4b80-7331-46f5-9962-807089758667	25.28	25.28	25.28	23	1014	5.22	93	E	6.48	f	0	clear sky	2026-05-23 01:57:19+00	2026-05-23 02:00:49.498981+00
d1ef3195-1c5b-4899-b86b-fc8c7848d29c	6432350e-9525-49a7-9965-65ace30857c2	986a4b80-7331-46f5-9962-807089758667	30.96	30.14	30.96	48	1007	11.12	190	S	0	t	0	clear sky	2026-05-23 01:55:04+00	2026-05-23 02:00:49.774103+00
da20da9c-e4ba-48c0-96db-1bebfbe9a1ad	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	986a4b80-7331-46f5-9962-807089758667	19.95	19.95	19.95	45	1013	1.84	320	NW	0	t	0	clear sky	2026-05-23 01:51:15+00	2026-05-23 02:00:50.045367+00
0e36d838-3bdd-4f63-ac06-add490b4ea94	1e806627-87ea-4c01-aad4-9f05ce90c257	986a4b80-7331-46f5-9962-807089758667	16.32	16.32	16.32	71	1015	10.87	193	SSW	11.7	t	0	clear sky	2026-05-23 01:56:43+00	2026-05-23 02:00:50.305671+00
9436d24d-40bf-4dd1-a1ae-13c1b01a0139	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	986a4b80-7331-46f5-9962-807089758667	15.05	11.75	15.05	58	1017	5.54	90	E	0	f	0	clear sky	2026-05-23 01:57:45+00	2026-05-23 02:00:50.602431+00
f4c05c01-d787-4f5a-91ff-b48df47c5f35	527f8a7d-5101-47fc-9889-f2e961c2b7e4	986a4b80-7331-46f5-9962-807089758667	28.21	28.21	28.21	43	1012	14.87	355	N	20.27	t	0	clear sky	2026-05-23 01:56:28+00	2026-05-23 02:00:50.886844+00
c812b2f3-f0ba-492b-9006-218501728cb3	11058438-9274-473f-bd2c-115fdb27b414	986a4b80-7331-46f5-9962-807089758667	28.57	27.17	28.99	44	1009	25.92	340	NNW	0	t	0	clear sky	2026-05-23 02:00:51+00	2026-05-23 02:00:51.168781+00
753c9cb7-a03b-4294-b3b5-3333f7296b40	3febc9d0-6443-496c-9ba6-55af7a506145	986a4b80-7331-46f5-9962-807089758667	22.02	21.12	22.19	78	1017	3.71	0	N	0	t	0	overcast clouds	2026-05-23 02:00:23+00	2026-05-23 02:00:51.442099+00
95f09e34-b246-4d0d-a39a-28fbccc7e2ba	d981da53-c316-48f1-8e7f-b9f42d74afa0	986a4b80-7331-46f5-9962-807089758667	20.99	20.99	20.99	47	1023	12.02	86	E	19.19	f	0	clear sky	2026-05-23 01:56:27+00	2026-05-23 02:00:51.713094+00
54630a8d-1d78-4130-97a3-681405f2467f	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	c77e7941-9e80-4f05-8251-9045d85db055	21.42	20.79	21.42	49	1015	7.42	100	E	0	f	0	clear sky	2026-05-23 03:00:22+00	2026-05-23 03:00:52.223698+00
4ed8515d-05f9-4ef4-bd0b-1237fab43a78	fc248375-8ec4-4683-9613-c149579eb366	c77e7941-9e80-4f05-8251-9045d85db055	25.8	25.8	25.8	23	1015	8.64	59	ENE	10.76	f	0	clear sky	2026-05-23 02:54:30+00	2026-05-23 03:00:52.526636+00
0c689361-ed1e-4130-b218-0f33dde08bbe	6432350e-9525-49a7-9965-65ace30857c2	c77e7941-9e80-4f05-8251-9045d85db055	28.96	28.96	29.14	42	1008	12.96	210	SSW	0	t	0	clear sky	2026-05-23 02:57:07+00	2026-05-23 03:00:52.818084+00
e0f0c8f3-dbbd-4d47-a7b1-28a33fb43953	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	c77e7941-9e80-4f05-8251-9045d85db055	21.95	21.95	21.95	40	1014	5.54	0	N	0	t	0	clear sky	2026-05-23 02:52:21+00	2026-05-23 03:00:53.101481+00
dbe824dd-2277-44b5-9c36-c28ccaed482b	1e806627-87ea-4c01-aad4-9f05ce90c257	c77e7941-9e80-4f05-8251-9045d85db055	15.77	15.77	15.77	72	1016	12.49	211	SSW	12.02	t	0	clear sky	2026-05-23 02:56:30+00	2026-05-23 03:00:53.378807+00
9e02d93d-e248-4b49-abdf-df93fcda7815	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	c77e7941-9e80-4f05-8251-9045d85db055	14.05	11.75	14.05	67	1017	5.54	90	E	0	f	0	clear sky	2026-05-23 02:51:59+00	2026-05-23 03:00:53.647777+00
81198138-b99d-4bb9-9d30-c1fa4a5ed462	527f8a7d-5101-47fc-9889-f2e961c2b7e4	c77e7941-9e80-4f05-8251-9045d85db055	29.32	29.32	29.32	41	1013	13.93	352	N	17.71	t	0	clear sky	2026-05-23 03:00:38+00	2026-05-23 03:00:53.923255+00
a214d37e-7056-4872-8552-69b0d66e4073	11058438-9274-473f-bd2c-115fdb27b414	c77e7941-9e80-4f05-8251-9045d85db055	29.16	27.17	29.99	42	1010	35.17	340	NNW	0	t	0	clear sky	2026-05-23 03:00:23+00	2026-05-23 03:00:54.197902+00
3cddcb33-26d4-4d95-bae2-3a5a1a9bc019	3febc9d0-6443-496c-9ba6-55af7a506145	c77e7941-9e80-4f05-8251-9045d85db055	22.02	21.12	22.19	78	1016	3.71	0	N	0	t	0	broken clouds	2026-05-23 02:57:15+00	2026-05-23 03:00:54.49074+00
48beae13-d76d-4080-a743-97ae21af5f5a	d981da53-c316-48f1-8e7f-b9f42d74afa0	c77e7941-9e80-4f05-8251-9045d85db055	20.18	20.18	20.18	48	1023	10.87	86	E	16.6	f	0	clear sky	2026-05-23 02:47:51+00	2026-05-23 03:00:54.764084+00
ecad97e2-e46d-48b0-8a7f-9c8a90aa756c	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	5928324c-07e0-4ea7-a7e0-19613afd53e4	20.42	20.23	20.42	49	1015	7.42	70	ENE	0	t	0	clear sky	2026-05-23 03:56:49+00	2026-05-23 04:00:55.492186+00
95260dc8-dc06-4832-85fc-c865146e3098	fc248375-8ec4-4683-9613-c149579eb366	5928324c-07e0-4ea7-a7e0-19613afd53e4	26.47	26.47	26.47	20	1015	10.12	67	ENE	14.15	f	0	clear sky	2026-05-23 03:55:29+00	2026-05-23 04:00:55.771526+00
53e02f06-ac25-4a7e-9d26-8cb02abf5f92	6432350e-9525-49a7-9965-65ace30857c2	5928324c-07e0-4ea7-a7e0-19613afd53e4	29.96	29.96	31.14	45	1008	7.42	210	SSW	0	t	0	clear sky	2026-05-23 03:55:13+00	2026-05-23 04:00:56.052602+00
398552a8-bb1b-4125-88c9-10c392bd4358	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	5928324c-07e0-4ea7-a7e0-19613afd53e4	21.95	21.95	21.95	43	1014	5.54	340	NNW	0	t	0	clear sky	2026-05-23 04:00:56+00	2026-05-23 04:00:56.360802+00
2e1381d7-a345-499c-abdd-b3e0362b3df0	1e806627-87ea-4c01-aad4-9f05ce90c257	5928324c-07e0-4ea7-a7e0-19613afd53e4	17.99	17.99	17.99	72	1016	14.26	217	SW	13.43	t	0	clear sky	2026-05-23 03:59:45+00	2026-05-23 04:00:56.634038+00
910c88b0-50f8-4db3-ba1e-608b1b1e6a18	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	5928324c-07e0-4ea7-a7e0-19613afd53e4	15.05	11.75	15.05	55	1018	3.71	70	ENE	0	f	0	clear sky	2026-05-23 03:50:52+00	2026-05-23 04:00:56.922148+00
0e4dd0a1-f304-4bde-b54b-a84ef75a9e8e	527f8a7d-5101-47fc-9889-f2e961c2b7e4	5928324c-07e0-4ea7-a7e0-19613afd53e4	29.88	29.88	29.88	45	1013	13.32	353	N	16.13	t	0	clear sky	2026-05-23 03:51:19+00	2026-05-23 04:00:57.253961+00
7ba60de4-014e-4e94-8713-7569f00d990f	11058438-9274-473f-bd2c-115fdb27b414	5928324c-07e0-4ea7-a7e0-19613afd53e4	30.16	28.94	30.99	41	1010	35.17	350	N	0	t	0	clear sky	2026-05-23 03:56:11+00	2026-05-23 04:00:57.533232+00
e03516f4-112a-4c53-8193-d96d032b20ad	3febc9d0-6443-496c-9ba6-55af7a506145	5928324c-07e0-4ea7-a7e0-19613afd53e4	21.85	21.85	22.19	78	1016	1.84	0	N	0	t	0	broken clouds	2026-05-23 03:59:32+00	2026-05-23 04:00:57.831899+00
15dddbae-2bd5-4660-a17e-9f8350012b75	d981da53-c316-48f1-8e7f-b9f42d74afa0	5928324c-07e0-4ea7-a7e0-19613afd53e4	19.43	19.43	19.43	53	1023	9.9	85	E	13	f	0	clear sky	2026-05-23 03:59:26+00	2026-05-23 04:00:58.125719+00
9f62b1e6-5139-48c4-a8a9-596ca9bf7a28	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	7142becc-238e-4600-bc7d-2ab99f90b2bc	22.42	21.9	22.42	46	1016	5.54	0	N	0	f	0	clear sky	2026-05-23 04:55:57+00	2026-05-23 05:00:58.763423+00
c5cba795-875f-4a91-8cb2-9e361bf64149	fc248375-8ec4-4683-9613-c149579eb366	7142becc-238e-4600-bc7d-2ab99f90b2bc	28.51	28.51	28.51	17	1015	10.84	70	ENE	13	f	0	clear sky	2026-05-23 04:52:51+00	2026-05-23 05:00:59.085419+00
a6a52467-dec7-4e43-9f39-ca06340d9b5b	6432350e-9525-49a7-9965-65ace30857c2	7142becc-238e-4600-bc7d-2ab99f90b2bc	31.96	31.96	33.14	48	1009	12.96	220	SW	0	t	0	clear sky	2026-05-23 04:56:48+00	2026-05-23 05:00:59.434353+00
edcd956e-c528-48f7-9476-8dea3beae152	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	7142becc-238e-4600-bc7d-2ab99f90b2bc	25.95	25.95	25.95	38	1015	7.42	0	N	0	f	0	clear sky	2026-05-23 04:51:30+00	2026-05-23 05:00:59.737091+00
80cf39cc-3fe7-4b49-a6cf-b80d63ff6d8e	1e806627-87ea-4c01-aad4-9f05ce90c257	7142becc-238e-4600-bc7d-2ab99f90b2bc	20.77	20.77	20.77	68	1016	14.36	224	SW	13.75	t	0	clear sky	2026-05-23 04:58:59+00	2026-05-23 05:01:00.070133+00
61a2d67b-1e69-4e69-bda0-1f0be0a1982a	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	7142becc-238e-4600-bc7d-2ab99f90b2bc	15.05	14.75	15.05	63	1018	3.71	130	SE	0	f	0	smoke	2026-05-23 04:53:28+00	2026-05-23 05:01:00.400215+00
dc8b24ce-4596-4666-8864-95f2dfc3c730	527f8a7d-5101-47fc-9889-f2e961c2b7e4	7142becc-238e-4600-bc7d-2ab99f90b2bc	29.88	29.88	29.88	45	1014	12.82	348	NNW	14.94	t	0	clear sky	2026-05-23 04:54:34+00	2026-05-23 05:01:00.726327+00
7d40350a-37b5-46db-b919-9c73ed192ee6	11058438-9274-473f-bd2c-115fdb27b414	7142becc-238e-4600-bc7d-2ab99f90b2bc	30.57	29.94	31.17	41	1011	37.04	350	N	0	t	0	clear sky	2026-05-23 04:53:15+00	2026-05-23 05:01:01.053131+00
1f824f4b-ce4c-46cb-b795-eb9685392ce8	3febc9d0-6443-496c-9ba6-55af7a506145	7142becc-238e-4600-bc7d-2ab99f90b2bc	21.19	19.12	21.19	83	1017	1.84	0	N	0	t	0	broken clouds	2026-05-23 04:57:55+00	2026-05-23 05:01:01.353947+00
51251bc8-ca16-431d-b0bc-f57ea8706eb8	d981da53-c316-48f1-8e7f-b9f42d74afa0	7142becc-238e-4600-bc7d-2ab99f90b2bc	19.55	19.55	19.55	53	1023	9	82	E	12.46	f	0	clear sky	2026-05-23 04:57:47+00	2026-05-23 05:01:01.663106+00
d576a462-6dcd-4a83-9aad-a108e8d7c934	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	ae92bed6-dd52-4685-b597-2f75132f5346	24.42	24.12	24.42	41	1016	7.42	330	NNW	0	f	0	clear sky	2026-05-23 05:46:37+00	2026-05-23 06:00:02.330821+00
a2b99764-6413-40dd-848a-6d1f7c622d48	fc248375-8ec4-4683-9613-c149579eb366	ae92bed6-dd52-4685-b597-2f75132f5346	30.01	30.01	30.01	16	1015	11.34	79	E	12.89	f	0	clear sky	2026-05-23 05:57:47+00	2026-05-23 06:00:02.638834+00
c95eb899-a7ae-40d9-bb6f-f02efa0854cc	6432350e-9525-49a7-9965-65ace30857c2	ae92bed6-dd52-4685-b597-2f75132f5346	33.96	33.96	35.14	46	1009	12.96	230	SW	0	f	0	clear sky	2026-05-23 05:45:10+00	2026-05-23 06:00:02.939943+00
12ac68cb-137e-4469-a9bf-b01646173cfe	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	ae92bed6-dd52-4685-b597-2f75132f5346	28.95	28.95	28.95	32	1015	9.25	30	NNE	0	f	0	clear sky	2026-05-23 05:59:04+00	2026-05-23 06:00:03.237564+00
40891842-287c-4539-b18a-3e7c169ffc97	1e806627-87ea-4c01-aad4-9f05ce90c257	ae92bed6-dd52-4685-b597-2f75132f5346	20.77	20.77	20.77	71	1016	15.73	228	SW	14.87	t	0	clear sky	2026-05-23 06:00:02+00	2026-05-23 06:00:03.523068+00
9d6b86dc-7bba-4d1d-b7a8-e196dde12ee0	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	ae92bed6-dd52-4685-b597-2f75132f5346	19.05	16.75	19.05	45	1018	3.71	0	N	0	f	0	haze	2026-05-23 05:47:38+00	2026-05-23 06:00:03.828783+00
24524ebc-ffdb-493a-9166-838fa7f05b21	527f8a7d-5101-47fc-9889-f2e961c2b7e4	ae92bed6-dd52-4685-b597-2f75132f5346	30.99	30.99	30.99	44	1014	11.45	337	NNW	14.29	f	0	clear sky	2026-05-23 06:00:03+00	2026-05-23 06:00:04.110867+00
a13e9158-1f4e-4277-9d69-d7acc03a617b	11058438-9274-473f-bd2c-115fdb27b414	ae92bed6-dd52-4685-b597-2f75132f5346	32.16	30.94	33.17	38	1011	35.17	0	N	0	t	0	clear sky	2026-05-23 05:55:58+00	2026-05-23 06:00:04.400882+00
04094310-71e2-4cdd-aa76-b486abd54194	3febc9d0-6443-496c-9ba6-55af7a506145	ae92bed6-dd52-4685-b597-2f75132f5346	22.02	21.12	22.19	64	1017	1.84	0	N	0	t	0	scattered clouds	2026-05-23 05:56:26+00	2026-05-23 06:00:04.673265+00
572f9b4a-9cda-443c-a87b-d5cf331ddd74	d981da53-c316-48f1-8e7f-b9f42d74afa0	ae92bed6-dd52-4685-b597-2f75132f5346	21.21	21.21	21.21	52	1024	8.82	83	E	10.66	f	0	clear sky	2026-05-23 05:56:34+00	2026-05-23 06:00:04.976468+00
b1a961e5-0d5c-4b58-9ad8-57eee025ac84	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	ab700634-6421-4a46-8878-14363880cdcb	26.42	25.79	26.42	36	1016	7.42	330	NNW	0	f	0	clear sky	2026-05-23 06:55:03+00	2026-05-23 07:00:05.645734+00
47c7fe38-0d2e-4bb8-a678-c9b1cb505df5	fc248375-8ec4-4683-9613-c149579eb366	ab700634-6421-4a46-8878-14363880cdcb	31.93	31.93	31.93	13	1015	9.97	74	ENE	11.2	f	0	clear sky	2026-05-23 06:53:43+00	2026-05-23 07:00:05.940709+00
bcf0ce40-4138-424e-b07e-1700baadc1fc	6432350e-9525-49a7-9965-65ace30857c2	ab700634-6421-4a46-8878-14363880cdcb	34.96	34.96	37.14	31	1008	12.96	260	W	0	f	0	clear sky	2026-05-23 06:58:38+00	2026-05-23 07:00:06.243569+00
9d075c19-2ead-45ff-bafd-8368a99be3a6	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	ab700634-6421-4a46-8878-14363880cdcb	30.95	30.95	30.95	23	1014	7.42	30	NNE	0	f	0	clear sky	2026-05-23 07:00:00+00	2026-05-23 07:00:06.543153+00
b0c06a17-cdbc-44ed-8c0c-b20e53dcc2e0	1e806627-87ea-4c01-aad4-9f05ce90c257	ab700634-6421-4a46-8878-14363880cdcb	22.43	22.43	22.43	69	1016	18.5	227	SW	18	t	0	clear sky	2026-05-23 07:00:06+00	2026-05-23 07:00:06.856479+00
7e9ff054-78d4-41b0-85dd-8248b1317cf8	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	ab700634-6421-4a46-8878-14363880cdcb	21.05	18.75	21.05	35	1018	16.67	280	W	0	f	0	haze	2026-05-23 06:54:30+00	2026-05-23 07:00:07.143829+00
06d97e24-ff25-45b7-8e9f-2cee750042cb	527f8a7d-5101-47fc-9889-f2e961c2b7e4	ab700634-6421-4a46-8878-14363880cdcb	30.99	30.99	30.99	44	1014	9.9	333	NNW	14.36	f	0	clear sky	2026-05-23 06:53:17+00	2026-05-23 07:00:07.461144+00
675412d7-c2cf-4190-9d67-330d610cd654	11058438-9274-473f-bd2c-115fdb27b414	ab700634-6421-4a46-8878-14363880cdcb	33.16	31.94	35.17	34	1010	38.88	350	N	0	t	0	clear sky	2026-05-23 07:00:07+00	2026-05-23 07:00:07.771393+00
54f2c5b3-14db-4528-8a08-3e0f30786804	3febc9d0-6443-496c-9ba6-55af7a506145	ab700634-6421-4a46-8878-14363880cdcb	22.02	21.12	22.19	60	1017	1.84	0	N	0	f	0	scattered clouds	2026-05-23 07:00:02+00	2026-05-23 07:00:08.057922+00
798831a2-d564-47fa-8eb6-f7b710b5b296	d981da53-c316-48f1-8e7f-b9f42d74afa0	ab700634-6421-4a46-8878-14363880cdcb	22.96	22.96	22.96	48	1024	7.06	91	E	6.84	f	0	clear sky	2026-05-23 06:57:02+00	2026-05-23 07:00:08.344038+00
4016374e-8107-4144-bb52-302b860f6a03	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	bcb5d564-cf32-4484-aa39-1f645cf878c7	27.42	26.9	27.42	34	1016	7.42	330	NNW	0	f	0	clear sky	2026-05-23 07:59:59+00	2026-05-23 08:00:09.081531+00
d82563de-e438-4461-8d10-c2ad7af08487	fc248375-8ec4-4683-9613-c149579eb366	bcb5d564-cf32-4484-aa39-1f645cf878c7	34.26	34.26	34.26	11	1014	9.61	95	E	9.86	f	0	clear sky	2026-05-23 08:00:02+00	2026-05-23 08:00:09.439361+00
0a9ccb76-da49-4d21-be40-2a91ee5992bf	6432350e-9525-49a7-9965-65ace30857c2	bcb5d564-cf32-4484-aa39-1f645cf878c7	36.96	36.96	38.14	25	1008	12.96	270	W	0	f	0	clear sky	2026-05-23 07:52:09+00	2026-05-23 08:00:09.780858+00
6cde83ed-a4f4-475a-8d7f-b0d2c2e79c37	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	bcb5d564-cf32-4484-aa39-1f645cf878c7	31.95	31.95	31.95	23	1014	7.42	0	N	0	f	0	clear sky	2026-05-23 07:50:26+00	2026-05-23 08:00:10.093396+00
e7d96c61-4a49-4cfb-96af-fa26238e9e45	1e806627-87ea-4c01-aad4-9f05ce90c257	bcb5d564-cf32-4484-aa39-1f645cf878c7	22.43	22.43	22.43	73	1017	18.97	228	SW	18.97	t	0	clear sky	2026-05-23 07:58:40+00	2026-05-23 08:00:10.454951+00
8113bfb2-d5a3-4ac4-a622-c0c63853722d	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	bcb5d564-cf32-4484-aa39-1f645cf878c7	22.05	21.75	22.05	30	1018	20.38	280	W	0	f	0	clear sky	2026-05-23 07:59:13+00	2026-05-23 08:00:10.823174+00
37ee2d16-c41b-4e70-8ea1-4d299a39f077	527f8a7d-5101-47fc-9889-f2e961c2b7e4	bcb5d564-cf32-4484-aa39-1f645cf878c7	30.44	30.44	30.44	46	1013	10.15	339	NNW	16.56	t	0	clear sky	2026-05-23 07:56:28+00	2026-05-23 08:00:11.158823+00
a80e7bd3-7cea-4379-adff-4cc225091404	11058438-9274-473f-bd2c-115fdb27b414	bcb5d564-cf32-4484-aa39-1f645cf878c7	34.57	33.94	37.17	26	1010	40.75	0	N	0	f	0	clear sky	2026-05-23 07:51:30+00	2026-05-23 08:00:11.470106+00
278536a8-86d8-4ab9-9b1c-2cd09eb76ea5	3febc9d0-6443-496c-9ba6-55af7a506145	bcb5d564-cf32-4484-aa39-1f645cf878c7	22.19	22.19	28.12	78	1018	1.84	0	N	0	f	0	few clouds	2026-05-23 08:00:11+00	2026-05-23 08:00:11.819958+00
be140a40-f5b6-4183-a74b-87ca0b67e83f	d981da53-c316-48f1-8e7f-b9f42d74afa0	bcb5d564-cf32-4484-aa39-1f645cf878c7	24.26	24.26	24.26	42	1024	3.2	86	E	4.93	f	0	clear sky	2026-05-23 07:47:01+00	2026-05-23 08:00:12.484647+00
1b57de0b-a749-404b-9578-58eaf7c53f0c	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	05f8c678-1418-4810-ba43-36e1bb009e1b	29.42	29.12	29.42	26	1015	9.25	340	NNW	0	f	0	scattered clouds	2026-05-23 08:54:10+00	2026-05-23 09:00:13.657675+00
1e162a9a-140b-4397-a82d-3734ceaa8abc	fc248375-8ec4-4683-9613-c149579eb366	05f8c678-1418-4810-ba43-36e1bb009e1b	36.28	36.28	36.28	10	1014	9.9	101	E	9.11	f	0	clear sky	2026-05-23 08:55:48+00	2026-05-23 09:00:13.965549+00
eff2b647-76c5-43ba-b009-b1d949cf1079	6432350e-9525-49a7-9965-65ace30857c2	05f8c678-1418-4810-ba43-36e1bb009e1b	36.96	36.96	39.14	22	1008	16.67	280	W	0	f	0	clear sky	2026-05-23 08:57:52+00	2026-05-23 09:00:14.324634+00
2a96ac45-3e3c-41b8-87bc-c3d9b6e49c7f	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	05f8c678-1418-4810-ba43-36e1bb009e1b	32.95	32.95	32.95	22	1014	7.42	0	N	0	f	0	clear sky	2026-05-23 09:00:02+00	2026-05-23 09:00:14.6448+00
44187e50-42ee-4b2e-b825-2ee4fd74a162	1e806627-87ea-4c01-aad4-9f05ce90c257	05f8c678-1418-4810-ba43-36e1bb009e1b	20.77	20.77	20.77	74	1017	18.14	227	SW	18.72	t	0	clear sky	2026-05-23 08:55:06+00	2026-05-23 09:00:14.948588+00
a2f7d177-8d13-4e24-8e42-a00ae47d7d21	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	05f8c678-1418-4810-ba43-36e1bb009e1b	23.05	22.75	23.05	27	1018	22.21	280	W	0	f	0	few clouds	2026-05-23 08:57:04+00	2026-05-23 09:00:15.273705+00
c886712b-d1b1-4bdd-ba15-62229e4d1123	527f8a7d-5101-47fc-9889-f2e961c2b7e4	05f8c678-1418-4810-ba43-36e1bb009e1b	34.18	34.18	34.18	35	1012	12.46	344	NNW	19.12	t	0	clear sky	2026-05-23 09:00:15+00	2026-05-23 09:00:15.62877+00
444fccb7-54bf-42e4-a219-4433d396b829	11058438-9274-473f-bd2c-115fdb27b414	05f8c678-1418-4810-ba43-36e1bb009e1b	35.16	33.94	38.17	26	1010	38.88	0	N	0	f	0	clear sky	2026-05-23 09:00:00+00	2026-05-23 09:00:15.966788+00
afd9c3f5-a459-4228-9f61-f2cf600de9aa	3febc9d0-6443-496c-9ba6-55af7a506145	05f8c678-1418-4810-ba43-36e1bb009e1b	25.74	25.74	26.19	54	1018	5.54	0	N	0	f	0	clear sky	2026-05-23 08:59:38+00	2026-05-23 09:00:16.3092+00
4cf0f5e0-981e-46a9-9d94-b970268ad71b	d981da53-c316-48f1-8e7f-b9f42d74afa0	05f8c678-1418-4810-ba43-36e1bb009e1b	25.67	25.67	25.67	36	1024	2.52	10	N	8.46	f	0	clear sky	2026-05-23 08:54:15+00	2026-05-23 09:00:16.642248+00
0447a960-70f8-4953-915e-b9ed310bdf9e	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	0ddb1370-3744-4c3d-9e40-aa48d3810b51	29.42	29.12	29.42	23	1015	14.83	320	NW	0	f	0	scattered clouds	2026-05-23 09:53:17+00	2026-05-23 10:00:17.649462+00
1bf005f4-4ea0-497a-998e-1c0b06078b94	fc248375-8ec4-4683-9613-c149579eb366	0ddb1370-3744-4c3d-9e40-aa48d3810b51	37.43	37.43	37.43	9	1013	9.22	99	E	8.71	f	0	clear sky	2026-05-23 09:57:51+00	2026-05-23 10:00:18.008419+00
25e90022-1103-4242-8066-121fabc559df	6432350e-9525-49a7-9965-65ace30857c2	0ddb1370-3744-4c3d-9e40-aa48d3810b51	37.96	37.96	39.14	18	1007	18.5	270	W	0	f	0	clear sky	2026-05-23 09:52:10+00	2026-05-23 10:00:18.66223+00
a824e5ca-6322-44f8-bf4f-f6e006475435	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	0ddb1370-3744-4c3d-9e40-aa48d3810b51	32.95	32.95	32.95	21	1013	7.42	60	ENE	0	f	0	clear sky	2026-05-23 09:49:24+00	2026-05-23 10:00:19.083661+00
8c4a430b-94d6-4017-8162-b6a637870e56	1e806627-87ea-4c01-aad4-9f05ce90c257	0ddb1370-3744-4c3d-9e40-aa48d3810b51	21.88	21.88	21.88	72	1017	17.53	233	SW	17.28	f	0	clear sky	2026-05-23 09:58:06+00	2026-05-23 10:00:19.510103+00
be361855-c968-4970-bd10-4a8d8d01e9b6	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	0ddb1370-3744-4c3d-9e40-aa48d3810b51	23.05	22.75	23.05	28	1017	22.21	260	W	0	f	0	few clouds	2026-05-23 10:00:04+00	2026-05-23 10:00:20.879302+00
28157151-cc48-4cf6-a49a-09bb67af2c53	527f8a7d-5101-47fc-9889-f2e961c2b7e4	0ddb1370-3744-4c3d-9e40-aa48d3810b51	30.99	30.99	30.99	47	1012	15.08	348	NNW	20.74	t	0	clear sky	2026-05-23 10:00:09+00	2026-05-23 10:00:21.231225+00
1f09cae6-4dbf-4ec4-aa1d-e0fc7dd8a7fe	11058438-9274-473f-bd2c-115fdb27b414	0ddb1370-3744-4c3d-9e40-aa48d3810b51	35.99	33.94	35.99	26	1010	37.04	0	N	0	f	0	clear sky	2026-05-23 09:59:57+00	2026-05-23 10:00:22.124779+00
542a3844-0933-419d-9cf8-35a4cb7db945	3febc9d0-6443-496c-9ba6-55af7a506145	0ddb1370-3744-4c3d-9e40-aa48d3810b51	27.96	27.96	28.19	48	1018	7.42	130	SE	0	f	0	clear sky	2026-05-23 10:00:01+00	2026-05-23 10:00:22.474064+00
89a00e6f-601c-4e96-96cb-e4872fe3df0e	d981da53-c316-48f1-8e7f-b9f42d74afa0	0ddb1370-3744-4c3d-9e40-aa48d3810b51	26.98	26.98	26.98	28	1023	2.84	342	NNW	10.3	f	0	clear sky	2026-05-23 09:53:33+00	2026-05-23 10:00:22.808585+00
6627bcc4-ed1a-472f-bac0-fd06615ed68a	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	4668b720-5df0-4a1c-b43e-58e99e3cee80	31.42	30.79	31.42	15	1015	12.96	240	WSW	0	f	0	scattered clouds	2026-05-23 11:00:01+00	2026-05-23 11:00:55.135074+00
90b46779-78b3-4af0-b90e-4c3a6dbcb669	fc248375-8ec4-4683-9613-c149579eb366	4668b720-5df0-4a1c-b43e-58e99e3cee80	38.33	38.33	38.33	8	1012	8.46	87	E	10.51	f	0	clear sky	2026-05-23 10:57:09+00	2026-05-23 11:00:55.471089+00
e8b424f6-1fad-4993-9dcf-7804e0825367	6432350e-9525-49a7-9965-65ace30857c2	4668b720-5df0-4a1c-b43e-58e99e3cee80	37.96	37.96	40.14	17	1007	20.38	280	W	0	f	0	clear sky	2026-05-23 10:54:52+00	2026-05-23 11:00:55.809515+00
c22c2369-a146-4580-b282-9d3f17344df8	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	4668b720-5df0-4a1c-b43e-58e99e3cee80	33.95	33.95	33.95	21	1012	11.12	0	N	0	f	0	clear sky	2026-05-23 10:53:22+00	2026-05-23 11:00:56.139035+00
44ce866e-7ebc-4112-9cb5-23d014494f41	1e806627-87ea-4c01-aad4-9f05ce90c257	4668b720-5df0-4a1c-b43e-58e99e3cee80	21.88	21.88	21.88	73	1017	15.88	240	WSW	15.8	f	0	clear sky	2026-05-23 10:51:53+00	2026-05-23 11:00:56.454828+00
aa3a782d-47f8-4f1f-81a9-ba16837ba341	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	4668b720-5df0-4a1c-b43e-58e99e3cee80	24.05	23.75	24.05	27	1017	22.21	260	W	0	f	0	few clouds	2026-05-23 10:55:05+00	2026-05-23 11:00:56.788427+00
e14a06c5-2dac-426c-b710-11f73ede9e05	527f8a7d-5101-47fc-9889-f2e961c2b7e4	4668b720-5df0-4a1c-b43e-58e99e3cee80	35.63	35.63	35.63	37	1011	15.3	351	N	20.48	t	0	clear sky	2026-05-23 11:00:57+00	2026-05-23 11:00:57.186075+00
53532fbe-5116-40b9-b344-ef57eb24909a	11058438-9274-473f-bd2c-115fdb27b414	4668b720-5df0-4a1c-b43e-58e99e3cee80	36.99	34.94	36.99	25	1009	37.04	0	N	0	f	0	clear sky	2026-05-23 11:00:01+00	2026-05-23 11:00:57.504113+00
351e5b88-096d-438e-b94f-c3aa950e45d6	3febc9d0-6443-496c-9ba6-55af7a506145	4668b720-5df0-4a1c-b43e-58e99e3cee80	31.85	31.85	32.19	29	1018	3.71	0	N	0	f	0	clear sky	2026-05-23 11:00:02+00	2026-05-23 11:00:57.864585+00
b98458cd-39e1-49ec-8109-9ffcea4d5c5f	d981da53-c316-48f1-8e7f-b9f42d74afa0	4668b720-5df0-4a1c-b43e-58e99e3cee80	28.44	28.44	28.44	26	1023	4.03	323	NW	14.26	f	0	clear sky	2026-05-23 10:56:43+00	2026-05-23 11:00:58.207854+00
0e8abaef-cd59-4921-9cd9-2b66b0bfcb06	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	6b6e2a49-0153-4cb8-916f-63abadf4f6d6	31.42	30.79	31.42	16	1014	18.5	310	NW	0	f	0	scattered clouds	2026-05-23 11:56:33+00	2026-05-23 12:00:58.804299+00
5bfe80d9-daa1-4d49-96d3-e797e2aed62c	fc248375-8ec4-4683-9613-c149579eb366	6b6e2a49-0153-4cb8-916f-63abadf4f6d6	38.52	38.52	38.52	7	1012	7.67	71	ENE	10.8	f	0	clear sky	2026-05-23 11:50:08+00	2026-05-23 12:00:59.145283+00
227a2d8a-f32d-4de4-a501-ff5e8db2e1cf	6432350e-9525-49a7-9965-65ace30857c2	6b6e2a49-0153-4cb8-916f-63abadf4f6d6	36.96	36.96	39.14	25	1006	20.38	280	W	0	f	0	clear sky	2026-05-23 11:56:45+00	2026-05-23 12:01:00.481153+00
29d01069-e4a7-4698-8839-42f193e4708a	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	6b6e2a49-0153-4cb8-916f-63abadf4f6d6	34.95	34.95	34.95	18	1012	9.25	0	N	0	f	0	clear sky	2026-05-23 11:55:31+00	2026-05-23 12:01:00.817156+00
f1524ec2-cd85-422a-be07-c9e6b6d41346	1e806627-87ea-4c01-aad4-9f05ce90c257	6b6e2a49-0153-4cb8-916f-63abadf4f6d6	22.43	22.43	22.43	71	1017	14.58	241	WSW	14.26	f	0	clear sky	2026-05-23 11:54:00+00	2026-05-23 12:01:01.142377+00
1fa880f8-80b6-400b-b401-f2b4135af528	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	6b6e2a49-0153-4cb8-916f-63abadf4f6d6	24.05	23.75	24.05	27	1017	18.5	260	W	0	f	0	few clouds	2026-05-23 11:56:47+00	2026-05-23 12:01:01.470241+00
a73151eb-95ab-413b-98fa-c0444fbf1db5	527f8a7d-5101-47fc-9889-f2e961c2b7e4	6b6e2a49-0153-4cb8-916f-63abadf4f6d6	35.91	35.91	35.91	37	1010	15.66	352	N	21.35	f	0	clear sky	2026-05-23 12:00:02+00	2026-05-23 12:01:02.25997+00
753bb030-1783-4b02-bdb4-31d9589264b0	11058438-9274-473f-bd2c-115fdb27b414	6b6e2a49-0153-4cb8-916f-63abadf4f6d6	37.99	35.94	37.99	19	1009	35.17	0	N	0	f	0	clear sky	2026-05-23 11:56:07+00	2026-05-23 12:01:02.550759+00
b481b085-ad47-4b55-b88d-f30e355a16a1	3febc9d0-6443-496c-9ba6-55af7a506145	6b6e2a49-0153-4cb8-916f-63abadf4f6d6	35.19	35.19	39.12	17	1018	3.71	0	N	0	f	0	clear sky	2026-05-23 11:55:13+00	2026-05-23 12:01:02.84362+00
88e327fb-e835-44f4-8302-c810d28465f4	d981da53-c316-48f1-8e7f-b9f42d74afa0	6b6e2a49-0153-4cb8-916f-63abadf4f6d6	29.4	29.4	29.4	23	1022	6.05	328	NNW	16.2	f	0	clear sky	2026-05-23 11:51:00+00	2026-05-23 12:01:03.155482+00
4ff43d1c-d75f-48a6-9512-4ebaaa7b4543	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	f1be9439-3795-4a4c-9bbd-d6caf8ce1ef5	31.42	30.79	31.42	18	1014	14.83	310	NW	0	f	0	scattered clouds	2026-05-23 12:59:06+00	2026-05-23 13:00:53.491666+00
7707db61-0d9c-4ea2-b5cd-aa1c67defdcf	fc248375-8ec4-4683-9613-c149579eb366	f1be9439-3795-4a4c-9bbd-d6caf8ce1ef5	39.66	39.66	39.66	7	1011	8.6	59	ENE	11.48	f	0	clear sky	2026-05-23 12:49:10+00	2026-05-23 13:00:53.878744+00
29391d7a-d702-4754-8e4d-847e9ab38f77	6432350e-9525-49a7-9965-65ace30857c2	f1be9439-3795-4a4c-9bbd-d6caf8ce1ef5	35.96	35.96	38.14	26	1006	20.38	280	W	0	f	0	clear sky	2026-05-23 13:00:54+00	2026-05-23 13:00:54.279402+00
2fbb7754-a6a1-491c-be50-94cbf986df9f	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	f1be9439-3795-4a4c-9bbd-d6caf8ce1ef5	34.95	34.95	34.95	18	1011	5.54	0	N	0	f	0	few clouds	2026-05-23 12:51:43+00	2026-05-23 13:00:54.602338+00
98e720a7-6b0a-48f5-b18f-03d6ad795f69	1e806627-87ea-4c01-aad4-9f05ce90c257	f1be9439-3795-4a4c-9bbd-d6caf8ce1ef5	22.43	22.43	22.43	72	1016	14.08	239	WSW	14.36	t	0	clear sky	2026-05-23 12:57:33+00	2026-05-23 13:00:54.970608+00
b968f673-8d30-46af-810c-a88d904a8d88	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	f1be9439-3795-4a4c-9bbd-d6caf8ce1ef5	25.05	24.75	25.05	25	1016	18.5	260	W	0	f	0	few clouds	2026-05-23 13:00:55+00	2026-05-23 13:00:55.352024+00
17a35d1d-740c-4843-99ec-52f2fe13421f	527f8a7d-5101-47fc-9889-f2e961c2b7e4	f1be9439-3795-4a4c-9bbd-d6caf8ce1ef5	31.55	31.55	31.55	49	1010	16.42	359	N	21.24	t	0	clear sky	2026-05-23 13:00:27+00	2026-05-23 13:00:55.818585+00
61d4ea5a-e040-423e-9b61-f46722780d38	11058438-9274-473f-bd2c-115fdb27b414	f1be9439-3795-4a4c-9bbd-d6caf8ce1ef5	37.99	35.94	37.99	18	1009	38.88	0	N	0	f	0	clear sky	2026-05-23 12:49:47+00	2026-05-23 13:00:56.176745+00
ce697684-d2be-4a0d-8de8-6d35485f4400	3febc9d0-6443-496c-9ba6-55af7a506145	f1be9439-3795-4a4c-9bbd-d6caf8ce1ef5	32.96	32.96	33.19	33	1018	11.12	340	NNW	0	f	0	clear sky	2026-05-23 12:56:22+00	2026-05-23 13:00:56.593865+00
d967baf0-794e-438b-9f2b-88b43799dad8	d981da53-c316-48f1-8e7f-b9f42d74afa0	f1be9439-3795-4a4c-9bbd-d6caf8ce1ef5	30.24	30.24	30.24	21	1021	6.66	343	NNW	16.92	f	0	clear sky	2026-05-23 12:58:47+00	2026-05-23 13:00:56.966199+00
e3fd5e6d-6343-4675-891b-c812acf102c3	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	6cc1cfce-ae9a-4bed-9ebf-8d2d23835f0e	30.42	30.23	30.42	20	1014	16.67	290	WNW	0	f	0	scattered clouds	2026-05-23 13:52:00+00	2026-05-23 14:00:57.658333+00
56795fab-875a-4a26-ab03-7447709291de	fc248375-8ec4-4683-9613-c149579eb366	6cc1cfce-ae9a-4bed-9ebf-8d2d23835f0e	39.3	39.3	39.3	7	1011	11.74	60	ENE	15.01	f	0	clear sky	2026-05-23 13:57:01+00	2026-05-23 14:00:57.984966+00
0a5325fe-0547-4c80-afc5-9285b19d0098	6432350e-9525-49a7-9965-65ace30857c2	6cc1cfce-ae9a-4bed-9ebf-8d2d23835f0e	34.96	34.96	36.14	36	1006	22.21	280	W	0	f	0	clear sky	2026-05-23 13:53:29+00	2026-05-23 14:00:58.296592+00
de6ebd4a-fbb2-4c56-b840-40700b69261f	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	6cc1cfce-ae9a-4bed-9ebf-8d2d23835f0e	34.95	34.95	34.95	20	1011	3.71	0	N	0	f	0	clear sky	2026-05-23 14:00:04+00	2026-05-23 14:00:58.624276+00
7791e49c-bcb3-40c8-a75a-a10d5e097c39	1e806627-87ea-4c01-aad4-9f05ce90c257	6cc1cfce-ae9a-4bed-9ebf-8d2d23835f0e	22.43	22.43	22.43	71	1016	14.29	230	SW	14.94	t	0	clear sky	2026-05-23 13:58:10+00	2026-05-23 14:00:58.937114+00
08899934-8c58-48c4-bcea-894f8a4651a3	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	6cc1cfce-ae9a-4bed-9ebf-8d2d23835f0e	25.05	24.75	25.05	25	1016	18.5	260	W	0	f	0	scattered clouds	2026-05-23 13:53:25+00	2026-05-23 14:00:59.283192+00
5f899904-aece-4f5a-b8da-b3a38ed58ff3	527f8a7d-5101-47fc-9889-f2e961c2b7e4	6cc1cfce-ae9a-4bed-9ebf-8d2d23835f0e	30.99	30.99	30.99	43	1010	13.68	22	NNE	18.54	f	0	clear sky	2026-05-23 14:00:59+00	2026-05-23 14:00:59.745607+00
94c37c51-8070-42ff-8488-dd1ff113edc2	11058438-9274-473f-bd2c-115fdb27b414	6cc1cfce-ae9a-4bed-9ebf-8d2d23835f0e	37.99	35.94	37.99	14	1009	33.34	350	N	0	f	0	clear sky	2026-05-23 13:55:10+00	2026-05-23 14:01:00.240643+00
da68829d-2cc6-4abf-acf3-1864fb6238ed	3febc9d0-6443-496c-9ba6-55af7a506145	6cc1cfce-ae9a-4bed-9ebf-8d2d23835f0e	30.18	30.18	30.19	45	1017	9.25	330	NNW	0	f	0	clear sky	2026-05-23 14:00:40+00	2026-05-23 14:01:00.740696+00
cd02da4c-9af7-4a4c-9407-9d16343631e7	d981da53-c316-48f1-8e7f-b9f42d74afa0	6cc1cfce-ae9a-4bed-9ebf-8d2d23835f0e	30.92	30.92	30.92	19	1020	3.92	7	N	13.61	f	0	clear sky	2026-05-23 13:55:15+00	2026-05-23 14:01:01.090556+00
8bf522d4-21f8-404c-8821-078f55146d0c	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	e5c371bc-ebda-48cc-816f-063595512752	30.42	30.23	30.42	20	1014	14.83	300	WNW	0	f	0	scattered clouds	2026-05-23 15:03:41+00	2026-05-23 15:00:54.922219+00
ebe018cc-736f-4b8a-b68b-d208ad2dc651	fc248375-8ec4-4683-9613-c149579eb366	e5c371bc-ebda-48cc-816f-063595512752	38.27	38.27	38.27	8	1012	15.23	75	ENE	16.88	f	0	clear sky	2026-05-23 15:05:34+00	2026-05-23 15:00:55.425547+00
b8df9a9d-425e-4391-867e-534f51c11516	6432350e-9525-49a7-9965-65ace30857c2	e5c371bc-ebda-48cc-816f-063595512752	31.96	31.96	34.14	45	1006	18.5	270	W	0	f	0	clear sky	2026-05-23 15:14:50+00	2026-05-23 15:00:55.759283+00
418561c7-437d-4e13-8efd-8bc74bf50c09	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	e5c371bc-ebda-48cc-816f-063595512752	33.95	33.95	33.95	21	1011	9.25	40	NE	0	f	0	clear sky	2026-05-23 15:10:33+00	2026-05-23 15:00:56.115201+00
1ccda1ae-8dec-45cd-8d91-805a18fd9cd2	1e806627-87ea-4c01-aad4-9f05ce90c257	e5c371bc-ebda-48cc-816f-063595512752	22.43	22.43	22.43	72	1016	15.41	231	SW	16.02	t	0	clear sky	2026-05-23 15:02:33+00	2026-05-23 15:00:56.437725+00
708209cf-e244-4e32-9334-822fb6753cda	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	e5c371bc-ebda-48cc-816f-063595512752	23.05	23.05	23.75	33	1017	22.21	290	WNW	0	f	0	scattered clouds	2026-05-23 15:15:59+00	2026-05-23 15:00:56.784697+00
64e20f1e-bb0e-4735-9a41-0eee8dd08a57	527f8a7d-5101-47fc-9889-f2e961c2b7e4	e5c371bc-ebda-48cc-816f-063595512752	30.99	30.99	30.99	43	1010	14.29	3	N	19.48	t	0	clear sky	2026-05-23 15:05:13+00	2026-05-23 15:00:57.119235+00
c814704d-d81a-4363-a141-7790f12af549	11058438-9274-473f-bd2c-115fdb27b414	e5c371bc-ebda-48cc-816f-063595512752	35.99	35.99	35.99	16	1008	29.63	340	NNW	0	f	0	clear sky	2026-05-23 15:14:38+00	2026-05-23 15:00:57.481003+00
d3dc3ece-7979-43cc-812c-d8ad075bdd5a	3febc9d0-6443-496c-9ba6-55af7a506145	e5c371bc-ebda-48cc-816f-063595512752	30.18	30.18	38.12	42	1017	12.89	330	NNW	0	f	0	clear sky	2026-05-23 15:10:01+00	2026-05-23 15:00:57.816973+00
324471e4-8eef-4dfd-ab2a-b000c932a222	d981da53-c316-48f1-8e7f-b9f42d74afa0	e5c371bc-ebda-48cc-816f-063595512752	31.17	31.17	31.17	19	1019	4.46	74	ENE	16.49	f	0	clear sky	2026-05-23 15:07:59+00	2026-05-23 15:00:58.13127+00
5b7cbed9-43a8-4a69-b487-aa831559ca60	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	eb5f97da-c66c-4c1f-a6f0-10953f5b3333	30.42	30.23	30.42	20	1014	14.83	330	NNW	0	f	0	scattered clouds	2026-05-23 16:10:03+00	2026-05-23 16:11:44.016987+00
6fe35961-d81a-41cd-8c0d-56ab20b2073c	fc248375-8ec4-4683-9613-c149579eb366	eb5f97da-c66c-4c1f-a6f0-10953f5b3333	36.29	36.29	36.29	8	1012	18.79	83	E	28.8	f	0	clear sky	2026-05-23 16:07:02+00	2026-05-23 16:11:44.292654+00
ac11f660-a502-4dda-a1f6-594b20676517	6432350e-9525-49a7-9965-65ace30857c2	eb5f97da-c66c-4c1f-a6f0-10953f5b3333	31.96	31.96	32.14	45	1006	9.25	250	WSW	0	f	0	clear sky	2026-05-23 16:08:31+00	2026-05-23 16:11:44.59193+00
41cea470-e31b-48b9-9e8a-ca820e39c463	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	eb5f97da-c66c-4c1f-a6f0-10953f5b3333	33.95	33.95	33.95	21	1011	9.25	40	NE	0	f	0	clear sky	2026-05-23 16:03:43+00	2026-05-23 16:11:44.873741+00
db48b5ca-619b-4575-86f0-0c5d03ef808a	1e806627-87ea-4c01-aad4-9f05ce90c257	eb5f97da-c66c-4c1f-a6f0-10953f5b3333	21.88	21.88	21.88	74	1016	14.98	222	SW	16.16	t	0	clear sky	2026-05-23 16:09:16+00	2026-05-23 16:11:45.201115+00
b5316994-2a2a-4ddc-b403-7fda8fbcb132	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	eb5f97da-c66c-4c1f-a6f0-10953f5b3333	20.17	20.17	20.17	39	1017	28.19	311	NW	26.57	f	0	clear sky	2026-05-23 16:11:08+00	2026-05-23 16:11:45.520589+00
70e3c5ef-ea1f-4087-bf3a-de05c972fcd8	527f8a7d-5101-47fc-9889-f2e961c2b7e4	eb5f97da-c66c-4c1f-a6f0-10953f5b3333	34.66	34.66	34.66	39	1010	17.35	351	N	21.67	f	0	clear sky	2026-05-23 16:11:20+00	2026-05-23 16:11:45.829171+00
c8467a7a-cc5c-4f84-b822-a092d7f74c73	11058438-9274-473f-bd2c-115fdb27b414	eb5f97da-c66c-4c1f-a6f0-10953f5b3333	34.99	34.99	34.99	18	1008	22.21	330	NNW	40.75	f	0	clear sky	2026-05-23 16:08:04+00	2026-05-23 16:11:46.195109+00
0a0762ce-a64f-4e50-aa46-a675b36c0c6a	3febc9d0-6443-496c-9ba6-55af7a506145	eb5f97da-c66c-4c1f-a6f0-10953f5b3333	27.96	27.96	28.19	51	1017	12.96	340	NNW	0	f	0	clear sky	2026-05-23 16:11:46+00	2026-05-23 16:11:46.506439+00
e65084d1-9a43-4102-bb47-d639de844dbf	d981da53-c316-48f1-8e7f-b9f42d74afa0	eb5f97da-c66c-4c1f-a6f0-10953f5b3333	31.61	31.61	31.61	17	1019	7.81	119	ESE	20.48	f	0	clear sky	2026-05-23 15:59:15+00	2026-05-23 16:11:46.816408+00
3dc7a375-784f-4664-b341-33ba8d485ff5	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	7a3e19f8-0dc2-417f-8f57-45f786f86ed6	28.42	28.01	28.42	36	1015	25.92	350	N	0	f	0	scattered clouds	2026-05-23 16:56:41+00	2026-05-23 17:06:53.906949+00
7bb6f253-05fe-4434-95af-880c895a1412	fc248375-8ec4-4683-9613-c149579eb366	7a3e19f8-0dc2-417f-8f57-45f786f86ed6	34.6	34.6	34.6	10	1012	19.4	84	E	33.23	f	0	clear sky	2026-05-23 17:03:04+00	2026-05-23 17:06:54.212219+00
9c9557ff-4990-4c6f-b1c8-59edcc01aa8e	6432350e-9525-49a7-9965-65ace30857c2	7a3e19f8-0dc2-417f-8f57-45f786f86ed6	31.96	31.96	32.14	45	1007	9.25	230	SW	0	f	0	clear sky	2026-05-23 17:00:17+00	2026-05-23 17:06:54.501382+00
ed8ae387-7a7c-47d3-9a38-ee7142d12833	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	7a3e19f8-0dc2-417f-8f57-45f786f86ed6	29.95	29.95	29.95	28	1011	9.25	40	NE	0	t	0	clear sky	2026-05-23 17:06:54+00	2026-05-23 17:06:54.792432+00
985dc0f0-9a71-4042-a57b-2307e1635d40	1e806627-87ea-4c01-aad4-9f05ce90c257	7a3e19f8-0dc2-417f-8f57-45f786f86ed6	19.65	19.65	19.65	80	1016	13.82	216	SW	14.54	t	0	clear sky	2026-05-23 17:06:34+00	2026-05-23 17:06:55.122035+00
f48343f3-50e8-4b9c-8e09-e77e13752d00	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	7a3e19f8-0dc2-417f-8f57-45f786f86ed6	22.05	21.75	22.05	35	1017	22.21	300	WNW	0	f	0	few clouds	2026-05-23 17:02:15+00	2026-05-23 17:06:55.399077+00
739f91d0-90dd-4355-a06e-9a2cb3bfc44e	527f8a7d-5101-47fc-9889-f2e961c2b7e4	7a3e19f8-0dc2-417f-8f57-45f786f86ed6	30.99	30.99	30.99	41	1010	17.57	348	NNW	22.39	f	0	clear sky	2026-05-23 17:06:55+00	2026-05-23 17:06:55.698735+00
1a26c1fb-eb99-43c0-9668-aa541b85ac9e	11058438-9274-473f-bd2c-115fdb27b414	7a3e19f8-0dc2-417f-8f57-45f786f86ed6	32.99	31.94	32.99	24	1009	33.34	320	NW	0	f	0	clear sky	2026-05-23 17:00:21+00	2026-05-23 17:06:55.998013+00
cfeb4c36-ea05-4085-962f-b9caa2dd04c9	3febc9d0-6443-496c-9ba6-55af7a506145	7a3e19f8-0dc2-417f-8f57-45f786f86ed6	27.96	27.96	28.19	48	1017	12.96	340	NNW	0	f	0	clear sky	2026-05-23 17:00:02+00	2026-05-23 17:06:56.328413+00
18fcf8c3-e7c7-47cb-8885-10129407bfd0	d981da53-c316-48f1-8e7f-b9f42d74afa0	7a3e19f8-0dc2-417f-8f57-45f786f86ed6	31.19	31.19	31.19	17	1018	12.31	129	SE	16.24	f	0	clear sky	2026-05-23 17:02:47+00	2026-05-23 17:06:56.613542+00
8f300086-d2a7-4eab-ad18-bc0bd723e724	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	cc51d816-972f-40c1-a89f-17681a71db93	26.42	25.79	26.42	44	1016	31.5	10	N	0	f	0	clear sky	2026-05-23 18:00:04+00	2026-05-23 18:00:57.261729+00
e1133d4f-2b53-41f1-ad60-e9119c79245b	fc248375-8ec4-4683-9613-c149579eb366	cc51d816-972f-40c1-a89f-17681a71db93	33.29	33.29	33.29	11	1013	24.84	83	E	43.99	f	0	clear sky	2026-05-23 17:56:37+00	2026-05-23 18:00:57.591132+00
dbd780d3-0b3c-4eef-b2df-5adb1bf6b4a1	6432350e-9525-49a7-9965-65ace30857c2	cc51d816-972f-40c1-a89f-17681a71db93	30.96	30.96	31.14	48	1007	9.25	200	SSW	0	t	0	clear sky	2026-05-23 17:49:51+00	2026-05-23 18:00:57.904296+00
d0488a45-d133-4bd2-a8eb-a6ce39443570	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	cc51d816-972f-40c1-a89f-17681a71db93	29.95	29.95	29.95	28	1011	9.25	40	NE	0	t	0	clear sky	2026-05-23 17:57:26+00	2026-05-23 18:00:58.238968+00
cb9c2573-4508-42df-9bf7-85ad21e50182	1e806627-87ea-4c01-aad4-9f05ce90c257	cc51d816-972f-40c1-a89f-17681a71db93	19.1	19.1	19.1	74	1016	12.6	224	SW	12.49	t	0	clear sky	2026-05-23 17:53:26+00	2026-05-23 18:00:58.597947+00
ff86824b-4435-431d-8ed2-12a326da9ea4	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	cc51d816-972f-40c1-a89f-17681a71db93	21.05	20.75	21.05	37	1017	22.21	300	WNW	0	f	0	clear sky	2026-05-23 17:59:33+00	2026-05-23 18:00:58.921836+00
e44bfbb2-9ff2-4cb7-ab55-856219447fe8	527f8a7d-5101-47fc-9889-f2e961c2b7e4	cc51d816-972f-40c1-a89f-17681a71db93	33.21	33.21	33.21	35	1011	15.88	351	N	22.25	f	0	clear sky	2026-05-23 18:00:59+00	2026-05-23 18:00:59.28065+00
f89e8d2d-71d6-4118-8f11-06c1ce2951ef	11058438-9274-473f-bd2c-115fdb27b414	cc51d816-972f-40c1-a89f-17681a71db93	31.99	30.94	31.99	27	1009	29.63	320	NW	0	f	0	clear sky	2026-05-23 17:55:17+00	2026-05-23 18:00:59.580848+00
821e8a3d-a7b0-4785-a312-51111e00793e	3febc9d0-6443-496c-9ba6-55af7a506145	cc51d816-972f-40c1-a89f-17681a71db93	25.74	25.74	26.19	57	1017	11.12	20	NNE	0	f	0	clear sky	2026-05-23 17:58:52+00	2026-05-23 18:00:59.908058+00
c93d5961-94fe-4082-ae44-30510ef64132	d981da53-c316-48f1-8e7f-b9f42d74afa0	cc51d816-972f-40c1-a89f-17681a71db93	30.48	30.48	30.48	18	1019	21.74	110	ESE	18.61	f	0	clear sky	2026-05-23 17:56:33+00	2026-05-23 18:01:00.266259+00
f51302d0-7469-4994-a06b-147148ee7c5d	231ce7ad-5cc1-48fb-83cb-74190d77a7ab	0a87dd31-84c9-4df4-928a-53be058ab709	25.42	25.23	25.42	44	1015	31.5	10	N	0	f	0	clear sky	2026-05-23 18:24:57+00	2026-05-23 18:33:34.414811+00
05520d48-5779-4b62-8922-f4209008fd00	fc248375-8ec4-4683-9613-c149579eb366	0a87dd31-84c9-4df4-928a-53be058ab709	33.24	33.24	33.24	11	1014	24.84	83	E	43.99	f	0	clear sky	2026-05-23 18:22:25+00	2026-05-23 18:33:34.733148+00
8f87a6a8-86c3-49ad-b7e6-03ff3f094df8	6432350e-9525-49a7-9965-65ace30857c2	0a87dd31-84c9-4df4-928a-53be058ab709	30.96	30.96	31.14	48	1007	9.25	220	SW	0	t	0	clear sky	2026-05-23 18:24:38+00	2026-05-23 18:33:35.765572+00
a5270a21-cd62-4233-91c4-cd4eff09ce27	1684211d-ce99-43b3-bc4e-8b9e8b9e6a2b	0a87dd31-84c9-4df4-928a-53be058ab709	30.95	30.95	30.95	25	1011	9.25	60	ENE	0	f	0	clear sky	2026-05-23 18:23:31+00	2026-05-23 18:33:36.190428+00
5f83274c-c18c-4bd8-9b53-e819c9e18485	1e806627-87ea-4c01-aad4-9f05ce90c257	0a87dd31-84c9-4df4-928a-53be058ab709	18.54	18.54	18.54	76	1016	12.6	224	SW	12.49	t	0	clear sky	2026-05-23 18:25:42+00	2026-05-23 18:33:36.561369+00
796cd882-ebdd-4f4b-83c9-85e41d9f3f0d	0f52b85f-68ea-4cd2-8ddf-c36fa2be6e7e	0a87dd31-84c9-4df4-928a-53be058ab709	19.05	19.05	19.75	39	1019	18.5	310	NW	0	f	0	clear sky	2026-05-23 18:29:17+00	2026-05-23 18:33:36.878436+00
204edc72-ff24-447a-a951-99d66a9acbaf	527f8a7d-5101-47fc-9889-f2e961c2b7e4	0a87dd31-84c9-4df4-928a-53be058ab709	33.77	33.77	33.77	34	1011	13.39	354	N	19.3	f	0	clear sky	2026-05-23 18:33:37+00	2026-05-23 18:33:37.154163+00
3f4261b0-6769-4fd9-91d3-13101c0d2401	11058438-9274-473f-bd2c-115fdb27b414	0a87dd31-84c9-4df4-928a-53be058ab709	31.99	30.94	31.99	29	1009	29.63	310	NW	0	f	0	clear sky	2026-05-23 18:33:37+00	2026-05-23 18:33:37.440054+00
633db01a-5488-41ab-a30e-d759d961d756	3febc9d0-6443-496c-9ba6-55af7a506145	0a87dd31-84c9-4df4-928a-53be058ab709	25.74	25.74	26.19	50	1017	9.25	40	NE	0	f	0	clear sky	2026-05-23 18:29:39+00	2026-05-23 18:33:38.392968+00
484b0700-4f25-4bb0-8136-62d10118f72d	d981da53-c316-48f1-8e7f-b9f42d74afa0	0a87dd31-84c9-4df4-928a-53be058ab709	30.48	30.48	30.48	18	1019	21.74	110	ESE	18.61	f	0	clear sky	2026-05-23 18:23:52+00	2026-05-23 18:33:38.671063+00
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

\unrestrict G18WkbI9Rf4DBLVD5SZQyLwWaOsbcHFjr5bc5kR03NCKr6L4NU7kXyVsO7fEo6y

