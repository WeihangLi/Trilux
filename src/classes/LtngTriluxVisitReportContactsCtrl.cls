public with sharing class LtngTriluxVisitReportContactsCtrl {
    private static Map<String, String> mapApplicationQueries = null;
    
    private static Map<String, String> getApplicationQueries() {
        
        if(mapApplicationQueries != null) return mapApplicationQueries;
        
       Mobile_Visit_Application_Queries__mdt query = [Select Attendees_Contacts__c  From Mobile_Visit_Application_Queries__mdt];
        
        if( query != null ){
            mapApplicationQueries = new Map<String, String>();
            
           mapApplicationQueries.put('Attendees_Contacts__c', query.Attendees_Contacts__c);
        }
        
        return mapApplicationQueries;
        return null;
    }
    
    @AuraEnabled
    public static List<Contact> getContacts(String accountId) {
        Map<String, String> applicationQueries = getApplicationQueries();
        
        if(applicationQueries != null){
        	String eventQuerySql = applicationQueries.get('Attendees_Contacts__c');
            
            String replacedSql = eventQuerySql.replace('accId', accountId);
            
            //For test
            /*String escapeWhere = eventQuerySql.substring(0, eventQuerySql.indexOf('where'));
            return Database.query(escapeWhere);*/

            return Database.query(eventQuerySql.replace('accId', accountId));
        }else{
            return null;
        }
    }
    
      @AuraEnabled
    public static String saveAgendaTopics(List<Agenda_Topics__c> agendaTopics) {
        // Perform isUpdateable() check here
        insert agendaTopics;
        return 'success';
    }

}