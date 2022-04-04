CREATE TABLE MEDICO
(cod_medico number(3),
nombre varchar2(150),
especialidad varchar2(200) DEFAULT 'FAM',
cod_director number(3),
CONSTRAINT pk_medico PRIMARY KEY (cod_medico)
);

ALTER TABLE MEDICO ADD CONSTRAINT fk_medico FOREIGN KEY (cod_director) REFERENCES medico (cod_medico) ON DELETE SET NULL;

CREATE TABLE ENFERMO
(cod_inscripcion number(4),
nss varchar2(10),
nombre varchar2(150),
sexo varchar2(1),
CONSTRAINT pk_enfermo PRIMARY KEY (cod_inscripcion)
);

CREATE TABLE HABITACION
(num_hab number(4),
numero_camas number(3),
CONSTRAINT pk_habitacion PRIMARY KEY (num_hab),
CONSTRAINT ck_habitacion CHECK (num_hab BETWEEN 100 AND 200),
CONSTRAINT ck2_habitacion CHECK (numero_camas BETWEEN 1 AND 4)
);

CREATE TABLE INGRESO
(cod_ingreso number(4),
cod_inscripcion number(4),
fecha_ingreso DATE DEFAULT sysdate,
fecha_alta DATE,
num_hab number(4),
CONSTRAINT pk_ingreso PRIMARY KEY (cod_ingreso),
CONSTRAINT fk_ingreso FOREIGN KEY (num_hab) REFERENCES habitacion (num_hab),
CONSTRAINT fk2_ingreso FOREIGN KEY (cod_inscripcion) REFERENCES enfermo (cod_inscripcion) ON DELETE CASCADE,
CONSTRAINT ck1_ingreso CHECK (fecha_alta>fecha_ingreso)
);

CREATE TABLE VISITA
(cod_medico number(3),
cod_inscripcion number(4),
fecha DATE,
diagnostico varchar2(300),
CONSTRAINT pk_visita PRIMARY KEY (cod_medico,cod_inscripcion),
CONSTRAINT fk_visita FOREIGN KEY (cod_medico) REFERENCES medico (cod_medico) ON DELETE CASCADE,
CONSTRAINT fk1_visita FOREIGN KEY (cod_inscripcion) REFERENCES enfermo(cod_inscripcion) ON DELETE CASCADE
);
