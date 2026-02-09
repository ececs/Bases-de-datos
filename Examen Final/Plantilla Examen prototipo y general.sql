# 📋 Plantilla Completa - Examen Final Bases de Datos

## 🔧 **Script 1: `examen_final_modificaciones.sql`**


-- ========================================
-- NOMBRE: Eudaldo Alvaro Cal Saul
-- CURSO: 1º DAW BAE Grupo A
-- FECHA: 04/10/2025
-- ========================================

-- ========================================
-- PARTE 1: AMPLIACIÓN DEL MODELO (2 puntos)
-- ========================================

-- 1.1 Añadir campo email a tabla agentes
-- Justificación: Se añade campo único y no nulo para gestionar comunicaciones

ALTER TABLE agentes 
ADD COLUMN email VARCHAR(100) UNIQUE NOT NULL;

-- 1.2 Crear tabla misiones
-- Justificación: Nueva entidad para gestionar asignaciones de trabajo
SET SQL_SAFE_UPDATES = 0;
CREATE TABLE misiones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(100) NOT NULL,
    fecha_inicio DATE,
    fecha_fin DATE,
    agente_id INT,
    FOREIGN KEY (agente_id) REFERENCES agentes(identificador) ON DELETE CASCADE
);
SET SQL_SAFE_UPDATES = 1;

-- 1.3 Crear índice sobre fecha_inicio
-- Justificación: Mejora rendimiento en consultas por fecha
CREATE INDEX idx_fecha_inicio ON misiones(fecha_inicio);

-- ========================================
-- PARTE 4: PROCEDIMIENTOS ALMACENADOS (2 puntos)
-- ========================================

-- 4.1 Procedimiento trasladarAgentesOficina
-- Justificación: Automatiza el traslado masivo de agentes entre oficinas
DELIMITER $$

CREATE PROCEDURE trasladarAgentesOficina(
    IN origen INT,
    IN destino INT
)
BEGIN
    DECLARE origen_count INT DEFAULT 0;
    DECLARE destino_count INT DEFAULT 0;
    
    -- Verificar que las oficinas existen
    SELECT COUNT(*) INTO origen_count FROM oficinas WHERE identificador = origen;
    SELECT COUNT(*) INTO destino_count FROM oficinas WHERE identificador = destino;
    
    -- Validaciones
    IF origen_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La oficina de origen no existe';
    END IF;
    
    IF destino_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La oficina de destino no existe';
    END IF;
    
    IF origen = destino THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Las oficinas de origen y destino deben ser diferentes';
    END IF;
    
    -- Realizar el traslado
    UPDATE agentes 
    SET oficina = destino 
    WHERE oficina = origen;
    
END$$

DELIMITER ;

-- ========================================
-- PARTE 5: TRIGGERS (2 puntos)
-- ========================================

-- 5.1 Crear tabla bitacora_bajas
-- Justificación: Auditoría de eliminaciones de agentes
CREATE TABLE bitacora_bajas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    agente_id INT,
    fecha_baja DATETIME,
    nombre_agente VARCHAR(100)
);

-- 5.2 Crear trigger after_delete_agente
-- Justificación: Registro automático de bajas para auditoría
DELIMITER $$

CREATE TRIGGER after_delete_agente
    AFTER DELETE ON agentes
    FOR EACH ROW
BEGIN
    INSERT INTO bitacora_bajas (agente_id, fecha_baja, nombre_agente)
    VALUES (OLD.identificador, NOW(), OLD.nombre);
END$$

DELIMITER ;


