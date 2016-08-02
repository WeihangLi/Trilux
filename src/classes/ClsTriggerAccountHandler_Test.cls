/**
 *  This Class is Test Class for ClsTriggerAccountHandler.
 *
 * @author Shengpeng Xiao
 * @created 2014-11-19
 * @version 1.0
 * @since 31.0
 *
 * @changelog
 *  2014-11-19 Shengpeng Xiao <shengpeng.xiao@itbconsult.com>
 *  - Created
 * @coverage 80%
 */
@isTest
private class ClsTriggerAccountHandler_Test {
    
    @isTest
    static void testSetAccount4Street() {
        
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
        insert con;
        
        acc.BillingStreet = 'test1\r\ntest2\r\ntest3\r\ntest4 ';
        update acc;
        acc.BillingStreet = 'test1\r\ntest2';
        update acc;
        
        User u = [select Id from User where Profile.Name = 'Middleware Integration'];
        system.runAs(u){
            acc.Type = 'BACU';
            acc.BillingStreet = 'test1\r\ntest2\r\ntest3\r\ntest4 ';
            update acc;
            acc.Street3__c = 'ttttttt';
            update acc;
            System.assertEquals(null, acc.Territory_Data__c);
        }
    }
}