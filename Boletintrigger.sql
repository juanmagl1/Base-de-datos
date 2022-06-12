--5.7.1. Crea un trigger que, cada vez que se inserte o elimine un empleado, registre
--una entrada en la tabla AUDITORIA_EMPLEADOS con la fecha del suceso,
--número y nombre de empleado, así como el tipo de operación realizada
--(INSERCIÓN o ELIMINACIÓN).
CREATE OR REPLACE TRIGGER anotaTabla
AFTER INSERT OR DELETE ON EMPLEADOS
FOR EACH ROW
BEGIN 
	IF INSERTING THEN
	--Como no entiende el numem que hemos insertado, le ponemos delante :new
		INSERT INTO AUDITORIA_EMPLEADOS VALUES (SYSDATE ||' '|| :NEW.NUMEM ||' '|| :NEW.NOMEM || ' INSERT' );
	ELSIF DELETING THEN 
	--Como hemos borrado, lo que tenemos que ponerle delante es el :old
		INSERT INTO AUDITORIA_EMPLEADOS VALUES (SYSDATE ||' '|| :OLD.NUMEM ||' '|| :OLD.NOMEM || ' DELETE' );
	END IF;
END;
INSERT INTO empleados (numem,nomem,numde) VALUES ('1','Juanma',100);
DELETE FROM empleados WHERE NUMEM =1;
SELECT * FROM EMPLEADOS e;
SELECT * FROM AUDITORIA_EMPLEADOS ae ;

--5.7.2. Crea un trigger que, cada vez que se modi(quen datos de un empleado,
--registre una entrada en la tabla AUDITORIA_EMPLEADOS con la fecha del
--suceso, valor antiguo y valor nuevo de cada campo, así como el tipo de operación
--realizada (en este caso MODIFICACIÓN).

CREATE OR REPLACE TRIGGER actualiza
AFTER UPDATE ON EMPLEADOS
FOR EACH ROW 
BEGIN 
	IF UPDATING('NUMEM') THEN 
		INSERT INTO AUDITORIA_EMPLEADOS VALUES (:OLD.NUMEM ||' '||:NEW.NUMEM||' '||'Modificacion '||sysdate);
	ELSIF UPDATING('NOMEM') THEN 
		INSERT INTO AUDITORIA_EMPLEADOS VALUES (:OLD.NOMEM||' '||:NEW.NOMEM||' '||'Modificacion '||sysdate);
	END IF;
END;

INSERT INTO empleados (numem,nomem,numde) VALUES ('1','Juanma',100);
UPDATE EMPLEADOS 
SET NUMEM =2
WHERE NUMEM =1;
UPDATE EMPLEADOS 
SET NOMEM  ='COMANDANTE'
WHERE NUMEM =2;
SELECT * FROM EMPLEADOS e;
SELECT * FROM AUDITORIA_EMPLEADOS ae ;

--.7.3. Crea un trigger para que registre en la tabla AUDITORIA_EMPLEADOS las
--subidas de salarios superiores al 5%. 
CREATE OR REPLACE TRIGGER sube
AFTER UPDATE ON empleados
FOR EACH ROW WHEN ((OLD.salar*0.05)+OLD.salar<NEW.Salar)
BEGIN 
	INSERT INTO AUDITORIA_EMPLEADOS VALUES (:OLD.salar || ' '||:NEW.salar||' '||sysdate);
END;

UPDATE empleados 
SET SALAR =(salar*0.05)+salar
WHERE NUMEM =110;
SELECT * FROM AUDITORIA_EMPLEADOS ae ;

--7.4. Deseamos operar sobre los datos de los departamentos y los centros donde
--se hallan. Para ello haremos uso de la vista SEDE_DEPARTAMENTOS creada
--anteriormente. Al tratarse de una vista que involucra más de una tabla,
--necesitaremos crear un trigger de sustitución para gestionar las operaciones de
--actualización de la información. Crea el trigger necesario para realizar inserciones,
--eliminaciones y modi(caciones en la vista anterior

CREATE OR REPLACE TRIGGER sustitucion
INSTEAD OF INSERT OR UPDATE OR DELETE ON SEDE_DEPARTAMENTOS
FOR EACH ROW 
BEGIN 
	IF UPDATING THEN 
		UPDATE CENTROS 
		SET NUMCE=:NEW.NUMCE,NOMCE=:NEW.NOMCE,DIRCE=:NEW.DIRCE
		WHERE NUMCE=:OLD.NUMCE;
		
		UPDATE DEPARTAMENTOS
		SET NUMDE=:NEW.NUMDE,NOMDE=:NEW.NOMDE,DIREC=:NEW.DIREC,TIDIR=:NEW.TIDIR,PRESU=:NEW.PRESU,DEPDE=:NEW.DEPDE
		WHERE :OLD.NUMDE=NUMDE AND :OLD.NUMCE=NUMCE;
	ELSIF INSERTING THEN 
		INSERT INTO CENTROS VALUES (:NEW.NUMCE,:NEW.NOMCE,:NEW.DIRCE);
		
		INSERT INTO DEPARTAMENTOS VALUES(:NEW.NUMDE,:NEW.NUMCE,:NEW.DIREC,:NEW.TIDIR,:NEW.PRESU,:NEW.DEPDE,:NEW.NOMDE);
	ELSIF DELETING THEN 
		DELETE FROM CENTROS
		WHERE :OLD.NUMCE=NUMCE;
		
		DELETE FROM DEPARTAMENTOS
		WHERE :OLD.NUMDE =NUMDE AND :OLD.NUMCE=NUMCE;
	END IF;
END;

-- Inserción de datos
INSERT INTO SEDE_DEPARTAMENTOS (NUMCE, NUMDE, NOMDE)
VALUES (30, 310, 'NUEVO1');
INSERT INTO SEDE_DEPARTAMENTOS (NUMCE, NUMDE, NOMDE)
VALUES (30, 320, 'NUEVO2');
INSERT INTO SEDE_DEPARTAMENTOS (NUMCE, NUMDE, NOMDE)
VALUES (30, 330, 'NUEVO3');
SELECT * FROM CENTROS;
SELECT * FROM DEPARTAMENTOS;
-- Borrado de datos
DELETE FROM SEDE_DEPARTAMENTOS WHERE NUMDE=310;
SELECT * FROM SEDE_DEPARTAMENTOS;
DELETE FROM SEDE_DEPARTAMENTOS WHERE NUMCE=30;
SELECT * FROM SEDE_DEPARTAMENTOS;
-- Modificación de datos
UPDATE SEDE_DEPARTAMENTOS
SET NOMDE='CUENTAS', TIDIR='F', NUMCE=20 WHERE NOMDE='FINANZAS';
SELECT * FROM DEPARTAMENTOS;
UPDATE SEDE_DEPARTAMENTOS
SET NOMDE='FINANZAS', TIDIR='P', NUMCE=10 WHERE NOMDE='CUENTAS';
SELECT * FROM DEPARTAMENTOS;