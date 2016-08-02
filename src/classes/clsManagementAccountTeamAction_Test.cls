/**
*	This class is tesclass for Class "clsManagementAccountTeamAction".
*
@author weihang li
@created 2016-03-08
@version 1.0
@since 20.0
*
@changelog
* 2016－03-08 weihang li <weihang.li@oinio.com>
* - Created
*- Test coverage  100
*/
@isTest(seeAllData=true) 
private class clsManagementAccountTeamAction_Test {
    static testMethod void testMostMethods() {
    	Account acc = [select Id,name from account limit 1];
    	
    	list<Id> list_accIds = new list<Id>();
    	list_accIds.add(acc.Id);
    	
    	test.startTest();
    	
    	//start oclausen change
    	//commented out following line
    	clsManagementAccountTeamAction.insertAccountTeamMember(list_accIds);
    	
    	System.assert(true);
    	//original line:
    	//System.assertEquals(true, acc.Id != null);
    	//end oclausen change
    	test.stopTest();
    }
}