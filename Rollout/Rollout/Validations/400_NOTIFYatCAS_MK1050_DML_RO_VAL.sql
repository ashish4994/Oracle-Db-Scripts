/*
  Script:      400_NOTIFYatCAS_MK1050_DML_RO_VAL.sql
  Author:      Levi Tamiozzo
  Date:        2021-02-05
*/

SET TERMOUT ON
SET ECHO OFF
SET LINESIZE 80
SET SERVEROUTPUT ON SIZE 1040040
WHENEVER SQLERROR EXIT ROLLBACK
column filename new_val filename1 

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME')  filename
  FROM dual;
  
spo 400_NOTIFYatCAS_MK1050_DML_RO_VAL_VAL_&filename1..log; 

ALTER SESSION SET CURRENT_SCHEMA = NOTIFY;
 
SELECT 'current user is ' || USER || ' at ' FROM dual;

SELECT SYS_CONTEXT('USERENV','INSTANCE_NAME') FROM dual;
 
SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

@VALIDATE_INSERT_EMAIL_REDEM_INTO_T_LU_NOTIFICATION_VARIABLE.sql;
sho ERRORS 

@VALIDATE_INSERT_EMAIL_REDEM_INTO_T_LU_NOTIFICATION_TMPL_TYPE.sql;
sho ERRORS 

@VALIDATE_INSERT_EMAIL_REDEM_INTO_T_LU_NOTIFICATION_TEMPLATE.sql;
sho ERRORS 

@VALIDATE_INSERT_EMAIL_REDEM_INTO_T_LU_NOTIFICATION_TMPL_VAR.sql;
sho ERRORS 

@VALIDATE_UPD_T_LU_NOTIFICATION_TEMPLATE.sql;
sho ERRORS

SELECT TO_CHAR(SYSDATE, 'DD-Mon-YYYY HH24:MI:SS') date_
  FROM dual;

sho ERRORS 
spo OFF
