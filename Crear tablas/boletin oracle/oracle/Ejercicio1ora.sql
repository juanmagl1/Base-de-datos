CREATE TABLE departamento
(codigo int(10),
nombre varchar(100),
presupuesto double,
CONSTRAINT pk_empleado PRIMARY KEY (codigo)
);


CREATE TABLE empleado
(codigo int(10),
nif varchar(9),
nombre varchar(100),
apellido1 varchar(100),
apellido2 varchar(100),
codigo_departamento int(10),
CONSTRAINT pk_1empleado PRIMARY KEY (codigo),
CONSTRAINT fk_empleado FOREIGN KEY (codigo_departamento) REFERENCES departamento (codigo)
);