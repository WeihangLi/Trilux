/*  Test class for class LtngTriluxVisitReportTopicsCtrl
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
private class LtngTriluxVisitReportTopicsCtrl_Test {

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
                
        //select Id, Name, Opportunity__r.Name, Quote_Total__c from Quote__c where Quote_Account__c='accId' and Opportunity__c in SetOppId
        Campaign campaign = new Campaign();
        campaign.Name = 'YFG';
        insert campaign;
        
        //select Id, Name, Opportunity__r.Name, Quote_Total__c from Quote__c where Quote_Account__c='accId' and Opportunity__c in SetOppId
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
        
        Agenda_Topics__c top = new Agenda_Topics__c();
        top.Visit_Report__c = visit.Id;
        top.Campaign__c = campaign.Id;
        top.Opportunity__c = opp.Id;
        top.Order__c = ord.Id;
        top.Quote__c = null;
        top.Remedial__c = complaint.Id;
        list<Agenda_Topics__c> list_tops = new list<Agenda_Topics__c>();
        list_tops.add(top);
        String topStr = (String)JSON.serialize(list_tops);
        
        List<Task> tasks = new List<Task>();
        tasks.add(task);
        
        List<Agenda_Topics__c> agendaTopics = new List<Agenda_Topics__c>();
        agendaTopics.add(top);
        
        //select OpportunityId from OpportunityPartner where AccountToId='accId' and Opportunity.Follow_Opportunity__c=True and Opportunity.StageName in ('01','03','08','10','14') and Opportunity.CreatedDate >=LAST_N_DAYS:365
        //select Id, SAP_Order_No__c, EffectiveDate, Total_Amount__c from Order where AccountId='accId' and OpportunityId in SetOppId and id = null               
        Test.startTest();
        
        List<CampaignMember> List_CampaignMembers = LtngTriluxVisitReportTopicsCtrl.getAgendaCampaigns((String)acc.Id);
        //List<Quote__c> List_Quote = LtngTriluxVisitReportTopicsCtrl.getAgendaOffers((String)acc.Id);
        List<Quote__c> List_Quote = LtngTriluxVisitReportTopicsCtrl.getAgendaOffers((String)acc.Id);
        String reusult = LtngTriluxVisitReportTopicsCtrl.getAgendaOpportunities((String)acc.Id);
        List<Order> List_Order = LtngTriluxVisitReportTopicsCtrl.getAgendaOrders((String)acc.Id);
        List<Complaint__c> List_Complaint = LtngTriluxVisitReportTopicsCtrl.getAgendaRemedial((String)acc.Id);
        List<Task> List_Tasks = LtngTriluxVisitReportTopicsCtrl.getAgendaTasks((String)acc.Id);
        system.assert(List_Tasks != null); 
        List<Id> list_id = LtngTriluxVisitReportTopicsCtrl.getAgendaOpportunityId((String)acc.Id);
        system.assert(list_id != null); 
        String result1 = LtngTriluxVisitReportTopicsCtrl.saveTopics(topStr);
        system.assert(result1 != null); 
        tasks = LtngTriluxVisitReportTopicsCtrl.saveTasks(tasks);
		system.assert(tasks != null);                 
        Test.stopTest();
    }
    
}