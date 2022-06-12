--1. Mostrar el nombre y distrito de la/s estación/es que tiene/n un menor número de
--accesos.
SELECT e.NOMBRE , e.DISTRITO 
FROM ESTACION e,ACCESO a 
WHERE e.CODIGO =a.ESTACION
GROUP BY e.NOMBRE,e.DISTRITO 
HAVING count(e.CODIGO)= (SELECT min(count(a2.NUMERO_ACCESO)) 
						FROM ACCESO a2,ESTACION e2 
						WHERE a2.ESTACION =e2.CODIGO  
						GROUP BY e2.CODIGO );
--2. Mostrar todos los datos de la estación/es que no tiene/n acceso norte.
SELECT * FROM ESTACION e WHERE e.CODIGO NOT IN (SELECT estacion 
												FROM acceso 
												WHERE orientacion = 'N');
--3. Seleccionar todos los datos de la línea por donde pase el tren o trenes cuyo
--número de cochera asignado sea mayor.
SELECT l.*
FROM LINEA l, TREN t
WHERE l.CODIGO =t.LINEA 
AND t.COCHERA = (SELECT max(c.CODIGO) 
				FROM COCHERA c,tren t
				WHERE c.CODIGO=t.COCHERA);

--4. Mostrar cada uno de los distritos junto con el número de trenes con una velocidad
--máxima de 100 k/h que pasan por cualquier estación que pertenezca a ese distrito,
--siempre y cuando pasen más de tres trenes con una velocidad máxima de 100
--kilómetros por hora.
SELECT e.DISTRITO , count(t.CODIGO) FROM ESTACION e,COCHERA c,TREN t
WHERE e.CODIGO =c.ESTACION
AND c.CODIGO = t.COCHERA 
GROUP BY e.DISTRITO
HAVING count(t.CODIGO)> (SELECT count(t2.CODIGO) 
						FROM TREN t2
						WHERE t2.VELOCIDAD_MAXIMA =100
						HAVING count(t2.CODIGO)>3);
--5. Mostrar la estación por la que solo pasan líneas con cobertura CENTRO.
SELECT DISTINCT e.NOMBRE FROM estacion e,LINEA_ESTACION le
WHERE e.CODIGO =le.ESTACION 
AND le.LINEA IN (SELECT codigo 
				FROM linea 
				WHERE upper(cobertura)='CENTRO');
--6. Mostrar el nombre y distrito de la estación por la que pasan más líneas.
SELECT e.NOMBRE , e.DISTRITO  FROM ESTACION e,LINEA_ESTACION le
WHERE e.CODIGO =le.ESTACION 
GROUP BY e.NOMBRE , e.DISTRITO  
HAVING sum(le.LINEA)= (SELECT max(count(l2.CODIGO))   
					  FROM LINEA l2,LINEA_ESTACION le2 
					  WHERE l2.CODIGO=le2.LINEA
					  GROUP BY le2.ESTACION); 
--7. Muestra las diferentes orientaciones de los accesos de la estación donde se
--guarda el tren más nuevo.
--8. Mostrar el modelo del tren que pasa por más estaciones distintas.
SELECT t.MODELO FROM TREN t,LINEA_ESTACION le2,LINEA l2
WHERE t.LINEA = l2.CODIGO 
AND l2.CODIGO =le2.LINEA 
GROUP BY t.MODELO
HAVING count(le2.ESTACION) = (SELECT max(count(DISTINCT le.ESTACION)) 
										FROM TREN t , LINEA l , LINEA_ESTACION le
										WHERE t.LINEA =l.CODIGO 
										AND l.CODIGO =le.LINEA
										GROUP BY t.CODIGO);		

--9. Mostrar el nombre de la estación junto con el nombre de las líneas que pasan por esa
--estación, y el modelo y velocidad máxima de los trenes que tienen esa línea, junto con
--la localización de la cochera en la que duerme el tren y el nombre de la estación a la
--que pertenece la cochera. Ordenar los datos por línea y estación.
									
