/**
 *  this batch is used to management account team
 *  ES-2: R-378: Customer & Contact Management: Account Team Assignment (Online)
 *  
 *
 @author  weihang li
 @created 2016-03-07 
 @version 1.0
 @since   36.0 (Force.com ApiVersion)
 *
 @changelog
 * 2015-03-07 weihang li <weihang.li@itbconsult.com>
 * - Created    
 */
global class BatchCls_ManagementAccountTeam extends SchedulerVizArt.ClsBatchVirtual {
    global override Database.QueryLocator start(Database.BatchableContext BC){
        String querySql = 'SELECT Id FROM Account where IsExcludedFromRealign = false';
        
        return Database.getQueryLocator(querySql);
    }
    
    global override void execute(Database.BatchableContext BC, list<SObject> list_sobj) {
        list<Id> list_accIds = new list<Id>();
        for(SObject sobj: list_sobj) {
            Account acc = (Account)sobj;
            list_accIds.add(acc.Id);
        }
        ClsTerritoryManagementUtil.deleteAccountTeamMember(list_accIds);
        ClsTerritoryManagementUtil.insertAccountTeamMember(list_accIds);
        system.debug('list_accIds:::: '+list_accIds);
    }
}