--
-- PostgreSQL database dump
--

\restrict 8SMHlTUf9NTGi19rZ1MR43ni4lmuFdbfv859KXNyU2qYfTcXDn9kjmirttC8zuW

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

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

ALTER TABLE IF EXISTS ONLY public.departamentos DROP CONSTRAINT IF EXISTS fk_pais;
ALTER TABLE IF EXISTS ONLY public.beneficios_marca DROP CONSTRAINT IF EXISTS fk_marca_beneficio;
ALTER TABLE IF EXISTS ONLY public.ciudades DROP CONSTRAINT IF EXISTS fk_departamento;
ALTER TABLE IF EXISTS ONLY public.usuarios DROP CONSTRAINT IF EXISTS usuarios_pkey;
ALTER TABLE IF EXISTS ONLY public.usuarios DROP CONSTRAINT IF EXISTS usuarios_correo_electronico_key;
ALTER TABLE IF EXISTS ONLY public.clientes_lealtad DROP CONSTRAINT IF EXISTS uklaxxruk3rbc6yeo7fkph1s7k7;
ALTER TABLE IF EXISTS ONLY public.clientes_lealtad DROP CONSTRAINT IF EXISTS ukho4knjf2w7jawtrh8li7q9b43;
ALTER TABLE IF EXISTS ONLY public.tokens_recuperacion DROP CONSTRAINT IF EXISTS ukhcqjf5nk080wnan5c5wyfildd;
ALTER TABLE IF EXISTS ONLY public.tokens_recuperacion DROP CONSTRAINT IF EXISTS tokens_recuperacion_pkey;
ALTER TABLE IF EXISTS ONLY public.tipos_identificacion DROP CONSTRAINT IF EXISTS tipos_identificacion_pkey;
ALTER TABLE IF EXISTS ONLY public.tipos_identificacion DROP CONSTRAINT IF EXISTS tipos_identificacion_nombre_tipo_key;
ALTER TABLE IF EXISTS ONLY public.paises DROP CONSTRAINT IF EXISTS paises_pkey;
ALTER TABLE IF EXISTS ONLY public.paises DROP CONSTRAINT IF EXISTS paises_nombre_pais_key;
ALTER TABLE IF EXISTS ONLY public.marcas DROP CONSTRAINT IF EXISTS marcas_pkey;
ALTER TABLE IF EXISTS ONLY public.marcas DROP CONSTRAINT IF EXISTS marcas_nombre_marca_key;
ALTER TABLE IF EXISTS ONLY public.departamentos DROP CONSTRAINT IF EXISTS departamentos_pkey;
ALTER TABLE IF EXISTS ONLY public.clientes_lealtad DROP CONSTRAINT IF EXISTS clientes_lealtad_pkey;
ALTER TABLE IF EXISTS ONLY public.ciudades DROP CONSTRAINT IF EXISTS ciudades_pkey;
ALTER TABLE IF EXISTS ONLY public.beneficios_marca DROP CONSTRAINT IF EXISTS beneficios_marca_pkey;
ALTER TABLE IF EXISTS public.usuarios ALTER COLUMN id_usuario DROP DEFAULT;
ALTER TABLE IF EXISTS public.tipos_identificacion ALTER COLUMN id_tipo_identificacion DROP DEFAULT;
ALTER TABLE IF EXISTS public.paises ALTER COLUMN id_pais DROP DEFAULT;
ALTER TABLE IF EXISTS public.marcas ALTER COLUMN id_marca DROP DEFAULT;
ALTER TABLE IF EXISTS public.departamentos ALTER COLUMN id_departamento DROP DEFAULT;
ALTER TABLE IF EXISTS public.ciudades ALTER COLUMN id_ciudad DROP DEFAULT;
ALTER TABLE IF EXISTS public.beneficios_marca ALTER COLUMN id_beneficio DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.usuarios_id_usuario_seq;
DROP TABLE IF EXISTS public.usuarios;
DROP TABLE IF EXISTS public.tokens_recuperacion;
DROP SEQUENCE IF EXISTS public.tipos_identificacion_id_tipo_identificacion_seq;
DROP TABLE IF EXISTS public.tipos_identificacion;
DROP SEQUENCE IF EXISTS public.paises_id_pais_seq;
DROP TABLE IF EXISTS public.paises;
DROP SEQUENCE IF EXISTS public.marcas_id_marca_seq;
DROP TABLE IF EXISTS public.marcas;
DROP SEQUENCE IF EXISTS public.departamentos_id_departamento_seq;
DROP TABLE IF EXISTS public.departamentos;
DROP TABLE IF EXISTS public.clientes_lealtad;
DROP SEQUENCE IF EXISTS public.ciudades_id_ciudad_seq;
DROP TABLE IF EXISTS public.ciudades;
DROP SEQUENCE IF EXISTS public.beneficios_marca_id_beneficio_seq;
DROP TABLE IF EXISTS public.beneficios_marca;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: beneficios_marca; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.beneficios_marca (
    id_beneficio integer NOT NULL,
    id_marca integer NOT NULL,
    titulo_beneficio character varying(150) NOT NULL,
    descripcion_beneficio text NOT NULL
);


