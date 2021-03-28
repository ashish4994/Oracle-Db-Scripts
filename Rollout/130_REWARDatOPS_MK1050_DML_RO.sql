/*
  Script:      130_REWARDatOPS_MK1050_DML_RO.sql
  Author:      Favio Massarini
  Date:        2021-02-05
  Project:     MK-1050
  Purpose:     Insert look up values for Six Flags offer types templates and six flags item.
*/

SET TERMOUT ON
SET ECHO OFF
SET LINESIZE 80
SET SERVEROUTPUT ON SIZE 1040040
WHENEVER SQLERROR EXIT ROLLBACK
column filename new_val filename1 

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME')  filename
  FROM dual;
  
spo 130_REWARDatOPS_MK1050_DML_RO_&filename1..log; 

ALTER SESSION SET CURRENT_SCHEMA = REWARD;
ALTER SESSION SET EDITION = ORA$BASE;
 
SELECT 'current user is ' || USER || ' at ' FROM dual;

SELECT SYS_CONTEXT('USERENV','INSTANCE_NAME') FROM dual;
 
SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

@INSERT_INTO_T_LU_REWARDS_OFFER_TYPE.sql;
sho ERRORS 

@INSERT_INTO_T_REWARDS_SIX_FLAGS_ITEM.sql;
sho ERRORS

SELECT TO_CHAR(SYSDATE, 'DD-Mon-YYYY HH24:MI:SS') date_
  FROM dual;

sho ERRORS 
spo OFF
