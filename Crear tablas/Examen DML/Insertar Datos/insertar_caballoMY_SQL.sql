--creamos las tablas
CREATE TABLE caballo
(cod_caballo VARCHAR(4),
nombre varchar(20) NOT NULL,
peso int(3),
fecha_nacimiento DATE,
propietario varchar(25),
nacionalidad varchar(20),
CONSTRAINT pk_caballo PRIMARY KEY (cod_caballo),
CONSTRAINT ck_caballo CHECK (peso BETWEEN 240 AND 300),
CONSTRAINT ck1_caballo CHECK (EXTRACT(YEAR FROM fecha_nacimiento)>2000),
CONSTRAINT ck2_caballo CHECK (upper(nacionalidad)=nacionalidad)
);

CREATE TABLE participaciones
(cod_caballo varchar(4),
cod_carrera varchar(4),
dorsal int(2) NOT NULL,
jockey varchar(10) NOT NULL,
posicionFinal int(2),
CONSTRAINT pk_participacion PRIMARY KEY (cod_caballo,cod_carrera),
CONSTRAINT fk_partcipacion FOREIGN KEY (cod_caballo) REFERENCES caballo (cod_caballo),
CONSTRAINT ck_participacion CHECK (posicionFinal>0)
);

CREATE TABLE carreras
(cod_carrera varchar(4),
fecha_hora DATE,
importe_premio int(6),
apuesta_limite float,
CONSTRAINT pk_carrera PRIMARY KEY (cod_carrera),
CONSTRAINT ck_carrera CHECK (apuesta_limite<2000)
);
ALTER TABLE carreras ADD CONSTRAINT ck1_carrera CHECK ((EXTRACT(HOUR FROM fecha_hora) BETWEEN 9 AND 14) OR (EXTRACT(HOUR FROM fecha_hora)=14 AND EXTRACT(MINUTE FROM fecha_hora)BETWEEN 0 AND 30));
ALTER TABLE carreras MODIFY apuesta_limite float;
ALTER TABLE participaciones ADD CONSTRAINT fk1_participacion FOREIGN KEY (cod_carrera) REFERENCES carreras (cod_carrera);
ALTER TABLE carreras DROP CONSTRAINT ck_carrera;
ALTER TABLE carreras ADD CONSTRAINT ck_carrera CHECK (apuesta_limite<20000);
CREATE TABLE apuestas
(DNICliente varchar(10),
cod_caballo varchar(4),
cod_carrera varchar(4),
importe int(6) DEFAULT 300 NOT NULL,
tantoporuno float,
CONSTRAINT pk_apuesta PRIMARY KEY (DNICliente,cod_caballo,cod_carrera),
CONSTRAINT fk_apuesta FOREIGN KEY (cod_caballo) REFERENCES caballo (cod_caballo) ON DELETE CASCADE,
CONSTRAINT fk1_apuesta FOREIGN KEY (cod_carrera) REFERENCES carreras (cod_carrera) ON DELETE CASCADE
);

CREATE TABLE clientes
(DNI varchar(10),
nombre varchar(20),
nacionalidad varchar(20),
CONSTRAINT pk_cliente PRIMARY KEY (DNI),
CONSTRAINT ck_cliente CHECK (regexp_like(DNI,'[0-9]{8}[A-Z]')),
CONSTRAINT ck1_cliente CHECK (upper(nacionalidad)=nacionalidad)
);
ALTER TABLE apuestas ADD CONSTRAINT fk3_apuesta FOREIGN KEY (DNICliente) REFERENCES clientes (DNI);
-- Apartados de dml 

-- 2.	Inserta el registro o registros necesarios para guardar la siguiente información:

-- realiza una apuesta al caballo más pesado de la primera carrera 
-- que se corra en el verano de 2009 por un importe de 2000 euros. 
-- En ese momento ese caballo en esa carrera se paga 30 a 1.
-- Si es necesario algún dato invéntatelo, pero sólo los datos que sean estrictamente necesaria.

