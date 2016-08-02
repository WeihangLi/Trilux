public class LtngTriluxVisitReportSaveVisitNoteCtrl {
    
    @AuraEnabled
    public static Visit__c saveVisit(Visit__c visit) {
        // Perform isUpdateable() check here
          update visit;
          return visit;
    }

}