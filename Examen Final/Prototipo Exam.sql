-- Añadir el campo email como NULL inicialmente
ALTER TABLE agentes 
ADD COLUMN email VARCHAR(100) NULL UNIQUE;
SET SQL_SAFE_UPDATES = 0;
-- Luego actualizar cada agente con un email único
-- Ejemplo usando el usuario como base para el email:
UPDATE agentes 
SET email = CONCAT(usuario, '@agencia.com');
SET SQL_SAFE_UPDATES = 1;
-- Finalmente, hacer el campo NOT NULL
ALTER TABLE agentes 
MODIFY COLUMN email VARCHAR(100) NOT NULL UNIQUE;

CREATE TABLE misiones (
id INT PRIMARY KEY AUTO_INCREMENT,
titulo VARCHAR(100) NOT NULL,
fecha_inicio DATE,
fecha_fin DATE,
agente_id INT, 
FOREIGN KEY (agente_id) REFERENCES agentes(identificador) ON DELETE CASCADE
);

CREATE INDEX ids_gecha_inicio ON misiones(fecha_inicio);

SELECT o.nombre, count(a.identificador) AS total_agentes 
FROM oficinas o
LEFT JOIN agentes a ON o.identificador = a.oficina
GROUP BY o.identificador, o.nombre
ORDER BY o.nombre;

SELECT nombre, habilidad
FROM agentes
WHERE UPPER(nombre) LIKE UPPER('%Gracía%')
ORDER BY habilidad DESC;

SELECT f.nombre
FROM familias f
LEFT JOIN agentes a ON f.identificador = a.familia
WHERE a.familia IS NULL
ORDER BY f.nombre;

SELECT categoria, COUNT(*) AS total_agentes
FROM agentes
WHERE categoria > 0
GROUP BY categoria
ORDER BY categoria;

INSERT INTO misiones (titulo, fecha_inicio, fecha_fin, agente_id)
VALUES ('Operación Eclipse', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 15 DAY), 1113);

SET SQL_SAFE_UPDATES = 0;
UPDATE agentes
SET categoria = 3
WHERE habilidad > 8;
SET SQL_SAFE_UPDATES = 1;

DELETE FROM agentes
WHERE categoria =0 AND oficina IS NULL;

DELIMITER //

CREATE PROCEDURE trasladarAgentesOficina(
    IN origen INT,
    IN destino INT
)
BEGIN
    DECLARE existe_origen INT DEFAULT 0;
    DECLARE existe_destino INT DEFAULT 0;
    
    -- Verificar que origen y destino son diferentes
    IF origen = destino THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La oficina de origen y destino deben ser diferentes';
    END IF;
    
    -- Verificar que la oficina origen existe
    SELECT COUNT(*) INTO existe_origen 
    FROM oficinas 
    WHERE identificador = origen;
    
    IF existe_origen = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La oficina de origen no existe';
    END IF;
    
    -- Verificar que la oficina destino existe
    SELECT COUNT(*) INTO existe_destino 
    FROM oficinas 
    WHERE identificador = destino;
    
    IF existe_destino = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La oficina de destino no existe';
    END IF;
    
    -- Si todas las validaciones pasan, realizar el traslado
    UPDATE agentes 
    SET oficina = destino 
    WHERE oficina = origen;
    
END //

DELIMITER ;


-- 1. Crear tabla bitacora_bajas
CREATE TABLE bitacora_bajas (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    agente_id INT,
    fecha_baja DATETIME,
    nombre_agente VARCHAR(100)
);

-- 2. Crear trigger after_delete_agente
DELIMITER //

CREATE TRIGGER after_delete_agente
    AFTER DELETE ON agentes
    FOR EACH ROW
BEGIN
    INSERT INTO bitacora_bajas (agente_id, fecha_baja, nombre_agente)
    VALUES (OLD.identificador, NOW(), OLD.nombre);
END //

DELIMITER ;
 -- Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.
-- 0 row(s) affected, 1 warning(s): 1831 Duplicate index 'email_2' defined on the table 'agencia.agentes'. This is deprecated and will be disallowed in a future release. Records: 0  Duplicates: 0  Warnings: 1
