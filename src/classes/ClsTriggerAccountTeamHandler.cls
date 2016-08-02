/**
 * Trigger handler class for Account Team which does following actions
 * - 1. Sync standard Account Team (R-182)
 *
 * @author Yuda Zheng
 * @created 2015-12-16
 * @version 1.0
 * @since 35.0
 *
 * @changelog
 * 2015-12-16 Yuda Zheng <yuda.zheng@oinio.com>
 * - Created
 */

public class ClsTriggerAccountTeamHandler extends ClsTriggerVirtual {
        
    /**
     * @see IntHelper.beforeTrigger
    */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        removeValForAccount(trgCtx);
    }
    
    /**
     * @see IntHelper.beforeTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        SyncAccountTeam(trgCtx);
        //added by weihang 2016-01-07
        setValToAccount(trgCtx);
    }
    /**
     *  This function is used to format the date.
     *  
     *
     @author    Weihang Li
     @created   2016-01-07
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-01-07 Weihang Li <weihang.li@itbconsult.com>
     * - Created
    */
    @TestVisible
    private String formatDate(Date theDate){
    	String year = String.valueOf(theDate.year());
    	String month = '';
    	if(theDate.month() <= 9){
    		month = '0'+theDate.month();
    	}else{
    		month = String.valueOf(theDate.month());
    	}
    	String day = '';
    	if(theDate.day() <= 9){
    		day = '0'+theDate.day();
    	}else{
    		day = String.valueOf(theDate.day());
    	}
    	String returnStr = year + '-' + month + '-' + day;
    	return returnStr;
    }
    /**
     *  This function is used to remove value to account(before delete) (R-241)
     *  
     *
     @author    Weihang Li
     @created   2016-01-07
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-01-07 Weihang Li <weihang.li@itbconsult.com>
     * - Created
    */
    @TestVisible
    private void removeValForAccount(ClsWrappers.TriggerContext trgCtx){
        if(trgCtx.isBefore && trgCtx.isDelete){
            map<Id,String> map_accId_appStr = new map<Id,String>();
            for(SObject sobj:trgCtx.oldList){
                Account_Team__c accTeam = (Account_Team__c)sobj;
                if(accTeam.Next_Visit_Date_Proposal__c != null){
                    String nvdProposal = formatDate(accTeam.Next_Visit_Date_Proposal__c);
                    String appendStr = String.valueOf(accTeam.Team_Member__c).substring(0,15) + ';' + nvdProposal;
                    map_accId_appStr.put(accTeam.Account__c, appendStr);
                }
            }
            if(!map_accId_appStr.isEmpty()){
                list<Account> list_updateAccounts = new list<Account>();
                for(Account acc:[select Id,Name,User_Proposed_Visit_Dates__c from Account where Id in:map_accId_appStr.keySet()]){
                    String currentStr = acc.User_Proposed_Visit_Dates__c;
                    String delStr = map_accId_appStr.get(acc.Id)+',';
                    if(currentStr != '' && currentStr != null && currentStr.indexOf(delStr) > -1){
                        acc.User_Proposed_Visit_Dates__c = currentStr.replace(delStr,'');
                        list_updateAccounts.add(acc);
                    }
                }
                if(!list_updateAccounts.isEmpty()) update list_updateAccounts;
            }
        }
    }
    /**
     *  This function is used to set value to account(after update, after insert) (R-241)
     *  
     *
     @author    Weihang Li
     @created   2016-01-07
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-01-07 Weihang Li <weihang.li@itbconsult.com>
     * - Created
    */
    @TestVisible
    private void setValToAccount(ClsWrappers.TriggerContext trgCtx){
        if(trgCtx.isAfter && (trgCtx.isInsert || trgCtx.isUpdate)){
            map<Id,String> map_accId_oldStr = new map<Id,String>();
            map<Id,String> map_accId_newStr = new map<Id,String>();
            set<Id> set_AccTeamIds = new set<Id>();
            for(SObject sobj:trgCtx.newList){
                Account_Team__c accTeam = (Account_Team__c)sobj;
                String newAppendStr = ''; 
                if(trgCtx.isInsert){
                    if(accTeam.Next_Visit_Date_Proposal__c != null){
                        String nvdProposal = formatDate(accTeam.Next_Visit_Date_Proposal__c);
                        newAppendStr = String.valueOf(accTeam.Team_Member__c).substring(0,15) + ';' + nvdProposal;
                        map_accId_newStr.put(accTeam.Account__c, newAppendStr);
                    }
                }else if(trgCtx.isUpdate){
                    Account_Team__c oldAccTeam = (Account_Team__c)trgCtx.oldMap.get(accTeam.Id);
                    if(accTeam.Next_Visit_Date_Proposal__c !=  oldAccTeam.Next_Visit_Date_Proposal__c){
                        String oldAppendStr = '';
                        String nvdProposal = '';
                        if(oldAccTeam != null && oldAccTeam.Next_Visit_Date_Proposal__c != null){
                        	nvdProposal = formatDate(oldAccTeam.Next_Visit_Date_Proposal__c);
                        }
                        newAppendStr = String.valueOf(accTeam.Team_Member__c).substring(0,15) + ';' + nvdProposal;
                        oldAppendStr = String.valueOf(oldAccTeam.Team_Member__c).substring(0,15) + ';' + nvdProposal;
                        map_accId_oldStr.put(accTeam.Account__c, oldAppendStr);
                        set_AccTeamIds.add(accTeam.Id);
                    }
                }
            }
            if(!map_accId_oldStr.isEmpty() || !map_accId_newStr.isEmpty()){
                if(!set_AccTeamIds.isEmpty()){
                    for(Account_Team__c atm:[select Id,name,Next_Visit_Date_Proposal__c,Team_Member__c,Account__c from Account_Team__c where id in: set_AccTeamIds]){
                        String nvdProposal = atm.Next_Visit_Date_Proposal__c != null ? formatDate(atm.Next_Visit_Date_Proposal__c) : '';
                        String newAppendStr = String.valueOf(atm.Team_Member__c).substring(0,15) + ';' + nvdProposal;
                        map_accId_newStr.put(atm.Account__c, newAppendStr);
                    }
                }
                list<Account> list_updateAccounts = new list<Account>();
                for(Account acc:[select Id,Name,User_Proposed_Visit_Dates__c from Account where Id in: map_accId_newStr.keySet()]){
                    String oldStr = map_accId_oldStr.get(acc.Id);
                    String newStr = map_accId_newStr.get(acc.Id);
                    if(acc.User_Proposed_Visit_Dates__c != null && acc.User_Proposed_Visit_Dates__c != ''){
                        if(oldStr != null && oldStr != '' && acc.User_Proposed_Visit_Dates__c.indexOf(oldStr) > -1 && trgCtx.isUpdate){
                            acc.User_Proposed_Visit_Dates__c = acc.User_Proposed_Visit_Dates__c.replace(oldStr, newStr);
                        }else{
                            acc.User_Proposed_Visit_Dates__c += newStr+','; 
                        }
                    }else{
                        acc.User_Proposed_Visit_Dates__c = newStr+',';
                    }
                    list_updateAccounts.add(acc);   
                }
                if(!list_updateAccounts.isEmpty()) update list_updateAccounts;
            }
        }
    }
    /**
     *  This function is used to Sync standard Account Team (after delete, after insert, after undelete, after update) (R-182)
     *  
     *
     @author    Yuda Zheng
     @created   2015-12-16
     @version   1.0
     @since     35.0 (Force.com ApiVersion)
     *
     @changelog
     * 2015-12-16 Yuda Zheng <yuda.zheng@oinio.com>
     * - Created
    */
    @TestVisible
    private void SyncAccountTeam(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isAfter) {
            
            list<AccountTeamMember> list_accTeamMember2Insert = new list<AccountTeamMember>();
            list<AccountTeamMember> list_accTeamMember2Update = new list<AccountTeamMember>();
            list<AccountTeamMember> list_accTeamMember2Delete = new list<AccountTeamMember>();
            map<String, map<String, Account_Team__c>> map_accId_userId_accTeam = new map<String, map<String, Account_Team__c>>();
            map<String, map<String, AccountTeamMember>> map_accId_userId_accTeamMember = new map<String, map<String, AccountTeamMember>>();
            
            if(trgCtx.isInsert || trgCtx.isUpdate){
                for(SObject sobj : trgCtx.newList) {
                    Account_Team__c accTeam = (Account_Team__c)sobj;
                    if(trgCtx.isInsert) {
                        AccountTeamMember accTeamMember = new AccountTeamMember();
                        accTeamMember.AccountId = accTeam.Account__c;
                        accTeamMember.UserId = accTeam.Team_Member__c;
                        accTeamMember.TeamMemberRole = accTeam.Team_Role__c;
                        
                        list_accTeamMember2Insert.add(accTeamMember);
                        
                    }else if(trgCtx.isUpdate){
                        Account_Team__c oldAccTeam = (Account_Team__c)trgCtx.oldMap.get(accTeam.Id);
                        if(oldAccTeam.Team_Member__c != accTeam.Team_Member__c || oldAccTeam.Team_Role__c != accTeam.Team_Role__c){
                            if(!map_accId_userId_accTeam.containsKey(accTeam.Account__c)){
                                map_accId_userId_accTeam.put(accTeam.Account__c, new map<String, Account_Team__c>());
                            }
                            map_accId_userId_accTeam.get(accTeam.Account__c).put(accTeam.Team_Member__c, accTeam);
                        }
                    }
                }
            }else if(trgCtx.isDelete){
                for(String key : trgCtx.oldMap.keySet()) {
                    Account_Team__c oldAccTeam = (Account_Team__c)trgCtx.oldMap.get(key);
                    if(!map_accId_userId_accTeam.containsKey(oldAccTeam.Account__c)){
                        map_accId_userId_accTeam.put(oldAccTeam.Account__c, new map<String, Account_Team__c>());
                    }
                    map_accId_userId_accTeam.get(oldAccTeam.Account__c).put(oldAccTeam.Team_Member__c, oldAccTeam);
                }
            }
            
            //get AccountTeamMember map
            if(!map_accId_userId_accTeam.isEmpty()){
                for(AccountTeamMember accTeamMember : [select Id, AccountId, UserId, TeamMemberRole from AccountTeamMember where AccountId in: map_accId_userId_accTeam.keySet()]) {
                    if(!map_accId_userId_accTeamMember.containsKey(accTeamMember.AccountId)){
                        map_accId_userId_accTeamMember.put(accTeamMember.AccountId, new map<String, AccountTeamMember>());
                    }
                    map_accId_userId_accTeamMember.get(accTeamMember.AccountId).put(accTeamMember.UserId, accTeamMember);
                }
                
                for(String accId : map_accId_userId_accTeam.keySet()){
                    if(!map_accId_userId_accTeam.get(accId).isEmpty()){
                        for(String userId : map_accId_userId_accTeam.get(accId).keySet()){
                            if(map_accId_userId_accTeamMember.get(accId) != null){
                                if(map_accId_userId_accTeamMember.get(accId).get(userId) != null){
                                    AccountTeamMember accTeamMember = map_accId_userId_accTeamMember.get(accId).get(userId);
                                    if(trgCtx.isUpdate){
                                        if(map_accId_userId_accTeamMember.get(accId).get(userId).TeamMemberRole != map_accId_userId_accTeam.get(accId).get(userId).Team_Role__c){
                                            accTeamMember.TeamMemberRole = map_accId_userId_accTeam.get(accId).get(userId).Team_Role__c;
                                            list_accTeamMember2Update.add(accTeamMember);
                                        }
                                        
                                    }
                                    if(trgCtx.isDelete){
                                        list_accTeamMember2Delete.add(accTeamMember);
                                    }
                                    map_accId_userId_accTeamMember.get(accId).remove(userId);
                                }else{
                                    if(trgCtx.isUpdate){
                                        AccountTeamMember accTeamMember = new AccountTeamMember();
                                        accTeamMember.AccountId = map_accId_userId_accTeam.get(accId).get(userId).Account__c;
                                        accTeamMember.UserId = map_accId_userId_accTeam.get(accId).get(userId).Team_Member__c;
                                        accTeamMember.TeamMemberRole = map_accId_userId_accTeam.get(accId).get(userId).Team_Role__c;
                                        
                                        list_accTeamMember2Insert.add(accTeamMember);
                                    }
                                }
                            }
                        }
                    }
                }
                
                if(!map_accId_userId_accTeamMember.isEmpty() && trgCtx.isUpdate){
                    for(String accId : map_accId_userId_accTeamMember.keySet()){
                        list_accTeamMember2Delete.addAll(map_accId_userId_accTeamMember.get(accId).values());
                    }
                }
            }
            
            if(!list_accTeamMember2Insert.isEmpty()){
                insert list_accTeamMember2Insert;
                //grantAccountShare(list_accTeamMember2Insert);
            }
            if(!list_accTeamMember2Update.isEmpty()){
                update list_accTeamMember2Update;
            }
            if(!list_accTeamMember2Delete.isEmpty()){
                delete list_accTeamMember2Delete;
            }
            
        }   
    }
    
    /**
     *  This function is used to add Account Share (R-182)
     *  
     *
     @author    Yuda Zheng
     @created   2015-12-16
     @version   1.0
     @since     35.0 (Force.com ApiVersion)
     *
     @changelog
     * 2015-12-16 Yuda Zheng <yuda.zheng@oinio.com>
     * - Created
    */
    /**@TestVisible
    private void grantAccountShare(list<AccountTeamMember> list_accTeamMember2Insert) {
        list<AccountShare> list_AccountShare2Update= new list<AccountShare>();
        map<String, set<String>> map_accountId_userIds = new map<String, set<String>>();
        
        for(AccountTeamMember accTeamMember : list_accTeamMember2Insert){
            if(!map_accountId_userIds.containsKey(accTeamMember.AccountId)){
                map_accountId_userIds.put(accTeamMember.AccountId, new set<String>());
            }
            map_accountId_userIds.get(accTeamMember.AccountId).add(accTeamMember.UserId);
        }
        
        for(AccountShare accShare : [select Id, AccountId, Account.OwnerId, UserOrGroupId, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, RowCause from AccountShare where AccountId in: map_accountId_userIds.keySet()]){
            if(accShare.RowCause == 'Team' && accShare.UserOrGroupId != accShare.Account.OwnerId
            && map_accountId_userIds.containsKey(accShare.AccountId) 
            && map_accountId_userIds.get(accShare.AccountId).contains(accShare.UserOrGroupId)){
                accShare.AccountAccessLevel = 'Edit';
                accShare.OpportunityAccessLevel = 'Read';
                accShare.CaseAccessLevel = 'Read';
                list_AccountShare2Update.add(accShare);
            }
        }
        
        if(!list_AccountShare2Update.isEmpty()){
            update list_AccountShare2Update;
        }
    }**/

}