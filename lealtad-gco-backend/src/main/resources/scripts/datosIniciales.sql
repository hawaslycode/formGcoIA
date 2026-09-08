-- ===================================================================
-- SCRIPT DE INICIALIZACIÓN DE CATÁLOGOS - PROGRAMA DE LEALTAD GCO
-- Propósito: Generar la estructura DDL de los catálogos e inyectar
-- todos los datos semilla (DML) requeridos por los selectores del frontend.
-- ===================================================================

-- 1. Catálogo de Tipos de Identificación
CREATE TABLE IF NOT EXISTS tipos_identificacion (
    id_tipo_identificacion SERIAL PRIMARY KEY,
    nombre_tipo VARCHAR(50) NOT NULL UNIQUE
);

-- 2. Catálogo de Marcas (GCO)
CREATE TABLE IF NOT EXISTS marcas (
    id_marca SERIAL PRIMARY KEY,
    nombre_marca VARCHAR(100) NOT NULL UNIQUE
);

-- 3. Catálogo Geográfico: Países
CREATE TABLE IF NOT EXISTS paises (
    id_pais SERIAL PRIMARY KEY,
    nombre_pais VARCHAR(100) NOT NULL UNIQUE
);

-- 4. Catálogo Geográfico: Departamentos / Estados
CREATE TABLE IF NOT EXISTS departamentos (
    id_departamento SERIAL PRIMARY KEY,
    nombre_departamento VARCHAR(100) NOT NULL,
    id_pais INTEGER NOT NULL REFERENCES paises(id_pais),
    UNIQUE(nombre_departamento, id_pais)
);

-- 5. Catálogo Geográfico: Ciudades
CREATE TABLE IF NOT EXISTS ciudades (
    id_ciudad SERIAL PRIMARY KEY,
    nombre_ciudad VARCHAR(100) NOT NULL,
    id_departamento INTEGER NOT NULL REFERENCES departamentos(id_departamento),
    UNIQUE(nombre_ciudad, id_departamento)
);

-- 6. Beneficios por Marca
CREATE TABLE IF NOT EXISTS beneficios_marca (
    id_beneficio SERIAL PRIMARY KEY,
    id_marca INT NOT NULL,
    titulo_beneficio VARCHAR(150) NOT NULL,
    descripcion_beneficio TEXT NOT NULL,
    CONSTRAINT fk_marca_beneficio FOREIGN KEY (id_marca) REFERENCES marcas(id_marca)
);

-- ===================================================================
-- LIMPIEZA PREVENTIVA Y SINCRONIZACIÓN DE CATÁLOGOS
-- Garantiza que en despliegues (Render / Cloud) no existan colisiones de claves
-- ni datos parciales previos, preservando intactos a usuarios y clientes_lealtad.
-- ===================================================================
DELETE FROM ciudades;
DELETE FROM departamentos;
DELETE FROM paises;
DELETE FROM beneficios_marca;
DELETE FROM marcas;
DELETE FROM tipos_identificacion;

-- ===================================================================
-- INSERCIÓN DE DATOS DE CATÁLOGOS
-- ===================================================================

-- 1. Tipos de Identificación
INSERT INTO tipos_identificacion (id_tipo_identificacion, nombre_tipo) VALUES 
(1, 'Cédula de Ciudadanía'), 
(2, 'Cédula de Extranjería'), 
(3, 'NIT'), 
(4, 'Pasaporte');

-- 2. Marcas (GCO)
INSERT INTO marcas (id_marca, nombre_marca) VALUES 
(1, 'Americanino'), 
(2, 'American Eagle'), 
(3, 'Chevignon'), 
(4, 'Esprit'), 
(5, 'Naf Naf'), 
(6, 'Rifle');

-- 3. Países
INSERT INTO paises (id_pais, nombre_pais) VALUES 
(1, 'Colombia'), 
(2, 'Perú'), 
(3, 'Ecuador'), 
(4, 'Guatemala'), 
(5, 'Estados Unidos');

