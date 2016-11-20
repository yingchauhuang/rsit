CREATE TABLE "XQ"."SZSE001"                                                     
   (	"SYMBOL" VARCHAR2(16) NOT NULL ENABLE,                                     
	"MARKET" VARCHAR2(4),                                                          
	"NAME" VARCHAR2(50),                                                           
	"SNAME" VARCHAR2(80),                                                          
	"CUR" VARCHAR2(5),                                                             
	"UNIT" NUMBER(*,0),   
	"PRICE" NUMBER(28,4),
	"ENAME" VARCHAR2(80),                                                          
	"SENAME" VARCHAR2(160),                                                        
	"UPD_DATE" VARCHAR2(8),                                                        
	"UPD_TIME" VARCHAR2(6),                                                        
	"STK_CD" VARCHAR2(12),                                                         
	"STK_CHNM" VARCHAR2(20),                                                       
	"STK_ENGNM" VARCHAR2(50)                                                       
   ) SEGMENT CREATION IMMEDIATE                                                 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                 
 NOCOMPRESS LOGGING                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "USERS";                                                      
                                                                                


