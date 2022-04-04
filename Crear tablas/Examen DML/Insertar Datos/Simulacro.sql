--Creación de usuario

CREATE TABLE PROFESOR
(id_profesor number(8),
nif_p varchar2(9),
nombre varchar2(100),
especialidad varchar2(150),
telefono varchar2(200),
CONSTRAINT pk_profesor PRIMARY KEY (id_profesor)
);

CREATE TABLE ASIGNATURA
(cod_asignatura number(4),
nombre varchar2(50),
id_profesor number(8),
CONSTRAINT pk_asignatura PRIMARY KEY (cod_asignatura),
CONSTRAINT fk_asignatura FOREIGN KEY (id_profesor) REFERENCES PROFESOR (id_profesor)
);

CREATE SEQUENCE secuencia_libro
START WITH 1
INCREMENT BY 1 
MAXVALUE 99999
CYCLE;

CREATE TABLE ALUMNO
(nummatricula number(5),
nombre varchar2(150),
fechanacimiento DATE,
telefono varchar2(9),
CONSTRAINT pk_alumno PRIMARY KEY (nummatricula)
);

CREATE TABLE RECIBE
(nummatricula number(5),
codasignatura number(4),
cursoescolar number(1),
CONSTRAINT pk_recibe PRIMARY KEY (nummatricula,codasignatura,cursoescolar),
CONSTRAINT fk_recibe FOREIGN KEY (nummatricula) REFERENCES ALUMNO (nummatricula),
CONSTRAINT fk2_recibe FOREIGN KEY (codasignatura) REFERENCES ASIGNATURA (cod_asignatura)
);

--Crear secuencia
CREATE SEQUENCE secuencia_generar
INCREMENT BY 1
START WITH 24

MAXVALUE 99999999
CYCLE;
--Apartado 2 
--Inserta 2 profesores
INSERT INTO PROFESOR (id_profesor,nombre) VALUES (secuencia_generar.nextval,'Paco');
SELECT *FROM profesor;
INSERT INTO PROFESOR (id_profesor,nombre) VALUES (secuencia_generar.nextval,'Manuel');
--Creamos otra secuencia para asignaturas
CREATE SEQUENCE codigo_asignatura
START WITH 1
MAXVALUE 99999
INCREMENT BY 1
CYCLE;
--INSERTA 4 ASIGNATURAS 
INSERT INTO ASIGNATURA VALUES (secuencia_generar.nextval,'Sistema',1);
SELECT * FROM asignatura;
INSERT INTO ASIGNATURA VALUES (2,'Programacion',2);
INSERT INTO ASIGNATURA VALUES (3,'Base',1);
INSERT INTO ASIGNATURA VALUES (4,'Lenguaje',2);

--Inserta 10 alumnos
INSERT INTO ALUMNO VALUES (1,'Juanma',NULL,NULL);
INSERT INTO ALUMNO VALUES (2,'Zari',NULL,NULL);
INSERT INTO ALUMNO VALUES (3,'Ruina',NULL,NULL);
INSERT INTO ALUMNO VALUES (4,'Canti',NULL,NULL);
INSERT INTO ALUMNO VALUES (5,'Malo',NULL,NULL);
INSERT INTO ALUMNO VALUES (6,'Zana',NULL,NULL);
INSERT INTO ALUMNO VALUES (7,'Terre',NULL,NULL);
INSERT INTO ALUMNO VALUES (8,'Vespi',NULL,NULL);
INSERT INTO ALUMNO VALUES (9,'Juanito',NULL,NULL);
INSERT INTO ALUMNO VALUES (10,'Monty',NULL,NULL);

--• Cada alumno	debe realizar al menos 2 asignaturas.
INSERT INTO RECIBE VALUES (1,1,1);
INSERT INTO RECIBE VALUES (1,2,1);
INSERT INTO RECIBE VALUES (2,1,1);
INSERT INTO RECIBE VALUES (2,2,1);
INSERT INTO RECIBE VALUES (3,1,1);
INSERT INTO RECIBE VALUES (3,2,1);
INSERT INTO RECIBE VALUES (4,1,1);
INSERT INTO RECIBE VALUES (4,2,1);
INSERT INTO RECIBE VALUES (5,1,1);
INSERT INTO RECIBE VALUES (5,2,1);
INSERT INTO RECIBE VALUES (6,1,1);
INSERT INTO RECIBE VALUES (6,2,1);
INSERT INTO RECIBE VALUES (7,1,1);
INSERT INTO RECIBE VALUES (7,2,1);
INSERT INTO RECIBE VALUES (8,1,1);
INSERT INTO RECIBE VALUES (8,2,1);
INSERT INTO RECIBE VALUES (9,1,1);
INSERT INTO RECIBE VALUES (9,2,1);
INSERT INTO RECIBE VALUES (10,1,1);
INSERT INTO RECIBE VALUES (10,2,1);

