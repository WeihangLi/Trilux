/**
 *   This test class is for Batchcls_CalOppSuccessRate
 *
 * @author weihang li
 * @created 2016-03-08
 * @version 1.0
 * @since 36.0
 *
 * @changelog
 *  2016-03-08 weihang li <weihang.li@oinio.com>
 * - Created 
 * - Coverage    
 */
 
 
@isTest 
private class Batchcls_CalOppSuccessRate_Test {
    static testMethod void myUnitTest() {
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.BillingStreet = 'Hu Min Rd';
        acc.BillingCountry = 'China';
        acc.BillingCity = 'Shanghai';
        acc.type = 'PROS';
        acc.Deletion_Flag__c = false;
        insert acc;
        
        Account acc2 = new Account();
        acc2.Name = 'Partern Account1';
        acc2.BillingCountry = 'Germany';
        acc2.BillingCity = 'Berlin';
        acc2.BillingStreet = 'test street2';
        acc2.External_ID_SAP__c = 'test';
        acc2.type = 'PROS';
        acc2.Deletion_Flag__c = false;
        insert acc2;
        
        
        Trilux_Project__c project = new Trilux_Project__c();
        project.Project_Name__c = 'EDEKA Hansen -Köln';
        project.Project_Location_City__c = 'Kölner Straße 12';
        project.Project_Location_Postal_Code__c = '201100';
        project.Project_Location_Country__c = 'Shanghai';
        project.Project_Location_Street__c = 'Shanghai';
        insert project;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.name = 'Test Opp';
        opp.StageName = '01';
        opp.CloseDate = Date.today().addMonths(-12);
        opp.Related_Project__c = project.Id;
        opp.Sales_Channels__c = '01';
        opp.SORG__c = '0001';
        opp.Statistic_Flag__c = 'BRU';
        opp.Vertical_Market__c = '01';
        opp.Application_Area__c = '01';
        opp.Sales_Regions__c = '0100';
        opp.Follow_Opportunity__c = true;
        //opp.Creation_Date__c = system.today();
        insert opp;
        
        Opportunity opp1 = new Opportunity();
        opp1.AccountId = acc2.Id;
        opp1.name = 'Test Opp';
        opp1.StageName = '01';
        opp1.CloseDate = Date.today().addMonths(-12);
        opp1.Related_Project__c = project.Id;
        opp1.Sales_Channels__c = '01';
        opp1.SORG__c = '0001';
        opp1.Statistic_Flag__c = 'BRU';
        opp1.Vertical_Market__c = '01';
        opp1.Application_Area__c = '01';
        opp1.Sales_Regions__c = '0100';
        opp1.Follow_Opportunity__c = true;
        //opp.Creation_Date__c = system.today();
        insert opp1;
        
        Opportunity_Partner__c oppPartnerc = new Opportunity_Partner__c();
        oppPartnerc.Opportunity__c = opp.Id;
        oppPartnerc.Partner_Account__c = acc2.Id;
        oppPartnerc.Partner_Role__c = 'Koordinator';
        oppPartnerc.Primary__c = true;
        insert oppPartnerc;
        
        Opportunity_Partner__c oppPartnerc1 = new Opportunity_Partner__c();
        oppPartnerc1.Opportunity__c = opp1.Id;
        oppPartnerc1.Partner_Account__c = acc.Id;
        oppPartnerc1.Partner_Role__c = 'Koordinator';
        oppPartnerc1.Primary__c = true;
        insert oppPartnerc1;
        
        list<SObject> scope = new list<SObject>();
        scope.add(acc);
        scope.add(acc2);
        
        Test.startTest();
        Batchcls_CalOppSuccessRate instance = new Batchcls_CalOppSuccessRate();
        
        Database.BatchableContext bc;
        instance.start(bc);
        instance.execute(bc, scope);
        instance.finish(bc);
        
        
        System.assertEquals(0, acc.Opportunity_Success_Rate_Count__c);
        
        Test.stopTest();
    }
}