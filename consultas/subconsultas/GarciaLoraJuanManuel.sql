--1. Mostrar el nombre y distrito de la/s estaci�n/es que tiene/n un menor n�mero de
--accesos.
SELECT e.NOMBRE , e.DISTRITO 
FROM ESTACION e,ACCESO a 
WHERE e.CODIGO =a.ESTACION
GROUP BY e.NOMBRE,e.DISTRITO 
HAVING count(e.CODIGO)= (SELECT min(count(a2.NUMERO_ACCESO)) 
						FROM ACCESO a2,ESTACION e2 
						WHERE a2.ESTACION =e2.CODIGO  
						GROUP BY e2.CODIGO );
--2. Mostrar todos los datos de la estaci�n/es que no tiene/n acceso norte.
SELECT * FROM ESTACION e WHERE e.CODIGO NOT IN (SELECT estacion 
												FROM acceso 
												WHERE orientacion = 'N');
--3. Seleccionar todos los datos de la l�nea por donde pase el tren o trenes cuyo
--n�mero de cochera asignado sea mayor.
SELECT l.*
FROM LINEA l, TREN t
WHERE l.CODIGO =t.LINEA 
AND t.COCHERA = (SELECT max(c.CODIGO) 
				FROM COCHERA c,tren t
				WHERE c.CODIGO=t.COCHERA);

--4. Mostrar cada uno de los distritos junto con el n�mero de trenes con una velocidad
--m�xima de 100 k/h que pasan por cualquier estaci�n que pertenezca a ese distrito,
--siempre y cuando pasen m�s de tres trenes con una velocidad m�xima de 100
--kil�metros por hora.
SELECT e.DISTRITO , count(t.CODIGO) FROM ESTACION e,COCHERA c,TREN t
WHERE e.CODIGO =c.ESTACION
AND c.CODIGO = t.COCHERA 
GROUP BY e.DISTRITO
HAVING count(t.CODIGO)> (SELECT count(t2.CODIGO) 
						FROM TREN t2
						WHERE t2.VELOCIDAD_MAXIMA =100
						HAVING count(t2.CODIGO)>3);
--5. Mostrar la estaci�n por la que solo pasan l�neas con cobertura CENTRO.
SELECT DISTINCT e.NOMBRE FROM estacion e,LINEA_ESTACION le
WHERE e.CODIGO =le.ESTACION 
AND le.LINEA IN (SELECT codigo 
				FROM linea 
				WHERE upper(cobertura)='CENTRO');
--6. Mostrar el nombre y distrito de la estaci�n por la que pasan m�s l�neas.
SELECT e.NOMBRE , e.DISTRITO  FROM ESTACION e,LINEA_ESTACION le
WHERE e.CODIGO =le.ESTACION 
GROUP BY e.NOMBRE , e.DISTRITO  
HAVING sum(le.LINEA)= (SELECT max(count(l2.CODIGO))   
					  FROM LINEA l2,LINEA_ESTACION le2 
					  WHERE l2.CODIGO=le2.LINEA
					  GROUP BY le2.ESTACION); 
--7. Muestra las diferentes orientaciones de los accesos de la estaci�n donde se
--guarda el tren m�s nuevo.
--8. Mostrar el modelo del tren que pasa por m�s estaciones distintas.
SELECT t.MODELO FROM TREN t,LINEA_ESTACION le2,LINEA l2
WHERE t.LINEA = l2.CODIGO 
AND l2.CODIGO =le2.LINEA 
GROUP BY t.MODELO
HAVING count(le2.ESTACION) = (SELECT max(count(DISTINCT le.ESTACION)) 
										FROM TREN t , LINEA l , LINEA_ESTACION le
										WHERE t.LINEA =l.CODIGO 
										AND l.CODIGO =le.LINEA
										GROUP BY t.CODIGO);		

--9. Mostrar el nombre de la estaci�n junto con el nombre de las l�neas que pasan por esa
--estaci�n, y el modelo y velocidad m�xima de los trenes que tienen esa l�nea, junto con
--la localizaci�n de la cochera en la que duerme el tren y el nombre de la estaci�n a la
--que pertenece la cochera. Ordenar los datos por l�nea y estaci�n.
									
