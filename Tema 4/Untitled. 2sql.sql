SELECT p.id_pedido, p.estado, pr.id_proveedor, pr.nombre
FROM pedidos p
JOIN proveedores pr ON( p.id_proveedor = pr.id_proveedor)
WHERE pr.nombre LIKE 'tecnopro%';

SELECT id_producto, nombre, stock_actual
FROM productos
ORDER BY nombre ASC;

SELECT id_pedido, SUM(cantidad) AS total_productos_solicitados
FROM detalle_pedidos
GROUP BY id_pedido;

SELECT nombre
FROM productos p
LEFT JOIN detalle_pedidos dp ON p.id_producto = dp.id_producto
WHERE dp.id_producto IS NOT NULL;

SELECT p.nombre, SUM(dp.cantidad) AS cantidad_total
FROM productos p
JOIN detalle_pedidos dp ON p.id_producto = dp.id_producto
GROUP BY p.nombre
ORDER BY cantidad_Total;