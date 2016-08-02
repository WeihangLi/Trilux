public with sharing class ClsCreateTaskAction {
    @InvocableMethod(label='create task' description='create a task everytime an order of type ZMUS is created')
    public static void insertTask(List<ID> ids) {
        list<Task> list_insertTasks = new list<Task>();
        for(Order ord:[select Id,Name,OpportunityId,Opportunity.Project_Manager__c,Opportunity.Name,AccountId,Account.Name,Account.BillingCity from Order where Id in: ids]){
            Task ta = new Task();
            ta.OwnerId = ord.Opportunity.Project_Manager__c;
            ta.Status = 'In Progress';
            ta.Priority = 'Normal';
            ta.ActivityDate = Date.today().addDays(7);
            ta.Subject = 'Sample Order Follow-Up '+ord.Opportunity.Name;
            ta.Description = 'Sample was ordered from customer: \n Account: '+ord.Account.Name+', '+ord.Account.BillingCity+'\n Project: '+ord.Opportunity.Name+'\n Please follow up.';
            list_insertTasks.add(ta);
        }
        if(!list_insertTasks.isEmpty()){
            insert list_insertTasks;
        }
    }
}