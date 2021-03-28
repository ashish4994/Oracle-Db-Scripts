CREATE OR REPLACE PACKAGE COLL.PKG_COLL_ACCOUNT_INFO_R IS

    /**************************VERSION CONTROL LOG*****************************
    *
    * DATE             AccuRev Version         WHO              Comments
    * 8/3/2009         Initial                 GBECKY           Initial checkin
    * 8/5/2009         COLL-76B                GBECKY
    * 3/5/2010         COLL-121a               NMATUSEVICH
    * 06/04/2010       COMP-32                 Pandiyaraj Ramadas       Payment Due Date change
    * 6/14/2010        MK-235                  Riley White      Authorized User changes
    * 1/21/2015        WO-66257           Vijayashankar Palanichamy Filtered the Duplicate Search Results.
    * 07/24/2018       CS-38                   jtrippel          Update pr_get_customer_data to support mobile phones.
    ***************************VERSION CONTROL LOG******************************/

    /******************************************************************************
    *
    *  Title:        fn_calculate_ptpkept_rate
    *  Schema Owner: COLL
    *  Created:      January 4, 2006
    *  Author:       S. Niazov
    *
    *  Description: This will calculate rate of kept promises
    *
    *  Modifications:
    *    Date            Who                    Description
    *    01/04/2006        S. Niazov            Initial procedure
    ******************************************************************************/
    FUNCTION fn_calculate_ptpkept_rate(p_card_number IN account.card_number%TYPE)
        RETURN NUMBER;

    /******************************************************************************
    *
    *  Title:        pr_get_customer_data
    *  Schema Owner: COLL
    *  Created:      January 5, 2006
    *  Author:       R. Rodriguez
    *
    *  Description: This will retreive the customer demographics
    *
    *  Modifications:
    *    Date            Who                    Description
    *    01/03/2006      rrodriguez         Initial procedure
    *    02/05/2008      Simi Augustine     optimize: rewrote the whole procedure
                                            CHANGES: single select from t_uc_chinfo
                                            replace pr_get_alternate_number with query from t_qc_customer_phone to get phone numbers
                                            eliminate querying address history table
    * 6/14/2010          Riley White        Authorized User changes
    ******************************************************************************/
    PROCEDURE pr_get_customer_data(pcard_number IN account.card_number%TYPE,
                                   pref_cursor  OUT SYS_REFCURSOR);

    /******************************************************************************
    *
    *  Title:        pr_get_customer_data
    *  Schema Owner: COLL
    *  Created:      June 14, 2010
    *  Author:       Riley White
    *
    *  Description: This will retreive the customer demographics by account_id
    *
    *  Modifications:
    *    Date            Who                    Description
    ******************************************************************************/
    PROCEDURE pr_get_customer_data_by_id(p_account_id IN NUMBER,
                                         p_return     OUT SYS_REFCURSOR);

    /******************************************************************************
    *
    *  Title:        pr_get_account_data
    *  Schema Owner: COLL
    *  Created:      January 5, 2006
    *  Author:       R. Rodriguez
    *
    *  Description: This will retreive the account demographics
    *
    *  Modifications:
    *    Date            Who               Description
    *    01/03/2006      rrodriguez        Initial procedure
    *    03/5/2010       COLL-121a         NMATUSEVICH
    *    06/14/2010      Riley White       Authorized User changes
    *    03/01/2016      MSANTOS           Added search by related agencies.
    ******************************************************************************/
    PROCEDURE pr_get_account_data(pcard_number IN account.card_number%TYPE,
                                  pref_cursor  OUT SYS_REFCURSOR);

    /******************************************************************************
    *
    *  Title:        pr_account_search_by_ssn
    *  Schema Owner: COLL
    *  Created:      February 9, 2006
    *  Author:       Simi Augustine
    *
    *  Description: This will search for account by SSN
    *
    *  Modifications:
    *    Date            Who                    Description
    *    02/09/2006      Simi                   Initial procedure
    *    08/11/2008      Gregg Becky            Add filter parameter
    *    1/21/2015     Vijayashankar Palanichamy   Filtered the Duplicate Search Results.
    ******************************************************************************/
    PROCEDURE pr_account_search_by_ssn(p_ssn       IN NUMBER,
                                       p_filter_by cl_agency.agency_ident%TYPE,
                                       pref_cursor OUT SYS_REFCURSOR);

    /******************************************************************************
    *
    *  Title:        fn_get_cust_utc_offset
    *  Schema Owner: COLL
    *  Created:      February 19, 2006
    *  Author:       R. Reineri
    *
    *  Description: Returns the customer UTC offset based on area code. If no
    *                data is found, returns -99 as a sentinel.
    *
    *  Modifications:
    *    Date            Who                    Description
    *    03/01/2016      MSANTOS                Added search by related agencies.
    ******************************************************************************/
    FUNCTION fn_get_cust_utc_offset(p_area_code IN NUMBER) RETURN NUMBER;

    /******************************************************************************
    *
    *  Title:        pr_account_search_by_name
    *  Schema Owner: COLL
    *  Created:      March 1, 2006
    *  Author:       Simi Augustine
    *
    *  Description: This will search for account by name
    *
    *  Modifications:
    *    Date            Who                          Description
    *    03/01/2006      Simi                         Initial procedure
    *    08/11/2008      Gregg Becky                  Add filter parameter
    *    01/21/2015      Vijayashankar Palanichamy    Filtered the Duplicate Search Results.
    *    03/01/2016      MSANTOS                      Added search by related agencies.
    ******************************************************************************/
    PROCEDURE pr_account_search_by_name(p_name      IN VARCHAR2,
                                        p_filter_by cl_agency.agency_ident%TYPE,
                                        pref_cursor OUT SYS_REFCURSOR);

    /******************************************************************************
    *
    *  Title:        pr_account_search_by_phone
    *  Schema Owner: COLL
    *  Created:      March 7, 2006
    *  Author:       Simi Augustine
    *
    *  Description: This will search for account by name
    *
    *  Modifications:
    *    Date            Who                         Description
    *    03/07/2006      Simi                        Initial procedure
    *    08/11/2008      Gregg Becky                 Add filter parameter
    *    01/21/2015      Vijayashankar Palanichamy   Filtered the Duplicate Search Results.
    *    03/01/2016      MSANTOS                     Added search by related agencies.
    ******************************************************************************/
    PROCEDURE pr_account_search_by_phone(p_phone     IN VARCHAR2,
                                         p_filter_by cl_agency.agency_ident%TYPE,
                                         pref_cursor OUT SYS_REFCURSOR);

    /******************************************************************************
    *
    *  Title:        pr_update_spouse_name
    *  Schema Owner: COLL
    *  Created:      March 7, 2006
    *  Author:       Sherzod Niazov
    *
    *  Description: This will update spouse's name
    *
    *  Modifications:
    *    Date            Who                    Description
    *    03/07/2006        Sherzod Niazov        Initial procedure
    ******************************************************************************/
    PROCEDURE pr_update_spouse_name(p_card_number IN account.card_number%TYPE,
                                    p_spouse_name IN VARCHAR2);

    /******************************************************************************
    *
    *  Title:        pr_update_dns
    *  Schema Owner: COLL
    *  Created:      March 7, 2006
    *  Author:       Sherzod Niazov
    *
    *  Description: This will update DO NOT NEGOTIOATE SPOUSE flag
    *
    *  Modifications:
    *    Date            Who                    Description
    *    03/07/2006        Sherzod Niazov        Initial procedure
    ******************************************************************************/
    PROCEDURE pr_update_dns(p_card_number IN account.card_number%TYPE,
                            p_flag        IN VARCHAR2);

    /******************************************************************************
    *
    *  Title:        pr_get_authorizations
    *  Schema Owner: COLL
    *  Created:      March 14, 2006
    *  Author:       Subbarac Chundu
    *
    *  Description:  This procedure return authorizations data set for a given card number.
    *
    *  Modifications:
    *    Date            Who                    Description
    *    03/07/2006        Subbarao Chundu        Initial procedure
    ******************************************************************************/
    PROCEDURE pr_get_authorizations(p_card_number IN NUMBER,
                                    pref_cursor   OUT SYS_REFCURSOR);

    PROCEDURE PR_GET_CUST_RECALL_MAXTIME(p_area_code IN NUMBER,
                                         pref_cursor OUT SYS_REFCURSOR);

    /******************************************************************************
    *
    *  Title:        pr_account_search_by_cust_id
    *  Schema Owner: COLL
    *  Created:      October 10, 2013
    *  Author:       LMALLIAHAGARI
    *
    *  Description: This will search for account by cust id
    *  Modifications:
    *    Date            Who                        Description
    *    03/01/2016     MSANTOS                     Added search by related agencies.
    ******************************************************************************/
    PROCEDURE PR_ACCOUNT_SEARCH_BY_CUST_ID(P_CUST_ID   IN NUMBER,
                                           p_filter_by cl_agency.agency_ident%TYPE,
                                           PREF_CURSOR OUT SYS_REFCURSOR);

    /******************************************************************************
    *
    *  Title:        pr_account_search_by_crdtacct_id
    *  Schema Owner: COLL
    *  Created:      October 10, 2013
    *  Author:       LMALLIAHAGARI
    *
    *  Description: This will search for account by credit account id
    *  Modifications:
    *    Date            Who                        Description
    *    03/01/2016     MSANTOS                     Added search by related agencies.
    ******************************************************************************/
    PROCEDURE PR_ACCOUNT_SEARCH_BY_CRDTACCT(P_CRDT_ACCT_ID IN NUMBER,
                                            p_filter_by    cl_agency.agency_ident%TYPE,
                                            PREF_CURSOR    OUT SYS_REFCURSOR);

    /******************************************************************************
    *
    *  Title:        pr_account_search_by_card_num
    *  Schema Owner: COLL
    *  Created:      October 10, 2013
    *  Author:       LMALLIAHAGARI
    *
    *  Description: This will search for account by card_num
    *
    *  Modifications:
    *    Date            Who                        Description
    *    01/21/2015     Vijayashankar Palanichamy   Filtered the Duplicate Search Results.
    *    03/01/2016     MSANTOS                     Added search by related agencies.
    ******************************************************************************/
    PROCEDURE PR_ACCOUNT_SEARCH_BY_CARD_NUM(P_CARD_NUM  IN v_customer_accounts.card_num%TYPE,
                                            p_filter_by cl_agency.agency_ident%TYPE,
                                            PREF_CURSOR OUT SYS_REFCURSOR);

    /******************************************************************************
    *
    *  Title:        pr_advanced_account_search
    *  Schema Owner: COLL
    *  Created:      February 29, 2016
    *  Author:       MSANTOS
    *
    *  Description: This will search for account by different criteria
    ******************************************************************************/
    PROCEDURE pr_advanced_account_search(p_filter_by       cl_agency.agency_ident%TYPE,
                                         p_crdt_account    v_customer_accounts.credit_account_id%TYPE,
                                         p_crdt_card_last4 v_customer_accounts.vr_card_num_last4%TYPE,
                                         p_phone_number    phone.phone_number%TYPE,
                                         p_ssn             v_customer_accounts.primary_ssn%TYPE,
                                         p_first_name      v_customer_accounts.primary_name%TYPE,
                                         p_last_name       v_customer_accounts.primary_name%TYPE,
                                         p_customer_id     v_old_customer_intersect.old_customer_id%TYPE,
                                         PREF_CURSOR       OUT SYS_REFCURSOR);

    /******************************************************************************
    *
    *  Title:        pr_default_account_search
    *  Schema Owner: COLL
    *  Created:      March 10, 2016
    *  Author:       MSANTOS
    *
    *  Description: This will search for account by default criteria
    ******************************************************************************/
    PROCEDURE pr_default_account_search(p_filter_by    cl_agency.agency_ident%TYPE,
                                        p_filter_value VARCHAR2,
                                        PREF_CURSOR    OUT SYS_REFCURSOR);
    /******************************************************************************
    *
    *  Title:        fn_get_phone_id
    *  Schema Owner: COLL
    *  Created:      May 03, 2016
    *  Author:       MSANTOS
    *
    *  Description: This will retrieve the last phone id for a customer
    ******************************************************************************/
    FUNCTION fn_get_phone_id(p_customer_id NUMBER) RETURN NUMBER;
