CREATE OR REPLACE PACKAGE PKG_MS_REWARDS_SIX_FLAGS_ITEM_P IS

	TYPE ARRAY_CODE_TYPE IS TABLE OF T_REWARDS_SIX_FLAGS_ITEM_CODE.CODE%TYPE INDEX BY PLS_INTEGER;

    /******************************************************************************
    *
    *  Title:       PKG_MS_REWARDS_SIX_FLAGS_ITEM_P
    *  Created:     22/01/2021
    *  Author:      LTAMIOZZO
    *
    *  Description: All procedures related to Rewards MS Six Flags Items.
    ******************************************************************************/

    /******************************************************************************
    *
    *  Title:       PR_GET
    *  Created:     22/01/2021
    *  Author:      LTAMIOZZO
    *
    *  Description: Return active/all Six Flags Items.
    ******************************************************************************/
    PROCEDURE PR_GET(P_INCLUDE_INACTIVE IN NUMBER DEFAULT 0,
					 CR_SIX_FLAGS_ITEMS OUT SYS_REFCURSOR);

    /******************************************************************************
    *
    *  Title:       PR_GET_BY_ID
    *  Created:     22/01/2021
    *  Author:      LTAMIOZZO
    *
    *  Description: Return a Six Flags Item matching the given Id.
    ******************************************************************************/
    PROCEDURE PR_GET_BY_ID(P_ID            		IN T_REWARDS_SIX_FLAGS_ITEM.ID%TYPE,
                           CR_SIX_FLAGS_ITEMS	OUT SYS_REFCURSOR);
						   
	/******************************************************************************
    *
    *  Title:       PR_GET_BY_ITEM_ID
    *  Created:     22/01/2021
    *  Author:      LTAMIOZZO
    *
    *  Description: Return a Six Flags Item matching the given item id.
    ******************************************************************************/
    PROCEDURE PR_GET_BY_ITEM_ID(P_ITEM_ID    		IN T_REWARDS_SIX_FLAGS_ITEM.ITEM_ID%TYPE,
								CR_SIX_FLAGS_ITEMS 	OUT SYS_REFCURSOR);

    /******************************************************************************
    *
    *  Title:       PR_INSERT
    *  Created:     22/01/2021
    *  Author:      LTAMIOZZO
    *
    *  Description: Inserts a new Six Flags Item.
    ******************************************************************************/
    PROCEDURE PR_INSERT(P_ITEM_ID				IN T_REWARDS_SIX_FLAGS_ITEM.ITEM_ID%TYPE,                        
						P_OFFER_NAME			IN T_REWARDS_SIX_FLAGS_ITEM.OFFER_NAME%TYPE,
						P_PARK_NAME				IN T_REWARDS_SIX_FLAGS_ITEM.PARK_NAME%TYPE, 
						P_LOW_VOLUME_THRESHOLD	IN T_REWARDS_SIX_FLAGS_ITEM.LOW_VOLUME_THRESHOLD%TYPE, 
						P_IS_ACTIVE				IN T_REWARDS_SIX_FLAGS_ITEM.IS_ACTIVE%TYPE, 
						P_OFFER_TYPE_ID    		IN T_LU_REWARDS_OFFER_TYPE.id%TYPE,
                        P_ID    				OUT T_REWARDS_SIX_FLAGS_ITEM.ID%TYPE);

    /******************************************************************************
    *
    *  Title:       PR_UPDATE
    *  Created:     22/01/2021
    *  Author:      LTAMIOZZO
    *
    *  Description: Updates a Six Flags Item.
    ******************************************************************************/					
	PROCEDURE PR_UPDATE(P_ID    				IN T_REWARDS_SIX_FLAGS_ITEM.ID%TYPE,   
						P_ITEM_ID				IN T_REWARDS_SIX_FLAGS_ITEM.ITEM_ID%TYPE,                        	
						P_OFFER_NAME			IN T_REWARDS_SIX_FLAGS_ITEM.OFFER_NAME%TYPE,
						P_PARK_NAME				IN T_REWARDS_SIX_FLAGS_ITEM.PARK_NAME%TYPE, 
						P_LOW_VOLUME_THRESHOLD	IN T_REWARDS_SIX_FLAGS_ITEM.LOW_VOLUME_THRESHOLD%TYPE, 
						P_IS_ACTIVE				IN T_REWARDS_SIX_FLAGS_ITEM.IS_ACTIVE%TYPE,
						P_OFFER_TYPE_ID    		IN T_LU_REWARDS_OFFER_TYPE.id%TYPE);
	
	/******************************************************************************
    *
    *  Title:       PR_DELETE
    *  Created:     22/01/2021
    *  Author:      LTAMIOZZO
    *
    *  Description: Deletes a Six Flags Item matching the given Id.
    ******************************************************************************/
    PROCEDURE PR_DELETE(P_ID IN T_REWARDS_SIX_FLAGS_ITEM.ID%TYPE);
	
	    /******************************************************************************
    *
    *  Title:       PR_INSERT_CODES
    *  Created:     22/01/2021
    *  Author:      LTAMIOZZO
    *
    *  Description: Insert codes for a Six Flags Item.
    ******************************************************************************/	
    PROCEDURE PR_INSERT_CODES(P_ID 					IN T_REWARDS_SIX_FLAGS_ITEM.ID%TYPE,
							  P_CODES				IN ARRAY_CODE_TYPE,
							  CR_SIX_FLAGS_ITEMS 	OUT SYS_REFCURSOR);
	
	/******************************************************************************
    *
    *  Title:       PR_GET_CODES_BY_ITEM_ID
    *  Created:     25/01/2021
    *  Author:      LTAMIOZZO
    *
    *  Description: Return a list of codes for a Six Flags Item matching the given id.
    ******************************************************************************/
    PROCEDURE PR_GET_CODES_BY_ITEM_ID(P_ID    			IN T_REWARDS_SIX_FLAGS_ITEM.ID%TYPE,
									  CR_SIX_FLAGS_ITEMS 	OUT SYS_REFCURSOR);
								
