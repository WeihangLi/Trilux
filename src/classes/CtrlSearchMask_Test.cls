/**
 *   This class is used to test class CtrlSearchMask
 *
 * @author weihang li
 * @created 2015-12-17
 * @version 1.0
 * @since 31.0
 *
 * @changelog
 *  2015-12-17 weihang li <weihang.li@oinio.com>
 * - Created 
 * - Coverage 80%
 */
@isTest
private class CtrlSearchMask_Test {

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
        
        Search_Mask_Object__c smo = new Search_Mask_Object__c();
        smo.Name = 'Obj Name';
        smo.Default_Field__c = 'Name';
        insert smo;
        
        test.startTest();
        CtrlSearchMask.OrderBy ord = new CtrlSearchMask.OrderBy();
        CtrlSearchMask ctrl = new CtrlSearchMask();
        ctrl.getMap_operators_type();
        ctrl.selObject = 'Account';
        ctrl.changeObj();
        ctrl.getObjItems();
        ctrl.getFilterFieldsItems();
        
        ctrl.filter_Str = '[{"fieldName":"Name","operator":"equals to","fieldVal":"test","fieldType":"STRING"},{"fieldName":"IsDeleted","operator":"equals to","fieldVal":"false","fieldType":"BOOLEAN"},{"fieldName":"KAM_Category__c","operator":"equals to","fieldVal":"1","fieldType":"PICKLIST"},{"fieldName":"BillingStreet","operator":"contains","fieldVal":"test","fieldType":"TEXTAREA"},{"fieldName":"BillingCity","operator":"starts with","fieldVal":"te","fieldType":"STRING"}]';
        ctrl.strOrderBy = '[{"objName":"Account","fieldName":"Name","orderType":"asc"}]';
        ctrl.searchResult();        
        ctrl.getQuery();
        system.assert(ctrl.getQuery() != null);
        CtrlSearchMask.getOrderByString(ctrl.strOrderBy,'Account');
        ctrl.getValue('String','test');
        ctrl.getValue('MULTIPICKLIST','test');
        ctrl.getValue('CURRENCY','2');
        ctrl.getValue('INTEGER','2');
        ctrl.delRecordId = acc.Id;
        ctrl.deleteRecord();
        //system.assert(acc.Id == null);
        
        test.stopTest();
    }
    static testMethod void myUnitTest2() {
        CtrlSearchMask ctrl = new CtrlSearchMask();
        ctrl.getObjItems();
        ctrl.getFilterOperator('equals to');
        ctrl.getFilterOperator('not equals to');
        ctrl.getFilterOperator('less than');
        ctrl.getFilterOperator('greater than');
        ctrl.getFilterOperator('less or equal');
        ctrl.getFilterOperator('greater or equal');
        ctrl.getFilterOperator('contains');
        ctrl.getFilterOperator('does not contain');
        ctrl.getFilterOperator('starts with');
        ctrl.getFilterOperator('includes');
        ctrl.getFilterOperator('excludes');
    }
}