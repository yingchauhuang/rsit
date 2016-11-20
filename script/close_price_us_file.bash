#!/bin/bash
. ~/.bash_profile
export Oracle_User=xq
export Oracle_PWD=xq1234
export WorkFolder=/xq/rsit/db

cd $WorkFolder

sqlldr $Oracle_User/$Oracle_PWD control=US002.ctrl

sqlldr $Oracle_User/$Oracle_PWD control=US001.ctrl

sqlplus -s -l $Oracle_User/$Oracle_PWD "@Update_US.sql"



