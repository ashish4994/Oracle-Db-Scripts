/*
  Script:      420_REPORTERatCAS_MK1050_DDL_RB_VAL.sql
  Author:      Favio Massarini
  Date:        03/08/2021
  Purpose:     Validates view creation.
*/

SET TERMOUT ON
SET ECHO OFF
SET LINESIZE 80

SET SERVEROUTPUT ON SIZE 10000
WHENEVER SQLERROR EXIT ROLLBACK
column filename NEW_VAL filename1 

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME')  filename
  FROM dual;

spo 420_REPORTERatCAS_MK1050_DDL_RB_VAL_&filename1..log;

ALTER SESSION SET CURRENT_SCHEMA = REPORTER;
ALTER SESSION SET EDITION = ORA$BASE;

SELECT 'current user is ' || USER || ' at ' FROM dual;

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

/* *** */

DECLARE
  v_count             int;
  
BEGIN

  -- RO Validation for view creation
  SELECT COUNT(1)
    INTO v_count
    FROM all_views
   WHERE view_name = 'V_REWARDS_SIX_FLAGS'
     AND owner = 'REPORTER';

  IF v_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('V_REWARDS_SIX_FLAGS view is deleted from the database');
  ELSE
    raise_application_error(-20002,
                            'V_REWARDS_SIX_FLAGS IS in the database! Validation FAILED');
  END IF;
   
END;
/

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

sho ERRORS
spo OFF
