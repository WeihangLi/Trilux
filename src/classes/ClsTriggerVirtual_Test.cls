/*  Test class for class ClsTriggerVirtual
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
private class ClsTriggerVirtual_Test {

    static testMethod void myUnitTest() {
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.BillingStreet = 'Hu Min Rd';
        acc.BillingCountry = 'China';
        acc.BillingCity = 'Shanghai';
        insert acc;
        
        Test.startTest();
        
        ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
        trgCtx.oldList = new List<SObject>();
        trgCtx.oldList.add((SObject) acc);
        
        trgCtx.newList = new List<SObject>();
        trgCtx.newList.add((SObject) acc);
        
        trgCtx.newMap = new Map<Id, SObject>();
        trgCtx.newMap.put(acc.Id, acc);
        
        trgCtx.oldMap = new Map<Id, SObject>();
        trgCtx.oldMap.put(acc.Id, acc);
        
        ClsTriggerVirtual cls = new ClsTriggerVirtual();
        cls.bulkBefore(trgCtx);  
        
        cls.bulkAfter(trgCtx);  
        trgCtx.isDelete = true;        
        cls.beforeTrigger(trgCtx); 
        
        trgCtx.isInsert = true;        
        cls.beforeTrigger(trgCtx); 
        
        trgCtx.isUpdate = true;        
        cls.beforeTrigger(trgCtx); 
        
        trgCtx.isDelete = true;    
        cls.afterTrigger(trgCtx); 
        trgCtx.isInsert = true;  
        cls.afterTrigger(trgCtx);  
        trgCtx.isUpdate = true;       
        cls.afterTrigger(trgCtx);   
        
        cls.andFinally(trgCtx);   
        
             
        Test.stopTest();
    }
    
}