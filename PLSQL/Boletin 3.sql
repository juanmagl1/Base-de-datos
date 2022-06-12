-- Realiza un procedimiento que reciba un número de departamento y muestre por pantalla su
--nombre y localidad. 
CREATE OR REPLACE PROCEDURE EMPLEADOPLNUEVO.nombreYLocalidad(numdept DEPT.DEPTNO%TYPE)
AS
CURSOR c_departamento(numdept DEPT.DEPTNO%TYPE) IS 
SELECT * FROM dept d WHERE d.DEPTNO = numdept;
BEGIN 
	FOR registro IN c_departamento LOOP 
		dbms_output.put_line('El nombre es '|| registro.dname || ' La localidad es: '|| registro.loc);
	END LOOP;
END;

BEGIN 
	nombreYLocalidad(10);
END;

--Realiza una función devolver_sal que reciba un nombre de departamento y devuelva la suma
--de sus salarios. 
CREATE OR REPLACE FUNCTION EMPLEADOPLNUEVO.devolver_sal (nombreDept varchar2)
RETURN NUMBER
IS 
total NUMBER;
BEGIN 
	SELECT sum(nvl(e.SAL,0)) INTO total FROM emp e,dept d WHERE d.DNAME = nombreDept AND e.DEPTNO =d.DEPTNO;
	IF total IS null THEN 
		RAISE_APPLICATION_ERROR(-20001,'No se ha encontrado ningun registro');
	END IF;
	RETURN total;
END;

SELECT devolver_sal('yoni') FROM dual;

--3. Realiza un procedimiento MostrarAbreviaturas que muestre las tres primeras letras del
--nombre de cada empleado.
CREATE OR REPLACE PROCEDURE EMPLEADOPLNUEVO.MostrarAbreviaturas
IS
CURSOR c_empleado IS 
SELECT * FROM emp e;
BEGIN 
	FOR registro IN c_empleado LOOP 
		dbms_output.put_line(lpad(registro.ename,3));
	END LOOP;
END;

BEGIN 
	MostrarAbreviaturas;
END;

--Realiza un procedimiento que reciba un número de departamento y muestre una lista de sus
--empleados.
CREATE OR REPLACE PROCEDURE EMPLEADOPLNUEVO.listaEmp(departamento emp.deptno%type) 
IS 
numero NUMBER;
CURSOR c_empleado(num_departamento emp.deptno%type) IS 
SELECT * FROM emp e WHERE e.DEPTNO = num_departamento;
BEGIN 
	--Se pone primero el implicito para xomparar excepciones
	SELECT d.DEPTNO INTO numero FROM dept d WHERE d.DEPTNO =numero; 
	FOR registro IN c_empleado(num_departamento) LOOP
		dbms_output.put_line('Nombre ' || registro.ename || ' Salario: '||registro.sal||' Departamento '||registro.deptno);
	END LOOP;
EXCEPTION 
WHEN NO_DATA_FOUND THEN 
dbms_output.put_line('No se han encontrado datos');
END;

BEGIN 
	listaEmp(1);
END;

--Realiza un procedimiento MostrarJefes que reciba el nombre de un departamento y muestre
--los nombres de los empleados de ese departamento que son jefes de otros empleados.Trata las
--excepciones que consideres necesarias.
CREATE OR REPLACE PROCEDURE EMPLEADOPLNUEVO.MostrarJefes(nombre dept.dname%type)
AS 
v_departamento NUMBER;
CURSOR c_emp(nombreDept dept.dname%type) IS 
   select e.ename
    from emp e,dept d
    where d.deptno = e.DEPTNO
    AND d.DNAME = nombreDept
    and e.empno in (select e1.mgr
                  from emp e1);
BEGIN 
	SELECT d.DEPTNO INTO v_departamento FROM dept d WHERE d.DEPTNO =v_departamento;
	FOR registro IN c_emp(nombreDept) LOOP
		dbms_output.put_line(registro.ename);
	END LOOP;
	EXCEPTION 
	WHEN NO_DATA_FOUND THEN 
	dbms_output.put_line('No hay ningun empleado jefe');
	WHEN OTHERS THEN 
	dbms_output.put_line('Error');
END;

BEGIN 
	MostrarJefes('ACCOUNTI');
END;
SELECT * FROM dept;

