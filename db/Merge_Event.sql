Update XQ.TW003 Set Market='T1',STK_CD=trim(SYMBOL);
Update XQ.TW003
set Market=(select Market from XQ.TW001 WHERE XQ.TW003.STK_CD=XQ.TW001.STK_CD )
where XQ.TW003.STK_CD in (select STK_CD from XQ.TW001  where STK_CD is not null);

whenever sqlerror exit 100
MERGE INTO SYSTEX.FSK984 D
   USING (SELECT STK_CD,to_CHAR(tDate,'YYYYMMDD') as START_DATE,to_CHAR(tDate,'YYYYMMDD') as END_DATE,'1' as WARN_TYPE,EVENT as WARN_REA from XQ.HK003 where Type='EV000110') S
   ON (D.STK_CD = S.STK_CD AND D.START_DATE=S.START_DATE)
   WHEN MATCHED THEN UPDATE SET D.UPD_USER='XQ',D.UPD_DATE=to_char(SYSDATE,'YYYYMMDD'),D.UPD_TIME=to_char(SYSDATE,'HHMMSS'),D.WARN_REA=S.WARN_REA
   WHEN NOT MATCHED THEN INSERT (D.STK_CD,D.START_DATE,D.END_DATE,D.WARN_TYPE,D.UPD_USER,D.UPD_DATE,D.UPD_TIME,D.WARN_REA) VALUES (S.STK_CD, S.START_DATE,S.END_DATE,S.WARN_TYPE,'XQ',to_char(SYSDATE,'YYYYMMDD'),to_char(SYSDATE,'HHMMSS'),S.WARN_REA);
commit;
whenever sqlerror exit 100
MERGE INTO SYSTEX.FSK984 D
   USING (SELECT STK_CD,to_CHAR(tDate,'YYYYMMDD') as START_DATE,to_CHAR(tDate,'YYYYMMDD') as END_DATE,TYPE as WARN_TYPE,EVENT as WARN_REA from XQ.TW003 where TYPE='1') S
   ON (D.STK_CD = S.STK_CD AND D.START_DATE=S.START_DATE)
   WHEN MATCHED THEN UPDATE SET D.UPD_USER='XQ',D.UPD_DATE=to_char(SYSDATE,'YYYYMMDD'),D.UPD_TIME=to_char(SYSDATE,'HHMMSS'),D.WARN_REA=S.WARN_REA
   WHEN NOT MATCHED THEN INSERT (D.STK_CD,D.START_DATE,D.END_DATE,D.WARN_TYPE,D.UPD_USER,D.UPD_DATE,D.UPD_TIME,D.WARN_REA) VALUES (S.STK_CD, S.START_DATE,S.END_DATE,S.WARN_TYPE,'XQ',to_char(SYSDATE,'YYYYMMDD'),to_char(SYSDATE,'HHMMSS'),S.WARN_REA);
commit;
MERGE INTO SYSTEX.FSK984 D
   USING (SELECT STK_CD,to_CHAR(tDate,'YYYYMMDD') as START_DATE,to_CHAR(tDate,'YYYYMMDD') as END_DATE,TYPE as WARN_TYPE,EVENT as WARN_REA from XQ.TW003 where TYPE='2') S
   ON (D.STK_CD = S.STK_CD AND D.START_DATE=S.START_DATE)
   WHEN MATCHED THEN UPDATE SET D.UPD_USER='XQ',D.UPD_DATE=to_char(SYSDATE,'YYYYMMDD'),D.UPD_TIME=to_char(SYSDATE,'HHMMSS'),D.WARN_REA=S.WARN_REA
   WHEN NOT MATCHED THEN INSERT (D.STK_CD,D.START_DATE,D.END_DATE,D.WARN_TYPE,D.UPD_USER,D.UPD_DATE,D.UPD_TIME,D.WARN_REA) VALUES (S.STK_CD, S.START_DATE,S.END_DATE,S.WARN_TYPE,'XQ',to_char(SYSDATE,'YYYYMMDD'),to_char(SYSDATE,'HHMMSS'),S.WARN_REA);
commit;
exit;
