--1
SELECT NOMBRE_EMPRESA FROM EMPRESAPRODUCTORA e 
WHERE UPPER(CIUDAD_EMPRESA) LIKE 'HUELVA' OR UPPER(CIUDAD_EMPRESA) LIKE 'MÁLAGA'
OR UPPER(CIUDAD_EMPRESA) LIKE 'MALAGA'
ORDER BY NOMBRE_EMPRESA DESC;

--2 Mostrar los nombres de los destinos cuya ciudad contenga una b mayúscula o minúscula.
SELECT NOMBRE_DESTINO FROM DESTINO d WHERE upper(CIUDAD_DESTINO) LIKE '%B%';

--3. Obtener el código de los residuos con una cantidad superior a 4 del constituyente 116.
SELECT COD_RESIDUO  
FROM RESIDUO_CONSTITUYENTE rc 
WHERE rc.CANTIDAD >4 AND COD_CONSTITUYENTE =116;
--. Muestra el tipo de transporte, los kilómetros y el coste de los traslados realizados en
--diciembre de 1994.
SELECT t.TIPO_TRANSPORTE , KMS ,COSTE FROM TRASLADO t 
WHERE extract(YEAR FROM t.FECHA_ENVIO)=1994 AND extract(MONTH FROM t.FECHA_ENVIO)=12;
--Mostrar el código del residuo y el número de constituyentes de cada residuo.
SELECT COD_RESIDUO , count( COD_CONSTITUYENTE) FROM RESIDUO_CONSTITUYENTE rc
GROUP BY COD_RESIDUO;
-- 6. Mostrar la cantidad media de residuo vertida por las empresas durante el año 1994.
SELECT nvl(avg(nvl(CANTIDAD ,0)),0) FROM RESIDUO_EMPRESA re
WHERE EXTRACT(YEAR FROM fecha)=1994;

--7 Mostrar el mayor número de kilómetros de un traslado realizado el mes de marzo.
SELECT max(KMS) FROM TRASLADO t WHERE extract(MONTH FROM t.FECHA_ENVIO)=3;

--8 Mostrar el número de constituyentes distintos que genera cada empresa, mostrando también
--el nif de la empresa, para aquellas empresas que generen más de 4 constituyentes
SELECT count(DISTINCT rc.COD_CONSTITUYENTE), re.NIF_EMPRESA 
FROM RESIDUO_CONSTITUYENTE rc , RESIDUO r , RESIDUO_EMPRESA re 
WHERE rc.COD_RESIDUO = r.COD_RESIDUO AND r.COD_RESIDUO = re.COD_RESIDUO
GROUP BY re.NIF_EMPRESA
HAVING count(DISTINCT rc.COD_CONSTITUYENTE)>4;
--9 . Mostrar el nombre de las diferentes empresas que han enviado residuos que contenga la
--palabra metales en su descripción. Si ha mandado residuos, tiene que ser la tabla traslado
SELECT DISTINCT e.NOMBRE_EMPRESA FROM RESIDUO r , RESIDUO_EMPRESA re , EMPRESAPRODUCTORA e,TRASLADO t 
WHERE r.COD_RESIDUO = re.COD_RESIDUO AND re.NIF_EMPRESA  =e.NIF_EMPRESA AND e.NIF_EMPRESA =t.NIF_EMPRESA
AND upper(r.OD_RESIDUO) LIKE '%METALES%';
--10 Mostrar el número de envíos que se han realizado entre cada ciudad, indicando también la
--ciudad origen y la ciudad destino.
 --dudosa cual es la ciudad de origen
SELECT e.CIUDAD_EMPRESA AS origen ,d.CIUDAD_DESTINO AS destino , count(d.COD_DESTINO) 
FROM DESTINO d,TRASLADO t,EMPRESAPRODUCTORA e
WHERE d.COD_DESTINO = t.COD_DESTINO AND e.NIF_EMPRESA =t.NIF_EMPRESA
GROUP BY d.CIUDAD_DESTINO,e.CIUDAD_EMPRESA ;
--11 Mostrar el nombre de la empresa transportista que ha transportado para una empresa que
--esté en Málaga o en Huelva un residuo que contenga Bario o Lantano. Mostrar también la
--fecha del transporte
SELECT e2.NOMBRE_EMPTRANSPORTE 
FROM RESIDUO_CONSTITUYENTE rc, RESIDUO r,EMPRESAPRODUCTORA e, TRASLADO t, EMPRESATRANSPORTISTA e2
WHERE rc.COD_RESIDUO = r.COD_RESIDUO 
AND r.COD_RESIDUO = t.COD_RESIDUO 
AND t.NIF_EMPRESA =e.NIF_EMPRESA  
AND t.NIF_EMPTRANSPORTE = e2.NIF_EMPTRANSPORTE 
AND (upper(e.NOMBRE_EMPRESA) LIKE 'MALAGA' OR upper(e.NOMBRE_EMPRESA) LIKE 'HUELVA') 
AND (rc.COD_CONSTITUYENTE=111 OR rc.COD_CONSTITUYENTE=112);  
--12 . Mostrar el coste por kilómetro del total de traslados encargados por la empresa productora
--Carbonsur
SELECT round(sum(t.COSTE)/sum(t.KMS),2) FROM TRASLADO t , EMPRESAPRODUCTORA e
WHERE t.NIF_EMPRESA =e.NIF_EMPRESA AND upper(e.NOMBRE_EMPRESA) LIKE 'CARBONSUR';
--13 
SELECT count(COD_CONSTITUYENTE), COD_RESIDUO FROM RESIDUO_CONSTITUYENTE rc
GROUP BY COD_RESIDUO;
--14 Mostrar la descripción de los residuos y la fecha que se generó el residuo, para aquellos
--residuos que se han generado en los últimos 30 días por una empresa cuyo nombre tenga una
--c. La consulta debe ser válida para cualquier fecha y el listado debe aparecer ordenado por la
--descripción del residuo y la fecha.
--dudas que me pone que falta el parwntesis derecho
SELECT distinct re.FECHA,r.OD_RESIDUO FROM RESIDUO_EMPRESA re,RESIDUO r, EMPRESAPRODUCTORA e 
WHERE re.COD_RESIDUO =r.COD_RESIDUO 
AND re.NIF_EMPRESA =e.NIF_EMPRESA 
AND re.FECHA BETWEEN sysdate-30 AND sysdate
AND upper(e.NOMBRE_EMPRESA) LIKE '%C%' 
ORDER BY r.OD_RESIDUO , re.FECHA ;