#!/bin/bash

. $HOME/.bash_profile

#exp system/rsit5580@tfund file=$HOME/OCS/temp/tfund_norows.dmp rows=n log=$HOME/OCS/log/tfund.exp.log full=y
#exp system/rsit5580@tfund file=$HOME/OCS/temp/tfund_MGM01.dmp.new log=$HOME/OCS/log/tfund_mgm01.exp.log tables=\(SW.MGM01,SW.BMS001\)

echo "
shutdown immediate
startup nomount
exit
"|sqlplus "sys/rsit5580@TFUND as sysdba"

echo "
set encryption on identified by 'rsit5580' only;
set decryption identified by 'rsit5580' ;
run {
#set until time \"trunc(sysdate-5) - to_number(to_char(trunc(sysdate-5),'D')) +1 +5 + 18/24\";
allocate auxiliary channel t1 type disk;
allocate auxiliary channel t2 type disk;
duplicate target database to tfund;
}
exit
"|rman target / auxiliary sys/rsit5580@TFUND log=/home/oracle/OCS/log/duplicate_tfund.log

echo "
shutdown immediate
startup mount
alter database flashback off;
alter database noarchivelog;
alter database open;
exec dbms_capture_adm.stop_capture('AV\$CAPTURE_21');
exec dbms_capture_adm.drop_capture('AV\$CAPTURE_21');
drop table SW.MGM01;
drop table SW.BMS001;
alter tablespace temp add tempfile '/oradata/tfund/temp02.dbf' reuse autoextend on maxsize 16384m;
alter tablespace temp drop tempfile '/oradata/tfund/temp01.dbf';
alter system set service_names='TFUND';
exit
"|sqlplus "sys/rsit5580@TFUND as sysdba"
OPENDB = $?
imp system/rsit5580@tfund file=$HOME/OCS/temp/tfund_MGM01.dmp.new log=$HOME/OCS/log/tfund_mgm01.imp.log fromuser=SW touser=SW 
#imp system/rsit5580@tfund file=$HOME/OCS/temp/tfund_norows.dmp log=$HOME/OCS/log/tfund.imp.log ignore=y full=y 

egrep -i 'error|fail' /home/oracle/OCS/log/duplicate_tfund.log
if [ $? -ne 0 ]
then
echo "
delete cust_job_status where CDATE < SYSDATE-30;
insert into cust_job_status values (sysdate,'$0','OK');
commit;
exit
"|sqlplus "/ as sysdba"
else
echo "
insert into cust_job_status values (sysdate,'$0','FAILED');
commit;
exit
"|sqlplus "/ as sysdba"
fi


