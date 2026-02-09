# 📋 Plantilla Genérica - Examen Final Bases de Datos

## 📝 **Estructura General del Examen**

### **Tiempo típico:** 2-3 horas
### **Puntuación:** 10 puntos distribuidos en 5 partes
### **Archivos a entregar:** 2 scripts SQL comentados

---

## 🔧 **Script 1: `examen_final_modificaciones.sql`**


-- ========================================
-- NOMBRE: [Tu Nombre Completo]
-- CURSO: [Tu Curso]
-- FECHA: [Fecha del examen]
-- ========================================

-- ========================================
-- PARTE 1: AMPLIACIÓN DEL MODELO ([X] puntos)
-- Tiempo estimado: [XX] minutos
-- ========================================

-- [Apartado 1.1] - Modificación de tabla existente
-- Justificación: [Explicar por qué se realiza esta modificación]
[COMANDO ALTER TABLE para añadir/modificar campos]

-- [Apartado 1.2] - Creación de nueva tabla
-- Justificación: [Explicar la funcionalidad de la nueva tabla]
[COMANDO CREATE TABLE con todas las restricciones necesarias]

-- [Apartado 1.3] - Creación de índices
-- Justificación: [Explicar qué consultas se optimizan]
[COMANDO CREATE INDEX sobre campos específicos]

-- [Apartado 1.X] - Otras modificaciones estructurales
-- [Añadir más modificaciones según el examen específico]

-- ========================================
-- PARTE 4: PROCEDIMIENTOS ALMACENADOS ([X] puntos)
-- Tiempo estimado: [XX] minutos
-- ========================================

-- [Apartado 4.1] - Procedimiento principal
-- Justificación: [Explicar la lógica del procedimiento]
DELIMITER $$

CREATE PROCEDURE [nombre_procedimiento](
    [Parámetros IN/OUT con tipos]
)
BEGIN
    [Declaración de variables locales]
    
    [Validaciones con IF y manejo de errores]
    
    [Lógica principal del procedimiento]
    
    [Uso de SIGNAL SQLSTATE para errores personalizados]
    
END$$

DELIMITER ;

-- ========================================
-- PARTE 5: TRIGGERS ([X] puntos)
-- Tiempo estimado: [XX] minutos
-- ========================================

-- [Apartado 5.1] - Tabla de auditoría/log
-- Justificación: [Explicar para qué sirve esta tabla]
CREATE TABLE [nombre_tabla_auditoria] (
    [Campos necesarios para el registro de eventos]
);

-- [Apartado 5.2] - Trigger de auditoría
-- Justificación: [Explicar qué eventos se registran y por qué]
DELIMITER $$

CREATE TRIGGER [nombre_trigger]
    [BEFORE/AFTER] [INSERT/UPDATE/DELETE] ON [tabla]
    FOR EACH ROW
BEGIN
    [Lógica del trigger usando OLD y NEW]
END$$

DELIMITER ;


---

## 📊 **Script 2: `respuestas_examen_final.sql`**


-- ========================================
-- NOMBRE: [Tu Nombre Completo]
-- CURSO: [Tu Curso]
-- FECHA: [Fecha del examen]
-- ========================================

-- ========================================
-- PARTE 2: CONSULTAS SQL ([X] puntos)
-- Tiempo estimado: [XX] minutos
-- ========================================

-- [Apartado 2.1] - Consulta con JOIN y agregación
-- Justificación: [Explicar el tipo de JOIN usado y por qué]
[SELECT con JOIN para relacionar tablas y funciones de agregación]

-- [Apartado 2.2] - Consulta con filtrado y ordenación
-- Justificación: [Explicar criterios de filtrado y ordenación]
[SELECT con WHERE, LIKE, ORDER BY según criterios específicos]

-- [Apartado 2.3] - Consulta para encontrar registros sin relación
-- Justificación: [Explicar la lógica para encontrar registros huérfanos]
[SELECT con LEFT JOIN y WHERE IS NULL]