ALTER TABLE public.beneficios_marca OWNER TO postgres;

--
-- Name: beneficios_marca_id_beneficio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.beneficios_marca_id_beneficio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.beneficios_marca_id_beneficio_seq OWNER TO postgres;

--
-- Name: beneficios_marca_id_beneficio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.beneficios_marca_id_beneficio_seq OWNED BY public.beneficios_marca.id_beneficio;


--
-- Name: ciudades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ciudades (
    id_ciudad integer NOT NULL,
    nombre_ciudad character varying(100) NOT NULL,
    id_departamento integer NOT NULL
);


ALTER TABLE public.ciudades OWNER TO postgres;

--
-- Name: ciudades_id_ciudad_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ciudades_id_ciudad_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ciudades_id_ciudad_seq OWNER TO postgres;

--
-- Name: ciudades_id_ciudad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ciudades_id_ciudad_seq OWNED BY public.ciudades.id_ciudad;


--
-- Name: clientes_lealtad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes_lealtad (
    id_cliente bigint NOT NULL,
    apellidos character varying(100) NOT NULL,
    ciudad character varying(100) NOT NULL,
    correo_electronico character varying(100) NOT NULL,
    departamento character varying(100) NOT NULL,
    direccion character varying(150) NOT NULL,
    fecha_nacimiento date NOT NULL,
    fecha_registro timestamp(6) without time zone,
    id_marca bigint NOT NULL,
    nombres character varying(100) NOT NULL,
    numero_identificacion character varying(50) NOT NULL,
    pais character varying(100) NOT NULL,
    tipo_identificacion character varying(50) NOT NULL
);


ALTER TABLE public.clientes_lealtad OWNER TO postgres;

--
-- Name: clientes_lealtad_id_cliente_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.clientes_lealtad ALTER COLUMN id_cliente ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.clientes_lealtad_id_cliente_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: departamentos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departamentos (
    id_departamento integer NOT NULL,
    nombre_departamento character varying(100) NOT NULL,
    id_pais integer NOT NULL
);


ALTER TABLE public.departamentos OWNER TO postgres;

--
-- Name: departamentos_id_departamento_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.departamentos_id_departamento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.departamentos_id_departamento_seq OWNER TO postgres;

--
-- Name: departamentos_id_departamento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.departamentos_id_departamento_seq OWNED BY public.departamentos.id_departamento;


--
-- Name: marcas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.marcas (
    id_marca integer NOT NULL,
    nombre_marca character varying(50) NOT NULL
);


ALTER TABLE public.marcas OWNER TO postgres;

--
-- Name: marcas_id_marca_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.marcas_id_marca_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.marcas_id_marca_seq OWNER TO postgres;

--
-- Name: marcas_id_marca_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.marcas_id_marca_seq OWNED BY public.marcas.id_marca;


--
-- Name: paises; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paises (
    id_pais integer NOT NULL,
    nombre_pais character varying(100) NOT NULL
);


ALTER TABLE public.paises OWNER TO postgres;

--
-- Name: paises_id_pais_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.paises_id_pais_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.paises_id_pais_seq OWNER TO postgres;

--
-- Name: paises_id_pais_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.paises_id_pais_seq OWNED BY public.paises.id_pais;


--
-- Name: tipos_identificacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipos_identificacion (
    id_tipo_identificacion integer NOT NULL,
    nombre_tipo character varying(50) NOT NULL
);


ALTER TABLE public.tipos_identificacion OWNER TO postgres;

