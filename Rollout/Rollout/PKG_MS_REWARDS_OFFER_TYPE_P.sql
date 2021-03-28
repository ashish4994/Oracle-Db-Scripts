CREATE OR REPLACE PACKAGE PKG_MS_REWARDS_OFFER_TYPE_P IS

    /******************************************************************************
    *
    *  Title:       PKG_MS_REWARDS_OFFER_TYPE_P
    *  Created:     02/04/2021
    *  Author:      CMENDOZA
    *
    *  Description: All procedures related to Rewards MS Offer Types.
    *
    ******************************************************************************/

    /******************************************************************************
    *
    *  Title:       PR_GET
    *  Created:     02/04/2021
    *  Author:      CMENDOZA
    *
    *  Description: Return all Rewards Offer Types.
    ******************************************************************************/
    PROCEDURE PR_GET(cr_offer_types OUT SYS_REFCURSOR);

    /******************************************************************************
    *
    *  Title:       PR_GET_BY_ID
    *  Created:     02/04/2021
    *  Author:      CMENDOZA
    *
    *  Description: Return a Rewards Offer Type matching the given Id.
    ******************************************************************************/
    PROCEDURE PR_GET_BY_ID(p_id            			IN T_LU_REWARDS_OFFER_TYPE.id%TYPE,
                           cr_offer_types	OUT SYS_REFCURSOR);

	/******************************************************************************
    *
    *  Title:       PR_GET_BY_NAME
    *  Created:     02/04/2021
    *  Author:      CMENDOZA
    *
    *  Description: Return a Rewards Offer Type matching the given name.
    ******************************************************************************/
    PROCEDURE PR_GET_BY_NAME(p_name    			IN T_LU_REWARDS_OFFER_TYPE.name%TYPE,
                             cr_offer_types 	OUT SYS_REFCURSOR);

    /******************************************************************************
    *
    *  Title:       PR_INSERT
    *  Created:     02/04/2021
    *  Author:      CMENDOZA
    *
    *  Description: Inserts a new Rewards Offer Type.
    *
    ******************************************************************************/
    PROCEDURE PR_INSERT(p_name	IN T_LU_REWARDS_OFFER_TYPE.name%TYPE,
      p_template_type_code    IN T_LU_REWARDS_OFFER_TYPE.template_type_code%TYPE,
                        p_id    OUT T_LU_REWARDS_OFFER_TYPE.id%TYPE);

    /******************************************************************************
    *
    *  Title:       PR_UPDATE
    *  Created:     02/04/2021
    *  Author:      CMENDOZA
    *
    *  Description: Updates a Rewards Offer Type.
    *
    ******************************************************************************/
    PROCEDURE PR_UPDATE(p_id    IN T_LU_REWARDS_OFFER_TYPE.id%TYPE,
                        p_name	IN T_LU_REWARDS_OFFER_TYPE.name%TYPE,
                        p_template_type_code    IN T_LU_REWARDS_OFFER_TYPE.template_type_code%TYPE);

    /******************************************************************************
    *
    *  Title:       PR_DELETE
    *  Created:     02/04/2021
    *  Author:      CMENDOZA
    *
    *  Description: Deletes a Rewards Offer Type matching the given Id.
    ******************************************************************************/
    PROCEDURE PR_DELETE(p_id IN T_LU_REWARDS_OFFER_TYPE.id%TYPE);

