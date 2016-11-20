--Update SW.fsk001
--set (STK_CHNM,STK_ENGNM)=(select SNAME,STK_ENGNM from XQ.TW001 WHERE SW.fsk001.STK_CD=XQ.TW001.STK_CD)
--where SW.fsk001.STK_CD in (select STK_CD from XQ.TW001);
--commit;
Merge INTO SW.FSK001 D
USING (select XQ.TW001.STK_CD,XQ.TW001.SNAME,XQ.TW001.STK_ENGNM as STK_ENGNM,(case when XQ.TW001.MARKET is NULL then 'T1' else  XQ.TW001.MARKET end) as DEAL_CTR,'TW' as COUNTRY_CD,'0' as INDEX_TYPE,cast(NVL(OS_STK,0) as number(09))*1000 as OS_STK,cast(CAPITAL as number(12)) as CPTL_AMT from XQ.TW001 left join XQ.TW_CAPITAL on XQ.TW001.STK_CD=XQ.TW_CAPITAL.SYMBOL WHERE  XQ.TW001.MARKET is NOT NULL) S
on (D.STK_CD = S.STK_CD AND D.DEAL_CTR = S.DEAL_CTR)
WHEN MATCHED THEN UPDATE SET
D.STK_CHNM = S.SNAME,
D.STK_ENGNM = S.STK_ENGNM
WHEN NOT MATCHED THEN INSERT
(D.STK_CD,
D.DEAL_CTR,
D.STK_CHNM,
D.STK_ENGNM,
D.STK_TYPE,
D.OS_STK,
D.CPTL_AMT,
D.UPD_USER,
D.UPD_DATE,
D.UPD_TIME,
D.CRNCY_CD,
D.WEIT_YN,
D.TRN_DEAL_CTR,
D.RELATION_YN,
D.TRAN_UNIT,
D.SUB_TYPE,
D.SCIENCE,
D.COUNTRY_CD,
D.INDEX_TYPE)
VALUES
(S.STK_CD,
S.DEAL_CTR,
S.SNAME,
S.STK_ENGNM,
case when S.DEAL_CTR='T2' then '2' else '1' end,
case when S.OS_STK is null then 0 else S.OS_STK end,
case when S.CPTL_AMT is null then 0 else S.CPTL_AMT end,
'XQ',
to_char(SYSDATE,'YYYYMMDD'),
to_char(SYSDATE,'HHMMSS') ,
'NTD',
' ',
'N',
'N',
1000,
'1',
'N',
S.COUNTRY_CD,
S.INDEX_TYPE);
commit;
Update SW.fsk001
set (STK_CHNM,STK_ENGNM)=(select SNAME,STK_ENGNM from XQ.TW001 WHERE SW.fsk001.STK_CD=XQ.TW001.STK_CD)
where SW.fsk001.STK_CD in (select STK_CD from XQ.TW001);
commit;

Update SW.fsk001
set OS_STK=(select cast(NVL(OS_STK,0) as number(12))*1000 from XQ.TW_Capital WHERE SW.fsk001.STK_CD=XQ.TW_Capital.STK_CD AND Capital is not null)
where SW.fsk001.STK_CD in (select STK_CD from XQ.TW_Capital  where Capital is not null);
commit;



commit;
exit;
