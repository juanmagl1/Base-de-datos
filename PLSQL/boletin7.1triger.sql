CREATE TABLE empleados
(dni VARCHAR2(9) PRIMARY KEY,
nomemp VARCHAR2(50),
jefe VARCHAR2(9),
departamento NUMBER,
salario NUMBER(9,2) DEFAULT 1000,
usuario VARCHAR2(50),
fecha DATE,
CONSTRAINT FK_JEFE FOREIGN KEY (jefe) REFERENCES empleados (dni) );

CREATE OR REPLACE TRIGGER menosde5
BEFORE INSERT OR UPDATE ON empleados
FOR EACH ROW 
DECLARE 
cont NUMBER;
BEGIN 
	SELECT count(e2.dni) INTO cont FROM EMPLEADOS e,EMPLEADOS e2 WHERE e.DNI =e2.JEFE;
	IF cont>5 THEN 
		raise_application_error(-20004,'No puede ser jefe de mas de 5 empleados');
	END IF;
END;

INSERT INTO empleados(dni,nomemp) VALUES ('12345678','Juanma');
INSERT INTO empleados(dni,nomemp,jefe) VALUES ('123','aurelio','12345678');
INSERT INTO empleados(dni,nomemp,jefe) VALUES ('1','Juanma','12345678');
INSERT INTO empleados(dni,nomemp,jefe) VALUES ('2','rafae','12345678');
INSERT INTO empleados(dni,nomemp,jefe) VALUES ('3','fali','12345678');
INSERT INTO empleados(dni,nomemp,jefe) VALUES ('4','josue','12345678');
INSERT INTO empleados(dni,nomemp,jefe) VALUES ('5','raimundo','12345678');

--2 Crear un trigger para impedir que se aumente el salario de un empleado en más de un
--20%. 
SELECT * FROM EMPLEADOS e;
CREATE OR REPLACE TRIGGER subida20 
BEFORE UPDATE ON empleados
FOR EACH ROW WHEN ((old.salario*0.2)+OLD.salario<new.salario)
BEGIN 
	raise_application_error(-20004,'No se puede actualizar');
END;
DROP TRIGGER asignaFechas;
UPDATE empleados
SET salario=(salario*0.21)+salario
WHERE dni='123';

-- 
CREATE TABLE empleados_baja
( dni VARCHAR2(9) PRIMARY KEY,
nomemp VARCHAR2 (50),
jefe VARCHAR2(9),
departamento NUMBER,
salario NUMBER(9,2) DEFAULT 1000,
usuario VARCHAR2(50),
fecha DATE );

-- Crear un trigger que inserte una fila en la tabla empleados_baja cuando se borre una fila
--en la tabla empleados. Los datos que se insertan son los del empleado que se da de baja
--en la tabla empleados, salvo en las columnas usuario y fecha se grabarán las variables
--del sistema USER y SYSDATE que almacenan el usuario y fecha actual
CREATE OR REPLACE TRIGGER borraFila
AFTER DELETE ON EMPLEADOS
FOR EACH ROW
DECLARE 
BEGIN
	--Cuando insertamos en una tabla despues de borrar se pone old (SIEMPRE)
	INSERT INTO empleados_baja VALUES (:old.dni,:old.nomemp,:old.jefe,:old.departamento,:old.salario,USER,sysdate);
END;

SELECT * FROM EMPLEADOS e ;
INSERT INTO empleados VALUES ('12','maria','123',3,200,'iuuu',sysdate);
DELETE FROM EMPLEADOS e 
WHERE DNI = 11;
SELECT * FROM EMPLEADOS_BAJA eb ;
--Crear un trigger para impedir que, al insertar un empleado, la suma de los salarios de los
--empleados pertenecientes al departamento del empleado insertado supere los 10.000
--euros.
CREATE OR REPLACE TRIGGER suma10000
BEFORE INSERT ON empleados
FOR EACH ROW 
DECLARE 
sumaSal NUMBER;
BEGIN 
	--Obtenemos la suma del salario
	SELECT sum(nvl(SALARIO,0)) INTO sumaSal FROM EMPLEADOS e;
	IF sumaSal>=10000 THEN 
		raise_application_error(-20004,'No puede superar los 10000 euros');
	END IF;
