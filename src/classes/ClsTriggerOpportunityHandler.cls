/**
 * Trigger handler class for Opportunity which does following actions
 * - 1. Update related Activities when Opportunity is changed Project (R-84)
 * - 2. set Trilux Project Sales_Region__c = Territory_Data__c.Sales_Region__c (R-654)
 *
 * @author Yuda Zheng
 * @created 2015-11-26
 * @version 1.0
 * @since 35.0
 *
 * @changelog
 * 2015-11-26 Yuda Zheng <yuda.zheng@oinio.com>
 * - Created
 */
public class ClsTriggerOpportunityHandler extends ClsTriggerVirtual {
        
    /**
     * @see IntHelper.beforeTrigger
    */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        //if(trgCtx.isUpdate) updateOppyAndManagementOppTeamMember(trgCtx);
        //added lili zhao 2016-04-21 begin
        setOppySalesRegion(trgCtx);        
        //end
    }
    
    /**
     * @see IntHelper.beforeTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        updateActivities(trgCtx);
        //if(trgCtx.isInsert){
        if(!ClsTerritoryManagementUtil.isOpportunityTriggerRun){
            updateOppyAndManagementOppTeamMember(trgCtx);
            ClsTerritoryManagementUtil.isOpportunityTriggerRun = true;
        }
        //}
        
    }
    /**
     *  This function is used to update Activities when Opportunity is changed Project (after update) (R-84)
     *  
     *
     @author    weihang li
     @created   2016-03-31
     @version   1.0
     @since     35.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-03-31 weihang li <weihang.li@oinio.com>
     * - Created
    */
    @TestVisible
    private void updateOppyAndManagementOppTeamMember(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isAfter && !trgCtx.isDelete){
            map<String,List<Opportunity>> map_zipCode_oppIds = new map<String,List<Opportunity>>();
            set<String> set_orgs = new set<String>();
            set<Id> set_Ids = new set<Id>();
            set<String> set_projectMangerOpp  =new set<String>();
            set<String> set_internalSalesOpp  =new set<String>();
            list<Opportunity_Team_Member__c> list_oppTeamMember2delte = new list<Opportunity_Team_Member__c>();
            list<Opportunity> list_opps = new list<Opportunity>();
            
            for(SObject sobj : trgCtx.newList){
                Opportunity opp = (Opportunity)sobj;
                Opportunity oldOpp;
                    if(trgCtx.isUpdate) oldOpp = (Opportunity)trgCtx.oldMap.get(opp.Id);
                    if((trgCtx.isInsert && opp.Sales_Channels__c != '') || (trgCtx.isUpdate && (opp.Postal_Code__c != oldOpp.Postal_Code__c || opp.Sales_Channels__c != oldOpp.Sales_Channels__c || opp.SORG__c != oldOpp.SORG__c))){
                        if(!map_zipCode_oppIds.containsKey(opp.Postal_Code__c)){
                            map_zipCode_oppIds.put(opp.Postal_Code__c,new list<Opportunity>());
                            set_Ids.add(opp.Id);
                        }
                        map_zipCode_oppIds.get(opp.Postal_Code__c).add(opp);
                        if(opp.SORG__c != ''){
                            set_orgs.add(opp.SORG__c);
                            
                        }
                    }
            }
            for(Opportunity opp : [select Id,Name,Sales_Channels__c,SORG__c,Related_Project__c,Related_Project__r.Project_Location_Postal_Code__c,Postal_Code__c, Related_Project__r.Project_Location_Country__c from Opportunity where id in: set_Ids]){
                list_opps.add(opp);
            }
            for(Opportunity_Team_Member__c oppTM : [select Id, Created_Automatically__c, Team_Role__c, Opportunity__c from Opportunity_Team_Member__c where Opportunity__c in: set_Ids and (Created_Automatically__c = true or Team_Role__c = 'Internal Sales Contact' or Team_Role__c = 'Project Manager')]){
                if(oppTM.Created_Automatically__c){
                    list_oppTeamMember2delte.add(oppTM);
                }else{
                    if(oppTM.Team_Role__c == 'Project Manager'){
                        set_projectMangerOpp.add(oppTM.Opportunity__c);
                    }
                    if(oppTM.Team_Role__c == 'Internal Sales Contact'){
                        set_internalSalesOpp.add(oppTM.Opportunity__c);
                    }
                }
            }
            if(!list_oppTeamMember2delte.isEmpty()){
                delete list_oppTeamMember2delte;
            }
            
            List<String> fields = new List<String>();
            fields.addAll(Territory_Data__c.SObjectType.getDescribe().fields.getMap().keySet());
            
            list<Territory_Data__c> list_terData = new list<Territory_Data__c>();
            String query = 'Select ';
            for(String strField : fields){
                query += strField + ', '; 
            }
            query = query.substring(0, query.lastIndexOf(',')) + ' from Territory_Data__c where Sales_Organisation__c in: set_orgs';
            for(Territory_Data__c td : database.query(query)){
                for(String code:map_zipCode_oppIds.keySet()){
                    if(code.indexOf(td.PLZ__c) == 0){
                        list_terData.add(td);
                    }
                }
            }
            
            if(!list_terData.isEmpty()){
                map<String,Opportunity> map_tdOppFieldVal_oppy = new map<String,Opportunity>();        
                map<String,Opportunity> map_tdAccFieldVal_oppy = new map<String,Opportunity>();      
                  
                for(Opportunity opp : list_opps){
                    for(Territory_Data__c td:list_terData){
                        if(opp.Postal_Code__c.indexOf(td.PLZ__c) == 0 && td.Sales_Organisation__c == opp.SORG__c && td.Country__c == opp.Related_Project__r.Project_Location_Country__c){
                            for(String str:fields){
                                if((str.toUpperCase()).indexOf(opp.Sales_Channels__c) > -1 && (str.toUpperCase()).indexOf('OPPORTUNITY') > -1){
                                    if(td.get(str) != null){
                                        if(!map_tdOppFieldVal_oppy.containsKey(String.valueOf(td.get(str)))){
                                            map_tdOppFieldVal_oppy.put(String.valueOf(td.get(str)), opp);
                                        }
                                    }
                                }
                                if((str.toUpperCase()).indexOf(opp.Sales_Channels__c) > -1 && (str.toUpperCase()).indexOf('ACCOUNT') > -1){
                                    //strAccVal += td.get(str)+',';
                                    if(td.get(str) != null){
                                        if(!map_tdAccFieldVal_oppy.containsKey(String.valueOf(td.get(str)))){
                                            map_tdAccFieldVal_oppy.put(String.valueOf(td.get(str)), opp);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }      

                if(!map_tdOppFieldVal_oppy.isEmpty() || !map_tdAccFieldVal_oppy.isEmpty()){
                    list<Opportunity_Team_Member__c> list_members = new list<Opportunity_Team_Member__c>();
                    map<String,list<Id>> map_district_userIds = new map<String,list<Id>>();
                    map<String,list<Id>> map_salesGroup_userIds = new map<String,list<Id>>();
                    map<Id,Id> map_oppId_usId = new map<Id,Id>();
        
                    for(User us:[select Id,Name,District__c, Sales_Group__c from User where Sales_Group__c in: map_tdOppFieldVal_oppy.keySet() or District__c in: map_tdAccFieldVal_oppy.keySet()]){
                        if(!map_district_userIds.containsKey(us.District__c)){
                            map_district_userIds.put(us.District__c,new list<Id>());
                        }
                        map_district_userIds.get(us.District__c).add(us.Id);
                        if(!map_salesGroup_userIds.containsKey(us.Sales_Group__c)){
                            map_salesGroup_userIds.put(us.Sales_Group__c,new list<Id>());
                        }
                        map_salesGroup_userIds.get(us.Sales_Group__c).add(us.Id);
                    }
                    if(!map_district_userIds.isEmpty()){
                        for(String str : map_tdAccFieldVal_oppy.keySet()){
                            if(map_tdAccFieldVal_oppy.get(str) != null){
                                Opportunity opp = map_tdAccFieldVal_oppy.get(str);
                                if(map_district_userIds.containsKey(str)){
                                    for(Id usId:map_district_userIds.get(str)){
                                        if(opp.Id != null && !set_projectMangerOpp.contains(opp.Id)){
                                            Opportunity_Team_Member__c otm = new Opportunity_Team_Member__c();
                                            otm.Opportunity__c = opp.Id;
                                            otm.Created_Automatically__c = true;
                                            otm.Team_Role__c = 'Project Manager';
                                            otm.User__c = usId;
                                            list_members.add(otm);
                                            map_oppId_usId.put(opp.Id,usId);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(!map_salesGroup_userIds.isEmpty()){
                        for(String str:map_tdOppFieldVal_oppy.keySet()){
                            if(map_tdOppFieldVal_oppy.get(str) != null){
                                Opportunity opp = map_tdOppFieldVal_oppy.get(str);
                                if(map_salesGroup_userIds.containsKey(str)){
                                    for(Id usId:map_salesGroup_userIds.get(str)){
                                        if(opp.Id != null && !set_internalSalesOpp.contains(opp.Id)){
                                            Opportunity_Team_Member__c otm = new Opportunity_Team_Member__c();
                                            otm.Opportunity__c = opp.Id;
                                            otm.Created_Automatically__c = true;
                                            otm.Team_Role__c = 'Internal Sales Contact';
                                            otm.User__c = usId;
                                            list_members.add(otm);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if(!list_members.isEmpty() && trgCtx.isAfter){
                        insert list_members;
                    }
                    if(trgCtx.isBefore && trgCtx.isUpdate){
                        if(!map_oppId_usId.isEmpty()){
                            for(SObject sobj : trgCtx.newList){
                                Opportunity opp = (Opportunity)sobj; 
                                opp.OwnerId = map_oppId_usId.get(opp.Id);
                            }
                        }
                    }
                }
            }

            
        } 
    }
    /**
     *  This function is used to update Activities when Opportunity is changed Project (after update) (R-84)
     *  
     *
     @author    Yuda Zheng
     @created   2015-11-26
     @version   1.0
     @since     35.0 (Force.com ApiVersion)
     *
     @changelog
     * 2015-11-26 Yuda Zheng <yuda.zheng@itbconsult.com>
     * - Created
    */
    @TestVisible
    private void updateActivities(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isAfter) {
            if(trgCtx.isUpdate){
                map<String, String> map_oppId_proId = new map<String, String>();
                //get map Opportunity Project
                for(SObject sobj : trgCtx.newList) {
                    Opportunity opp = (Opportunity)sobj;
                    Opportunity oldOpp = (Opportunity)trgCtx.oldMap.get(opp.Id);
                    if(oldOpp.Related_Project__c != opp.Related_Project__c){
                        map_oppId_proId.put(opp.Id, opp.Related_Project__c);
                    }
                }
                
                if(!map_oppId_proId.isEmpty()){
                    list<Event> list_event2Update = new list<Event>();
                    list<Task> list_task2Update = new list<Task>();
                    
                    //update Evnet
                    for(Event event : [Select Id, whatId, Related_Project__c from Event where whatId in: map_oppId_proId.keySet()]){
                        if(map_oppId_proId.containsKey(event.whatId) && map_oppId_proId.get(event.whatId) != null){
                            event.Related_Project__c = map_oppId_proId.get(event.whatId);
                            list_event2Update.add(event);
                        }else{
                            event.Related_Project__c = null;
                            list_event2Update.add(event);
                        }
                    }
                    //update Task
                    for(Task task : [Select Id, whatId, Related_Project__c from Task where whatId in: map_oppId_proId.keySet()]){
                        if(map_oppId_proId.containsKey(task.whatId) && map_oppId_proId.get(task.whatId) != null){
                            task.Related_Project__c = map_oppId_proId.get(task.whatId);
                            list_task2Update.add(task);
                        }else{
                            task.Related_Project__c = null;
                            list_task2Update.add(task);
                        }
                    }
                    
                    if(!list_event2Update.isEmpty()){
                        update list_event2Update;
                    }
                    if(!list_task2Update.isEmpty()){
                        update list_task2Update;
                    }
                }
            }
        }   
    }
    /**
     *  This function is used to set Trilux Project Sales_Region__c = Territory_Data__c.Sales_Region__c
     *  If Opportunity.Sales_Regions__c is unchanged (--None--), set Opportunity.Sales_Regions__c = Opportunity.Related_Project__r.Sales_Region__c
     *  Else if, Opportunity.Sales_Regions__c is set manually (not --None--), set Opportunity.Sales_Regions__c to manually selected value
     *  Add validation rule, that ensures, that Opportunity.Sales_Regions__c is manually filled, if Opportunity.Related_Project__r.Sales_Region__c is empty
     *  
     *
     @author    Lili Zhao
     @created   2016-04-21
     @version   1.0
     @since     35.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-04-21 Lili Zhao <lili.zhao@itbconsult.com>
     * - Created
    */
    @TestVisible
    private void setOppySalesRegion(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isBefore && (trgCtx.isInsert || trgCtx.isUpdate)) {
            set<String> set_projectId = new set<String>();
            list<Opportunity> list_oppys = new list<Opportunity>();
            map<String, String> map_projectId_saleRegion = new map<String, String>();
            
            for(SObject sobj : trgCtx.newList) {
                Opportunity oppy = (Opportunity)sobj;
                Opportunity oldOppy = new Opportunity();
                if(trgCtx.isUpdate) oldOppy = (Opportunity)trgCtx.oldMap.get(oppy.Id);   
                
                if(((trgCtx.isUpdate && oppy.Sales_Regions__c != oldOppy.Sales_Regions__c) || 
                    trgCtx.isInsert ) && oppy.Sales_Regions__c == null ) {
                    if(oppy.Related_Project__c != null) {
                        set_projectId.add(oppy.Related_Project__c);
                        list_oppys.add(oppy);
                    }else {
                        oppy.addError(Label.OppySaleRegionEmptyError);
                        return;
                    }
                }                                   
            }
            if(!set_projectId.isEmpty()){
                //get map Project 
                for(Trilux_Project__c project : [select Sales_Region__c   
                                                 from Trilux_Project__c 
                                                 where Id in: set_projectId
                                                 And Sales_Region__c != null]) {
                    map_projectId_saleRegion.put(project.Id, project.Sales_Region__c);
                }
                for(Opportunity oppy : list_oppys) {
                    if(map_projectId_saleRegion.containsKey(oppy.Related_Project__c)) {
                        oppy.Sales_Regions__c = map_projectId_saleRegion.get(oppy.Related_Project__c);                      
                    }else {
                        oppy.addError(Label.OppySaleRegionEmptyError);
                        return;
                    }
                }
            }                       
        }   
    }
}