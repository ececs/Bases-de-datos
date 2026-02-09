-- ==========================================
-- BD06 - Tarea: Procedimientos y Triggers
-- Cal Saul Eudaldo Alvaro
-- ==========================================

-- Cambiar el delimitador para definir procedimientos y triggers
DELIMITER //

-- ==========================================
-- Procedimiento: CambiarAgentesFamilia
-- Descripción: Cambia los agentes de una familia a otra
-- ==========================================
CREATE PROCEDURE CambiarAgentesFamilia(IN id_FamiliaOrigen INT, IN id_FamiliaDestino INT)
BEGIN
    -- Declaración de variables
    DECLARE v_existe_origen INT DEFAULT 0;
    DECLARE v_existe_destino INT DEFAULT 0;
    DECLARE v_nombre_origen VARCHAR(40);
    DECLARE v_nombre_destino VARCHAR(40);
    DECLARE v_agentes_afectados INT DEFAULT 0;

    -- Validación de igualdad entre ids
    IF id_FamiliaOrigen = id_FamiliaDestino THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La familia origen y destino no pueden ser iguales';
    END IF;

    -- Validación de existencia de familias
    SELECT COUNT(*) INTO v_existe_origen 
    FROM familias 
    WHERE identificador = id_FamiliaOrigen;
    
    SELECT COUNT(*) INTO v_existe_destino 
    FROM familias 
    WHERE identificador = id_FamiliaDestino;

    IF v_existe_origen = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La familia origen no existe';
    END IF;

    IF v_existe_destino = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La familia destino no existe';
    END IF;

    -- Obtener nombres de las familias (origen y destino)
    SELECT nombre INTO v_nombre_origen 
    FROM familias 
    WHERE identificador = id_FamiliaOrigen;
    
    SELECT nombre INTO v_nombre_destino 
    FROM familias 
    WHERE identificador = id_FamiliaDestino;

    -- Actualización de los agentes
    UPDATE agentes 
    SET familia = id_FamiliaDestino 
    WHERE familia = id_FamiliaOrigen;
    
    -- Obtener el número de filas afectadas
    SET v_agentes_afectados = ROW_COUNT();

    -- Mostrar mensaje final
    SELECT CONCAT('Se han trasladado ', v_agentes_afectados, ' agentes de la familia ', 
                  id_FamiliaOrigen, ' a la familia ', id_FamiliaDestino) AS mensaje;

END;
//




-- ==========================================
-- Trigger: Validación de agentes
-- Descripción: Comprueba restricciones de integridad en la tabla agentes
-- ==========================================
CREATE TRIGGER validar_agentes
BEFORE INSERT ON agentes
FOR EACH ROW
BEGIN
    -- Validar longitud de clave (mínimo 6 caracteres)
    IF LENGTH(NEW.clave) < 6 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La clave debe tener al menos 6 caracteres';
    END IF;

    -- Validar rango de habilidad (0 a 9)
    IF NEW.habilidad < 0 OR NEW.habilidad > 9 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La habilidad debe estar entre 0 y 9';
    END IF;

    -- Validar valores permitidos en categoría (0, 1, 2)
    IF NEW.categoria NOT IN (0, 1, 2) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La categoría debe ser 0, 1 o 2';
    END IF;

    -- Validar coherencia categoría vs familia/oficina
    IF NEW.categoria = 2 AND (NEW.familia IS NOT NULL OR NEW.oficina IS NULL) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Los agentes de categoría 2 deben tener solo oficina (sin familia)';
    END IF;

    IF NEW.categoria = 1 AND (NEW.oficina IS NOT NULL OR NEW.familia IS NULL) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Los agentes de categoría 1 deben tener solo familia (sin oficina)';
    END IF;

    -- Validar exclusividad familia vs oficina
    IF NEW.familia IS NOT NULL AND NEW.oficina IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Un agente no puede pertenecer a una familia y oficina simultáneamente';
    END IF;

    -- Para categoría 0, pueden tener familia pero no oficina (según los datos de ejemplo)
    IF NEW.categoria = 0 AND NEW.oficina IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Los agentes de categoría 0 no pueden tener oficina asignada';
    END IF;

