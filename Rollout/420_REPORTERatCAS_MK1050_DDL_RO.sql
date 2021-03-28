/*
  Script:      420_REPORTERatCAS_MK1050_DDL_RO.sql
  Author:      Favio Massarini
  Date:        03/08/2021
  Purpose:     Create view V_REWARD_SIX_FLAGS
*****************************************************************************/


SET TERMOUT ON
SET ECHO OFF
SET LINESIZE 80
SET SERVEROUTPUT ON SIZE 10000
WHENEVER SQLERROR EXIT ROLLBACK
column filename new_val filename1 

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME')  filename
  FROM dual;
  
spo 420_REPORTERatCAS_MK1050_DDL_RO_&filename1..log;

ALTER SESSION SET CURRENT_SCHEMA = REPORTER;
ALTER SESSION SET EDITION = ORA$BASE;
 
SELECT 'current user is ' || USER || ' at ' FROM dual;

SELECT SYS_CONTEXT('USERENV','INSTANCE_NAME') FROM dual;
 
SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

--View Creation

@V_REWARDS_SIX_FLAGS.sql;
SHOW ERRORS;

SELECT TO_CHAR(SYSDATE, 'DD-Mon-YYYY HH24:MI:SS') date_
  FROM dual;

sho ERRORS 
spo OFF