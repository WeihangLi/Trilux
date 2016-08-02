/**
 *  This Class is Test Class for ClsTriggerAccountHandler.
 *
 * @author Yuda Zheng
 * @created 2015-12-17
 * @version 1.0
 * @since 35.0
 *
 * @changelog
 *  2015-12-17 Yuda Zheng <yuda.zheng@oinio.com>
 *  - Created
 * @coverage 99%
 */
@isTest
private class ClsTriggerAccountTeamHandler_Test {

    static testMethod void myUnitTest() {
        //create Account
        Account acc1;
        User u1;
        User u2;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        System.runAs ( thisUser ) {
            acc1 = new Account();
            acc1.BillingStreet = 'Hu Min Rd';
            acc1.BillingCountry = 'China';
            acc1.BillingCity = 'Shanghai';
            acc1.Name = 'Test Team';
            
            insert acc1;
            
            u1 = new User();
            u1.FirstName ='AccountTeam1';
            u1.LastName = 'Test';
            u1.Username = 'AccountTeam1@Test.com';
            u1.Alias = 'Atm1Test';
            u1.Email = 'AccountTeam1@company.com';
            u1.CommunityNickname = u1.Alias;
            u1.ProfileId = [Select Id from Profile Where Name = 'Systemadministrator' OR Name = 'System Administrator' limit 1].Id;
            u1.TimeZoneSidKey = 'America/Chicago';
            u1.LocaleSidKey = 'en_US';
            u1.EmailEncodingKey = 'UTF-8';
            u1.LanguageLocaleKey = 'en_US';
            u1.District__c = '0001';
            insert u1;
            
            u2 = new User();
            u2.FirstName ='AccountTeam2';
            u2.LastName = 'Test';
            u2.Username = 'AccountTeam2@Test.com';
            u2.Alias = 'Atm2Test';
            u2.Email = 'AccountTeam2@company.com';
            u2.CommunityNickname = u2.Alias;
            u2.ProfileId = [Select Id from Profile Where Name = 'Systemadministrator' OR Name = 'System Administrator' limit 1].Id;
            u2.TimeZoneSidKey = 'America/Chicago';
            u2.LocaleSidKey = 'en_US';
            u2.EmailEncodingKey = 'UTF-8';
            u2.LanguageLocaleKey = 'en_US';
            insert u2;
        }
		acc1 = [Select Sales_Org_Stat_Count_0001__c From Account Where id =: acc1.Id limit 1];
		
		if(acc1.Sales_Org_Stat_Count_0001__c == 0) {
			Account_Details__c accDet = new Account_Details__c();
	        accDet.Account__c = acc1.Id;
	        accDet.VKOrg_Deletion_Flag__c = true;
	        accDet.Sales_Organisation__c = '0001';
	        insert accDet;
		}
        Test.startTest();
        
        Account_Team__c accTeam = new Account_Team__c();
        accTeam.Account__c = acc1.Id;
        accTeam.Team_Member__c = u1.Id;
        accTeam.Team_Role__c = 'KAM';
        accTeam.Yearly_Completed_Visits__c = 1;
        accTeam.Yearly_Visit_Target__c = 4;
        accTeam.Last_Visit_Date__c = Date.today();
        accTeam.SORG__c = '0001';
        accTeam.Team_Role__c = 'Main Account Manager';
        insert accTeam;
        
        Account_Team__c accTeam2 = new Account_Team__c();
        accTeam2.Account__c = acc1.Id;
        accTeam2.Team_Member__c = u2.Id;
        accTeam2.Team_Role__c = 'KAM';
        accTeam2.Yearly_Completed_Visits__c = 2;
        accTeam2.Yearly_Visit_Target__c = 4;
        accTeam2.Last_Visit_Date__c = Date.today();
        accTeam2.SORG__c = '0001';
        accTeam2.Team_Role__c = 'Project Manager';
        insert accTeam2;
        
        //AccountTeamMember accTeamMember= [select Id, AccountId, UserId from AccountTeamMember where AccountId =: acc1.Id  and UserId =: u1.Id];
        //system.assert(accTeamMember != null);
        
        //accTeam.Team_Role__c = 'Project Manager';
        //update accTeam;
        
        AccountTeamMember accTeamMember= [select Id, TeamMemberRole from AccountTeamMember where AccountId =: acc1.Id  and UserId =: u2.Id];
        system.assert(accTeamMember.TeamMemberRole == 'Project Manager');

        accTeam2.Yearly_Visit_Target__c = 11;
        update accTeam2;
        
        delete accTeam2;

        accTeamMember = null;
        for(AccountTeamMember atm : [select Id, TeamMemberRole from AccountTeamMember where AccountId =: acc1.Id  and UserId =: u2.Id]){
            accTeamMember = atm;
        }
        system.assert(accTeamMember == null);
        
        Test.stopTest();
    }
}