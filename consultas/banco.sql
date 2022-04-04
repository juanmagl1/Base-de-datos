--1. Mostrar el saldo medio de todas las cuentas de la entidad bancaria con dos decimales y
--suma de los saldos de todas las cuentas bancarias.
SELECT ROUND(AVG(c.SALDO),2), SUM(c.SALDO) 
FROM CUENTA c;

--2. Mostrar el saldo mínimo, máximo y medio de todas las cuentas bancarias.
SELECT MIN(c.SALDO), MAX(c.SALDO), round(AVG(nvl(c.SALDO,0)))
FROM CUENTA c;

--3. Mostrar la suma de los saldos y el saldo medio de las cuentas bancarias por cada
--código de sucursal.
SELECT SUM(c.SALDO), AVG(c.SALDO)
FROM CUENTA c
GROUP BY c.COD_SUCURSAL;

--4. Para cada cliente del banco se desea conocer su código, la cantidad total que tiene
--depositada en la entidad y el número de cuentas abiertas.
SELECT c.COD_CLIENTE, SUM(c2.SALDO), COUNT(c2.COD_CUENTA) 
FROM CLIENTE c, CUENTA c2
WHERE c.COD_CLIENTE = c2.COD_CLIENTE
GROUP BY c.COD_CLIENTE;

--5. Retocar la consulta anterior para que aparezca el nombre y apellidos de cada cliente en
--vez de su código de cliente.
SELECT c.NOMBRE, c.APELLIDOS, SUM(c2.SALDO), COUNT(c2.COD_CUENTA) 
FROM CLIENTE c, CUENTA c2
WHERE c.COD_CLIENTE = c2.COD_CLIENTE
GROUP BY c.NOMBRE, c.APELLIDOS;

--6. Para cada sucursal del banco se desea conocer su dirección, el número de cuentas que
--tiene abiertas y la suma total que hay en ellas.
SELECT s.DIRECCION, COUNT(c.COD_CUENTA), SUM(c.SALDO)  
FROM SUCURSAL s, CUENTA c 
WHERE s.COD_SUCURSAL = c.COD_SUCURSAL
GROUP BY s.DIRECCION;

--7. Mostrar el saldo medio y el interés medio de las cuentas a las que se le aplique un
--interés mayor del 10%, de las sucursales 1 y 2.
SELECT AVG(nvl(c.SALDO,0)), AVG(nvl(c.INTERES,0)) 
FROM SUCURSAL s, CUENTA c 
WHERE s.COD_SUCURSAL = c.COD_SUCURSAL 
AND c.INTERES > 10
AND s.COD_SUCURSAL = 1 OR s.COD_SUCURSAL = 2;

--8. Mostrar los tipos de movimientos de las cuentas bancarias, sus descripciones y el
--volumen total de dinero que se manejado en cada tipo de movimiento.
SELECT tm.COD_TIPO_MOVIMIENTO, tm.DESCRIPCION, SUM(m.IMPORTE) 
FROM TIPO_MOVIMIENTO tm, MOVIMIENTO m
WHERE tm.COD_TIPO_MOVIMIENTO = m.COD_TIPO_MOVIMIENTO
GROUP BY tm.COD_TIPO_MOVIMIENTO, tm.DESCRIPCION;

--9. Mostrar cuál es la cantidad media que los clientes de nuestro banco tienen en el
--epígrafe “Retirada por cajero automático”
SELECT AVG(nvl(m.IMPORTE,0))
FROM TIPO_MOVIMIENTO tm, MOVIMIENTO m
WHERE tm.COD_TIPO_MOVIMIENTO = m.COD_TIPO_MOVIMIENTO
AND tm.DESCRIPCION = 'Retirada por cajero automatico';

--10. Calcular la cantidad total de dinero que emite la entidad bancaria clasificada según los
--tipos de movimientos de salida.
SELECT sum(nvl(m.IMPORTE,0)) FROM MOVIMIENTO m ,TIPO_MOVIMIENTO tm 
WHERE m.COD_TIPO_MOVIMIENTO =tm.COD_TIPO_MOVIMIENTO
AND tm.SALIDA ='Si'
GROUP BY tm.SALIDA ;

--11. Calcular la cantidad total de dinero que ingresa cada cuenta bancaria clasificada según
--los tipos de movimientos de entrada mostrando además la descripción del tipo de
--movimiento.
SELECT sum(nvl(m.IMPORTE,0)) FROM MOVIMIENTO m,TIPO_MOVIMIENTO tm
WHERE m.COD_TIPO_MOVIMIENTO = tm.COD_TIPO_MOVIMIENTO
AND tm.SALIDA ='No';
--12. Calcular la cantidad total de dinero que sale de la sucursal de Paseo Castellana.
SELECT sum(nvl(m.IMPORTE,0)) FROM SUCURSAL s , CUENTA c, MOVIMIENTO m,TIPO_MOVIMIENTO tm
WHERE s.COD_SUCURSAL =c.COD_SUCURSAL 
AND c.COD_CUENTA =m.COD_CUENTA 
AND m.COD_TIPO_MOVIMIENTO =tm.COD_TIPO_MOVIMIENTO 
AND upper(s.DIRECCION) LIKE '%PASEO CASTELLANA%'
AND tm.SALIDA ='Si';
-- 13. Mostrar la suma total por tipo de movimiento de las cuentas bancarias de los clientes
--del banco. Se deben mostrar los siguientes campos: apellidos, nombre, cod_cuenta,
--descripción del tipo movimiento y el total acumulado de los movimientos de un
--mismo tipo.
SELECT DISTINCT c.APELLIDOS, c.NOMBRE , c2.COD_CUENTA , tm.DESCRIPCION, sum(nvl(m.IMPORTE,0))
FROM CLIENTE c , CUENTA c2 ,MOVIMIENTO m, TIPO_MOVIMIENTO tm
WHERE c.COD_CLIENTE =c2.COD_CLIENTE 
AND c2.COD_CUENTA =m.COD_CUENTA 
AND m.COD_TIPO_MOVIMIENTO =tm.COD_TIPO_MOVIMIENTO
GROUP BY c.APELLIDOS, c.NOMBRE , c2.COD_CUENTA , tm.DESCRIPCION;

