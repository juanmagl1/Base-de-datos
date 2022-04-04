/*Apartado	1.	(1 punto)
Deberás	registrarte	en	la	base	de	datos	de	la	Universidad	como	un nuevo alumno/a	con	
tus	datos	personales	y	matricularte	de	la asignatura	“Contabilidad”.*/

INSERT INTO PERSONA VALUES ('47428086Q','Juan Manuel','Garcia','Brenes','Ramón y Cajal',16,'665274802',to_date('12/04/1994','DD/MM/YYYY'),1);
INSERT INTO ALUMNO VALUES ('A141414','47428086Q');
INSERT INTO ALUMNO_ASIGNATURA VALUES ('A141414','160002',1);

/*El	profesor	de	la asignatura	“Contabilidad” se	ha	cambiado	de	Universidad	por	lo	que
es	necesario darlo	de	baja de	la	base	de	datos y asignar	 la	asignatura de	“Contabilidad”
a	la	nueva	profesora	que	no	se	encuentra	en	el	sistema	cuyos	datos	son:
DNI:	 77222122K, NOMBRE Y	 APELLIDOS:	 MARTA LÓPEZ	 MARTOS,	 CIUDAD:	 SEVILLA,	
DIRECCIÓN: CALLE	 TARFIA,	 NÚMERO: 9,	 TELÉFONO:	 615891432,	 FECHA	 DE	
NACIMIENTO:	22	de	Julio	de	1981,	SEXO:	MUJER.*/
--Primero borramos todas las constraint para crearlas en on delete cascade
ALTER TABLE PROFESOR DROP CONSTRAINT SYS_C0011429;
ALTER TABLE PROFESOR ADD CONSTRAINT SYS_C0011429 FOREIGN KEY (DNI) REFERENCES PERSONA (DNI) ON DELETE CASCADE;
ALTER TABLE ASIGNATURA DROP CONSTRAINT SYS_C0011431;
ALTER TABLE ASIGNATURA ADD CONSTRAINT SYS_C0011431 FOREIGN KEY (IDPROFESOR) REFERENCES PROFESOR(IDPROFESOR) ON DELETE CASCADE;
ALTER TABLE ALUMNO_ASIGNATURA DROP CONSTRAINT SYS_C0011435;
ALTER TABLE ALUMNO_ASIGNATURA ADD CONSTRAINT SYS_C0011435 FOREIGN KEY (IDASIGNATURA) REFERENCES ASIGNATURA(IDASIGNATURA) ON DELETE CASCADE;
--PRIMERO BORRAMOS A LA PERSONA EN BASE DE DATOS MODIFICANDO TODAS LAS CLAVES AJENAS Y PONIENDOLAS ON DELETE CASCADE
DELETE FROM PERSONA 
WHERE DNI = '25252525A';
--PROCEDEMOS A CREAR A LA NUEVA PROFESORA
INSERT INTO PERSONA VALUES ('77222122K','MARTA','LÓPEZ MARTOS','SEVILLA','CALLE	TARFIA',9,'615891432',to_date('22/7/1981','DD/MM/YYYY'),0);
--creamos al profesor
INSERT INTO profesor VALUES ('P305','77222122K');
--PROCEDEMOS A CREAR LA TITULACION
INSERT INTO TITULACION VALUES ('17000','Contabilidad');
--PROCEDEMOS A CREAR LA ASIGNATURA
INSERT INTO ASIGNATURA VALUES ('160256','Contabilidad',4,1,80,'P305','17000',1);

/*Apartado	3.	 (1,5 puntos)	La	universidad	nos	ha	pedido	que	guardemos	en	una	nueva	
tabla	 llamada	 ALUMNOS_MUYREPETIDORES que	 tendrá	 las	 siguientes	 columnas	
IDASIGNATURA,	DNI,	NOMBRE,	APELLIDO	Y	TELÉFONO aquellos	alumnos	que	se	han	
matriculado	tres o	más	veces de	una	asignatura. Deberás	crear	en	primer	lugar	la	tabla	
y	luego	utilizando	una	única	sentencia	guardar	todos	los	datos	solicitados.*/

