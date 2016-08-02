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
private class ClsProjectOppyController_Test {

    static testMethod void myUnitTest() {   
    	
    	Account acc = ClsTestHelp.createTestAccounts();
        acc.BillingStreet = 'Hu Min Rd';
        acc.BillingCountry = 'China';
        acc.BillingCity = 'Shanghai';
        insert acc;
        
        Account acc2 = new Account();
        acc2.Name = 'Partern Account1';
        acc2.BillingCountry = 'Germany';
        acc2.BillingCity = 'Berlin';
        acc2.BillingStreet = 'test street2';
        insert acc2;
        
        
        Contact con = ClsTestHelp.createTestContacts();
        con.FirstName = 'sdf';
        con.AccountId = acc.Id;
        con.salutation = 'testcon';
        insert con;
        
        Trilux_Project__c project = new Trilux_Project__c();
        project.Project_Name__c = 'EDEKA Hansen -Köln';
        project.Project_Location_City__c = 'Kölner Straße 12';
        project.Project_Location_Postal_Code__c = '201100';
        project.Project_Location_Country__c = 'Shanghai';
        //insert project;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.name = 'Test Opp';
        opp.StageName = '01';
        opp.CloseDate = Date.newInstance(2016,1,1);
        //opp.Related_Project__c = project.Id;
        opp.Sales_Channels__c = '01';
        opp.SORG__c = '0001';
        opp.Statistic_Flag__c = 'BRU';
        opp.Vertical_Market__c = '01';
        opp.Application_Area__c = '01';
        opp.Sales_Regions__c = '0100';
        opp.Follow_Opportunity__c = true;
        //insert opp;
        
        Opportunity_Partner__c oppPartnerc = new Opportunity_Partner__c();
        oppPartnerc.Opportunity__c = opp.Id;
        oppPartnerc.Partner_Account__c = acc2.Id;
        oppPartnerc.Partner_Role__c = 'Koordinator';
        oppPartnerc.Primary__c = true;
        //insert oppPartnerc;
        
        Lightning_Project_Setting__c setting = new Lightning_Project_Setting__c();
        setting.Name = 'Single Account Id';
        setting.Value__c = acc2.Id;
        insert setting;
        
        
        Test.startTest();
        
        ClsProjectOppyController.createProjectOppy(project, opp, true);
        ClsProjectOppyController.initProjectOppy();
        ClsProjectOppyController.initOppyAccount();
        ClsProjectOppyController.getUserName();
        ClsProjectOppyController.getContacts();
        System.assertEquals(true, opp.Id != null);
        System.assertEquals(true, project.Id != null);
        Test.stopTest();
    }
}