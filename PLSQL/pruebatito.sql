-- 1. Realizar un paquete que contenga todos los procedimientos y funciones que se piden en este
--ejercicio. A continuación deberás incluir las sentencias necesarias para probar todas las
--funcionalidades del paquete
CREATE OR REPLACE PACKAGE CICLISMO.garciaLoraJuanma IS 
PROCEDURE listado;
FUNCTION numeroGanada (cod number) RETURN NUMBER;
FUNCTION agregarciclista(nombre varchar2,nacionalidad varchar2,fecha DATE,codigo_equipo NUMBER,nombreEquipo varchar2) RETURN NUMBER;
END;

CREATE OR REPLACE PACKAGE BODY CICLISMO.garciaLoraJuanma IS 
PROCEDURE listado IS 
CURSOR c_equipos IS 
SELECT * FROM EQUIPOS e;
CURSOR c_ciclistas(cod_equipo EQUIPOS.CODEQUIPO%TYPE) IS 
SELECT * FROM CICLISTAS c WHERE c.CODEQUIPO =cod_equipo;
numeroCiclista NUMBER;
numeroEquipo NUMBER;
BEGIN 
	FOR registro IN c_equipos LOOP
		dbms_output.put_line('Nombre: '||registro.nombre||' Nacionalidad: '||registro.nacionalidad||' Nombre del director: '||registro.nombredirector);
		FOR listado IN c_ciclistas(registro.codequipo) LOOP
			dbms_output.put_line(listado.nombre||listado.dorsal||' '||listado.fechanacimiento);
			
		END LOOP;
	SELECT count(c2.DORSAL) INTO numeroCiclista FROM CICLISTAS c2 WHERE c2.CODEQUIPO =registro.codequipo;
			dbms_output.put_line('Numero de ciclistas en el equipo ' ||numeroCiclista);
	END LOOP;
	SELECT count(e.CODEQUIPO) INTO numeroEquipo FROM EQUIPOS e;
	dbms_output.put_line('Nº Total de ciclistas en el equipo: '||numeroEquipo);
END;
FUNCTION numeroGanada(cod number) RETURN NUMBER IS 
contador NUMBER;
codigo NUMBER;
BEGIN 
	SELECT count(e.CODEQUIPO) INTO codigo FROM EQUIPOS e WHERE e.CODEQUIPO =cod;
	IF codigo =0 THEN 
		raise_application_error(-20004,'No existe el equipo');
	ELSE 
		SELECT count(c.DORSAL) INTO contador FROM CICLISTAS c,CLASIFICACIONETAPAS c2 WHERE c.DORSAL =c2.DORSAL AND c2.POSICION ='1' AND c.CODEQUIPO =1;
	END IF;
	RETURN contador;
END;
FUNCTION agregarciclista(nombre varchar2,nacionalidad varchar2,fecha DATE,codigo_equipo NUMBER,nombreEquipo varchar2) RETURN NUMBER IS 
codigo NUMBER;
ciclistaExiste EXCEPTION;
numeroCiclista NUMBER;
nacion varchar2(200);
codigoCiclista NUMBER;
BEGIN
	--Compruebo si existe el equipo
	SELECT count(e.CODEQUIPO) INTO codigo FROM EQUIPOS e WHERE e.NOMBRE =nombre;
	--Si el equipo no existe procedo a crearlo
	IF codigo =0 THEN 
		dbms_output.put_line('No existe el equipo, procedemos a crearlo');
		INSERT INTO equipos VALUES (codigo_equipo,nombre,NULL,null);
	END IF;
	SELECT count(c.DORSAL) INTO numeroCiclista FROM CICLISTAS c WHERE c.NOMBRE = nombre;
	IF numeroCiclista>0 THEN
		raise ciclistaExiste;
	ELSE 
		INSERT INTO ciclistas VALUES (8,nombre,nacionalidad,codigo_equipo,fecha);
	END IF;
	SELECT NACIONALIDAD INTO nacion FROM CICLISTAS c2 WHERE c2.NOMBRE =nombre;
	IF nacion IS NULL THEN 
		UPDATE ciclistas
		SET NACIONALIDAD ='ESPAÑOL'
		WHERE NOMBRE =nombre;
	END IF;
	SELECT dorsal INTO codigoCiclista FROM CICLISMO.CICLISTAS WHERE NOMBRE =nombre;
RETURN codigoCiclista;
EXCEPTION 
WHEN ciclistaExiste THEN 
	dbms_output.put_line('El ciclista que estás intentando introducir ya existe,');
	ROLLBACK;
END;
END garciaLoraJuanma;
BEGIN 
	garciaLoraJuanma.listado;
END;
SELECT garciaLoraJuanma.numeroGanada('1') FROM dual;
SELECT garciaLoraJuanma.numeroGanada('10') FROM dual;

DECLARE 
variable NUMBER;
BEGIN 
	variable:=agregarciclista('Paco',NULL,to_date('12/04/1994','DD/MM/YYYY'),17,'SPANAIR');
END;

SELECT * FROM CICLISTAS c;

