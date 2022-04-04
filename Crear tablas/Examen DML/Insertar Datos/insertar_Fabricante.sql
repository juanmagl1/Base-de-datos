--Introducimos los fabricantes
INSERT INTO FABRICANTE (codigo,nombre) VALUES (1,'Asus');
INSERT INTO FABRICANTE (codigo,nombre) VALUES (2,'Lenovo');
INSERT INTO FABRICANTE (codigo,nombre) VALUES (3,'HP');
INSERT INTO FABRICANTE (codigo,nombre) VALUES (4,'Samsung');
INSERT INTO FABRICANTE (codigo,nombre) VALUES (5,'Seagate');
INSERT INTO FABRICANTE (codigo,nombre) VALUES (6,'Crucial');
INSERT INTO FABRICANTE (codigo,nombre) VALUES (7,'Gigabyte');
INSERT INTO FABRICANTE (codigo,nombre) VALUES (8,'Huawei');
INSERT INTO FABRICANTE (codigo,nombre) VALUES (9,'Xiaomi');

--modificamos la columna
ALTER TABLE PRODUCTO MODIFY precio number(10,2);
--Introducimos los productos
INSERT INTO PRODUCTO (codigo,nombre,precio,codigo_fabricante) VALUES (1,'Disco duro SATA3 1TB',86.99,5);
INSERT INTO PRODUCTO (codigo,nombre,precio,codigo_fabricante) VALUES (2,'Memoria RAM DDR4 8GB',120,6);
INSERT INTO PRODUCTO (codigo,nombre,precio,codigo_fabricante) VALUES (3,'Disco SSD 1 TB',150.99,4);
INSERT INTO PRODUCTO (codigo,nombre,precio,codigo_fabricante) VALUES (4,'GeForce GTX 1050Ti',185,7);
INSERT INTO PRODUCTO (codigo,nombre,precio,codigo_fabricante) VALUES (5,'GeForce GTX 1080 Xtreme',755,6);
INSERT INTO PRODUCTO (codigo,nombre,precio,codigo_fabricante) VALUES (6,'Monitor 24 LED Full HD',202,1);
INSERT INTO PRODUCTO (codigo,nombre,precio,codigo_fabricante) VALUES (7,'Monitor 27 LED Full HD',245.99,1);
INSERT INTO PRODUCTO (codigo,nombre,precio,codigo_fabricante) VALUES (8,'Portátil Yoga 520',559,2);
INSERT INTO PRODUCTO (codigo,nombre,precio,codigo_fabricante) VALUES (9,'Portátil Ideapad 320',444,2);
INSERT INTO PRODUCTO (codigo,nombre,precio,codigo_fabricante) VALUES (10,'Impresora HP Deskjet 3720',59.99,3);
INSERT INTO PRODUCTO (codigo,nombre,precio,codigo_fabricante) VALUES (11,'Impresora HP Laserjet Pro M26nw',180,3);

--1. Inserta un nuevo fabricante indicando su código y su nombre.
INSERT INTO fabricante (codigo,nombre) VALUES (10,'Apple');
--2. Inserta un nuevo fabricante indicando solamente su nombre.
INSERT INTO fabricante (nombre) VALUES ('MSI'); --Nos falla porque codigo es un campo que NO puede ir vacio
--Lo que hacemos que deshabilitamos la constraint ejecutamos la instruccion anterior 
--despues la habilitamos, pero no nos deja habulitarla porque hemos violado la clave primaria
ALTER TABLE fabricante disable CONSTRAINT pk_fabricante cascade;
ALTER TABLE fabricante enable CONSTRAINT pk_fabricante;
DELETE fabricante WHERE nombre='MSI';
ALTER TABLE PRODUCTO enable CONSTRAINT fk_producto;
--Una vez que borremos los datos volvemos a ejecutar la instruccion de validar y si nos debe de dejar
--3. Inserta un nuevo producto asociado a uno de los nuevos fabricantes. La
--sentencia de inserción debe
--incluir: código, nombre, precio y código_fabricante.
INSERT INTO PRODUCTO (codigo,nombre,precio,codigo_fabricante) VALUES (12,'Apple Iphone 13 pro max 1Tb',1499.99,10);
--Inserta un nuevo producto asociado a uno de los nuevos fabricantes. La
--sentencia de inserción debe incluir: nombre, precio y código_fabricante.
INSERT INTO producto (nombre,precio,codigo_fabricante) VALUES (13,'Xiaomi mi band 6',30.99,9);
--Nos pasa como en el caso del apartado 2 que nos falla porque la clave primaria no puede estar vacia
--5. Elimina el fabricante Asus. ¿Es posible eliminarlo? Si no fuese posible,
--¿qué cambios debería realizar para que fuese posible borrarlo?
DELETE fabricante WHERE nombre='Asus';
-- No Nos deja borrarlo, por lo que procedemos a eliminar la clave foranea
ALTER TABLE PRODUCTO disable CONSTRAINT fk_producto;
--La ponemos como on delete cascade
ALTER TABLE PRODUCTO ADD CONSTRAINT fk1_producto FOREIGN KEY (codigo_fabricante) REFERENCES FABRICANTE (codigo) ON DELETE CASCADE;

