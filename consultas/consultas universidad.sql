--1
SELECT nombre,creditos FROM asignatura;
--2
SELECT DISTINCT creditos FROM asignatura;
--3
SELECT * FROM persona;
--4
SELECT nombre,creditos FROM asignatura WHERE cuatrimestre =1;
--5
SELECT nombre,apellido FROM persona WHERE FECHA_NACIMIENTO < TO_date('01/01/1975','DD/MM/YYYY');
--6
SELECT nombre,costebasico FROM ASIGNATURA a WHERE CREDITOS > 4.5;
--7 
SELECT nombre FROM asignatura WHERE COSTEBASICO BETWEEN 25 AND 35;
--8 
SELECT idalumno FROM ALUMNO_ASIGNATURA aa WHERE idasignatura= '150212' OR idasignatura = '130113' OR (idasignatura = '130113' AND idasignatura= '150212') ;
--9
SELECT nombre FROM asignatura WHERE CUATRIMESTRE =2 AND CREDITOS !=6;
--10
SELECT nombre,apellido FROM persona WHERE APELLIDO LIKE 'G%';
--11
SELECT nombre FROM ASIGNATURA a WHERE IDTITULACION IS NULL;
--12
SELECT nombre FROM ASIGNATURA a WHERE IDTITULACION IS NOT NULL;
--13
SELECT nombre FROM asignatura WHERE (COSTEBASICO)>8;
--14
SELECT nombre,(creditos*10) AS numero_horas FROM ASIGNATURA a;
--cuando sale nulo para quitar esos valores se usa la funcion nvl que los nulos los pasa a 0
--SELECT nombre,nvl(creditos,0)*10 AS numero_horas FROM ASIGNATURA a;
--15
SELECT * 
FROM asignatura 
WHERE CUATRIMESTRE =2
ORDER BY IDASIGNATURA;
--16
SELECT nombre FROM persona WHERE CIUDAD LIKE 'Madrid' AND varon ='0';
--17
SELECT nombre,telefono FROM persona WHERE telefono LIKE '91%';
--18
SELECT nombre FROM asignatura WHERE upper(NOMBRE) LIKE '%PRO%';
--19 
SELECT  nombre FROM asignatura a
WHERE a.CURSO =1 AND a.IDPROFESOR ='P101'; 
--20
SELECT idalumno,idasignatura FROM ALUMNO_ASIGNATURA aa 
WHERE NUMEROMATRICULA >=3;
--21
SELECT nombre,COSTEBASICO, COSTEBASICO +(COSTEBASICO*0.1) AS primera_repeticion, 
COSTEBASICO +(COSTEBASICO*0.3) AS segunda_repeticion, 
COSTEBASICO +(COSTEBASICO*0.6) AS tercera_repeticion
FROM asignatura;

--22
SELECT * FROM persona 
WHERE extract(YEAR FROM fecha_nacimiento)<1970;

--23
SELECT DISTINCT dni FROM profesor;

--24
SELECT idalumno FROM ALUMNO_ASIGNATURA aa 
WHERE IDASIGNATURA LIKE '130122';

--25
SELECT DISTINCT idasignatura FROM ALUMNO_ASIGNATURA aa 
WHERE NUMEROMATRICULA >=1;

--26
SELECT nombre FROM ASIGNATURA a 
WHERE CREDITOS >4 AND (CUATRIMESTRE=1 OR CURSO=1);

--27
SELECT DISTINCT idtitulacion FROM ASIGNATURA a WHERE IDTITULACION IS NOT NULL;

--28
--al usar el upper ya lo haces en las 2 formas tanto en mayusculas como en minusculas
SELECT dni FROM PERSONA p 
WHERE upper(apellido) LIKE '%G%'; 

--29
SELECT * FROM persona 
WHERE varon=1 AND extract(YEAR FROM fecha_nacimiento) >1970 AND ciudad LIKE 'M%';