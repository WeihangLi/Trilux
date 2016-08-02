/**
 * Trigger handler class for Event which does following actions
 * - 1. Synchronize from event to visit.
 * - 2. Check the IsPrivate and WhatId
 * - 3. fill Related_Project__c before insert/update if Event related to Opportunity
 *
 * @author Lingjun Jiang
 * @created 2014-10-15
 * @version 1.0
 * @since 30.0
 *
 * @changelog
 * 2014-10-15 Lingjun Jiang <lingjun.jiang@itbconsult.com>
 * - Created
 *
 * 2016-02-17 Mei Xing <mei.xing@oinio.com>
 * - Modified
 */

public class ClsTriggerEventHandler extends ClsTriggerVirtual {
        
    /**
     * @see IntHelper.beforeTrigger
     */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        //Comment out by Yuda Zheng <yuda.zheng@oinio.com> on 2015-11-25
        //validatePrivateAndWhatId(trgCtx);
        //fillReltedProject(trgCtx);
    }
    
    /**
     * @see IntHelper.beforeTrigger
     */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        //Comment out by Yuda Zheng <yuda.zheng@oinio.com> on 2015-11-25
        //Currently we have problem that visit can't be sync from Event whatId is not Account.
        //syncEventToVisit(trgCtx);
        VisitRepport_SYNC(trgCtx);
    }
    
    /**
     * This trigger is a after trigger on object "Event "(after delete, after insert, after undelete, after update).
     * This trigger is used to synchronize from event to visit.
     * 
     * @author      Yinfeng Guo
     * @created     2013-06-15
     * @since       27.0 (Force.com ApiVersion)    
     * @version     1.0 
     *
     * @changelog
     * 2013-06-15 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created    
    */
    /**@TestVisible
    private void syncEventToVisit(ClsWrappers.TriggerContext trgCtx) {
        
        // Check trigger event.
        if (!trgCtx.isAfter) return;
        
        // Transfer all SObject to a specifical type.
        list<Event> trgCtxNewList = new list<Event>();
        list<Event> trgCtxOldList = new list<Event>();
        if(!trgCtx.isDelete) {
            for (SObject sobj : trgCtx.newList) {
                trgCtxNewList.add((Event) sobj);
            }
        }
        if(trgCtx.isUpdate || trgCtx.isDelete) {
            for (SObject sobj : trgCtx.oldList) {
                trgCtxOldList.add((Event) sobj);
            }
        }
        
        
        if(!TriggerRecursionDefense.visitEventSync && trgCtx.isAfter) {
            //System.debug('************************* ' + triggerName + ': After Trigger *************');
            if(trgCtx.isAfter) {
                TriggerRecursionDefense.visitEventSync = true;
                String mode;
                list<Event> list_new = new list<Event>();
                list<Event> list_old = new list<Event>();
                
                if(trgCtx.isInsert || trgCtx.isUnDelete) {
                    mode = ClsVisitUtil.MODE_INSERT;
                    list_new = trgCtxNewList; 
                } else if (trgCtx.isUpdate) {
                    mode = ClsVisitUtil.MODE_UPDATE;
                    list_new = trgCtxNewList;
                    list_old = trgCtxOldList;
                } else if (trgCtx.isDelete) {
                    mode = ClsVisitUtil.MODE_DELETE;
                    list_old = trgCtxOldList;
                }
                
                if (!test.isRunningTest()) {
                    ClsVisitUtil.calculateTriggerOnEvent(mode, list_new, list_old);
                }
                TriggerRecursionDefense.visitEventSync = false;
            }
        }
    }**/
    
    /**
     * This trigger is a after trigger on object "Event "(before insert, before update).
     * This trigger is used to check the IsPrivate and WhatId.
     * 
     * @author      Yinfeng Guo
     * @created     2013-06-15
     * @since       27.0 (Force.com ApiVersion)    
     * @version     1.0 
     *
     * @changelog
     * 2013-06-15 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created    
    */
    /**@TestVisible
    private void validatePrivateAndWhatId(ClsWrappers.TriggerContext trgCtx) {
        
        // Check trigger event.
        if (!trgCtx.isBefore) return;
        
        //System.debug('************************* ' + triggerName + ': Before Trigger ************');
        if(trgCtx.isUpdate) {
            for(SObject sobj : trgCtx.newList) {
                Event e = (Event) sobj;
                    Event oldEvent = (Event) trgCtx.oldMap.get(e.id);
                if(e.IsPrivate != oldEvent.IsPrivate) {
                    e.IsPrivate.addError('You can not change private');
                } else if (!e.IsPrivate && oldEvent.WhatId != null && e.WhatId != oldEvent.WhatId) {
                    e.WhatId.addError('You can not change related to');
                }
            }
        }
    }**/
    
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
     * 2015-11-25 Yuda Zheng <yuda.zheng@itbconsult.com>
     * - Created
    
    @TestVisible
    private void fillReltedProject(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isBefore) {
            if(trgCtx.isInsert || trgCtx.isUpdate){
                set<String> set_oppId = new set<String>();
                map<String, String> map_oppId_proId = new map<String, String>();
                    
                for(SObject sobj : trgCtx.newList) {
                    Event event = (Event)sobj;
                    if(event.whatId.getSobjectType() == Schema.Opportunity.SObjectType){
                        set_oppId.add(event.whatId);
                    }
                }
                
                for(Opportunity opp : [select Id, Related_Project__c from Opportunity where Id in: set_oppId]){
                    if(opp.Related_Project__c != null){
                        map_oppId_proId.put(opp.Id, opp.Related_Project__c);
                    }
                }
                
                for(SObject sobj : trgCtx.newList) {
                    Event event = (Event)sobj;
                    if(event.whatId.getSobjectType() == Schema.Opportunity.SObjectType){
                        if(map_oppId_proId.containsKey(event.whatId) != null){
                            sobj.put('Related_Project__c', map_oppId_proId.get(event.whatId));
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
    */
    /**
     *  This function is used to SYNC the visit repport (R-226)
     *  
     @author    Mei Xing
     @created   2016-02-17
     @version   1.0
     @since     35.0 (Force.com ApiVersion)
     
     @changelog
     * 2016-02-17 Mei Xing <mei.xing@oinio.com>
     * - Created
    */
    private void VisitRepport_SYNC(ClsWrappers.TriggerContext trgCtx){
        if(trgCtx.isBefore) return;
        list<Visit__c> list_visit = new list<Visit__c>();
        list<Event> list_event_update = new list<Event>();
        map<Id,Id> map_eventId_visitId = new map<Id,Id>();
        map<Id,Event> map_Id_event_update = new map<Id,Event>();
        map<Id,Event> map_Id_event_delete = new map<Id,Event>();
        
        if(trgCtx.isInsert){
            for(Sobject sobj : trgCtx.newlist) {
                Event event_new = (Event)sobj;
                if(event_new.Is_Customer_Visit__c && event_new.WhatId != null && event_new.WhatId.getSObjectType().getDescribe().getName()=='Account'  ) {
                    Visit__c visit = new Visit__c();
                    visit.Account__c = event_new.WhatId;
                    visit.Subject__c = event_new.Subject;
                    visit.Location__c = event_new.Location;
                    visit.Start_Time__c = event_new.StartDateTime;
                    visit.End_Time__c = event_new.EndDateTime;
                    visit.Description__c = event_new.Description;
                    visit.Sales_Rep__c = event_new.OwnerId;
                    visit.Visit_Status__c = 'Planned';
                    visit.Activity_Id__c = event_new.Id;
                    if(event_new.WhoId != null && event_new.WhoId.getSObjectType().getDescribe().getName()=='Contact'){
                        visit.Contact__c = event_new.WhoId;
                    }
                    list_visit.add(visit);
                }
            }
            if(list_visit != null) {
                insert list_visit;
                for(Visit__c visit:list_visit) {
                    map_eventId_visitId.put(visit.Activity_Id__c,visit.Id);
                }
            }
            
            if(map_eventId_visitId != null) {
                for (Event event_update : [select Id , Visit__c ,Activity_Type__c from Event where Id in : map_eventId_visitId.keySet()]) {
                    event_update.Visit__c = map_eventId_visitId.get(event_update.Id);
                    event_update.Activity_Type__c = 'Visit';
                    list_event_update.add(event_update);
                }
            }
            
            if(list_event_update != null) {
                update list_event_update;
            }
            
        }
        
        if(trgCtx.isUpdate){
            for(Sobject sobj : trgCtx.newlist) {
                Event event_new = (Event)sobj;
                Event event_old = (Event)trgCtx.oldMap.get(event_new.Id);
                
                if(event_new.Is_Customer_Visit__c && event_new.WhatId != null && event_new.WhatId.getSObjectType().getDescribe().getName()=='Account') {
                    if(!event_old.Is_Customer_Visit__c) {
                        Visit__c visit = new Visit__c();
                        visit.Account__c = event_new.WhatId;
                        visit.Subject__c = event_new.Subject;
                        visit.Location__c = event_new.Location;
                        visit.Start_Time__c = event_new.StartDateTime;
                        visit.End_Time__c = event_new.EndDateTime;
                        visit.Description__c = event_new.Description;
                        visit.Sales_Rep__c = event_new.OwnerId;
                        visit.Visit_Status__c = 'Planned';
                        visit.Activity_Id__c = event_new.Id;
                        if(event_new.WhoId != null && event_new.WhoId.getSObjectType().getDescribe().getName()=='Contact'){
                            visit.Contact__c = event_new.WhoId;
                        }
                        list_visit.add(visit);
                    }else if(event_old.WhatId == null || event_old.WhatId.getSObjectType().getDescribe().getName()!='Account') {
                        Visit__c visit = new Visit__c();
                        visit.Account__c = event_new.WhatId;
                        visit.Subject__c = event_new.Subject;
                        visit.Location__c = event_new.Location;
                        visit.Start_Time__c = event_new.StartDateTime;
                        visit.End_Time__c = event_new.EndDateTime;
                        visit.Description__c = event_new.Description;
                        visit.Sales_Rep__c = event_new.OwnerId;
                        visit.Visit_Status__c = 'Planned';
                        visit.Activity_Id__c = event_new.Id;
                        if(event_new.WhoId != null && event_new.WhoId.getSObjectType().getDescribe().getName()=='Contact'){
                            visit.Contact__c = event_new.WhoId;
                        }
                        list_visit.add(visit);
                    }else if(event_new.Subject != event_old.Subject ||
                             event_new.StartDateTime != event_old.StartDateTime ||
                             event_new.EndDateTime != event_old.EndDateTime ||
                             event_new.Description != event_old.Description ||
                             event_new.OwnerId != event_old.OwnerId ||
                             event_new.Location != event_old.Location ||
                             event_new.WhoId != event_old.WhoId) {
                        map_Id_event_update.put(event_new.Id,event_new);
                    }
                }else if(event_old.Is_Customer_Visit__c || event_old.WhatId.getSObjectType().getDescribe().getName()=='Account') {
                    map_Id_event_delete.put(event_new.Id,event_new);
                }
            }
            if(list_visit != null) {
                insert list_visit;
                for(Visit__c visit:list_visit) {
                    map_eventId_visitId.put(visit.Activity_Id__c,visit.Id);
                }
            }
            
            if(map_eventId_visitId != null) {
                for (Event event_update : [select Id , Visit__c ,Activity_Type__c from Event where Id in : map_eventId_visitId.keySet()]) {
                    event_update.Visit__c = map_eventId_visitId.get(event_update.Id);
                    event_update.Activity_Type__c = 'Visit';
                    list_event_update.add(event_update);
                }
            }
            
            if(list_event_update != null) {
                update list_event_update;
            }
            
            list_visit.clear();
            if(map_Id_event_update != null) {
                for(Visit__c visit : [Select Id,Subject__c,Account__c,Location__c,Start_Time__c,End_Time__c,Description__c,Sales_Rep__c,Visit_Status__c,Activity_Id__c
                                      From Visit__c Where Activity_Id__c in: map_Id_event_update.keySet()]) {
                    Event event_new = map_Id_event_update.get(visit.Activity_Id__c);
                    visit.Subject__c = event_new.Subject;
                    visit.Location__c = event_new.Location;
                    visit.Start_Time__c = event_new.StartDateTime;
                    visit.End_Time__c = event_new.EndDateTime;
                    visit.Description__c = event_new.Description;
                    visit.Sales_Rep__c = event_new.OwnerId;
                    visit.Visit_Status__c = 'Planned';
                    visit.Activity_Id__c = event_new.Id;
                    if(event_new.WhoId != null && event_new.WhoId.getSObjectType().getDescribe().getName()=='Contact'){
                        visit.Contact__c = event_new.WhoId;
                    }
                    list_visit.add(visit);
                }
            }
            if(list_visit != null) {
                update list_visit;
            }
            
            list_visit.clear();
            if(map_Id_event_delete != null) {
                for(Visit__c visit : [Select Id From Visit__c Where Activity_Id__c in: map_Id_event_delete.keySet()]) {
                    list_visit.add(visit);
                }
            }
            if(list_visit != null) {
                delete list_visit;
            }
        }
        if(trgCtx.isDelete){
            for(Sobject sobj : trgCtx.oldlist) {
                Event event_new = (Event)sobj;
                if(event_new.Is_Customer_Visit__c && event_new.WhatId != null && event_new.WhatId.getSObjectType().getDescribe().getName()=='Account') {
                    map_Id_event_delete.put(event_new.Id,event_new);
                }
            }
            if(map_Id_event_delete != null) {
                for(Visit__c visit : [Select Id From Visit__c Where Activity_Id__c in: map_Id_event_delete.keySet()]) {
                    list_visit.add(visit);
                }
            }
            if(list_visit != null) {
                delete list_visit;
            }
        }
    }
    
}