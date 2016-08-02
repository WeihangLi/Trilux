global with sharing class ClsSearchOpportunityController {
    private static final String FILTEROPERATORS_EQUALS = system.label.ProjectSearch_Value_equalsto;
    private static final String FILTEROPERATORS_NOTEQUALTO =system.label.ProjectSearch_Value_notequalto;
    private static final String FILTEROPERATORS_LESSTHAN =system.label.ProjectSearch_Value_lessthan;
    private static final String FILTEROPERATORS_GREATERTHAN =system.label.ProjectSearch_Value_greaterthan;
    private static final String FILTEROPERATORS_LESSOREQUAL =system.label.ProjectSearch_Value_lessorequal;
    private static final String FILTEROPERATORS_GREATEROREQUAL =system.label.ProjectSearch_Value_greaterorequal;
    private static final String FILTEROPERATORS_CONTAINS =system.label.ProjectSearch_Value_contains;
    private static final String FILTEROPERATORS_DOESNOTCONTAIN =system.label.ProjectSearch_Value_doesnotcontain;
    private static final String FILTEROPERATORS_STARTSWITH =system.label.ProjectSearch_Value_startswith;
    public static map<String,String> Map_operators_type = new Map<String, String>{
        'DATE' => (system.label.ProjectSearch_Value_equalsto+','+system.label.ProjectSearch_Value_notequalto+ ','+system.label.ProjectSearch_Value_lessthan+','+system.label.ProjectSearch_Value_greaterthan+','+system.label.ProjectSearch_Value_lessorequal+','+system.label.ProjectSearch_Value_greaterorequal),
        'DOUBLE' => (system.label.ProjectSearch_Value_equalsto+','+system.label.ProjectSearch_Value_notequalto+','+system.label.ProjectSearch_Value_lessthan+','+system.label.ProjectSearch_Value_greaterthan+','+system.label.ProjectSearch_Value_lessorequal+','+system.label.ProjectSearch_Value_greaterorequal),
        'INTEGER' => (system.label.ProjectSearch_Value_equalsto+','+system.label.ProjectSearch_Value_notequalto+ ','+system.label.ProjectSearch_Value_lessthan+','+system.label.ProjectSearch_Value_greaterthan+','+system.label.ProjectSearch_Value_lessorequal+','+system.label.ProjectSearch_Value_greaterorequal),
        'PICKLIST' => (system.label.ProjectSearch_Value_equalsto+','+system.label.ProjectSearch_Value_notequalto),
        'STRING' => (system.label.ProjectSearch_Value_equalsto+','+system.label.ProjectSearch_Value_notequalto+','+system.label.ProjectSearch_Value_contains+','+system.label.ProjectSearch_Value_doesnotcontain+','+ system.label.ProjectSearch_Value_startswith),
        'REFERENCE' => (system.label.ProjectSearch_Value_equalsto+','+system.label.ProjectSearch_Value_notequalto)
    };
    
    /**
    *   This method is used to get current user language
    *
    * @author weihang li
    * @created 2016-03-14
    * @version 1.0
    * @since 31.0
    *
    * @changelog
    *   2016-03-14 weihang li <weihang.li@oinio.com>
    * - Created 
    * 
    */
    @AuraEnabled
    public static String getCurrentUserLocaleSidKeyLabel(){
        String localekey = [select Id,LocaleSidKey from User where id =: UserInfo.getUserId()].LocaleSidKey;
        Schema.DescribeSObjectResult objDescribe = Trilux_Project__c.getSObjectType().getDescribe();       
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        list<Schema.PicklistEntry> values = fieldMap.get('Project_Location_Country__c').getDescribe().getPickListValues();
        for(Schema.PicklistEntry a : values){ 
            if(localekey.indexOf(a.getValue()) > -1){
                localekey = a.getValue();
            }
        }
        return localekey;
    }
    
    /**
    *   This method is used to init picklist value
    *
    * @author weihang li
    * @created 2016-03-14
    * @version 1.0
    * @since 31.0
    * 
    * @changelog
    *   2016-03-14 weihang li <weihang.li@oinio.com>
    * - Created 
    * 
    */
    @AuraEnabled
    public static PickListWrapper initPickListItems(){
        PickListWrapper pw = new PickListWrapper(); 
        pw.strOperItems = getPickValue('STRING');
        pw.douOperItems = getPickValue('DOUBLE');
        pw.dateOperItems = getPickValue('DATE');
        pw.refOperItems = getPickValue('REFERENCE');
        pw.pickOperItems = getPickValue('PICKLIST');
        pw.pickStaticFlagItems = getSalesPickListValue('Opportunity','Statistic_Flag__c');
        pw.pickSalesChannelItems = getSalesPickListValue('Opportunity','Sales_Channels__c');
        pw.pickCountryItems = getSalesPickListValue('Trilux_Project__c','Project_Location_Country__c');
        return pw;
    }
    /**
    *   This method is used to get operation picklist value
    *
    * @author weihang li
    * @created 2016-03-14
    * @version 1.0
    * @since 31.0
    *
    * @changelog
    *   2016-03-14 weihang li <weihang.li@oinio.com>
    * - Created 
    * 
    */
    private static List<CustomSelectOption> getSalesPickListValue(String ObjName,String fieldName){
        list<CustomSelectOption> options = new list<CustomSelectOption>();
        Schema.DescribeSObjectResult objDescribe;
        if(objName == 'Opportunity') objDescribe = Opportunity.getSObjectType().getDescribe();     
        if(objName == 'Trilux_Project__c') objDescribe = Trilux_Project__c.getSObjectType().getDescribe();   
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        list<Schema.PicklistEntry> values = fieldMap.get(fieldName).getDescribe().getPickListValues();
        for(Schema.PicklistEntry a : values){ 
            options.add(new CustomSelectOption(a.getValue(), a.getLabel())); 
        }
        return options;
    }
    
    /**
    *   This method is used to get operation picklist value
    *
    * @author weihang li
    * @created 2016-03-14
    * @version 1.0
    * @since 31.0
    *
    * @changelog
    *   2016-03-14 weihang li <weihang.li@oinio.com>
    * - Created 
    * 
    */
    private static List<CustomSelectOption> getPickValue(String fdType){
        List<CustomSelectOption> options = new List<CustomSelectOption>();
        for(String op:Map_operators_type.get(fdType).split(',')){
            options.add(new CustomSelectOption(op,op));
        }
        return options;
    }
    /**
    *   This method is used to search opportunity
    *
    * @author weihang li
    * @created 2016-03-14
    * @version 1.0
    * @since 31.0
    *
    * @changelog
    *   2016-03-14 weihang li <weihang.li@oinio.com>
    * - Created 
    * 
    */
    @AuraEnabled
    public static list<customOpportunity> searchResult(String filter_Str){
        list<customOpportunity> list_oppys = new list<customOpportunity>();
        String proQuery = '';
        String oppyQuery = '';
        String oppPartnerQuery = '';
        String oppTeamMemberQuery = '';
        String quoteItemQuery = '';
        String quoteQuery = '';
        
        list<customFilter> list_filters = (list<customFilter>)JSON.deserialize(filter_Str, list<customFilter>.class); 
        set<String> set_objects = new set<String>();
        for(customFilter f:list_filters){
            set_objects.add(f.objName);
            if(f.operator != null && f.operator != '') {
            	
            	if(f.operator == 'equals to') {
            		f.operator = system.label.ProjectSearch_Value_equalsto;
            	}else if(f.operator == 'not equal to') {
            		f.operator = system.label.ProjectSearch_Value_notequalto;
            	}else if(f.operator == 'less than') {
            		f.operator = system.label.ProjectSearch_Value_lessthan;
            	}else if(f.operator == 'greater than') {
            		f.operator = system.label.ProjectSearch_Value_greaterthan;
            	}else if(f.operator == 'less or equal') {
            		f.operator = system.label.ProjectSearch_Value_lessorequal;
            	}else if(f.operator == 'greater or equal') {
            		f.operator = system.label.ProjectSearch_Value_greaterorequal;
            	}else if(f.operator == 'contains') {
            		f.operator = system.label.ProjectSearch_Value_contains;
            	}else if(f.operator == 'does not contain') {   
            		f.operator = system.label.ProjectSearch_Value_doesnotcontain;
            	}else if(f.operator == 'starts with') {
            		f.operator = system.label.ProjectSearch_Value_startswith;
            	}
            }
        }
        for(String objName:set_objects){
            if(objName == 'Trilux_Project__c'){
                proQuery = getQuery(list_filters,objName);
            }else if(objName == 'Opportunity'){
                oppyQuery = getQuery(list_filters,objName);
            }else if(objName == 'Opportunity_Partner__c'){
                oppPartnerQuery = getQuery(list_filters,objName);
            }else if(objName == 'Opportunity_Team_Member__c'){
                oppTeamMemberQuery = getQuery(list_filters,objName);
            }else if(objName == 'Quote_Line_Item__c'){
                quoteItemQuery = getQuery(list_filters,objName);
            }else if(objName == 'Quote__c'){
                quoteQuery = getQuery(list_filters,objName);
            }
        }
        system.debug('ffffffffffff:'+proQuery);
        system.debug('ffffffffffff:'+oppyQuery);
        system.debug('ffffffffffff:'+oppPartnerQuery);
        system.debug('ffffffffffff:'+oppTeamMemberQuery);
        system.debug('ffffffffffff:'+quoteItemQuery);
        system.debug('ffffffffffff:'+quoteQuery);
        set<Id> set_ProjectOppyIds = new set<Id>();
        set<Id> set_oppyIds = new set<Id>();
        set<Id> set_PartnerOppyIds = new set<Id>();
        set<Id> set_TeamMemberOppyIds = new set<Id>();
        set<Id> set_QuoteItemOppyIds = new set<Id>();
        set<Id> set_QuoteOppyIds = new set<Id>();
        if(proQuery != ''){
            for(Opportunity opp:database.query(proQuery)){
                set_ProjectOppyIds.add(opp.Id);
            }
        }
        if(oppyQuery != ''){
            for(Opportunity opp:database.query(oppyQuery)){
                set_oppyIds.add(opp.Id);
            }
        }
        if(oppPartnerQuery != ''){
            for(Opportunity_Partner__c par:database.query(oppPartnerQuery)){
                set_PartnerOppyIds.add(par.Opportunity__c);
            }
        }
        if(oppTeamMemberQuery != ''){
            for(Opportunity_Team_Member__c otm:database.query(oppTeamMemberQuery)){
                set_TeamMemberOppyIds.add(otm.Opportunity__c);
            }
        }
        if(quoteItemQuery != ''){
            for(Quote_Line_Item__c item:database.query(quoteItemQuery)){
                set_QuoteItemOppyIds.add(item.Quote__r.Opportunity__c); 
            }
        }
        if(quoteQuery != ''){
            for(Quote__c quo:database.query(quoteQuery)){
                set_QuoteOppyIds.add(quo.Opportunity__c);
            }
        }
        if(set_ProjectOppyIds.isEmpty() && set_oppyIds.isEmpty() && set_PartnerOppyIds.isEmpty() && set_TeamMemberOppyIds.isEmpty() && set_QuoteItemOppyIds.isEmpty() && set_QuoteOppyIds.isEmpty()){
            list_oppys.clear();
            return list_oppys;
        }else if((proQuery != '' && set_ProjectOppyIds.isEmpty()) || (oppyQuery != '' && set_oppyIds.isEmpty()) || 
                 (oppPartnerQuery != '' && set_PartnerOppyIds.isEmpty()) || (oppTeamMemberQuery != '' && set_TeamMemberOppyIds.isEmpty()) || 
                 (quoteItemQuery != '' && set_QuoteItemOppyIds.isEmpty()) || (quoteQuery != '' && set_QuoteOppyIds.isEmpty()) ){
            list_oppys.clear();
            return list_oppys;
        }else{
            String oppSql = 'select Id,Name,City__c,Street__c,Country__c,Amount,toLabel(StageName),CreatedDate,toLabel(Sales_Channels__c),toLabel(SORG__c) from Opportunity where id != null ';
            system.debug('zzzzzzzz:'+set_ProjectOppyIds+'==='+set_oppyIds);
            if(!set_ProjectOppyIds.isEmpty()) oppSql += ' and Id in: set_ProjectOppyIds';
            if(!set_oppyIds.isEmpty()) oppSql += ' and Id in: set_oppyIds';
            if(!set_PartnerOppyIds.isEmpty()) oppSql += ' and Id in: set_PartnerOppyIds';
            if(!set_TeamMemberOppyIds.isEmpty()) oppSql += ' and Id in: set_TeamMemberOppyIds';
            if(!set_QuoteItemOppyIds.isEmpty()) oppSql += ' and Id in: set_QuoteItemOppyIds';
            if(!set_QuoteOppyIds.isEmpty()) oppSql += ' and Id in: set_QuoteOppyIds';
            system.debug('xxxxxxxxxxxxxxxxxxxxx:'+oppSql);
            oppSql += ' limit 1000';
            for(Opportunity opp : database.query(oppSql)){
                if(opp.Amount == null) opp.Amount = 0;
                String amount = (Integer.valueOf(opp.Amount)).format();
                if(amount.indexOf('.') > -1) amount = amount.replace('.',',');
                String cDate = opp.CreatedDate.year() + '-' + opp.CreatedDate.month() + '-' + opp.CreatedDate.day();
                list_oppys.add(new customOpportunity(String.valueOf(opp.Id),opp.Name,opp.City__c,opp.Street__c,opp.Country__c,amount,opp.StageName,cDate,opp.Sales_Channels__c,opp.SORG__c));
            }
            return list_oppys;
        }
        
        
    }
    /**
    *   This method is used to search opportunity
    *
    * @author weihang li
    * @created 2016-03-14
    * @version 1.0
    * @since 31.0
    *
    * @changelog
    *   2016-03-14 weihang li <weihang.li@oinio.com>
    * - Created 
    * 
    */
    public static String getQuery(list<customFilter> list_filters,String objName){
        String str_select = '';
        String allCondition = '';
        if(objName == 'Trilux_Project__c'){
            str_select = 'select Id from Opportunity ';
        }else if(objName == 'Opportunity'){
            //str_select = 'select Id from ' + objName;
            str_select = 'select Id from Opportunity';
        }else if(objName == 'Opportunity_Partner__c'){
            str_select = 'select Id,Opportunity__c from ' + objName;
        }else if(objName == 'Opportunity_Team_Member__c'){
            str_select = 'select Id,Opportunity__c from ' + objName;
        }else if(objName == 'Quote_Line_Item__c'){
            str_select = 'select Id,Quote__c,Quote__r.Opportunity__c from ' + objName;
        }else if(objName == 'Quote__c'){
            str_select = 'select Id,Opportunity__c from ' + objName;
        }
        str_select += ' where Id != null ';
        for(customFilter f:list_filters){
            if(f.objName == objName){
                String filterStr = '';
                //get operator
                String str_oper = getFilterOperator(f.operator);
                system.debug('str_oper::::: '+str_oper);
                filterStr = str_oper;
                //get value
                String value = f.fieldVal;
                value = getValue(f.fieldType,value);
                if(str_oper.contains('fieldName')){
                    filterStr = filterStr.replace('fieldName',f.fieldName);
                }else{
                    filterStr = f.fieldName + filterStr;
                }
                system.debug('filterStr:281:::: '+filterStr);
                if(f.fieldType == 'Double' && value.split(',').size() > 1){
                    String doubleVal = f.fieldVal;
                    filterStr = f.fieldName +' >= ' + doubleVal.split(',').get(0) + ' and ' + f.fieldName + ' <= ' + doubleVal.split(',').get(1);
                }/*else if(f.fieldType == 'PICKLIST' && f.fieldName == 'Related_Project__r.Project_Location_Country__c'){
                    //map<String,String> map_picLabel_picVal = new map<String,String>();
                    //Schema.DescribeSObjectResult objDescribe = Trilux_Project__c.getSObjectType().getDescribe();
                    //map_picLabel_picVal = getPickFieldLabelValue(objDescribe, 'Project_Location_Country__c');
                    //Schema.DescribeSObjectResult objDescribe = Trilux_Project__c.getSObjectType().getDescribe();       
                    //map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
                    //list<Schema.PicklistEntry> values = fieldMap.get('Project_Location_Country__c').getDescribe().getPickListValues();
                    //for(Schema.PicklistEntry a : values){ 
                    //    map_picLabel_picVal.put(a.getLabel(), a.getValue()); 
                    //}
                    //String fdVal = '\'' + map_picLabel_picVal.get(f.fieldVal) + '\'';
                    filterStr += fdVal; 
                }*/
                /*else if(f.fieldType == 'PICKLIST' && f.fieldName == 'Sales_Channels__c'){
                    map<String,String> map_picLabel_picVal = new map<String,String>();
                    Schema.DescribeSObjectResult objDescribe = Opportunity.getSObjectType().getDescribe();
                    map_picLabel_picVal = getPickFieldLabelValue(objDescribe, 'Sales_Channels__c');
                    String fdVal = '\'' + map_picLabel_picVal.get(f.fieldVal) + '\'';
                    filterStr += fdVal; 
                }*/else{
                    if(str_oper.contains('ReplacedStringValue')){
                        if (value.indexOf('\'') == 0 && value.lastIndexOf('\'') == value.length() - 1){
                            value=value.substring(1, value.lastIndexOf('\''));
                            filterStr = filterStr.replace('ReplacedStringValue',value);
                        }
                    }else if(str_oper.contains('ReplacedValue')){
                        filterStr = filterStr.replace('ReplacedValue',value);
                    }else if(str_oper.indexOf('!=') > -1 && value.indexOf('(') > -1 && value.indexOf(')') > -1){
                        filterStr=filterStr.replace('!=', ' not in ');
                        filterStr+=value;
                    }else if (str_oper.indexOf('=') > -1 && value.indexOf('(') > -1 && value.indexOf(')') > -1){
                        filterStr=filterStr.replace('=', ' in ');
                        filterStr+=value;
                    }else{
                        filterStr += value;
                    }
                }
                system.debug('filterStr:322:::: '+filterStr);
                if(filterStr != '')
                allCondition += ' and '+filterStr;
            }
        }
        //String str_limit = ' limit 200';
        String str_limit = '';
        String sql = str_Select + allCondition + str_limit;
        system.debug('sql::::: '+sql);
        return sql;
    }
    
    public static map<string,string> getPickFieldLabelValue (Schema.DescribeSObjectResult objDescribe, string fieldName){
        map<string,string> map_picLabel_picVal = new map<string,string>();
        //Schema.DescribeSObjectResult objDescribe = objName.getSObjectType().getDescribe();       
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        list<Schema.PicklistEntry> values = fieldMap.get(fieldName).getDescribe().getPickListValues();
        for(Schema.PicklistEntry a : values){ 
            map_picLabel_picVal.put(a.getLabel(), a.getValue()); 
        }
        return map_picLabel_picVal;
    }
    /**
    *   This method is used to get operator
    *
    * @author weihang li
    * @created 2016-03-14
    * @version 1.0
    * @since 31.0
    *
    * @changelog
    *   2016-03-14 weihang li <weihang.li@oinio.com>
    * - Created 
    * 
    */
    public static String getValue(String fieldType,String value){
        String returnValue = '';
        if(fieldType == 'STRING' || fieldType == 'EMAIL' || fieldType == 'REFERENCE' || fieldType == 'PHONE' || fieldType == 'URL' || fieldType == 'TEXTAREA'){
            returnValue = getStringMultiValue(value);
        }else if(fieldType == 'PICKLIST'){
            if(value.split(',').size() > 1){
                returnValue = getMultiPicklistValue(value);
            }else{
                returnValue = getStringMultiValue(value);
            }
        }else if(fieldType == 'MULTIPICKLIST'){
            returnValue = getMultiPicklistValue(value);
        }else if(fieldType == 'CURRENCY'){
            returnValue = getMultiCurrencyValue(value);
        }else if(fieldType == 'INTEGER' || fieldType == 'DOUBLE' || fieldType == 'PERCENT' || fieldType == 'DATE' || fieldType == 'DATETIME'){
            returnValue = getMultiValue(value);
        }else{
            returnValue = getMultiValue(value);
        }
        return returnValue;
    }
    /**
    *   This method is used to get operator
    *
    * @author weihang li
    * @created 2016-03-14
    * @version 1.0
    * @since 31.0
    *
    * @changelog
    *   2016-03-14 weihang li <weihang.li@oinio.com>
    * - Created 
    * 
    */
    public static String getFilterOperator(String operator){
        String operatorStr = '';
        if(operator == FILTEROPERATORS_EQUALS){
            operatorStr = ' = ';
        }else if(operator == FILTEROPERATORS_NOTEQUALTO){
            operatorStr = ' != ';
        }else if(operator == FILTEROPERATORS_LESSTHAN){
            operatorStr = ' < ';
        }else if(operator == FILTEROPERATORS_GREATERTHAN){
            operatorStr = ' > ';
        }else if(operator == FILTEROPERATORS_LESSOREQUAL){
            operatorStr = ' <= ';
        }else if(operator == FILTEROPERATORS_GREATEROREQUAL){
            operatorStr = ' >= ';
        }else if(operator == FILTEROPERATORS_CONTAINS){
            operatorStr = ' like \'%ReplacedStringValue%\'';
        }else if(operator == FILTEROPERATORS_DOESNOTCONTAIN){
            operatorStr = ' (not fieldName like \'%ReplacedStringValue%\')';
        }else if(operator == FILTEROPERATORS_STARTSWITH){
            operatorStr = ' like \'ReplacedStringValue%\'';
        }
        return operatorStr;
    }
    public static String getStringMultiValue(String value){
        String result = '';
        if (value != ''){
            if (value.indexOf(',') > -1){
                for(String item: value.split(',')){
                    result+='\'' + item + '\',';
                }
                result='(' + result.substring(0, result.lastIndexOf(',')) + ')';
            }else{
                result = '\'' + value + '\'';
            }
        }
        return result;
    }
    //used to reset multipicklist value
    public static String getMultiPicklistValue(String value){
        String result = '';
        if (value != ''){
            if (value.indexOf(',') > -1){
                for(String item: value.split(',')){
                    result += '\'' + item + '\',';
                }
                result = '(' + result.substring(0, result.lastIndexOf(',')) + ')';
            }else{
                result = '\'' + value + '\'';
            }
        }
        return result;
    }
    //used to reset currency value
    public static String getMultiCurrencyValue(String value){
        String result ='';
        if(value != ''){
            if(value.indexOf(',') > -1){
                for(String item:value.split(',')){
                    if(item.indexOf(' ') > -1){
                        item += item.substring(value.indexOf(' ') + 1);
                    }
                    result=item + ',';
                }
                result = '(' + result.substring(0, result.lastIndexOf(',')) + ')';
            }else{
                if(value.indexOf(' ') > -1){
                    value=value.substring(value.indexOf(' ') + 1); 
                }
                result=value;
            }
        }
        return result;
    }
    //used to reset other value
    public static String getMultiValue(String value){
        String result = '';
        if(value != ''){
            if(value.indexOf(',') > -1){
                for(String item:value.split(',')){
                    result+=item + ',';
                }
                result = '(' + result.substring(0, result.lastIndexOf(',')) + ')';
            }else{
                result=value;
            }
        }
        return result;
    }
    global class PickListWrapper{
        @AuraEnabled
        List<CustomSelectOption> strOperItems {get; set;}
        @AuraEnabled
        List<CustomSelectOption> douOperItems {get; set;}
        @AuraEnabled
        List<CustomSelectOption> refOperItems {get; set;}
        @AuraEnabled
        List<CustomSelectOption> dateOperItems {get; set;}
        @AuraEnabled
        List<CustomSelectOption> pickOperItems {get; set;}
        @AuraEnabled
        List<CustomSelectOption> pickStaticFlagItems {get;set;}
        @AuraEnabled
        List<CustomSelectOption> pickSalesChannelItems {get;set;}
        @AuraEnabled
        List<CustomSelectOption> pickCountryItems {get;set;}
        @AuraEnabled
        String strcontains {get;set;}
        @AuraEnabled 
        String strgreaterorequal {get;set;}
        PickListWrapper(){
        	strcontains = FILTEROPERATORS_CONTAINS;
        	strgreaterorequal = FILTEROPERATORS_GREATEROREQUAL;
        }
    }
    global class CustomSelectOption{
        @AuraEnabled 
        String label {get; set;}
        @AuraEnabled
        String value {get; set;} 
        CustomSelectOption(String v, String k){
            value = v;
            label = k;          
        }
    }
    global class customFilter{
        @AuraEnabled
        String objName {get; set;}
        @AuraEnabled
        String fieldName {get; set;} 
        @AuraEnabled
        String operator {get; set;} 
        @AuraEnabled
        String fieldVal {get; set;} 
        @AuraEnabled
        String fieldType {get;set;}
        
        customFilter(String oName, String fName, String oper, String fdVal, String fdType){
            objName = oName;
            fieldName = fName;
            operator = oper;
            fieldVal = fdVal;
            fieldType = fdType;
        }
    }
    global class customOpportunity{
        @AuraEnabled
        String oppyId {get;set;}
        @AuraEnabled
        String oppyName {get;set;}
        @AuraEnabled
        String city {get;set;}
        @AuraEnabled
        String street {get;set;}
        @AuraEnabled
        String country {get;set;}
        @AuraEnabled
        String amount {get;set;}
        @AuraEnabled
        String stage {get;set;}
        @AuraEnabled
        String createDate {get;set;}
        @AuraEnabled
        String salesChannel {get;set;}
        @AuraEnabled
        String sorg {get;set;}
        customOpportunity(String opId, String opName, String str_City, String str_Street, String str_Country, String de_amount, String str_Stage, String str_CreateDate, String strSalesChannel, String str_Sorg){
            oppyId = opId;
            oppyName = opName;
            city = str_City;
            street = str_Street;
            country = str_Country;
            amount = de_amount;
            stage = str_Stage;
            createDate = str_CreateDate;
            salesChannel = strSalesChannel;
            sorg = str_Sorg;
        }
    }
}