--10. Mostrar el nombre y distrito de las estaciones cuya capacidad en sus cocheras supere a
--la media de capacidad por estación.
SELECT DISTINCT e.NOMBRE,e.DISTRITO FROM ESTACION e,COCHERA c 
WHERE e.CODIGO =c.ESTACION
AND c.CAPACIDAD >(SELECT avg(nvl(c2.CAPACIDAD,0)) FROM COCHERA c2);									
--11. Añadir un campo numLineas a la tabla estacion, este campo contendrá el número de
--líneas que pasan por dicha estación. Rellena este campo con los datos existentes en la
--base de datos.
ALTER TABLE ESTACION ADD numLineas number(7);
INSERT INTO ESTACION (codigo,numLineas)
VALUES (27,(SELECT count(e.CODIGO) FROM ESTACION e)); 
					  
--Consultas varias
--12. Obtener el número de trenes que entraron entre los meses de enero y abril del año
--pasado.
SELECT count(t.CODIGO) FROM tren t
WHERE extract(MONTH FROM t.FECHA_ENTRADA) BETWEEN 1 AND 4
AND extract(YEAR FROM t.FECHA_ENTRADA) = EXTRACT(YEAR FROM sysdate)-1;

--13. Mostrar el número de accesos que hay de cada orientación menos del tipo 'S'
--mostrando también la orientación
SELECT count(a.NUMERO_ACCESO),ORIENTACION  FROM ACCESO a 
WHERE ORIENTACION !='S'
GROUP BY ORIENTACION;
--14. Mostrar cada uno de los distritos junto con el número de trenes con una velocidad
--máxima de 100 k/h que pasan por cualquier estación que pertenezca a ese distrito,
--siempre y cuando pasen más de tres trenes con una velocidad máxima de 100
--kilómetros por hora.
SELECT count(t.CODIGO), e.DISTRITO  
FROM ESTACION e, LINEA_ESTACION le , TREN t,LINEA l 
WHERE e.CODIGO =le.ESTACION 
AND le.LINEA = l.CODIGO
AND l.CODIGO =t.LINEA 
AND t.VELOCIDAD_MAXIMA = 100
GROUP BY e.DISTRITO 
HAVING count(t.CODIGO)>3;
--15. Mostrar el nombre de la estación junto con el nombre de las líneas que pasan por esa
--estación, y el modelo y velocidad máxima de los trenes que tienen esa línea, junto con
--la localización de la cochera en la que duerme el tren y el nombre de la estación a la
--que pertenece la cochera. Ordenar los datos por línea y estación.
SELECT distinct e.NOMBRE , l.NOMBRE , t.MODELO , t.VELOCIDAD_MAXIMA , c.LOCALIZACION, e2.NOMBRE AS estacion_cochera
FROM ESTACION e , LINEA_ESTACION le , LINEA l , TREN t , COCHERA c,ESTACION e2 
WHERE e.CODIGO =le.ESTACION 
AND le.LINEA =l.CODIGO 
AND l.CODIGO =t.LINEA 
AND t.COCHERA =c.CODIGO
AND c.ESTACION =e2.CODIGO
ORDER BY l.NOMBRE, e.NOMBRE;
--16. Mostrar el número total de “huecos” que hay en todas las cocheras de la base de
--datos. Es decir, que nos diga el número total de huecos.
SELECT sum(c.CAPACIDAD -count(t.CODIGO)) FROM COCHERA c , TREN t 
WHERE c.CODIGO =t.COCHERA
GROUP BY c.CAPACIDAD ;
--17. Sin realizar subconsultas deberás mostrar el nombre de las estaciones que no tengan
--ningún acceso.
SELECT e.NOMBRE FROM ESTACION e, ACCESO a
WHERE e.CODIGO =a.ESTACION(+)
AND a.ESTACION  IS NULL;
--18. Utilizando la sintaxis del INNER JOIN, realiza la siguiente consulta: Mostrar el
--nombre de la estación junto con el nombre de las líneas que pasan por esa estación, y
--el modelo y velocidad máxima de los trenes que tienen esa línea, junto con la
--localización de la cochera en la que duerme el tren y el nombre de la estación a la que
--pertenece la cochera.Ordenar los datos por línea y estación.
--19. Sin realizar subconsultas y utilizando OUTER JOIN pero sin usar (+) deberás
--mostrar el nombre de las estaciones que no tengan ningún acceso.
SELECT e.NOMBRE FROM ESTACION e
LEFT JOIN ACCESO a 
ON e.CODIGO =a.ESTACION
WHERE a.ESTACION IS NULL;
--20. ¿Qué palabra reservada permite unir dos consultas SELECT de modo que el resultado
--serán las filas que estén presentes en ambas consultas? Explícalo e indica una consulta
--de ejemplo donde la utilices.