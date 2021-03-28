/*
  Script:      VALIDATE_DELETE_EMAIL_REDEM_INTO_T_LU_NOTIFICATION_TMPL_VAR.sql
  Schema:      NOTIFY
  Author:      Levi Tamiozzo
  Project:     MK-1050
  Date:        2021-02-04
  Purpose:     Validate delete template variables for Six Falgs REDEM Emails.
*/

DECLARE

    V_COUNT NUMBER;
	
	TYPE TMPL_TYPE IS RECORD(
		REC_TMPL_CODE 			T_LU_NOTIFICATION_TMPL_VAR.NOTIFICATION_TMPL_CODE%TYPE
    );

	TYPE TMPL_LIST_TYPE IS TABLE OF TMPL_TYPE INDEX BY PLS_INTEGER;
	
    V_TMPL_LIST TMPL_LIST_TYPE;

BEGIN		      

	V_TMPL_LIST(1).REC_TMPL_CODE 	:= '364467';	
	V_TMPL_LIST(2).REC_TMPL_CODE 	:= '364582';
	V_TMPL_LIST(3).REC_TMPL_CODE 	:= '364585';
	V_TMPL_LIST(4).REC_TMPL_CODE 	:= '364466';	
	V_TMPL_LIST(5).REC_TMPL_CODE 	:= '364583';
	V_TMPL_LIST(6).REC_TMPL_CODE 	:= '364561';
	V_TMPL_LIST(7).REC_TMPL_CODE 	:= '364505';
	V_TMPL_LIST(8).REC_TMPL_CODE 	:= '364601';
	V_TMPL_LIST(9).REC_TMPL_CODE	:= '364581';
	V_TMPL_LIST(10).REC_TMPL_CODE 	:= '364584';
  	
	FOR I IN V_TMPL_LIST.FIRST .. V_TMPL_LIST.LAST LOOP 
		
		-- Check if any template var exist for the template code. 
		SELECT COUNT(1)
		  INTO V_COUNT
		  FROM T_LU_NOTIFICATION_TMPL_VAR T
		 WHERE T.NOTIFICATION_TMPL_CODE = V_TMPL_LIST(I).REC_TMPL_CODE;

		IF V_COUNT = 0 THEN		
			DBMS_OUTPUT.PUT_LINE('No template vars for template code '''|| V_TMPL_LIST(I).REC_TMPL_CODE ||''' were found. VALIDATION SUCCEDED');
		ELSE                                                   
			RAISE_APPLICATION_ERROR(-20002, 'Some template var for template code '''|| V_TMPL_LIST(I).REC_TMPL_CODE ||''' still exist. VALIDATION FAILED.');
		END IF;
	  
	END LOOP;
    
END;
/