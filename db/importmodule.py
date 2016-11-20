'''
Created on 2013/3/16

@author: yhuang
'''
import sys
import os
import csv
from config.manager import configmanager
from time import strftime
import codecs

def getstoragepath():
        try:
            STORAGE_DIR = os.path.abspath(os.path.dirname(__file__))
            return STORAGE_DIR
        except:
            return None
        
def stocksymbol(conn):
    hk001file=configmanager.getvalue('HK001')
    if hk001file is None:
            print ('Please set HK001 file')
            return
    try:
        PROJECT_DIR = os.path.abspath(os.path.dirname(__file__))
        RAW_FILE = os.path.join(PROJECT_DIR, hk001file)

        with open(RAW_FILE, 'rb') as f:
            reader = csv.reader(f)
            cursor = conn.cursor()
            conn.set_character_set('utf8')
            cursor.execute('SET NAMES utf8;')
            cursor.execute('SET CHARACTER SET utf8;')
            cursor.execute('SET character_set_connection=utf8;')
            for line in reader:
                try:
#                    tline=line.split(",")
#                    Market = tline[1].decode('cp950').strip()
#                    Symbol = tline[0].decode('cp950').strip()
#                    Name = tline[2].decode('cp950').strip()
#                    SName = tline[3].decode('cp950').strip()
#                    CUR = tline[4].decode('cp950').strip()
#                    Unit = tline[5].decode('cp950').strip()
#                    Reference = tline[6].decode('cp950').strip()
#                    EName = tline[7].decode('cp950').strip()
#                    SEName = tline[8].decode('cp950').strip()
#                    Uplimit = tline[9].decode('cp950').strip()
#                    Downlimit = tline[10].decode('cp950').strip()
                    Market = line[1].decode('cp950')
                    Symbol = line[0].decode('cp950')
                    Name = line[2].decode('cp950').rstrip('\n')
                    SName = line[3].decode('cp950').rstrip('\n')
                    CUR = line[4].decode('cp950')
                    Unit = line[5].decode('cp950')
                    Reference = line[6].decode('cp950')
                    EName = line[7].decode('cp950').rstrip('\n')
                    SEName = line[8].decode('cp950').rstrip('\n')
                    Uplimit = line[9].decode('cp950')
                    Downlimit = line[10].decode('cp950')
                    UPD_Date = strftime("%Y%m%d")
                    UPD_Time = strftime("%H%M%S")
                    #param={'Symbol':Symbol,'Market':'HK','Name':Name,'SName':SName,'CUR':CUR,'Unit':Unit,'EName':Name,'SEName':SName,'UPD_Date':UPD_Date,'UPD_Time':UPD_Time}  
                    cursor.execute(u'call sp_HK001_INSERT_byPK(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)',(Symbol,Market,Name,SName,CUR,Unit,EName,SEName,UPD_Time,UPD_Time)); 
                    conn.commit()
                    #print "Insert:"+tick_symbol+" Date:"+ tick_date
                except Exception, e:
                    print '(stocksymbol)Insert Error:'+Symbol+' ->'+Name+' : '+unicode(e)+unicode(sys.exc_info()[0])      
                        
            f.close()
    except:
        print "Unexpected error:", sys.exc_info()[0]
        
def stockclose(conn):
    
    hk002file=configmanager.getvalue('HK002')
    if hk002file is None:
            print ('Please set HK002 file')
            return
    try:
        PROJECT_DIR = os.path.abspath(os.path.dirname(__file__))
        RAW_FILE = os.path.join(PROJECT_DIR, hk002file)

        f = open(RAW_FILE)
        cursor = conn.cursor()
        conn.set_character_set('utf8')
        cursor.execute('SET NAMES utf8;')
        cursor.execute('SET CHARACTER SET utf8;')
        cursor.execute('SET character_set_connection=utf8;')
        for line in f:
            try:
                tline=line.split(",")
                tick_date = tline[0].encode('utf-8')[0:10]
                tick_symbol = tline[1].encode('utf-8')
                tick_open = tline[2].encode('utf-8')
                tick_high = tline[3].encode('utf-8')
                tick_low = tline[4].encode('utf-8')
                tick_close = tline[5].encode('utf-8')
                tick_volume= tline[6].encode('utf-8')
                #param={'Symbol':tick_symbol,'Market':'HK','tDate':tick_date,'Open':tick_open,'Open':tick_high,'Open':tick_low,'Open':tick_close,'Open':tick_volume}  
                cursor.execute(u'call sp_HK002_INSERT_byPK(%s,%s,%s,%s,%s,%s,%s,%s)',(tick_symbol,'HK',tick_date,tick_open,tick_high,tick_low,tick_close,tick_volume)); 
                conn.commit()
                #print "Insert:"+tick_symbol+" Date:"+ tick_date
            except Exception, e:
                print '(stockclose)Insert Error:'+tick_symbol+' ->'+unicode(e)+unicode(sys.exc_info()[0])      
                    
        f.close()
    except:
        print "Unexpected error:", sys.exc_info()[0]
        
       
