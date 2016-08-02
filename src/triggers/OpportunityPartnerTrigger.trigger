trigger OpportunityPartnerTrigger on Opportunity_Partner__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    ClsTriggerFactory.createHandler(Opportunity_Partner__c.sObjectType);
}