--
-- Name: tipos_identificacion_id_tipo_identificacion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipos_identificacion_id_tipo_identificacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipos_identificacion_id_tipo_identificacion_seq OWNER TO postgres;

--
-- Name: tipos_identificacion_id_tipo_identificacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipos_identificacion_id_tipo_identificacion_seq OWNED BY public.tipos_identificacion.id_tipo_identificacion;


--
-- Name: tokens_recuperacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tokens_recuperacion (
    id bigint NOT NULL,
    correo_usuario character varying(255) NOT NULL,
    fecha_expiracion timestamp(6) without time zone NOT NULL,
    token_acceso character varying(255) NOT NULL
);


ALTER TABLE public.tokens_recuperacion OWNER TO postgres;

--
-- Name: tokens_recuperacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tokens_recuperacion ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tokens_recuperacion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id_usuario bigint NOT NULL,
    correo_electronico character varying(100) NOT NULL,
    contrasena character varying(255) NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_usuario_seq OWNER TO postgres;

--
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_usuario_seq OWNED BY public.usuarios.id_usuario;


--
-- Name: beneficios_marca id_beneficio; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beneficios_marca ALTER COLUMN id_beneficio SET DEFAULT nextval('public.beneficios_marca_id_beneficio_seq'::regclass);


--
-- Name: ciudades id_ciudad; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ciudades ALTER COLUMN id_ciudad SET DEFAULT nextval('public.ciudades_id_ciudad_seq'::regclass);


--
-- Name: departamentos id_departamento; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departamentos ALTER COLUMN id_departamento SET DEFAULT nextval('public.departamentos_id_departamento_seq'::regclass);


--
-- Name: marcas id_marca; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marcas ALTER COLUMN id_marca SET DEFAULT nextval('public.marcas_id_marca_seq'::regclass);


--
-- Name: paises id_pais; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paises ALTER COLUMN id_pais SET DEFAULT nextval('public.paises_id_pais_seq'::regclass);


--
-- Name: tipos_identificacion id_tipo_identificacion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipos_identificacion ALTER COLUMN id_tipo_identificacion SET DEFAULT nextval('public.tipos_identificacion_id_tipo_identificacion_seq'::regclass);


--
-- Name: usuarios id_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuarios_id_usuario_seq'::regclass);


--
-- Data for Name: beneficios_marca; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.beneficios_marca (id_beneficio, id_marca, titulo_beneficio, descripcion_beneficio) FROM stdin;
1	1	Bono de Bienvenida	20% de descuento en tu primera compra como miembro del programa de lealtad.
2	1	Cashback Exclusivo	Acumula el 5% de tus compras en puntos redimibles en cualquier tienda Americanino.
3	2	Acceso Anticipado VIP	Entrada preferencial y anticipada a colecciones de temporada y rebajas especiales.
4	2	Obsequio de Cumpleaños	Bono de .000 COP redimible durante el mes de tu cumpleaños.
5	3	Envío Gratuito	Envíos sin costo en todas tus compras realizadas a través de canales digitales.
6	3	Garantía Extendida	Garantía preferencial en chaquetas de cuero y prendas de alta durabilidad.
7	4	Descuento Aniversario	30% de descuento en todo el catálogo durante el mes de aniversario de la marca.
8	4	Taller de Estilo	Invitación exclusiva a asesorías de imagen personalizadas y eventos privados.
9	5	Preventa Flash	Descuentos exclusivos de hasta el 40% en colecciones seleccionadas antes del público general.
10	5	Acumulación Doble	Doble acumulación de puntos en compras realizadas los fines de semana.
11	6	Puntos Redimibles	1 punto por cada .000 COP gastados, utilizables como parte de pago en tiendas físicas.
12	6	Mantenimiento de Prendas	Servicio de ajuste y dobladillos sin costo en jeans y pantalones.
\.


