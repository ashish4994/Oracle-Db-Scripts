CREATE OR REPLACE PACKAGE IFLOW.PKG_T_RT_R AS
    -- ACCUREV RISK160 version  DRB 6/2/09
    --added fee waiver liquidation status to getCurrentSummaryLookups
    -- ACCUREV initial version  DRB 6/2/09 was version 11
    -- 11/15/2009         WO3029                 Natalie Matusevich
    -- 01/13/2010         COMP-23                Natalie Matusevich
    -- 02/12/2010         MK-327                 Natalie Matusevich
    -- 07/29/2010         RISK 183               Dave Krakow
    -- 05/16/2018         RISK-232		 Sebastian Zunini	
    /******************************************************************************
    *
    *  Title:        pkg_t_rt
    *  Schema Owner: IFLOW
    *  Created:      March 29, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: All related IFLOWections lookup functions and procedures
    *        Functions:
    *              N/A
    *        Procedures:
    *              get_script_by_id
    *              get_scripts_by_type
    *              get_billing_cycle_code
    *              get_payment_due_dates
    *              Is_pricing_strategy_expired
    *              get_cli_override_reasons
    *              get_cli_override_reason_bycode
    *              get_cli_override_days
    *              get_ptp_rules
    *              get_ptp_rules_bytype
    *              get_lu_coll_paymentopt
    *              get_lu_coll_paymenttype
    *              get_lu_coll_noptp
    *              get_lu_coll_refusalrsn
    *              get_lu_coll_item_byid
    *              get_securedconv_disclosure
    *              get_pricing_strategy_desc
    *
    *  Modifications:
    *    BR#: COLL-064 MODIFICATIONS:
    *      1.  ADDED ADDITIONAL LOOKUP CALLS IN ADDITION TO EXISTING PROCEDURES.
    *    Risk-088 Reopen Phase II MODIFICATIONS:
    *      1.  ADDED ADDITIONAL LOOKUP CALL get_securedconv_disclosure.
    *      2.  MODIFIED TO RETURN THE APPROPRIATE CURSOR BASED ON I_CARD_TYPE
    *    Risk-088 Reopen Phase II Modifications:
    *      1.  Added new lookup get_pricing_strategy_desc().
    *    MK-327  Added SPs to retrieve t_rt_script.script_definition based on type_id
    *             and pricing strategy
    *
    ******************************************************************************/
    TYPE t_ref_cursor IS REF CURSOR;

    /******************************************************************************
    *
    *  Title:        fn_is_acct_bankrupt
    *  Schema Owner: Iflow
    *  Created:      09-AUG-2012
    *  Author:       Arun Asokan
    *
    *  Description:  Given external Status AND reason Code,.
    *                It'll tell if its bankrupt(1) or not(0).
    *
    *  Modifications:
    *
    *   DATE        WHO         DESCRIPTION
    * 09-AUG-2012   AASOKAN     Initial Function for RISK186.
    ******************************************************************************/
    FUNCTION fn_is_acct_bankrupt(p_estat IN account.external_status%TYPE,
                                 p_rsn_cd IN account.status_reason%TYPE)
        RETURN NUMBER;

    /******************************************************************************
    *
    *  Title:        get_script_pricingstrategy
    *  Schema Owner: IFLOW
    *  Created:      February 12, 2010
    *  Author:       N. Matusevich
    *
    *  Description: Retrieve the script for script types broken down by
    *                pricing strategy using ly_pricing_script_mapping table
    *
    *  Modifications:
    ******************************************************************************/

    PROCEDURE get_script_pricingstrategy(p_pricing_strategy_code VARCHAR2,
                                         p_script_type_desc      VARCHAR2,
                                         p_script_return         OUT SYS_REFCURSOR);
    PROCEDURE get_script_by_id(i_script_id        IN NUMBER,
                               i_script_desc_type IN VARCHAR2,
                               i_rt_script        OUT t_ref_cursor);
    PROCEDURE get_scripts_by_type(i_script_desc_type IN VARCHAR2,
                                  i_rt_script_type   OUT t_ref_cursor);
    PROCEDURE get_billing_cycle_code(i_bill_cycle_type    IN VARCHAR2,
                                     i_billing_cycle_code OUT t_ref_cursor);
    PROCEDURE get_payment_due_dates(i_ref OUT t_ref_cursor);
    PROCEDURE Is_pricing_strategy_expired(i_pricing_strategy_code IN VARCHAR2,
                                          i_is_expired_flag       OUT VARCHAR2);
    --///////////////////////////////////////////////////////// - 01/19/2005
    -- R.Rodriguez
    -- Description: This will retreive all CLI Override Reasons per BR: AS-027.
    PROCEDURE get_cli_override_reasons(i_ref OUT t_ref_cursor);
    --///////////////////////////////////////////////////////// - 01/19/2005
    -- R.Rodriguez
    -- Description: This will retreive specific Override Reason code information per BR: AS-027.
    PROCEDURE get_cli_override_reason_bycode(i_code IN VARCHAR2,
                                             i_ref  OUT t_ref_cursor);
    --///////////////////////////////////////////////////////// - 01/19/2005
    -- R.Rodriguez
    -- Description: This will retreive CLI Override decrease days per BR: AS-027.
    PROCEDURE get_cli_override_days(i_ref OUT t_ref_cursor);
    /******************************************************************************
    *
    *  Title:        get_lu_coll_paymentopt
    *  Schema Owner: IFLOW
    *  Created:      March 29, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: Retreive all payment option group items in T_RT_LOOKUP
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_lu_coll_paymentopt(i_ref OUT t_ref_cursor);
    /******************************************************************************
    *
    *  Title:        get_lu_coll_paymenttype
    *  Schema Owner: IFLOW
    *  Created:      March 29, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: Retreive all payment type group items in T_RT_LOOKUP
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_lu_coll_paymenttype(i_ref OUT t_ref_cursor);
    /******************************************************************************
    *
    *  Title:        get_lu_coll_noptp
    *  Schema Owner: IFLOW
    *  Created:      March 29, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: Retreive all no ptp reasons group items in T_RT_LOOKUP
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_lu_coll_noptp(i_ref OUT t_ref_cursor);
    /******************************************************************************
    *
    *  Title:        get_lu_coll_refusalrsn
    *  Schema Owner: IFLOW
    *  Created:      March 29, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: Retreive all refusal reasons group items in T_RT_LOOKUP
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_lu_coll_refusalrsn(i_ref OUT t_ref_cursor);
    /******************************************************************************
    *
    *  Title:        get_lu_coll_item_byid
    *  Schema Owner: IFLOW
    *  Created:      March 29, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: Retreive specific PTP lookup item information from
    *                T_RT_LOOKUP by ID (LOOKUP_ID).
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_lu_coll_item_byid(i_lookup_id NUMBER,
                                    i_ref       OUT t_ref_cursor);
    /******************************************************************************
    *
    *  Title:        get_ptp_rules
    *  Schema Owner: IFLOW
    *  Created:      March 29, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: Retreive all ptp payment rules in t_rt_coll_ptp_paymentdate_rules.
    *                This is used to determine how many days before and after the
    *                current date to add as date range for PTP.
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_ptp_rules(i_ref OUT t_ref_cursor);
    /******************************************************************************
    *
    *  Title:        get_ptp_rules_bytype
    *  Schema Owner: IFLOW
    *  Created:      March 29, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: Retreive specific item information in
    *                t_rt_coll_ptp_paymentdate_rules by type (ptp_type).
    *                This is used to determine how many days before and after the
    *                current date to add as date range for PTP.
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_ptp_rules_bytype(i_ptp_type VARCHAR2,
                                   i_ref      OUT t_ref_cursor);
    /******************************************************************************
    *
    *  Title:        get_securedconv_disclosure
    *  Schema Owner: IFLOW
    *  Created:      April 14, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: Retrieve all text secured converted to unsecured disclosure
    *                paramerter values in T_RT_LOOKUP.
    *
    *  Modifications:
    *    DATE        WHO                DESCRIPTION
    *    04/18/2005    R.RRODRIGUEZ    ADDED NEW PARAMETER i_card_type THAT WILL BE USED
    *                                TO RETURN THE CORRECT CURSOR (SECURED/UNSECURED).
    ******************************************************************************/
    PROCEDURE get_securedconv_disclosure(i_card_type         VARCHAR2,
                                         i_disclosure_number VARCHAR2,
                                         i_ref               OUT t_ref_cursor);
    /******************************************************************************
    *
    *  Title:        get_pricing_strategy_desc
    *  Schema Owner: IFLOW
    *  Created:      May 02, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: Retrieve the pricing description (price_strategy_desc)
    *                based on pricing strategy. (created for risk-088 reopen phase II)
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_pricing_strategy_desc(i_pricing_strategy VARCHAR2,
                                        i_ref              OUT t_ref_cursor);
    /******************************************************************************
    *
    *  Title:        get_LookUpDesc_By_LookupValue
    *  Schema Owner: IFLOW
    *  Created:      Decemeber 22, 2005
    *  Author:       R. Penuela
    *
    *  Description: Retrieves the lookup Description based on lookupType and lookupValue
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_LookUpDesc_By_LookupValue(i_lookupType  VARCHAR2,
                                            i_lookupValue VARCHAR2,
                                            i_result      OUT STRING);

    /******************************************************************************
    *
    *  Title:        get_LookUpData
    *  Schema Owner: IFLOW
    *  Created:      Decemeber 30, 2005
    *  Author:       R. Penuela
    *
    *  Description: Retrieves the lookup Data based on lookupType
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_LookUpData(i_lookupType VARCHAR2,
                             i_result     OUT t_ref_cursor);

    /******************************************************************************
    *
    *  Title:        get_CIUAction
    *  Schema Owner: IFLOW
    *  Created:      Decemeber 30, 2005
    *  Author:       R. Penuela
    *
    *  Description: Retrieves the CIU Action if allowed based on status code,
    *                product code
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_CIUAction(i_result OUT t_ref_cursor);

    /******************************************************************************
    *  Title:       get_QueueList_by_EmployeeID
    *  Created:     March 24, 2006
    *  Author:      Romena Penuela
    *
    *  Description: This will retrieve a list of queues a given agent is allowed
    *                to access or has permission
    *
    *  Modifications:
    *  July 11, 2011 Modified for RISK185 Secured Queues
    ******************************************************************************/
    PROCEDURE get_QueueList_by_EmployeeID(i_employeeID IN NUMBER,
                                          i_ref        OUT t_ref_cursor);

    /******************************************************************************
    *
    *  Title:        get_annual_fee
    *  Schema Owner: IFLOW
    *  Created:      May 31, 2006
    *  Author:       A.Mulukutla
    *
    *  Description: Retrieve the annual fee
    *                based on pricing strategy.
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_annual_fee(i_pricing_strategy VARCHAR2,
                             i_ref              OUT t_ref_cursor);


    /******************************************************************************
    *
    *  Title:        get_AlertNotes
    *  Schema Owner: IFLOW
    *  Created:      May 16, 2006
    *  Author:       P.Riley
    *
    *  Description: Returns all available alert notes
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_AlertNotes(i_result OUT t_ref_cursor);

    /******************************************************************************
    *
    *  Title:        get_AccountAlerts
    *  Schema Owner: IFLOW
    *  Created:      July 13, 2006
    *  Author:       BJ Perna
    *
    *  Description: Retrieve all the alert notes of a given type for an account.
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_AccountAlerts(cardNumber    IN t_card.card_num%TYPE,
                                alertNoteType IN VARCHAR2,
                                i_ref         OUT t_ref_cursor);
    /******************************************************************************
    *  Title:        get_GetCurrentSummaryLookups
    *  Schema Owner: IFLOW
    *  Created:      July 13, 2006
    *  Author:       BJ Perna
    *
    *  Description: Retrieve lookup values for get current summary.
    *  DATE            WHO                DESCRIPTION
    *  07/21/2006    R.PENUELA        ADDED CREDIT BUREAU FLAG DESC, SAVINGS BALANCE,
    *                                ISCLILASTREJECT > 90 DAYS
    *  01/13/2010    N.Matusevich    Added account_id
    ******************************************************************************/
    PROCEDURE get_GetCurrentSummaryLookups(extStat          IN VARCHAR2,
                                           extStatRsn       IN VARCHAR2,
                                           intStat          IN VARCHAR2,
                                           sysId            IN VARCHAR2,
                                           prinId           IN VARCHAR2,
                                           agentId          IN VARCHAR2,
                                           creditBureauFlag IN VARCHAR2,
                                           cardNumber       IN t_card.card_num%TYPE,
                                           savingsAcct      IN VARCHAR2,
                                           i_ref            OUT t_ref_cursor);

    /******************************************************************************
    *  Title:       PR_GET_FEE_EXCLUSION_FLAG
    *  Created:     August 2, 2006
    *  Author:      BJ Perna
    *
    *  Description: This will get the fee exclusion flag.
    *
    *    Modifications:
    *    Date        Who            Description
    *
    ******************************************************************************/
    PROCEDURE PR_GET_FEE_EXCLUSION_FLAG(pUseCaseTypeName IN VARCHAR2,
                                        pPricingStrategy IN VARCHAR2,
                                        pExclusionFlag   OUT VARCHAR2);

    PROCEDURE PR_GET_LTR_LIST(pREF_CURSOR OUT SYS_REFCURSOR);

    /******************************************************************************
    *  Title:       PR_GET_LTR_LIST (override with ltr_group)
    *  Created:     11/10/2006
    *  Author:      RRODRIGUEZ
    *
    *  Description: This will retrieve all letter list.
    *
    *    Modifications:
    *    Date        Who            Description
    *    11/10/2006   rrodriguez    initial procedure
    *	 06/06/2018	 cbarnes		Added new column for communication channel for suppressing the letter
    ******************************************************************************/
    PROCEDURE PR_GET_LTR_LIST(pltr_group  IN CHAR,
                              pREF_CURSOR OUT SYS_REFCURSOR);

    /******************************************************************************
    *  Title:       PR_GET_LTR_LIST (override with ltr_num, ltr_group)
    *  Created:     11/10/2006
    *  Author:      RRODRIGUEZ
    *
    *  Description: This will retrieve all letter list.
    *
    *    Modifications:
    *    Date        Who            Description
    *    11/10/2006    rrodriguez    initial procedure
    *	 06/06/2018	 cbarnes		Added new column for communication channel for suppressing the letter
    ******************************************************************************/
    PROCEDURE PR_GET_LTR_LIST(pltr_num    IN VARCHAR2,
                              pltr_group  IN CHAR,
                              pREF_CURSOR OUT SYS_REFCURSOR);

    /******************************************************************************
    *  Title:       PR_GET_LTR_VARS
    *  Created:     11/20/2006
    *  Author:      RRODRIGUEZ
    *
    *  Description: This will retrieve associated letter variables
    *
    *    Modifications:
    *    Date        Who            Description
    *    11/20/2006    rrodriguez    TS-33 initial procedure
    ******************************************************************************/
    PROCEDURE PR_GET_LTR_VARS(P_LTR_NUM IN CHAR,
                              P_SYS     IN CHAR,
                              P_PRIN    IN CHAR,
                              P_AGENT   IN CHAR,
                              P_REF     OUT SYS_REFCURSOR);

    /******************************************************************************
    *  Title:       PR_GET_LTR_TEXT
    *  Created:     11/20/2006
    *  Author:      RRODRIGUEZ
    *
    *  Description: This will retrieve the letter text contents
    *
    *    Modifications:
    *    Date        Who            Description
    *    11/20/2006    rrodriguez    TS-33 initial procedure
    ******************************************************************************/
    PROCEDURE PR_GET_LTR_TEXT(P_LTR_NUM IN CHAR,
                              P_SYS     IN CHAR,
                              P_PRIN    IN CHAR,
                              P_AGENT   IN CHAR,
                              P_REF     OUT SYS_REFCURSOR);

    /******************************************************************************
    *  Title:       PR_INSERT_LTR_LIST
    *  Created:     11/20/2006
    *  Author:      RRODRIGUEZ
    *
    *  Description: This will insert new letter to the list
    *
    *    Modifications:
    *    Date        Who            Description
    *    11/20/2006    rrodriguez    TS-33 initial procedure
    *	 06/06/2018	 cbarnes		Added new parameter for communication channel for suppressing the letter
    ******************************************************************************/
    PROCEDURE PR_INSERT_LTR_LIST(P_LTR_NUM   IN CHAR,
                                 P_LTR_DESC  IN VARCHAR2,
                                 P_LTR_GROUP IN CHAR,
								 P_COMM_CHANNEL IN T_RT_LTR_LIST.COMM_CHANNEL_CODE%TYPE DEFAULT 'LETTERS');

    /******************************************************************************
    *  Title:       PR_INSERT_LTR_VAR
    *  Created:     11/20/2006
    *  Author:      RRODRIGUEZ
    *
    *  Description: This will insert new letter variables data
    *
    *    Modifications:
    *    Date        Who            Description
    *    11/20/2006    rrodriguez    TS-33 initial procedure
    ******************************************************************************/
    PROCEDURE PR_INSERT_LTR_VAR(P_LTR_NUM        IN CHAR,
                                P_SYS            IN CHAR,
                                P_PRIN           IN CHAR,
                                P_AGENT          IN CHAR,
                                P_VAR_CAPTION_1  IN CHAR,
                                P_VAR_CAPTION_2  IN CHAR,
                                P_VAR_CAPTION_3  IN CHAR,
                                P_VAR_CAPTION_4  IN CHAR,
                                P_VAR_CAPTION_5  IN CHAR,
                                P_VAR_CAPTION_6  IN CHAR,
                                P_VAR_CAPTION_7  IN CHAR,
                                P_VAR_CAPTION_8  IN CHAR,
                                P_VAR_CAPTION_9  IN CHAR,
                                P_VAR_CAPTION_10 IN CHAR);

    /******************************************************************************
    *  Title:       PR_INSERT_LTR_TEXT
    *  Created:     11/20/2006
    *  Author:      RRODRIGUEZ
    *
    *  Description: This will insert new letter text data
    *
    *    Modifications:
    *    Date        Who            Description
    *    11/20/2006    rrodriguez    TS-33 initial procedure
    ******************************************************************************/
    PROCEDURE PR_INSERT_LTR_TEXT(P_LTR_NUM  IN CHAR,
                                 P_SYS      IN CHAR,
                                 P_PRIN     IN CHAR,
                                 P_AGENT    IN CHAR,
                                 P_CLIENT   IN CHAR,
                                 P_LTR_TYPE IN CHAR,
                                 P_PAGE_NUM IN NUMBER,
                                 P_LINE_1   IN VARCHAR2,
                                 P_LINE_2   IN VARCHAR2,
                                 P_LINE_3   IN VARCHAR2,
                                 P_LINE_4   IN VARCHAR2,
                                 P_LINE_5   IN VARCHAR2,
                                 P_LINE_6   IN VARCHAR2,
                                 P_LINE_7   IN VARCHAR2,
                                 P_LINE_8   IN VARCHAR2,
                                 P_LINE_9   IN VARCHAR2,
                                 P_LINE_10  IN VARCHAR2,
                                 P_LINE_11  IN VARCHAR2,
                                 P_LINE_12  IN VARCHAR2,
                                 P_LINE_13  IN VARCHAR2,
                                 P_LINE_14  IN VARCHAR2,
                                 P_LINE_15  IN VARCHAR2,
                                 P_LINE_16  IN VARCHAR2,
                                 P_LINE_17  IN VARCHAR2,
                                 P_LINE_18  IN VARCHAR2,
                                 P_LINE_19  IN VARCHAR2,
                                 P_LINE_20  IN VARCHAR2,
                                 P_LINE_21  IN VARCHAR2,
                                 P_LINE_22  IN VARCHAR2,
                                 P_LINE_23  IN VARCHAR2,
                                 P_LINE_24  IN VARCHAR2,
                                 P_LINE_25  IN VARCHAR2,
                                 P_LINE_26  IN VARCHAR2,
                                 P_LINE_27  IN VARCHAR2,
                                 P_LINE_28  IN VARCHAR2,
                                 P_LINE_29  IN VARCHAR2,
                                 P_LINE_30  IN VARCHAR2,
                                 P_LINE_31  IN VARCHAR2,
                                 P_LINE_32  IN VARCHAR2,
                                 P_LINE_33  IN VARCHAR2,
                                 P_LINE_34  IN VARCHAR2,
                                 P_LINE_35  IN VARCHAR2,
                                 P_LINE_36  IN VARCHAR2,
                                 P_LINE_37  IN VARCHAR2,
                                 P_LINE_38  IN VARCHAR2,
                                 P_LINE_39  IN VARCHAR2,
                                 P_LINE_40  IN VARCHAR2,
                                 P_LINE_41  IN VARCHAR2,
                                 P_LINE_42  IN VARCHAR2,
                                 P_LINE_43  IN VARCHAR2,
                                 P_LINE_44  IN VARCHAR2,
                                 P_LINE_45  IN VARCHAR2,
                                 P_LINE_46  IN VARCHAR2,
                                 P_LINE_47  IN VARCHAR2,
                                 P_LINE_48  IN VARCHAR2,
                                 P_LINE_49  IN VARCHAR2,
                                 P_LINE_50  IN VARCHAR2,
                                 P_LINE_51  IN VARCHAR2,
                                 P_LINE_52  IN VARCHAR2,
                                 P_LINE_53  IN VARCHAR2,
                                 P_LINE_54  IN VARCHAR2,
                                 P_LINE_55  IN VARCHAR2,
                                 P_LINE_56  IN VARCHAR2,
                                 P_LINE_57  IN VARCHAR2,
                                 P_LINE_58  IN VARCHAR2,
                                 P_LINE_59  IN VARCHAR2,
                                 P_LINE_60  IN VARCHAR2,
                                 P_LINE_61  IN VARCHAR2,
                                 P_LINE_62  IN VARCHAR2,
                                 P_LINE_63  IN VARCHAR2,
                                 P_LINE_64  IN VARCHAR2,
                                 P_LINE_65  IN VARCHAR2,
                                 P_LINE_66  IN VARCHAR2,
                                 P_LINE_67  IN VARCHAR2,
                                 P_LINE_68  IN VARCHAR2,
                                 P_LINE_69  IN VARCHAR2,
                                 P_LINE_70  IN VARCHAR2,
                                 P_LINE_71  IN VARCHAR2,
                                 P_LINE_72  IN VARCHAR2,
                                 P_LINE_73  IN VARCHAR2,
                                 P_LINE_74  IN VARCHAR2,
                                 P_LINE_75  IN VARCHAR2,
                                 P_LINE_76  IN VARCHAR2,
                                 P_LINE_77  IN VARCHAR2,
                                 P_LINE_78  IN VARCHAR2,
                                 P_LINE_79  IN VARCHAR2,
                                 P_LINE_80  IN VARCHAR2);

    /******************************************************************************
    *  Title:       PR_UPDATE_LTR_LIST
    *  Created:     10/21/2010
    *  Author:      JOE AGSTER
    *
    *  Description: This will update a letter in the list. Replaces IFLOW DU_LETTER_LIST
    *
    *    Modifications:
    *    Date            Who            Description
    *    10/21/2010      jagster        WO13013 - IFLOW Conversion
    ******************************************************************************/
    PROCEDURE PR_UPDATE_LTR_LIST(P_LTR_NUM   IN CHAR,
                                 P_LTR_DESC  IN VARCHAR2,
                                 P_LTR_GROUP IN CHAR);

    /******************************************************************************
    *  Title:       PR_DELETE_LTR_LIST
    *  Created:     10/21/2010
    *  Author:      JOE AGSTER
    *
    *  Description: This will delete a letter in the list. Replaces IFLOW DU_LETTER_LIST
    *
    *    Modifications:
    *    Date            Who            Description
    *    10/21/2010      jagster        WO13013 - IFLOW Conversion
    ******************************************************************************/
    PROCEDURE PR_DELETE_LTR_LIST(P_LTR_NUM IN CHAR);

    /******************************************************************************
    *  Title:       PR_GetClosureRevEvalInfo
    *  Created:     08/22/2007
    *  Author:      R.Penuela
    *
    *  Description: This will gather closure reversal decline letter and message display
    *
    *    Modifications:
    *    Date        Who            Description
     ******************************************************************************/
    PROCEDURE PR_GetClosureRevEvalInfo(p_closureEvalCode IN VARCHAR2,
                                       p_letterNumber    OUT VARCHAR2,
                                       p_msgDisplay      OUT VARCHAR2,
                                       p_letterPrintHost OUT VARCHAR2, 
                                       p_declineReason   OUT VARCHAR2);

    /******************************************************************************
    *  Title:       PR_GetPaymentInquiryScripts
    *  Created:     10/11/2010
    *  Author:      Jasdeep Madan
    *
    *  Description: TS-49 SEC 5
    *
    *    Modifications:
    *    Date        Who            Description
     ******************************************************************************/

    PROCEDURE PR_GetPaymentInquiryScripts(i_ref OUT t_ref_cursor);

    /******************************************************************************
    *  Title:       pr_get_lookup_value
    *  Created:     6/10/2011
    *  Author:      Shirley Steen
    *
    *  Description: RISK190  Replaces customer.pkg_cli.get_cli_existing_line. This
    *               is a more generic lookup on t_rt_lookup and t_rt_lookup_type.
    *
    *    Modifications:
    *    Date        Who            Description
     ******************************************************************************/
    PROCEDURE pr_get_lookup_value(p_lookup_type_desc IN VARCHAR2,
                                  p_lookup_desc      IN VARCHAR2,
                                  p_is_found         OUT NUMBER,
                                  p_value            OUT VARCHAR2);

