--
-- PostgreSQL database dump
--

-- Dumped from database version 12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)

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
-- Name: number_order_user(integer); Type: FUNCTION; Schema: public; Owner: gb_user
--

CREATE FUNCTION public.number_order_user(num_user_id integer) RETURNS bigint
    LANGUAGE sql
    AS $$
SELECT COUNT(number_order)
FROM orders
WHERE user_id = num_user_id;
$$;


ALTER FUNCTION public.number_order_user(num_user_id integer) OWNER TO gb_user;

--
-- Name: summ_product_category(); Type: FUNCTION; Schema: public; Owner: gb_user
--

CREATE FUNCTION public.summ_product_category() RETURNS numeric
    LANGUAGE sql
    AS $$
SELECT 
 SUM(price) AS summ_product_category_2
FROM products
WHERE category_id = 2;
$$;


ALTER FUNCTION public.summ_product_category() OWNER TO gb_user;

--
-- Name: update_message_body_trigger(); Type: FUNCTION; Schema: public; Owner: gb_user
--

CREATE FUNCTION public.update_message_body_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE is_found BOOLEAN;
BEGIN
is_found := EXISTS(SELECT * FROM banned_words WHERE NEW.body LIKE '%' || word
|| '%' );
IF is_found THEN
NEW.body := '_MODERATED_';
END IF;
RETURN NEW;
END
$$;


ALTER FUNCTION public.update_message_body_trigger() OWNER TO gb_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: banned_words; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.banned_words (
    word character varying(255)
);


ALTER TABLE public.banned_words OWNER TO gb_user;

--
-- Name: categories_product; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.categories_product (
    id integer NOT NULL,
    name character varying(30) NOT NULL
);


ALTER TABLE public.categories_product OWNER TO gb_user;

--
-- Name: category_product_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.category_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.category_product_id_seq OWNER TO gb_user;

--
-- Name: category_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.category_product_id_seq OWNED BY public.categories_product.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.products (
    id integer NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    category_id integer NOT NULL,
    manufacturer_id integer NOT NULL
);


ALTER TABLE public.products OWNER TO gb_user;

--
-- Name: count_product_category; Type: VIEW; Schema: public; Owner: gb_user
--

CREATE VIEW public.count_product_category AS
 SELECT categories_product.name,
    count(products.description) AS count
   FROM public.categories_product,
    public.products
  WHERE (products.category_id = categories_product.id)
  GROUP BY categories_product.name;


ALTER TABLE public.count_product_category OWNER TO gb_user;

--
-- Name: customer_reviews; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.customer_reviews (
    id integer NOT NULL,
    user_id integer NOT NULL,
    product_id integer NOT NULL,
    body text,
    created_at timestamp without time zone
);


ALTER TABLE public.customer_reviews OWNER TO gb_user;

--
-- Name: customer_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.customer_reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_reviews_id_seq OWNER TO gb_user;

--
-- Name: customer_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.customer_reviews_id_seq OWNED BY public.customer_reviews.id;


--
-- Name: delivery; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.delivery (
    id integer NOT NULL,
    order_id integer NOT NULL,
    delivary_date timestamp without time zone,
    status_id integer NOT NULL
);


ALTER TABLE public.delivery OWNER TO gb_user;

--
-- Name: delivery_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.delivery_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.delivery_id_seq OWNER TO gb_user;

--
-- Name: delivery_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.delivery_id_seq OWNED BY public.delivery.id;


--
-- Name: linked_cards; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.linked_cards (
    id integer NOT NULL,
    user_id integer NOT NULL,
    number_cart_user character varying(19) NOT NULL
);


ALTER TABLE public.linked_cards OWNER TO gb_user;

--
-- Name: linked_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.linked_cards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.linked_cards_id_seq OWNER TO gb_user;

--
-- Name: linked_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.linked_cards_id_seq OWNED BY public.linked_cards.id;


--
-- Name: manufacturers; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.manufacturers (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.manufacturers OWNER TO gb_user;

--
-- Name: manufacturer_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.manufacturer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.manufacturer_id_seq OWNER TO gb_user;

--
-- Name: manufacturer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.manufacturer_id_seq OWNED BY public.manufacturers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    phone character varying(15) NOT NULL,
    email character varying(40) NOT NULL,
    date_or_registration timestamp without time zone
);


ALTER TABLE public.users OWNER TO gb_user;

--
-- Name: number_cart_user; Type: VIEW; Schema: public; Owner: gb_user
--

CREATE VIEW public.number_cart_user AS
 SELECT users.name,
    linked_cards.number_cart_user
   FROM (public.linked_cards
     LEFT JOIN public.users ON ((users.id = linked_cards.user_id)));


ALTER TABLE public.number_cart_user OWNER TO gb_user;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id integer NOT NULL,
    product_id integer NOT NULL,
    number_order integer,
    created_at timestamp without time zone
);


ALTER TABLE public.orders OWNER TO gb_user;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_id_seq OWNER TO gb_user;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_id_seq OWNER TO gb_user;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: returns_product; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.returns_product (
    id integer NOT NULL,
    product_id integer NOT NULL,
    user_id integer NOT NULL,
    reason_for_return text NOT NULL,
    created_at timestamp without time zone
);


ALTER TABLE public.returns_product OWNER TO gb_user;

--
-- Name: returns_product_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.returns_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.returns_product_id_seq OWNER TO gb_user;

--
-- Name: returns_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.returns_product_id_seq OWNED BY public.returns_product.id;


