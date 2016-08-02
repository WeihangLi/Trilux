/**
 * Trigger handler class for Opportunity Partner which does following actions
 * - 1. Sync standard Opportunity Partner (R-208)
 *
 * @author Yuda Zheng
 * @created 2015-12-21
 * @version 1.0
 * @since 35.0
 *
 * @changelog
 * 2015-12-21 Yuda Zheng <yuda.zheng@oinio.com>
 * - Created
 */

public class ClsTriggerOpportunityPartnerHandler extends ClsTriggerVirtual {
        
	/**
	 * @see IntHelper.beforeTrigger
	*/
	public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
		
	}
	
	/**
	 * @see IntHelper.beforeTrigger
	*/
	public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
		SyncOpportunityPartner(trgCtx);
		//added by weihang 2016-01-20
		SyncProjectPartnerRole(trgCtx);
	}
	
	/**
	 *  This function is used to Sync standard Opportunity Partner (after delete, after insert, after undelete, after update) (R-208)
	 *	
	 *
	 @author    Yuda Zheng
	 @created   2015-12-21
	 @version   1.0
	 @since     35.0 (Force.com ApiVersion)
	 *
	 @changelog
	 * 2015-12-21 Yuda Zheng <yuda.zheng@oinio.com>
	 * - Created
	*/
	@TestVisible
	private void SyncOpportunityPartner(ClsWrappers.TriggerContext trgCtx) {
		if(trgCtx.isAfter) {
			list<Partner> list_oppPartner2Insert = new list<Partner>();
			list<Partner> list_oppPartner2Delete = new list<Partner>();
			map<String, map<String, String>> map_oppId_accId_oldAccId = new map<String, map<String, String>>();
			map<String, map<String, Opportunity_Partner__c>> map_oppId_accId_oppPartnerc = new map<String, map<String, Opportunity_Partner__c>>();
			map<String, map<String, Partner>> map_oppId_accId_oppPartner = new map<String, map<String, Partner>>();
	
			if(trgCtx.isInsert || trgCtx.isUpdate){
				for(SObject sobj : trgCtx.newList) {
					Opportunity_Partner__c oppPartnerc = (Opportunity_Partner__c)sobj;
					if(trgCtx.isInsert) {
						Partner oppPartner = new Partner();
						oppPartner.OpportunityId = oppPartnerc.Opportunity__c;
						oppPartner.AccountToId = oppPartnerc.Partner_Account__c;
						oppPartner.Role = oppPartnerc.Partner_Role__c;
						oppPartner.IsPrimary = oppPartnerc.Primary__c;
						
						list_oppPartner2Insert.add(oppPartner);
						
					}else if(trgCtx.isUpdate){
						Opportunity_Partner__c oldOppPartnerc = (Opportunity_Partner__c)trgCtx.oldMap.get(oppPartnerc.Id);
						if(oldOppPartnerc.Partner_Account__c != oppPartnerc.Partner_Account__c 
						|| oldOppPartnerc.Partner_Role__c != oppPartnerc.Partner_Role__c
						|| oldOppPartnerc.Primary__c != oppPartnerc.Primary__c){
							if(!map_oppId_accId_oppPartnerc.containsKey(oppPartnerc.Opportunity__c)){
								map_oppId_accId_oppPartnerc.put(oppPartnerc.Opportunity__c, new map<String, Opportunity_Partner__c>());
							}
							map_oppId_accId_oppPartnerc.get(oppPartnerc.Opportunity__c).put(oldOppPartnerc.Partner_Account__c, oppPartnerc);
							
							if(oldOppPartnerc.Partner_Account__c != oppPartnerc.Partner_Account__c){
								if(!map_oppId_accId_oldAccId.containsKey(oppPartnerc.Opportunity__c)){
									map_oppId_accId_oldAccId.put(oppPartnerc.Opportunity__c, new map<String, String>());
								}	
								map_oppId_accId_oldAccId.get(oppPartnerc.Opportunity__c).put(oppPartnerc.Partner_Account__c, oldOppPartnerc.Partner_Account__c);
							}
						}
					}
				}
			}else if(trgCtx.isDelete){
				for(String key : trgCtx.oldMap.keySet()) {
					Opportunity_Partner__c oldOppPartnerc = (Opportunity_Partner__c)trgCtx.oldMap.get(key);
					if(!map_oppId_accId_oppPartnerc.containsKey(oldOppPartnerc.Opportunity__c)){
						map_oppId_accId_oppPartnerc.put(oldOppPartnerc.Opportunity__c, new map<String, Opportunity_Partner__c>());
					}
					map_oppId_accId_oppPartnerc.get(oldOppPartnerc.Opportunity__c).put(oldOppPartnerc.Partner_Account__c, oldOppPartnerc);
				}
			}
			
			if(!map_oppId_accId_oppPartnerc.isEmpty()){
				for(Partner oppPartner : [select id, AccountToId, OpportunityId, Role, IsPrimary from Partner where OpportunityId in: map_oppId_accId_oppPartnerc.keySet()]){
					if(!map_oppId_accId_oppPartner.containsKey(oppPartner.OpportunityId)){
						map_oppId_accId_oppPartner.put(oppPartner.OpportunityId, new map<String, Partner>());
					}
					map_oppId_accId_oppPartner.get(oppPartner.OpportunityId).put(oppPartner.AccountToId, oppPartner);
				}
			}

			for(String oppId : map_oppId_accId_oppPartnerc.keySet()){
				if(!map_oppId_accId_oppPartnerc.get(oppId).isEmpty()){
					for(String accId : map_oppId_accId_oppPartnerc.get(oppId).keySet()){
						if(map_oppId_accId_oppPartnerc.get(oppId).get(accId) != null){
							if(trgCtx.isUpdate){
								if(map_oppId_accId_oppPartner.get(oppId) != null){
									Partner oppPartner2Delete;
									
									if(map_oppId_accId_oppPartner.get(oppId).get(accId) != null){
										oppPartner2Delete = map_oppId_accId_oppPartner.get(oppId).get(accId);
									}else if(map_oppId_accId_oldAccId.get(oppId) != null
											&& map_oppId_accId_oldAccId.get(oppId).get(accId) != null
											&& map_oppId_accId_oppPartner.get(oppId).get(map_oppId_accId_oldAccId.get(oppId).get(accId)) != null){
										oppPartner2Delete = map_oppId_accId_oppPartner.get(oppId).get(map_oppId_accId_oldAccId.get(oppId).get(accId));
									}	
									
									if(oppPartner2Delete != null){
										list_oppPartner2Delete.add(oppPartner2Delete);
										
										Partner oppPartner2Insert = new Partner();
										
										oppPartner2Insert.OpportunityId = map_oppId_accId_oppPartnerc.get(oppId).get(accId).Opportunity__c;
										oppPartner2Insert.AccountToId = map_oppId_accId_oppPartnerc.get(oppId).get(accId).Partner_Account__c;
										oppPartner2Insert.Role = map_oppId_accId_oppPartnerc.get(oppId).get(accId).Partner_Role__c;
										oppPartner2Insert.IsPrimary = map_oppId_accId_oppPartnerc.get(oppId).get(accId).Primary__c;
										
										list_oppPartner2Insert.add(oppPartner2Insert);
									}
								}
							}
							if(trgCtx.isDelete){
								if(map_oppId_accId_oppPartner.get(oppId) != null 
								&& map_oppId_accId_oppPartner.get(oppId).get(accId) != null){
									list_oppPartner2Delete.add(map_oppId_accId_oppPartner.get(oppId).get(accId));
								}
							}
						}
					}
				}
			}
			
			system.debug('dddddddddd:'+list_oppPartner2Insert);
			if(!list_oppPartner2Delete.isEmpty()){
				delete list_oppPartner2Delete;
			}
			if(!list_oppPartner2Insert.isEmpty()){
				insert list_oppPartner2Insert;
			}
		}
	}
	/**
	 *  This function is used to Sync project partner role 
	 *	
	 *
	 @author    Weihang Li
	 @created   2016-01-20
	 @version   1.0
	 @since     35.0 (Force.com ApiVersion)
	 *
	 @changelog
	 * 2016-01-20 Weihang Li <weihang.li@oinio.com>
	 * - Created
	*/
	@TestVisible
	private void SyncProjectPartnerRole(ClsWrappers.TriggerContext trgCtx) {
		if(trgCtx.isAfter){
			map<Id,Opportunity_Partner__c> map_opId_insertOppPartner = new map<Id,Opportunity_Partner__c>();
			map<Id,Opportunity_Partner__c> map_opId_deleteOppPartner = new map<Id,Opportunity_Partner__c>();
			set<Id> set_oldAccIds = new set<Id>();
			set<Id> set_delAccIds = new set<Id>();
			if(trgCtx.isInsert || trgCtx.isUpdate){
				for(SObject sobj : trgCtx.newList) {
					Opportunity_Partner__c oppPartnerc = (Opportunity_Partner__c)sobj;
					if(trgCtx.isInsert){
						map_opId_insertOppPartner.put(oppPartnerc.Opportunity__c, oppPartnerc);
					}else if(trgCtx.isUpdate){
						Opportunity_Partner__c oldOppPartnerc = (Opportunity_Partner__c)trgCtx.oldMap.get(oppPartnerc.Id);
						if(oldOppPartnerc.Partner_Account__c != oppPartnerc.Partner_Account__c || 
						   oldOppPartnerc.Partner_Role__c != oppPartnerc.Partner_Role__c || 
						   oldOppPartnerc.Primary__c != oppPartnerc.Primary__c){
							map_opId_deleteOppPartner.put(oppPartnerc.Opportunity__c, oppPartnerc);
							set_oldAccIds.add(oldOppPartnerc.Partner_Account__c);
							map_opId_insertOppPartner.put(oppPartnerc.Opportunity__c, oppPartnerc);
						}
					}
				}
			}else if(trgCtx.isDelete){
				for(String key : trgCtx.oldMap.keySet()) {
					Opportunity_Partner__c oldOppPartnerc = (Opportunity_Partner__c)trgCtx.oldMap.get(key);
					map_opId_deleteOppPartner.put(oldOppPartnerc.Opportunity__c, oldOppPartnerc);
					set_delAccIds.add(oldOppPartnerc.Partner_Account__c);
				}
			}
			if(!map_opId_insertOppPartner.isEmpty() || !map_opId_deleteOppPartner.isEmpty()){
				map<String, OpportunityPartner> map_accId_OpportunityPartner = new map<String, OpportunityPartner>();
				list<Project_Partner_Role__c> list_insertProPartnerRoles = new list<Project_Partner_Role__c>();
				list<Project_Partner_Role__c> list_deleteProPartnerRoles = new list<Project_Partner_Role__c>();
				map<Id,Id> map_oppId_reProjectId = new map<Id,Id>();
				map<Id,Id> map_oppId_proId = new map<Id,Id>();
				set<Id> set_oppAccId = new set<Id>();
				for(Opportunity opp : [select Id, Related_Project__c,AccountId from Opportunity where id in:map_opId_insertOppPartner.keySet() or id in: map_opId_deleteOppPartner.keySet()]){
					set_oppAccId.add(opp.AccountId);
					map_oppId_reProjectId.put(opp.Id, opp.Related_Project__c);
		        }
		       
		        for(Project_Partner_Role__c ppr : [select Id, Account_Name__c from Project_Partner_Role__c where Project__c in: map_oppId_reProjectId.values()]){
					if((trigger.isUpdate && set_oldAccIds.contains(ppr.Account_Name__c)) || (trigger.isDelete && set_delAccIds.contains(ppr.Account_Name__c))){
						list_deleteProPartnerRoles.add(ppr);
					}
				}
				system.debug('aaaaaaaaa:'+set_oppAccId);
				system.debug('bbbbbbbbb:'+set_oppAccId);
				if(!map_opId_insertOppPartner.isEmpty()){
		        	for(Id opId : map_opId_insertOppPartner.keySet()){
		        		if(!set_oppAccId.contains(map_opId_insertOppPartner.get(opId).Partner_Account__c)){
			        		Project_Partner_Role__c ppr = new Project_Partner_Role__c();
			        		ppr.Account_Role__c = map_opId_insertOppPartner.get(opId).Partner_Role__c;
			        		ppr.Account_Name__c = map_opId_insertOppPartner.get(opId).Partner_Account__c;
			        		ppr.Is_Primary_Account__c = map_opId_insertOppPartner.get(opId).Primary__c;
				            ppr.Project__c = map_oppId_reProjectId.get(opId);
				            list_insertProPartnerRoles.add(ppr);
		        		}
		        	}
		        }
		        if(!list_deleteProPartnerRoles.isEmpty()){
		        	delete list_deleteProPartnerRoles;
		        }
		        if(!list_insertProPartnerRoles.isEmpty()){
		        	insert list_insertProPartnerRoles;
		        }
			}
		}
	}
	
}