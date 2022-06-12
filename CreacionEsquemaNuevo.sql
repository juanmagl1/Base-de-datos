alter session set "_oracle_script"=true;  
create user examen identified by examen;
GRANT CONNECT, RESOURCE, DBA TO examen;
