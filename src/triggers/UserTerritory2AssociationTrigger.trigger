trigger UserTerritory2AssociationTrigger on UserTerritory2Association (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    ClsTriggerFactory.createHandler(UserTerritory2Association.sObjectType);
}