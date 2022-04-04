--1
SELECT DISTINCT COSTEBASICO,NOMBRE FROM ASIGNATURA a
ORDER BY COSTEBASICO DESC, nombre asc;
--2
SELECT nombre, apellido FROM PERSONA p ,PROFESOR p2  
WHERE p.DNI =p2.DNI; 
--3
SELECT a.NOMBRE FROM ASIGNATURA a ,PROFESOR p2 ,PERSONA p 
WHERE p.DNI =p2.DNI AND p2.IDPROFESOR =a.IDPROFESOR AND p.CIUDAD ='Sevilla';  
--4
SELECT p.NOMBRE,p.APELLIDO FROM PERSONA p,ALUMNO a
WHERE p.DNI = a.dni;
--5
SELECT p.NOMBRE,p.APELLIDO,p.DNI  FROM PERSONA p,ALUMNO a
WHERE p.DNI = a.dni AND p.CIUDAD = 'Sevilla'; 
--6
SELECT p.DNI ,p.NOMBRE ,p.APELLIDO  
FROM PERSONA p , ALUMNO a, ALUMNO_ASIGNATURA aa,ASIGNATURA a2 
WHERE p.DNI =a.DNI AND a.IDALUMNO = aa.IDALUMNO AND aa.IDASIGNATURA =a2.IDASIGNATURA 
AND a2.NOMBRE ='Seguridad Vial';
--7
SELECT DISTINCT a2.IDTITULACION  FROM ALUMNO a, ALUMNO_ASIGNATURA aa, ASIGNATURA a2
WHERE a.IDALUMNO =aa.IDALUMNO 
AND aa.IDASIGNATURA = a2.IDASIGNATURA 
AND a.DNI LIKE '20202020A';
--8
SELECT a2.NOMBRE 
FROM PERSONA p , ALUMNO a, ALUMNO_ASIGNATURA aa,ASIGNATURA a2 
WHERE p.DNI =a.DNI 
AND a.IDALUMNO = aa.IDALUMNO 
AND aa.IDASIGNATURA =a2.IDASIGNATURA 
AND upper(p.NOMBRE) LIKE 'ROSA' 
AND UPPER(p.APELLIDO) LIKE 'GARCIA';
--9 
SELECT a2.DNI  
FROM PERSONA p,PROFESOR p2,ASIGNATURA a,ALUMNO_ASIGNATURA aa,ALUMNO a2
WHERE p.DNI =p2.DNI AND p2.IDPROFESOR =a.IDPROFESOR AND a.IDASIGNATURA =aa.IDASIGNATURA AND
aa.IDALUMNO =a2.IDALUMNO AND p.NOMBRE LIKE 'Jorge' AND p.APELLIDO LIKE 'Saenz';
--10
SELECT a2.DNI,p3.NOMBRE,p3.APELLIDO  
FROM PERSONA p,PROFESOR p2,ASIGNATURA a,ALUMNO_ASIGNATURA aa,ALUMNO a2, PERSONA p3
WHERE p.DNI =p2.DNI AND p2.IDPROFESOR =a.IDPROFESOR AND a.IDASIGNATURA =aa.IDASIGNATURA AND
aa.IDALUMNO =a2.IDALUMNO AND a2.DNI  =p3.DNI AND p.NOMBRE LIKE 'Jorge' AND p.APELLIDO LIKE 'Saenz';
--11
SELECT t.NOMBRE FROM TITULACION t,ASIGNATURA a
WHERE t.IDTITULACION = a.IDTITULACION AND a.CREDITOS =4;
--12
SELECT a.NOMBRE ,a.CREDITOS,t.NOMBRE  FROM ASIGNATURA a, TITULACION t 
WHERE a.IDTITULACION =t.IDTITULACION AND a.CUATRIMESTRE =1; 
--13
SELECT a.NOMBRE,a.COSTEBASICO ,p.NOMBRE FROM ASIGNATURA a,ALUMNO_ASIGNATURA aa ,ALUMNO a2 ,PERSONA p
WHERE a.IDASIGNATURA =aa.IDASIGNATURA AND aa.IDALUMNO =a2.IDALUMNO AND a2.DNI =p.DNI AND a.CREDITOS >4.5;
--14
SELECT p.NOMBRE FROM PERSONA p,PROFESOR p2, ASIGNATURA a
WHERE p.DNI =p2.DNI AND p2.IDPROFESOR = a.IDPROFESOR AND a.COSTEBASICO BETWEEN 25 AND 30;
--15 duda posici�n de los parentesis
SELECT p.NOMBRE  FROM PERSONA p,ALUMNO a , ALUMNO_ASIGNATURA aa
WHERE p.DNI =a.DNI 
AND a.IDALUMNO =aa.IDALUMNO 
AND (aa.IDASIGNATURA = '150212' OR aa.IDASIGNATURA = '130113' 
OR (aa.IDASIGNATURA = '150212' AND aa.IDASIGNATURA = '130113'));
--16
SELECT a.NOMBRE,t.NOMBRE  FROM ASIGNATURA a, TITULACION t
WHERE a.IDTITULACION = t.IDTITULACION AND a.CUATRIMESTRE =2 AND a.CREDITOS !=6;
--17 habria que ver como se agrupan para que no salgan repetidos
SELECT a.NOMBRE ,a.CREDITOS *10 AS numero_horas,a2.DNI FROM ASIGNATURA a, ALUMNO_ASIGNATURA aa, ALUMNO a2 
WHERE a.IDASIGNATURA =aa.IDASIGNATURA 
AND aa.IDALUMNO =a2.IDALUMNO; 
--18
SELECT p.NOMBRE FROM PERSONA p, ALUMNO a , ALUMNO_ASIGNATURA aa
WHERE p.DNI =a.DNI AND a.IDALUMNO =aa.IDALUMNO AND p.VARON =0 AND p.CIUDAD LIKE 'Sevilla';
--estas consultas para ver que elena es profesora y alumna
SELECT persona.nombre,persona.apellido,persona.dni FROM persona,profesor WHERE persona.dni=profesor.dni;
SELECT persona.nombre,persona.apellido,persona.dni FROM persona,alumno WHERE persona.dni=alumno.dni;
--19
SELECT nombre FROM ASIGNATURA a WHERE CURSO =1 AND UPPER(IDPROFESOR) = 'P101';
--20
SELECT p.NOMBRE  FROM PERSONA p ,ALUMNO a,ALUMNO_ASIGNATURA aa
WHERE p.DNI =a.DNI 
AND a.IDALUMNO =aa.IDALUMNO 
AND aa.NUMEROMATRICULA >=3;