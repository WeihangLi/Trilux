/**
 *  
 *
 @author  weihang li
 @created 2016-03-23    
 @version 1.0
 @since   36.0 (Force.com ApiVersion)
 *
 @changelog
 * 2016-03-23 weihang li <weihang.li@oinio.com>
 * - Created    
 */
global class BatchCls_UpdateTerritoryDataOnAccount extends SchedulerVizArt.ClsBatchVirtual{
    global override Database.QueryLocator start(Database.BatchableContext BC){
        String querySql = 'SELECT Id,Name,Initial_Sales_Channel__c,Territory_Data__c,BillingPostalCode,Sales_Organisation__c FROM Account where Initial_Sales_Channel__c != \'\'';
         
        return Database.getQueryLocator(querySql);
    }
    
    global override void execute(Database.BatchableContext BC, list<SObject> list_sobj) {
        List<Account> list_accUpdate = new List<Account>();
        map<String,List<Account>> map_zipCode_accIds = new map<String,List<Account>>();
        set<String> set_orgs = new set<String>();
        for(SObject sobj: list_sobj) {
            Account acc = (Account)sobj;
            if(!map_zipCode_accIds.containsKey(acc.BillingPostalCode)){
                map_zipCode_accIds.put(acc.BillingPostalCode,new list<Account>());
            }
            
            if(acc.Sales_Organisation__c != ''){
                map_zipCode_accIds.get(acc.BillingPostalCode).add(acc);
                set_orgs.add(acc.Sales_Organisation__c);
            }
        }
        List<String> fields = new List<String>();
        fields.addAll(Territory_Data__c.SObjectType.getDescribe().fields.getMap().keySet());
        
        list<Territory_Data__c> list_terData = new list<Territory_Data__c>();
        list_terData = [select Id,X01_06_Account_MAM__c,X01_06_Opportunity_ID__c,X02_Account_MAM__c,X02_Opportunity_ID__c,
                                   X03_Account_MAM__c,X03_Opportunity_ID__c,X09_Account_MAM__c,X09_Opportunity_ID__c, Country__c, 
                                   X11_Account_MAM__c,X11_Opportunity_ID__c,X15_Account_MAM__c,X15_Opportunity_ID__c,PLZ__c,Sales_Organisation__c 
                                   from Territory_Data__c where PLZ__c in: map_zipCode_accIds.keySet() and Sales_Organisation__c in: set_orgs];
        for(SObject sobj: list_sobj){
            Account acc = (Account)sobj;
            String strVal = '';
            for(Territory_Data__c td:list_terData){
                if(acc.BillingPostalCode == td.PLZ__c){
                    for(String str:fields){
                        if((str.toUpperCase()).indexOf(acc.Initial_Sales_Channel__c) > -1 && (str.toUpperCase()).indexOf('ACCOUNT') > -1){
                            strVal += td.get(str)+',';
                        }
                    }
                }
            }
            if(strVal != '') strVal = strVal.substring(0,strVal.length() - 1);
            acc.Territory_Data__c = strVal;
            list_accUpdate.add(acc);
        }                            
        if(!list_accUpdate.isEmpty()){
        	system.debug('list_accUpdate::: '+list_accUpdate);
            update list_accUpdate;
        }
    }
}