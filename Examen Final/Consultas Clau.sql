SELECT nombre, usuario, habilidad
FROM agentes
WHERE (habilidad BETWEEN 7 AND 9) AND (UPPER(nombre) LIKE UPPER('%José%'))
ORDER BY habilidad ASC;

SELECT o.nombre, AVG(a.habilidad) AS habilidad_promedio
FROM oficinas o
INNER JOIN agentes a ON o.identificador = a.oficina
GROUP BY o.identificador, o.nombre
HAVING COUNT(a.identificador) >=2;

SELECT a.nombre, a.habilidad, f.nombre
FROM agentes a
INNER JOIN familias f ON a.familia = f.identificador
WHERE a.habilidad = (
	SELECT MAX(a2.habilidad)
	FROM agentes a2
	WHERE a2.familia = a.familia
);

SET SQL_SAFE_UPDATES = 0;
UPDATE agentes
SET habilidad = habilidad + 1
WHERE oficina = 1 AND categoria = 1; 
SET SQL_SAFE_UPDATES = 1;

DELIMITER //
CREATE PROCEDURE promoverAgente(IN agente_id INT)
BEGIN
	DECLARE categoria_actual INT default 0;
    DECLARE agente_existe INT DEFAULT 0;
    
    SELECT COUNT(*), IFNULL(categoria, o)
    INT agente_existe, categoria _actual
    FROM agentes
    WHERE identificador = agente_id;
    
	IF agente_EXISTE = 0 THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'EL agente no existe';
	END IF;
    
	IF categoria_actual >= 2 THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'EL agente ya tiene categoria máxima';
	END IF;
    
    UPDATE agentes
    SET categoria = categoria +1
    WHERE identificador = agente_id;
    
END //

DELIMITER ;