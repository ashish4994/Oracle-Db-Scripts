/*
  Script:      410_ODSSTGatCAS_MK1050_PKG_RO_VAL.sql
  Author:      Carlos Mendoza
  Date:        04/03/2020
  Purpose:     Validates pkg creation for PKG_FDR_REWARDS_STAGING.
*/

SET TERMOUT ON
SET ECHO OFF
SET LINESIZE 80

SET SERVEROUTPUT ON SIZE 10000
WHENEVER SQLERROR EXIT ROLLBACK
column filename NEW_VAL filename1 

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME')  filename
  FROM dual;

spo 410_ODSSTGatCAS_MK1050_PKG_RO_VAL_&filename1..log;

ALTER SESSION SET CURRENT_SCHEMA = ODS_STG;
ALTER SESSION SET EDITION = ORA$BASE;

SELECT 'current user is ' || USER || ' at ' FROM dual;

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

/* *** */

DECLARE
  v_count             int;
  
BEGIN

  -- RO Validation for package creation
  SELECT COUNT(1)
    INTO v_count
    FROM dba_objects
  WHERE object_name = 'PKG_FDR_REWARDS_STAGING_P'
     AND owner = 'ODS_STG'
     AND status = 'VALID';
  
  IF v_count = 2 THEN
    DBMS_OUTPUT.PUT_LINE('PKG_FDR_REWARDS_STAGING_P package is created in the database');
  ELSE
    raise_application_error(-20002,
                            'PKG_FDR_REWARDS_STAGING_P IS NOT in the database or invalid! Validation FAILED');
  END IF;
  
  
   
END;
/

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

sho ERRORS
spo OFF
