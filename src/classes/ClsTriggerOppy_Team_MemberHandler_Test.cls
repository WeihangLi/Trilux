/**
 *  This Class is Test Class for ClsTriggerOpportunity_Team_MemberHandler.
 *
 * @author Mei Xing
 * @created 2016-02-16
 * @version 1.0
 * @since 35.0
 *
 * @changelog
 *  2015-02-16 Mei Xing <mei.xing@oinio.com>
 *  - Created
 * @coverage 98%
 */
@isTest 
private class ClsTriggerOppy_Team_MemberHandler_Test {

    static testMethod void createOTM() {
        // TO DO: implement unit test
        list<Opportunity_Team_Member__c> list_OTM = new list<Opportunity_Team_Member__c>();
        list<User> list_user = new list<User>();
        
        //User user01 = [Select Id,District__c from User where Id = '00525000000za8J'];
        //User user02 = [Select Id,District__c from User where Id = '00525000000zaaI'];
        //User user03 = [Select Id,District__c from User where Id = '00525000000zek2'];
        
        User user01 = new User();
        user01.FirstName ='sdf11';
        user01.LastName = 'reg11';
        user01.Username = 'impriv1ate1@imprivate.com';
        user01.Alias = 'mtst11';
        user01.Email = 'mteste1r@company.com';
        user01.CommunityNickname = user01.Alias;
        user01.ProfileId = [Select Id from Profile Where Name = 'Systemadministrator' OR Name = 'System Administrator' limit 1].Id;
        user01.TimeZoneSidKey = 'America/Chicago';
        user01.LocaleSidKey = 'en_US';
        user01.EmailEncodingKey = 'UTF-8';
        user01.LanguageLocaleKey = 'en_US';
        user01.Sales_Group__c = '118';
        user01.District__c = '0100D3';
        insert user01;
        
        
        User user02 = new User();
        user02.FirstName ='sdf12';
        user02.LastName = 'reg12';
        user02.Username = 'impr2ivate1@imprivate.com';
        user02.Alias = 'mtst12';
        user02.Email = 'mtest2er@company.com';
        user02.CommunityNickname = user02.Alias;
        user02.ProfileId = [Select Id from Profile Where Name = 'Systemadministrator' OR Name = 'System Administrator' limit 1].Id;
        user02.TimeZoneSidKey = 'America/Chicago';
        user02.LocaleSidKey = 'en_US';
        user02.EmailEncodingKey = 'UTF-8';
        user02.LanguageLocaleKey = 'en_US';
        user02.Sales_Group__c = '118';
        user02.District__c = '0100D2';
        insert user02;
        
        User user03 = new User();
        user03.FirstName ='sdf13';
        user03.LastName = 'reg14';
        user03.Username = 'imp4rivate1@imprivate.com';
        user03.Alias = 'mtst41';
        user03.Email = 'mtest4er@company.com';
        user03.CommunityNickname = user03.Alias;
        user03.ProfileId = [Select Id from Profile Where Name = 'Systemadministrator' OR Name = 'System Administrator' limit 1].Id;
        user03.TimeZoneSidKey = 'America/Chicago';
        user03.LocaleSidKey = 'en_US';
        user03.EmailEncodingKey = 'UTF-8';
        user03.LanguageLocaleKey = 'en_US';
        user03.Sales_Group__c = '118';
        user03.District__c = '0100D1';
        insert user03;
        
        
        user01.District__c = 'www';
        user02.District__c = 'www';
        user03.District__c = 'www';
        list_user.add(user01);
        list_user.add(user02);
        list_user.add(user03);
        update list_user;

        Account acc = ClsTestHelp.createTestAccounts();
        acc.BillingStreet = 'Hu Min Rd';
        acc.BillingCountry = 'China';
        acc.BillingCity = 'Shanghai';
        insert acc;
       
        
        Trilux_Project__c Pro01 = new Trilux_Project__c(Project_Name__c='pro01',Public_Authorities__c='Public',Project_Location_City__c='WuXi',Project_Location_Country__c='CN',Project_Location_Postal_Code__c='12345');
        insert Pro01;
        
        Opportunity oppy1 = new Opportunity(Name='oppy1',AccountId=acc.Id,Related_Project__c=Pro01.Id,StageName='Budgeting',SORG__c='0001',Vertical_Market__c='Office & Administration',Application_Area__c='01',CloseDate=date.today().addDays(2));
        Opportunity oppy2 = new Opportunity(Name='oppy2',AccountId=acc.Id,Related_Project__c=Pro01.Id,StageName='Budgeting',SORG__c='0032',Vertical_Market__c='Office & Administration',Application_Area__c='02',CloseDate=date.today().addDays(2));
        oppy1.Sales_Regions__c = '0100';
        oppy2.Sales_Regions__c = '0100';
        insert oppy1;
        insert oppy2;
        
        Opportunity_Team_Member__c OppyTM01 = new Opportunity_Team_Member__c(Opportunity__c=oppy1.Id,User__c=user01.Id,Team_Role__c='Project Manager',Is_Project_Decider__c=true);
        Opportunity_Team_Member__c OppyTM02 = new Opportunity_Team_Member__c(Opportunity__c=oppy1.Id,User__c=user02.Id,Team_Role__c='Sales Engineer',Is_Key_Account_Manager__c=true);
        Opportunity_Team_Member__c OppyTM03 = new Opportunity_Team_Member__c(Opportunity__c=oppy1.Id,User__c=user03.Id,Team_Role__c='Internal Sales Contact');
        
        Opportunity_Team_Member__c OppyTM04 = new Opportunity_Team_Member__c(Opportunity__c=oppy2.Id,User__c=user01.Id,Team_Role__c='Project Manager',Is_Project_Decider__c=true);
        Opportunity_Team_Member__c OppyTM05 = new Opportunity_Team_Member__c(Opportunity__c=oppy2.Id,User__c=user02.Id,Team_Role__c='Internal Sales Contact',Is_Key_Account_Manager__c=true);
        
        list_OTM.add(OppyTM01);
        list_OTM.add(OppyTM02);
        list_OTM.add(OppyTM03);
        list_OTM.add(OppyTM04);
        list_OTM.add(OppyTM05);
        insert list_OTM;
        
        list<OpportunityTeamMember> standOppyTeamMem = [Select Id From OpportunityTeamMember where id =:oppy1.Id limit 1 ];
        system.assert(oppy1.Project_Manager__c != user01.Id);
        OppyTM01.Is_Project_Decider__c=false;
        OppyTM02.Is_Project_Decider__c=false;
        OppyTM03.Is_Project_Decider__c=true;
        
        //OppyTM04.Team_Role__c='Internal Sales Contact';
        OppyTM05.Is_Key_Account_Manager__c=false;
        
        list_OTM.clear();
        list_OTM.add(OppyTM01);
        list_OTM.add(OppyTM02);
        list_OTM.add(OppyTM03);
        list_OTM.add(OppyTM04);
        list_OTM.add(OppyTM05);
        update list_OTM;

        //delete list_OTM;
        
    }
}