--6. Hacer un procedimiento que muestre el nombre y el salario del empleado cuyo código es
--7082 
CREATE OR REPLACE 
PROCEDURE nombreYSalar(numero NUMBER)
IS 
nombre varchar2;
salario NUMBER;
BEGIN 
	SELECT e.ENAME , e.SAL INTO nombre,salario FROM emp e WHERE e.EMPNO = numero;
	dbms_output.put_line('Nombre '||nombre||' Salario'||salario);

EXCEPTION 
WHEN NO_DATA_FOUND THEN
dbms_output.put_line('Departamento no encontrado');
END;
BEGIN 
	nombreYSalar(7082);
END;

--Realiza un procedimiento llamado HallarNumEmp que recibiendo un nombre de
--departamento, muestre en pantalla el número de empleados de dicho departamento
--Si el departamento no tiene empleados deberá mostrar un mensaje informando de ello. Si el
--departamento no existe se tratará la excepción correspondiente.
CREATE OR REPLACE PROCEDURE EMPLEADOPLNUEVO.HallarNumEmp (nombre dept.dname%type)
IS 
numero NUMBER;
BEGIN 
	SELECT count(e.EMPNO) INTO numero
	FROM emp e,dept d 
	WHERE e.DEPTNO = d.DEPTNO
	AND d.DNAME = nombre;
	IF numero=0 THEN 
		RAISE_APPLICATION_ERROR(-20001,'no Existe el departamento');
	END IF;
	dbms_output.put_line(numero);
	EXCEPTION 
	WHEN NO_DATA_FOUND THEN 
	dbms_output.put_line('No hay ningun registro');
END;

BEGIN 
	HallarNumEmp('SALES');	
END;

-- 8. Hacer un procedimiento que reciba como parámetro un código de empleado y devuelva su
--nombre.
CREATE OR REPLACE 
PROCEDURE nombreEmp (codEmp EMP.EMPNO%TYPE)
AS
nombre varchar2(300);
BEGIN 
	--Primeros miramos si existe el nombre
	SELECT e.ENAME INTO nombre FROM emp e WHERE e.EMPNO = codEmp;
	dbms_output.put_line(nombre);
	EXCEPTION 
	WHEN no_data_found THEN 
	dbms_output.put_line('No se encuentra el empleado');
END;

BEGIN 
	nombreEmp(79);
END;

CREATE OR REPLACE PROCEDURE EMPLEADOPLNUEVO.alReves(cadena varchar2)
AS 
cadenaReves varchar2(300);
BEGIN 
	FOR registro IN reverse 1..length(cadena) LOOP
		cadenaReves:=cadenaReves||substr(cadena,registro,1);
	END LOOP;
	dbms_output.put_line(cadenaReves);
END;

BEGIN 
	alReves('Yoni');
END;

--10. Escribir un procedimiento que reciba una fecha y escriba el año, en número, correspondiente a
--esa fecha. 
CREATE OR REPLACE 
PROCEDURE annoFecha(dia date)
AS
fecha NUMBER;
BEGIN 
	-- Para usarlo en una consulta se le pone from dual
	SELECT EXTRACT(YEAR FROM dia) INTO fecha FROM dual;
	dbms_output.put_line(fecha);
END;

BEGIN 
	annoFecha(to_date('12/04/1994','DD/MM/YYYY'));
END;
-- 11. Realiza una función llamada CalcularCosteSalarial que reciba un nombre de departamento y
--devuelva la suma de los salarios y comisiones de los empleados de dicho departamento.
CREATE OR REPLACE PROCEDURE EMPLEADOPLNUEVO.CalcularCosteSalarial (nombre DEPT.DNAME%TYPE)
AS 
num NUMBER;
salario NUMBER;
comision NUMBER;
BEGIN 
	SELECT d.DEPTNO INTO num FROM dept d WHERE d.DNAME =nombre;
	SELECT SUM(nvl(e.SAL,0)),SUM(nvl(e.COMM,0))INTO salario,comision FROM emp e WHERE e.DEPTNO = num;
	dbms_output.put_line('Salario '||salario||' Comision:' || comision);
EXCEPTION 
WHEN no_data_found THEN 
DBMS_OUTPUT.PUT_LINE('No existen datos');
END;

BEGIN 
	CalcularCosteSalarial('ACCOUNTING');
END;

