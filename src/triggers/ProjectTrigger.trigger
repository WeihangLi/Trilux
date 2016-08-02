trigger ProjectTrigger on Trilux_Project__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
     ClsTriggerFactory.createHandler(Trilux_Project__c.sObjectType);
}