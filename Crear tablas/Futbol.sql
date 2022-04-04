CREATE TABLE EQUIPO
(Cod_equipo VARCHAR2(4),
Nombre VARCHAR2(30) NOT NULL,
Localidad VARCHAR2(15),
CONSTRAINT pk_equipo PRIMARY KEY (Cod_equipo)
);
ALTER TABLE EQUIPO ADD Goles_Marcados NUMBER(3);

CREATE TABLE JUGADOR
(Cod_jugador VARCHAR2(4),
Nombre VARCHAR2(30) NOT NULL,
Fecha_Nacimiento DATE,
Demarcacion VARCHAR2(10),
Cod_equipo VARCHAR2(4),
CONSTRAINT pk_jugador PRIMARY KEY (Cod_jugador),
CONSTRAINT fk_equipo FOREIGN KEY (Cod_equipo) REFERENCES EQUIPO (Cod_equipo) 
);

ALTER TABLE JUGADOR ADD CONSTRAINT ck_equipo CHECK (Demarcacion IN ('Portero','Defensa','Medio','Delantero'));

CREATE TABLE PARTIDO
(Cod_partido VARCHAR2(4),
Cod_Equipo_Local VARCHAR2(4),
Cod_Equipo_Visitante VARCHAR2(4),
Fecha DATE,
Competicion VARCHAR2(4),
Jornada VARCHAR2(20),
CONSTRAINT pk_partido PRIMARY KEY (Cod_partido),
CONSTRAINT fk1_partido FOREIGN KEY (Cod_Equipo_Local) REFERENCES EQUIPO (Cod_equipo),
CONSTRAINT fk2_partido FOREIGN KEY (Cod_Equipo_Visitante) REFERENCES EQUIPO (Cod_equipo),
CONSTRAINT ck_partido CHECK (EXTRACT(MONTH FROM Fecha) !=7 AND EXTRACT(MONTH FROM Fecha)!=8)
);
ALTER TABLE PARTIDO ADD CONSTRAINT ck2_partido CHECK (Competicion IN ('Liga','Copa'));
ALTER TABLE PARTIDO ADD CONSTRAINT ck2_partido CHECK (Competicion LIKE 'Copa' OR Competicion LIKE 'Liga');

--Para crear restricciones de conjunto de valores, se usa la palabra IN y se usa comillas simples, también se usa el termino like

CREATE TABLE INCIDENCIAS
(NumIncidencia VARCHAR2(6),
Cod_Partido VARCHAR2(4),
Cod_Jugador VARCHAR2(4),
Minuto NUMBER(2),
Tipo VARCHAR2(20) NOT NULL,
CONSTRAINT pk_incidencias PRIMARY KEY (NumIncidencia),
CONSTRAINT fk1_incidencias FOREIGN KEY (Cod_Partido) REFERENCES PARTIDO (Cod_Partido),
CONSTRAINT fk2_incidencias FOREIGN KEY (Cod_jugador) REFERENCES JUGADOR (Cod_Jugador),
CONSTRAINT ck_incidencias CHECK (minuto BETWEEN 1 AND 99)
);
--Funcion de oracle para que enpiece el nombre por mayusculas
ALTER TABLE JUGADOR ADD CONSTRAINT nombre_Jugador CHECK(Nombre= initcap(nombre));
ALTER TABLE INCIDENCIAS MODIFY Tipo NOT NULL;
--Expresion regular para que comience el codigo equipo por un número, 
--lo que está entre llaves es que quiero que coja un numero nada mas
ALTER TABLE EQUIPO ADD CONSTRAINT ck3_equipo CHECK (regexp_like(Cod_Equipo,'^[0-9]{1}'));
SELECT * FROM user_constraints;