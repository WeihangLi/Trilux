trigger AccountTeamTrigger on Account_Team__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    ClsTriggerFactory.createHandler(Account_Team__c.sObjectType);
}