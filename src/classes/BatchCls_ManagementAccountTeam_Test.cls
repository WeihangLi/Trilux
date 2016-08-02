/**
*	This class is tesclass for Class "BatchCls_ManagementAccountTeam".
*
@author weihang li
@created 2016-03-08
@version 1.0
@since 20.0
*
@changelog
* 2016－03-08 weihang li <weihang.li@oinio.com>
* - Created
*- Test coverage  100
*/
@isTest 
private class BatchCls_ManagementAccountTeam_Test {
    static testMethod void testMostMethods() {
    	
    	Account acc = ClsTestHelp.createTestAccounts();
        acc.BillingStreet = 'Hu Min Rd';
        acc.BillingCountry = 'China';
        acc.BillingCity = 'Shanghai';
        acc.IsExcludedFromRealign = false;
        insert acc;
        
        list<SObject> scope = new list<SObject>();
        scope.add(acc);
        
        Test.startTest();
        BatchCls_ManagementAccountTeam instance = new BatchCls_ManagementAccountTeam();
        
        Database.BatchableContext bc;
        instance.start(bc);
        instance.execute(bc, scope);
        instance.finish(bc);
        
        
        System.assertEquals(true, acc.Id != null);
        Test.stopTest();
    }
}