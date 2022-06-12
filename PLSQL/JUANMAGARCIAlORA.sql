--Crea un procedimiento que muestre un listado en el que aparezcan todos los cines, el número de salas que tiene, los
--nombres de las salas y las películas proyectadas
CREATE OR REPLACE PROCEDURE listadoCine IS
CURSOR c_cine IS
SELECT DISTINCT c.CINE, c.CIUDAD_CINE, c.DIRECCION_CINE FROM CINE c ORDER BY c.CINE;
CURSOR c_sala IS
SELECT DISTINCT s.SALA, s.AFORO, COUNT(p.CIP) AS NUM FROM SALA s, PROYECCION p WHERE s.CINE = p.CINE AND s.SALA = p.SALA GROUP BY s.SALA, s.AFORO ORDER BY s.SALA;
CURSOR c_peliculas IS
SELECT DISTINCT p.TITULO_P, p2.FECHA_ESTRENO, (p2.RECAUDACION * s.AFORO) AS RECAUDACION_SALA, p2.RECAUDACION FROM PELICULA p, PROYECCION p2, SALA s WHERE p.CIP = p2.CIP AND s.CINE = p2.CINE AND s.SALA = p2.SALA ORDER BY p2.FECHA_ESTRENO DESC;
BEGIN
FOR registro IN c_cine LOOP
dbms_output.put_line('CINE: ' || registro.CINE || ' CIUDAD: ' || registro.CIUDAD_CINE || ' DIRECCION: ' || registro.DIRECCION_CINE);
FOR registro2 IN c_sala LOOP
dbms_output.put_line('***SALA: ' || registro2.SALA || ' AFORO: ' || registro2.AFORO || ' NÚMERO DE PELICULAS PROYECTADAS: ' || registro2.NUM);
FOR registro3 IN c_peliculas LOOP
dbms_output.put_line('******TITULO: ' || registro3.TITULO_P || ' FECHA_ESTRENO: ' || registro3.FECHA_ESTRENO || ' RECAUDACIÓN_SALA: ' || registro3.RECAUDACION_SALA || ' RECAUDACIÓN PELICULA: ' || registro3.RECAUDACION);
END LOOP;
END LOOP;
END LOOP;
END;
BEGIN 
	listadoCine;
END;

-- Crea una tabla llamada auditoria_peliculas con un campo llamado descripción que sea una cadena de 300
--caracteres donde se almacenará una entrada en la tabla auditoria_peliculas con la fecha del suceso, valor
--antiguo y valor nuevo de cada campo, así como el tipo de operación realizada (-inserción, -modificación,
---borrado).
CREATE TABLE auditoria_peliculas 
(descripcion varchar2(300) PRIMARY KEY
);

CREATE OR REPLACE TRIGGER apuntar
AFTER INSERT OR UPDATE OR DELETE ON pelicula
FOR EACH ROW 
BEGIN 
	IF inserting THEN 
		INSERT INTO AUDITORIA_PELICULAS VALUES (sysdate||:NEW.cip||:NEW.titulo_p||:NEW.ano_produccion||:NEW.titulo_s||:NEW.nacionalidad||:NEW.presupuesto||:NEW.duracion||' Insercion');
	ELSIF updating('TITULO_P') THEN
		INSERT INTO AUDITORIA_PELICULAS VALUES (sysdate||:OLD.titulo_p||:new.titulo_p ||' Modificacion');
	ELSIF updating('ANO_PRODUCCION') THEN 
		INSERT INTO AUDITORIA_PELICULAS VALUES (sysdate||:OLD.ANO_PROCUCCION||:new.ANO_PRODUCCION||' Modificacion');
	ELSIF updating('TITULO_S') THEN
		INSERT INTO AUDITORIA_PELICULAS VALUES (sysdate||:OLD.titulo_s||:new.titulo_s||' Modificacion');
	ELSIF updating('NACIONALIDAD') THEN
		INSERT INTO AUDITORIA_PELICULAS VALUES (sysdate||:OLD.nacionalidad||:new.nacionalidad||' Modificacion');
	ELSIF updating('PRESUPUESTO') THEN
		INSERT INTO AUDITORIA_PELICULAS VALUES (sysdate||:OLD.PRESUPUESTO||:new.PRESUPUESTO||' Modificacion');
	ELSIF updating('DURACION') THEN
		INSERT INTO AUDITORIA_PELICULAS VALUES (sysdate||:OLD.DURACION||:new.DURACION||' Modificacion');
	ELSIF DELETING THEN 
		INSERT INTO AUDITORIA_PELICULAS VALUES (:OLD.cip||:OLD.TITULO_P||:OLD.ANO_PRODUCCION||:OLD.TITULO_S||:OLD.NACIONALIDAD||:OLD.PRESUPUESTO||:OLD.DURACION||' Borrado');
	END IF;
	END;

INSERT INTO PELICULA VALUES ('b','el miundo a sus pies',1234,'ellll','españa',123456,120);
UPDATE PELICULA 
SET TITULO_P = 'el'
WHERE CIP ='b';
DELETE FROM PELICULA p WHERE CIP ='b';
SELECT * FROM AUDITORIA_PELICULAS ap;

--3 Crear el trigger necesario para impedir que un cine tenga más de 5 salas. En el caso de no cumplir la casuística
--deberá lanzar una excepción que interrumpa el proceso. El error será -200007: Un cine no puede tener más
--de 5 salas.
CREATE OR REPLACE TRIGGER nomas5
BEFORE INSERT ON sala
FOR EACH ROW 
DECLARE 
numeroSala NUMBER;
BEGIN 
	SELECT count(sala) INTO numeroSala FROM SALA s WHERE s.CINE =:NEW.cine;
	IF numeroSala >=5 THEN 
		raise_application_error(-20007,'No puede tener mas de 5 salas el cine');
	END IF;
END;
INSERT INTO SALA VALUES ('El Arcangel',21,1234);
--Consultamos que tiene mas de 5
SELECT count(sala) FROM SALA s WHERE s.CINE ='El Arcangel';
--borramos una
DELETE FROM SALA s2 WHERE SALA =2 AND CINE ='El Arcangel';
--insertamos una
INSERT INTO SALA VALUES ('El Arcangel',2,1234);
--consultamos que tiene 5
SELECT count(sala) FROM SALA s WHERE s.CINE ='El Arcangel';
--Intentamos añadir otra
INSERT INTO SALA VALUES ('El Arcangel',24,1234);