/**
*   This class is tesclass for Class "ClsTerritoryManagementUtil".
*
@author weihang li
@created 2016-03-08
@version 1.0
@since 20.0
*
@changelog
* 2016－03-08 weihang li <weihang.li@oinio.com>
* - Created
*- Test coverage  
*/
@isTest(seeAllData=true) 
private class ClsTerritoryManagementUtil_Test {
    static testMethod void testMostMethods() {
        //Account acc = [select Id,name from account where IsExcludedFromRealign = false limit 1];
        
        Account acc = new Account();
        acc.Name = 'Test Team';
        acc.Type = 'PROS';
        acc.Street__c = 'test street';
        acc.BillingCountry = 'china';
        acc.BillingCity = 'xian';
        acc.BillingStreet = 'test street';
        acc.BillingPostalCode = '01001';
        acc.Initial_Sales_Channel__c = 'VDI1';
        acc.Sales_Organisation__c = '0001';
        acc.Initial_Sales_Org__c = '0001';
        acc.IsExcludedFromRealign = false;
        insert acc;
        
        list<Account_Details__c> list_accDet = new list<Account_Details__c>();    
        Account_Details__c accDet = new Account_Details__c();
        accDet.Account__c = acc.Id;
        accDet.VKOrg_Deletion_Flag__c = true;
        accDet.Sales_Organisation__c = '0001';
        //insert accDet;
        //list_accDet.add(accDet);
        
        Account_Details__c accDet1 = new Account_Details__c();
        accDet1.Account__c = acc.Id;
        accDet1.VKOrg_Deletion_Flag__c = true;
        accDet1.Sales_Organisation__c = '0009';
        //insert accDet;
        list_accDet.add(accDet1);
        
        
        Account_Details__c accDet2 = new Account_Details__c();
        accDet2.Account__c = acc.Id;
        accDet2.VKOrg_Deletion_Flag__c = true;
        accDet2.Sales_Organisation__c = '0031';
        //insert accDet;
        list_accDet.add(accDet2);
        
        
        Account_Details__c accDet3 = new Account_Details__c();
        accDet3.Account__c = acc.Id;
        accDet3.VKOrg_Deletion_Flag__c = true;
        accDet3.Sales_Organisation__c = '0032';
        //insert accDet;
        list_accDet.add(accDet3);
        
        
        Account_Details__c accDet4 = new Account_Details__c();
        accDet4.Account__c = acc.Id;
        accDet4.VKOrg_Deletion_Flag__c = true;
        accDet4.Sales_Organisation__c = '0033';
        //insert accDet;
        list_accDet.add(accDet4);
        
        
        
        Account_Details__c accDet5 = new Account_Details__c();
        accDet5.Account__c = acc.Id;
        accDet5.VKOrg_Deletion_Flag__c = true;
        accDet5.Sales_Organisation__c = '0034';
        //insert accDet;
        list_accDet.add(accDet5);
        
        
        Account_Details__c accDet6 = new Account_Details__c();
        accDet6.Account__c = acc.Id;
        accDet6.VKOrg_Deletion_Flag__c = true;
        accDet6.Sales_Organisation__c = '0035';
        //insert accDet;
        list_accDet.add(accDet6);
        
        
        Account_Details__c accDet7 = new Account_Details__c();
        accDet7.Account__c = acc.Id;
        accDet7.VKOrg_Deletion_Flag__c = true;
        accDet7.Sales_Organisation__c = '0047';
        //insert accDet;
        list_accDet.add(accDet7);
        
        Account_Details__c accDet8 = new Account_Details__c();
        accDet8.Account__c = acc.Id;
        accDet8.VKOrg_Deletion_Flag__c = true;
        accDet8.Sales_Organisation__c = '0057';
        //insert accDet;
        list_accDet.add(accDet8);
        
        Account_Details__c accDet9 = new Account_Details__c();
        accDet9.Account__c = acc.Id;
        accDet9.VKOrg_Deletion_Flag__c = true;
        accDet9.Sales_Organisation__c = '0058';
        //insert accDet;
        list_accDet.add(accDet9);
        insert list_accDet;
        //User testUser = [Select id from User where Id = :UserInfo.getUserId()];
        
        User testUser = new User();
        testUser.FirstName ='sdf1';
        testUser.LastName = 'reg1';
        testUser.Username = 'imprivate1@imprivate.com';
        testUser.Alias = 'mtst1';
        testUser.Email = 'mtester@company.com';
        testUser.CommunityNickname = testUser.Alias;
        testUser.ProfileId = [Select Id from Profile Where Name = 'Systemadministrator' OR Name = 'System Administrator' limit 1].Id;
        testUser.TimeZoneSidKey = 'America/Chicago';
        testUser.LocaleSidKey = 'en_US';
        testUser.EmailEncodingKey = 'UTF-8';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.Sales_Group__c = '118';
        testUser.District__c = '0100DB';
        insert testUser;
        
        list<Account_Team__c> list_accTeam = new list<Account_Team__c>();       
        
        Account_Team__c accTeam = new Account_Team__c();
        accTeam.Account__c = acc.Id;
        accTeam.Team_Member__c = testUser.Id;
        accTeam.Team_Role__c = 'Main Account Manager';
        accTeam.SORG__c = '0001';
        //insert accTeam;
        list_accTeam.add(accTeam);
        
        Account_Team__c accTeam1 = new Account_Team__c();
        accTeam1.Account__c = acc.Id;
        accTeam1.Team_Member__c = testUser.Id;
        accTeam1.Team_Role__c = 'Main Account Manager';
        accTeam1.SORG__c = '0009';
        //insert accTeam1;
        list_accTeam.add(accTeam1);
        
        Account_Team__c accTeam2 = new Account_Team__c();
        accTeam2.Account__c = acc.Id;
        accTeam2.Team_Member__c = testUser.Id;
        accTeam2.Team_Role__c = 'Main Account Manager';
        accTeam2.SORG__c = '0031';
        //insert accTeam2;
        list_accTeam.add(accTeam2);
        
        Account_Team__c accTeam3 = new Account_Team__c();
        accTeam3.Account__c = acc.Id;
        accTeam3.Team_Member__c = testUser.Id;
        accTeam3.Team_Role__c = 'Main Account Manager';
        accTeam3.SORG__c = '0032';
        //insert accTeam3;
        list_accTeam.add(accTeam3);
        
        Account_Team__c accTeam4 = new Account_Team__c();
        accTeam4.Account__c = acc.Id;
        accTeam4.Team_Member__c = testUser.Id;
        accTeam4.Team_Role__c = 'Main Account Manager';
        accTeam4.SORG__c = '0033';
        //insert accTeam3;
        list_accTeam.add(accTeam4);
        
        Account_Team__c accTeam5 = new Account_Team__c();
        accTeam5.Account__c = acc.Id;
        accTeam5.Team_Member__c = testUser.Id;
        accTeam5.Team_Role__c = 'Main Account Manager';
        accTeam5.SORG__c = '0034';
        //insert accTeam3;
        list_accTeam.add(accTeam5);
        
        Account_Team__c accTeam6 = new Account_Team__c();
        accTeam6.Account__c = acc.Id;
        accTeam6.Team_Member__c = testUser.Id;
        accTeam6.Team_Role__c = 'Main Account Manager';
        accTeam6.SORG__c = '0035';
        //insert accTeam3;
        list_accTeam.add(accTeam6);
        
        Account_Team__c accTeam7 = new Account_Team__c();
        accTeam7.Account__c = acc.Id;
        accTeam7.Team_Member__c = testUser.Id;
        accTeam7.Team_Role__c = 'Main Account Manager';
        accTeam7.SORG__c = '0047';
        //insert accTeam3;
        list_accTeam.add(accTeam7);
        
        Account_Team__c accTeam8 = new Account_Team__c();
        accTeam8.Account__c = acc.Id;
        accTeam8.Team_Member__c = testUser.Id;
        accTeam8.Team_Role__c = 'Main Account Manager';
        accTeam8.SORG__c = '0057';
        //insert accTeam8;
        list_accTeam.add(accTeam8);
        
        Account_Team__c accTeam9 = new Account_Team__c();
        accTeam9.Account__c = acc.Id;
        accTeam9.Team_Member__c = testUser.Id;
        accTeam9.Team_Role__c = 'Main Account Manager';
        accTeam9.SORG__c = '0058';
        //insert accTeam9;
        list_accTeam.add(accTeam9);
        
        insert list_accTeam;
        list<Id> list_accIds = new list<Id>();
        list_accIds.add(acc.Id);
        
        list<Territory2> list_te = [select Id from Territory2 limit 2];
        
        UserTerritory2Association us = new UserTerritory2Association();
        us.RoleInTerritory2 = 'KAM';
        if(list_te != null && list_te.size() > 0){
            us.Territory2Id = list_te.get(0).Id;
        }
        us.UserId = UserInfo.getUserId();
        //insert us;
        
        map<Id,set<Id>> map_accId_userIds = new map<Id,set<Id>>();
        if(!map_accId_userIds.containsKey(acc.Id)){
            map_accId_userIds.put(acc.Id,new set<Id>());
        }
        map_accId_userIds.get(acc.Id).add(testUser.Id);
        
        /**User u = new User();
        u.FirstName ='sdf';
        u.LastName = 'reg';
        u.Username = 'imprivate@imprivate.com';
        u.Alias = 'mtst';
        u.Email = 'mtester@company.com';
        u.CommunityNickname = u.Alias;
        u.ProfileId = [Select Id from Profile Where Name = 'Systemadministrator' OR Name = 'System Administrator' limit 1].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.Sales_Group__c = '118';
        u.District__c = '0100DB';
        u.VKORG__c = '0001';
        insert u;
        
        list<Territory2> list_te = [select Id from Territory2 limit 2];
        
        UserTerritory2Association us = new UserTerritory2Association();
        us.RoleInTerritory2 = 'KAM';
        us.Territory2Id = list_te.get(0).Id;
        us.UserId = u.Id;
        insert us;
        
        update us;
        
        delete us;**/
        
        test.startTest();
        ClsTerritoryManagementUtil.updateAccount(map_accId_userIds);
        System.assertEquals(true, acc.OwnerId != testUser.Id);
        ClsTerritoryManagementUtil.insertAccountTeamMember(list_accIds);
        ClsTerritoryManagementUtil.deleteAccountTeamMember(list_accIds);
        
        
        test.stopTest();
    }
    /**static testMethod void testMostMethods2() {
        list<Territory2> list_te = [select Id from Territory2 limit 2];
        
        UserTerritory2Association us = new UserTerritory2Association();
        us.RoleInTerritory2 = 'KAM';
        us.Territory2Id = list_te.get(0).Id;
        us.UserId = UserInfo.getUserId();
        insert us;
        
        update us;
        
        delete us;
    }**/
}