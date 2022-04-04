--1.	Número de clientes que tienen alguna factura con IVA 16%.
SELECT count(CODCLI) 
FROM FACTURAS f 
WHERE IVA =16;

SELECT count(CODCLI) 
FROM CLIENTES c
WHERE CODCLI IN (SELECT CODCLI 
FROM FACTURAS f 
WHERE IVA =16);

--2.	Número de clientes que no tienen ninguna factura con un 16% de IVA.
SELECT count(CODCLI) 
FROM FACTURAS f 
WHERE IVA !=16;

SELECT count(CODCLI) 
FROM CLIENTES c
WHERE CODCLI IN (SELECT CODCLI 
FROM FACTURAS f 
WHERE IVA !=16);
--3.	Número de clientes que en todas sus facturas tienen un 16% de IVA 
--(los clientes deben tener al menos una factura).
SELECT count(CODCLI) 
FROM CLIENTES c 
WHERE CODCLI IN (SELECT CODCLI 
				FROM FACTURAS f
				WHERE f.IVA=16
				HAVING count(f.CODFAC)>=1
				GROUP BY CODCLI,f);
--4.	Fecha de la factura con mayor importe (sin tener en cuenta descuentos ni impuestos).
SELECT f2.FECHA 
FROM FACTURAS f2 ,LINEAS_FAC lf2 
WHERE f2.CODFAC =lf2.CODFAC 
AND lf2.PRECIO = (
SELECT max(lf.PRECIO)
FROM FACTURAS f,LINEAS_FAC lf 
WHERE f.CODFAC =lf.CODFAC);
--5.	Número de pueblos en los que no tenemos clientes.
--Como dice que no tenemos clientes se pone el nulo en los clientes
SELECT count(p.CODPUE) FROM PUEBLOS p , CLIENTES c
WHERE p.CODPUE =c.CODPUE(+)
AND c.CODPUE IS NULL;
--6.	Número de artículos cuyo stock supera las 20 unidades, 
--con precio superior a 15 euros y de los que no hay ninguna factura en el último trimestre del año pasado.
SELECT count(a.CODART)FROM LINEAS_FAC lf ,ARTICULOS a 
WHERE lf.CODART =a.CODART 
AND a.STOCK >20 AND lf.PRECIO >15
AND CODFAC NOT IN (SELECT CODFAC 
				FROM FACTURAS f 
				WHERE EXTRACT(MONTH FROM fecha) BETWEEN 10 AND 12 
				AND EXTRACT(YEAR FROM fecha)=EXTRACT(YEAR FROM sysdate)-1);
--7.	Obtener el número de clientes que en todas las facturas del año pasado han pagado 
--IVA (no se ha pagado IVA si es cero o nulo).
SELECT count(CODCLI)
FROM FACTURAS f 
WHERE f.IVA IS NULL and f.IVA =0
AND EXTRACT(YEAR FROM fecha)=EXTRACT(YEAR FROM sysdate)-1;
--8.	Clientes (código y nombre) que fueron preferentes durante el mes de noviembre del año pasado 
--y que en diciembre de ese mismo año no tienen ninguna factura. 
--Son clientes preferentes de un mes aquellos que han solicitado más de 
--60,50 euros en facturas durante ese mes, sin tener en cuenta descuentos ni impuestos.
SELECT c.CODCLI ,c.NOMBRE 
FROM CLIENTES c , (SELECT f.CODCLI ,f.fecha
				   FROM LINEAS_FAC lf,FACTURAS f 
				   WHERE lf.CODFAC =f.CODFAC 
				   AND EXTRACT(YEAR FROM f.FECHA)=EXTRACT(YEAR FROM sysdate)-1
				   AND EXTRACT(MONTH FROM f.FECHA)=11
				   GROUP BY f.CODCLI, f.fecha
				   HAVING sum(lf.PRECIO)>60.50) cliente_preferente
WHERE c.CODCLI = cliente_preferente.codcli 
AND EXTRACT(YEAR FROM cliente_preferente.FECHA)=EXTRACT(YEAR FROM sysdate)-1
AND EXTRACT(MONTH FROM cliente_preferente.FECHA)=12;
--9.	Código, descripción y precio de los diez artículos más caros.
-- Para poder poner el rownum tienes que poner la sub en el from sino no te deja
SELECT *
FROM (SELECT CODART,descrip,precio 
	  FROM ARTICULOS a 
	  ORDER BY a.PRECIO desc)
WHERE rownum<=10;
--10.	Nombre de la provincia con mayor número de clientes.
--tenia que agrupar por codpro y unir tambien la tabla provincia
SELECT p.NOMBRE 
FROM PROVINCIAS p,PUEBLOS p2 ,CLIENTES c 
WHERE p.CODPRO =p2.CODPRO 
AND p2.CODPUE =c.CODPUE
GROUP BY p.NOMBRE
HAVING count(c.CODCLI) = (SELECT max(count(c2.codcli)) 
						FROM CLIENTES c2,PUEBLOS p4,PROVINCIAS p3 
						WHERE c2.CODPUE=p4.codpue 
						AND p3.CODPRO =p4.CODPRO 
						GROUP BY p3.CODPRO);


--11.	Código y descripción de los artículos cuyo precio es mayor de 
--90,15 euros y se han vendido menos de 10 unidades (o ninguna) durante el año pasado.
--Bien
SELECT a.CODART , a.DESCRIP  
FROM LINEAS_FAC lf , ARTICULOS a, FACTURAS f  
WHERE lf.CODART = a.CODART 
AND f.CODFAC =lf.CODFAC 
AND a.PRECIO >90.15 
AND EXTRACT(YEAR FROM f.FECHA)=EXTRACT(YEAR FROM sysdate)-1
GROUP BY a.CODART , a.DESCRIP
HAVING count(lf.CODART)<=10 OR count(lf.CODART)=0 ;
--12.	Código y descripción de los artículos cuyo precio es más de 
--tres mil veces mayor que el precio mínimo de cualquier artículo.
SELECT DISTINCT CODART , DESCRIP FROM ARTICULOS a 
WHERE precio > (SELECT min(PRECIO)*3000 
					  FROM ARTICULOS a2);
					 
--13.	Nombre del cliente con mayor facturación.
--Tnedria que unir la tabla cliente también en la subconsulta
-- y agrupar por codigo de cliente
SELECT c.NOMBRE FROM CLIENTES c, LINEAS_FAC lf2,FACTURAS f  
WHERE c.CODCLI =f.CODCLI 
AND f.CODFAC = lf2.CODFAC
GROUP BY c.NOMBRE 
HAVING sum(lf2.PRECIO)=(SELECT max(sum(lf.PRECIO)) 
					  FROM LINEAS_FAC lf,FACTURAS f2 
					  WHERE lf.CODFAC =f2.CODFAC 
					  GROUP BY f2.CODCLI); 
--14.	Código y descripción de aquellos artículos con un precio superior 
--a la media y que hayan sido comprados por más de 5 clientes.
SELECT a.CODART , a.DESCRIP FROM ARTICULOS a , LINEAS_FAC lf,FACTURAS f  
WHERE a.CODART =lf.CODART 
AND f.CODFAC =lf.CODFAC 
AND a.PRECIO > (SELECT avg(nvl(a2.PRECIO,0)) FROM ARTICULOS a2)
GROUP BY a.CODART , a.DESCRIP 
HAVING count(lf.CODART)>5;
