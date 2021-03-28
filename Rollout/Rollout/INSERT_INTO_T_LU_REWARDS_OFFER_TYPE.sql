/*
  Script:      INSERT_INTO_T_LU_REWARDS_OFFER_TYPE.sql
  Schema:      REWARD
  Author:      Favio Massarini
  Project:     MK-1050
  Date:        2021-02-05
  Purpose:     Insert look up values for Six Flags Offer Types
*/

DECLARE

  V_COUNT       NUMBER;
  V_NAME	VARCHAR2(50);
  V_CODE	VARCHAR2(20);

BEGIN  

  -- Set values
  V_NAME := '12 month membership';
  V_CODE := 'SIXFLAGS12MMEMB';

  -- Check if value already exists
  SELECT COUNT(1) INTO V_COUNT FROM T_LU_REWARDS_OFFER_TYPE WHERE TEMPLATE_TYPE_CODE = V_CODE;

  -- Insert value
  IF V_COUNT = 0 THEN
    INSERT INTO T_LU_REWARDS_OFFER_TYPE (ID, NAME, TEMPLATE_TYPE_CODE)
    VALUES (SEQ_LU_REWARDS_OFFER_TYPE.NEXTVAL, V_NAME, V_CODE);
  
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' CREATED SUCCESFULLY.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' ALREADY EXISTS. No data was changed.');
  END IF;

  -- Set values
  V_NAME := 'Season pass';
  V_CODE := 'SIXFLAGSSSNPASS';

  -- Check if value already exists
  SELECT COUNT(1) INTO V_COUNT FROM T_LU_REWARDS_OFFER_TYPE WHERE TEMPLATE_TYPE_CODE = V_CODE;

  -- Insert value
  IF V_COUNT = 0 THEN
    INSERT INTO T_LU_REWARDS_OFFER_TYPE (ID, NAME, TEMPLATE_TYPE_CODE)
    VALUES (SEQ_LU_REWARDS_OFFER_TYPE.NEXTVAL, V_NAME, V_CODE);
  
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' CREATED SUCCESFULLY.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' ALREADY EXISTS. No data was changed.');
  END IF;

  -- Set values
  V_NAME := 'Single day pass';
  V_CODE := 'SIXFLAGSDAYPASS';

  -- Check if value already exists
  SELECT COUNT(1) INTO V_COUNT FROM T_LU_REWARDS_OFFER_TYPE WHERE TEMPLATE_TYPE_CODE = V_CODE;

  -- Insert value
  IF V_COUNT = 0 THEN
    INSERT INTO T_LU_REWARDS_OFFER_TYPE (ID, NAME, TEMPLATE_TYPE_CODE)
    VALUES (SEQ_LU_REWARDS_OFFER_TYPE.NEXTVAL, V_NAME, V_CODE);
  
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' CREATED SUCCESFULLY.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' ALREADY EXISTS. No data was changed.');
  END IF;

  -- Set values
  V_NAME := 'Deluxe dining pass';
  V_CODE := 'SIXFLAGSDXDINEPASS';

  -- Check if value already exists
  SELECT COUNT(1) INTO V_COUNT FROM T_LU_REWARDS_OFFER_TYPE WHERE TEMPLATE_TYPE_CODE = V_CODE;

  -- Insert value
  IF V_COUNT = 0 THEN
    INSERT INTO T_LU_REWARDS_OFFER_TYPE (ID, NAME, TEMPLATE_TYPE_CODE)
    VALUES (SEQ_LU_REWARDS_OFFER_TYPE.NEXTVAL, V_NAME, V_CODE);
  
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' CREATED SUCCESFULLY.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' ALREADY EXISTS. No data was changed.');
  END IF;

  -- Set values
  V_NAME := 'Annual Dining pass';
  V_CODE := 'SIXFLAGSANDINEPASS';

  -- Check if value already exists
  SELECT COUNT(1) INTO V_COUNT FROM T_LU_REWARDS_OFFER_TYPE WHERE TEMPLATE_TYPE_CODE = V_CODE;

  -- Insert value
  IF V_COUNT = 0 THEN
    INSERT INTO T_LU_REWARDS_OFFER_TYPE (ID, NAME, TEMPLATE_TYPE_CODE)
    VALUES (SEQ_LU_REWARDS_OFFER_TYPE.NEXTVAL, V_NAME, V_CODE);
  
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' CREATED SUCCESFULLY.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' ALREADY EXISTS. No data was changed.');
  END IF;

  -- Set values
  V_NAME := 'All season drink bottle';
  V_CODE := 'SIXFLAGSSSNDRINK';

  -- Check if value already exists
  SELECT COUNT(1) INTO V_COUNT FROM T_LU_REWARDS_OFFER_TYPE WHERE TEMPLATE_TYPE_CODE = V_CODE;

  -- Insert value
  IF V_COUNT = 0 THEN
    INSERT INTO T_LU_REWARDS_OFFER_TYPE (ID, NAME, TEMPLATE_TYPE_CODE)
    VALUES (SEQ_LU_REWARDS_OFFER_TYPE.NEXTVAL, V_NAME, V_CODE);
  
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' CREATED SUCCESFULLY.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' ALREADY EXISTS. No data was changed.');
  END IF;

  -- Set values
  V_NAME := 'All day drink bottle';
  V_CODE := 'SIXFLAGSDAYDRINK';

  -- Check if value already exists
  SELECT COUNT(1) INTO V_COUNT FROM T_LU_REWARDS_OFFER_TYPE WHERE TEMPLATE_TYPE_CODE = V_CODE;

  -- Insert value
  IF V_COUNT = 0 THEN
    INSERT INTO T_LU_REWARDS_OFFER_TYPE (ID, NAME, TEMPLATE_TYPE_CODE)
    VALUES (SEQ_LU_REWARDS_OFFER_TYPE.NEXTVAL, V_NAME, V_CODE);
  
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' CREATED SUCCESFULLY.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' ALREADY EXISTS. No data was changed.');
  END IF;

  -- Set values
  V_NAME := 'One day dining deal';
  V_CODE := 'SIXFLAGSDAYDINE';

  -- Check if value already exists
  SELECT COUNT(1) INTO V_COUNT FROM T_LU_REWARDS_OFFER_TYPE WHERE TEMPLATE_TYPE_CODE = V_CODE;

  -- Insert value
  IF V_COUNT = 0 THEN
    INSERT INTO T_LU_REWARDS_OFFER_TYPE (ID, NAME, TEMPLATE_TYPE_CODE)
    VALUES (SEQ_LU_REWARDS_OFFER_TYPE.NEXTVAL, V_NAME, V_CODE);
  
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' CREATED SUCCESFULLY.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' ALREADY EXISTS. No data was changed.');
  END IF;

  -- Set values
  V_NAME := 'One day flash pass';
  V_CODE := 'SIXFLAGSDAYFLASH';

  -- Check if value already exists
  SELECT COUNT(1) INTO V_COUNT FROM T_LU_REWARDS_OFFER_TYPE WHERE TEMPLATE_TYPE_CODE = V_CODE;

  -- Insert value
  IF V_COUNT = 0 THEN
    INSERT INTO T_LU_REWARDS_OFFER_TYPE (ID, NAME, TEMPLATE_TYPE_CODE)
    VALUES (SEQ_LU_REWARDS_OFFER_TYPE.NEXTVAL, V_NAME, V_CODE);
  
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' CREATED SUCCESFULLY.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' ALREADY EXISTS. No data was changed.');
  END IF;

  -- Set values
  V_NAME := 'Parking voucher';
  V_CODE := 'SIXFLAGSPARKING';

  -- Check if value already exists
  SELECT COUNT(1) INTO V_COUNT FROM T_LU_REWARDS_OFFER_TYPE WHERE TEMPLATE_TYPE_CODE = V_CODE;

  -- Insert value
  IF V_COUNT = 0 THEN
    INSERT INTO T_LU_REWARDS_OFFER_TYPE (ID, NAME, TEMPLATE_TYPE_CODE)
    VALUES (SEQ_LU_REWARDS_OFFER_TYPE.NEXTVAL, V_NAME, V_CODE);
  
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' CREATED SUCCESFULLY.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Value ' || V_CODE || ' ALREADY EXISTS. No data was changed.');
  END IF;

  COMMIT;

END;
/
