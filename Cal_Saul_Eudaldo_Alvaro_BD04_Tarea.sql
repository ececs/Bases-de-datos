/*
1. Obtener los nombres y salarios de los empleados con más de 1000 euros de salario 
por orden alfabético.
*/
-- Se seleccionan los nombres y salarios de la tabla de empleado, filtrando los salarios
-- superiores a 1000 y ordenándolos alfabéticamente.

SELECT nombre, salario
FROM empleado
WHERE salario > 1000
ORDER BY nombre ASC;

/*
2. Obtener el nombre de los empleados cuya comisión es superior al 20% de su salario.
*/
-- La condición compara la comisión con el 20% del salario de cada empleado.
SELECT nombre
FROM empleado
WHERE comision > (0.2 * salario);

/*
3. Obtener el código de empleado, código de departamento, nombre y sueldo total en pesetas
de aquellos empleados cuyo sueldo total (salario más comisión) supera los 1800 euros.
*/
-- Se calcula el sueldo total como la suma de salario y comisión, convirtiéndolo a pesetas,
-- y se filtran los casos en que supera 1800 euros.
SELECT codemple, coddpto, nombre, (salario + comision) * 166 AS sueldo_total_pesetas
FROM empleado
WHERE (salario + comision) > 1800
ORDER BY coddpto, nombre;

/*
4. Obtener por orden alfabético los nombres de empleados cuyo salario igualen o superen en
más de un 5% al salario de la empleada ‘MARIA JAZMIN’.
*/
-- Se utiliza una subconsulta para obtener el salario de 'MARIA JAZMIN', aplicando el 
-- cálculo del 5% y filtrando.
SELECT nombre
FROM empleado
WHERE salario >= (1.05 * (SELECT salario FROM empleado WHERE nombre = 'MARIA' AND ape1 = 'JAZMIN'))
ORDER BY nombre;

/*
5. Obtener un listado ordenado por años en la empresa con los nombres, apellidos de los 
empleados y los años de antigüedad en la empresa.
*/
-- Se calcula la antigüedad restando el año actual al año de contratación y se ordena por 
-- antigüedad.
SELECT nombre, ape1, ape2, YEAR(CURDATE()) - YEAR(fechaingreso) AS antiguedad
FROM empleado
ORDER BY antiguedad DESC;

/*
6. Obtener el nombre de los empleados que trabajan en un departamento con presupuesto 
superior a 50.000 euros.
*/
-- Se utiliza una subconsulta para filtrar los códigos de departamentos con presupuestos
-- mayores a 50.000.
SELECT nombre
FROM empleado
WHERE coddpto IN (
    SELECT coddpto
    FROM dpto
    WHERE presupuesto > 50000
);

/*
7. Obtener los nombres y apellidos de empleados que más cobran en la empresa.
*/
-- Se calcula el salario total como la suma de salario y comisión, reemplazando null por 0,
-- se ordena por salario total en orden descendente y se limita a los 3 que más cobran.
SELECT nombre, ape1, ape2, (salario + COALESCE(comision, 0)) AS salarioTotal
FROM empleado
ORDER BY salarioTotal DESC
LIMIT 3;

/*
8. Obtener en orden alfabético los nombres de empleados cuyo salario es inferior al mínimo
de los empleados del departamento 1
*/
-- Se obtiene el salario mínimo del departamento 1 mediante una subconsulta y se compara.
SELECT nombre
FROM empleado
WHERE salario < (
    SELECT MIN(salario)
    FROM empleado
    WHERE coddpto = 1
)
ORDER BY nombre;

/*
9. Obtener los nombres de empleados que trabajan en el departamento del cuál es jefe el 
empleado con código 1.
*/
-- Se identifica el departamento del jefe con código 1 y se seleccionan los empleados 
-- correspondientes.
SELECT nombre
FROM empleado
WHERE coddpto = (
    SELECT coddpto
    FROM empleado
    WHERE codemple = 1
);

/*
10. Obtener los nombres de los empleados cuyo primer apellido empiece por las letras 
P, Q, R, S.
*/
-- Se filtran los apellidos que comienzan con las letras P, Q, R o S usando LIKE.
SELECT nombre
FROM empleado
WHERE ape1 LIKE 'P%' OR ape1 LIKE 'Q%' OR ape1 LIKE 'R%' OR ape1 LIKE 'S%';

