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
	INSERT INTO auditoria."Orders" (table_name, order_name, action, old_data, query)
	VALUES (TG_TABLE_NAME, current_user, TG_OP, row_to_json(OLD), current_query());
ELSIF (TG_OP = 'UPDATE') THEN
	INSERT INTO auditoria."Orders" (table_name, order_name, action, old_data, new_data, query)
	VALUES (TG_TABLE_NAME, current_user, TG_OP, row_to_json(OLD), row_to_json(NEW), current_query());
ELSIF (TG_OP = 'INSERT') THEN
	INSERT INTO auditoria."Orders" (table_name, order_name, action, new_data, query)
	VALUES (TG_TABLE_NAME, current_user, TG_OP, row_to_json(NEW), current_query());
END IF;

RETURN NULL;
END;
$$;


ALTER FUNCTION auditoria.audit_function() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Orders; Type: TABLE; Schema: auditoria; Owner: postgres
--

CREATE TABLE auditoria."Orders" (
    id bigint NOT NULL,
    table_name text NOT NULL,
    order_name text NOT NULL,
    action text,
    old_data jsonb,
    new_data jsonb,
    query text,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE auditoria."Orders" OWNER TO postgres;

--
-- Name: Orders_id_seq; Type: SEQUENCE; Schema: auditoria; Owner: postgres
--

ALTER TABLE auditoria."Orders" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME auditoria."Orders_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: OrderItem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."OrderItem" (
    id integer NOT NULL,
    "orderId" integer NOT NULL,
    "productId" integer NOT NULL,
    "productName" text NOT NULL,
    "productPrice" double precision NOT NULL
);


ALTER TABLE public."OrderItem" OWNER TO postgres;

--
-- Name: OrderItem_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."OrderItem_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."OrderItem_id_seq" OWNER TO postgres;

--
-- Name: OrderItem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."OrderItem_id_seq" OWNED BY public."OrderItem".id;


--
-- Name: Orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Orders" (
    id integer NOT NULL,
    total double precision NOT NULL,
    status text NOT NULL,
    "paymentId" integer
);


ALTER TABLE public."Orders" OWNER TO postgres;

--
-- Name: Orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Orders_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Orders_id_seq" OWNER TO postgres;

--
-- Name: Orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Orders_id_seq" OWNED BY public."Orders".id;


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
-- Name: OrderItem id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OrderItem" ALTER COLUMN id SET DEFAULT nextval('public."OrderItem_id_seq"'::regclass);


--
-- Name: Orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Orders" ALTER COLUMN id SET DEFAULT nextval('public."Orders_id_seq"'::regclass);


--
-- Data for Name: Orders; Type: TABLE DATA; Schema: auditoria; Owner: postgres
--

COPY auditoria."Orders" (id, table_name, order_name, action, old_data, new_data, query, "timestamp") FROM stdin;
1	Orders	postgres	INSERT	\N	{"id": 1, "total": 130000, "status": "pending", "paymentId": null}	INSERT INTO public."Orders" (\ntotal, status) VALUES (\n$1::double precision, $2::text)\n returning id;	2024-11-13 17:22:40.246526
3	Orders	postgres	UPDATE	{"id": 1, "total": 130000, "status": "pending", "paymentId": null}	{"id": 1, "total": 456456, "status": "cancelado", "paymentId": null}	UPDATE public."Orders" SET\ntotal = $1::double precision, status = $2::text WHERE\nid = 1;	2024-11-13 17:24:32.447266
4	Orders	postgres	DELETE	{"id": 1, "total": 456456, "status": "cancelado", "paymentId": null}	\N	DELETE FROM public."Orders"\n    WHERE id IN\n        (1);	2024-11-13 17:25:14.626766
\.


--
-- Data for Name: OrderItem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."OrderItem" (id, "orderId", "productId", "productName", "productPrice") FROM stdin;
\.


--
-- Data for Name: Orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Orders" (id, total, status, "paymentId") FROM stdin;
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
e2100ba4-14c3-4310-89f6-bdd7ecd8bbdd	5424d3f8b774eb4883f8e95bdbcf411124ba96ed957e6cbfaa815a20df4ecd4d	2024-11-12 23:01:34.001635+00	20241109030726_init	\N	\N	2024-11-12 23:01:33.917192+00	1
b4a7b3f3-8d02-4680-b086-a588d02e34ed	5424d3f8b774eb4883f8e95bdbcf411124ba96ed957e6cbfaa815a20df4ecd4d	2024-11-12 22:01:39.807056+00	20241109030726_init	\N	\N	2024-11-12 22:01:39.744956+00	1
\.


--
-- Name: Orders_id_seq; Type: SEQUENCE SET; Schema: auditoria; Owner: postgres
--

SELECT pg_catalog.setval('auditoria."Orders_id_seq"', 4, true);


--
-- Name: OrderItem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."OrderItem_id_seq"', 1, false);


--
-- Name: Orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Orders_id_seq"', 1, true);


--
-- Name: Orders Orders_pkey; Type: CONSTRAINT; Schema: auditoria; Owner: postgres
--

ALTER TABLE ONLY auditoria."Orders"
    ADD CONSTRAINT "Orders_pkey" PRIMARY KEY (id);


--
-- Name: OrderItem OrderItem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OrderItem"
    ADD CONSTRAINT "OrderItem_pkey" PRIMARY KEY (id);


--
-- Name: Orders Orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Orders"
    ADD CONSTRAINT "Orders_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: Orders orders_audit_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER orders_audit_trigger AFTER INSERT OR DELETE OR UPDATE ON public."Orders" FOR EACH ROW EXECUTE FUNCTION auditoria.audit_function();


--
-- Name: OrderItem OrderItem_orderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."OrderItem"
    ADD CONSTRAINT "OrderItem_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES public."Orders"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