--10. Mostrar el nombre y distrito de las estaciones cuya capacidad en sus cocheras supere a
--la media de capacidad por estaci�n.
SELECT DISTINCT e.NOMBRE,e.DISTRITO FROM ESTACION e,COCHERA c 
WHERE e.CODIGO =c.ESTACION
AND c.CAPACIDAD >(SELECT avg(nvl(c2.CAPACIDAD,0)) FROM COCHERA c2);									
--11. A�adir un campo numLineas a la tabla estacion, este campo contendr� el n�mero de
--l�neas que pasan por dicha estaci�n. Rellena este campo con los datos existentes en la
--base de datos.
ALTER TABLE ESTACION ADD numLineas number(7);
INSERT INTO ESTACION (codigo,numLineas)
VALUES (27,(SELECT count(e.CODIGO) FROM ESTACION e)); 
					  
--Consultas varias
--12. Obtener el n�mero de trenes que entraron entre los meses de enero y abril del a�o
--pasado.
SELECT count(t.CODIGO) FROM tren t
WHERE extract(MONTH FROM t.FECHA_ENTRADA) BETWEEN 1 AND 4
AND extract(YEAR FROM t.FECHA_ENTRADA) = EXTRACT(YEAR FROM sysdate)-1;

--13. Mostrar el n�mero de accesos que hay de cada orientaci�n menos del tipo 'S'
--mostrando tambi�n la orientaci�n
SELECT count(a.NUMERO_ACCESO),ORIENTACION  FROM ACCESO a 
WHERE ORIENTACION !='S'
GROUP BY ORIENTACION;
--14. Mostrar cada uno de los distritos junto con el n�mero de trenes con una velocidad
--m�xima de 100 k/h que pasan por cualquier estaci�n que pertenezca a ese distrito,
--siempre y cuando pasen m�s de tres trenes con una velocidad m�xima de 100
--kil�metros por hora.
SELECT count(t.CODIGO), e.DISTRITO  
FROM ESTACION e, LINEA_ESTACION le , TREN t,LINEA l 
WHERE e.CODIGO =le.ESTACION 
AND le.LINEA = l.CODIGO
AND l.CODIGO =t.LINEA 
AND t.VELOCIDAD_MAXIMA = 100
GROUP BY e.DISTRITO 
HAVING count(t.CODIGO)>3;
--15. Mostrar el nombre de la estaci�n junto con el nombre de las l�neas que pasan por esa
--estaci�n, y el modelo y velocidad m�xima de los trenes que tienen esa l�nea, junto con
--la localizaci�n de la cochera en la que duerme el tren y el nombre de la estaci�n a la
--que pertenece la cochera. Ordenar los datos por l�nea y estaci�n.
SELECT distinct e.NOMBRE , l.NOMBRE , t.MODELO , t.VELOCIDAD_MAXIMA , c.LOCALIZACION, e2.NOMBRE AS estacion_cochera
FROM ESTACION e , LINEA_ESTACION le , LINEA l , TREN t , COCHERA c,ESTACION e2 
WHERE e.CODIGO =le.ESTACION 
AND le.LINEA =l.CODIGO 
AND l.CODIGO =t.LINEA 
AND t.COCHERA =c.CODIGO
AND c.ESTACION =e2.CODIGO
ORDER BY l.NOMBRE, e.NOMBRE;
--16. Mostrar el n�mero total de �huecos� que hay en todas las cocheras de la base de
--datos. Es decir, que nos diga el n�mero total de huecos.
SELECT sum(c.CAPACIDAD -count(t.CODIGO)) FROM COCHERA c , TREN t 
WHERE c.CODIGO =t.COCHERA
GROUP BY c.CAPACIDAD ;
--17. Sin realizar subconsultas deber�s mostrar el nombre de las estaciones que no tengan
--ning�n acceso.
SELECT e.NOMBRE FROM ESTACION e, ACCESO a
WHERE e.CODIGO =a.ESTACION(+)
AND a.ESTACION  IS NULL;
--18. Utilizando la sintaxis del INNER JOIN, realiza la siguiente consulta: Mostrar el
--nombre de la estaci�n junto con el nombre de las l�neas que pasan por esa estaci�n, y
--el modelo y velocidad m�xima de los trenes que tienen esa l�nea, junto con la
--localizaci�n de la cochera en la que duerme el tren y el nombre de la estaci�n a la que
--pertenece la cochera.Ordenar los datos por l�nea y estaci�n.
--19. Sin realizar subconsultas y utilizando OUTER JOIN pero sin usar (+) deber�s
--mostrar el nombre de las estaciones que no tengan ning�n acceso.
SELECT e.NOMBRE FROM ESTACION e
LEFT JOIN ACCESO a 
ON e.CODIGO =a.ESTACION
WHERE a.ESTACION IS NULL;
--20. �Qu� palabra reservada permite unir dos consultas SELECT de modo que el resultado
--ser�n las filas que est�n presentes en ambas consultas? Expl�calo e indica una consulta
--de ejemplo donde la utilices.