/* Create Table */

CREATE TABLE  T_REWARDS_SIX_FLAGS_ITEM_CODE
(
  ID        		NUMBER    CONSTRAINT NN_REW_SIX_FLAGS_ITEM_CODE_ID  			NOT NULL,
  SIX_FLAGS_ITEM_ID	NUMBER	CONSTRAINT NN_REW_SIX_FLAGS_ITEM_CODE_ITEM_ID  		NOT NULL,
  CODE				VARCHAR2(20)  	CONSTRAINT NN_REW_SIX_FLAGS_ITEM_CODE_CODE			NOT NULL,
  CREATED_DATE      DATE	CONSTRAINT NN_REW_SIX_FLAGS_CREATED_DATE    NOT NULL,
  USED_DATE			DATE	NULL,
  STATUS_CHANGED_DATE		DATE
)
TABLESPACE REWARD_D;
;

/* Create Primary Keys, Indexes, Uniques, Checks, Triggers */

CREATE INDEX IX_RSFIC_STATUS_CHANGE_DATE ON T_REWARDS_SIX_FLAGS_ITEM_CODE
(TRUNC(STATUS_CHANGED_DATE)) TABLESPACE REWARD_I;

ALTER TABLE T_REWARDS_SIX_FLAGS_ITEM_CODE 
  ADD CONSTRAINT PK_T_REWARDS_SIX_FLAGS_ITEM_CODE
  PRIMARY KEY
  (ID);
  
ALTER TABLE T_REWARDS_SIX_FLAGS_ITEM_CODE
  ADD CONSTRAINT FK_T_RWRD_SIX_FLAGS_ITEM_CODE_T_RWRD_SIX_FLAGS_ITEM
	FOREIGN KEY (SIX_FLAGS_ITEM_ID) REFERENCES T_REWARDS_SIX_FLAGS_ITEM (ID);

ALTER TABLE T_REWARDS_SIX_FLAGS_ITEM_CODE
	ADD CONSTRAINT SIX_FLAGS_ITEM_CODE_CODE_UNIQUE UNIQUE (CODE);	
