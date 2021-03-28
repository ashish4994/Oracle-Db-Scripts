/*
  Script:      420_REPORTERatCAS_MK1050_DDL_RB.sql
  Author:      Favio Massarini
  Date:        03/08/2020
  Purpose:     Drop view V_REWARD_SIX_FLAGS
*****************************************************************************/


SET TERMOUT ON
SET ECHO OFF
SET LINESIZE 80
SET SERVEROUTPUT ON SIZE 10000
WHENEVER SQLERROR EXIT ROLLBACK
column filename new_val filename1 

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME')  filename
  FROM dual;
  
spo 420_REPORTERatCAS_MK1050_DDL_RB_&filename1..log;

ALTER SESSION SET CURRENT_SCHEMA = REPORTER;
ALTER SESSION SET EDITION = ORA$BASE;
 
SELECT 'current user is ' || USER || ' at ' FROM dual;

SELECT SYS_CONTEXT('USERENV','INSTANCE_NAME') FROM dual;
 
SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

--View Deletion

DECLARE
  v_count             int;
  
BEGIN

  -- RO Validation for view creation
  SELECT COUNT(1)
    INTO v_count
    FROM all_views
   WHERE view_name = 'V_REWARDS_SIX_FLAGS'
     AND owner = 'REPORTER';

  IF v_count = 1 THEN
    EXECUTE IMMEDIATE 'DROP VIEW V_REWARDS_SIX_FLAGS';
  END IF;
   
END;
/

SHOW ERRORS;

SELECT TO_CHAR(SYSDATE, 'DD-Mon-YYYY HH24:MI:SS') date_
  FROM dual;

sho ERRORS 
spo OFF