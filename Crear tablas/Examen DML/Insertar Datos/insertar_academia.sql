CREATE TABLE PROFESORES
(nombre varchar2(100),
apellido1 varchar2(100),
apellido2 varchar2(100),
dni varchar2(9),
direccion varchar2(100),
titulo varchar2(100),
gana number(8,2),
CONSTRAINT pk_profesor PRIMARY KEY (dni)
);

CREATE TABLE alumnos
(nombre varchar2(100),
apellido varchar2(100),
apellido2 varchar2(100),
dni varchar2(9),
direccion varchar2(100),
sexo varchar2(1),
fecha_nacimiento DATE,
curso number(4),
CONSTRAINT pk_alumno PRIMARY KEY (dni),
CONSTRAINT ck_alumno CHECK (sexo IN('H','M'))
);

CREATE TABLE cursos 
(nombre_curso varchar2(100),
cod_curso number(4),
dni_profesor varchar2(9),
maximo_alumnos number(5),
fecha_inicio DATE,
fecha_fin DATE,
num_horas number(5),
CONSTRAINT pk_curso PRIMARY KEY (cod_curso),
CONSTRAINT fk_curso FOREIGN KEY (dni_profesor) REFERENCES profesores (dni)
);

ALTER TABLE alumnos ADD CONSTRAINT fk_alumno FOREIGN KEY (curso) REFERENCES CURSOS (cod_curso);

--Insertamos los datos

--Tabla profesores
INSERT INTO profesores VALUES ('Juan','Arch','López','32432455','Puerta Negra, 4','Ing. Informática',7500);
INSERT INTO profesores VALUES ('Maria','Oliva','Rubio','43215643','Juan Alfonso 32','Lda.Fil.Inglesa',5400);

--Tabla cursos

INSERT INTO cursos VALUES ('Inglés Básico',1,'43215643',15,to_date('01/11/2000','DD/MM/YYYY'),to_date('22-12/2000','DD-MM-YYYY'),120);
INSERT INTO cursos(nombre_curso,cod_curso,dni_profesor,fecha_inicio,num_horas) VALUES ('Administración Linux',2,'32432455',to_date('01/11/2000','DD/MM/YYYY'),80);

--Tabla Alumnos
INSERT INTO alumnos (nombre,apellido,apellido2,dni,direccion,sexo,fecha_nacimiento,curso) VALUES ('Lucas','Manilva','López','123523','Alhamar, 3','H',to_date('01/11/1979','DD/MM/YYYY'),1);
--En el insert de arriba nos falla porque violamos la restriccion check porque solo admite h o m, y tiene un v
INSERT INTO alumnos (nombre,apellido,apellido2,dni,direccion,sexo,curso) VALUES ('Antonia','López','Alcantara','2567567','Maniquí, 21','M',2);
INSERT INTO alumnos (nombre,apellido,apellido2,dni,direccion,sexo,curso) VALUES ('Manuel','Alcantara','Pedrós','3123689','Julian, 2','H',1);
--En el insert de arriba nos falla porque violamos la restriccion check porque solo admite h o m, y tiene un 2
INSERT INTO alumnos (nombre,apellido,apellido2,dni,direccion,sexo,fecha_nacimiento,curso) VALUES ('José','Pérez','Caballar','4896765','Jarcha,5','H',to_date('03/02/1977','DD/MM/YYYY'),2);
--En el insert de arriba nos falla porque violamos la restriccion check porque solo admite h o m, y tiene un v
--Tambien nos pone que no ha encontrado el curso porque solo tenemos creado curso 1 y 2 y el 3 no lo coge

--3. Insertar una tabla

INSERT INTO alumnos VALUES ('Sergio','Navas','Retal','12523',NULL,'H',NULL,1);
--Falla porque no puede haber 2 personas con la misma clave primaria y el sexo es p y viola el check

INSERT INTO profesores VALUES ('Juan','Arch','Lopez','32432475','Puerta Negra,4','Ing. Informática',NULL);
--Falla porque es el mismo dni, aunque los demas datos sean distintos
UPDATE profesores 
SET nombre='Paco'
WHERE dni LIKE '32432475';

INSERT INTO alumnos VALUES ('María','Jaén','Sevilla','789678','Martos,5','M',NULL,NULL);

