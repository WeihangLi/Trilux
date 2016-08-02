/*  Test class for class ExtLtngOpportunityPartner
 *
 @author Lili Zhao
 @created 2016-04-13
 @version 1.0
 @since 35.0
 *
 @return
 *
 @changelog
 * 2016-04-13 Lili Zhao <lili.zhao@itbconsult.com>
 * - Created
 *- Test coverage 100%
 */
@isTest 
private class ExtLtngOpportunityPartner_Test {

    static testMethod void myUnitTest() {
        //select Id, Name, Email, Function__c from Contact where Contact.AccountId='accId'
        
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
        acc2.type = 'PROS';
        acc2.Deletion_Flag__c = false;
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
        insert project;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.name = 'Test Opp';
        opp.StageName = '01';
        opp.CloseDate = Date.newInstance(2016,1,1);
        opp.Related_Project__c = project.Id;
        opp.Sales_Channels__c = '01';
        opp.SORG__c = '0001';
        opp.Statistic_Flag__c = 'BRU';
        opp.Vertical_Market__c = '01';
        opp.Application_Area__c = '01';
        opp.Sales_Regions__c = '0100';
        opp.Follow_Opportunity__c = true;
        insert opp;
        
        Opportunity_Partner__c oppPartnerc = new Opportunity_Partner__c();
        oppPartnerc.Opportunity__c = opp.Id;
        oppPartnerc.Partner_Account__c = acc2.Id;
        oppPartnerc.Partner_Role__c = 'Koordinator';
        oppPartnerc.Primary__c = true;
        insert oppPartnerc;
        
        
        Test.startTest();
        
        ApexPages.StandardController stdCtrl = new ApexPages.Standardcontroller(oppPartnerc);
        ApexPages.currentPage().getParameters().put('test_lkid', opp.Id);
        ExtLtngOpportunityPartner ext = new ExtLtngOpportunityPartner(stdCtrl);        
        system.assert(ext.oppy.Id == opp.Id);       
        Test.stopTest();
    }
    
}