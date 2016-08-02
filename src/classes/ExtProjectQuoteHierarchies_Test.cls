/**
 *  test class for ExtProjectQuoteHierarchies
 *
 *
 @author  weihang li
 @created 2016-03-21
 @version 1.0
 @since   36.0 (Force.com ApiVersion)
 *
 @changelog
 * 2016-03-21 weihang li <weihang.li@oinio.com>
 * - Created    
 * - Coverage 100%
 */
 @isTest
private class ExtProjectQuoteHierarchies_Test {
    static testMethod void myUnitTest() {
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
        opp.Sales_Channels__c = '01';
        opp.SORG__c = '0001';
        opp.Sales_Regions__c = '0100';
        insert opp;
        
        test.startTest();
        ApexPages.currentPage().getParameters().put('id', project.Id);
        ApexPages.StandardController stdCtrl = new ApexPages.Standardcontroller(project);
        ExtProjectQuoteHierarchies ext = new ExtProjectQuoteHierarchies(stdCtrl);
        system.assert(ext.projectId == project.Id);    
        test.stopTest();
    }
}