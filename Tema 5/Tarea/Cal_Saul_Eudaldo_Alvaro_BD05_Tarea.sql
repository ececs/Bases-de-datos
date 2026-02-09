/*
2. He omitido el codigo ya que es autoincremental asi que cada ves que se inserta un registro se 
incrementa automaticamente
*/
INSERT INTO PROFESORADO (Nombre, Apellidos, DNI, Especialidad, Fecha_Nac, Antiguedad)
VALUES 
    ('MARIA LUISA', 'FABRE BERDUN', '51083099F', 'TECNOLOGIA', '1975-03-31', 4),
    ('JAVIER', 'JIMENEZ HERNANDO', NULL, 'LENGUA', '1969-05-04', 10),
    ('ESTEFANIA', 'FERNANDEZ MARTINEZ', '19964324W', 'INGLES', '1973-06-22', 5),
    ('JOSE M.', 'ANERO PAYAN', NULL, 'LENGUA', NULL, 5);
    

/*
4.
*/

UPDATE PROFESORADO
SET Fecha_Nac = '1974-06-22', Antiguedad = 4
WHERE Nombre = 'ESTEFANIA';

/*
Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE 
that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and 
reconnect.

"safe update mode" (modo de actualización segura), que evita que ejecutemos actualizaciones masivas
 sin una cláusula WHERE que use una columna clave.
*/

/*Por lo que actualizamos usando la clave primaria en la clausula WHERE*/

UPDATE PROFESORADO
SET Fecha_Nac = '1974-06-22', Antiguedad = 4
WHERE Codigo = 4;

/*
5. Usamos una condición que afecte a todos los registros y mencione la clave primaria.
*/
UPDATE PROFESORADO 
SET Antiguedad = Antiguedad + 1
WHERE Codigo IS NOT NULL;

/*
7. Esta instrucción SQL elimina en una sola operación todos los alumnos que estén 
asignados al curso con código 3
*/

DELETE FROM ALUMNADO WHERE Cod_Curso = 3;

/*
8. Esta sentencia copia todos los registros de la tabla ALUMNADO_NUEVO a la tabla ALUMNADO
*/

INSERT INTO ALUMNADO (Nombre, Apellidos, Sexo, Fecha_Nac, Cod_Curso)
SELECT Nombre, Apellidos, Sexo, Fecha_Nac, NULL
FROM ALUMNADO_NUEVO;

/*
9. Utilizamos una subconsulta para contar el número de alumnos en la tabla ALUMNADO cuyo 
Cod_Curso es igual a 2
*/

UPDATE CURSOS
SET Max_Alumn = (SELECT COUNT(*) FROM ALUMNADO WHERE Cod_Curso = 2) 
WHERE Codigo = 2;

/*
10. Para eliminar de la tabla ALUMNADO todos los registros asociados a cursos impartidos por 
la profesora "NURIA", necesitamos crear una consulta SQL que relacione CURSOS con PROFESORADO
*/

DELETE FROM ALUMNADO
WHERE Cod_Curso IN (
    SELECT c.Codigo
    FROM CURSOS c
    JOIN PROFESORADO p ON c.Cod_Profe = p.Codigo
    WHERE p.Nombre = 'NURIA'
);