-- 4. Departamentos / Estados
INSERT INTO departamentos (id_departamento, nombre_departamento, id_pais) VALUES 
-- Colombia (1..33)
(1, 'Amazonas', 1),
(2, 'Antioquia', 1),
(3, 'Arauca', 1),
(4, 'Atlántico', 1),
(5, 'Bogotá D.C.', 1),
(6, 'Bolívar', 1),
(7, 'Boyacá', 1),
(8, 'Caldas', 1),
(9, 'Caquetá', 1),
(10, 'Casanare', 1),
(11, 'Cauca', 1),
(12, 'Cesar', 1),
(13, 'Chocó', 1),
(14, 'Córdoba', 1),
(15, 'Cundinamarca', 1),
(16, 'Guainía', 1),
(17, 'Guaviare', 1),
(18, 'Huila', 1),
(19, 'La Guajira', 1),
(20, 'Magdalena', 1),
(21, 'Meta', 1),
(22, 'Nariño', 1),
(23, 'Norte de Santander', 1),
(24, 'Putumayo', 1),
(25, 'Quindío', 1),
(26, 'Risaralda', 1),
(27, 'San Andrés y Providencia', 1),
(28, 'Santander', 1),
(29, 'Sucre', 1),
(30, 'Tolima', 1),
(31, 'Valle del Cauca', 1),
(32, 'Vaupés', 1),
(33, 'Vichada', 1),
-- Perú (34..38)
(34, 'Lima', 2),
(35, 'Arequipa', 2),
(36, 'Cusco', 2),
(37, 'La Libertad', 2),
(38, 'Piura', 2),
-- Ecuador (39..45)
(39, 'Pichincha', 3),
(40, 'Guayas', 3),
(41, 'Azuay', 3),
(42, 'Manabí', 3),
(43, 'Santo Domingo de los Tsáchilas', 3),
(44, 'Tungurahua', 3),
(45, 'Loja', 3),
-- Guatemala (46..50)
(46, 'Guatemala', 4),
(47, 'Chiquimula', 4),
(48, 'Chimaltenango', 4),
(49, 'Quetzaltenango', 4),
(50, 'Sacatepéquez', 4),
-- Estados Unidos (51..54)
(51, 'Texas', 5),
(52, 'Florida', 5),
(53, 'California', 5),
(54, 'New York', 5);

