/**
 *   This class is used to Initial Setup of Search Mask 
 *
 * @author weihang li
 * @created 2015-12-17
 * @version 1.0 
 * @since 31.0
 *
 * @changelog
 * 	2015-12-17 weihang li <weihang.li@oinio.com>
 * - Created 
 * 
 */
public with sharing class CtrlSearchMask {
	//********************************* -=BEGIN public members=- ************************************
	public String selObject{get;set;}
	public String selFilter{get;set;}
	public boolean isShowFilterPanel{get;set;}
	public List<String> list_repeatTr {get;set;}
	public boolean isShowResultPanel{get;set;}
	public String filter_Str {get;set;}
	public String strOrderBy {get;set;}
	public list<SObject> list_results {get;set;}
	public String delRecordId {get;set;}
	public list<String> list_shownFields {get;set;}
	public map<String,String> map_fdName_fdLabel {get;set;}
	public String defaultOp {get;set;}
	public String defaultVal {get;set;}
	public String getMap_operators_type (){
		return JSON.serialize(new Map<String, String> {
	    	'BOOLEAN' => 'equals to|not equal to',
	    	'CURRENCY' => 'equals to|not equal to|less than|greater than|less or equal|greater or equal',
	    	'DATE' => 'equals to|not equal to|less than|greater than|less or equal|greater or equal',
	    	'DATETIME' => 'equals to|not equal to|less than|greater than|less or equal|greater or equal',
	    	'DOUBLE' => 'equals to|not equal to|less than|greater than|less or equal|greater or equal',
	    	'EMAIL' => 'equals to|not equal to|contains|does not contain|starts with',
	    	//'ID' => 'equals to|not equal to|starts with',
	    	'INTEGER' => 'equals to|not equal to|less than|greater than|less or equal|greater or equal',
	    	'MULTIPICKLIST' => 'equals to|not equal to|includes|excludes',
	    	'PERCENT' => 'equals to|not equal to|less than|greater than|less or equal|greater or equal',
	    	'PHONE' => 'equals to|not equal to|contains|does not contain|starts with',
	    	'PICKLIST' => 'equals to|not equal to',
	    	'STRING' => 'equals to|not equal to|contains|does not contain|starts with',
	    	'TEXTAREA' => 'equals to|not equal to|contains|does not contain|starts with',
	    	'REFERENCE' => 'equals to|not equal to'
		});
    }
	//********************************* -=END public members=- ************************************
	//********************************* -=BEGIN public members=- ************************************
	private static final String FILTEROPERATORS_EQUALS = 'equals to';
	private static final String FILTEROPERATORS_NOTEQUALTO = 'not equal to';
	private static final String FILTEROPERATORS_LESSTHAN = 'less than';
	private static final String FILTEROPERATORS_GREATERTHAN = 'greater than';
	private static final String FILTEROPERATORS_LESSOREQUAL = 'less or equal';
	private static final String FILTEROPERATORS_GREATEROREQUAL = 'greater or equal';
	private static final String FILTEROPERATORS_CONTAINS = 'contains';
	private static final String FILTEROPERATORS_DOESNOTCONTAIN = 'does not contain';
	private static final String FILTEROPERATORS_STARTSWITH = 'starts with';
	private static final String FILTEROPERATORS_INCLUDES = 'includes';
	private static final String FILTEROPERATORS_EXCLUDES = 'excludes';
	
	//********************************* -=END public members=- ************************************
	
	 //********************************* -=BEGIN CONSTRUCTOR=- ***************************************
	public CtrlSearchMask(){
		selObject = '';
		selFilter = '';
		isShowFilterPanel = false;
		isShowResultPanel = false;
		filter_Str = '';
		strOrderBy = '';
		list_results = new list<SObject>();
		list_repeatTr = new list<String>{'1','2','3'};
		delRecordId = '';
		list_shownFields = new list<String>();
		defaultOp = '';
		defaultVal = '';
	}
	//********************************* -=END CONSTRUCTOR=- ***************************************
	 
    //********************************* -=BEGIN Public Methods =- ***********************************
    /**
	 *   This method is used to delete account record
	 *
	 * @author weihang li
	 * @created 2015-12-17
	 * @version 1.0
	 * @since 31.0
	 *
	 * @changelog
	 * 	2015-12-17 weihang li <weihang.li@oinio.com>
	 * - Created 
	 * 
	 */
    public void deleteRecord(){
    	if(delRecordId != ''){
    		delete [select Id from Account where Id =: delRecordId];
    		searchResult();
    	}
    }
  	/**
	 *   This method is used to get object items
	 *
	 * @author weihang li
	 * @created 2015-12-17
	 * @version 1.0
	 * @since 31.0
	 *
	 * @changelog
	 * 	2015-12-17 weihang li <weihang.li@oinio.com>
	 * - Created 
	 * 
	 */
	public void changeObj(){
		list_results.clear();
		if(selObject != null && selObject != ''){
			Search_Mask_Object__c smo = Search_Mask_Object__c.getInstance(selObject);
			if(smo != null){
				if(smo.Default_Field__c != '' && smo.Default_Field__c != null){
					list_repeatTr = new list<String>();
					map<String,String> map_fdName_fdOption = new map<String,String>();
					map<String,String> map_fdName_fdValue = new map<String,String>();
					for(String str: smo.Default_Field__c.split(',')){
						
						list<String> list_str = str.split('&');
						list_repeatTr.add(list_str.get(0));
						if(list_str.size() >= 2){
							map_fdName_fdOption.put(list_str.get(0), list_str.get(1));
						}
						if(list_str.size() >= 3){
							map_fdName_fdValue.put(list_str.get(0), list_str.get(2));
						}
					}
					defaultOp = JSON.serialize(map_fdName_fdOption);
					defaultVal = JSON.serialize(map_fdName_fdValue);
				}else{
					list_repeatTr = new list<String>{'1','2','3'};
				}
			}
			getFilterFieldsItems();
			isShowFilterPanel = true;
			isShowResultPanel = false;
		}else{
			isShowFilterPanel = false;
			isShowResultPanel = false;
		}
	}
    /**
	 *   This method is used to get object items
	 *
	 * @author weihang li
	 * @created 2015-12-17
	 * @version 1.0
	 * @since 31.0
	 *
	 * @changelog
	 * 	2015-12-17 weihang li <weihang.li@oinio.com>
	 * - Created 
	 * 
	 */
	public list<SelectOption> getObjItems(){
		list<SelectOption> list_options = new list<SelectOption>();
		list_options.add(new SelectOption('',system.label.None_Value));
		for(Search_Mask_Object__c smo:Search_Mask_Object__c.getAll().values()){
			list_options.add(new SelectOption(smo.Name, smo.Name));
		}
		if(list_options.isEmpty()){
			list_options.add(new SelectOption('Account', 'Account'));
		}
		return list_options;
	} 
	/**
	 *   This method is used to get object fields.
	 *
	 * @author weihang li
	 * @created 2015-12-17
	 * @version 1.0
	 * @since 31.0
	 *
	 * @changelog
	 * 	2015-12-17 weihang li <weihang.li@oinio.com>
	 * - Created 
	 * 
	 */
	public List<SelectOption> getFilterFieldsItems(){
		list<SelectOption> list_options = new list<SelectOption>();
		list_options.add(new SelectOption('', system.label.None_Value));
		if(selObject != ''){
			Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(selObject).getDescribe().Fields.getMap();
			if (fMap != null){ 
	            for(Schema.SObjectField ft : fMap.values()){
	                Schema.DescribeFieldResult fd = ft.getDescribe();
	                if(String.valueOf(fd.getType()) != 'ID'){
	                	list_options.add(new SelectOption(fd.getName()+','+fd.getType()+','+fd.getReferenceTo(), fd.getLabel()));
	                }
	            }
	        }
		}
		return list_options;
	}
	/**
	*   This method is used to get operator
	*
	* @author weihang li
	* @created 2015-12-22
	* @version 1.0
	* @since 31.0
	*
	* @changelog
	* 	2015-12-22 weihang li <weihang.li@oinio.com>
	* - Created 
	* 
	*/
	public void searchResult(){
		list_results.clear();
		list_shownFields.clear();
		list_shownFields.addAll(getShownFields());
		for(sobject so:database.query(getQuery())){
			/*Account acc = new Account();
			acc = (Account)so;*/
			list_results.add(so);
		}
		isShowResultPanel = true;
	}
	/**
	*   This method is used to get operator
	*
	* @author weihang li
	* @created 2015-12-22
	* @version 1.0
	* @since 31.0
	*
	* @changelog
	* 	2015-12-22 weihang li <weihang.li@oinio.com>
	* - Created 
	* 
	*/
	public String getQuery(){
		list<Filter> list_filters = (list<Filter>)JSON.deserialize(filter_Str, list<Filter>.class); 
		String selFields = 'select';
		Search_Mask_Object__c smo = Search_Mask_Object__c.getInstance(selObject);
		if(smo != null && smo.Default_Columns__c != null && smo.Default_Columns__c != ''){
			for(String str:smo.Default_Columns__c.split(',')){
				selFields += ' '+str+',';
			}
			selFields = selFields.substring(0,selFields.length() - 1);
		}
		if(selFields == 'select'){
			selFields = 'select Id,Name ';
		}
		String str_Select = selFields + ' from ' + selObject+' where Id != null ';
		String allCondition = '';
		String orderby_Str = '';
		for(Filter f:list_filters){
			String filterStr = '';
			String str_oper = getFilterOperator(f.operator);
			filterStr = str_oper;
			
			String value = f.fieldVal;
			value = getValue(f.fieldType,value);
			
			if(str_oper.contains('fieldName')){
				filterStr = filterStr.replace('fieldName',f.fieldName);
			}else{
				filterStr = f.fieldName + filterStr;
			}
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
			if(filterStr != '')
			allCondition += ' and '+filterStr;
		}
		if(strOrderBy != ''){
			orderby_Str = getOrderByString(strOrderBy,'Account');
		}
		String str_limit = ' limit 200';
		String sql = str_Select + allCondition + orderby_Str + str_limit;
		return sql;
	}
	public String getValue(String fieldType,String value){
		String returnValue = '';
		if(fieldType == 'STRING' || fieldType == 'EMAIL' || fieldType == 'REFERENCE' || fieldType == 'PICKLIST' || fieldType == 'PHONE' || fieldType == 'URL' || fieldType == 'TEXTAREA'){
			returnValue = getStringMultiValue(value);
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
	* @created 2015-12-22
	* @version 1.0
	* @since 31.0
	*
	* @changelog
	* 	2015-12-22 weihang li <weihang.li@oinio.com>
	* - Created 
	* 
	*/
	public String getFilterOperator(String operator){
		String operatorStr = '';
		if(operator == FILTEROPERATORS_EQUALS){
			operatorStr = '=';
		}else if(operator == FILTEROPERATORS_NOTEQUALTO){
			operatorStr = '!=';
		}else if(operator == FILTEROPERATORS_LESSTHAN){
			operatorStr = '<';
		}else if(operator == FILTEROPERATORS_GREATERTHAN){
			operatorStr = '>';
		}else if(operator == FILTEROPERATORS_LESSOREQUAL){
			operatorStr = '<=';
		}else if(operator == FILTEROPERATORS_GREATEROREQUAL){
			operatorStr = '>=';
		}else if(operator == FILTEROPERATORS_CONTAINS){
			operatorStr = ' like \'%ReplacedStringValue%\'';
		}else if(operator == FILTEROPERATORS_DOESNOTCONTAIN){
			operatorStr = ' (not fieldName like \'%ReplacedStringValue%\')';
		}else if(operator == FILTEROPERATORS_STARTSWITH){
			operatorStr = ' like \'ReplacedStringValue%\'';
		}else if(operator == FILTEROPERATORS_INCLUDES){
			operatorStr = ' INCLUDES (ReplacedValue)';
		}else if(operator == FILTEROPERATORS_EXCLUDES){
			operatorStr = ' EXCLUDES (ReplacedValue)';
		}
		return operatorStr;
	}
	/**
	*   This method is used to get order by string
	*
	* @author weihang li
	* @created 2015-12-22
	* @version 1.0
	* @since 31.0
	*
	* @changelog
	* 	2015-12-22 weihang li <weihang.li@oinio.com>
	* - Created 
	* 
	*/
	public static String getOrderByString(String orderbyStr, String objN) {
        list<OrderBy> list_orderBy = new list<OrderBy>();
        String orderBy = '';
        try{
            list_orderBy = (list<OrderBy>) JSON.deserialize(orderbyStr, list<OrderBy>.class);
            if(list_orderBy.isEmpty()) {
                return '';
            }
            for(OrderBy o : list_orderBy) {
                if(o.objName == objN && o.orderType != null && o.orderType != '' &&  o.fieldName != null &&  o.fieldName != '') {
                    orderBy += ' Order by ' + o.fieldName + ' ' + o.orderType + ' NULLS LAST ';
                }
            }
            return orderBy;
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
            return '';
        }   
    }
 	//********************************* -=END Public Methods =- ***********************************
	 
	//********************************* -=BEGIN private Methods =- ***********************************
	//used to reset string,email,referece,picklist,phone,url,textarea value
	private String getStringMultiValue(String value){
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
	private String getMultiPicklistValue(String value){
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
	private String getMultiCurrencyValue(String value){
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
	private String getMultiValue(String value){
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
	
	public list<String> getShownFields(){
		list<String> list_returnStr = new list<String>();
		set<String> set_fields = new set<String>();
		Search_Mask_Object__c sf = Search_Mask_Object__c.getInstance(selObject);
		if(sf != null && sf.Default_Columns__c != null && sf.Default_Columns__c != ''){
			for(String str: sf.Default_Columns__c.split(',')){
				list_returnStr.add(str);
				set_fields.add(str);
			}
		}else{
			list_returnStr.add('Name');
			set_fields.add('Name');
		}
		
		if(selObject != ''){
			map_fdName_fdLabel = new map<String,String>();
			Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(selObject).getDescribe().Fields.getMap();
			if (fMap != null){ 
	            for(Schema.SObjectField ft : fMap.values()){
	                Schema.DescribeFieldResult fd = ft.getDescribe();
	                if(set_fields.contains(fd.getName())){
	                	map_fdName_fdLabel.put(fd.getName(), fd.getLabel());
	                }
	            }
	        }
		}
		return list_returnStr;
	}
	
	//********************************* -=END private Methods =- ***********************************
	public class Filter{
		public String fieldName{get;set;}
		public String operator{get;set;}
		public String fieldVal{get;set;}
		public String fieldType{get;set;}
	}
	public class OrderBy {
        public String objName {get; set;}
        public String fieldName {get; set;}
        public String orderType {get; set;}
        public OrderBy() {
            this.objName = '';
            this.fieldName = '';
            this.orderType = '';
        }
    }
}