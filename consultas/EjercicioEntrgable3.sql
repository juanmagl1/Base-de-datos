--1.Cuantos costes básicos hay.
SELECT COUNT (COSTEBASICO) FROM ASIGNATURA;
--2.Para cada titulación mostrar el número de asignaturas que hay junto con el nombre de la titulación.
SELECT TI.NOMBRE,COUNT(IDASIGNATURA)FROM TITULACION TI , ASIGNATURA AA   
WHERE TI.IDTITULACION = AA.IDTITULACION 
GROUP BY TI.NOMBRE;
--3.Para cada titulación mostrar el nombre de la titulación junto con el precio total de todas sus asignaturas.
SELECT TI.NOMBRE,SUM(AA.COSTEBASICO)FROM TITULACION TI , ASIGNATURA AA   WHERE TI.IDTITULACION = AA.IDTITULACION GROUP BY TI.NOMBRE;
--4.Cual sería el coste global de cursar la titulación de Matemáticas si el coste de cada asignatura fuera incrementado en un 7%. 
--NO HAY ASIGNATURAS QUE SE LLAMEN MATEMATICAS
SELECT AVG((AA.COSTEBASICO *7 /100) + AA.COSTEBASICO) 
FROM ASIGNATURA AA,TITULACION TI WHERE AA.IDTITULACION =130110;
--5.Cuantos alumnos hay matriculados en cada asignatura, junto al id de la asignatura. 
SELECT COUNT(IDALUMNO),IDASIGNATURA FROM ALUMNO_ASIGNATURA 
GROUP BY IDASIGNATURA;
--6.Igual que el anterior pero mostrando el nombre de la asignatura.
SELECT A.NOMBRE ,COUNT(AA.IDALUMNO) FROM ALUMNO_ASIGNATURA AA ,ASIGNATURA A
WHERE A.IDASIGNATURA= AA.IDASIGNATURA
GROUP BY A.NOMBRE;
--7.Mostrar para cada alumno, el nombre del alumno junto con lo que tendría que pagar por el total de todas las asignaturas en las que estï¿½ matriculada. 
--Recuerda que el precio de la matricula tiene un incremento de un 10% por cadaño en el que esté matriculado. 
SELECT P.NOMBRE,SUM(AA.COSTEBASICO),(AA.COSTEBASICO*ASIG.NUMEROMATRICULA)*0.1 AS PRECIO FROM PERSONA P,ASIGNATURA AA,ALUMNO AL ,ALUMNO_ASIGNATURA ASIG
WHERE P.DNI=AL.DNI 
AND AL.IDALUMNO=ASIG.IDALUMNO 
AND ASIG.IDASIGNATURA=AA.IDASIGNATURA
GROUP BY P.NOMBRE,AA.COSTEBASICO,ASIG.NUMEROMATRICULA;
--8.Coste medio de las asignaturas de cada titulación, para aquellas titulaciones en el que el coste total de la 1ï¿½ matrï¿½cula sea mayor que 60 euros. 
SELECT AVG(COSTEBASICO),t.NOMBRE FROM ASIGNATURA a,TITULACION t,ALUMNO_ASIGNATURA aa
WHERE aa.IDASIGNATURA = a.IDASIGNATURA AND a.IDTITULACION =t.IDTITULACION
AND aa.NUMEROMATRICULA =1
GROUP BY t.NOMBRE
HAVING sum(COSTEBASICO)>60;
--9.Nombre de las titulaciones  que tengan más de tres alumnos.
SELECT TI.NOMBRE FROM TITULACION TI ,ALUMNO A,ALUMNO_ASIGNATURA ASIG,ASIGNATURA AA 
WHERE A.IDALUMNO=ASIG.IDALUMNO AND ASIG.IDASIGNATURA=AA.IDASIGNATURA AND TI.IDTITULACION=AA.IDTITULACION
GROUP BY TI.NOMBRE
HAVING COUNT (ASIG.IDALUMNO)>3; 
--10.Nombre de cada ciudad junto con el número de personas que viven en ella.
SELECT  CIUDAD ,COUNT (NOMBRE) FROM PERSONA 
GROUP BY CIUDAD;
--11.Nombre de cada profesor junto con el número de asignaturas que imparte.
SELECT P.NOMBRE,COUNT (A.IDASIGNATURA) FROM ASIGNATURA A ,PROFESOR PR,PERSONA P
WHERE A.IDPROFESOR =PR.IDPROFESOR AND P.DNI=PR.DNI
GROUP BY P.NOMBRE;
--12.Nombre de cada profesor junto con el número de alumnos que tiene, para aquellos profesores que tengan dos o más de 2 alumnos.
SELECT P.NOMBRE,COUNT (AA.IDALUMNO) FROM ASIGNATURA A ,PROFESOR PR,PERSONA P,ALUMNO AL,ALUMNO_ASIGNATURA AA
WHERE AL.IDALUMNO=AA.IDALUMNO AND P.DNI=PR.DNI 
AND PR.IDPROFESOR=A.IDPROFESOR AND A.IDASIGNATURA=AA.IDASIGNATURA
GROUP BY P.NOMBRE
HAVING COUNT(AA.IDALUMNO)>=2;
--13.Obtener el máximo de las sumas de los costesbásicos de cada cuatrimestre
SELECT MAX(SUM(COSTEBASICO)) FROM ASIGNATURA GROUP BY IDASIGNATURA;
--14.Suma del coste de las asignaturas
SELECT SUM(COSTEBASICO) FROM ASIGNATURA;
--15.¿Cuántas asignaturas hay?
SELECT COUNT(IDASIGNATURA) FROM ASIGNATURA;
--16.Coste de la asignatura más cara y de la más barata
SELECT MAX(COSTEBASICO),MIN(COSTEBASICO) FROM ASIGNATURA;
--17.¿Cuántas posibilidades de créditos de asignatura hay?
SELECT count(DISTINCT CREDITOS) FROM ASIGNATURA;
--18.¿Cuántos cursos hay?
SELECT COUNT (DISTINCT NVL(CURSO,0)) FROM ASIGNATURA;
--19.Â¿Cuántas ciudades haY?
SELECT COUNT (DISTINCT CIUDAD) FROM PERSONA;
--20.Nombre y número de horas de todas las asignaturas.
SELECT DISTINCT  AA.NOMBRE,AA.CREDITOS *10 AS NUM_HORAS 
FROM ASIGNATURA AA ;
--21.Mostrar las asignaturas que no pertenecen a ninguna titulación.
SELECT  A.IDASIGNATURA ,A.NOMBRE FROM ASIGNATURA A
WHERE  A.IDTITULACION IS NULL;
--22.Listado del nombre completo de las personas, sus teléfonos y sus direcciones, 
--llamando a la columna del nombre "NombreCompleto" y a la de direcciones "Direccion".
SELECT NOMBRE || ' ' || APELLIDO || '' || TELEFONO || ' 'AS NOMBRECOMPLETO , DIRECCIONCALLE || ' ' || DIRECCIONNUM AS DIRECCION FROM PERSONA;
--23.Cual es el día siguiente al día en que nacieron las personas de la B.D.
SELECT SUM(EXTRACT(DAY FROM FECHA_NACIMIENTO+1)) FROM PERSONA GROUP BY DNI;
--24.Años de las personas de la Base de Datos, esta consulta tiene que valor para cualquier momento
SELECT EXTRACT(YEAR FROM SYSDATE) - EXTRACT( YEAR FROM FECHA_NACIMIENTO) FROM PERSONA;
--25.Listado de personas mayores de 25 años ordenadas por apellidos y nombre, esta consulta tiene que valor para cualquier momento
SELECT NOMBRE,APELLIDO ,SUM(EXTRACT(YEAR FROM SYSDATE) - EXTRACT( YEAR FROM FECHA_NACIMIENTO)) FROM PERSONA P
GROUP BY NOMBRE,APELLIDO
HAVING SUM(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM FECHA_NACIMIENTO))>25
ORDER BY NOMBRE,APELLIDO;
--26.Nombres completos de los profesores que además son alumnos
SELECT P.NOMBRE || ' '||P.APELLIDO AS NOMBRECOMPLETO FROM PERSONA P,PROFESOR PR,ALUMNO A
WHERE A.DNI =P.DNI AND PR.DNI=P.DNI;
--27.Suma de los créditos de las asignaturas de la titulación de Matemáticas
SELECT SUM(A.CREDITOS) FROM ASIGNATURA A,TITULACION TI WHERE TI.IDTITULACION=A.IDTITULACION AND UPPER(TI.NOMBRE)='MATEMATICAS';
--28.Número de asignaturas de la titulación de Matemáticas
SELECT COUNT(A.IDASIGNATURA) FROM ASIGNATURA A,TITULACION TI WHERE TI.IDTITULACION=A.IDTITULACION AND UPPER(TI.NOMBRE)='MATEMATICAS';
--29.¿Cuánto paga cada alumno por su matrícula?
SELECT DISTINCT  NVL(A.COSTEBASICO * ASIG.NUMEROMATRICULA,0),P.NOMBRE FROM ASIGNATURA A ,TITULACION TI ,ALUMNO_ASIGNATURA ASIG,PROFESOR PR
WHERE A.IDPROFESOR=PR.IDPROFESOR AND PR.DNI=P.DNI AND A.IDASIGNATURA=ASIG.IDASIGNATURA ;
--30.¿Cuántos alumnos hay matriculados en cada asignatura?
SELECT A.NOMBRE,COUNT(AA.IDALUMNO) FROM ASIGNATURA A , ALUMNO AL ,ALUMNO_ASIGNATURA AA 
WHERE A.IDASIGNATURA = AA.IDASIGNATURA 
AND AL.IDALUMNO=AA.IDALUMNO 
GROUP BY A.NOMBRE;

