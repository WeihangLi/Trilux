/*  Test class for class LtngTriluxVisitAppCtrl
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
@isTest (seealldata=true) 
private class LtngTriluxVisitAppCtrl_Test {

    static testMethod void myUnitTest() {
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.BillingStreet = 'Hu Min Rd';
        acc.BillingCountry = 'China';
        acc.BillingCity = 'Shanghai';
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.FirstName = 'sdf';
        con.AccountId = acc.Id;
        con.salutation = 'testcon';
        insert con;
        
        Visit__c visit = new Visit__c();
        visit.Account__c = acc.Id;
        visit.Contact__c = con.Id;
        visit.Visit_Status__c = 'Planned';
        visit.End_Time__c = system.today().addDays(2);
        visit.Start_Time__c = system.today().addDays(-10);
        visit.Sales_Rep__c = UserInfo.getUserId();
        insert visit;
        
        Task task = new Task();
        task.OwnerId = UserInfo.getUserId();
        task.Subject = 'test class list ' + system.today().addDays(-2);
        task.ActivityDate = system.today();
        task.Priority = 'High';
        task.Remind_Day__c = system.today().addDays(-2);
        task.status = 'In Progress';
        task.WhatId = acc.Id;
        insert task;
        
        Task task1 = new Task();
        task1.OwnerId = UserInfo.getUserId();
        task1.Subject = 'test class list ' + system.today().addDays(-2);
        task1.ActivityDate = system.today().addDays(-2);
        task1.Priority = 'High';
        task1.Remind_Day__c = system.today().addDays(-2);
        task1.status = 'In Progress';
        task1.WhatId = acc.Id;
        insert task1;       
        
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
        
        OpportunityPartner oppyPart = new OpportunityPartner();
        //oppyPart.AccountToId = acc.Id;
        //oppyPart.OpportunityId = opp.Id;
        //insert oppyPart;
        
        Case c = new Case();
        c.Status = 'New';
        c.Origin = 'Phone';
        c.Related_Opportunity__c = opp.Id;       
        //insert c;
        
        Quote__c qu = new Quote__c();
        qu.Opportunity__c = opp.Id;
        qu.Sales_Doc_Type__c = 'AF';
        qu.Quote_Total__c = 100;
        qu.Quote_Account__c = acc.id;
        insert qu;
        
        Order ord = new Order();
        ord.OpportunityId = opp.Id;
        ord.Type = 'KA';
        ord.Total_Amount__c = 100;
        ord.AccountId = acc.Id;
        ord.EffectiveDate = date.today();
        ord.Status = 'A';
        insert ord;
        
        Campaign campaign = new Campaign();
        campaign.Name = 'YFG';
        insert campaign;
        
        CampaignMember  cm = new CampaignMember ();
        cm.CampaignId = campaign.Id;
        cm.ContactId = con.Id;
        insert cm;
        
        Complaint__c complaint = new Complaint__c();
        complaint.Account_Number__c = acc.Id;
        complaint.Notification_Date__c = system.today().addDays(-3);
        complaint.Name = 'test complaint';
        insert complaint;
        
        Event event = new Event(Subject='Other',Location='aa',StartDateTime=date.today(),EndDateTime=date.today().addDays(2),Description='cc',WhatId=acc.Id);
        event.ActivityDate = system.today().addDays(-3);
        insert event;
        
        Test.startTest();
        
        List<String> List_String = LtngTriluxVisitAppCtrl.getHomeViewEvents();
        system.assert(List_String != null);  
        List<Task> List_allTask = LtngTriluxVisitAppCtrl.getHomeViewTasks();
        String reusult = LtngTriluxVisitAppCtrl.getAgendaOpportunities((String)acc.Id);
        List<Task> List_Tasks = LtngTriluxVisitAppCtrl.getAgendaTasks((String)acc.Id);
        List<Quote__c> List_Quote = LtngTriluxVisitAppCtrl.getAgendaQuotes((String)acc.Id);
        List<Order> List_Order = LtngTriluxVisitAppCtrl.getAgendaOrders((String)acc.Id);
        List<Id> list_id = LtngTriluxVisitAppCtrl.getAgendaOpportunityId((String)acc.Id);
        List<CampaignMember> list_CampaignMember = LtngTriluxVisitAppCtrl.getAgendaCampaigns((String)acc.Id);
        List<Task> list_task = LtngTriluxVisitAppCtrl.getPastActivitiesTask((String)acc.Id);
        List<Complaint__c> List_Complaint = LtngTriluxVisitAppCtrl.getAgendaRemedials((String)acc.Id);
        task = LtngTriluxVisitAppCtrl.updateTask(task);
        system.assert(task.Id != null); 
        List<Event> list_Event = LtngTriluxVisitAppCtrl.getPastActivitiesEvent((String)acc.Id);
        system.assert(list_Event != null);  
        List<ListView> list_ListView = LtngTriluxVisitAppCtrl.getListViews();
        system.assert(list_ListView != null);  
               
        Test.stopTest();
    }
    
}