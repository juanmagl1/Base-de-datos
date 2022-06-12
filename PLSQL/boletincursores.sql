--1. Escribe un procedimiento que muestre el número de empleados y el salario
--mínimo, máximo y medio del departamento de FINANZAS. Debe hacerse
--uso de cursores implícitos, es decir utilizar SELECT ... INTO.

CREATE OR REPLACE 
PROCEDURE finanzas
AS
trabajador EMPLEADOS%ROWTYPE;
BEGIN 
	SELECT count(e.NUMEM),max(SALAR),min(SALAR),avg(SALAR) INTO trabajador
	FROM EMPLEADOS e 
	WHERE e.NUMDE =130;
	dbms_output.put_line(trabajador);
END;

BEGIN
	finanzas;
END;


--2. Escribe un procedimiento que suba un 10% el salario a los EMPLEADOS
--con más de 2 hijos y que ganen menos de 2000 €. Para cada empleado se
--mostrar por pantalla el código de empleado, nombre, salario anterior y final.
--Utiliza un cursor explícito. La transacción no puede quedarse a medias. Si
--por cualquier razón no es posible actualizar todos estos salarios, debe
--deshacerse el trabajo a la situación inicial.

CREATE OR REPLACE
PROCEDURE actualizaSalario
AS 
CURSOR c_empleado IS 
SELECT * FROM empleados e WHERE e.SALAR <2000 AND e.NUMHI >2;
BEGIN 
	FOR registro IN c_empleado
	LOOP 
		UPDATE empleados
		SET registro.salar=(registro.salar)+(registro.salar*0.1);
	END LOOP;
END;

BEGIN 
actualizaSalario();
END;

-- Escribe un procedimiento que reciba dos parámetros (número de
--departamento, hijos). Deber. crearse un cursor explícito al que se le pasarán
--estos parámetros y que mostrar. los datos de los empleados que pertenezcan
--al departamento y con el número de hijos indicados. Al final se indicar. el
--número de empleados obtenidos

CREATE OR REPLACE 
PROCEDURE mostrarHijos(numDept EMPLEADOS.NUMDE%TYPE,numHijos EMPLEADOS.NUMHI%TYPE)
AS
CURSOR c_empleados(numDept,numHijos) IS 
SELECT * FROM EMPLEADOS e WHERE e.NUMDE =numDept AND e.NUMHI = numHijos;
contador NUMBER:=0;
BEGIN 
	FOR registro IN c_empleados LOOP
		dbms_output.put_line('Numero de departamento: '||registro.numde|| ' Numero de hijos: '|| registro.numhi);
	contador:=contador+1;
	end LOOP;
	dbms_output.put_line('El numero de empleados es '||contador);
END;

BEGIN 
	MOSTRARHIJOS(121,3);
END;

--4. Escribe un procedimiento con un parámetro para el nombre de empleado,
--que nos muestre la edad de dicho empleado en años, meses y días.
CREATE OR REPLACE 
PROCEDURE convertirFecha(nombre EMPLEADOS.NOMEM%TYPE)
AS
CURSOR c_empleados AS 
SELECT e.FECNA FROM empleados e WHERE e.NOMEM = nombre;
f_nacimiento date; 
f_calculo DATE := sysdate;
anios number;
meses number;
dias number;
todo_meses number;
begin
OPEN c_empleados;
LOOP 
	FETCH c_empleados INTO f_nacimiento;
	EXIT WHEN c_empleados%notfound; 
--todo a meses
todo_meses := months_between(f_calculo, f_nacimiento);
anios := trunc(solo_meses / 12);
meses := trunc(mod(solo_meses, 12));
dias := f_calculo - add_months(f_nacimiento, trunc(solo_meses));
--
dbms_output.put_line('Usted tiene : ' || anios || ' año ' ||
meses || ' mes y ' || dias || ' dias');
END LOOP;
end;
 
BEGIN 
	convertirFecha('CESAR');
END;