END PKG_MS_REWARDS_OFFER_TYPE_P;
/
CREATE OR REPLACE PACKAGE BODY PKG_MS_REWARDS_OFFER_TYPE_P IS

    /******************************************************************************
    *
    *  Title:       PKG_MS_REWARDS_OFFER_TYPE_P
    *  Created:     02/04/2021
    *  Author:      CMENDOZA
    *
    *  Description: All procedures related to Rewards MS Offer Types.
    *
    ******************************************************************************/

    /******************************************************************************
    *
    *  Title:       PR_GET
    *  Created:     02/04/2021
    *  Author:      CMENDOZA
    *
    *  Description: Return all Rewards Offer Types.
    ******************************************************************************/
    PROCEDURE PR_GET(cr_offer_types OUT SYS_REFCURSOR) AS

    BEGIN
        OPEN cr_offer_types FOR

            SELECT rpg.*
              FROM T_LU_REWARDS_OFFER_TYPE rpg;
    END PR_GET;

    /******************************************************************************
    *
    *  Title:       PR_GET_BY_ID
    *  Created:     02/04/2021
    *  Author:      CMENDOZA
    *
    *  Description: Return a Rewards Offer Type matching the given Id.
    ******************************************************************************/
    PROCEDURE PR_GET_BY_ID(p_id            		IN T_LU_REWARDS_OFFER_TYPE.id%TYPE,
                           cr_offer_types	OUT SYS_REFCURSOR) AS

    BEGIN
        OPEN cr_offer_types FOR

            SELECT rpg.*
              FROM T_LU_REWARDS_OFFER_TYPE rpg
             WHERE rpg.ID = p_id;
    END PR_GET_BY_ID;

	/******************************************************************************
    *
    *  Title:       PR_GET_BY_NAME
    *  Created:     02/04/2021
    *  Author:      CMENDOZA
    *
    *  Description: Return a Rewards Offer Type matching the given Offer Type Name.
    ******************************************************************************/
    PROCEDURE PR_GET_BY_NAME(p_name   			IN T_LU_REWARDS_OFFER_TYPE.name%TYPE,
                             cr_offer_types  OUT SYS_REFCURSOR) AS

    BEGIN
        OPEN cr_offer_types FOR

            SELECT rpg.*
              FROM T_LU_REWARDS_OFFER_TYPE rpg
             WHERE rpg.name = p_name;
    END PR_GET_BY_NAME;

    /******************************************************************************
    *
    *  Title:       PR_INSERT
    *  Created:     02/04/2021
    *  Author:      CMENDOZA
    *
    *  Description: Inserts a new Rewards Offer Type.
    *
    ******************************************************************************/
    PROCEDURE PR_INSERT(p_name	IN T_LU_REWARDS_OFFER_TYPE.name%TYPE,
      						p_template_type_code    IN T_LU_REWARDS_OFFER_TYPE.template_type_code%TYPE,
                        p_id    OUT T_LU_REWARDS_OFFER_TYPE.id%TYPE
) IS

    BEGIN

        INSERT INTO T_LU_REWARDS_OFFER_TYPE
            (id,
             name,
			 template_type_code)
        VALUES
            (SEQ_LU_REWARDS_OFFER_TYPE.nextval,
             p_name,
			 p_template_type_code)

        RETURNING id INTO p_id;

        COMMIT;
    END PR_INSERT;

    /******************************************************************************
    *
    *  Title:       PR_UPDATE
    *  Created:     02/04/2021
    *  Author:      CMENDOZA
    *
    *  Description: Updates a Rewards Offer Type.
    *
    ******************************************************************************/
    PROCEDURE PR_UPDATE(p_id      IN T_LU_REWARDS_OFFER_TYPE.id%TYPE,
                        p_name    IN T_LU_REWARDS_OFFER_TYPE.name%TYPE,
						p_template_type_code    IN T_LU_REWARDS_OFFER_TYPE.template_type_code%TYPE) IS

    BEGIN
        UPDATE T_LU_REWARDS_OFFER_TYPE rpg
           SET rpg.name = p_name, template_type_code = p_template_type_code
         WHERE rpg.id = p_id;
        COMMIT;

    END PR_UPDATE;

    /******************************************************************************
    *
    *  Title:       PR_DELETE
    *  Created:     02/04/2021
    *  Author:      CMENDOZA
    *
    *  Description: Deletes a Rewards Offer Type matching the given Id.
    ******************************************************************************/
    PROCEDURE PR_DELETE(p_id IN T_LU_REWARDS_OFFER_TYPE.id%TYPE) AS

    BEGIN
        DELETE FROM T_LU_REWARDS_OFFER_TYPE rpg
         WHERE rpg.Id = p_id;
        COMMIT;
    END PR_DELETE;

END PKG_MS_REWARDS_OFFER_TYPE_P;
/
