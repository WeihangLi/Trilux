public with sharing class LtngTriluxVisitReportTopicsCtrl {

    private static Map<String, String> mapApplicationQueries = null;
    
    private static Map<String, String> getApplicationQueries(){
        if(mapApplicationQueries != null) return mapApplicationQueries;
        
        Mobile_Visit_Application_Queries__mdt query = [Select Attendees_Campaigns__c, Attendees_Offers__c, Attendees_Offers2__c, 
                                                      Attendees_Orders__c, Agenda_Opportunities__c,
                                                       Agenda_OpportunityTeam__c, Agenda_OpportunityTeam2__c, Agenda_Opportunity_Partner__c, 
                                                       Attendees_Remedial__c, Attendees_Tasks__c  From Mobile_Visit_Application_Queries__mdt];
        
        if( query != null ){
            mapApplicationQueries = new Map<String, String>();
            
            mapApplicationQueries.put('Attendees_Campaigns__c', query.Attendees_Campaigns__c);
         
            mapApplicationQueries.put('Attendees_Offers__c', query.Attendees_Offers__c);
            mapApplicationQueries.put('Attendees_Offers2__c', query.Attendees_Offers2__c);
           
            mapApplicationQueries.put('Attendees_Orders__c', query.Attendees_Orders__c);
            
            mapApplicationQueries.put('Attendees_Remedial__c', query.Attendees_Remedial__c);
           
            mapApplicationQueries.put('Attendees_Tasks__c', query.Attendees_Tasks__c);
            
            mapApplicationQueries.put('Agenda_OpportunityTeam__c', query.Agenda_OpportunityTeam__c);
            mapApplicationQueries.put('Agenda_OpportunityTeam2__c', query.Agenda_OpportunityTeam2__c);
            mapApplicationQueries.put('Agenda_Opportunity_Partner__c',query.Agenda_Opportunity_Partner__c);
            mapApplicationQueries.put('Agenda_Opportunities__c',query.Agenda_Opportunities__c);
        }
        
        return mapApplicationQueries;
    }
    
     @AuraEnabled
    public static List<CampaignMember> getAgendaCampaigns(String accountID) {
        
        Map<String, String> applicationQueries = getApplicationQueries();
        
        if(applicationQueries != null){
            String contactSql = 'select Id from Contact where AccountId = \'accId\'';
            String repContactSql=contactSql.replace('accId', accountID);
            List<String> contactIds = new List<String>();
            for(Contact contact:DataBase.query(repContactSql)) {
                contactIds.add(contact.Id);
            }
            
            String campaignMbsSql = applicationQueries.get('Attendees_Campaigns__c');
            String repCampaignMbsSql=campaignMbsSql.replace('setContactIds', ': contactIds');
            
            return Database.query(repCampaignMbsSql);
        }else{
            return null;
        }
    }
    
      @AuraEnabled
    public static List<Quote__c> getAgendaOffers(String accountID) {
        
        Map<String, String> applicationQueries = getApplicationQueries();
        
        if(applicationQueries != null){
             List<Id> oppIds=getAgendaOpportunityId(accountID);
            String part1 =applicationQueries.get('Attendees_Offers__c');
            String replacedSql = part1.replace('accId', accountID).replace('SetOppId',': oppIds');
            return Database.query(replacedSql);
        }else{
            return null;
        }
    }
    
    @AuraEnabled
    public static String getAgendaOpportunities(String accountID) {
        
        Map<String, String> applicationQueries = getApplicationQueries();
        
        if(applicationQueries != null){
            //First: Lookup the opportunity Id set from Agenda_Opportunity_Partner__c,replace 
             String partnerSql = applicationQueries.get('Agenda_Opportunity_Partner__c').replace('accId', accountID);
            
            List<Id> partnerOppIds = new List<Id>();
            for(OpportunityPartner obj : Database.query(partnerSql)){
                partnerOppIds.add(obj.OpportunityId);
            }
            
            /*String part1 = applicationQueries.get('Agenda_OpportunityTeam__c');
            String part2 = applicationQueries.get('Agenda_OpportunityTeam2__c');
            
            String userId = Userinfo.getUserId();
            String replacedSql = part1 + ' ' + part2.replace('uid', userId).replace('accId', accountID).replace('SetOppId', ': partnerOppIds');
            
            List<Id> teamOppIds = new List<Id>();
            for(OpportunityTeamMember obj : Database.query(replacedSql)){
                teamOppIds.add(obj.OpportunityId);
            }*/
                        
            String agendaOpportunitySql = applicationQueries.get('Agenda_Opportunities__c');
            agendaOpportunitySql = agendaOpportunitySql.replace('accId', accountID).replace('SetOppId',': partnerOppIds');
            //For test
            //String escapeWhere = eventQuerySql.substring(0, eventQuerySql.indexOf('where'));
            map<String, OpportunityObject> map_oppId_opp = new map<String, OpportunityObject>();
            for(Opportunity obj : Database.query(agendaOpportunitySql)){
                OpportunityObject relatedOpp =new OpportunityObject();
                relatedOpp.Id=obj.Id;
                relatedOpp.amount=obj.Amount;
                relatedOpp.stageName=obj.StageName;
                relatedOpp.currencyIsoCode=obj.CurrencyIsoCode;
                relatedOpp.name=obj.Name;
                map_oppId_opp.put(obj.Id, relatedOpp);
            }
            Set<String> mapOppIds=map_oppId_opp.keySet();
            List<OpportunityObject> agendaOpps=new List<OpportunityObject>();
            String CaseQueries= 'Select count(Id) caseNum, Related_Opportunity__c oppId from Case where Related_Opportunity__c in setOppIds group by Related_Opportunity__c';
            CaseQueries = CaseQueries.replace('setOppIds', ': mapOppIds');
            List<AggregateResult> records= Database.query(CaseQueries);
            
            for(AggregateResult caseCount:records){
                String relatedOppId=(String)caseCount.get('oppId'); 
                OpportunityObject opp=map_oppId_opp.get(relatedOppId);
                opp.lightningDesign=(Integer)caseCount.get('caseNum');          
            }
            String visitOpps =JSON.serialize(map_oppId_opp.values());
            return visitOpps;
        }else{
            return null;
        }
    }
    
      @AuraEnabled
    public static List<Order> getAgendaOrders(String accountID) {
        
        Map<String, String> applicationQueries = getApplicationQueries();
        
        if(applicationQueries != null){
            List<Id> oppIds=getAgendaOpportunityId(accountID);
            
            String agendaOrderSql = applicationQueries.get('Attendees_Orders__c');
             agendaOrderSql = agendaOrderSql.replace('accId', accountID).replace('SetOppId',': oppIds');
            //For test
            //String escapeWhere = eventQuerySql.substring(0, eventQuerySql.indexOf('where'));
            return Database.query(agendaOrderSql);
        }else{
            return null;
        }
    }
    
    @AuraEnabled
    public static List<Complaint__c> getAgendaRemedial(String accountID) {
        
        Map<String, String> applicationQueries = getApplicationQueries();
        
        if(applicationQueries != null){

            String eventQuerySql = applicationQueries.get('Attendees_Remedial__c');
            String userId = Userinfo.getUserId();
            String replacedSql = eventQuerySql.replace('accId', accountID);
            
            //For test
            /*String escapeWhere = eventQuerySql.substring(0, eventQuerySql.indexOf('where'));
            return Database.query(escapeWhere);*/
            return Database.query(replacedSql);
        }else{
            return null;
        }
    }
    
    @AuraEnabled
    public static List<Task> getAgendaTasks(String accountID) {
        
        Map<String, String> applicationQueries = getApplicationQueries();
        
        if(applicationQueries != null){
            String eventQuerySql = applicationQueries.get('Attendees_Tasks__c');
            String userId = Userinfo.getUserId();
            String replacedSql = eventQuerySql.replace('userId', userId).replace('accId', accountID);
            
            //For test
            //String escapeWhere = eventQuerySql.substring(0, eventQuerySql.indexOf('where'));
            return Database.query(replacedSql);
        }else{
            return null;
        }
    }
    
     public static List<Id> getAgendaOpportunityId(String accountID) {
        Map<String, String> applicationQueries = getApplicationQueries();
        
        if(applicationQueries != null){
            
            //First: Lookup the opportunity Id set from Agenda_Opportunity_Partner__c,replace 
            String partnerSql = applicationQueries.get('Agenda_Opportunity_Partner__c').replace('accId', accountID);
            
            List<Id> partnerOppIds = new List<Id>();
            for(OpportunityPartner obj : Database.query(partnerSql)){
                partnerOppIds.add(obj.OpportunityId);
            }
            
            /*String part1 = applicationQueries.get('Agenda_OpportunityTeam__c');
            String part2 = applicationQueries.get('Agenda_OpportunityTeam2__c');
            
            String userId = Userinfo.getUserId();
            String replacedSql = part1 + ' ' + part2.replace('uid', userId).replace('accId', accountID).replace('SetOppId', ': partnerOppIds');
            
            List<Id> teamOppIds = new List<Id>();
            for(OpportunityTeamMember obj : Database.query(replacedSql)){
                teamOppIds.add(obj.OpportunityId);
            }*/
            
            String agendaOpportunitySql = applicationQueries.get('Agenda_Opportunities__c');
            agendaOpportunitySql = agendaOpportunitySql.replace('accId', accountID).replace('SetOppId',': partnerOppIds');
            
            List<Id> oppIds = new List<Id>();
            for(Opportunity obj: Database.query(agendaOpportunitySql)){
                oppIds.add(obj.Id);
            }
            return oppIds;
        }
        else {
            return null;
        }
        
    }
    
    
    @AuraEnabled
    public static String saveTopics(String agendaTopics) {
        // Perform isUpdateable() check here
        List<Agenda_Topics__c> topics=new List<Agenda_Topics__c>();
        List<Object> Atopics =(List<Object>)JSON.deserializeUntyped(agendaTopics);
        
        for (Object atopic : Atopics)
        {
            Map<String, Object> m=(Map<String, Object>)atopic;
            Agenda_Topics__c topic = new Agenda_Topics__c();
            if(m.get('Visit_Report__c') != null)
                topic.Visit_Report__c= (String)m.get('Visit_Report__c');
            if(m.get('Campaign__c') != null)
                topic.Campaign__c=(String)m.get('Campaign__c');
            if(m.get('Opportunity__c') != null)
                topic.Opportunity__c=(String)m.get('Opportunity__c');
            if(m.get('Order__c') != null)
                topic.Order__c=(String)m.get('Order__c');
            if(m.get('Quote__c') != null)
                topic.Quote__c=(String)m.get('Quote__c');
            if(m.get('Remedial__c') != null)
                topic.Remedial__c=(String)m.get('Remedial__c');
            topics.add(topic);
            
        }
        insert topics;
        return 'Success';
    }
    
     @AuraEnabled
    public static List<Task> saveTasks(List<Task> tasks) {
        // Perform isUpdateable() check here
          update tasks;
        return tasks;
    }

    
     class OpportunityObject {
        public String Id;
        public Decimal amount;
        public String stageName;
        public Integer lightningDesign;
        public String name;
        public String currencyIsoCode;
        
        public OpportunityObject() {}
    }
    
}