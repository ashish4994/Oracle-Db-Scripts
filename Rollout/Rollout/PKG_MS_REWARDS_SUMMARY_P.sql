CREATE OR REPLACE PACKAGE PKG_MS_REWARDS_SUMMARY_P IS

    /******************************************************************************
    *
    *  Title:       PKG_MS_REWARDS_SUMMARY_P
    *  Created:     04/29/2020
    *  Author:      CMENDOZA
    *
    *  Description: All procedures related to Rewards MS.
    *
    ******************************************************************************/

    /******************************************************************************
    *
    *  Title:       PR_GET_BY_CREDIT_ACCOUNT_ID
    *  Created:     04/29/2020
    *  Author:      CMENDOZA
    *
    *  Description: Return a Rewards SUMMARY matching the given CreditAcountId.
    ******************************************************************************/
    PROCEDURE PR_GET_BY_CREDIT_ACCOUNT_ID(p_credit_account_id IN T_REWARD_SUMMARY.CREDIT_ACCOUNT_ID%TYPE,
                                          cr_rewards_summary  OUT SYS_REFCURSOR);

    /******************************************************************************
      *
      *  Title:       PR_GET_REDEMPTIONS_BY_CREDIT_ACCOUNT_ID
      *  Created:     05/22/2020
      *  Author:      CMENDOZA
      *
      *  Description: Return a Rewards REDEMPTIONS matching the given CreditAcountId
    *  and filtered by a number of days.
      ******************************************************************************/
    PROCEDURE PR_GET_REDEMPTIONS_BY_CREDIT_ACCOUNT_ID(p_credit_account_id IN T_REWARD_SUMMARY.CREDIT_ACCOUNT_ID%TYPE,
                                                      p_number_days       NUMBER,
                                                      cr_redemptions      OUT SYS_REFCURSOR);

    /******************************************************************************
      *
      *  Title:       PR_GET_REWARDS_EARNED_BY_CREDIT_ACCOUNT_ID
      *  Created:     05/22/2020
      *  Author:      CMENDOZA
      *
      *  Description: Return a Rewards TRANSACTIONS matching the given CreditAcountId
    *  and filtered by a number of days.
      ******************************************************************************/
    PROCEDURE PR_GET_REWARDS_EARNED_BY_CREDIT_ACCOUNT_ID(p_credit_account_id IN T_REWARD_SUMMARY.CREDIT_ACCOUNT_ID%TYPE,
                                                         p_number_days       NUMBER,
                                                         cr_rewards_earned   OUT SYS_REFCURSOR);

    /******************************************************************************
    *
    *  Title:       PR_GET_CASH_REWARDS_EARNED_BY_CREDIT_ACCOUNT_ID
    *  Created:     08/04/2020
    *  Author:      YVARGAS
    *
    *  Description: Returns cash reward summary amounts for an account
    ******************************************************************************/
    PROCEDURE PR_GET_CASH_REWARDS_EARNED_BY_CREDIT_ACCOUNT_ID(p_credit_account_id    IN T_ACCOUNT_SUMMARY.CREDIT_ACCOUNT_ID%TYPE,
                                                              cr_cash_rewards_earned OUT SYS_REFCURSOR);

END PKG_MS_REWARDS_SUMMARY_P;

/