CREATE TABLE ALUMNOS_MUYREPETIDORES
(id_asignatura varchar2(8),
id_alumno varchar2(8),
nombre varchar2(150),
apellido varchar2(150),
telefono varchar2(9),
CONSTRAINT pk_alumnosMR PRIMARY KEY (id_asignatura,id_alumno),
CONSTRAINT fk_alumnosMR FOREIGN KEY (id_asignatura) REFERENCES asignatura (idasignatura) ON DELETE CASCADE,
CONSTRAINT fk2_alumnosMR FOREIGN KEY (id_alumno) REFERENCES alumno (idalumno) ON DELETE CASCADE
);
--Realizamos un insert de select desde la tabla alumno_asignatura
INSERT INTO ALUMNOS_MUYREPETIDORES 
SELECT alumno_asignatura.idasignatura,alumno_asignatura.idalumno,persona.nombre,persona.apellido,persona.telefono 
FROM alumno_asignatura,alumno,persona 
WHERE alumno_asignatura.idalumno=alumno.idalumno AND alumno.dni=persona.dni AND  NUMEROMATRICULA>=3;
--comprobamos si estan los datos
SELECT * FROM ALUMNOS_MUYREPETIDORES;
SELECT * FROM alumno_asignatura WHERE numeromatricula>=3;
/* Apartado 4. (1 puntos) Sobre	 la	 tabla	 creada	 anteriormente	
ALUMNOS_MUYREPETIDORES nos	han	pedido que	añadamos	una	nueva	columna	que	
se	llamará	“OBSERVACIONES”.	Para	los	alumnos/as existentes	en	la	tabla	que	residen
en	SEVILLA	y	cuyo	número	de	teléfono	contiene	el	20	se rellenara la	nueva	columna	con	
el	texto	“Se	encuentra	en	seguimiento”;*/
--creamos la columna 
ALTER TABLE alumnos_muyrepetidores ADD observaciones varchar2(250);
--añdimos al alumno
INSERT INTO alumnos_muyrepetidores 
SELECT alumno_asignatura.idasignatura,alumno_asignatura.idalumno,persona.nombre,persona.apellido,persona.telefono 
FROM alumno_asignatura,alumno,persona 
WHERE alumno_asignatura.idalumno=alumno.idalumno AND alumno.dni=persona.dni 
AND ciudad LIKE 'Sevilla' AND persona.telefono LIKE '%20%';
-- Actualizamos para ponerlo en se encuentra en seguimiento
UPDATE alumnos_muyrepetidores
SET observaciones = 'Se encuentra en seguimiento'
WHERE id_alumno IN (SELECT idalumno FROM persona,alumno WHERE ciudad LIKE 'Sevilla' AND persona.telefono LIKE '%20%' AND persona.dni=alumno.dni);
SELECT * FROM alumnos_muyrepetidores;

/* Apartado 5. (1 punto) De	 la tabla	 ALUMNOS_MUYREPETIDORES se	 desea	 borrar	
aquellos	nacidos	en	Noviembre	de	1971.*/

DELETE FROM alumnos_muyrepetidores 
WHERE id_alumno IN 
(SELECT idalumno FROM persona,alumno 
WHERE extract(YEAR FROM fecha_nacimiento)=1971 AND extract(MONTH FROM fecha_nacimiento)=11 
AND persona.dni=alumno.dni);

/* Apartado	 6.	 (1punto). Crear	 una	 nueva	 tabla	 cuyo	 nombre	 sea	
RESUMEN_TITULACIONES que	 tendrá	la	columna	NOMBRE_TITULACIÓN y	la	columna	
NUMEROASIGNATURAS.	 Deberá	 guardarse	 en	 esa	 nueva	 tabla	 mediante	 una	 única	
sentencia los nombres	de	la	titulaciones	y	cuantas	asignaturas	tiene	cada	titulación.*/
--creamos la tabla 
CREATE TABLE RESUMEN_TITULACIONES 
(id_titulacion  varchar2(150),
nombre_titulacion varchar2(150),
CONSTRAINT pk_resumen PRIMARY KEY (id_titulacion),
CONSTRAINT fk_resumen FOREIGN KEY (id_titulacion) REFERENCES titulacion (idtitulacion) ON DELETE CASCADE
);
--realizamos un insert de select para llevar los datos de la tabla titulacion a resumen_titulaciones
INSERT INTO resumen_titulaciones SELECT * FROM titulacion;

