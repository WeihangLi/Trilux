/**
 * Trigger factory class, centual adapter for all trigger runs
 * - creates trigger according trigger handler, throws ClsTriggerException 
 *      if no handler is registered
 * - uses test run skipper to control tests run or not 
 * - excecutes code logic seperately in before and after trigger context, 
 *      which is defined in according trigger handler itself
 *
 *  
 * @author Haobo Song
 * @created 2014-06-07
 * @version 1.0
 * @since 28.0
 *
 * @changelog
 * 2014-06-07 Haobo Song <haobo.song@itbconsult.com>
 * - Created
 */

public class ClsTriggerFactory {

    /**
     *  Global test run skipper as privat static member
     */
    //oclausen start change
    //public static Boolean isSkipTrigger = !Test.isRunningTest();
    public static Boolean isSkipTrigger = false;
    //oclausen end change
    /**
     *  Test run skippers for all trigger handlers as privat static member in form of map
     */
    public static Map<String, Boolean> map_handler_isSkip = new Map<String, Boolean>();
    
    /**
     *  Public static method to create and execute a trigger handler
     *  Throws a ClsTriggerException if no handler has been registered.
     *
     *  
     * @author Haobo Song
     * @created 2014-06-07
     * @version 1.0
     * @since 28.0
     *
     * @param   soType      the Sobject Type, on which the current trigger is running
     *
     * @changelog
     * 2014-06-07 Haobo Song <haobo.song@itbconsult.com>
     * - Created
     */
    public static void createHandler(Schema.sObjectType soType) {

        // Get a handler appropriate to the object being processed
        IntTrigger handler = getHandler(soType);
        
        // Make sure we have a handler registered, 
        //new handlers must be registered in the getHandler method.
        if (handler == null) {
            throw new ClsTriggerException('No Trigger Handler registered for Object Type: ' + soType);
        }
        
        // Execute the handler to fulfil the trigger
        execute(handler);
    }
    
    /**
     *  Private static method to control the execution of the handler
     * - trigger test run skipper examination
     * - runs in before trigger context
     * - runs in after trigger context
     *
     *  
     * @author Haobo Song
     * @created 2014-06-07
     * @version 1.0
     * @since 28.0
     *
     * @param   handler     trigger handler interface
     *
     * @changelog
     * 2014-06-07 Haobo Song <haobo.song@itbconsult.com>
     * - Created
     */
    private static void execute(IntTrigger handler) {

        Boolean skip = false;

        // The skip flag in the map has a higher priority than global flag
        if (map_handler_isSkip.containsKey(String.valueOf(handler).split(':')[0])) {
            skip = map_handler_isSkip.get(String.valueOf(handler).split(':')[0]);
        } else if (ClsTriggerFactory.isSkipTrigger) {
            skip = ClsTriggerFactory.isSkipTrigger;
        }
        
        if (skip) {
            // The handler should be skipped
            return;
        }

        ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext(Trigger.isBefore, Trigger.isAfter, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.isUndelete, Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);

        // Before Trigger
        if (Trigger.isBefore) {

            // Call the bulk before to handle any caching of data and enable bulkification
            handler.bulkBefore(trgCtx);
            
            // Execute business logic in before trigger context
            handler.beforeTrigger(trgCtx);
            
        } else {

            // Call the bulk after to handle any caching of data and enable bulkification
            handler.bulkAfter(trgCtx);
            
            // Execute business logic in after trigger context
            handler.afterTrigger(trgCtx);
            
        }
         
        // Perform any post processing
        handler.andFinally(trgCtx);
    }
    
    /**
     *  Public static method to set global test run skipper
     *
     *  
     * @author Haobo Song
     * @created 2014-06-07
     * @version 1.0
     * @since 28.0
     *
     * @param   skip        true or false
     *
     * @changelog
     * 2014-06-07 Haobo Song <haobo.song@itbconsult.com>
     * - Created
     */
    public static void setSkipHandlers(Boolean skip) {
        isSkipTrigger = skip;
    }
    
    /**
     *  Public static method to set test run skipper a specific trigger handler
     *
     *  
     * @author Haobo Song
     * @created 2014-06-07
     * @version 1.0
     * @since 28.0
     *
     * @param   handlerName     the hander name as string
     * @param   skip            true or false
     *
     * @changelog
     * 2014-06-07 Haobo Song <haobo.song@itbconsult.com>
     * - Created
     */
    public static void setSkipHandler(String handlerName, Boolean skip) {
        map_handler_isSkip.put(handlerName, skip);
    }
    
