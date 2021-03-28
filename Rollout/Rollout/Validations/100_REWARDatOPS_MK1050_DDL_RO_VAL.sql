/*
  Script:      100_REWARDatOPS_MK1050_DDL_RO_VAL.sql
  Author:      Levi Tamiozzo
  Date:        01/26/2021
  Purpose:     Validates new table 		T_REWARDS_SIX_FLAGS_ITEM.
			   Validates new sequence 	SEQ_REWARDS_SIX_FLAGS_ITEM.
			   
			   Validates new table 		T_REWARDS_SIX_FLAGS_ITEM_CODE.
			   Validates new sequence 	SEQ_REWARDS_SIX_FLAGS_ITEM_CODE.
			   
			   Validates new columns 		T_REWARDS_REDEMPTION_SIX_FLAGS.
			   Validates new columns 	SEQ_REWARDS_REDEMPTION_SIX_FLAGS.
			   
			   Validates new table 	T_LU_REWARDS_OFFER_TYPE.
			   Validates new sequence 	SEQ_LU_REWARDS_OFFER_TYPE.
*/

SET TERMOUT ON
SET ECHO Off
spool off

SET LINESIZE 80

SET SERVEROUTPUT ON SIZE 10000
WHENEVER SQLERROR EXIT ROLLBACK
column filename new_val filename1 
COLUMN script_name new_val _script_name

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME')     filename
  FROM dual; 
  
spool  100_REWARDatOPS_MK1050_DDL_RO_VAL_&filename1..log

ALTER SESSION SET CURRENT_SCHEMA = REWARD;
ALTER SESSION SET EDITION = ORA$BASE;
 
SELECT 'current user is ' || USER || ' at '
  FROM dual;


SELECT TO_CHAR(SYSDATE, 'DD-Mon-YYYY HH24:MI:SS') date_
  FROM dual;

DECLARE

    V_COUNT           	PLS_INTEGER;
    
    STR_AUDIT           VARCHAR2(10000);
    STR_ERR             VARCHAR2(10000);
    STR_VALIDATION_TYPE VARCHAR2(100) := 'ROLLOUT VALIDATION for DDL Reward changes';
	
	TYPE VAL_REC IS RECORD(
		OBJ_NAME VARCHAR2(200),
		OBJ_TYPE VARCHAR2(200)
    );
	
	TYPE VAL_OBJ_LIST_TYPE IS TABLE OF VAL_REC INDEX BY PLS_INTEGER;
    V_VAL_OBJ_LIST VAL_OBJ_LIST_TYPE;
    v_table_name    	VARCHAR2(60);		