-- 5. Ciudades
INSERT INTO ciudades (id_ciudad, nombre_ciudad, id_departamento) VALUES 
-- 1 Amazonas
(1, 'Leticia', 1),
(2, 'Puerto Nariño', 1),
-- 2 Antioquia
(3, 'Medellín', 2),
(4, 'Bello', 2),
(5, 'Itagüí', 2),
(6, 'Envigado', 2),
(7, 'Sabaneta', 2),
(8, 'Rionegro', 2),
(9, 'Apartadó', 2),
(10, 'Turbo', 2),
(11, 'Caucasia', 2),
-- 3 Arauca
(12, 'Arauca', 3),
(13, 'Tame', 3),
(14, 'Saravena', 3),
-- 4 Atlántico
(15, 'Barranquilla', 4),
(16, 'Soledad', 4),
(17, 'Malambo', 4),
(18, 'Puerto Colombia', 4),
(19, 'Sabanalarga', 4),
-- 5 Bogotá D.C.
(20, 'Bogotá', 5),
-- 6 Bolívar
(21, 'Cartagena', 6),
(22, 'Magangué', 6),
(23, 'Turbaco', 6),
(24, 'El Carmen de Bolívar', 6),
-- 7 Boyacá
(25, 'Tunja', 7),
(26, 'Duitama', 7),
(27, 'Sogamoso', 7),
(28, 'Chiquinquirá', 7),
(29, 'Paipa', 7),
-- 8 Caldas
(30, 'Manizales', 8),
(31, 'La Dorada', 8),
(32, 'Villamaría', 8),
(33, 'Chinchiná', 8),
-- 9 Caquetá
(34, 'Florencia', 9),
(35, 'San Vicente del Caguán', 9),
-- 10 Casanare
(36, 'Yopal', 10),
(37, 'Aguazul', 10),
(38, 'Villanueva', 10),
-- 11 Cauca
(39, 'Popayán', 11),
(40, 'Santander de Quilichao', 11),
(41, 'Puerto Tejada', 11),
-- 12 Cesar
(42, 'Valledupar', 12),
(43, 'Aguachica', 12),
(44, 'Agustín Codazzi', 12),
-- 13 Chocó
(45, 'Quibdó', 13),
(46, 'Istmina', 13),
-- 14 Córdoba
(47, 'Montería', 14),
(48, 'Cereté', 14),
(49, 'Lorica', 14),
(50, 'Montelíbano', 14),
(51, 'Sahagún', 14),
-- 15 Cundinamarca
(52, 'Chía', 15),
(53, 'Soacha', 15),
(54, 'Zipaquirá', 15),
(55, 'Facatativá', 15),
(56, 'Fusagasugá', 15),
(57, 'Girardot', 15),
(58, 'Mosquera', 15),
(59, 'Madrid', 15),
(60, 'Funza', 15),
(61, 'Cajicá', 15),
-- 16 Guainía
(62, 'Inírida', 16),
-- 17 Guaviare
(63, 'San José del Guaviare', 17),
-- 18 Huila
(64, 'Neiva', 18),
(65, 'Pitalito', 18),
(66, 'Garzón', 18),
(67, 'La Plata', 18),
-- 19 La Guajira
(68, 'Riohacha', 19),
(69, 'Maicao', 19),
(70, 'Uribia', 19),
(71, 'Fonseca', 19),
(72, 'San Juan del Cesar', 19),
-- 20 Magdalena
(73, 'Santa Marta', 20),
(74, 'Ciénaga', 20),
(75, 'Fundación', 20),
(76, 'El Banco', 20),
-- 21 Meta
(77, 'Villavicencio', 21),
(78, 'Acacías', 21),
(79, 'Granada', 21),
(80, 'Puerto López', 21),
-- 22 Nariño
(81, 'Pasto', 22),
(82, 'Ipiales', 22),
(83, 'Tumaco', 22),
(84, 'Túquerres', 22),
-- 23 Norte de Santander
(85, 'Cúcuta', 23),
(86, 'Ocaña', 23),
(87, 'Pamplona', 23),
(88, 'Villa del Rosario', 23),
(89, 'Los Patios', 23),
-- 24 Putumayo
(90, 'Mocoa', 24),
(91, 'Puerto Asís', 24),
(92, 'Orito', 24),
-- 25 Quindío
(93, 'Armenia', 25),
(94, 'Calarcá', 25),
(95, 'La Tebaida', 25),
(96, 'Montenegro', 25),
(97, 'Quimbaya', 25),
-- 26 Risaralda
(98, 'Pereira', 26),
(99, 'Dosquebradas', 26),
(100, 'Santa Rosa de Cabal', 26),
-- 27 San Andrés y Providencia
(101, 'San Andrés', 27),
(102, 'Providencia', 27),
-- 28 Santander
(103, 'Bucaramanga', 28),
(104, 'Floridablanca', 28),
(105, 'Girón', 28),
(106, 'Piedecuesta', 28),
(107, 'Barrancabermeja', 28),
(108, 'San Gil', 28),
(109, 'Socorro', 28),
-- 29 Sucre
(110, 'Sincelejo', 29),
(111, 'Corozal', 29),
(112, 'San Marcos', 29),
-- 30 Tolima
(113, 'Ibagué', 30),
(114, 'Espinal', 30),
(115, 'Melgar', 30),
(116, 'Mariquita', 30),
(117, 'Chaparral', 30),
-- 31 Valle del Cauca
(118, 'Cali', 31),
(119, 'Palmira', 31),
(120, 'Buenaventura', 31),
(121, 'Tuluá', 31),
(122, 'Buga', 31),
(123, 'Cartago', 31),
(124, 'Jamundí', 31),
(125, 'Yumbo', 31),
-- 32 Vaupés
(126, 'Mitú', 32),
-- 33 Vichada
(127, 'Puerto Carreño', 33),
-- 34 Lima
(128, 'Lima', 34),
(129, 'Miraflores', 34),
(130, 'San Isidro', 34),
(131, 'Surco', 34),
-- 35 Arequipa
(132, 'Arequipa', 35),
(133, 'Cayma', 35),
(134, 'Yanahuara', 35),
-- 36 Cusco
(135, 'Cusco', 36),
(136, 'Wanchaq', 36),
-- 37 La Libertad
(137, 'Trujillo', 37),
-- 38 Piura
(138, 'Piura', 38),
(139, 'Sullana', 38),
-- 39 Pichincha
(140, 'Quito', 39),
(141, 'Sangolquí', 39),
-- 40 Guayas
(142, 'Guayaquil', 40),
(143, 'Samborondón', 40),
(144, 'Durán', 40),
-- 41 Azuay
(145, 'Cuenca', 41),
-- 42 Manabí
(146, 'Manta', 42),
(147, 'Portoviejo', 42),
-- 43 Santo Domingo de los Tsáchilas
(148, 'Santo Domingo', 43),
-- 44 Tungurahua
(149, 'Ambato', 44),
-- 45 Loja
(150, 'Loja', 45),
-- 46 Guatemala
(151, 'Ciudad de Guatemala', 46),
(152, 'Mixco', 46),
(153, 'Villa Nueva', 46),
-- 47 Chiquimula
(154, 'Chiquimula', 47),
-- 48 Chimaltenango
(155, 'Chimaltenango', 48),
-- 49 Quetzaltenango
(156, 'Quetzaltenango', 49),
-- 50 Sacatepéquez
(157, 'Antigua Guatemala', 50),
-- 51 Texas
(158, 'Houston', 51),
(159, 'Cypress', 51),
(160, 'Dallas', 51),
(161, 'Austin', 51),
(162, 'San Antonio', 51),
-- 52 Florida
(163, 'Miami', 52),
(164, 'Orlando', 52),
(165, 'Tampa', 52),
(166, 'Fort Lauderdale', 52),
-- 53 California
(167, 'Los Angeles', 53),
(168, 'San Francisco', 53),
(169, 'San Diego', 53),
-- 54 New York
(170, 'New York', 54),
(171, 'Brooklyn', 54),
(172, 'Queens', 54);

