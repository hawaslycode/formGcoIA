-- ===================================================================
-- SCRIPT DE INICIALIZACIÓN DE CATÁLOGOS - PROGRAMA DE LEALTAD GCO
-- ===================================================================

-- 1. Catálogo de Tipos de Identificación
CREATE TABLE IF NOT EXISTS tipos_identificacion (
    id_tipo_identificacion SERIAL PRIMARY KEY,
    nombre_tipo VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO tipos_identificacion (nombre_tipo) VALUES 
('Cédula de Ciudadanía'), 
('Cédula de Extranjería'), 
('Pasaporte'), 
('NIT')
ON CONFLICT (nombre_tipo) DO NOTHING;

-- 2. Catálogo de Marcas (GCO)
CREATE TABLE IF NOT EXISTS marcas (
    id_marca SERIAL PRIMARY KEY,
    nombre_marca VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO marcas (nombre_marca) VALUES 
('Americanino'), 
('American Eagle'), 
('Chevignon'), 
('Esprit'), 
('Naf Naf'), 
('Rifle')
ON CONFLICT (nombre_marca) DO NOTHING;

-- 3. Catálogo Geográfico: Países
CREATE TABLE IF NOT EXISTS paises (
    id_pais SERIAL PRIMARY KEY,
    nombre_pais VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO paises (nombre_pais) VALUES 
('Colombia'), 
('Ecuador'), 
('Perú')
ON CONFLICT (nombre_pais) DO NOTHING;

-- 4. Catálogo Geográfico: Departamentos / Estados
CREATE TABLE IF NOT EXISTS departamentos (
    id_departamento SERIAL PRIMARY KEY,
    nombre_departamento VARCHAR(100) NOT NULL,
    id_pais INTEGER NOT NULL REFERENCES paises(id_pais),
    UNIQUE(nombre_departamento, id_pais)
);

INSERT INTO departamentos (nombre_departamento, id_pais) VALUES 
('Antioquia', 1), 
('Cundinamarca', 1), 
('Valle del Cauca', 1),
('Pichincha', 2),
('Lima', 3)
ON CONFLICT (nombre_departamento, id_pais) DO NOTHING;

-- 5. Catálogo Geográfico: Ciudades
CREATE TABLE IF NOT EXISTS ciudades (
    id_ciudad SERIAL PRIMARY KEY,
    nombre_ciudad VARCHAR(100) NOT NULL,
    id_departamento INTEGER NOT NULL REFERENCES departamentos(id_departamento),
    UNIQUE(nombre_ciudad, id_departamento)
);

INSERT INTO ciudades (nombre_ciudad, id_departamento) VALUES 
('Medellín', 1), 
('Bello', 1), 
('Envigado', 1), 
('Bogotá', 2), 
('Chía', 2), 
('Cali', 3), 
('Quito', 4), 
('Miraflores', 5)
ON CONFLICT (nombre_ciudad, id_departamento) DO NOTHING;

-- 6. Beneficios por Marca
CREATE TABLE IF NOT EXISTS beneficios_marca (
    id_beneficio SERIAL PRIMARY KEY,
    id_marca INT NOT NULL,
    titulo_beneficio VARCHAR(150) NOT NULL,
    descripcion_beneficio TEXT NOT NULL,
    CONSTRAINT fk_marca_beneficio FOREIGN KEY (id_marca) REFERENCES marcas(id_marca)
);