/*
  Script:      700_DBAatOPS_MK1050_SYN_RO.sql
  Author:      Levi Tamiozzo
  Date:        2021-01-26
  Purpose:     Update pkg synonym.
*/

SET TERMOUT ON
SET ECHO OFF
SET LINESIZE 80
SET SERVEROUTPUT ON SIZE 10000
WHENEVER SQLERROR EXIT ROLLBACK
column filename new_val filename1 

SELECT SYS_CONTEXT('USERENV', 'INSTANCE_NAME')     filename
  FROM dual; 
  
spo 700_DBAatOPS_MK1050_SYN_RO_&filename1..log;

SELECT 'current user is ' || USER || ' at ' FROM dual;
 
SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

DROP PUBLIC SYNONYM PKG_MS_REWARDS_SUMMARY;

CREATE OR REPLACE EDITIONABLE PUBLIC SYNONYM PKG_MS_REWARDS_SUMMARY FOR REWARD.PKG_MS_REWARDS_SUMMARY_P;

CREATE OR REPLACE EDITIONABLE PUBLIC SYNONYM PKG_MS_REWARDS_SIX_FLAGS_ITEM FOR REWARD.PKG_MS_REWARDS_SIX_FLAGS_ITEM_P;

CREATE OR REPLACE EDITIONABLE PUBLIC SYNONYM PKG_MS_REWARDS_OFFER_TYPE FOR REWARD.PKG_MS_REWARDS_OFFER_TYPE_P;

SELECT TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS') date_ FROM dual;

sho ERRORS
spo OFF
