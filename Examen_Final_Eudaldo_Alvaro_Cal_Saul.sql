-- PLANTILLA EXAMEN FINAL - BASE DE DATOS (Sakila, versión profesional V4)
-- Nombre del alumno: Eudaldo Alvaro Cal Saul

-- ========================================
-- PARTE 1 - Ampliación del modelo
-- ========================================

-- 1. Añadir campo phone_number a staff

ALTER TABLE staff 
ADD COLUMN phone_number VARCHAR(20) NULL;

-- ALTER TABLE staff: Se añadió phone_number VARCHAR(20) NULL siguiendo el patrón de otros campos de teléfono en la BD Sakila.

-- Se ejecuta correctamente agregando phone_number como columna de la tabla staff
-- ALTER TABLE staff  ADD COLUMN phone_number VARCHAR(20) NULL
-- 0 row(s) affected Records: 0  Duplicates: 0  Warnings: 0

-- 2. Crear tabla promotion
CREATE TABLE promotion (
    promotion_id INT AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    store_id TINYINT UNSIGNED,
    PRIMARY KEY (promotion_id),
    CONSTRAINT fk_promotion_store 
        FOREIGN KEY (store_id) 
        REFERENCES store (store_id) 
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Se creó con todos los campos requeridos, incluyendo constraint de FK con ON DELETE CASCADE según especificaciones.

-- Se crea correctamente la tabla promotion con los campos requeridos
-- CREATE TABLE promotion (     promotion_id INT AUTO_INCREMENT,     title VARCHAR(100) NOT NULL,     start_date DATE,     end_date DATE,     store_id TINYINT UNSIGNED,     PRIMARY KEY (promotion_id),     CONSTRAINT fk_promotion_store          FOREIGN KEY (store_id)          REFERENCES store (store_id)          ON DELETE CASCADE ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
-- 0 row(s) affected


-- 3. Crear índice sobre start_date
CREATE INDEX idx_promotion_start_date ON promotion (start_date);

-- Creo indice sobre start_date que optimiza las consultas por fechas.

-- Creo correctamente el indice sobre el campo start_date de la tabla promotion.
-- CREATE INDEX idx_promotion_start_date ON promotion (start_date)
-- 0 row(s) affected Records: 0  Duplicates: 0  Warnings: 0


-- ========================================
-- PARTE 2 - Consultas SQL
-- ========================================

-- 1. Categorías y número total de películas
SELECT 
    c.name AS categoria,
    COUNT(fc.film_id) AS total_peliculas
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.category_id, c.name
ORDER BY c.name;

-- Categorías con conteo: LEFT JOIN para incluir categorías sin películas, GROUP BY con COUNT() para obtener totales por categoría.

-- Devuelve el nombre de todas las categorías y el número total de películas que pertenecen a cada una
-- SELECT      c.name AS categoria,     COUNT(fc.film_id) AS total_peliculas FROM category c LEFT JOIN film_category fc ON c.category_id = fc.category_id GROUP BY c.category_id, c.name ORDER BY c.name LIMIT 0, 1000
-- 16 row(s) returned


-- 2. Actores cuyo apellido contenga 'GEN', ordenados por apellido descendente
SELECT 
    first_name AS nombre,
    last_name AS apellido
FROM actor
WHERE last_name LIKE '%GEN%'
ORDER BY last_name DESC;

-- Actores con 'GEN': LIKE '%GEN%' para búsqueda de substring, ORDER BY DESC para orden descendente por apellido.

-- Muestra el nombre y apellido de los actores cuyo apellido contenga la cadena 'GEN'
-- SELECT      first_name AS nombre,     last_name AS apellido FROM actor WHERE last_name LIKE '%GEN%' ORDER BY last_name DESC LIMIT 0, 1000
-- 4 row(s) returned


-- 3. Películas sin inventario
SELECT 
    f.title AS titulo
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
WHERE i.film_id IS NULL
ORDER BY f.title;

-- Películas sin inventario: LEFT JOIN con IS NULL para encontrar registros huérfanos (películas sin copias físicas).

-- Devuelve los títulos de las películas que no tienen ningún inventario asociado
-- SELECT      f.title AS titulo FROM film f LEFT JOIN inventory i ON f.film_id = i.film_id WHERE i.film_id IS NULL ORDER BY f.title LIMIT 0, 1000
-- 42 row(s) returned


-- 4. Clientes por tienda con más de 100 clientes
SELECT 
    store_id AS tienda,
    COUNT(*) AS total_clientes
FROM customer
GROUP BY store_id
HAVING COUNT(*) > 100
ORDER BY store_id;

-- Clientes por tienda: GROUP BY con HAVING COUNT(*) > 100 para filtrar solo tiendas con muchos clientes después de la agrupación.

-- Consulta el número total de clientes por tienda, solo para tiendas con más de 100 clientes
-- SELECT      store_id AS tienda,     COUNT(*) AS total_clientes FROM customer GROUP BY store_id HAVING COUNT(*) > 100 ORDER BY store_id LIMIT 0, 1000
-- 2 row(s) returned

-- ========================================
-- PARTE 3 - Modificación de datos (DML)
-- ========================================

-- 1. Insertar nueva promoción "Spring Sale"
-- Con start_date: fecha de hoy, end_date: 30 días después, store_id = 1
INSERT INTO promotion (title, start_date, end_date, store_id)
VALUES (
    'Spring Sale',
    CURDATE(),
    DATE_ADD(CURDATE(), INTERVAL 30 DAY),
    1
);

-- INSERT promoción: Uso de CURDATE() y DATE_ADD() para fechas dinámicas, asignación a store_id específico según requerimientos.

-- INSERT INTO promotion (title, start_date, end_date, store_id) VALUES (     'Spring Sale',     CURDATE(),     DATE_ADD(CURDATE(), INTERVAL 30 DAY),     1 )
-- 1 row(s) affected
-- Compruebo que se ha creado correctmente la promoción
SELECT * FROM promotion WHERE title = 'Spring Sale';

-- 2. Cambiar active a 0 para clientes con más de 20 pagos (store_id=1)
-- Actualiza el campo active para clientes de la tienda 1 que tengan más de 20 pagos
UPDATE customer 
SET active = 0
WHERE store_id = 1 
AND customer_id IN (
    SELECT customer_id 
    FROM (
        SELECT customer_id
        FROM payment
        GROUP BY customer_id
        HAVING COUNT(*) > 20
    ) AS subquery
);

-- UPDATE clientes: Subconsulta segura con GROUP BY customer_id y HAVING COUNT(*) > 20 para identificar clientes con muchos pagos, solo en store_id = 1.

-- UPDATE customer  SET active = 0 WHERE store_id = 1  AND customer_id IN (     SELECT customer_id      FROM (         SELECT customer_id         FROM payment         GROUP BY customer_id         HAVING COUNT(*) > 20     ) AS subquery )
-- 292 row(s) affected Rows matched: 298  Changed: 292  Warnings: 0

-- Verifico los clientes actualizados

SELECT customer_id, active FROM customer WHERE store_id = 1 AND active = 0;

-- 3. Eliminar clientes antiguos sin rentals
-- Elimina clientes con create_date anterior a 2006-01-01 y sin alquileres
-- Usando subconsulta segura para evitar conflictos en modo seguro

-- EXAMEN FINAL - CONSULTAS Y OPERACIONES DML
-- Base de datos: Sakila
-- Archivo: respuestas_examen_final.sql

-- ========================================
-- PARTE 2 - Consultas SQL
-- ========================================

-- 1. Categorías y número total de películas
-- Devuelve el nombre de todas las categorías y el número total de películas que pertenecen a cada una
SELECT 
    c.name AS categoria,
    COUNT(fc.film_id) AS total_peliculas
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.category_id, c.name
ORDER BY c.name;

-- 2. Actores cuyo apellido contenga 'GEN', ordenados por apellido descendente
-- Muestra el nombre y apellido de los actores cuyo apellido contenga la cadena 'GEN'
SELECT 
    first_name AS nombre,
    last_name AS apellido
FROM actor
WHERE last_name LIKE '%GEN%'
ORDER BY last_name DESC;

-- 3. Películas sin inventario
-- Devuelve los títulos de las películas que no tienen ningún inventario asociado
SELECT 
    f.title AS titulo
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
WHERE i.film_id IS NULL
ORDER BY f.title;

-- 4. Clientes por tienda con más de 100 clientes
-- Consulta el número total de clientes por tienda, solo para tiendas con más de 100 clientes
SELECT 
    store_id AS tienda,
    COUNT(*) AS total_clientes
FROM customer
GROUP BY store_id
HAVING COUNT(*) > 100
ORDER BY store_id;

-- ========================================
-- PARTE 3 - Modificación de datos (DML)
-- ========================================

-- 1. Insertar nueva promoción "Spring Sale"
-- Con start_date: fecha de hoy, end_date: 30 días después, store_id = 1
INSERT INTO promotion (title, start_date, end_date, store_id)
VALUES (
    'Spring Sale',
    CURDATE(),
    DATE_ADD(CURDATE(), INTERVAL 30 DAY),
    1
);

-- 2. Cambiar active a 0 para clientes con más de 20 pagos (store_id=1)
-- Actualiza el campo active para clientes de la tienda 1 que tengan más de 20 pagos
-- Solución con tabla temporal para garantizar compatibilidad con Safe Update Mode

-- Crear tabla temporal con los customer_id que cumplen las condiciones
CREATE TEMPORARY TABLE temp_customers_to_update AS
SELECT c.customer_id
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
WHERE c.store_id = 1
GROUP BY c.customer_id
HAVING COUNT(p.payment_id) > 20;

-- Actualizar usando INNER JOIN con la tabla temporal (Safe Mode compatible)
UPDATE customer c
INNER JOIN temp_customers_to_update temp ON c.customer_id = temp.customer_id
SET c.active = 0;

-- Limpiar tabla temporal
DROP TEMPORARY TABLE temp_customers_to_update;

-- 3. Eliminar clientes antiguos sin rentals
-- Elimina clientes con create_date anterior a 2006-01-01 y sin alquileres
-- Solución con tabla temporal para garantizar compatibilidad con Safe Update Mode
-- IMPORTANTE: Solo elimina clientes SIN pagos NI alquileres (por restricciones FK)

-- Crear tabla temporal con los customer_id que cumplen las condiciones
CREATE TEMPORARY TABLE temp_customers_to_delete AS
SELECT DISTINCT c.customer_id
FROM customer c
WHERE c.create_date < '2006-01-01'
AND c.customer_id NOT IN (
    -- Excluir clientes que tienen rentals
    SELECT DISTINCT r.customer_id 
    FROM rental r 
    WHERE r.customer_id IS NOT NULL
)
AND c.customer_id NOT IN (
    -- Excluir clientes que tienen payments (por constraint FK)
    SELECT DISTINCT p.customer_id 
    FROM payment p 
    WHERE p.customer_id IS NOT NULL
);

-- CREATE TEMPORARY TABLE temp_customers_to_delete AS SELECT DISTINCT c.customer_id FROM customer c WHERE c.create_date < '2006-01-01' AND c.customer_id NOT IN (     -- Excluir clientes que tienen rentals     SELECT DISTINCT r.customer_id      FROM rental r      WHERE r.customer_id IS NOT NULL ) AND c.customer_id NOT IN (     -- Excluir clientes que tienen payments (por constraint FK)     SELECT DISTINCT p.customer_id      FROM payment p      WHERE p.customer_id IS NOT NULL )
-- 0 row(s) affected Records: 0  Duplicates: 0  Warnings: 0

-- Eliminar usando INNER JOIN con la tabla temporal (Safe Mode compatible)
DELETE c FROM customer c
INNER JOIN temp_customers_to_delete temp ON c.customer_id = temp.customer_id;

-- DELETE c FROM customer c INNER JOIN temp_customers_to_delete temp ON c.customer_id = temp.customer_id
-- 0 row(s) affected

-- Limpiar tabla temporal
DROP TEMPORARY TABLE temp_customers_to_delete;

-- DROP TEMPORARY TABLE temp_customers_to_delete
-- 0 row(s) affected


-- ========================================
-- PARTE 4 - Procedimientos almacenados
-- ========================================

-- Procedimiento trasladarInventario
DELIMITER //

CREATE PROCEDURE trasladarInventario(
    IN origen TINYINT UNSIGNED,
    IN destino TINYINT UNSIGNED
)
BEGIN
    DECLARE origen_exists INT DEFAULT 0;
    DECLARE destino_exists INT DEFAULT 0;
    
    -- Comprobar que origen existe
    SELECT COUNT(*) INTO origen_exists 
    FROM store 
    WHERE store_id = origen;
    
    -- Comprobar que destino existe
    SELECT COUNT(*) INTO destino_exists 
    FROM store 
    WHERE store_id = destino;
    
    -- Validaciones
    IF origen_exists = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'La tienda de origen no existe';
    END IF;
    
    IF destino_exists = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'La tienda de destino no existe';
    END IF;
    
    IF origen = destino THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Las tiendas de origen y destino deben ser diferentes';
    END IF;
    
    -- Si todas las validaciones pasan, realizar el traslado
    UPDATE inventory 
    SET store_id = destino 
    WHERE store_id = origen;
    
END//

DELIMITER ;

-- trasladarInventario: Implementado con validaciones completas usando SIGNAL SQLSTATE
-- para manejo de errores. Verifico la existencia de tiendas y que sean diferentes antes
-- de realizar el UPDATE masivo del inventario.

-- CREATE PROCEDURE trasladarInventario(     IN origen TINYINT UNSIGNED,     IN destino TINYINT UNSIGNED ) BEGIN     DECLARE origen_exists INT DEFAULT 0;     DECLARE destino_exists INT DEFAULT 0;          -- Comprobar que origen existe     SELECT COUNT(*) INTO origen_exists      FROM store      WHERE store_id = origen;          -- Comprobar que destino existe     SELECT COUNT(*) INTO destino_exists      FROM store      WHERE store_id = destino;          -- Validaciones     IF origen_exists = 0 THEN         SIGNAL SQLSTATE '45000'          SET MESSAGE_TEXT = 'La tienda de origen no existe';     END IF;          IF destino_exists = 0 THEN         SIGNAL SQLSTATE '45000'          SET MESSAGE_TEXT = 'La tienda de destino no existe';     END IF;          IF origen = destino THEN         SIGNAL SQLSTATE '45000'          SET MESSAGE_TEXT = 'Las tiendas de origen y destino deben ser diferentes';     END IF;          -- Si todas las validaciones pasan, realizar el traslado     UPDATE inventory      SET store_id = destino      WHERE store_id = origen;      END
-- 0 row(s) affected

-- Verificar procedimiento (ejemplo de uso)
CALL trasladarInventario(1, 2);

-- La llamada al procedimiento se ejecuto correctamente
-- CALL trasladarInventario(1, 2)
-- 2270 row(s) affected

-- ========================================
-- PARTE 5 - Triggers
-- ========================================

-- 1. Crear tabla bitacora_bajas_customer
CREATE TABLE bitacora_bajas_customer (
    id INT AUTO_INCREMENT,
    customer_id SMALLINT UNSIGNED,
    delete_date DATETIME,
    full_name VARCHAR(100),
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Creo la Tabla bitacora_bajas_customer para auditoría de eliminaciones.

-- CREATE TABLE bitacora_bajas_customer (     id INT AUTO_INCREMENT,     customer_id SMALLINT UNSIGNED,     delete_date DATETIME,     full_name VARCHAR(100),     PRIMARY KEY (id) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
-- 0 row(s) affected

-- 2. Crear trigger after_delete_customer
DELIMITER //

CREATE TRIGGER after_delete_customer
    AFTER DELETE ON customer
    FOR EACH ROW
BEGIN
    INSERT INTO bitacora_bajas_customer (
        customer_id, 
        delete_date, 
        full_name
    ) VALUES (
        OLD.customer_id,
        NOW(),
        CONCAT(OLD.first_name, ' ', OLD.last_name)
    );
END//

DELIMITER ;

-- Captura automáticamente datos del registro eliminado usando OLD.* y registra timestamp con NOW().

-- CREATE TRIGGER after_delete_customer     AFTER DELETE ON customer     FOR EACH ROW BEGIN     INSERT INTO bitacora_bajas_customer (         customer_id,          delete_date,          full_name     ) VALUES (         OLD.customer_id,         NOW(),         CONCAT(OLD.first_name, ' ', OLD.last_name)     ); END
-- 0 row(s) affected

-- Para verificar borro una fila 
-- '1', '2', '2025-06-04 19:49:12', 'PATRICIA JOHNSON'
-- Verificar tabla bitácora (después de eliminar clientes)
SELECT * FROM bitacora_bajas_customer;

-- devuelve '1', '2', '2025-06-04 19:49:12', 'PATRICIA JOHNSON'


-- FIN DEL EXAMEN
