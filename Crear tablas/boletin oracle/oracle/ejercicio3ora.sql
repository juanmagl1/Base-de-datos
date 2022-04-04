create table departamento
(id number(10),
nombre varchar2(50),
constraint pk_departamento primary key (id)
);

create table persona
(id number(10),
nif varchar2(9),
nombre varchar2(25),
apellido1 varchar2(50),
apellido2 varchar2(50),
ciudad varchar2(25),
direccion varchar2(50),
telefono varchar2(9),
fecha_nacimiento date,
sexo varchar2(1),
tipo varchar2(50),
constraint pk_persona primary key (id),
CONSTRAINT ck_persona check(sexo IN('H','M')),
CONSTRAINT ck1_persona check(tipo IN('Soltero','Casado'))
);

create table profesor
(id number(10),
id_departamento number(10),
constraint pk_profesor primary key (id)
);

create table grado
(id number(10),
nombre varchar2(100),
constraint pk_grado primary key (id)
);

create table asignatura
(id number(10),
nombre varchar2(100),
creditos NUMBER(4,2),
tipo varchar2(40),
curso number(3),
cuatrimestre number(3),
id_profesor number(10),
id_grado number(10),
constraint pk_asignatura primary key (id),
constraint fk_asignatura foreign key (id_profesor) references profesor(id),
constraint fk1_asignatura foreign key (id_grado) references grado(id),
CONSTRAINT ck2_asignatura CHECK(tipo IN('Anual','Cuatrimestral'))
);

create table curso_escolar
(id number(10),
anno_inicio number(4),
anno_fin number(4),
constraint pk_curso_escolar primary key (id)
);

create table alumno_se_matricula_asignatura
(id_alumno number(10),
id_asignatura number(10),
id_curso_escolar number(10),
constraint pk_alumno_Matricula primary key (id_alumno,id_asignatura,id_curso_escolar),
constraint fk_alumno_Matricula foreign key (id_alumno) references persona(id),
constraint fk1_alumno_Matricula foreign key (id_asignatura) references asignatura(id),
constraint fk2_alumno_Matricula foreign key (id_curso_escolar) references curso_escolar(id)
);