--
-- Data for Name: ciudades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ciudades (id_ciudad, nombre_ciudad, id_departamento) FROM stdin;
1	Leticia	1
2	Puerto Nariño	1
3	Medellín	2
4	Bello	2
5	Itagüí	2
6	Envigado	2
7	Sabaneta	2
8	Rionegro	2
9	Apartadó	2
10	Turbo	2
11	Caucasia	2
12	Arauca	3
13	Tame	3
14	Saravena	3
15	Barranquilla	4
16	Soledad	4
17	Malambo	4
18	Puerto Colombia	4
19	Sabanalarga	4
20	Bogotá	5
21	Cartagena	6
22	Magangué	6
23	Turbaco	6
24	El Carmen de Bolívar	6
25	Tunja	7
26	Duitama	7
27	Sogamoso	7
28	Chiquinquirá	7
29	Paipa	7
30	Manizales	8
31	La Dorada	8
32	Villamaría	8
33	Chinchiná	8
34	Florencia	9
35	San Vicente del Caguán	9
36	Yopal	10
37	Aguazul	10
38	Villanueva	10
39	Popayán	11
40	Santander de Quilichao	11
41	Puerto Tejada	11
42	Valledupar	12
43	Aguachica	12
44	Agustín Codazzi	12
45	Quibdó	13
46	Istmina	13
47	Montería	14
48	Cereté	14
49	Lorica	14
50	Montelíbano	14
51	Sahagún	14
52	Chía	15
53	Soacha	15
54	Zipaquirá	15
55	Facatativá	15
56	Fusagasugá	15
57	Girardot	15
58	Mosquera	15
59	Madrid	15
60	Funza	15
61	Cajicá	15
62	Inírida	16
63	San José del Guaviare	17
64	Neiva	18
65	Pitalito	18
66	Garzón	18
67	La Plata	18
68	Riohacha	19
69	Maicao	19
70	Uribia	19
71	Fonseca	19
72	San Juan del Cesar	19
73	Santa Marta	20
74	Ciénaga	20
75	Fundación	20
76	El Banco	20
77	Villavicencio	21
78	Acacías	21
79	Granada	21
80	Puerto López	21
81	Pasto	22
82	Ipiales	22
83	Tumaco	22
84	Túquerres	22
85	Cúcuta	23
86	Ocaña	23
87	Pamplona	23
88	Villa del Rosario	23
89	Los Patios	23
90	Mocoa	24
91	Puerto Asís	24
92	Orito	24
93	Armenia	25
94	Calarcá	25
95	La Tebaida	25
96	Montenegro	25
97	Quimbaya	25
98	Pereira	26
99	Dosquebradas	26
100	Santa Rosa de Cabal	26
101	San Andrés	27
102	Providencia	27
103	Bucaramanga	28
104	Floridablanca	28
105	Girón	28
106	Piedecuesta	28
107	Barrancabermeja	28
108	San Gil	28
109	Socorro	28
110	Sincelejo	29
111	Corozal	29
112	San Marcos	29
113	Ibagué	30
114	Espinal	30
115	Melgar	30
116	Mariquita	30
117	Chaparral	30
118	Cali	31
119	Palmira	31
120	Buenaventura	31
121	Tuluá	31
122	Buga	31
123	Cartago	31
124	Jamundí	31
125	Yumbo	31
126	Mitú	32
127	Puerto Carreño	33
128	Lima	34
129	Miraflores	34
130	San Isidro	34
131	Surco	34
132	Arequipa	35
133	Cayma	35
134	Yanahuara	35
135	Cusco	36
136	Wanchaq	36
137	Trujillo	37
138	Piura	38
139	Sullana	38
140	Quito	39
141	Sangolquí	39
142	Guayaquil	40
143	Samborondón	40
144	Durán	40
145	Cuenca	41
146	Manta	42
147	Portoviejo	42
148	Santo Domingo	43
149	Ambato	44
150	Loja	45
151	Ciudad de Guatemala	46
152	Mixco	46
153	Villa Nueva	46
154	Chiquimula	47
155	Chimaltenango	48
156	Quetzaltenango	49
157	Antigua Guatemala	50
158	Houston	51
159	Cypress	51
160	Dallas	51
161	Austin	51
162	San Antonio	51
163	Miami	52
164	Orlando	52
165	Tampa	52
166	Fort Lauderdale	52
167	Los Angeles	53
168	San Francisco	53
169	San Diego	53
170	New York	54
171	Brooklyn	54
172	Queens	54
\.


