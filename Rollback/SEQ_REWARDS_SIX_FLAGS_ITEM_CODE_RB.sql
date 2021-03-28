/*
  Script:      SEQ_REWARDS_SIX_FLAGS_ITEM_CODE_RB.sql
  Schema:      REWARD
  Author:      Levi Tamiozzo
  Date:        01/26/2021
  Purpose:     Rollback for SEQ_REWARDS_SIX_FLAGS_ITEM_CODE sequence creation.  
*/

DECLARE

  V_COUNT NUMBER;
  
BEGIN

  SELECT COUNT(1) 
	INTO V_COUNT 
	FROM ALL_SEQUENCES S 
	WHERE UPPER(S.SEQUENCE_NAME) = 'SEQ_REWARDS_SIX_FLAGS_ITEM_CODE';
  
  IF (V_COUNT = 1) THEN 
      EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_REWARDS_SIX_FLAGS_ITEM_CODE';
  END IF;
   
END;
/
