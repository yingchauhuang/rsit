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

if [ $? -eq 0 ]
then
curl -o HKD_Update_web.txt 'http://getmkdata.moneydj.com/getmkdata.aspx?BrokerID=SysJust&A=HK'
if [ $? -ne 0 ]
then
export SFTP=1
else
export SFTP=0
fi
else
SFTP=1
fi

#sqlplus -s -l $Oracle_User/$Oracle_PWD "@cleandb.sql"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@clean_HK.sql"
sqlldr $Oracle_User/$Oracle_PWD control=HK002_web.ctrl

sqlplus -s -l $Oracle_User/$Oracle_PWD "@Update_HK_Close.sql"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@Sync_HK_Close.sql"
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



