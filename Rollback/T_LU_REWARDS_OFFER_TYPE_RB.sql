/*
  Script:      T_LU_REWARDS_OFFER_TYPE_RB.sql
  Schema:      REWARD
  Author:      Carlos Mendoza
  Date:        02/04/2021
  Purpose:     Rollback for T_LU_REWARDS_OFFER_TYPE table creation.  
*/

DECLARE

  V_COUNT NUMBER;  
  
BEGIN

  SELECT COUNT(1) 
  INTO V_COUNT 
  FROM ALL_TABLES T
  WHERE UPPER(T.TABLE_NAME) = 'T_LU_REWARDS_OFFER_TYPE';
  
  IF (V_COUNT = 1) THEN 
      EXECUTE IMMEDIATE 'DROP TABLE T_LU_REWARDS_OFFER_TYPE';
  END IF;
   
END;
/
