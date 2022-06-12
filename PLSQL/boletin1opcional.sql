-- 1
DECLARE 
horasTrabajadas number(4):=38;
sueldoHora number(4):=60;
descuento number(4,3):=0.155;
pagaBruta number(7,3);
descuentoPorImpuesto number(7,3);
pagaNeta number(7,3);
BEGIN
	pagaBruta:=horasTrabajadas*sueldoHora;
	descuentoPorImpuesto:=(pagaBruta*descuento);
	pagaNeta:=pagaBruta-descuentoPorImpuesto;
	dbms_output.put_line(pagaBruta);
	dbms_output.put_line(descuentoPorImpuesto);
	dbms_output.put_line(pagaNeta);
END;

-- 2.Realizar un procedure que calcule el salario neto de un trabajador 
--recibiendo como parámetro las horas trabajadas, 
--el precio de la hora y el tanto por ciento de impuestos que se aplicará sobre el salario bruto.

CREATE OR REPLACE 
PROCEDURE calculaSalario (horas NUMBER,precioHora NUMBER,porcentaje NUMBER)
AS
salarioNeto NUMBER;
BEGIN
	salarioNeto:=(horas*precioHora)-((horas*precioHora)*(porcentaje/100));
	dbms_output.put_line(salarioNeto);
END;

BEGIN 
	calculaSalario(38,60,15.5);
END;

--3.Realizar un procedure para 
--halla la media ponderada de tres puntuaciones de exámenes que se pasarán como parámetros. 
--Los pesos asociados a cada uno de los exámenes serán fijos y son 50%, 20% y 30% para cada puntuación

CREATE OR REPLACE 
PROCEDURE mediaNota (nota1 NUMBER,nota2 NUMBER,nota3 number)
IS 
resultado NUMBER;
BEGIN 
	resultado:= (nota1*0.5)+ (nota2*0.2) + (nota3*0.1);
	dbms_output.put_line(resultado);
END;

BEGIN
	mediaNota(5,8,6);
END;

--4.	Escribe un procedure para calcular el cuadrado 
--y el cubo de un número introducido por parámetros y mostrar el resultado.

CREATE OR REPLACE
PROCEDURE cuadradoCubo (numero number)
IS 
cuadrado NUMBER;
cubo NUMBER;
BEGIN 
	cuadrado:=numero**2;
	dbms_output.put_line(cuadrado);
	cubo:=numero**3;
	dbms_output.put_line(cubo);
END;

BEGIN
	cuadradoCubo(2);
END;

-- 5.	Escribe un procedure para calcular la longitud de la circunferencia 
--y el área del círculo cuyo radio se pasa por parámetro. (longitud=2*pi*r y área pi*r*r)
CREATE OR REPLACE 
PROCEDURE longitudArea (radio number)
IS 
longitud NUMBER;
area NUMBER;
BEGIN 
	longitud:=2*PI*radio;
	area:=PI*radio**2;
	dbms_output.put_line(longitud);
	dbms_output.put_line(area);
END;

BEGIN 
	longitudArea(9);
END;

--6.	Realizar un procedure que reciba tres números  
--y diga si la suma de de los dos primeros número es igual al tercero. 
--Si se cumple esta condición escribir “Iguales”, y en caso contrario escribir “Distintos”
CREATE OR REPLACE 
PROCEDURE numerosIguales (numero1 NUMBER,numero2 NUMBER,numero3 number)
IS 
resultadoSuma NUMBER;
cadena varchar2;
BEGIN 
	resultado:=numero1+numero2;
	IF resultado=numero3 THEN 
	cadena:="Iguales";
	ELSE 
	cadena:="Distintos";
	END IF;
	dbms_output.put_line(cadena);
END;

BEGIN 
	numerosIguales (2,9,3);
END;

-- 7.	Realizar un procedure que reciba 
--un número y muestre “Positivo” si el número es mayor o igual que cero, y “negativo” en caso contrario.
CREATE OR REPLACE 
PROCEDURE numeroPos (numero number)
IS 
cadena varchar2(60);
BEGIN
	IF numero>0 THEN
	cadena:='Positivo';
	ELSE IF numero=0 THEN 
	cadena:='Igual a 0';
	ELSE 
	cadena:='Negativo';
	END IF ;
	dbms_output.put.line(cadena);
END;

BEGIN 
	numeroPos(1);
END;

--8.	Realizar un procedure que reciba un número y diga si el número es “Par” 
--si el número es par, e impar en caso contrario.
CREATE OR REPLACE 
PROCEDURE numeroPar (numero number)
IS 
resultado varchar2(60);
BEGIN
	IF mod(numero,2)=0 THEN 
	dbms_output.put_line("Par");
	ELSE 
	dbms_output.put_line("Impar");
	END IF;
END;

BEGIN 
	numeroPar(5);
END;

-- 9.	Realizar un procedure que reciba un número y diga si el número es 
--“Par positivo”, “Par negativo”, “Impar positivo”
--“Impar negativo” o “cero”, según sea el número.