INSERT INTO clientes (DNI,nacionalidad) VALUES ('12345678W','ESCOCIA');
alter table carreras modify fecha_hora datetime;
INSERT INTO carreras (cod_carrera,fecha_hora,apuesta_limite) VALUES ('1','2009/06/21 10:00:00',10000);
INSERT INTO caballo (cod_caballo,nombre,peso) VALUES ('12','aurelio',298);
INSERT INTO apuestas VALUES ('12345678W','12','1',2000,30.1);

-- 3.	Inscribe a 2 caballos  en la carrera cuyo código es C6. 
-- La carrera aún no se ha celebrado. Invéntate los jockeys y los dorsales y los caballos.
INSERT INTO caballo (cod_Caballo,nombre) VALUES ('1','Yegua');
INSERT INTO carreras(Cod_carrera) VALUES ('C6');
INSERT INTO participaciones(cod_caballo,cod_carrera,dorsal,jockey) VALUES ('12','C6',1,'Yo');
INSERT INTO participaciones(cod_caballo,cod_carrera,dorsal,jockey) VALUES ('1','C6',3,'Juanma');

-- 4.	Inserta dos carreras con los datos que creas necesario.
INSERT INTO carreras (cod_carrera,importe_premio,apuesta_limite) VALUES ('2',90000,15000);
INSERT INTO carreras (cod_carrera,importe_premio,apuesta_limite) VALUES ('3',60000,1000);

-- 5.	Quita el campo propietario de la tabla caballos
ALTER TABLE caballo DROP COLUMN propietario;

-- 6.	Añadir las siguientes restricciones a las tablas:
-- •	En la Tabla Participaciones los nombres de los jockeys tienen siempre las iniciales en mayúsculas.
ALTER TABLE participaciones ADD CONSTRAINT ck4_participaciones CHECK (regexp_like(jockey,'^[A-Z]{1}'));
-- •	La temporada de carreras transcurre del 10 de Marzo al 10 de Noviembre.
ALTER TABLE carreras ADD CONSTRAINT ck6_carrera CHECK (fecha_hora>='2000/03/10' AND fecha_hora<='2000/11/10');
-- •	La nacionalidad de los caballos sólo puede ser Española, Británica o Árabe.
ALTER TABLE caballo DROP CONSTRAINT ck2_caballo;
ALTER TABLE participaciones DROP CONSTRAINT fk_partcipacion; 
ALTER TABLE participaciones ADD CONSTRAINT fk_participacion FOREIGN KEY  (cod_caballo) REFERENCES caballo (cod_caballo);
ALTER TABLE caballo ADD CONSTRAINT ck_3 caballo CHECK (nacionalidad IN ('ESPAÑOLA','BRITANICA','ARABE'));
-- 6.	Borra las carreras en las que no hay caballos inscritos.
DELETE FROM participaciones
WHERE cod_caballo is null;


-- 7.	Añade un campo llamado código en el campo clientes, que no permita valores nulos ni repetidos
ALTER TABLE clientes ADD codigo int(6) UNIQUE;

-- 8.	Nos hemos equivocado y el código C6 de la carrera en realidad es C66.
ALTER TABLE participaciones drop CONSTRAINT fk1_participacion;
ALTER TABLE participaciones ADD CONSTRAINT fk1_participacion FOREIGN KEY (cod_carrera) REFERENCES carreras (cod_carrera) on update cascade;


UPDATE carreras 
SET cod_carrera='C66'
WHERE cod_carrera='C6';



-- 9.	Añade un campo llamado premio a la tabla apuestas.
ALTER TABLE apuestas ADD premio float;

--10.Borra todas las tablas y datos con el número menor de instrucciones posibles.
DROP TABLE apuestas;
DROP TABLE caballo;
DROP TABLE carreras;
DROP TABLE clientes;
DROP TABLE participaciones;