    /**
     *  Private static method to get the appropriate handler for the object type.
     *  Modify this method to register any additional handlers.
     *
     *  
     * @author Haobo Song
     * @created 2014-06-07
     * @version 1.0
     * @since 28.0
     *
     * @param   soType      the Sobject Type, on which the current trigger is running
     * @return  IntTrigger  the trigger handler interface if exists, or null
     *
     * @changelog
     * 2014-06-07 Haobo Song <haobo.song@itbconsult.com>
     * - Created 
     */
    private static IntTrigger getHandler(Schema.sObjectType soType) {
        
        if (soType == Account.sObjectType) {
            return new ClsTriggerAccountHandler();
        } /**else if (soType == Account_Objective__c.sObjectType) {
            return new ClsTriggerAccountObjectiveHandler();
        } else if (soType == Cycle__c.sObjectType) {
            return new ClsTriggerCycleHandler();
        } **/else if (soType == Event.sObjectType) {
            return new ClsTriggerEventHandler();
        } /**else if (soType == Organizational_Team__c.sObjectType) {
            return new ClsTriggerOrganizationalTeamHandler();
        } else if (soType == Storyboard__c.sObjectType) { 
            return new ClsTriggerStoryboardHandler();
        } else if (soType == Survey_Question_Response__c.sObjectType) {
            return new ClsTriggerSurveyQuestionResponseHandler();
        } else if (soType == Target_Group__c.sObjectType) {
            return new ClsTriggerTargetGroupHandler();
        } else if (soType == Target_Group_Objective__c.sObjectType) {
            return new ClsTriggerTargetGroupObjectiveHandler();
        } else if (soType == Target_Group_Survey__c.sObjectType) {
            return new ClsTriggerTargetGroupSurveyHandler();
        } **/else if (soType == User.sObjectType) {
            return new ClsTriggerUserHandler();
        } /**else if (soType == Visit__c.sObjectType) {
            return new ClsTriggerVisitHandler();
        } else if (soType == Notification__c.sObjectType) {
            return new ClsTriggerNotificationHandler();
        } else if (soType == Account_Survey__c.sObjectType) {
            return new ClsTriggerAccountMarketingActionHandler();
        } else if (soType == Target_Group_Mission__c.sObjectType) {
            return new ClsTriggerTargetGroupMissionHandler();
        } else if (soType == Target_Group_Account__c.sObjectType) {
            return new ClsTriggerTargetGroupAccountHandler();
        } else if (soType == Survey__c.sObjectType) {
            return new ClsTriggerSurveyHandler();
        } else if (soType == Daily_Report__c.sObjectType) {
            return new ClsTriggerDailyReport();
        }else if(soType == SurveyToMission__c.sObjectType) {
            return new ClsTriggerSurveyToMission();
        }**/
        //added by Yuda Zheng <yuda.zheng@oinio.com> 2015.11.24
        /*comment out by weihang 2016-01-08
        /**else if(soType == OpportunityTeamMember.sObjectType){
            return new ClsTriggerOpportunityTeamMemberHandler();
        }**/
        //added by Yuda Zheng <yuda.zheng@oinio.com> 2015.11.25
        else if(soType == Task.sObjectType){
            return new ClsTriggerTaskHandler();
        }
        //added by Yuda Zheng <yuda.zheng@oinio.com> 2015.11.26
        else if(soType == Opportunity.sObjectType){
            return new ClsTriggerOpportunityHandler();
        }
        //added by Yuda Zheng <yuda.zheng@oinio.com> 2015.11.30
        else if(soType == Trilux_Project__c.sObjectType){
            return new ClsTriggerProjectHandler();
        }
        /*comment out by weihang 2016-01-08
        //added by Yuda Zheng <yuda.zheng@oinio.com> 2015.12.10
        else if(soType == Visit_Frequency_Planning__c.sObjectType){
            return new ClsTriggerVisitFrequencyPlanningHandler();
        }
        */
        //added by Yuda Zheng <yuda.zheng@oinio.com> 2015.12.16
        else if(soType == Account_Team__c.sObjectType){
            return new ClsTriggerAccountTeamHandler();
        }
        //added by Yuda Zheng <yuda.zheng@oinio.com> 2015.12.21
        else if(soType == Opportunity_Partner__c.sObjectType){
            return new ClsTriggerOpportunityPartnerHandler();
        }
        else if(soType == Account_Details__c.sObjectType){//added by weihang 2016-02-01
            return new ClsTriggerAccountDetailsHandler();
        }
        //added by Yuda Zheng <yuda.zheng@oinio.com> 2016.02.05
        else if(soType == Contact.sObjectType){
            return new ClsTriggerContactHandler();
        }
        //added by Mei Xing <mei.xing@oinio.com> 2016.02.15
        else if(soType == Opportunity_Team_Member__c.sObjectType){
            return new ClsTriggerOpportunity_Team_MemberHandler(); 
        }
        //added by weihang 2016-03-07 
        else if(soType == UserTerritory2Association.sObjectType){
            return new ClsTriggerUserTerritory2AssociatHandler();
        }
        return null; 
    }

}