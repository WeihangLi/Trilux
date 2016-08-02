/**
 *   This test class is for BatchCls_AccountTeamVisitCalc
 *
 * @author Yuda Zheng
 * @created 2016-02-15
 * @version 1.0
 * @since 35.0
 *
 * @changelog
 *  2016-02-15 Yuda Zheng <yuda.zheng@oinio.com>
 * - Created 
 * - Coverage   75%
 */
@isTest 
private class BatchCls_AccountTeamVisitCalc_Test {

    static testMethod void myUnitTest() {
        //create Account
        Account acc = ClsTestHelp.createTestAccounts();
        acc.BillingStreet = 'Hu Min Rd';
        acc.BillingCountry = 'China';
        acc.BillingCity = 'Shanghai';
        insert acc;
        
        Account_Details__c accDet = new Account_Details__c();
        accDet.Account__c = acc.Id;
        accDet.VKOrg_Deletion_Flag__c = true;
        accDet.Sales_Organisation__c = '0001';
        insert accDet;
        
        User testUser = [Select id from User where Id = :UserInfo.getUserId()];
        
        User user01 = new User();
        user01.FirstName ='sdf1';
        user01.LastName = 'reg1';
        user01.Username = 'imprivate1@imprivate.com';
        user01.Alias = 'mtst1';
        user01.Email = 'mtester@company.com';
        user01.CommunityNickname = user01.Alias;
        user01.ProfileId = [Select Id from Profile Where Name = 'Systemadministrator' OR Name = 'System Administrator' limit 1].Id;
        user01.TimeZoneSidKey = 'America/Chicago';
        user01.LocaleSidKey = 'en_US';
        user01.EmailEncodingKey = 'UTF-8';
        user01.LanguageLocaleKey = 'en_US';
        user01.Sales_Group__c = '118';
        user01.District__c = '0100DB';
        insert user01;
        
        Visit__c visit = new Visit__c();
        visit.Account__c = acc.Id;
        visit.Visit_Status__c = 'Completed';
        visit.End_Time__c = system.today().addDays(2);
        visit.Start_Time__c = system.today().addDays(-1);
        visit.Sales_Rep__c = user01.Id;
        //visit.Assigned_to__c = testUser.Id;
        insert visit;
        
        Account_Team__c accTeam = new Account_Team__c();
        accTeam.Account__c = acc.Id;
        accTeam.Team_Member__c = user01.Id;
        accTeam.Team_Role__c = 'Main Account Manager';
        accTeam.SORG__c = '0001';
        insert accTeam;
        
        list<SObject> scope = new list<SObject>();
        scope.add(accTeam);
        
        Test.startTest();
        
        BatchCls_AccountTeamVisitCalc instance = new BatchCls_AccountTeamVisitCalc();
        
        Database.BatchableContext bc;
        instance.start(bc);
        instance.execute(bc, scope);
        instance.finish(bc);

        accTeam = [Select Id, Yearly_Completed_Visits__c from  Account_Team__c where Id =: accTeam.Id];

        System.assertEquals(1, accTeam.Yearly_Completed_Visits__c);
        Test.stopTest();
    }
}