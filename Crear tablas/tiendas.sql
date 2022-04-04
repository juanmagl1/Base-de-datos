CREATE TABLE TIENDA
(NIF VARCHAR2(10),
nombre VARCHAR2(20),
direccion varchar2(20),
poblacion varchar2(20),
provincia varchar2(20),
codpostal number(5),
CONSTRAINT pk_tienda PRIMARY KEY (NIF),
CONSTRAINT ck_tienda CHECK (upper(provincia)=provincia)
);

CREATE TABLE FABRICANTE
(cod_fabricante NUMBER(3),
nombre varchar2(15),
pais varchar2(15),
CONSTRAINT pk_fabricante PRIMARY KEY (cod_fabricante),
CONSTRAINT ck_fabricante check(upper(nombre)=nombre AND upper(pais)=pais)
);

CREATE TABLE ARTICULOS
(articulo varchar2(20),
cod_fabricante number(3),
peso number(3),
categoria varchar2(10),
precio_venta number(4,2),
precio_costo number(4,2),
existencias number(5),
CONSTRAINT pk_articulos PRIMARY KEY (articulo,cod_fabricante,peso,categoria),
CONSTRAINT fk_articulos FOREIGN KEY (cod_fabricante) REFERENCES FABRICANTE (cod_fabricante),
CONSTRAINT ck_articulos CHECK (precio_venta>0 AND precio_costo>0 AND peso>0),
CONSTRAINT ck2_articulos CHECK (categoria IN ('PRIMERA','SEGUNDA','TERCERA'))
);

CREATE TABLE PEDIDOS 
(NIF VARCHAR2(10),
articulo varchar2(20),
cod_fabricante NUMBER(3),
peso number(3),
categoria varchar2(10),
fecha_pedido DATE,
unidades_pedidas number(4),
CONSTRAINT pk_pedidos PRIMARY KEY (NIF,articulo,cod_fabricante,peso,categoria,fecha_pedido),
CONSTRAINT fk2_pedidos FOREIGN KEY (articulo,peso,categoria,cod_fabricante) REFERENCES articulos (articulo,peso,categoria,cod_fabricante) ON DELETE CASCADE,
CONSTRAINT fk5_pedidos FOREIGN KEY (NIF) REFERENCES tienda (NIF),
CONSTRAINT ck_pedidos CHECK(unidades_pedidas>0)
);

CREATE TABLE VENTAS
(NIF VARCHAR2(10),
articulo varchar2(20),
cod_fabricante NUMBER(3),
peso number(3),
categoria varchar2(10),
fecha_venta DATE DEFAULT sysdate,
unidadesVendidas number(4),
CONSTRAINT pk_ventas PRIMARY KEY (NIF,articulo,cod_fabricante,peso,categoria,fecha_venta),
CONSTRAINT fk2_ventas FOREIGN KEY (articulo,peso,categoria,cod_fabricante) REFERENCES articulos (articulo,peso,categoria,cod_fabricante) ON DELETE CASCADE,
CONSTRAINT fk5_ventas FOREIGN KEY (NIF) REFERENCES tienda (NIF),
CONSTRAINT ck_ventas CHECK(unidadesVendidas>0)
);

--Modificar las columnas de las tablas pedidos y ventas para que las
--unidades_vendidas y las unidades_pedidas puedan almacenar cantidades numéricas
--de 6 dígitos.
ALTER TABLE PEDIDOS MODIFY unidades_pedidas number(6);
ALTER TABLE VENTAS MODIFY unidadesVendidas number(6);
--Añadir a las tablas pedidos y ventas una nueva columna para que almacenen el PVP
--del artículo
ALTER TABLE PEDIDOS ADD PVP NUMBER(4,2);
ALTER TABLE VENTAS ADD PVP NUMBER(4,2);
--. Borra la columna pais de la tabla fabricante
ALTER TABLE FABRICANTE DROP CONSTRAINT ck_fabricante;
ALTER TABLE FABRICANTE DROP COLUMN pais;
--4. Añade una restricción que indique que las unidades vendidas son como mínimo 100
ALTER TABLE VENTAS ADD CONSTRAINT ck4_venta CHECK (unidadesVendidas>=100)
--Borra todas las tablas
/*DROP TABLE ARTICULOS CASCADE CONSTRAINT;
DROP TABLE FABRICANTE CASCADE CONSTRAINT;
DROP TABLE PEDIDOS CASCADE CONSTRAINT;
DROP TABLE TIENDA CASCADE CONSTRAINT;
DROP TABLE VENTAS CASCADE CONSTRAINT;*/