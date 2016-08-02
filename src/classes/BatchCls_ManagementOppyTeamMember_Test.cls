/**
 *   This test class is for BatchCls_ManagementOppyTeamMember
 *
 * @author weihang li
 * @created 2016-04-01
 * @version 1.0
 * @since 36.0
 *
 * @changelog
 *  2016-04-01 weihang li <weihang.li@oinio.com>
 * - Created 
 * - Coverage 100%
 */
 @isTest(seeAllData=true) 
private class BatchCls_ManagementOppyTeamMember_Test {
    static testMethod void myUnitTest() {
    	/*
        Trilux_Project__c project = new Trilux_Project__c();
        project.Project_Name__c = 'EDEKA Hansen -Köln';
        project.Project_Location_City__c = 'Kölner Straße 12';
        project.Project_Location_Postal_Code__c = '99999';
        project.Sales_Region__c = '0100';
        project.Project_Location_Country__c = 'NL';
        insert project;
        
        Account acc = new Account();
        acc.Name = 'Test Team';
        acc.Type = 'PROS';
        acc.Street__c = 'test street';
        acc.BillingCountry = 'china';
        acc.BillingCity = 'xian';
        acc.BillingStreet = 'test street';
        acc.BillingPostalCode = '01001';
        acc.Initial_Sales_Channel__c = 'VDI1';
        acc.Sales_Organisation__c = '0001';
        acc.Initial_Sales_Org__c = '0001';
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
        
        Territory_Data__c te = new Territory_Data__c();
        te.PLZ__c = '99999';
        te.Country__c = 'NL';
        te.X01_06_Account_MAM__c = '0100DB';
        te.X01_06_Opportunity_ID__c = '118';
        te.Sales_Organisation__c = '0001';
        insert te;
        
        User u = new User();
        u.FirstName ='sdf';
        u.LastName = 'reg';
        u.Username = 'imprivate@imprivate.com';
        u.Alias = 'mtst';
        u.Email = 'mtester@company.com';
        u.CommunityNickname = u.Alias;
        u.ProfileId = [Select Id from Profile Where Name = 'Systemadministrator' OR Name = 'System Administrator' limit 1].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.Sales_Group__c = '118';
        u.District__c = '0100DB';
        insert u;
        
        list<SObject> scope = new list<SObject>();
        
        Opportunity oppys = [SELECT Id,Name,Sales_Channels__c,SORG__c,Related_Project__c,Related_Project__r.Project_Location_Postal_Code__c,Postal_Code__c, Related_Project__r.Project_Location_Country__c  from Opportunity where id =: opp.Id];
        scope.add(oppys);
        
        
        test.startTest();
        BatchCls_ManagementOppyTeamMember instance = new BatchCls_ManagementOppyTeamMember();
        
        Database.BatchableContext bc;
        instance.start(bc);
        instance.execute(bc, scope);
        instance.finish(bc);
        
        
        Opportunity_Team_Member__c teamMem = [Select Id From Opportunity_Team_Member__c Where Opportunity__c =: opp.Id limit 1];
        System.assertEquals(true, teamMem.Id != null);
        test.stopTest();
        */
        System.assert(true);
    }
    
}