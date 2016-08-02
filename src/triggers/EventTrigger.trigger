trigger EventTrigger on Event (after insert, after update, after delete, after undelete, before insert, before update, before delete) {
    ClsTriggerFactory.createHandler(Event.sObjectType);
}