CREATE OR REPLACE PACKAGE BODY PKG_MS_REWARDS_SUMMARY_P IS

    /******************************************************************************
    *
    *  Title:       PKG_MS_REWARDS_SUMMARY_P
    *  Created:     04/29/2020
    *  Author:      CMENDOZA
    *
    *  Description: All procedures related to Rewards MS.
    *
    ******************************************************************************/

    /******************************************************************************
    *
    *  Title:       PR_GET_BY_CREDIT_ACCOUNT_ID
    *  Created:     04/29/2020
    *  Author:      CMENDOZA
    *
    *  Description: Return a Rewards SUMMARY matching the given CreditAcountId.
    ******************************************************************************/
    PROCEDURE PR_GET_BY_CREDIT_ACCOUNT_ID(p_credit_account_id IN T_REWARD_SUMMARY.CREDIT_ACCOUNT_ID%TYPE,
                                          cr_rewards_summary  OUT SYS_REFCURSOR) AS
    
    BEGIN
        OPEN cr_rewards_summary FOR
            SELECT rs.CREDIT_ACCOUNT_ID,
                   rs.PROGRAM_ID,
                   rs.PROGRAM_REG_DATE AS PROGRAM_ENROLLMENT_DATE,
                   rs.PROGRAM_TERM_DATE AS PROGRAM_UNENROLLMENT_DATE,
                   rp.PRODUCT_ID,
                   rp.PRODUCT_NAME,
                   rp.PRODUCT_DESC,
                   rp.BUCKET_ID,
                   rp.REDEMPTION_URL,
                   rp.RETURN_URL,
                   rp.IS_BASE_PRODUCT,
				   rpg.NAME as PRODUCT_GROUP_NAME                   
              FROM T_REWARD_SUMMARY rs
             INNER JOIN T_REWARDS_PRODUCT rp
                ON rs.PROGRAM_ID = rp.ID
			 INNER JOIN T_LU_REWARDS_PRODUCT_GROUP rpg
				ON rp.PRODUCT_GROUP_ID = rpg.ID
             WHERE rs.CREDIT_ACCOUNT_ID = p_credit_account_id  and rp.is_base_product = 1;
    END PR_GET_BY_CREDIT_ACCOUNT_ID;

    /******************************************************************************
      *
      *  Title:       PR_GET_REDEMPTIONS_BY_CREDIT_ACCOUNT_ID
      *  Created:     05/22/2020
      *  Author:      CMENDOZA
      *
      *  Description: Return a Rewards REDEMPTIONS matching the given CreditAcountId
    *  and filtered by a number of days.
      ******************************************************************************/
    PROCEDURE PR_GET_REDEMPTIONS_BY_CREDIT_ACCOUNT_ID(p_credit_account_id IN T_REWARD_SUMMARY.CREDIT_ACCOUNT_ID%TYPE,
                                                      p_number_days       NUMBER,
                                                      cr_redemptions      OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN cr_redemptions FOR
            SELECT rrh.REDEMPTION_HISTORY_ID AS REDEMPTION_ID,
                   rrh.PROGRAM_ID,
                   rrh.REDEMPTION_DATE       AS DATE_REDEEMED,
                   rrh.RECORD_TYPE           AS REDEMPTION_TYPE,
                   rrh.SUPPLIER_DESC         AS REDEMPTION_DESCRIPTION,
                   rrh.CATALOG_CATEGORY_NAME,
                   coalesce(sfi.PARK_NAME,null) as PARTNER_REDEMPTION_ITEM, --SixFlags, Wander
                   coalesce(sfic.CODE, null) AS ITEM_CODE, --SixFlags, Wander
                   DECODE(rrh.POINTS_REDEEMED_SIGN, '+', rrh.POINTS_REDEEMED, '-', -1 * rrh.POINTS_REDEEMED) AS POINTS_REDEEMED,
                   rrh.SUPPLIER_NAME,
                   rp.PRODUCT_ID,
                   rp.PRODUCT_NAME,
                   rp.PRODUCT_DESC,
                   rp.IS_BASE_PRODUCT,
				   rrh.EMAIL_SEND_DATE
              FROM T_REWARD_REDEMPTION_HISTORY rrh
              LEFT JOIN T_REWARDS_PRODUCT rp
                ON rrh.PROGRAM_ID = rp.ID
			  LEFT JOIN T_REWARDS_SIX_FLAGS_ITEM sfi
                ON sfi.id = rrh.partner_redemption_item_id and rrh.web_present_code = 'PLPCRD02' --SixFlags
              LEFT JOIN T_REWARDS_SIX_FLAGS_ITEM_CODE sfic
                ON sfic.ID = rrh.PARTNER_REDEMPTION_ITEM_CODE_ID and rrh.web_present_code = 'PLPCRD02' --SixFlags
             WHERE rrh.CREDIT_ACCOUNT_ID = p_credit_account_id AND
                   rrh.REDEMPTION_DATE >= (trunc(SYSDATE) - p_number_days)
				   ORDER BY DATE_REDEEMED DESC;
    END PR_GET_REDEMPTIONS_BY_CREDIT_ACCOUNT_ID;

    /******************************************************************************
      *
      *  Title:       PR_GET_REWARDS_EARNED_BY_CREDIT_ACCOUNT_ID
      *  Created:     05/22/2020
      *  Author:      CMENDOZA
      *
      *  Description: Return a Rewards TRANSACTIONS matching the given CreditAcountId
    *  and filtered by a number of days.
      ******************************************************************************/
    PROCEDURE PR_GET_REWARDS_EARNED_BY_CREDIT_ACCOUNT_ID(p_credit_account_id IN T_REWARD_SUMMARY.CREDIT_ACCOUNT_ID%TYPE,
                                                         p_number_days       NUMBER,
                                                         cr_rewards_earned   OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN cr_rewards_earned FOR
            SELECT rth.TRANSACTION_HISTORY_ID AS TRANSACTION_ID,
                   rth.PROGRAM_ID,
                   rth.TRANSACTION_DATE AS DATE_EARNED,
                   rth.MERCHANT_NAME,
                   coalesce(mc.mcc_desc, 'Other') AS EARNED_DESCRIPTION,
                   rth.TRANSACTION_AMOUNT,
                   DECODE(rth.REWARD_AMOUNT_SIGN, '+', rth.REWARD_AMOUNT, '-', -1 * rth.REWARD_AMOUNT) AS POINTS_EARNED,
                   rth.PROGRAM_NAME   AS PRODUCT_ID,
                   rp.PRODUCT_NAME,
                   rp.PRODUCT_DESC,
                   rp.IS_BASE_PRODUCT
              FROM T_REWARD_TRANSACTION_HISTORY rth
              LEFT JOIN T_REWARDS_PRODUCT rp
                ON rth.PROGRAM_ID = rp.ID
              LEFT JOIN T_REWARDS_MCC_CODE mc
                ON mc.mcc_code = rth.MCC_SIC_CODE
             WHERE rth.CREDIT_ACCOUNT_ID = p_credit_account_id AND
                   rth.TRANSACTION_DATE >= (trunc(SYSDATE) - p_number_days)
				   ORDER BY DATE_EARNED DESC;
    
    END PR_GET_REWARDS_EARNED_BY_CREDIT_ACCOUNT_ID;

    /******************************************************************************
    *
    *  Title:       PR_GET_CASH_REWARDS_EARNED_BY_CREDIT_ACCOUNT_ID
    *  Created:     08/04/2020
    *  Author:      YVARGAS
    *
    *  Description: Returns cash reward summary amounts for an account.
    ******************************************************************************/
    PROCEDURE PR_GET_CASH_REWARDS_EARNED_BY_CREDIT_ACCOUNT_ID(p_credit_account_id    IN T_ACCOUNT_SUMMARY.CREDIT_ACCOUNT_ID%TYPE,
                                                              cr_cash_rewards_earned OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN cr_cash_rewards_earned FOR
            SELECT T.CREDIT_ACCOUNT_ID,
                   T.REWARD_AMOUNT_TOTAL,
                   T.REWARD_AMOUNT_LAST12MON,
                   T.DATE_LAST_UPDATED
              FROM T_ACCOUNT_SUMMARY T
             WHERE T.CREDIT_ACCOUNT_ID = p_credit_account_id;
    
    END PR_GET_CASH_REWARDS_EARNED_BY_CREDIT_ACCOUNT_ID;

END PKG_MS_REWARDS_SUMMARY_P;
/