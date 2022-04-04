--1.Mostrar el identificador de los alumnos matriculados 
--en cualquier asignatura excepto la '150212' y la '130113'.
SELECT IDALUMNO 
FROM ALUMNO a 
WHERE IDALUMNO IN (SELECT IDALUMNO  
				FROM ALUMNO_ASIGNATURA aa 
				WHERE IDASIGNATURA != '150212' AND IDASIGNATURA !='130113');
--2.	Mostrar el nombre de las asignaturas que tienen más créditos que "Seguridad Vial". 
SELECT NOMBRE  
FROM ASIGNATURA a2 
WHERE CREDITOS > (SELECT CREDITOS  
				FROM ASIGNATURA a 
				WHERE NOMBRE LIKE 'Seguridad Vial');
--3.	Obtener el Id de los alumnos matriculados en las asignaturas "150212" y "130113" a la vez. 
SELECT IDALUMNO 
FROM ALUMNO a 
WHERE IDALUMNO IN (SELECT aa.IDALUMNO 
				FROM ALUMNO_ASIGNATURA aa , ALUMNO_ASIGNATURA aa2 
				WHERE aa2.IDASIGNATURA ='150212' AND aa.IDASIGNATURA ='130113'
				AND aa.IDALUMNO=aa2.IDALUMNO);
--4.	Mostrar el Id de los alumnos matriculados en las asignatura "150212" ó "130113", 
--en una o en otra pero no en ambas a la vez. 
SELECT IDALUMNO 
FROM ALUMNO a 
WHERE IDALUMNO IN (SELECT DISTINCT IDALUMNO 
				FROM ALUMNO_ASIGNATURA aa 
				WHERE IDASIGNATURA ='150212' OR IDASIGNATURA ='130113' );

--5.	Mostrar el nombre de las asignaturas de la titulación "130110" 
--cuyos costes básicos sobrepasen el coste básico promedio por asignatura en esa titulación.
SELECT NOMBRE
FROM ASIGNATURA a 
WHERE IDTITULACION = '130110'
AND COSTEBASICO > (SELECT avg(nvl(COSTEBASICO,0)) 
				   FROM ASIGNATURA a2 
				   WHERE IDTITULACION = '130110');


--7.	Mostrar el Id de los alumnos matriculados en la asignatura "150212" pero no en la "130113". 
SELECT IDALUMNO 
FROM ALUMNO a 
WHERE IDALUMNO IN (SELECT IDALUMNO  
				   FROM ALUMNO_ASIGNATURA aa 
				   WHERE IDASIGNATURA = '150212' AND IDASIGNATURA !='130113');


--9.	Mostrar las personas que no son ni profesores ni alumnos.
SELECT NOMBRE FROM PERSONA p3 WHERE DNI NOT IN (SELECT p.DNI FROM PERSONA p , PROFESOR p2
										WHERE p.DNI =p2.DNI)
AND DNI NOT IN (SELECT p.DNI FROM PERSONA p, ALUMNO a
				WHERE p.DNI =a.DNI) ;
			
--10.	Mostrar el nombre de las asignaturas que tengan más créditos. 
SELECT NOMBRE FROM ASIGNATURA a WHERE CREDITOS =  (SELECT max(nvl(CREDITOS,0)) 
									FROM ASIGNATURA a2) ;

--11.	Lista de asignaturas en las que no se ha matriculado nadie. 
SELECT a.NOMBRE FROM ASIGNATURA a 
WHERE a.IDASIGNATURA NOT IN (SELECT DISTINCT IDASIGNATURA 
							FROM ALUMNO_ASIGNATURA aa);
--12.	Ciudades en las que vive algún profesor y también algún alumno. 
SELECT CIUDAD, DNI FROM PERSONA p 
WHERE DNI IN (SELECT DNI FROM PROFESOR p2)
AND DNI IN (SELECT DNI FROM ALUMNO a);