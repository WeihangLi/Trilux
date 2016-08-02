trigger Opportunity_Team_MemberTrigger on Opportunity_Team_Member__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
     ClsTriggerFactory.createHandler(Opportunity_Team_Member__c.sObjectType); 
}