/*
  Script:      300_DBAatCAS_MK1001_SYN_RB_VALIDATION.sql
  Author:      Carlos Mendoza
  Date:        03/27/2020
  Purpose:     rollback tables synonym validation.
*/

SET TERMOUT ON
SET ECHO OFF
SET LINESIZE 80

SET SERVEROUTPUT ON SIZE 10000
WHENEVER SQLERROR EXIT ROLLBACK
column filename NEW_VAL filename1 

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME')  filename
  FROM dual;

spo 300_DBAatCAS_MK1001_SYN_RB_VALIDATION_&filename1..log;

SELECT 'current user is ' || USER || ' at ' FROM dual;

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;


DECLARE
  str_audit           VARCHAR2(10000);
  str_err             VARCHAR2(10000);
  v_varchar           VARCHAR2(50);
  str_syn             VARCHAR2(100);
  str_schema          VARCHAR2(100);
  str_validation_type VARCHAR2(100);
  v_count             NUMBER;
  str_db_link		  VARCHAR2(50);
  v_user_env VARCHAR2(20);
BEGIN
  str_err   := NULL;
  str_audit := NULL;
  
  
  -- Validate tables syn rollback

  str_syn             := 'T_REWARDS_SIX_FLAGS_ITEM';
  str_schema          := 'REWARD';
  str_validation_type := 'ROLLBACK';

    SELECT LOWER(SYS_CONTEXT('USERENV', 'DB_NAME')) INTO v_user_env FROM dual;

	IF v_user_env =  'cas'  THEN
	    str_db_link := 'OPSREWARD.US.ORACLE.COM';
	ELSE
	    str_db_link := 'OPSREWARD.FNBM.CORP';
	END IF;
  
  -- Validate Synonym
  SELECT COUNT(1)
  INTO v_count
  FROM dba_SYNONYMS
  WHERE SYNONYM_name = str_syn
  AND owner = 'PUBLIC'
  AND table_owner = str_schema
  AND db_Link = str_db_link;
  
  IF (v_count = 0) THEN
    str_audit := str_audit || 'Public synonym ' || str_syn ||
                     ' was removed from the database' ||
                     chr(13);
  ELSE
    str_err := str_err || '- Public synonym ' || str_syn || ' still exists in the database' || chr(13);
  END IF;
  
  str_syn := 'T_REWARDS_SIX_FLAGS_ITEM_CODE';
  SELECT COUNT(1)
  INTO v_count
  FROM dba_SYNONYMS
  WHERE SYNONYM_name = str_syn
  AND owner = 'PUBLIC'
  AND table_owner = str_schema
  AND db_Link = str_db_link;
  
  IF (v_count = 0) THEN
    str_audit := str_audit || 'Public synonym ' || str_syn ||
                     ' was removed from the database' ||
                     chr(13);
  ELSE
    str_err := str_err || '- Public synonym ' || str_syn || ' still exists in the database' || chr(13);
  END IF;
  
  str_syn := 'T_LU_REWARDS_OFFER_TYPE';
  SELECT COUNT(1)
  INTO v_count
  FROM dba_SYNONYMS
  WHERE SYNONYM_name = str_syn
  AND owner = 'PUBLIC'
  AND table_owner = str_schema
  AND db_Link = str_db_link;
  
  IF (v_count = 0) THEN
    str_audit := str_audit || 'Public synonym ' || str_syn ||
                     ' was removed from the database' ||
                     chr(13);
  ELSE
    str_err := str_err || '- Public synonym ' || str_syn || ' still exists in the database' || chr(13);
  END IF;

  str_syn := 'CHD_PROCESS_LOG_01';

SELECT COUNT(1)
  INTO v_count
  FROM DBA_TAB_PRIVS
 WHERE GRANTEE = 'NOTIFY'
   AND TABLE_NAME = 'CHD_PROCESS_LOG_01'
   AND PRIVILEGE = 'UPDATE';

  IF (v_count = 0) THEN
    str_audit := str_audit || 'Privilege on table ' || str_syn ||
                     ' was removed from the database' ||
                     chr(13);
  ELSE
    str_err := str_err || '- Privilege on table  ' || str_syn || ' still exists in the database' || chr(13);
  END IF;
  
  IF (NVL(LENGTH(str_err), 0) = 0) THEN
    DBMS_OUTPUT.PUT_LINE(str_validation_type || ' is successfull!' ||
                         chr(13));
  ELSE
    DBMS_OUTPUT.PUT_LINE(str_validation_type || ' FAILED!' || chr(13));
    DBMS_OUTPUT.PUT_LINE('Audit Data:');
    DBMS_OUTPUT.PUT_LINE(str_audit);
    DBMS_OUTPUT.PUT_LINE('Error Data:');
    DBMS_OUTPUT.PUT_LINE(str_err);
    RAISE_APPLICATION_ERROR(-20001,
                            'Validation failed! ' || str_validation_type ||
                            ' FAILED!' || chr(13) || 'Audit Data: ' ||
                            str_audit || chr(13) || 'Error Data: ' ||
                            chr(13) || str_err || chr(13));
  END IF;

END;
/

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

sho ERRORS
spo OFF
