'''
Created on 2013/3/16

@author: yhuang
'''
import sys
import MySQLdb
#import cx_Oracle  
from config.manager import configmanager

def getconnection():
    try:
        dbtype=configmanager.getvalue('dbtype')
        if dbtype=='Oracle':
            oracleodbc=configmanager.getvalue('OracleODBC')
            try:
                conn = cx_Oracle.connect(oracleodbc)  
                return conn
            except Exception, e:
                        print '(getconnection)Initial Error:'+unicode(e)+unicode(sys.exc_info()[0])  
        else:
            try:
                conn = MySQLdb.connect(host=configmanager.getvalue('host'), user=configmanager.getvalue('user'), passwd=configmanager.getvalue('passwd'), db=configmanager.getvalue('db'))  
                return conn
            except Exception, e:
                        print '(getconnection)Initial Error:'+unicode(e)+unicode(sys.exc_info()[0])  
    except:
        print "Unexpected error:", sys.exc_info()[0]