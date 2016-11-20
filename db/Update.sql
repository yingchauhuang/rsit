Update XQ.FIN001 Set STK_CD=LTRIM(SYMBOL,'0')||' HK',YQ=TO_CHAR((case when AnnDATE<FinDate then AnnDate else FinDate end),'YYYYQ');
Update XQ.HK001 Set Market='H1',STK_CD=LTRIM(SYMBOL,'0')||' HK',STK_CHNM=cast(SUBSTR(Name,0,20) as varchar(20)),STK_ENGNM=cast(SUBSTR(nvl(SEName,STK_ENGNM),0,50) as varchar(50));
Update XQ.HK002 Set Market='H1',STK_CD=LTRIM(SYMBOL,'0')||' HK';
Update XQ.HK003 Set Market='H1',STK_CD=LTRIM(SYMBOL,'0')||' HK';
Update XQ.HK_Capital Set STK_CD=LTRIM(SYMBOL,'0')||' HK';
commit;
exit;
