/*
  Script:      DELETE_EMAIL_REDEM_INTO_T_LU_NOTIFICATION_VARIABLE.sql
  Schema:      NOTIFY
  Author:      Levi Tamiozzo
  Project:     MK-1050
  Date:        2021-02-04
  Purpose:     Delete template variables for Six Falgs REDEM Emails.
*/

DECLARE

    V_COUNT NUMBER;
	
	TYPE REC_TYPE IS RECORD(
		REC_NAME T_LU_NOTIFICATION_VARIABLE.VARIABLE_NAME%TYPE
    );
	
	TYPE LIST_TYPE IS TABLE OF REC_TYPE INDEX BY PLS_INTEGER;
	
    V_LIST LIST_TYPE;

BEGIN		      

	V_LIST(1).REC_NAME := 'MISCELLANEOUS10';
	V_LIST(2).REC_NAME := 'MISCELLANEOUS11';
	V_LIST(3).REC_NAME := 'MISCELLANEOUS12';
	V_LIST(4).REC_NAME := 'MISCELLANEOUS13';
	V_LIST(5).REC_NAME := 'MISCELLANEOUS17';
	V_LIST(6).REC_NAME := 'MISCELLANEOUS18';
  	
	FOR I IN V_LIST.FIRST .. V_LIST.LAST LOOP 
	 
		-- Check if the variable exists. 
		SELECT COUNT(1)
		  INTO V_COUNT
		  FROM T_LU_NOTIFICATION_VARIABLE T
		 WHERE T.VARIABLE_NAME =  V_LIST(I).REC_NAME;

		-- Delete it if it does.
		IF V_COUNT = 1 THEN
			
			DELETE FROM T_LU_NOTIFICATION_VARIABLE T
				  WHERE T.VARIABLE_NAME =  V_LIST(I).REC_NAME;
		  
			DBMS_OUTPUT.PUT_LINE('Variable '''|| V_LIST(I).REC_NAME ||''' deleted succesfuly.');
		ELSE                                                   
			DBMS_OUTPUT.PUT_LINE('Variable '''|| V_LIST(I).REC_NAME ||''' not found, no data was changed.');
		END IF;	  
	  
	END LOOP;
	
	COMMIT;
    
END;
/
