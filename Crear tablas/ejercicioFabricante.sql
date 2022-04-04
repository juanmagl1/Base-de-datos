CREATE TABLE PRODUCTO
(codigo number(10),
nombre varchar2(100),
precio number(4,2),
codigo_fabricante number(10),
CONSTRAINT pk_producto PRIMARY KEY (codigo)
);

CREATE TABLE FABRICANTE
(codigo number(10),
nombre varchar2(100),
CONSTRAINT pk_fabricante PRIMARY KEY (codigo)
);

ALTER TABLE PRODUCTO ADD CONSTRAINT fk_producto FOREIGN KEY (codigo_fabricante) REFERENCES FABRICANTE (codigo);
