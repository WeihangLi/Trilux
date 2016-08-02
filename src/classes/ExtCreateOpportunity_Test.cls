/**
 * Test class for ExtAddAccountCampaignMember
 */
@isTest
private class ExtCreateOpportunity_Test {
    static testMethod void myUnitTest() {
        Account acc1 = new Account();
        acc1.Name = 'test1';
        acc1.BillingCountry = 'china';
        acc1.BillingCity = 'shanghai';
        acc1.BillingStreet = 'humin road';
        acc1.BillingPostalCode = '235000';
        insert acc1;
        
        Trilux_Project__c project1 = new Trilux_Project__c();
        project1.Project_Name__c = 'EDEKAqasHansen -Köln';
        project1.Project_Location_City__c = 'Kölner Straße 12';
        project1.Project_Location_Postal_Code__c = '201100';
        project1.Project_Location_Country__c = 'Shanghai';
        insert project1;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc1.Id;
        opp.name = 'Test Opp2';
        opp.Related_Project__c = project1.Id;
        opp.StageName = 'Prospecting';
        opp.CloseDate = Date.newInstance(2016,1,1);
        opp.Sales_Channels__c = '01';
        opp.SORG__c = '0001';
        opp.Statistic_Flag__c = 'BRU';
        opp.Vertical_Market__c = '01';
        opp.Application_Area__c = '01';
        opp.Sales_Regions__c = '0100';
        opp.Follow_Opportunity__c = true;
        
        insert opp;
        
        Dummy_Account_for_Opportunities__c daf = new Dummy_Account_for_Opportunities__c();
        daf.Name = 'Dummy Account';
        daf.Dummy_Account_ID__c = acc1.Id;
        insert daf;
        
        Trilux_Project__c project = new Trilux_Project__c();
        project.Project_Name__c = 'EDEKA Hansen -Köln';
        project.Project_Location_City__c = 'Kölner Straße 12';
        insert project;
        
        ApexPages.currentPage().getParameters().put('proId',project.Id);
        ApexPages.currentPage().getParameters().put('proName',project.Project_Name__c);
        ApexPages.currentPage().getParameters().put('retURL','%2F006%2Fo');
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(opp);
        ExtCreateOpportunity ext = new ExtCreateOpportunity(stdCtrl);
        ext.opp.Name = 'test';
        ext.opp.StageName = 'TX order';
        ext.opp.CloseDate = date.today();
        ext.opp.Sales_Regions__c = '0100';
        ext.saveOpp();
        system.assert(ext.opp.Id != null);
        ext.cancel();
    }
    static testMethod void myUnitTest1() {
        Account acc1 = new Account();
        acc1.Name = 'test1';
        acc1.BillingCountry = 'china';
        acc1.BillingCity = 'shanghai';
        acc1.BillingStreet = 'humin road';
        acc1.BillingPostalCode = '235000';
        insert acc1;
        
        Trilux_Project__c project1 = new Trilux_Project__c();
        project1.Project_Name__c = 'EDEKAszxcvhxansenihfKöln';
        project1.Project_Location_City__c = 'Kölner Straße 12';
        project1.Project_Location_Postal_Code__c = '201100';
        project1.Project_Location_Country__c = 'Shanghai';
        insert project1;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc1.Id;
        opp.Related_Project__c = project1.Id;
        opp.name = 'Test Opp';
        opp.StageName = '01';
        opp.CloseDate = Date.newInstance(2016,1,1);
        opp.Sales_Channels__c = '01';
        opp.SORG__c = '0001';
        opp.Statistic_Flag__c = 'BRU';
        opp.Vertical_Market__c = '01';
        opp.Application_Area__c = '01';
        opp.Sales_Regions__c = '0100';
        opp.Follow_Opportunity__c = true;
        insert opp;
        
        Dummy_Account_for_Opportunities__c daf = new Dummy_Account_for_Opportunities__c();
        daf.Name = 'Dummy Account';
        daf.Dummy_Account_ID__c = acc1.Id;
        insert daf;
        
        Trilux_Project__c project = new Trilux_Project__c();
        project.Project_Name__c = 'EDEKA HansenwastihfKöln';
        project.Project_Location_City__c = 'Kölner Straße 12';
        insert project;
        
        ApexPages.currentPage().getParameters().put('proId',project.Id);
        ApexPages.currentPage().getParameters().put('proName',project.Project_Name__c);
        ApexPages.currentPage().getParameters().put('accid',acc1.Id);
        ApexPages.currentPage().getParameters().put('vkorg','test');
        ApexPages.currentPage().getParameters().put('opp3',project.Project_Name__c);
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(opp);
        ExtCreateOpportunity ext = new ExtCreateOpportunity(stdCtrl);
        ext.opp.Name = 'test';
        ext.opp.StageName = 'TX order';
        ext.opp.CloseDate = date.today();
        ext.opp.Sales_Regions__c = '0100';
        ext.saveNew();
        system.assert(ext.opp.Id != null);
    }
}