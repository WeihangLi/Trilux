trigger UserTrigger on User (after insert, after update, after delete, after undelete, before insert, before update, before delete) {
    ClsTriggerFactory.createHandler(User.sObjectType);
}