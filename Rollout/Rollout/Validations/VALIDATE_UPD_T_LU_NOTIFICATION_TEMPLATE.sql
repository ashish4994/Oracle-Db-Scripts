/*
  Script:      UPD_T_LU_NOTIFICATION_TEMPLATE
  Schema:      NOTIFY
  Author:      Favio Massarini
  Project:     MK-1050
  Date:        02/22/2021
  Purpose:     add C1B template name for Six Flags
*/

DECLARE
	V_ENV                          VARCHAR2(50);
	V_COUNT						   NUMBER;
	V_NOTIFICATION_TMPL_CODE       VARCHAR2(100);
	V_C1B_TEMPLATE_NAME            VARCHAR2(20) := 'MT070050';
BEGIN

	-- Get environment
	SELECT SYS_CONTEXT('USERENV', 'DB_NAME') INTO V_ENV FROM DUAL;

	-- Push: Set production / test template code
	IF UPPER(V_ENV) = 'CAS' THEN
		V_NOTIFICATION_TMPL_CODE := 'c462a71e-5253-4a79-a5ad-c208585dde6b';
	ELSE
		V_NOTIFICATION_TMPL_CODE := 'bc9a55e7-aa65-4636-b074-a26f50ca49c5';
	END IF;

	SELECT COUNT(*)
	INTO V_COUNT
	FROM T_LU_NOTIFICATION_TEMPLATE
	WHERE NOTIFICATION_TMPL_CODE = V_NOTIFICATION_TMPL_CODE
	AND C1B_TEMPLATE_NAME = V_C1B_TEMPLATE_NAME;
	
	IF V_COUNT = 1 THEN									
		DBMS_OUTPUT.PUT_LINE('Template '|| V_NOTIFICATION_TMPL_CODE ||' has been updated. VALIDATION SUCCEDED');				
	ELSE                                                   
		RAISE_APPLICATION_ERROR(-20002, 'Template '|| V_NOTIFICATION_TMPL_CODE ||' has not been updated. VALIDATION FAILED.');  			
	END IF; 
	
	-- MsgCenter: Set production / test template code
	IF UPPER(V_ENV) = 'CAS' THEN
	V_NOTIFICATION_TMPL_CODE := 'bfedde50-0023-4e3f-aa69-4e3a6695b68c';
	ELSE
	V_NOTIFICATION_TMPL_CODE := '8aee927b-3b32-47d3-866a-e4aa5c31d5d5';
	END IF;
	
	SELECT COUNT(*)
	INTO V_COUNT
	FROM T_LU_NOTIFICATION_TEMPLATE
	WHERE NOTIFICATION_TMPL_CODE = V_NOTIFICATION_TMPL_CODE
	AND C1B_TEMPLATE_NAME = V_C1B_TEMPLATE_NAME;
  
	IF V_COUNT = 1 THEN									
		DBMS_OUTPUT.PUT_LINE('Template '|| V_NOTIFICATION_TMPL_CODE ||' has been updated. VALIDATION SUCCEDED');				
	ELSE                                                   
		RAISE_APPLICATION_ERROR(-20002, 'Template '|| V_NOTIFICATION_TMPL_CODE ||' has not been updated. VALIDATION FAILED.');  			
	END IF; 

END;
/
