/*
  Script:      VALIDATE_INSERT_INTO_T_REWARDS_SIX_FLAGS_ITEM.sql
  Schema:      REWARD
  Author:      Favio Massarini
  Project:     MK-1050
  Date:        2021-02-05
  Purpose:     Validate the Six Flags Items.
*/

DECLARE

  V_COUNT           NUMBER;  

BEGIN
  
  -- Validate that Six Flags Items exist
  DBMS_OUTPUT.PUT_LINE('Validating that Six Flags Items exist.');
  
  SELECT COUNT(1)
    INTO V_COUNT
    FROM T_REWARDS_SIX_FLAGS_ITEM;
  
  IF V_COUNT = 230 THEN
    DBMS_OUTPUT.PUT_LINE('ROLLOUT VALIDATION SUCCEEDED!');
  ELSE
    RAISE_APPLICATION_ERROR(-20001, 'ROLLOUT VALIDATION FAILED!');
  END IF;

END;
/
