CREATE TABLE EDITORIAL
(cod_editorial	number(4),
denominacion VARCHAR2(60),
CONSTRAINT pk_editorial PRIMARY KEY (cod_editorial)
);

CREATE TABLE TEMA
(cod_tema NUMBER(3),
denominacion VARCHAR2(150),
cod_tema_padre NUMBER(3),
CONSTRAINT pk_tema PRIMARY KEY (cod_tema),
CONSTRAINT ck_tema_padre CHECK (cod_tema_padre>=cod_tema)
);
ALTER TABLE TEMA ADD CONSTRAINT fk_tema FOREIGN KEY (cod_tema_padre) REFERENCES TEMA (cod_tema) ON DELETE CASCADE;

CREATE TABLE AUTOR
(cod_autor	number(4),
nombre 	VARCHAR2(80),
f_nacimiento DATE,
libro_principal NUMBER(4),
CONSTRAINT pk_autor PRIMARY KEY (cod_autor)
);

CREATE TABLE LIBRO 
(cod_libro	number(4),
titulo VARCHAR2(120),
f_creacion DATE,
cod_tema NUMBER(3),
autor_principal NUMBER(3),
CONSTRAINT pk_libro PRIMARY KEY (cod_libro),
CONSTRAINT fk1_libro FOREIGN KEY (cod_tema) REFERENCES TEMA (cod_tema),
CONSTRAINT fk2_libro FOREIGN KEY (autor_principal) REFERENCES AUTOR (cod_autor)
);
ALTER TABLE AUTOR ADD CONSTRAINT fk_Autor FOREIGN KEY (libro_principal) REFERENCES LIBRO (cod_libro);

CREATE TABLE LIBRO_AUTOR
(cod_libro	number(4),
cod_autor 	number(4),
orden		NUMBER(1),
CONSTRAINT pk_libroAutor PRIMARY KEY (cod_libro,cod_autor),
CONSTRAINT fk1_libroAutor FOREIGN KEY (cod_libro) REFERENCES LIBRO (cod_libro),
CONSTRAINT fk2_libroAutor FOREIGN KEY (cod_autor) REFERENCES AUTOR (cod_autor),
CONSTRAINT ck_libroAutor CHECK (orden BETWEEN 1 AND 5)
);

CREATE TABLE PUBLICACION
(cod_editorial	NUMBER(4),
cod_libro		number(4),
precio 			NUMBER(4) NOT NULL,
f_publicacion	DATE DEFAULT sysdate,
CONSTRAINT pk_publicacion PRIMARY KEY (cod_editorial,cod_libro),
CONSTRAINT fk1_publicacion FOREIGN KEY (cod_editorial) REFERENCES EDITORIAL (cod_editorial),
CONSTRAINT fk2_publicacion FOREIGN KEY (cod_libro) REFERENCES LIBRO (cod_libro),
CONSTRAINT ck2_publicacion CHECK (precio>0)
);

--Ejercicios extra--
--1.Nos hemos dado cuenta que una misma editorial puede publicar varias veces el mismo libro. 
--Razona si se podría hacer, y en caso contrario indica las órdenes a seguir.

--No puede públicar varias veces el mismo libro porque la clave no nos permite repetir la clave conjunta, la instrucción que deberiamos realizar es
--ampliar la clave 
ALTER TABLE PUBLICACION DROP CONSTRAINT pk_publicacion;
--Con este comando eliminamos la clave y procedemos a ampliarla
ALTER TABLE PUBLICACION ADD CONSTRAINT pk_publicacion PRIMARY KEY (cod_editorial,cod_libro,f_publicacion);
--2.Borrar todas las tablas--
DROP TABLE PUBLICACION;
DROP TABLE EDITORIAL;
DROP TABLE LIBRO_AUTOR;
ALTER TABLE LIBRO DROP CONSTRAINT fk1_libro;
ALTER TABLE LIBRO DROP CONSTRAINT fk2_libro;
DROP TABLE TEMA;
DROP TABLE AUTOR;
DROP TABLE LIBRO;