--Volvemos a ejecutar la sentencia
DELETE fabricante WHERE nombre='Asus';
--Ahora si nos deja eliminarlo
--Elimina el fabricante Xiaomi. ¿Es posible eliminarlo? Si no fuese posible,
--¿qué cambios debería realizar para que fuese posible borrarlo?
DELETE fabricante WHERE nombre='Xiaomi'; --Nos deja borrarlo
--7. Actualiza el código del fabricante Lenovo y asígnale el valor 20. ¿Es
--posible actualizarlo? Si no fuese posible, ¿qué cambios debería realizar
--para que fuese actualizarlo?
DELETE producto WHERE codigo_fabricante = 1;
ALTER TABLE PRODUCTO ADD CONSTRAINT fk1_producto FOREIGN KEY (codigo_fabricante) REFERENCES FABRICANTE (codigo) ON DELETE CASCADE;
UPDATE fabricante
SET codigo=20
WHERE nombre='Lenovo';
ALTER TABLE PRODUCTO ADD CONSTRAINT fk3_producto FOREIGN KEY (codigo_fabricante) REFERENCES FABRICANTE (codigo) ON UPDATE CASCADE;
--No deja usar
--No nos deja actualizarlo
ALTER TABLE PRODUCTO DISABLE CONSTRAINT fk1_producto;
--Deshabilitamos la foreign key y actualizamos los datos manualmente primero tabla producto, despues tabla fabricante
UPDATE producto
SET codigo_fabricante=20
WHERE codigo_fabricante=2;

UPDATE producto
SET codigo_fabricante=20
WHERE codigo=2;
ALTER TABLE PRODUCTO ENABLE CONSTRAINT fk1_producto;
ALTER TABLE PRODUCTO ADD CONSTRAINT fk1_producto FOREIGN KEY (codigo_fabricante) REFERENCES FABRICANTE (codigo) ON DELETE CASCADE;
ALTER TABLE PRODUCTO DROP CONSTRAINT fk1_producto;
ALTER TABLE PRODUCTO ADD CONSTRAINT fk1_producto FOREIGN KEY (codigo_fabricante) refErences FABRICANTE (codigo) ON UPDATE CASCADE;
--8. Actualiza el código del fabricante Huawei y asígnale el valor 30. ¿Es
--posible actualizarlo? Si no fuese posible, ¿qué cambios debería realizar
--para que fuese actualizarlo?
ALTER TABLE PRODUCTO DISABLE CONSTRAINT fk1_producto;
UPDATE fabricante
SET codigo=30
WHERE nombre='Huawei';

ALTER TABLE PRODUCTO ENABLE CONSTRAINT fk1_producto;

--9. Actualiza el precio de todos los productos sumándole 5 € al precio
--actual.
UPDATE PRODUCTO
SET precio=precio+5;

--10.Elimina todas las impresoras que tienen un precio menor de 200 €.
DELETE producto
WHERE precio<200 AND nombre LIKE 'Impresora%';