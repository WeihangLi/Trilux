/*  Test class for class InputLookupController
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
private class InputLookupController_Test {

    static testMethod void myUnitTest() {
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Name = 'testacc';
        acc.BillingStreet = 'Hu Min Rd';
        acc.BillingCountry = 'China';
        acc.BillingCity = 'Shanghai';
        acc.Deletion_Flag__c = false;
        insert acc;
        
        Account acc1 = new Account();
        
        Contact con = ClsTestHelp.createTestContacts();
        con.FirstName = 'sdf';
        con.AccountId = acc.Id;
        con.salutation = 'testcon';
        insert con;
        
        
        Test.startTest();
        
        String name = InputLookupController.getCurrentValue('', '');
        system.assert(name == null);  
        String name1 = InputLookupController.getCurrentValue('Account', (String)acc.Id);
        system.assert(name1 == 'testacc');  
        String name2 = InputLookupController.getCurrentValue('Account1', (String)acc.Id);
        system.assert(name2 == null);  
        String name3 = InputLookupController.getCurrentValue('Account', (String)acc1.Id);
        String accName = InputLookupController.searchSObject('Account', 'test');
        String accName1 = InputLookupController.searchSObject('', 'test');
        String accName2 = InputLookupController.searchSObject('Account1', 'test');
        String reusult = InputLookupController.searchSObject('Account', 'test', '', true, 'Shanghai', 'false');
        String reusult1 = InputLookupController.searchSObject('Account', 'test', '', false, '', 'true');
        String reusult2 = InputLookupController.searchSObject('Contact', 'sdf', acc.Id, false, '', 'false');
        String reusult3 = InputLookupController.searchSObject('Contact1', 'sdf', acc.Id, false, '', 'false');
        system.assert(reusult3 == null);  
        String reusult4 = InputLookupController.searchSObject('Opportunity_Team_Member__c', 'sdf', '', false, '', 'false');
        String reusult5 = InputLookupController.searchSObject('', '', '', false, '', 'false');
        InputLookupController.SearchResult sr = new InputLookupController.SearchResult();
        
        InputLookupController conl = new InputLookupController();
        
               
        Test.stopTest();
    }
    
}