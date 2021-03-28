CREATE OR REPLACE PACKAGE PKG_FDR_REWARDS_STAGING_P AS

    v_email_to            VARCHAR2(50) := 'FDR_Team@creditone.com';
    v_prod_email_subject  VARCHAR2(50) := 'Missing BMA program codes';
    v_cards_email_subject VARCHAR2(50) := 'Pending Card Numbers';
    v_accts_email_subject VARCHAR2(50) := 'Redemptions to review';
    v_email_from          VARCHAR2(50) := 'email.notifications@creditone.com';
    v_amex_FirstDigits   VARCHAR2(2) := '37';

    /******************************************************************************
    *
    *  Title:        PKG_FDR_REWARDS_STAGING
    *  Schema Owner: ODS_STG
    *  Created:      March 27, 2020  07:19:15
    *  Author:       CMENDOZA
    *
    *  Description: This package is designed to facilate FDR file processing.
    *               It will extract data from External table and insert processed
    *               data into staging tables.
    *
    * Procedures:
    *
    * Modifications:
    *
    *    DATE        WHO                DESCRIPTION
    *
    ******************************************************************************/


    /******************************************************************************
    *
    *  Title:        PKG_FDR_REWARDS_STAGING_P.STAGE_REWARD_MSTR
    *  Schema Owner: ODS_STG
    *  Created:      March 27, 2020  07:19:15
    *  Author:       CMENDOZA
    *
    *  Description: Loads T_REWARD_SUMMARY from master file external tables
    *
    *  Modifications:
    *
    *    DATE        WHO                DESCRIPTION
    *
    ******************************************************************************/
    PROCEDURE STAGE_REWARD_MSTR(v_post_date    IN DATE DEFAULT TRUNC(SYSDATE - 1),
                                filename       IN VARCHAR2,
                                process_status OUT NUMBER);

    /******************************************************************************
    *
    *  Title:        PKG_FDR_REWARDS_STAGING_P.STAGE_REWARD_REDEMPTION
    *  Schema Owner: ODS_STG
    *  Created:      March 27, 2020  07:19:15
    *  Author:       CMENDOZA
    *
    *  Description: Loads T_REWARD_REDEMPTION_HISTORY from redemption file external tables
    *
    *  Modifications:
    *
    *    DATE        WHO                DESCRIPTION
    *
    ******************************************************************************/
    PROCEDURE STAGE_REWARD_REDEMPTION(v_post_date    IN DATE DEFAULT TRUNC(SYSDATE - 1),
                                      filename       IN VARCHAR2,
                                      process_status OUT NUMBER);

    /******************************************************************************
    *
    *  Title:        PKG_FDR_REWARDS_STAGING_P.STAGE_REWARD_TRANSACTION
    *  Schema Owner: ODS_STG
    *  Created:      March 27, 2020  07:19:15
    *  Author:       CMENDOZA
    *  Author:       CMENDOZA
    *
    *  Description: Loads T_REWARD_TRANSACTION_HISTORY from transaction file external tables
    *
    *  Modifications:
    *
    *    DATE        WHO                DESCRIPTION
    *
    ******************************************************************************/
    PROCEDURE STAGE_REWARD_TRANSACTION(v_post_date    IN DATE DEFAULT TRUNC(SYSDATE - 1),
                                       filename       IN VARCHAR2,
                                       process_status OUT NUMBER);

END;

/

