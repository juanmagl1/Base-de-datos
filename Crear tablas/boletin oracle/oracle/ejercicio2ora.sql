CREATE TABLE COMERCIAL
(id int(10),
nombre varchar(100),
apellido1 varchar(100),
apellido2 varchar(100),
ciudad varchar2(100),
comision float,
CONSTRAINT pk_comercial PRIMARY KEY (id)
);

CREATE TABLE cliente
(id int(10),
nombre varchar(100),
apellido1 varchar(100),
apellido2 varchar(100),
ciudad varchar(100),
categoria int(10),
CONSTRAINT pk_cliente PRIMARY KEY (id)
);
ALTER TABLE cliente MODIFY categoria varchar(25);

CREATE TABLE pedido
(id int(10),
cantidad double,
fecha DATE,
id_cliente int(10),
id_comercial int(10),
CONSTRAINT pk_pedido PRIMARY KEY (id),
CONSTRAINT fk_pedido FOREIGN KEY (id_cliente) REFERENCES cliente (id),
CONSTRAINT fk1_pedido FOREIGN KEY (id_comercial) REFERENCES comercial (id)
);