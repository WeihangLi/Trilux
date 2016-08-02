/**
 *  This Class is Test Class for ClsTriggerOpportunityHandler.
 *
 * @author Lili Zhao
 * @created 2016-4-21
 * @version 1.0
 * @since 35.0
 *
 * @changelog
 * 	2016-4-21 Lili Zhao <lili.zhao@oinio.com>
 *  - Created
 * @coverage 100%
 */
@isTest 
private class ClsTriggerProjectHandler_Test {

    static testMethod void myUnitTest() {
    	
    	Territory_Data__c teData = new Territory_Data__c();
    	teData.PLZ__c = '201100';
    	teData.Sales_Region__c = 'testRegion';
    	insert teData;
    	
    	//create Project
        Trilux_Project__c project = new Trilux_Project__c();
        project.Project_Name__c = 'EDEKA Hansen -Köln';
        project.Project_Location_City__c = 'Kölner Straße 12';
        project.Project_Location_Postal_Code__c = '201100';
        insert project;
        
        Trilux_Project__c project2 = new Trilux_Project__c();
        project2.Project_Name__c = 'EDEKA Hansen';
        project2.Project_Location_City__c = 'test city';
        project2.Project_Location_Street__c = 'test Street';
        project2.Project_Location_Postal_Code__c = 'test';
        project2.Project_Location_Country__c ='AD';
        insert project2;
        system.debug(':::: '+project.Sales_Region__c);
        system.assert(project.Sales_Region__c == null);
        project2.Project_Location_Postal_Code__c = '201100';
        update project2;
        system.debug(':::: '+project.Sales_Region__c);
        system.assert(project.Sales_Region__c == null);
        delete project;
    }
}