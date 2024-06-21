-- Función para simular una Máquina de Turing
CREATE OR REPLACE FUNCTION simuladorMT(input_string TEXT) RETURNS VOID AS $$
DECLARE
    current_state VARCHAR(255) := 'q0';  -- Estado inicial asumido
    current_char CHAR(1);
    next_state VARCHAR(255);
    next_char CHAR(1);
    move CHAR(1);
    head_position INT := 1;  -- Asume que la posición inicial del cabezal es 1
    tape TEXT := input_string;
    action RECORD;
    finished BOOLEAN := FALSE;
begin
	--Limpio las trazas anteriores
	truncate traza_ejecucion;
    -- Inserta el estado inicial en la tabla traza_ejecucion antes de iniciar el procesamiento
    INSERT INTO traza_ejecucion (estado_actual, cinta_actual, posicion_cabezal, estado_siguiente, cinta_siguiente, movimiento, es_final)
    VALUES (current_state, tape, head_position, NULL, tape, NULL, FALSE);

    -- Bucle principal de la simulación
    WHILE NOT finished LOOP
        -- Obtener el carácter actual en la posición del cabezal
        current_char := SUBSTRING(tape FROM head_position FOR 1);

        -- Buscar la acción a realizar basada en el estado actual y el carácter actual
        SELECT estado_nuevo, caracter_nuevo, desplazamiento INTO next_state, next_char, move
        FROM programa
        WHERE estado_origen = current_state AND caracter_origen = current_char;

        -- Si no hay acción definida, se asume que la máquina debe detenerse
        IF NOT FOUND THEN
            finished := TRUE;
            -- Marcar la finalización en la tabla de trazas
            
            if (current_state = 'qf') THEN
                INSERT INTO traza_ejecucion (estado_actual, cinta_actual, posicion_cabezal, estado_siguiente, cinta_siguiente, movimiento, es_final)
                VALUES (current_state, tape, head_position, NULL, tape, NULL, TRUE);
            ELSE
                INSERT INTO traza_ejecucion (estado_actual, cinta_actual, posicion_cabezal, estado_siguiente, cinta_siguiente, movimiento, es_final)
                VALUES (current_state, tape, head_position, NULL, tape, NULL, FALSE);
            END IF;
        END IF;

        -- Actualizar la cinta con el nuevo carácter
        tape := OVERLAY(tape PLACING next_char FROM head_position FOR 1);

        -- Actualizar la posición del cabezal según el movimiento
        IF move = 'R' THEN
            head_position := head_position + 1;
        ELSIF move = 'L' THEN
            head_position := head_position - 1;
        END IF;

        IF next_state IS NOT NULL THEN
            -- Registrar el movimiento en la tabla traza_ejecucion
            INSERT INTO traza_ejecucion (estado_actual, cinta_actual, posicion_cabezal, estado_siguiente, cinta_siguiente, movimiento, es_final)
            VALUES (current_state, tape, head_position, next_state, tape, move, FALSE);
        END IF;

        -- Actualizar el estado actual al siguiente estado
        current_state := next_state;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
