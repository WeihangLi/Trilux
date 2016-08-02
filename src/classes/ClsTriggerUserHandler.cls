/**
 * Trigger handler class for User which does following actions
 * - 1. use to create GroupMember
 *
 * @author Lingjun Jiang
 * @created 2014-10-15
 * @version 1.0
 * @since 30.0
 *
 * @changelog
 * 2014-10-15 Lingjun Jiang <lingjun.jiang@itbconsult.com>
 * - Created
 */

public class ClsTriggerUserHandler extends ClsTriggerVirtual {
        
    /** 
     * @see IntHelper.beforeTrigger
     */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        syncUserLanguage(trgCtx);
    }
    
    /**
     * @see IntHelper.beforeTrigger
     */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {

    }
    
    private void syncUserLanguage(ClsWrappers.TriggerContext trgCtx) {
        if (!trgCtx.isBefore) return;
        for (sObject so: trgCtx.newList) {
            User u = (User) so;
            u.Language_Locale_Key__c = u.LanguageLocaleKey;
        }
    }
   
}