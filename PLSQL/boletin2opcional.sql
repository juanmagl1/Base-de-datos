--1.	Realizar un procedure que muestre los números múltiplos de 5 de 0 a 100
CREATE OR REPLACE 
PROCEDURE primerosMultiplos
AS
contador NUMBER :=0;
BEGIN 
	WHILE contador<=100 LOOP
		IF mod(contador,5)=0 THEN 
			dbms_output.put_line(contador);
		END IF;
	contador:=contador+1;
	end LOOP;
	
END;

BEGIN 
	primerosMultiplos;
END;

--2.	Procedure que muestre por pantalla todos los números 
--comprendidos entre 1 y 100 que son múltiplos de 7 o de 13.
CREATE OR REPLACE 
PROCEDURE multiplo
AS
contador NUMBER :=1;
BEGIN 
	WHILE contador<100 LOOP
		IF mod(contador,7)=0 OR mod(contador,13)=0  THEN 
			dbms_output.put_line(contador)
		END IF;
	contador:=contador+1;
	end LOOP;
END;

BEGIN
	multiplo;
END;
--3.	Realizar un procedure que
--muestre los número múltiplos del primer parámetro que van desde el segundo parámetro hasta el tercero.

CREATE OR REPLACE
PROCEDURE numeroMultiplo(numero1 NUMBER,numero2 NUMBER,numero3 number)
AS
BEGIN 
	WHILE numero2<numero3 LOOP
		IF mod(numero2,numero1)=0 THEN 
		dbms_output.put_line(numero2);
		END IF;
	numero2:=numero2+1;
	end LOOP;
END;

BEGIN 
	numeroMultiplo(2,1,10);
END;

--4.	Procedure que muestre por pantalla todos los números 
--comprendidos entre 1 y 100 que son múltiplos de 7 y de 13.
CREATE OR REPLACE 
PROCEDURE multiplo7Y13
AS
contador NUMBER :=1;
BEGIN 
	WHILE contador<100 LOOP
		IF mod(contador,7)=0 AND mod(contador,13)=0  THEN 
			dbms_output.put_line(contador)
		END IF;
	contador:=contador+1;
	end LOOP;
END;

BEGIN
	multiplo7Y13;
END;

--5.	Procedure que reciba un número entero por parámetro y visualice su tabla de multiplicar
CREATE OR REPLACE
PROCEDURE tablaMultiplicar(numero number)
AS
contador NUMBER:=0;
resultado NUMBER;
BEGIN 
	WHILE contador<11 LOOP
		resultado:=numero*contador;
		dbms_output.put_line(numero || "x" || contador || "=" || resultado);
		contador:=contador+1;
	END LOOP;
	
END;

BEGIN
	tablaMultiplicar(3);
END;

--6.	Realizar un procedure que muestre los número comprendidos desde el primer parámetro hasta el segundo.
CREATE OR REPLACE 
PROCEDURE contar(numero1 NUMBER,numero2 number)
AS
contador NUMBER :=numero1;
BEGIN 
	WHILE contador<numero2 LOOP 
		contador:=contador+1;
		dbms_output.put_line(contador);
	END LOOP;
END;

BEGIN
	contar(1,10);
END;

-- 7.	Realizar un procedure que cuente de 20 en 20, desde el primer parámetro hasta el segundo.
CREATE OR REPLACE 
PROCEDURE cuenta20(numero1 NUMBER,numero2 number)
AS
contador NUMBER :=numero1;
BEGIN 
	WHILE contador<numero2 LOOP
		dbms_output.put_line(contador);
	contador:=contador+20;
	end LOOP;
END;

BEGIN 
	cuenta20(1,100);
END;

--8.	Realizar un procedure que muestre por pantalla el cuadrado y 
--el cubo de los cinco número consecutivos a partir del que se le pasa por parámetro.

CREATE OR REPLACE 
PROCEDURE cuadradoYcubo(numero number)
AS
contador NUMBER := numero + 1;
contadorBucle NUMBER :=0;
resultadoCuadrado NUMBER;
resultadoCubo NUMBER;
BEGIN 
	WHILE contador<5 LOOP 
		resultadoCuadrado:=contador**2;
		resultadoCubo:=contador**3;
		dbms_output.put_line('El cuadrado y cubo del numero ' || contador || ' son' || resultadoCuadrado || resultadoCubo);	
		contador:=contador+1;
	END LOOP;
END;

BEGIN 
	cuadradoYCubo(2);
END;

--9.	Realizar un procedure que reciba dos números como parámetro, y muestre el resultado 
--de elevar el primero parámetro al segundo.
CREATE OR REPLACE 
PROCEDURE elevarA2(numero1 NUMBER,numero2 number)
AS
resultado:=numero1**numero2;
BEGIN 
	dbms_output.put_line(resultado);
END;

BEGIN 
	elevarA2(2,3);
END;

--10.	Realizar un procedure que reciba dos números como parámetro 
--y muestre el resultado de elevar el primero número a 1, a 2... hasta el segundo número.
CREATE OR REPLACE 
PROCEDURE elevarAParametro(numero1 NUMBER,numero2 number)
AS
contador NUMBER:=1;
resultado NUMBER;
BEGIN 
	WHILE contador<numero2 LOOP
		resultado:=:=numero1**contador
		dbms_output.put_line(resultado);
		contador:=contador+1;
	end LOOP;
END;

BEGIN 
	elevarAParametro(2,3);
END;

--11.	Procedure que tome un número N que se le pasa por parámetro 
--y muestre la suma de los N primeros números.
CREATE OR REPLACE 
PROCEDURE sumaNumeros(numero NUMBER)
IS 
resultado NUMBER;
contadorBucle NUMBER:=0;
BEGIN 
	WHILE contadorBucle<numero LOOP
		resultado:=resultado+contadorBucle;
		contadorBucle:=contadorBucle+1;
	end LOOP;
	
END;

BEGIN 
	sumaNumeros(10);
END;

--12.	Procedure que tome como parámetros dos números enteros A y B, 
--y calcule el producto de A y B mediante sumas, mostrando el resultado.
CREATE OR REPLACE 
PROCEDURE productoSuma(numero NUMBER,numero2 number)
AS
resultado NUMBER;
BEGIN 
	IF numero2=0 THEN 
	resultado:=1;
	ELSE 
	FOR i IN contador..numero2 LOOP
		resultado:=resultado+numero;
	end LOOP;
	END IF;
	dbms_output.put_line(resultado);
END;

BEGIN 
	productoSuma(2,3);
END;

--13.	Procedure que tome como parámetros dos números B y E enteros positivos, 
--y calcule la potencia (B elevado a E) a través de productos.
CREATE OR REPLACE 
PROCEDURE elevaProducto(numero NUMBER,numero2 number)
AS
resultado NUMBER;
contador NUMBER :=0;
BEGIN 
	IF numero2=0 THEN 
	resultado:=1;
	ELSE 
	FOR i IN contador..numero2 LOOP
		resultado:=resultado*numero;
	end LOOP;
	END IF;
	dbms_output.put_line(resultado);
END;

BEGIN
	elevaProducto(2,3);
END;
