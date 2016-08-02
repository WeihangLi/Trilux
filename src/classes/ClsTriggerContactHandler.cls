/**
 * Trigger handler class for Contact which does following actions
 * - 1. clean up SPA Id after undelete
 *
 * @author Yuda Zheng
 * @created 2016-02-05
 * @version 1.0
 * @since 30.0
 *
 * @changelog
 * 2016-02-05 Yuda Zheng <yuda.zheng@itbconsult.com>
 * - Created
 */
public class ClsTriggerContactHandler extends ClsTriggerVirtual {    
	
	/**
    * @see IntHelper.beforeTrigger
    */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
    	
    }
    
    /**
    * @see IntHelper.beforeTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
    	cleanUpSPAID(trgCtx);
    }
	
	/**
     *  This function is used to clean up SPA Id after undelete (R-386)
     *  
     *
     @author    Yuda Zheng
     @created   2016-02-05
     @version   1.0
     @since     35.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-02-05 Yuda Zheng <yuda.zheng@oinio.com>
     * - Created
    */
    @TestVisible
    private void cleanUpSPAID(ClsWrappers.TriggerContext trgCtx) {
    	if(trgCtx.isAfter) {
    		if(trgCtx.isUndelete){
    			list<Contact> list_contact2Update = new list<Contact>();
    			set<String> set_conId = new set<String>();
    			
    			for(SObject sobj : trgCtx.newList) {
    				Contact con = (Contact)sobj;
    				set_conId.add(con.Id);
    			}
    			
    			if(!set_conId.isEmpty()){
    				for(Contact con : [Select Id, Contact_SAP_ID__c from Contact where id in: set_conId]){
    					con.Contact_SAP_ID__c = null;
    					list_contact2Update.add(con);
    				}
    			}
    			
    			if(!list_contact2Update.isEmpty()){
    				update list_contact2Update;
    			}
    		}
    	}
    
    }
}