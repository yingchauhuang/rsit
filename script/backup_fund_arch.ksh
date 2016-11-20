#!/bin/bash

. ~/.bash_profile
export ORACLE_SID=fund
echo "
set encryption on identified by 'rsit5580' only;
backup
current controlfile for standby;
sql 'alter system archive log current';
backup 
archivelog all delete input;
"|rman target / nocatalog log=$HOME/OCS/log/bk_fund_arch.log
