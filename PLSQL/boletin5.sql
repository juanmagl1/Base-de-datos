-- 1. Crear un procedimiento que en la tabla emp incremente el salario el 10% a los empleados que
--tengan una comisión superior al 5% del salario.
CREATE OR REPLACE PROCEDURE EMPLEADOPLNUEVO.incremento
AS 
CURSOR c_emp IS 
SELECT * FROM emp WHERE comm>(sal*0.5);
BEGIN 
	FOR registro IN c_emp LOOP
	UPDATE emp
	SET sal=sal+(sal*0.5)
	WHERE empno=registro.empno;
	END LOOP;
EXCEPTION 
WHEN NO_data_found THEN 
dbms_output.put_line('No hay datos');
WHEN OTHERS THEN 
dbms_output.put_line('Error');
END;
BEGIN 
	incremento;
END;

-- Realiza un procedimiento MostrarMejoresVendedores que muestre los nombres de los dos
--vendedores/as con más comisiones
CREATE OR REPLACE PROCEDURE MostrarMejoresVendedores 
AS 
CURSOR c_emp IS 
SELECT ename FROM (SELECT ename,comm 
				  FROM emp 
				  WHERE comm IS NOT NULL AND comm !=0 ORDER BY comm desc)
WHERE rownum <=2;
BEGIN 
	FOR registro IN c_emp LOOP
		dbms_output.put_line(registro.ename);
	END LOOP;
EXCEPTION 
WHEN no_data_found THEN 
dbms_output.put_line('No hay datos');
END;

BEGIN 
	mostrarMejoresVendedores;
END;

-- 3. Realiza un procedimiento MostrarsodaelpmE que reciba el nombre de un departamento al
--revés y muestre los nombres de los empleados de ese departamento
CREATE OR REPLACE PROCEDURE mostrarsodaelpmE(inverso dept.dname%type)
AS 
normal varchar2(500);
CURSOR c_emp IS 
SELECT e.ENAME FROM EMP e ,DEPT d WHERE e.DEPTNO =d.DEPTNO AND d.DNAME =normal;
BEGIN 
	
	FOR registro IN c_emp LOOP
		dbms_output.put_line(registro.ename);
	end LOOP;
	EXCEPTION
	WHEN no_data_found THEN 
	dbms_output.put_line('Error inesperado');
END;
--BEGIN 
	--mostrarsodaelpmE(EMPLEADOPLNUEVO.alReves('GNITNUOCCA'));
--END;

--4. Realiza un procedimiento RecortarSueldos que recorte el sueldo un 20% a los empleados
--cuyo nombre empiece por la letra que recibe como parámetro. Trata las excepciones que
--consideres necesarias.
CREATE OR REPLACE PROCEDURE EMPLEADOPLNUEVO.recortarSueldos(letra char)
AS 
CURSOR c_emp(letra char) IS 
SELECT ename FROM emp WHERE ename LIKE letra || '%';
BEGIN 
	FOR registro IN c_emp(letra) LOOP
		UPDATE emp 
		SET sal=(sal*0.2)-sal
		WHERE empno=registro.ename;
	END LOOP;
	EXCEPTION
	WHEN no_data_found THEN 
	dbms_output.put_line('Error');
END;
BEGIN 
	recortarsueldos('N');
END;

SELECT ename FROM emp WHERE ename LIKE 'A%';
--5. Realiza un procedimiento BorrarBecarios que borre a los dos empleados más nuevos de cada
--departamento

CREATE OR REPLACE procedure EMPLEADOPLNUEVO.BorrarBecarios
is
       cursor c_emp
       is
       SELECT e.ename,e.HIREDATE,d.DEPTNO 
       FROM EMP e,DEPT d 
       WHERE d.DEPTNO =e.DEPTNO
       ORDER BY d.DEPTNO, e.HIREDATE desc;
     v_emp EMP%ROWTYPE;
BEGIN
	OPEN c_emp;
	while (c_emp%rowcount <= 2) LOOP
		FETCH c_emp INTO v_emp;
		delete emp
		where ename = v_emp.ename;
	end loop;
	CLOSE c_emp;
END;
BEGIN 
	borrarBecarios;
END;


SELECT * FROM emp WHERE DEPTNO =10;