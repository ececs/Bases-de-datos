-- A) MODIFICACIONES EN LAS TABLAS


-- Una columna de tipo fecha llamada FechaUltimaEntrada que por defecto tome el valor de la fecha actual.
ALTER TABLE STOCK
ADD FechaUltimaEntrada DATE DEFAULT (CAST(NOW() AS DATE));

/*
Una columna llamada Beneficio que contendrá el tipo de porcentaje de beneficio que esa tienda 
aplica en ese producto. Se debe controlar que el valor que almacene sea 1,2, 3, 4 o 5. 
*/
ALTER TABLE STOCK
ADD Beneficio TINYINT CHECK (Beneficio IN (1, 2, 3, 4, 5));

-- Eliminar de la tabla producto la columna Descripción.
ALTER TABLE PRODUCTO
DROP COLUMN Descripcion;

-- Añadir una columna llamada perecedero que únicamente acepte los valores: S o N.
ALTER TABLE PRODUCTO
ADD perecedero CHAR(1) CHECK (perecedero IN ('S', 'N'));

-- Modificar el tamaño de la columna Denoproducto a 50. 
ALTER TABLE PRODUCTO
MODIFY Denoproducto VARCHAR(50);

/*
Añadir una columna llamada IVA, que represente el porcentaje de IVA y únicamente pueda contener 
los valores 21,10,ó 4.
*/
ALTER TABLE FAMILIA
ADD IVA TINYINT CHECK (IVA IN (21, 10, 4));

/*
La empresa desea restringir el número de tiendas con las que trabaja, de forma que no pueda haber 
más de una tienda en una misma zona (la zona se identifica por el código postal). 
Definir mediante DDL las restricciones necesarias para que se cumpla en el campo correspondiente..
*/
ALTER TABLE TIENDA
ADD CONSTRAINT unica_zona UNIQUE (CodigoPostal);

-- Renombra la tabla STOCK por PRODXTIENDAS.
RENAME TABLE STOCK TO PRODXTIENDAS;

-- Elimina la tabla FAMILIA y su contenido si lo tuviera.
ALTER TABLE PRODUCTO
DROP FOREIGN KEY PRODUCTO_ibfk_1;
DROP TABLE IF EXISTS FAMILIA;

/*Crea un usuario llamado C##INVITADO siguiendo los pasos de la unidad 1 y dale 
todos los privilegios sobre la tabla PRODUCTO.
*/
CREATE USER 'C##INVITADO'@'localhost' IDENTIFIED BY 'Inv@1234';

GRANT ALL PRIVILEGES ON PRODUCTO TO 'C##INVITADO'@'localhost';
FLUSH PRIVILEGES;

/*
Retira los permisos de modificar la estructura de la tabla y 
borrar contenido de la tabla PRODUCTO al usuario anterior.
*/
REVOKE ALTER, DELETE ON PRODUCTO FROM 'C##INVITADO'@'localhost';
FLUSH PRIVILEGES;

