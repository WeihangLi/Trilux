/**
 *  This Class is Test Class for ClsTriggerUserHandler.
 *
 * @author Lili Zhao
 * @created 2016-05-11
 * @version 1.0
 * @since 35.0
 *
 * @changelog
 *  2016-05-11 Lili Zhao <lili.zhao@oinio.com>
 *  - Created
 * @coverage 96%
 */
@isTest 
private class ClsTriggerUserTerritory2AssoHandler_Test {

    static testMethod void myUnitTest() {   
        
        //Select o.Territory2Id, o.SystemModstamp, o.SobjectType, o.ObjectId, o.Id, o.AssociationCause From ObjectTerritory2Association o
        Account acc1 = new Account();
        acc1.BillingCountry = 'china';
        acc1.BillingCity = 'xian';
        acc1.BillingStreet = 'test street1';
        acc1.Name = 'Host Account111';     
        acc1.IsExcludedFromRealign = false;   
        //insert acc1;
        
        Territory2Model model = new Territory2Model();
        for(Territory2Model model1 : [Select Id From Territory2Model where State = 'Active' limit 1]) {
            model = model1;         
        }
        
        if(model.Id == null) {
            model.Name = 'name';
            model.DeveloperName = 'testname';
            insert model;
        }
        
        Territory2Type type2 = new Territory2Type();
        list<Territory2> list_te = [select Id from Territory2 limit 2];
        
        for(Territory2Type teType : [Select Id From Territory2Type limit 1]) {
            type2 = teType;         
        }
        
        if(type2.Id == null) {
            type2.MasterLabel = 'testActive';
            type2.Priority = 1;
            type2.DeveloperName = 'testname';
            //insert type2;
        }

        Territory2 territory2 = new Territory2(); 
        territory2.Territory2ModelId = model.Id;
        territory2.Territory2TypeId = type2.id;
        territory2.DeveloperName = 'testname';
        territory2.name= 'nametest';
        //insert territory2;
        
        Territory2 territory = new Territory2(); 
        territory.Territory2ModelId = model.Id;
        territory.Territory2TypeId = type2.id;
        territory.DeveloperName = 'testname2';
        territory.name= 'nametest2';
        //insert territory;
       
        
        
        ObjectTerritory2Association objAss = new ObjectTerritory2Association();
        //objAss.Territory2Id = [select Id from Territory2 limit 1].Id;
        for(Territory2 terri : [select Id from Territory2 limit 1]){
            objAss.Territory2Id = terri.Id;
        }
        //objAss.SobjectType = 'Account';
        //objAss.ObjectId = [select Id from Account limit 1].Id;
        objAss.AssociationCause = 'Territory2Manual';
        //insert objAss;
        
        Account_Team__c accTeam = new Account_Team__c();
        accTeam.Account__c = acc1.Id;
        accTeam.Team_Member__c = UserInfo.getUserId();
        accTeam.Team_Role__c = 'Main Account Manager';
        accTeam.SORG__c = '0001';
        accTeam.Created_Automatically__c = true;
        //insert accTeam;
        
        Test.startTest();
        
        UserTerritory2Association us = new UserTerritory2Association();
        us.RoleInTerritory2 = 'KAM';
        us.Territory2Id = list_te.get(0).Id;
        us.UserId = UserInfo.getUserId();
        insert us;
        
        Account_Team__c accteam1  = new Account_Team__c();
        for(Account_Team__c team : [select Id from Account_Team__c where Account__c =: acc1.id limit 1]) {
            accteam1 = team;
        }
        system.assert(accteam1.Id == null);
        //us.Territory2Id = list_te.get(1).Id;
        update us;
        delete us;
        system.assert(accteam1.Id == null);
        
        Test.stopTest();
    }
    
    static testMethod void myUnitTest1() {   
        
        
        Account acc1 = new Account();
        acc1.BillingCountry = 'china';
        acc1.BillingCity = 'xian';
        acc1.BillingStreet = 'test street1';
        acc1.Name = 'Host Account111';     
        acc1.IsExcludedFromRealign = false;   
        insert acc1;
                    
        list<Territory2> list_te = [select Id from Territory2 limit 2];
        ObjectTerritory2Association objAss = new ObjectTerritory2Association();
        set<Id> set_userTerIds = new set<Id>();
        set<Id> set_Territory2Ids = new set<Id>(); 
        
        if(list_te != null && list_te.size() > 0){
            objAss.Territory2Id = list_te.get(0).Id;
            objAss.ObjectId = acc1.Id;
            objAss.AssociationCause = 'Territory2Manual';
            insert objAss;  
            set_Territory2Ids.add(objAss.Territory2Id);   
        } 

        Test.startTest();
        ClsTriggerUserTerritory2AssociatHandler.doInsert(set_userTerIds, set_Territory2Ids);
        
        Test.stopTest();
    }
    
    
}