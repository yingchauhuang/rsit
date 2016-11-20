Update XQ.TWFIN001 Set STK_CD=SYMBOL,YQ=TO_CHAR((case when AnnDATE<FinDate then AnnDate else FinDate end),'YYYYQ');
Update XQ.TWFIN001B Set STK_CD=SYMBOL,YQ=TO_CHAR((case when AnnDATE<FinDate then AnnDate else FinDate end),'YYYYQ');
Update XQ.TW001 Set SYMBOL=trim(SYMBOL);
Update XQ.TW001 Set Market=case substr(Category,3,1) when '0' then 'T1' when '1' then 'T2' when '2' then 'T3' else '' end,STK_CD=trim(SYMBOL),STK_CHNM=cast(SUBSTR(Name,0,20) as varchar(20)),STK_ENGNM=cast(SUBSTR(SEName,0,50) as varchar(50));
Update XQ.TW_Capital Set STK_CD=SYMBOL;
commit;
exit;
