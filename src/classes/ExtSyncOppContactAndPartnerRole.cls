/**
 * This class is used for page ExtSyncOppContactAndPartnerRole which does following actions
 * - 1. add or delete ProjectContactRole after OpportunityContactRole is added or deleted (R-85)
 * - 2. add or delete ProjectPartnerRole after OpportunityPartner is added or deleted (R-85)
 *
 * @author Yuda Zheng
 * @created 2015-12-03
 * @version 1.0
 * @since 35.0
 *
 * @changelog
 * 2015-12-03 Yuda Zheng <yuda.zheng@oinio.com>
 * - Created
 */
public with sharing class ExtSyncOppContactAndPartnerRole { 
    public Opportunity opp;
    public ExtSyncOppContactAndPartnerRole( ApexPages.StandardController stdController ) {
        opp = ( Opportunity )stdController.getRecord();     
    }
    public void syncOppContactAndPartnerRole(){ 
        ExtSyncOppContactAndPartnerRole.syncOppContactAndPartnerRoleFuture(opp.Id);    
    }
    
    @future 
    public static void syncOppContactAndPartnerRoleFuture( Id oppId) {
        String proId = '';
        for(Opportunity opp : [select Id, Related_Project__c from Opportunity where id =: oppId]){
            proId = opp.Related_Project__c;
        }
        
        if(proId != null){
            list<Project_Contact_Role__c> list_pcr2add = new list<Project_Contact_Role__c>();
            list<Project_Contact_Role__c> list_pcr2delete = new list<Project_Contact_Role__c>();
            map<String, OpportunityContactRole> map_conId_OpportunityContactRole = new map<String, OpportunityContactRole>();
            
            for(OpportunityContactRole ocr :  [ SELECT Id, ContactId, Role, IsPrimary FROM OpportunityContactRole WHERE OpportunityId = :oppId ]){
                map_conId_OpportunityContactRole.put(ocr.ContactId, ocr);
            }   
            
            for(Project_Contact_Role__c pcr : [select Id, Contact_Name__c from Project_Contact_Role__c where Project__c =: proId]){
                if(map_conId_OpportunityContactRole.containsKey(pcr.Contact_Name__c)){
                    map_conId_OpportunityContactRole.remove(pcr.Contact_Name__c);
                }else{
                    list_pcr2delete.add(pcr);
                }
            }
            
            if(!map_conId_OpportunityContactRole.isEmpty()){
                for(String conId : map_conId_OpportunityContactRole.keySet()){
                    Project_Contact_Role__c pcr = new Project_Contact_Role__c();
                    pcr.Project__c = proId;
                    pcr.Contact_Name__c = conId;
                    pcr.Is_Primary_Contact__c = map_conId_OpportunityContactRole.get(conId).IsPrimary;
                    pcr.Contact_Role__c = map_conId_OpportunityContactRole.get(conId).Role;
                    list_pcr2add.add(pcr);
                }
            }

            if(!list_pcr2add.isEmpty()) insert list_pcr2add; 
            if(!list_pcr2delete.isEmpty()) delete list_pcr2delete;
                    
        }
    }
}