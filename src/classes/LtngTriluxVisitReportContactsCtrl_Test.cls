/*  Test class for class LtngTriluxVisitReportContactsCtrl
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
private class LtngTriluxVisitReportContactsCtrl_Test {

    static testMethod void myUnitTest() {
    	//select Id, Name, Email, Function__c from Contact where Contact.AccountId='accId'
        
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
        
        Agenda_Topics__c top = new Agenda_Topics__c();
        top.Visit_Report__c = visit.Id;
        
        List<Agenda_Topics__c> agendaTopics = new List<Agenda_Topics__c>();
        agendaTopics.add(top);
        
        
        
        Test.startTest();
        
        List<Contact> list_cons = LtngTriluxVisitReportContactsCtrl.getContacts((String)acc.Id);
        String str = LtngTriluxVisitReportContactsCtrl.saveAgendaTopics(agendaTopics);
        
		system.assert(str != null);                
        Test.stopTest();
    }
    
}