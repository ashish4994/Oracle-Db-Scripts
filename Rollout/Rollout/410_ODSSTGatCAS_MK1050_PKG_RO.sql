/*
  Script:      410_ODSSTGatCAS_MK1050_PKG_RO.sql
  Author:      Carlos Mendoza
  Date:        04/03/2020
  Purpose:     Create pkg PKG_FDR_REWARDS_STAGING
*****************************************************************************/


SET TERMOUT ON
SET ECHO OFF
SET LINESIZE 80
SET SERVEROUTPUT ON SIZE 10000
WHENEVER SQLERROR EXIT ROLLBACK
column filename new_val filename1 

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME')  filename
  FROM dual;
  
spo 410_ODSSTGatCAS_MK1050_PKG_RO_&filename1..log;

ALTER SESSION SET CURRENT_SCHEMA = ODS_STG;
ALTER SESSION SET EDITION = ORA$BASE;
 
SELECT 'current user is ' || USER || ' at ' FROM dual;

SELECT SYS_CONTEXT('USERENV','INSTANCE_NAME') FROM dual;
 
SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

--Package Creation

@PKG_FDR_REWARDS_STAGING_P.sql;
SHOW ERRORS;

@PKG_FDR_REWARDS_STAGING_R.sql;
SHOW ERRORS;

SELECT TO_CHAR(SYSDATE, 'DD-Mon-YYYY HH24:MI:SS') date_
  FROM dual;

sho ERRORS 
spo OFF