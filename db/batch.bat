set Oracel_Host=TFUND.rsit.com.tw
set Oracel_User=xq
set Oracel_PWD=xq1234
set WorkFolder=C:\XQ\rsit\db\
cd %WorkFolder%
winscp.com /script=download_script.txt
%WorkFolder%tools\unrar e -y %WorkFolder%FinData.rar
%WorkFolder%tools\unrar e -y %WorkFolder%Symbol.rar
%WorkFolder%tools\unrar e -y %WorkFolder%HisData_HK.rar

sqlplus -s -l %Oracel_User%@%Oracel_Host%/%Oracel_PWD% "@cleandb.sql" 
sqlldr %Oracel_User%@%Oracel_Host%/%Oracel_PWD% control=HK_Capital.ctrl
sqlldr %Oracel_User%@%Oracel_Host%/%Oracel_PWD% control=HK003.ctrl
sqlldr %Oracel_User%@%Oracel_Host%/%Oracel_PWD% control=HK002.ctrl
sqlldr %Oracel_User%@%Oracel_Host%/%Oracel_PWD% control=HK001.ctrl
sqlldr %Oracel_User%@%Oracel_Host%/%Oracel_PWD% control=FIN001.ctrl
sqlplus -s -l %Oracel_User%@%Oracel_Host%/%Oracel_PWD% "@update.sql" 
sqlplus -s -l %Oracel_User%@%Oracel_Host%/%Oracel_PWD% "@Sync.sql" 
sqlplus -s -l %Oracel_User%@%Oracel_Host%/%Oracel_PWD% "@Update_Fin.sql" 
sqlplus -s -l %Oracel_User%@%Oracel_Host%/%Oracel_PWD% "@compute_vol10.sql" 