trigger ContactTrigger on Contact (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    ClsTriggerFactory.createHandler(Contact.sObjectType);
}