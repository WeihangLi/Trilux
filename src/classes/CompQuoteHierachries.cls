/**
*Controller class for component CompQuoteHierachries
*
@author  weihang li
@created  2016-03-15
@version  1.0
@since  36.0 (Force.com ApiVersion) 
*
@changelog
*2016-03-15 weihang li <weihang.li@oinio.com>
*-Created
*/
global with sharing class CompQuoteHierachries {
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public String opportunityIds {get;set;}
    public transient String hierJson {get; set;}
    public String cType {get;set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    public CompQuoteHierachries(){
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- /////////////////////////////////////
    /**
    * this method is used to  
    *
    @author Weihang Li
    @created 2016-03-15
    @version 1.0
    @since 36.0 (Force.com ApiVersion)
    *
    @changelog
    * 2016-03-15 Weihang Li <weihang.li@oinio.com>
    * - Created  
    */
    public void initFirstHierachy(){
        set<String> set_oppIds = new set<String>();
        if(opportunityIds != null && opportunityIds != ''){
            for(String str:opportunityIds.split(',')){
                set_oppIds.add(str);
            }
        }
        if(!set_oppIds.isEmpty()){
            list<CustomHierachy> list_info = new list<CustomHierachy>();
            system.debug('aaaaaaaaaaaaaaaaaaa:'+cType+'---'+set_oppIds);
            if(cType == 'project'){
                for(Opportunity opp:[select Id,Name,Country__c,City__c from Opportunity where Id in: set_oppIds]){
                    String str = '';
                    str += opp.Name;
                    list_info.add(new CustomHierachy(opp.Id,'',str));
                }
            }else{
                User us = [select Id,Name,DefaultCurrencyIsoCode from User where id =: UserInfo.getUserId()];
                decimal rate = 0;
                map<String,decimal> map_isoCode_rate = new map<String,decimal>();
                for(CurrencyType cur:[select Id,ConversionRate,IsoCode from CurrencyType]){
                    map_isoCode_rate.put(cur.IsoCode,cur.ConversionRate);
                }
                for(Quote__c qu:[select Id,Name,Creation_Date__c,Statistic_Flag__c,Quote_Total__c,Quote_Account__r.Name,Quote_Account__r.BillingCity,SAP_Discount__c,Sales_Doc_Type__c,CurrencyIsoCode from Quote__c where Opportunity__c in: set_oppIds and Reference_Doc__c = null and (Sales_Doc_Type__c = 'AG' or Sales_Doc_Type__c = 'AF') order by Sales_Doc_Type__c desc]){
                    String str = '';
                    String creaDate = ''; 
                    String accName = '';
                    String accCity = '';
                    Integer total = 0;
                    if(qu.Statistic_Flag__c == null) qu.Statistic_Flag__c = '';
                    if(qu.SAP_Discount__c == null) qu.SAP_Discount__c = 0.00;
                    if(qu.Quote_Account__c != null) accName = qu.Quote_Account__r.Name;
                    if(qu.Quote_Account__c != null && qu.Quote_Account__r.BillingCity != null) accCity = qu.Quote_Account__r.BillingCity;
                    if(qu.Quote_Total__c != null && qu.Quote_Total__c != 0){
                        total = Integer.valueOf(qu.Quote_Total__c/map_isoCode_rate.get(qu.CurrencyIsoCode)*map_isoCode_rate.get(us.DefaultCurrencyIsoCode));
                    }else{
                        qu.Quote_Total__c = 0.00;
                    }
                    if(qu.Creation_Date__c != null){
                        creaDate = qu.Creation_Date__c.day()+'/'+qu.Creation_Date__c.month()+'/'+qu.Creation_Date__c.year();
                    }
                    if(qu.Sales_Doc_Type__c == 'AF'){
                        str = creaDate + ' - ' + qu.Name + ' - ' + qu.Statistic_Flag__c + ' - ' + +Integer.valueOf(qu.Quote_Total__c)+' '+qu.CurrencyIsoCode +' ('+total + ' ' + us.DefaultCurrencyIsoCode+')';
                        list_info.add(new CustomHierachy(qu.Id,'AF',str));
                    }else{
                        str = creaDate + ' - ' + qu.Name + ' - ' + qu.Quote_Account__r.Name + ' - ' + qu.Quote_Account__r.BillingCity + ' - ' + qu.Statistic_Flag__c + ' - SR: ' + qu.SAP_Discount__c + ' - ' +Integer.valueOf(qu.Quote_Total__c)+' '+qu.CurrencyIsoCode + ' ('+total + ' ' + us.DefaultCurrencyIsoCode+')';
                        list_info.add(new CustomHierachy(qu.Id,'AG',str));
                    }
                }
                for(Order ord:[select Id,Name,CreatedDate,SAP_Order_No__c,Account.Name,Account.BillingCity,Total_Amount__c,Type,CurrencyIsoCode from Order where OpportunityId in: set_oppIds and Quote__c = null and Type in ('KL','KM','TA','ZANZ','ZES','ZLAG','ZLES','ZMKC','ZMUS','ZTAW')]){
                    String str = '';
                    String creaDate = '';
                    if(ord.CreatedDate != null){
                        creaDate = ord.CreatedDate.day()+'/'+ord.CreatedDate.month()+'/'+ord.CreatedDate.year();
                    }
                    Integer amount = 0;
                    if(ord.Total_Amount__c != null && ord.Total_Amount__c != 0){
                        amount = Integer.valueOf(ord.Total_Amount__c/map_isoCode_rate.get(ord.CurrencyIsoCode)*map_isoCode_rate.get(us.DefaultCurrencyIsoCode));
                    }else{
                        ord.Total_Amount__c = 0.00;
                    }
                    if(ord.Type == 'KA' || ord.Type == 'TA' || ord.Type == 'ZANZ' || ord.Type == 'ZES' || ord.Type == 'ZLAG' || ord.Type == 'ZLES' || ord.Type == 'ZMUS' || ord.Type == 'ZTAW'){
                        str = creaDate + ' - ' + ord.SAP_Order_No__c + ' - ' + ord.Account.Name + ' - ' + ord.Account.BillingCity + ' - ' +Integer.valueOf(ord.Total_Amount__c)+' '+ord.CurrencyIsoCode + ' ('+ amount + ' ' + us.DefaultCurrencyIsoCode +')';
                        list_info.add(new CustomHierachy(ord.Id,'Order',str));
                    }else{
                        str = creaDate + ' - ' + ord.SAP_Order_No__c + ' - ' + ord.Account.Name + ' - ' + ord.Account.BillingCity + ' - ' +Integer.valueOf(ord.Total_Amount__c)+' '+ord.CurrencyIsoCode+ ' ('+ amount + ' ' + us.DefaultCurrencyIsoCode +')';
                        list_info.add(new CustomHierachy(ord.Id,'Other',str));
                    }
                }
            }
            this.hierJson = Json.serialize(list_info);
        }
        
    }
    @RemoteAction 
    global static String getChildRd(String id){
        list<CustomHierachy> list_hierachy = new list<CustomHierachy>();
        User us = [select Id,Name,DefaultCurrencyIsoCode from User where id =: UserInfo.getUserId()];
        decimal rate = 0;
        map<String,decimal> map_isoCode_rate = new map<String,decimal>();
        for(CurrencyType cur:[select Id,ConversionRate,IsoCode from CurrencyType]){
            map_isoCode_rate.put(cur.IsoCode,cur.ConversionRate);
        }
        String quoteQuery = 'select Id,Name,Creation_Date__c,Statistic_Flag__c,Quote_Total__c,Quote_Account__r.Name,Quote_Account__r.BillingCity,Additional_Discount__c,Sales_Doc_Type__c,Reference_Doc__c,CurrencyIsoCode,SAP_Discount__c from Quote__c where (Sales_Doc_Type__c = \'AG\' or Sales_Doc_Type__c = \'AF\')';
        String orderQuery = 'select Id,Name,CreatedDate,SAP_Order_No__c,Account.Name,Account.BillingCity,Total_Amount__c,Type,CurrencyIsoCode from Order where (Type = \'KA\' or Type = \'KL\' or Type = \'TA\' or Type = \'ZANZ\' or Type = \'ZES\' or Type = \'ZLAG\' or Type = \'ZLES\' or Type = \'ZMUS\' or Type = \'ZTAW\' or Type = \'KM\' or Type = \'ZMKC\')';
        if(id.substring(0,3) == '006'){
            quoteQuery += ' and Opportunity__c = \''+id+'\'';
            orderQuery += ' and OpportunityId = \''+id+'\'';
        }else{
            quoteQuery += ' and Reference_Doc__c = \''+id+'\'';
            orderQuery += ' and Quote__c = \''+id+'\'';
        }
        //for(Quote__c qu:[select Id,Name,Creation_Date__c,Statistic_Flag__c,Quote_Total__c,Quote_Account__r.Name,Quote_Account__r.BillingCity,Additional_Discount__c,Sales_Doc_Type__c,Reference_Doc__c,CurrencyIsoCode from Quote__c where Reference_Doc__c =:id and (Sales_Doc_Type__c = 'AG' or Sales_Doc_Type__c = 'AF')]){
        system.debug('aaaaaaaaaaaaaaaa:'+quoteQuery);
        for(Quote__c qu : Database.query(quoteQuery)){
            String str = '';
            String creaDate = '';
            String accName = '';
            String accCity = '';
            if(qu.Statistic_Flag__c == null) qu.Statistic_Flag__c = '';
            if(qu.SAP_Discount__c == null) qu.SAP_Discount__c = 0.00;
            if(qu.Quote_Account__c != null) accName = qu.Quote_Account__r.Name;
            if(qu.Quote_Account__c != null && qu.Quote_Account__r.BillingCity != null) accCity = qu.Quote_Account__r.BillingCity;
            if(qu.Creation_Date__c != null){
                creaDate = qu.Creation_Date__c.day()+'/'+qu.Creation_Date__c.month()+'/'+qu.Creation_Date__c.year();
            } 
            Integer total = 0;
            if(qu.Quote_Total__c == null) qu.Quote_Total__c = 0.00;
            if(qu.Quote_Total__c != null && qu.Quote_Total__c != 0){
                system.debug('aaaaaaaaaaaaaaaaaa:'+qu.CurrencyIsoCode+'---'+us.DefaultCurrencyIsoCode);
                total = Integer.valueOf(qu.Quote_Total__c/map_isoCode_rate.get(qu.CurrencyIsoCode)*map_isoCode_rate.get(us.DefaultCurrencyIsoCode));
            }else{
                qu.SAP_Discount__c = 0.00;
            }
            if(qu.Sales_Doc_Type__c == 'AF'){
                str = creaDate + ' - ' + qu.Name + ' - ' + qu.Statistic_Flag__c + ' - ' +Integer.valueOf(qu.Quote_Total__c)+' '+qu.CurrencyIsoCode+' ('+ total + ' ' + us.DefaultCurrencyIsoCode + ')';
                list_hierachy.add(new CustomHierachy(qu.Id,'AF',str));
            }else{
                str = creaDate + ' - ' + qu.Name + ' - ' + accName + ' - ' + accCity + ' - ' + qu.Statistic_Flag__c + ' - SR: ' + qu.SAP_Discount__c + ' - ' +Integer.valueOf(qu.Quote_Total__c)+' '+qu.CurrencyIsoCode+ ' ('+ total + ' ' + us.DefaultCurrencyIsoCode +')';
                list_hierachy.add(new CustomHierachy(qu.Id,'AG',str));
            }
        }
        //for(Order ord:[select Id,Name,CreatedDate,SAP_Order_No__c,Account.Name,Account.BillingCity,Total_Amount__c,Type,CurrencyIsoCode from Order where Quote__c =:id and (Type = 'KA' or Type = 'KB')]){
        for(Order ord : Database.query(orderQuery)){
            String str = '';
            String creaDate = ''; 
            if(ord.CreatedDate != null){
                creaDate = ord.CreatedDate.day()+'/'+ord.CreatedDate.month()+'/'+ord.CreatedDate.year();
            }
            Integer amount = 0;
            if(ord.Total_Amount__c != null && ord.Total_Amount__c != 0){
                amount = Integer.valueOf(ord.Total_Amount__c/map_isoCode_rate.get(ord.CurrencyIsoCode)*map_isoCode_rate.get(us.DefaultCurrencyIsoCode));
            }else{
                ord.Total_Amount__c = 0.00;
            }
            if(ord.Type == 'KA' || ord.Type == 'TA' || ord.Type == 'ZANZ' || ord.Type == 'ZES' || ord.Type == 'ZLAG' || ord.Type == 'ZLES' || ord.Type == 'ZMUS' || ord.Type == 'ZTAW'){
                str = creaDate + ' - ' + ord.SAP_Order_No__c + ' - ' + ord.Account.Name + ' - ' + ord.Account.BillingCity + ' - ' +Integer.valueOf(ord.Total_Amount__c)+' '+ord.CurrencyIsoCode+' ('+ amount + ' ' + us.DefaultCurrencyIsoCode + ')';
                list_hierachy.add(new CustomHierachy(ord.Id,'Order',str));
            }else{
                str = creaDate + ' - ' + ord.SAP_Order_No__c + ' - ' + ord.Account.Name + ' - ' + ord.Account.BillingCity + ' - ' +Integer.valueOf(ord.Total_Amount__c)+' '+ord.CurrencyIsoCode+' ('+ amount + ' ' + us.DefaultCurrencyIsoCode + ')';
                list_hierachy.add(new CustomHierachy(ord.Id,'Other',str));
            }
        }
        return Json.serialize(list_hierachy);
    }
    public class CustomHierachy{
        public String quoteType {get;set;}
        public String quoteInfo {get;set;}
        public String recordId {get;set;}
        public CustomHierachy(String rdId, String qType, String qInfo){
            this.recordId = rdId;
            this.quoteType = qType;
            this.quoteInfo = qInfo;
        }
    }
}