END PKG_T_RT_R;
/
CREATE OR REPLACE PACKAGE BODY IFLOW.PKG_T_RT_R IS

    /******************************************************************************
    *
    *  Title:        fn_is_acct_bankrupt
    *  Schema Owner: Iflow
    *  Created:      09-AUG-2012
    *  Author:       Arun Asokan
    *
    *  Description:  Given external Status AND reason Code,.
    *                It'll tell if its bankrupt(1) or not(0).
    *
    *  Modifications:
    *
    *   DATE        WHO         DESCRIPTION
    * 09-AUG-2012   AASOKAN     Initial Function for RISK186.
    ******************************************************************************/
    FUNCTION fn_is_acct_bankrupt(p_estat IN account.external_status%TYPE,
                                 p_rsn_cd IN account.status_reason%TYPE)
        RETURN NUMBER IS
       v_is_bankrupt pls_integer := 0;
      BEGIN

        CASE
            WHEN p_estat = 'B' THEN
                v_is_bankrupt := 1;
            WHEN p_rsn_cd = '89' THEN
                v_is_bankrupt :=  1;
            ELSE
                v_is_bankrupt :=  0;
        END CASE;

         RETURN v_is_bankrupt;

      END fn_is_acct_bankrupt;

    /******************************************************************************
    *
    *  Title:        pkg_t_rt
    *  Schema Owner: IFLOW
    *  Created:      March 29, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: All related IFLOWections lookup functions and procedures
    *                Functions:
    *                            N/A
    *                Procedures:
    *                            get_script_by_id
    *                            get_scripts_by_type
    *                            get_billing_cycle_code
    *                            get_payment_due_dates
    *                            Is_pricing_strategy_expired
    *                            get_cli_override_reasons
    *                            get_cli_override_reason_bycode
    *                            get_cli_override_days
    *                            get_ptp_rules
    *                            get_ptp_rules_bytype
    *                            get_lu_coll_paymentopt
    *                            get_lu_coll_paymenttype
    *                            get_lu_coll_noptp
    *                            get_lu_coll_refusalrsn
    *                            get_lu_coll_item_byid
    *                            get_securedconv_disclosure
    *                            get_pricing_strategy_desc
    *
    *  Modifications:
    *        BR#: COLL-064 MODIFICATIONS:
    *            1.    ADDED ADDITIONAL LOOKUP CALLS IN ADDITION TO EXISTING PROCEDURES.
    *        Risk-088 Reopen Phase II MODIFICATIONS:
    *            1.    ADDED ADDITIONAL LOOKUP CALL get_securedconv_disclosure.
    *            2.    MODIFIED TO RETURN THE APPROPRIATE CURSOR BASED ON I_CARD_TYPE
    *        Risk-088 Reopen Phase II Modifications:
    *            1.    Added new lookup get_pricing_strategy_desc().
    *
    ******************************************************************************/
    PROCEDURE get_script_pricingstrategy(p_pricing_strategy_code VARCHAR2,
                                         p_script_type_desc      VARCHAR2,
                                         p_script_return         OUT SYS_REFCURSOR) AS
        v_pricing_strategy_code t_lu_pricing_script_mapping.pricing_strategy_code%TYPE;
        v_script_type_desc      t_rt_script_type.script_type_desc%TYPE;
    BEGIN
        v_pricing_strategy_code := p_pricing_strategy_code;
        v_script_type_desc      := p_script_type_desc;
        OPEN p_script_return FOR
            SELECT scr.script_id,
                   scr.script_type_id,
                   scr.script_lookup_order,
                   scr.script_definition
              FROM t_lu_pricing_script_mapping map_
              JOIN t_rt_script_type scr_type
                ON (map_.script_type_id = scr_type.script_type_id)
              JOIN t_rt_script scr
                ON (scr.script_id = map_.script_type_id AND
                   scr.script_type_id = map_.script_id)
               AND NVL(SCR.active_flag, 0) = 1
               AND map_.pricing_strategy_code = v_pricing_strategy_code
               AND scr_type.script_type_desc = v_script_type_desc
             ORDER BY script_lookup_order;
    END get_script_pricingstrategy;

    --////////////////////////////////////////////////////
    PROCEDURE get_script_by_id(i_script_id        IN NUMBER,
                               i_script_desc_type IN VARCHAR2,
                               i_rt_script        OUT t_ref_cursor) IS
    BEGIN
        OPEN i_rt_script FOR
            SELECT s.script_id,
                   s.script_type_id,
                   script_lookup_order,
                   script_definition
              FROM t_rt_script      s,
                   t_rt_script_type st
             WHERE s.script_id = st.script_type_id
               AND s.script_type_id = i_script_id
               AND st.script_type_desc = i_script_desc_type
               AND s.active_flag = '1'
             ORDER BY script_lookup_order ASC;
    END get_script_by_id;
    PROCEDURE get_scripts_by_type(i_script_desc_type IN VARCHAR2,
                                  i_rt_script_type   OUT t_ref_cursor) IS
    BEGIN
        OPEN i_rt_script_type FOR
            SELECT s.script_id,
                   s.script_type_id,
                   script_lookup_order,
                   script_definition
              FROM t_rt_script      s,
                   t_rt_script_type st
             WHERE s.script_id = st.script_type_id
               AND st.script_type_desc = i_script_desc_type
               AND s.active_flag = '1'
             ORDER BY script_lookup_order ASC;
    END get_scripts_by_type;
    --////////////////////////////////////////////// - 7/20/2004
    PROCEDURE get_billing_cycle_code(i_bill_cycle_type    IN VARCHAR2,
                                     i_billing_cycle_code OUT t_ref_cursor) IS
    BEGIN
        OPEN i_billing_cycle_code FOR
            SELECT L.lookup_id,
                   L.lookup_type_id,
                   L.lookup_desc,
                   L.lookup_value,
                   L.active
              FROM T_RT_LOOKUP      L,
                   T_RT_LOOKUP_TYPE LT
             WHERE L.LOOKUP_TYPE_ID = LT.LOOKUP_TYPE_ID
               AND LT.LOOKUP_TYPE_DESC = i_bill_cycle_type
               AND ACTIVE = 1;
    END;
    --/////////////////////////////////////////////////////////// - 7/30/2004
    PROCEDURE get_payment_due_dates(i_ref OUT t_ref_cursor) IS
    BEGIN
        OPEN i_ref FOR
            SELECT LOOKUP_VALUE,
                   LOOKUP_DESC
              FROM T_RT_LOOKUP
             WHERE LOOKUP_TYPE_ID = 81
               AND ACTIVE = 1
             ORDER BY LOOKUP_DESC;
    END;
    --/////////////////////////////////////////////////////////// - 7/30/2004
    PROCEDURE Is_pricing_strategy_expired(i_pricing_strategy_code IN VARCHAR2,
                                          i_is_expired_flag       OUT VARCHAR2) IS
        i_expired_flag VARCHAR2(1);
    BEGIN
        SELECT DECODE(expired, ' ', 'F', 'Y', 'T', expired)
          INTO i_expired_flag
          FROM T_RT_fees
         WHERE pricing_strategy = i_pricing_strategy_code;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20212, 'Pricing strategy not found.');
    END;
    --///////////////////////////////////////////////////////// - 01/19/2005
    -- R.Rodriguez
    -- Description: This will retreive all CLI Override Reasons per BR: AS-027.
    PROCEDURE get_cli_override_reasons(i_ref OUT t_ref_cursor) IS
    BEGIN
        OPEN i_ref FOR
            SELECT CODE,
                   DESCRIPTION,
                   INCREASE_CODE,
                   DECREASE_CODE
              FROM LU_CLI_OVERRIDE_REASON
             ORDER BY DESCRIPTION DESC;
    END;
    --///////////////////////////////////////////////////////// - 01/19/2005
    -- R.Rodriguez
    -- Description: This will retreive specific Override Reason code information per BR: AS-027.
    PROCEDURE get_cli_override_reason_bycode(i_code IN VARCHAR2,
                                             i_ref  OUT t_ref_cursor) IS
    BEGIN
        OPEN i_ref FOR
            SELECT CODE,
                   DESCRIPTION,
                   INCREASE_CODE,
                   DECREASE_CODE
              FROM LU_CLI_OVERRIDE_REASON
             WHERE CODE = i_code;
    END;
    --///////////////////////////////////////////////////////// - 01/19/2005
    -- R.Rodriguez
    -- Description: This will retreive CLI Override decrease days per BR: AS-027.
    PROCEDURE get_cli_override_days(i_ref OUT t_ref_cursor) IS
    BEGIN
        OPEN i_ref FOR
            SELECT l.LOOKUP_VALUE
              FROM t_rt_lookup_type lt,
                   t_rt_lookup      l
             WHERE UPPER(lt.LOOKUP_TYPE_DESC) = 'CLI OVERRIDE DAYS'
               AND l.LOOKUP_TYPE_ID = lt.LOOKUP_TYPE_ID
             ORDER BY l.lookup_value DESC;
    END;
    /******************************************************************************
    *
    *  Title:        get_lu_coll_paymentopt
    *  Schema Owner: IFLOW
    *  Created:      March 29, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: Retreive all payment option group items in T_RT_LOOKUP
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_lu_coll_paymentopt(i_ref OUT t_ref_cursor) IS
    BEGIN
        OPEN i_ref FOR
            SELECT l.lookup_id,
                   l.lookup_type_id,
                   t.lookup_type_desc,
                   l.lookup_value,
                   l.lookup_desc
              FROM T_RT_LOOKUP      l,
                   T_RT_LOOKUP_TYPE t
             WHERE LOWER(t.lookup_type_desc) = 'ptpoption01'
               AND l.lookup_type_id = t.lookup_type_id;
    END;
    /******************************************************************************
    *
    *  Title:        get_lu_coll_paymenttype
    *  Schema Owner: IFLOW
    *  Created:      March 29, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: Retreive all payment type group items in T_RT_LOOKUP
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_lu_coll_paymenttype(i_ref OUT t_ref_cursor) IS
    BEGIN
        OPEN i_ref FOR
            SELECT l.lookup_id,
                   l.lookup_type_id,
                   t.lookup_type_desc,
                   l.lookup_value,
                   l.lookup_desc
              FROM T_RT_LOOKUP      l,
                   T_RT_LOOKUP_TYPE t
             WHERE LOWER(t.lookup_type_desc) = 'ptptype01'
               AND l.lookup_type_id = t.lookup_type_id;
    END;
    /******************************************************************************
    *
    *  Title:        get_lu_coll_noptp
    *  Schema Owner: IFLOW
    *  Created:      March 29, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: Retreive all no ptp reasons group items in T_RT_LOOKUP
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_lu_coll_noptp(i_ref OUT t_ref_cursor) IS
    BEGIN
        OPEN i_ref FOR
            SELECT l.lookup_id,
                   l.lookup_type_id,
                   t.lookup_type_desc,
                   l.lookup_value,
                   l.lookup_desc
              FROM T_RT_LOOKUP      l,
                   T_RT_LOOKUP_TYPE t
             WHERE LOWER(t.lookup_type_desc) = 'noptpreason01'
               AND l.lookup_type_id = t.lookup_type_id;
    END;
    /******************************************************************************
    *
    *  Title:        get_lu_coll_refusalrsn
    *  Schema Owner: IFLOW
    *  Created:      March 29, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: Retreive all refusal reasons group items in T_RT_LOOKUP
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_lu_coll_refusalrsn(i_ref OUT t_ref_cursor) IS
    BEGIN
        OPEN i_ref FOR
            SELECT l.lookup_id,
                   l.lookup_type_id,
                   t.lookup_type_desc,
                   l.lookup_value,
                   l.lookup_desc
              FROM T_RT_LOOKUP      l,
                   T_RT_LOOKUP_TYPE t
             WHERE LOWER(t.lookup_type_desc) = 'ptprefusalreason01'
               AND l.lookup_type_id = t.lookup_type_id;
    END;
    /******************************************************************************
    *
    *  Title:        get_lu_coll_item_byid
    *  Schema Owner: IFLOW
    *  Created:      March 29, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: Retreive specific PTP lookup item information from
    *                T_RT_LOOKUP by ID (LOOKUP_ID).
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_lu_coll_item_byid(i_lookup_id NUMBER,
                                    i_ref       OUT t_ref_cursor) IS
    BEGIN
        OPEN i_ref FOR
            SELECT l.lookup_id,
                   l.lookup_type_id,
                   t.lookup_type_desc,
                   l.lookup_value,
                   l.lookup_desc
              FROM T_RT_LOOKUP      l,
                   T_RT_LOOKUP_TYPE t
             WHERE l.lookup_id = i_lookup_id
               AND t.lookup_type_id = l.lookup_type_id;
    END;
    /******************************************************************************
    *
    *  Title:        get_ptp_rules
    *  Schema Owner: IFLOW
    *  Created:      March 29, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: Retreive all ptp payment rules in t_rt_coll_ptp_paymentdate_rules.
    *                This is used to determine how many days before and after the
    *                current date to add as date range for PTP.
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_ptp_rules(i_ref OUT t_ref_cursor) IS
    BEGIN
        OPEN i_ref FOR
            SELECT payment_rule_id,
                   ptp_type,
                   payment_days
              FROM T_RT_PTP_PAYMENTDATE_RULES;
    END;
    /******************************************************************************
    *
    *  Title:        get_ptp_rules_bytype
    *  Schema Owner: IFLOW
    *  Created:      March 29, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: Retreive specific item information in
    *                t_rt_coll_ptp_paymentdate_rules by type (ptp_type).
    *                This is used to determine how many days before and after the
    *                current date to add as date range for PTP.
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_ptp_rules_bytype(i_ptp_type VARCHAR2,
                                   i_ref      OUT t_ref_cursor) IS
    BEGIN
        OPEN i_ref FOR
            SELECT payment_rule_id,
                   ptp_type,
                   payment_days
              FROM T_RT_PTP_PAYMENTDATE_RULES
             WHERE LOWER(ptp_type) = LOWER(i_ptp_type);
    END;

    /******************************************************************************
    *
    *  Title:        get_securedconv_disclosure
    *  Schema Owner: IFLOW
    *  Created:      April 14, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: Retrieve all text secured converted to unsecured disclosure
    *                paramerter values in T_RT_LOOKUP.
    *
    *  Modifications:
    *    DATE        WHO                DESCRIPTION
    *    04/18/2005    R.RRODRIGUEZ    ADDED NEW PARAMETER i_card_type THAT WILL BE USED
    *                                TO RETURN THE CORRECT CURSOR (SECURED/UNSECURED).
    *    12/16/2005  R.PENUELA        MODIFIED TO CHECK IF DISCLOSURE LETTER REQUIRES, PARAM
    *    11/16/2009  N.Matusevich     Modified the default value of v_description
    *
    ******************************************************************************/
    PROCEDURE get_securedconv_disclosure(i_card_type         VARCHAR2,
                                         i_disclosure_number VARCHAR2,
                                         i_ref               OUT t_ref_cursor) IS

        v_description VARCHAR2(30) := 'Secured Conv Disclosure';
        v_parm_flag   VARCHAR2(1);

    BEGIN

        IF i_card_type = 'Secured' THEN
            v_description := 'Secured Disclosure';
        END IF;

        --CHECK IF DISCLOSURE REQUIRES PARAM
        SELECT DISTINCT PARAM_FLAG
          INTO v_parm_flag
          FROM T_RT_DISCLOSURE
         WHERE UPPER(DISCLOSURE_LTR) = UPPER(I_DISCLOSURE_NUMBER);

        --IF PARAM REQUIRED
        IF v_parm_flag = 'Y' THEN
            OPEN i_ref FOR
                SELECT l.lookup_id,
                       l.lookup_value,
                       l.lookup_desc
                  FROM T_RT_LOOKUP      l,
                       T_RT_LOOKUP_TYPE t
                 WHERE t.lookup_type_desc = v_description
                   AND l.lookup_type_id = t.lookup_type_id;
        END IF;


    END;

    /******************************************************************************
    *
    *  Title:        get_pricing_strategy_desc
    *  Schema Owner: IFLOW
    *  Created:      May 02, 2005
    *  Author:       R. Rodriguez
    *
    *  Description: Retrieve the pricing description (price_strategy_desc)
    *                based on pricing strategy. (created for risk-088 reopen phase II)
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_pricing_strategy_desc(i_pricing_strategy VARCHAR2,
                                        i_ref              OUT t_ref_cursor) IS
    BEGIN
        OPEN i_ref FOR
            SELECT price_strategy_desc
              FROM t_rt_fees
             WHERE pricing_strategy = i_pricing_strategy;
    END;
    /******************************************************************************
    *
    *  Title:        get_LookUpDesc_By_LookupValue
    *  Schema Owner: IFLOW
    *  Created:      Decemeber 22, 2005
    *  Author:       R. Penuela
    *
    *  Description: Retrieves the lookup Description based on lookupType and lookupValue
    *  Modifications:
    *    DATE        WHO                DESCRIPTION
    *    05/05/2010    L.PETITJEAN   IF THE PASSED IN LOOKUPVALUE IS NOT FOUND IN THE T_RT_LOOKUP TABLE
    *                                IT LOOKS UP THE DEFAULT VALUE (LU.IS_DEFAULT = 1).
    ******************************************************************************/
    PROCEDURE get_LookUpDesc_By_LookupValue(i_lookupType  VARCHAR2,
                                            i_lookupValue VARCHAR2,
                                            i_result      OUT STRING) IS
        v_count NUMBER := 0;
    BEGIN

        SELECT COUNT(1)
          INTO v_count
          FROM T_RT_LOOKUP      LU,
               T_RT_LOOKUP_TYPE LUT
      WHERE UPPER(LUT.LOOKUP_TYPE_DESC) = UPPER(i_lookupType)
           AND LU.LOOKUP_TYPE_ID = LUT.LOOKUP_TYPE_ID
           AND UPPER(LU.LOOKUP_VALUE) = UPPER(i_lookupValue);

      if (v_count = 0) then
        SELECT LU.LOOKUP_DESC
            INTO i_result
            FROM T_RT_LOOKUP      LU,
                 T_RT_LOOKUP_TYPE LUT
        WHERE UPPER(LUT.LOOKUP_TYPE_DESC) = UPPER(i_lookupType)
            AND LU.LOOKUP_TYPE_ID = LUT.LOOKUP_TYPE_ID
            AND LU.IS_DEFAULT = 1;

      else
        SELECT LU.LOOKUP_DESC
            INTO i_result
            FROM T_RT_LOOKUP      LU,
                 T_RT_LOOKUP_TYPE LUT
        WHERE UPPER(LUT.LOOKUP_TYPE_DESC) = UPPER(i_lookupType)
           AND LU.LOOKUP_TYPE_ID = LUT.LOOKUP_TYPE_ID
           AND UPPER(LU.LOOKUP_VALUE) = UPPER(i_lookupValue);
      end if;


    END get_LookUpDesc_By_LookupValue;

    /******************************************************************************
    *
    *  Title:        get_LookUpData
    *  Schema Owner: IFLOW
    *  Created:      Decemeber 30, 2005
    *  Author:       R. Penuela
    *
    *  Description: Retrieves the lookup Data based on lookupType
    *  Modifications:
    *
    *   DATE        WHO               BR/WO       DESCRIPTION
    *   09-25-15    Alagiyanathan     RISK-225    Modify the select query to include 
                                                  FdrExternal Block used for bma settings.
    ******************************************************************************/
    PROCEDURE get_LookUpData(i_lookupType VARCHAR2,
                             i_result     OUT t_ref_cursor) IS
    BEGIN
        OPEN i_result FOR
            SELECT LU.LOOKUP_ID,
                   LU.LOOKUP_TYPE_ID,
                   LU.LOOKUP_VALUE,
                   LU.LOOKUP_DESC,
                   LU.ACTIVE,
                   SUBSTR(LU.LOOKUP_DESC, 1, 1) AS FdrExternalBlock,
                   SUBSTR(LU.LOOKUP_DESC, 1, 1) || LU.LOOKUP_VALUE ||
                   SUBSTR(LU.LOOKUP_DESC,2,LENGTH(LU.LOOKUP_DESC)) AS FdrReasonCode
              FROM T_RT_LOOKUP      LU,
                   T_RT_LOOKUP_TYPE LUT
             WHERE UPPER(LUT.LOOKUP_TYPE_DESC) = UPPER(i_lookupType)
               AND LU.LOOKUP_TYPE_ID = LUT.LOOKUP_TYPE_ID
               AND LU.ACTIVE = 1;

    END get_LookUpData;

    /******************************************************************************
    *
    *  Title:        get_CIUAction
    *  Schema Owner: IFLOW
    *  Created:      Decemeber 30, 2005
    *  Author:       R. Penuela
    *
    *  Description: Retrieves the CIU Action if allowed based on status code,
    *                product code
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_CIUAction(i_result OUT t_ref_cursor) IS
        v_result VARCHAR2(1);
    BEGIN
        --         SELECT ACTION INTO
        --             v_result
        --         FROM
        --             T_RT_CIU_PERMISSION
        --         WHERE
        --             UPPER(PRODUCT_CODE) = UPPER(i_productCode) AND
        --             UPPER(STATUS_CODE) = UPPER(i_statusCode);
        --
        --         IF V_RESULT IN ('C','P') THEN
        --             i_result := 'true';
        --         ELSE
        --             i_result := 'false';
        --         END IF;
        --
        --         EXCEPTION WHEN NO_DATA_FOUND THEN
        --             i_result := 'false';
        OPEN i_result FOR
            SELECT CIU_PERMISSION_ID,
                   PRODUCT_CODE,
                   STATUS_CODE,
                   ACTION
              FROM T_RT_CIU_PERMISSION;

    END get_CIUAction;

    /******************************************************************************
    *  Title:       get_QueueList_by_EmployeeID
    *  Created:     March 24, 2006
    *  Author:      Romena Penuela
    *
    *  Description: This will retrieve a list of queues a given agent is allowed
    *                to access or has permission
    *
    *  Modifications:
    *  July 11, 2011 Modified for RISK185 Secured Queues
    ******************************************************************************/
    PROCEDURE get_QueueList_by_EmployeeID(i_employeeID IN NUMBER,
                                          i_ref        OUT t_ref_cursor) IS
    BEGIN
        OPEN i_ref FOR
            SELECT QU.QUEUE_ID,
                   QU.QUEUE_NAME
              FROM EMPLOYEE            E,
                   T_AGENT_GROUP_QUEUE Q,
                   t_iflow_queue             QU
             WHERE E.employee_id = i_employeeID
               AND E.agent_group_id = Q.agent_group_id
               AND Q.QUEUE_ID = QU.QUEUE_ID
               AND QU.SYSTEM_QUEUE = 'N'
            UNION
            SELECT QU.QUEUE_ID,
                   QU.QUEUE_NAME
              FROM EMPLOYEE       E,
                   t_iflow_queue        QU,
                   EMP_ASSIGNMENT ea,
                   department     d
             WHERE E.employee_id = i_employeeID
               AND QU.SYSTEM_QUEUE = 'N'
               AND ea.employee_id(+) = e.employee_id
               AND ea.department_id = d.department_id(+)
               AND ea.end_date IS NULL
               AND d.department_name = 'RISK'
               AND qu.queue_name = 'Secured Account Reopen - New'
            UNION
            SELECT QU.QUEUE_ID,
                   QU.QUEUE_NAME
              FROM EMPLOYEE       E,
                   t_iflow_queue        QU,
                   EMP_ASSIGNMENT ea,
                   department     d
             WHERE E.employee_id = i_employeeID
               AND QU.SYSTEM_QUEUE = 'N'
               AND ea.employee_id(+) = e.employee_id
               AND ea.department_id = d.department_id(+)
               AND ea.end_date IS NULL
               AND d.department_name IN
                   ('TRANSACTION SERVICES', 'ACCOUNT SERVICES')
               AND qu.queue_name = 'Secured Account Reopen - Approved';

    END get_QueueList_by_EmployeeID;

    /******************************************************************************
    *
    *  Title:        get_annual_fee
    *  Schema Owner: IFLOW
    *  Created:      May 31, 2006
    *  Author:       A.Mulukutla
    *
    *  Description: Retrieve the annual fee
    *                based on pricing strategy.
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_annual_fee(i_pricing_strategy VARCHAR2,
                             i_ref              OUT t_ref_cursor) IS
    BEGIN


        OPEN i_ref FOR
            SELECT Annual_Fee
              FROM t_rt_fees
             WHERE pricing_strategy = i_pricing_strategy;
    END;

    /******************************************************************************
    *
    *  Title:        get_AlertNotes
    *  Schema Owner: IFLOW
    *  Created:      May 16, 2006
    *  Author:       P.Riley
    *
    *  Description: Returns all available alert notes
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_AlertNotes(i_result OUT t_ref_cursor) IS
    BEGIN
        OPEN i_result FOR
            SELECT ALERT_NOTE_ID,
                   ALERT_TEXT,
                   ALERT_DESC
              FROM T_ALERT_NOTES
             WHERE ALERT_EXPIRATION_DATE IS NULL;


    END get_AlertNotes;

    /******************************************************************************
    *
    *  Title:        get_AccountAlerts
    *  Schema Owner: IFLOW
    *  Created:      July 12, 2006
    *  Author:       BJ Perna
    *
    *  Description: Retrieve all the alert notes of a given type for an account.
    *
    *  Modifications:
    ******************************************************************************/
    PROCEDURE get_AccountAlerts(cardNumber    IN t_card.card_num%TYPE,
                                alertNoteType IN VARCHAR2,
                                i_ref         OUT t_ref_cursor) IS
    BEGIN

        OPEN i_ref FOR
            SELECT AN.alert_text
              FROM T_ALERT_ACCOUNT   AA,
                   T_ALERT_NOTES     AN,
                   T_ALERT_NOTE_TYPE NT,
                   T_RT_LOOKUP       LU,
                   T_RT_LOOKUP_TYPE  LT
             WHERE AA.alert_acct_number = TO_NUMBER(cardNumber)
               AND UPPER(LT.LOOKUP_TYPE_DESC) = 'ALERT NOTE TYPE CATEGORY'
               AND UPPER(LU.LOOKUP_DESC) = UPPER(alertNoteType)
               AND LU.LOOKUP_TYPE_ID = LT.LOOKUP_TYPE_ID
               AND NT.lookup_id = LU.lookup_id
               AND NT.alert_note_id = AA.alert_note_id
               AND AA.alert_note_id = AN.alert_note_id
               AND (AN.alert_expiration_date IS NULL OR
                   AN.alert_expiration_date >= SYSDATE);
    END;

    /******************************************************************************
    *
    *  Title:        get_GetCurrentSummaryLookups
    *  Schema Owner: IFLOW
    *  Created:      July 13, 2006
    *  Author:       BJ Perna
    *
    *  Description: Retrieve lookup values for get current summary.
    *
    *  Modifications:
    *  DATE            WHO                DESCRIPTION
    *  07/21/2006    R.PENUELA        ADDED CREDIT BUREAU FLAG DESC, SAVINGS BALANCE,
    *                                CLIDAYSLASTREJECT
    *  10/24/2006    R.Penuela        Modified to get max date for cliDaysLastReject
    *  06/02/2009    D.Brown DRB      added
    *  01/13/2010    N.Matusevich    Added account_id
    *  03/04/2011    S.Steen         COLL137  Added Bankruptcy flag.
    *  12/14/2011    S.Steen         CS9 Added internal days delinquent and cycles
    *                                delinquent to return cursor. Added call to
    *                                fn_get_cash_days_delinquent for days delinquent.
    *  04/10/2012    Jasdeep Madan        wo#26998   Added Bind Variables for Tuning after IVR New Rollout.
    *
    ******************************************************************************/
    PROCEDURE get_GetCurrentSummaryLookups(extStat          IN VARCHAR2,
                                           extStatRsn       IN VARCHAR2,
                                           intStat          IN VARCHAR2,
                                           sysId            IN VARCHAR2,
                                           prinId           IN VARCHAR2,
                                           agentId          IN VARCHAR2,
                                           creditBureauFlag IN VARCHAR2,
                                           cardNumber       IN t_card.card_num%TYPE,
                                           savingsAcct      IN VARCHAR2,
                                           i_ref            OUT t_ref_cursor)
    IS
        v_is_bankruptcy             NUMBER(1);
        v_internal_days_delinquent  NUMBER(4);
        v_process_date              DATE    := TRUNC(SYSDATE);
        v_cycles_delq               NUMBER(3);
        v_ext_status       varchar2(20):='EXTERNAL STATUS';
        v_int_status       varchar2(20):= 'INTERNAL STATUS';
        v_cred_bureu       varchar2(20):= 'CREDIT BUREAU FLAGS';
        v_ext_status_reason       varchar2(25):= 'EXTERNAL STATUS REASON';
        v_acct_id number;
        v_principal_balance number;
        v_cardnumber number;
    BEGIN

        v_is_bankruptcy := fn_is_acct_bankrupt(extstat,extStatRsn);
        v_cardnumber:= to_number(cardNumber) ;
        begin
        SELECT nvl(a.cycles_delinquent,0),account_id, PRINCIPLE_BALANCE
         INTO v_cycles_delq,v_acct_id, v_principal_balance
                     FROM account  a
                    WHERE a.card_number =  v_cardnumber  ;
          exception when no_data_found then v_cycles_delq:=0;v_acct_id:=0; v_principal_balance:= null; end;

        IF v_cycles_delq <> 0 THEN
            v_internal_days_delinquent := fn_get_cash_days_delinquent(p_cardnum => cardNumber,
                                                                      p_process_date => v_process_date,
                                                                      p_cycles_delinquent => v_cycles_delq);
        END IF;

        OPEN i_ref FOR
            SELECT (SELECT lu.lookup_desc
                      FROM t_rt_lookup      lu,
                           t_rt_lookup_type lut
                     WHERE lu.lookup_type_id = lut.lookup_type_id
                       AND UPPER(lookup_type_desc) = v_ext_status
                       AND lu.lookup_value = extStat) AS "external_status",
                   (SELECT lu.lookup_desc
                      FROM t_rt_lookup      lu,
                           t_rt_lookup_type lut
                     WHERE lu.lookup_type_id = lut.lookup_type_id
                       AND UPPER(lookup_type_desc) = v_ext_status_reason
                       AND lu.lookup_value = extStatRsn) AS "external_status_reason",
                   (SELECT lu.lookup_desc
                      FROM t_rt_lookup      lu,
                           t_rt_lookup_type lut
                     WHERE lu.lookup_type_id = lut.lookup_type_id
                       AND UPPER(lookup_type_desc) = v_int_status
                       AND lu.lookup_value = intStat) AS "internal_status",
                   (SELECT lu.lookup_desc
                      FROM t_rt_lookup      lu,
                           t_rt_lookup_type lut
                     WHERE lu.lookup_type_id = lut.lookup_type_id
                       AND UPPER(lookup_type_desc) = v_cred_bureu
                       AND lu.lookup_value = creditBureauFlag) AS "creditBureauFlag",
                   0 AS "savingsBalance",
                   pm.product AS "product_name",
                   pm.card_type AS "secure_unsecure",
                   NVL((SELECT la.offer_status
                         FROM t_liquidation_account la --,  account               a
                        WHERE la.account_id = v_acct_id), 'NONE') AS "FeeWaiverLiquidationStatus",
                   v_principal_balance AS "principal_balance",
                   v_acct_id AS "account_id",
                   v_is_bankruptcy AS "is_bankrupted",
                   v_internal_days_delinquent internal_days_delinquent,
                   v_cycles_delq cycles_delq
              FROM t_rt_product_matrix pm
             WHERE pm.sys = sysId
               AND pm.prin = prinId
               AND pm.AGENT = agentId;


    END get_GetCurrentSummaryLookups;



    /******************************************************************************
    *  Title:       PR_GET_FEE_EXCLUSION_FLAG
    *  Created:     August 2, 2006
    *  Author:      BJ Perna
    *
    *  Description: This will get the fee exclusion flag.
    *
    *    Modifications:
    *    Date        Who            Description
    *
    ******************************************************************************/
    PROCEDURE PR_GET_FEE_EXCLUSION_FLAG(pUseCaseTypeName IN VARCHAR2,
                                        pPricingStrategy IN VARCHAR2,
                                        pExclusionFlag   OUT VARCHAR2) IS
    BEGIN

        SELECT 'Y'
          INTO pExclusionFlag
          FROM T_RT_FEES          F,
               T_UC_TYPE          T,
               T_RT_FEE_EXCLUSION E
         WHERE f.pricing_strategy = e.pricing_strategy
           AND e.uc_type_id = t.uc_type_id
           AND e.uc_category_id = t.uc_category_id
           AND t.uc_name = pUseCaseTypeName
           AND e.pricing_strategy = pPricingStrategy;

    EXCEPTION
        WHEN OTHERS THEN
            SELECT 'N'
              INTO pExclusionFlag
              FROM dual;

    END PR_GET_FEE_EXCLUSION_FLAG;

    /******************************************************************************
    *  Title:       PR_GET_LTR_LIST
    *  Created:     11/10/2006
    *  Author:      RRODRIGUEZ
    *
    *  Description: This will retrieve all letter list.
    *
    *    Modifications:
    *    Date        Who            Description
    *    11/10/2006    rrodriguez    TS-33 initial procedure
    *    07/27/2010    dkrakow       check active --RISK183
    *    6/28/2011     gthoms        modified risk-185
    *	 06/06/2018	 cbarnes		Added new column for communication channel for suppressing the letter
    ******************************************************************************/
    PROCEDURE PR_GET_LTR_LIST(pREF_CURSOR OUT SYS_REFCURSOR) IS

    BEGIN
        OPEN pREF_CURSOR FOR
            SELECT L.ltr_num,
                   L.ltr_group,
                   L.ltr_desc,
                   l.manual_send,
				   l.COMM_CHANNEL_CODE
              FROM T_RT_LTR_LIST L
             WHERE active = 1
             ORDER BY L.ltr_num;

    END;

    /******************************************************************************
    *  Title:       PR_GET_LTR_LIST (override with ltr_group)
    *  Created:     11/10/2006
    *  Author:      RRODRIGUEZ
    *
    *  Description: This will retrieve all letter list.
    *
    *    Modifications:
    *    Date        Who            Description
    *    11/10/2006    rrodriguez    TS-33 initial procedure
    *    07/27/2010    dkrakow       check active --RISK183
    *    6/28/2011     gthoms        modified risk-185
    *	 06/06/2018	 cbarnes		Added new column for communication channel for suppressing the letter
    ******************************************************************************/
    PROCEDURE PR_GET_LTR_LIST(pltr_group  IN CHAR,
                              pREF_CURSOR OUT SYS_REFCURSOR) IS

    BEGIN

        OPEN pREF_CURSOR FOR
            SELECT L.ltr_num,
                   L.ltr_group,
                   L.ltr_desc,
                   l.manual_send,
				   l.COMM_CHANNEL_CODE
              FROM T_RT_LTR_LIST L
             WHERE RTRIM(UPPER(L.ltr_group)) = UPPER(pltr_group)
               AND active = 1
             ORDER BY L.ltr_num;

    END;

    /******************************************************************************
    *  Title:       PR_GET_LTR_LIST (override with ltr_num, ltr_group)
    *  Created:     11/10/2006
    *  Author:      RRODRIGUEZ
    *
    *  Description: This will retrieve all letter list.
    *
    *    Modifications:
    *    Date        Who            Description
    *    11/10/2006    rrodriguez    TS-33 initial procedure
    *    6/28/2011     gthoms        modified risk-185
    *	 06/06/2018	 cbarnes		Added new column for communication channel for suppressing the letter
    ******************************************************************************/
    PROCEDURE PR_GET_LTR_LIST(pltr_num    IN VARCHAR2,
                              pltr_group  IN CHAR,
                              pREF_CURSOR OUT SYS_REFCURSOR) IS

    BEGIN

        OPEN pREF_CURSOR FOR
            SELECT L.ltr_num,
                   L.ltr_group,
                   L.ltr_desc,
                   l.manual_send,
				   l.COMM_CHANNEL_CODE
              FROM T_RT_LTR_LIST L
             WHERE RTRIM(UPPER(L.ltr_num)) = UPPER(pltr_num)
               AND RTRIM(UPPER(L.ltr_group)) = UPPER(pltr_group)
             ORDER BY L.ltr_num;

    END;


    /******************************************************************************
    *  Title:       PR_GET_LTR_VARS
    *  Created:     11/20/2006
    *  Author:      RRODRIGUEZ
    *
    *  Description: This will retrieve associated letter variables
    *
    *    Modifications:
    *    Date        Who            Description
    *    11/20/2006    rrodriguez    TS-33 initial procedure
    ******************************************************************************/
    PROCEDURE PR_GET_LTR_VARS(P_LTR_NUM IN CHAR,
                              P_SYS     IN CHAR,
                              P_PRIN    IN CHAR,
                              P_AGENT   IN CHAR,
                              P_REF     OUT SYS_REFCURSOR) IS

    BEGIN

        -- RETRIEVE LTR VARIABLES
        OPEN P_REF FOR
            SELECT DECODE(NVL(RTRIM(L.LTR_NUM), 'NONE'), 'NONE', P_LTR_NUM,
                          L.LTR_NUM) LTR_NUM,
                   L.LTR_DESC,
                   'C' LTR_TYPE_CD,
                   V.SYS,
                   V.PRIN,
                   V.AGENT,
                   V.VAR_CAPTION_1,
                   V.VAR_CAPTION_2,
                   V.VAR_CAPTION_3,
                   V.VAR_CAPTION_4,
                   V.VAR_CAPTION_5,
                   V.VAR_CAPTION_6,
                   V.VAR_CAPTION_7,
                   V.VAR_CAPTION_8,
                   V.VAR_CAPTION_9,
                   V.VAR_CAPTION_10
              FROM T_RT_LTR_LIST L,
                   T_RT_LTR_VAR  V
             WHERE V.LTR_NUM = P_LTR_NUM
               AND L.LTR_NUM(+) = V.LTR_NUM
               AND V.SYS = P_SYS
               AND V.PRIN = P_PRIN
               AND V.AGENT = P_AGENT;
    END;

    /******************************************************************************
    *  Title:       PR_GET_LTR_TEXT
    *  Created:     11/20/2006
    *  Author:      RRODRIGUEZ
    *
    *  Description: This will retrieve the letter text contents
    *
    *    Modifications:
    *    Date        Who            Description
    *    11/20/2006    rrodriguez    TS-33 initial procedure
    ******************************************************************************/
    PROCEDURE PR_GET_LTR_TEXT(P_LTR_NUM IN CHAR,
                              P_SYS     IN CHAR,
                              P_PRIN    IN CHAR,
                              P_AGENT   IN CHAR,
                              P_REF     OUT SYS_REFCURSOR) IS

    BEGIN

        OPEN P_REF FOR
            SELECT DECODE(NVL(RTRIM(L.LTR_NUM), 'NONE'), 'NONE', P_LTR_NUM,
                          L.LTR_NUM) LTR_NUM,
                   L.LTR_DESC,
                   T.SYS,
                   T.PRIN,
                   T.AGENT,
                   T.CLIENT,
                   T.LTR_TYPE,
                   T.PAGE_NUM,
                   T.LINE_1,
                   T.LINE_2,
                   T.LINE_3,
                   T.LINE_4,
                   T.LINE_5,
                   T.LINE_6,
                   T.LINE_7,
                   T.LINE_8,
                   T.LINE_9,
                   T.LINE_10,
                   T.LINE_11,
                   T.LINE_12,
                   T.LINE_13,
                   T.LINE_14,
                   T.LINE_15,
                   T.LINE_16,
                   T.LINE_17,
                   T.LINE_18,
                   T.LINE_19,
                   T.LINE_20,
                   T.LINE_21,
                   T.LINE_22,
                   T.LINE_23,
                   T.LINE_24,
                   T.LINE_25,
                   T.LINE_26,
                   T.LINE_27,
                   T.LINE_28,
                   T.LINE_29,
                   T.LINE_30,
                   T.LINE_31,
                   T.LINE_32,
                   T.LINE_33,
                   T.LINE_34,
                   T.LINE_35,
                   T.LINE_36,
                   T.LINE_37,
                   T.LINE_38,
                   T.LINE_39,
                   T.LINE_40,
                   T.LINE_41,
                   T.LINE_42,
                   T.LINE_43,
                   T.LINE_44,
                   T.LINE_45,
                   T.LINE_46,
                   T.LINE_47,
                   T.LINE_48,
                   T.LINE_49,
                   T.LINE_50,
                   T.LINE_51,
                   T.LINE_52,
                   T.LINE_53,
                   T.LINE_54,
                   T.LINE_55,
                   T.LINE_56,
                   T.LINE_57,
                   T.LINE_58,
                   T.LINE_59,
                   T.LINE_60,
                   T.LINE_61,
                   T.LINE_62,
                   T.LINE_63,
                   T.LINE_64,
                   T.LINE_65,
                   T.LINE_66,
                   T.LINE_67,
                   T.LINE_68,
                   T.LINE_69,
                   T.LINE_70,
                   T.LINE_71,
                   T.LINE_72,
                   T.LINE_73,
                   T.LINE_74,
                   T.LINE_75,
                   T.LINE_76,
                   T.LINE_77,
                   T.LINE_78,
                   T.LINE_79,
                   T.LINE_80
              FROM T_RT_LTR_LIST L,
                   T_RT_LTR_TEXT T
             WHERE T.LTR_NUM = P_LTR_NUM
               AND L.LTR_NUM(+) = T.LTR_NUM
               AND T.SYS = P_SYS
               AND T.PRIN = P_PRIN
               AND T.AGENT = P_AGENT
             ORDER BY T.PAGE_NUM;

    END;

    /******************************************************************************
    *  Title:       PR_INSERT_LTR_LIST
    *  Created:     11/20/2006
    *  Author:      RRODRIGUEZ
    *
    *  Description: This will insert new letter to the list
    *
    *    Modifications:
    *    Date        Who            Description
    *    11/20/2006    rrodriguez    TS-33 initial procedure
    *	 06/06/2018	 cbarnes		Added new parameter for communication channel for suppressing the letter
    ******************************************************************************/
    PROCEDURE PR_INSERT_LTR_LIST(P_LTR_NUM   IN CHAR,
                                 P_LTR_DESC  IN VARCHAR2,
                                 P_LTR_GROUP IN CHAR,
								 P_COMM_CHANNEL IN T_RT_LTR_LIST.COMM_CHANNEL_CODE%TYPE DEFAULT 'LETTERS') IS

    BEGIN

        -- ADD NEW LETTER
        INSERT INTO T_RT_LTR_LIST
            (LTR_NUM,
             LTR_DESC,
             LTR_GROUP,
			 COMM_CHANNEL_CODE)
        VALUES
            (P_LTR_NUM,
             P_LTR_DESC,
             P_LTR_GROUP,
			 P_COMM_CHANNEL);

        COMMIT;

    END;

    /******************************************************************************
    *  Title:       PR_INSERT_LTR_VAR
    *  Created:     11/20/2006
    *  Author:      RRODRIGUEZ
    *
    *  Description: This will insert new letter variables data
    *
    *    Modifications:
    *    Date        Who            Description
    *    11/20/2006    rrodriguez    TS-33 initial procedure
    ******************************************************************************/
    PROCEDURE PR_INSERT_LTR_VAR(P_LTR_NUM        IN CHAR,
                                P_SYS            IN CHAR,
                                P_PRIN           IN CHAR,
                                P_AGENT          IN CHAR,
                                P_VAR_CAPTION_1  IN CHAR,
                                P_VAR_CAPTION_2  IN CHAR,
                                P_VAR_CAPTION_3  IN CHAR,
                                P_VAR_CAPTION_4  IN CHAR,
                                P_VAR_CAPTION_5  IN CHAR,
                                P_VAR_CAPTION_6  IN CHAR,
                                P_VAR_CAPTION_7  IN CHAR,
                                P_VAR_CAPTION_8  IN CHAR,
                                P_VAR_CAPTION_9  IN CHAR,
                                P_VAR_CAPTION_10 IN CHAR) IS

    BEGIN

        -- ADD LETTER VARIABLES
        INSERT INTO T_RT_LTR_VAR
            (LTR_NUM,
             SYS,
             PRIN,
             AGENT,
             VAR_CAPTION_1,
             VAR_CAPTION_2,
             VAR_CAPTION_3,
             VAR_CAPTION_4,
             VAR_CAPTION_5,
             VAR_CAPTION_6,
             VAR_CAPTION_7,
             VAR_CAPTION_8,
             VAR_CAPTION_9,
             VAR_CAPTION_10)
        VALUES
            (P_LTR_NUM,
             P_SYS,
             P_PRIN,
             P_AGENT,
             P_VAR_CAPTION_1,
             P_VAR_CAPTION_2,
             P_VAR_CAPTION_3,
             P_VAR_CAPTION_4,
             P_VAR_CAPTION_5,
             P_VAR_CAPTION_6,
             P_VAR_CAPTION_7,
             P_VAR_CAPTION_8,
             P_VAR_CAPTION_9,
             P_VAR_CAPTION_10);
        COMMIT;
    END;

    /******************************************************************************
    *  Title:       PR_INSERT_LTR_TEXT
    *  Created:     11/20/2006
    *  Author:      RRODRIGUEZ
    *
    *  Description: This will insert new letter text data
    *
    *    Modifications:
    *    Date        Who            Description
    *    11/20/2006    rrodriguez    TS-33 initial procedure
    ******************************************************************************/
    PROCEDURE PR_INSERT_LTR_TEXT(P_LTR_NUM  IN CHAR,
                                 P_SYS      IN CHAR,
                                 P_PRIN     IN CHAR,
                                 P_AGENT    IN CHAR,
                                 P_CLIENT   IN CHAR,
                                 P_LTR_TYPE IN CHAR,
                                 P_PAGE_NUM IN NUMBER,
                                 P_LINE_1   IN VARCHAR2,
                                 P_LINE_2   IN VARCHAR2,
                                 P_LINE_3   IN VARCHAR2,
                                 P_LINE_4   IN VARCHAR2,
                                 P_LINE_5   IN VARCHAR2,
                                 P_LINE_6   IN VARCHAR2,
                                 P_LINE_7   IN VARCHAR2,
                                 P_LINE_8   IN VARCHAR2,
                                 P_LINE_9   IN VARCHAR2,
                                 P_LINE_10  IN VARCHAR2,
                                 P_LINE_11  IN VARCHAR2,
                                 P_LINE_12  IN VARCHAR2,
                                 P_LINE_13  IN VARCHAR2,
                                 P_LINE_14  IN VARCHAR2,
                                 P_LINE_15  IN VARCHAR2,
                                 P_LINE_16  IN VARCHAR2,
                                 P_LINE_17  IN VARCHAR2,
                                 P_LINE_18  IN VARCHAR2,
                                 P_LINE_19  IN VARCHAR2,
                                 P_LINE_20  IN VARCHAR2,
                                 P_LINE_21  IN VARCHAR2,
                                 P_LINE_22  IN VARCHAR2,
                                 P_LINE_23  IN VARCHAR2,
                                 P_LINE_24  IN VARCHAR2,
                                 P_LINE_25  IN VARCHAR2,
                                 P_LINE_26  IN VARCHAR2,
                                 P_LINE_27  IN VARCHAR2,
                                 P_LINE_28  IN VARCHAR2,
                                 P_LINE_29  IN VARCHAR2,
                                 P_LINE_30  IN VARCHAR2,
                                 P_LINE_31  IN VARCHAR2,
                                 P_LINE_32  IN VARCHAR2,
                                 P_LINE_33  IN VARCHAR2,
                                 P_LINE_34  IN VARCHAR2,
                                 P_LINE_35  IN VARCHAR2,
                                 P_LINE_36  IN VARCHAR2,
                                 P_LINE_37  IN VARCHAR2,
                                 P_LINE_38  IN VARCHAR2,
                                 P_LINE_39  IN VARCHAR2,
                                 P_LINE_40  IN VARCHAR2,
                                 P_LINE_41  IN VARCHAR2,
                                 P_LINE_42  IN VARCHAR2,
                                 P_LINE_43  IN VARCHAR2,
                                 P_LINE_44  IN VARCHAR2,
                                 P_LINE_45  IN VARCHAR2,
                                 P_LINE_46  IN VARCHAR2,
                                 P_LINE_47  IN VARCHAR2,
                                 P_LINE_48  IN VARCHAR2,
                                 P_LINE_49  IN VARCHAR2,
                                 P_LINE_50  IN VARCHAR2,
                                 P_LINE_51  IN VARCHAR2,
                                 P_LINE_52  IN VARCHAR2,
                                 P_LINE_53  IN VARCHAR2,
                                 P_LINE_54  IN VARCHAR2,
                                 P_LINE_55  IN VARCHAR2,
                                 P_LINE_56  IN VARCHAR2,
                                 P_LINE_57  IN VARCHAR2,
                                 P_LINE_58  IN VARCHAR2,
                                 P_LINE_59  IN VARCHAR2,
                                 P_LINE_60  IN VARCHAR2,
                                 P_LINE_61  IN VARCHAR2,
                                 P_LINE_62  IN VARCHAR2,
                                 P_LINE_63  IN VARCHAR2,
                                 P_LINE_64  IN VARCHAR2,
                                 P_LINE_65  IN VARCHAR2,
                                 P_LINE_66  IN VARCHAR2,
                                 P_LINE_67  IN VARCHAR2,
                                 P_LINE_68  IN VARCHAR2,
                                 P_LINE_69  IN VARCHAR2,
                                 P_LINE_70  IN VARCHAR2,
                                 P_LINE_71  IN VARCHAR2,
                                 P_LINE_72  IN VARCHAR2,
                                 P_LINE_73  IN VARCHAR2,
                                 P_LINE_74  IN VARCHAR2,
                                 P_LINE_75  IN VARCHAR2,
                                 P_LINE_76  IN VARCHAR2,
                                 P_LINE_77  IN VARCHAR2,
                                 P_LINE_78  IN VARCHAR2,
                                 P_LINE_79  IN VARCHAR2,
                                 P_LINE_80  IN VARCHAR2) IS

    BEGIN

        -- ADD LETTER TEXT
        INSERT INTO T_RT_LTR_TEXT
            (LTR_NUM,
             SYS,
             PRIN,
             AGENT,
             CLIENT,
             LTR_TYPE,
             PAGE_NUM,
             LINE_1,
             LINE_2,
             LINE_3,
             LINE_4,
             LINE_5,
             LINE_6,
             LINE_7,
             LINE_8,
             LINE_9,
             LINE_10,
             LINE_11,
             LINE_12,
             LINE_13,
             LINE_14,
             LINE_15,
             LINE_16,
             LINE_17,
             LINE_18,
             LINE_19,
             LINE_20,
             LINE_21,
             LINE_22,
             LINE_23,
             LINE_24,
             LINE_25,
             LINE_26,
             LINE_27,
             LINE_28,
             LINE_29,
             LINE_30,
             LINE_31,
             LINE_32,
             LINE_33,
             LINE_34,
             LINE_35,
             LINE_36,
             LINE_37,
             LINE_38,
             LINE_39,
             LINE_40,
             LINE_41,
             LINE_42,
             LINE_43,
             LINE_44,
             LINE_45,
             LINE_46,
             LINE_47,
             LINE_48,
             LINE_49,
             LINE_50,
             LINE_51,
             LINE_52,
             LINE_53,
             LINE_54,
             LINE_55,
             LINE_56,
             LINE_57,
             LINE_58,
             LINE_59,
             LINE_60,
             LINE_61,
             LINE_62,
             LINE_63,
             LINE_64,
             LINE_65,
             LINE_66,
             LINE_67,
             LINE_68,
             LINE_69,
             LINE_70,
             LINE_71,
             LINE_72,
             LINE_73,
             LINE_74,
             LINE_75,
             LINE_76,
             LINE_77,
             LINE_78,
             LINE_79,
             LINE_80)
        VALUES
            (P_LTR_NUM,
             P_SYS,
             P_PRIN,
             P_AGENT,
             P_CLIENT,
             P_LTR_TYPE,
             P_PAGE_NUM,
             P_LINE_1,
             P_LINE_2,
             P_LINE_3,
             P_LINE_4,
             P_LINE_5,
             P_LINE_6,
             P_LINE_7,
             P_LINE_8,
             P_LINE_9,
             P_LINE_10,
             P_LINE_11,
             P_LINE_12,
             P_LINE_13,
             P_LINE_14,
             P_LINE_15,
             P_LINE_16,
             P_LINE_17,
             P_LINE_18,
             P_LINE_19,
             P_LINE_20,
             P_LINE_21,
             P_LINE_22,
             P_LINE_23,
             P_LINE_24,
             P_LINE_25,
             P_LINE_26,
             P_LINE_27,
             P_LINE_28,
             P_LINE_29,
             P_LINE_30,
             P_LINE_31,
             P_LINE_32,
             P_LINE_33,
             P_LINE_34,
             P_LINE_35,
             P_LINE_36,
             P_LINE_37,
             P_LINE_38,
             P_LINE_39,
             P_LINE_40,
             P_LINE_41,
             P_LINE_42,
             P_LINE_43,
             P_LINE_44,
             P_LINE_45,
             P_LINE_46,
             P_LINE_47,
             P_LINE_48,
             P_LINE_49,
             P_LINE_50,
             P_LINE_51,
             P_LINE_52,
             P_LINE_53,
             P_LINE_54,
             P_LINE_55,
             P_LINE_56,
             P_LINE_57,
             P_LINE_58,
             P_LINE_59,
             P_LINE_60,
             P_LINE_61,
             P_LINE_62,
             P_LINE_63,
             P_LINE_64,
             P_LINE_65,
             P_LINE_66,
             P_LINE_67,
             P_LINE_68,
             P_LINE_69,
             P_LINE_70,
             P_LINE_71,
             P_LINE_72,
             P_LINE_73,
             P_LINE_74,
             P_LINE_75,
             P_LINE_76,
             P_LINE_77,
             P_LINE_78,
             P_LINE_79,
             P_LINE_80);

        COMMIT;

    END;

    /******************************************************************************
    *  Title:       PR_UPDATE_LTR_LIST
    *  Created:     10/21/2010
    *  Author:      JOE AGSTER
    *
    *  Description: This will update a letter in the list. Replaces IFLOW DU_LETTER_LIST
    *
    *    Modifications:
    *    Date            Who            Description
    *    10/21/2010      jagster        WO13013 - IFLOW Conversion
    ******************************************************************************/
    PROCEDURE PR_UPDATE_LTR_LIST(P_LTR_NUM   IN CHAR,
                                 P_LTR_DESC  IN VARCHAR2,
                                 P_LTR_GROUP IN CHAR) IS

    BEGIN

        -- UPDATE LETTER
        UPDATE T_RT_LTR_LIST
           SET LTR_DESC  = P_LTR_DESC,
               LTR_GROUP = P_LTR_GROUP
         WHERE LTR_NUM = P_LTR_NUM;

        COMMIT;

    END;

    /******************************************************************************
    *  Title:       PR_DELETE_LTR_LIST
    *  Created:     10/21/2010
    *  Author:      JOE AGSTER
    *
    *  Description: This will delete a letter in the list. Replaces IFLOW DU_LETTER_LIST
    *
    *    Modifications:
    *    Date            Who            Description
    *    10/21/2010      jagster        WO13013 - IFLOW Conversion
    ******************************************************************************/
    PROCEDURE PR_DELETE_LTR_LIST(P_LTR_NUM IN CHAR) IS

    BEGIN

        -- DELETE LETTER
        DELETE FROM T_RT_LTR_LIST
         WHERE LTR_NUM = P_LTR_NUM;

        COMMIT;

    END;

    /******************************************************************************
    *  Title:       PR_GetClosureRevEvalInfo
    *  Created:     08/22/2007
    *  Author:      R.Penuela
    *
    *  Description: This will gather closure reversal decline letter and message display
    *
    *    Modifications:
    *    Date        Who            Description
     ******************************************************************************/
    PROCEDURE PR_GetClosureRevEvalInfo(p_closureEvalCode IN VARCHAR2,
                                       p_letterNumber    OUT VARCHAR2,
                                       p_msgDisplay      OUT VARCHAR2,
                                       p_letterPrintHost OUT VARCHAR2, 
	                               p_declineReason   OUT VARCHAR2) IS
    BEGIN
        SELECT I.closure_rev_EVAL_letter,
               I.closure_rev_EVAL_message,
               I.CLOSURE_REV_LTTR_PRINT_HOST,
               I.closure_rev_eval_reason
          INTO p_letterNumber,
               p_msgDisplay,
               p_letterPrintHost,
               p_declineReason   
          FROM T_RT_CLOSURE_REV_EVAL_INFO I
         WHERE CLOSURE_REV_EVAL_DESC = p_closureEvalCode;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            SELECT NULL,
                   NULL,
                   NULL,
		   NULL
              INTO p_letterNumber,
                   p_msgDisplay,
                   p_letterPrintHost,
		   p_declineReason
              FROM DUAL;

    END PR_GetClosureRevEvalInfo;

    /******************************************************************************
    *  Title:       PR_GetPaymentInquiryScripts
    *  Created:     10/11/2010
    *  Author:      Jasdeep Madan
    *
    *  Description: TS-49 SEC 5
    *
    *    Modifications:
    *    Date        Who            Description
     ******************************************************************************/

    PROCEDURE PR_GetPaymentInquiryScripts(i_ref OUT t_ref_cursor) IS

    BEGIN
        OPEN i_ref FOR
            SELECT s.script_id,
                   s.script_type_id,
                   script_lookup_order,
                   script_definition,
                   s.script_code_id
              FROM t_rt_script      s,
                   t_rt_script_type st

             WHERE s.script_id = st.script_type_id

               AND st.script_type_desc = 'Payment Inquiry Script'
               AND s.active_flag = '1'
             ORDER BY script_lookup_order ASC;
    END;

    /******************************************************************************
    *  Title:       pr_get_lookup_value
    *  Created:     6/10/2011
    *  Author:      Shirley Steen
    *
    *  Description: RISK190  Replaces customer.pkg_cli.get_cli_existing_line. This
    *               is a more generic lookup on t_rt_lookup and t_rt_lookup_type.
    *
    *    Modifications:
    *    Date        Who            Description
     ******************************************************************************/
    PROCEDURE pr_get_lookup_value(p_lookup_type_desc IN VARCHAR2,
                                  p_lookup_desc      IN VARCHAR2,
                                  p_is_found         OUT NUMBER,
                                  p_value            OUT VARCHAR2) IS

    BEGIN
        SELECT l.lookup_value,
               1
          INTO p_value,
               p_is_found
          FROM t_rt_lookup      l,
               t_rt_lookup_type t
         WHERE l.lookup_type_id = t.lookup_type_id
           AND t.lookup_type_desc = p_lookup_type_desc
           AND l.lookup_desc = p_lookup_desc;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_is_found := 0;
            p_value    := NULL;
    END pr_get_lookup_value;

END PKG_T_RT_R;
/

GRANT EXECUTE ON IFLOW.PKG_T_RT_R TO CUSTOMER;

GRANT EXECUTE ON IFLOW.PKG_T_RT_R TO DLSRVC;

GRANT EXECUTE ON IFLOW.PKG_T_RT_R TO WEB_RO;
