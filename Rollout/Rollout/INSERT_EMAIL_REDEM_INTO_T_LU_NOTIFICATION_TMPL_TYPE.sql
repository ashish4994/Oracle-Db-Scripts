/*
  Script:      INSERT_EMAIL_REDEM_INTO_T_LU_NOTIFICATION_TMPL_TYPE.sql
  Schema:      NOTIFY
  Author:      Levi Tamiozzo
  Project:     MK-1050
  Date:        2021-02-04
  Purpose:     Insert notification template type for Six Flags REDEM Emails.
*/

DECLARE

    V_COUNT NUMBER;
	
	TYPE REC_TYPE IS RECORD(
		REC_CODE T_LU_NOTIFICATION_TMPL_TYPE.NOTIFICATION_TMPL_TYPE_CODE%TYPE,
		REC_NAME T_LU_NOTIFICATION_TMPL_TYPE.NOTIFICATION_TMPL_NAME%TYPE
    );
	
	TYPE LIST_TYPE IS TABLE OF REC_TYPE INDEX BY PLS_INTEGER;
	
    V_LIST LIST_TYPE;

BEGIN		   

	V_LIST(1).REC_CODE := 'SIXFLAGS12MMEMB';
	V_LIST(1).REC_NAME := '12 month membership';
	
	V_LIST(2).REC_CODE := 'SIXFLAGSSSNPASS';
	V_LIST(2).REC_NAME := 'Season pass';
	
	V_LIST(3).REC_CODE := 'SIXFLAGSDAYPASS';
	V_LIST(3).REC_NAME := 'Single day pass';
	
	V_LIST(4).REC_CODE := 'SIXFLAGSDXDINEPASS';
	V_LIST(4).REC_NAME := 'Deluxe dining pass';
	
	V_LIST(5).REC_CODE := 'SIXFLAGSANDINEPASS';
	V_LIST(5).REC_NAME := 'Anual dining pass';
	
	V_LIST(6).REC_CODE := 'SIXFLAGSSSNDRINK';
	V_LIST(6).REC_NAME := 'All season drink bottle';
	
	V_LIST(7).REC_CODE := 'SIXFLAGSDAYDRINK';
	V_LIST(7).REC_NAME := 'All day drink bottle';
	
	V_LIST(8).REC_CODE := 'SIXFLAGSDAYDINE';
	V_LIST(8).REC_NAME := 'One day dining deal';
	
	V_LIST(9).REC_CODE := 'SIXFLAGSDAYFLASH';
	V_LIST(9).REC_NAME := 'One day flash pass';
	
	V_LIST(10).REC_CODE := 'SIXFLAGSPARKING';
	V_LIST(10).REC_NAME := 'Parking voucher';
  	
	FOR I IN V_LIST.FIRST .. V_LIST.LAST LOOP 
	 
		-- Check if the template type already exists. 
		SELECT COUNT(1)
		  INTO V_COUNT
		  FROM T_LU_NOTIFICATION_TMPL_TYPE T
		 WHERE T.NOTIFICATION_TMPL_TYPE_CODE =  V_LIST(I).REC_CODE;

		-- Insert it if it doesn't.
		IF V_COUNT = 0 THEN
			
			INSERT INTO T_LU_NOTIFICATION_TMPL_TYPE
				(NOTIFICATION_TMPL_TYPE_CODE,
				 NOTIFICATION_TMPL_NAME)
			VALUES
				(V_LIST(I).REC_CODE,
				 V_LIST(I).REC_NAME);
		  
			DBMS_OUTPUT.PUT_LINE('Template type '''|| V_LIST(I).REC_CODE ||''' created succesfuly.');
		ELSE                                                   
			DBMS_OUTPUT.PUT_LINE('Template type '''|| V_LIST(I).REC_CODE ||''' already exists, skipped.');
		END IF;	  
	  
	END LOOP;
	
	COMMIT;
    
END;
/
