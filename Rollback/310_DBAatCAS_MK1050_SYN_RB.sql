/*
  Script:      310_DBatCAS_MK1050_SYN_RB.sql
  Author:      Favio Massarini
  Date:        02/09/2021
  Purpose:     rollback tables synonym.
*/

SET TERMOUT ON
SET ECHO OFF
SET LINESIZE 80

SET SERVEROUTPUT ON SIZE 10000
WHENEVER SQLERROR EXIT ROLLBACK
column filename NEW_VAL filename1 

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME')  filename
  FROM dual;

spo 310_DBatCAS_MK1050_SYN_RB_&filename1..log;

ALTER SESSION SET EDITION = ORA$BASE;

SELECT 'current user is ' || USER || ' at ' FROM dual;

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

DECLARE 
  str_syn             VARCHAR2(100);
  str_schema          VARCHAR2(100);
  str_validation_type VARCHAR2(100);
  v_count             NUMBER;
  str_db_link		  VARCHAR2(50);
  v_user_env VARCHAR2(20);
BEGIN
  str_syn             := 'T_REWARDS_SIX_FLAGS_ITEM';
  str_schema          := 'REWARD';
  str_validation_type := 'ROLLBACK';
/* *** */

    SELECT LOWER(SYS_CONTEXT('USERENV', 'DB_NAME')) INTO v_user_env FROM dual;

	IF v_user_env =  'cas'  THEN
	    str_db_link := 'OPSREWARD.US.ORACLE.COM';
	ELSE
	    str_db_link := 'OPSREWARD.FNBM.CORP';
	END IF;

  SELECT COUNT(1)
  INTO v_count
  FROM dba_SYNONYMS
  WHERE SYNONYM_name = str_syn
  AND owner = 'PUBLIC'
  AND table_owner = str_schema
  AND db_Link = str_db_link;
      
  IF v_count > 0 THEN
     EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ' || str_syn;
  END IF;
  
  str_syn := 'T_REWARDS_SIX_FLAGS_ITEM_CODE';
  
  SELECT COUNT(1)
  INTO v_count
  FROM dba_SYNONYMS
  WHERE SYNONYM_name = str_syn
  AND owner = 'PUBLIC'
  AND table_owner = str_schema
  AND db_Link = str_db_link;
      
  IF v_count > 0 THEN
     EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ' || str_syn;
  END IF;
  
  str_syn := 'T_LU_REWARDS_OFFER_TYPE';
  
  SELECT COUNT(1)
  INTO v_count
  FROM dba_SYNONYMS
  WHERE SYNONYM_name = str_syn
  AND owner = 'PUBLIC'
  AND table_owner = str_schema
  AND db_Link = str_db_link;
      
  IF v_count > 0 THEN
     EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ' || str_syn;
  END IF;
  
  str_syn := 'CHD_PROCESS_LOG_01';
  
  SELECT COUNT(1)
  INTO v_count
  FROM DBA_TAB_PRIVS
 WHERE GRANTEE = 'NOTIFY'
   AND TABLE_NAME = str_syn
   AND PRIVILEGE = 'UPDATE';
   
   IF v_count > 0 THEN
     EXECUTE IMMEDIATE 'REVOKE UPDATE ON CUSTOMER.' || str_syn || ' FROM NOTIFY';
   END IF;
  

/* *** */
END;
/

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

sho ERRORS
spo OFF
