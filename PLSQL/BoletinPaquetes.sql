--5.6.1. Desarrolla el paquete ARITMETICA cuyo código fuente viene en este tema.
--Crea un archivo para la especi(cación y otro para el cuerpo. Realiza varias pruebas
--para comprobar que las llamadas a funciones y procedimiento funcionan
--correctamente.
CREATE OR REPLACE PACKAGE ARITMETICA IS 
version NUMBER:=1.0;
PROCEDURE mostrarInfo;
FUNCTION suma(a number,b number) RETURN NUMBER;
FUNCTION resta(a NUMBER,b number) RETURN NUMBER;
FUNCTION multiplica(a NUMBER,b number) RETURN NUMBER;
FUNCTION divide (a NUMBER,b number) RETURN NUMBER;
END ;

CREATE OR REPLACE PACKAGE BODY ARITMETICA IS 
 PROCEDURE mostrar_info IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE
      ('Paquete de operaciones aritméticas. Versión ' || version);
  END mostrar_info;

  FUNCTION suma       (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a+b);
  END suma;

  FUNCTION resta      (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a-b);
  END resta;

  FUNCTION multiplica (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a*b);
  END multiplica;

  FUNCTION divide     (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a/b);
  END divide;

END aritmetica;

--5.6.2. Al paquete anterior añade una función llamada RESTO que reciba dos
--parámetros, el dividendo y el divisor, y devuelva el resto de la división
CREATE OR REPLACE PACKAGE aritmetica IS 
version NUMBER:=1.0;
PROCEDURE mostrarInfo;
FUNCTION suma(a number,b number) RETURN NUMBER;
FUNCTION resta(a NUMBER,b number) RETURN NUMBER;
FUNCTION multiplica(a NUMBER,b number) RETURN NUMBER;
FUNCTION divide (a NUMBER,b number) RETURN NUMBER;
FUNCTION resto (a NUMBER,b number) RETURN NUMBER;
END ;

CREATE OR REPLACE PACKAGE BODY aritmetica IS 
PROCEDURE mostrar_info IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE
      ('Paquete de operaciones aritméticas. Versión ' || version);
  END mostrar_info;

  FUNCTION suma       (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a+b);
  END suma;

  FUNCTION resta      (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a-b);
  END resta;

  FUNCTION multiplica (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a*b);
  END multiplica;

  FUNCTION divide     (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a/b);
  END divide;
  FUNCTION resto (a NUMBER,b number) RETURN NUMBER IS 
  BEGIN 
  	RETURN (MOD(a,b));
  END resto;
  END aritmetica;
  
 --5.6.3. Al paquete anterior añade un procedimiento sin parámetros llamado AYUDA
--que muestre un mensaje por pantalla de los procedimientos y funciones disponibles
--en el paquete, su utilidad y forma de uso.
CREATE OR REPLACE PACKAGE aritmetica IS 
version NUMBER:=1.0;
PROCEDURE mostrarInfo;
PROCEDURE ayuda;
FUNCTION suma(a number,b number) RETURN NUMBER;
FUNCTION resta(a NUMBER,b number) RETURN NUMBER;
FUNCTION multiplica(a NUMBER,b number) RETURN NUMBER;
FUNCTION divide (a NUMBER,b number) RETURN NUMBER;
FUNCTION resto (a NUMBER,b number) RETURN NUMBER;
END ;

CREATE OR REPLACE PACKAGE BODY aritmetica IS 
PROCEDURE mostrar_info IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE
      ('Paquete de operaciones aritméticas. Versión ' || version);
  END mostrar_info;
PROCEDURE ayuda IS 
	BEGIN
		dbms_output.put_line('Tenemos un procedimiento que describe lo que hace el paquete con la version que le 
corresponde, tenemos una funcion que le pasamos 2 numeros por parametro y nos devuelve la suma, tenemos una funcion
llamada resta que le pasamos dos numeros por parametro y nos devuelve el resultado de la resta, otra funcion llamada
multiplicación que le pasamos dos numeros por parametro y nos muestra el resultado de la multiplicacion, una funcion
llamada division que le pasamos dos numeros por parametro y nos devuelve el resultado de la division y una 
funcion llamada resto que a los dos numeros que se le pasan por parametro nos devuelve el resto de la división');
	END ayuda;
  FUNCTION suma       (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a+b);
  END suma;

  FUNCTION resta      (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a-b);
  END resta;

  FUNCTION multiplica (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a*b);
  END multiplica;

  FUNCTION divide     (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a/b);
  END divide;
  FUNCTION resto (a NUMBER,b number) RETURN NUMBER IS 
  BEGIN 
  	RETURN (MOD(a,b));
  END resto;
  END aritmetica;
  
 --5.6.4. Desarrolla el paquete GESTION. En un principio tendremos los
--procedimientos para gestionar los departamentos. Dado el archivo de
--especi(cación mostrado más abajo crea el archivo para el cuerpo. Realiza varias
--pruebas para comprobar que las llamadas a funciones y procedimientos funcionan
--correctamente
 CREATE OR REPLACE
PACKAGE GESTION AS
PROCEDURE CREAR_DEP (nombre VARCHAR2, presupuesto NUMBER);
FUNCTION NUM_DEP (nombre VARCHAR2) RETURN NUMBER;
PROCEDURE MOSTRAR_DEP (numero NUMBER);
PROCEDURE BORRAR_DEP (numero NUMBER);
PROCEDURE MODIFICAR_DEP (numero NUMBER, presupuesto NUMBER);
END GESTION;

CREATE SEQUENCE valor
START WITH 1
INCREMENT BY 1
MAXVALUE 99999
MINVALUE 1;
SELECT * FROM dept;
CREATE OR REPLACE PACKAGE BODY EMPLEADOPLNUEVO.GESTION IS 
PROCEDURE CREAR_DEP(nombre varchar2,presupuesto number) IS 
contarDept NUMBER:=0;
error EXCEPTION;
nombreAux varchar2(100);
BEGIN 
	nombreAux:=nombre;
	SELECT count(NOMBRE) INTO contarDept FROM DEP d2 WHERE NOMBRE =nombreAux;
	IF contarDept=0 THEN 
	raise error;
	END IF;
EXCEPTION 
	WHEN error THEN 
	INSERT INTO DEP VALUES (valor.NEXTVAL,nombre,presupuesto);
	
END CREAR_DEP;


FUNCTION NUM_DEP (nombre varchar2) RETURN NUMBER IS
num NUMBER;
aux varchar2(100);
BEGIN 
	aux:=nombre;
	SELECT count(d.COD_DEP) INTO num FROM dep d WHERE d.NOMBRE =aux;
	IF num=0 THEN 
	raise_application_error(-20001,'No existe el departamento');
	END IF;
RETURN num;
END NUM_DEP;
PROCEDURE MOSTRAR_DEP(numero number) IS 
nombre varchar2(100);
BEGIN 
	SELECT d.NOMBRE INTO nombre FROM DEP d WHERE d.COD_DEP =numero;
	dbms_output.put_line(nombre);
END MOSTRAR_DEP;
PROCEDURE BORRAR_DEP(numero number) IS 
numeroDept NUMBER;
error EXCEPTION;
BEGIN 
	SELECT count(cod_dep) INTO numeroDept FROM dep WHERE COD_DEP =numero;
	IF numeroDept =0 THEN
		raise error;
	END IF;
	DELETE FROM dep
	WHERE COD_DEP =numero;
EXCEPTION 
WHEN error THEN 
	dbms_output.put_line('No existe el departamento');
END BORRAR_DEP;
PROCEDURE MODIFICAR_DEP(numero NUMBER,presupuesto NUMBER) IS 
BEGIN 
	UPDATE dep 
	SET PRESUPUESTO = presupuesto
	WHERE COD_DEP =numero;
END MODIFICAR_DEP;
END gestion;


BEGIN 
	GESTION.CREAR_DEP('Contabilidad',27000);
END;
SELECT * FROM DEP;


	SELECT GESTION.NUM_DEP('ooooo') FROM dual;

BEGIN 
	GESTION.borrar_dep(1);
END;
SELECT * FROM dep;