END;
SELECT* FROM EMPLEADOS e;
INSERT INTO empleados (dni,salario) VALUES ('12',4000);

--Crear un trigger para impedir que, al insertar un empleado, el empleado y su jefe puedan
--pertenecer a departamentos distintos. Es decir, el jefe y el empleado deben pertenecer al
--mismo departamento.
CREATE OR REPLACE TRIGGER mismoDept
BEFORE INSERT ON empleados
FOR EACH ROW 
DECLARE 
departamentoJefe NUMBER;
BEGIN 
	--Obtenemos el departamento del jefe
	SELECT DISTINCT DEPARTAMENTO INTO departamentoJefe FROM EMPLEADOS e WHERE JEFE =:NEW.jefe;
	IF :NEW.DEPARTAMENTO!=departamentoJefe THEN
		raise_application_error(-20004,'No puede ser el departamento distinto');
	END IF;
	
END;
DROP TRIGGER menosde5;
INSERT INTO EMPLEADOS (dni,jefe,departamento) VALUES ('31','1',9);

-- Creamos un trigger que se active cuando modificamos algún campo de "empleados" y
--almacene en "controlCambios" el nombre del usuario que realiza la actualización, la
--fecha, el tipo de operación que se realiza, el dato que se cambia y el nuevo valor.

CREATE TABLE controlCambios(
 usuario varchar2(30),
 fecha date,
 tipooperacion varchar2(30),
 datoanterior varchar2(30),
 datonuevo varchar2(30)
);

CREATE OR REPLACE TRIGGER escribeControl
AFTER UPDATE ON empleados 
FOR EACH ROW 
BEGIN 
	IF UPDATING('NOMEMP') THEN 
		INSERT INTO CONTROLCAMBIOS VALUES (USER,SYSDATE,'UPDATE',:OLD.NOMEMP,:NEW.NOMEMP);
	ELSIF UPDATING('JEFE') THEN 
		INSERT INTO CONTROLCAMBIOS VALUES (USER,SYSDATE,'UPDATE',:OLD.JEFE,:NEW.jefe);
	ELSIF UPDATING ('DEPARTAMENTO') THEN 
		INSERT INTO CONTROLCAMBIOS VALUES (USER,SYSDATE,'UPDATE',:OLD.DEPARTAMENTO,:NEW.DEPARTAMENTO);
	ELSIF UPDATING ('SALARIO') THEN 
		INSERT INTO CONTROLCAMBIOS VALUES (USER,SYSDATE,'UPDATE',:OLD.SALARIO,:NEW.SALARIO);
	ELSIF UPDATING('USUARIO') THEN
		INSERT INTO CONTROLCAMBIOS VALUES (USER,SYSDATE,'UPDATE',:OLD.USUARIO,:NEW.USUARIO);
	ELSIF UPDATING('FECHA') THEN 
		INSERT INTO CONTROLCAMBIOS VALUES (USER,SYSDATE,'UPDATE',:OLD.FECHA,:NEW.FECHA);
	END IF;
END;

UPDATE EMPLEADOS 
SET NOMEMP  ='Aurelio'
WHERE DNI=1;

SELECT * FROM controlCambios;

--Creamos otro trigger que se active cuando ingresamos un nuevo registro en "empleados",
--debe almacenar en "controlCambios" el nombre del usuario que realiza el ingreso, la
--fecha, el tipo de operación que se realiza , "null" en "datoanterior" (porque se dispara con
--una inserción) y en "datonuevo" el valor del nuevo dato
CREATE OR REPLACE TRIGGER insertaControl
AFTER INSERT ON empleados
FOR EACH ROW 
BEGIN 
	INSERT INTO CONTROLCAMBIOS VALUES (USER,SYSDATE,'INSERT', NULL,:NEW.DNI);
END;
DELETE FROM EMPLEADOS e WHERE NOMEMP IS NULL;
INSERT INTO EMPLEADOS (DNI,NOMEMP) VALUES('4567','JU');
SELECT * FROM CONTROLCAMBIOS c ;

