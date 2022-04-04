--creamos las tablas
CREATE TABLE departamento
(codigo int(10) auto_increment,
nombre varchar(100),
presupuesto double,
gasto double,
CONSTRAINT pk_departamento PRIMARY KEY (codigo)
);

CREATE TABLE empleado
(codigo int(10) auto_increment,
nif varchar(9),
nombre varchar(100),
apellido varchar(100),
apellido2 varchar(100),
codigo_departamento int(10),
CONSTRAINT pk_empleado PRIMARY KEY (codigo),
CONSTRAINT fk_empleado FOREIGN KEY (codigo_departamento) REFERENCES departamento (codigo)
);

--insertamos los datos
INSERT INTO departamento VALUES (1,'Desarrollo',120000,6000);
INSERT INTO departamento VALUES (2,'Sistemas',150000,21000);
INSERT INTO departamento VALUES (3,'Recursos Humanos',280000,25000);
INSERT INTO departamento VALUES (4,'Contabilidad',110000,3000);
INSERT INTO departamento VALUES (5,'I+D',375000,38000);
INSERT INTO departamento VALUES (6,'Proyectos',0,0);
INSERT INTO departamento VALUES (7,'Publicidad',0,1000);

INSERT INTO empleado (codigo,nif,nombre,apellido,apellido2,codigo_departamento) VALUES (1,'32481596F','Aarón','Rivero','Gómez',1);
INSERT INTO empleado (codigo,nif,nombre,apellido,apellido2,codigo_departamento) VALUES (2,'Y5575632D','Adela','Salas','Díaz',2);
INSERT INTO empleado (codigo,nif,nombre,apellido,apellido2,codigo_departamento) VALUES (3,'R6970642B','Adolfo','Rubio','Flores',3);
INSERT INTO empleado (codigo,nif,nombre,apellido,codigo_departamento) VALUES (4,'77705545E','Adrián','Suárez',4);
INSERT INTO empleado (codigo,nif,nombre,apellido,apellido2,codigo_departamento) VALUES (5,'17087203C','Marcos','Loyola','Méndez',5);
INSERT INTO empleado (codigo,nif,nombre,apellido,apellido2,codigo_departamento) VALUES (6,'38382980M','María','Santana','Moreno',1);
INSERT INTO empleado (codigo,nif,nombre,apellido,codigo_departamento) VALUES (7,'80576669X','Pilar','Ruiz',2);
INSERT INTO empleado (codigo,nif,nombre,apellido,apellido2,codigo_departamento) VALUES (8,'71651431Z','Pepe','Ruiz','Santana',3);
INSERT INTO empleado (codigo,nif,nombre,apellido,apellido2,codigo_departamento) VALUES (9,'56399183D','Juan','Gómez','López',2);
INSERT INTO empleado (codigo,nif,nombre,apellido,apellido2,codigo_departamento) VALUES (10,'46384486H','Diego','Flores','Salas',5);
INSERT INTO empleado (codigo,nif,nombre,apellido,apellido2,codigo_departamento) VALUES (11,'67389283A','Marta','Herrera','Gil',1);
INSERT INTO empleado (codigo,nif,nombre,apellido,apellido2) VALUES (12,'41234836R','Irene','Salas','Flores');
INSERT INTO empleado (codigo,nif,nombre,apellido,apellido2) VALUES (13,'82635162B','Juan Antonio','Sáez','Guerrero');

--Ejercicios adicionales
--1. Inserta un nuevo departamento indicando su código, nombre y presupuesto.
INSERT INTO departamento(codigo,nombre,presupuesto) VALUES (8,'Productividad',170000);

--2. Inserta un nuevo departamento indicando su nombre y presupuesto.
INSERT INTO departamento(nombre,presupuesto) VALUES ('Calidad',10000);
-- Nos deja porque se autoincrementa solo

--3. Inserta un nuevo departamento indicando su código, nombre, presupuesto y gastos.
INSERT INTO departamento VALUES (10,'Finanzas',10000,1000);

-- 4. Inserta un nuevo empleado asociado a uno de los nuevos departamentos. La sentencia de inserción debe
-- incluir: código, nif, nombre, apellido1, apellido2 y codigo_departamento
INSERT INTO empleado (codigo,nif,nombre,apellido,apellido2,codigo_departamento) VALUES (14,'2345689P','Juanma','Jimenez','Garcia',8);

-- 5. Inserta un nuevo empleado asociado a uno de los nuevos departamentos. La sentencia de inserción debe
-- incluir: nif, nombre, apellido1, apellido2 y codigo_departamento
-- nos deja por el mismo motivo de antes

-- 6. Crea una nueva tabla con el nombre departamento_backup que tenga las
-- mismas columnas que la tabla departamento. Una vez creada copia todos
-- las filas de tabla departamento en departamento_backup
CREATE TABLE departamento_backup
(codigo int(10) auto_increment,
nombre varchar(100),
presupuesto double,
gasto double,
CONSTRAINT pk_departamento PRIMARY KEY (codigo)
);

-- insertamos los datos con un insert de select
INSERT INTO departamento_backup
SELECT * FROM departamento;

-- 7. Elimina el departamento Proyectos. ¿Es posible eliminarlo? Si no fuese
-- posible, ¿qué cambios debería realizar para que fuese posible borrarlo?
DELETE FROM departamento
WHERE nombre='Proyectos';

-- Se borra sin modificar la constraint porque no tiene hijos

-- 8. Elimina el departamento Desarrollo. ¿Es posible eliminarlo? Si no fuese
-- posible, ¿qué cambios debería realizar para que fuese posible borrarlo?
DELETE FROM DEPARTAMENTO
WHERE nombre='Desarrollo';
-- No nos deja asi que procedemos a modificar la constraint
ALTER TABLE empleado DROP CONSTRAINT fk_empleado;
ALTER TABLE empleado ADD CONSTRAINT fk_empleado FOREIGN KEY (codigo_departamento) REFERENCES departamento (codigo) ON DELETE CASCADE;
-- Procedemos a ejecutar de nuevo
DELETE FROM departamento
WHERE nombre='Desarrollo';
-- Ahora si funciona

-- 9. Actualiza el código del departamento Recursos Humanos y asígnale el valor
-- 30. ¿Es posible actualizarlo? Si no fuese posible, ¿qué cambios debería
-- realizar para que fuese actualizarlo?
-- Le ponemos el update cascade porque en mySQL si funciona
ALTER TABLE empleado drop CONSTRAINT fk_empleado;
ALTER TABLE empleado ADD CONSTRAINT fk_empleado FOREIGN KEY (codigo_departamento) REFERENCES departamento (codigo) ON UPDATE CASCADE;

UPDATE departamento
SET codigo=30
WHERE nombre LIKE 'Recursos Humanos';


-- 10.Actualiza el código del departamento Publicidad y asígnale el valor 40.
-- ¿Es posible actualizarlo? Si no fuese posible, ¿qué cambios debería
-- realizar para que fuese actualizarlo?

UPDATE departamento
SET codigo=40
WHERE nombre LIKE 'Publicidad';


-- 11.Actualiza el presupuesto de los departamentos sumándole 50000 € al
-- valor del presupuesto actual, solamente a aquellos departamentos que
-- tienen un presupuesto menor que 20000 €.
UPDATE departamento 
SET presupuesto=presupuesto +50000
WHERE presupuesto<20000;

-- 12.Realiza una transacción que elimine todas los empleados que no tienen
-- un departamento asociado.
DELETE FROM empleado
WHERE codigo_departamento IS NULL;
-- Usamos el operador IS NULL PARA DECIR QUE ES NULO

