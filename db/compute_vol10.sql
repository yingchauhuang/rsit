declare
 VOL10 varchar2(10);
 VCurrent varchar2(10);
begin
select DATA_DATE into VOL10 from (select ROWNUM NUM,DATA_DATE from (select DATA_DATE  from SW.FSK004  O  where O.STKLG_TYPE='00000000' and  DEAL_CTR='H1' order  by DATA_DATE DESC)) where NUM=15;
select max(DATA_DATE) into VCurrent from SW.FSK004  O  where O.STKLG_TYPE='00000000';
Update SW.FSK004 D
Set TENTH_AVG_QTY=(select sum(O.TRA_QTY)/15 from SW.FSK004 O  where TO_DATE(O.DATA_DATE,'YYYYMMDD') >= TO_DATE(VOL10,'YYYYMMDD') and O.STKLG_TYPE=D.STKLG_TYPE)
WHERE D.DATA_DATE=VCurrent and DEAL_CTR='H1';
end;
/
commit;
exit;
