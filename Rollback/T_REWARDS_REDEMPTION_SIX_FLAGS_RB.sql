/*
  Script:      T_REWARDS_REDEMPTION_SIX_FLAGS_RB.sql
  Schema:      REWARD
  Author:      Levi Tamiozzo
  Date:        01/26/2021
  Purpose:     Rollback for T_REWARDS_REDEMPTION_SIX_FLAGS table creation.  
*/

DECLARE

  V_COUNT NUMBER;  
  
BEGIN

  SELECT COUNT(1) 
  INTO V_COUNT 
  FROM ALL_TABLES T
  WHERE UPPER(T.TABLE_NAME) = 'T_REWARDS_REDEMPTION_SIX_FLAGS';
  
  IF (V_COUNT = 1) THEN 
      EXECUTE IMMEDIATE 'DROP TABLE T_REWARDS_REDEMPTION_SIX_FLAGS';
  END IF;
   
END;
/
