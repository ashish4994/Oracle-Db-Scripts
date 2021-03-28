/*
  Script:      150_REWARDatOPS_MK1050_PKG_RB.sql
  Author:      Levi Tamiozzo
  Date:        01/26/2021
*/

SET TERMOUT ON
SET ECHO OFF
SET LINESIZE 80
SET SERVEROUTPUT ON SIZE 1040040
WHENEVER SQLERROR EXIT ROLLBACK
column filename new_val filename1 

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME')  filename
  FROM dual;
  
spo 150_REWARDatOPS_MK1050_PKG_RB_&filename1..log; 

ALTER SESSION SET CURRENT_SCHEMA = REWARD;
ALTER SESSION SET EDITION = ORA$BASE;
 
SELECT 'current user is ' || USER || ' at ' FROM dual;

SELECT SYS_CONTEXT('USERENV','INSTANCE_NAME') FROM dual;
 
SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

/* SQL Statements Start */

DECLARE

  V_COUNT NUMBER;
  
BEGIN  

  -- Drop Package PKG_MS_REWARDS_SIX_FLAGS_ITEM_P
  SELECT COUNT(1)
    INTO V_COUNT 
    FROM DBA_OBJECTS T
   WHERE T.OBJECT_TYPE = 'PACKAGE'
     AND T.OBJECT_NAME = 'PKG_MS_REWARDS_SIX_FLAGS_ITEM_P';
  
  IF (V_COUNT > 0) THEN 
     EXECUTE IMMEDIATE 'DROP PACKAGE PKG_MS_REWARDS_SIX_FLAGS_ITEM_P';
  END IF;
  
  
  -- Drop Package PKG_MS_REWARDS_OFFER_TYPE_P
  SELECT COUNT(1)
    INTO V_COUNT 
    FROM DBA_OBJECTS T
   WHERE T.OBJECT_TYPE = 'PACKAGE'
     AND T.OBJECT_NAME = 'PKG_MS_REWARDS_OFFER_TYPE_P';
  
  IF (V_COUNT > 0) THEN 
     EXECUTE IMMEDIATE 'DROP PACKAGE PKG_MS_REWARDS_OFFER_TYPE_P';
  END IF;
  
END;
/

/* SQL Statements Start End */

SELECT TO_CHAR(SYSDATE, 'DD-Mon-YYYY HH24:MI:SS') date_
  FROM dual;

sho ERRORS 
spo OFF