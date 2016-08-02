/**
 *  This Class is Test Class for ClsTriggerOpportunityHandler.
 *
 * @author Yuda Zheng
 * @created 2015-11-26
 * @version 1.0
 * @since 35.0
 *
 * @changelog
 *  2015-11-26 Yuda Zheng <yuda.zheng@oinio.com>
 *  - Created
 * @coverage 100%
 */
@isTest
private class ClsTriggerOpportunityHandler_Test {

    static testMethod void myUnitTest() {
    
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
        u.Sales_Group__c = '147';
        u.District__c = '0100AC';
        insert u;
        
        Territory_Data__c teData = new Territory_Data__c();
        teData.PLZ__c = '201100';
        teData.Sales_Region__c = 'testRegion';
        teData.Sales_Organisation__c = '0001';
        teData.Country__c = 'Shanghai';
        teData.X01_06_Account_MAM__c = '0100AC';
        teData.X01_06_Opportunity_ID__c = '147';
        insert teData;
        
        //create Project
        Trilux_Project__c project = new Trilux_Project__c();
        project.Project_Name__c = 'EDEKA Hansen -Köln';
        project.Project_Location_City__c = 'Kölner Straße 12';
        project.Project_Location_Postal_Code__c = '201100';
        project.Project_Location_Country__c = 'Shanghai';
        insert project;
        
        Trilux_Project__c project2 = new Trilux_Project__c();
        project2.Project_Name__c = 'EDEKA Hansen';
        project2.Project_Location_City__c = 'test city';
        project2.Project_Location_Street__c = 'test Street';
        project2.Project_Location_Postal_Code__c = '201111';
        project2.Project_Location_Country__c ='AD';
        insert project2;
        
        //project2.Project_Location_Postal_Code__c = '201100';
        
        //create Account  
        Account acc = ClsTestHelp.createTestAccounts();
        acc.BillingCountry = 'Cuba';
        acc.BillingCity = 'shanghai';
        acc.BillingStreet = 'shanghaiRode';
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
        opp.Statistic_Flag__c = 'BRU';
        opp.Vertical_Market__c = '01';
        opp.Application_Area__c = '01';
        //opp.Postal_Code__c = '201100';
        insert opp;

        //create Task
        Task task = new Task();
        task.OwnerId = userInfo.getUserId();
        task.Status = 'In Progress';
        task.Subject = 'Other';
        task.Priority = 'Normal';
        task.WhatId = opp.Id;
        insert task;
        
        //create Event
        Event event = new Event();
        event.OwnerId = userInfo.getUserId();
        event.StartDateTime = Datetime.now();
        event.EndDateTime = Datetime.now();
        event.WhatId = opp.Id;
        insert event;
        
        task = [select Id, Related_Project__c from Task where Id =: task.Id];
        system.assert(task.Related_Project__c == project.Id);
        
        event = [select Id, Related_Project__c from Event where Id =: event.Id];
        //system.assert(event.Related_Project__c == project.Id);
        
        opp.Related_Project__c = project2.Id;
        update opp;
        
        task = [select Id, Related_Project__c from Task where Id =: task.Id];
        system.assert(task.Related_Project__c == project2.Id);
        
        event = [select Id, Related_Project__c from Event where Id =: event.Id];

        delete project;
    }
}