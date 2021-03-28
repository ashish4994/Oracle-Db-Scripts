/*
  Script:      200_COLLatCAS_MK1050_PKG_RO.sql
  Schema:      COLL
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
spo 200_COLLatCAS_MK1050_PKG_RO_&filename1..log;

ALTER SESSION SET CURRENT_SCHEMA = COLL;
ALTER SESSION SET EDITION = ORA$BASE;

SELECT 'current user is ' || USER || ' at ' FROM dual;
SELECT SYS_CONTEXT('USERENV','INSTANCE_NAME') FROM dual;
SELECT SYS_CONTEXT('USERENV', 'SERVER_HOST') FROM dual;
SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

@pkg_coll_account_info_p.sql;
sho ERRORS;

@pkg_coll_account_info_r.sql;
sho ERRORS;

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

sho ERRORS 
spo OFF
