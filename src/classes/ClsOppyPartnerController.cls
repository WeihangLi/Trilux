/**
 *  StroyId: R-468 
 *  Project & Opportunity Mgmt: Opportunity Partners and Contact Roles (Online)
 *
 @author  Tony
 @ 2016-2-29
 @version 1.0
 *
 * - Created    
 */ 
public class ClsOppyPartnerController {
    
    @AuraEnabled
    public static List<OpportunityContactRole> ContactListByAccountId(String aId){
        
        List<OpportunityContactRole> contactList = New List<OpportunityContactRole>();
        //[select Id,FirstName from Contact where AccountId=:aId];
        return contactList;
    }
    
    @AuraEnabled
    public static ResponsesInfo saveOppyPartnerAndConRole(Opportunity_Partner__c oppyPartner, list<OpportunityContactRole> list_oppyContactRoles, OpportunityContactRole conRole2, OpportunityContactRole conRole3, OpportunityContactRole conRole4, OpportunityContactRole conRole5){
        ResponsesInfo info = new ResponsesInfo();
        list<OpportunityContactRole> list_oppyConRoles = new list<OpportunityContactRole>();
        try{                    
            insert oppyPartner;

            if(conRole2.ContactId != null && conRole2.Role != null) {
                //conList.push(conRole2);
                conRole2.OpportunityId = oppyPartner.Opportunity__c;
                list_oppyConRoles.add(conRole2);
            }
            if(conRole3.ContactId != null && conRole3.Role != null) {
                conRole3.OpportunityId = oppyPartner.Opportunity__c;
                list_oppyConRoles.add(conRole3);
            }
            if(conRole4.ContactId != null && conRole4.Role != null) {
                conRole4.OpportunityId = oppyPartner.Opportunity__c;
                list_oppyConRoles.add(conRole4);
            }
            if(conRole5.ContactId != null && conRole5.Role != null) {
                conRole5.OpportunityId = oppyPartner.Opportunity__c;
                list_oppyConRoles.add(conRole5);
            }
            system.debug('list_oppyConRoles::: '+ list_oppyConRoles);
            if(list_oppyConRoles.size() > 0) {                
                insert list_oppyConRoles;
            }
            info.success = true;
            info.partnerId = oppyPartner.Opportunity__c;
            return info;
        }
        catch(Exception ex){
            info.success = false;
            info.errorMessage = ex.getMessage();
            return info;
        } 
        
    }
    
    @AuraEnabled
    public static PickListWrapper initOppyPicklist(){
        Schema.DescribeFieldResult fieldResult;
        
        PickListWrapper pw = new PickListWrapper(); 
        fieldResult = Opportunity_Partner__c.Partner_Role__c.getDescribe();
        pw.partnerRoleList = getPicklist(fieldResult);
        
        fieldResult = OpportunityContactRole.Role.getDescribe();
        pw.oppyConRoleList = getPicklist(fieldResult);
        return pw;
    }
    
    public class CustomSelectOption{
        @AuraEnabled
        String label {get; set;}
        @AuraEnabled
        String value {get; set;}
        CustomSelectOption(String v, String k){
            value = v;
            label = k;          
        }
    }
    
    public class ResponsesInfo{
        @AuraEnabled
        Boolean success {get;set;}
        @AuraEnabled
        String errorMessage {get;set;} 
        @AuraEnabled
        String partnerId {get;set;}
        ResponsesInfo(){
            this.success = false;         
        }
    }
    
    public class PickListWrapper{
        
        @AuraEnabled
        List<CustomSelectOption> partnerRoleList {get; set;}
        @AuraEnabled
        List<CustomSelectOption> oppyConRoleList {get; set;}
    }
    private static List<CustomSelectOption>  getPicklist(Schema.DescribeFieldResult fieldResult){
        
        List<CustomSelectOption> options = new List<CustomSelectOption>();
        
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new CustomSelectOption(f.getValue(), f.getLabel()));
        }       
        return options;
    }
}