--
-- Data for Name: clientes_lealtad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientes_lealtad (id_cliente, apellidos, ciudad, correo_electronico, departamento, direccion, fecha_nacimiento, fecha_registro, id_marca, nombres, numero_identificacion, pais, tipo_identificacion) FROM stdin;
2	Mendez Hawasly	Chía	hawas@pepito.com	Cundinamarca	asd 0200	2004-05-18	2026-09-06 02:43:18.652601	1	Johan David	1234567891	Colombia	Cédula de Ciudadanía
3	Mendez Hawasly	Cypress	SFASD@GMAIL.COM	Texas	Calle 38 dsa	2000-08-17	2026-09-06 02:50:30.403054	5	Johan David	108520552	Estados Unidos	NIT
4	hawasly	Barranquilla	FFDA@GMAIL.COM	Atlántico	12ads ss	2000-05-14	2026-09-06 03:02:15.955931	3	Johan David Mendez	15456456	Colombia	Pasaporte
6	mendez	Medellín	test@gmail.com	Antioquia	calle 3ed	2004-08-18	2026-09-06 14:18:00.408854	1	johan	1003542185	Colombia	Cédula de Ciudadanía
1	Mendez	Cuenca	hawaslypc@gmail.com	Azuay	calle 21331	2000-12-12	2026-09-06 02:40:16.060595	2	Johan David	1068417418	Ecuador	Cédula de Extranjería
8	ASDA	Lima	comodoro@gmail.com	Lima	CALLE 	2000-05-17	2026-09-06 17:52:22.565861	2	DA	1090538528	Perú	Cédula de Ciudadanía
5	gco	Armenia	test@gco.com	Quindío	adsf	2005-12-10	2026-09-06 05:24:46.56302	1	test	1017541200	Colombia	Cédula de Ciudadanía
9	manuel	Pereira	jeidermanuelhawasly@gmail.com	Risaralda	ffas	2001-12-14	2026-09-06 19:39:33.197225	5	jeider	10684174114	Colombia	Cédula de Extranjería
10	ape1	Arequipa	corre@correo.com	Arequipa	direccion	2000-12-12	2026-09-06 21:04:26.505977	1	nombre 1	1440782	Perú	Cédula de Extranjería
7	Cobos Jaimes	Armenia	estefanicobos18@gmail.com	Quindío	Calle 49B #93-115	1999-09-18	2026-09-06 16:23:58.459795	4	Estefania	1090538520	Colombia	Cédula de Ciudadanía
12	123ad	Arequipa	jmhawaslypc@gmial.com	Arequipa	asdasda	1222-02-12	2026-09-07 01:32:05.418312	2	2112as	da121	Perú	Cédula de Ciudadanía
11	mendez hawasly	Cartagena	jmhawaslypc@gmail.com	Bolívar	calle 80 # 28-10	2000-02-01	2026-09-06 21:06:55.667261	2	johan david	10684174181	Colombia	Cédula de Ciudadanía
13	mende	Medellín	corrre@correo.com	Antioquia	asd	0200-12-12	2026-09-07 22:39:49.848728	1	asdas	10521223	Colombia	Cédula de Ciudadanía
\.


--
-- Data for Name: departamentos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departamentos (id_departamento, nombre_departamento, id_pais) FROM stdin;
1	Amazonas	1
2	Antioquia	1
3	Arauca	1
4	Atlántico	1
5	Bogotá D.C.	1
6	Bolívar	1
7	Boyacá	1
8	Caldas	1
9	Caquetá	1
10	Casanare	1
11	Cauca	1
12	Cesar	1
13	Chocó	1
14	Córdoba	1
15	Cundinamarca	1
16	Guainía	1
17	Guaviare	1
18	Huila	1
19	La Guajira	1
20	Magdalena	1
21	Meta	1
22	Nariño	1
23	Norte de Santander	1
24	Putumayo	1
25	Quindío	1
26	Risaralda	1
27	San Andrés y Providencia	1
28	Santander	1
29	Sucre	1
30	Tolima	1
31	Valle del Cauca	1
32	Vaupés	1
33	Vichada	1
34	Lima	2
35	Arequipa	2
36	Cusco	2
37	La Libertad	2
38	Piura	2
39	Pichincha	3
40	Guayas	3
41	Azuay	3
42	Manabí	3
43	Santo Domingo de los Tsáchilas	3
44	Tungurahua	3
45	Loja	3
46	Guatemala	4
47	Chiquimula	4
48	Chimaltenango	4
49	Quetzaltenango	4
50	Sacatepéquez	4
51	Texas	5
52	Florida	5
53	California	5
54	New York	5
\.


--
-- Data for Name: marcas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.marcas (id_marca, nombre_marca) FROM stdin;
1	Americanino
2	American Eagle
3	Chevignon
4	Esprit
5	Naf Naf
6	Rifle
\.


