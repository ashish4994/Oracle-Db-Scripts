/*
  Script:      350_NOTIFYatCAS_MK1050_PKG_RB_VAL.sql
  Author:      FMASSARINI
  Date:        02/24/2021
  Purpose:     Validates PKGs
*/

SET TERMOUT ON
SET ECHO OFF
SET LINESIZE 80
--SET ESCAPE ^
--SET DEFINE OFF
SET SERVEROUTPUT ON SIZE 10000
WHENEVER SQLERROR EXIT ROLLBACK
column filename NEW_VAL filename1 

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME')  filename
  FROM dual;

spo 110_350_NOTIFYatCAS_MK1050_PKG_RB_VAL_&filename1..log;

ALTER SESSION SET CURRENT_SCHEMA = NOTIFY;

SELECT 'current user is ' || USER || ' at ' FROM dual;

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

/* *** */

DECLARE
  v_count             int;
  
BEGIN

  -- RB Validation for package creation
  SELECT COUNT(1)
    INTO v_count
    FROM dba_objects
  WHERE object_name = 'PKG_NOTIFY_SIXFLAGS_P'
     AND owner = 'NOTIFY';
  
  IF v_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('PKG_NOTIFY_SIXFLAGS_P package was removed from the database');
  ELSE
    raise_application_error(-20002,
                            'PKG_NOTIFY_SIXFLAGS_P was NOT removed from the database! Validation FAILED');
  END IF;
   
END;
/

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

sho ERRORS
spo OFF
