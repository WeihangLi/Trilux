/**
*Controller class for page ExtProjectQuoteHierarchies
*
@author  weihang li
@created  2016-03-15
@version  1.0
@since  36.0 (Force.com ApiVersion)
*
@changelog
*2016-03-15 weihang li <weihang.li@oinio.com>
*-Created
*/
public with sharing class ExtProjectQuoteHierarchies {
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public String projectId {get;set;}
	public String oppId {get;set;}
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    public ExtProjectQuoteHierarchies(ApexPages.StandardController stdCtrl) {
    	oppId = '';
    	projectId = ApexPages.currentPage().getParameters().get('id');
    	for(Opportunity opp:[select Id from Opportunity where Related_Project__c =: projectId]){
    		oppId += opp.Id + ',';
    	}
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- /////////////////////////////////////
    /**
    * this method is used to  
    *
    @author Weihang Li
    @created 2016-03-15
    @version 1.0
    @since 36.0 (Force.com ApiVersion)
    *
    @changelog
    * 2016-03-15 Weihang Li <weihang.li@oinio.com>
    * - Created  
    */
}