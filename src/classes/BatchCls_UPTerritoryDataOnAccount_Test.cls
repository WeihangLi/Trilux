/**
 *   This test class is for BatchCls_UpdateTerritoryDataOnAccount
 *
 * @author weihang li
 * @created 2016-03-23
 * @version 1.0
 * @since 36.0
 *
 * @changelog
 * 	2016-03-23 weihang li <weihang.li@oinio.com>
 * - Created 
 * - Coverage 100%
 */
 @isTest 
private class BatchCls_UPTerritoryDataOnAccount_Test {
    static testMethod void myUnitTest() {
    	Account acc = new Account();
    	acc.Name = 'Test Team';
    	acc.Type = 'CUST';
    	acc.Street__c = 'test street';
    	acc.BillingCountry = 'china';
    	acc.BillingCity = 'xian';
    	acc.BillingStreet = 'test street';
    	acc.BillingPostalCode = '01001';
    	acc.Initial_Sales_Channel__c = 'VDI1';
    	acc.Sales_Organisation__c = '0001';
    	insert acc;
    	
    	Territory_Data__c te = new Territory_Data__c();
    	te.PLZ__c = '99999';
    	te.X01_06_Account_MAM__c = '0100DB';
		te.X01_06_Opportunity_ID__c = '118';
		te.Sales_Organisation__c = '0001';
		insert te;
    	
    	
    	list<SObject> scope = new list<SObject>();
    	scope.add(acc);
    	
    	Test.startTest();
    	BatchCls_UpdateTerritoryDataOnAccount instance = new BatchCls_UpdateTerritoryDataOnAccount();
        
        Database.BatchableContext bc;   
		instance.start(bc);
        instance.execute(bc, scope);
        instance.finish(bc);
        
        System.assertEquals(true, acc.Territory_Data__c == '');
        Test.stopTest();
    }
}