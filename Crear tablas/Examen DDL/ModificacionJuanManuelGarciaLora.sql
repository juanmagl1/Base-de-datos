--Apartado 2

--1. El campo sexo de la tabla ENFERMO solo podrá tomar valores 'H', o 'M'.
ALTER TABLE ENFERMO ADD CONSTRAINT ck_enfermo CHECK (sexo IN ('H','M'));

-- 2. Modificar la columna NSS para que su longitud sea 22.
ALTER TABLE ENFERMO MODIFY nss varchar(22);

-- 3. Añade el campo fecha_próxima_visita a la tabla Visita.
ALTER TABLE VISITA ADD fecha_proxima_visita DATE;

/* 4. Nos llaman para decirnos que hay un problema 
 * en la base de datos y que no pueden insertar datos de forma que un mismo médico 
 * vea dos veces a un mismo enfermo en la tabla de visitas. ¿A qué puede ser debido?
 * No se puede hacer la instrucción porque no se puede repetir la clave primaria, entonces lo que podriamos hacer
 * sería ampliar la clave primaria en la tabla visita y así arreglariamos el error*/
--Primero borramos la clave primaria erronea
ALTER TABLE VISITA DROP CONSTRAINT pk_visita;
--Ahora procedemos a introducir la clave primaria que arregle el error
ALTER TABLE VISITA ADD CONSTRAINT pk_visita PRIMARY KEY (cod_medico,cod_inscripcion,fecha);
 /* Explica por qué ocurre y arréglalo con las instrucciones de modificación de tablas correspondientes.
 *  Recuerda que para incluir los comentarios en tu código deberás usar para más de una linea, o - - 
 * si solo quieres comentar una línea .
 * 
 */
 
--5  5. Borra todos los datos de la tabla enfermo. 
TRUNCATE TABLE enfermo;

-- 6. Borra todas las tablas que has creado con el número mínimo de instrucciones.
DROP TABLE ENFERMO CASCADE CONSTRAINT;
DROP TABLE HABITACION CASCADE CONSTRAINT;
DROP TABLE INGRESO CASCADE CONSTRAINT;
DROP TABLE MEDICO CASCADE CONSTRAINT;
DROP TABLE VISITA CASCADE CONSTRAINT;