def stockevent(conn):
    hk003file=configmanager.getvalue('HK003')
    if hk003file is None:
            print ('Please set HK003 file')
            return
    try:
        PROJECT_DIR = os.path.abspath(os.path.dirname(__file__))
        RAW_FILE = os.path.join(PROJECT_DIR, hk003file)

        with open(RAW_FILE, 'rb') as f:
            reader = csv.reader(f)
            cursor = conn.cursor()
            conn.set_character_set('utf8')
            cursor.execute('SET NAMES utf8;')
            cursor.execute('SET CHARACTER SET utf8;')
            cursor.execute('SET character_set_connection=utf8;')
            for line in reader:
                try:
                    Market = line[0].decode('cp950')
                    Symbol = line[1].decode('cp950')
                    tdate = line[2].decode('cp950')
                    Event = line[3].decode('cp950').rstrip('\n')
                    cursor.execute(u'call sp_HK003_INSERT_byPK(%s,%s,%s,%s)',(Symbol,Market,tdate,Event)); 
                    conn.commit()
                    #print "Insert:"+tick_symbol+" Date:"+ tick_date
                except Exception, e:
                    print '(stockevent)Insert Error:'+Symbol+' ->'+Event+' : '+unicode(e)+unicode(sys.exc_info()[0])      
                        
            f.close()
    except:
        print "Unexpected error:", sys.exc_info()[0]
        
def stockfin(conn):
    fin001file=configmanager.getvalue('fin001')
    if fin001file is None:
            print ('Please set fin001 file')
            return
    try:
        PROJECT_DIR = os.path.abspath(os.path.dirname(__file__))
        RAW_FILE = os.path.join(PROJECT_DIR, fin001file)

        with open(RAW_FILE, 'rb') as f:
        #with codecs.open(RAW_FILE, 'rU', 'utf-16') as f:
            reader = csv.reader(f)
            cursor = conn.cursor()
            conn.set_character_set('utf8')
            cursor.execute('SET NAMES utf8;')
            cursor.execute('SET CHARACTER SET utf8;')
            cursor.execute('SET character_set_connection=utf8;')
            for line in reader:
                try:
                    Symbol = line[0].decode('cp950')
                    FinDate = line[1].decode('cp950')[0:10] or None
                    YearDate = line[2].decode('cp950')[0:10] or None
                    AnnDate = line[3].decode('cp950')[0:10] or None
                    F1 = line[4].decode('cp950') or None
                    F2 = line[5].decode('cp950') or None
                    F3 = line[6].decode('cp950') or None
                    F4 = line[7].decode('cp950') or None
                    F5 = line[8].decode('cp950') or None
                    F6 = line[9].decode('cp950') or None
                    F7 = line[10].decode('cp950') or None
                    F8 = line[11].decode('cp950') or None
                    F9 = line[12].decode('cp950') or None
                    F10= line[13].decode('cp950') or None
                    F11 = line[14].decode('cp950') or None
                    F12 = line[15].decode('cp950') or None
                    F13 = line[16].decode('cp950') or None
                    F14 = line[17].decode('cp950') or None
                    F15 = line[18].decode('cp950') or None
                    F16 = line[19].decode('cp950') or None
                    F17 = line[20].decode('cp950') or None
                    F18 = line[21].decode('cp950') or None
                    F19 = line[22].decode('cp950') or None
                    F20 = line[23].decode('cp950') or None
                    F21 = line[24].decode('cp950') or None
                    F22 = line[25].decode('cp950') or None
                    F23 = line[26].decode('cp950') or None
                    F24 = line[27].decode('cp950') or None
                    F25 = line[28].decode('cp950') or None
                    F26 = line[29].decode('cp950') or None
                    F27 = line[30].decode('cp950') or None
                    F28 = line[31].decode('cp950') or None
                    F29 = line[32].decode('cp950') or None
                    F30= line[33].decode('cp950') or None
                    cursor.execute(u'call sp_fin001_INSERT_byPK(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)',(Symbol,FinDate,YearDate,AnnDate,
         F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,
        F11,F12,F13,F14,F15,F16,F17,F18,F19,F20,
        F21,F22,F23,F24,F25,F26,F27,F28,F29,F30)); 
                    conn.commit()
                    #print "Insert:"+tick_symbol+" Date:"+ tick_date
                except Exception, e:
                    print '(stockFin)Insert Error:'+Symbol+' ->'+FinDate+' : '+unicode(e)+unicode(sys.exc_info()[0])      
                        
            f.close()
    except:
        print "Unexpected error:", sys.exc_info()[0]