--
-- Data for Name: paises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.paises (id_pais, nombre_pais) FROM stdin;
1	Colombia
2	Perú
3	Ecuador
4	Guatemala
5	Estados Unidos
\.


--
-- Data for Name: tipos_identificacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipos_identificacion (id_tipo_identificacion, nombre_tipo) FROM stdin;
1	Cédula de Ciudadanía
2	Cédula de Extranjería
3	NIT
4	Pasaporte
\.


--
-- Data for Name: tokens_recuperacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tokens_recuperacion (id, correo_usuario, fecha_expiracion, token_acceso) FROM stdin;
5	estefanicobos18@gmail.com	2026-09-06 16:39:35.508674	2a9eeb86-e208-468d-824f-9a212b0407f2
8	hawaslypc@gmail.com	2026-09-06 19:29:59.553182	c6859fe8-5018-43b4-81ab-04735a88b315
11	corre@correo.com	2026-09-06 21:20:10.42187	d30c639e-6915-4130-b496-c4ebe021aa39
18	jmhawaslypc@gmial.com	2026-09-07 01:54:13.858107	85fde05a-8487-4818-be7d-955875a70399
21	alvarezmau979@gmai.com	2026-09-07 22:55:34.832993	f3b0640c-bf4a-469f-99b2-85e8c856a675
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id_usuario, correo_electronico, contrasena, fecha_creacion) FROM stdin;
9	SFASD@GMAIL.COM	$2a$10$u72GPYXZjY8tWyZukNeq5eAtexZE3kxekvU9ORoOP3qdmStXlzGPa	2026-09-06 04:43:54.764387
10	test@gco.com	$2a$10$/xVSqDmsI/ePhR0DCDg2bOR7Blb4vN3oG6o/U8rg3O/nEKaaUG3uq	2026-09-06 05:07:41.490182
11	test@gmail.com	$2a$10$6aXbXAKW/KK2/CkqPGZQ4efVq4u2HbzponaIXDf.r5jjVaVraa5n2	2026-09-06 14:17:13.663996
12	corre@test.com	$2a$10$vJsBLnsddGmSYTURhQuiyOXwhqJ2sS58fB7RyBltzJb22mspmDW/y	2026-09-06 14:24:37.541318
13	estefanicobos18@gmail.com	$2a$10$4wNjWA1ngRo3kJIv61.JC.2QAZfsrHzgUONZLIzPmw3/1tbtDwXOG	2026-09-06 16:12:26.881138
14	comodoro@gmail.com	$2a$10$J/3quA/6IS3GEjw4I9ElyeMzBzaNVh4.reFqRnu89FceYTcDTvFmq	2026-09-06 16:48:45.456536
8	hawaslypc@gmail.com	$2a$10$QMb9VFBK8igra.t8U4HL/eiXt1iWUdTLZtZyM6HJD9ZjJm5hoW2RO	2026-09-06 04:15:14.495898
15	stefa@gmail.com	$2a$10$VXrJYQPvFtTwpCA1fRuTZOvpuqXdR3Z/VW775CTGKtqvR0lvx7vxC	2026-09-06 19:15:37.528819
16	jeidermanuelhawasly@gmail.com	$2a$10$cARntlzWqNZ3JBvIqfrSGu3kqgt7ufFnb4EuvEVv84ZIq3Q9cCMAy	2026-09-06 19:37:00.058112
17	corre@correo.com	$2a$10$5lnVh3sq23BbXbQvAM/NpuDXgJ8CAap/acr.dVrbLJ5SGSvRJD3x2	2026-09-06 21:03:32.705153
19	jmhawaslypc@gmial.com	$2a$10$QIi8xwVA2xWFW.5ICUrBKelmqRrPewNa7pS2i5x/StNH7Fd2c4sHG	2026-09-07 01:31:23.951249
18	jmhawaslypc@gmail.com	$2a$10$mC/rWoEVCYO/Exj0fVM1suv5l6KZxagxdxKN9OedtPd2nnWkjTOc2	2026-09-06 21:06:23.059021
20	corrre@correo.com	$2a$10$kyf5wsgRxHsdWWuRv7pjeefxdHvvMYHox56y1SH0602etmAS61h.C	2026-09-07 03:10:37.566918
\.