-- [Apartado 2.4] - Consulta con agrupación y filtrado de grupos
-- Justificación: [Explicar diferencia entre WHERE y HAVING]
[SELECT con GROUP BY y HAVING para filtrar grupos]

-- [Apartado 2.X] - Consultas adicionales
-- [Añadir más consultas según el examen específico]

-- ========================================
-- PARTE 3: MODIFICACIÓN DE DATOS (DML) ([X] puntos)
-- Tiempo estimado: [XX] minutos
-- ========================================

-- [Apartado 3.1] - Inserción de datos
-- Justificación: [Explicar valores calculados o funciones usadas]
INSERT INTO [tabla] ([campos])
VALUES ([valores con funciones de fecha u otros cálculos]);

-- [Apartado 3.2] - Actualización masiva
-- Justificación: [Explicar criterios de actualización]
UPDATE [tabla]
SET [campo] = [nuevo_valor]
WHERE [condiciones específicas];

-- [Apartado 3.3] - Eliminación condicional
-- Justificación: [Explicar criterios de eliminación y posibles efectos]
DELETE FROM [tabla]
WHERE [condiciones múltiples];

-- ========================================
-- VERIFICACIONES Y CONSULTAS DE COMPROBACIÓN
-- ========================================

-- Verificar estructura modificada
DESCRIBE [tabla_modificada];

-- Verificar datos insertados
SELECT * FROM [tabla] WHERE [condición_verificación];

-- Verificar cambios realizados
SELECT [campos_relevantes] FROM [tabla] WHERE [condición_cambios];

-- Verificar funcionamiento de triggers (si aplica)
SELECT * FROM [tabla_auditoria];

-- Ejemplo de uso del procedimiento
-- CALL [nombre_procedimiento]([parámetros_ejemplo]);

-- Verificar índices creados
SHOW INDEX FROM [tabla];




## 📚 **Metodología de Resolución**

### **📋 Antes de Empezar:**
1. **Lee todo el examen** completo antes de comenzar
2. **Identifica las dependencias** entre apartados
3. **Planifica el tiempo** por cada parte
4. **Revisa la base de datos** proporcionada para entender la estructura

### **🔍 Para Cada Apartado:**
1. **Lee el enunciado 2-3 veces** hasta entenderlo completamente
2. **Identifica** qué tipo de operación necesitas (DDL, DML, consulta)
3. **Piensa en la lógica** antes de escribir código
4. **Escribe comentarios** explicando tu razonamiento
5. **Verifica** que tu solución cumple todos los requisitos

### **✅ Lista de Verificación por Partes:**

#### **Parte 1 - Ampliación del Modelo:**
- [ ] ¿He usado el tipo de dato correcto para cada campo?
- [ ] ¿He puesto todas las restricciones necesarias (NOT NULL, UNIQUE, etc.)?
- [ ] ¿Las claves foráneas tienen las acciones ON DELETE/UPDATE apropiadas?
- [ ] ¿Los índices están en los campos que realmente se consultan?
- [ ] ¿He justificado cada modificación?

#### **Parte 2 - Consultas SQL:**
- [ ] ¿He usado el tipo de JOIN adecuado para cada consulta?
- [ ] ¿Las condiciones WHERE filtran correctamente?
- [ ] ¿He usado funciones de agregación donde es necesario?
- [ ] ¿El ORDER BY ordena según lo pedido?
- [ ] ¿He manejado valores NULL correctamente?

#### **Parte 3 - Modificación de datos:**
- [ ] ¿Los INSERT respetan todas las restricciones?
- [ ] ¿Los UPDATE modifican solo los registros correctos?
- [ ] ¿Los DELETE no violan integridad referencial?
- [ ] ¿He usado funciones de fecha correctamente?

#### **Parte 4 - Procedimientos:**
- [ ] ¿He declarado correctamente los parámetros IN/OUT?
- [ ] ¿Valido que los datos de entrada son correctos?
- [ ] ¿Manejo todos los casos de error posibles?
- [ ] ¿Los mensajes de error son descriptivos?
- [ ] ¿He usado DELIMITER correctamente?

