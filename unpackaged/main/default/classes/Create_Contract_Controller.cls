public class Create_Contract_Controller {

    public string strName {get;set;}
    public string servChargeVal {get;set;}
    public string strName2 {get;set;}
    public string strName3 {get;set;}
    public string strName4 {get;set;}
    public string strName5 {get;set;}
    public string strName6 {get;set;}
    public List<Contract__c> Contractdetails {get;set;}

     public Create_Contract_Controller(ApexPages.StandardController stdController)
    {
        String quoteId = ApexPages.currentPage().getParameters().get('Id'); 
        system.debug(quoteId);
        strName  = ApexPages.CurrentPage().getparameters().get ('name');
        strName2  = ApexPages.CurrentPage().getparameters().get('name2');
        strName3  = ApexPages.CurrentPage().getparameters().get('name3');
        strName4  = ApexPages.CurrentPage().getparameters().get('name4');
        strName5  = ApexPages.CurrentPage().getparameters().get('name5');
        strName6  = ApexPages.CurrentPage().getparameters().get('name6');
        
         Contractdetails=[select Name,Quote_Name__c,Quote_Number__c,Quote_Total_Investment__c,Total_Investment__c,Total_Number_of_Main_Vehicles__c,Total_Number_of_Vehicles__c,Type__c from Contract__c where Quote_Number__c =:quoteId];
    system.debug(Contractdetails);
    } 
    
    
     public Attachment att {
        get {
            if (att == null) {
                att = [SELECT Body, ContentType, Name FROM Attachment WHERE ID = '0698E000002h4GrQAI'];
            }
            return att;
        }
        private set;
    }
    public String pdf { 
        get {
            return EncodingUtil.Base64Encode(att.body);
        }
    }
    
    
}