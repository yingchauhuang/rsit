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

unrar e -y FinData.rar  && unrar e -y FundSymbol.rar  && unrar e -y HisData_Fund.rar && \
unrar e -y HisData_HK.rar && \
unrar e -y HisData_US.rar && \
unrar e -y Symbol.rar && \
unrar e -y HisData_TW_Factor.rar
if [ $? -ne 0 ]
then
export URAR=1
else
export URAR=0
fi

#sqlplus -s -l $Oracle_User/$Oracle_PWD "@cleandb.sql"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@clean_dividend.sql"
sqlldr $Oracle_User/$Oracle_PWD control=TWDividend.ctrl
sqlplus -s -l $Oracle_User/$Oracle_PWD "@Update_Dividend.sql"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@clean_TWSH.sql"
sqlldr $Oracle_User/$Oracle_PWD control=TWSH.ctrl
sqlplus -s -l $Oracle_User/$Oracle_PWD "@Update_TWSH.sql"
export STR=''
export LOADER=0

#if [ $? -eq 0 ] && [ $LOADER -eq 0 ] && [ $SFTP -eq 0 ] && [ $URAR -eq 0 ]
if [ $? -eq 0 ] && [ $LOADER -eq 0 ]
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