/*
11. Obtener los empleados cuyo nombre de pila contenga el nombre JUAN.
*/
-- Se busca el patrón 'JUAN' en el nombre del empleado con LIKE.
SELECT nombre, ape1, ape2, codemple
FROM empleado
WHERE nombre LIKE '%JUAN%';

/*
12. Obtener los nombres de los empleados que viven en ciudades en las que hay
algún centro de trabajo.
*/
-- Se seleccionan empleados cuya ciudad de residencia coincide con las localidades de centros.
SELECT nombre
FROM empleado
WHERE localidad IN (
    SELECT localidad
    FROM centro
);

/*
13. Obtener el nombre del jefe de departamento que tiene mayor salario de entre los jefes 
de departamento.
*/
-- Se usa subconsulta en combinacion con un JOIN para identificar los empleados que son jefe 
-- de departamento y que tienen el salario más alto
SELECT e.nombre
FROM empleado e
JOIN dpto d ON e.codemple = d.codemplejefe
WHERE e.salario = (
    SELECT MAX(e2.salario)
    FROM empleado e2
    JOIN dpto d2 ON e2.codemple = d2.codemplejefe
);

/*
14. Obtener en orden alfabético los salarios y nombres de los empleados cuyo salario sea 
superior al 60% del máximo salario de la empresa.
*/
-- Se calcula el 60% del salario máximo usando una subconsulta y se seleccionan los 
-- empleados que lo cumplen.
SELECT salario, nombre
FROM empleado
WHERE salario > (0.6 * (SELECT MAX(salario) FROM empleado))
ORDER BY nombre;

/*
15. Obtener en cuántas ciudades distintas viven los empleados.
*/
-- Se utiliza DISTINCT para contar las ciudades únicas.
SELECT COUNT(DISTINCT localidad) AS ciudades_distintas
FROM empleado;

/*
16. El nombre y apellidos del empleado que más salario cobra.
*/
-- Se selecciona el empleado con el salario máximo, si hay mas de uno con ese salario los 
-- muestra.
SELECT nombre, ape1, ape2
FROM empleado
WHERE salario = (SELECT MAX(salario) FROM empleado);

/*
17. Obtener las localidades y número de empleados de aquellas en las que 
viven más de 3 empleados.
*/
-- Se agrupan las localidades y se filtran aquellas con más de 3 empleados.
SELECT localidad, COUNT(*) AS numero_empleados
FROM empleado
GROUP BY localidad
HAVING COUNT(*) > 3;

/*
18. Obtener para cada departamento cuántos empleados trabajan, la suma de sus salarios
y la suma de sus comisiones para aquellos departamento en los que hay algún empleado 
cuyo salario es superior a 1700 euros.
*/
-- Se agrupan los datos por departamento y se calculan las sumas y el conteo.
SELECT coddpto, COUNT(*) AS numero_empleados, SUM(salario) AS suma_salarios, SUM(COALESCE(comision, 0)) AS suma_comisiones
FROM empleado
WHERE coddpto IN (
    SELECT coddpto
    FROM empleado
    WHERE salario > 1700
)
GROUP BY coddpto;

/*
19. Obtener el departamento que más empleados tiene.
*/
-- Se agrupan los empleados por departamento y se ordena en orden descendente, limitando 
-- al primero.
SELECT d.denominacion AS departamento, d.coddpto, COUNT(e.codemple) AS numero_empleados
FROM empleado e
JOIN dpto d ON e.coddpto = d.coddpto
GROUP BY d.coddpto
ORDER BY numero_empleados DESC
LIMIT 1;


/*
20. Obtener los nombres de todos los centros y los departamentos que se ubican en cada uno.
*/
-- Se utiliza una combinación LEFT JOIN para incluir los centros sin departamentos asociados.
SELECT centro.localidad AS nombreCentro, dpto.codcentro, dpto.denominacion AS nombreDepartamento
FROM centro
LEFT JOIN dpto ON centro.codcentro = dpto.codcentro;



