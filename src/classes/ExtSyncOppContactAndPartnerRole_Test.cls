/*  Test class for class ExtSyncOppContactAndPartnerRole
 *
 @author Lili Zhao
 @created 2016-04-13
 @version 1.0
 @since 35.0
 *
 @return
 *
 @changelog
 * 2016-04-13 Lili Zhao <lili.zhao@itbconsult.com>
 * - Created
 *- Test coverage 100%
 */
@isTest 
private class ExtSyncOppContactAndPartnerRole_Test {

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
        acc2.type = 'PROS';
        acc2.Deletion_Flag__c = false;
        insert acc2;
        
        
        Contact con = ClsTestHelp.createTestContacts();
        con.FirstName = 'sdf';
        con.AccountId = acc.Id;
        con.salutation = 'testcon';
        insert con;
        
        Contact con1 = ClsTestHelp.createTestContacts();
        con1.FirstName = 'sdf1';
        con1.AccountId = acc2.Id;
        con1.salutation = 'testcon1';
        insert con1;
        
        Trilux_Project__c project = new Trilux_Project__c();
        project.Project_Name__c = 'EDEKA Hansen -Köln';
        project.Project_Location_City__c = 'Kölner Straße 12';
        project.Project_Location_Postal_Code__c = '201100';
        project.Project_Location_Country__c = 'Shanghai';
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
        insert opp;
        
        Opportunity_Partner__c oppPartnerc = new Opportunity_Partner__c();
        oppPartnerc.Opportunity__c = opp.Id;
        oppPartnerc.Partner_Account__c = acc2.Id;
        oppPartnerc.Partner_Role__c = 'Koordinator';
        oppPartnerc.Primary__c = true;
        insert oppPartnerc;
        
        list<OpportunityContactRole> list_oppyContactRoles = new list<OpportunityContactRole>();
        OpportunityContactRole conRole2 = new OpportunityContactRole();
        conRole2.OpportunityId = opp.Id;
        conRole2.ContactId = con.Id;
        conRole2.Role = 'test21';
        insert conRole2;
        
        OpportunityContactRole conRole3 = new OpportunityContactRole();
        conRole3.OpportunityId = opp.Id;
        conRole3.ContactId = con.Id;
        conRole3.Role = 'test13';
        
        
        Project_Contact_Role__c proRole = new Project_Contact_Role__c();
        proRole.Contact_Name__c = con1.Id;
        proRole.Project__c = project.Id;
        insert proRole;
        
        Project_Partner_Role__c parRole = new Project_Partner_Role__c();
        parRole.Account_Name__c = acc.Id;
        parRole.Project__c = project.Id;
        insert parRole;
        
        
        Test.startTest();
        Project_Contact_Role__c role = [Select Id from Project_Contact_Role__c where Project__c =: project.Id limit 1];
        ApexPages.StandardController stdCtrl = new ApexPages.Standardcontroller(opp);
        ExtSyncOppContactAndPartnerRole ext = new ExtSyncOppContactAndPartnerRole(stdCtrl);  
        ext.opp = opp;    
        ext.syncOppContactAndPartnerRole();
        system.assert(role.Id != null);  
        Test.stopTest();
    }
    
}