CREATE TABLE pedidos
 ( CODIGOPEDIDO NUMBER,
FECHAPEDIDO DATE,
FECHAESPERADA DATE,
FECHAENTREGA DATE DEFAULT NULL,
ESTADO VARCHAR2(15),
COMENTARIOS CLOB,
CODIGOCLIENTE NUMBER
 );
 alter SESSION set NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
Insert into PEDIDOS
(CODIGOPEDIDO,FECHAPEDIDO,FECHAESPERADA,FECHAENTREGA,ESTADO,CODIGOCLIENTE)
values
(1,to_date('17/1/06','DD/MM/YY'),to_date('19/1/06','DD/MM/YY'),to_date('19/
1/06','DD/MM/YY'),'Entregado',5);
Insert into PEDIDOS
(CODIGOPEDIDO,FECHAPEDIDO,FECHAESPERADA,FECHAENTREGA,ESTADO,CODIGOCLIENTE)
values
(2,to_date('23/10/07','DD/MM/YY'),to_date('28/10/07','DD/MM/YY'),to_date('26/1
0/07','DD/MM/YY'),'Entregado',5);
Insert into PEDIDOS
(CODIGOPEDIDO,FECHAPEDIDO,FECHAESPERADA,FECHAENTREGA,ESTADO,CODIGOCLIENTE)
values
(3,to_date('20/6/08','DD/MM/YY'),to_date('25/6/08','DD/MM/YY'),null,'Rechaza
do',5);
Insert into PEDIDOS
(CODIGOPEDIDO,FECHAPEDIDO,FECHAESPERADA,FECHAENTREGA,ESTADO,CODIGOCLIENTE)
values
(4,to_date('20/1/09','DD/MM/YY'),to_date('26/1/09','DD/MM/YY'),null,'Pendien
te',5);

--Crea un trigger que al actualizar la columna fechaentrega de pedidos la compare con la
--fechaesperada.
--• Si fechaentrega es menor que fechaesperada añadirá a los comentarios 'Pedido
--entregado antes de lo esperado'.
--• Si fechaentrega es mayor que fechaesperada añadir a los comentarios 'Pedido
--entregado con retraso'.
CREATE OR REPLACE PACKAGE pck_fechas AS 
v_fecha_entrega_Nueva PEDIDOS.FECHAENTREGA%TYPE;
v_fecha_esperada_Nueva PEDIDOS.FECHAESPERADA%TYPE;
v_fecha_entrega_Vieja PEDIDOS.FECHAENTREGA%TYPE;
v_fecha_esperada_Vieja PEDIDOS.FECHAESPERADA%TYPE;
END;
CREATE OR REPLACE TRIGGER asignaFechas 
BEFORE UPDATE ON empleados
FOR EACH ROW 
BEGIN
	pck_fechas.v_fecha_entrega_Nueva:=:NEW.fechaentrega;
	pck_fechas.v_fecha_esperada_Nueva:=:NEW.fechaesperada;
	pck_fechas.v_fecha_entrega_Vieja:=:old.fechaentrega;
	pck_fechas.v_fecha_esperada_Vieja:=:old.fechaesperada;
END;

CREATE OR REPLACE TRIGGER comparaFechas
BEFORE update ON pedidos 
BEGIN 
	IF pck_fechas.fecha_entrega_Nueva<pck_fechas.fecha_esperada_Vieja THEN
		UPDATE pedidos
		SET comentarios = 'Pedido entregado antes de lo esperado'
		WHERE pck_fechas.fecha_entrega_Vieja=pck_fechas.fecha_entrega_Nueva;
	ELSE 
		UPDATE pedidos
		SET comentarios = 'Pedido entregado con retraso'
		WHERE pck_fechas.fecha_entrega_Vieja=pck_fechas.fecha_entrega_Nueva;
	END IF;
END;
UPDATE PEDIDOS 
SET FECHAESPERADA = to_date('23/1/06','DD/MM/YY')
WHERE CODIGOPEDIDO =1;

SELECT comentarios FROM PEDIDOS p WHERE CODIGOPEDIDO =1;
