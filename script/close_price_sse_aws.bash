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

unrar e -y Symbol.rar
unrar e -y HisData_CH.rar


echo "Begin clean_close"
#sqlplus -s -l $Oracle_User/$Oracle_PWD "@cleandb.sql"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@clean_close_SSE.sql"

echo "Begin import data"

sqlldr $Oracle_User/$Oracle_PWD control=SSE002_aws.ctrl

echo "Begin After Import"
sqlplus -s -l $Oracle_User/$Oracle_PWD "@After_Import_SSE.sql"

#因為大盤及所有股票沒進來Computer 需要　refer 大盤... 所以先disable
#echo "Begin SZSE_Compute_vol10"
#sqlplus -s -l $Oracle_User/$Oracle_PWD "@compute_vol10_SZSE.sql"





