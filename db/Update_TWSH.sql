Update XQ.TWSH Set Symbol=trim(substr(Symbol,3,length(Symbol)-2));
commit;
Update XQ.TWSH
set Market=(select Market from XQ.TW001 WHERE TRIM(XQ.TWSH.Symbol)=TRIM(XQ.TW001.STK_CD) );
commit;
Update XQ.TWSH
set Market=(case when XQ.TWSH.MARKET is NULL then 'T1' else  XQ.TWSH.MARKET end);
commit;
delete from sw.FSK016 where UPD_USER='XQ' and SHMT_DATE>(select min(Event_Date) from XQ.TWSH);
commit;
Merge INTO SW.FSK016 D
USING (select XQ.TWSH.Symbol as STK_CD,
XQ.TWSH.MARKET  as DEAL_CTR,
Event_Date as SHMT_DATE,
(case when XQ.TWSH.TYPE like '%Á{®É·|%' then to_char((TO_DATE(Event_Date,'yyyymmdd')-30),'YYYYMMDD') else to_char((TO_DATE(Event_Date,'yyyymmdd')-60),'YYYYMMDD') end) as LSRG_DATE,
(case when XQ.TWSH.FLAG='0' then 'N' else  'Y' end) as CHF_CHG_YN,
'XQ' as UPD_USER,to_char(SYSDATE,'YYYYMMDD') as UPD_DATE,
to_char(SYSDATE,'HHMMSS') as UPD_TIME,
ADDRESS as SHMT_ADDR,
TYPE as SHMT_NAME
from XQ.TWSH WHERE  XQ.TWSH.Symbol is not NULL) S
on (D.STK_CD = S.STK_CD AND D.DEAL_CTR = S.DEAL_CTR AND D.SHMT_DATE = S.SHMT_DATE AND D.SHMT_NAME=D.SHMT_NAME)
WHEN MATCHED THEN UPDATE SET
D.LSRG_DATE = S.LSRG_DATE,
D.CHF_CHG_YN = S.CHF_CHG_YN,
D.UPD_USER = S.UPD_USER,
D.UPD_DATE = S.UPD_DATE,
D.UPD_TIME = S.UPD_TIME,
D.SHMT_ADDR = S.SHMT_ADDR
WHEN NOT MATCHED THEN INSERT
(D.STK_CD,
D.DEAL_CTR,
D.SHMT_DATE,
D.LSRG_DATE,
D.CHF_CHG_YN,
D.UPD_USER,
D.UPD_DATE,
D.UPD_TIME,
D.SHMT_ADDR,
D.SHMT_NAME)
VALUES
(S.STK_CD,
S.DEAL_CTR,
S.SHMT_DATE,
S.LSRG_DATE,
S.CHF_CHG_YN,
S.UPD_USER,
S.UPD_DATE,
S.UPD_TIME,
S.SHMT_ADDR,
S.SHMT_NAME);

commit;
Update SW.FSK016
set LSBY_DATE=get_bsdt_num(LSRG_DATE,'01','2',2)
where UPD_USER='XQ';
commit;
exit;
