SELECT nombre, fecha_registro
FROM usuarios
WHERE fecha_registro > '2025-04-05';

SELECT nombre, precio
FROM productos
WHERE precio >= 50
ORDER BY precio;

SELECT id, estado
FROM pedidos
WHERE estado = 'pendiente' OR estado = 'enviado';

SELECT nombre, stock
FROM productos
WHERE stock < 60
ORDER BY stock; 

SELECT id, usuario_id
FROM pedidos
WHERE usuario_id = 1;

