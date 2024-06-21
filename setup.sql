-- Crea la tabla para almacenar los programas de la Máquina de Turing
CREATE TABLE IF NOT EXISTS programa (
    estado_origen VARCHAR(255),
    caracter_origen CHAR(1),
    estado_nuevo VARCHAR(255),
    caracter_nuevo CHAR(1),
    desplazamiento CHAR(1)
);

-- Crea la tabla para registrar cada movimiento de la Máquina de Turing
CREATE TABLE IF NOT EXISTS traza_ejecucion (
    estado_actual VARCHAR(255),
    cinta_actual TEXT,
    posicion_cabezal INT,
    estado_siguiente VARCHAR(255),
    cinta_siguiente TEXT,
    movimiento CHAR(1),
    es_final BOOLEAN DEFAULT false
);

-- Crea la tabla para almacenar los caracteres válidos del alfabeto de la Máquina de Turing
CREATE TABLE IF NOT EXISTS alfabeto (
    caracter CHAR(1) PRIMARY KEY
);
