/**
 *   This class is used to set account id
 *
 * @author weihang li
 * @created 2016-02-23
 * @version 1.0 
 * @since 31.0
 *
 * @changelog
 *  2016-02-23 weihang li <weihang.li@oinio.com>
 * - Created 
 * 
 */
public with sharing class ExtCreateOpportunity {
    //********************************* -=BEGIN public members=- ************************************
    public Opportunity opp {get;set;}
    private map<String, String> map_urlParams;   //added lili zhao 2016-05-12 begin
    //********************************* -=END public members=- ************************************
    //********************************* -=BEGIN private members=- ************************************
    //********************************* -=END private members=- ************************************
    //********************************* -=BEGIN CONSTRUCTOR=- ***************************************
    public ExtCreateOpportunity(ApexPages.StandardController stdCtrl){
        opp = new Opportunity();
        setDummyAccount();
    }
    //********************************* -=END CONSTRUCTOR=- ***************************************
    //********************************* -=BEGIN Public Methods =- ***********************************
    /**
     *   This method is used to set dummy account
     *
     * @author weihang li
     * @created 2016-02-23
     * @version 1.0
     * @since 31.0
     *
     * @changelog
     *  2016-02-23 weihang li <weihang.li@oinio.com>
     * - Created 
     * 
     */
    public void setDummyAccount(){
    	this.map_urlParams = ApexPages.currentPage().getParameters(); 
        String projectId = '';
        String proCustomName = '';
        
        //added lili zhao 2016-05-12 begin 
        
        String accId = '';
        String vkorg = '';
        String opp3= '';
        
        if(this.map_urlParams.containsKey('proId')) projectId = this.map_urlParams.get('proId'); 
        if(this.map_urlParams.containsKey('pName')) proCustomName = this.map_urlParams.get('pName');        
        
        if(this.map_urlParams.containsKey('accid')) accId = this.map_urlParams.get('accid');
        if(this.map_urlParams.containsKey('vkorg')) vkorg = this.map_urlParams.get('vkorg');
        if(this.map_urlParams.containsKey('opp3')) opp3 = this.map_urlParams.get('opp3');
        //end
       
        Dummy_Account_for_Opportunities__c daf = Dummy_Account_for_Opportunities__c.getInstance('Single Account Id');
        Account acc = new Account();
        if(daf != null && daf.Dummy_Account_ID__c != null && daf.Dummy_Account_ID__c != ''){
            acc = [select Id,Name from Account where id =: daf.Dummy_Account_ID__c];
        }
        User us = [select Id,Name,VKORG__c from User where id =: UserInfo.getUserId()];
        //opp.AccountId = acc.Id;
        opp.AccountId = (accId != '' ? accId : acc.Id);
        if(vkorg != '') opp.SORG__c = vkorg;
        //opp.SORG__c = us.VKORG__c;
        
        
        if(projectId != '' && projectId != null){
            opp.Related_Project__c = projectId;
        }
        /*
        if(proCustomName != ''){
            opp.Name = proCustomName;
        }
        */
        if(opp3 != '') {
        	opp.Name = opp3;
        }
    }
    /**
     *   This method is used save opportunity
     *
     * @author weihang li
     * @created 2016-02-23
     * @version 1.0
     * @since 31.0
     *
     * @changelog
     *  2016-02-23 weihang li <weihang.li@oinio.com>
     * - Created 
     * 
     */
    public PageReference saveOpp(){
        insert opp;
        PageReference pa = new PageReference('/'+opp.Id);
        return pa;
    }
    public PageReference saveNew(){
        insert opp;
        String url = ApexPages.currentPage().getURL();
         if(Test.isRunningTest()){
            return null;
        }else{
            PageReference pa = new PageReference(url);
            return pa;
        }
    }
    /**
     *   This method is cancel
     *
     * @author weihang li
     * @created 2016-02-23
     * @version 1.0
     * @since 31.0
     *
     * @changelog
     *  2016-02-23 weihang li <weihang.li@oinio.com>
     * - Created 
     * 
     */
    public PageReference cancel(){
        String url = ApexPages.currentPage().getParameters().get('retURL');
        PageReference pa = new PageReference(url);
        return pa;
    }
}