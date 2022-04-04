create table departamento
(id int(10),
nombre varchar(50),
constraint pk_departamento primary key (id)
);

create table persona
(id int(10),
nif varchar(9),
nombre varchar(25),
apellido1 varchar(50),
apellido2 varchar(50),
ciudad varchar(25),
direccion varchar(50),
telefono varchar(9),
fecha_nacimiento date,
sexo enum('H','M'),
tipo enum('Soltero','Casado'),
constraint pk_persona primary key (id)
);

create table profesor
(id int(10),
id_departamento int(10),
constraint pk_profesor primary key (id)
);

create table grado
(id int(10),
nombre varchar(100),
constraint pk_grado primary key (id)
);

create table asignatura
(id int(10),
nombre varchar(100),
creditos float,
tipo enum('anual','cuatrimestral'),
curso tinyint(3),
cuatrimestre tinyint(3),
id_profesor int(10),
id_grado int(10),
constraint pk_asignatura primary key (id),
constraint fk_asignatura foreign key (id_profesor) references profesor(id),
constraint fk1_asignatura foreign key (id_grado) references grado(id)
);

create table curso_escolar
(id int(10),
anno_inicio year(4),
anno_fin year(4),
constraint pk_curso_escolar primary key (id)
);

create table alumno_se_matricula_asignatura
(id_alumno int(10),
id_asignatura int(10),
id_curso_escolar int(10),
constraint pk_alumno_Matricula primary key (id_alumno,id_asignatura,id_curso_escolar),
constraint fk_alumno_Matricula foreign key (id_alumno) references persona(id),
constraint fk1_alumno_Matricula foreign key (id_asignatura) references asignatura(id),
constraint fk2_alumno_Matricula foreign key (id_curso_escolar) references curso_escolar(id)
);