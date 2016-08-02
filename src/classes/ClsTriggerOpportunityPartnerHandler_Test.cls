/**
 *  This Class is Test Class for ClsTriggerOpportunityPartnerHandler.
 *
 * @author Yuda Zheng
 * @created 2015-12-23
 * @version 1.0
 * @since 35.0
 *
 * @changelog
 *  2015-12-23 Yuda Zheng <yuda.zheng@oinio.com>
 *  - Created
 * @coverage 96%
 */
@isTest
private class ClsTriggerOpportunityPartnerHandler_Test {

    static testMethod void myUnitTest() {
        Trilux_Project__c project = new Trilux_Project__c();
        project.Project_Name__c = 'EDEKA Hansen -Köln';
        project.Project_Location_City__c = 'Kölner Straße 12';
        project.Project_Location_Postal_Code__c = '99999';
        project.Sales_Region__c = '0100';
        project.Project_Location_Country__c = 'NL';
        insert project;

        Account acc1 = new Account();
        acc1.BillingCountry = 'china';
        acc1.BillingCity = 'xian';
        acc1.BillingStreet = 'test street';
        acc1.Name = 'Host Account';
        acc1.type = 'PROS';
        acc1.Deletion_Flag__c = false;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.Name = 'Partern Account1';
        acc2.BillingCountry = 'Germany';
        acc2.BillingCity = 'Berlin';
        acc2.BillingStreet = 'test street2';
        acc2.type = 'PROS';
        acc2.Deletion_Flag__c = false;
        insert acc2;
        
        Account acc3 = new Account();
        acc3.Name = 'Partern Account2';
        acc3.BillingCountry = 'France';
        acc3.BillingCity = 'Paris';
        acc3.BillingStreet = 'test street3';
        acc3.type = 'PROS';
        acc3.Deletion_Flag__c = false;
        insert acc3;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc1.Id;
        opp.name = 'Test Opp Partner';
        opp.StageName = 'Prospecting';
        opp.CloseDate = Date.newInstance(2016,1,1);
        opp.Related_Project__c = project.Id;
        opp.Sales_Channels__c = '01';
        opp.SORG__c = '0001';
        opp.Sales_Regions__c = '0100';
        insert opp;
        
        Test.startTest();
        
        Opportunity_Partner__c oppPartnerc = new Opportunity_Partner__c();
        oppPartnerc.Opportunity__c = opp.Id;
        oppPartnerc.Partner_Account__c = acc2.Id;
        oppPartnerc.Partner_Role__c = 'Koordinator';
        oppPartnerc.Primary__c = true;
        insert oppPartnerc;
        
        Partner oppPartner;
        
        for(Partner ptn : [select Id, OpportunityId, AccountToId from Partner where AccountToId =: acc2.Id  and OpportunityId =: opp.Id]){
            oppPartner = ptn;
        }
        system.assert(oppPartner != null);
        
        oppPartnerc.Primary__c = false;
        
        update oppPartnerc;
        
        for(Partner ptn : [select Id, OpportunityId, AccountToId, IsPrimary from Partner where AccountToId =: acc2.Id  and OpportunityId =: opp.Id]){
            oppPartner = ptn;
        }
        system.assert(oppPartner.IsPrimary == false);

        oppPartnerc.Partner_Account__c = acc3.Id;
        
        update oppPartnerc;
        
        for(Partner ptn : [select Id, OpportunityId, AccountToId from Partner where AccountToId =: acc3.Id  and OpportunityId =: opp.Id]){
            oppPartner = ptn;
        }
        system.assert(oppPartner != null);

        delete oppPartnerc;

        oppPartner = null;
        
        for(Partner ptn : [select Id, OpportunityId, AccountToId from Partner where AccountToId =: acc3.Id  and OpportunityId =: opp.Id]){
            oppPartner = ptn;
        }
        system.assert(oppPartner == null);
        
        Test.stopTest();
    }
}