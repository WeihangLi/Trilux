/**
 *   This trigger is used to management account team member
 *
 * @author      weihang li
 * @created     2016-03-04
 * @since       29.0    
 * @version     1.0                                                                
 * 
 * @changelog
 * 2016-03-04 weihang li <weihang.li@oinio.com>
 * - Created
 *    
 */ 
public with sharing class ClsTriggerUserTerritory2AssociatHandler extends ClsTriggerVirtual{
    /**
    * @see IntHelper.beforeTrigger
    */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        delAccTeam(trgCtx);
    }
    
    /**
    * @see IntHelper.beforeTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        insertAccountTeam(trgCtx);
    }
    /**
     *  This function is used to ES-2: R-378: Customer & Contact Management: Account Team Assignment (Online)
     *  
     *
     @author    weihang li
     @created   2016-03-04
     @version   1.0
     @since     35.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-03-04 weihang li <weihang.li@oinio.com>
     * - Created
    */
    @TestVisible
    public static void insertAccountTeam(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isInsert){
            set<Id> set_Territory2Ids = new set<Id>();
            map<Id,list<UserTerritory2Association>> map_terId_userTerAsso = new map<Id,list<UserTerritory2Association>>();
            set<Id> set_userTerIds = new set<Id>();
            for(SObject sobj : trgCtx.newList){
                UserTerritory2Association u2a = (UserTerritory2Association)sobj;
                set_Territory2Ids.add(u2a.Territory2Id);
                set_userTerIds.add(u2a.Id);
            }
            doInsert(set_userTerIds,set_Territory2Ids);
        }
    }
     
    @future
    public static void doInsert(set<Id> set_userTerIds, set<Id> set_Territory2Ids) {
        if(!set_Territory2Ids.isEmpty()){
            map<Id,list<Id>> map_terId_accIds = new map<Id,list<Id>>();
            set<Id> set_obIds = new set<Id>();
            set<Id> set_acIds = new set<Id>();
            for(ObjectTerritory2Association ob:[select Id,ObjectId,Territory2Id from ObjectTerritory2Association where Territory2Id in: set_Territory2Ids]){
                set_obIds.add(ob.ObjectId);
            }
            for(Account acc:[select Id,Name,IsExcludedFromRealign from Account where id in: set_obIds and IsExcludedFromRealign = false]){
                set_acIds.add(acc.Id);
            }
            set<Id> set_accountIds = new set<Id>();
            for(ObjectTerritory2Association ob:[select Id,ObjectId,Territory2Id from ObjectTerritory2Association where Territory2Id in: set_Territory2Ids and ObjectId in: set_acIds]){
                if(!map_terId_accIds.containsKey(ob.ObjectId)){
                    map_terId_accIds.put(ob.Territory2Id,new list<Id>());
                }
                map_terId_accIds.get(ob.Territory2Id).add(ob.ObjectId);
                set_accountIds.add(ob.ObjectId);
            }
            
            if(!map_terId_accIds.isEmpty()){
                //for(SObject sobj : trgCtx.newList){
                list<Account_Team__c> list_insertList = new list<Account_Team__c>();
                for(UserTerritory2Association u2a:[select Id, IsActive, LastModifiedById, LastModifiedDate, RoleInTerritory2, SystemModstamp, Territory2Id, UserId,User.VKORG__c from UserTerritory2Association where id in: set_userTerIds]){  
                    //UserTerritory2Association u2a = (UserTerritory2Association)sobj;
                    system.debug('bbbbbbbbbbbbbbbbbbb:'+u2a);
                    
                    for(Id aId:map_terId_accIds.get(u2a.Territory2Id)){
                        if(u2a.User.VKORG__c != '' && u2a.User.VKORG__c != null){
                            Account_Team__c atm = new Account_Team__c();
                            atm.Account__c = aId;
                            atm.SORG__c = u2a.User.VKORG__c;
                            atm.Team_Member__c = u2a.UserId;
                            atm.Team_Role__c = u2a.RoleInTerritory2;
                            atm.Created_Automatically__c = true;
                            list_insertList.add(atm);
                        }
                    }
                }
                if(!list_insertList.isEmpty()) insert list_insertList;
                
            }
        }
    }
    
    /**
     *  This function is used to ES-2: R-378: Customer & Contact Management: Account Team Assignment (Online)
     *  
     *
     @author    weihang li
     @created   2016-03-04
     @version   1.0
     @since     35.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-03-04 weihang li <weihang.li@oinio.com>
     * - Created
    */
    @TestVisible
    public void delAccTeam(ClsWrappers.TriggerContext trgCtx){
        if(trgCtx.isDelete){
            set<Id> set_Territory2Ids = new set<Id>();
            for(SObject sobj : trgCtx.oldList) {
                UserTerritory2Association u2a = (UserTerritory2Association)sobj;
                set_Territory2Ids.add(u2a.Territory2Id);
            }
            deleteAccountTeam(set_Territory2Ids);
        }
    }
    @future
    public static void deleteAccountTeam(set<Id> set_Territory2Ids) {
        /*if(trgCtx.isDelete){
            set<Id> set_Territory2Ids = new set<Id>();
            for(SObject sobj : trgCtx.oldList) {
                UserTerritory2Association u2a = (UserTerritory2Association)sobj;
                set_Territory2Ids.add(u2a.Territory2Id);
            }*/
            if(!set_Territory2Ids.isEmpty()){
                map<Id,list<Id>> map_terId_accIds = new map<Id,list<Id>>();
                set<Id> set_obIds = new set<Id>();
                system.debug('aaaaaaaa');
                for(ObjectTerritory2Association ob:[select Id,ObjectId,Territory2Id from ObjectTerritory2Association where Territory2Id in: set_Territory2Ids]){
                    set_obIds.add(ob.ObjectId);
                }
                system.debug('bbbbbbbbbbbb'+set_obIds);
                if(!set_obIds.isEmpty())
                    delete [select Id,Name from Account_Team__c where Account__c in: set_obIds and Account__r.IsExcludedFromRealign = false and Created_Automatically__c = true];

            }
        //}
    }
}