--6.- La fecha de nacimiento de Antonia López está equivocada. La verdadera es 23 de diciembre de 1976.
UPDATE alumnos 
SET fecha_nacimiento = to_date('23/12/1976','DD/MM/YYYY')
WHERE dni LIKE '2567567';

--7.-  Cambiar a Antonia López al curso de código 5.
UPDATE alumnos
SET curso=5
WHERE dni LIKE '2567567';
--Nos falla porque no hay ningun curso de codigo 5

--8.- Eliminar la profesora Laura Jiménez
DELETE profesores
WHERE nombre LIKE 'Laura' AND apellido1 LIKE 'Jimenez';

--Este delete ejecuta pero no hace nada porque no hay ninguna profesora llamada laura jimenez

--9.- Borrar el curso con código 1.
--nos falla porque tiene hijos y ponemos on delete cascade en el foreign key
ALTER TABLE alumnos DROP CONSTRAINT fk_alumno;
ALTER TABLE alumnos ADD CONSTRAINT fk_alumno FOREIGN KEY (curso) REFERENCES cursos (cod_curso) ON DELETE CASCADE;
DELETE cursos
WHERE cod_curso=1;

--10.- Añadir un campo llamado numero_alumnos en la tabla curso

ALTER TABLE CURSOS ADD numero_alumnos number(4);

-- 11.- Modificar la fecha de nacimiento a 01/01/2012 
-- en aquellos alumnos que no tengan fecha de nacimiento.
UPDATE ALUMNOS
SET fecha_nacimiento = to_date('01/01/2012','DD/MM/YYYY')
WHERE fecha_nacimiento IS NULL;

--12.- Borra el campo sexo en la tabla de alumnos.
ALTER TABLE ALUMNOS DROP COLUMN sexo; 

-- 13.- Modificar la tabla profesores 
--para que los  profesores de Informática cobren un 20 pro ciento más de lo que cobran actualmente.

UPDATE PROFESORES
--cuando el campo es = nulo, se usa la funcion nvl(campo,el valor que queramos darle)
SET gana= nvl(gana,0)+(nvl(gana,0)*0.2)
WHERE titulo LIKE '%Informática%';
SELECT * FROM profesores WHERE titulo LIKE '%Informática%';

-- Modifica el dni de Juan Arch a 1234567
UPDATE PROFESORES
SET DNI='1234567'
WHERE DNI = '32432455';
--No nos funciona entonces vamos a deshabilitar la clave ajena
ALTER TABLE cursos disable CONSTRAINT fk_curso;

--Ahora cambiamos en la tabla padre y en la tabla hija
UPDATE PROFESORES
SET DNI='1234567'
WHERE DNI = '32432455';

UPDATE CURSOS
SET dni_profesor='1234567'
WHERE dni_profesor = '32432455';

-- ahora habilitamos la constraint
ALTER TABLE cursos enable CONSTRAINT fk_curso;

-- 15.- Modifica el dni de todos los profesores de informática para que tengan el dni 7654321
ALTER TABLE cursos disable CONSTRAINT fk_curso;
ALTER TABLE profesores disable CONSTRAINT pk_profesor;

UPDATE PROFESORES
SET DNI='7654321'
WHERE titulo LIKE '%Informática%';

UPDATE CURSOS
SET dni_profesor='7654321'
WHERE dni_profesor = '1234567';

ALTER TABLE cursos ADD CONSTRAINT fk_curso FOREIGN KEY (dni_profesor) REFERENCES profesores (dni);
ALTER TABLE profesores DROP CONSTRAINT pk_profesor CASCADE ;
ALTER TABLE PROFESORES ADD CONSTRAINT pk_profesor PRIMARY KEY (dni);
--No nos deja porque no puede haber 2 personas con el mismo dni
UPDATE PROFESORES
SET DNI='76543211'
WHERE nombre LIKE 'Juan';
-- 16.- Cambia el sexo de la alumna María Jaén a F.
UPDATE alumnos 
SET sexo='F'
WHERE nombre LIKE 'Maria' AND apellido1 LIKE 'Jaen';
--Esta instrucción no nos va porque en el ejercicio 12 hemos eliminado la columna sexo
--en la tabla alumnos

