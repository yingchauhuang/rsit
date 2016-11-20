#!/bin/bash
. ~/.bash_profile
export Oracle_User=xq
export Oracle_PWD=xq1234
export WorkFolder=/xq/rsit/db

mkdir $WorkFolder
cd $WorkFolder

if [ $? -eq 0 ]
then
echo "
whenever sqlerror exit 50
$STR
select 1/count(*)  from v\$database where database_role = 'PRIMARY';
exit ;
"|sqlplus "/ as sysdba"
fi

#sqlplus -s -l $Oracle_User/$Oracle_PWD "@cleandb.sql"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@clean_Fund.sql"
sqlldr $Oracle_User/$Oracle_PWD control=FD002.ctrl
sqlldr $Oracle_User/$Oracle_PWD control=FD001.ctrl
sqlldr $Oracle_User/$Oracle_PWD control=WFD002.ctrl
sqlldr $Oracle_User/$Oracle_PWD control=WFD001.ctrl

#sqlplus -s -l $Oracle_User/$Oracle_PWD "@Update_Fund.sql"
#sqlplus -s -l $Oracle_User/$Oracle_PWD "@Sync_US.sql"
#sqlplus -s -l $Oracle_User/$Oracle_PWD "@After_Import.sql"

#sqlplus -s -l $Oracle_User/$Oracle_PWD "@compute_vol10.sql"
#sqlplus -s -l $Oracle_User/$Oracle_PWD "@TW_compute_vol10.sql"
#sqlplus -s -l $Oracle_User/$Oracle_PWD  @/home/oracle/XQ/sqlcmd/Merge_Event.sql

export STR=''
export LOADER=0

if [ $? -eq 0 ] 
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



