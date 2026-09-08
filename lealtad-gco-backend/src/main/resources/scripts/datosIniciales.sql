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

INSERT INTO tipos_identificacion (id_tipo_identificacion, nombre_tipo) VALUES 
(1, 'Cédula de Ciudadanía'), 
(2, 'Cédula de Extranjería'), 
(3, 'NIT'), 
(4, 'Pasaporte')
ON CONFLICT (id_tipo_identificacion) DO NOTHING;

-- 2. Catálogo de Marcas (GCO)
CREATE TABLE IF NOT EXISTS marcas (
    id_marca SERIAL PRIMARY KEY,
    nombre_marca VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO marcas (id_marca, nombre_marca) VALUES 
(1, 'Americanino'), 
(2, 'American Eagle'), 
(3, 'Chevignon'), 
(4, 'Esprit'), 
(5, 'Naf Naf'), 
(6, 'Rifle')
ON CONFLICT (id_marca) DO NOTHING;

-- 3. Catálogo Geográfico: Países
CREATE TABLE IF NOT EXISTS paises (
    id_pais SERIAL PRIMARY KEY,
    nombre_pais VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO paises (id_pais, nombre_pais) VALUES 
(1, 'Colombia'), 
(2, 'Perú'), 
(3, 'Ecuador'), 
(4, 'Guatemala'), 
(5, 'Estados Unidos')
ON CONFLICT (id_pais) DO NOTHING;

-- 4. Catálogo Geográfico: Departamentos / Estados
CREATE TABLE IF NOT EXISTS departamentos (
    id_departamento SERIAL PRIMARY KEY,
    nombre_departamento VARCHAR(100) NOT NULL,
    id_pais INTEGER NOT NULL REFERENCES paises(id_pais),
    UNIQUE(nombre_departamento, id_pais)
);

INSERT INTO departamentos (id_departamento, nombre_departamento, id_pais) VALUES 
(1, 'Antioquia', 1),
(2, 'Atlántico', 1),
(3, 'Bolívar', 1),
(4, 'Boyacá', 1),
(5, 'Caldas', 1),
(6, 'Caquetá', 1),
(7, 'Casanare', 1),
(8, 'Cauca', 1),
(9, 'Cesar', 1),
(10, 'Chocó', 1),
(11, 'Córdoba', 1),
(12, 'Cundinamarca', 1),
(13, 'Huila', 1),
(14, 'Magdalena', 1),
(15, 'Meta', 1),
(16, 'Nariño', 1),
(17, 'Norte de Santander', 1),
(18, 'Quindío', 1),
(19, 'Risaralda', 1),
(20, 'Santander', 1),
(21, 'Sucre', 1),
(22, 'Tolima', 1),
(23, 'Valle del Cauca', 1),
(24, 'Bogotá D.C.', 1),
(25, 'Lima', 2),
(26, 'Arequipa', 2),
(27, 'Pichincha', 3),
(28, 'Guayas', 3),
(29, 'Azuay', 3),
(30, 'Manabí', 3),
(31, 'Santo Domingo de los Tsáchilas', 3),
(32, 'Tungurahua', 3),
(33, 'Guatemala', 4),
(34, 'Chiquimula', 4),
(35, 'Chimaltenango', 4),
(36, 'Quetzaltenango', 4),
(37, 'Texas', 5)
ON CONFLICT (id_departamento) DO NOTHING;

-- 5. Catálogo Geográfico: Ciudades
CREATE TABLE IF NOT EXISTS ciudades (
    id_ciudad SERIAL PRIMARY KEY,
    nombre_ciudad VARCHAR(100) NOT NULL,
    id_departamento INTEGER NOT NULL REFERENCES departamentos(id_departamento),
    UNIQUE(nombre_ciudad, id_departamento)
);

INSERT INTO ciudades (id_ciudad, nombre_ciudad, id_departamento) VALUES 
(1, 'Medellín', 1),
(2, 'Envigado', 1),
(3, 'Sabaneta', 1),
(4, 'Rionegro', 1),
(5, 'Bello', 1),
(6, 'Apartadó', 1),
(7, 'Barranquilla', 2),
(8, 'Cartagena', 3),
(9, 'Tunja', 4),
(10, 'Duitama', 4),
(11, 'Manizales', 5),
(12, 'Florencia', 6),
(13, 'Yopal', 7),
(14, 'Popayán', 8),
(15, 'Valledupar', 9),
(16, 'Quibdó', 10),
(17, 'Montería', 11),
(18, 'Chía', 12),
(19, 'Neiva', 13),
(20, 'Santa Marta', 14),
(21, 'Villavicencio', 15),
(22, 'Acacías', 15),
(23, 'Pasto', 16),
(24, 'Ipiales', 16),
(25, 'Cúcuta', 17),
(26, 'Armenia', 18),
(27, 'Pereira', 19),
(28, 'Bucaramanga', 20),
(29, 'Piedecuesta', 20),
(30, 'Barrancabermeja', 20),
(31, 'San Gil', 20),
(32, 'Sincelejo', 21),
(33, 'Ibagué', 22),
(34, 'Cali', 23),
(35, 'Palmira', 23),
(36, 'Cartago', 23),
(37, 'Bogotá', 24),
(38, 'Lima', 25),
(39, 'Arequipa', 26),
(40, 'Quito', 27),
(41, 'Guayaquil', 28),
(42, 'Cuenca', 29),
(43, 'Manta', 30),
(44, 'Santo Domingo', 31),
(45, 'Ambato', 32),
(46, 'Ciudad de Guatemala', 33),
(47, 'Chiquimula', 34),
(48, 'Chimaltenango', 35),
(49, 'Quetzaltenango', 36),
(50, 'Houston', 37),
(51, 'Cypress', 37)
ON CONFLICT (id_ciudad) DO NOTHING;

-- 6. Beneficios por Marca
CREATE TABLE IF NOT EXISTS beneficios_marca (
    id_beneficio SERIAL PRIMARY KEY,
    id_marca INT NOT NULL,
    titulo_beneficio VARCHAR(150) NOT NULL,
    descripcion_beneficio TEXT NOT NULL,
    CONSTRAINT fk_marca_beneficio FOREIGN KEY (id_marca) REFERENCES marcas(id_marca)
);

INSERT INTO beneficios_marca (id_beneficio, id_marca, titulo_beneficio, descripcion_beneficio) VALUES
(1, 1, 'Bono de Bienvenida', '20% de descuento en tu primera compra como miembro del programa de lealtad.'),
(2, 1, 'Cashback Exclusivo', 'Acumula el 5% de tus compras en puntos redimibles en cualquier tienda Americanino.'),
(3, 2, 'Acceso Anticipado VIP', 'Entrada preferencial y anticipada a colecciones de temporada y rebajas especiales.'),
(4, 2, 'Obsequio de Cumpleaños', 'Bono de $50.000 COP redimible durante el mes de tu cumpleaños.'),
(5, 3, 'Envío Gratuito', 'Envíos sin costo en todas tus compras realizadas a través de canales digitales.'),
(6, 3, 'Garantía Extendida', 'Garantía preferencial en chaquetas de cuero y prendas de alta durabilidad.'),
(7, 4, 'Descuento Aniversario', '30% de descuento en todo el catálogo durante el mes de aniversario de la marca.'),
(8, 4, 'Taller de Estilo', 'Invitación exclusiva a asesorías de imagen personalizadas y eventos privados.'),
(9, 5, 'Preventa Flash', 'Descuentos exclusivos de hasta el 40% en colecciones seleccionadas antes del público general.'),
(10, 5, 'Acumulación Doble', 'Doble acumulación de puntos en compras realizadas los fines de semana.'),
(11, 6, 'Puntos Redimibles', '1 punto por cada $1.000 COP gastados, utilizables como parte de pago en tiendas físicas.'),
(12, 6, 'Mantenimiento de Prendas', 'Servicio de ajuste y dobladillos sin costo en jeans y pantalones.')
ON CONFLICT (id_beneficio) DO NOTHING;

-- 7. Ajustar secuencias de ID para evitar conflictos en futuras inserciones
SELECT setval('tipos_identificacion_id_tipo_identificacion_seq', COALESCE((SELECT MAX(id_tipo_identificacion) FROM tipos_identificacion), 1));
SELECT setval('marcas_id_marca_seq', COALESCE((SELECT MAX(id_marca) FROM marcas), 1));
SELECT setval('paises_id_pais_seq', COALESCE((SELECT MAX(id_pais) FROM paises), 1));
SELECT setval('departamentos_id_departamento_seq', COALESCE((SELECT MAX(id_departamento) FROM departamentos), 1));
SELECT setval('ciudades_id_ciudad_seq', COALESCE((SELECT MAX(id_ciudad) FROM ciudades), 1));
SELECT setval('beneficios_marca_id_beneficio_seq', COALESCE((SELECT MAX(id_beneficio) FROM beneficios_marca), 1));