/*

## 📊 **Script 2: `respuestas_examen_final.sql`**

sql
-- ========================================
-- NOMBRE: [Tu Nombre Completo]
-- CURSO: [Tu Curso - ej: 1º DAW BAE]
-- FECHA: [Fecha del examen]
-- ========================================

-- ========================================
-- PARTE 2: CONSULTAS SQL (2 puntos)
-- ========================================

-- 2.1 Nombre de oficinas y número total de agentes
-- Justificación: LEFT JOIN para incluir oficinas sin agentes
SELECT 
    o.nombre AS oficina,
    COUNT(a.identificador) AS total_agentes
FROM oficinas o
LEFT JOIN agentes a ON o.identificador = a.oficina
GROUP BY o.identificador, o.nombre
ORDER BY total_agentes DESC;

-- 2.2 Agentes con 'García' en el nombre, ordenados por habilidad
-- Justificación: LIKE para búsqueda de subcadena, ORDER BY DESC
SELECT 
    nombre,
    habilidad
FROM agentes
WHERE nombre LIKE '%García%'
ORDER BY habilidad DESC;

-- 2.3 Familias sin agentes asociados
-- Justificación: LEFT JOIN con WHERE NULL para encontrar registros sin relación
SELECT 
    f.nombre AS familia_sin_agentes
FROM familias f
LEFT JOIN agentes a ON f.identificador = a.familia
WHERE a.familia IS NULL;

-- 2.4 Total de agentes por categoría (solo categorías > 0)
-- Justificación: GROUP BY con HAVING para filtrar grupos
SELECT 
    categoria,
    COUNT(*) AS total_agentes
FROM agentes
WHERE categoria > 0
GROUP BY categoria
ORDER BY categoria;

-- ========================================
-- PARTE 3: MODIFICACIÓN DE DATOS (DML) (2 puntos)
-- ========================================

-- 3.1 Insertar nueva misión
-- Justificación: DATE_ADD para calcular fecha fin automáticamente
INSERT INTO misiones (titulo, fecha_inicio, fecha_fin, agente_id)
VALUES (
    'Operación Eclipse',
    CURDATE(),
    DATE_ADD(CURDATE(), INTERVAL 15 DAY),
    1113
);

-- 3.2 Cambiar categoría de agentes con habilidad > 8
-- Justificación: UPDATE con WHERE para modificación condicional
UPDATE agentes
SET categoria = 3
WHERE habilidad > 8;

-- 3.3 Eliminar agentes categoría 0 sin oficina
-- Justificación: DELETE con múltiples condiciones
DELETE FROM agentes
WHERE categoria = 0 AND oficina IS NULL;

-- ========================================
-- VERIFICACIONES Y CONSULTAS DE COMPROBACIÓN
-- ========================================

-- Verificar estructura de tabla agentes después de modificaciones
DESCRIBE agentes;

-- Verificar datos insertados en misiones
SELECT * FROM misiones WHERE titulo = 'Operación Eclipse';

-- Verificar cambios de categoría
SELECT nombre, habilidad, categoria 
FROM agentes 
WHERE habilidad > 8;

-- Verificar tabla bitacora_bajas (si se han eliminado agentes)
SELECT * FROM bitacora_bajas;

-- Comprobar funcionamiento del procedimiento (ejemplo)
-- CALL trasladarAgentesOficina(1, 2);

-- Verificar índices creados
SHOW INDEX FROM misiones;


---

## 📚 **Guía de Referencia Rápida**

### **Comandos DDL Esenciales:**

-- Modificar tabla
ALTER TABLE nombre_tabla ADD COLUMN campo TIPO restricciones;
ALTER TABLE nombre_tabla DROP COLUMN campo;
ALTER TABLE nombre_tabla MODIFY COLUMN campo NUEVO_TIPO;

-- Crear tabla
CREATE TABLE nombre (
    campo TIPO restricciones,
    PRIMARY KEY (campo),
    FOREIGN KEY (campo) REFERENCES tabla(campo) ON DELETE CASCADE
);

-- Índices
CREATE INDEX nombre_indice ON tabla(campo);
DROP INDEX nombre_indice ON tabla;
```

### **Comandos DML Esenciales:**
```sql
-- Insertar
INSERT INTO tabla (campos) VALUES (valores);

-- Actualizar
UPDATE tabla SET campo = valor WHERE condicion;

-- Eliminar
DELETE FROM tabla WHERE condicion;


### **Consultas JOIN Comunes:**

-- Inner Join
SELECT campos FROM tabla1 t1 
JOIN tabla2 t2 ON t1.campo = t2.campo;

-- Left Join (incluye registros sin coincidencia)
SELECT campos FROM tabla1 t1 
LEFT JOIN tabla2 t2 ON t1.campo = t2.campo;

-- Encontrar registros sin relación
SELECT t1.* FROM tabla1 t1 
LEFT JOIN tabla2 t2 ON t1.id = t2.tabla1_id 
WHERE t2.tabla1_id IS NULL;


### **Funciones de Agregación:**

COUNT(*) -- Contar filas
SUM(campo) -- Sumar valores
AVG(campo) -- Promedio
MAX(campo) -- Valor máximo
MIN(campo) -- Valor mínimo

-- Agrupación y filtrado
GROUP BY campo
HAVING condicion -- Filtrar grupos
ORDER BY campo ASC/DESC


### **Funciones de Fecha:**

NOW() -- Fecha y hora actual
CURDATE() -- Fecha actual
DATE_ADD(fecha, INTERVAL n TIPO) -- Sumar tiempo
DATEDIFF(fecha1, fecha2) -- Diferencia en días


### **Procedimientos y Triggers:**

-- Procedimiento básico
DELIMITER $$
CREATE PROCEDURE nombre(parametros)
BEGIN
    -- Lógica del procedimiento
    IF condicion THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error personalizado';
    END IF;
END$$
DELIMITER ;

-- Trigger básico
DELIMITER $$
CREATE TRIGGER nombre
    BEFORE/AFTER INSERT/UPDATE/DELETE ON tabla
    FOR EACH ROW
BEGIN
    -- Usar OLD.campo para valores anteriores
    -- Usar NEW.campo para valores nuevos
END$$
DELIMITER ;


/*### **Estados SQL Comunes:**
-- `'45000'` - Error general definido por usuario
-- `'23000'` - Violación de restricción de integridad
-- `'42000'` - Error de sintaxis

-- ### **Consejos para el Examen:**
1. **Lee cada enunciado dos veces** antes de empezar
2. **Comenta tu código** explicando la lógica
3. **Usa nombres descriptivos** para variables y procedimientos
4. **Verifica las restricciones** antes de insertar datos
5. **Prueba tus consultas** con datos de ejemplo
6. **Gestiona errores** en procedimientos almacenados
7. **Usa transacciones** cuando sea necesario
8. **Revisa la sintaxis** de JOINs y subconsultas

### **Errores Comunes a Evitar:**
- Olvidar el `DELIMITER` en procedimientos/triggers
- No manejar valores NULL en JOINs
- Usar COUNT() en lugar de COUNT(*) 
- Olvidar el `ON DELETE CASCADE` en claves foráneas
- No validar parámetros en procedimientos
- Confundir HAVING con WHERE