trigger TaskTrigger on Task (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    ClsTriggerFactory.createHandler(Task.sObjectType);
}