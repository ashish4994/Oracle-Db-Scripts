/*
  Script:      100_REWARDatOPS_MK1050_DDL_RB.sql
  Author:      Levi Tamiozzo
  Date:        01/26/2021
  Purpose:     Drop table 		T_REWARDS_SIX_FLAGS_ITEM. 
			   Drop sequence 	SEQ_REWARDS_SIX_FLAGS_ITEM.
			   
			   Drop table 		T_REWARDS_SIX_FLAGS_ITEM_CODE. 
			   Drop sequence 	SEQ_REWARDS_SIX_FLAGS_ITEM_CODE.
			   
			   Remove new columns 	T_REWARD_REDEMPTION_HISTORY. 
			   Remove new columns 	T_RWRD_REDEMPTION_PENDING.
*/

SET TERMOUT ON
SET ECHO Off
spool off

SET LINESIZE 80

SET SERVEROUTPUT ON SIZE 10000
WHENEVER SQLERROR EXIT ROLLBACK
column filename new_val filename1 
COLUMN script_name new_val _script_name

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME')     filename
  FROM dual; 
  
spool  100_REWARDatOPS_MK1050_DDL_RB_&filename1..log

ALTER SESSION SET CURRENT_SCHEMA = REWARD;
ALTER SESSION SET EDITION = ORA$BASE;
 
SELECT 'current user is ' || USER || ' at '
  FROM dual;

SELECT TO_CHAR(SYSDATE, 'DD-Mon-YYYY HH24:MI:SS') date_
  FROM dual;
  
@ALTER_T_REWARD_REDEMPTION_HISTORY_RB.sql
sho ERRORS;

@ALTER_T_RWRD_REDEMPTION_PENDING_RB.sql
sho ERRORS;

@T_REWARDS_SIX_FLAGS_ITEM_CODE_RB.sql
sho ERRORS;

@SEQ_REWARDS_SIX_FLAGS_ITEM_CODE_RB.sql
sho ERRORS;

@T_REWARDS_SIX_FLAGS_ITEM_RB.sql
sho ERRORS;

@SEQ_REWARDS_SIX_FLAGS_ITEM_RB.sql
sho ERRORS;

@T_LU_REWARDS_OFFER_TYPE_RB.sql
sho ERRORS;

@SEQ_LU_REWARDS_OFFER_TYPE_RB.sql
sho ERRORS;

SELECT TO_CHAR(SYSDATE, 'DD-Mon-YYYY HH24:MI:SS') date_
  FROM dual;

sho ERRORS 
spo OFF
/

 

 
