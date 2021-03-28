/*
  Script:      700_DBAatOPS_MK1050_SYN_RB_VAL.sql
  Author:      Levi Tamiozzo
  Date:        2021-01-26
  Purpose:     Validate synonyms drop.
*/

SET TERMOUT ON
SET ECHO OFF
SET LINESIZE 80
SET SERVEROUTPUT ON SIZE 10000
WHENEVER SQLERROR EXIT ROLLBACK
column filename NEW_VAL filename1 

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME')  filename
  FROM dual;

spo 700_DBAatOPS_MK1050_SYN_RB_VAL_&filename1..log;

SELECT 'current user is ' || USER || ' at ' FROM dual;

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

/* SQL Statement Start */

DECLARE

    V_COUNT 		NUMBER;    	
    V_OBJECT_NAME 	VARCHAR2(255);
 
	TYPE SYN_REC IS RECORD(
		SYN_NAME VARCHAR2(200)
    );
	
	TYPE SYN_NAME_LIST_TYPE IS TABLE OF SYN_REC INDEX BY PLS_INTEGER;
    V_SYN_NAME_LIST SYN_NAME_LIST_TYPE;       

BEGIN		      

	V_SYN_NAME_LIST(1).SYN_NAME 	:= 'PKG_MS_REWARDS_SIX_FLAGS_ITEM';		
    V_SYN_NAME_LIST(2).SYN_NAME 	:= 'PKG_MS_REWARDS_OFFER_TYPE';	
	
	-- Validate that synonyms doesn't exist.
	FOR I IN V_SYN_NAME_LIST.FIRST .. V_SYN_NAME_LIST.LAST LOOP 
	 
		-- Validate Synonym. 
		SELECT COUNT(1)
		  INTO V_COUNT
		  FROM DBA_OBJECTS		  
		 WHERE OBJECT_TYPE = 'SYNONYM'
		   AND OBJECT_NAME =  V_SYN_NAME_LIST(I).SYN_NAME;
		  
		IF V_COUNT = 0 THEN
			DBMS_OUTPUT.PUT_LINE('Synonym '''|| V_SYN_NAME_LIST(I).SYN_NAME ||''' does not exists. VALIDATION SUCCEEDED.');
		ELSE                                                   
			RAISE_APPLICATION_ERROR(-20002,'Synonym '''|| V_SYN_NAME_LIST(I).SYN_NAME ||''' still exists. VALIDATION FAILED.');
		END IF;
	  
	END LOOP;
	
	SELECT TABLE_NAME
		  INTO V_OBJECT_NAME
		  FROM DBA_SYNONYMS
		 WHERE SYNONYM_NAME = 'PKG_MS_REWARDS_SUMMARY'
		   AND OWNER = 'PUBLIC'
		   AND TABLE_OWNER = 'REWARD';
		
		IF V_OBJECT_NAME = 'PKG_MS_REWARDS_SUMMARY_R' THEN
		  DBMS_OUTPUT.PUT_LINE('Synonym is pointing to PKG_MS_REWARDS_SUMMARY_R. VALIDATION SUCCEDED');
		ELSE
			RAISE_APPLICATION_ERROR(-20002,'Synonym is not pointing to PKG_MS_REWARDS_SUMMARY_R. VALIDATION FAILED');
		END IF;
    
END;
/

/* SQL Statement End */

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

sho ERRORS
spo OFF
