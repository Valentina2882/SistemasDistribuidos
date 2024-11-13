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
	INSERT INTO auditoria."ShoppingCart" (table_name, shopping_name, action, old_data, query)
	VALUES (TG_TABLE_NAME, current_user, TG_OP, row_to_json(OLD), current_query());
ELSIF (TG_OP = 'UPDATE') THEN
	INSERT INTO auditoria."ShoppingCart" (table_name, shopping_name, action, old_data, new_data, query)
	VALUES (TG_TABLE_NAME, current_user, TG_OP, row_to_json(OLD), row_to_json(NEW), current_query());
ELSIF (TG_OP = 'INSERT') THEN
	INSERT INTO auditoria."ShoppingCart" (table_name, shopping_name, action, new_data, query)
	VALUES (TG_TABLE_NAME, current_user, TG_OP, row_to_json(NEW), current_query());
END IF;

RETURN NULL;
END;
$$;


ALTER FUNCTION auditoria.audit_function() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ShoppingCart; Type: TABLE; Schema: auditoria; Owner: postgres
--

CREATE TABLE auditoria."ShoppingCart" (
    id bigint NOT NULL,
    table_name text NOT NULL,
    shopping_name text NOT NULL,
    action text,
    old_data jsonb,
    new_data jsonb,
    query text,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE auditoria."ShoppingCart" OWNER TO postgres;

--
-- Name: ShoppingCart_id_seq; Type: SEQUENCE; Schema: auditoria; Owner: postgres
--

ALTER TABLE auditoria."ShoppingCart" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME auditoria."ShoppingCart_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Order" (
    id integer NOT NULL,
    "shoppingCartId" integer
);


ALTER TABLE public."Order" OWNER TO postgres;

--
-- Name: Order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Order_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Order_id_seq" OWNER TO postgres;

--
-- Name: Order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Order_id_seq" OWNED BY public."Order".id;


--
-- Name: ShoppingCart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ShoppingCart" (
    id integer NOT NULL
);


ALTER TABLE public."ShoppingCart" OWNER TO postgres;

--
-- Name: ShoppingCart_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ShoppingCart_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ShoppingCart_id_seq" OWNER TO postgres;

--
-- Name: ShoppingCart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ShoppingCart_id_seq" OWNED BY public."ShoppingCart".id;


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
-- Name: Order id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Order" ALTER COLUMN id SET DEFAULT nextval('public."Order_id_seq"'::regclass);


--
-- Name: ShoppingCart id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ShoppingCart" ALTER COLUMN id SET DEFAULT nextval('public."ShoppingCart_id_seq"'::regclass);


--
-- Data for Name: ShoppingCart; Type: TABLE DATA; Schema: auditoria; Owner: postgres
--

COPY auditoria."ShoppingCart" (id, table_name, shopping_name, action, old_data, new_data, query, "timestamp") FROM stdin;
1	ShoppingCart	postgres	INSERT	\N	{"id": 10}	INSERT INTO public."ShoppingCart" (\nid) VALUES (\n DEFAULT )\n returning id;	2024-11-13 20:43:32.419309
2	ShoppingCart	postgres	DELETE	{"id": 10}	\N	DELETE FROM public."ShoppingCart"\n    WHERE id IN\n        (10);	2024-11-13 20:43:43.774057
3	ShoppingCart	postgres	DELETE	{"id": 1}	\N	DELETE FROM public."ShoppingCart"\n    WHERE id IN\n        (1);	2024-11-13 20:43:53.662412
\.


--
-- Data for Name: Order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Order" (id, "shoppingCartId") FROM stdin;
\.


--
-- Data for Name: ShoppingCart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ShoppingCart" (id) FROM stdin;
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
a708049e-9654-4c23-8790-868677198612	fa6008e331b9ff43d3a555b6701a31a583447693125d2a80909d634967c518e2	2024-11-13 20:10:13.919018+00	20241109030605_init	\N	\N	2024-11-13 20:10:13.857755+00	1
\.


--
-- Name: ShoppingCart_id_seq; Type: SEQUENCE SET; Schema: auditoria; Owner: postgres
--

SELECT pg_catalog.setval('auditoria."ShoppingCart_id_seq"', 3, true);


--
-- Name: Order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Order_id_seq"', 1, false);


--
-- Name: ShoppingCart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ShoppingCart_id_seq"', 10, true);


--
-- Name: ShoppingCart ShoppingCart_pkey; Type: CONSTRAINT; Schema: auditoria; Owner: postgres
--

ALTER TABLE ONLY auditoria."ShoppingCart"
    ADD CONSTRAINT "ShoppingCart_pkey" PRIMARY KEY (id);


--
-- Name: Order Order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Order"
    ADD CONSTRAINT "Order_pkey" PRIMARY KEY (id);


--
-- Name: ShoppingCart ShoppingCart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ShoppingCart"
    ADD CONSTRAINT "ShoppingCart_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: ShoppingCart shoppingcart_audit_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER shoppingcart_audit_trigger AFTER INSERT OR DELETE OR UPDATE ON public."ShoppingCart" FOR EACH ROW EXECUTE FUNCTION auditoria.audit_function();


--
-- Name: Order Order_shoppingCartId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Order"
    ADD CONSTRAINT "Order_shoppingCartId_fkey" FOREIGN KEY ("shoppingCartId") REFERENCES public."ShoppingCart"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

