alter session set "_oracle_script"=true;  
create user peces identified by peces;
GRANT CONNECT, RESOURCE, DBA TO peces;
