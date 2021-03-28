/*
  Script:      010_DBAatCAS_MK1050_SYN_RO.sql
  Author:      Levi Tamiozzo
  Date:        2020-11-17
  Purpose:     grant select on account tables.
*/

SET TERMOUT ON
SET ECHO OFF
SET LINESIZE 80
spool off
SET SERVEROUTPUT ON SIZE 10000
WHENEVER SQLERROR EXIT ROLLBACK
column filename NEW_VAL filename1 

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME')  filename
  FROM dual;

spo 010_DBAatCAS_MK1050_SYN_RO_&filename1..log;

ALTER SESSION SET EDITION = ORA$BASE;

SELECT 'current user is ' || USER || ' at ' FROM dual;
 
SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

/* SQL Statement Start */

GRANT SELECT ON ACCOUNT.T_LU_PRODUCT_GROUP_PROGRAM TO IFLOW;
GRANT SELECT ON ACCOUNT.T_LU_PRODUCT_GROUP TO IFLOW;

/* SQL Statement End */

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

sho ERRORS
spo OFF
