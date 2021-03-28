CREATE OR REPLACE PACKAGE PKG_NOTIFY_SIXFLAGS_P AS

    v_email_to            			VARCHAR2(50) := 'SixFlagsProcessing@creditone.com';
    v_unavailable_email_subject  	VARCHAR2(50) := 'Barcodes Unavailable';
    v_low_volume_email_subject 		VARCHAR2(50) := 'Low Item Codes volume';
    v_email_from          			VARCHAR2(50) := 'email.notifications@creditone.com';
    TYPE var_name_value_array IS TABLE OF t_notification_variable.variable_value%TYPE INDEX BY t_notification_variable.variable_name%TYPE;

    /******************************************************************************
    *
    *  Title:        PKG_NOTIFY_SIXFLAGS_P
    *  Schema Owner: PROCESS
    *  Created:      02/03/2021
    *  Author:       FMASSARINI
    *
    *  Description: This package is designed to process Six Flags Rewards Redemption.
    *               It will pick up pending redemptions, associate a barcode from the pool
	*				and generate a notification.
    *
    * Procedures: PROCESS_SIXFLAGS_REDEMPTIONS
    *
    * Modifications:
    *
    *    DATE        WHO                DESCRIPTION
    *
    ******************************************************************************/

    /******************************************************************************
    *
    *  Title:        PKG_NOTIFY_SIXFLAGS_P.PROCESS_SIXFLAGS_REDEMPTIONS
    *  Schema Owner: PROCESS
    *  Created:      02/03/2021
    *  Author:       FMASSARINI
    *
    *  Description: Picks up pending SIXFLAGS redemptions, asociates a valid barcode
	*				and send a notification.
    *
    *  Modifications:
    *
    *    DATE        WHO                DESCRIPTION
    *
    ******************************************************************************/
    PROCEDURE PROCESS_SIXFLAGS_REDEMPTIONS;


END;
/

