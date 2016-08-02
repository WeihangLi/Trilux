trigger AccountDetailsTrigger on Account_Details__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    ClsTriggerFactory.createHandler(Account_Details__c.sObjectType);
}