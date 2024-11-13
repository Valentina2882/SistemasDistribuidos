--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0 (Debian 17.0-1.pgdg120+1)
-- Dumped by pg_dump version 17.0 (Debian 17.0-1.pgdg120+1)

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
-- Name: auditoria; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA auditoria;


ALTER SCHEMA auditoria OWNER TO postgres;

--
-- Name: audit_function(); Type: FUNCTION; Schema: auditoria; Owner: postgres
--

CREATE FUNCTION auditoria.audit_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

IF(TG_OP = 'DELETE') THEN
	INSERT INTO auditoria."Payments" (table_name, payment_name, action, old_data, query)
	VALUES (TG_TABLE_NAME, current_user, TG_OP, row_to_json(OLD), current_query());
ELSIF (TG_OP = 'UPDATE') THEN
	INSERT INTO auditoria."Payments" (table_name, payment_name, action, old_data, new_data, query)
	VALUES (TG_TABLE_NAME, current_user, TG_OP, row_to_json(OLD), row_to_json(NEW), current_query());
ELSIF (TG_OP = 'INSERT') THEN
	INSERT INTO auditoria."Payments" (table_name, payment_name, action, new_data, query)
	VALUES (TG_TABLE_NAME, current_user, TG_OP, row_to_json(NEW), current_query());
END IF;

RETURN NULL;
END;
$$;


ALTER FUNCTION auditoria.audit_function() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Payments; Type: TABLE; Schema: auditoria; Owner: postgres
--

CREATE TABLE auditoria."Payments" (
    id bigint NOT NULL,
    table_name text NOT NULL,
    payment_name text NOT NULL,
    action text,
    old_data jsonb,
    new_data jsonb,
    query text,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE auditoria."Payments" OWNER TO postgres;

--
-- Name: Payments_id_seq; Type: SEQUENCE; Schema: auditoria; Owner: postgres
--

ALTER TABLE auditoria."Payments" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME auditoria."Payments_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Payments" (
    id integer NOT NULL,
    amount double precision NOT NULL,
    method text NOT NULL,
    date timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status text DEFAULT 'processed'::text NOT NULL
);


ALTER TABLE public."Payments" OWNER TO postgres;

--
-- Name: Payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Payments_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Payments_id_seq" OWNER TO postgres;

--
-- Name: Payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Payments_id_seq" OWNED BY public."Payments".id;


--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- Name: Payments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Payments" ALTER COLUMN id SET DEFAULT nextval('public."Payments_id_seq"'::regclass);


--
-- Data for Name: Payments; Type: TABLE DATA; Schema: auditoria; Owner: postgres
--

COPY auditoria."Payments" (id, table_name, payment_name, action, old_data, new_data, query, "timestamp") FROM stdin;
1	Payments	postgres	INSERT	\N	{"id": 1, "date": "2024-11-13T19:17:54.012", "amount": 543543, "method": "credito", "status": "processed"}	INSERT INTO public."Payments" (\namount, method) VALUES (\n$1::double precision, $2::text)\n returning id;	2024-11-13 19:17:54.011644
2	Payments	postgres	UPDATE	{"id": 1, "date": "2024-11-13T19:17:54.012", "amount": 543543, "method": "credito", "status": "processed"}	{"id": 1, "date": "2024-11-13T19:17:54.012", "amount": 123123, "method": "credito", "status": "processed"}	UPDATE public."Payments" SET\namount = $1::double precision WHERE\nid = 1;	2024-11-13 19:19:25.861869
3	Payments	postgres	DELETE	{"id": 1, "date": "2024-11-13T19:17:54.012", "amount": 123123, "method": "credito", "status": "processed"}	\N	DELETE FROM public."Payments"\n    WHERE id IN\n        (1);	2024-11-13 19:20:07.738915
\.


--
-- Data for Name: Payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Payments" (id, amount, method, date, status) FROM stdin;
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
49a67eec-85ab-4761-8f32-326e1a1dd79f	57429260ec243d75ff4b56fe8ceeaad3d3602e6a27d6241b2c6d075a611d152d	2024-11-13 17:32:39.566271+00	20241109030834_init	\N	\N	2024-11-13 17:32:39.531945+00	1
\.


--
-- Name: Payments_id_seq; Type: SEQUENCE SET; Schema: auditoria; Owner: postgres
--

SELECT pg_catalog.setval('auditoria."Payments_id_seq"', 3, true);


--
-- Name: Payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Payments_id_seq"', 1, true);


--
-- Name: Payments Payments_pkey; Type: CONSTRAINT; Schema: auditoria; Owner: postgres
--

ALTER TABLE ONLY auditoria."Payments"
    ADD CONSTRAINT "Payments_pkey" PRIMARY KEY (id);


--
-- Name: Payments Payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Payments"
    ADD CONSTRAINT "Payments_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: Payments payments_audit_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER payments_audit_trigger AFTER INSERT OR DELETE OR UPDATE ON public."Payments" FOR EACH ROW EXECUTE FUNCTION auditoria.audit_function();


--
-- PostgreSQL database dump complete
--