--
-- Name: statuses; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.statuses (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.statuses OWNER TO gb_user;

--
-- Name: statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.statuses_id_seq OWNER TO gb_user;

--
-- Name: statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.statuses_id_seq OWNED BY public.statuses.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO gb_user;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: categories_product id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.categories_product ALTER COLUMN id SET DEFAULT nextval('public.category_product_id_seq'::regclass);


--
-- Name: customer_reviews id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.customer_reviews ALTER COLUMN id SET DEFAULT nextval('public.customer_reviews_id_seq'::regclass);


--
-- Name: delivery id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.delivery ALTER COLUMN id SET DEFAULT nextval('public.delivery_id_seq'::regclass);


--
-- Name: linked_cards id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.linked_cards ALTER COLUMN id SET DEFAULT nextval('public.linked_cards_id_seq'::regclass);


--
-- Name: manufacturers id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.manufacturers ALTER COLUMN id SET DEFAULT nextval('public.manufacturer_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: returns_product id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.returns_product ALTER COLUMN id SET DEFAULT nextval('public.returns_product_id_seq'::regclass);


--
-- Name: statuses id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.statuses ALTER COLUMN id SET DEFAULT nextval('public.statuses_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: banned_words; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.banned_words (word) FROM stdin;
test
\.


--
-- Data for Name: categories_product; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.categories_product (id, name) FROM stdin;
1	бытовая техника
2	продукты питания
3	электро-товары
4	бытовая химия
5	авто-товары
6	посуда
7	мебель
8	текстиль
9	детские товары
10	товары для отдыха
\.


--
-- Data for Name: customer_reviews; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.customer_reviews (id, user_id, product_id, body, created_at) FROM stdin;
1	8	37	lectus pede, ultrices a, auctor non, feugiat	2022-04-01 09:28:56
2	100	64	Donec felis orci,	2022-12-29 02:07:17
3	21	11	turpis egestas. Fusce aliquet magna a neque. Nullam ut nisi a	2023-02-28 14:45:53
4	20	87	adipiscing lobortis risus. In mi pede, nonummy ut, molestie in, tempus	2022-08-19 02:17:59
5	5	30	tristique pharetra. Quisque ac libero nec ligula consectetuer rhoncus. Nullam velit	2023-08-08 21:37:01
6	83	56	arcu vel quam	2022-07-21 13:01:29
7	39	16	a feugiat tellus lorem eu metus. In lorem. Donec elementum, lorem ut	2022-05-22 17:37:22
8	20	41	id risus quis diam	2022-08-01 00:40:44
9	48	9	mi tempor lorem, eget mollis lectus pede et risus. Quisque libero lacus, varius et,	2022-12-16 07:29:19
10	15	40	cursus a, enim.	2024-01-02 11:53:25
11	7	74	imperdiet dictum magna. Ut tincidunt orci quis lectus.	2022-03-07 01:06:57
12	75	84	eu dui. Cum sociis natoque penatibus et	2023-03-12 14:07:44
13	62	82	pharetra, felis eget varius ultrices, mauris ipsum porta elit,	2023-06-28 10:56:49
14	54	29	odio. Etiam ligula tortor, dictum eu, placerat eget, venenatis a, magna. Lorem ipsum	2022-11-30 17:09:32
15	97	45	mauris, aliquam eu, accumsan sed, facilisis vitae, orci. Phasellus dapibus quam	2023-06-17 07:43:19
16	78	26	dapibus id, blandit at, nisi. Cum sociis natoque penatibus et magnis dis parturient montes,	2023-08-09 05:43:13
17	12	83	et magnis dis parturient montes, nascetur ridiculus mus. Proin vel nisl. Quisque fringilla euismod enim.	2023-02-26 02:08:03
19	73	22	Donec elementum, lorem ut aliquam iaculis, lacus pede sagittis augue, eu tempor erat neque non	2022-12-29 20:01:00
20	98	83	Duis ac arcu. Nunc mauris. Morbi non sapien molestie orci tincidunt adipiscing. Mauris	2022-01-21 02:02:40
21	20	70	eu dui. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus	2022-02-17 22:47:37
22	89	21	felis ullamcorper viverra. Maecenas iaculis aliquet diam. Sed diam lorem,	2022-04-18 23:39:52
23	91	74	volutpat. Nulla facilisis. Suspendisse commodo	2024-01-01 03:34:58
24	45	35	tellus id nunc	2023-10-30 00:52:16
25	2	83	iaculis quis, pede. Praesent eu dui. Cum sociis natoque penatibus	2022-10-11 23:08:51
26	98	69	dolor. Nulla semper tellus id nunc interdum feugiat. Sed nec metus facilisis lorem	2022-12-05 04:21:55
27	50	57	nibh. Phasellus nulla. Integer vulputate, risus	2023-01-10 14:09:29
28	89	80	eleifend vitae, erat. Vivamus nisi. Mauris nulla. Integer urna. Vivamus molestie dapibus ligula.	2023-11-01 13:29:28
29	84	33	elit sed consequat	2023-12-01 10:28:47
30	19	71	felis ullamcorper viverra. Maecenas iaculis aliquet diam.	2023-07-17 11:08:05
31	9	48	vel pede blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae velit egestas lacinia.	2022-03-07 15:25:25
32	67	41	ipsum leo elementum sem, vitae aliquam eros turpis non enim. Mauris quis turpis vitae	2024-01-07 04:03:23
33	76	64	purus sapien, gravida non, sollicitudin a, malesuada id, erat. Etiam vestibulum massa rutrum magna.	2022-09-19 02:05:01
34	16	19	blandit mattis. Cras eget	2023-02-13 11:26:15
35	65	51	quis arcu vel quam dignissim pharetra. Nam ac nulla. In tincidunt congue turpis.	2022-07-15 02:57:54
36	96	62	nec enim. Nunc ut erat. Sed	2022-03-08 20:27:21
37	19	86	nulla at sem molestie sodales. Mauris blandit enim consequat purus. Maecenas libero est,	2024-01-05 01:20:06
38	95	21	semper cursus. Integer mollis. Integer tincidunt aliquam arcu. Aliquam ultrices iaculis odio.	2023-07-04 12:54:19
39	52	47	urna. Nullam lobortis quam a felis ullamcorper viverra. Maecenas iaculis	2023-06-18 18:01:39
40	72	94	ligula. Nullam	2023-01-17 19:36:20
41	76	63	ac mi eleifend egestas. Sed pharetra, felis eget varius ultrices, mauris ipsum	2023-05-03 00:56:56
42	76	11	lobortis, nisi nibh lacinia orci, consectetuer euismod est arcu ac	2023-01-03 03:49:53
43	33	48	Morbi sit amet massa. Quisque porttitor eros	2022-11-14 14:25:10
44	5	89	dis parturient montes, nascetur ridiculus mus. Aenean eget magna. Suspendisse tristique neque venenatis	2022-04-26 09:57:58
45	53	57	quam vel sapien	2022-04-25 19:06:23
46	68	53	ligula. Nullam feugiat placerat velit. Quisque varius.	2023-12-09 03:01:58
47	69	64	at, libero. Morbi accumsan	2023-04-12 16:31:24
48	84	39	euismod in, dolor.	2023-07-25 20:14:18
49	44	77	Vestibulum ut eros non enim commodo hendrerit. Donec porttitor tellus non magna.	2023-01-03 06:44:02
50	91	90	fames ac turpis egestas. Aliquam fringilla cursus	2022-07-20 23:47:32
51	42	6	lacinia mattis. Integer eu lacus. Quisque imperdiet, erat nonummy ultricies	2023-10-24 14:13:55
52	85	4	egestas	2022-08-30 17:48:46
53	14	77	Nulla dignissim. Maecenas ornare egestas ligula. Nullam feugiat placerat velit. Quisque varius.	2022-06-16 12:50:23
54	55	69	commodo tincidunt nibh. Phasellus nulla.	2023-06-19 10:50:24
55	71	42	Curabitur vel	2023-10-11 01:22:04
56	62	87	Curae Donec tincidunt. Donec vitae erat vel pede blandit congue. In scelerisque scelerisque dui.	2023-11-11 21:58:38
57	29	15	Sed nec metus facilisis lorem tristique	2023-07-09 21:15:58
58	63	44	mi eleifend egestas. Sed pharetra, felis eget varius ultrices, mauris ipsum	2022-01-09 22:26:13
59	96	80	Sed id risus quis diam luctus lobortis. Class aptent taciti sociosqu	2022-04-05 08:46:45
60	32	2	Fusce fermentum fermentum	2022-11-09 09:23:01
61	3	52	Ut nec urna et arcu imperdiet ullamcorper. Duis at lacus. Quisque purus	2022-03-12 10:02:29
62	55	2	Fusce mollis.	2022-01-09 23:34:48
63	44	66	Praesent interdum ligula	2023-01-27 07:38:30
64	62	39	fringilla est.	2023-01-26 13:46:15
65	22	32	mauris sagittis placerat. Cras dictum ultricies ligula. Nullam enim. Sed	2022-01-10 06:32:50
66	79	7	amet massa. Quisque porttitor eros nec tellus.	2023-07-10 20:59:55
67	17	81	enim. Nunc ut erat. Sed nunc est, mollis non, cursus non, egestas a, dui.	2022-07-23 18:41:37
68	93	16	egestas. Fusce aliquet magna a neque. Nullam ut nisi a odio	2023-04-06 06:46:05
69	86	95	sem, vitae aliquam eros turpis non enim. Mauris quis turpis vitae purus gravida sagittis. Duis	2022-11-17 20:49:16
70	34	99	Cras convallis convallis dolor. Quisque tincidunt pede ac urna. Ut	2022-11-26 08:17:58
71	96	8	amet massa. Quisque porttitor eros nec tellus. Nunc lectus pede, ultrices a, auctor	2023-03-09 20:50:58
72	29	53	amet luctus vulputate, nisi sem	2023-03-15 22:00:04
73	88	42	justo. Praesent luctus. Curabitur egestas nunc sed libero. Proin	2023-05-28 15:30:23
74	76	34	Fusce feugiat. Lorem ipsum dolor sit amet, consectetuer	2022-02-03 21:15:01
75	65	28	dis parturient montes, nascetur ridiculus mus.	2023-03-20 19:50:56
76	91	74	sapien. Nunc pulvinar arcu et pede. Nunc sed orci lobortis augue scelerisque mollis. Phasellus libero	2023-09-12 21:50:16
77	99	34	Aenean euismod mauris eu elit. Nulla	2023-12-16 21:24:51
78	98	35	ullamcorper, nisl arcu iaculis enim, sit amet ornare lectus justo eu arcu.	2022-03-10 22:03:42
79	1	45	accumsan interdum libero dui	2022-06-07 08:46:57
80	75	17	ac mattis semper, dui lectus	2023-04-03 10:57:38
81	14	49	a mi fringilla mi lacinia mattis. Integer eu lacus. Quisque imperdiet, erat nonummy ultricies	2022-07-22 18:28:40
82	99	66	pretium et, rutrum non, hendrerit id, ante. Nunc mauris	2022-09-08 13:27:10
83	96	19	sem mollis	2023-02-11 23:19:54
84	35	77	est mauris, rhoncus id, mollis nec, cursus a, enim. Suspendisse aliquet, sem ut cursus luctus,	2022-08-19 11:38:53
85	58	26	hymenaeos. Mauris ut quam	2023-07-18 10:47:54
86	40	84	Sed	2022-08-05 17:10:39
87	56	80	sed consequat auctor, nunc nulla vulputate dui, nec tempus mauris erat	2023-09-29 00:30:48
88	46	62	vehicula et, rutrum eu, ultrices sit amet, risus. Donec nibh	2023-11-30 11:42:59
89	1	90	interdum. Sed auctor odio a purus. Duis elementum, dui quis accumsan	2023-08-16 16:08:03
90	93	98	Suspendisse ac	2022-06-16 12:00:56
91	20	39	at pede. Cras vulputate velit eu sem. Pellentesque ut	2023-04-18 20:43:20
92	92	5	ac mattis velit	2023-10-27 06:44:54
93	31	99	diam lorem, auctor quis,	2022-10-07 14:56:12
94	94	29	non, luctus sit amet, faucibus ut,	2023-11-04 07:25:44
95	35	64	natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.	2023-03-01 05:39:23
96	80	24	non enim commodo hendrerit. Donec porttitor tellus non magna. Nam	2022-06-08 20:47:24
97	92	10	sit amet nulla. Donec non justo. Proin non massa non ante bibendum ullamcorper. Duis	2023-12-27 15:32:06
98	65	92	elit. Aliquam auctor, velit eget laoreet posuere, enim nisl elementum purus, accumsan interdum	2022-07-12 03:56:30
99	99	35	justo faucibus lectus, a	2022-08-04 20:40:59
100	19	57	lacus. Quisque purus sapien, gravida	2023-11-22 23:30:03
18	98	41	_MODERATED_	2022-09-07 19:34:03
\.


--
-- Data for Name: delivery; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.delivery (id, order_id, delivary_date, status_id) FROM stdin;
1	90	2023-07-12 01:23:45	5
2	17	2022-04-10 08:39:25	2
3	31	2023-09-11 02:27:53	3
4	32	2022-12-23 20:43:39	4
5	34	2022-09-14 18:22:24	2
6	38	2023-08-09 09:53:28	3
7	79	2023-02-03 15:27:08	3
8	40	2023-09-11 12:10:53	5
9	40	2022-09-29 13:18:03	3
10	70	2022-06-16 16:03:53	3
11	2	2022-03-03 02:20:30	4
12	56	2023-05-30 01:14:55	4
13	70	2022-10-04 06:15:13	4
14	60	2022-12-20 08:43:11	2
15	78	2023-04-14 19:13:15	5
16	63	2022-02-02 09:21:21	3
17	34	2023-01-10 12:15:32	3
18	6	2022-11-19 03:20:07	1
19	91	2023-03-10 02:07:30	2
20	88	2023-08-14 03:31:24	3
21	95	2023-05-22 07:03:20	3
22	77	2023-02-04 04:02:38	2
23	49	2023-09-07 23:38:46	2
24	33	2023-03-21 00:35:58	2
25	88	2023-01-12 13:17:35	1
26	94	2023-08-18 13:57:02	3
27	54	2022-08-09 00:33:27	3
28	55	2022-03-25 16:10:25	1
29	35	2022-07-10 18:10:31	4
30	50	2022-11-21 09:45:18	4
31	84	2022-01-26 15:51:50	2
32	53	2023-05-11 01:11:15	2
33	48	2022-05-27 01:04:21	2
34	83	2022-10-14 04:00:50	5
35	16	2022-05-21 22:40:08	4
36	15	2022-01-23 11:24:46	4
37	23	2023-09-30 05:11:11	4
38	38	2022-08-19 16:47:01	2
39	7	2022-12-09 19:35:12	1
40	54	2022-03-06 12:27:23	4
41	91	2023-07-03 12:26:50	4
42	70	2023-04-27 06:08:50	2
43	15	2022-03-25 08:30:19	2
44	63	2022-02-08 15:35:35	2
45	77	2022-10-19 17:53:34	4
46	23	2023-05-24 20:30:53	3
47	89	2022-12-10 00:59:28	4
48	86	2022-10-17 04:34:32	1
49	83	2023-03-04 10:24:48	4
50	47	2023-01-27 06:34:19	4
51	23	2022-10-22 06:09:28	2
52	97	2023-09-13 23:51:31	2
53	79	2023-11-18 17:57:16	3
54	81	2022-07-05 18:57:16	2
55	6	2023-07-11 22:06:49	4
56	49	2022-03-06 20:09:23	5
57	55	2023-02-03 16:46:37	2
58	95	2023-03-01 20:17:27	3
59	18	2023-06-08 15:33:55	2
60	95	2023-12-15 10:53:34	1
61	62	2022-08-23 22:07:31	1
62	64	2022-12-15 00:33:16	4
63	54	2022-04-17 06:48:29	5
64	4	2023-09-28 14:45:00	4
65	91	2022-07-14 12:42:33	3
66	8	2023-03-10 20:13:30	3
67	43	2023-08-30 22:41:45	4
68	88	2023-12-31 01:47:20	1
69	35	2023-10-10 12:29:04	2
70	86	2023-10-29 09:06:23	5
71	28	2023-07-26 23:16:45	4
72	84	2023-08-11 17:26:32	2
73	22	2022-12-08 01:55:54	2
74	12	2022-09-12 15:02:27	3
75	75	2023-06-08 01:00:06	2
76	62	2022-05-29 16:59:50	3
77	4	2022-04-12 01:11:30	3
78	55	2022-05-11 22:43:55	2
79	68	2022-01-21 00:43:27	3
80	52	2022-10-20 08:43:08	3
81	48	2022-12-22 21:05:25	4
82	58	2023-07-07 17:51:30	2
83	49	2023-02-09 19:38:29	2
84	14	2022-12-31 14:09:08	4
85	57	2022-06-11 00:46:37	3
86	81	2022-03-12 11:57:54	4
87	43	2023-12-19 03:09:18	3
88	77	2023-11-21 10:52:12	4
89	23	2022-09-20 07:28:00	1
90	90	2022-03-07 10:50:48	3
91	52	2023-11-09 02:59:58	4
92	62	2023-03-15 07:21:45	3
93	11	2023-02-11 20:01:11	1
94	15	2023-12-23 09:58:50	3
95	92	2022-03-03 20:07:01	4
96	52	2023-12-22 18:45:19	3
97	40	2022-04-06 12:46:50	3
98	51	2022-11-01 13:11:21	2
99	50	2023-03-22 21:30:58	3
100	15	2022-04-17 03:45:15	2
\.


--
-- Data for Name: linked_cards; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.linked_cards (id, user_id, number_cart_user) FROM stdin;
51	84	0.7208399697
52	84	1.0717960024
53	3	1.0522551902
54	65	1.5878678003
55	79	1.1180693210
56	70	1.3454475083
57	53	0.9797962323
58	5	0.5944921600
59	5	1.2442235226
60	75	0.8120981438
61	71	0.5469193309
62	80	1.0521388138
63	91	1.4347645884
64	6	1.2896459264
65	94	0.7835576496
66	93	1.1867623010
67	94	1.3367246000
68	78	0.9085632380
69	94	1.1309542015
70	15	0.8753899323
71	32	0.9238905754
72	90	0.7475083698
73	44	1.3583625391
74	82	0.9825980480
75	5	0.7081353905
76	58	0.9995151340
77	76	1.3246937057
78	39	1.1078324021
79	90	1.2943676624
80	30	1.0633314450
81	10	1.0258772930
82	85	1.1666535001
83	50	0.7966926536
84	81	0.8051060780
85	6	0.8081116943
86	17	1.0712253891
87	98	0.8976735521
88	40	1.1449394831
89	61	0.6881537066
90	77	1.0770023795
91	39	0.9694892506
92	71	1.1687719423
93	3	1.1244998696
94	60	1.3416043373
95	53	1.2512655752
96	74	0.8841474197
97	90	1.3725946278
98	66	1.0448842027
99	97	1.1609529659
100	14	0.9791957665
101	57	0.8811936661
102	23	0.9320569217
103	68	0.8591242086
104	32	0.6267546279
105	77	1.0401686370
106	40	1.1169507516
107	50	0.9931157649
108	78	0.9515420284
109	87	1.1258771175
110	83	1.2607144405
111	75	1.1000288301
112	85	0.8196421882
113	65	1.3820964258
114	56	0.8943450907
115	34	0.7284148203
116	45	0.7737990188
117	34	0.5155167355
118	57	1.0838321781
119	4	1.0890962072
120	21	0.8501593146
121	20	0.8606212826
122	62	1.0326673571
123	86	0.6443561675
124	14	0.7507976191
125	47	1.3209729127
126	34	0.6556434695
127	63	0.8765630866
128	22	0.7421119337
129	37	1.0496138645
130	88	1.1238777042
131	1	0.3837243216
132	17	0.8702436721
133	22	0.6730651831
134	69	1.1174088481
135	28	0.9978290978
136	11	1.0360998650
137	11	0.9039549484
138	16	0.8012211274
139	67	0.9925378816
140	15	1.5126554165
141	19	1.1147978904
142	67	1.0268967840
143	80	0.7964046512
144	65	0.6769622833
145	40	0.9817753063
146	3	1.1290458614
147	3	0.8312093054
148	46	0.9383383489
149	29	1.0070300828
150	12	0.8744809373
\.


--
-- Data for Name: manufacturers; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.manufacturers (id, name) FROM stdin;
1	Vel Corporation
2	Aliquet Magna Corporation
3	Eu Odio LLP
4	Lobortis Industries
5	Consectetuer Limited
6	Vulputate Dui Industries
7	Vitae Corp.
8	Dui Semper Et Corporation
9	Ut Institute
10	Ut Erat Sed Associates
11	Mauris Ut Foundation
12	Bibendum Ltd
13	Egestas Fusce Aliquet Limited
14	Fermentum Metus Limited
15	Tincidunt Adipiscing Foundation
16	Quis Tristique Associates
17	Sit Amet Associates
18	Et Eros Proin Associates
19	Dictum Foundation
20	In Faucibus Corp.
21	Est Industries
22	Faucibus Ut Nulla Corp.
23	Nisl Corporation
24	Dolor Associates
25	Ante Maecenas Corp.
26	Blandit Institute
27	Integer Id Associates
28	Taciti Sociosqu LLC
29	Accumsan Associates
30	Sed Tortor Foundation
31	Morbi Non LLC
32	Amet Ultricies Sem Incorporated
33	Lacus Varius Foundation
34	Magna Praesent Inc.
35	Vestibulum Neque PC
36	Lorem Donec Incorporated
37	In Associates
38	Nec Urna PC
39	Convallis LLP
40	Amet Industries
41	Dui Institute
42	Tincidunt PC
43	Donec Ltd
44	Morbi Metus Incorporated
45	Eu Neque Pellentesque Industries
46	Quis Corp.
47	Lectus Rutrum Foundation
48	Diam Proin Associates
49	Est Mauris Industries
50	Lorem Sit Associates
51	Molestie Tortor Ltd
52	Suscipit Est Ac Associates
53	Nam Tempor Diam Limited
54	Ac Ltd
55	A Malesuada Foundation
56	Nulla Facilisi Company
57	Magna Tellus Limited
58	Facilisis Corporation
59	Maecenas Malesuada Limited
60	Non Luctus Ltd
61	Augue Ac Ltd
62	Duis Industries
63	Etiam Ligula Tortor Ltd
64	Proin Eget PC
65	Lobortis Class Aptent Corporation
66	At Iaculis PC
67	Augue Ut Lacus PC
68	Mauris Inc.
69	Cras Dolor Institute
70	Tincidunt Donec Corporation
71	Duis Gravida Limited
72	Commodo At LLP
73	Ipsum Dolor Sit Foundation
74	Fusce Mi Lorem Inc.
75	Aenean Sed Pede Associates
76	Risus Donec Incorporated
77	Vel Nisl Quisque Institute
78	Pharetra Sed Hendrerit Industries
79	Libero Associates
80	Ipsum Suspendisse Ltd
81	Sem Eget Massa Incorporated
82	Mauris Vel Turpis Corporation
83	Ornare Libero Foundation
84	Lorem Eget Associates
85	Dapibus Rutrum Justo Corporation
86	Est Incorporated
87	Quis Ltd
88	Auctor Associates
89	Arcu Ac Corp.
90	Luctus Ipsum Ltd
91	Quis PC
92	Magnis Dis Parturient Company
93	Ligula Aliquam Limited
94	Arcu Morbi Limited
95	Ornare Elit Elit Associates
96	Ut Nec Corp.
97	At Augue Id Ltd
98	Urna Convallis Corp.
99	Aliquam Erat Corp.
100	Feugiat Sed Nec Ltd
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.orders (id, user_id, product_id, number_order, created_at) FROM stdin;
1	7	56	104	2022-04-27 17:14:36
2	63	12	175	2022-04-04 14:07:33
3	28	54	969	2022-05-06 00:41:45
4	65	60	970	2023-04-16 08:02:01
5	57	81	871	2022-03-11 22:58:44
6	73	89	825	2022-02-28 00:46:30
7	85	57	225	2022-05-18 03:11:01
8	25	24	296	2023-03-07 02:43:35
9	4	69	128	2022-10-17 01:06:10
10	69	73	249	2023-11-22 12:31:26
11	75	78	216	2022-11-23 07:22:52
12	94	82	603	2022-07-11 03:35:24
13	7	95	916	2022-03-07 11:46:22
14	87	43	255	2022-07-15 20:27:57
15	12	44	550	2022-12-07 15:32:56
16	55	53	439	2022-01-29 14:22:31
17	57	64	196	2022-09-13 16:22:01
18	95	13	507	2023-08-28 21:01:30
19	10	11	532	2022-09-22 02:51:11
20	33	91	456	2023-07-25 04:02:35
21	7	77	797	2023-01-10 16:36:56
22	81	86	403	2023-11-30 23:45:27
23	2	36	280	2023-07-30 16:38:23
24	40	1	297	2023-07-11 05:25:11
25	68	39	508	2023-07-29 22:22:16
26	72	39	139	2022-12-05 10:12:21
27	90	11	906	2022-03-18 13:18:57
28	86	35	824	2023-08-31 03:08:08
29	14	6	982	2022-03-22 04:56:13
30	11	38	591	2022-12-17 08:22:22
31	22	39	880	2022-12-22 04:44:51
32	74	32	416	2023-03-10 10:08:43
33	2	88	389	2023-01-27 13:23:35
34	7	32	684	2023-04-29 13:19:11
35	20	65	485	2022-09-22 14:04:42
36	76	21	168	2023-05-05 07:24:19
37	39	58	637	2022-06-05 10:08:58
38	70	98	598	2023-02-21 02:45:34
39	62	38	488	2022-12-24 02:14:15
40	97	42	611	2023-06-15 10:33:54
41	63	68	404	2022-12-29 01:57:40
42	60	73	751	2022-09-12 05:22:50
43	24	92	538	2023-12-27 22:56:53
44	10	71	606	2022-12-15 05:35:02
45	59	94	899	2022-11-06 21:36:45
46	74	57	153	2022-06-27 02:29:04
47	49	16	710	2023-07-04 23:55:10
48	48	45	908	2023-09-05 14:36:54
49	13	5	903	2022-06-09 03:28:02
50	57	76	146	2023-12-09 12:39:18
51	79	63	324	2022-11-13 15:38:44
52	58	56	959	2023-05-16 16:36:13
53	30	82	158	2023-07-14 09:19:18
54	94	59	619	2022-06-18 01:04:02
55	8	27	831	2022-01-28 03:25:38
56	30	61	674	2023-04-06 13:35:02
57	10	17	152	2023-02-23 05:55:28
58	52	20	348	2022-11-08 12:22:07
59	100	65	816	2023-01-02 05:54:37
60	94	17	186	2023-02-03 21:04:18
61	78	23	380	2023-05-03 09:04:23
62	93	21	213	2023-11-07 14:17:07
63	68	27	448	2023-10-14 18:31:05
64	99	99	618	2022-09-21 09:57:20
65	87	40	609	2022-03-07 05:08:05
66	95	78	921	2023-08-17 18:08:46
67	16	74	629	2023-09-25 00:30:46
68	38	64	813	2022-05-30 06:29:01
69	45	38	788	2023-11-22 06:24:53
70	3	12	106	2022-07-19 03:46:24
71	91	79	167	2023-06-26 20:31:02
72	36	39	541	2022-12-07 19:52:38
73	34	68	475	2023-01-30 12:42:38
74	94	74	349	2022-08-16 17:02:48
75	72	62	117	2022-10-01 07:20:25
76	36	82	612	2024-01-07 03:23:31
77	25	75	157	2022-09-17 22:48:13
78	28	6	978	2022-12-26 18:08:42
79	60	95	794	2022-11-23 18:44:59
80	16	14	968	2022-12-28 16:45:38
81	1	91	504	2023-08-05 13:59:48
82	43	73	840	2022-05-13 03:13:44
83	4	59	827	2023-10-27 20:22:16
84	50	96	735	2023-08-10 16:01:07
85	21	80	930	2022-05-11 07:37:38
86	47	52	872	2022-03-07 19:59:12
87	25	52	891	2023-01-27 09:42:49
88	73	87	494	2023-09-20 00:22:56
89	49	86	301	2023-05-23 15:44:43
90	39	35	748	2022-02-18 01:43:25
91	93	53	361	2023-09-08 23:56:06
92	28	63	705	2022-10-27 08:04:16
93	80	14	896	2023-10-31 13:27:16
94	65	78	230	2022-06-03 11:32:36
95	29	100	994	2022-05-26 05:45:45
96	59	47	381	2023-07-16 14:20:50
97	2	94	388	2023-06-26 07:50:55
98	69	26	353	2023-01-14 19:35:51
99	42	94	671	2022-04-16 05:06:01
100	54	60	237	2023-12-31 22:15:36
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.products (id, description, price, category_id, manufacturer_id) FROM stdin;
1	vestibulum massa rutrum magna. Cras convallis convallis dolor. Quisque tincidunt pede ac	26.02	1	14
2	lectus ante dictum mi, ac mattis velit justo nec ante. Maecenas mi felis, adipiscing	25.40	4	44
3	Nullam suscipit, est ac facilisis facilisis, magna tellus faucibus leo, in lobortis tellus	21.95	7	76
4	lorem, auctor	27.60	7	46
5	in faucibus orci luctus et ultrices posuere cubilia Curae Donec tincidunt. Donec vitae erat vel pede blandit	28.83	2	80
6	Integer id magna et ipsum cursus vestibulum. Mauris	27.28	9	80
7	vitae, orci. Phasellus dapibus quam quis diam. Pellentesque habitant morbi	28.58	5	60
8	metus facilisis lorem tristique	26.09	5	42
9	nibh lacinia orci,	21.80	6	68
10	sit amet massa. Quisque porttitor eros nec tellus. Nunc lectus pede, ultrices a, auctor non, feugiat nec,	25.03	6	4
11	purus. Nullam scelerisque neque sed	22.71	3	40
12	lectus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.	28.02	3	75
13	lectus convallis est, vitae sodales nisi magna sed dui. Fusce aliquam,	27.88	7	80
14	aliquet, sem ut cursus luctus, ipsum leo elementum sem, vitae aliquam eros turpis non	25.12	2	82
15	vitae risus. Duis a mi fringilla mi lacinia mattis. Integer eu lacus. Quisque imperdiet, erat nonummy ultricies	28.50	8	4
16	Fusce diam nunc, ullamcorper eu, euismod ac, fermentum vel, mauris. Integer sem elit, pharetra ut, pharetra sed,	25.89	8	88
17	Aenean egestas hendrerit neque. In	23.45	2	44
18	sodales purus, in molestie tortor nibh sit amet	24.86	3	79
19	interdum. Nunc sollicitudin commodo ipsum. Suspendisse non leo. Vivamus nibh dolor, nonummy ac, feugiat non, lobortis quis, pede. Suspendisse	26.87	4	69
20	dolor. Fusce feugiat. Lorem ipsum dolor sit amet, consectetuer adipiscing	22.36	5	9
21	posuere cubilia Curae Donec tincidunt. Donec vitae erat vel pede blandit congue. In scelerisque scelerisque dui.	26.21	8	57
22	tempor lorem, eget mollis lectus pede et risus. Quisque libero lacus,	19.34	4	50
23	pretium neque. Morbi quis urna. Nunc quis arcu vel quam dignissim pharetra. Nam ac nulla. In tincidunt congue turpis. In	28.98	9	50
24	nec quam. Curabitur vel lectus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec dignissim magna	29.05	8	72
25	feugiat tellus lorem eu metus. In lorem. Donec elementum, lorem ut aliquam iaculis, lacus	27.79	2	51
26	lorem eu metus. In	22.72	1	97
27	convallis convallis dolor. Quisque tincidunt pede ac urna. Ut tincidunt vehicula risus. Nulla eget metus eu erat semper	22.77	2	51
28	Donec dignissim magna a tortor. Nunc commodo auctor velit. Aliquam	29.66	2	25
29	tristique	23.47	3	52
30	libero. Morbi accumsan laoreet ipsum. Curabitur consequat, lectus sit amet luctus vulputate, nisi sem semper erat, in consectetuer ipsum	26.73	5	92
31	mauris elit, dictum eu, eleifend nec, malesuada ut, sem. Nulla	27.92	3	6
32	pede, nonummy ut, molestie in, tempus eu, ligula.	23.16	4	86
33	magna. Praesent interdum ligula eu enim. Etiam imperdiet dictum magna.	29.22	8	16
34	odio. Phasellus at augue id	26.55	6	61
35	Sed et libero. Proin mi. Aliquam gravida mauris ut mi. Duis risus odio, auctor vitae, aliquet nec, imperdiet nec,	30.83	8	81
36	orci. Ut sagittis lobortis mauris. Suspendisse aliquet molestie tellus. Aenean egestas hendrerit neque. In ornare sagittis	29.96	3	3
37	tortor. Nunc commodo auctor velit. Aliquam nisl. Nulla eu neque pellentesque massa lobortis ultrices. Vivamus	26.41	10	67
38	rhoncus. Proin nisl sem, consequat nec, mollis vitae, posuere at, velit. Cras lorem lorem, luctus ut, pellentesque eget, dictum	21.70	5	21
39	nunc sit amet metus.	27.27	1	72
40	rhoncus. Donec est. Nunc	30.10	6	82
41	Nam	28.65	8	74
42	non leo. Vivamus nibh dolor, nonummy ac, feugiat non,	26.68	2	46
43	dictum eleifend, nunc risus varius orci, in consequat enim diam	26.28	7	21
44	elit, pellentesque a, facilisis non, bibendum sed,	23.55	3	11
45	mauris.	21.11	7	9
46	ipsum primis in faucibus orci luctus	28.35	3	19
47	Quisque purus sapien, gravida non, sollicitudin a, malesuada id,	29.62	9	33
48	pede, nonummy ut, molestie in, tempus eu, ligula. Aenean euismod mauris eu elit.	28.65	4	83
49	dolor elit,	30.13	8	74
50	Donec porttitor tellus non magna.	33.45	7	83
51	a, magna. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Etiam laoreet, libero et tristique pellentesque,	30.45	8	69
52	quam. Pellentesque habitant morbi tristique senectus et netus et	25.06	5	43
53	molestie tortor nibh sit amet orci. Ut sagittis lobortis mauris. Suspendisse aliquet	28.08	9	47
54	erat. Vivamus	26.62	8	86
55	sapien. Cras dolor dolor, tempus non, lacinia at, iaculis quis, pede. Praesent eu	29.52	5	92
56	aliquet. Proin velit. Sed malesuada augue	27.74	8	76
57	tellus. Phasellus elit pede, malesuada vel, venenatis vel,	31.24	10	55
58	mattis. Integer eu lacus. Quisque imperdiet, erat nonummy ultricies ornare, elit elit fermentum risus, at fringilla purus mauris	21.78	3	83
59	mus. Proin vel nisl. Quisque fringilla euismod enim. Etiam gravida molestie arcu. Sed eu nibh vulputate mauris sagittis placerat.	22.25	3	73
60	sit amet ornare lectus justo eu arcu. Morbi sit amet massa.	22.90	6	68
61	Duis	29.02	9	40
62	Nulla facilisis. Suspendisse commodo tincidunt nibh. Phasellus nulla. Integer vulputate, risus a ultricies adipiscing, enim	24.17	8	21
63	parturient montes, nascetur ridiculus mus. Proin	30.79	6	66
64	egestas blandit. Nam nulla magna, malesuada vel, convallis	27.62	8	67
65	ultrices a, auctor non, feugiat nec, diam. Duis mi enim, condimentum eget, volutpat ornare, facilisis eget, ipsum. Donec	28.43	5	11
66	mus. Proin vel nisl. Quisque fringilla euismod enim. Etiam gravida molestie arcu.	27.23	7	21
67	rhoncus. Proin	23.57	1	37
68	habitant morbi tristique	29.43	9	55
69	erat vel pede blandit congue. In scelerisque scelerisque dui. Suspendisse ac	27.87	3	51
70	lobortis quam a felis ullamcorper viverra. Maecenas iaculis aliquet diam. Sed	23.59	1	99
71	arcu. Morbi	26.13	10	21
72	et, commodo at, libero. Morbi accumsan laoreet	30.84	3	10
73	odio tristique pharetra. Quisque ac libero	27.57	6	38
74	purus, in molestie tortor nibh sit amet orci. Ut sagittis lobortis mauris. Suspendisse aliquet molestie tellus. Aenean egestas	27.66	9	18
75	eu neque pellentesque massa lobortis ultrices. Vivamus rhoncus.	20.93	3	74
76	risus. Quisque libero lacus, varius et,	26.28	1	50
77	pede blandit congue. In scelerisque scelerisque dui. Suspendisse ac	29.03	6	20
78	libero lacus, varius et, euismod et, commodo	18.00	7	22
79	ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus.	29.76	5	68
80	pede. Cras	24.73	3	35
81	Nulla interdum. Curabitur dictum. Phasellus in felis. Nulla tempor augue ac ipsum. Phasellus vitae mauris sit amet lorem semper	16.19	8	64
82	et, rutrum eu, ultrices sit amet, risus. Donec nibh enim, gravida sit amet, dapibus id, blandit	21.72	8	35
83	tellus id nunc interdum feugiat. Sed nec metus facilisis lorem tristique aliquet. Phasellus	24.63	5	21
84	torquent per conubia nostra, per inceptos hymenaeos. Mauris ut quam vel sapien imperdiet ornare. In	25.81	4	26
85	Pellentesque tincidunt tempus risus. Donec egestas. Duis ac arcu. Nunc mauris. Morbi non sapien molestie orci tincidunt adipiscing. Mauris	26.11	4	79
86	vulputate velit eu sem. Pellentesque ut ipsum	19.71	5	66
87	tincidunt nibh. Phasellus nulla.	25.74	4	80
88	lacus. Aliquam rutrum lorem ac risus. Morbi metus. Vivamus euismod urna. Nullam lobortis quam	22.29	6	20
89	Integer aliquam adipiscing lacus. Ut nec urna et arcu imperdiet ullamcorper. Duis at lacus.	29.41	7	49
90	est	26.81	6	29
91	velit. Quisque varius. Nam porttitor scelerisque neque. Nullam nisl. Maecenas malesuada fringilla est. Mauris eu turpis. Nulla aliquet. Proin	27.48	9	68
92	aliquet magna	29.63	3	35
93	vitae velit egestas lacinia. Sed congue, elit sed consequat auctor, nunc nulla vulputate dui, nec tempus mauris erat eget	23.40	6	8
94	lorem, eget mollis lectus pede	22.54	4	47
95	erat. Vivamus	33.04	3	48
96	blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae velit egestas lacinia. Sed congue, elit sed	31.04	5	35
97	tincidunt pede ac urna. Ut tincidunt vehicula risus. Nulla eget metus eu erat semper rutrum. Fusce	23.58	9	78
98	semper tellus id nunc interdum	23.07	8	63
99	vitae dolor. Donec fringilla. Donec feugiat	27.40	5	36
100	tincidunt dui augue eu tellus. Phasellus	24.65	9	89
\.


--
-- Data for Name: returns_product; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.returns_product (id, product_id, user_id, reason_for_return, created_at) FROM stdin;
1	65	33	magna. Praesent interdum	2023-12-19 07:05:05
2	30	78	eu, odio. Phasellus at augue id ante dictum cursus. Nunc mauris elit, dictum	2022-03-24 20:39:06
3	21	3	aliquet. Phasellus fermentum convallis ligula.	2023-06-04 10:40:08
4	4	93	nisi magna sed dui.	2023-12-25 13:24:58
5	7	36	dis parturient montes, nascetur ridiculus mus. Proin	2023-10-20 20:18:10
6	25	98	lorem ac risus. Morbi metus. Vivamus euismod urna.	2022-07-16 16:35:08
7	15	41	Curae Phasellus ornare. Fusce mollis. Duis sit amet diam eu dolor egestas rhoncus. Proin nisl	2022-07-28 17:49:46
8	58	31	Aliquam auctor, velit eget laoreet posuere,	2022-09-21 22:22:57
9	58	36	et, commodo at, libero. Morbi	2022-08-12 18:24:19
10	78	36	Curabitur massa. Vestibulum accumsan neque et nunc. Quisque ornare tortor at risus.	2023-08-10 19:35:08
11	53	65	Donec egestas. Duis ac arcu. Nunc mauris. Morbi non sapien molestie orci tincidunt adipiscing.	2022-07-27 21:27:12
12	25	86	quis, pede. Suspendisse dui. Fusce diam nunc, ullamcorper eu, euismod ac, fermentum	2022-01-09 10:34:59
13	72	53	fringilla, porttitor vulputate, posuere vulputate, lacus. Cras interdum. Nunc sollicitudin commodo ipsum. Suspendisse	2023-11-25 00:08:49
14	74	51	quam. Curabitur vel lectus. Cum sociis natoque penatibus	2022-05-30 00:51:15
15	42	34	Aliquam nec enim. Nunc ut erat. Sed nunc est, mollis non, cursus	2022-03-02 14:38:40
16	65	2	massa. Quisque porttitor eros nec tellus. Nunc lectus pede, ultrices a, auctor	2024-01-05 19:34:44
17	88	12	ornare egestas ligula. Nullam feugiat placerat velit. Quisque varius. Nam	2023-07-25 09:13:28
18	95	58	ac mattis velit justo nec ante. Maecenas mi	2022-02-04 03:58:47
19	58	56	Phasellus ornare. Fusce mollis. Duis sit amet diam eu dolor egestas rhoncus. Proin	2022-11-19 17:07:32
20	50	35	lacinia orci, consectetuer euismod est arcu ac orci. Ut semper pretium neque. Morbi	2022-03-24 22:00:11
21	89	38	Aliquam erat volutpat. Nulla dignissim. Maecenas ornare egestas ligula. Nullam feugiat placerat	2022-06-10 13:19:36
22	97	80	non quam. Pellentesque habitant	2022-08-21 22:42:57
23	54	30	tempor lorem,	2023-05-25 10:27:06
24	69	41	sapien, gravida non, sollicitudin a, malesuada id, erat. Etiam vestibulum massa rutrum magna. Cras convallis	2023-07-23 14:57:32
25	10	13	lacus. Cras interdum. Nunc sollicitudin commodo ipsum. Suspendisse non leo. Vivamus nibh dolor, nonummy	2023-08-22 11:14:30
26	30	2	ut ipsum ac mi eleifend egestas. Sed pharetra, felis eget varius ultrices,	2022-03-21 10:37:16
27	6	56	taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Mauris ut quam vel	2023-02-22 13:57:07
28	31	76	vel turpis. Aliquam adipiscing lobortis risus. In mi pede, nonummy	2022-11-14 05:51:54
29	26	58	dictum eu, placerat eget, venenatis a, magna. Lorem ipsum dolor sit amet,	2023-01-17 04:07:01
30	69	89	dictum ultricies ligula. Nullam enim.	2023-02-06 15:25:28
31	76	30	magna. Duis dignissim tempor arcu. Vestibulum ut eros non enim commodo	2022-12-29 06:00:37
32	62	37	elit. Etiam laoreet, libero et tristique pellentesque, tellus	2022-12-28 20:05:01
33	2	16	fermentum convallis ligula. Donec luctus aliquet odio. Etiam ligula	2023-03-28 17:52:27
34	28	78	in consequat enim diam vel arcu. Curabitur ut	2022-11-27 17:59:17
35	84	71	Donec tincidunt. Donec vitae erat vel pede blandit congue. In scelerisque scelerisque dui. Suspendisse ac	2023-04-25 02:33:46
36	6	3	molestie in, tempus	2023-03-11 19:54:44
37	54	51	tellus. Suspendisse sed dolor. Fusce mi lorem, vehicula et, rutrum	2022-01-27 21:02:12
38	74	54	metus sit amet	2022-12-16 01:03:05
39	30	7	vestibulum nec,	2023-05-21 18:03:22
40	88	47	Phasellus ornare. Fusce mollis. Duis sit amet diam eu dolor egestas rhoncus.	2023-03-10 16:37:31
41	38	99	libero est, congue a, aliquet	2022-04-23 00:15:50
42	51	13	eros turpis non enim. Mauris quis turpis vitae purus gravida sagittis.	2023-02-08 22:34:57
43	70	93	nunc id	2022-09-27 09:29:47
44	33	46	non enim commodo hendrerit.	2024-01-04 19:11:22
45	49	37	arcu. Vestibulum ante ipsum primis	2023-10-07 22:31:23
46	41	34	nec urna	2022-04-26 23:58:47
47	4	79	Fusce aliquam, enim nec tempus scelerisque, lorem	2023-12-31 22:04:17
48	15	94	mauris. Morbi non sapien molestie orci tincidunt adipiscing. Mauris	2023-08-13 13:33:55
49	2	36	mus. Proin vel nisl. Quisque fringilla euismod enim. Etiam	2023-11-24 05:16:37
50	68	94	adipiscing lobortis risus. In mi pede, nonummy	2022-11-16 19:47:44
51	12	69	et tristique pellentesque, tellus sem mollis dui, in sodales elit	2022-05-26 20:05:30
52	15	11	imperdiet dictum magna. Ut tincidunt	2023-12-17 11:23:34
53	44	69	placerat eget, venenatis a, magna. Lorem ipsum dolor sit amet, consectetuer	2023-02-20 04:31:31
54	86	61	molestie arcu. Sed eu nibh vulputate mauris sagittis placerat. Cras dictum	2022-01-13 15:17:41
55	48	81	neque. In ornare sagittis felis. Donec tempor, est ac mattis semper, dui lectus	2022-01-10 06:08:47
56	46	23	magnis dis parturient montes, nascetur ridiculus mus. Aenean eget magna.	2022-02-06 19:20:53
57	71	22	leo, in lobortis	2022-02-17 02:44:26
58	4	98	luctus lobortis. Class aptent	2023-07-05 07:10:43
59	27	76	ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus. Ut	2023-05-21 03:47:53
60	72	69	Fusce fermentum fermentum arcu. Vestibulum	2022-04-01 09:48:33
61	77	31	augue id ante dictum cursus.	2023-03-23 03:02:50
62	15	90	varius ultrices, mauris ipsum porta elit, a feugiat tellus lorem eu metus.	2022-10-06 08:32:06
63	93	95	vel pede	2023-01-15 16:29:01
64	27	77	dui quis accumsan convallis, ante lectus convallis est, vitae sodales nisi magna sed dui.	2022-05-22 20:49:31
65	53	20	non enim commodo hendrerit. Donec porttitor tellus non magna. Nam ligula elit, pretium et,	2022-09-22 11:09:08
66	80	3	pede sagittis augue, eu tempor erat neque non quam. Pellentesque habitant	2022-02-21 06:59:26
67	89	98	a, malesuada id, erat. Etiam vestibulum massa rutrum magna. Cras convallis convallis dolor.	2022-04-12 17:50:43
68	19	38	Sed eu eros. Nam	2022-05-04 01:28:40
69	56	52	dolor. Donec	2022-05-03 21:28:05
70	89	81	et netus et malesuada fames ac turpis egestas. Fusce aliquet magna a	2022-02-11 07:33:13
71	68	18	scelerisque mollis. Phasellus	2023-12-12 13:31:56
72	13	94	nunc, ullamcorper eu, euismod ac, fermentum vel, mauris. Integer sem elit, pharetra ut, pharetra sed,	2022-07-17 11:19:36
73	3	14	gravida sit amet, dapibus id, blandit at, nisi. Cum sociis	2022-10-25 12:31:07
74	6	31	nibh enim, gravida sit amet, dapibus id, blandit at, nisi. Cum	2022-04-01 22:42:00
75	99	65	egestas blandit. Nam nulla	2023-12-31 20:38:15
76	64	48	velit. Quisque varius. Nam porttitor scelerisque neque. Nullam nisl. Maecenas malesuada fringilla est. Mauris	2023-07-02 02:46:14
77	61	23	Phasellus nulla. Integer vulputate, risus a ultricies adipiscing,	2023-03-31 10:37:18
78	92	42	vulputate eu, odio. Phasellus at augue id ante dictum cursus. Nunc mauris elit,	2023-03-02 02:35:43
79	4	48	eu eros. Nam consequat dolor vitae dolor. Donec fringilla. Donec feugiat metus sit	2023-05-09 08:28:54
80	75	68	feugiat. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.	2022-12-17 16:57:06
81	74	42	mauris id sapien. Cras dolor dolor, tempus	2023-11-07 16:23:59
82	97	63	accumsan sed, facilisis	2024-01-07 03:11:10
83	87	59	tellus. Suspendisse sed dolor. Fusce mi lorem, vehicula et, rutrum eu, ultrices sit amet,	2022-01-19 07:55:05
84	3	81	sed pede nec ante blandit viverra.	2023-07-14 22:23:40
85	26	29	odio. Nam interdum enim non nisi. Aenean eget metus. In nec orci. Donec	2023-01-05 12:55:51
86	18	25	netus et malesuada fames ac turpis egestas. Fusce aliquet magna a neque. Nullam	2023-05-06 17:05:50
87	95	22	mauris. Morbi non sapien molestie	2022-11-22 20:40:36
88	93	55	elit. Aliquam	2022-06-21 07:58:26
89	32	46	odio, auctor vitae, aliquet nec, imperdiet nec, leo. Morbi neque tellus, imperdiet	2022-11-05 14:12:21
90	69	76	vel nisl. Quisque fringilla euismod	2022-08-17 18:44:12
91	79	68	a, scelerisque sed, sapien. Nunc pulvinar arcu et pede.	2023-09-29 19:34:52
92	34	83	Nunc ullamcorper, velit in aliquet lobortis, nisi nibh lacinia orci,	2022-01-31 04:01:28
93	89	62	mollis. Integer tincidunt	2022-03-17 01:12:26
94	17	45	ipsum leo elementum sem, vitae aliquam eros turpis non enim. Mauris quis turpis vitae	2022-02-28 23:56:54
95	28	81	vitae nibh. Donec est mauris, rhoncus id, mollis nec, cursus a, enim. Suspendisse aliquet, sem	2023-04-04 20:06:42
96	54	32	lacus vestibulum	2023-05-15 21:02:32
97	22	80	adipiscing elit. Curabitur	2022-11-09 22:37:52
98	57	87	a feugiat tellus	2022-06-05 21:11:38
99	90	99	erat, in consectetuer ipsum nunc id enim. Curabitur massa.	2022-09-25 02:45:21
100	28	53	urna. Ut tincidunt vehicula risus.	2023-10-30 22:45:28
101	65	33	magna. Praesent interdum	2023-12-19 07:05:05
102	30	78	eu, odio. Phasellus at augue id ante dictum cursus. Nunc mauris elit, dictum	2022-03-24 20:39:06
103	21	3	aliquet. Phasellus fermentum convallis ligula.	2023-06-04 10:40:08
104	4	93	nisi magna sed dui.	2023-12-25 13:24:58
105	7	36	dis parturient montes, nascetur ridiculus mus. Proin	2023-10-20 20:18:10
106	25	98	lorem ac risus. Morbi metus. Vivamus euismod urna.	2022-07-16 16:35:08
107	15	41	Curae Phasellus ornare. Fusce mollis. Duis sit amet diam eu dolor egestas rhoncus. Proin nisl	2022-07-28 17:49:46
108	58	31	Aliquam auctor, velit eget laoreet posuere,	2022-09-21 22:22:57
109	58	36	et, commodo at, libero. Morbi	2022-08-12 18:24:19
110	78	36	Curabitur massa. Vestibulum accumsan neque et nunc. Quisque ornare tortor at risus.	2023-08-10 19:35:08
111	53	65	Donec egestas. Duis ac arcu. Nunc mauris. Morbi non sapien molestie orci tincidunt adipiscing.	2022-07-27 21:27:12
112	25	86	quis, pede. Suspendisse dui. Fusce diam nunc, ullamcorper eu, euismod ac, fermentum	2022-01-09 10:34:59
113	72	53	fringilla, porttitor vulputate, posuere vulputate, lacus. Cras interdum. Nunc sollicitudin commodo ipsum. Suspendisse	2023-11-25 00:08:49
114	74	51	quam. Curabitur vel lectus. Cum sociis natoque penatibus	2022-05-30 00:51:15
115	42	34	Aliquam nec enim. Nunc ut erat. Sed nunc est, mollis non, cursus	2022-03-02 14:38:40
116	65	2	massa. Quisque porttitor eros nec tellus. Nunc lectus pede, ultrices a, auctor	2024-01-05 19:34:44
117	88	12	ornare egestas ligula. Nullam feugiat placerat velit. Quisque varius. Nam	2023-07-25 09:13:28
118	95	58	ac mattis velit justo nec ante. Maecenas mi	2022-02-04 03:58:47
119	58	56	Phasellus ornare. Fusce mollis. Duis sit amet diam eu dolor egestas rhoncus. Proin	2022-11-19 17:07:32
120	50	35	lacinia orci, consectetuer euismod est arcu ac orci. Ut semper pretium neque. Morbi	2022-03-24 22:00:11
121	89	38	Aliquam erat volutpat. Nulla dignissim. Maecenas ornare egestas ligula. Nullam feugiat placerat	2022-06-10 13:19:36
122	97	80	non quam. Pellentesque habitant	2022-08-21 22:42:57
123	54	30	tempor lorem,	2023-05-25 10:27:06
124	69	41	sapien, gravida non, sollicitudin a, malesuada id, erat. Etiam vestibulum massa rutrum magna. Cras convallis	2023-07-23 14:57:32
125	10	13	lacus. Cras interdum. Nunc sollicitudin commodo ipsum. Suspendisse non leo. Vivamus nibh dolor, nonummy	2023-08-22 11:14:30
126	30	2	ut ipsum ac mi eleifend egestas. Sed pharetra, felis eget varius ultrices,	2022-03-21 10:37:16
127	6	56	taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Mauris ut quam vel	2023-02-22 13:57:07
128	31	76	vel turpis. Aliquam adipiscing lobortis risus. In mi pede, nonummy	2022-11-14 05:51:54
129	26	58	dictum eu, placerat eget, venenatis a, magna. Lorem ipsum dolor sit amet,	2023-01-17 04:07:01
130	69	89	dictum ultricies ligula. Nullam enim.	2023-02-06 15:25:28
131	76	30	magna. Duis dignissim tempor arcu. Vestibulum ut eros non enim commodo	2022-12-29 06:00:37
132	62	37	elit. Etiam laoreet, libero et tristique pellentesque, tellus	2022-12-28 20:05:01
133	2	16	fermentum convallis ligula. Donec luctus aliquet odio. Etiam ligula	2023-03-28 17:52:27
134	28	78	in consequat enim diam vel arcu. Curabitur ut	2022-11-27 17:59:17
135	84	71	Donec tincidunt. Donec vitae erat vel pede blandit congue. In scelerisque scelerisque dui. Suspendisse ac	2023-04-25 02:33:46
136	6	3	molestie in, tempus	2023-03-11 19:54:44
137	54	51	tellus. Suspendisse sed dolor. Fusce mi lorem, vehicula et, rutrum	2022-01-27 21:02:12
138	74	54	metus sit amet	2022-12-16 01:03:05
139	30	7	vestibulum nec,	2023-05-21 18:03:22
140	88	47	Phasellus ornare. Fusce mollis. Duis sit amet diam eu dolor egestas rhoncus.	2023-03-10 16:37:31
141	38	99	libero est, congue a, aliquet	2022-04-23 00:15:50
142	51	13	eros turpis non enim. Mauris quis turpis vitae purus gravida sagittis.	2023-02-08 22:34:57
143	70	93	nunc id	2022-09-27 09:29:47
144	33	46	non enim commodo hendrerit.	2024-01-04 19:11:22
145	49	37	arcu. Vestibulum ante ipsum primis	2023-10-07 22:31:23
146	41	34	nec urna	2022-04-26 23:58:47
147	4	79	Fusce aliquam, enim nec tempus scelerisque, lorem	2023-12-31 22:04:17
148	15	94	mauris. Morbi non sapien molestie orci tincidunt adipiscing. Mauris	2023-08-13 13:33:55
149	2	36	mus. Proin vel nisl. Quisque fringilla euismod enim. Etiam	2023-11-24 05:16:37
150	68	94	adipiscing lobortis risus. In mi pede, nonummy	2022-11-16 19:47:44
151	12	69	et tristique pellentesque, tellus sem mollis dui, in sodales elit	2022-05-26 20:05:30
152	15	11	imperdiet dictum magna. Ut tincidunt	2023-12-17 11:23:34
153	44	69	placerat eget, venenatis a, magna. Lorem ipsum dolor sit amet, consectetuer	2023-02-20 04:31:31
154	86	61	molestie arcu. Sed eu nibh vulputate mauris sagittis placerat. Cras dictum	2022-01-13 15:17:41
155	48	81	neque. In ornare sagittis felis. Donec tempor, est ac mattis semper, dui lectus	2022-01-10 06:08:47
156	46	23	magnis dis parturient montes, nascetur ridiculus mus. Aenean eget magna.	2022-02-06 19:20:53
157	71	22	leo, in lobortis	2022-02-17 02:44:26
158	4	98	luctus lobortis. Class aptent	2023-07-05 07:10:43
159	27	76	ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus. Ut	2023-05-21 03:47:53
160	72	69	Fusce fermentum fermentum arcu. Vestibulum	2022-04-01 09:48:33
161	77	31	augue id ante dictum cursus.	2023-03-23 03:02:50
162	15	90	varius ultrices, mauris ipsum porta elit, a feugiat tellus lorem eu metus.	2022-10-06 08:32:06
163	93	95	vel pede	2023-01-15 16:29:01
164	27	77	dui quis accumsan convallis, ante lectus convallis est, vitae sodales nisi magna sed dui.	2022-05-22 20:49:31
165	53	20	non enim commodo hendrerit. Donec porttitor tellus non magna. Nam ligula elit, pretium et,	2022-09-22 11:09:08
166	80	3	pede sagittis augue, eu tempor erat neque non quam. Pellentesque habitant	2022-02-21 06:59:26
167	89	98	a, malesuada id, erat. Etiam vestibulum massa rutrum magna. Cras convallis convallis dolor.	2022-04-12 17:50:43
168	19	38	Sed eu eros. Nam	2022-05-04 01:28:40
169	56	52	dolor. Donec	2022-05-03 21:28:05
170	89	81	et netus et malesuada fames ac turpis egestas. Fusce aliquet magna a	2022-02-11 07:33:13
171	68	18	scelerisque mollis. Phasellus	2023-12-12 13:31:56
172	13	94	nunc, ullamcorper eu, euismod ac, fermentum vel, mauris. Integer sem elit, pharetra ut, pharetra sed,	2022-07-17 11:19:36
173	3	14	gravida sit amet, dapibus id, blandit at, nisi. Cum sociis	2022-10-25 12:31:07
174	6	31	nibh enim, gravida sit amet, dapibus id, blandit at, nisi. Cum	2022-04-01 22:42:00
175	99	65	egestas blandit. Nam nulla	2023-12-31 20:38:15
176	64	48	velit. Quisque varius. Nam porttitor scelerisque neque. Nullam nisl. Maecenas malesuada fringilla est. Mauris	2023-07-02 02:46:14
177	61	23	Phasellus nulla. Integer vulputate, risus a ultricies adipiscing,	2023-03-31 10:37:18
178	92	42	vulputate eu, odio. Phasellus at augue id ante dictum cursus. Nunc mauris elit,	2023-03-02 02:35:43
179	4	48	eu eros. Nam consequat dolor vitae dolor. Donec fringilla. Donec feugiat metus sit	2023-05-09 08:28:54
180	75	68	feugiat. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.	2022-12-17 16:57:06
181	74	42	mauris id sapien. Cras dolor dolor, tempus	2023-11-07 16:23:59
182	97	63	accumsan sed, facilisis	2024-01-07 03:11:10
183	87	59	tellus. Suspendisse sed dolor. Fusce mi lorem, vehicula et, rutrum eu, ultrices sit amet,	2022-01-19 07:55:05
184	3	81	sed pede nec ante blandit viverra.	2023-07-14 22:23:40
185	26	29	odio. Nam interdum enim non nisi. Aenean eget metus. In nec orci. Donec	2023-01-05 12:55:51
186	18	25	netus et malesuada fames ac turpis egestas. Fusce aliquet magna a neque. Nullam	2023-05-06 17:05:50
187	95	22	mauris. Morbi non sapien molestie	2022-11-22 20:40:36
188	93	55	elit. Aliquam	2022-06-21 07:58:26
189	32	46	odio, auctor vitae, aliquet nec, imperdiet nec, leo. Morbi neque tellus, imperdiet	2022-11-05 14:12:21
190	69	76	vel nisl. Quisque fringilla euismod	2022-08-17 18:44:12
191	79	68	a, scelerisque sed, sapien. Nunc pulvinar arcu et pede.	2023-09-29 19:34:52
192	34	83	Nunc ullamcorper, velit in aliquet lobortis, nisi nibh lacinia orci,	2022-01-31 04:01:28
193	89	62	mollis. Integer tincidunt	2022-03-17 01:12:26
194	17	45	ipsum leo elementum sem, vitae aliquam eros turpis non enim. Mauris quis turpis vitae	2022-02-28 23:56:54
195	28	81	vitae nibh. Donec est mauris, rhoncus id, mollis nec, cursus a, enim. Suspendisse aliquet, sem	2023-04-04 20:06:42
196	54	32	lacus vestibulum	2023-05-15 21:02:32
197	22	80	adipiscing elit. Curabitur	2022-11-09 22:37:52
198	57	87	a feugiat tellus	2022-06-05 21:11:38
199	90	99	erat, in consectetuer ipsum nunc id enim. Curabitur massa.	2022-09-25 02:45:21
200	28	53	urna. Ut tincidunt vehicula risus.	2023-10-30 22:45:28
\.


--
-- Data for Name: statuses; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.statuses (id, name) FROM stdin;
1	Собирается
2	Отгружено
3	Отправлено
4	В пути
5	Доставлено
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.users (id, name, phone, email, date_or_registration) FROM stdin;
1	Glenna Roman	(355) 475-8326	donec.feugiat@hotmail.edu	2023-07-31 19:10:55
2	Whilemina George	(646) 946-8284	proin@google.org	2022-08-30 03:15:13
3	Venus West	(946) 941-7334	id.sapien@hotmail.org	2022-06-27 05:31:13
4	Iola Juarez	(228) 260-9772	nulla.facilisis@aol.edu	2022-06-22 09:16:15
5	Ashton Terrell	(466) 870-1845	laoreet@icloud.net	2023-11-15 03:08:50
6	Iris Mcfadden	(236) 325-8003	hendrerit.donec@outlook.org	2024-01-01 00:27:55
7	Fuller Petersen	(588) 671-2132	ligula.nullam@google.couk	2023-03-12 03:40:41
8	Maile Vance	(330) 696-5234	fermentum.vel@icloud.ca	2023-07-23 10:43:19
9	Devin Riggs	(828) 236-2431	sociis.natoque@aol.org	2022-03-09 10:05:27
10	Glenna Bird	(276) 788-9338	euismod.est@outlook.ca	2023-06-25 02:25:39
11	Yuri Sutton	(288) 471-5723	nam.nulla@protonmail.ca	2023-10-01 08:11:24
12	Zeus Romero	(456) 766-6136	ante.nunc@icloud.ca	2022-08-31 02:39:37
13	Tyrone Noel	(666) 235-5765	orci.lacus.vestibulum@icloud.com	2023-05-24 12:04:10
14	Keelie Dunlap	(891) 340-5244	fringilla@yahoo.com	2023-08-30 20:16:32
15	Sasha Lucas	(538) 162-9518	morbi.accumsan@icloud.couk	2022-09-08 22:13:10
16	Miranda Stevenson	(922) 817-4333	arcu@aol.net	2023-03-20 09:07:12
17	Madonna Manning	(164) 501-3692	ipsum.nunc.id@aol.edu	2022-06-06 01:53:51
18	Yasir Frye	(976) 942-9742	ornare@icloud.ca	2022-03-05 07:53:33
19	Naida Sweeney	(295) 941-3168	ridiculus.mus@icloud.com	2022-09-15 05:08:56
20	Aquila Savage	(246) 836-1462	curabitur@yahoo.com	2023-01-03 02:17:30
21	Barclay Dotson	(818) 311-1482	accumsan.laoreet@yahoo.org	2023-05-02 03:51:24
22	Sacha Estes	(237) 886-8975	ac@google.couk	2023-05-10 20:47:49
23	Inga Beasley	(578) 512-6171	quisque.ornare@protonmail.org	2022-04-16 12:08:50
24	Chanda Mack	(422) 645-5686	tortor.integer.aliquam@yahoo.net	2022-02-12 18:23:44
25	Echo Langley	(220) 857-8116	dictum.eu.placerat@protonmail.couk	2023-02-28 06:12:04
26	Christian Barron	(214) 713-8107	luctus.curabitur.egestas@icloud.com	2023-08-23 04:57:28
27	Randall Bishop	(757) 341-4335	malesuada@icloud.net	2024-01-06 22:37:53
28	Brennan Bush	(515) 284-2202	auctor@aol.edu	2022-04-10 17:01:52
29	Jason Maynard	(584) 906-6665	aliquam.adipiscing@icloud.org	2022-01-20 13:34:53
30	Alvin Jennings	(775) 496-1383	sem.molestie@google.edu	2023-11-25 01:44:34
31	Malik Michael	(551) 322-6218	mauris.magna@yahoo.com	2022-08-31 00:58:55
32	Lane Roth	(572) 342-3384	vestibulum.neque@yahoo.com	2024-01-05 16:43:45
33	Melyssa Acevedo	(572) 664-2741	lorem@yahoo.net	2023-05-07 10:29:11
34	Bevis Gay	(373) 203-8372	tellus.id.nunc@hotmail.org	2023-04-05 00:44:55
35	Dana Nolan	(841) 834-2246	mauris.blandit@google.ca	2022-08-13 02:30:56
36	Portia Mcintosh	(839) 867-2505	non.magna.nam@aol.edu	2023-02-05 22:38:26
37	Ethan Christensen	(587) 372-3269	dui.cras@hotmail.couk	2022-02-07 13:53:00
38	Hamish White	(289) 418-2028	scelerisque.lorem@protonmail.couk	2023-11-15 05:02:19
39	Vernon Hardy	(715) 784-1111	enim.sed@outlook.couk	2022-12-22 00:25:38
40	Portia Thompson	(178) 227-8971	tempus.lorem.fringilla@google.org	2022-02-13 17:15:55
41	Shana Lester	(475) 705-1487	phasellus.libero@google.net	2023-08-28 03:13:36
42	Devin Marsh	(675) 436-2856	fringilla.cursus.purus@protonmail.ca	2023-07-09 04:40:56
43	Kadeem Vasquez	(153) 206-2343	et.ultrices@outlook.couk	2023-09-13 16:57:18
44	Inez Joseph	(235) 669-7876	cursus.vestibulum@outlook.edu	2023-03-27 21:29:27
45	Noah Bruce	(735) 861-0714	risus.varius@icloud.ca	2022-08-26 23:23:14
46	Jana Davenport	(275) 222-6455	lacus.ut.nec@icloud.net	2023-07-21 21:23:54
47	Lani Robertson	(685) 401-8847	eu.arcu@outlook.couk	2023-08-15 01:04:38
48	Nissim Mcintyre	(313) 413-3359	et.rutrum.non@icloud.couk	2023-03-18 06:57:07
49	Hollee Gordon	(963) 728-2348	praesent.eu@protonmail.couk	2022-09-23 15:59:39
50	Tallulah Christian	(596) 827-6652	nunc@icloud.com	2022-06-13 06:02:15
51	Leigh Holcomb	(808) 880-1176	enim.sit@hotmail.edu	2023-04-24 10:19:01
52	Jakeem Pope	(472) 534-0624	lorem.fringilla@outlook.edu	2023-11-13 05:12:02
53	September Hobbs	(643) 442-2265	magna@google.edu	2023-12-07 02:08:52
54	Shelly Sampson	(387) 386-0078	tellus@icloud.edu	2023-10-13 14:04:07
55	Graiden Franks	(686) 966-4160	dui.suspendisse@outlook.org	2022-12-29 06:38:12
56	Silas Cobb	(558) 251-0016	pede@icloud.net	2023-11-11 07:18:24
57	Sean Green	(348) 447-1296	per@outlook.couk	2022-06-07 08:29:46
58	Erin Gross	(327) 713-8513	risus@aol.org	2023-05-18 15:51:42
59	Fatima Barnett	(621) 549-1868	nunc.mauris.elit@outlook.couk	2023-12-19 17:37:02
60	Rebecca Weiss	(999) 359-4202	consectetuer.adipiscing.elit@outlook.net	2023-10-20 14:13:16
61	Ross Pierce	(282) 518-7265	sem@hotmail.net	2023-03-05 01:56:53
62	Hiram Durham	(960) 517-8853	diam@icloud.ca	2022-10-18 02:09:19
63	Cheyenne Sellers	(762) 558-9080	lorem.sit.amet@icloud.ca	2023-07-28 03:25:54
64	Wendy Hess	(245) 155-3682	nisl.maecenas.malesuada@yahoo.couk	2023-10-22 03:51:58
65	Kylynn Sosa	(524) 977-9543	ultrices@hotmail.com	2023-10-13 23:02:23
66	Juliet White	(717) 334-6234	dictum.ultricies@icloud.org	2022-12-24 03:58:53
67	Mark Spears	(573) 495-7878	accumsan@icloud.ca	2023-03-09 04:02:38
68	Glenna Singleton	(320) 650-2631	fringilla@google.com	2023-07-05 14:51:19
69	Rhiannon Ray	(726) 776-2041	lacus.quisque@icloud.com	2023-03-28 02:43:34
70	Adele Herrera	(640) 201-4798	pharetra.quisque.ac@yahoo.net	2023-09-06 15:23:19
71	Scarlett Mcintyre	(405) 882-6006	dis.parturient.montes@aol.net	2023-01-25 10:26:38
72	Yvonne Moses	(581) 380-7762	in.scelerisque@aol.net	2024-01-07 04:47:41
73	Macaulay Duke	(846) 664-0475	ipsum@icloud.couk	2023-02-21 15:59:17
74	Bevis Knox	(478) 486-1349	odio.aliquam.vulputate@outlook.edu	2022-09-07 16:44:38
75	Brennan Ortiz	(342) 647-9261	erat.vivamus.nisi@icloud.org	2023-11-14 02:27:56
76	Iola Bond	(371) 875-4727	sem@protonmail.ca	2023-03-21 16:25:53
77	Jessamine Hale	(111) 418-0525	odio.nam@outlook.edu	2023-04-12 13:07:11
78	Fatima Sloan	(214) 855-5628	metus.aenean@outlook.edu	2022-01-09 14:01:12
79	Ciaran Manning	(730) 784-4234	dictum.cursus@yahoo.couk	2022-04-30 20:01:15
80	Gillian Rosa	(827) 831-3674	cubilia.curae@yahoo.org	2022-05-10 22:00:19
81	Andrew Castaneda	(825) 286-5490	elit@protonmail.org	2022-12-16 03:42:55
82	Wynter Edwards	(634) 206-2783	at.velit@protonmail.couk	2023-01-09 15:59:27
83	Kirestin Hansen	(485) 376-9292	ut@aol.ca	2022-05-25 08:48:21
84	Chantale Hunter	(512) 371-2820	parturient.montes.nascetur@hotmail.couk	2023-07-14 03:16:35
85	Kiayada Ray	(523) 868-8317	egestas.rhoncus@google.ca	2022-04-24 06:16:03
86	Imogene Robertson	(111) 787-0653	enim.commodo@outlook.com	2023-10-13 05:57:39
87	Harding Joyner	(305) 184-4506	molestie.tortor.nibh@protonmail.couk	2022-04-04 08:17:43
88	Karly Thompson	(571) 320-0262	curae@hotmail.com	2023-05-26 12:13:24
89	Sebastian Brewer	(715) 828-8009	eget.ipsum@protonmail.net	2023-05-26 06:28:01
90	Kylee Terrell	(655) 256-2020	montes.nascetur.ridiculus@protonmail.org	2022-10-25 16:44:42
91	Quinlan Martin	(801) 612-2027	mus.donec@google.ca	2023-12-21 13:41:59
92	Brian Miranda	(555) 238-8438	lectus@hotmail.org	2023-04-12 16:20:13
93	Regina Sherman	(986) 426-6373	at@protonmail.net	2022-09-09 15:51:11
94	Pearl Luna	(783) 874-0321	lacus.pede@outlook.ca	2023-12-29 01:54:20
95	Cassidy Ayers	(417) 414-6802	morbi@icloud.ca	2023-06-18 13:02:10
96	Daphne Potter	(948) 661-1283	non.magna@icloud.com	2022-07-11 22:47:32
97	Tallulah Santos	(964) 494-3188	augue.sed@protonmail.edu	2022-06-23 03:38:19
98	Cameron Beard	(352) 916-5566	porttitor@outlook.edu	2022-03-31 23:05:07
99	Rogan Hardy	(267) 258-8554	cras@icloud.edu	2022-01-26 11:44:20
100	Burke Buchanan	(804) 582-3781	blandit.mattis.cras@google.net	2023-05-23 14:36:39
\.


--
-- Name: category_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.category_product_id_seq', 10, true);


--
-- Name: customer_reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.customer_reviews_id_seq', 100, true);


--
-- Name: delivery_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.delivery_id_seq', 100, true);


--
-- Name: linked_cards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.linked_cards_id_seq', 150, true);


--
-- Name: manufacturer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.manufacturer_id_seq', 100, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.orders_id_seq', 1, false);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.products_id_seq', 100, true);


--
-- Name: returns_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.returns_product_id_seq', 200, true);


--
-- Name: statuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.statuses_id_seq', 5, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.users_id_seq', 100, true);


--
-- Name: categories_product category_product_name_key; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.categories_product
    ADD CONSTRAINT category_product_name_key UNIQUE (name);


--
-- Name: categories_product category_product_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.categories_product
    ADD CONSTRAINT category_product_pkey PRIMARY KEY (id);


--
-- Name: customer_reviews customer_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.customer_reviews
    ADD CONSTRAINT customer_reviews_pkey PRIMARY KEY (id);


--
-- Name: delivery delivery_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT delivery_pkey PRIMARY KEY (id);


--
-- Name: linked_cards linked_cards_numder_cart_user_key; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.linked_cards
    ADD CONSTRAINT linked_cards_numder_cart_user_key UNIQUE (number_cart_user);


--
-- Name: linked_cards linked_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.linked_cards
    ADD CONSTRAINT linked_cards_pkey PRIMARY KEY (id);


--
-- Name: manufacturers manufacturer_name_key; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturer_name_key UNIQUE (name);


--
-- Name: manufacturers manufacturer_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturer_pkey PRIMARY KEY (id);


--
-- Name: orders orders_number_order_key; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_number_order_key UNIQUE (number_order);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: returns_product returns_product_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.returns_product
    ADD CONSTRAINT returns_product_pkey PRIMARY KEY (id);


--
-- Name: statuses statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.statuses
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: created_at_return_product; Type: INDEX; Schema: public; Owner: gb_user
--

CREATE INDEX created_at_return_product ON public.returns_product USING btree (created_at);


--
-- Name: manufacturer_product_id_fk; Type: INDEX; Schema: public; Owner: gb_user
--

CREATE INDEX manufacturer_product_id_fk ON public.products USING btree (manufacturer_id);


--
-- Name: product_category_id_fk; Type: INDEX; Schema: public; Owner: gb_user
--

CREATE INDEX product_category_id_fk ON public.products USING btree (category_id);


--
-- Name: returns_product_id_fk; Type: INDEX; Schema: public; Owner: gb_user
--

CREATE INDEX returns_product_id_fk ON public.returns_product USING btree (product_id);


--
-- Name: returns_product_user_id_fk; Type: INDEX; Schema: public; Owner: gb_user
--

CREATE INDEX returns_product_user_id_fk ON public.returns_product USING btree (user_id);


--
-- Name: customer_reviews check_message_on_insert; Type: TRIGGER; Schema: public; Owner: gb_user
--

CREATE TRIGGER check_message_on_insert BEFORE INSERT ON public.customer_reviews FOR EACH ROW EXECUTE FUNCTION public.update_message_body_trigger();


--
-- Name: customer_reviews check_message_on_update; Type: TRIGGER; Schema: public; Owner: gb_user
--

CREATE TRIGGER check_message_on_update BEFORE UPDATE ON public.customer_reviews FOR EACH ROW EXECUTE FUNCTION public.update_message_body_trigger();


--
-- Name: customer_reviews customer_reviews_product_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.customer_reviews
    ADD CONSTRAINT customer_reviews_product_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: customer_reviews customer_reviews_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.customer_reviews
    ADD CONSTRAINT customer_reviews_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: delivery delivery_order_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT delivery_order_id_fk FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: delivery delivery_status_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT delivery_status_id_fk FOREIGN KEY (status_id) REFERENCES public.statuses(id);


--
-- Name: linked_cards linked_card_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.linked_cards
    ADD CONSTRAINT linked_card_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: products manufacturer_product_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT manufacturer_product_id_fk FOREIGN KEY (manufacturer_id) REFERENCES public.manufacturers(id);


--
-- Name: orders orders_product_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_product_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: orders orders_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: products product_category_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT product_category_id_fk FOREIGN KEY (category_id) REFERENCES public.categories_product(id);


--
-- Name: returns_product returns_product_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.returns_product
    ADD CONSTRAINT returns_product_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: returns_product returns_product_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.returns_product
    ADD CONSTRAINT returns_product_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

