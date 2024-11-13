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
	INSERT INTO auditoria."Products" (table_name, product_name, action, old_data, query)
	VALUES (TG_TABLE_NAME, current_user, TG_OP, row_to_json(OLD), current_query());
ELSIF (TG_OP = 'UPDATE') THEN
	INSERT INTO auditoria."Products" (table_name, product_name, action, old_data, new_data, query)
	VALUES (TG_TABLE_NAME, current_user, TG_OP, row_to_json(OLD), row_to_json(NEW), current_query());
ELSIF (TG_OP = 'INSERT') THEN
	INSERT INTO auditoria."Products" (table_name, product_name, action, new_data, query)
	VALUES (TG_TABLE_NAME, current_user, TG_OP, row_to_json(NEW), current_query());
END IF;

RETURN NULL;
END;
$$;


ALTER FUNCTION auditoria.audit_function() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Products; Type: TABLE; Schema: auditoria; Owner: postgres
--

CREATE TABLE auditoria."Products" (
    id bigint NOT NULL,
    table_name text NOT NULL,
    product_name text NOT NULL,
    action text,
    old_data jsonb,
    new_data jsonb,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    query text
);


ALTER TABLE auditoria."Products" OWNER TO postgres;

--
-- Name: Products_id_seq; Type: SEQUENCE; Schema: auditoria; Owner: postgres
--

ALTER TABLE auditoria."Products" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME auditoria."Products_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Products" (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    price double precision NOT NULL,
    stock integer NOT NULL,
    category text NOT NULL
);


ALTER TABLE public."Products" OWNER TO postgres;

--
-- Name: Products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Products_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Products_id_seq" OWNER TO postgres;

--
-- Name: Products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Products_id_seq" OWNED BY public."Products".id;


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
-- Name: Products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Products" ALTER COLUMN id SET DEFAULT nextval('public."Products_id_seq"'::regclass);


--
-- Data for Name: Products; Type: TABLE DATA; Schema: auditoria; Owner: postgres
--

COPY auditoria."Products" (id, table_name, product_name, action, old_data, new_data, "timestamp", query) FROM stdin;
1	Products	postgres	INSERT	\N	{"id": 6, "name": "celular", "price": 123123, "stock": 567, "category": "tecnologia", "description": "Dispositivo movil"}	2024-11-13 19:49:39.520331	INSERT INTO public."Products" (\nname, description, price, stock, category) VALUES (\n$1::text, $2::text, $3::double precision, $4::integer, $5::text)\n returning id;
2	Products	postgres	UPDATE	{"id": 6, "name": "celular", "price": 123123, "stock": 567, "category": "tecnologia", "description": "Dispositivo movil"}	{"id": 6, "name": "celular", "price": 987876, "stock": 567, "category": "tecnologia", "description": "Dispositivo movil"}	2024-11-13 19:50:16.137316	UPDATE public."Products" SET\nprice = $1::double precision WHERE\nid = 6;
3	Products	postgres	DELETE	{"id": 6, "name": "celular", "price": 987876, "stock": 567, "category": "tecnologia", "description": "Dispositivo movil"}	\N	2024-11-13 19:53:09.002217	DELETE FROM public."Products"\n    WHERE id IN\n        (6);
\.


--
-- Data for Name: Products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Products" (id, name, description, price, stock, category) FROM stdin;
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
7135a8f1-5260-4e11-83cd-7ab968165377	a854f6d92fc05bede507733c2b9a745d0bd9f1a9bcc7126bea3183306644b1d5	2024-11-13 19:34:24.749356+00	20241109025802_init	\N	\N	2024-11-13 19:34:24.709518+00	1
\.


--
-- Name: Products_id_seq; Type: SEQUENCE SET; Schema: auditoria; Owner: postgres
--

SELECT pg_catalog.setval('auditoria."Products_id_seq"', 3, true);


--
-- Name: Products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Products_id_seq"', 6, true);


--
-- Name: Products Products_pkey; Type: CONSTRAINT; Schema: auditoria; Owner: postgres
--

ALTER TABLE ONLY auditoria."Products"
    ADD CONSTRAINT "Products_pkey" PRIMARY KEY (id);


--
-- Name: Products Products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Products"
    ADD CONSTRAINT "Products_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: Products products_audit_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER products_audit_trigger AFTER INSERT OR DELETE OR UPDATE ON public."Products" FOR EACH ROW EXECUTE FUNCTION auditoria.audit_function();


--
-- PostgreSQL database dump complete
--

