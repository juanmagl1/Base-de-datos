/*BEGIN
	DBMS_OUTPUT.PUT_LINE('Hola mundo');
END;

*/

/*DECLARE 
fecha DATE;
BEGIN 
	SELECT sysdate INTO fecha FROM dual;
	dbms_output.put_line(
	    to_CHAR(fecha,'day", "dd" de "month" de "yyyy", a las "hh24:mi:ss')
	   );
	dbms_output.put_line(fecha);
END;*/
--Bloques de pl/sql

--1 Sale cierto, porque los el 10 es mayor que es 5 entonces se ejecutará la función que está dentro del if 
BEGIN
 IF 10 > 5 THEN
 DBMS_OUTPUT.PUT_LINE ('Cierto');
 ELSE
 DBMS_OUTPUT.PUT_LINE ('Falso');
 END IF;
END;

-- 2 Sale cierto porque 10 es mayor que 5 y 5 es mayor que 1 entonces una vez ejecutado el if se sale 
BEGIN
IF 10 > 5 AND 5 > 1 THEN
 DBMS_OUTPUT.PUT_LINE ('Cierto');
ELSE
 DBMS_OUTPUT.PUT_LINE ('Falso');
END IF;
END;

--3 Se ejecutará el falso porque 10 es mayor que 5, pero 5 es menor que 50 
-- enotnces no ejecuta el if porque no cumple la condición y se va al else
BEGIN
	IF 10 > 5 AND 5 > 50 THEN
 DBMS_OUTPUT.PUT_LINE ('Cierto');
	ELSE
 DBMS_OUTPUT.PUT_LINE ('Falso');
	END IF;
END;

--4 sale lo mismo que en el ejercicio anterior que con el case

BEGIN
CASE
 WHEN 10 > 5 AND 5 > 50 THEN
 DBMS_OUTPUT.PUT_LINE ('Cierto');
 ELSE
 DBMS_OUTPUT.PUT_LINE ('Falso');
END CASE;
END;

--5 va a ir imprimiendo numeros del 1 al 10 con el 
-- salto de linea 
BEGIN
 FOR i IN 1..10 LOOP
 DBMS_OUTPUT.PUT_LINE (i);
 END LOOP;
END;

--6 va a imprimir los numeros del 10 al 1 
BEGIN
 FOR i IN REVERSE 1..10 LOOP
 DBMS_OUTPUT.PUT_LINE (i);
 END LOOP;
END;

-- 7 se va a ejecutar el bloque 50 veces y va a sacar solamente los numeros pares
DECLARE
 num NUMBER(3) := 0;
BEGIN
 WHILE num<=100 LOOP
 DBMS_OUTPUT.PUT_LINE (num);
 num:= num+2;
 END LOOP;
END;

-- 8 Se va a ejecutar el bucle primero se imprime num, si el numero es mayor que 100 se sale, sino es
--mayor que 100 se suman 2 hasta que entre en el if, y te imprime el 102 
-- porque te imprime el numero antes de ejecutarse el condicional
DECLARE
 num NUMBER(3) := 0;
BEGIN
 LOOP
 DBMS_OUTPUT.PUT_LINE (num);
 IF num > 100 THEN EXIT; END IF;
 num:= num+2;
 END LOOP;
END;

--9 se declara la variable y te mete en el bucle, y se volverá a salir cuando el número vuelva a ser mayor que
--100, antes de salirse del bucle cuando el numero valga 102 te lo vuelve a imprimir porque aun no se ha salido 
--del bucle
DECLARE
 num NUMBER(3) := 0;
BEGIN
 LOOP
 DBMS_OUTPUT.PUT_LINE (num);
 EXIT WHEN num > 100;
 num:= num+2;
 END LOOP;
END;

