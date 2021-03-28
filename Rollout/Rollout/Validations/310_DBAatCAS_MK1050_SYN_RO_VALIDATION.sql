/*
  Script:      310_DBAatCAS_MK1050_SYN_RO_VALIDATION.sql
  Author:      Favio Massarini
  Date:        02/09/2021
  Purpose:     Validate table synonym creation.
*/

SET TERMOUT ON
SET ECHO OFF
SET LINESIZE 80

SET SERVEROUTPUT ON SIZE 10000
WHENEVER SQLERROR EXIT ROLLBACK
column filename NEW_VAL filename1 

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME')  filename
  FROM dual;

spo 310_DBAatCAS_MK1050_SYN_RO_VALIDATION_&filename1..log;

SELECT 'current user is ' || USER || ' at ' FROM dual;

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;


DECLARE
  str_audit           VARCHAR2(10000);
  str_err             VARCHAR2(10000);
  v_varchar           VARCHAR2(50);
  str_syn             VARCHAR2(100);
  str_schema          VARCHAR2(100);
  str_dblink_name VARCHAR2(100);
  str_validation_type VARCHAR2(100);
v_count		NUMBER;
v_user_env VARCHAR2(20);
BEGIN
  str_err   := NULL;
  str_audit := NULL;
  
  -- Validate tables syn rollout

  -- Set these 3 variables for your package.
  str_syn             := 'T_REWARDS_SIX_FLAGS_ITEM';
  str_schema          := 'REWARD';
  str_validation_type := 'ROLLOUT'; -- Should be either 'ROLLOUT' or 'ROLLBACK'
  
  -- Validate Synonym T_REWARDS_SIX_FLAGS_ITEM
  BEGIN  
    SELECT LOWER(SYS_CONTEXT('USERENV', 'DB_NAME')) INTO v_user_env FROM dual;

	IF v_user_env =  'cas'  THEN
	    str_dblink_name := 'OPSREWARD.US.ORACLE.COM';
	ELSE
	    str_dblink_name := 'OPSREWARD.FNBM.CORP';
	END IF;
	
    -- Select synonym   
    SELECT table_name
      INTO v_varchar
      FROM dba_synonyms
     WHERE synonym_name = str_syn
       AND owner = 'PUBLIC'
       AND table_owner = str_schema
	   AND db_link = str_dblink_name;
    
    -- Validate synonym created and pointing to correct package
    IF v_varchar = str_syn THEN
      str_audit := str_audit || 'Public synonym ' || str_syn ||
                   ' is created for ' || v_varchar || ' in the database' ||
                   chr(13);
    ELSE
      str_err := str_err || '- Public synonym is NOT created for ' ||
                 str_syn || ' in the database' || chr(13);
    END IF;
    
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      str_err := str_err || '- Public synonym is NOT created for ' ||
                 str_syn || chr(13);
  END;
  
  -- Validate Synonym T_REWARDS_SIX_FLAGS_ITEM_CODE
  str_syn := 'T_REWARDS_SIX_FLAGS_ITEM_CODE';
  BEGIN  
    -- Select synonym   
    SELECT table_name
      INTO v_varchar
      FROM dba_synonyms
     WHERE synonym_name = str_syn
       AND owner = 'PUBLIC'
       AND table_owner = str_schema
	   AND db_link = str_dblink_name;
    
    -- Validate synonym created and pointing to correct package
    IF v_varchar = str_syn THEN
      str_audit := str_audit || 'Public synonym ' || str_syn ||
                   ' is created for ' || v_varchar || ' in the database' ||
                   chr(13);
    ELSE
      str_err := str_err || '- Public synonym is NOT created for ' ||
                 str_syn || ' in the database' || chr(13);
    END IF;
    
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      str_err := str_err || '- Public synonym is NOT created for ' ||
                 str_syn || chr(13);
  END;
  
  -- Validate Synonym T_LU_REWARDS_OFFER_TYPE
  str_syn := 'T_LU_REWARDS_OFFER_TYPE';
  BEGIN  
    -- Select synonym   
    SELECT table_name
      INTO v_varchar
      FROM dba_synonyms
     WHERE synonym_name = str_syn
       AND owner = 'PUBLIC'
       AND table_owner = str_schema
	   AND db_link = str_dblink_name;
    
    -- Validate synonym created and pointing to correct package
    IF v_varchar = str_syn THEN
      str_audit := str_audit || 'Public synonym ' || str_syn ||
                   ' is created for ' || v_varchar || ' in the database' ||
                   chr(13);
    ELSE
      str_err := str_err || '- Public synonym is NOT created for ' ||
                 str_syn || ' in the database' || chr(13);
    END IF;
    
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      str_err := str_err || '- Public synonym is NOT created for ' ||
                 str_syn || chr(13);
  END;

str_syn := 'CHD_PROCESS_LOG_01';

SELECT COUNT(1)
  INTO v_count
  FROM DBA_TAB_PRIVS
 WHERE GRANTEE = 'NOTIFY'
   AND TABLE_NAME = str_syn
   AND PRIVILEGE = 'UPDATE';

  IF (v_count = 1) THEN
    str_audit := str_audit || 'Privilege UPDATE on table ' || str_syn ||
                     ' was created for NOTIFY in the database' ||
                     chr(13);
  ELSE
    str_err := str_err || '- Privilege UPDATE on table  ' || str_syn || ' was NOT created for NOTIFY in the database' || chr(13);
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
