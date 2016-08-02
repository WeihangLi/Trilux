/**
 * Trigger handler class for Account which does following actions
 * - 1. Update KAM / ASR AccuntSharing ,Group and update KAM / ASR GroupMember.
 * - 2. Update Account's Manually__c.
 * - 3. R-202?Key Account Sharing , https://emea.salesforce.com/a0E2000000qYffeEAC
 * - 4. R-911 Account Sharing: Trigger for Contact Sharing (Online), https://bgcloudservice.my.salesforce.com/a0E2000000tkQLuEAM
 *
 * @author Lingjun Jiang
 * @created 2014-10-15
 * @version 1.0
 * @since 30.0
 *
 * @changelog
 * 2014-10-15 Lingjun Jiang <lingjun.jiang@itbconsult.com>
 * 2016-05-23 Lili Zhao <lili.zhao@oinio.com>
 * - 1.D-1239 Contact Address has been changed
 * - Created
 */

public class ClsTriggerAccountHandler extends ClsTriggerVirtual {
    
    private static final Map<String, String> map_userLanguage_accLanguage = new Map<String, String> {
        'de' => 'DE',
        'en_US' => 'EN',
        'es' => 'ES',
        'fr' => 'FR',
        'it' => 'IT',
        'nl_NL' => 'NL'
    };
    
