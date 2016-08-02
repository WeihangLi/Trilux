public class ExtLtngOpportunityPartner {
	
	public Opportunity oppy {get; set;}
	public Opportunity_Partner__c oppyPartner {get; set;}
	private map<String, String> map_urlParams;   
	private String oppyId; 

    /**
     * the constructor
     */
    public ExtLtngOpportunityPartner(ApexPages.StandardController stdCtrl) { 
        this.oppyPartner = (Opportunity_Partner__c) stdCtrl.getRecord();
        this.map_urlParams = ApexPages.currentPage().getParameters(); 
        this.oppy = new Opportunity();
        for(String key: map_urlParams.keyset()){
			if(key.contains('_lkid')){
				oppyId = map_urlParams.get(key);
				break;
			}
		}
        try{                    
            for(Opportunity opp : [Select Id, Name From Opportunity Where Id=: this.oppyId]) {
				this.oppy = opp;
            }
                     
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, ex.getStackTraceString()));
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, ex.getMessage()));
        } 
    }
}