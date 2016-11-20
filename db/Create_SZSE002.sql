                                               
  CREATE TABLE "XQ"."SZSE002"                                                     
   (	"SYMBOL" VARCHAR2(16) NOT NULL ENABLE,                                     
	"MARKET" VARCHAR2(2),                                                          
	"TDATE" DATE,                                                                  
	"TOPEN" NUMBER(28,4),                                                          
	"THIGH" NUMBER(28,4),                                                          
	"TLOW" NUMBER(28,4),                                                           
	"TCLOSE" NUMBER(28,4),                                                         
	"TVOLUME" NUMBER(28,0),
	"TAMOUNT" NUMBER(28,0),	
	"TLASTBUY" NUMBER(28,0),  
	"TLASTSELL" NUMBER(28,0),  
	"TMARK" VARCHAR2(3),
	"STK_CD" VARCHAR2(12)                                                          
   ) SEGMENT CREATION IMMEDIATE                                                 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255                                 
 NOCOMPRESS LOGGING                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "USERS";                                                          

