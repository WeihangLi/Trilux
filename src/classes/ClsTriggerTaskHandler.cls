/**
 * Trigger handler class for Task which does following actions
 * - 1. fill Related_Project__c before insert/update if Task related to Opportunity
 *
 * @author Yuda Zheng
 * @created 2015-11-25
 * @version 1.0
 * @since 35.0
 *
 * @changelog
 * 2015-11-25 Yuda Zheng <yuda.zheng@oinio.com>
 * - Created
 */

public class ClsTriggerTaskHandler extends ClsTriggerVirtual {
        
    /**
     * @see IntHelper.beforeTrigger
     */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        fillReltedProject(trgCtx);
    }
    
    /**
     * @see IntHelper.beforeTrigger
     */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {

    }

    /**
     *  This function is used to update fill field Related_Project__c. (before insert, before update) (R-84)
     *  
     *
     @author    Yuda Zheng
     @created   2015-11-25
     @version   1.0
     @since     35.0 (Force.com ApiVersion)
     *
     @changelog
     * 2015-11-25 Yuda Zheng <yuda.zheng@oinio.com>
     * - Created
    */
    @TestVisible
    private void fillReltedProject(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isBefore) {
            if(trgCtx.isInsert || trgCtx.isUpdate){
                set<String> set_oppId = new set<String>();
                map<String, String> map_oppId_proId = new map<String, String>();
                    
                for(SObject sobj : trgCtx.newList) {
                    Task task = (Task)sobj;
                    if(task.whatId != null && task.whatId.getSobjectType() == Schema.Opportunity.SObjectType){
                        set_oppId.add(task.whatId);
                    }
                }
                
                if(!set_oppId.isEmpty()) {
                    for(Opportunity opp : [select Id, Related_Project__c from Opportunity where Id in: set_oppId]){
                        if(opp.Related_Project__c != null){
                            map_oppId_proId.put(opp.Id, opp.Related_Project__c);
                        }
                    }
                    
                    for(SObject sobj : trgCtx.newList) {
                        Task task = (Task)sobj;
                        if(task.whatId != null && task.whatId.getSobjectType() == Schema.Opportunity.SObjectType){
                            if(map_oppId_proId.containsKey(task.whatId) != null){
                                sobj.put('Related_Project__c', map_oppId_proId.get(task.whatId));
                            }else{
                                sobj.put('Related_Project__c', null);
                            }
                        }else{
                            sobj.put('Related_Project__c', null);
                        }
                    }
                }  
            }   
        }   
    }
}