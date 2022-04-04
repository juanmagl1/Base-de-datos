CREATE TABLE VEHICULO
(Matricula	varchar2(7),
Marca	varchar2(10) NOT NULL,
Modelo varchar2(7) NOT NULL,
Fecha_compra	DATE CHECK (extract(YEAR FROM fecha_compra)>=2001),
PrecioPorDia	NUMBER(5,2),
CONSTRAINT pk_matricula PRIMARY KEY (Matricula)
);
ALTER TABLE VEHICULO ADD CONSTRAINT ck_vehiculo CHECK (PrecioPorDia>-1);
ALTER TABLE VEHICULO ADD kilometrosRecorridos NUMBER(6); 





CREATE TABLE CLIENTES
(DNI 	varchar2(9),
Nombre	varchar2(30) NOT NULL,
Nacionalidad varchar2(30),
Fecha_nacimiento DATE,
Direccion varchar2(50),
CONSTRAINT pk_clientes PRIMARY KEY (DNI)
);

CREATE TABLE ALQUILERES 
(Matricula varchar2(7),
DNI 	varchar2(9),
FechaHora DATE,
Num_dias NUMBER(2),
Kilometros NUMBER(4),
CONSTRAINT pk_alquileres PRIMARY KEY (Matricula,DNI,FechaHora),
CONSTRAINT fk_vehiculos FOREIGN KEY (Matricula) REFERENCES VEHICULO (Matricula),
CONSTRAINT fk_clientes FOREIGN KEY (DNI) REFERENCES CLIENTES (DNI)
);


