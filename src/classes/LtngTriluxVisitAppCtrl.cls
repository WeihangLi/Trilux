public with sharing class LtngTriluxVisitAppCtrl {
    private static Map<String, String> mapApplicationQueries = null;
    
    private static Map<String, String> getApplicationQueries(){
        
        if(mapApplicationQueries != null) return mapApplicationQueries;
        
        Mobile_Visit_Application_Queries__mdt query = [Select HomeView_Event__c,HomeView_Tasks__c,HomeView_Contact__c,
                                                       Agenda_Tasks__c, HomeView_Event2__c, Agenda_Campaigns__c, Agenda_Campaigns_Member__c, 
                                                       Agenda_Offers__c,Agenda_Offers2__c, Agenda_Orders__c, Agenda_Remedials__c,
                                                       PastActivities_Task__c,PastActivities_Event__c,
                                                       Agenda_Opportunities__c,Agenda_OpportunityTeam__c,Agenda_OpportunityTeam2__c,Agenda_Opportunity_Partner__c
                                                       From Mobile_Visit_Application_Queries__mdt];
        
        if( query != null ){
            mapApplicationQueries = new Map<String, String>();
            
            mapApplicationQueries.put('HomeView_Event__c', query.HomeView_Event__c);
            mapApplicationQueries.put('HomeView_Event2__c', query.HomeView_Event2__c);
            //HomeView_Tasks__c
            mapApplicationQueries.put('HomeView_Tasks__c', query.HomeView_Tasks__c);
            //HomeView_Contact__c
            mapApplicationQueries.put('HomeView_Contact__c', query.HomeView_Contact__c);
            //Agenda_Opportunities__c
            mapApplicationQueries.put('Agenda_Opportunities__c', query.Agenda_Opportunities__c);
            //Agenda_Tasks__c
            mapApplicationQueries.put('Agenda_Tasks__c', query.Agenda_Tasks__c);
            //AgendaQuote__c
            mapApplicationQueries.put('Agenda_Offers__c', query.Agenda_Offers__c);
            mapApplicationQueries.put('Agenda_Offers2__c', query.Agenda_Offers2__c);
            
            mapApplicationQueries.put('PastActivities_Task__c', query.PastActivities_Task__c);
            mapApplicationQueries.put('PastActivities_Event__c', query.PastActivities_Event__c);
            
            //Agenda_Opportunity_Partner__c
            mapApplicationQueries.put('Agenda_Opportunity_Partner__c', query.Agenda_Opportunity_Partner__c);
            mapApplicationQueries.put('Agenda_OpportunityTeam__c', query.Agenda_OpportunityTeam__c);
            mapApplicationQueries.put('Agenda_OpportunityTeam2__c', query.Agenda_OpportunityTeam2__c);
            
            mapApplicationQueries.put('Agenda_Orders__c', query.Agenda_Orders__c);
            
            mapApplicationQueries.put('Agenda_Campaigns__c', query.Agenda_Campaigns__c);
            mapApplicationQueries.put('Agenda_Campaigns_Member__c', query.Agenda_Campaigns_Member__c);
            
            mapApplicationQueries.put('Agenda_Remedials__c', query.Agenda_Remedials__c);
        }
        
        return mapApplicationQueries;
    }
    
    @AuraEnabled
    public static List<String> getHomeViewEvents() {
        
        Map<String, String> applicationQueries = getApplicationQueries();
        
        List<String> results = new List<String>();
        if(applicationQueries != null){
            String part1 = applicationQueries.get('HomeView_Event__c');
            String part2 = applicationQueries.get('HomeView_Event2__c');
            String eventQuerySql = part1 + ' '+ part2;
            String userId = Userinfo.getUserId();
            String replacedSql = eventQuerySql.replace('userId', userId);
            
            //For test
            //String escapeWhere = eventQuerySql.substring(0, eventQuerySql.indexOf('where'));
            //List<Visit__c> records = Database.query(escapeWhere);
            List<Visit__c> records = Database.query(replacedSql);
            for(Integer i=0; i<records.size(); i++){
                Visit__c visit = records[i];
                String whatId = visit.Account__c;
                if(whatId!=null && whatId.startsWith('001')){
                    
                    TriluxEvent triluxEvent = new TriluxEvent();
                    
                    triluxEvent.Id = visit.Id;
                    triluxEvent.visitId = visit.Id;
                    triluxEvent.whatId = visit.Account__c;
                    triluxEvent.whoId = visit.Contact__c;
                    triluxEvent.whatName = visit.Account__r.Name;
                    triluxEvent.whoName = visit.Contact__r.Name;
                    triluxEvent.startTime = visit.Start_Time__c;
                    triluxEvent.visitStatus= visit.Visit_Status__c;
                    triluxEvent.subject= visit.Subject__c;
                    if(triluxEvent.startTime < date.today())
                        triluxEvent.isPast = true;
                    else
                        triluxEvent.isPast = false;
                    
                    if(visit.Contact__c != null){
                        String conatctQuerySql = applicationQueries.get('HomeView_Contact__c');
                        String replacedContactSql = conatctQuerySql.replace('contactId', visit.Contact__c);
                        Contact contact = Database.query(replacedContactSql);
                        
                        if(contact!=null){
                            triluxEvent.mailingPostalCode = contact.mailingPostalCode;
                            triluxEvent.mailingCity = contact.mailingCity;
                            triluxEvent.mailingStreet = contact.mailingStreet;
                        }
                    }
                    
                    results.add(JSON.serialize(triluxEvent));
                }
            }
            
            return results;
        }else{
            return null;
        }
    }
    
    @AuraEnabled
    public static List<Task> getHomeViewTasks() {
        
        Map<String, String> applicationQueries = getApplicationQueries();
        
        if(applicationQueries != null){
            String eventQuerySql = applicationQueries.get('HomeView_Tasks__c');
            String userId = Userinfo.getUserId();
            String replacedSql = eventQuerySql.replace('userId', userId);
            
            //For test
            //String escapeWhere = eventQuerySql.substring(0, eventQuerySql.indexOf('where'));
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
    public static List<Task> getAgendaTasks(String accountID) {
        
        Map<String, String> applicationQueries = getApplicationQueries();
        
        if(applicationQueries != null){
            String eventQuerySql = applicationQueries.get('Agenda_Tasks__c');
            String userId = Userinfo.getUserId();
            String replacedSql = eventQuerySql.replace('userId', userId).replace('accId', accountID);
            //String replacedSql = eventQuerySql.replace('accountId', accountID);
            
            //For test
            String escapeWhere = eventQuerySql.substring(0, eventQuerySql.indexOf('where'));
            return Database.query(replacedSql);
        }else{
            return null;
        }
    }
    
    @AuraEnabled
    public static List<Quote__c> getAgendaQuotes(String accountID) {
        
        Map<String, String> applicationQueries = getApplicationQueries();
        
        if(applicationQueries != null){
            List<Id> oppIds=getAgendaOpportunityId(accountID);
            String part1 = applicationQueries.get('Agenda_Offers__c');
            
            String replacedSql = part1.replace('accId', accountID).replace('SetOppId',': oppIds');
            
            return Database.query(replacedSql);
        }else{
            return null;
        }
    }
    
    @AuraEnabled
    public static List<Order> getAgendaOrders(String accountID) {
        
        Map<String, String> applicationQueries = getApplicationQueries();
        
        if(applicationQueries != null){
            List<Id> oppIds=getAgendaOpportunityId(accountID);
            
            String agendaOrderSql = applicationQueries.get('Agenda_Orders__c');
            agendaOrderSql = agendaOrderSql.replace('accId', accountID).replace('SetOppId',': oppIds');
            //For test
            //String escapeWhere = eventQuerySql.substring(0, eventQuerySql.indexOf('where'));
            return Database.query(agendaOrderSql);
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
    public static List<CampaignMember> getAgendaCampaigns(String accountID) {
        Map<String, String> applicationQueries = getApplicationQueries();
        
        if(applicationQueries != null){
            String contactSql = 'select Id from Contact where AccountId = \'accId\'';
            String repContactSql=contactSql.replace('accId', accountID);
            List<String> contactIds = new List<String>();
            for(Contact contact:DataBase.query(repContactSql)) {
                contactIds.add(contact.Id);
            }
            String campaignMbsSql = applicationQueries.get('Agenda_Campaigns_Member__c');
            String repCampaignMbsSql=campaignMbsSql.replace('setContactIds', ': contactIds');
            
            return DataBase.query(repCampaignMbsSql);
        }else {
            return null;
        }
            
    }
    
    @AuraEnabled
    public static List<Task> getPastActivitiesTask(String accountID) {
        
        Map<String, String> applicationQueries = getApplicationQueries();
        
        if(applicationQueries != null){
            String eventQuerySql = applicationQueries.get('PastActivities_Task__c');
            
            String replacedSql = eventQuerySql.replace('accId', accountID);
            
            //For test
            String escapeWhere = eventQuerySql.substring(0, eventQuerySql.indexOf('where'));
            return Database.query(replacedSql);
        }else{
            return null;
        }
    }
    
    @AuraEnabled
    public static List<Complaint__c> getAgendaRemedials(String accountID) {
         Map<String, String> applicationQueries = getApplicationQueries();
        
        if(applicationQueries != null){
            String complaintQuerySql = applicationQueries.get('Agenda_Remedials__c').replace('accId', accountID);
            return DataBase.query(complaintQuerySql);
            
        }else {
            return null;
        }
    }
    
    @AuraEnabled
    public static Task updateTask(Task task) {       
        upsert task;        
        return task;
    }
    
    @AuraEnabled
    public static List<Event> getPastActivitiesEvent(String accountID) {
        
        Map<String, String> applicationQueries = getApplicationQueries();
        
        if(applicationQueries != null){
            List<Event> results = new List<Event>();
            
            String eventQuerySql = applicationQueries.get('PastActivities_Event__c');
            //String userId = Userinfo.getUserId();
            String replacedSql = eventQuerySql.replace('accId', accountID);
            
            //For test
            String escapeWhere = eventQuerySql.substring(0, eventQuerySql.indexOf('where'));
            return Database.query(replacedSql);
            
            List<Event> records = Database.query(replacedSql);
            for(Integer i=0; i<records.size(); i++){
                Event event = records[i];
                String whatId = event.whatId;
                if( whatId!=null && whatId.startsWith('001')){
                    results.add(event);
                }
            }
            
            return results;
        }else{
            return null;
        }
    }
    
    @AuraEnabled
    public static List<ListView> getListViews() {
        List<ListView> listviews = 
            [SELECT Id, Name FROM ListView WHERE SobjectType = 'Opportunity' and Name='All Opportunities'];
        
        // Perform isAccessible() check here
        return listviews;
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
    
    
    class TriluxEvent {
        public String Id;
        //public String accountId;
        public String visitId;
        public String whoId;
        public String whatId;
        public String whoName;
        public String whatName;
        public String mailingPostalCode;
        public String mailingCity;
        public String mailingStreet;
        public Datetime startTime;
        public String visitStatus;
        public Boolean isPast;
        public String subject;
        
        public TriluxEvent() {}
    }
}