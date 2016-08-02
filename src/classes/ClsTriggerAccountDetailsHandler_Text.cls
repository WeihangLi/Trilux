/**
 *  This Class is Test Class for ClsTriggerAccountDetailsHandler.
 *
 * @author weihang li
 * @created 2016-02-01
 * @version 1.0
 * @since 29.0
 *
 * @changelog
 *  2016-02-01 weihang li <weihang.li@oinio.com>
 *  - Created
 * @coverage 99%
 */
@isTest
private class ClsTriggerAccountDetailsHandler_Text {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Account acc1 = ClsTestHelp.createTestAccounts();
        acc1.BillingStreet = 'Hu Min Rd';
        acc1.BillingCountry = 'China';
        acc1.BillingCity = 'Shanghai';
        insert acc1;
        
        Account_Details__c accDet = new Account_Details__c();
        accDet.Account__c = acc1.Id;
        accDet.VKOrg_Deletion_Flag__c = true;
        insert accDet;
        
        accDet.VKOrg_Deletion_Flag__c = false;
        update accDet;
        
        System.assertEquals(false, acc1.Deletion_Flag__c);
        
    }
}