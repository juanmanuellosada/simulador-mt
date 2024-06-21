-- Inserta el alfabeto en la tabla alfabeto
truncate alfabeto;
INSERT INTO alfabeto (caracter) VALUES ('1'), ('0'), ('B');

-- Define las transiciones necesarias para la máquina de Turing que invierte 0s y 1s
-- Asumimos que el estado inicial es q0 y que q1 es un estado de parada
TRUNCATE programa CASCADE;
INSERT INTO programa (estado_origen, caracter_origen, estado_nuevo, caracter_nuevo, desplazamiento) VALUES
('q0', '1', 'q0', '0', 'R'),  -- Cuando lee un '1', escribe un '0' y se mueve a la derecha
('q0', '0', 'q0', '1', 'R'),  -- Cuando lee un '0', escribe un '1' y se mueve a la derecha
('q0', 'B', 'q1', 'B', 'S');  -- Cuando encuentra un espacio en blanco, entra al estado de parada

-- Función para ejecutar la simulación de la máquina de Turing inversora
-- Se asume que el usuario llamará a esta función pasando la cinta inicial
CREATE OR REPLACE FUNCTION ejecutar_inversorBinario(cinta TEXT) RETURNS SETOF traza_ejecucion AS $$
BEGIN
	-- Llama a la función simuladorMT, que realiza la simulación y llena la tabla traza_ejecucion
	PERFORM simuladorMT(cinta);

	-- Muestra la traza de la ejecución usando la vista vista_movimientos
	-- Esta parte puede ser manejada por el usuario fuera de la función si se prefiere
	RETURN QUERY SELECT * FROM traza_ejecucion;
END;
$$ LANGUAGE plpgsql;

-- Ejemplo de uso:
SELECT ejecutar_inversorBinario('10101B');
