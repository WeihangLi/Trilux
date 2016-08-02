/**
 *  This Batch Job is used to calculate the number of completed visits per account  
 *  and per year for every user of the sales team (R-234)
 *
 @author  Yuda Zheng
 @created 2016-02-15    
 @version 1.0
 @since   35.0 (Force.com ApiVersion)
 *
 @changelog
 * 2016-02-15  Yuda Zheng <yuda.zheng@oinio.com>
 * - Created    
 */

global class BatchCls_AccountTeamVisitCalc extends SchedulerVizArt.ClsBatchVirtual{
    global override Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Team_Member__c, Account__c FROM Account_Team__c';
        return Database.getQueryLocator(query);
    }
    
    global override void execute(Database.BatchableContext BC, list<SObject> list_accTeam){
        map<String, map<String, integer>> map_acc_user_count = new map<String, map<String, integer>>();
        map<String, map<String, date>> map_acc_user_lastVisitDate = new map<String, map<String, date>>();
        list<Account_Team__c> list_accTeam2Update = new list<Account_Team__c>();
        set<Id> set_AccId = new set<Id>();
        set<Id> set_UserId = new set<Id>();
        
        for(SObject sobj: list_accTeam) {
            Account_Team__c accTeam = (Account_Team__c)sobj;
            if(accTeam.Team_Member__c != null){
                set_UserId.add(accTeam.Team_Member__c);
            }
            if(accTeam.Account__c != null){
                set_AccId.add(accTeam.Account__c);
            }
        }

        for (AggregateResult visitCount : [SELECT count(Id) VisitNum, Account__c, Sales_Rep__c from Visit__c WHERE CALENDAR_YEAR(Start_Time__c) =: Date.today().year() and
             Account__c in: set_AccId and Visit_Status__c = 'Completed' and Sales_Rep__c != null group by Account__c, Sales_Rep__c]) {
            if(!map_acc_user_count.containsKey((String)visitCount.get('Account__c'))){
                map_acc_user_count.put((String)visitCount.get('Account__c'), new map<String, integer>());
            }
            map_acc_user_count.get((String)visitCount.get('Account__c')).put((String)visitCount.get('Sales_Rep__c'), integer.valueOf(visitCount.get('VisitNum')));
        }
        
        for(AggregateResult lastVisit : [SELECT max(End_Time__c) lastVisitDate, Account__c, Sales_Rep__c from Visit__c
            WHERE Account__c in: set_AccId and Visit_Status__c = 'Completed' and Sales_Rep__c != null group by Account__c, Sales_Rep__c]){
            if(!map_acc_user_lastVisitDate.containsKey((String)lastVisit.get('Account__c'))){
                map_acc_user_lastVisitDate.put((String)lastVisit.get('Account__c'), new map<String, date>());
            }
            map_acc_user_lastVisitDate.get((String)lastVisit.get('Account__c')).put((String)lastVisit.get('Sales_Rep__c'), date.valueOf(lastVisit.get('lastVisitDate')));
        }
        

        for(SObject sobj: list_accTeam) {
            Account_Team__c accTeam = (Account_Team__c)sobj;
            Boolean isChanged = false;
            if(map_acc_user_count.get(accTeam.Account__c) != null 
                && map_acc_user_count.get(accTeam.Account__c).get(accTeam.Team_Member__c) != null){
                accTeam.Yearly_Completed_Visits__c = map_acc_user_count.get(accTeam.Account__c).get(accTeam.Team_Member__c);
                isChanged = true;
            }else{
                accTeam.Yearly_Completed_Visits__c = 0;
                isChanged = true;
            }
            if(map_acc_user_lastVisitDate.get(accTeam.Account__c) != null 
                && map_acc_user_lastVisitDate.get(accTeam.Account__c).get(accTeam.Team_Member__c) != null){
                accTeam.Last_Visit_Date__c = map_acc_user_lastVisitDate.get(accTeam.Account__c).get(accTeam.Team_Member__c);
                isChanged = true;
            }
            if(isChanged){
                list_accTeam2Update.add(accTeam);
            }
        }
        if(!list_accTeam2Update.isEmpty()){
        	system.debug('list_accTeam2Update::: '+list_accTeam2Update);
            update list_accTeam2Update;
        }
    }
}