--14. Contar el número de cuentas bancarias que no tienen asociados movimientos.
SELECT count(cod_cuenta) 
FROM cuenta 
WHERE COD_CUENTA NOT IN (SELECT m.COD_CUENTA FROM MOVIMIENTO m);

--15. Por cada cliente, contar el número de cuentas bancarias que posee sin movimientos. Se
--deben mostrar los siguientes campos: cod_cliente, num_cuentas_sin_movimiento.
SELECT c.COD_CLIENTE  , count(cod_cuenta) FROM cuenta c
WHERE COD_CUENTA NOT IN (SELECT m.COD_CUENTA FROM MOVIMIENTO m)
GROUP BY c.COD_CLIENTE  ;

--16. Mostrar el código de cliente, la suma total del dinero de todas sus cuentas y el número
--de cuentas abiertas, sólo para aquellos clientes cuyo capital supere los 35.000 euros
SELECT c.COD_CLIENTE , sum(nvl(c.SALDO,0)),count(c.COD_CUENTA) FROM CUENTA c , SUCURSAL s
WHERE c.COD_SUCURSAL = s.COD_SUCURSAL 
GROUP BY c.COD_CLIENTE
HAVING sum(nvl(c.SALDO,0))>35000;

--17. Mostrar los apellidos, el nombre y el número de cuentas abiertas sólo de aquellos
--clientes que tengan más de 2 cuentas.
SELECT c2.APELLIDOS , c2.NOMBRE , count(c.COD_CUENTA) FROM CUENTA c,CLIENTE c2 
WHERE c.COD_CLIENTE =c2.COD_CLIENTE 
GROUP BY c2.APELLIDOS  ,c2.NOMBRE
HAVING count(c.COD_CUENTA) >2;

--18. Mostrar el código de sucursal, dirección, capital del año anterior y la suma de los
--saldos de sus cuentas, sólo de aquellas sucursales cuya suma de los saldos de las
--cuentas supera el capital del año anterior ordenadas por sucursal.
SELECT s.COD_SUCURSAL , s.DIRECCION , s.CAPITAL_ANIO_ANTERIOR , sum(nvl(c.SALDO ,0)) FROM SUCURSAL s ,CUENTA c
WHERE s.COD_SUCURSAL =c.COD_SUCURSAL
GROUP BY s.COD_SUCURSAL , s.DIRECCION , s.CAPITAL_ANIO_ANTERIOR
HAVING sum(nvl(c.SALDO ,0)) > s.CAPITAL_ANIO_ANTERIOR
ORDER BY s.COD_SUCURSAL;
--19. Mostrar el código de cuenta, su saldo, la descripción del tipo de movimiento y la suma
--total de dinero por movimiento, sólo para aquellas cuentas cuya suma total de dinero
--por movimiento supere el 20% del saldo.
SELECT c.COD_CUENTA , SALDO ,tm.DESCRIPCION ,sum(nvl(m.IMPORTE,0)) FROM CUENTA c, MOVIMIENTO m, TIPO_MOVIMIENTO tm
WHERE c.COD_CUENTA =m.COD_CUENTA 
AND m.COD_TIPO_MOVIMIENTO =tm.COD_TIPO_MOVIMIENTO
GROUP BY c.COD_CUENTA , SALDO ,tm.DESCRIPCION
HAVING sum(nvl(m.IMPORTE,0)) > (c.SALDO*0.2);
--20. Mostrar los mismos campos del ejercicio anterior pero ahora sólo de aquellas cuentas
--cuya suma de importes por movimiento supere el 10% del saldo y no sean de la
--sucursal 4.
SELECT c.COD_CUENTA , SALDO ,tm.DESCRIPCION ,sum(nvl(m.IMPORTE,0)) 
FROM CUENTA c, MOVIMIENTO m, TIPO_MOVIMIENTO tm
WHERE c.COD_CUENTA =m.COD_CUENTA 
AND m.COD_TIPO_MOVIMIENTO =tm.COD_TIPO_MOVIMIENTO
AND c.COD_SUCURSAL !=4
GROUP BY c.COD_CUENTA , SALDO ,tm.DESCRIPCION
HAVING sum(nvl(m.IMPORTE,0)) > (c.SALDO*0.1);
--21. Mostrar los datos de aquellos clientes para los que el saldo de sus cuentas suponga al
--menos el 20% del capital del año anterior de su sucursal. 
SELECT c.* FROM CLIENTE c, CUENTA c2,SUCURSAL s
WHERE c.COD_CLIENTE =c2.COD_CLIENTE 
AND s.COD_SUCURSAL =c2.COD_SUCURSAL 
GROUP BY c.COD_CLIENTE ,c.APELLIDOS ,c.NOMBRE , c.DIRECCION ,s.CAPITAL_ANIO_ANTERIOR 
HAVING sum(c2.SALDO) >=(s.CAPITAL_ANIO_ANTERIOR*0.2);