CREATE OR REPLACE 
PROCEDURE ListarEmpleados
AS
CURSOR c_Empleados IS 
SELECT * FROM EMPLEADOS e WHERE upper(NOMEM) LIKE '%A%';
BEGIN 
	FOR registro IN c_empleado 
	LOOP
		dbms_output.put_line('Nombre: ' || registro.NOMEM || ' ' || 'Sueldo: '|| registro.SALAR);
	END LOOP;
END;

BEGIN 
	ListarEmpleados;
END;

--Otra forma 
CREATE OR REPLACE 
procedure ListarEmpleadoOtra
IS
CURSOR c_Empleados IS 
SELECT * FROM EMPLEADOS e WHERE upper(NOMEM) LIKE '%A%';
registro EMPLEADOS%ROWTYPE;
BEGIN 
	OPEN c_empleado;
	LOOP
		FETCH c_Empleados INTO registro
		EXIT WHEN registro%notfound;
			dbms_output.put_line('Nombre: ' || registro.NOMEM || ' ' || 'Sueldo: '|| registro.SALAR);
	end LOOP;
	CLOSE c_empleado;
END;

BEGIN 
	ListarEmpleadoOtra;
END;