BEGIN
	
	STR_ERR   := NULL;
	STR_AUDIT := NULL;
	
	V_VAL_OBJ_LIST(1).OBJ_NAME := 'T_REWARDS_SIX_FLAGS_ITEM';
	V_VAL_OBJ_LIST(1).OBJ_TYPE := 'TABLE';
	
	V_VAL_OBJ_LIST(2).OBJ_NAME := 'SEQ_REWARDS_SIX_FLAGS_ITEM';
	V_VAL_OBJ_LIST(2).OBJ_TYPE := 'SEQUENCE';
	
	V_VAL_OBJ_LIST(3).OBJ_NAME := 'T_REWARDS_SIX_FLAGS_ITEM_CODE';
	V_VAL_OBJ_LIST(3).OBJ_TYPE := 'TABLE';
	
	V_VAL_OBJ_LIST(4).OBJ_NAME := 'SEQ_REWARDS_SIX_FLAGS_ITEM_CODE';
	V_VAL_OBJ_LIST(4).OBJ_TYPE := 'SEQUENCE';	
	
	V_VAL_OBJ_LIST(5).OBJ_NAME := 'T_LU_REWARDS_OFFER_TYPE';
	V_VAL_OBJ_LIST(5).OBJ_TYPE := 'TABLE';

	V_VAL_OBJ_LIST(6).OBJ_NAME := 'SEQ_LU_REWARDS_OFFER_TYPE';
	V_VAL_OBJ_LIST(6).OBJ_TYPE := 'SEQUENCE';		
	
	-- Validate Objects
	FOR I IN V_VAL_OBJ_LIST.FIRST .. V_VAL_OBJ_LIST.LAST LOOP 
		
		SELECT COUNT(1)
		  INTO V_COUNT
		  FROM DBA_OBJECTS T
		 WHERE OWNER = 'REWARD'
		   AND T.OBJECT_TYPE = V_VAL_OBJ_LIST(I).OBJ_TYPE
		   AND UPPER(T.OBJECT_NAME) = V_VAL_OBJ_LIST(I).OBJ_NAME;
		 
		IF (V_COUNT = 1) THEN
		  STR_AUDIT := STR_AUDIT || V_VAL_OBJ_LIST(I).OBJ_TYPE || ' ' || V_VAL_OBJ_LIST(I).OBJ_NAME || ' has been created ' || chr(13);   
		ELSE
		  STR_ERR := STR_ERR || 'VALIDATION FAILED CHECKING FOR ' || V_VAL_OBJ_LIST(I).OBJ_TYPE || ' ' || V_VAL_OBJ_LIST(I).OBJ_NAME || chr(13); 
		END IF;
		
	END LOOP;	

	v_table_name  := 'T_REWARD_REDEMPTION_HISTORY';

    SELECT COUNT(a.COLUMN_NAME)
      INTO v_count
      FROM all_tab_columns a
     WHERE upper(table_name) = v_table_name
       AND (upper(column_name)='PARTNER_REDEMPTION_ITEM_ID' or 
		upper(column_name)='REDEMPTION_TIME' or upper(column_name) = 'ORDER_CONFIRMATION' or upper(column_name) = 'CLIENT_NUMBER' or upper(column_name)='EMAIL_SEND_DATE' 
		or upper(column_name)='PARTNER_REDEMPTION_ITEM_CODE_ID' or upper(column_name)='WEB_PRESENT_CODE' or 
		upper(column_name)='REDEEMER_EMAIL_1' or upper(column_name)='NOTIFICATION_ID');
	   
	IF (v_count = 9) THEN
		str_audit := str_audit || 'new columns have been added to table ' || v_table_name || chr(13);		
	ELSE
		str_err := str_err || 'VALIDATION FAILED CHECKING FOR NEW COLUMNS IN TABLE ' || v_table_name || chr(13);	
	END IF;
	
	v_table_name  := 'T_RWRD_REDEMPTION_PENDING';

    SELECT COUNT(a.COLUMN_NAME)
      INTO v_count
      FROM all_tab_columns a
     WHERE upper(table_name) = v_table_name
       AND (upper(column_name)='SUPPLIER_GOODS_ID' or 
		upper(column_name)='REDEMPTION_TIME' or upper(column_name) = 'ORDER_CONFIRMATION' or upper(column_name) = 'CLIENT_NUMBER' or upper(column_name)='WEB_PRESENT_CODE' 
		or upper(column_name)='REDEEMER_EMAIL_1');
	   
	IF (v_count = 6) THEN
		str_audit := str_audit || 'new columns have been added to table ' || v_table_name || chr(13);		
	ELSE
		str_err := str_err || 'VALIDATION FAILED CHECKING FOR NEW COLUMNS IN TABLE ' || v_table_name || chr(13);	
	END IF;
	
	-- Print Result
    IF (NVL(LENGTH(STR_ERR), 0) = 0) THEN
		DBMS_OUTPUT.PUT_LINE(STR_VALIDATION_TYPE || ' is successfull!' || chr(13));
	ELSE
	  DBMS_OUTPUT.PUT_LINE(STR_VALIDATION_TYPE || ' FAILED!' || chr(13));
	  DBMS_OUTPUT.PUT_LINE('Audit Data:');
	  DBMS_OUTPUT.PUT_LINE(STR_AUDIT);
	  DBMS_OUTPUT.PUT_LINE('Error Data:');
	  DBMS_OUTPUT.PUT_LINE(STR_ERR);
	  RAISE_APPLICATION_ERROR(-20001,
							  'Validation failed! ' || STR_VALIDATION_TYPE ||
							  ' FAILED!' || chr(13) || 'Audit Data: ' ||
							  STR_AUDIT || chr(13) || 'Error Data: ' ||
							  chr(13) || STR_ERR || chr(13));
	END IF;

END;
/

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

sho ERRORS 
spo OFF 

 

 
