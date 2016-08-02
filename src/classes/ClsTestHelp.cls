/**
*   This class is a help class.
*
@author Di Chen
@created 2013-10-23
@version 1.0
@since 20.0
*
@changelog
* 2013-10-23 Di Chen <di.chen@itbconsult.com>
* - Created
*
*/ 
@isTest
public class ClsTestHelp {  

    public static Account createTestAccounts() {
        //RecordType rt=[SELECT Id, Name FROM RecordType where Name='Country'];
        //Region__c r=new Region__c();
        //r.RecordTypeId=rt.Id;
        //insert r;
        //RecordType rt2=[SELECT Id, Name FROM RecordType where Name='Brick'];
        //Region__c r2=new Region__c();
        //r2.RecordTypeId=rt2.Id;
        //insert r2;
        
        Account acc = new Account();
        acc.Name = 'TestaAccount';
        acc.OwnerId = UserInfo.getuserId();
        //acc.Brick__c=r2.Id;
        //acc.Country__c=r.Id;
        return acc; 
    }
    public static Contact createTestContacts() {
        Contact con = new Contact();
        con.FirstName = 'sdf';
        con.LastName = 'sdf';
        con.Email = 'asdf@daf.com';
        return con; 
    }
    public static Product2 createTestProduct() {
        Product2 p2 = new Product2();
        p2.Name = 'product';
        return p2;
    }
    
    public static User createTestUsers() {
        User u = new User();
        u.FirstName ='sdf';
        u.LastName = 'reg';
        u.Username = 'test123@test123.com';
        u.Alias = 'mtst';
        u.Email = 'mtester@company.com';
        u.CommunityNickname = u.Alias;
        u.ProfileId = [Select Id from Profile Where Name = 'Systemadministrator' OR Name = 'System Administrator' limit 1].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        //u.ISO_Code_Country__c = 'GBP'; 
        return u;
    }
       
    public static Event createTestEvent(){
        Event event = new Event();
        event.Subject = 'Test FFA';
        event.DurationInMinutes = 120;
        event.ActivityDateTime = date.newInstance(2011, 10, 23);
        event.Description = 'ldshafkjhakldshfjkadksj';
        //event.Activity_Type__c = 'Telefonat';
        return event;  
    }
    
    public static RecordType createAccRT1() {
        RecordType rt = [SELECT Id, Name FROM RecordType where Name='Chain / HQ' and DeveloperName='Chain_HQ' and SobjectType='Account'];
        return rt;
    }
    
}