#### **Parte 5 - Triggers:**
- [ ] ¿El trigger se dispara en el momento correcto (BEFORE/AFTER)?
- [ ] ¿Uso OLD y NEW apropiadamente?
- [ ] ¿La tabla de auditoría guarda toda la información necesaria?
- [ ] ¿He considerado todos los efectos secundarios?

---

## 🎯 **Estrategias de Tiempo**

### **Distribución Recomendada:**
| Parte | Tiempo | Estrategia |
|-------|--------|------------|
| **Lectura inicial** | 5 min | Entender todo el examen |
| **Parte 1** | 25 min | Empezar por lo más fácil |
| **Parte 2** | 25 min | Verificar cada consulta |
| **Parte 3** | 20 min | Cuidado con las restricciones |
| **Parte 4** | 25 min | Más tiempo para validaciones |
| **Parte 5** | 20 min | Probar el trigger |
| **Revisión** | 15 min | Verificar todo funciona |

### **Consejos de Gestión del Tiempo:**
- **No te atasques** en un apartado, sigue adelante
- **Deja comentarios** aunque no termines la implementación
- **Prioriza** los apartados que más puntos valen
- **Reserva tiempo** para verificaciones al final

---

## 🚨 **Errores Frecuentes a Evitar**

### **Errores Técnicos:**
- Olvidar `DELIMITER $$` en procedimientos y triggers
- Confundir `HAVING` con `WHERE`
- No manejar valores `NULL` en `JOIN`
- Usar `COUNT(campo)` en lugar de `COUNT(*)`
- No validar parámetros en procedimientos

### **Errores de Planificación:**
- No leer todo el enunciado antes de empezar
- No reservar tiempo para verificaciones
- Intentar hacer todo perfecto en lugar de completar todo
- No comentar el código adecuadamente

### **Errores de Presentación:**
- No poner nombre y curso en los scripts
- No organizar el código en secciones comentadas
- No justificar las decisiones tomadas
- Entregar scripts que no se pueden ejecutar

---

## 📝 **Plantilla de Comentarios**


-- ========================================
-- APARTADO [X.Y]: [Descripción breve]
-- ========================================
-- OBJETIVO: [Qué se quiere conseguir]
-- ESTRATEGIA: [Cómo se va a resolver]
-- CONSIDERACIONES: [Aspectos importantes a tener en cuenta]
-- ========================================

[Código SQL aquí]

-- VERIFICACIÓN: [Cómo comprobar que funciona]
-- RESULTADO ESPERADO: [Qué debería devolver/hacer]


---

## 🔗 **Comandos de Referencia Rápida**

### **Modificación de Estructura:**
- `ALTER TABLE ... ADD COLUMN ...`
- `ALTER TABLE ... MODIFY COLUMN ...`
- `CREATE TABLE ... (PRIMARY KEY, FOREIGN KEY)`
- `CREATE INDEX ... ON ...`

### **Consultas Esenciales:**
- `SELECT ... FROM ... JOIN ... ON ...`
- `WHERE ... LIKE ...`
- `GROUP BY ... HAVING ...`
- `ORDER BY ... ASC/DESC`

### **Manipulación de Datos:**
- `INSERT INTO ... VALUES ...`
- `UPDATE ... SET ... WHERE ...`
- `DELETE FROM ... WHERE ...`

### **Programación:**
- `CREATE PROCEDURE ... BEGIN ... END`
- `CREATE TRIGGER ... FOR EACH ROW`
- `SIGNAL SQLSTATE ... SET MESSAGE_TEXT`

### **Funciones Útiles:**
- `NOW()`, `CURDATE()`, `DATE_ADD()`
- `COUNT()`, `SUM()`, `AVG()`, `MAX()`, `MIN()`
- `CONCAT()`, `SUBSTRING()`, `UPPER()`, `LOWER()`