/* Apartado	7. Suponiendo	que	tenemos	el	AUTOCOMMIT desactivado,	¿Qué	pasaría	en	
las	siguientes	situaciones?/*

/*7.1 (0,5	puntos) Si	creo	una	nueva	tabla llamada	FACTURA en	la	base	de	datos	y	
posteriormente	 inserto	 datos sobre	 ella.	 ¿Podrá ver	 esos	 datos	 otro	
programador/a que	trabaje	en	tu	equipo	de	desarrollo y	que	tenga	acceso	a	
la	misma	base	de	datos?. Justifica	la	respuesta.*/
--No los puede ver, porque no le ha relizado el commit correspondiente, y al salirse y no persistir los datos mediante el commit
--y al ser una sentencia DML
--no lo puede ver el otro compañero

/* 7.2 (0,5	puntos) Si	posteriormente	creo	una	nueva	tabla CLIENTE en	la	base	de	
datos.	¿Quedarán	persistidos	los	datos	en	la	base	de	datos?	Indica	qué ocurre	
y	justifica	la	respuesta.*/

-- si se queda, porque es una instrucción DDL tiene el autocommit activado

/*7.3 (0,5	puntos) Posteriormente	nos	damos	cuenta	que	alguno	de	los datos	que	
inserté en	la	tabla	FACTURA no	son	correctos. ¿Puedo	volver	a	la	situación	
inicial con	alguna	operación?	Indica	cuál	en	caso	de	ser	posible	y	justifica	la	
respuesta.*/

--La instrucción seria un rollback, pero se podría volver a la situación inicial si no se hubiera echo un 
-- commit o una instruccion DDL

/* 7.4 . (0,5	 puntos) Inserto	 datos	 en	 la	 tabla	 CLIENTE	 y	 quiero	 que	 los	 datos	
queden	persistidos	en	la	base	de	datos.	¿Qué operación	necesito	realizar?	
Justifica	la	respuesta./*

--La operación es la sentencia commit;
--con esa instruccion todas las instrucciones quedan persistidas en la base de datos

/* 7.5 (0,5	 puntos) Posteriormente	 quiero	 borrar	solo	 algunos	 datos	 de	 la	 tabla	
CLIENTE pero	 por	 error	 he	 borrado	 todos	 los	 datos	 de	 la	 tabla.	 ¿Puedo	
realizar	algo	para	recuperar	los	datos	que	borre?.	Justifícalo	y	en	caso	de ser	
posible	indica	cómo	actuarias.*/

--Se usa la sentencia Rollback, que vuelve hasta el último commit realizado o hasta la ultima sentencia DDL
--realizada

/* (1 puntos) ¿En	qué	consiste	el	SAVEPOINT?	Explícalo detalladamente e	indica	
a	 modo	 de	 ejemplo	 las	 instrucciones	 necesarias	 donde	 se	 vea	 que	 has	
utilizado	varios	INSERT y	SAVEPOINT	de	forma	que	quede	bien	explicado	su	
funcionamiento.*/

--El Savepoint es un punto de control a la hora de hacer un rollback se puede hacer el rollback to y el nombre
--del Savepoint y no se borra todas las instrucciones que has realizado ni pierdes esos datos
/*Ejemplo:
 * INSERT INTO PERSONA(DNI,NOMBRE) VALUES ('2345643Y','JUANMA');
 * INSERT INTO PERSONA(DNI,NOMBRE) VALUES ('2345643Y','J');
 * INSERT INTO PERSONA(DNI,NOMBRE) VALUES ('2345623Y','MANUEL');
 * INSERT INTO PERSONA(DNI,NOMBRE) VALUES ('2345683Y','JUAN');
 * SAVEPOINT introducir_alumno
 * INSERT INTO PROFESOR (IDPROFESOR) VALUES ('P236');
 * INSERT INTO PROFESOR (IDPROFESOR) VALUES ('P234');
 * INSERT INTO PROFESOR (IDPROFESOR) VALUES ('P232');
 * INSERT INTO PROFESOR (IDPROFESOR) VALUES ('P231');
 * INSERT INTO PROFESOR (IDPROFESOR) VALUES ('P238');
 * Si ahora me he equivocado o me he olvidado algo, puedo hacer un rollback to introducir_alumno y todos 
 * los datos que he insertado con la sentencia insert que están despues del savepoint no apararecerán en la base
 * de datos
 */ 

TRUNCATE TABLE persona;