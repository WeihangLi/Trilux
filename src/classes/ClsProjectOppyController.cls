/**
 *  StroyId: R-395 
 *  Project and Opportunity Component/VFP (Online)
 *
 @author  Hui Qin
 @ 2016-2-17
 @version 1.0
 *
 * - Created    
 */ 
global with sharing class ClsProjectOppyController {
    /*
    @AuraEnabled
    public static void createProjectOppyList(Trilux_Project__c proj, List<Opportunity> oppyList) {
        system.debug('---------------------------------------Here is project:' + proj);
        system.debug('---------------------------------------Here is list:' + oppyList);
        insert proj;
        String accId = '';
        if(Lightning_Project_Setting__c.getInstance('Single Account Id') != null && Lightning_Project_Setting__c.getInstance('Single Account Id').Value__c != null ) 
        accId = Lightning_Project_Setting__c.getInstance('Single Account Id').Value__c;
        for(Account account : [Select Id, Name From Account Where Id =: accId]) {
            accId = account.Id;
        }
        for(Opportunity oppy : oppyList){
            oppy.Related_Project__c = proj.Id;
            oppy.AccountId = (accId == '' ? null : accId);
            oppy.OwnerId = userinfo.getUserId();
            oppy.Name = proj.Project_Name__c;
        }
        insert oppyList;
        return;
    }
    */
    @AuraEnabled
    public static ResponsesInfo createProjectOppy(Trilux_Project__c proj, Opportunity oppy, Boolean isDefault) {
        ResponsesInfo info = new ResponsesInfo();
        boolean isAdmin = false;
        boolean isError = false;
        if(proj.Project_Name__c == null || proj.Public_Authorities__c == '' || 
           proj.Project_Location_City__c == null || proj.Project_Location_Country__c == '' || 
           proj.Project_Location_Postal_Code__c == null ) {
            info.success = false;
            info.errorMessage = ' You must enter a value for required field';
            return info;
        }
        for(User user : [select Profile.Name 
                         From User 
                         where id =: UserInfo.getUserId() 
                         And Profile.Name = 'System Administrator']) {
            isAdmin = true;
        }
        try{       
            if(isDefault == true) oppy.CloseDate = date.newInstance(3500, 1, 1);
            if(oppy.Name == null || oppy.AccountId == null || oppy.StageName == '' || 
               oppy.SORG__c == '' || oppy.CloseDate == null || oppy.Vertical_Market__c == '' || 
               oppy.Application_Area__c == '' || oppy.Statistic_Flag__c == '' || 
               oppy.Sales_Channels__c == '') {
                isError = true;
                if(!isAdmin) {
                    info.success = false;
                    info.errorMessage = ' You can not create a project without an opportunity, You must enter a value for required field';
                    return info;
                }
            }
            insert proj;
            system.debug('isError::: '+ isError);
            info.oppyId = proj.Id;
            if(!isError) {
                oppy.Related_Project__c = proj.Id;
                oppy.OwnerId = userinfo.getUserId();
                oppy.Name = proj.Project_Name__c;
                if(oppy.Statistic_Flag__c == 'SO') {
                    oppy.Follow_Opportunity__c = false;
                }else {
                    oppy.Follow_Opportunity__c = true;
                }
                
                //Start added by Yuda Zheng <yuda.zheng@oinio.com> 2016-03-28 for R-560
                if(oppy.Statistic_Flag__c == 'V'){
                    oppy.StageName = '01';
                }else if(oppy.Statistic_Flag__c == 'K'){
                    oppy.StageName = '03';
                }else if(String.valueOf(oppy.Statistic_Flag__c).indexOf('X') == 0){
                    oppy.StageName = '19';
                    oppy.Opportunity_Lost_Reason__c = 'Cancelled by TX';
                }else{
                    oppy.StageName = '08';
                }
                //End added by Yuda Zheng <yuda.zheng@oinio.com> 2016-03-28 for R-560
                
                insert oppy; 
                info.oppyId = oppy.Id;
            }
            info.success = true;
            
            return info;
            
            //return oppy.Id;
        }
        catch(Exception ex){
            info.success = false;
            info.errorMessage = ' '+ex.getMessage();
            return info;
            //return ex.getMessage();
        } 
        
        
    }
    
    global class PickListWrapper{
        
        @AuraEnabled
        List<CustomSelectOption> publicAuthorityList {get; set;}
        
        @AuraEnabled
        List<CustomSelectOption> publicCountryList {get; set;}
        
        @AuraEnabled
        List<CustomSelectOption> stageList {get; set;}
        @AuraEnabled
        List<CustomSelectOption> sOrgList {get; set;}
        @AuraEnabled
        List<CustomSelectOption> verticalMarketList {get; set;}
        @AuraEnabled
        List<CustomSelectOption> applicationAreaList {get; set;}
        @AuraEnabled
        List<CustomSelectOption> builtList {get; set;} 
        @AuraEnabled
        List<CustomSelectOption> flagList {get; set;}        
        @AuraEnabled
        String userSorg {get; set;} 
        @AuraEnabled
        String userCountry {get; set;} 
        @AuraEnabled
        String closeDate {get; set;}  
		@AuraEnabled
        String userCurrency {get; set;} 
        @AuraEnabled
        Date defaultCloseDate {get; set;} 
        
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
    
    @AuraEnabled
    public static PickListWrapper initProjectOppy(){
        
        system.debug('---------------------------------------init pickup list:');
        User user = new User();
        for(User u : [Select VKORG__c, LocaleSidKey, DefaultCurrencyIsoCode  From User Where Id =: userInfo.getUserId()]) {                      
            user = u;
        }
        
        Schema.DescribeFieldResult fieldResult;
        
        PickListWrapper pw = new PickListWrapper(); 
        
        //init private/public
        fieldResult = Trilux_Project__c.Public_Authorities__c.getDescribe();
        pw.publicAuthorityList = getPicklist(fieldResult);
        
        fieldResult = Trilux_Project__c.Project_Location_Country__c.getDescribe();
        pw.publicCountryList = getPicklist(fieldResult);
        pw.userCountry = user.LocaleSidKey;
        pw.userCurrency = '';
		if(user.DefaultCurrencyIsoCode  != null) pw.userCurrency = user.DefaultCurrencyIsoCode ;
        
        //init stage
        fieldResult = Opportunity.StageName.getDescribe();
        pw.stageList = getPicklist(fieldResult);

        //int sOrg
        fieldResult = Opportunity.SORG__c.getDescribe();                        
        pw.sOrgList = getPicklist(fieldResult);
        pw.userSorg = user.VKORG__c;
        pw.closeDate = date.newInstance(3500, 1, 1).format() + ' ';
        pw.defaultCloseDate = date.newInstance(3500, 1, 1);
        
        //init VerticalMarket
        fieldResult = Opportunity.Vertical_Market__c.getDescribe();
        pw.verticalMarketList = getPicklist(fieldResult);
        
        //init ApplicationArea
        fieldResult = Opportunity.Application_Area__c.getDescribe();
        pw.applicationAreaList = getPicklist(fieldResult);
        
        //init built
        fieldResult = Opportunity.Type.getDescribe();
        pw.builtList = getPicklist(fieldResult);
        
        //init Statistic Flag
        fieldResult = Opportunity.Statistic_Flag__c.getDescribe();
        pw.flagList = getPicklist(fieldResult);
        
        if(pw.userCountry != null) {
            string countryStr = pw.userCountry.split('_')[1];
            pw.userCountry = countryStr;
        }
        
        System.debug('-----------------pw pw pw pw pw: ' + pw);
        
        return pw;
    }
    
    @AuraEnabled
    public static Account initOppyAccount(){
        
        String accId = '';
        Account acc = new Account();
        if(Lightning_Project_Setting__c.getInstance('Single Account Id') != null && Lightning_Project_Setting__c.getInstance('Single Account Id').Value__c != null ) 
        accId = Lightning_Project_Setting__c.getInstance('Single Account Id').Value__c;
        for(Account account : [Select Id, Name From Account Where Id =: accId]) {
            acc = account;
        }
        return acc;
    }
    
    @AuraEnabled
    public static String getUserName() {
        return userinfo.getName();
    }
    
    private static List<CustomSelectOption>  getPicklist(Schema.DescribeFieldResult fieldResult){
        
        List<CustomSelectOption> options = new List<CustomSelectOption>();
        
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new CustomSelectOption(f.getValue(), f.getLabel()));
        }       
        return options;
    }
   
    @AuraEnabled
    public static List<Trilux_Project__c> getContacts() {
        return [
            SELECT Id, Project_Location_Country__c,Project_Location_State__c
            FROM Trilux_Project__c
            LIMIT 10
        ];
    }
    
    public class ResponsesInfo{
        @AuraEnabled
        Boolean success {get;set;}
        @AuraEnabled
        String errorMessage {get;set;} 
        @AuraEnabled
        String oppyId {get;set;}
        ResponsesInfo(){
            this.success = false;         
        }
    }

}