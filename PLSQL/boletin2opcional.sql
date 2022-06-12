--1.	Realizar un procedure que muestre los n�meros m�ltiplos de 5 de 0 a 100
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

--2.	Procedure que muestre por pantalla todos los n�meros 
--comprendidos entre 1 y 100 que son m�ltiplos de 7 o de 13.
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
--muestre los n�mero m�ltiplos del primer par�metro que van desde el segundo par�metro hasta el tercero.

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

--4.	Procedure que muestre por pantalla todos los n�meros 
--comprendidos entre 1 y 100 que son m�ltiplos de 7 y de 13.
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

--5.	Procedure que reciba un n�mero entero por par�metro y visualice su tabla de multiplicar
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

--6.	Realizar un procedure que muestre los n�mero comprendidos desde el primer par�metro hasta el segundo.
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

-- 7.	Realizar un procedure que cuente de 20 en 20, desde el primer par�metro hasta el segundo.
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
--el cubo de los cinco n�mero consecutivos a partir del que se le pasa por par�metro.

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

--9.	Realizar un procedure que reciba dos n�meros como par�metro, y muestre el resultado 
--de elevar el primero par�metro al segundo.
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

--10.	Realizar un procedure que reciba dos n�meros como par�metro 
--y muestre el resultado de elevar el primero n�mero a 1, a 2... hasta el segundo n�mero.
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

--11.	Procedure que tome un n�mero N que se le pasa por par�metro 
--y muestre la suma de los N primeros n�meros.
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

--12.	Procedure que tome como par�metros dos n�meros enteros A y B, 
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

--13.	Procedure que tome como par�metros dos n�meros B y E enteros positivos, 
--y calcule la potencia (B elevado a E) a trav�s de productos.
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