-- 12. Codificar un procedimiento que permita borrar un empleado cuyo número se pasará en la
--llamada. Si no existiera dar el correspondiente mensaje de error.
CREATE OR REPLACE PROCEDURE borrarEmpleado (numeroEmp EMP.EMPNO%TYPE)
AS 
numero NUMBER;
BEGIN 
	SELECT e.EMPNO INTO numero FROM EMP e WHERE e.EMPNO =numeroEmp;
	IF SQL%NOTFOUND THEN 
	RAISE_APPLICATION_ERROR(-20001,'No existe el empleado');
	ELSE 
	DELETE FROM emp 
	WHERE empno=numeroEmp;
	dbms_output.put_line('Borrado con exito');
	END IF;
END;
INSERT INTO emp (empno,ename,deptno) VALUES (1,'Juanma',10);
BEGIN 
	borrarEmpleado(1);
END;

SELECT * FROM emp;

-- Realiza un procedimiento MostrarCostesSalariales que muestre los nombres de todos los
--departamentos y el coste salarial de cada uno de ellos
CREATE OR REPLACE 
PROCEDURE MostrarCostesSalariales 
AS
CURSOR c_dept IS 
SELECT sum(nvl(e.SAL,0)) AS coste,d.DNAME FROM emp e,dept d
WHERE e.DEPTNO(+) =d.DEPTNO
GROUP BY d.DNAME;
BEGIN 
	FOR registro IN c_dept LOOP
		dbms_output.put_line('Nombre: '||registro.dname||' Coste '||registro.coste);
	END LOOP;
	
END;
BEGIN 
	MostrarCostesSalariales;
END;

-- 14. Escribir un procedimiento que modifique la localidad de un departamento. El procedimiento
--recibirá como parámetros el número del departamento y la localidad nueva. 
CREATE OR REPLACE PROCEDURE modificaDept(numDept DEPT.DEPTNO%TYPE,localidad DEPT.LOC%TYPE)
AS 
num NUMBER;
BEGIN 
	SELECT d.DEPTNO INTO num FROM DEPT d WHERE d.DEPTNO =numDept;
	IF num=0 THEN 
	RAISE_APPLICATION_ERROR(-20001,'No existe el departamento');
	ELSE 
	UPDATE dept
	SET loc=localidad
	WHERE DEPTNO = num;
	dbms_output.put_line('Modificado con exito');
END;
INSERT INTO dept (deptno,loc) VALUES (1,'Sevilla');

BEGIN 
	modificaDept(2,'Sevilla');
END;
SELECT * FROM dept;

-- 15. Realiza un procedimiento MostrarMasAntiguos que muestre el nombre del empleado más
--antiguo de cada departamento junto con el nombre del departamento. Trata las excepciones
--que consideres necesarias.
CREATE OR REPLACE PROCEDURE MostrarMasAntiguos 
AS
CURSOR c_empleado IS 
SELECT e.ENAME AS empleado,d.DNAME AS departamento 
FROM emp e,dept d 
WHERE e.DEPTNO = d.DEPTNO
AND e.HIREDATE IN (SELECT min(e.HIREDATE) 
				 FROM emp e
				 GROUP BY e.DEPTNO)
GROUP BY e.ENAME ,d.DNAME;
BEGIN 
	FOR registro IN c_empleado LOOP
		dbms_output.put_line('Nombre del departamento '|| registro.departamento ||' Nombre del empleado '|| registro.empleado);
	end LOOP;
	EXCEPTION 
	WHEN no_data_found THEN 
	dbms_output.put_line('No hay ninguna persona');
	WHEN OTHERS THEN 
	dbms_output.put_line('Error');
END;
BEGIN 
	MostrarMasAntiguos;
END;
-- segunda opcion
CREATE OR REPLACE PROCEDURE MostrarMasAntiguos22
AS
CURSOR c_empleado IS 
SELECT e.ENAME AS empleado,d.DNAME AS departamento 
FROM emp e,dept d 
WHERE e.DEPTNO = d.DEPTNO
AND e.HIREDATE IN (SELECT min(e.HIREDATE) 
				 FROM emp e
				 GROUP BY e.DEPTNO)
GROUP BY e.ENAME ,d.DNAME;
BEGIN 
	OPEN c_empleado;
	LOOP 
	FETCH c_empleado INTO registro;
	EXIT WHEN c_empleado%notfound;
		dbms_output.put_line('Nombre del departamento '|| registro.departamento ||' Nombre del empleado '|| registro.empleado);
	END LOOP;
	CLOSE c_empleado;
	EXCEPTION 
	WHEN no_data_found THEN 
	dbms_output.put_line('No hay ninguna persona');
	WHEN OTHERS THEN 
	dbms_output.put_line('Error');
END;