    /**
    * @see IntHelper.beforeTrigger
    */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        setAccountLanguage(trgCtx);
        updateTerritoryData(trgCtx);
        setAccount4Street(trgCtx);
    }
    
    /**
    * @see IntHelper.beforeTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        updateContactAddress(trgCtx);
        createSalesOrgStatistics(trgCtx);
        updateAccountDetailRecordType(trgCtx);
    }
    /**
     *  This function is used to update Contact Address information (R-290)
     *  
     *
     @author    Yuda Zheng
     @created   2016-01-19
     @version   1.0
     @since     35.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-01-19 Yuda Zheng <yuda.zheng@oinio.com>
     * - Created
    */
    @TestVisible
    private void updateTerritoryData(ClsWrappers.TriggerContext trgCtx){
        if(trgCtx.isBefore && !trgCtx.isDelete){
            map<String,List<Account>> map_zipCode_accIds = new map<String,List<Account>>();
            set<String> set_orgs = new set<String>();
            for(SObject sobj : trgCtx.newList){
                Account acc = (Account)sobj;
                Account oldAcc;
                if(trgCtx.isUpdate){
                    oldAcc = (Account)trgCtx.oldMap.get(acc.Id);
                }
                if((trgCtx.isInsert && acc.BillingPostalCode != '') || (trgCtx.isUpdate && acc.BillingPostalCode != '' && acc.BillingPostalCode != oldAcc.BillingPostalCode)){
                    if(!map_zipCode_accIds.containsKey(acc.BillingPostalCode)){
                        map_zipCode_accIds.put(acc.BillingPostalCode,new list<Account>());
                    }
                    if(acc.Sales_Organisation__c != ''){
                        set_orgs.add(acc.Sales_Organisation__c);
                        map_zipCode_accIds.get(acc.BillingPostalCode).add(acc);
                    }
                }
            }
            List<String> fields = new List<String>();
            fields.addAll(Territory_Data__c.SObjectType.getDescribe().fields.getMap().keySet());
            list<Territory_Data__c> list_terData = new list<Territory_Data__c>();
            list_terData = [select Id,X01_06_Account_MAM__c,X01_06_Opportunity_ID__c,X02_Account_MAM__c,X02_Opportunity_ID__c,
                                   X03_Account_MAM__c,X03_Opportunity_ID__c,X09_Account_MAM__c,X09_Opportunity_ID__c, Country__c, 
                                   X11_Account_MAM__c,X11_Opportunity_ID__c,X15_Account_MAM__c,X15_Opportunity_ID__c,PLZ__c,Sales_Organisation__c 
                                   from Territory_Data__c where PLZ__c in: map_zipCode_accIds.keySet() and Sales_Organisation__c in: set_orgs];
            for(SObject sobj : trgCtx.newList){
                Account acc = (Account)sobj;
                String strVal = '';
                for(Territory_Data__c td:list_terData){
                    if(acc.BillingPostalCode == td.PLZ__c){
                        for(String str:fields){
                            if(acc.Initial_Sales_Channel__c != null && (str.toUpperCase()).indexOf(acc.Initial_Sales_Channel__c) > -1 && (str.toUpperCase()).indexOf('ACCOUNT') > -1){
                                strVal += td.get(str)+',';
                            }
                        }
                    }
                }
                if(strVal.length() > 1){
                    strVal = strVal.substring(0,strVal.length() - 1);
                }
                acc.Territory_Data__c = strVal;
                
                if(acc.Initial_Sales_Org__c == '' || acc.Initial_Sales_Org__c == null){
                    String vkOrg = '';
                    for(User u : [select Id, VKORG__c, ProfileId from User where id =: UserInfo.getUserID()]){
                        vkOrg = u.VKORG__c;
                    }
                    acc.Initial_Sales_Org__c = vkOrg;
                }
            }                            
        }
    }
    /**
     *  This function is used to update Contact Address information (R-290)
     *  
     *
     @author    Yuda Zheng
     @created   2016-01-19
     @version   1.0
     @since     35.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-01-19 Yuda Zheng <yuda.zheng@oinio.com>
     * - Created
    */
    @TestVisible
    private void updateContactAddress(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isAfter) {
             map<String, Account> map_accId_newAccounts = new map<String, Account>();
             map<String, Account> map_accId_oldAccounts = new map<String, Account>();
             list<Contact> list_contact2Update = new list<Contact>();
             
             if(trgCtx.isUpdate){
                for(SObject sobj : trgCtx.newList) {
                    Account acc = (Account)sobj;
                    Account oldAcc = (Account)trgCtx.oldMap.get(acc.Id);
                    if(acc.BillingStreet != oldAcc.BillingStreet || acc.BillingPostalCode != oldAcc.BillingPostalCode || acc.BillingCity != oldAcc.BillingCity
                     || acc.BillingState != oldAcc.BillingState ||acc.BillingCountry != oldAcc.BillingCountry){
                        map_accId_oldAccounts.put(oldAcc.Id, oldAcc);
                        map_accId_newAccounts.put(acc.Id, acc);
                    }
                }
                
                if(!map_accId_oldAccounts.isEmpty()){
                    for(Contact con : [select Id, AccountId, MailingStreet, MailingPostalCode, MailingCity, MailingState, MailingCountry  from Contact where AccountId in: map_accId_oldAccounts.keySet()]) {
                        if(map_accId_oldAccounts.containsKey(con.AccountId) && map_accId_oldAccounts.get(con.AccountId) != null){
                            Boolean isChanged = false;
                            //added lili zhao 2016-5-23 due to compare all address fields mutually and evaluate a match / dismatch based on all fields.
                            /*
                            if(map_accId_oldAccounts.get(con.AccountId).BillingStreet == con.MailingStreet){
                                con.MailingStreet = map_accId_newAccounts.get(con.AccountId).BillingStreet;
                                isChanged = true;
                            }
                            if(map_accId_oldAccounts.get(con.AccountId).BillingPostalCode == con.MailingPostalCode){
                                con.MailingPostalCode = map_accId_newAccounts.get(con.AccountId).BillingPostalCode;
                                isChanged = true;
                            }
                            if(map_accId_oldAccounts.get(con.AccountId).BillingCity == con.MailingCity){
                                con.MailingCity = map_accId_newAccounts.get(con.AccountId).BillingCity;
                                isChanged = true;
                            }
                            if(map_accId_oldAccounts.get(con.AccountId).BillingState == con.MailingState){
                                con.MailingState = map_accId_newAccounts.get(con.AccountId).BillingState;
                                isChanged = true;
                            }
                            if(map_accId_oldAccounts.get(con.AccountId).BillingCountry == con.MailingCountry){
                                con.MailingCountry = map_accId_newAccounts.get(con.AccountId).BillingCountry;
                                isChanged = true;
                            }
                            */
                            
                            if(map_accId_oldAccounts.get(con.AccountId).BillingStreet == con.MailingStreet && 
                               map_accId_oldAccounts.get(con.AccountId).BillingPostalCode == con.MailingPostalCode && 
                               map_accId_oldAccounts.get(con.AccountId).BillingCity == con.MailingCity && 
                               map_accId_oldAccounts.get(con.AccountId).BillingState == con.MailingState && 
                               map_accId_oldAccounts.get(con.AccountId).BillingCountry == con.MailingCountry) {
                                
                                con.MailingStreet = map_accId_newAccounts.get(con.AccountId).BillingStreet;
                                con.MailingPostalCode = map_accId_newAccounts.get(con.AccountId).BillingPostalCode;
                                con.MailingCity = map_accId_newAccounts.get(con.AccountId).BillingCity;
                                con.MailingState = map_accId_newAccounts.get(con.AccountId).BillingState;
                                con.MailingCountry = map_accId_newAccounts.get(con.AccountId).BillingCountry;
                                isChanged = true;
                            }
                            
                            // end
                            if(isChanged == true){
                                list_contact2Update.add(con);
                            }
                        }
                    }
                }
                
                if(!list_contact2Update.isEmpty()){
                    update list_contact2Update;
                }   
             } 
        }
    }
    
    /**
     *  This function is used to create Sales Org Statistics (R-512)
     *  
     *
     @author    Yuda Zheng
     @created   2016-03-08
     @version   1.0
     @since     35.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-03-08 Yuda Zheng <yuda.zheng@oinio.com>
     * - Created
    */
    @TestVisible
    private void createSalesOrgStatistics(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isAfter) {
             if(trgCtx.isInsert){
                String profileId;
                String vkOrg = '';
                
                for(Profile pf : [Select Id from profile where Name = 'Middleware Integration']){
                    profileId = pf.Id;
                }
                
                //for(User u : [select Id, VKORG__c, ProfileId from User where id =: UserInfo.getUserID() and ProfileId !=: profileId]){
                for(User u : [select Id, VKORG__c, ProfileId from User where id =: UserInfo.getUserID()]){
                    vkOrg = u.VKORG__c;
                }
                //comment out by weihang 2016-04-01
                /*if(vkOrg != ''){
                    set<String> set_accId = new set<String>();
                    list<Account_Details__c> list_accountDetail2Insert = new list<Account_Details__c>();
                    
                    for(SObject sobj : trgCtx.newList) {
                        Account acc = (Account)sobj;
                        set_accId.add(acc.Id);
                    }
                    
                    if(!set_accId.isEmpty()){
                        for(String accId : set_accId){
                            Account_Details__c accDetail = new Account_Details__c();
                            accDetail.Account__c = accId;
                            accDetail.Sales_Organisation__c = vkOrg;
                            //added by Yuda Zheng <yuda.zheng@oinio.com> 2016-03-25 for R-567
                            accDetail.Inco_Terms__c = '100';
                            
                            for(Sales_Org_Statistics_Setting__mdt sossMdt : [select Field__c, Sales_Organisation__c, Value__c from Sales_Org_Statistics_Setting__mdt where Sales_Organisation__c =: vkOrg]){
                                accDetail.put(sossMdt.Field__c, sossMdt.Value__c);
                            }
                            list_accountDetail2Insert.add(accDetail);
                        }
                    }
                    if(!list_accountDetail2Insert.isEmpty()){
                        insert list_accountDetail2Insert;
                    }
                }*/
                //added by weihang 2016-04-01
                list<Account_Details__c> list_accountDetail2Insert = new list<Account_Details__c>();
                
                for(SObject sobj : trgCtx.newList) {
                    Account acc = (Account)sobj;
                    if(acc.type == 'PROS'){
                        if((acc.Initial_Sales_Org__c != null && acc.Initial_Sales_Org__c != '') || vkOrg != ''){
                            Account_Details__c accDetail = new Account_Details__c();
                            accDetail.Account__c = acc.Id;
                            if(acc.Initial_Sales_Org__c != '' && acc.Initial_Sales_Org__c != null){
                                accDetail.Sales_Organisation__c = acc.Initial_Sales_Org__c;
                            }else{
                                accDetail.Sales_Organisation__c = vkOrg;
                            }
                            accDetail.Inco_Terms__c = '100';
                            for(Sales_Org_Statistics_Setting__mdt sossMdt : [select Field__c, Sales_Organisation__c, Value__c from Sales_Org_Statistics_Setting__mdt where Sales_Organisation__c =: accDetail.Sales_Organisation__c]){
                                  accDetail.put(sossMdt.Field__c, sossMdt.Value__c);                               
                            }
                            list_accountDetail2Insert.add(accDetail);
                        }
                    }
                }
                if(!list_accountDetail2Insert.isEmpty()){
                    insert list_accountDetail2Insert;
                }
             } 
        }
    }
    
    
    /**
     *  This function is used to set account language (R-380)
     *  
     *
     @author    Yuda Zheng
     @created   2016-03-11
     @version   1.0
     @since     35.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-03-11 Yuda Zheng <yuda.zheng@oinio.com>
     * - Created
    */
    @TestVisible
    private void setAccountLanguage(ClsWrappers.TriggerContext trgCtx) {
        String lanLocal = '';
        for(User u : [select Language_Locale_Key__c from User where id =: UserInfo.getUserID()]){
            if(u.Language_Locale_Key__c != null ) lanLocal = u.Language_Locale_Key__c;
        }
        //map_userLanguage_accLanguage
        if(trgCtx.isBefore && !trgCtx.isDelete) {
            for(SObject sobj : trgCtx.newList) {
                if(sobj.get('Account_Language__c') == null && lanLocal != '' && map_userLanguage_accLanguage.containsKey(lanLocal)){
                    sobj.put('Account_Language__c', map_userLanguage_accLanguage.get(lanLocal));
                }
            }
        }
    }
    /**
     *  This function is used to set account Account.Street__c, Account.Street2__c, Account.Street3__c, Account.Street4__c. (R-540)
     *  
     *
     @author    Lili Zhao
     @created   2016-03-16
     @version   1.0
     @since     30.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-03-16 Lili Zhao <lili.zhao@oinio.com>
     * - Created
    */
    @TestVisible
    private void setAccount4Street(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isUpdate || trgCtx.isInsert){
            String currentProfile = '';
            for(User u : [select Id, Profile.Name from User where id =: UserInfo.getUserId()]){
                currentProfile = u.Profile.Name;
            }
            
            if(currentProfile == 'Middleware Integration'){
                for(SObject sobj : trgCtx.newList) {
                    Account acc = (Account)sobj;
                    
                    if(acc.Type == 'CUST' || acc.Type == 'BACU' || acc.Type == '0012'){
                        setBillingStreetAsAccount4Street(acc);
                    }
                }
            }else{
                for(SObject sobj : trgCtx.newList) {
                    Account account = (Account)sobj;
                    if(account.Type == 'PROS' && account.BillingStreet != null){
                        setAccount4StreetAsBillingStreet(account);
                    }
                }
            }
        }

    }
    
    /**
     *  This function is used to set account Account.Street__c, Account.Street2__c, Account.Street3__c, Account.Street4__c. (R-540)
     *  
     *
     @author    Lili Zhao
     @created   2016-03-16
     @version   1.0
     @since     30.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-03-16 Lili Zhao <lili.zhao@oinio.com>
     * - Created
    */    
    @TestVisible 
    private void setBillingStreetAsAccount4Street(Account acc) {
        acc.BillingStreet = (acc.Street2__c == null ? '' : (acc.Street2__c)) + '\r\n'
                          + (acc.Street3__c == null ? '' : ( acc.Street3__c)) + '\r\n'
                          + (acc.Street__c == null ? '' : (acc.Street__c )) + '\r\n' 
                          + (acc.Street4__c == null ? '' : (acc.Street4__c));
    }
    
    /**
     *  This function is used to set account Account.Street__c, Account.Street2__c, Account.Street3__c, Account.Street4__c. (R-540)
     *  
     *
     @author    Lili Zhao
     @created   2016-03-16
     @version   1.0
     @since     30.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-03-16 Lili Zhao <lili.zhao@oinio.com>
     * - Created
    */    
    @TestVisible 
    private void setAccount4StreetAsBillingStreet(Account acc) {
        list<String> list_lines = acc.BillingStreet.split('\r\n');
        if(list_lines.size() > 4) {
            acc.addError(Label.More_Than_4_Lines_Validation);
        }else if(list_lines.size() == 1){
            if(list_lines[0].length() > 40) {
                acc.addError(Label.More_Than_40_Chars_Validation);
            }else {
                acc.Street__c = list_lines[0];
                acc.Street2__c = null;
                acc.Street3__c = null;
                acc.Street4__c = null;
            }
        }else if(list_lines.size() == 2){
            if(list_lines[0].length() > 40 || list_lines[1].length() > 40) {
                acc.addError(Label.More_Than_40_Chars_Validation);
            }else {
                acc.Street2__c = null;
                acc.Street3__c = list_lines[0];
                acc.Street__c = list_lines[1];
                acc.Street4__c = null;
            }
        }else if(list_lines.size() == 3 || list_lines.size() == 4) {
            if(list_lines[0].length() > 40 || list_lines[1].length() > 40 || list_lines[2].length() > 40) {
                acc.addError(Label.More_Than_40_Chars_Validation);
            }else {
                if(list_lines.size() == 4 && list_lines[3].length() > 40) {
                    acc.addError(Label.More_Than_40_Chars_Validation);
                }
                acc.Street2__c = list_lines[0];
                acc.Street3__c = list_lines[1];
                acc.Street__c = list_lines[2];
                acc.Street4__c = null;
                if(list_lines.size() == 4) acc.Street4__c = list_lines[3];
            }
        }
    }

    /**
     *  This function is used to update Sales Org Statistics Record Type (R-419)
     *  
     *
     @author    Yuda Zheng
     @created   2016-03-28
     @version   1.0
     @since     35.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-03-28 Yuda Zheng <yuda.zheng@oinio.com>
     * - Created
    */
    @TestVisible
    private void updateAccountDetailRecordType(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isAfter) {
            if(trgCtx.isUpdate){
                Map<String, String> map_AccountRecordType_id = new Map<String, String>();
                Map<String, String> map_AccountDetailRecordType_id = new Map<String, String>();
                list<Account_Details__c> list_AccountDetail2Update = new list<Account_Details__c>();
                set<String> set_accId = new set<String>();

                for(RecordType rt : [select Id, DeveloperName, SobjectType from RecordType where SobjectType in ('Account', 'Account_Details__c') and DeveloperName in ('Pros2Cus', 'Customer')]){
                    if(rt.SobjectType == 'Account'){
                        map_AccountRecordType_id.put(rt.DeveloperName, rt.Id);
                    }else{
                        map_AccountDetailRecordType_id.put(rt.DeveloperName, rt.Id);
                    }
                }
                
                if(map_AccountRecordType_id != null){
                    for(SObject sobj : trgCtx.newList) {
                        Account acc = (Account)sobj;
                        Account oldAcc = (Account)trgCtx.oldMap.get(acc.Id);
                        if(acc.RecordTypeId != oldAcc.RecordTypeId && 
                            ((map_AccountRecordType_id.get('Pros2Cus') != null && acc.RecordTypeId == map_AccountRecordType_id.get('Pros2Cus'))
                            || (map_AccountRecordType_id.get('Pros2Cus') != null && acc.RecordTypeId == map_AccountRecordType_id.get('Customer')))){
                            set_accId.add(acc.Id);
                        }
                    }
                }

                if(!set_accId.isEmpty()){
                    
                    
                    if(map_AccountDetailRecordType_id != null){
                        for(Account_Details__c accDetail : [select Id, Account__c, Account__r.RecordType.Name, RecordTypeId from Account_Details__c where Account__c in: set_accId]){
                            if(accDetail.Account__r.RecordType.Name == 'Pros2Cus'){
                                accDetail.RecordTypeId = map_AccountDetailRecordType_id.get('Pros2Cus');
                                list_AccountDetail2Update.add(accDetail);
                            }else if(accDetail.Account__r.RecordType.Name == 'Customer'){
                                accDetail.RecordTypeId = map_AccountDetailRecordType_id.get('Customer');
                                list_AccountDetail2Update.add(accDetail);
                            }
                        }
                    }
                }

                if(!list_AccountDetail2Update.isEmpty()){
                    update list_AccountDetail2Update;
                }
             } 
        }
    }
}