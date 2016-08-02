/**
 * Trigger handler class for Opportunity_Team_Member__c which does following actions
 * - 1. Sync standard Opportunity Team Member
 *
 * @author Mei Xing
 * @created 2015-02-15
 * @version 1.0
 * @since 35.0 
 *
 * @changelog
 * 2015-02-15 Mei Xing <mei.xing@oinio.com>
 * - Created
 */
public without sharing class ClsTriggerOpportunity_Team_MemberHandler  extends ClsTriggerVirtual{
    /**
     * @see IntHelper.beforeTrigger
     */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        
        if(trgCtx.isBefore) return;
        
    }
    /**
     * @see IntHelper.beforeTrigger
     */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        
        this.oppyTeamMember_SYNC(trgCtx);
        
    }
    /**
     *  This function is used to standard Opportunity Team Member
     *  creat a standard Opportunity Team Member after create a Opportunity_Team_Member__c
     *  update opposite OpportunityTeamMember via opportunity and user after user update Opportunity_Team_Member__c 
     *  delete opposite OpportunityTeamMember via opportunity and user after user delete Opportunity_Team_Member__c 
     @author    Mei Xing
     @created   2016-02-15
     @version   1.0 
     @since     35.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-02-15 Mei Xing <mei.xing@oinio.com>
     * - Created
    */
    public void oppyTeamMember_SYNC(ClsWrappers.TriggerContext trgCtx){
        if(trgCtx.isBefore) return;
        List<OpportunityTeamMember> list_standoppyTeamMems = new List<OpportunityTeamMember>();
        Map<Id,Map<Id,Id>> map_oppyId_map_userId_oppTeamMemId = new Map<Id,Map<Id,Id>>();
        Map<Id,Opportunity_Team_Member__c> map_id_custoppyTeamMems_New = new Map<Id,Opportunity_Team_Member__c>();
        if(trgCtx.isInsert){
            //added by weihang 2016-04-05
            set<Id> set_oppTeamMems = new set<Id>();
            
            for(Sobject sobj : trgCtx.newlist) {
                Opportunity_Team_Member__c custOppyTeamMem = (Opportunity_Team_Member__c)sobj;
                OpportunityTeamMember standOppyTeamMem = new OpportunityTeamMember();
                standOppyTeamMem.OpportunityId = custOppyTeamMem.Opportunity__c;
                system.debug('standOppyTeamMem.OpportunityId:'+standOppyTeamMem.OpportunityId);
                standOppyTeamMem.UserId = custOppyTeamMem.User__c;
                system.debug('custOppyTeamMem.User__c:'+ custOppyTeamMem.User__c);
                standOppyTeamMem.TeamMemberRole = custOppyTeamMem.Team_Role__c;
                if(custOppyTeamMem.Is_Project_Decider__c) {
                    standOppyTeamMem.Project_Decider__c = 'Yes';
                }else {
                    standOppyTeamMem.Project_Decider__c = 'No';
                }
                if(custOppyTeamMem.Is_Key_Account_Manager__c) {
                    standOppyTeamMem.Key_Account_Manager__c = 'Yes';
                }else {
                    standOppyTeamMem.Key_Account_Manager__c = 'No';
                }
                list_standoppyTeamMems.add(standOppyTeamMem);
                
                //added by weihang 2016-04-05
                set_oppTeamMems.add(custOppyTeamMem.Id);
            }
            if(list_standoppyTeamMems != null) {
            system.debug('list_standoppyTeamMems:'+ list_standoppyTeamMems);
                insert list_standoppyTeamMems;
            }
            //added by weihang 2016-04-05 begin
            if(!set_oppTeamMems.isEmpty()){
                map<Id,Id> map_oppId_usId = new map<Id,Id>();
                for(Opportunity_Team_Member__c opm:[select Id,Name,Opportunity__c,Team_Role__c,User__c,Opportunity__r.SORG__c,Is_Project_Decider__c from Opportunity_Team_Member__c where Id in: set_oppTeamMems]){
                    //if(opm.Team_Role__c == 'Project Manager' || Is_Project_Decider__c) map_oppId_usId.put(opm.Opportunity__c, opm.User__c);
                    if(opm.Team_Role__c == 'Project Manager' && opm.Opportunity__r.SORG__c != '0001'){
                        map_oppId_usId.put(opm.Opportunity__c, opm.User__c);
                    }else if(opm.Opportunity__r.SORG__c == '0001' && opm.Is_Project_Decider__c){
                        map_oppId_usId.put(opm.Opportunity__c, opm.User__c);
                    }
                }
                list<Opportunity> list_updateOppys = new list<Opportunity>();
                for(Opportunity opp:[select Id,Project_Manager__c from Opportunity where Id in: map_oppId_usId.keySet()]){
                    opp.Project_Manager__c = map_oppId_usId.get(opp.Id);
                    list_updateOppys.add(opp);
                }
                if(!list_updateOppys.isEmpty()){
                    update list_updateOppys;
                }
            }
            //added by weihang 2016-04-05 end
        }
        if(trgCtx.isUpdate){
            for(Sobject sobj : trgCtx.oldlist) {
                Opportunity_Team_Member__c custOppyTeamMem = (Opportunity_Team_Member__c)sobj;
                Opportunity_Team_Member__c custOppyTeamMemOld = (Opportunity_Team_Member__c)trgCtx.newMap.get(custOppyTeamMem.Id);
                if(custOppyTeamMem.Opportunity__c != custOppyTeamMemOld.Opportunity__c ||
                    custOppyTeamMem.User__c != custOppyTeamMemOld.User__c ||
                    custOppyTeamMem.Team_Role__c != custOppyTeamMemOld.Team_Role__c ||
                    custOppyTeamMem.Is_Project_Decider__c != custOppyTeamMemOld.Is_Project_Decider__c ||
                    custOppyTeamMem.Is_Key_Account_Manager__c != custOppyTeamMemOld.Is_Key_Account_Manager__c) {
                    Map<Id,Id> map_userId_oppTeamMemId = new Map<Id,Id>();
                    map_userId_oppTeamMemId.put(custOppyTeamMem.User__c,custOppyTeamMem.Id);
                    map_oppyId_map_userId_oppTeamMemId.put(custOppyTeamMem.Opportunity__c,map_userId_oppTeamMemId);
                }
            }
            for(Sobject sobj : trgCtx.newlist) {
                Opportunity_Team_Member__c custOppyTeamMem = (Opportunity_Team_Member__c)sobj;
                map_id_custoppyTeamMems_New.put(custOppyTeamMem.Id,custOppyTeamMem);
            }
            if(map_oppyId_map_userId_oppTeamMemId != null && map_id_custoppyTeamMems_New != null) {
                for(OpportunityTeamMember standOppyTeamMem : [Select OpportunityId,UserId,TeamMemberRole,Project_Decider__c,Key_Account_Manager__c
                                                              From OpportunityTeamMember
                                                              Where OpportunityId in : map_oppyId_map_userId_oppTeamMemId.keySet() ] ) {
                    if(map_oppyId_map_userId_oppTeamMemId.get(standOppyTeamMem.OpportunityId).containsKey(standOppyTeamMem.UserId)) {
                        Opportunity_Team_Member__c custOppyTeamMem = map_id_custoppyTeamMems_New.get(map_oppyId_map_userId_oppTeamMemId.get(standOppyTeamMem.OpportunityId).get(standOppyTeamMem.UserId));
                        if(custOppyTeamMem != null) {
                            standOppyTeamMem.TeamMemberRole = custOppyTeamMem.Team_Role__c; 
                            if(custOppyTeamMem.Is_Project_Decider__c) {
                                standOppyTeamMem.Project_Decider__c = 'Yes';
                            }else {
                                standOppyTeamMem.Project_Decider__c = 'No';
                            }
                            if(custOppyTeamMem.Is_Key_Account_Manager__c) {
                                standOppyTeamMem.Key_Account_Manager__c = 'Yes';
                            }else {
                                standOppyTeamMem.Key_Account_Manager__c = 'No';
                            }
                            list_standoppyTeamMems.add(standOppyTeamMem);
                        }
                    }
                }
            }
            if(list_standoppyTeamMems != null) {
                update list_standoppyTeamMems;
            }
        } 
        if(trgCtx.isDelete){
            for(Sobject sobj : trgCtx.oldlist) {
                Opportunity_Team_Member__c custOppyTeamMem = (Opportunity_Team_Member__c)sobj;
                Map<Id,Id> map_userId_oppTeamMemId = new Map<Id,Id>();
                map_userId_oppTeamMemId.put(custOppyTeamMem.User__c,null);
                map_oppyId_map_userId_oppTeamMemId.put(custOppyTeamMem.Opportunity__c,map_userId_oppTeamMemId);
            }
            if(map_oppyId_map_userId_oppTeamMemId != null) {
                for(OpportunityTeamMember standOppyTeamMem : [Select OpportunityId,UserId,TeamMemberRole,Is_Project_Decider__c,Is_Key_Account_Manager__c
                                                              From OpportunityTeamMember 
                                                              Where OpportunityId in : map_oppyId_map_userId_oppTeamMemId.keySet()] ) {
                    if(map_oppyId_map_userId_oppTeamMemId.get(standOppyTeamMem.OpportunityId).containsKey(standOppyTeamMem.UserId)) {
                        list_standoppyTeamMems.add(standOppyTeamMem);
                    }
                }
            }
            if(list_standoppyTeamMems != null) {
             delete list_standoppyTeamMems;
            }
        }
    }
}