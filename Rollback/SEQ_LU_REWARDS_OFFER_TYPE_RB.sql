/*
  Script:      SEQ_LU_REWARDS_OFFER_TYPE_RB.sql
  Schema:      REWARD
  Author:      Carlos Mendoza
  Date:        02/04/2021
  Purpose:     Rollback for SEQ_LU_REWARDS_OFFER_TYPE sequence creation.  
*/

DECLARE

  V_COUNT NUMBER;
  
BEGIN

  SELECT COUNT(1) 
	INTO V_COUNT 
	FROM ALL_SEQUENCES S 
	WHERE UPPER(S.SEQUENCE_NAME) = 'SEQ_LU_REWARDS_OFFER_TYPE';
  
  IF (V_COUNT = 1) THEN 
      EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_LU_REWARDS_OFFER_TYPE';
  END IF;
   
END;
/
