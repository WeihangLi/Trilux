/**
 *  This Class is Test Class for ClsTriggerUserHandler.
 *
 * @author Lili Zhao
 * @created 2016-05-11
 * @version 1.0
 * @since 35.0
 *
 * @changelog
 *  2016-05-11 Lili Zhao <lili.zhao@oinio.com>
 *  - Created
 * @coverage 96%
 */
@isTest 
private class ClsSearchOpportunityController_Test {

    static testMethod void myUnitTest() {   
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.BillingStreet = 'Hu Min Rd';
        acc.BillingCountry = 'China';
        acc.BillingCity = 'Shanghai';
        acc.type = 'PROS';
        acc.Deletion_Flag__c = false;
        insert acc;
        
        Account acc2 = new Account();
        acc2.Name = 'Partern Account1';
        acc2.BillingCountry = 'Germany';
        acc2.BillingCity = 'Berlin';
        acc2.BillingStreet = 'test street2';
        acc2.External_ID_SAP__c = 'test';
        acc2.type = 'PROS';
        acc2.Deletion_Flag__c = false;
        insert acc2;
        
        
        Contact con = ClsTestHelp.createTestContacts();
        con.FirstName = 'sdf';
        con.AccountId = acc.Id;
        con.salutation = 'testcon';
        insert con;
        
        Trilux_Project__c project = new Trilux_Project__c();
        project.Project_Name__c = 'EDEKA Hansen -Köln';
        project.Project_Location_City__c = 'Kölner Straße 12';
        project.Project_Location_Postal_Code__c = '201100';
        project.Project_Location_Country__c = 'Shanghai';
        project.Project_Location_Street__c = 'Shanghai';
        insert project;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.name = 'Test Opp';
        opp.StageName = '01';
        opp.CloseDate = Date.newInstance(2016,1,1);
        opp.Related_Project__c = project.Id;
        opp.Sales_Channels__c = '01';
        opp.SORG__c = '0001';
        opp.Statistic_Flag__c = 'BRU';
        opp.Vertical_Market__c = '01';
        opp.Application_Area__c = '01';
        opp.Sales_Regions__c = '0100';
        opp.Follow_Opportunity__c = true;
        //opp.Creation_Date__c = system.today();
        insert opp;
        
        Opportunity_Partner__c oppPartnerc = new Opportunity_Partner__c();
        oppPartnerc.Opportunity__c = opp.Id;
        oppPartnerc.Partner_Account__c = acc2.Id;
        oppPartnerc.Partner_Role__c = 'Koordinator';
        oppPartnerc.Primary__c = true;
        insert oppPartnerc;
        
        User user01 = new User();
        user01.FirstName ='sdf1';
        user01.LastName = 'reg1';
        user01.Username = 'imprivate1@imprivate.com';
        user01.Alias = 'mtst1';
        user01.Email = 'mtester@company.com';
        user01.CommunityNickname = user01.Alias;
        user01.ProfileId = [Select Id from Profile Where Name = 'Systemadministrator' OR Name = 'System Administrator' limit 1].Id;
        user01.TimeZoneSidKey = 'America/Chicago';
        user01.LocaleSidKey = 'en_US';
        user01.EmailEncodingKey = 'UTF-8';
        user01.LanguageLocaleKey = 'en_US';
        user01.Sales_Group__c = '118';
        user01.District__c = '0100DB';
        insert user01;
        
        Opportunity_Team_Member__c OppyTM01 = new Opportunity_Team_Member__c(Opportunity__c=opp.Id,User__c=user01.Id,Team_Role__c='Project Manager',Is_Project_Decider__c=true);
        insert OppyTM01;
        
        Quote__c qu = new Quote__c();
        qu.Opportunity__c = opp.Id;
        qu.Sales_Doc_Type__c = 'AF';
        qu.Quote_Total__c = 100;
        qu.Quote_Account__c = acc.id;
        qu.Specification_No__c = 'test';
        qu.Specification_Date__c = system.today();
        insert qu;        
        
        Quote_Line_Item__c lineItem = new Quote_Line_Item__c();
        lineItem.Quote__c = qu.Id;
        lineItem.Product_Name__c = 'test';
        lineItem.Quantity__c = 100;
        lineItem.Product_Code__c = 'test';
        lineItem.Description__c = 'test';
        insert lineItem;
        
        Schema.DescribeSObjectResult objDescribe = Trilux_Project__c.getSObjectType().getDescribe();
        
        String filter_Str = '';
        filter_Str += '[{"objName":"Opportunity","fieldName":"Related_Project__r.Project_Name__c","operator":"equals to","fieldVal":"EDEKA Hansen -Köln","fieldType":"String"},'
                    + '{"objName":"Opportunity","fieldName":"Related_Project__r.Project_Location_City__c","operator":"contains","fieldVal":"12","fieldType":"String"},'
                    + '{"objName":"Opportunity","fieldName":"Related_Project__r.Project_Location_Country__c","operator":"equals to","fieldVal":"Shanghai","fieldType":"PICKLIST"},'
                    + '{"objName":"Opportunity","fieldName":"Related_Project__r.Project_Location_Street__c","operator":"contains","fieldVal":"Shanghai","fieldType":"String"}, '
                    + '{"objName":"Opportunity","fieldName":"Name","operator":"contains","fieldVal":"Test","fieldType":"String"},' 
                    + '{"objName":"Opportunity","fieldName":"Sales_Channels__c","operator":"equals to","fieldVal":"01","fieldType":"PICKLIST"},'
                    + '{"objName":"Opportunity","fieldName":"Statistic_Flag__c","operator":"equals to","fieldVal":"BRU","fieldType":"PICKLIST"},'
                    + '{"objName":"Opportunity","fieldName":"Creation_Date__c","operator":"greater or equal","fieldVal":"2015-10-06","fieldType":"DATE"},'
                    + '{"objName":"Opportunity","fieldName":"CreatedById","operator":"equals to","fieldVal":"'+userInfo.getUserId()+'","fieldType":"Reference"},'
                    + '{"objName":"Opportunity_Team_Member__c","fieldName":"User__c","operator":"equals to","fieldVal":"'+ user01.Id+'","fieldType":"Reference"},'
                    + '{"objName":"Opportunity_Partner__c","fieldName":"Partner_Account__r.External_ID_SAP__c","operator":"contains","fieldVal":"test","fieldType":"String"},'
                    + '{"objName":"Quote_Line_Item__c","fieldName":"Product_Name__c","operator":"contains","fieldVal":"test","fieldType":"String"},'
                    + '{"objName":"Quote_Line_Item__c","fieldName":"Quantity__c","fieldVal":"0,100000","fieldType":"Double"},'
                    + '{"objName":"Quote_Line_Item__c","fieldName":"Product_Code__c","operator":"contains","fieldVal":"test","fieldType":"String"},'
                    + '{"objName":"Quote__c","fieldName":"Specification_No__c","operator":"contains","fieldVal":"test","fieldType":"String"},'
                    + '{"objName":"Quote_Line_Item__c","fieldName":"Description__c","operator":"contains","fieldVal":"test","fieldType":"String"},'
                    + '{"objName":"Quote__c","fieldName":"Specification_Date__c","operator":"greater or equal","fieldVal":"2003-10-02","fieldType":"Date"}]';

        Test.startTest();
        
        ClsSearchOpportunityController.getCurrentUserLocaleSidKeyLabel();
        ClsSearchOpportunityController.initPickListItems();
        ClsSearchOpportunityController.getPickFieldLabelValue(objDescribe, 'Project_Location_Country__c');
        list<ClsSearchOpportunityController.customOpportunity> list_oppys = ClsSearchOpportunityController.searchResult(filter_Str);
        System.assertEquals(true, list_oppys.size() > 0);
        Test.stopTest();
    }
}