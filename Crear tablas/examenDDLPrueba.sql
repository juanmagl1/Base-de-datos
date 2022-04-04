alter session set "_oracle_script"=true;  
create user GARCIALORAJUANMA IDENTIFIED by GARCIALORAJUANMA;
GRANT CONNECT, RESOURCE, DBA TO GARCIALORAJUANMA;

--Comienzo del script

CREATE TABLE T_ESTRACTO
(estrato number(4),
descripcion varchar2(50),
totalusuarios number(10) DEFAULT 0,
CONSTRAINT pk_estracto PRIMARY KEY (estrato),
CONSTRAINT ck1_estracto CHECK (estrato>39),
CONSTRAINT ck2_estrato CHECK (totalusuarios>-1)
);

CREATE TABLE T_CARGOS 
(idcargo varchar2(2),
descripcioncargo varchar2(50),
CONSTRAINT pk_t_cargos PRIMARY KEY (idcargo),
CONSTRAINT ck_t_cargo CHECK (idcargo IN ('FC,RC','RF','CO'))
);

CREATE TABLE T_SERVICIOS
(servicio varchar2(3),
nservicio number(4),
descripcionservicio varchar2(200)NOT NULL,
cupousuarios number(6),
nusuarios number(10) DEFAULT 0,
testrato number(4),
importefijo number(8,2),
valorconsumo number(10,2),
CONSTRAINT pk_t_servicios PRIMARY KEY (servicio,nservicio),
CONSTRAINT fk_t_servicios FOREIGN KEY (testrato) REFERENCES T_ESTRACTO (estrato),
CONSTRAINT ck_t_servicios CHECK (nusuarios>=0)
);

CREATE TABLE T_MOVIMIENTOS
(id_cliente number(5),
fechaimporte DATE DEFAULT sysdate,
fechamovimiento DATE,
cargo_aplicado varchar2(2),
servicio varchar2(3),
nservicio number(4),
consumo number(10,2) NOT NULL,
importefac number(10,2) NOT NULL,
importerec number(10,2) NOT NULL,
importerefa number(10,2) NOT NULL,
importeconv number(10,2) NOT NULL,
CONSTRAINT pk_movimiento PRIMARY KEY (id_cliente,cargo_aplicado,servicio,nservicio),
CONSTRAINT fk_movimiento FOREIGN KEY (servicio,nservicio) REFERENCES T_SERVICIOS (servicio,nservicio),
CONSTRAINT fk2_movimiento FOREIGN KEY (cargo_aplicado) REFERENCES T_CARGOS (idcargo)
);

ALTER TABLE T_MOVIMIENTOS ADD CONSTRAINT pk_movimiento PRIMARY KEY (id_cliente);
CREATE TABLE T_MAESTRO
(suscripcion number(5),
alta DATE,
nombre varchar2(20) NOT NULL,
direccion varchar2(30),
barrio varchar2(16),
saldoactual number(10,2),
estrato number(5),
mail varchar2(80) UNIQUE,
fechaalta DATE,
CONSTRAINT pk_maestro PRIMARY KEY (suscripcion),
CONSTRAINT fk_maestro FOREIGN KEY (estrato) REFERENCES T_ESTRACTO(estrato),
CONSTRAINT fk2_maestro FOREIGN KEY (suscripcion) REFERENCES T_MOVIMIENTOS(id_cliente),
CONSTRAINT ck_maestro CHECK (suscripcion>=0)
--realizada con el to_char
CONSTRAINT ck3_maestro CHECK (to_char(fechaalta,'DD/MM')>'01/01')
--realizada con el extract 
CONSTRAINT ck3_maestro CHECK (EXTRACT(MONTH FROM fechaalta)>1 AND EXTRACT (DAY FROM fechaalta)>1)
);
ALTER TABLE T_MOVIMIENTOS DISABLE CONSTRAINT pk_movimiento;
ALTER TABLE T_MAESTRO DISABLE CONSTRAINT fk2_maestro;
ALTER TABLE T_MOVIMIENTOS DROP CONSTRAINT pk_movimiento1;
ALTER TABLE T_MOVIMIENTOS ADD CONSTRAINT pk_movimiento1 PRIMARY KEY (id_cliente);
ALTER TABLE T_MAESTRO ADD CONSTRAINT fk2_maestro FOREIGN KEY (suscripcion) REFERENCES T_MOVIMIENTOS(id_cliente);
ALTER TABLE T_MAESTRO DISABLE CONSTRAINT fk2_maestro;
ALTER TABLE T_MOVIMIENTOS ADD CONSTRAINT PRIMARY KEY (id_cliente,cargo_aplicado,servicio,nservicio);

--En los diagramas my sql cuando la linea es discontinua la clave es ajena solo y cuando es continua 
-- es clave primaria en la otra tabla

