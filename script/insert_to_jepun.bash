#!/bin/bash
. ~/.bash_profile

export MAILADDR=daniel-peng@mails.rsit.com.tw
MAIL_INFO () {
if [ -z $STATUS ]
then
STATUS='OK'
fi
echo "
--------------------------
script_job : $0
status :$STATUS
`cat /tmp/jepnu.tmp`
-------------------------
"|mailx -s ${status}:$0 $MAILADDR
}

CHECK () {
echo "
set line 1000
set pages 0
set echo off
set feed off
select 'cmn_stkmp  :  '||count(*) ||' rows inserted ' from \"cmn_stkmp\"@jepun_bin28k.rsit.com.tw where \"logdate_\" >=  trunc(SYSDATE)
union all
select 'cmn_taiex  :  '||count(*) ||' rows inserted ' from \"cmn_taiex\"@jepun_bin28k.rsit.com.tw where \"logdate_\"  >=  trunc(SYSDATE);
"|sqlplus -s "/ as sysdba" > /tmp/jepnu.tmp
}

echo "
set line 1000
set pages 0
set echo off
set feed off
set trims on
whenever sqlerror exit 100
select 'insert into \"cmn_stkmp\"@jepun_bin28k.rsit.com.tw values('''||JS.\"sno_\"||''' ,to_date('''||fsk004.data_date||''',''yyyymmdd''),'||0||','||0||','||0||','||fsk004.cls_pri||','||0||','||0||','||0||',''admin'' ,to_date('''||fsk004.data_date||''',''yyyymmdd''));'
   from (select fsk004.data_date,stklg_type,cls_pri
         from fsk004
         where data_date=TO_CHAR(SYSDATE,'YYYYMMDD') and deal_ctr like 'T%') fsk004,\"cmn_stock\"@jepun_bin28k.rsit.com.tw JS
                     where fsk004.stklg_type=JS.\"stkno_\" 
union all
select 'commit;' from dual;
"|sqlplus -s "/ as sysdba"|sqlplus -s "/ as sysdba"
if [ $? -ne 0 ]
then
STATUS=FAILED
fi


echo "
whenever sqlerror exit 100
set line 1000
set pages 0
set echo off
set feed off
set trims on
select 'insert into \"cmn_taiex\"@jepun_bin28k.rsit.com.tw values ('''||decode(fsk004.deal_ctr,'T1','TSE','T2','OTC')||''',to_date('''||fsk004.data_date||''',''yyyy/mm/dd''),'||fsk004.cls_pri||',0,0,''admin'',to_date('''||fsk004.data_date||''',''yyyy/mm/dd''));'
from sw.fsk004
where data_date=to_char(sysdate,'yyyymmdd') and  stkdata_kind <>'00' and deal_ctr like 'T%'
union all
select 'commit;' from dual;
"|sqlplus -s "/ as sysdba"|sqlplus -s "/ as sysdba"
if [ $? -ne 0 ]
then
STATUS=FAILED
fi



echo "
delete cust_job_status where CDATE < SYSDATE-30;
insert into cust_job_status values (sysdate,'$0',nvl('${STATUS}',null,'OK');
commit;
exit
"|sqlplus "/ as sysdba"


CHECK
MAIL_INFO
