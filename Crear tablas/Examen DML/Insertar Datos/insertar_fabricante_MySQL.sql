--Creamos las tablas
create table producto
(codigo int(10) auto_increment,
nombre varchar(100),
precio double,
codigo_fabricante int(10),
constraint pk_producto primary key (codigo)
);

create table fabricante
(codigo int(10) auto_increment,
nombre varchar(100),
constraint pk_fabricante primary key (codigo)
);
alter table producto add constraint fk_producto foreign key (codigo_fabricante) references fabricante (codigo);




--Introducimos los fabricantes
INSERT INTO fabricante (codigo,nombre) VALUES (1,'Asus');
INSERT INTO  fabricante (codigo,nombre) VALUES (2,'Lenovo');
INSERT INTO fabricante  (codigo,nombre) VALUES (3,'HP');
INSERT INTO fabricante  (codigo,nombre) VALUES (4,'Samsung');
INSERT INTO fabricante  (codigo,nombre) VALUES (5,'Seagate');
INSERT INTO fabricante  (codigo,nombre) VALUES (6,'Crucial');
INSERT INTO fabricante  (codigo,nombre) VALUES (7,'Gigabyte');
INSERT INTO fabricante  (codigo,nombre) VALUES (8,'Huawei');
INSERT INTO fabricante  (codigo,nombre) VALUES (9,'Xiaomi');

--modificamos la columna
ALTER TABLE PRODUCTO MODIFY precio number(10,2);
--Introducimos los productos
INSERT INTO producto (codigo,nombre,precio,codigo_fabricante) VALUES (1,'Disco duro SATA3 1TB',86.99,5);
INSERT INTO producto (codigo,nombre,precio,codigo_fabricante) VALUES (2,'Memoria RAM DDR4 8GB',120,6);
INSERT INTO producto (codigo,nombre,precio,codigo_fabricante) VALUES (3,'Disco SSD 1 TB',150.99,4);
INSERT INTO producto (codigo,nombre,precio,codigo_fabricante) VALUES (4,'GeForce GTX 1050Ti',185,7);
INSERT INTO producto (codigo,nombre,precio,codigo_fabricante) VALUES (5,'GeForce GTX 1080 Xtreme',755,6);
INSERT INTO producto (codigo,nombre,precio,codigo_fabricante) VALUES (6,'Monitor 24 LED Full HD',202,1);
INSERT INTO producto (codigo,nombre,precio,codigo_fabricante) VALUES (7,'Monitor 27 LED Full HD',245.99,1);
INSERT INTO producto (codigo,nombre,precio,codigo_fabricante) VALUES (8,'Portátil Yoga 520',559,2);
INSERT INTO producto (codigo,nombre,precio,codigo_fabricante) VALUES (9,'Portátil Ideapad 320',444,2);
INSERT INTO producto (codigo,nombre,precio,codigo_fabricante) VALUES (10,'Impresora HP Deskjet 3720',59.99,3);
INSERT INTO producto (codigo,nombre,precio,codigo_fabricante) VALUES (11,'Impresora HP Laserjet Pro M26nw',180,3);

--1. Inserta un nuevo fabricante indicando su código y su nombre.
INSERT INTO fabricante (codigo,nombre) VALUES (10,'Apple');
--2. Inserta un nuevo fabricante indicando solamente su nombre.
INSERT INTO fabricante (nombre) VALUES ('LG'); --Nos la hace porque nos autoincrementa la clave

--3. Inserta un nuevo producto asociado a uno de los nuevos fabricantes. La
--sentencia de inserción debe
--incluir: código, nombre, precio y código_fabricante.
INSERT INTO producto (codigo,nombre,precio,codigo_fabricante) VALUES (12,'Apple Iphone 13 pro max 1Tb',1499.99,10);
--Inserta un nuevo producto asociado a uno de los nuevos fabricantes. La
--sentencia de inserción debe incluir: nombre, precio y código_fabricante.
INSERT INTO producto (nombre,precio,codigo_fabricante) VALUES ('Xiaomi mi band 6',30.99,9);
--funciona por el mismo caso que antes
--5. Elimina el fabricante Asus. ¿Es posible eliminarlo? Si no fuese posible,
--¿qué cambios debería realizar para que fuese posible borrarlo?
DELETE fabricante WHERE nombre='Asus';
-- No Nos deja borrarlo, por lo que procedemos a eliminar la clave foranea
ALTER TABLE producto drop CONSTRAINT fk_producto;
--La ponemos como on delete cascade
ALTER TABLE producto ADD CONSTRAINT fk1_producto FOREIGN KEY (codigo_fabricante) REFERENCES fabricante (codigo) ON DELETE CASCADE;

--Volvemos a ejecutar la sentencia
DELETE from fabricante WHERE nombre like'Asus';
--Ahora si nos deja eliminarlo
--Elimina el fabricante Xiaomi. ¿Es posible eliminarlo? Si no fuese posible,
--¿qué cambios debería realizar para que fuese posible borrarlo?
DELETE from fabricante WHERE nombre like 'Xiaomi'; --Nos deja borrarlo
--7. Actualiza el código del fabricante Lenovo y asígnale el valor 20. ¿Es
--posible actualizarlo? Si no fuese posible, ¿qué cambios debería realizar
--para que fuese actualizarlo?
ALTER TABLE producto drop CONSTRAINT fk1_producto;
ALTER TABLE producto ADD CONSTRAINT fk1_producto FOREIGN KEY (codigo_fabricante) REFERENCES fabricante (codigo) ON UPDATE CASCADE;
UPDATE fabricante
SET codigo=20
WHERE nombre='Lenovo';
-- Nos deja y tambien se actualizan los hijos
ALTER TABLE PRODUCTO DISABLE CONSTRAINT fk1_producto;
-- Deshabilitamos la foreign key y actualizamos los datos manualmente primero tabla producto, despues tabla fabricante
UPDATE producto
SET codigo_fabricante=20
WHERE codigo_fabricante=2;

--8. Actualiza el código del fabricante Huawei y asígnale el valor 30. ¿Es
--posible actualizarlo? Si no fuese posible, ¿qué cambios debería realizar
--para que fuese actualizarlo?
UPDATE fabricante
SET codigo=30
WHERE nombre='Huawei';
--Nos deja por la mofificacion que hemos realizado antes
--9. Actualiza el precio de todos los productos sumándole 5 € al precio
--actual.
UPDATE producto
SET precio=precio+5;

--10.Elimina todas las impresoras que tienen un precio menor de 200 €.
DELETE from producto
WHERE precio<200 AND nombre LIKE 'Impresora%';