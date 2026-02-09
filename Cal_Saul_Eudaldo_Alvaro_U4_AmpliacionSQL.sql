/*
Muestra el nombre, apellidos y salario de todos los empleados que no tienen comisión 
asignada (NULL). Ordena los resultados por salario en orden descendente.
*/

SELECT nombre, ape1, ape2, salario 
FROM empleado 
WHERE comision IS NULL 
ORDER BY salario DESC;

/*
Muestra el código del centro y la suma total del presupuesto de todos los departamentos
ubicados en ese centro. Ordena los resultados por presupuesto total en orden descendente.
*/

SELECT codcentro, SUM(presupuesto) AS presupuesto_total 
FROM dpto
GROUP BY codcentro
ORDER BY presupuesto_total DESC;

/*
Devuelve un listado de localidades en las que haya al menos un centro de trabajo y viva 
algún empleado. El resultado debe estar ordenado alfabéticamente.
*/

SELECT localidad
FROM centro
WHERE localidad IN (
    SELECT localidad
    FROM empleado
)
ORDER BY localidad ASC;

/*
Obtén el nombre de los departamentos cuyo salario medio de sus empleados supere los 1500 euros. 
El listado debe incluir el nombre del departamento y el salario medio redondeado a dos decimales.
*/

SELECT d.denominacion, AVG(e.salario) AS salario_medio
FROM dpto d
JOIN empleado e ON(e.coddpto = d.coddpto)
GROUP BY d.coddpto
HAVING salario_medio > 1500;