--
-- Name: beneficios_marca_id_beneficio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.beneficios_marca_id_beneficio_seq', 12, true);


--
-- Name: ciudades_id_ciudad_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ciudades_id_ciudad_seq', 172, true);


--
-- Name: clientes_lealtad_id_cliente_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_lealtad_id_cliente_seq', 13, true);


--
-- Name: departamentos_id_departamento_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departamentos_id_departamento_seq', 54, true);


--
-- Name: marcas_id_marca_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.marcas_id_marca_seq', 6, true);


--
-- Name: paises_id_pais_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.paises_id_pais_seq', 5, true);


--
-- Name: tipos_identificacion_id_tipo_identificacion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipos_identificacion_id_tipo_identificacion_seq', 4, true);


--
-- Name: tokens_recuperacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tokens_recuperacion_id_seq', 21, true);


--
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_usuario_seq', 20, true);


--
-- Name: beneficios_marca beneficios_marca_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beneficios_marca
    ADD CONSTRAINT beneficios_marca_pkey PRIMARY KEY (id_beneficio);


--
-- Name: ciudades ciudades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ciudades
    ADD CONSTRAINT ciudades_pkey PRIMARY KEY (id_ciudad);


--
-- Name: clientes_lealtad clientes_lealtad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes_lealtad
    ADD CONSTRAINT clientes_lealtad_pkey PRIMARY KEY (id_cliente);


--
-- Name: departamentos departamentos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departamentos
    ADD CONSTRAINT departamentos_pkey PRIMARY KEY (id_departamento);


--
-- Name: marcas marcas_nombre_marca_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marcas
    ADD CONSTRAINT marcas_nombre_marca_key UNIQUE (nombre_marca);


--
-- Name: marcas marcas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marcas
    ADD CONSTRAINT marcas_pkey PRIMARY KEY (id_marca);


--
-- Name: paises paises_nombre_pais_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paises
    ADD CONSTRAINT paises_nombre_pais_key UNIQUE (nombre_pais);


--
-- Name: paises paises_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paises
    ADD CONSTRAINT paises_pkey PRIMARY KEY (id_pais);


--
-- Name: tipos_identificacion tipos_identificacion_nombre_tipo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipos_identificacion
    ADD CONSTRAINT tipos_identificacion_nombre_tipo_key UNIQUE (nombre_tipo);


--
-- Name: tipos_identificacion tipos_identificacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipos_identificacion
    ADD CONSTRAINT tipos_identificacion_pkey PRIMARY KEY (id_tipo_identificacion);


--
-- Name: tokens_recuperacion tokens_recuperacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens_recuperacion
    ADD CONSTRAINT tokens_recuperacion_pkey PRIMARY KEY (id);


--
-- Name: tokens_recuperacion ukhcqjf5nk080wnan5c5wyfildd; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens_recuperacion
    ADD CONSTRAINT ukhcqjf5nk080wnan5c5wyfildd UNIQUE (token_acceso);


--
-- Name: clientes_lealtad ukho4knjf2w7jawtrh8li7q9b43; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes_lealtad
    ADD CONSTRAINT ukho4knjf2w7jawtrh8li7q9b43 UNIQUE (correo_electronico);


--
-- Name: clientes_lealtad uklaxxruk3rbc6yeo7fkph1s7k7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes_lealtad
    ADD CONSTRAINT uklaxxruk3rbc6yeo7fkph1s7k7 UNIQUE (numero_identificacion);


--
-- Name: usuarios usuarios_correo_electronico_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_electronico_key UNIQUE (correo_electronico);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario);


--
-- Name: ciudades fk_departamento; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ciudades
    ADD CONSTRAINT fk_departamento FOREIGN KEY (id_departamento) REFERENCES public.departamentos(id_departamento);


--
-- Name: beneficios_marca fk_marca_beneficio; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beneficios_marca
    ADD CONSTRAINT fk_marca_beneficio FOREIGN KEY (id_marca) REFERENCES public.marcas(id_marca);


--
-- Name: departamentos fk_pais; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departamentos
    ADD CONSTRAINT fk_pais FOREIGN KEY (id_pais) REFERENCES public.paises(id_pais);


--
-- PostgreSQL database dump complete
--

\unrestrict 8SMHlTUf9NTGi19rZ1MR43ni4lmuFdbfv859KXNyU2qYfTcXDn9kjmirttC8zuW

