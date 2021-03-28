/*
  Script:      DELETE_EMAIL_REDEM_INTO_T_LU_NOTIFICATION_TEMPLATE.sql
  Schema:      NOTIFY
  Author:      Levi Tamiozzo
  Project:     MK-1050
  Date:        2021-02-04
  Purpose:     Delete templates for Six Flags REDEM Emails.
*/

DECLARE

    V_COUNT NUMBER;
	
	TYPE REC_TYPE IS RECORD(
		REC_TMPL_CODE 			T_LU_NOTIFICATION_TEMPLATE.NOTIFICATION_TMPL_CODE%TYPE
    );	
		
	TYPE LIST_TYPE IS TABLE OF REC_TYPE INDEX BY PLS_INTEGER;
	
    V_LIST LIST_TYPE;

BEGIN		  

	V_LIST(1).REC_TMPL_CODE 		:= '364467';
	V_LIST(2).REC_TMPL_CODE 		:= '364582';
	V_LIST(3).REC_TMPL_CODE 		:= '364585';
	V_LIST(4).REC_TMPL_CODE 		:= '364466';
	V_LIST(5).REC_TMPL_CODE 		:= '364583';
	V_LIST(6).REC_TMPL_CODE 		:= '364561';
	V_LIST(7).REC_TMPL_CODE 		:= '364505';
	V_LIST(8).REC_TMPL_CODE 		:= '364601';
	V_LIST(9).REC_TMPL_CODE 		:= '364581';
	V_LIST(10).REC_TMPL_CODE 		:= '364584';

  	
	FOR I IN V_LIST.FIRST .. V_LIST.LAST LOOP 
		
		-- Check if the template exists. 
		SELECT COUNT(1)
		  INTO V_COUNT
		  FROM T_LU_NOTIFICATION_TEMPLATE T
		 WHERE T.NOTIFICATION_TMPL_CODE = V_LIST(I).REC_TMPL_CODE;

		-- Delete it if it does.
		IF V_COUNT = 1 THEN
			
			DELETE FROM T_LU_NOTIFICATION_TEMPLATE T
				  WHERE T.NOTIFICATION_TMPL_CODE = V_LIST(I).REC_TMPL_CODE;
		  
			DBMS_OUTPUT.PUT_LINE('Template '''|| V_LIST(I).REC_TMPL_CODE ||''' deleted succesfuly.');
		ELSE                                                   
			DBMS_OUTPUT.PUT_LINE('Template '''|| V_LIST(I).REC_TMPL_CODE ||''' not found, no data was changed.');
		END IF;	  
	  
	END LOOP;
	
	COMMIT;
    
END;
/