-- ==========================================
-- 2. Procedimiento: mover_familia_a_oficina
-- Descripción: Mueve una familia y toda su jerarquía a una oficina específica
-- ==========================================
DELIMITER //
CREATE PROCEDURE mover_familia_a_oficina(IN p_familia_id INT, IN p_oficina_id INT)
BEGIN
    -- Declaración de variables
    DECLARE v_existe_familia INT DEFAULT 0;
    DECLARE v_existe_oficina INT DEFAULT 0;
    DECLARE v_familias_actualizadas INT DEFAULT 0;
    DECLARE v_agentes_actualizados INT DEFAULT 0;
    DECLARE v_nombre_familia VARCHAR(40);
    DECLARE v_nombre_oficina VARCHAR(40);
    
    -- Comprobar si existe la familia
    SELECT COUNT(*), nombre INTO v_existe_familia, v_nombre_familia
    FROM familias 
    WHERE identificador = p_familia_id;
    
    -- Comprobar si existe la oficina
    SELECT COUNT(*), nombre INTO v_existe_oficina, v_nombre_oficina
    FROM oficinas 
    WHERE identificador = p_oficina_id;
    
    -- Validaciones
    IF v_existe_familia = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La familia especificada no existe';
    END IF;
    
    IF v_existe_oficina = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La oficina especificada no existe';
    END IF;
    
    -- Actualizar la familia principal
    UPDATE familias 
    SET oficina = p_oficina_id 
    WHERE identificador = p_familia_id;
    
    -- Actualizar todas las subfamilias (jerarquía completa)
    -- Usamos una consulta recursiva para encontrar toda la jerarquía
    UPDATE familias 
    SET oficina = p_oficina_id 
    WHERE identificador IN (
        -- CTE recursivo para encontrar toda la jerarquía de familias
        WITH RECURSIVE jerarquia_familias AS (
            -- Caso base: familia raíz
            SELECT identificador 
            FROM familias 
            WHERE identificador = p_familia_id
            
            UNION ALL
            
            -- Caso recursivo: familias hijas
            SELECT f.identificador
            FROM familias f
            INNER JOIN jerarquia_familias jf ON f.familia = jf.identificador
        )
        SELECT identificador FROM jerarquia_familias
    );
    
    SET v_familias_actualizadas = ROW_COUNT();
    
    -- Actualizar agentes de la familia y sus subfamilias
    UPDATE agentes 
    SET oficina = p_oficina_id 
    WHERE familia IN (
        WITH RECURSIVE jerarquia_familias AS (
            SELECT identificador 
            FROM familias 
            WHERE identificador = p_familia_id
            
            UNION ALL
            
            SELECT f.identificador
            FROM familias f
            INNER JOIN jerarquia_familias jf ON f.familia = jf.identificador
        )
        SELECT identificador FROM jerarquia_familias
    );
    
    SET v_agentes_actualizados = ROW_COUNT();
    
    -- Mostrar resumen de la operación
    SELECT CONCAT('Operación completada exitosamente:') AS titulo;
    SELECT CONCAT('- Familia movida: ', v_nombre_familia, ' (ID: ', p_familia_id, ')') AS familia_movida;
    SELECT CONCAT('- Oficina destino: ', v_nombre_oficina, ' (ID: ', p_oficina_id, ')') AS oficina_destino;
    SELECT CONCAT('- Familias actualizadas: ', v_familias_actualizadas) AS familias_actualizadas;
    SELECT CONCAT('- Agentes actualizados: ', v_agentes_actualizados) AS agentes_actualizados;
    
END;
DELIMITER ;
