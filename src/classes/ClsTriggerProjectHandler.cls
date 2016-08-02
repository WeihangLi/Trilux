/**
 * Trigger handler class for Project which does following actions
 * - 1. prevernt to delete project if has at least one related Opportunity (R-406)
 * - 2. set Trilux Project Sales_Region__c = Territory_Data__c.Sales_Region__c (R-654)
 *
 * @author Yuda Zheng
 * @created 2016-02-14
 * @version 1.0
 * @since 35.0
 *
 * @changelog
 * 2016-02-14 Yuda Zheng <yuda.zheng@oinio.com>
 * - Created
 */
public class ClsTriggerProjectHandler extends ClsTriggerVirtual {
        
    /**
     * @see IntHelper.beforeTrigger
    */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        validateOpportunities(trgCtx);
        //added lili zhao 2016-04-21 begin
        setProjectSalesRegion(trgCtx);        
        //end
    }
    
    /**
     * @see IntHelper.beforeTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        
    }
    
    /**
     *  This function is used to prevernt to delete project if has at least one related Opportunity  (R-406)
     *  
     *
     @author    Yuda Zheng
     @created   2016-02-14
     @version   1.0
     @since     35.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-02-14 Yuda Zheng <yuda.zheng@itbconsult.com>
     * - Created
    */
    @TestVisible
    private void validateOpportunities(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isBefore) {
            if(trgCtx.isDelete){
                system.debug('isDelete:');
                map<String, list<Opportunity>> map_proId_listOpp = new map<String, list<Opportunity>>();
                
                for(SObject sobj : trgCtx.oldList) {
                    Trilux_Project__c project = (Trilux_Project__c)sobj;
                    map_proId_listOpp.put(project.Id, new list<Opportunity>());
                }
                system.debug('map_proId_listOpp:' + map_proId_listOpp);
                if(!map_proId_listOpp.isEmpty()){
                    //get map Project Opportunity
                    for(Opportunity opp : [select Id, StageName, Related_Project__c from Opportunity where Related_Project__c in: map_proId_listOpp.keySet()]) {
                        if(map_proId_listOpp.containsKey(opp.Related_Project__c)) {
                            map_proId_listOpp.get(opp.Related_Project__c).add(opp);
                        }
                    }
                    system.debug('map_proId_listOpp:' + map_proId_listOpp);
                    for(SObject sobj : trgCtx.oldList) {
                        Trilux_Project__c project = (Trilux_Project__c)sobj;
                        system.debug('project.Id:' + project.Id);
                        if(map_proId_listOpp.containsKey(project.Id) && !map_proId_listOpp.get(project.Id).isEmpty()){
                            project.addError(Label.DeleteProjectError);
                            return;
                        }
                    }
                }
            }
        }   
    }
    
    /**
     *  This function is used to set Trilux Project Sales_Region__c = Territory_Data__c.Sales_Region__c
     *  
     *
     @author    Lili Zhao
     @created   2016-04-21
     @version   1.0
     @since     35.0 (Force.com ApiVersion)
     *
     @changelog
     * 2016-04-21 Lili Zhao <lili.zhao@itbconsult.com>
     * - Created
    */
    @TestVisible
    private void setProjectSalesRegion(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isBefore && (trgCtx.isInsert || trgCtx.isUpdate)) {
            map<String, list<Trilux_Project__c>> map_postCode_list_projects = new map<String, list<Trilux_Project__c>>();
            map<String, Territory_Data__c > map_plz_Territory_Data = new map<String, Territory_Data__c >();
            set<String> set_country = new set<String>();
            
            for(SObject sobj : trgCtx.newList) {
                Trilux_Project__c project = (Trilux_Project__c)sobj;
                Trilux_Project__c oldProject = new Trilux_Project__c();
                if(trgCtx.isUpdate) oldProject = (Trilux_Project__c)trgCtx.oldMap.get(project.Id);   
                project.Sales_Region__c = null;

                //the Project_Location_Postal_Code have changed for update or insert
                if(((trgCtx.isUpdate && project.Project_Location_Postal_Code__c != oldProject.Project_Location_Postal_Code__c ) || 
                    trgCtx.isInsert ) && project.Project_Location_Postal_Code__c != null) {
                    if(!map_postCode_list_projects.containsKey(project.Project_Location_Postal_Code__c)) {
                        map_postCode_list_projects.put(project.Project_Location_Postal_Code__c, new list<Trilux_Project__c>());
                    }
                    map_postCode_list_projects.get(project.Project_Location_Postal_Code__c).add(project);
                    if(project.Project_Location_Country__c != null){
                        set_country.add(project.Project_Location_Country__c);
                    }
                }                   
            }

            if(!map_postCode_list_projects.isEmpty()){
                //get map Project Opportunity
                for(Territory_Data__c teData : [select PLZ__c, Sales_Region__c, Country__c 
                                                from Territory_Data__c where Country__c in: set_country
                                                and Sales_Region__c != null and PLZ__c != null]) {
                                                /**where PLZ__c in: map_postCode_list_projects.keySet()
                                                And Sales_Region__c != null
                                                And PLZ__c != null]) {**/
                    map_plz_Territory_Data.put(teData.PLZ__c, teData);
                }

                for(String postCode : map_postCode_list_projects.keySet()) {
                    for(String plz : map_plz_Territory_Data.keySet()){
                        if(postCode.indexOf(plz) == 0){
                            for(Trilux_Project__c project : map_postCode_list_projects.get(postCode)) {
                                if(project.Project_Location_Country__c == map_plz_Territory_Data.get(plz).Country__c){
                                    project.Sales_Region__c = map_plz_Territory_Data.get(plz).Sales_Region__c;
                                }
                            }
                        }
                    }
                    /**if(map_plz_saleRegion.containsKey(postCode)) {
                        for(Trilux_Project__c project : map_postCode_list_projects.get(postCode)) {
                            project.Sales_Region__c = map_plz_saleRegion.get(postCode);
                        }
                    }**/
                }
            }                       
        }   
    }
}