END PKG_COLL_ACCOUNT_INFO_R;
/
CREATE OR REPLACE PACKAGE BODY COLL.PKG_COLL_ACCOUNT_INFO_R IS
    /******************************************************************************
    *
    *  Title:        pkg_coll_account_info_01
    *  Schema Owner: COLL
    *  Created:      January 16, 2006
    *  Author:       S. Niazov
    *
    *  Description: All related collections alert functions and procedures
    *                Functions:
    *                            N/A
    *                Procedures:
    *  Modifications:
    *    Date            Who                    Descritpion
    *    01-16-2006        S. Niazov            Initial Creation
    *    02/13/2006        RRODRIGUEZ            MODIFIED PROCEDURE PR_GET_ACCOUNT_DATA
    *                                        RETREIVING THE OWNER_PHONE(vdn_phone)
    *                                        FROM CL_VDN TABLE. pkg_coll_account_info_02
    *                                        IS THE BACKUP PRIOR TO THIS CHANGE.
    *    04/24/2006        RRODRIGUEZ            MODIFIED PROCEDURE PR_GET_CUSTOMER_DATA()
    *    07/21/2006        RRRODRIGUEZ            MODIFIED PROCEDURE PR_GET_CUSTOMER_DATA()
    *    07/25/2006        saugustine            modified procedure pr_get_customer_data()
    *    07/26/2006        rrodriguez            modified procedure pr_get_customer_data()
    *    08/05/2009        GBECKY                Modified: pr_account_search by ssn(),
    *                                            pr_account_search_by_name(), and
    *                                            pr_account_search_by_phone().
    *    07/24/2018        jtrippel              modified procedure pr_get_account_data()
    ******************************************************************************/

    /******************************************************************************
    *
    *  Title:        fn_calculate_ptpkept_rate
    *  Schema Owner: COLL
    *  Created:      January 4, 2006
    *  Author:       S. Niazov
    *
    *  Description: This will calculate rate of kept promises
    *
    *  Modifications:
    *    Date            Who                    Description
    *    01/04/2006        S. Niazov            Initial procedure
    ******************************************************************************/
    FUNCTION FN_CALCULATE_PTPKEPT_RATE(P_CARD_NUMBER IN account.card_number%TYPE)
        RETURN NUMBER IS
        V_KEPT   NUMBER;
        V_BROKEN NUMBER;
        V_RATE   NUMBER;
    BEGIN
        -- calculate amount of kept promises
        SELECT COUNT(1)
          INTO V_KEPT
          FROM ACCOUNT A,
               T_UC    UC,
               T_CARD  C
         WHERE A.CARD_NUMBER = P_CARD_NUMBER
           AND UC.CARD_ID = C.CARD_ID
           AND C.CARD_NUM = TO_CHAR(A.CARD_NUMBER)
           AND UC.TYPE_ID = (SELECT UT.UC_TYPE_ID
                               FROM T_UC_TYPE UT
                              WHERE LOWER(UT.UC_NAME) = 'ptp')
           AND UC.STATUS_ID =
               (SELECT ST.STATUS_ID
                  FROM T_RT_STATUS ST
                 WHERE LOWER(ST.STATUS_NAME) = 'ptp kept');
    
        -- calculate amount of broken promises
        SELECT COUNT(1)
          INTO V_BROKEN
          FROM ACCOUNT A,
               T_UC    UC,
               T_CARD  C
         WHERE A.CARD_NUMBER = P_CARD_NUMBER
           AND UC.CARD_ID = C.CARD_ID
           AND C.CARD_NUM = TO_CHAR(A.CARD_NUMBER)
           AND UC.TYPE_ID = (SELECT UT.UC_TYPE_ID
                               FROM T_UC_TYPE UT
                              WHERE LOWER(UT.UC_NAME) = 'ptp')
           AND UC.STATUS_ID =
               (SELECT ST.STATUS_ID
                  FROM T_RT_STATUS ST
                 WHERE LOWER(ST.STATUS_NAME) = 'ptp broken');
    
        -- check if amount of broken promises is not zero to avaid deviding by zero
        IF V_BROKEN = 0 THEN
            IF V_KEPT > 0 THEN
                -- borken is 0, and kept > 0, means the rate is 100%
                V_RATE := 100;
            END IF;
        ELSE
            -- calculate the rate in percents
            V_RATE := V_KEPT / (V_KEPT + V_BROKEN) * 100;
        END IF;
    
        RETURN V_BROKEN;
    END FN_CALCULATE_PTPKEPT_RATE;

    /******************************************************************************
    *
    *  Title:        pr_get_customer_data
    *  Schema Owner: COLL
    *  Created:      January 5, 2006
    *  Author:       R. Rodriguez
    *
    *  Description: This will retreive the customer demographics
    *
    *  Modifications:
    *    Date            Who                    Description
    *    01/03/2006        rrodriguez            Initial procedure
    *    04/24/2006        RRODRIGUEZ            MODIFIED TO RETREIVE LATEST CH ADDRESS
    *                                        IF USECASE CREATED ON CURRENT DATE.
    *    07/21/2006        RRRODRIGUEZ            MODIFIED SUB SELECT UNDER
    *                                        --GET NEW ADDRESS VIA T_UC_CHINFO
    *                                        TO GET THE MOST RECENT CHANGE THAT EXISTS
    *                                        IN T_UC_CHINFO.
    *    07/24/2006        RRODRIGUEZ            ADDED EXCEPTION HANDLING WHEN NO DATA FOUND FOR ADDRESS
    *    07/25/2006        saugustine            REMOVED ROWNUM WHEN SELECTING CUSTOMER ADDRESS IF
    *                                        v_isChanged = 0
    *    07/26/2006        rrodriguez            Modified select statement when selecting address
    *                                        from T_UC_CHINFO fixing multiple return
    *    02/05/2008        Simi Augustine    optimize: rewrote the whole procedure
    *                                        CHANGES: single select from t_uc_chinfo
    *                                        replace pr_get_alternate_number with query from t_qc_customer_phone to get phone numbers
    *                                        eliminate querying address history table
    *    04/08/2008        LVo               Implemented Simi's performance improvement change by adding
    *                                        BETWEEN on the open date comparison.
    *    07/24/2018        jtrippel          Modified to get the mobile phone most recent data.
    **********************************************************************************/
    PROCEDURE PR_GET_CUSTOMER_DATA(PCARD_NUMBER IN account.card_number%TYPE,
                                   PREF_CURSOR  OUT SYS_REFCURSOR) AS
        V_ADDRESS1                VARCHAR2(26);
        V_ADDRESS2                VARCHAR2(26);
        V_CITY                    VARCHAR2(50);
        V_STATE                   VARCHAR2(2);
        V_ZIP                     VARCHAR2(10);
        V_CARDHOLDER_INFO_UC      VARCHAR2(30) := 'cardholder info';
        V_CARDHOLDER_INFO_TYPE_ID NUMBER;
        V_RCLOSED                 VARCHAR2(30) := 'RCLOSED';
        V_RCLOSED_STATUS_ID       NUMBER;
        V_HMPHONE                 NUMBER;
        V_WKPHONE                 NUMBER;
        V_MBPHONE                 NUMBER;
        V_ALTPHONE                NUMBER;
        V_ACCOUNT_ID              ACCOUNT.ACCOUNT_ID%TYPE;
        V_ADR_UC_ID               NUMBER;
        V_SPOUSE_NAME             T_COLL_ACCT.SPOUSE_NAME%TYPE;
        V_EMPLOYER_NAME           T_COLL_ACCT.EMPLOYER_NAME%TYPE;
        V_SEC_EMPLOYER_NAME       T_COLL_ACCT.SEC_EMPLOYER_NAME%TYPE;
    
        V_PRI_ADDRESS_ID          ADDRESS.ADDRESS_ID%TYPE;
        V_PRI_CUSTOMER_ID         CUSTOMER.CUSTOMER_ID%TYPE;
        V_PRI_ROLE_CD             CUSTOMER.ROLE%TYPE := 'P';
        V_PRI_NAME                CUSTOMER.NAME%TYPE;
        V_PRI_DATE_OF_BIRTH       CUSTOMER.DATE_OF_BIRTH%TYPE;
        V_PRI_SSN                 CUSTOMER.SSN%TYPE;
        V_PRI_MOTHERS_MAIDEN_NAME CUSTOMER.MOTHERS_MAIDEN_NAME%TYPE;
        V_PRI_LANGUAGE_FLAG       CUSTOMER.LANGUAGE_FLAG%TYPE;
    
    
    BEGIN
    
        /* Get Primary Cardholder Info */
        SELECT A.ACCOUNT_ID,
               C.CUSTOMER_ID,
               C.ADDRESS_ID,
               C.NAME,
               C.DATE_OF_BIRTH,
               C.SSN SSN,
               C.MOTHERS_MAIDEN_NAME,
               C.LANGUAGE_FLAG
          INTO V_ACCOUNT_ID,
               V_PRI_CUSTOMER_ID,
               V_PRI_ADDRESS_ID,
               V_PRI_NAME,
               V_PRI_DATE_OF_BIRTH,
               V_PRI_SSN,
               V_PRI_MOTHERS_MAIDEN_NAME,
               V_PRI_LANGUAGE_FLAG
          FROM ACCOUNT  A,
               CUSTOMER C
         WHERE A.CARD_NUMBER = PCARD_NUMBER
           AND A.ACCOUNT_ID = C.ACCOUNT_ID
           AND C.ROLE = V_PRI_ROLE_CD;
    
        /* Get Coll Acct info */
        BEGIN
            SELECT TRIM(CA.SPOUSE_NAME),
                   TRIM(CA.EMPLOYER_NAME),
                   TRIM(CA.SEC_EMPLOYER_NAME)
              INTO V_SPOUSE_NAME,
                   V_EMPLOYER_NAME,
                   V_SEC_EMPLOYER_NAME
              FROM T_COLL_ACCT CA
             WHERE CA.ACCOUNT_ID = V_ACCOUNT_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_SPOUSE_NAME       := '';
                V_EMPLOYER_NAME     := '';
                V_SEC_EMPLOYER_NAME := '';
        END;
    
        --We need to get the mobile phone data always from table t_qc_customer_phone
        BEGIN
            SELECT PHONE_MOBILE
              INTO V_MBPHONE
              FROM T_QC_CUSTOMER_PHONE
             WHERE CUSTOMER_ID = V_PRI_CUSTOMER_ID;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_MBPHONE := NULL;
        END;
        -- 04/24/06: rod
        -- lets check if we have an address change occurred for today's date
        BEGIN
        
            SELECT UC_TYPE_ID
              INTO V_CARDHOLDER_INFO_TYPE_ID
              FROM T_UC_TYPE
             WHERE LOWER(RTRIM(UC_NAME)) = V_CARDHOLDER_INFO_UC;
        
            SELECT STATUS_ID
              INTO V_RCLOSED_STATUS_ID
              FROM T_RT_STATUS
             WHERE STATUS_NAME = V_RCLOSED;
        
            -- 04/08/08: combined two selects, added BETWEEN to the subselect
            -- per Simi's performance improvement change
        
            SELECT ADDRESS_1,
                   ADDRESS_2,
                   CITY,
                   STATE,
                   ZIP,
                   HOME_PHONE,
                   WORK_PHONE
              INTO -- SET THE VARIABLES
                   V_ADDRESS1,
                   V_ADDRESS2,
                   V_CITY,
                   V_STATE,
                   V_ZIP,
                   V_HMPHONE,
                   V_WKPHONE
              FROM T_UC_CHINFO
             WHERE UC_ID = (SELECT MAX(UC.UC_ID)
                              FROM T_UC   UC,
                                   T_CARD C
                             WHERE UC.CARD_ID = C.CARD_ID
                               AND C.CARD_NUM = TO_CHAR(PCARD_NUMBER)
                               AND UC.TYPE_ID = V_CARDHOLDER_INFO_TYPE_ID
                               AND UC.STATUS_ID = V_RCLOSED_STATUS_ID
                               AND UC.OPEN_DATE BETWEEN TRUNC(SYSDATE) AND
                                   TRUNC(SYSDATE + 1));
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --no address change done today
                BEGIN
                
                    -- get the current address
                    SELECT AD.ADDRESS_LINE1,
                           AD.ADDRESS_LINE2,
                           AD.CITY,
                           AD.STATE,
                           AD.ZIP
                      INTO -- SET THE VARIABLES
                           V_ADDRESS1,
                           V_ADDRESS2,
                           V_CITY,
                           V_STATE,
                           V_ZIP
                      FROM ADDRESS AD
                     WHERE AD.ADDRESS_ID = V_PRI_ADDRESS_ID;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        -- SET THE VARIABLES
                        V_ADDRESS1 := NULL;
                        V_ADDRESS2 := NULL;
                        V_CITY     := NULL;
                        V_STATE    := NULL;
                        V_ZIP      := NULL;
                END;
            
                BEGIN
                    -- get the current address
                    SELECT PHONE_HOME,
                           PHONE_WORK,
                           PHONE_OTHER
                    --PHONE4
                      INTO -- SET THE VARIABLES
                           V_HMPHONE,
                           V_WKPHONE,
                           V_ALTPHONE
                      FROM T_QC_CUSTOMER_PHONE
                     WHERE CUSTOMER_ID = V_PRI_CUSTOMER_ID;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        -- SET THE VARIABLES
                        V_HMPHONE  := NULL;
                        V_WKPHONE  := NULL;
                        V_ALTPHONE := NULL;
                END;
        END;
    
        -- RETURN THE CURSOR
        OPEN PREF_CURSOR FOR
            SELECT V_PRI_NAME NAME,
                   V_PRI_DATE_OF_BIRTH DATE_OF_BIRTH,
                   LPAD(V_PRI_SSN, 9, 0) SSN,
                   V_PRI_MOTHERS_MAIDEN_NAME MOTHERS_MAIDEN_NAME,
                   V_PRI_LANGUAGE_FLAG LANGUAGE_FLAG,
                   V_PRI_ROLE_CD ROLE,
                   1 FDR_ROLE_CODE,
                   1 IS_ACTIVE,
                   '' NICK_NAME, -- we need a field
                   V_SPOUSE_NAME SPOUSE,
                   V_EMPLOYER_NAME EMPLOYER_NAME,
                   RTRIM(V_ADDRESS1) ADDRESS_LINE1,
                   RTRIM(V_ADDRESS2) ADDRESS_LINE2,
                   RTRIM(V_CITY) CITY,
                   RTRIM(V_STATE) STATE,
                   RTRIM(V_ZIP) ZIP,
                   RTRIM(V_HMPHONE) HOME_PHONE,
                   RTRIM(V_WKPHONE) WORK_PHONE,
                   RTRIM(V_MBPHONE) MOBILE_PHONE,
                   RTRIM(V_ALTPHONE) ALTERNATE_PHONE
              FROM DUAL
            UNION ALL
            SELECT C.NAME,
                   C.DATE_OF_BIRTH,
                   LPAD(C.SSN, 9, 0) SSN,
                   C.MOTHERS_MAIDEN_NAME,
                   C.LANGUAGE_FLAG,
                   C.ROLE,
                   C.FDR_ROLE_CODE,
                   C.IS_ACTIVE,
                   '' NICK_NAME, -- we need a field
                   '' SPOUSE,
                   V_SEC_EMPLOYER_NAME EMPLOYER_NAME,
                   '' ADDRESS_LINE1,
                   '' ADDRESS_LINE2,
                   '' CITY,
                   '' STATE,
                   '' ZIP,
                   '' HOME_PHONE,
                   '' WORK_PHONE,
                   '' MOBILE_PHONE,
                   '' ALTERNATE_PHONE
              FROM CUSTOMER C
             WHERE C.ACCOUNT_ID = V_ACCOUNT_ID
               AND C.ROLE <> V_PRI_ROLE_CD;
    END;

    PROCEDURE pr_get_customer_data_by_id(p_account_id IN NUMBER,
                                         p_return     OUT SYS_REFCURSOR) IS
        v_card_number account.card_number%TYPE;
    BEGIN
        SELECT a.card_number
          INTO v_card_number
          FROM account a
         WHERE a.account_id = p_account_id;
    
        pr_get_customer_data(pcard_number => v_card_number,
                             pref_cursor => p_return);
    END pr_get_customer_data_by_id;

    /******************************************************************************
      *
      *  Title:        pr_get_account_data
      *  Schema Owner: COLL
      *  Created:      January 5, 2006
      *  Author:       R. Rodriguez
      *
      *  Description: This will retreive the account demographics
      *
      *  Modifications:
      *    Date            Who                    Description
      *    01/03/2006     rrodriguez          Initial procedure
      *    04/18/2006     Simi                changed the agency_name to include the owner code, CHGO, DLTE
      *    02/22/2008     RCaballero          Modifications to improve performance
      *    11/04/2009     VCuzma              Using incorrect table, it was getting wrong Agency Owner
      *    3/5/2010       NMATUSEVICH         Included Principal Balance, Risk Level, Profit Score to OUTPUT
      *    06/04/2010  Pandiyaraj Ramadas     COMP-32: Payment Due Date change
      *    02/07/2011     SSteen              COLL137: Added flag for bankruptcy.
      *    11/28/2011     SSteen              No Code Changes were made. Added note for
      *                                       days_delinquent is the same calculation being used
      *                                       in new function ods_stg.fn_get_cash_days_delinquent
    *    02/02/2017    MQUINTANA        WO108904 : Use T_LU_SPA instead of SYSPRINAGENT to avoid
    *                                  conflict with 10 digit prefix codes
      ******************************************************************************/
    PROCEDURE pr_get_account_data(pcard_number IN account.card_number%TYPE,
                                  pref_cursor  OUT SYS_REFCURSOR) AS
        v_systemcode            NUMBER;
        v_start                 NUMBER;
        vAgentCodeWildCard      VARCHAR2(3);
        vCardNumChar            VARCHAR2(19);
        v_is_bankrupted         NUMBER;
        v_ext_status            account.external_status%TYPE;
        v_status_rsn            account.status_reason%TYPE;
        v_co_cnt                NUMBER;
        v_prechargeoff_bill_day charge_off.prechargeoff_bill_day%TYPE;
        v_pend_late_fee         t_unbilled_late_fees.amount%TYPE;
        v_6month_DC_paymnt_cnt  NUMBER;
        v_card_spa_id           NUMBER;
    BEGIN
        -- get the system_code
    
        -- MQuintana 02/02/2017 WO108904
        SELECT c.spa_id
          INTO v_card_spa_id
          FROM t_card c
         WHERE c.card_num = pcard_number;
    
        SELECT DISTINCT RTRIM(system_code)
          INTO v_systemcode
          FROM t_lu_spa s
         WHERE s.spa_id = v_card_spa_id;
    
        /************************************
        * now we have the system code
        * lets set the start position for agent code
        *************************************/
        IF v_systemcode = 5073 THEN
            v_start := 9;
        ELSIF v_systemcode = 3227 THEN
            v_start := 9;
        ELSIF v_systemcode = 5727 THEN
            v_start := 8;
        ELSE
            v_start := 8;
        END IF;
    
        -- rcaballero 02/22/2008
        SELECT SUBSTR(TO_CHAR(pcard_number), v_start, 2) || '%'
          INTO vAgentCodeWildCard
          FROM dual;
    
        SELECT a.status_reason,
               a.external_status
          INTO v_status_rsn,
               v_ext_status
          FROM account a
         WHERE a.card_number = pcard_number;
        CASE
            WHEN v_ext_status = 'B' THEN
                v_is_bankrupted := 1;
            WHEN v_status_rsn = '89' THEN
                v_is_bankrupted := 1;
            ELSE
                v_is_bankrupted := 0;
        END CASE;
    
        -- IF the Account is chaged off
        ---- get pre charge off billing cycle day
        -- because charge_off table has duplicates
        SELECT COUNT(1)
          INTO v_co_cnt
          FROM CHARGE_OFF co,
               ACCOUNT    a
         WHERE co.ACCOUNT_ID = a.ACCOUNT_ID
           AND A.card_number = pcard_number
           AND co.prechargeoff_bill_day IS NOT NULL;
    
        CASE
            WHEN v_co_cnt = 0 THEN
                v_prechargeoff_bill_day := 0;
            
            WHEN v_co_cnt = 1 THEN
            
                SELECT NVL(co.prechargeoff_bill_day, 0)
                  INTO v_prechargeoff_bill_day
                  FROM CHARGE_OFF co,
                       ACCOUNT    a
                 WHERE co.ACCOUNT_ID = a.ACCOUNT_ID
                   AND A.card_number = pcard_number;
            
            WHEN v_co_cnt > 1 THEN
                SELECT prechargeoff_bill_day
                  INTO v_prechargeoff_bill_day
                  FROM (SELECT NVL(prechargeoff_bill_day, 0) prechargeoff_bill_day,
                               charge_off_date
                          FROM CHARGE_OFF co,
                               ACCOUNT    a
                         WHERE co.ACCOUNT_ID = a.ACCOUNT_ID
                           AND a.card_number = pcard_number
                           AND co.prechargeoff_bill_day IS NOT NULL
                         ORDER BY co.charge_off_date)
                 WHERE ROWNUM < 2;
            
        END CASE;
    
        -- get pending late fee for this account between due date and cycle date if it exists
        SELECT NVL(SUM(ulf.amount), 0)
          INTO v_pend_late_fee
          FROM t_unbilled_late_fees ulf,
               account              a
         WHERE a.account_id = ulf.account_id
           AND a.card_number = pcard_number
           AND ulf.post_date BETWEEN a.payment_due_date AND
               add_months(a.LAST_STATEMENT_DATE, 1);
        --get last 6 month debit card payment count
    
        SELECT NVL(COUNT(1), 0)
          INTO v_6month_DC_paymnt_cnt
          FROM T_UC_DEBIT_CARD_EXTERNAL e,
               t_uc                     u,
               t_card                   c
         WHERE e.uc_id = u.uc_id
           AND u.card_id = c.card_id
           AND E.CONFIRMATION_NUMBER IS NOT NULL
           AND c.card_num = TO_CHAR(pcard_number)
           AND u.open_date >= add_months(SYSDATE, -6);
    
        -- get the notes for the account
        OPEN pref_cursor FOR
            SELECT DISTINCT m.product product_desc,
                            a.open_date,
                            NULL xref_one,
                            NULL xref_two,
                            NULL xref_three,
                            NULL xref_one_ext_stat,
                            NULL xref_two_ext_stat,
                            NULL xref_three_ext_stat,
                            NULL xref_one_ext_stat_desc,
                            NULL xref_two_ext_stat_desc,
                            NULL xref_three_ext_stat_desc,
                            a.expiration_date,
                            a.balance_current -
                            NVL(colla.disputed_amount, 0) AS balance_current,
                            NVL(colla.minimum_payment_due, 0) AS min_pay_due,
                            a.credit_line,
                            abs(a.amt_last_payment) AS amt_last_payment,
                            a.date_last_payment,
                            a.fixed_pymt,
                            DECODE(a.external_status, 'N', ' ',
                                   a.external_status) AS external_status,
                            a.status_reason,
                            (SELECT l.lookup_desc
                               FROM t_rt_lookup_type lt,
                                    t_rt_lookup      l
                              WHERE LOWER(lt.lookup_type_desc) =
                                    'external status'
                                AND l.lookup_type_id = lt.lookup_type_id
                                AND LOWER(l.lookup_value) =
                                    LOWER(a.external_status)) AS external_status_desc,
                            (SELECT l.lookup_desc
                               FROM t_rt_lookup_type lt,
                                    t_rt_lookup      l
                              WHERE LOWER(lt.lookup_type_desc) =
                                    'external status reason'
                                AND l.lookup_type_id = lt.lookup_type_id
                                AND LOWER(l.lookup_value) =
                                    LOWER(a.status_reason)) AS status_reason_desc,
                            (SELECT MAX(TRUNC(st.effective_date))
                               FROM customer.account_external_status st
                              WHERE st.account_id = a.account_id) AS status_date,
                            a.billing_day_of_month,
                            Fn_Get_Date(a.Payment_Due_Date,
                                        (-1) * a.cycles_delinquent) AS due_date,
                            CASE
                                WHEN (a.credit_line - a.balance_current) >= 0 THEN
                                 0
                                ELSE
                                 (a.balance_current - a.credit_line)
                            END AS ocl_amount,
                            colla.disputed_amount,
                            colla.agy_placement_date,
                            CASE
                                WHEN a.abandon_date IS NOT NULL THEN
                                 'DLTE'
                                WHEN a.external_status = 'Z' THEN
                                 'CHGO'
                                WHEN o.owner_code IS NOT NULL THEN
                                 DECODE(ca.agency_ident, 'FNBM', 'C1B',
                                        ca.agency_ident) || '-' ||
                                 o.owner_code
                                ELSE
                                 DECODE(ca.agency_ident, 'FNBM', 'C1B',
                                        ca.agency_ident)
                            END AS agency_name,
                            colla.followup_date,
                            fn_calculate_ptpkept_rate(a.card_number) AS ptp_kept_rate,
                            (100 - fn_calculate_ptpkept_rate(a.card_number)) AS ptp_broken_rate,
                            --< days_delinquent is the same calculation being used
                            -- in new function ods_stg.fn_get_cash_days_delinquent
                            TRUNC(SYSDATE) -
                            ADD_MONTHS(a.payment_due_date,
                                       (-1) * a.cycles_delinquent) AS days_delinquent,
                            -->
                            a.cycles_delinquent,
                            (da.del_1cyc_amt + da.del_2cyc_amt +
                            da.del_3cyc_amt + da.del_4cyc_amt +
                            da.del_5cyc_amt + da.del_6cyc_amt +
                            da.del_7cyc_amt) AS delq_amt_total,
                            da.del_1cyc_amt,
                            da.del_2cyc_amt,
                            da.del_3cyc_amt,
                            da.del_4cyc_amt,
                            da.del_5cyc_amt,
                            da.del_6cyc_amt,
                            da.del_7cyc_amt,
                            da.ctd_amt_adj,
                            da.ctd_amt_cash,
                            da.ctd_amt_payment,
                            da.ctd_amt_return,
                            da.ctd_amt_sale,
                            da.ctd_no_adj,
                            da.ctd_no_cash,
                            da.ctd_no_payments,
                            da.ctd_no_return,
                            da.ctd_no_sale,
                            da.no_1cyc_del,
                            da.no_2cyc_del,
                            da.no_3cyc_del,
                            a.account_id,
                            da.auth_flag,
                            da.avail_credit,
                            da.cash_adv_bal,
                            '01 - Jan - 2006' AS date_status_chg,
                            da.del_amt_arrears,
                            colla.dont_negotiate_spouse,
                            RTRIM(v.vdn_phone) owner_phone,
                            a.reservation_number,
                            a.last_statement_date,
                            NVL(a.principle_balance, 0) AS principle_balance,
                            a.temp_collector_code collector_code,
                            (SELECT COUNT(1)
                               FROM customer c
                              WHERE c.account_id = a.account_id
                                AND c.role = 'A'
                                AND c.is_active <> 0) AS is_au_assigned,
                            v_is_bankrupted AS is_bankrupted,
                            v_pend_late_fee AS Pending_late_fee,
                            v_prechargeoff_bill_day AS PreCHargeOff_Bill_Day,
                            v_6month_DC_paymnt_cnt AS Six_mnth_DbtCard_pmnt_cnt,
                            a.statement_hold_code
              FROM account             a,
                   t_del_acct          da,
                   t_coll_acct         colla,
                   cl_agency           ca,
                   chd_stmt_summary    stmt,
                   t_lu_spa            spa,
                   t_rt_product_matrix m,
                   cl_agency_owner     o,
                   cl_vdn              v,
                   t_agency_relation   r
             WHERE a.card_number = pcard_number
               AND da.account_id(+) = a.account_id
               AND colla.account_id(+) = a.account_id
               AND ca.agency_id(+) = colla.agency_id
               AND r.agency_related_to(+) = colla.agency_id
               AND o.agency_owner_id(+) = colla.agency_owner_id
               AND stmt.account_id(+) = a.account_id
               AND stmt.closing_date(+) = a.last_statement_date
               AND spa.spa_id = v_card_spa_id
               AND m.sys(+) = spa.system_code
               AND m.prin(+) = spa.prin_code
               AND m.agent(+) = spa.agent_code
               AND spa.agent_code(+) LIKE vagentcodewildcard
               AND v.vdn_id(+) = o.vdn_id;
    
    END pr_get_account_data;

    /******************************************************************************
    *
    *  Title:        pr_account_search_by_ssn
    *  Schema Owner: COLL
    *  Created:      February 9, 2006
    *  Author:       Simi Augustine
    *
    *  Description: This will search for account by SSN
    *
    *  Modifications:
    *    Date            Who                    Description
    *    02/09/2006      Simi            Initial procedure
    *    08/05/2009      GBECKY          Add account AgencyOwner to Select list
    *    08/11/2009      GBECKY          Add filter criteria for non-FNBM users
    *    01/07/2014      LMALLIAHAGARI   Added new columns customer _id , credit acct id and new table t_card.
    *    1/21/2015     Vijayashankar Palanichamy   Filtered the Duplicate Search Results.
    *    04/24/2015      Alagiyanathan          Added phonetype and phonetypeid in select query
    ******************************************************************************/
    PROCEDURE PR_ACCOUNT_SEARCH_BY_SSN(P_SSN       IN NUMBER,
                                       p_filter_by cl_agency.agency_ident%TYPE,
                                       PREF_CURSOR OUT SYS_REFCURSOR) AS
    BEGIN
    
        IF p_filter_by = 'FNBM' OR p_filter_by IS NULL THEN
        
            OPEN PREF_CURSOR FOR
                SELECT DISTINCT vca.card_num,
                                vca.primary_name,
                                vca.primary_ssn,
                                vca.external_status,
                                vca.customer_id,
                                vca.credit_account_id,
                                NULL                  AS phone_type,
                                NULL                  AS phone_type_id
                  FROM v_customer_accounts vca
                 WHERE vca.primary_ssn = P_SSN
                 ORDER BY vca.primary_name;
        ELSE
        
            OPEN PREF_CURSOR FOR
                SELECT DISTINCT vca.card_num,
                                vca.primary_name,
                                vca.primary_ssn,
                                vca.external_status,
                                vca.customer_id,
                                vca.credit_account_id,
                                NULL                  AS phone_type,
                                NULL                  AS phone_type_id
                  FROM v_customer_accounts vca,
                       t_coll_acct         t,
                       cl_agency           cl,
                       cl_agency_owner     clo
                 WHERE vca.primary_ssn = P_SSN
                   AND t.account_id = vca.old_account_id
                   AND t.agency_id = clo.agency_owner_id
                   AND (clo.agency_owner_id = cl.agency_id OR EXISTS
                        (SELECT r.agency_related_to
                           FROM t_agency_relation r
                          WHERE r.agency_id = cl.agency_id
                            AND r.agency_related_to = clo.agency_owner_id))
                   AND cl.agency_ident = p_filter_by
                 ORDER BY vca.primary_name;
        END IF;
    
    END;
    /******************************************************************************
    *
    *  Title:        fn_get_cust_utc_offset
    *  Schema Owner: COLL
    *  Created:      February 19, 2006
    *  Author:       R. Reineri
    *
    *  Description: Returns the customer UTC offset based on area code. If no
    *                data is found, returns -99 as a sentinel.
    *
    *  Modifications:
    *    Date            Who                    Description
    *
    ******************************************************************************/
    FUNCTION FN_GET_CUST_UTC_OFFSET(P_AREA_CODE IN NUMBER) RETURN NUMBER IS
        V_OFFSET NUMBER;
    BEGIN
        BEGIN
            SELECT TZ.UTC_OFFSET
              INTO V_OFFSET
              FROM T_LU_TIMEZONE TZ
             WHERE TZ.AREA_CODE = P_AREA_CODE;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_OFFSET := -99;
        END;
    
        RETURN V_OFFSET;
    END FN_GET_CUST_UTC_OFFSET;

    /******************************************************************************
      *
      *  Title:        pr_account_search_by_name
      *  Schema Owner: COLL
      *  Created:      March 1, 2006
      *  Author:       Simi Augustine
      *
      *  Description: This will search for account by name
      *
      *  Modifications:
      *    Date            Who                      Description
      *    03/01/2006      Simi                    Initial procedure
      *    08/05/2009      GBECKY                  Add account AgencyOwner to Select list
      *    08/11/2009      GBECKY                  Add filter criteria for non-FNBM users
      *    10/10/2013      LMALLIAHAGARI           Added new column credit acct id and new table t_card.
    *    1/21/2015     Vijayashankar Palanichamy   Filtered the Duplicate Search Results.
      *    04/24/2015      Alagiyanathan          Added phonetype and phonetypeid in select query
      ******************************************************************************/
    PROCEDURE PR_ACCOUNT_SEARCH_BY_NAME(P_NAME      IN VARCHAR2,
                                        p_filter_by cl_agency.agency_ident%TYPE,
                                        PREF_CURSOR OUT SYS_REFCURSOR) AS
        V_FIRST      VARCHAR2(100);
        V_LAST       VARCHAR2(100);
        V_SEARCH_STR VARCHAR2(250);
    BEGIN
        IF INSTR(P_NAME, ',') > 0 THEN
            V_LAST  := TRIM(SUBSTR(P_NAME, 0, INSTR(P_NAME, ',') - 1));
            V_FIRST := TRIM(SUBSTR(P_NAME, INSTR(P_NAME, ',') + 1,
                                   LENGTH(P_NAME)));
        ELSE
            V_LAST  := P_NAME;
            V_FIRST := '';
        END IF;
    
        IF (V_FIRST IS NOT NULL) THEN
            V_SEARCH_STR := UPPER(V_LAST) || '%,%' || UPPER(V_FIRST) || '%';
        ELSE
            V_SEARCH_STR := UPPER(V_LAST) || '%';
        END IF;
    
        IF p_filter_by = 'FNBM' OR p_filter_by IS NULL THEN
        
            OPEN PREF_CURSOR FOR
                SELECT DISTINCT vca.card_num,
                                vca.primary_name,
                                vca.primary_ssn,
                                vca.external_status,
                                vca.customer_id,
                                vca.credit_account_id,
                                NULL                  AS phone_type,
                                NULL                  AS phone_type_id
                  FROM v_customer_accounts vca
                 WHERE vca.primary_name LIKE V_SEARCH_STR
                 ORDER BY vca.primary_name;
        
        ELSE
        
            OPEN PREF_CURSOR FOR
                SELECT /*+ USE_NL(CLO,T,CL) */
                DISTINCT vca.card_num,
                         vca.primary_name,
                         vca.primary_ssn,
                         vca.external_status,
                         vca.customer_id,
                         vca.credit_account_id,
                         NULL                  AS phone_type,
                         NULL                  AS phone_type_id
                  FROM v_customer_accounts vca,
                       t_coll_acct         t,
                       cl_agency           cl,
                       cl_agency_owner     clo
                 WHERE vca.primary_name LIKE V_SEARCH_STR
                   AND t.account_id = vca.old_account_id
                   AND t.agency_id = clo.agency_owner_id
                   AND (clo.agency_owner_id = cl.agency_id OR EXISTS
                        (SELECT r.agency_related_to
                           FROM t_agency_relation r
                          WHERE r.agency_id = cl.agency_id
                            AND r.agency_related_to = clo.agency_owner_id))
                   AND cl.agency_ident = p_filter_by
                 ORDER BY vca.primary_name;
        END IF;
    END;

    /******************************************************************************
    *
    *  Title:        pr_account_search_by_phone
    *  Schema Owner: COLL
    *  Created:      March 7, 2006
    *  Author:       Simi Augustine
    *
    *  Description: This will search for account by name
    *
    *  Modifications:
    *    Date            Who                    Description
    *    03/07/2006      Simi            Initial procedure
    *    08/05/2009      GBECKY          Add account AgencyOwner to Select list
    *    08/11/2009      GBECKY          Add filter criteria for non-FNBM users
    *    3/23/2011       GTHOMS          Added condition to only return verified good or potential good #'s
    *    10/10/2013      LMALLIAHAGARI   Added new column credit acct id and new table t_card.
    *    1/21/2015     Vijayashankar Palanichamy   Filtered the Duplicate Search Results.
    *    04/06/2015      Alagiyanathan            Added phonetype and phonetypeid
    ******************************************************************************/
    PROCEDURE PR_ACCOUNT_SEARCH_BY_PHONE(P_PHONE     IN VARCHAR2,
                                         p_filter_by cl_agency.agency_ident%TYPE,
                                         PREF_CURSOR OUT SYS_REFCURSOR) AS
    BEGIN
    
        IF p_filter_by = 'FNBM' OR p_filter_by IS NULL THEN
        
            OPEN PREF_CURSOR FOR
                SELECT DISTINCT vca.card_num,
                                vca.primary_name,
                                vca.primary_ssn,
                                vca.external_status,
                                vca.customer_id,
                                vca.credit_account_id,
                                pt.phone_type,
                                pt.phone_type_id
                  FROM v_customer_accounts      vca,
                       V_OLD_CUSTOMER_INTERSECT vo,
                       CUSTOMER_PHONE           CP,
                       PHONE                    PH,
                       LU_PHONE_TYPE            PT
                 WHERE CP.PHONE_ID = PH.PHONE_ID
                   AND CP.CUSTOMER_ID = vo.old_customer_id
                   AND vo.old_account_id = vca.old_account_id
                   AND PH.PHONE_NUMBER = P_PHONE
                   AND PT.PHONE_TYPE_ID = CP.PHONE_TYPE_ID
                   AND CP.lu_cust_phone_disposition_id IN
                       (SELECT lu_cust_phone_disposition_id
                          FROM lu_customer_phone_disposition
                         WHERE cust_phone_disposition_desc IN
                               ('VERIFIED GOOD', 'POTENTIAL GOOD'));
        
        ELSE
        
            OPEN PREF_CURSOR FOR
                SELECT DISTINCT vca.card_num,
                                vca.primary_name,
                                vca.primary_ssn,
                                vca.external_status,
                                vca.customer_id,
                                vca.credit_account_id,
                                ph.phone_number,
                                pt.phone_type,
                                pt.phone_type_id
                  FROM v_customer_accounts      vca,
                       V_OLD_CUSTOMER_INTERSECT vo,
                       customer_phone           cp,
                       phone                    ph,
                       lu_phone_type            pt,
                       t_coll_acct              t,
                       cl_agency                cl,
                       cl_agency_owner          clo
                 WHERE cp.phone_id = ph.phone_id
                   AND cp.customer_id = vo.old_customer_id
                   AND vo.old_account_id = vca.old_account_id
                   AND ph.phone_number = p_phone
                   AND pt.phone_type_id = cp.phone_type_id
                   AND t.account_id = vca.old_account_id
                   AND t.agency_id = clo.agency_owner_id
                   AND (clo.agency_owner_id = cl.agency_id OR EXISTS
                        (SELECT r.agency_related_to
                           FROM t_agency_relation r
                          WHERE r.agency_id = cl.agency_id
                            AND r.agency_related_to = clo.agency_owner_id))
                   AND cl.agency_ident = p_filter_by
                   AND CP.lu_cust_phone_disposition_id IN
                       (SELECT lu_cust_phone_disposition_id
                          FROM lu_customer_phone_disposition
                         WHERE cust_phone_disposition_desc IN
                               ('VERIFIED GOOD', 'POTENTIAL GOOD'))
                 ORDER BY pt.phone_type;
        
        END IF;
    END;

    /******************************************************************************
    *
    *  Title:        pr_update_spouse_name
    *  Schema Owner: COLL
    *  Created:      March 7, 2006
    *  Author:       Sherzod Niazov
    *
    *  Description: This will update spouse's name
    *
    *  Modifications:
    *    Date            Who                    Description
    *    03/07/2006        Sherzod Niazov        Initial procedure
    ******************************************************************************/
    PROCEDURE PR_UPDATE_SPOUSE_NAME(P_CARD_NUMBER IN account.card_number%TYPE,
                                    P_SPOUSE_NAME IN VARCHAR2) IS
    BEGIN
        UPDATE T_COLL_ACCT COLLA
           SET COLLA.SPOUSE_NAME = P_SPOUSE_NAME
         WHERE COLLA.ACCOUNT_ID =
               (SELECT ACCOUNT_ID
                  FROM ACCOUNT
                 WHERE CARD_NUMBER = P_CARD_NUMBER);
    
        COMMIT;
    END;

    /******************************************************************************
    *
    *  Title:        pr_update_dns
    *  Schema Owner: COLL
    *  Created:      March 7, 2006
    *  Author:       Sherzod Niazov
    *
    *  Description: This will update DO NOT NEGOTIOATE SPOUSE flag
    *
    *  Modifications:
    *    Date            Who                    Description
    *    03/07/2006        Sherzod Niazov        Initial procedure
    ******************************************************************************/
    PROCEDURE PR_UPDATE_DNS(P_CARD_NUMBER IN account.card_number%TYPE,
                            P_FLAG        IN VARCHAR2) IS
        VALLIST   VARCHAR2(4000);
        VCARD_NUM VARCHAR2(19);
        VFLAG     VARCHAR2(1);
    BEGIN
        UPDATE T_COLL_ACCT COLLA
           SET COLLA.DONT_NEGOTIATE_SPOUSE = P_FLAG
         WHERE COLLA.ACCOUNT_ID =
               (SELECT ACCOUNT_ID
                  FROM ACCOUNT
                 WHERE CARD_NUMBER = P_CARD_NUMBER);
    
        COMMIT;
    END;

    /******************************************************************************
    *
    *  Title:        pr_get_authorizations
    *  Schema Owner: COLL
    *  Created:      March 14, 2006
    *  Author:       Subbarac Chundu
    *
    *  Description:  This procedure return authorizations data set for a given card number.
    *
    *  Modifications:
    *    Date            Who                    Description
    *    03/07/2006        Subbarao Chundu        Initial procedure
    ******************************************************************************/
    PROCEDURE PR_GET_AUTHORIZATIONS(P_CARD_NUMBER IN NUMBER,
                                    PREF_CURSOR   OUT SYS_REFCURSOR) IS
        vAuditReturnCode NUMBER := 0;
    BEGIN
        OPEN PREF_CURSOR FOR
            SELECT TO_NUMBER(TC.CARD_NUM) CARD_NUMBER,
                   UT.TRANSACTION_AMOUNT,
                   UT.TRANSACTION_DATE,
                   UT.MERCHANT_DESCRIPTION,
                   UT.AUTH_SOURCE,
                   UT.AUTHORIZATION_NUMBER
              FROM UNBILLED_TRANSACTIONS UT,
                   T_CARD                TC
             WHERE TC.CARD_NUM = TO_CHAR(P_CARD_NUMBER)
               AND UT.CARD_ID = TC.CARD_ID
               AND UT.TRANSACTION_CODE = 252
               AND SUBSTR(UT.REFERENCE, 1, 1) = 'G';
    
        pkg_app_audit.pr_set_audit_data(p_audit_applicatn_cd => 'CASH',
                                        p_audit_process_name => 'PR_GET_AUTHORIZATIONS',
                                        p_audit_action => 'Select',
                                        p_audit_value_type => NULL,
                                        p_audit_old_value => NULL,
                                        p_audit_new_value => NULL,
                                        p_audit_ref_id => NULL,
                                        p_audit_ref_type_id => NULL,
                                        p_audit_employee_id => NULL,
                                        p_audit_return_code => vAuditReturnCode);
    END;

    PROCEDURE PR_GET_CUST_RECALL_MAXTIME(p_area_code IN NUMBER,
                                         pref_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN pref_cursor FOR
            SELECT RECALL_MAX_HR,
                   RECALL_MAX_MM,
                   RECALL_MAX_SS
              FROM T_LU_TIMEZONE
             WHERE AREA_CODE = p_area_code;
    END;

    /******************************************************************************
    *
    *  Title:        pr_account_search_by_cust_id
    *  Schema Owner: COLL
    *  Created:      October 10, 2013
    *  Author:       LMALLIAHAGARI
    *
    *  Description: This will search for account by cust id
    *
    *  Modifications:
    *    Date            Who                    Description
    *    04/24/2015      Alagiyanathan          Added phonetype and phonetypeid in select query
    ******************************************************************************/
    PROCEDURE PR_ACCOUNT_SEARCH_BY_CUST_ID(P_CUST_ID   IN NUMBER,
                                           p_filter_by cl_agency.agency_ident%TYPE,
                                           PREF_CURSOR OUT SYS_REFCURSOR) AS
    BEGIN
    
        IF p_filter_by = 'FNBM' OR p_filter_by IS NULL THEN
        
            OPEN PREF_CURSOR FOR
                SELECT DISTINCT vca.card_num,
                                vca.primary_name,
                                vca.primary_ssn,
                                vca.external_status,
                                vca.customer_id,
                                vca.credit_account_id,
                                NULL                  AS phone_type,
                                NULL                  AS phone_type_id
                  FROM v_customer_accounts vca
                 WHERE vca.customer_id = P_CUST_ID
                 ORDER BY vca.primary_name;
        
        ELSE
        
            OPEN PREF_CURSOR FOR
            
                SELECT DISTINCT vca.card_num,
                                vca.primary_name,
                                vca.primary_ssn,
                                vca.external_status,
                                vca.customer_id,
                                vca.credit_account_id,
                                NULL                  AS phone_type,
                                NULL                  AS phone_type_id
                  FROM v_customer_accounts vca,
                       t_coll_acct         t,
                       cl_agency           cl,
                       cl_agency_owner     clo
                 WHERE vca.customer_id = P_CUST_ID
                   AND t.account_id = vca.old_account_id
                   AND t.agency_id = clo.agency_owner_id
                   AND (clo.agency_owner_id = cl.agency_id OR EXISTS
                        (SELECT r.agency_related_to
                           FROM t_agency_relation r
                          WHERE r.agency_id = cl.agency_id
                            AND r.agency_related_to = clo.agency_owner_id))
                   AND cl.agency_ident = p_filter_by
                 ORDER BY vca.primary_name;
        END IF;
    
    END;

    /******************************************************************************
    *
    *  Title:        pr_account_search_by_crdtacct
    *  Schema Owner: COLL
    *  Created:      October 10, 2013
    *  Author:       LMALLIAHAGARI
    *
    *  Description: This will search for account by credit account id
    *
    *  Modifications:
    *    Date            Who                    Description
    *    04/24/2015      Alagiyanathan          Added phonetype and phonetypeid in select query
    ******************************************************************************/
    PROCEDURE PR_ACCOUNT_SEARCH_BY_CRDTACCT(P_CRDT_ACCT_ID IN NUMBER,
                                            p_filter_by    cl_agency.agency_ident%TYPE,
                                            PREF_CURSOR    OUT SYS_REFCURSOR) AS
    BEGIN
    
        IF p_filter_by = 'FNBM' OR p_filter_by IS NULL THEN
        
            OPEN PREF_CURSOR FOR
                SELECT DISTINCT vca.card_num,
                                vca.primary_name,
                                vca.primary_ssn,
                                vca.external_status,
                                vca.customer_id,
                                vca.credit_account_id,
                                NULL                  AS phone_type,
                                NULL                  AS phone_type_id
                  FROM v_customer_accounts vca
                 WHERE vca.credit_account_id = P_CRDT_ACCT_ID
                 ORDER BY vca.primary_name;
        
        ELSE
        
            OPEN PREF_CURSOR FOR
                SELECT DISTINCT vca.card_num,
                                vca.primary_name,
                                vca.primary_ssn,
                                vca.external_status,
                                vca.customer_id,
                                vca.credit_account_id,
                                NULL                  AS phone_type,
                                NULL                  AS phone_type_id
                  FROM v_customer_accounts vca,
                       t_coll_acct         t,
                       cl_agency           cl,
                       cl_agency_owner     clo
                 WHERE vca.credit_account_id = P_CRDT_ACCT_ID
                   AND t.account_id = vca.old_account_id
                   AND t.agency_id = clo.agency_owner_id
                   AND (clo.agency_owner_id = cl.agency_id OR EXISTS
                        (SELECT r.agency_related_to
                           FROM t_agency_relation r
                          WHERE r.agency_id = cl.agency_id
                            AND r.agency_related_to = clo.agency_owner_id))
                   AND cl.agency_ident = p_filter_by
                 ORDER BY vca.primary_name;
        
        END IF;
    
    END;

    /******************************************************************************
      *
      *  Title:        pr_account_search_by_phone
      *  Schema Owner: COLL
      *
      *  Description: This will search for account by Card number
      *
      *  Modifications:
      *    Date            Who                    Description
    *    1/21/2015     Vijayashankar Palanichamy   Filtered the Duplicate Search Results.
      *    04/24/2015      Alagiyanathan          Added phonetype and phonetypeid in select query
      ******************************************************************************/
    PROCEDURE PR_ACCOUNT_SEARCH_BY_CARD_NUM(P_CARD_NUM  IN v_customer_accounts.card_num%TYPE,
                                            p_filter_by cl_agency.agency_ident%TYPE,
                                            PREF_CURSOR OUT SYS_REFCURSOR) AS
    BEGIN
    
        IF p_filter_by = 'FNBM' OR p_filter_by IS NULL THEN
        
            OPEN PREF_CURSOR FOR
                SELECT DISTINCT vca.card_num,
                                vca.primary_name,
                                vca.primary_ssn,
                                vca.external_status,
                                vca.customer_id,
                                vca.credit_account_id,
                                NULL                  AS phone_type,
                                NULL                  AS phone_type_id
                  FROM v_customer_accounts vca
                 WHERE vca.card_num = P_CARD_NUM
                 ORDER BY vca.primary_name;
        
        ELSE
        
            OPEN PREF_CURSOR FOR
            
                SELECT DISTINCT vca.card_num,
                                vca.primary_name,
                                vca.primary_ssn,
                                vca.external_status,
                                vca.customer_id,
                                vca.credit_account_id,
                                NULL                  AS phone_type,
                                NULL                  AS phone_type_id
                  FROM v_customer_accounts vca,
                       t_coll_acct         t,
                       cl_agency           cl,
                       cl_agency_owner     clo
                 WHERE vca.card_num = P_CARD_NUM
                   AND t.account_id = vca.old_account_id
                   AND t.agency_id = clo.agency_owner_id
                   AND (clo.agency_owner_id = cl.agency_id OR EXISTS
                        (SELECT r.agency_related_to
                           FROM t_agency_relation r
                          WHERE r.agency_id = cl.agency_id
                            AND r.agency_related_to = clo.agency_owner_id))
                   AND cl.agency_ident = p_filter_by
                 ORDER BY vca.primary_name;
        END IF;
    
    END;

    /******************************************************************************
    *
    *  Title:        pr_advanced_account_search
    *  Schema Owner: COLL
    *  Created:      February 29, 2016
    *  Author:       MSANTOS
    *
    *  Description: This will search for account by different criteria
    ******************************************************************************/
    PROCEDURE pr_advanced_account_search(p_filter_by       cl_agency.agency_ident%TYPE,
                                         p_crdt_account    v_customer_accounts.credit_account_id%TYPE,
                                         p_crdt_card_last4 v_customer_accounts.vr_card_num_last4%TYPE,
                                         p_phone_number    phone.phone_number%TYPE,
                                         p_ssn             v_customer_accounts.primary_ssn%TYPE,
                                         p_first_name      v_customer_accounts.primary_name%TYPE,
                                         p_last_name       v_customer_accounts.primary_name%TYPE,
                                         p_customer_id     v_old_customer_intersect.old_customer_id%TYPE,
                                         PREF_CURSOR       OUT SYS_REFCURSOR) AS
    
        v_main_query VARCHAR2(5000);
        v_filters    VARCHAR2(500);
        v_order_by   VARCHAR2(200);
        v_first_name VARCHAR2(200);
        v_last_name  VARCHAR2(200);
        v_agency_id  cl_agency.agency_id%TYPE;
    BEGIN
    
        IF p_filter_by = 'FNBM' OR p_filter_by IS NULL THEN
        
            v_main_query := 'SELECT DISTINCT vca.card_num,' ||
                            '                vca.primary_name,' ||
                            '                vca.primary_ssn,' ||
                            '                vca.external_status,' ||
                            '                vca.customer_id,' ||
                            '                vca.credit_account_id,' ||
                            '                ph.phone_number,' ||
                            '                pt.phone_type,' ||
                            '                pt.phone_type_id' ||
                            '  FROM v_customer_accounts      vca,' ||
                            '       v_old_customer_intersect vo,' ||
                            '       customer_phone           cp,' ||
                            '       phone                    ph,' ||
                            '       lu_phone_type            pt' ||
                            ' WHERE vca.old_account_id = vo.old_account_id(+)' ||
                            '   AND vo.old_customer_id = cp.customer_id(+) ' ||
                            '   AND cp.phone_id = ph.phone_id(+)' ||
                            '   AND cp.phone_type_id = pt.phone_type_id(+)' ||
                            '   AND (vo.old_customer_id IS NULL OR vo.primary_chd_id IS NOT NULL)';
        
        ELSE
        
            SELECT cl.agency_id
              INTO v_agency_id
              FROM cl_agency cl
             WHERE cl.agency_ident = p_filter_by;
        
            v_main_query := 'SELECT DISTINCT vca.card_num,' ||
                            '                vca.primary_name,' ||
                            '                vca.primary_ssn,' ||
                            '                vca.external_status,' ||
                            '                vca.customer_id,' ||
                            '                vca.credit_account_id,' ||
                            '                ph.phone_number,' ||
                            '                pt.phone_type,' ||
                            '                pt.phone_type_id' ||
                            '  FROM v_customer_accounts      vca,' ||
                            '       t_coll_acct              t,' ||
                            '       cl_agency                cl,' ||
                            '       cl_agency_owner          clo,' ||
                            '       v_old_customer_intersect vo,' ||
                            '       customer_phone           cp,' ||
                            '       phone                    ph,' ||
                            '       lu_phone_type            pt' ||
                            ' WHERE t.account_id = vca.old_account_id' ||
                            '   AND t.agency_id = clo.agency_owner_id' ||
                            '   AND cl.agency_id = ' || v_agency_id ||
                            '   AND (clo.agency_owner_id = cl.agency_id OR' ||
                            '       EXISTS' ||
                            '         (SELECT r.agency_related_to' ||
                            '            FROM t_agency_relation r' ||
                            '           WHERE r.agency_id = cl.agency_id' ||
                            '           AND r.agency_related_to = clo.agency_owner_id))' ||
                            '   AND vca.old_account_id = vo.old_account_id(+)' ||
                            '   AND vo.old_customer_id = cp.customer_id(+) ' ||
                            '   AND cp.phone_id = ph.phone_id(+)' ||
                            '   AND cp.phone_type_id = pt.phone_type_id(+)' ||
                            '   AND (vo.old_customer_id IS NULL OR vo.primary_chd_id IS NOT NULL)';
        
        END IF;
    
        IF (p_crdt_account IS NOT NULL) THEN
            v_filters := v_filters || ' AND vca.credit_account_id = ' ||
                         p_crdt_account;
        END IF;
    
        IF (p_crdt_card_last4 IS NOT NULL) THEN
            v_filters := v_filters || ' AND vca.vr_card_num_last4 = ''' ||
                         p_crdt_card_last4 || '''';
        END IF;
    
        IF (p_phone_number IS NOT NULL) THEN
            v_filters := v_filters || ' AND ph.phone_number = ' ||
                         p_phone_number;
        ELSE
            v_filters := v_filters ||
                         ' AND (cp.customer_phone_id IS NULL OR  cp.customer_phone_id = PKG_COLL_ACCOUNT_INFO.fn_get_phone_id(cp.customer_id))';
        END IF;
    
        IF (p_ssn IS NOT NULL) THEN
            v_filters := v_filters || ' AND vca.primary_ssn = ''' || p_ssn || '''';
        END IF;
    
        IF (p_first_name IS NOT NULL) THEN
            v_first_name := UPPER(p_first_name);
            v_last_name  := UPPER(p_last_name);
        
            v_filters := v_filters || ' AND vca.primary_name LIKE ''' ||
                         v_last_name || '%,%' || v_first_name || '%''';
        
        ELSE
            v_last_name := UPPER(p_last_name);
            v_filters   := v_filters || ' AND vca.primary_name LIKE ''' ||
                           v_last_name || '%''';
        
        END IF;
    
        IF (p_customer_id IS NOT NULL) THEN
            v_filters := v_filters || ' AND vca.customer_id = ' ||
                         p_customer_id;
        END IF;
    
        v_order_by := ' ORDER BY vca.primary_name';
    
        OPEN PREF_CURSOR FOR v_main_query || v_filters || v_order_by;
    
    END;

    /******************************************************************************
    *
    *  Title:        pr_default_account_search
    *  Schema Owner: COLL
    *  Created:      March 10, 2016
    *  Author:       MSANTOS
    *
    *  Description: This will search for account by default criteria
    ******************************************************************************/
    PROCEDURE pr_default_account_search(p_filter_by    cl_agency.agency_ident%TYPE,
                                        p_filter_value VARCHAR2,
                                        PREF_CURSOR    OUT SYS_REFCURSOR) AS
        v_default          VARCHAR2(100);
        v_main_query       VARCHAR2(5000);
        v_filters          VARCHAR2(500);
        v_order_by         VARCHAR2(200);
        v_lookup_type_desc t_coll_lookup_type.lookup_type_desc%TYPE := 'CASH Default Search';
    BEGIN
        SELECT lc.lookup_value
          INTO v_default
          FROM t_coll_lookup_code lc,
               t_coll_lookup_type lt
         WHERE lc.lookup_type_id = lt.lookup_type_id
           AND lt.lookup_type_desc = v_lookup_type_desc
           AND lc.lookup_desc = p_filter_by
           AND ROWNUM = 1;
    
        IF (v_default IS NOT NULL) THEN
            IF p_filter_by = 'FNBM' OR p_filter_by IS NULL THEN
            
                v_main_query := 'SELECT DISTINCT vca.card_num,' ||
                                '                vca.primary_name,' ||
                                '                vca.primary_ssn,' ||
                                '                vca.external_status,' ||
                                '                vca.customer_id,' ||
                                '                vca.credit_account_id,' ||
                                '                NULL as phone_number,' ||
                                '                NULL as phone_type,' ||
                                '                NULL as phone_type_id' ||
                                '  FROM v_customer_accounts      vca' ||
                                ' WHERE vca.current_card = 1';
            
            ELSE
                v_main_query := 'SELECT DISTINCT vca.card_num,' ||
                                '                vca.primary_name,' ||
                                '                vca.primary_ssn,' ||
                                '                vca.external_status,' ||
                                '                vca.customer_id,' ||
                                '                vca.credit_account_id,' ||
                                '                NULL as phone_number,' ||
                                '                NULL as phone_type,' ||
                                '                NULL as phone_type_id' ||
                                '  FROM v_customer_accounts      vca,' ||
                                '       t_coll_acct              t,' ||
                                '       cl_agency                cl,' ||
                                '       cl_agency_owner          clo' ||
                                ' WHERE t.account_id = vca.old_account_id' ||
                                '   AND t.agency_id = clo.agency_owner_id' ||
                                '   AND cl.agency_ident = ''' ||
                                p_filter_by || '''' ||
                                '   AND (clo.agency_owner_id = cl.agency_id OR' ||
                                '       EXISTS' ||
                                '         (SELECT r.agency_related_to' ||
                                '            FROM t_agency_relation r' ||
                                '           WHERE r.agency_id = cl.agency_id' ||
                                '           AND r.agency_related_to = clo.agency_owner_id))' ||
                                '   AND vca.current_card = 1';
            END IF;
            v_filters  := v_filters || 'AND vca.' || v_default || ' = ' ||
                          p_filter_value;
            v_order_by := ' ORDER BY vca.primary_name';
        
            OPEN PREF_CURSOR FOR v_main_query || v_filters || v_order_by;
        END IF;
    END;

    /******************************************************************************
    *
    *  Title:        fn_get_phone_id
    *  Schema Owner: COLL
    *  Created:      May 03, 2016
    *  Author:       MSANTOS
    *
    *  Description: This will search for the last phone id for a customer
    ******************************************************************************/
    FUNCTION fn_get_phone_id(p_customer_id NUMBER) RETURN NUMBER AS
        v_phone_id NUMBER;
    BEGIN
        SELECT customer_phone_id
          INTO v_phone_id
          FROM (SELECT cp.customer_phone_id
                  FROM customer_phone cp
                 WHERE cp.customer_id = p_customer_id
                 ORDER BY EFFECTIVE_DATE DESC)
         WHERE ROWNUM = 1;
    
        RETURN v_phone_id;
    END;

END PKG_COLL_ACCOUNT_INFO_R;
/
GRANT EXECUTE ON COLL.PKG_COLL_ACCOUNT_INFO_P TO ODS_STG;
