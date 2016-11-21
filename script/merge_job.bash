#!/bin/bash
. ~/.bash_profile
export Oracle_User=xq
export Oracle_PWD=xq1234
export WorkFolder=/xq/rsit/db

mkdir $WorkFolder
cd $WorkFolder

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

unrar e -y FinData.rar   
unrar e -y FundSymbol.rar   
unrar e -y HisData_Fund.rar 
unrar e -y HisData_HK.rar 
unrar e -y HisData_US.rar
unrar e -y Symbol.rar
unrar e -y HisData_TW.rar
unrar e -y HisData_TW_Factor.rar
sqlplus -s -l $Oracle_User/$Oracle_PWD "@cleandb.sql"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@clean_US.sql"

#sqlplus -s -l $Oracle_User/$Oracle_PWD "@clean_close.sql"
sqlldr $Oracle_User/$Oracle_PWD control=HK_Capital.ctrl
sqlldr $Oracle_User/$Oracle_PWD control=HK003.ctrl
sqlldr $Oracle_User/$Oracle_PWD control=HK002_aws.ctrl
sqlldr $Oracle_User/$Oracle_PWD control=HK001.ctrl
sqlldr $Oracle_User/$Oracle_PWD control=FIN001.ctrl
sqlldr $Oracle_User/$Oracle_PWD control=TW_Capital.ctrl

sqlldr $Oracle_User/$Oracle_PWD control=TW003.ctrl
#sqlldr $Oracle_User/$Oracle_PWD control=TW002.ctrl
sqlldr $Oracle_User/$Oracle_PWD control=TW001.ctrl
#sqlldr $Oracle_User/$Oracle_PWD control=TWFIN001.ctrl
sqlldr $Oracle_User/$Oracle_PWD control=TWFIN001B.ctrl
sqlldr $Oracle_User/$Oracle_PWD control=US002_AWS.ctrl
sqlldr $Oracle_User/$Oracle_PWD control=US001.ctrl
sqlldr $Oracle_User/$Oracle_PWD control=SSE001.ctrl
sqlldr $Oracle_User/$Oracle_PWD control=SZSE001.ctrl
sqlldr $Oracle_User/$Oracle_PWD control=CN_Capital.ctrl
sqlplus -s -l $Oracle_User/$Oracle_PWD "@Update_US.sql"

sqlplus -s -l $Oracle_User/$Oracle_PWD "@Update.sql"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@Sync.sql"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@Update_Fin.sql"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@Update_Fin_TW.sql"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@Update_TW.sql"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@Update_SSE.sql"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@Update_SZSE.sql"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@Sync_TW.sql"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@Sync_CN.sql"

currenMD=$(date +"%m-%d")
echo $currenMD
if [ "$currenMD" == "03-31" ] || [ "$currenMD" == "04-01" ] || [ "$currenMD" == "04-06" ] || [  "$currenMD" == "02-01" ]  || [ "$currenMD" == "02-02" ]|| [  "$currenMD" == "02-03" ]|| [ "$currenMD" == "05-16" ] || [ "$currenMD" == "05-17" ] || [  "$currenMD" == "05-18" ] || [  "$currenMD" == "05-19" ] || [ "$currenMD" == "05-20" ] || [  "$currenMD" == "05-21" ] || [  "$currenMD" == "05-22" ] || [  "$currenMD" == "08-16" ] || [  "$currenMD" == "08-17" ] || [  "$currenMD" == "08-18" ]  || [  "$currenMD" == "08-19" ] || [ "$currenMD" == "08-20" ] || [  "$currenMD" == "08-21" ] || [  "$currenMD" == "08-22" ] || [  "$currenMD" == "11-16" ] || [  "$currenMD" == "11-17" ] || [  "$currenMD" == "11-18" ]  || [  "$currenMD" == "11-19" ] || [ "$currenMD" == "11-20" ] || [  "$currenMD" == "11-21" ] || [  "$currenMD" == "11-22" ] 
then
	echo "Update Finance Date !!!"
        sqlplus -s -l $Oracle_User/$Oracle_PWD "@Update_Fin_TW.sql"
else
	echo "Not necessary Update Finance Data !!!"
fi
#sqlplus -s -l $Oracle_User/$Oracle_PWD "@After_Import.sql"

#sqlplus -s -l $Oracle_User/$Oracle_PWD "@TW_compute_vol10.sql"
echo "@Merge_Event.sql"
echo "@compute_vol10.sql"

sqlplus -s -l $Oracle_User/$Oracle_PWD  "@Merge_Event.sql"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@compute_vol10.sql"

