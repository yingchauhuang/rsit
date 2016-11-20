SQL> 
SQL> select dbms_metadata.get_ddl('TABLE','HK003','XQ') from dual;

                                                                                
  CREATE TABLE "XQ"."HK003"                                                     
   (	"SYMBOL" VARCHAR2(16) NOT NULL ENABLE,                                     
	"MARKET" VARCHAR2(2),                                                          
	"TDATE" DATE,                                                                  
	"EVENT" VARCHAR2(80),                                                          
	"STK_CD" VARCHAR2(12),                                                         
	"TYPE" VARCHAR2(8)                                                             
   ) SEGMENT CREATION IMMEDIATE                                                 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                 
 NOCOMPRESS LOGGING                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "USERS"                                                            
                                                                                

SQL> 
SQL> spool ofquit
