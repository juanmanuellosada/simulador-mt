-- Inserta el alfabeto en la tabla alfabeto
TRUNCATE alfabeto;
INSERT INTO alfabeto (caracter) VALUES ('1'), ('0'), ('X'), ('B');

-- Define las transiciones necesarias para la Máquina de Turing Palíndromo Checker
-- Define las transiciones necesarias para la Máquina de Turing Palíndromo Checker
-- Reinicia la tabla de transiciones para la Máquina de Turing
TRUNCATE programa CASCADE;

-- Inserta las transiciones actualizadas en la tabla
INSERT INTO programa (estado_origen, caracter_origen, estado_nuevo, caracter_nuevo, desplazamiento) VALUES
-- Estado inicial q0, busca el primer caracter no marcado ('X') para iniciar la comprobación
('q0', '0', 'q1', 'B', 'R'),
('q0', '1', 'q2', 'B', 'R'),
('q0', 'B', 'qf', 'B', 'S'),

('q1', '0', 'q3', '0', 'R'),
('q1', '1', 'q3', '1', 'R'),
('q1', 'B', 'qf', 'B', 'S'),

('q2', '0', 'q4', '0', 'R'),
('q2', '1', 'q4', '1', 'R'),
('q2', 'B', 'qf', 'B', 'S'),

('q3', '0', 'q3', '0', 'R'),
('q3', '1', 'q3', '1', 'R'),
('q3', 'B', 'q5', 'B', 'L'),

('q4', '0', 'q4', '0', 'R'),
('q4', '1', 'q4', '1', 'R'),
('q4', 'B', 'q6', 'B', 'L'),

('q5', '0', 'q7', 'B', 'L'),

('q6', '1', 'q7', 'B', 'L'),

('q7', '0', 'q7', '0', 'L'),
('q7', '1', 'q7', '1', 'L'),
('q7', 'B', 'q0', 'B', 'R');



-- Función para ejecutar la simulación de la Máquina de Turing Es Palíndromo
-- Se asume que el usuario llamará a esta función pasando la cinta inicial
CREATE OR REPLACE FUNCTION ejecutar_esPalindromo(cinta TEXT) RETURNS SETOF traza_ejecucion AS $$
BEGIN
    -- Llama a la función simuladorMT, que realiza la simulación y llena la tabla traza_ejecucion
    PERFORM simuladorMT(cinta);

    -- Muestra la traza de la ejecución usando la vista vista_movimientos
    -- Esta parte puede ser manejada por el usuario fuera de la función si se prefiere
    RETURN QUERY SELECT * FROM traza_ejecucion;
END;

$$ LANGUAGE plpgsql;

-- Ejemplo de uso:
SELECT ejecutar_esPalindromo('10101B');