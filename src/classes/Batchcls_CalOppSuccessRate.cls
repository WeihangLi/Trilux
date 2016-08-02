global class Batchcls_CalOppSuccessRate  extends SchedulerVizArt.ClsBatchVirtual{
    global override Database.QueryLocator start(Database.BatchableContext BC){
        String querySql = 'SELECT Id FROM Account';
        
        return Database.getQueryLocator(querySql);
    }
    
    global override void execute(Database.BatchableContext BC, list<SObject> list_sobj) {
        map<String, map<String, Opportunity>> map_accid_Opps = new map<String, map<String, Opportunity>>();
        map<String, Account> map_accid_Accs = new map<String, Account>();
        list<Account> list_account2update = new list<Account>();
        
        for(SObject sobj: list_sobj) {
            Account acc = (Account)sobj;
            map_accid_Accs.put(acc.Id, acc);
            map_accid_Opps.put(acc.Id, new map<String, Opportunity>());
        }
        
        for(Opportunity opp : [Select Id, Order_Value__c, Amount, Degree_Of_Fulfillment__c, AccountId From Opportunity where AccountId in: map_accid_Opps.keySet() 
                              and CreatedDate >=: Date.today().addMonths(-36) and CreatedDate <: Date.today().addDays(1)]){
            if(!map_accid_Opps.get(opp.AccountId).containsKey(opp.Id)){
                map_accid_Opps.get(opp.AccountId).put(opp.Id, opp);
            }
        }
        for(Opportunity_Partner__c oppPartner : [Select Id, Partner_Account__c,Opportunity__c, Opportunity__r.Order_Value__c, Opportunity__r.Amount, Opportunity__r.Degree_Of_Fulfillment__c
                                                From Opportunity_Partner__c where Partner_Account__c in: map_accid_Opps.keySet() 
                                                and Opportunity__r.CreatedDate >=: Date.today().addMonths(-36) and Opportunity__r.CreatedDate <: Date.today().addDays(1)]){
            if(!map_accid_Opps.get(oppPartner.Partner_Account__c).containsKey(oppPartner.Opportunity__c)){
                Opportunity opp = new Opportunity();
                opp.Amount = oppPartner.Opportunity__r.Amount;
                opp.Degree_Of_Fulfillment__c = oppPartner.Opportunity__r.Degree_Of_Fulfillment__c;
                map_accid_Opps.get(oppPartner.Partner_Account__c).put(oppPartner.Opportunity__c, opp);
            }
        }
        if(!map_accid_Opps.isEmpty()){
            for(String accId : map_accid_Opps.keySet()){
                if(!map_accid_Opps.get(accId).isEmpty()){
                    decimal sumOrderValue = 0;
                    decimal sumAmount = 0;
                    decimal countOpp = 0;
                    decimal countFulFillment = 0;
                    for(Opportunity opp : map_accid_Opps.get(accId).values()){
                        sumOrderValue += (opp.Amount != null ? opp.Amount : 0) * (opp.Degree_Of_Fulfillment__c != null ? opp.Degree_Of_Fulfillment__c : 0) / 100;
                        sumAmount += opp.Amount != null ? opp.Amount : 0;
                        countOpp += 1;
                        if(opp.Degree_Of_Fulfillment__c != null  && opp.Degree_Of_Fulfillment__c > 0){
                            countFulFillment += 1;
                        }
                    }
                    Account acc = map_accid_Accs.get(accId);
                    
                    if(sumAmount != 0){
                        acc.Opportunity_Success_Rate_Amount__c = sumOrderValue / sumAmount * 100;
                    }else{
                        acc.Opportunity_Success_Rate_Amount__c = 0;
                    }
                    if(countOpp != 0){
                        acc.Opportunity_Success_Rate_Count__c = countFulFillment / countOpp * 100;
                    }else{
                        acc.Opportunity_Success_Rate_Count__c = 0;
                    }
                    
                    list_account2update.add(acc);
                }
            }
        }
        
        if(!list_account2update.isEmpty()){
        	system.debug('list_account2update:::: '+list_account2update);
            update list_account2update;
        }
    }
}