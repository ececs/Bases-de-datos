/*
Inserta un nuevo profesor en la tabla PROFESORADO con los siguientes datos:

Campo	Valor
Nombre	MARTA
Apellidos	GOMEZ LOPEZ
DNI	78299011K
Especialidad	BIOLOGÍA
Fecha_Nac	1983-06-22
Antiguedad	6
*/

SELECT Codigo, Nombre, Apellidos, DNI, Especialidad, Fecha_Nac, Antiguedad
FROM PROFESORADO
WHERE codigo = 4;


/*
2. Actualización de antigüedad por especialidad (1 punto)
Enunciado:
Actualiza la antigüedad de todos los profesores cuya especialidad sea INFORMÁTICA o MATEMÁTICAS, 
incrementándola en 2 años.
*/

UPDATE PROFESORADO
SET Antiguedad = Antiguedad + 2
WHERE Especialidad IN ('INFORMÁTICA', 'MATEMÁTICAS');


/*
Inserta todos los registros de ALUMNADO_NUEVO en la tabla ALUMNADO, asignando el curso 
con Codigo = 2 a todos.
*/

INSERT INTO ALUMNADO (Nombre, Apellidos, Sexo, Fecha_Nac, Cod_Curso)
SELECT Nombre, Apellidos, Sexo, Fecha_Nac, 2
FROM ALUMNADO_NUEVO;


/*
Elimina de ALUMNADO todos los alumnos matriculados en cursos impartidos por profesores 
con más de 15 años de antigüedad.
*/


DELETE A
FROM ALUMNADO A
JOIN CURSOS C ON A.codigo = C.codigo
JOIN PROFESORADO P ON C.codigo = P.codigo
WHERE P.antiguedad > 15;