END;
//


-- Trigger adicional para UPDATE
CREATE TRIGGER validar_agentes_update
BEFORE UPDATE ON agentes
FOR EACH ROW
BEGIN
    -- Validar longitud de clave solo si se está modificando
    IF NEW.clave != OLD.clave AND LENGTH(NEW.clave) < 6 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La clave debe tener al menos 6 caracteres';
    END IF;

    -- Validar rango de habilidad (0 a 9)
    IF NEW.habilidad < 0 OR NEW.habilidad > 9 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La habilidad debe estar entre 0 y 9';
    END IF;

    -- Validar valores permitidos en categoría (0, 1, 2)
    IF NEW.categoria NOT IN (0, 1, 2) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La categoría debe ser 0, 1 o 2';
    END IF;

    -- Validar coherencia categoría vs familia/oficina
    IF NEW.categoria = 2 AND (NEW.familia IS NOT NULL OR NEW.oficina IS NULL) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Los agentes de categoría 2 deben tener solo oficina (sin familia)';
    END IF;

    IF NEW.categoria = 1 AND (NEW.oficina IS NOT NULL OR NEW.familia IS NULL) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Los agentes de categoría 1 deben tener solo familia (sin oficina)';
    END IF;

    -- Validar exclusividad familia vs oficina
    IF NEW.familia IS NOT NULL AND NEW.oficina IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Un agente no puede pertenecer a una familia y oficina simultáneamente';
    END IF;

    -- Para categoría 0, pueden tener familia pero no oficina
    IF NEW.categoria = 0 AND NEW.oficina IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Los agentes de categoría 0 no pueden tener oficina asignada';
    END IF;

END;
//

DELIMITER ;

/*
Ventajas de usar CHECK vs TRIGGER:

* Las restricciones CHECK son más eficientes
* Se evalúan antes que los triggers
* Son más claras en el esquema de la base de datos

Cuándo usar TRIGGERS:

* Para validaciones complejas que requieren consultas a otras tablas
* Para lógica de negocio que involucra múltiples campos
* Para validaciones que dependen del contexto (como la exclusividad familia/oficina según categoría)

*/

-- ========================================================================================
-- Pruebas Procedimiento: CambiarAgentesFamilia
-- ========================================================================================

-- Prueba del procedimiento: mover agentes de la familia 111 a la familia 112
CALL CambiarAgentesFamilia(112, 112);

-- Prueba del procedimiento con error (familias iguales)
CALL CambiarAgentesFamilia(111, 111);

-- Prueba del procedimiento con familia inexistente
CALL CambiarAgentesFamilia(999, 112);

-- ========================================================================================


-- ========================================================================================
-- Pruebas Trigger: Validación de agentes
-- ========================================================================================

-- Pruebas del trigger - INSERT válido
INSERT INTO agentes VALUES (999, 'Prueba Test', 'ptest', 'clave123', 5, 0, 111, NULL);

-- Pruebas del trigger - INSERT con clave corta (debe fallar)
INSERT INTO agentes VALUES (998, 'Error Test', 'etest', '123', 5, 0, 111, NULL);

-- Pruebas del trigger - INSERT con habilidad inválida (debe fallar)
INSERT INTO agentes VALUES (997, 'Error Test 2', 'etest2', 'clave123', 15, 0, 111, NULL);

-- Pruebas del trigger - INSERT con categoría inválida (debe fallar)
INSERT INTO agentes VALUES (996, 'Error Test 3', 'etest3', 'clave123', 5, 5, 111, NULL);

-- Pruebas del trigger - INSERT con familia y oficina (debe fallar)
INSERT INTO agentes VALUES (995, 'Error Test 4', 'etest4', 'clave123', 5, 0, 111, 1);

-- Pruebas del trigger - UPDATE válido
UPDATE agentes SET habilidad = 6 WHERE identificador = 311;

-- Pruebas del trigger - UPDATE con error (debe fallar)
UPDATE agentes SET clave = '123' WHERE identificador = 311;

-- ========================================================================================

