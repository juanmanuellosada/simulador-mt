-- Función para simular una Máquina de Turing
CREATE OR REPLACE FUNCTION simuladorMT(input_string TEXT) RETURNS VOID AS $$
DECLARE
    estado_actual VARCHAR(255) := 'q0';  -- Estado inicial asumido
    caracter_actual CHAR(1);
    siguiente_estado VARCHAR(255);
    siguiente_caracter CHAR(1);
    mover CHAR(1);
    posicion_cabezal INT := 1;  -- Asume que la posición inicial del cabezal es 1
    cinta TEXT := input_string;
    action RECORD;
    termino_ejecucion BOOLEAN := FALSE;
begin
	--Limpio las trazas anteriores
	truncate traza_ejecucion;
    -- Inserta el estado inicial en la tabla traza_ejecucion antes de iniciar el procesamiento
    INSERT INTO traza_ejecucion (estado_actual, cinta_actual, posicion_cabezal, estado_siguiente, cinta_siguiente, movimiento, es_final)
    VALUES (estado_actual, cinta, posicion_cabezal, NULL, cinta, NULL, FALSE);

    -- Bucle principal de la simulación
    WHILE NOT termino_ejecucion LOOP
        -- Obtener el carácter actual en la posición del cabezal
        caracter_actual := SUBSTRING(cinta FROM posicion_cabezal FOR 1);

        -- Buscar la acción a realizar basada en el estado actual y el carácter actual
        SELECT estado_nuevo, caracter_nuevo, desplazamiento INTO siguiente_estado, siguiente_caracter, mover
        FROM programa
        WHERE estado_origen = estado_actual AND caracter_origen = caracter_actual;

        -- Si no hay acción definida, se asume que la máquina debe detenerse
        IF NOT FOUND THEN
            termino_ejecucion := TRUE;
            -- Marcar la finalización en la tabla de trazas
            
            if (estado_actual = 'qf') THEN
                INSERT INTO traza_ejecucion (estado_actual, cinta_actual, posicion_cabezal, estado_siguiente, cinta_siguiente, movimiento, es_final)
                VALUES (estado_actual, cinta, posicion_cabezal, NULL, cinta, NULL, TRUE);
            ELSE
                INSERT INTO traza_ejecucion (estado_actual, cinta_actual, posicion_cabezal, estado_siguiente, cinta_siguiente, movimiento, es_final)
                VALUES (estado_actual, cinta, posicion_cabezal, NULL, cinta, NULL, FALSE);
            END IF;
        END IF;

        -- Actualizar la cinta con el nuevo carácter
        cinta := OVERLAY(cinta PLACING siguiente_caracter FROM posicion_cabezal FOR 1);

        -- Actualizar la posición del cabezal según el movimiento
        IF mover = 'R' THEN
            posicion_cabezal := posicion_cabezal + 1;
        ELSIF mover = 'L' THEN
            posicion_cabezal := posicion_cabezal - 1;
        END IF;

        IF siguiente_estado IS NOT NULL THEN
            -- Registrar el movimiento en la tabla traza_ejecucion
            INSERT INTO traza_ejecucion (estado_actual, cinta_actual, posicion_cabezal, estado_siguiente, cinta_siguiente, movimiento, es_final)
            VALUES (estado_actual, cinta, posicion_cabezal, siguiente_estado, cinta, mover, FALSE);
        END IF;

        -- Actualizar el estado actual al siguiente estado
        estado_actual := siguiente_estado;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
