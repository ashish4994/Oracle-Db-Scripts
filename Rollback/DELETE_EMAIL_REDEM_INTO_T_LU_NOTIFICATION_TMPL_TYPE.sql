/*
  Script:      DELETE_EMAIL_REDEM_INTO_T_LU_NOTIFICATION_TMPL_TYPE.sql
  Schema:      NOTIFY
  Author:      Levi Tamiozzo
  Project:     MK-1050
  Date:        2021-02-04
  Purpose:     Delete notification template type for Six Flags REDEM Emails.
*/

DECLARE

    V_COUNT NUMBER;
	
	TYPE REC_TYPE IS RECORD(
		REC_CODE T_LU_NOTIFICATION_TMPL_TYPE.NOTIFICATION_TMPL_TYPE_CODE%TYPE
    );
	
	TYPE LIST_TYPE IS TABLE OF REC_TYPE INDEX BY PLS_INTEGER;
	
    V_LIST LIST_TYPE;

BEGIN		   

	V_LIST(1).REC_CODE := 'SIXFLAGS12MMEMB';
	V_LIST(2).REC_CODE := 'SIXFLAGSSSNPASS';
	V_LIST(3).REC_CODE := 'SIXFLAGSDAYPASS';
	V_LIST(4).REC_CODE := 'SIXFLAGSDXDINEPASS';
	V_LIST(5).REC_CODE := 'SIXFLAGSANDINEPASS';
	V_LIST(6).REC_CODE := 'SIXFLAGSSSNDRINK';
	V_LIST(7).REC_CODE := 'SIXFLAGSDAYDRINK';
	V_LIST(8).REC_CODE := 'SIXFLAGSDAYDINE';
	V_LIST(9).REC_CODE := 'SIXFLAGSDAYFLASH';	
	V_LIST(10).REC_CODE := 'SIXFLAGSPARKING';	
  	
	FOR I IN V_LIST.FIRST .. V_LIST.LAST LOOP 
	 
		-- Check if the template type exists. 
		SELECT COUNT(1)
		  INTO V_COUNT
		  FROM T_LU_NOTIFICATION_TMPL_TYPE T
		 WHERE T.NOTIFICATION_TMPL_TYPE_CODE =  V_LIST(I).REC_CODE;

		-- Insert it if it does.
		IF V_COUNT = 1 THEN
			
			DELETE FROM T_LU_NOTIFICATION_TMPL_TYPE T
				  WHERE T.NOTIFICATION_TMPL_TYPE_CODE =  V_LIST(I).REC_CODE;
		  
			DBMS_OUTPUT.PUT_LINE('Template type '''|| V_LIST(I).REC_CODE ||''' deleted succesfuly.');
		ELSE                                                   
			DBMS_OUTPUT.PUT_LINE('Template type '''|| V_LIST(I).REC_CODE ||''' not found, no data was changed.');
		END IF;	  
	  
	END LOOP;
	
	COMMIT;
    
END;
/
