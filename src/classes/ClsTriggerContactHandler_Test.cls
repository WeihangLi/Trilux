/**
 *  This Class is Test Class for ClsTriggerContactHandler.
 *
 * @author Yuda Zheng
 * @created 2016-05-05
 * @version 1.0
 * @since 35.0
 *
 * @changelog
 *  2016-05-05 Yuda Zheng <yuda.zheng@oinio.com>
 *  - Created
 * @coverage 80%
 */
@isTest
private class ClsTriggerContactHandler_Test {
    
    @isTest
    static void testCleanUpSPAID() {
        
        Account acc = new Account(Name = 'esrtcAcc');
        acc.RecordTypeId = [SELECT Id, Name FROM RecordType where Name='Prospect' and DeveloperName='Prospect' and SobjectType='Account'].Id;
        acc.BillingStreet = 'Hu Min Rd';
        acc.BillingCountry = 'China';
        acc.BillingCity = 'Shanghai';
        acc.Type = 'PROS';
        insert acc;
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.FirstName = 'Test';
        con.LastName = 'Address';
        con.Salutation = '0001';
        con.Language__c = 'EN';
        con.Contact_SAP_ID__c = '0001';
        insert con;
        
      	delete con;
      	
      	undelete con;
      	
      	Contact undeleteCon = [select Id, Contact_SAP_ID__c from Contact where id =: con.Id];
      	system.assert(undeleteCon.Contact_SAP_ID__c == null);
      	
    }
}