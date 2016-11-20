--CN Only Update Data which the data has been in FSK001 already
--Not insert symbol like US


-- Update Data from SSE01 ..current not use
-- Update SW.fsk001
-- set (STK_CHNM,STK_ENGNM)=(select SNAME,STK_ENGNM from XQ.SSE001 WHERE SW.fsk001.STK_CD=XQ.SSE001.STK_CD)
-- where SW.fsk001.STK_CD in (select STK_CD from XQ.SSE001);
-- commit;

-- Update Data from SZSE01 ..current not use
-- Update SW.fsk001
-- set (STK_CHNM,STK_ENGNM)=(select SNAME,STK_ENGNM from XQ.SSE001 WHERE SW.fsk001.STK_CD=XQ.SZSE001.STK_CD)
-- where SW.fsk001.STK_CD in (select STK_CD from XQ.SZSE001);
-- commit;

Update SW.fsk001
set (STK_CHNM)=(select STK_CHNM from XQ.SSE001 WHERE SW.fsk001.STK_CD=XQ.SSE001.STK_CD)
where SW.fsk001.DEAL_CTR='SN' and SW.fsk001.STK_CD in (select STK_CD from XQ.SSE001);
commit;

Update SW.fsk001
set (STK_CHNM)=(select STK_CHNM from XQ.SZSE001 WHERE SW.fsk001.STK_CD=XQ.SZSE001.STK_CD)
where SW.fsk001.DEAL_CTR='SN' and SW.fsk001.STK_CD in (select STK_CD from XQ.SZSE001);
commit;

Update SW.fsk001
set OS_STK=(select cast(Capital as number(12)) from XQ.CN_Capital WHERE SW.fsk001.STK_CD=XQ.CN_Capital.STK_CD AND Capital is not null)
where SW.fsk001.DEAL_CTR='SN' and SW.fsk001.STK_CD in (select STK_CD from XQ.CN_Capital  where Capital is not null);
commit;

Update SW.fsk001
set OS_STK=(select cast(NVL(OS_STK,0) as number(12))*1000 from XQ.CN_Capital WHERE SW.fsk001.STK_CD=XQ.CN_Capital.STK_CD AND Capital is not null)
where SW.fsk001.DEAL_CTR='SN' and SW.fsk001.STK_CD in (select STK_CD from XQ.CN_Capital  where Capital is not null);
commit;



commit;
exit;
