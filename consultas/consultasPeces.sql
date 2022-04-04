--1.	Nombre, apellido y teléfono de todos los afiliados que sean hombres 
--y que hayan nacido antes del 1 de enero de 1970
SELECT NOMBRE ,APELLIDOS ,TELF 
FROM AFILIADOS a 
WHERE extract(YEAR FROM a.NACIMIENTO)<1970
AND SEXO ='H';

--2.	Peso, talla  y nombre de todos los peces que se han pescado por con 
--talla inferior o igual a 45. 
--Los datos deben salir ordenados por el nombre del pez, 
--y para el mismo pez por el peso (primero los más grandes) y 
--para el mismo peso por la talla (primero los más grandes).
SELECT PEZ ,PESO ,TALLA FROM CAPTURASEVENTOS c WHERE TALLA <=45
UNION 
SELECT PEZ ,PESO ,TALLA FROM CAPTURASSOLOS c2  WHERE TALLA <=45
ORDER BY PEZ DESC,PESO DESC , TALLA DESC;
--3.	Obtener los nombres y apellidos de los afiliados que o 
--bien tienen la licencia de pesca que comienzan con una A (mayúscula o minúscula), 
--o bien el teléfono empieza en 9 y la dirección comienza en Avda.
SELECT DISTINCT a.NOMBRE ,APELLIDOS 
FROM AFILIADOS a,PERMISOS p 
WHERE a.FICHA =p.FICHA 
AND upper(p.LICENCIA )LIKE 'A%' 
OR (a.TELF LIKE '9%' AND upper(a.DIRECCION) LIKE 'AVDA%');

--4.	Lugares del cauce “Rio Genil” que en el campo de observaciones no tengan valor.
SELECT LUGAR 
FROM LUGARES l 
WHERE OBSERVACIONES IS NULL AND CAUCE LIKE 'Rio Genil';
--5.	Mostrar el nombre y apellidos de cada afiliado, 
--junto con la ficha de los afiliados que lo han avalado alguna vez como primer avalador.
SELECT a.NOMBRE ,APELLIDOS,c.AVAL1 
FROM AFILIADOS a ,CAPTURASSOLOS c 
WHERE a.FICHA =c.AVAL1;

--6.	Obtén los cauces y en qué lugar de ellos han encontrado tencas 
--(tipo de pez) cuando nuestros afiliados han ido a pescar solos, 
--indicando la comunidad a la que pertenece dicho lugar. (no deben salir valores repetidos)
SELECT DISTINCT l.CAUCE ,l.LUGAR,l.COMUNIDAD  
FROM CAPTURASSOLOS c ,LUGARES l
WHERE c.LUGAR =l.LUGAR
AND upper(c.PEZ) LIKE 'TENCA';

--7.	Mostrar el nombre y apellido de los afiliados que han conseguido alguna copa. 
--Los datos deben salir ordenador por la fecha del evento, mostrando primero los eventos más antiguos.
SELECT a.NOMBRE ,a.APELLIDOS FROM AFILIADOS a ,PARTICIPACIONES p,EVENTOS e 
WHERE a.FICHA =p.FICHA
AND e.EVENTO =p.EVENTO
AND p.TROFEO LIKE 'Copa%'
ORDER BY e.FECHA_EVENTO ASC;

--8.	Obtén la ficha, nombre, apellidos, posición y trofeo de todos los participantes del evento 
--'Super Barbo' mostrándolos según su clasificación.
SELECT a.FICHA ,a.NOMBRE ,a.APELLIDOS ,p.POSICION FROM AFILIADOS a,PARTICIPACIONES p
WHERE a.FICHA =p.FICHA 
AND upper(p.EVENTO) LIKE 'SUPER BARBO'
ORDER BY p.POSICION asc;

--9.	Mostrar el nombre y apellidos de cada afiliado, junto con el nombre y apellidos de 
--los afiliados que lo han avalado alguna vez como segundo avalador.
SELECT DISTINCT a.NOMBRE ,a.APELLIDOS,a2.NOMBRE ,a2.APELLIDOS
FROM AFILIADOS a ,CAPTURASSOLOS c,AFILIADOS a2 
WHERE a.FICHA =c.FICHA
AND  c.AVAL2 =a2.FICHA;


--10.	Indica todos los eventos en los que participó el afiliado 3796 en 1995 que no 
--consiguió trofeo, ordenados descendentemente por fecha.
SELECT e.*
FROM EVENTOS e , PARTICIPACIONES p 
WHERE e.EVENTO =p.EVENTO 
AND p.FICHA = 3796
AND EXTRACT(YEAR FROM e.FECHA_EVENTO)=1995
AND p.TROFEO IS NULL;