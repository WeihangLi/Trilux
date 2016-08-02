/**
 *  This Class is Test Class for ClsTriggerUserHandler.
 *
 * @author Lili Zhao
 * @created 2015-12-23
 * @version 1.0
 * @since 35.0
 *
 * @changelog
 *  2015-12-23 Lili Zhao <lili.zhao@oinio.com>
 *  - Created
 * @coverage 96%
 */
@isTest
private class ClsTriggerUserHandler_Test {

    static testMethod void myUnitTest() {        
        
        Test.startTest();
        
        User u = ClsTestHelp.createTestUsers();
        u.FirstName ='Firsterg';
        u.LastName = 'Testerrgre';
        u.Username = '4frgg@adf.com';
        u.Country = 'Germany';  
        insert u;
         
        system.assert(u.Language_Locale_Key__c == null);
        Test.stopTest();
    }
}