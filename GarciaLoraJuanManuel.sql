-- 1. Realiza un procedimiento que reciba una fecha inicial y una fecha final y muestre
--todas las apuestas que han resultado ganadoras entre esas dos fechas. Las
--apuestas deben mostrarse con el siguiente formato:
CREATE OR REPLACE PROCEDURE EXAMENCABALLOS.apuestasGanadoras(fechaInicial DATE, fechaFinal DATE) IS
CURSOR c_carrera IS
SELECT c.NOMBRECARRERA, c.FECHAHORA FROM CARRERAS c WHERE c.FECHAHORA >= fechaInicial AND c.FECHAHORA <= fechaFinal;
CURSOR c_clientes IS
SELECT cl.NOMBRE, a.IMPORTE, (a.IMPORTE * a.TANTOPORUNO) AS GANANCIAS FROM APUESTAS a, CLIENTES cl WHERE cl.DNI = a.DNICLIENTE;
BEGIN
	IF fechaInicial>fechaFinal THEN 
		raise_application_error(-20004,'La fecha no es correcta');
	END IF;
dbms_output.put_line('INFORME DE APUESTAS GANADORAS ENTRE ' || fechaInicial || ' Y ' || fechaFinal);
FOR registro IN c_carrera LOOP 
	dbms_output.put_line('Carrera: ' || registro.NOMBRECARRERA);
	dbms_output.put_line('Fecha: ' || registro.FECHAHORA);
	FOR listado IN c_clientes LOOP 
		dbms_output.put_line('Cliente: ' || listado.NOMBRE||' ImporteApostado: ' || listado.IMPORTE||' Ganancias: ' || listado.GANANCIAS);
	END LOOP;
END LOOP;
END;
BEGIN
	apuestasGanadoras(to_date('12/07/2009','DD/MM/YYYY'),to_date('19/07/2009','DD/MM/YYYY'));	
END;
BEGIN
	apuestasGanadoras(to_date('19/07/2009','DD/MM/YYYY'),to_date('12/07/2009','DD/MM/YYYY'));	
END;

BEGIN 
--2 Añade una columna a la tabla Caballos para almacenar el número de
--carreras ganadas por cada uno de ellos. Realiza un procedimiento para
--llenarla con los valores adecuados.
ALTER TABLE CABALLOS ADD NUMEROGANADA NUMBER(3);
CREATE OR REPLACE PROCEDURE carrerasGanadas IS 
CURSOR c_caballos IS 
SELECT count(POSICIONFINAL) AS carreraGanada,CODCABALLO FROM participaciones WHERE POSICIONFINAL =1 GROUP BY CODCABALLO ;
BEGIN 
	FOR registro IN c_caballos LOOP
		UPDATE caballos
		SET numeroganada=registro.carreraGanada
		WHERE codcaballo=registro.codcaballo;
	END LOOP;
	
END;
BEGIN 
	carrerasGanadas;
END;
SELECT * FROM caballos;

--4 Realiza un procedimiento para insertar una apuesta. El procedimiento
--recibirá el nombre del caballo, el nombre de la carrera, el nombre y nacionalidad
--del cliente y el importe. 
SELECT * FROM caballos;
SELECT * FROM CARRERAS c;
SELECT * FROM clientes;

CREATE SEQUENCE valorCaballo 
INCREMENT BY 1
START WITH 9
MAXVALUE 99999;

CREATE SEQUENCE valorCarrera
START WITH 10
MAXVALUE 99999;

CREATE SEQUENCE valorCliente2
MINVALUE 10
MAXVALUE 99999
START WITH 10;
CREATE OR REPLACE PROCEDURE EXAMENCABALLOS.insertaApuesta(nombreCaballo varchar2,nombreCarrera varchar2,nombreCliente varchar2,nacionalidadCliente varchar2,importe NUMBER) IS 
existeCaballo NUMBER;
existeCarrera NUMBER;
existeCliente NUMBER;
BEGIN 
	SELECT count(dni) INTO existeCliente FROM CLIENTES c WHERE c.NOMBRE = nombreCliente;
	IF existeCliente=0 THEN 
		dbms_output.put_line('El cliente no existe');
		INSERT INTO clientes VALUES (valorCliente2.nextval,nombreCliente,nacionalidadCliente);
	END IF;
	SELECT count(c2.CODCABALLO) INTO existeCaballo FROM CABALLOS c2 WHERE c2.NOMBRE = nombreCaballo;
	IF existeCliente=0 THEN 
		DBMS_OUTPUT.PUT_LINE('El caballo no existe');
		INSERT INTO caballos(codcaballo,nombre) VALUES (valorCaballo.nextval,nombreCaballo);
	END IF;
	SELECT count(c3.CODCARRERA) INTO existeCarrera FROM carreras c3 WHERE c3.NOMBRECARRERA  = nombreCarrera;
	IF existeCliente=0 THEN 
		dbms_output.put_line('La carrera no existe');
		INSERT INTO carreras(codcarrera,nombrecarrera) VALUES (valorCarrera.nextval,nombreCarrera);
	END IF;
	INSERT INTO apuestas VALUES (valorCliente2.currval,valorCaballo.currval,valorCarrera.currval,importe,2);
END;
BEGIN 
	insertaapuesta('Marco','Miami','Juanma','España',2500);
END;
--estos select son para comprobar que estan los clientes caballos y carreras creadas
SELECT * FROM apuestas;
SELECT * FROM clientes;
SELECT * FROM caballos;
