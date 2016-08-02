/**
 * Trigger handler class for account details which does following actions
 * - 1.ES-2: R-359: Customer & Contact Management: Account Deletion Flag (Online)
 *
 * @author weihang li
 * @created 2016-02-01
 * @version 1.0
 * @since 29.0
 *
 * @changelog
 * 2016-02-01 weihang li <weihang.li@oinio.com>
 * - Created
 */
public class ClsTriggerAccountDetailsHandler extends ClsTriggerVirtual{
	/**
     * @see IntHelper.beforeTrigger
    */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
    	
    }
    
    /**
     * @see IntHelper.beforeTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
    	changeAccountVal(trgCtx);
    }
    /**
     *  This function is used to format the date.
     *  
     *
     @author    Weihang Li
     @created   2016-02-01
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-01-07 Weihang Li <weihang.li@itbconsult.com>
     * - Created
    */
    @TestVisible
    public void changeAccountVal(ClsWrappers.TriggerContext trgCtx){
    	set<Id> set_accIds = new set<Id>();
    	for(SObject sobj:trgCtx.newList){
    		Account_Details__c accDet = (Account_Details__c)sobj;
    		if(trgCtx.isUpdate){
    			Account_Details__c oldAccDet = (Account_Details__c)trgCtx.oldMap.get(accDet.Id);
    			if(accDet.VKOrg_Deletion_Flag__c != oldAccDet.VKOrg_Deletion_Flag__c){
    				set_accIds.add(accDet.Account__c);
    			}
    		}else if(trgCtx.isInsert){
    			set_accIds.add(accDet.Account__c);
    		}
    	}
    	if(!set_accIds.isEmpty()){
    		list<Account> list_updateAccounts = new list<Account>();
    		for(Account acc:[select Id,Name,Deletion_Flag__c,(select Id,Name,VKOrg_Deletion_Flag__c from Account_Details__r) from Account where Id in: set_accIds]){
				Integer i = 0;
				for(Account_Details__c ad:acc.Account_Details__r){
					if(!ad.VKOrg_Deletion_Flag__c){
						i++;
					}
				}
				if(i > 0){
					acc.Deletion_Flag__c = false;
				}else{
					acc.Deletion_Flag__c = true;
				}
    			list_updateAccounts.add(acc);
    		}
    		if(!list_updateAccounts.isEmpty()){
    			update list_updateAccounts;
    		}
    	}
    }
    
}