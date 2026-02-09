SELECT p.nombre, SUM(dp.cantidad) AS UnidadesPorProducto
FROM detalle_pedidos dp
JOIN productos p on(p.id_producto = dp.id_producto)
GROUP BY nombre
ORDER BY nombre;

SELECT nombre
FROM productos p
LEFT JOIN detalle_pedidos dp ON (p.id_producto = dp.id_producto)
WHERE dp.id_producto IS NOT NULL;

SELECT id_pedido, SUM(cantidad) AS productos_pedidos
FROM detalle_pedidos 
GROUP BY id_pedido;

SELECT nombre, stock_actual
FROM productos
ORDER BY nombre;

SELECT p.id_pedido, pr.id_proveedor, pr.nombre
FROM pedidos p
JOIN proveedores pr ON(p.id_proveedor=pr.id_proveedor)
WHERE pr.nombre LIKE 'tecno%'
