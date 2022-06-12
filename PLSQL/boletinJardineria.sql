--1.- Desarrollar un procedimiento que visualice el nombre, apellidos y puesto
--de todos los empleados, ordenados por primer apellido.
CREATE OR REPLACE PROCEDURE mostrarEmp
AS 
CURSOR c_emp IS 
SELECT * FROM empleado e;
BEGIN 
	FOR registro IN c_emp LOOP 
		dbms_output.put_line('Nombre '||registro.nombre||' Apellidos '||registro.apellido1||' '||registro.apellido2||' Puesto '||registro.puesto);
		
	END LOOP;
	
END;

BEGIN 
	mostrarEmp;
END;

-- 2.- Desarrollar un procedimiento que muestre el código de cada oficina y el
--número de empleados que tiene.
CREATE OR REPLACE PROCEDURE muestraOfi
AS 
CURSOR c_oficinas IS 
SELECT e.codigo_oficina,count(e.codigo_empleado) AS num_empleados
FROM empleado e
GROUP BY e.codigo_oficina;
BEGIN 
	FOR registro IN c_oficinas LOOP 
		dbms_output.put_line('Codigo oficina: '||registro.codigo_oficina||' Num.emp 'registro.num_empleados);
	END LOOP;
	
END;
BEGIN 
	muestraOfi;
END;
--3.- Desarrollar un procedimiento que reciba como parámetro una cadena de
--texto y muestre el código de cliente y nombre de cliente de todos los
--clientes cuyo nombre contenga la cadena especificada. Al finalizar debe
--mostrar el número de clientes mostrados.
CREATE OR REPLACE PROCEDURE contieneCadena(cadena varchar2)
AS
contador NUMBER:=0;
CURSOR c_cliente IS 
SELECT * FROM cliente c WHERE c.NOMBRE_CLIENTE LIKE '%'||cadena||'%';
BEGIN 
	FOR registro IN c_cliente LOOP 
		dbms_output.put_line('Nombre '||registro.nombre_||' Codigo '||registro.codigo_empleado);
		contador:=contador+1;
	END LOOP;
	dbms_output.put_line(contador);
END;
BEGIN 
	contieneCadena('agua');
END;
--4.- Escribir un programa que muestre el código de producto, nombre y gama
--de los 5 productos más vendidos. 

DECLARE 
CURSOR c_producto IS 
SELECT * FROM (SELECT DISTINCT dp.codigo_producto,p.nombre,p.gama,dp.cantidad
			   FROM DETALLE_PEDIDO dp,PRODUCTO p 
			   WHERE dp.codigo_producto=p.codigo_producto
			   ORDER BY dp.cantidad desc
			   ) p 
WHERE rownum<=5; 
BEGIN 
	FOR registro IN c_producto LOOP 
		dbms_output.put_line( 'Codigo producto ' ||registro.codigo_producto||' Nombre' || registro.nombre ||' Gama' || registro.gama);
	END LOOP;
END;

-- 5.- Desarrollar un procedimiento que aumente el límite de crédito en un
--50% a aquellos clientes que cuyo valor sea inferior al límite de crédito
--medio actual.

CREATE OR REPLACE PROCEDURE aumentaLimite
AS 
 ;
BEGIN  
		UPDATE cliente 
		SET limite_credito=limite_credito+(limite_credito*0.5)
		WHERE LIMITE_CREDITO <(SELECT avg(nvl(c1.LIMITE_CREDITO,0)) 
						 FROM cliente c1);
	
END;

SELECT * 
FROM cliente c 
WHERE c.LIMITE_CREDITO <(SELECT avg(nvl(c1.LIMITE_CREDITO,0)) 
						 FROM cliente c1) ;
						
BEGIN 
	aumentaLimite;
END;

--6.- Diseñar una función que dado un código de producto retorne el número
--de unidades vendidas del producto. En caso de introducir un producto
--inexistente retornará -1.
CREATE OR REPLACE FUNCTION unidadVendida(cod Producto.codigo_producto%type)
RETURN NUMBER 
IS 
unidades NUMBER;
numero VARCHAR2(100);
BEGIN 
	--comprobamos si el codigo del producto está
	SELECT p.CODIGO_PRODUCTO INTO numero FROM producto p ;
	IF SQL%NOTFOUND THEN 
	RAISE_APPLICATION_ERROR('Ese numero no es correcto');
END;
SELECT sum(dp.CANTIDAD) FROM DETALLE_PEDIDO dp WHERE dp.CODIGO_PRODUCTO LIKE 'FR-67' ;
SELECT UNIDADVENDIDA('FR') FROM DUAL;

-- 7.- Diseñar una función que dado un código de cliente y un año retorne la
--cantidad total pagada por el cliente durante el periodo indicado. En caso de
--introducir un cliente inexistente retornará -1.
CREATE OR REPLACE FUNCTION totalPagado(cod Cliente.codigo_cliente%TYPE,anno number)
RETURN NUMBER
AS 
total NUMBER;


