Update XQ.TW002 Set Market='T1',STK_CD=SYMBOL;
Update XQ.TW002
set Market=(select Market from XQ.TW001 WHERE XQ.TW002.STK_CD=XQ.TW001.STK_CD )
where XQ.TW002.STK_CD in (select STK_CD from XQ.TW001  where STK_CD is not null);
Update XQ.TW002 Set Market='T1',STK_CD='00000000' where SYMBOL='TSE';

Update XQ.TW002 Set Market='T2',STK_CD='00000000' where SYMBOL='OTC';

INSERT INTO SW.FSK004(STKDATA_KIND,
STKLG_TYPE,
DEAL_CTR,
DATA_DATE,
OPEN_PRI,
CLS_PRI,
TOP_PRI,
LOW_PRI,
TRA_QTY,
TRA_AMT,
CPTL_AMT,
OS_STK,
TR_SOURCE,
UPD_USER,
UPD_DATE,
UPD_TIME,
UPLOAD_UID,
UPLOAD_DATE,
UPLOAD_TIME)
select case when TW002.SYMBOL='TSE'  then '90' when  TW002.SYMBOL='OTC'  then '80' else '00' end,TW002.STK_CD,MARKET,to_char(tDate,'YYYYMMDD'),tOpen,tClose,tHigh,tLow,tVolume,NVL(cast(tAmount as number(16)),0), NVL(cast(Capital as number(16)),0)*1000,NVL(cast(OS_STK as number(12)),0)*1000,'C','XQ',to_char(SYSDATE,'YYYYMMDD'),to_char(SYSDATE,'HHMISS'),'XQ',to_char(SYSDATE,'YYYYMMDD'),to_char(SYSDATE,'HHMISS')
from XQ.TW002
left join XQ.TW_CAPITAL on TW_CAPITAL.SYMBOL=TW002.SYMBOL
WHERE (TW002.SYMBOL in (select SYMBOL from XQ.TW001) or (TW002.SYMBOL in ('TSE','OTC')))
AND TW002.STK_CD not in (select STKLG_TYPE from SW.FSK004 where DATA_DATE=to_char(tDate,'YYYYMMDD') AND DEAL_CTR=MARKET);


commit;
exit;
