-- 1. Crea un procedimiento llamado ESCRIBE para mostrar por pantalla el
--mensaje HOLA MUNDO.
CREATE OR REPLACE 
PROCEDURE DUMMY.ESCRIBE 
AS
BEGIN 
	DBMS_OUTPUT.PUT_LINE('Hola mundo');
END;

BEGIN
	escribe;
END;
-- 2 . Crea un procedimiento llamado ESCRIBE_MENSAJE que tenga un
--par�metro de tipo VARCHAR2 que recibe un texto y lo muestre por pantalla.
--La forma del procedimiento ser. la siguiente:
--ESCRIBE_MENSAJE (mensaje VARCHAR2)
CREATE OR REPLACE 
PROCEDURE DUMMY.ESCRIBEMENSAJE (mensaje VARCHAR2)
AS 
BEGIN
	DBMS_OUTPUT.PUT_LINE(mensaje);
END;

BEGIN
	ESCRIBEMENSAJE('HOLA CABESA');
END;

--3. Crea un procedimiento llamado SERIE que muestre por pantalla una serie de
--n�meros desde un m�nimo hasta un m�ximo con un determinado paso. La
--forma del procedimiento ser. la siguiente:
--SERIE (minimo NUMBER, maximo NUMBER, paso NUMBER)

CREATE OR REPLACE
PROCEDURE DUMMY.serie (minimo NUMBER,maximo NUMBER,paso NUMBER)
AS
BEGIN
	FOR i IN minimo..maximo LOOP
		DBMS_OUTPUT.PUT.LINE(minimo);
		minimo+=maximo;
	END LOOP
	
END;

BEGIN
	serie(0,6,2);
END;

-- 4. Crea una funci�n AZAR que reciba dos par�metros y genere un n�mero al
--azar entre un m�nimo y m�ximo indicado. La forma de la funci�n ser� la
--siguiente:
--AZAR (minimo NUMBER, maximo NUMBER) RETURN NUMBER

CREATE OR REPLACE 
FUNCTION DUMMY.AZAR (minimo NUMBER,maximo NUMBER)
RETURN NUMBER
IS 
BEGIN 
	RETURN MOD(ABS(DBMS_RANDOM.RANDOM),(maximo-minimo)+1)+minimo;
END;

SELECT azar(2,10) FROM dual;

--5. Crea una funci�n NOTA que reciba un par�metro que ser� una nota num�rica
--entre 0 y 10 y devuelva una cadena de texto con la calificaci�n (Suficiente,
--Bien, Notable, ...). La forma de la funci�n ser� la siguiente:
--NOTA (nota NUMBER) RETURN VARCHAR2

CREATE OR REPLACE 
FUNCTION DUMMY.NOTA (nota number)
RETURN varchar2
IS 
resultado varchar2;
BEGIN 
	CASE nota
    WHEN nota= 10 OR nota=9 THEN resultado:=('Sobresaliente');
    WHEN nota=8 OR nota=7 THEN resultado:=('Notable');
    WHEN 6  THEN resultado:=('Bien');
    WHEN 5  THEN resultado:=('Suficiente');
    WHEN nota <4 AND nota>-1  THEN resultado:=('Insuficiente');
    ELSE nota:=('Nota no v�lida');
  END CASE;
 RETURN resultado;
END;

SELECT nota(0) FROM dual;