CREATE OR REPLACE 
PROCEDURE tipoNumero (numero number)
IS
BEGIN
	IF mod(num,2)=0 AND numero>0 THEN 
	dbms_output.put_line('Par positivo');
	ELSIF mod(num,2)=0 AND numero<0 THEN 
	dbms_output.put_line('Par negativo');
	elsIF mod(num,2)!=0 AND numero>0 THEN 
	dbms_output.put_line('Impar positivo');
	elsIF mod(num,2)!=0 AND numero<0 THEN 
	dbms_output.put_line('Impar negativo');
	END IF;
END;

BEGIN
	tipoNumero(-3);
END;

--10.	Realizar un procedure que reciba dos números como parámetro, y muestre la suma de los dos números.
CREATE OR REPLACE 
PROCEDURE suma(numero NUMBER,numero2 number)
IS 
resultado NUMBER;
BEGIN 
	resultado:=numero+numero2;
dbms_output.put_line(resultado);
END;

BEGIN 
	suma(3,2);
END;


--11.	Realizar un procedure que reciba dos números como parámetros y muestre la resta de los dos números.
CREATE OR REPLACE 
PROCEDURE resta(numero NUMBER,numero2 number)
IS 
resultado NUMBER;
BEGIN 
	resultado:=numero-numero2;
dbms_output.put_line(resultado);
END;

BEGIN 
	resta(3,2);
END;

--12.	Realizar un procedure que reciba dos número como parámetros y muestre la suma de los dos números si 
--los dos números son mayor que cero, y la resta de los dos números si alguno de los números es menor que cero.
CREATE OR REPLACE 
PROCEDURE sumaNumero(numero NUMBER,numero2 number)
IS 
resultado NUMBER;
BEGIN 
	IF numero>0 AND numero2>0 THEN 
	resultado:=numero+numero2;
	ELSIF numero<0 OR THEN 
		resultado:=numero2+numero;
	ELSIF numero2<0 THEN 
		resultado:=numero+numero2;
	END IF;
	dbms_output.put_line(resultado);
END;

BEGIN 
	sumaNumero(3,-2);
END;
--13.	Realizar un procedure que reciba dos número como parámetros
--y muestre la suma de los dos números si los dos números son mayor que cero o 
--si los dos números son menor que cero. Si un número es positivo y el otro negativo, 
--muestre la resta del número positivo menos el número negativo.
CREATE OR REPLACE 
PROCEDURE sumaNumero2(numero NUMBER,numero2 number)
IS 
resultado NUMBER;
BEGIN 
	IF (numero>0 AND numero2>0) OR (numero<0 AND numero2<0)  THEN 
	resultado:=numero+numero2;
	ELSIF numero<0 THEN 
		resultado:=numero2+numero;
	ELSIF numero2<0 THEN 
		resultado:=numero+numero2;
	END IF;
	dbms_output.put_line(resultado);
END;

BEGIN 
	sumaNumero(-3,-2);
END;
--14.	Realizar un procedure que calcule el salario neto semanal de un trabajador. 
--El procedure recibirá como parámetro el numero de horas trabajadas y el precio por hora, 
--y hay que tener en cuenta los siguientes aspectos:
--•	Las primeras 35 horas se pagan a tarifa normal
--•	Las horas que pasen de 35 se pagan a 1,5 veces la tarifa normal.
--•	Las tasa de impuesto son:
--•	Las primeros 600 euros son libres de impuestos.
--•	Los siguientes 300 euros tienen un 25% de impuestos.
--•	Los restantes euros un 45 % de impuestos.


CREATE OR REPLACE 
PROCEDURE SALARIO(HORAS NUMBER, PRECIO_HORA NUMBER)
AS
CONTADOR NUMBER := 0;
TOTAL NUMBER := 0;
CONTADOR2 NUMBER := 0;
TOTAL_IMPUESTO NUMBER := 0;
BEGIN
	
	
	WHILE CONTADOR < HORAS LOOP
		IF CONTADOR < 35 THEN
		TOTAL := TOTAL + PRECIO_HORA; 
		CONTADOR := CONTADOR + 1;
		ELSE
		TOTAL := TOTAL + PRECIO_HORA * 1.5;
		CONTADOR := CONTADOR + 1;
		END IF;
	END LOOP;



WHILE CONTADOR2 < TOTAL LOOP
	IF CONTADOR2 <= 600 THEN
	TOTAL_IMPUESTO := TOTAL_IMPUESTO + 1;
	CONTADOR2 := CONTADOR2 + 1;
	ELSIF CONTADOR2 > 600 AND CONTADOR2 <= 900 THEN
	TOTAL_IMPUESTO := TOTAL_IMPUESTO + 1 * 0.75;
	CONTADOR2 := CONTADOR2 + 1;
	ELSIF CONTADOR2 > 900 THEN
	TOTAL_IMPUESTO := TOTAL_IMPUESTO + 1 * 0.55;
	CONTADOR2 := CONTADOR2 + 1;
	END IF;
END LOOP;

DBMS_OUTPUT.PUT_LINE(TOTAL_IMPUESTO);

END;


BEGIN
	SALARIO(40, 30);
END;
