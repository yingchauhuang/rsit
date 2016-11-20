#!/bin/bash

. ~/.bash_profile
export ORACLE_SID=fund
echo "
set encryption on identified by 'rsit5580' only;
backup as compressed backupset 
database plus archivelog delete input;
delete noprompt obsolete ;
"|rman target / nocatalog log=$HOME/OCS/log/bk_fund.log
/bin/tar cvf ~/dev/st0 /oracle /flashback/FUND/autobackup /flashback/FUND/backupset >> $HOME/OCS/log/bk_fund.log