/*
21. Obtener el nombre del departamento de más alto nivel, es decir, aquel que no depende 
de ningún otro.
*/
-- Se selecciona la el nombre de departamento que no depende de otro departamento
SELECT denominacion
FROM dpto
WHERE coddptodepende IS NULL;

/*
22. Obtener todos los departamentos existentes en la empresa y los empleados (si los tiene) 
que pertenecen a él.
*/
-- Se realiza un LEFT JOIN entre departamento y empleado para incluir todos los 
-- departamentos, incluso los que no tienen empleados.
SELECT d.denominacion, e.nombre, e.ape1, e.ape2
FROM dpto d
LEFT JOIN empleado e ON d.coddpto = e.coddpto
ORDER BY d.denominacion;

/*
23. Obtener un listado en el que aparezcan todos los departamentos existentes y el departamento 
del cual depende, si depende de alguno.
*/
-- Se utiliza un LEFT JOIN para incluir tanto los departamentos principales como de los 
-- que dependen .
SELECT d1.coddpto AS codigo_dpto, d1.denominacion AS departamento, d2.coddpto AS codigo_dpto_superior, d2.denominacion AS departamento_superior
FROM 
    dpto d1
LEFT JOIN 
    dpto d2 ON d1.coddptodepende = d2.coddpto
ORDER BY 
    d1.coddpto;

/*
24. Obtener un listado ordenado alfabéticamente donde aparezcan los nombres de los empleados y a 
continuación el literal "tiene comisión" si la tiene, y "no tiene comisión" si no la tiene.
*/
-- Se utiliza una cláusula CASE para comprobar si el empleado tiene comisión, agregando el 
-- literal correspondiente.
SELECT nombre, 
CASE 
    WHEN comision > 0 THEN 'tiene comisión'
    ELSE 'no tiene comisión'
END AS estado_comision
FROM empleado
ORDER BY nombre;

/*
25. Obtener un listado de las localidades en las que hay centros y no vive ningún empleado 
ordenado alfabéticamente.
*/
-- Se seleccionan las localidades de centros que no coinciden con las ciudades de residencia
-- de los empleados, usando NOT IN.
SELECT localidad
FROM centro
WHERE localidad NOT IN (
    SELECT localidad
    FROM empleado
)
ORDER BY localidad;

/*
26. Obtener un listado de las localidades en las que hay centros y además vive al menos un 
empleado ordenado alfabéticamente.
*/
-- Se seleccionan las localidades de centros que coinciden con las ciudades de residencia 
-- de empleados, usando IN.
SELECT localidad
FROM centro
WHERE localidad IN (
    SELECT localidad
    FROM empleado
)
ORDER BY localidad;

/*
27. Se desea dar una gratificación por navidades en función de la antigüedad en la empresa siguiendo estas pautas:
Si lleva entre 1 y 5 años, se le dará 100 euros
Si lleva entre 6 y 10 años, se le dará 50 euros por año
Si lleva entre 11 y 20 años, se le dará 70 euros por año
Si lleva más de 21 años, se le dará 100 euros por año
*/
/*
28. Obtener un listado de los empleados, ordenado alfabéticamente, indicando cuánto 
le corresponde de gratificación.
*/
-- Se calcula la gratificación según la antigüedad del empleado en base a las condiciones 
-- dadas, usando una cláusula CASE.
SELECT nombre, ape1, ape2,
CASE 
    WHEN antiguedad BETWEEN 1 AND 5 THEN 100
    WHEN antiguedad BETWEEN 6 AND 10 THEN antiguedad * 50
    WHEN antiguedad BETWEEN 11 AND 20 THEN antiguedad * 70
    WHEN antiguedad > 21 THEN antiguedad * 100
END AS gratificacion
FROM (
    SELECT nombre, ape1, ape2, YEAR(CURDATE()) - YEAR(fechaingreso) AS antiguedad
    FROM empleado
) AS empleados_antiguedad
ORDER BY nombre;

/*
29. Obtener los nombres y apellidos de los empleados que no son jefes de departamento.
*/
-- Se seleccionan los empleados cuyo código no aparece en la lista de jefes de departamento, 
-- usando NOT IN.
SELECT nombre, ape1, ape2
FROM empleado
WHERE codemple NOT IN (
    SELECT codemplejefe
    FROM dpto
);



