CREATE TABLE FAMILIA
(nombre varchar2(150),
caracteristicas varchar2(150),
CONSTRAINT pk_familia PRIMARY KEY (nombre)
);

CREATE TABLE GENERO
(nombre varchar2(150),
caracteristicas varchar2(150),
nombre_Familia varchar2(150),
CONSTRAINT pk_genero PRIMARY KEY (nombre),
CONSTRAINT fk_genero FOREIGN KEY (nombre_Familia) REFERENCES FAMILIA (nombre)
);

CREATE TABLE ESPECIE 
(nombre varchar2(150),
caracteristicas varchar2(150),
nombre_genero varchar2(150),
CONSTRAINT pk_especie PRIMARY KEY (nombre),
CONSTRAINT fk_especie FOREIGN KEY (nombre_genero) REFERENCES GENERO (nombre)
);

CREATE TABLE PERSONA
(DNI varchar2(9),
nombre varchar2(150),
direccion varchar2(150),
telefono varchar2(9),
usuario number(4),
CONSTRAINT pk_persona PRIMARY KEY (DNI)
);
ALTER TABLE PERSONA MODIFY usuario UNIQUE;

CREATE TABLE COLECCION
(DNI_Persona varchar2(9),
n_ejemplares number(4),
fecha_inicio DATE,
precio number(4,2),
CONSTRAINT pk_coleccion PRIMARY KEY (DNI_Persona)
);
ALTER TABLE COLECCION ADD CONSTRAINT ck_coleccion CHECK (n_ejemplares BETWEEN 1 AND 150);

CREATE TABLE ZONA
(nombre varchar2(150),
localidad varchar2(80),
extension varchar2(70),
protegida varchar2(2),
CONSTRAINT pk_zona PRIMARY KEY (nombre),
CONSTRAINT ck_zona CHECK (protegida IN('Si','No'))
);

CREATE TABLE EJEMPLAR_MARIPOSA
(fecha_captura DATE,
hora_captura varchar2(6),
nombre_zona varchar2(150),
dni_persona varchar2(9),
dni_coleccion varchar2(9),
fecha_coleccion DATE,
nombre_comun varchar2(150),
precio_ejemplar number(4,2),
CONSTRAINT pk_ejemplar PRIMARY KEY (fecha_captura,hora_captura,nombre_zona,dni_persona),
CONSTRAINT fk_ejemplar FOREIGN KEY (nombre_zona) REFERENCES ZONA (nombre),
CONSTRAINT fk2_ejemplar FOREIGN KEY (dni_persona) REFERENCES PERSONA (DNI),
CONSTRAINT fk3_ejemplar FOREIGN KEY (dni_coleccion) REFERENCES COLECCION (DNI_Persona),
CONSTRAINT ck_ejemplar CHECK (precio_ejemplar>0)
);

--Incluir un atributo para almacenar los apellidos de una persona.
ALTER TABLE PERSONA ADD Apellidos varchar2(150);

--Incluir una restricción para controlar la extensión de una zona está
--entre 100m y 1500m.

ALTER TABLE ZONA ADD CONSTRAINT ck4_zona CHECK(extension BETWEEN 100 AND 1500);

--Deshabilitar la restricción que obligaba a que los ejemplares tienen
--que tener un precio mayor que 0.
ALTER TABLE EJEMPLAR_MARIPOSA DISABLE CONSTRAINT ck_ejemplar;

--1. Buscar personas por nombre y apellidos.
CREATE INDEX index_persona ON PERSONA (nombre,Apellidos);

--2. Buscar ejemplares de mariposa por fecha de captura.

CREATE INDEX index_ejemplar ON EJEMPLAR_MARIPOSA (fecha_captura);

--Empleados: deben consultar, insertar y modificar la información de
--los personas, ejemplares, colecciones y zonas.
--Creamos el usuario empleado
CREATE USER empleado IDENTIFIED BY password;
--le damos permiso a empleado para una tabla de una en una 
GRANT SELECT,INSERT,UPDATE ON EJEMPLAR_MARIPOSA TO empleado;
GRANT SELECT,INSERT,UPDATE ON COLECCION TO empleado;
GRANT SELECT,INSERT,UPDATE ON ZONA TO empleado;

--Administrador: usuario que tendrá todos los privilegios.
CREATE USER administrador IDENTIFIED BY password;
GRANT ALL PRIVILEGES TO administrador;

--Usuarios: deben consultar la información relacionada con personas,
--ejemplares de mariposas y colecciones.
CREATE USER usuario IDENTIFIED BY password;

GRANT SELECT ON EJEMPLAR_MARIPOSA TO usuario;
GRANT SELECT ON COLECCION TO usuario;
GRANT SELECT ON ZONA TO usuario;
GRANT 


--ELIMINAR ROLES
REVOKE SELECT,INSERT,UPDATE ON EJEMPLAR_MARIPOSA FROM empleado;
REVOKE SELECT,INSERT,UPDATE ON COLECCION FROM empleado;
 REVOKE SELECT,INSERT,UPDATE ON ZONA FROM empleado;
 
REVOKE ALL PRIVILEGES FROM administrador;
REVOKE SELECT ON EJEMPLAR_MARIPOSA FROM usuario;
REVOKE SELECT ON COLECCION FROM usuario;

--Borrar indices
DROP INDEX index_persona;
DROP INDEX index_ejemplar;

--Borrar tablas 
DROP TABLE COLECCION CASCADE CONSTRAINT;
DROP TABLE ESPECIE CASCADE CONSTRAINT;
DROP TABLE FAMILIA CASCADE CONSTRAINT;
DROP TABLE GENERO CASCADE CONSTRAINT;
DROP TABLE PERSONA CASCADE CONSTRAINT;
DROP TABLE ZONA CASCADE CONSTRAINT;
DROP TABLE EJEMPLAR_MARIPOSA CASCADE CONSTRAINT;