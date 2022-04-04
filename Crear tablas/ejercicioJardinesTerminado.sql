CREATE TABLE GAMA_PRODUCTO
(gama VARCHAR2(50),
descripcion_texto VARCHAR2(250),
descripcion_html VARCHAR2(250),
imagen VARCHAR2(256),
CONSTRAINT pk_gama_producto PRIMARY KEY (gama)
);

CREATE TABLE PRODUCTO
(codigo_producto VARCHAR2(15),
nombre VARCHAR2(70),
gama VARCHAR2(50),
dimensiones VARCHAR2(25),
proveedor VARCHAR2(50),
descripcion VARCHAR2(125),
cantidad_en_stock number(6),
precio_venta number(15,2),
precio_proveedor Number(15,2),
CONSTRAINT pk_producto PRIMARY KEY (codigo_producto),
CONSTRAINT fk_producto FOREIGN KEY (gama) REFERENCES gama_producto (gama)
);

CREATE TABLE EMPLEADO
(codigo_empleado number(11),
nombre VARCHAR2(50),
apellido1 VARCHAR2(50),
apellido2 varchar2(50),
extension VARCHAR(10),
email VARCHAR2(100),
codigo_oficina VARCHAR2(10),
codigo_jefe number(11),
puesto VARCHAR2(50),
CONSTRAINT pk_empleado PRIMARY KEY (codigo_empleado)
);
ALTER TABLE EMPLEADO ADD CONSTRAINT fk_empleado FOREIGN KEY (codigo_jefe) REFERENCES empleado (codigo_empleado);

CREATE TABLE OFICINA
(codigo_oficina VARCHAR2(10),
ciudad VARCHAR2(30),
pais VARCHAR2(50),
region VARCHAR2(50),
codigo_postal VARCHAR2(10),
telefono VARCHAR2(20),
linea_direccion1 VARCHAR2(50),
linea_direccion2 VARCHAR2(50),
CONSTRAINT pk_oficina PRIMARY KEY (codigo_oficina)
);

ALTER TABLE EMPLEADO ADD CONSTRAINT fk_oficina FOREIGN KEY (codigo_oficina) REFERENCES oficina (codigo_oficina);

CREATE TABLE CLIENTE
(codigo_cliente number(11),
nombre_cliente VARCHAR2(50),
nombre_contacto VARCHAR2(30),
apellido_contacto VARCHAR2(30),
telefono VARCHAR(15),
fax VARCHAR2(15),
linea_direccion1 VARCHAR2(50),
linea_direccion2 VARCHAR2(50),
ciudad VARCHAR2(50),
region VARCHAR2(50),
pais VARCHAR2(50),
codigo_postal VARCHAR2(10),
codigo_empleado_rep_ventas number(11),
limite_credito number(15,2),
CONSTRAINT pk_cliente PRIMARY KEY (codigo_cliente),
CONSTRAINT fk_cliente FOREIGN KEY (codigo_empleado_rep_ventas) REFERENCES EMPLEADO (codigo_empleado)
);

CREATE TABLE PAGO
(codigo_cliente NUMBER(11),
forma_pago VARCHAR2(40),
id_transaccion VARCHAR2(50),
fecha_pago DATE,
total NUMBER(15,2),
CONSTRAINT pk_pago PRIMARY KEY (id_transaccion),
CONSTRAINT fk_pago FOREIGN KEY (codigo_cliente) REFERENCES cliente (codigo_cliente)
);

CREATE TABLE PEDIDO
(codigo_pedido number(11),
fecha_pedido DATE,
fecha_esperada DATE,
fecha_entrega DATE,
estado VARCHAR2(15),
comentarios VARCHAR2(150),
codigo_cliente number(11),
CONSTRAINT pk_pedido PRIMARY KEY (codigo_pedido),
CONSTRAINT fk_pedido FOREIGN KEY (codigo_cliente) REFERENCES cliente (codigo_cliente)
);

CREATE TABLE DETALLE_PEDIDO
(codigo_pedido number(11),
codigo_producto varchar2(15),
cantidad NUMBER(11),
precio_unidad number(15,2),
numero_linea number(6),
CONSTRAINT pk_detalle_pedido PRIMARY KEY (codigo_pedido,codigo_producto),
CONSTRAINT fk1_detalle_pedido FOREIGN KEY (codigo_pedido) REFERENCES pedido (codigo_pedido),
CONSTRAINT fk2_detalle_pedido FOREIGN KEY (codigo_producto) REFERENCES producto (codigo_producto)
);
