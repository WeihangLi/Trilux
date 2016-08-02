/**
 * This class is used to choose value
 *
 * @author      Weihang Li
 * @created     2015-12-18
 * @since       29.0    
 * @version     1.0 
 *
 * 2015-12-18 Weihang Li <Weihang.Li@oinio.com>
 * - Created 
 */
public with sharing class CtrlPopUpWindow {
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public String searchStr {get;set;}
    public String objName {get;set;}
    public String fieldType {get;set;}
    public String fieldName {get;set;}
    public String referenceObj {get;set;}
    public list<String> list_items {get;set;}
    public boolean isShowBol {get;set;}
    public map<String,String> map_pickLabel_pickVal {get;set;}
    public List<referenceInfo> list_refInfos{get;set;}
    public String selectedValue {get;set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    public CtrlPopUpWindow(){
        searchStr = '';
        objName = ApexPages.currentPage().getParameters().get('objectName');
        fieldType = ApexPages.currentPage().getParameters().get('fieldType');
        fieldName = ApexPages.currentPage().getParameters().get('fieldName');
        referenceObj = ApexPages.currentPage().getParameters().get('fieldReference');
        selectedValue = ApexPages.currentPage().getParameters().get('selVal');
        list_items = new list<String>();
        map_pickLabel_pickVal = new map<String,String>();
        list_refInfos = new list<referenceInfo>();
        initItems();
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- /////////////////////////////////////
    
    //********************************* -=BEGIN public methods=- **********************************
    /**
    * This method is used to init values
    *
    * @author      Weihang Li
    * @created     2013-10-29
    * @since       20.0    
    * @version     1.0 
    *
    * 
    * 2013-10-29 Weihang Li <Weihang.Li@itbconsult.com>
    * @Created
    *
    */
    public void initItems(){
    	if(fieldType != ''){
	    	if(fieldType == 'BOOLEAN'){
	    		list_items.add('True');
	    		list_items.add('false');
	    		isShowBol = true;
	    	}else if(fieldType == 'PICKLIST'){
	    		list_items.addAll(getPicklistValues(objName,fieldName));
	    		isShowBol = true;
	    	}else if(fieldType == 'REFERENCE'){
	    		list_refInfos.addAll(getLKPValues(referenceObj));
	    		isShowBol = true;
	    	}
    	}
    }
    /**
    * This method is used to search result
    *
    * @author      Weihang Li
    * @created     2015-12-22
    * @since       20.0    
    * @version     1.0 
    *
    * 
    * 2013-10-29 Weihang Li <Weihang.Li@itbconsult.com>
    * @Created
    *
    */
    public void searchResult(){
    	list_refInfos.clear();
    	list_refInfos.addAll(getLKPValues(referenceObj));
    }
    /**
    * This method is used to get picklist field value.
    *
    * @author      Weihang Li
    * @created     2015-12-21
    * @since       29.0    
    * @version     1.0 
    *
    * 
    * 2013-10-29 Weihang Li <Weihang.Li@oinio.com>
    * @Created
    *
    */
    public list<referenceInfo> getLKPValues(String referenceObj){
    	list<referenceInfo> list_lkpItems = new list<referenceInfo>();
    	list_lkpItems.clear();
    	String sql = 'select Id,Name from '+referenceObj+' where id != null '; 
    	if(searchStr != ''){
    		searchStr = searchStr.trim();
    		sql += ' and Name like \'%'+searchStr+'%\'';
    	}
    	sql +=' order by LastModifiedDate desc limit 200';
    	for(sobject obj:database.query(sql)){
    		String rdId = String.valueOf(obj.get('Id'));
    		String rdName = String.valueOf(obj.get('Name'));
    		list_lkpItems.add(new referenceInfo(rdId,rdName));
    	}
    	return list_lkpItems;
    }
	/**
    * This method is used to get picklist field value.
    *
    * @author      Weihang Li
    * @created     2015-12-21
    * @since       29.0    
    * @version     1.0 
    *
    *  
    * 2013-10-29 Weihang Li <Weihang.Li@oinio.com>
    * @Created
    *
    */
    public List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 
	    List<String> lstPickvals=new List<String>();
	    Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);
	    Sobject Object_name = targetType.newSObject();
	    Schema.sObjectType sobject_type = Object_name.getSObjectType(); 
	    Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); 
	    Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); 
	    List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); 
	    for (Schema.PicklistEntry a : pick_list_values) { 
	    	lstPickvals.add(a.getLabel());
	    	map_pickLabel_pickVal.put(a.getLabel(),a.getValue());
	    }
	    return lstPickvals;
    }
    public class referenceInfo{
    	public String recordId{get;set;}
    	public String recordName{get;set;}
    	public referenceInfo(String recordId,String recordName){
    		this.recordId = recordId;
    		this.recordName = recordName;
    	}
    }
}