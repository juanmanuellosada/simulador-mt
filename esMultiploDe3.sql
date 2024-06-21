-- Reinicia la tabla de transiciones para la Máquina de Turing
TRUNCATE programa CASCADE;

-- Inserta las transiciones en la tabla
INSERT INTO programa (estado_origen, caracter_origen, estado_nuevo, caracter_nuevo, desplazamiento) VALUES
('q0', '0', 'q0', '0', 'R'),
('q0', '1', 'q1', '1', 'R'),

('q1', '0', 'q2', '0', 'R'),
('q1', '1', 'q0', '1', 'R'),

('q2', '0', 'q1', '0', 'R'),
('q2', '1', 'q2', '1', 'R'),

-- Transiciones para manejar el carácter blanco al final de la cinta
('q0', 'B', 'qf', 'B', 'R'), -- Múltiplo de 3
('q1', 'B', 'q_reject', 'B', 'R'), -- No es múltiplo de 3
('q2', 'B', 'q_reject', 'B', 'R'); -- No es múltiplo de 3

-- Función para ejecutar la simulación de la Máquina de Turing
CREATE OR REPLACE FUNCTION ejecutar_esMultiplode3(cinta TEXT) RETURNS SETOF traza_ejecucion AS $$
BEGIN
    -- Llama a la función simuladorMT, que realiza la simulación y llena la tabla traza_ejecucion
    PERFORM simuladorMT(cinta);

    -- Muestra la traza de la ejecución
    RETURN QUERY SELECT * FROM traza_ejecucion;
END;
$$ LANGUAGE plpgsql;

-- Ejemplo de uso:
SELECT ejecutar_esMultiplode3('1011011101101110B');
