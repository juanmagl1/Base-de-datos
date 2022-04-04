-- 1
SELECT apellido,oficio,dept_no from EMPLE;

-- 2
SELECT * FROM DEPART;

-- 3
SELECT * FROM EMPLE;

-- 4
SELECT * FROM EMPLE
ORDER BY apellido;
-- 5
SELECT * FROM EMPLE
order by dept_no desc;
-- 6

SELECT * FROM EMPLE
order by dept_no desc,apellido asc;
-- 8
SELECT * FROM EMPLE
where salario > 2000000;

-- 9
SELECT * FROM EMPLE
where upper(oficio) like 'ANALISTA';

-- 10
SELECT apellido,oficio FROM EMPLE where dept_no = 20;

-- 12
SELECT * FROM EMPLE where oficio = 'VENDEDOR'
ORDER BY apellido;

-- 13
