Update XQ.SZSE001 Set SYMBOL=trim(SYMBOL);
Update XQ.SZSE001 Set Market='SN',STK_CD=trim(SYMBOL),STK_CHNM=cast(SUBSTR(Name,0,20) as varchar(20)),STK_ENGNM=cast(SUBSTR(SEName,0,50) as varchar(50));
Update XQ.CN_Capital Set STK_CD=SYMBOL;
commit;
exit;
