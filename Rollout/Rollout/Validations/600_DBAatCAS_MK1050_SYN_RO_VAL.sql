/*
  Script:      600_DBAatCAS_MK1050_SYN_RO_VAL.sql
  Author:      Levi Tamiozzo
  Date:        2020-11-17
  Purpose:     Validate synonyms creation.
*/

SET TERMOUT ON
SET ECHO OFF
SET LINESIZE 80
SET SERVEROUTPUT ON SIZE 10000
WHENEVER SQLERROR EXIT ROLLBACK
column filename NEW_VAL filename1 

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME')  filename
  FROM dual;

spo 600_DBAatCAS_MK1050_SYN_RO_VAL_&filename1..log;

SELECT 'current user is ' || USER || ' at ' FROM dual;

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

/* SQL Statement Start */

DECLARE
    V_COUNT NUMBER;
    V_OBJECT_NAME VARCHAR2(255);
	
	TYPE SYN_REC IS RECORD(
		SYN_NAME VARCHAR2(200),
		PROC_NAME VARCHAR2(200),
		SCHEMA_NAME VARCHAR2(200)
    );
	
	TYPE SYN_NAME_LIST_TYPE IS TABLE OF SYN_REC INDEX BY PLS_INTEGER;
    V_SYN_NAME_LIST SYN_NAME_LIST_TYPE;
    
    V_SYN_NAME_DROP_LIST SYN_NAME_LIST_TYPE;

BEGIN		      

	V_SYN_NAME_LIST(1).SYN_NAME := 'Pkg_T_Rt';
	V_SYN_NAME_LIST(1).PROC_NAME := 'Pkg_T_Rt_P';
	V_SYN_NAME_LIST(1).SCHEMA_NAME := 'IFLOW';

	V_SYN_NAME_LIST(2).SYN_NAME := 'pkg_coll_account_info';
	V_SYN_NAME_LIST(2).PROC_NAME := 'pkg_coll_account_info_p';
	V_SYN_NAME_LIST(2).SCHEMA_NAME := 'COLL';

	V_SYN_NAME_LIST(3).SYN_NAME := 'pkg_notify_sixflags';
	V_SYN_NAME_LIST(3).PROC_NAME := 'pkg_notify_sixflags_p';
	V_SYN_NAME_LIST(3).SCHEMA_NAME := 'NOTIFY';	
	
	V_SYN_NAME_LIST(4).SYN_NAME := 'PKG_FDR_REWARDS_STAGING';
	V_SYN_NAME_LIST(4).PROC_NAME := 'PKG_FDR_REWARDS_STAGING_P';
	V_SYN_NAME_LIST(4).SCHEMA_NAME := 'ODS_STG';	
    
	-- Validate synonyms that might point to the "P" object.
	FOR I IN V_SYN_NAME_LIST.FIRST .. V_SYN_NAME_LIST.LAST
		 LOOP 
	 
    -- Validate synonym. 
    SELECT COUNT(1)
      INTO V_COUNT
      FROM DBA_OBJECTS
     WHERE OBJECT_NAME =  upper(V_SYN_NAME_LIST(I).SYN_NAME)  
       AND OBJECT_TYPE = 'SYNONYM';

	  
	  IF V_COUNT = 1 THEN
		DBMS_OUTPUT.PUT_LINE('Synonym '''|| V_SYN_NAME_LIST(I).SYN_NAME ||''' exists. VALIDATION SUCCEEDED.');
	  ELSE                                                   
		RAISE_APPLICATION_ERROR(-20002,'Synonym '''|| V_SYN_NAME_LIST(I).SYN_NAME ||''' does not exist. VALIDATION FAILED.');
	  END IF;
	  
	 -- Validate package synonym.
    SELECT TABLE_NAME
      INTO V_OBJECT_NAME
      FROM DBA_SYNONYMS
     WHERE upper(SYNONYM_NAME) = upper(V_SYN_NAME_LIST(I).SYN_NAME)
       AND OWNER = 'PUBLIC'
       AND TABLE_OWNER = V_SYN_NAME_LIST(I).SCHEMA_NAME;
    
    IF V_OBJECT_NAME = upper(V_SYN_NAME_LIST(I).PROC_NAME) THEN
      DBMS_OUTPUT.PUT_LINE('Synonym is pointing to '''|| V_SYN_NAME_LIST(I).PROC_NAME ||''' ! VALIDATION SUCCEDED');
    ELSE
	    RAISE_APPLICATION_ERROR(-20002,'Synonym is not pointing to '''|| V_SYN_NAME_LIST(I).PROC_NAME ||'''! ' || V_OBJECT_NAME || ' VALIDATION FAILED');
    END IF;
	  
	END LOOP;
    
END;
/

/* SQL Statement End */

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

sho ERRORS
spo OFF
