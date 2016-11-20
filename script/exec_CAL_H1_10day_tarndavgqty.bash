#!/bin/bash
. $HOME/.bash_profile
export ORACLE_SID=fund

echo "
exec sw.CAL_H1_10day_tarndavgqty;
"|sqlplus -s "/ as sysdba" > $HOME/OCS/log/CAL_H1_10day_tarndavgqty.log
