public class LtngTriluxVisitReportSaveRecordsCtrl {
    
    @AuraEnabled
    public static Visit__c saveVisit(Visit__c visit) {
        // Perform isUpdateable() check here
          upsert visit;
          return visit;
    }

}