/*Apartado 3. (0,5 puntos) Introduce 2	 alumnos	 con	 el	 mismo	 NumMatricula.	 ¿Qué	
sucede?	 ¿Por	 qué?.	 Deberás	 escribir	 las	 sentencias	 concretas	 además de	 explicar	
detalladamente	lo	que	sucede*/
INSERT INTO ALUMNO (nummatricula) VALUES (11);
INSERT INTO ALUMNO (nummatricula) VALUES (11);
--Nos da error porque no se puede repetir la clave primaria, la solución seria cambuandole la clave primaria
INSERT INTO ALUMNO (nummatricula) VALUES (12);
--Apartado	4. (0,5 puntos) Introduce	3	alumnos para	los	cuales	no	conocemos	el	número	
--de	teléfono
INSERT INTO ALUMNO VALUES (13,'Juanma',to_date('12/04/1990','DD/MM/YYYY'),NULL);
INSERT INTO ALUMNO VALUES (14,'Juan',to_date('12/07/1992','DD/MM/YYYY'),NULL);
INSERT INTO ALUMNO VALUES (15,'Manuel',to_date('12/09/1993','DD/MM/YYYY'),NULL);
INSERT INTO ALUMNO VALUES (16,'Manuel',to_date('12/09/2002','DD/MM/YYYY'),NULL);

--Apartado	5.	(0,5 puntos) Modifica	los	datos	de	los 3	alumnos anteriores	para	establecer	
--un	número	de	teléfono
UPDATE ALUMNO 
SET telefono ='658234123'
WHERE telefono IS NULL;

--Apartado	6.	(1 puntos) Para	aquellos	alumnos nacidos	después del	año	2000	se	deberá	
--actualizar	su	fecha	de	nacimiento	con	el	valor	22/07/1981.	Deberá	realizarse	con	una	
--única	instrucción.
UPDATE ALUMNO
SET fechanacimiento =to_date('22/07/1981','DD/MM/YYYY')
WHERE EXTRACT(YEAR FROM fechanacimiento)>2000;

-- Apartado	7.	(1 puntos) Para	los	profesores que	tienen	número	de	teléfono	y cuyo NIF	
--no	comience	por	9,	se	deberá actualizar	a “Informática”	su especialidad.
UPDATE PROFESOR 
SET especialidad ='Informática'
WHERE telefono IS NOT NULL AND nif_p NOT LIKE '9%';

-- Apartado	8. (0,5 puntos) En	la	tabla	Recibe borra	todos	los	registros	que	pertenecen	a	
--una	de	las	asignaturas
ALTER TABLE recibe DROP CONSTRAINT fk2_recibe;
ALTER TABLE recibe ADD CONSTRAINT fk2_recibe FOREIGN KEY (codasignatura) REFERENCES ASIGNATURA (cod_asignatura) ON DELETE CASCADE;

DELETE FROM RECIBE
WHERE codasignatura =1;

-- Apartado	9. (0,5 puntos) En	la	tabla	Asignatura borra	dicha	asignatura
DELETE FROM ASIGNATURA
WHERE codasignatura =1;
SELECT * FROM ASIGNATURA;

-- Apartado	10. (0,5 puntos) Borra	el	resto	de	asignaturas. Indica	la	instrucción	a	ejecutar.
--¿Qué	sucede?	Se borra todos los datos¿Por	qué? Porque las foreign key son on delete cascade ¿Como	lo	solucionarías?	¿Podría	haberse	evitado	el	problema	
--con	 otro	 diseño	 físico?¿Cómo?. Explícalo	 detalladamente	 e	 indica	 las	 instrucciones	
--necesarias	para	solucionarlo.
DELETE FROM ASIGNATURA;

-- Apartado	11.	(0,5 puntos) Borra	todos	los	profesores. Indica	la	instrucción	a	ejecutar.
--¿Qué	sucede?	¿Por	qué?	¿Como	lo	solucionarías?	¿Podría	haberse	evitado	el	problema	
--con	 otro	 diseño	 físico?¿Cómo?. Explícalo	 detalladamente	 e	 indica	 las	 instrucciones	
--necesarias	para	solucionarlo.
DELETE FROM profesor;
SELECT *FROM profesor;

-- Apartado	12. (1 puntos) Se	ha	detectado	que	en	la	tabla	alumnos	los	nombres	de	los	
--alumnos	están	en	minúsculas.	 Se	 desea	 actualizar	el	 nombre	 de	 cada	 alumno	 por	el	
--correspondiente	convertido	en	MAYÚSCULA.
UPDATE ALUMNO
SET NOMBRE=UPPER(NOMBRE);
SELECT*FROM alumno;

--Apartado	13. (1 puntos) Crea una	nueva	tabla	llamada	ALUMNO_BACKUP que	tenga	
--las	mismas	columnas	que	la	tabla	ALUMNO.	Una	vez	creada	copia, todos	las	filas	de	la	
--tabla	ALUMNO a	la	tabla	ALUMNO_BACKUP.	La	copia	deberá	realizarse	con	una	única	
--instrucción.

CREATE TABLE ALUMNO_BACKUP
(nummatricula number(5),
nombre varchar2(150),
fechanacimiento DATE,
telefono varchar2(9),
CONSTRAINT pk_alumno_B PRIMARY KEY (nummatricula)
);
INSERT INTO ALUMNO_BACKUP
SELECT *FROM ALUMNO_BACKUP;