-- 8.- Diseñar una función que dado un código de cliente elimine todos sus
--pedidos realizados. La función retornará el número de pedidos borrados.
CREATE OR REPLACE FUNCTION borraPedido (cod PEDIDO.codigo_cliente%TYPE)
RETURN number
IS
contador NUMBER:=0;
CURSOR c_pedido (cod PEDIDO.codigo_cliente%TYPE) IS 
SELECT * FROM PEDIDO p WHERE p.CODIGO_CLIENTE =cod;
BEGIN 
	FOR registro IN c_pedido(codigo) LOOP 
		DELETE FROM pedido
		WHERE codigo_pedido=registro.codigo_pedido;
		contador:=contador+1;
	END LOOP;
	RETURN contador;
END;
SELECT p.CODIGO_CLIENTE ,count (p.CODIGO_PEDIDO) FROM PEDIDO p WHERE p.CODIGO_CLIENTE =1 GROUP BY p.CODIGO_CLIENTE  ;
SELECT borraPedido(1) FROM dual;

CREATE OR REPLACE FUNCTION borraPedido (cod PEDIDO.codigo_cliente%TYPE)
RETURN number
IS
contador NUMBER:=0;
BEGIN 
		DELETE FROM detalle_pedido
		WHERE CODIGO_PEDIDO =cod;
		DELETE FROM pedido
		WHERE CODIGO_PEDIDO  = cod;
	RETURN contador;
END;
SELECT borraPedido(1) FROM dual;
DECLARE 
variable NUMBER;
BEGIN 
	variable:= borraPedido(2);
	dbms_output.put_line(variable);
END;

	
-- 9.- Desarrollar un procedimiento que actualice el precio de venta de todos
--los productos de una determinada gama. El procedimiento recibirá como
--parámetro la gama, y actualizará el precio de venta como el precio de
--proveedor + 70%. Al finalizar el procedimiento indicará el número de
--productos actualizados y su gama.

CREATE OR REPLACE PROCEDURE JARDINERIA.actualizaPrecio(gama_producto PRODUCTO.gama%type)
AS 
numero varchar2(500);
BEGIN 
SELECT distinct p.GAMA INTO numero FROM producto p WHERE p.GAMA LIKE gama_producto;
		UPDATE producto 
		SET precio_venta=precio_venta+(precio_venta*0.7),precio_proveedor=precio_proveedor+(precio_proveedor*0.7)
		WHERE gama=numero;
	dbms_output.put_line('Filas actualizadas '||SQL%rowcount|| ' Gama producto '|| gama_producto);
END;
BEGIN 
	actualizaPrecio('Frutales');
END;
SELECT distinct p.GAMA FROM producto p WHERE p.GAMA LIKE 'Frutales';
SELECT * FROM producto WHERE gama LIKE 'Frutales';

-- 10 
CREATE OR REPLACE PROCEDURE JARDINERIA.listarEmp
IS 
numeroCliente NUMBER;
CURSOR c_emp IS 
SELECT e.codigo_empleado, e.nombre,e.apellido1,e.apellido2,o.CODIGO_OFICINA,o.CIUDAD , e.puesto 
FROM empleado e, oficina o 
WHERE e.codigo_oficina=o.CODIGO_OFICINA;

CURSOR c_cliente(codigoEmpleado number) IS 
SELECT c.CODIGO_CLIENTE ,c.NOMBRE_CLIENTE ,sum(nvl(p.TOTAL,0)) AS suma,count(p2.CODIGO_PEDIDO) AS contar FROM CLIENTE c ,PAGO p, PEDIDO p2 
WHERE c.CODIGO_CLIENTE =p.CODIGO_CLIENTE (+)
AND c.CODIGO_CLIENTE =p2.CODIGO_CLIENTE(+)
AND c.CODIGO_EMPLEADO_REP_VENTAS =codigoEmpleado
GROUP BY c.CODIGO_CLIENTE ,c.NOMBRE_CLIENTE;
BEGIN 
	dbms_output.put_line('********************************************');
	FOR registro IN c_emp LOOP 
		dbms_output.put_line('Nombre del empleado '||registro.nombre||' '||registro.apellido1||' '||registro.apellido2||' Puesto: '||registro.puesto);
		SELECT count(c.CODIGO_CLIENTE) INTO numeroCliente 
		FROM EMPLEADO e,CLIENTE c 
		WHERE e.CODIGO_EMPLEADO =c.CODIGO_EMPLEADO_REP_VENTAS 
		AND e.CODIGO_EMPLEADO =registro.codigo_empleado;
		dbms_output.put_line('Nº total de clientes representados: '||numeroCliente);
		FOR clientes IN c_cliente(registro.codigo_empleado) LOOP
			dbms_output.put_line(clientes.codigo_cliente||' Cliente: '||clientes.nombre_cliente||' Total pagos: '||clientes.suma|| ' Total pedidos:'||clientes.contar);
		end LOOP;
	dbms_output.put_line('****************************************************');
	END LOOP;
END;
BEGIN 
	listarEmp;
END;

