-- Crear la base de datos tienda_virtual
CREATE DATABASE IF NOT EXISTS TIENDAVIRTUAL; 
USE TIENDAVIRTUAL;

/*
TABLA FAMILIA: Contiene las familias a las que pertenecen los productos, como por ejemplo 
ordenadores, impresoras,etc.
*/
CREATE TABLE FAMILIA ( 
	CodFamilia NUMERIC(3) PRIMARY KEY, -- Clave primaria: código númerico de 3 digitos.
    DenoFamilia VARCHAR(50) NOT NULL UNIQUE -- Denominación de la familia: alfanumérico de 50 caracteres, único y obligatorio
);

/*
TABLA PRODUCTO => contendrá información general sobre los productos que distribuye la 
empresa a las tiendas.
*/
CREATE TABLE PRODUCTO ( -- Crear la tabla PRODUCTO
    CodProducto NUMERIC(5) PRIMARY KEY, -- Clave primaria: código de 5 dígitos.
    DenoProducto VARCHAR(20) NOT NULL, -- Denominación del producto: alfanumérico de 20 caracteres, obligatorio.
    Descripcion VARCHAR(100), -- Descripción: alfanumérico 10 caracteres, opcional.
    PrecioBase NUMERIC(8, 2) NOT NULL CHECK (PrecioBase > 0), -- Precio base del producto, númerico de 8 dígitos dos de ellos decimales, mayor que 0 y obligatorio.
    PorcReposición NUMERIC(3) CHECK (PorcReposición > 0), -- Porcentaje de reposición, númerico de 3 dígitos mayor que 0.
    UnidadesMinimas NUMERIC(4) NOT NULL CHECK (UnidadesMinimas > 0), -- Unidades mínimas, númerico de 4 dígitos, mayor que 0 y obligatorio.
    CodFamilia NUMERIC(3) NOT NULL, -- Clave ajena: referencia a CodFamilia en la tabla FAMILIA, obligatorio.
    FOREIGN KEY (CodFamilia) REFERENCES FAMILIA(CodFamilia) -- Establecer relación con FAMILIA.
);

/*
TABLA TIENDA => contendrá información básica sobre las tiendas que distribuyen los productos.
*/
CREATE TABLE TIENDA (
    CodTienda NUMERIC(3) PRIMARY KEY, -- Clave primaria: código númerico de 3 digitos
    DenoTienda VARCHAR(20) NOT NULL, -- Nombre de la tienda: alfanumérico de 20 caracteres, obligatorio.
    Telefono VARCHAR(11), -- Teléfono: alfanumérico 11 caracteres, opcional.
    CodigoPostal VARCHAR(5) NOT NULL, -- Codigo postal: alfanumérico de 5 caracteres y obligatorio.
    Provincia VARCHAR(5) NOT NULL -- Provincia donde se ubica la tienda: alfanumérico de 5 caracteres y obligatorio.
); 

 /*
TABLA STOCK => Contendrá para cada tienda el número de unidades disponibles de cada producto. La clave primaria está formada por la concatenación de los campos Codtienda y Codproducto.
*/
CREATE TABLE STOCK ( -- Crear la tabla STOCK
    CodTienda NUMERIC(3) NOT NULL, -- Código de la tienda: unico y númerico de 3 digitos.
    CodProducto NUMERIC(5) NOT NULL, -- Código del producto, obligatorio.
    Unidades NUMERIC(6) NOT NULL CHECK (Unidades >= 0), -- Unidades, mayor o igual a 0 y obligatorio.
    PRIMARY KEY (CodTienda, CodProducto), -- Clave primaria compuesta por Codtienda y Codproducto.
    FOREIGN KEY (CodTienda) REFERENCES TIENDA(CodTienda), -- Clave ajena a la tabla TIENDA.
    FOREIGN KEY (CodProducto) REFERENCES PRODUCTO(CodProducto) -- Clave ajena a la tabla PRODUCTO.
);
