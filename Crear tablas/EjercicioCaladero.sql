CREATE TABLE BARCOS
(matricula VARCHAR2(7),
nombre VARCHAR2(140),
clase VARCHAR2(80),
armador NUMBER(2),
capacidad NUMBER(4),
nacionalidad VARCHAR2(200),
CONSTRAINT pk_matricula PRIMARY KEY (matricula),
CONSTRAINT ck_matricula CHECK (regexp_like(matricula,'^[A-Z]{2}[-]{1}[0-9]{4}'))
);

CREATE TABLE LOTES
(codigo VARCHAR2(10),
matricula VARCHAR2(7),
numkilos NUMBER(15,2),
preciokilosporsalida NUMBER(4,2),
precioporkiloadjudicado number(4,2),
fechaVenta DATE NOT NULL,
cod_especie number(4),
CONSTRAINT pk_lotes PRIMARY KEY (codigo),
CONSTRAINT fk_lotes FOREIGN KEY (matricula) REFERENCES BARCOS (matricula) ON DELETE CASCADE,
CONSTRAINT ck_lotes CHECK (precioporkiloadjudicado>preciokilosporsalida),
CONSTRAINT ck1_lotes CHECK (numkilos>0),
CONSTRAINT ck2_lotes CHECK (preciokilosporsalida>0 AND precioporkiloadjudicado>0)
);

CREATE TABLE ESPECIE 
(codigo number(4),
nombre VARCHAR2(180),
tipo VARCHAR2(90),
cupoporbarco number(4),
caladero_principal number(2),
CONSTRAINT pk_especie PRIMARY KEY (codigo)
);

ALTER TABLE lotes ADD CONSTRAINT fk2_lotes FOREIGN KEY (cod_especie) REFERENCES especie (codigo) ON DELETE CASCADE;

CREATE TABLE CALADERO 
(codigo NUMBER(2),
nombre varchar2(150),
ubicacion varchar2(75),
especie_principal number(4),
CONSTRAINT pk_caladero PRIMARY KEY (codigo),
CONSTRAINT fk_caladero FOREIGN KEY (especie_principal) REFERENCES especie (codigo) ON DELETE SET NULL,
CONSTRAINT ck_caladero CHECK (upper(nombre)=nombre AND upper(ubicacion)=ubicacion)
);
ALTER TABLE ESPECIE ADD CONSTRAINT fk_especie3 FOREIGN KEY (caladero_principal) REFERENCES caladero (codigo);

CREATE TABLE FECHAS_CAPTURAS_PERMITIDAS
(cod_especie number(4),
cod_caladero number(2),
fecha_inicial DATE,
fecha_final DATE,
CONSTRAINT pk_captura_permitida PRIMARY KEY (cod_especie,cod_caladero),
CONSTRAINT fk_captura_permitida FOREIGN KEY (cod_especie) REFERENCES especie (codigo),
CONSTRAINT fk2_captura_permitida FOREIGN KEY (cod_caladero) REFERENCES caladero (codigo),
CONSTRAINT ck_captura_permitida CHECK (fecha_inicial<to_date('02/02/2020','DD/MM/YYYY') AND fecha_final>to_date('28/03/2020','DD/MM/YYYY'))
);
--Añade un nuevo campo
ALTER TABLE CALADERO ADD nombre_cientifico VARCHAR2(190);
--Insertar 2 registros
INSERT INTO BARCOS (matricula) VALUES ('AA-1234');
INSERT INTO BARCOS (matricula) VALUES ('BB-1234');
INSERT INTO LOTES (codigo,fechaventa) VALUES (1,to_date('01/01/2000','DD/MM/YYYY'));
INSERT INTO LOTES (codigo,fechaventa) VALUES (3,to_date('12/04/2000','DD/MM/YYYY'));
INSERT INTO ESPECIE (codigo) VALUES (1);
INSERT INTO ESPECIE (codigo) VALUES (2);
INSERT INTO CALADERO (codigo) VALUES (2);
INSERT INTO CALADERO (codigo) VALUES (1);
INSERT INTO FECHAS_CAPTURAS_PERMITIDAS (cod_especie,cod_caladero) VALUES (1,2);
INSERT INTO FECHAS_CAPTURAS_PERMITIDAS (cod_especie,cod_caladero) VALUES (2,1);
--Borrar el campo armador
ALTER TABLE BARCOS DROP COLUMN armador;
--Borrar todas las tablas
/*DROP TABLE BARCOS CASCADE CONSTRAINT;
DROP TABLE LOTES CASCADE CONSTRAINT;
DROP TABLE ESPECIE CASCADE CONSTRAINT;
DROP TABLE CALADERO CASCADE CONSTRAINT;
DROP TABLE FECHAS_CAPTURAS_PERMITIDAS CASCADE CONSTRAINT;*/
--ENABLE: Activar restricción, DISABLE Desactivar la restricción
--Borrado restringido, es el borrado normal.
--Truncate table: eliminar los datos de una tabla
ALTER TABLE LOTES DISABLE CONSTRAINT ck_lotes;
ALTER TABLE LOTES ENABLE CONSTRAINT ck2_lotes;


