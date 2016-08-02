/**
 *   This is used to management account team member
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
 
public with sharing class ClsTerritoryManagementUtil {
    //********************************* -=BEGIN public members=- ************************************
    public static boolean isOpportunityTriggerRun = false;
    //********************************* -=END public members=- **************************************
    /**
    * This method is used to insert account team member
    *
    @author weihang li 
    @created 2016-03-04
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    @changelog
    * 2016-03-04 weihang li <weihang.li@oinio.com>
    * - Created
    */
    public static void insertAccountTeamMember(list<ID> list_accIds){
        set<Id> set_accIds = new set<Id>();
        for(ID aId:list_accIds){
            set_accIds.add(aId);
        }
        if(!set_accIds.isEmpty()){
        	map<String, set<String>> map_accId_mainAccManagerSorg = new map<String, set<String>>();
        	for(Account acc : [select Id, Main_Acc_Manager_Count_0001__c, Main_Acc_Manager_Count_0009__c, Main_Acc_Manager_Count_0031__c, 
        	 	Main_Acc_Manager_Count_0032__c , Main_Acc_Manager_Count_0033__c, Main_Acc_Manager_Count_0034__c, Main_Acc_Manager_Count_0035__c,
        	 	Main_Acc_Manager_Count_0047__c, Main_Acc_Manager_Count_0057__c, Main_Acc_Manager_Count_0058__c from Account where Id in: set_accIds]){
        		set<String> set_sorg = new set<String>();
        		if(acc.Main_Acc_Manager_Count_0001__c >=1){
        			set_sorg.add('0001');
        		}
        		if(acc.Main_Acc_Manager_Count_0009__c >=1){
        			set_sorg.add('0009');
        		}
        		if(acc.Main_Acc_Manager_Count_0031__c >=1){
        			set_sorg.add('0031');
        		}
        		if(acc.Main_Acc_Manager_Count_0032__c >=1){
        			set_sorg.add('0032');
        		}
        		if(acc.Main_Acc_Manager_Count_0033__c >=1){
        			set_sorg.add('0033');
        		}
        		if(acc.Main_Acc_Manager_Count_0034__c >=1){
        			set_sorg.add('0034');
        		}
        		if(acc.Main_Acc_Manager_Count_0035__c >=1){
        			set_sorg.add('0035');
        		}
        		if(acc.Main_Acc_Manager_Count_0047__c >=1){
        			set_sorg.add('0047');
        		}
        		if(acc.Main_Acc_Manager_Count_0057__c >=1){
        			set_sorg.add('0057');
        		}
        		if(acc.Main_Acc_Manager_Count_0058__c >=1){
        			set_sorg.add('0058');
        		}
        		
        		map_accId_mainAccManagerSorg.put(acc.Id, set_sorg);
        	}
        	
			map<Id,list<Id>> map_territoryId_accIds = new map<Id,list<Id>>();
            list<Account_Team__c> list_insertAccTeam = new list<Account_Team__c>();
            for(ObjectTerritory2Association ot2a : [Select Id, Territory2Id, ObjectId from ObjectTerritory2Association where ObjectId in: map_accId_mainAccManagerSorg.keySet()]){
                if(!map_territoryId_accIds.containsKey(ot2a.Territory2Id)){
                    map_territoryId_accIds.put(ot2a.Territory2Id,new list<ID>());
                }
                map_territoryId_accIds.get(ot2a.Territory2Id).add(ot2a.ObjectId);
            }
            map<Id,set<Id>> map_accId_userIds = new map<Id,set<Id>>();
            if(!map_territoryId_accIds.isEmpty()){
                for(UserTerritory2Association ust : [select Id, IsActive, LastModifiedById, LastModifiedDate, RoleInTerritory2, SystemModstamp, Territory2Id, UserId, User.VKORG__c from UserTerritory2Association where Territory2Id in: map_territoryId_accIds.keySet()]){
                    for(ID acId : map_territoryId_accIds.get(ust.Territory2Id)){
                        if(ust.User.VKORG__c != '' && ust.User.VKORG__c != null && (!map_accId_mainAccManagerSorg.containsKey(acId) 
                        || (map_accId_mainAccManagerSorg.containsKey(acId) && !map_accId_mainAccManagerSorg.get(acId).contains(ust.User.VKORG__c)))){
                            Account_Team__c atm = new Account_Team__c();
                            atm.Account__c = acId;
                            atm.SORG__c = ust.User.VKORG__c;
                            atm.Team_Member__c = ust.UserId;
                            atm.Team_Role__c = ust.RoleInTerritory2;
                            atm.Created_Automatically__c = true;
                            list_insertAccTeam.add(atm);
                            if(!map_accId_userIds.containsKey(acId)){
                                map_accId_userIds.put(acId,new set<Id>());
                            }
                            map_accId_userIds.get(acId).add(ust.UserId);
                        }
                    }
                }
            }
            
            if(!map_accId_userIds.isEmpty()){
            	/*
                list<Account> list_accounts = new list<Account>();
                for(Account acc:[select Id,Name,OwnerId from Account where Id in: map_accId_userIds.keySet()]){
                    if(!map_accId_userIds.get(acc.Id).contains(acc.OwnerId)){
                        list<Id> list_Ids = new list<Id>();
                        list_Ids.addAll(map_accId_userIds.get(acc.Id));
                        acc.OwnerId = list_Ids.get(0);
                        list_accounts.add(acc);
                    }
                }
                if(!list_accounts.isEmpty()) {
                    update list_accounts;
                }
                */
                updateAccount(map_accId_userIds);
            }
            if(!list_insertAccTeam.isEmpty()) insert list_insertAccTeam;
            
        }
    }
    
    /**
    * this method is used to delete account team member
    *
    @author weihang li 
    @created 2016-03-04
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    @changelog
    * 2016-03-04 weihang li <weihang.li@oinio.com>
    * - Created
    */
    public static void updateAccount(map<Id,set<Id>> map_accId_userIds){
    	list<Account> list_accounts = new list<Account>();
        for(Account acc:[select Id,Name,OwnerId from Account where Id in: map_accId_userIds.keySet()]){
            if(!map_accId_userIds.get(acc.Id).contains(acc.OwnerId)){
                list<Id> list_Ids = new list<Id>();
                list_Ids.addAll(map_accId_userIds.get(acc.Id));
                acc.OwnerId = list_Ids.get(0);
                list_accounts.add(acc);
            }
        }
        if(!list_accounts.isEmpty()) {
            update list_accounts;
        }
    }
    /**
    * this method is used to delete account team member
    *
    @author weihang li 
    @created 2016-03-04
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    @changelog
    * 2016-03-04 weihang li <weihang.li@oinio.com>
    * - Created
    */
    public static void deleteAccountTeamMember(list<ID> list_accIds){
        set<Id> set_accIds = new set<Id>();
        for(Account acc: [select Id,Name,BillingPostalcode from Account where Id in:list_accIds]){
            set_accIds.add(acc.Id);
        }
        if(!set_accIds.isEmpty()){
            delete [select Id,Name,Account__c from Account_Team__c where Account__c in: set_accIds and Created_Automatically__c = true];
        }
        
    }
}