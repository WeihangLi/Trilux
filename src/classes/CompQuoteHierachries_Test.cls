/**
 *  test class for CompQuoteHierachries
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
 * - Coverage 89%
 */
 @isTest
private class CompQuoteHierachries_Test {
    static testMethod void myUnitTest() {
        Trilux_Project__c project = new Trilux_Project__c();
        project.Project_Name__c = 'EDEKA Hansen -Köln';
        project.Project_Location_City__c = 'Kölner Straße 12';
        project.Project_Location_Postal_Code__c = '99999';
        project.Sales_Region__c = '0100';
        project.Project_Location_Country__c = 'NL';
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
        
        Quote__c qu = new Quote__c();
        qu.Opportunity__c = opp.Id;
        qu.Sales_Doc_Type__c = 'AF';
        qu.Quote_Total__c = 100;
        insert qu;
        
        Quote__c qu1 = new Quote__c();
        qu1.Opportunity__c = opp.Id;
        qu1.Sales_Doc_Type__c = 'AG';
        qu.Quote_Total__c = 50;
        insert qu1;
        
        Order ord = new Order();
        ord.OpportunityId = opp.Id;
        ord.Type = 'KA';
        ord.Total_Amount__c = 100;
        ord.AccountId = acc.Id;
        ord.EffectiveDate = date.today();
        ord.Status = 'A';
        insert ord;
        
        Order ord1 = new Order();
        ord1.OpportunityId = opp.Id;
        ord.Total_Amount__c = 10;
        ord1.Type = 'KB';
        ord1.AccountId = acc.Id;
        ord1.EffectiveDate = date.today();
        ord1.Status = 'B';
        insert ord1;
        
        test.startTest();
        CompQuoteHierachries com = new CompQuoteHierachries();
        com.OpportunityIds = opp.Id;
        com.initFirstHierachy();
        com.cType = 'Opportunity';
        CompQuoteHierachries.getChildRd(opp.Id);
        
        com.cType = 'project';
        CompQuoteHierachries.getChildRd(opp.Id);
        
        
        system.assert(CompQuoteHierachries.getChildRd(opp.Id) != null);
        test.stopTest();
    }
}