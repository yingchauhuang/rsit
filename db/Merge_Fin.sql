MERGE INTO SW.RAT001 D
   USING (select Symbol,YQ,'ACT003',F24 from XQ.FIN001 where FinDate>TRUNC(TRUNC(SYSDATE , 'Month')-1 , 'Month')) S
   ON (D.LIST_CODE = S.Symbol AND D.YQ=S.YQ AND D.RATIO_CODE='ACT003')
   WHEN MATCHED THEN UPDATE SET D.RATIO_VALUE = S.F24
   WHEN NOT MATCHED THEN INSERT (D.LIST_CODE,D.YQ,D.RATIO_CODE,D.RATIO_VALUE)  VALUES (S.Symbol, S.YQ,'ACT003',S.F24);
   
Commit;

MERGE INTO SW.RAT001 D
   USING (select Symbol,YQ,'ACT003',F24 from XQ.FIN001 where FinDate>TRUNC(TRUNC(SYSDATE , 'Month')-1 , 'Month')) S
   ON (D.LIST_CODE = S.Symbol AND D.YQ=S.YQ AND D.RATIO_CODE='ACT003')
   WHEN MATCHED THEN UPDATE SET D.RATIO_VALUE = S.F24
   WHEN NOT MATCHED THEN INSERT (D.LIST_CODE,D.YQ,D.RATIO_CODE,D.RATIO_VALUE)  VALUES (S.Symbol, S.YQ,'ACT003',S.F24);
   
Commit;
exit