CREATE OR REPLACE PACKAGE BODY PKG_FDR_REWARDS_STAGING_P AS

	/******************************************************************************
    *
    *  Title:       PKG_FDR_REWARDS_STAGING_P.log_update
    *  Created:     July 01, 2011  16:01:25
    *  Author:     Arun Asokan
    *
    *  Description: updates process log
    *  Modifications:
    *
    *    DATE        WHO                DESCRIPTION
    *  6/1/11     AASOKAN           Initial procedure
    ******************************************************************************/
    PROCEDURE log_update(v_process_name IN chd_process_log.process_name%TYPE,
                         v_post_date    IN chd_process_log.process_date%TYPE,
                         v_rcnt         IN chd_process_log.rowcnt%TYPE,
                         v_msg          IN chd_process_log.msg%TYPE,
                         v_status       IN chd_process_log.status%TYPE) IS
    BEGIN
        UPDATE chd_process_log
           SET status = v_status,
               rowcnt = v_rcnt,
               msg    = v_msg
         WHERE status = 'RUNNING' AND process_name = v_process_name AND
               process_date = v_post_date;
    END log_update;

    /******************************************************************************
        *
        *  Title:       PKG_FDR_REWARDS_STAGING_P.fdr_notification
        *  Created:     07/03/2020
        *  Author:     cmendoza
        *
        *  Description: alert fdr team by sending email
        *  Modifications:
        *
        *    DATE        WHO                DESCRIPTION
        *  07/03/2020    cmendoza           Initial procedure
    ******************************************************************************/
    PROCEDURE fdr_prods_notification(v_process_name IN chd_process_log.process_name%TYPE,
                                     v_msg          IN VARCHAR2) IS
        v_dbenv VARCHAR2(30);
    BEGIN
        SELECT SYS_CONTEXT('USERENV', 'DB_NAME')
          INTO v_dbenv
          FROM DUAL;

        pkg_notify.send_email('REWARDS', 'Missing program codes <br>' || v_msg,
                                         v_email_from, v_email_to, '[' ||
                               UPPER(v_dbenv) ||
                               ']: FDR_REWARDS_STAGING PROCESS WARNING - ' ||
                               v_prod_email_subject);
    END fdr_prods_notification;

    PROCEDURE fdr_cards_notification(v_process_name IN chd_process_log.process_name%TYPE,
                                     v_msg          IN VARCHAR2) IS
        v_dbenv VARCHAR2(30);
    BEGIN
        SELECT SYS_CONTEXT('USERENV', 'DB_NAME')
          INTO v_dbenv
          FROM DUAL;

        pkg_notify.send_email('REWARDS', 'The following card numbers do not exist on Credit One Bank since at least 3 days.<br>' || v_msg,
                                         v_email_from, v_email_to, '[' ||
                               UPPER(v_dbenv) ||
                               ']: FDR_REWARDS_STAGING PROCESS WARNING - ' ||
                               v_cards_email_subject);
    END fdr_cards_notification;

    PROCEDURE fdr_accts_notification(v_process_name IN chd_process_log.process_name%TYPE,
                                     v_msg          IN VARCHAR2) IS
        v_dbenv VARCHAR2(30);
    BEGIN
        SELECT SYS_CONTEXT('USERENV', 'DB_NAME')
          INTO v_dbenv
          FROM DUAL;

        pkg_notify.send_email('REWARDS', 'The following accounts have redemptions but are not associated with a Rewards Program.<br>' || v_msg,
                                         v_email_from, v_email_to, '[' ||
                               UPPER(v_dbenv) ||
                               ']: FDR_REWARDS_STAGING PROCESS WARNING - ' ||
                               v_accts_email_subject);
    END fdr_accts_notification;

    /******************************************************************************
    *
    *  Title:        PKG_FDR_REWARDS_STAGING_P.STAGE_REWARD_MSTR
    *  Schema Owner: ODS_STG
    *  Created:      March 27, 2020  07:19:15
    *  Author:       CMENDOZA
    *
    *  Description: Loads T_REWARD_SUMMARY from master file external tables
    *
    *  Modifications:
    *
    *    DATE        WHO                DESCRIPTION
    *
    ******************************************************************************/
    PROCEDURE STAGE_REWARD_MSTR(v_post_date    IN DATE DEFAULT TRUNC(SYSDATE - 1),
                                filename       IN VARCHAR2,
                                process_status OUT NUMBER) IS
        v_rowcnt       NUMBER := 0;
        v_errmsg       VARCHAR2(500);
        v_proc_name    VARCHAR2(40);
        v_product_ids  VARCHAR2(4000);
        v_formated_product_ids  VARCHAR2(4000);
        v_card_numbers VARCHAR2(2000);
    BEGIN
        process_status := 0;
        v_proc_name    := 'STAGE_REWARD_MSTR';
        INSERT INTO chd_process_log
            (process_name, process_date, system_name, user_name, run_date,
             status, msg, level_name, rowcnt)
        VALUES
            (v_proc_name, v_post_date, 'REWARDS', 'ODS_STG', SYSDATE,
             'RUNNING', 'Processing file ' || filename, NULL, 0);

        COMMIT;

        -- Check if all products in the Master File are added in T_REWARDS_PRODUCT for each account. If not, send email to FRD team to add them
        FOR c IN (
          SELECT dt, listagg(prog_id, ', ' on overflow truncate) within GROUP(ORDER BY prog_id) as product_names
          FROM (SELECT DISTINCT (et.plp_calc_program_id) AS prog_id, to_char(to_date(et.plp_calc_pgm_start_dt,'yyyymmdd'), 'YYYY-MM-DD' ) as dt
            FROM ET_PLP_RWRD_MSTR_BASE et
           WHERE NOT EXISTS
           (SELECT DISTINCT (rp.product_id)
                    FROM t_rewards_product rp
                   WHERE upper(rp.product_id) = upper(et.plp_calc_program_id)))
          group by dt)
          LOOP
            v_formated_product_ids:= v_formated_product_ids || '<p>' || c.dt || ' --> ' || c.product_names || '</p>';
			v_product_ids:= v_product_ids || c.product_names || ', ';
         END LOOP;

        IF (v_product_ids IS NOT NULL) THEN
            -- It is a hard error (returns 1)
            log_update(v_proc_name, v_post_date, 0, 'File: ' || filename ||
                        '. Rewards Product IDs provided in the Master file do not exist in REWARD.T_REWARDS_PRODUCT: ' ||
                        v_product_ids, 'ERROR');
            COMMIT;
            -- Sends email to FDR team with information about missing programs in the BMA
            fdr_prods_notification(v_proc_name, v_formated_product_ids);
            process_status := 1;
        ELSE
            -- PROCESS PENDING ACCOUNTS

            -- Moves from T_RWRD_SUMMARY_PENDING to T_REWARD_SUMMARY the cards records with a match in T_CARD
            MERGE INTO T_REWARD_SUMMARY tgt
            USING (SELECT credit_account_id,
                          card_id,
                          program_id,
                          program_name,
                          program_reg_date,
                          program_term_date
                     FROM T_RWRD_SUMMARY_PENDING rsp
                    INNER JOIN T_CARD tc
                       ON tc.card_num = rsp.card_num) src
            ON (tgt.PROGRAM_NAME = src.program_name AND tgt.CARD_ID = src.card_id)
            WHEN NOT MATCHED THEN
                INSERT
                    (ID, CREDIT_ACCOUNT_ID, CARD_ID, PROGRAM_ID,
                     PROGRAM_NAME, PROGRAM_REG_DATE, PROGRAM_TERM_DATE)
                VALUES
                    (SEQ_REWARD_SUMMARY.nextval, src.credit_account_id,
                     src.card_id, src.program_id, src.program_name,
                     src.program_reg_date, src.program_term_date);

            -- Removes previous cards were updated in T_REWARD_SUMMARY
            DELETE FROM T_RWRD_SUMMARY_PENDING p
             WHERE EXISTS (SELECT *
                      FROM T_CARD tc
                     WHERE tc.card_num = p.card_num);
            COMMIT;

            -- Checks if there are cards in T_RWRD_SUMMARY_PENDING whose arrival date is older than 5 days
            WITH cns AS
             (SELECT DISTINCT (card_num)
                FROM T_RWRD_SUMMARY_PENDING
               WHERE arrival_date <= trunc(SYSDATE) - 5)

            SELECT listagg(substr(card_num, -4), ', ') within GROUP(ORDER BY card_num) c
              INTO v_card_numbers
              FROM cns;

            IF (v_card_numbers IS NOT NULL) THEN
                -- Sends email to FDR_Team to further investigation
                fdr_cards_notification(v_proc_name, v_card_numbers);

                -- Logs the sending of the email
                INSERT INTO chd_process_log
                    (process_name, process_date, system_name, user_name,
                     run_date, status, msg, level_name, rowcnt)
                VALUES
                    (v_proc_name, v_post_date, 'REWARDS', 'ODS_STG',
                     SYSDATE, 'WARNING',
                     substr('Email sent to FDR Team with the cards numbers: ' ||
                             v_card_numbers, 0, 500), NULL, 0);
                COMMIT;
            END IF;


            -- Updates T_CREDIT_ACCOUNT with Fiserv Program Id that exist in the BMA (t_rewards_product)
            MERGE INTO t_credit_account t1
            USING (SELECT et.plp_calc_program_id,
                          c.credit_account_id,
						  ROW_NUMBER() OVER(PARTITION BY credit_account_id ORDER BY plp_calc_program_id ASC) AS rn
                     FROM ET_PLP_RWRD_MSTR_BASE et
                    INNER JOIN t_card c
                       ON c.card_num = et.plp_key_acct_no or (substr(et.plp_key_acct_no,0,2) = v_amex_FirstDigits and c.card_num = substr(et.plp_key_acct_no,0,15))
                    WHERE EXISTS
                    (SELECT *
                             FROM t_rewards_product rp
                            WHERE rp.product_id = et.plp_calc_program_id and rp.is_base_product = 1)) t2
            ON (t1.credit_account_id = t2.credit_account_id AND rn = 1)
            WHEN MATCHED THEN
                UPDATE
                   SET t1.rewards_product_id = t2.plp_calc_program_id;

            COMMIT;

            -- Update of T_REWARD_SUMMARY records based on Master File cards with a match in T_CARD
            MERGE INTO T_REWARD_SUMMARY tgt
            USING (SELECT DISTINCT (mb.PLP_CALC_PROGRAM_ID),
                                   tc.CREDIT_ACCOUNT_ID,
                                   tc.CARD_ID,
                                   rp.ID AS PROGRAM_ID,
                                   mb.PLP_CALC_PGM_REG_DT,
                                   mb.PLP_CALC_PGM_TERM_DT
                     FROM ET_PLP_RWRD_MSTR_BASE mb
                    INNER JOIN T_CARD tc
                       ON tc.card_num = mb.plp_key_acct_no or (substr(mb.plp_key_acct_no,0,2) = v_amex_FirstDigits and tc.card_num = substr(mb.plp_key_acct_no,0,15))
                     LEFT JOIN T_REWARDS_PRODUCT rp
                       ON upper(rp.PRODUCT_ID) =
                          upper(mb.PLP_CALC_PROGRAM_ID)) src
            ON (tgt.PROGRAM_NAME = src.PLP_CALC_PROGRAM_ID AND tgt.CARD_ID = src.CARD_ID)
            WHEN NOT MATCHED THEN
                INSERT
                    (ID, CREDIT_ACCOUNT_ID, CARD_ID, PROGRAM_ID,
                     PROGRAM_NAME, PROGRAM_REG_DATE, PROGRAM_TERM_DATE)
                VALUES
                    (SEQ_REWARD_SUMMARY.NEXTVAL, src.CREDIT_ACCOUNT_ID,
                     src.CARD_ID, src.PROGRAM_ID,
                     upper(src.PLP_CALC_PROGRAM_ID),
                     TO_DATE(src.PLP_CALC_PGM_REG_DT, 'YYYYMMDD'),
                     TO_DATE(src.PLP_CALC_PGM_TERM_DT, 'YYYYMMDD'))
            WHEN MATCHED THEN
                UPDATE
                   SET PROGRAM_ID        = src.PROGRAM_ID,
                       PROGRAM_REG_DATE  = TO_DATE(src.PLP_CALC_PGM_REG_DT, 'YYYYMMDD'),
                       PROGRAM_TERM_DATE = TO_DATE(src.PLP_CALC_PGM_TERM_DT, 'YYYYMMDD');

            COMMIT;

            -- Saves in T_RWRD_SUMMARY_PENDING the cards with no matching record in T_CARD.
            MERGE INTO T_RWRD_SUMMARY_PENDING tgt
            USING (SELECT CASE WHEN substr(mb.plp_key_acct_no,0,2) = v_amex_FirstDigits THEN substr(mb.plp_key_acct_no,0,15)
                               ELSE mb.plp_key_acct_no END AS card_number,
                          rp.ID AS program_id,
                          mb.PLP_CALC_PROGRAM_ID AS program_name,
                          mb.PLP_CALC_PGM_REG_DT AS program_reg_date,
                          mb.PLP_CALC_PGM_TERM_DT AS program_term_date,
                          TRUNC(SYSDATE)
                     FROM ET_PLP_RWRD_MSTR_BASE mb
                     LEFT JOIN T_REWARDS_PRODUCT rp
                       ON upper(rp.PRODUCT_ID) =
                          upper(mb.PLP_CALC_PROGRAM_ID)
                    WHERE mb.PLP_ACCT_LYLT_PRCS_ID <> 'L' and NOT EXISTS
                    (SELECT *
                             FROM t_card c
                            WHERE c.card_num = mb.plp_key_acct_no or
                             (substr(mb.plp_key_acct_no,0,2) = v_amex_FirstDigits and c.card_num = substr(mb.plp_key_acct_no,0,15))
                             )) src
            ON (tgt.card_num = src.card_number)
            WHEN NOT MATCHED THEN
                INSERT
                    (Id, card_num, card_num_last_4, PROGRAM_ID,
                     PROGRAM_NAME, PROGRAM_REG_DATE, PROGRAM_TERM_DATE,
                     ARRIVAL_DATE)
                VALUES
                    (SEQ_RWRD_SUMMARY_PENDING.nextval, src.card_number,
                     substr(src.card_number, -4), src.program_id,
                     src.program_name,
                     TO_DATE(src.program_reg_date, 'YYYYMMDD'),
                     TO_DATE(src.program_term_date, 'YYYYMMDD'),
                     TRUNC(SYSDATE));
            COMMIT;


            SELECT COUNT(DISTINCT(card_num))
              INTO v_rowcnt
              FROM T_RWRD_SUMMARY_PENDING;

            IF v_rowcnt > 0 THEN
                -- It is a soft error (returns 2)
                process_status := 2;
                log_update(v_proc_name, v_post_date, v_rowcnt, 'file: ' ||
                            filename ||
                            '. Some cards numbers provided in the Master file do not exist in ACCOUNT.T_CARD.', 'WARNING');
            ELSE
                -- Success
                process_status := 0;
                log_update(v_proc_name, v_post_date, v_rowcnt, 'file: ' ||
                            filename, 'COMPLETED');
            END IF;
            COMMIT;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            v_errmsg := SUBSTR(SQLERRM, 1, 500);
            log_update(v_proc_name, v_post_date, v_rowcnt, v_errmsg, 'ERROR');
            COMMIT;
            raise_application_error(-20101, 'Error processing in ' ||
                                     V_PROC_NAME || '.  ' ||
                                     v_errmsg);
            COMMIT;
    END STAGE_REWARD_MSTR;


    /******************************************************************************
    *
    *  Title:        PKG_FDR_REWARDS_STAGING_P.STAGE_REWARD_REDEMPTION
    *  Schema Owner: ODS_STG
    *  Created:      March 27, 2020  07:19:15
    *  Author:       CMENDOZA
    *
    *  Description: Loads T_REWARD_REDEMPTION_HISTORY from redemption file external tables
    *
    *  Modifications:
    *
    *    DATE        WHO                DESCRIPTION
    *
    ******************************************************************************/
    PROCEDURE STAGE_REWARD_REDEMPTION(v_post_date    DATE,
                                      filename       IN VARCHAR2,
                                      process_status OUT NUMBER) IS
        v_rowcnt       NUMBER := 0;
        v_errmsg       VARCHAR2(500);
        v_proc_name    VARCHAR2(40);
        v_card_numbers VARCHAR2(2000);
        v_account_ids  VARCHAR2(2000);
    BEGIN
        process_status := 0;
        v_proc_name    := 'STAGE_REWARD_REDEM';
        INSERT INTO chd_process_log
            (process_name, process_date, system_name, user_name, run_date,
             status, msg, level_name, rowcnt)
        VALUES
            (v_proc_name, v_post_date, 'REWARDS', 'ODS_STG', SYSDATE,
             'RUNNING', 'Processing file ' || filename, NULL, 0);

        COMMIT;

        /* Check if exist any redeemed transactions whose account is not associated to a rewards program yet.
        If yes, send email to FRD team with the list of accounts */
        WITH res AS
         (SELECT DISTINCT (tc.credit_account_id) AS credit_account_id
            FROM ET_PLP_REDEMPTION_HISTORY_DETAIL rd
           INNER JOIN t_card tc
              ON tc.card_num = rd.plp_03_account_number or (substr(rd.plp_03_account_number,0,2) = v_amex_FirstDigits and tc.card_num = substr(rd.plp_03_account_number,0,15))
           WHERE NOT EXISTS
           (SELECT *
                    FROM t_credit_account ca
                   WHERE ca.credit_account_id = tc.credit_account_id AND
                         ca.rewards_product_id IS NOT NULL))

        SELECT listagg(credit_account_id, ', ') within GROUP(ORDER BY credit_account_id) c
          INTO v_account_ids
          FROM res;
        IF (v_account_ids IS NOT NULL) THEN
            -- It is a hard error (returns 1) - Redemptions not matching a rewards program
            log_update(v_proc_name, v_post_date, 0, 'File: ' || filename ||
                        '.There are accounts have redemptions but are not associated with a Rewards Program: ' ||
                        v_account_ids, 'ERROR');
            COMMIT;
            -- Sends email to FDR team with the list of accounts
            fdr_accts_notification(v_proc_name, v_account_ids);
            process_status := 1;
        ELSE

            -- PROCESS PENDING ACCOUNTS

            -- Moves from  T_RWRD_REDEMPTION_PENDING to T_REWARD_REDEMPTION_HISTORY the cards records with a match in T_CARD
            MERGE INTO T_REWARD_REDEMPTION_HISTORY tgt
            USING (SELECT tc.CREDIT_ACCOUNT_ID,
                          tc.CARD_ID,
                          rp.id,
                          rp.product_id,
                          POINTS_REDEEMED,
                          REDEMPTION_DATE,
                          POINTS_REDEEMED_SIGN,
                          RECORD_TYPE,
                          ITEM_CATEGORY_TYPE,
                          REDEMPTION_ORDER_ID,
						              REDEMPTION_ORDER_ITEM_ID,
                          SUPPLIER_NAME,
                          SUPPLIER_DESC,
                          CATALOG_CATEGORY_ID,
                          CATALOG_CATEGORY_NAME,
                          sfi.ID as PARTNER_REDEMPTION_ITEM_ID,
                          REDEMPTION_TIME,
                          ORDER_CONFIRMATION,
                          CLIENT_NUMBER,
                          WEB_PRESENT_CODE,
                          REDEEMER_EMAIL_1
                     FROM T_RWRD_REDEMPTION_PENDING rrp
                    INNER JOIN T_CARD tc
                       ON tc.CARD_NUM = rrp.card_num
                    INNER JOIN T_CREDIT_ACCOUNT ca
                       ON ca.credit_account_id = tc.credit_account_id
                    INNER JOIN T_REWARDS_PRODUCT rp
                       ON rp.product_id = ca.rewards_product_id
                    LEFT JOIN T_REWARDS_SIX_FLAGS_ITEM sfi

                        ON sfi.ITEM_ID = rrp.SUPPLIER_GOODS_ID) src
            ON (tgt.CARD_ID = src.CARD_ID AND tgt.redemption_order_id = src.REDEMPTION_ORDER_ID AND tgt.redemption_order_item_id = src.REDEMPTION_ORDER_ITEM_ID)
            WHEN NOT MATCHED THEN
                INSERT
                    (REDEMPTION_HISTORY_ID, CREDIT_ACCOUNT_ID, CARD_ID,
                     PROGRAM_ID, PROGRAM_NAME, POINTS_REDEEMED,
                     REDEMPTION_DATE, POINTS_REDEEMED_SIGN, RECORD_TYPE,
                     ITEM_CATEGORY_TYPE, REDEMPTION_ORDER_ID, REDEMPTION_ORDER_ITEM_ID,
					           SUPPLIER_NAME, SUPPLIER_DESC,
					           CATALOG_CATEGORY_ID, CATALOG_CATEGORY_NAME,
                     PARTNER_REDEMPTION_ITEM_ID,
                     REDEMPTION_TIME,
                     ORDER_CONFIRMATION,
                     CLIENT_NUMBER,
                     EMAIL_SEND_DATE,
                     PARTNER_REDEMPTION_ITEM_CODE_ID,
                     WEB_PRESENT_CODE,
                     REDEEMER_EMAIL_1,
                     NOTIFICATION_ID)
                VALUES
                    (SEQ_REWARD_REDEMPTION_HISTORY.nextval,
                     src.credit_account_id, src.card_id, src.id,
                     src.product_id, src.POINTS_REDEEMED,
                     TO_DATE(src.REDEMPTION_DATE, 'YYYYMMDD'),
                     src.POINTS_REDEEMED_SIGN, src.RECORD_TYPE,
                     src.ITEM_CATEGORY_TYPE, src.REDEMPTION_ORDER_ID, src.REDEMPTION_ORDER_ITEM_ID,
                     src.SUPPLIER_NAME, src.SUPPLIER_DESC,
                     src.CATALOG_CATEGORY_ID, src.CATALOG_CATEGORY_NAME,                     
                     src.PARTNER_REDEMPTION_ITEM_ID,
                     src.REDEMPTION_TIME,
                     src.ORDER_CONFIRMATION,
                     src.CLIENT_NUMBER,
                     NULL,
                     NULL,
                     src.WEB_PRESENT_CODE,
                     src.REDEEMER_EMAIL_1,
                     NULL);

            -- Removes previous cards were updated in T_REWARD_REDEMPTION_HISTORY
            DELETE FROM T_RWRD_REDEMPTION_PENDING p
             WHERE EXISTS (SELECT *
                      FROM T_CARD tc
                     WHERE tc.card_num = p.card_num);
            COMMIT;

            -- Checks if there are cards in T_RWRD_REDEMPTION_PENDING whose arrival date is older than 5 days
            WITH cns AS
             (SELECT DISTINCT (card_num)
                FROM T_RWRD_REDEMPTION_PENDING
               WHERE arrival_date <= trunc(SYSDATE) - 5)

            SELECT listagg(substr(card_num, -4), ', ') within GROUP(ORDER BY card_num) c
              INTO v_card_numbers
              FROM cns;

            IF (v_card_numbers IS NOT NULL) THEN
                -- Sends email to FDR_Team to further investigation
                fdr_cards_notification(v_proc_name, v_card_numbers);

                -- Logs the sending of the email
                INSERT INTO chd_process_log
                    (process_name, process_date, system_name, user_name,
                     run_date, status, msg, level_name, rowcnt)
                VALUES
                    (v_proc_name, v_post_date, 'REWARDS', 'ODS_STG',
                     SYSDATE, 'WARNING',
                     substr('Email sent to FDR Team with the cards numbers: ' ||
                             v_card_numbers, 0, 500), NULL, 0);
                COMMIT;
            END IF;

            -- Update of T_REWARD_REDEMPTION_HISTORY records based on Redemption File cards with a match in T_CARD
            MERGE INTO T_REWARD_REDEMPTION_HISTORY tgt
            USING (SELECT tc.CREDIT_ACCOUNT_ID,
                          tc.CARD_ID,
                          rp.id,
                          rp.product_id,
                          ri.PLP_04_POINTS_REDEEMED,
                          rd.PLP_03_REDEMPTION_DT,
                          ri.PLP_04_POINTS_REDEEMED_SIGN,
                          CASE ri.PLP_04_ITEM_CTGR_TYPE_CD
                              WHEN 'AO' THEN
                               'Other'
                              WHEN 'CB' THEN
                               'Cashback'
                              WHEN 'ME' THEN
                               'Merchandise Electronics'
                              WHEN 'TR' THEN
                               'Travel Other'
                              WHEN 'SC' THEN
                               'Statement Credit'
                              WHEN 'GT' THEN
                               'Gift Points/Dollars'
                              WHEN 'DD' THEN
                               'Direct Deposit'
                              WHEN 'CT' THEN
                               'Certificate'
                              WHEN 'RT' THEN
                               'Real Time Reward'
                              WHEN 'PC' THEN
                               'Physical Gift Card'
                              WHEN 'GC' THEN
                               'Virtual Gift Card'
                              WHEN 'AC' THEN
                               'Experiences/Adventures'
                              WHEN 'ET' THEN
                               'Event Ticket'
                              WHEN 'TA' THEN
                               'Flight'
                              WHEN 'CR' THEN
                               'Cruise'
                              WHEN 'RC' THEN
                               'Rental Car'
                              WHEN 'HT' THEN
                               'Hotel'
                              WHEN 'MO' THEN
                               'Merchandise'
                              WHEN 'CD' THEN
                               'Charity Deposit'
                              WHEN 'PE' THEN
                               'Purchase Eraser'
                              WHEN 'SD' THEN
                               'Standard Distribution'
                              ELSE
                               NULL
                          END AS REDEMPTION_TYPE, --redemption type
                          ri.PLP_04_ITEM_CTGR_TYPE_CD,
                          ri.PLP_04_REDEMPTION_ID, --redemption order identifier
                          ri.PLP_04_LINE_ITEM_ID, --redeemed item identifier within the order
                          ri.PLP_04_SUPPLIER_NAME,
                          ri.PLP_04_SUPPLIER_ITEM_NAME, --redemption desc
                          ri.PLP_04_CATALOG_CATEGORY_ID,
                          ri.PLP_04_CATALOG_CATEGORY_NAME,
                          sfi.ID as PARTNER_REDEMPTION_ITEM_ID,
                          rd.PLP_03_REDEMPTION_TM,
                          rd.PLP_03_ORDER_CONFIRMATION,
                          rd.PLP_03_CLIENT_NO,
                          rd.PLP_03_WEB_PRESENT_CODE,
                          rd.PLP_03_REDEEMER_EMAIL_1
                     FROM ET_PLP_REDEMPTION_HISTORY_DETAIL rd -- Details
                    INNER JOIN ET_PLP_REDEMPTION_ITEMIZED ri
                       ON ri.PLP_04_REDEMPTION_ID = rd.PLP_03_REDEMPTION_ID -- Items
                    INNER JOIN T_CARD tc
                       ON tc.card_num = ri.PLP_04_ACCOUNT_NUMBER or (substr(ri.PLP_04_ACCOUNT_NUMBER,0,2) = v_amex_FirstDigits and tc.card_num = substr(ri.PLP_04_ACCOUNT_NUMBER,0,15))
                    INNER JOIN T_CREDIT_ACCOUNT ca
                       ON ca.credit_account_id = tc.credit_account_id
                    INNER JOIN T_REWARDS_PRODUCT rp
                       ON rp.product_id = ca.rewards_product_id
                    LEFT JOIN T_REWARDS_SIX_FLAGS_ITEM sfi
                        ON sfi.ITEM_ID = ri.PLP_04_SUPPLIER_GOODS_ID) src
            ON (tgt.CARD_ID = src.CARD_ID AND tgt.redemption_order_id = src.PLP_04_REDEMPTION_ID AND tgt.redemption_order_item_id = src.PLP_04_LINE_ITEM_ID)
            -- Adds new records
            WHEN NOT MATCHED THEN
                INSERT
                    (REDEMPTION_HISTORY_ID, CREDIT_ACCOUNT_ID, CARD_ID,
                     PROGRAM_ID, PROGRAM_NAME, POINTS_REDEEMED,
                     REDEMPTION_DATE, POINTS_REDEEMED_SIGN, RECORD_TYPE,
                     ITEM_CATEGORY_TYPE, REDEMPTION_ORDER_ID, REDEMPTION_ORDER_ITEM_ID, SUPPLIER_NAME,
                     SUPPLIER_DESC, CATALOG_CATEGORY_ID,
                     CATALOG_CATEGORY_NAME,
                     PARTNER_REDEMPTION_ITEM_ID,
                     REDEMPTION_TIME,
                     ORDER_CONFIRMATION,
                     CLIENT_NUMBER,
                     EMAIL_SEND_DATE,
                     PARTNER_REDEMPTION_ITEM_CODE_ID,
                     WEB_PRESENT_CODE,
                     REDEEMER_EMAIL_1,
                     NOTIFICATION_ID)
                VALUES
                    (SEQ_REWARD_REDEMPTION_HISTORY.nextval,
                     src.CREDIT_ACCOUNT_ID, src.CARD_ID, src.id,
                     src.product_id, src.PLP_04_POINTS_REDEEMED,
                     TO_DATE(src.PLP_03_REDEMPTION_DT, 'YYYYMMDD'),
                     src.PLP_04_POINTS_REDEEMED_SIGN,
                     src.REDEMPTION_TYPE,
                     src.PLP_04_ITEM_CTGR_TYPE_CD, src.PLP_04_REDEMPTION_ID, src.PLP_04_LINE_ITEM_ID,
                     src.PLP_04_SUPPLIER_NAME, src.PLP_04_SUPPLIER_ITEM_NAME,
                     src.PLP_04_CATALOG_CATEGORY_ID,
                     src.PLP_04_CATALOG_CATEGORY_NAME,
                     src.PARTNER_REDEMPTION_ITEM_ID,
                     src.PLP_03_REDEMPTION_TM,
                     src.PLP_03_ORDER_CONFIRMATION,
                     src.PLP_03_CLIENT_NO,
                     NULL,
                     NULL,
                     src.PLP_03_WEB_PRESENT_CODE,
                     src.PLP_03_REDEEMER_EMAIL_1,
                     NULL)
            WHEN MATCHED THEN
                UPDATE
                   SET program_id   = src.id,
                       program_name = src.product_id;

            COMMIT;

            -- Saves in T_RWRD_REDEMPTION_PENDING the cards with no matching record in T_CARD.
            MERGE INTO T_RWRD_REDEMPTION_PENDING tgt
            USING (SELECT CASE WHEN substr(rd.PLP_03_ACCOUNT_NUMBER,0,2) = v_amex_FirstDigits THEN substr(rd.PLP_03_ACCOUNT_NUMBER,0,15)
                               ELSE rd.PLP_03_ACCOUNT_NUMBER END AS card_number,
                          ri.PLP_04_POINTS_REDEEMED,
                          rd.PLP_03_REDEMPTION_DT,
                          ri.PLP_04_POINTS_REDEEMED_SIGN,
                          CASE ri.PLP_04_ITEM_CTGR_TYPE_CD
                              WHEN 'AO' THEN
                               'Other'
                              WHEN 'CB' THEN
                               'Cashback'
                              WHEN 'ME' THEN
                               'Merchandise Electronics'
                              WHEN 'TR' THEN
                               'Travel Other'
                              WHEN 'SC' THEN
                               'Statement Credit'
                              WHEN 'GT' THEN
                               'Gift Points/Dollars'
                              WHEN 'DD' THEN
                               'Direct Deposit'
                              WHEN 'CT' THEN
                               'Certificate'
                              WHEN 'RT' THEN
                               'Real Time Reward'
                              WHEN 'PC' THEN
                               'Physical Gift Card'
                              WHEN 'GC' THEN
                               'Virtual Gift Card'
                              WHEN 'AC' THEN
                               'Experiences/Adventures'
                              WHEN 'ET' THEN
                               'Event Ticket'
                              WHEN 'TA' THEN
                               'Flight'
                              WHEN 'CR' THEN
                               'Cruise'
                              WHEN 'RC' THEN
                               'Rental Car'
                              WHEN 'HT' THEN
                               'Hotel'
                              WHEN 'MO' THEN
                               'Merchandise'
                              WHEN 'CD' THEN
                               'Charity Deposit'
                              WHEN 'PE' THEN
                               'Purchase Eraser'
                              WHEN 'SD' THEN
                               'Standard Distribution'
                              ELSE
                               NULL
                          END AS REDEMPTION_TYPE, --redemption type
                          ri.PLP_04_ITEM_CTGR_TYPE_CD,
                          ri.PLP_04_REDEMPTION_ID, --redemption order identifier
                          ri.PLP_04_LINE_ITEM_ID, --redeemed item identifier within the order
                          ri.PLP_04_SUPPLIER_NAME,
                          ri.PLP_04_SUPPLIER_ITEM_NAME, --redemption desc
                          ri.PLP_04_CATALOG_CATEGORY_ID,
                          ri.PLP_04_CATALOG_CATEGORY_NAME,
                          NULLIF(rd.plp_03_fulfil_last_name || ',' ||
                                 rd.plp_03_fulfil_first_name, ',') AS card_holder_name,
                          rd.plp_03_fulfil_email_1 AS card_holder_email,
                          rd.plp_03_fulfil_telephone AS card_holder_phone,
                          rd.plp_03_fulfil_addr_line_1 AS card_holder_addr1,
                          ri.PLP_04_SUPPLIER_GOODS_ID,
                          rd.PLP_03_REDEMPTION_TM,
                          rd.PLP_03_ORDER_CONFIRMATION,
                          rd.PLP_03_CLIENT_NO,
                          rd.PLP_03_WEB_PRESENT_CODE,
                          rd.PLP_03_REDEEMER_EMAIL_1
                     FROM ET_PLP_REDEMPTION_HISTORY_DETAIL rd -- Details
                    INNER JOIN ET_PLP_REDEMPTION_ITEMIZED ri
                       ON ri.PLP_04_REDEMPTION_ID = rd.PLP_03_REDEMPTION_ID -- Items
                    WHERE NOT EXISTS
                    (SELECT *
                             FROM t_card c
                            WHERE c.card_num = rd.PLP_03_ACCOUNT_NUMBER or (substr(rd.PLP_03_ACCOUNT_NUMBER,0,2) = v_amex_FirstDigits and c.card_num = substr(rd.PLP_03_ACCOUNT_NUMBER,0,15))
                            )
                    OR (rd.PLP_03_WEB_PRESENT_CODE = 'PLPCRD02' --SixFlags
                       and NOT EXISTS (
                           SELECT * FROM T_REWARDS_SIX_FLAGS_ITEM sfi
                           WHERE sfi.ITEM_ID = ri.PLP_04_SUPPLIER_GOODS_ID
                       ))) src
            ON (tgt.card_num = src.card_number AND tgt.redemption_order_id = src.PLP_04_REDEMPTION_ID AND tgt.redemption_order_item_id = src.PLP_04_LINE_ITEM_ID)
            WHEN NOT MATCHED THEN
                INSERT
                    (Id, card_num, card_num_last_4, POINTS_REDEEMED,
                     REDEMPTION_DATE, POINTS_REDEEMED_SIGN, RECORD_TYPE,
                     ITEM_CATEGORY_TYPE, REDEMPTION_ORDER_ID, REDEMPTION_ORDER_ITEM_ID, SUPPLIER_NAME,
                     SUPPLIER_DESC, CATALOG_CATEGORY_ID,
                     CATALOG_CATEGORY_NAME, ARRIVAL_DATE, CARD_HOLDER_NAME,
                     CARD_HOLDER_EMAIL, CARD_HOLDER_PHONE, CARD_HOLDER_ADDR1,
                     SUPPLIER_GOODS_ID,
                     REDEMPTION_TIME,
                     ORDER_CONFIRMATION,
                     CLIENT_NUMBER,
                     WEB_PRESENT_CODE,
                     REDEEMER_EMAIL_1)
                VALUES
                    (SEQ_RWRD_REDEMPTION_PENDING.nextval, src.card_number,
                     substr(src.card_number, -4), src.PLP_04_POINTS_REDEEMED,
                     TO_DATE(src.PLP_03_REDEMPTION_DT, 'YYYYMMDD'),
                     src.PLP_04_POINTS_REDEEMED_SIGN,
                     src.REDEMPTION_TYPE,
                     src.PLP_04_ITEM_CTGR_TYPE_CD, src.PLP_04_REDEMPTION_ID, src.PLP_04_LINE_ITEM_ID,
                     src.PLP_04_SUPPLIER_NAME, src.PLP_04_SUPPLIER_ITEM_NAME,
                     src.PLP_04_CATALOG_CATEGORY_ID,
                     src.PLP_04_CATALOG_CATEGORY_NAME, trunc(SYSDATE),
                     src.card_holder_name,
                     src.card_holder_email,
                     src.card_holder_phone,
                     src.card_holder_addr1,
                     src.PLP_04_SUPPLIER_GOODS_ID,
                     src.PLP_03_REDEMPTION_TM,
                     src.PLP_03_ORDER_CONFIRMATION,
                     src.PLP_03_CLIENT_NO,
                     src.PLP_03_WEB_PRESENT_CODE,
                     src.PLP_03_REDEEMER_EMAIL_1);

            COMMIT;

            SELECT COUNT(DISTINCT(card_num))
              INTO v_rowcnt
              FROM T_RWRD_REDEMPTION_PENDING;

            IF v_rowcnt > 0 THEN
                -- There are accounts with no matching record. It is a soft error (returns 2)
                process_status := 2;
                log_update(v_proc_name, v_post_date, v_rowcnt, 'file: ' ||
                            filename ||
                            '. Some cards numbers provided in the Redemptions file do not exist in ACCOUNT.T_CARD.', 'WARNING');
            ELSE
                            
              SELECT COUNT(DISTINCT(SUPPLIER_GOODS_ID))
              INTO v_rowcnt
              FROM T_RWRD_REDEMPTION_PENDING;

              IF v_rowcnt > 0 THEN
                  -- There are item ids with no matching record. It is a soft error (returns 2)
                  process_status := 3;
                  log_update(v_proc_name, v_post_date, v_rowcnt, 'file: ' ||
                              filename ||
                              '. Some item IDs provided in the Redemptions file do not exist in REWARD.T_REWARDS_SIX_FLAGS_ITEM.', 'WARNING');
              ELSE
                  -- Success
                  process_status := 0;
                  log_update(v_proc_name, v_post_date, v_rowcnt, 'file: ' ||
                              filename, 'COMPLETED');
              END IF;
            END IF;
            COMMIT;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            v_errmsg := SUBSTR(SQLERRM, 1, 500);
            log_update(v_proc_name, v_post_date, v_rowcnt, v_errmsg, 'ERROR');
            COMMIT;
            raise_application_error(-20101, 'Error processing in ' ||
                                     V_PROC_NAME || '.  ' ||
                                     v_errmsg);
            COMMIT;
    END STAGE_REWARD_REDEMPTION;

    /******************************************************************************
    *
    *  Title:        PKG_FDR_REWARDS_STAGING_P.STAGE_REWARD_TRANSACTION
    *  Schema Owner: ODS_STG
    *  Created:      March 27, 2020  07:19:15
    *  Author:       CMENDOZA
    *
    *  Description: Loads T_REWARD_TRANSACTION_HISTORY from transaction file external tables
    *
    *  Modifications:
    *
    *    DATE        WHO                DESCRIPTION
    *
    ******************************************************************************/
    PROCEDURE STAGE_REWARD_TRANSACTION(v_post_date    DATE,
                                       filename       IN VARCHAR2,
                                       process_status OUT NUMBER) IS
        v_rowcnt       NUMBER := 0;
        v_errmsg       VARCHAR2(500);
        v_proc_name    VARCHAR2(40);
        v_product_ids  VARCHAR2(4000);
		v_formated_product_ids  VARCHAR2(4000);
        v_card_numbers VARCHAR2(2000);
    BEGIN
        process_status := 0;
        v_proc_name    := 'STAGE_REWARD_TRAN';
        INSERT INTO chd_process_log
            (process_name, process_date, system_name, user_name, run_date,
             status, msg, level_name, rowcnt)
        VALUES
            (v_proc_name, v_post_date, 'REWARDS', 'ODS_STG', SYSDATE,
             'RUNNING', 'Processing file ' || filename, NULL, 0);

        COMMIT;

        -- Checks if all products provided in the transaction file are added in T_REWARDS_PRODUCT. If not, send email to FRD team to add them
        FOR c IN (
          SELECT dt, listagg(prog_id, ', ' on overflow truncate) within GROUP(ORDER BY prog_id) as product_names
          FROM (SELECT DISTINCT (et.plp_program_name) AS prog_id, to_char(to_date(et.plp_program_start_date,'yyyymmdd'), 'YYYY-MM-DD' ) as dt
            FROM ET_PLP_TRAN_HIST_DETAIL et
           WHERE NOT EXISTS
           (SELECT DISTINCT (rp.product_id)
                    FROM t_rewards_product rp
                   WHERE upper(rp.product_id) = upper(et.plp_program_name)))
          group by dt)
          LOOP
            v_formated_product_ids:= v_formated_product_ids || '<p>' || c.dt || ' --> ' || c.product_names || '</p>';
			v_product_ids:= v_product_ids || c.product_names || ', ';

         END LOOP;

        IF (v_product_ids IS NOT NULL) THEN
            -- It is a hard error (returns 1)
            log_update(v_proc_name, v_post_date, 0, 'File: ' || filename ||
                        '. Rewards Product IDs provided in the Transaction file do not exist in REWARD.T_REWARDS_PRODUCT: ' ||
                        v_product_ids, 'ERROR');
            COMMIT;
            -- Sends email to FDR team with information about missing programs in the BMA
            fdr_prods_notification(v_proc_name, v_formated_product_ids);
            process_status := 1;
        ELSE
            -- PROCESS PENDING ACCOUNTS

            -- Moves from T_RWRD_TRANSACTION_PENDING to T_REWARD_TRANSACTION_HISTORY the cards records with a match in T_CARD
            MERGE INTO T_REWARD_TRANSACTION_HISTORY tgt
            USING (SELECT credit_account_id,
                          card_id,
                          program_id,
                          program_name,
                          POST_DATE,
                          TRANSACTION_CODE,
                          TRANSACTION_DATE,
                          TRANSACTION_TYPE,
                          REWARD_CATEGORY,
                          MERCHANT_ID,
                          MERCHANT_NAME,
                          TRANSACTION_AMOUNT_SIGN,
                          TRANSACTION_AMOUNT,
                          REWARD_AMOUNT_SIGN,
                          REWARD_AMOUNT,
                          MCC_SIC_CODE,
                          TRANSACTION_ID
                     FROM T_RWRD_TRANSACTION_PENDING rtp
                    INNER JOIN T_CARD tc
                       ON tc.CARD_NUM = rtp.card_num) src
            ON (tgt.PROGRAM_NAME = src.program_name AND tgt.CARD_ID = src.card_id AND tgt.TRANSACTION_ID = src.TRANSACTION_ID)
            WHEN NOT MATCHED THEN
                INSERT
                    (TRANSACTION_HISTORY_ID, CREDIT_ACCOUNT_ID, CARD_ID,
                     PROGRAM_ID, PROGRAM_NAME, POST_DATE, TRANSACTION_CODE,
                     TRANSACTION_DATE, TRANSACTION_TYPE, REWARD_CATEGORY,
                     MERCHANT_ID, MERCHANT_NAME, TRANSACTION_AMOUNT_SIGN,
                     TRANSACTION_AMOUNT, REWARD_AMOUNT_SIGN, REWARD_AMOUNT,
                     MCC_SIC_CODE, TRANSACTION_ID)
                VALUES
                    (SEQ_REWARD_TRANSACTION_HISTORY.nextval,
                     src.credit_account_id, src.card_id, src.program_id,
                     src.program_name, src.POST_DATE, src.TRANSACTION_CODE,
                     src.TRANSACTION_DATE, src.TRANSACTION_TYPE,
                     src.REWARD_CATEGORY, src.MERCHANT_ID, src.MERCHANT_NAME,
                     src.TRANSACTION_AMOUNT_SIGN, src.TRANSACTION_AMOUNT,
                     src.REWARD_AMOUNT_SIGN, src.REWARD_AMOUNT,
                     src.MCC_SIC_CODE, src.TRANSACTION_ID);

            -- Removes previous cards were updated in T_REWARD_TRANSACTION_HISTORY
            DELETE FROM T_RWRD_TRANSACTION_PENDING p
             WHERE EXISTS (SELECT *
                      FROM T_CARD tc
                     WHERE tc.card_num = p.card_num);
            COMMIT;

            -- Checks if there are cards in T_RWRD_TRANSACTION_PENDING whose arrival date is older than 5 days
            WITH cns AS
             (SELECT DISTINCT (card_num)
                FROM T_RWRD_TRANSACTION_PENDING
               WHERE arrival_date <= trunc(SYSDATE) - 5)

            SELECT listagg(substr(card_num, -4), ', ') within GROUP(ORDER BY card_num) c
              INTO v_card_numbers
              FROM cns;

            IF (v_card_numbers IS NOT NULL) THEN
                -- Sends email to FDR_Team to further investigation
                fdr_cards_notification(v_proc_name, v_card_numbers);

                -- Logs the sending of the email
                INSERT INTO chd_process_log
                    (process_name, process_date, system_name, user_name,
                     run_date, status, msg, level_name, rowcnt)
                VALUES
                    (v_proc_name, v_post_date, 'REWARDS', 'ODS_STG',
                     SYSDATE, 'WARNING',
                     substr('Email sent to FDR Team with the accounts: ' ||
                             v_card_numbers, 0, 500), NULL, 0);
                COMMIT;
            END IF;

            -- Updates accounts with Fiserv Program Id that exist in the BMA (t_rewards_product)
            MERGE INTO t_credit_account t1
            USING (SELECT et.plp_program_name,
                          c.credit_account_id
                     FROM ET_PLP_TRAN_HIST_DETAIL et
                    INNER JOIN t_card c
                       ON c.card_num = et.plp_account_number or (substr(et.plp_account_number,0,2) = v_amex_FirstDigits and c.card_num = substr(et.plp_account_number,0,15))
                    WHERE EXISTS
                    (SELECT *
                             FROM t_rewards_product rp
                            WHERE rp.product_id = et.plp_program_name and rp.is_base_product = 1)) t2
            ON (t1.credit_account_id = t2.credit_account_id)
            WHEN MATCHED THEN
                UPDATE
                   SET t1.rewards_product_id = t2.plp_program_name;

            COMMIT;

            -- Update of T_REWARD_TRANSACTION_HISTORY records based on Transaction File cards with a match in T_CARD
            MERGE INTO T_REWARD_TRANSACTION_HISTORY tgt
            USING (SELECT DISTINCT (td.PLP_PROGRAM_NAME),
                                   tc.CREDIT_ACCOUNT_ID,
                                   tc.CARD_ID,
                                   rp.ID,
                                   td.PLP_POST_DATE,
                                   td.PLP_TRAN_CODE,
                                   td.PLP_TRAN_DATE,
                                   td.PLP_TRAN_TYPE,
                                   td.PLP_CATEGORY,
                                   td.PLP_MERCHANT_ID,
                                   td.PLP_MERCHANT_NAME,
                                   td.PLP_TRAN_AMT_SIGN,
                                   td.PLP_TRAN_AMT,
                                   td.PLP_REWARD_VALUE_SIGN,
                                   td.PLP_REWARD_VALUE,
                                   td.PLP_MCC_SIC_CODE,
                                   td.PLP_TRAN_IDENTIFIER
                     FROM ET_PLP_TRAN_HIST_DETAIL td
                    INNER JOIN T_CARD tc
                       ON tc.card_num = td.PLP_ACCOUNT_NUMBER or (substr(td.PLP_ACCOUNT_NUMBER,0,2) = v_amex_FirstDigits and tc.card_num = substr(td.PLP_ACCOUNT_NUMBER,0,15))
                    LEFT JOIN T_REWARDS_PRODUCT rp
                       ON upper(rp.PRODUCT_ID) = upper(td.PLP_PROGRAM_NAME)
                          WHERE td.PLP_REWARD_VALUE <> 0) src
            ON (tgt.PROGRAM_NAME = src.PLP_PROGRAM_NAME AND tgt.CARD_ID = src.CARD_ID AND tgt.TRANSACTION_ID = src.PLP_TRAN_IDENTIFIER)
            -- Adds new records
            WHEN NOT MATCHED THEN
                INSERT
                    (TRANSACTION_HISTORY_ID, CREDIT_ACCOUNT_ID, CARD_ID,
                     PROGRAM_ID, PROGRAM_NAME, POST_DATE, TRANSACTION_CODE,
                     TRANSACTION_DATE, TRANSACTION_TYPE, REWARD_CATEGORY,
                     MERCHANT_ID, MERCHANT_NAME, TRANSACTION_AMOUNT_SIGN,
                     TRANSACTION_AMOUNT, REWARD_AMOUNT_SIGN, REWARD_AMOUNT,
                     MCC_SIC_CODE, TRANSACTION_ID)
                VALUES
                    (SEQ_REWARD_TRANSACTION_HISTORY.nextval,
                     src.CREDIT_ACCOUNT_ID, src.CARD_ID, src.ID,
                     src.PLP_PROGRAM_NAME,
                     TO_DATE(src.PLP_POST_DATE, 'YYYYMMDD'),
                     src.PLP_TRAN_CODE,
                     TO_DATE(src.PLP_TRAN_DATE, 'YYYYMMDD'),
                     src.PLP_TRAN_TYPE, src.PLP_CATEGORY,
                     src.PLP_MERCHANT_ID, src.PLP_MERCHANT_NAME,
                     src.PLP_TRAN_AMT_SIGN, src.PLP_TRAN_AMT,
                     src.PLP_REWARD_VALUE_SIGN, src.PLP_REWARD_VALUE,
                     src.PLP_MCC_SIC_CODE, src.PLP_TRAN_IDENTIFIER);

            COMMIT;

            -- Saves in T_RWRD_TRANSACTION_PENDING the cards with no matching record in T_CARD.
            MERGE INTO T_RWRD_TRANSACTION_PENDING tgt
            USING (SELECT CASE WHEN substr(m.PLP_ACCOUNT_NUMBER,0,2) = v_amex_FirstDigits THEN substr(m.PLP_ACCOUNT_NUMBER,0,15)
                               ELSE m.PLP_ACCOUNT_NUMBER END AS card_number,
                          rp.ID AS program_id,
                          m.PLP_PROGRAM_NAME AS program_name,
                          TO_DATE(PLP_POST_DATE, 'YYYYMMDD') AS POST_DATE,
                          PLP_TRAN_CODE,
                          TO_DATE(PLP_TRAN_DATE, 'YYYYMMDD') AS TRANSACTION_DATE,
                          PLP_TRAN_TYPE,
                          PLP_CATEGORY,
                          PLP_MERCHANT_ID,
                          PLP_MERCHANT_NAME,
                          PLP_TRAN_AMT_SIGN,
                          PLP_TRAN_AMT,
                          PLP_REWARD_VALUE_SIGN,
                          PLP_REWARD_VALUE,
                          PLP_MCC_SIC_CODE,
                          PLP_PI_ID_NAME,
                          PLP_TRAN_IDENTIFIER
                     FROM ET_PLP_TRAN_HIST_DETAIL m
                     LEFT JOIN T_REWARDS_PRODUCT rp
                       ON upper(rp.PRODUCT_ID) = upper(m.PLP_PROGRAM_NAME)
                    WHERE NOT EXISTS
                    (SELECT *
                             FROM t_card c
                            WHERE c.card_num = m.PLP_ACCOUNT_NUMBER or (substr(m.PLP_ACCOUNT_NUMBER,0,2) = v_amex_FirstDigits and c.card_num = substr(m.PLP_ACCOUNT_NUMBER,0,15))
                            ) and m.PLP_REWARD_VALUE <> 0) src
            ON (tgt.card_num = src.card_number AND tgt.transaction_date = src.TRANSACTION_DATE)
            WHEN NOT MATCHED THEN
                INSERT
                    (Id, card_num, card_num_last_4, PROGRAM_ID,
                     PROGRAM_NAME, POST_DATE, TRANSACTION_CODE,
                     TRANSACTION_DATE, TRANSACTION_TYPE, REWARD_CATEGORY,
                     MERCHANT_ID, MERCHANT_NAME, TRANSACTION_AMOUNT_SIGN,
                     TRANSACTION_AMOUNT, REWARD_AMOUNT_SIGN, REWARD_AMOUNT,
                     MCC_SIC_CODE, ARRIVAL_DATE, CARD_HOLDER_NAME,
                     TRANSACTION_ID)
                VALUES
                    (SEQ_RWRD_TRANSACTION_PENDING.nextval, src.card_number,
                     substr(src.card_number, -4), src.program_id,
                     src.program_name, src.POST_DATE, src.PLP_TRAN_CODE,
                     src.TRANSACTION_DATE, src.PLP_TRAN_TYPE,
                     src.PLP_CATEGORY, src.PLP_MERCHANT_ID,
                     src.PLP_MERCHANT_NAME, src.PLP_TRAN_AMT_SIGN,
                     src.PLP_TRAN_AMT, src.PLP_REWARD_VALUE_SIGN,
                     src.PLP_REWARD_VALUE, src.PLP_MCC_SIC_CODE,
                     TRUNC(SYSDATE), nvl(src.PLP_PI_ID_NAME, 'N/A'),
                     src.PLP_TRAN_IDENTIFIER);
            COMMIT;

            SELECT COUNT(DISTINCT(card_num))
              INTO v_rowcnt
              FROM T_RWRD_TRANSACTION_PENDING;


            IF v_rowcnt > 0 THEN
                -- It is a soft error (returns 2)
                process_status := 2;
                log_update(v_proc_name, v_post_date, v_rowcnt, 'file: ' ||
                            filename ||
                            '. Some account numbers provided in the Transaction file do not exist in ACCOUNT.T_CARD.', 'WARNING');
            ELSE
                -- Success
                process_status := 0;
                log_update(v_proc_name, v_post_date, v_rowcnt, 'file: ' ||
                            filename, 'COMPLETED');
            END IF;
            COMMIT;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            v_errmsg := SUBSTR(SQLERRM, 1, 500);
            log_update(v_proc_name, v_post_date, v_rowcnt, v_errmsg, 'ERROR');
            COMMIT;
            raise_application_error(-20101, 'Error processing in ' ||
                                     V_PROC_NAME || '.  ' ||
                                     v_errmsg);
            COMMIT;
    END STAGE_REWARD_TRANSACTION;

END;
/

GRANT EXECUTE ON PKG_FDR_REWARDS_STAGING_P TO ODS_STG;