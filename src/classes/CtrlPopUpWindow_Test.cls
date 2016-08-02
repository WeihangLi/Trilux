/**
 * This class is used to test CtrlPopUpWindow
 *
 * @author      Weihang Li
 * @created     2015-12-23
 * @since       29.0    
 * @version     1.0 
 *
 * 2015-12-23 Weihang Li <Weihang.Li@oinio.com>
 * - Created 
 * - Coverage 100%
 */
@isTest
private class CtrlPopUpWindow_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Account acc = new Account();
        acc.Name = 'Test Team';
        acc.Type = 'PROS';
        acc.Street__c = 'test street';
        acc.BillingCountry = 'china';
        acc.BillingCity = 'xian';
        acc.BillingStreet = 'test street';
        acc.BillingPostalCode = '01001';
        acc.Initial_Sales_Channel__c = 'VDI1';
        acc.Sales_Organisation__c = '0001';
        acc.Initial_Sales_Org__c = '0001';
        insert acc;
        
        test.startTest();
        CtrlPopUpWindow ctrl = new CtrlPopUpWindow();
        ctrl.fieldType = 'BOOLEAN';
        ctrl.initItems();
        ctrl.objName = 'Account';
        ctrl.fieldName = 'Rating';
        ctrl.fieldType = 'PICKLIST';
        ctrl.initItems();
        ctrl.referenceObj = 'Account';
        ctrl.fieldType = 'REFERENCE';
        ctrl.initItems();
        ctrl.searchStr = 'test123';
        ctrl.getLKPValues('Account');
        system.assert(ctrl.getLKPValues('Account') != null);
        //ctrl.getPicklistValues('Account', 'Industry');
        ctrl.searchResult();
        
        CtrlPopUpWindow.referenceInfo ref = new CtrlPopUpWindow.referenceInfo(acc.Id,acc.Name);
        
        
        test.stopTest();
    }
}