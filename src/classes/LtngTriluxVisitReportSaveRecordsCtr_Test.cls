/*  Test class for class LtngTriluxVisitReportSaveRecordsCtrl
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
private class LtngTriluxVisitReportSaveRecordsCtr_Test {

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
        
        
        Test.startTest();
        
        visit = LtngTriluxVisitReportSaveRecordsCtrl.saveVisit(visit);
        system.assert(visit.Id != null);  
               
        Test.stopTest();
    }
    
}