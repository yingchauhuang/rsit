#!/bin/bash -x
. ~/.bash_profile
export Oracle_User=xq
export Oracle_PWD=xq1234
export WorkFolder=/xq/rsit/db

cd $WorkFolder


sqlplus -s -l $Oracle_User/$Oracle_PWD "@TW_compute_vol10.sql"


