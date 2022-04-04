--1
SELECT DISTINCT nacionalidad 
FROM pelicula;

--2
SELECT DISTINCT CIP , FECHA_ESTRENO ,RECAUDACION 
FROM PROYECCION p
WHERE FECHA_ESTRENO < to_date('22/09/1997','DD/MM/YYYY')
ORDER BY RECAUDACION desc;

--3 
SELECT DISTINCT CIP , RECAUDACION , ESPECTADORES  
FROM PROYECCION p
WHERE ESPECTADORES >3000 OR RECAUDACION >= 2000000
ORDER BY ESPECTADORES DESC;

--4 
SELECT CINE 
FROM CINE c
WHERE upper(DIRECCION_CINE) LIKE '%AR%';

-- 5
SELECT CINE , SUM(nvl(AFORO,0)) 
FROM SALA s
GROUP BY CINE
HAVING SUM(nvl(AFORO,0))>600
ORDER BY SUM(nvl(AFORO,0)) DESC;

--6 
SELECT DISTINCT p.TITULO_P 
FROM PELICULA p , PROYECCION p2
WHERE p.CIP = p2.CIP
AND EXTRACT(DAY FROM p2.FECHA_ESTRENO) BETWEEN 1 AND 15;

--7 
SELECT NACIONALIDAD , avg(nvl(PRESUPUESTO,0)) 
FROM pelicula
WHERE PRESUPUESTO >500
GROUP BY NACIONALIDAD;

--8 
SELECT NOMBRE_PERSONA , SEXO_PERSONA  
FROM personaje
WHERE (NOMBRE_PERSONA LIKE '%n' 
OR NOMBRE_PERSONA LIKE '%s' OR NOMBRE_PERSONA LIKE '%e')
AND (SEXO_PERSONA IS NULL);

--9
SELECT p.TITULO_P 
FROM PELICULA p , PROYECCION p2
WHERE p.CIP =p2.CIP
GROUP BY p.TITULO_P 
HAVING sum(nvl(p2.DIAS_ESTRENO,0))>50;

--10
SELECT distinct c.CINE , c.DIRECCION_CINE ,c.CIUDAD_CINE,s.SALA,s.AFORO,p2.TITULO_P
FROM CINE c, SALA s, PROYECCION p, PELICULA p2
WHERE c.CINE =s.CINE 
AND s.CINE = p.CINE
AND s.SALA =p.SALA
AND p.CIP = p2.CIP
ORDER BY c.CINE, s.SALA,p2.TITULO_P;

--11
SELECT tarea,count(DISTINCT NOMBRE_PERSONA) 
FROM TRABAJO t
GROUP BY tarea;

--12 
SELECT DISTINCT p.* 
FROM PELICULA p, PROYECCION p2
WHERE p.CIP = p2.CIP
AND p2.FECHA_ESTRENO BETWEEN to_date('20/09/1995','DD/MM/YYYY') AND to_date('15/12/1995','DD/MM/YYYY');

--13 
SELECT c.CINE,c.CIUDAD_CINE, count(DISTINCT p.CIP)
FROM CINE c,SALA s, PROYECCION p
WHERE c.CINE =s.CINE 
AND s.CINE =p.CINE 
AND s.SALA =p.SALA 
GROUP BY c.CINE,c.CIUDAD_CINE
HAVING count(DISTINCT p.CIP)>=22;

--14
SELECT DISTINCT p2.TITULO_P , p2.PRESUPUESTO  
FROM PELICULA p2 ,PROYECCION p,SALA s,CINE c
WHERE p2.CIP =p.CIP  
AND p.CINE =s.CINE 
AND p.SALA =s.SALA 
AND s.CINE =c.CINE
AND p2.NACIONALIDAD = 'EE.UU'
AND upper(c.CIUDAD_CINE) LIKE 'CORDOBA';

--15 
SELECT p.TITULO_P , sum(nvl(p2.RECAUDACION,0)) 
FROM PELICULA p, PROYECCION p2
WHERE p.CIP =p2.CIP
AND p.TITULO_P LIKE '%vi%'
OR p.TITULO_P LIKE '%7%'
GROUP BY p.TITULO_P;

--16
SELECT max(nvl(PRESUPUESTO,0)) AS presupuesto_Maximo,min(nvl(PRESUPUESTO,0)) AS presupuesto_Minimo 
FROM PELICULA p;

--17
/*
 * El Outer join es un tipo de uni�n de tablas que nos muestra los datos que cumplen con la condici�n e
 * incluyen valores nulos.
 * 
 * Ejemplo:
 * el enunciado seria este:
 * Mostrar todos los datos de pel�culas junto con los datos de sus proyecciones. En
	este listado deben aparecer tanto las pel�culas que tienes proyecciones como las
	que no tienen proyecci�n.
	La sentencia ser�a esta: 
	SELECT p.*,p2.* FROM PELICULA p , PROYECCION p2
	WHERE p.CIP =p2.CIP(+); 
	En el lado que tenemos los valores nulos, se le pone el (+) en la condici�n
 */

--18
SELECT p.*,add_months(p.FECHA_ESTRENO,2) AS fecha_estimada
FROM PROYECCION p;

--19
SELECT p.*,p2.* FROM PELICULA p , PROYECCION p2
WHERE p.CIP =p2.CIP(+);

--20
SELECT count(nvl(t.NOMBRE_PERSONA,0)), p.TITULO_P
FROM PELICULA p, TRABAJO t
WHERE p.CIP =t.CIP 
GROUP BY p.TITULO_P
ORDER BY p.TITULO_P ASC;