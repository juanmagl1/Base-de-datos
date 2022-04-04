alter session set "_oracle_script"=true;  
create user alumnos identified by alumnos;
GRANT CONNECT, RESOURCE, DBA TO alumnos;

CREATE TABLE PROFESOR
(DNI VARCHAR2(9),
nombre varchar2(170) unique,
titulacion varchar2(150),
direccion varchar2(150),
sueldo number(5,2) NOT NULL,
CONSTRAINT pk_profesor PRIMARY KEY (DNI)
);
--Para poner que los dos profesores no pueden llamarse igual, se le pone el atributo unique

CREATE TABLE CURSO
(Cod_curso number(3),
numeroAlumnosMaximo number(3),
fecha_inicio DATE,
fecha_fin DATE,
numeroHoras number(4)NOT NULL,
nombre varchar2(250) unique,
DNI_Profesor varchar2(9),
CONSTRAINT pk_curso PRIMARY KEY (Cod_curso),
CONSTRAINT fk_curso FOREIGN KEY (DNI_Profesor) REFERENCES PROFESOR (DNI),
CONSTRAINT ck_curso CHECK (fecha_inicio<fecha_fin)
);

CREATE TABLE ALUMNO
(DNI VARCHAR2(9),
nombre VARCHAR2(150),
apellidos VARCHAR2(140),
fecha_nacimiento DATE,
direccion VARCHAR2(125),
sexo varchar2(1),
Cod_curso number(3),
CONSTRAINT pk_alumno PRIMARY KEY (DNI),
CONSTRAINT fk_alumno FOREIGN KEY (Cod_curso) REFERENCES CURSO (Cod_curso),
CONSTRAINT ck_alumno CHECK (sexo IN ('H','M'))
);