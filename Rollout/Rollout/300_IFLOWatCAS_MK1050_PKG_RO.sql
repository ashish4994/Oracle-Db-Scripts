/*
  Script:      300_IFLOWatCAS_MK1050_PKG_RO.sql
  Schema:      IFLOW
  Author:      Levi Tamiozzo
  Date:        2021-01-12
  Purpose:     Run package deployment.    
*/

SET TERMOUT ON
SET ECHO Off
SET DEFINE ON
SET LINESIZE 80
SET SERVEROUTPUT ON SIZE 10000
WHENEVER SQLERROR EXIT ROLLBACK
column filename new_val filename1 

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME') filename FROM dual; 
spo 300_IFLOWatCAS_MK1050_PKG_RO_&filename1..log;

ALTER SESSION SET CURRENT_SCHEMA = IFLOW;
ALTER SESSION SET EDITION = ORA$BASE;

SELECT 'current user is ' || USER || ' at ' FROM dual;
SELECT SYS_CONTEXT('USERENV','INSTANCE_NAME') FROM dual;
SELECT SYS_CONTEXT('USERENV', 'SERVER_HOST') FROM dual;
SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

@Pkg_T_Rt_P.sql;
sho ERRORS;

@Pkg_T_Rt_R.sql;
sho ERRORS;

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

sho ERRORS 
spo OFF
