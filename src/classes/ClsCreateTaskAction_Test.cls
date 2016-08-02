/**
 *  This class is tesclass for Class "ClsCreateTaskAction".
 *
 @author    weihang li
 @created   2016-04-05
 @version   1.0
 @since     36.0 (Force.com ApiVersion)
 *
 @changelog
 * 2016-04-05 weihang li <weihang.li@oinio.com>
 * - Created
 * 
 * - Modified coverage 100%
 */
@isTest
private class ClsCreateTaskAction_Test {
    static testMethod void testMostMethods() {
        Trilux_Project__c project = new Trilux_Project__c();
        project.Project_Name__c = 'EDEKA Hansen -Köln';
        project.Project_Location_City__c = 'Kölner Straße 12';
        insert project;
        
        Account acc = new Account();
        acc.Name = 'Test Team';
        acc.Type = 'CUST';
        acc.Street__c = 'test street';
        acc.BillingCountry = 'china';
        acc.BillingCity = 'xian';
        acc.BillingStreet = 'test street';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.name = 'Test Opp';
        opp.StageName = 'Prospecting';
        opp.CloseDate = Date.newInstance(2016,1,1);
        opp.Related_Project__c = project.Id;
        opp.Project_Manager__c = UserInfo.getUserId();
        opp.Sales_Regions__c = '0100';
        insert opp;
        
        Order ord = new Order();
        ord.OpportunityId = opp.Id;
        ord.Type = 'KA';
        ord.Total_Amount__c = 100;
        ord.AccountId = acc.Id;
        ord.EffectiveDate = date.today();
        ord.Status = 'A';
        insert ord;
        
        list<Id> list_ids = new list<Id>();
        list_ids.add(ord.Id);
        
        test.startTest();
        ClsCreateTaskAction.insertTask(list_ids);
        
        Task ta = [Select Id from Task where OwnerId =: UserInfo.getUserId() limit 1];
        System.assertEquals(true, ta.Id != null);
        test.stopTest();
    }
}