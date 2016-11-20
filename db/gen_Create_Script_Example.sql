set heading off;
set echo off;
Set pages 999;
set long 90000;
 
spool Create_HK003.sql
 
select dbms_metadata.get_ddl('TABLE','HK003','XQ') from dual;
 
spool off;
