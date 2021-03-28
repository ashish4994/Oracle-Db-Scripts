/*
  Script:      350_NOTIFYatCAS_MK1050_PKG_RO.sql
  Schema:      NOTIFY
  Author:      Favio Massarini
  Date:        2021-02-09
  Purpose:     Run package deployment.    
*/

SET TERMOUT ON
SET ECHO Off
-- SET DEFINE ON
SET LINESIZE 80
SET SERVEROUTPUT ON SIZE 10000
WHENEVER SQLERROR EXIT ROLLBACK
column filename new_val filename1 

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME') filename FROM dual; 
spo 350_NOTIFYatCAS_MK1050_PKG_RO_&filename1..log;

ALTER SESSION SET CURRENT_SCHEMA = NOTIFY;
ALTER SESSION SET EDITION = ORA$BASE;

SELECT 'current user is ' || USER || ' at ' FROM dual;
SELECT SYS_CONTEXT('USERENV','INSTANCE_NAME') FROM dual;
SELECT SYS_CONTEXT('USERENV', 'SERVER_HOST') FROM dual;
SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

@PKG_NOTIFY_SIXFLAGS_P.sql;
sho ERRORS;

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

sho ERRORS 
spo OFF
