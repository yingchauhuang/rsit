echo "
startup nomount
whenever sqlerror exit 100
select 1/(count(*)-1) from v\$database where open_mode = 'READ WRITE';
WHENEVER SQLERROR CONTINUE 
shutdown immediate
startup nomount
exit
"|sqlplus "sys/rsit5580@FUND_RSIT-DB02.rsit.com.tw as sysdba"

echo "
set encryption on identified by 'rsit5580' only;
set decryption identified by 'rsit5580' ;
backup current controlfile for standby;
sql 'alter system archive log current';
sql 'alter system checkpoint';
run {
allocate auxiliary channel t1 type disk;
allocate auxiliary channel t2 type disk;
duplicate target database for standby dorecover nofilenamecheck;
}
exit
"|rman target / auxiliary sys/rsit5580@FUND_RSIT-DB02.rsit.com.tw log=/home/oracle/OCS/log/duplicate_fund_stdby.log

dgmgrl / "enable configuraiton"