END PKG_MS_REWARDS_SIX_FLAGS_ITEM_P;
/

CREATE OR REPLACE PACKAGE BODY PKG_MS_REWARDS_SIX_FLAGS_ITEM_P IS

    /******************************************************************************
    *
    *  Title:       PKG_MS_REWARDS_SIX_FLAGS_ITEM_P
    *  Created:     22/01/2021
    *  Author:      LTAMIOZZO
    *
    *  Description: All procedures related to Rewards MS Six Flags Items.
    ******************************************************************************/

    /******************************************************************************
    *
    *  Title:       PR_GET
    *  Created:     22/01/2021
    *  Author:      LTAMIOZZO
    *
    *  Description: Return active/all Six Flags Items.
    ******************************************************************************/
        PROCEDURE PR_GET(P_INCLUDE_INACTIVE IN NUMBER DEFAULT 0,
						 CR_SIX_FLAGS_ITEMS OUT SYS_REFCURSOR) AS

    BEGIN

        OPEN CR_SIX_FLAGS_ITEMS FOR

            SELECT SFI.*,
				  (SELECT COUNT(1)
					 FROM T_REWARDS_SIX_FLAGS_ITEM_CODE SFIC
					WHERE SFIC.SIX_FLAGS_ITEM_ID = SFI.ID
					  AND SFIC.USED_DATE IS NULL) AS CURRENT_AVAILABLE_CODES,
					rot.NAME as OFFER_TYPE_NAME
              FROM T_REWARDS_SIX_FLAGS_ITEM SFI,
					T_LU_REWARDS_OFFER_TYPE rot
			  WHERE rot.ID = SFI.OFFER_TYPE_ID
			    AND	(P_INCLUDE_INACTIVE = 1 OR SFI.IS_ACTIVE = 1);

    END PR_GET;

    /******************************************************************************
    *
    *  Title:       PR_GET_BY_ID
    *  Created:     22/01/2021
    *  Author:      LTAMIOZZO
    *
    *  Description: Return a Six Flags Item matching the given Id.
    ******************************************************************************/
    PROCEDURE PR_GET_BY_ID(P_ID            		IN T_REWARDS_SIX_FLAGS_ITEM.ID%TYPE,
                           CR_SIX_FLAGS_ITEMS	OUT SYS_REFCURSOR) AS

    BEGIN
        OPEN CR_SIX_FLAGS_ITEMS FOR

            SELECT SFI.*,
				  (SELECT COUNT(1)
					 FROM T_REWARDS_SIX_FLAGS_ITEM_CODE SFIC
					WHERE SFIC.SIX_FLAGS_ITEM_ID = SFI.ID
					  AND SFIC.USED_DATE IS NULL) AS CURRENT_AVAILABLE_CODES,
					  rot.NAME as OFFER_TYPE_NAME
              FROM T_REWARDS_SIX_FLAGS_ITEM SFI,
					T_LU_REWARDS_OFFER_TYPE rot
			  WHERE rot.ID = SFI.OFFER_TYPE_ID and SFI.ID = P_ID;

    END PR_GET_BY_ID;

	/******************************************************************************
    *
    *  Title:       PR_GET_BY_ITEM_ID
    *  Created:     22/01/2021
    *  Author:      LTAMIOZZO
    *
    *  Description: Return a Six Flags Item matching the given ItemID.
    ******************************************************************************/
    PROCEDURE PR_GET_BY_ITEM_ID(P_ITEM_ID   		IN T_REWARDS_SIX_FLAGS_ITEM.ITEM_ID%TYPE,
								CR_SIX_FLAGS_ITEMS  OUT SYS_REFCURSOR) AS

    BEGIN
        OPEN CR_SIX_FLAGS_ITEMS FOR

            SELECT SFI.*,
				  (SELECT COUNT(1)
					 FROM T_REWARDS_SIX_FLAGS_ITEM_CODE SFIC
					WHERE SFIC.SIX_FLAGS_ITEM_ID = SFI.ID
					  AND SFIC.USED_DATE IS NULL) AS CURRENT_AVAILABLE_CODES,
					  rot.NAME as OFFER_TYPE_NAME
             FROM T_REWARDS_SIX_FLAGS_ITEM SFI,
					T_LU_REWARDS_OFFER_TYPE rot
			  WHERE rot.ID = SFI.OFFER_TYPE_ID and SFI.ITEM_ID = P_ITEM_ID;

    END PR_GET_BY_ITEM_ID;

    /******************************************************************************
    *
    *  Title:       PR_INSERT
    *  Created:     22/01/2021
    *  Author:      LTAMIOZZO
    *
    *  Description: Inserts a new Six Flags Item.
    ******************************************************************************/
    PROCEDURE PR_INSERT(P_ITEM_ID				IN T_REWARDS_SIX_FLAGS_ITEM.ITEM_ID%TYPE,
						P_OFFER_NAME			IN T_REWARDS_SIX_FLAGS_ITEM.OFFER_NAME%TYPE,
						P_PARK_NAME				IN T_REWARDS_SIX_FLAGS_ITEM.PARK_NAME%TYPE,
						P_LOW_VOLUME_THRESHOLD	IN T_REWARDS_SIX_FLAGS_ITEM.LOW_VOLUME_THRESHOLD%TYPE,
						P_IS_ACTIVE				IN T_REWARDS_SIX_FLAGS_ITEM.IS_ACTIVE%TYPE,
						P_OFFER_TYPE_ID    		IN T_LU_REWARDS_OFFER_TYPE.id%TYPE,
                        P_ID    				OUT T_REWARDS_SIX_FLAGS_ITEM.ID%TYPE) AS

    BEGIN

        INSERT INTO T_REWARDS_SIX_FLAGS_ITEM
            (ID,
             ITEM_ID,
			 OFFER_NAME,
			 PARK_NAME,
			 LOW_VOLUME_THRESHOLD,
			 OFFER_TYPE_ID,
			 IS_ACTIVE,
			 STATUS_CHANGED_DATE)
        VALUES
            (SEQ_REWARDS_SIX_FLAGS_ITEM.NEXTVAL,
			 P_ITEM_ID,
			 P_OFFER_NAME,
             P_PARK_NAME,
			 P_LOW_VOLUME_THRESHOLD,
			 P_OFFER_TYPE_ID,
			 P_IS_ACTIVE,
			 SYSDATE)

        RETURNING ID INTO P_ID;

        COMMIT;

    END PR_INSERT;

    /******************************************************************************
    *
    *  Title:       PR_UPDATE
    *  Created:     22/01/2021
    *  Author:      LTAMIOZZO
    *
    *  Description: Updates a Six Flags Item.
    *
    ******************************************************************************/
    PROCEDURE PR_UPDATE(P_ID            IN T_REWARDS_SIX_FLAGS_ITEM.ID%TYPE,
            P_ITEM_ID       IN T_REWARDS_SIX_FLAGS_ITEM.ITEM_ID%TYPE,
            P_OFFER_NAME      IN T_REWARDS_SIX_FLAGS_ITEM.OFFER_NAME%TYPE,
            P_PARK_NAME       IN T_REWARDS_SIX_FLAGS_ITEM.PARK_NAME%TYPE,
            P_LOW_VOLUME_THRESHOLD  IN T_REWARDS_SIX_FLAGS_ITEM.LOW_VOLUME_THRESHOLD%TYPE,
            P_IS_ACTIVE       IN T_REWARDS_SIX_FLAGS_ITEM.IS_ACTIVE%TYPE,
            P_OFFER_TYPE_ID       IN T_LU_REWARDS_OFFER_TYPE.id%TYPE) AS
     V_IS_ACTIVE number(1);
     V_STATUS_CHANGED_DATE DATE;
    BEGIN
        SELECT IS_ACTIVE, STATUS_CHANGED_DATE
        INTO V_IS_ACTIVE, V_STATUS_CHANGED_DATE
        FROM T_REWARDS_SIX_FLAGS_ITEM
        WHERE ID = P_ID;

        IF (V_IS_ACTIVE <> P_IS_ACTIVE) THEN
          V_STATUS_CHANGED_DATE:= SYSDATE;
        END IF;

        UPDATE T_REWARDS_SIX_FLAGS_ITEM SFI
           SET SFI.ITEM_ID = P_ITEM_ID,
         SFI.OFFER_NAME = P_OFFER_NAME,
         SFI.PARK_NAME = P_PARK_NAME,
         SFI.LOW_VOLUME_THRESHOLD = P_LOW_VOLUME_THRESHOLD,
         SFI.IS_ACTIVE = P_IS_ACTIVE,
         SFI.OFFER_TYPE_ID = P_OFFER_TYPE_ID,
         SFI.STATUS_CHANGED_DATE = V_STATUS_CHANGED_DATE
         WHERE SFI.ID = P_ID;

    COMMIT;

    END PR_UPDATE;

    /******************************************************************************
    *
    *  Title:       PR_DELETE
    *  Created:     22/01/2021
    *  Author:      LTAMIOZZO
    *
    *  Description: Deletes a Six Flags Item matching the given Id.
    ******************************************************************************/
    PROCEDURE PR_DELETE(P_ID IN T_REWARDS_SIX_FLAGS_ITEM.ID%TYPE) AS

    BEGIN

        DELETE FROM T_REWARDS_SIX_FLAGS_ITEM_CODE SFIC
				 WHERE SFIC.SIX_FLAGS_ITEM_ID = P_ID AND SFIC.USED_DATE IS NULL;

        DELETE FROM T_REWARDS_SIX_FLAGS_ITEM SFI
         WHERE SFI.Id = P_ID;

		COMMIT;

    END PR_DELETE;

	/******************************************************************************
    *
    *  Title:       PR_INSERT_CODES
    *  Created:     22/01/2021
    *  Author:      LTAMIOZZO
    *
    *  Description: Insert codes for a Six Flags Item.
    ******************************************************************************/
    PROCEDURE PR_INSERT_CODES(P_ID 					IN T_REWARDS_SIX_FLAGS_ITEM.ID%TYPE,
							  P_CODES				IN ARRAY_CODE_TYPE,
							  CR_SIX_FLAGS_ITEMS 	OUT SYS_REFCURSOR) AS

    BEGIN

		FORALL i IN P_CODES.FIRST..P_CODES.LAST
			INSERT INTO T_REWARDS_SIX_FLAGS_ITEM_CODE
				(ID,
				 SIX_FLAGS_ITEM_ID,
				 CODE,
				 CREATED_DATE,
				 USED_DATE,
				 STATUS_CHANGED_DATE)
			VALUES
				(SEQ_REWARDS_SIX_FLAGS_ITEM_CODE.NEXTVAL,
				 P_ID,
				 P_CODES(i),
				 SYSDATE,
				 NULL,
				 SYSDATE);

		COMMIT;

		OPEN CR_SIX_FLAGS_ITEMS FOR

            SELECT SFI.*,
				  (SELECT COUNT(1)
					 FROM T_REWARDS_SIX_FLAGS_ITEM_CODE SFIC
					WHERE SFIC.SIX_FLAGS_ITEM_ID = SFI.ID
					  AND SFIC.USED_DATE IS NULL) AS CURRENT_AVAILABLE_CODES,
            rot.NAME as OFFER_TYPE_NAME
              FROM T_REWARDS_SIX_FLAGS_ITEM SFI,
              T_LU_REWARDS_OFFER_TYPE rot
			  WHERE rot.ID = SFI.OFFER_TYPE_ID
             and SFI.ID = P_ID;

    END PR_INSERT_CODES;

	/******************************************************************************
    *
    *  Title:       PR_GET_CODES_BY_ITEM_ID
    *  Created:     25/01/2021
    *  Author:      LTAMIOZZO
    *
    *  Description: Return a list of codes for a Six Flags Item matching the given id.
    ******************************************************************************/
    PROCEDURE PR_GET_CODES_BY_ITEM_ID(P_ID   				IN T_REWARDS_SIX_FLAGS_ITEM.ID%TYPE,
									  CR_SIX_FLAGS_ITEMS  OUT SYS_REFCURSOR) AS

    BEGIN
        OPEN CR_SIX_FLAGS_ITEMS FOR

            SELECT SFIC.CODE
              FROM T_REWARDS_SIX_FLAGS_ITEM_CODE SFIC
             WHERE SFIC.SIX_FLAGS_ITEM_ID = P_ID;

    END PR_GET_CODES_BY_ITEM_ID;

END PKG_MS_REWARDS_SIX_FLAGS_ITEM_P;
/