-- 6. Beneficios por Marca
INSERT INTO beneficios_marca (id_beneficio, id_marca, titulo_beneficio, descripcion_beneficio) VALUES
(1, 1, 'Bono de Bienvenida', '20% de descuento en tu primera compra como miembro del programa de lealtad.'),
(2, 1, 'Cashback Exclusivo', 'Acumula el 5% de tus compras en puntos redimibles en cualquier tienda Americanino.'),
(3, 2, 'Acceso Anticipado VIP', 'Entrada preferencial y anticipada a colecciones de temporada y rebajas especiales.'),
(4, 2, 'Obsequio de Cumpleaños', 'Bono de .000 COP redimible durante el mes de tu cumpleaños.'),
(5, 3, 'Envío Gratuito', 'Envíos sin costo en todas tus compras realizadas a través de canales digitales.'),
(6, 3, 'Garantía Extendida', 'Garantía preferencial en chaquetas de cuero y prendas de alta durabilidad.'),
(7, 4, 'Descuento Aniversario', '30% de descuento en todo el catálogo durante el mes de aniversario de la marca.'),
(8, 4, 'Taller de Estilo', 'Invitación exclusiva a asesorías de imagen personalizadas y eventos privados.'),
(9, 5, 'Preventa Flash', 'Descuentos exclusivos de hasta el 40% en colecciones seleccionadas antes del público general.'),
(10, 5, 'Acumulación Doble', 'Doble acumulación de puntos en compras realizadas los fines de semana.'),
(11, 6, 'Puntos Redimibles', '1 punto por cada .000 COP gastados, utilizables como parte de pago en tiendas físicas.'),
(12, 6, 'Mantenimiento de Prendas', 'Servicio de ajuste y dobladillos sin costo en jeans y pantalones.');

-- 7. Sincronización de secuencias automáticas de ID
SELECT setval('tipos_identificacion_id_tipo_identificacion_seq', COALESCE((SELECT MAX(id_tipo_identificacion) FROM tipos_identificacion), 1));
SELECT setval('marcas_id_marca_seq', COALESCE((SELECT MAX(id_marca) FROM marcas), 1));
SELECT setval('paises_id_pais_seq', COALESCE((SELECT MAX(id_pais) FROM paises), 1));
SELECT setval('departamentos_id_departamento_seq', COALESCE((SELECT MAX(id_departamento) FROM departamentos), 1));
SELECT setval('ciudades_id_ciudad_seq', COALESCE((SELECT MAX(id_ciudad) FROM ciudades), 1));
SELECT setval('beneficios_marca_id_beneficio_seq', COALESCE((SELECT MAX(id_beneficio) FROM beneficios_marca), 1));
