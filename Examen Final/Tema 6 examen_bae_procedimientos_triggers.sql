USE agencia;

-- ==========================================
-- PARTE 1 - PROCEDIMIENTOS ALMACENADOS
-- ==========================================

-- ==========================================
-- 1. Procedimiento: contar_agentes_categoria
-- Descripción: Cuenta los agentes que pertenecen a una categoría específica
-- ==========================================
DELIMITER //
CREATE PROCEDURE contar_agentes_categoria(IN p_categoria TINYINT)
BEGIN
    DECLARE v_contador INT DEFAULT 0;
    
    -- Contar agentes de la categoría especificada
    SELECT COUNT(*) INTO v_contador
    FROM agentes 
    WHERE categoria = p_categoria;
    
    -- Mostrar el resultado
    SELECT CONCAT('Número de agentes en la categoría ', p_categoria, '= ', v_contador) AS resultado;
    
END;
//
DELIMITER ;



-- ==========================================
-- 2. Procedimiento: mover_familia_a_oficina
-- Descripción: Mueve una familia y toda su jerarquía a una oficina específica
-- ==========================================
DELIMITER //

CREATE PROCEDURE mover_familia_a_oficina(IN p_familia_id INT, IN p_oficina_id INT)
BEGIN
    -- Validar existencia
    IF (SELECT COUNT(*) FROM familias WHERE identificador = p_familia_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Familia no existe';
    END IF;
    
    IF (SELECT COUNT(*) FROM oficinas WHERE identificador = p_oficina_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Oficina no existe';
    END IF;
    
    -- Actualizar familia principal
    UPDATE familias SET oficina = p_oficina_id WHERE identificador = p_familia_id;
    
    -- Actualizar subfamilias
    UPDATE familias SET oficina = p_oficina_id WHERE familia = p_familia_id;
    
    -- Actualizar agentes
    UPDATE agentes SET oficina = p_oficina_id WHERE familia = p_familia_id;
    UPDATE agentes SET oficina = p_oficina_id WHERE familia IN 
        (SELECT identificador FROM familias WHERE familia = p_familia_id);
    
    SELECT 'Procedimiento ejecutado correctamente' AS resultado;
END;
//

DELIMITER ;


-- ==========================================
-- PARTE 2 - TRIGGERS
-- ==========================================

-- ==========================================
-- 3. Trigger: trg_nombre_agente_mayusculas
-- Descripción: Convierte automáticamente el nombre del agente a mayúsculas
-- ==========================================
DELIMITER //
CREATE TRIGGER trg_nombre_agente_mayusculas
BEFORE INSERT ON agentes
FOR EACH ROW
BEGIN
    -- Convertir el nombre a mayúsculas antes de insertar
    SET NEW.nombre = UPPER(NEW.nombre);
END;
//

-- Trigger para UPDATE también
CREATE TRIGGER trg_nombre_agente_mayusculas_update
BEFORE UPDATE ON agentes
FOR EACH ROW
BEGIN
    -- Convertir el nombre a mayúsculas antes de actualizar
    SET NEW.nombre = UPPER(NEW.nombre);
END;
//
DELIMITER ;


-- ==========================================
-- 4. Trigger: trg_bloquear_categoria_jefe
-- Descripción: Impide cambiar la categoría de agentes que son jefes (categoría 2)
-- ==========================================
DELIMITER //
CREATE TRIGGER trg_bloquear_categoria_jefe
BEFORE UPDATE ON agentes
FOR EACH ROW
BEGIN
    -- Verificar si se intenta cambiar la categoría de un jefe
    IF OLD.categoria = 2 AND NEW.categoria != 2 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: No se puede cambiar la categoría de un agente jefe (categoría 2)';
    END IF;
END;
//

DELIMITER ;


/*
Pruebas
1. CALL contar_agentes_categoria(1);
Devuelve el valor esperado correctamente
'Número de agentes en la categoría 1= 6'

2. CALL mover_familia_a_oficina(112, 2);

Devuelve el valor esperado:
'Procedimiento ejecutado correctamente'
1 row(s) returned
Verifico la fila afectada
'1121', 'Silvia Thomas Barrós', 'stb', 'ag1121', '7', '1', '112', '2'



3. Al insertar una nueva fila con un nuevo agente:
INSERT INTO `agencia`.`agentes` (`identificador`, `nombre`, `usuario`, `clave`, `habilidad`, `categoria`, `familia`) VALUES ('11234', 'eudaldo alvaro cal saul', 'eucal', 'eu11234', '5', '0', '1123');

Devuelve el valor esperado:
'11234', 'EUDALDO ALVARO CAL SAUL', 'eucal', 'eu11234', '5', '0', '1123', NULL

4. AL cambiar la categoria 2 de la fila:

'11', 'Narciso Jáimez Toro', 'njt', 'sup11', '9', '2', NULL, '1'
'11', 'Narciso Jáimez Toro', 'njt', 'sup11', '9', '1', NULL, '1'

Devuelve el valor esperado:
Operation failed: There was an error while applying the SQL script to the database.
Executing:
UPDATE `agencia`.`agentes` SET `categoria` = '1' WHERE (`identificador` = '11');

ERROR 1644: 1644: Error: No se puede cambiar la categoría de un agente jefe (categoría 2)
SQL Statement:
UPDATE `agencia`.`agentes` SET `categoria` = '1' WHERE (`identificador` = '11')

*/
