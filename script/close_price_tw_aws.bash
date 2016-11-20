#!/bin/bash
. ~/.bash_profile
export Oracle_User=xq
export Oracle_PWD=xq1234
export WorkFolder=/xq/rsit/db

mkdir $WorkFolder
cd $WorkFolder


if [ $? -eq 0 ]
then
scp -i ~/.ssh/ychkyc01.pem ubuntu@52.206.21.188:/home/moneydjtv/data/xq/global/* $WorkFolder
if [ $? -ne 0 ]
then
export SFTP=1
else
export SFTP=0
fi
else
SFTP=1
fi

if [ $? -eq 0 ]
then
scp -i ~/.ssh/ychkyc01.pem ubuntu@52.206.21.188:/home/moneydjtv/data/xq/tw/* $WorkFolder
if [ $? -ne 0 ]
then
export SFTP=1
else
export SFTP=0
fi
else
SFTP=1
fi

unrar e -y FinData.rar 
unrar e -y FundSymbol.rar 
unrar e -y HisData_Fund.rar
unrar e -y HisData_HK.rar 
unrar e -y HisData_US.rar
unrar e -y Symbol.rar
unrar e -y HisData_SZSE.rar
unrar e -y HisData_SSE.rar
unrar e -y HisData_TW.rar
unrar e -y HisData_TW_Factor.rar
if [ $? -ne 0 ]
then
export URAR=1
else
export URAR=0
fi

echo "Begin clean_close"
#sqlplus -s -l $Oracle_User/$Oracle_PWD "@cleandb.sql"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@clean_close.sql"
#sqlldr $Oracle_User/$Oracle_PWD control=HK_Capital.ctrl
#sqlldr $Oracle_User/$Oracle_PWD control=HK003.ctrl
#sqlldr $Oracle_User/$Oracle_PWD control=HK002.ctrl
#sqlldr $Oracle_User/$Oracle_PWD control=HK001.ctrl
#sqlldr $Oracle_User/$Oracle_PWD control=FIN001.ctrl
#sqlldr $Oracle_User/$Oracle_PWD control=TW_Capital.ctrl
echo "Begin import data"
#sqlldr $Oracle_User/$Oracle_PWD control=TW003.ctrl
sqlldr $Oracle_User/$Oracle_PWD control=TW002_aws.ctrl
#sqlldr $Oracle_User/$Oracle_PWD control=TW001.ctrl
#sqlldr $Oracle_User/$Oracle_PWD control=TWFIN001.ctrl

#sqlplus -s -l $Oracle_User/$Oracle_PWD "@Update.sql"
#sqlplus -s -l $Oracle_User/$Oracle_PWD "@Sync.sql"
#sqlplus -s -l $Oracle_User/$Oracle_PWD "@Update_Fin.sql"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@Update_TW.sql"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@Sync_TW.sql"
#sqlplus -s -l $Oracle_User/$Oracle_PWD "@Update_Fin_TW.sql"
echo "Begin After Import"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@After_Import.sql"


#sqlplus -s -l $Oracle_User/$Oracle_PWD "@compute_vol10.sql"
echo "Begin TW_Compute_vol10"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@TW_compute_vol10.sql"
#sqlplus -s -l $Oracle_User/$Oracle_PWD  @/home/oracle/XQ/sqlcmd/Merge_Event.sql

export STR=''
export LOADER=0

if [ $? -eq 0 ] && [ $LOADER -eq 0 ] && [ $SFTP -eq 0 ] && [ $URAR -eq 0 ]
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






