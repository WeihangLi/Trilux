/**
*Controller class for page ExtOpportunityQuoteHierarchies
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
public with sharing class ExtOpportunityQuoteHierarchies {
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public String oppId {get;set;}
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    public ExtOpportunityQuoteHierarchies(ApexPages.StandardController stdCtrl) {
    	oppId = ApexPages.currentPage().getParameters().get('id');
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