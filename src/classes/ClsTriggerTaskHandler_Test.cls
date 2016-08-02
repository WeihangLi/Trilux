/**
 *  This Class is Test Class for ClsTriggerTaskHandler.
 *
 * @author Yuda Zheng
 * @created 2015-11-25
 * @version 1.0
 * @since 35.0
 *
 * @changelog
 *  2015-11-25 Yuda Zheng <yuda.zheng@oinio.com>
 *  - Created
 * @coverage 91%
 */
 
@isTest
private class ClsTriggerTaskHandler_Test {

    static testMethod void myUnitTest() {
    
        User testUser = new User();
        testUser.FirstName ='sdf';
        testUser.LastName = 'reg';
        testUser.Username = 'imprivate@imprivate.com';
        testUser.Alias = 'mtst';
        testUser.Email = 'mtester@company.com';
        testUser.CommunityNickname = testUser.Alias;
        testUser.ProfileId = [Select Id from Profile Where Name = 'Systemadministrator' OR Name = 'System Administrator' limit 1].Id;
        testUser.TimeZoneSidKey = 'America/Chicago';
        testUser.LocaleSidKey = 'en_US';
        testUser.EmailEncodingKey = 'UTF-8';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.Sales_Group__c = '118';
        testUser.District__c = '0100DB';
        insert testUser;
        
        //create Project
        Trilux_Project__c project = new Trilux_Project__c();
        project.Project_Name__c = 'EDEKA Hansen -Köln';
        project.Project_Location_City__c = 'Kölner Straße 12';
        
        insert project;
        
        //create Account
        Account acc = ClsTestHelp.createTestAccounts();
        acc.BillingStreet = 'Hu Min Rd';
        acc.BillingCountry = 'China';
        acc.BillingCity = 'Shanghai';
        insert acc;
        
        //create Opportunity
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
        
        Opportunity opp2 = new Opportunity();
        opp2.AccountId = acc.Id;
        opp2.name = 'Test Opp2';
        opp2.StageName = 'Prospecting';
        opp2.CloseDate = Date.newInstance(2016,1,1);
        opp2.Sales_Channels__c = '02';
        opp2.SORG__c = '0002';
        opp2.Sales_Regions__c = '0200';
        insert opp2;
        
        //create Task
        Task task = new Task();
        task.OwnerId = testUser.Id;
        task.Status = 'In Progress';
        task.Subject = 'Other';
        task.Priority = 'Normal';
        task.WhatId = acc.Id;
        insert task;
        
        task = [select Id, Related_Project__c from Task where Id =: task.Id];
        system.assert(task.Related_Project__c == null);

        task.WhatId = opp.Id;
        update task;
        
        task = [select Id, Related_Project__c from Task where Id =: task.Id];
        system.assert(task.Related_Project__c == opp.Related_Project__c);
        
        task.WhatId = opp2.Id;
        update task;
        
        task = [select Id, Related_Project__c from Task where Id =: task.Id];
        system.assert(task.Related_Project__c == null);
    }
}