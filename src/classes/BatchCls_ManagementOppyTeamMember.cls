/**
 *  
 *
 @author  weihang li
 @created 2016-03-29    
 @version 1.0
 @since   36.0 (Force.com ApiVersion)
 *
 @changelog
 * 2016-03-29 weihang li <weihang.li@oinio.com>
 * - Created    
 */
global class BatchCls_ManagementOppyTeamMember extends SchedulerVizArt.ClsBatchVirtual{
    /*
    global override Database.QueryLocator start(Database.BatchableContext BC){
        String querySql = 'SELECT Id,Name,Sales_Channels__c,SORG__c,Related_Project__c,Related_Project__r.Project_Location_Postal_Code__c,Postal_Code__c, Related_Project__r.Project_Location_Country__c from Opportunity where Sales_Channels__c != \'\' ';
         
        return Database.getQueryLocator(querySql);
    } 
     
    global override void execute(Database.BatchableContext BC, list<SObject> list_sobj) {
        //ClsTerritoryManagementUtil.isOpportunityBatchRun = true;
    
        list<Opportunity> list_updateOppys = new list<Opportunity>();
        map<String,List<Opportunity>> map_zipCode_oppIds = new map<String,List<Opportunity>>();
        set<String> set_orgs = new set<String>();
        set<Id> set_oppIds = new set<Id>();
        set<String> set_projectMangerOpp  =new set<String>();
        set<String> set_internalSalesOpp  =new set<String>();
        list<Opportunity_Team_Member__c> list_oppTeamMember2delte = new list<Opportunity_Team_Member__c>();
            
        for(SObject sobj: list_sobj) {
            Opportunity opp = (Opportunity)sobj;
            if(opp.Postal_Code__c != null && opp.Postal_Code__c != ''){
                if(!map_zipCode_oppIds.containsKey(opp.Postal_Code__c)){
                    map_zipCode_oppIds.put(opp.Postal_Code__c,new list<Opportunity>());
                }
                map_zipCode_oppIds.get(opp.Postal_Code__c).add(opp);
            }
            
            if(opp.SORG__c != '' && opp.SORG__c != null){
                set_orgs.add(opp.SORG__c);
            }
            set_oppIds.add(opp.Id);
        }
        
        for(Opportunity_Team_Member__c oppTM : [select Id, Created_Automatically__c, Team_Role__c, Opportunity__c from Opportunity_Team_Member__c where Opportunity__c in: set_oppIds and (Created_Automatically__c = true or Team_Role__c = 'Internal Sales Contact' or Team_Role__c = 'Project Manager')]){
            if(oppTM.Created_Automatically__c){
                list_oppTeamMember2delte.add(oppTM);
            }else{
                if(oppTM.Team_Role__c == 'Project Manager'){
                    set_projectMangerOpp.add(oppTM.Opportunity__c);
                }
                if(oppTM.Team_Role__c == 'Internal Sales Contact'){
                    set_internalSalesOpp.add(oppTM.Opportunity__c);
                }
            }
        }
        if(!list_oppTeamMember2delte.isEmpty()){
            delete list_oppTeamMember2delte;
        }
        system.debug('set_projectMangerOpp:'+set_projectMangerOpp);
        system.debug('set_internalSalesOpp:'+set_internalSalesOpp);
        List<String> fields = new List<String>();
        fields.addAll(Territory_Data__c.SObjectType.getDescribe().fields.getMap().keySet());
        list<Territory_Data__c> list_terData = new list<Territory_Data__c>();
        String query = 'Select ';
        for(String strField : fields){
            query += strField + ', '; 
        }
        query = query.substring(0, query.lastIndexOf(',')) + ' from Territory_Data__c where Sales_Organisation__c in: set_orgs';
        for(Territory_Data__c td : database.query(query)){
            for(String code:map_zipCode_oppIds.keySet()){
                if(code.indexOf(td.PLZ__c) == 0){
                    list_terData.add(td);
                }
            }
        }
        system.debug('list_terData:'+list_terData);
        if(!list_terData.isEmpty()){
            map<String,set<Opportunity>> map_tdOppFieldVal_oppy = new map<String,set<Opportunity>>();        
            map<String,set<Opportunity>> map_tdAccFieldVal_oppy = new map<String,set<Opportunity>>();        
            for(SObject sobj: list_sobj){
                Opportunity opp = (Opportunity)sobj;
                String strOppVal = '';
                String strAccVal = '';
                set<String> set_fdOppVal = new set<String>();
                set<String> set_fdAccVal = new set<String>();
                for(Territory_Data__c td:list_terData){
                    if(opp.Postal_Code__c != null && td.PLZ__c != null && opp.Postal_Code__c.indexOf(td.PLZ__c) == 0 && td.Sales_Organisation__c == opp.SORG__c && td.Country__c == opp.Related_Project__r.Project_Location_Country__c){
                        for(String str:fields){
                            if((str.toUpperCase()).indexOf(opp.Sales_Channels__c) > -1 && (str.toUpperCase()).indexOf('OPPORTUNITY') > -1){
                                if(td.get(str) != null){
                                    if(!map_tdOppFieldVal_oppy.containsKey(String.valueOf(td.get(str)))){
                                        map_tdOppFieldVal_oppy.put(String.valueOf(td.get(str)), new set<Opportunity>());
                                    }   
                                    map_tdOppFieldVal_oppy.get(String.valueOf(td.get(str))).add(opp);
                                }
                            }
                            if((str.toUpperCase()).indexOf(opp.Sales_Channels__c) > -1 && (str.toUpperCase()).indexOf('ACCOUNT') > -1){
                                if(td.get(str) != null){
                                    if(!map_tdAccFieldVal_oppy.containsKey(String.valueOf(td.get(str)))){
                                        map_tdAccFieldVal_oppy.put(String.valueOf(td.get(str)), new set<Opportunity>());
                                    }   
                                    map_tdAccFieldVal_oppy.get(String.valueOf(td.get(str))).add(opp);
                                }
                            }
                        }
                    }
                }
            }    
          system.debug('map_tdOppFieldVal_oppy:'+map_tdOppFieldVal_oppy);
          system.debug('map_tdAccFieldVal_oppy:'+map_tdAccFieldVal_oppy);
            if(!map_tdOppFieldVal_oppy.isEmpty() || !map_tdAccFieldVal_oppy.isEmpty()){
                list<Opportunity_Team_Member__c> list_insertTeamMember = new list<Opportunity_Team_Member__c>();
                set<Opportunity> set_internalOppys = new set<Opportunity>(); // added lili zhao 
                set<Opportunity> set_projectOppys = new set<Opportunity>(); // added lili zhao 
                set<Id> set_opporIds = new set<Id>();
                map<String, String> map_oppyId_userId = new map<String, String>();
                map<String, String> map_proOppyId_userId = new map<String, String>();
                for(User us:[select Id,Name,District__c, Sales_Group__c from User where Sales_Group__c in: map_tdOppFieldVal_oppy.keySet() or District__c in: map_tdAccFieldVal_oppy.keySet()]){
                    if(map_tdOppFieldVal_oppy.get(us.Sales_Group__c) != null){
                        for(Opportunity opp : map_tdOppFieldVal_oppy.get(us.Sales_Group__c)){
                            if(!set_internalSalesOpp.contains(opp.Id)){
                                
                                map_oppyId_userId.put(opp.Id,us.Id);
                                set_internalOppys.add(opp);
                            }
                        } 
                    }
                    if(map_tdAccFieldVal_oppy.get(us.District__c) != null){
                        for(Opportunity opp : map_tdAccFieldVal_oppy.get(us.District__c)){
                            if(!set_projectMangerOpp.contains(opp.Id)){                                                                
                                set_projectOppys.add(opp);
                                map_proOppyId_userId.put(opp.Id, us.Id);
                            }
                        } 
                    }
                      
                }
                
                // added lili zhao 
                if(set_internalOppys.size() > 0) {
                    
                    list<Opportunity> list_internalOppys = new list<Opportunity>(); 
                    for(Opportunity opp : set_internalOppys) {
                        Opportunity_Team_Member__c otm = new Opportunity_Team_Member__c();
                        otm.Opportunity__c = opp.Id;
                        otm.Created_Automatically__c = true;
                        otm.Team_Role__c = 'Internal Sales Contact';
                        otm.User__c = map_oppyId_userId.get(opp.Id);
                        list_insertTeamMember.add(otm);
                    }
                    
                }
                
                if(set_projectOppys.size() > 0) {
                    
                    list<Opportunity> list_projectOppys = new list<Opportunity>(); 
                    for(Opportunity opp : set_projectOppys) {
                        Opportunity_Team_Member__c otm = new Opportunity_Team_Member__c();
                        otm.Opportunity__c = opp.Id;
                        otm.Created_Automatically__c = true;
                        otm.Team_Role__c = 'Project Manager';
                        otm.User__c = map_proOppyId_userId.get(opp.Id);
                        list_insertTeamMember.add(otm);   
                        opp.OwnerId = map_proOppyId_userId.get(opp.Id);
                        if(!set_opporIds.contains(opp.Id)){
                            set_opporIds.add(opp.Id);
                            list_updateOppys.add(opp);
                        }
                    }
                    
                }
                //end
                system.debug('list_insertTeamMember:'+list_insertTeamMember);
                if(!list_updateOppys.isEmpty()){
                    update list_updateOppys;
                }
                if(!list_insertTeamMember.isEmpty()){
                    insert list_insertTeamMember;
                }
                    
            }
        }
        
    }*/
}