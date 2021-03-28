/*
  Script:      300_IFLOWatCAS_MK1050_PKG_RO_VAL.sql
  Author:      Levi Tamiozzo
  Date:        2020-11-17
  Purpose:     Validates pkg creation.
*/

SET TERMOUT ON
SET ECHO OFF
SET LINESIZE 80
SET SERVEROUTPUT ON SIZE 10000
WHENEVER SQLERROR EXIT ROLLBACK
column filename NEW_VAL filename1 

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME')  filename
  FROM dual;

spo 300_IFLOWatCAS_MK1050_PKG_RO_VAL_&filename1..log;

ALTER SESSION SET CURRENT_SCHEMA = IFLOW;

SELECT 'current user is ' || USER || ' at ' FROM dual;

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

/* SQL Statement Start */

DECLARE

  V_COUNT        NUMBER;
  V_OWNER		 VARCHAR2(20) := 'IFLOW';
  V_STATUS_VALID VARCHAR2(20) := 'VALID';
  V_PACKAGE_NAME VARCHAR2(50) := 'PKG_T_RT_P';
  
BEGIN

  -- RO Validation for PKG_T_RT_P.
  SELECT COUNT(1)
    INTO V_COUNT
    FROM DBA_OBJECTS
  WHERE OBJECT_NAME = V_PACKAGE_NAME
     AND OWNER = V_OWNER
     AND STATUS = V_STATUS_VALID;
  
  IF V_COUNT = 2 THEN
    DBMS_OUTPUT.PUT_LINE(V_PACKAGE_NAME || ' package exists and is valid. VALIDATION SUCCESFUL.');
  ELSE
    RAISE_APPLICATION_ERROR(-20002, V_PACKAGE_NAME || ' does not exists or invalid! VALIDATION FAILED.');
  END IF;
         
END;
/

/* SQL Statement End */

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

sho ERRORS
spo OFF