CREATE OR REPLACE PACKAGE BODY PKG_NOTIFY_SIXFLAGS_P AS

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
        *  Title:       PKG_NOTIFY_SIXFLAGS_P.sxflgs_codes_unavailable_notif
        *  Created:     02/03/2021
        *  Author:     FMASSARINI
        *
        *  Description: Alert Six Flags Processing team of unavailable barcodes by sending email.
        *  Modifications:
        *
        *    DATE        WHO                DESCRIPTION
        *  02/03/2021    FMASSARINI           Initial procedure
    ******************************************************************************/
    PROCEDURE sxflgs_codes_unavailable_notif(v_items_list          IN VARCHAR2) IS
        v_dbenv VARCHAR2(30);
    BEGIN
        SELECT SYS_CONTEXT('USERENV', 'DB_NAME')
          INTO v_dbenv
          FROM DUAL;

        pkg_notify.send_email('REWARDS', 'The redemption process has failed to process some records due to a lack of available codes ' ||
										 'for the following items: <br>' || v_items_list,
                                         v_email_from, v_email_to, '[' ||
                               UPPER(v_dbenv) ||
                               ']: REWARDS_SIXFLAGS PROCESS WARNING - ' ||
                               v_unavailable_email_subject);
    END sxflgs_codes_unavailable_notif;
	
    /******************************************************************************
        *
        *  Title:       PKG_NOTIFY_SIXFLAGS_P.sxflgs_codes_low_vol_notif
        *  Created:     02/03/2021
        *  Author:     FMASSARINI
        *
        *  Description: Alert Six Flags Processing team of low volume barcodes by sending email.
        *  Modifications:
        *
        *    DATE        WHO                DESCRIPTION
        *  02/03/2021    FMASSARINI           Initial procedure
    ******************************************************************************/
    PROCEDURE sxflgs_codes_low_vol_notif(v_items_list          IN VARCHAR2) IS
        v_dbenv VARCHAR2(30);
    BEGIN
        SELECT SYS_CONTEXT('USERENV', 'DB_NAME')
          INTO v_dbenv
          FROM DUAL;

        pkg_notify.send_email('REWARDS', 'The following items have passed the low volume threshold ' ||
										 'and will soon run out of available codes.<br>' || v_items_list,
                                         v_email_from, v_email_to, '[' ||
                               UPPER(v_dbenv) ||
                               ']: REWARDS_SIXFLAGS PROCESS WARNING - ' ||
                               v_low_volume_email_subject);
    END sxflgs_codes_low_vol_notif;

    /******************************************************************************
    *
    *  Title:       PKG_NOTIFY_SIXFLAGS_P.fn_get_notif_tmpl_code
    *  Created:     02/08/2021
    *  Author:     FMASSARINI
    *
    *  Description: Gets the notification template based on the item template type.
    *  Modifications:
    *
    *    DATE        WHO                DESCRIPTION
    *  02/08/2021    FMASSARINI           Initial procedure
    ******************************************************************************/
    FUNCTION fn_get_notif_tmpl_code(p_tmpl_type_code  IN  t_lu_notification_template.notification_tmpl_type_code%TYPE,
                                    p_trans_type_code IN  t_lu_notification_template.notification_trans_type_code%TYPE)
    RETURN VARCHAR2 IS
  
    v_notification_tmpl_code  t_lu_notification_template.notification_tmpl_code%TYPE;
                  
    BEGIN
    SELECT nt.notification_tmpl_code
          INTO v_notification_tmpl_code
          FROM t_lu_notification_template nt
         WHERE nt.notification_tmpl_type_code = p_tmpl_type_code
           AND nt.notification_trans_type_code = p_trans_type_code
           AND nt.is_active = 1;
       
    RETURN v_notification_tmpl_code;
    END fn_get_notif_tmpl_code;
  
  /******************************************************************************
    *
    *  Title:       PKG_NOTIFY_SIXFLAGS_P.fn_get_operating_season
    *  Created:     02/08/2021
    *  Author:     FMASSARINI
    *
    *  Description: Gets the operating season based on the item code.
    *  Modifications:
    *
    *    DATE        WHO                DESCRIPTION
    *  02/08/2021    FMASSARINI           Initial procedure
    ******************************************************************************/
	FUNCTION fn_get_operating_season(p_six_flags_item     IN  t_rewards_six_flags_item.item_id%TYPE)
		RETURN VARCHAR2 IS
                  
    BEGIN
           RETURN SUBSTR(p_six_flags_item, 6, 4);
    END fn_get_operating_season;
	
	  /******************************************************************************
    *
    *  Title:       PKG_NOTIFY_SIXFLAGS_P.pr_get_barcode
    *  Created:     02/08/2021
    *  Author:     FMASSARINI
    *
    *  Description: Gets the operating season based on the item code.
    *  Modifications:
    *
    *    DATE        WHO                DESCRIPTION
    *  02/08/2021    FMASSARINI           Initial procedure
    ******************************************************************************/
	PROCEDURE pr_get_barcode(p_six_flags_item_id	IN	t_rewards_six_flags_item.id%TYPE,
							 p_barcode_id			OUT	t_rewards_six_flags_item_code.id%TYPE,
							 p_barcode 				OUT	t_rewards_six_flags_item_code.code%TYPE) IS
							 
	BEGIN
		BEGIN
			SELECT c.ID, c.CODE
			INTO p_barcode_id, p_barcode
			FROM T_REWARDS_SIX_FLAGS_ITEM_CODE c
			WHERE c.SIX_FLAGS_ITEM_ID = p_six_flags_item_id
			AND USED_DATE IS NULL
			AND ROWNUM = 1;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				p_barcode_id := 0;
				p_barcode := 0;
		END;
	END pr_get_barcode;
    
    /******************************************************************************
    *
    *  Title:       PKG_NOTIFY_SIXFLAGS_P.pr_ins_sixflags_notif
    *  Created:     02/03/2021
    *  Author:     FMASSARINI
    *
    *  Description: Generates a real time email notification for a six flags redemption.
    *  Modifications:
    *
    *    DATE        WHO                DESCRIPTION
    *  02/03/2021    FMASSARINI           Initial procedure
    ******************************************************************************/
	PROCEDURE pr_ins_sixflags_notif(p_credit_account_id 		IN t_credit_account.credit_account_id%TYPE,
									p_points_redeemed			IN t_reward_redemption_history.points_redeemed%TYPE, 
									p_redemption_date			IN t_reward_redemption_history.redemption_date%TYPE, 
									p_park_name 				IN t_rewards_six_flags_item.park_name%TYPE,
									p_offer_name 				IN t_rewards_six_flags_item.offer_name%TYPE,
									p_redeemer_email			IN t_reward_redemption_history.redeemer_email_1%TYPE,
									p_notif_tmpl_type_code		IN t_lu_rewards_offer_type.template_type_code%TYPE,
									p_item_id					IN t_rewards_six_flags_item.item_id%TYPE,
									p_item_code        			IN t_rewards_six_flags_item_code.code%TYPE,
									p_notification_id        	OUT t_notification.notification_id%TYPE) IS
									
	v_notification_variables 	var_name_value_array;
	v_source_identifier       	t_notification.source_identifier%TYPE;
	v_notification_tmpl_code	t_lu_notification_template.notification_tmpl_type_code%TYPE;
	v_variable_name           	T_NOTIFICATION_VARIABLE.VARIABLE_NAME%TYPE;
	v_variable_value          	T_NOTIFICATION_VARIABLE.VARIABLE_VALUE%TYPE;
	v_index                   	t_notification_variable.variable_name%TYPE;
	v_count                     NUMBER;
	v_cursor					SYS_REFCURSOR;
	
    BEGIN
		v_notification_tmpl_code := fn_get_notif_tmpl_code(p_notif_tmpl_type_code, 'EMAILEXTERNAL');
		
		-- Auto fill by Credit Account: FIRSTNAME, LASTNAME, CARDTYPE, CARDLAST4
		v_notification_variables('MISCELLANEOUS10') := p_points_redeemed;
		v_notification_variables('MISCELLANEOUS11') := p_park_name;
		v_notification_variables('MISCELLANEOUS12') := p_offer_name;	
		v_notification_variables('MISCELLANEOUS13') := p_item_code;
		v_notification_variables('MISCELLANEOUS17') := p_redemption_date;
		v_notification_variables('MISCELLANEOUS18') := fn_get_operating_season(p_item_id);
    
    SELECT ac.config_value
          INTO v_source_identifier
          FROM t_application_configurations ac
         WHERE ac.config_type = 'NotificationSourceIdentifier'
           AND ac.config_key = 'ITExternalSourceIdentifer';
												   
		-- Call to pkg_notification.pr_insert SP for doing the insert into the T_NOTIFICATION and T_NOTIFICATION_QUEUE		
        pkg_notification.pr_insert(p_notification_tmpl_code => v_notification_tmpl_code,
                                   p_sent_from              => NULL,
                                   p_sent_to                => p_redeemer_email,
                                   p_notification_subject   => NULL,
                                   p_message_body           => NULL,
								   p_status_type_code       => 'READY', 
								   p_is_real_time           => 1, 
								   p_sent_date              => NULL, 
								   p_requested_date         => SYSDATE, 
								   p_source_identifier      => v_source_identifier,
								   p_notification_id        => p_notification_id); 
								   
        -- insert notification (credit account verif.)
        INSERT INTO t_credit_acc_notification(notification_id, credit_account_id) VALUES (p_notification_id, p_credit_account_id);

        -- retrieve variables for this credit account and template
        pkg_notification_variable.pr_retrieve_for_crd_acct(p_notification_tmpl_code => v_notification_tmpl_code,
                                                           p_credit_account_id => p_credit_account_id,
                                                           p_result => v_cursor);

        -- insert notification variables
        LOOP
            FETCH v_cursor
                INTO v_variable_name, v_variable_value;
            EXIT WHEN v_cursor%NOTFOUND;

            INSERT INTO t_notification_variable
                (notification_variable_id, notification_id, variable_name, variable_value, variable_order)
            VALUES
                (seq_notification_variable_id.nextval, p_notification_id, v_variable_name, v_variable_value, NULL);
        END LOOP;
        CLOSE v_cursor;

        -- insert notification variables. exclude variables not present in the current template
        v_index := v_notification_variables.FIRST;
        WHILE (v_index IS NOT NULL)
        LOOP
            SELECT COUNT(*)
              INTO v_count
              FROM T_LU_NOTIFICATION_TMPL_VAR tv
             WHERE tv.VARIABLE_NAME = v_index
               AND tv.NOTIFICATION_TMPL_CODE = v_notification_tmpl_code;

            IF (v_count > 0) THEN
                INSERT INTO t_notification_variable
                    (notification_variable_id,
                     notification_id,
                     variable_name,
                     variable_value,
                     variable_order)
                VALUES
                    (seq_notification_variable_id.nextval,
                     p_notification_id,
                     v_index,
                     v_notification_variables(v_index),
                     NULL);
            END IF;

            v_index := v_notification_variables.NEXT(v_index);
        END LOOP;
    END pr_ins_sixflags_notif;
	
	
    /******************************************************************************
    *
    *  Title:        PKG_NOTIFY_SIXFLAGS_P.PROCESS_SIXFLAGS_REDEMPTIONS
    *  Schema Owner: PROCESS
    *  Created:      02/03/2021
    *  Author:       FMASSARINI
    *
    *  Description: Picks up pending SIXFLAGS redemptions, asociates a valid barcode
	*				and send a notification.
    *
    *  Modifications:
    *
    *    DATE        WHO                DESCRIPTION
    *
    ******************************************************************************/
    PROCEDURE PROCESS_SIXFLAGS_REDEMPTIONS IS
        v_process_status    	VARCHAR2(10);
        v_rowcnt       			NUMBER := 0;
        v_errmsg       			VARCHAR2(500);
        v_proc_name    			VARCHAR2(40);
        v_item_codes  			VARCHAR2(15000);
        v_formatted_item_codes  VARCHAR2(15000);
		v_barcode				VARCHAR2(20);
		v_barcode_id			NUMBER;
		v_notify_id				t_notification.notification_id%TYPE;
		
    BEGIN
        v_process_status := '0:Success';
        v_proc_name      := 'PROCESS_SIXFLAGS_REDEMPTIONS';
		
        INSERT INTO chd_process_log
            (process_name, process_date, system_name, user_name, run_date,
             status, msg, level_name, rowcnt)
        VALUES
            (v_proc_name, trunc(SYSDATE), 'REWARDS', 'NOTIFY', SYSDATE,
             'RUNNING', 'Processing records', NULL, 0);

        COMMIT;
		
		-- Loop through pending redemptions
		FOR r IN (
      SELECT rh.CREDIT_ACCOUNT_ID,
             rh.REDEMPTION_HISTORY_ID,
             DECODE(rh.POINTS_REDEEMED_SIGN,
                    '+', rh.POINTS_REDEEMED,
                    '-', -1 * rh.POINTS_REDEEMED) AS POINTS_REDEEMED,
             rh.REDEMPTION_DATE,
             rh.REDEEMER_EMAIL_1,
             s.ID AS SIX_FLAGS_ITEM_ID,
             s.ITEM_ID,
             s.PARK_NAME,
             s.OFFER_NAME,
             o.TEMPLATE_TYPE_CODE
        FROM T_REWARD_REDEMPTION_HISTORY rh
       INNER JOIN T_REWARDS_SIX_FLAGS_ITEM s
          ON (s.Id = rh.PARTNER_REDEMPTION_ITEM_ID)
       INNER JOIN T_LU_REWARDS_OFFER_TYPE o
          ON (s.OFFER_TYPE_ID = o.ID)
       WHERE rh.WEB_PRESENT_CODE = 'PLPCRD02' -- Six Flags Partner Code
         AND rh.PARTNER_REDEMPTION_ITEM_ID IS NOT NULL
         AND rh.PARTNER_REDEMPTION_ITEM_CODE_ID IS NULL
		 AND s.IS_ACTIVE = 1)
		LOOP
			--Get ItemCode From Pool
			pr_get_barcode(p_six_flags_item_id => r.SIX_FLAGS_ITEM_ID,
						   p_barcode_id => v_barcode_id,
						   p_barcode => v_barcode);
			
			IF v_barcode_id = 0 THEN
				v_formatted_item_codes:= v_formatted_item_codes || '<p>' || '- ' || r.ITEM_ID || '</p>';
				v_item_codes := v_item_codes || r.ITEM_ID || ', ';
			ELSE
				pr_ins_sixflags_notif(p_credit_account_id => r.CREDIT_ACCOUNT_ID,
									  p_points_redeemed => r.POINTS_REDEEMED, 
									  p_redemption_date => r.REDEMPTION_DATE,
									  p_park_name => r.PARK_NAME, 
									  p_offer_name => r.OFFER_NAME,
									  p_redeemer_email => r.REDEEMER_EMAIL_1,
									  p_notif_tmpl_type_code => r.TEMPLATE_TYPE_CODE,
									  p_item_id => r.ITEM_ID, 
									  p_item_code => v_barcode, 
									  p_notification_id => v_notify_id);
				
				IF v_notify_id IS NOT NULL THEN
					UPDATE T_REWARD_REDEMPTION_HISTORY
					SET	PARTNER_REDEMPTION_ITEM_CODE_ID = v_barcode_id,
						NOTIFICATION_ID = v_notify_id,
						EMAIL_SEND_DATE = SYSDATE
					WHERE REDEMPTION_HISTORY_ID = r.REDEMPTION_HISTORY_ID;
					
					UPDATE T_REWARDS_SIX_FLAGS_ITEM_CODE
					SET	USED_DATE = SYSDATE, STATUS_CHANGED_DATE = SYSDATE
					WHERE ID = v_barcode_id;
					
					v_rowcnt := v_rowcnt + 1;
				END IF;
			END IF;
		END LOOP;
		
		COMMIT;
		
		-- Sends email with information about missing barcodes
        IF (v_item_codes IS NOT NULL) THEN          
            sxflgs_codes_unavailable_notif(v_formatted_item_codes);
            
			v_process_status := '1:Warning';
			
			-- Logs the sending of the email
            INSERT INTO chd_process_log
                (process_name, process_date, system_name, user_name,
				run_date, status, msg, level_name, rowcnt)
            VALUES
				(v_proc_name, SYSDATE, 'REWARDS', 'NOTIFY',
                SYSDATE, 'WARNING',
                substr('Unavailable codes email sent to Six Flags Processing with item codes: ' ||
					v_item_codes, 0, 500), NULL, 0);
            COMMIT;
        END IF;
		
		-- Validate barcodes volume and notify if necessary
		v_formatted_item_codes := '';
		v_item_codes := '';
		
		FOR i IN (
			SELECT DISTINCT i.ID,
                i.ITEM_ID,
                i.LOW_VOLUME_THRESHOLD,
                COUNT(CASE
                        WHEN c.ID IS NOT NULL AND c.USED_DATE IS NULL THEN 1 END)
						OVER(PARTITION BY i.ID) AS COUNT
			FROM T_REWARDS_SIX_FLAGS_ITEM i
			LEFT OUTER JOIN T_REWARDS_SIX_FLAGS_ITEM_CODE c
				ON (i.ID = c.SIX_FLAGS_ITEM_ID))
		LOOP
			IF (i.COUNT <= i.LOW_VOLUME_THRESHOLD) THEN
				v_formatted_item_codes:= v_formatted_item_codes || '<p>' || '- ' || i.ITEM_ID || '</p>';
				v_item_codes := v_item_codes || i.ITEM_ID || ', ';
			END IF;
		END LOOP;
		
		IF (v_item_codes IS NOT NULL) THEN
            -- Sends email with information about low barcode volume
            sxflgs_codes_low_vol_notif(v_formatted_item_codes);
            
			v_process_status := '1:Warning';
      
			-- Logs the sending of the email
            INSERT INTO chd_process_log
                (process_name, process_date, system_name, user_name,
				run_date, status, msg, level_name, rowcnt)
            VALUES
				(v_proc_name, SYSDATE, 'REWARDS', 'NOTIFY',
                SYSDATE, 'WARNING',
                substr('Low volume codes email sent to Six Flags Processing with item codes: ' ||
					v_item_codes, 0, 500), NULL, 0);
					
			COMMIT;
		END IF;
		
    log_update(v_proc_name, trunc(SYSDATE), v_rowcnt, 'Status: ' || v_process_status, 'COMPLETED');	
	COMMIT;
        
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            v_errmsg := SUBSTR(SQLERRM, 1, 500);
			      v_process_status := '2:Error';
            log_update(v_proc_name, SYSDATE, 0, v_errmsg, 'ERROR');
            COMMIT;
            raise_application_error(-20101, 'Error processing in ' ||
                                     V_PROC_NAME || '.  ' ||
                                     v_errmsg);
    END PROCESS_SIXFLAGS_REDEMPTIONS;

END;
/
