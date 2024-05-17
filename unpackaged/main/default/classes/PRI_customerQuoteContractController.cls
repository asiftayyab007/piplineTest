public class PRI_customerQuoteContractController {
    
    public List<PRI_customerQuoteController.Article> contractDetails { get; set; }
    public list<Customer_Vehicle_Quote_Item__c> VehiclList { get; set; }
    
    public PRI_customerQuoteContractController(ApexPages.StandardController stdController) {
        String recordId = stdController.getId();
        contractDetails = PRI_customerQuoteController.getContractClauses(recordId);
        
        Contract_Pdf_Header__c PDFH =[Select Id, Name, Customer_Quote__c from Contract_Pdf_Header__c where Id =:recordId];
        System.debug(Customer_Quote__c.Id);
        VehiclList =[select Id,Name,Vehicle_Source__c,
                     Service_Type__c,
                     Vehicle_Manufacture_Year__c,
                     Number_of_Vehicles__c,
                     Vehicle_Monthly_Price__c,
                     Total_Annual_Price_Target_Prices__c,				
                     Monthly_Rate_All_Unit_with_VAT__c from Customer_Vehicle_Quote_Item__c where Customer_Quote__c =:PDFH.Customer_Quote__c];
        System.debug(VehiclList);
    }
     @AuraEnabled
    public static string generateQuoteDoc(string quoteId, String Sector){
        List<Contract_Pdf_Header__c>  cusQuote =[select Id, Name from Contract_Pdf_Header__c where Id =:quoteId];
        String CusQuoteName = cusQuote[0].Name;
        String VFpageName;
        if(Sector == 'School'){
            VFpageName ='ET_generateContractPdf_School';
        }
         if(Sector == 'Transport And Lease'){
            VFpageName ='ET_generateContractPdf_TL';
        }
		PageReference pdf = new PageReference('/' + VFpageName);
        pdf.getParameters().put('Id',quoteId);
        Blob pdfBlob;
        if (!Test.isRunningTest()) {
            pdfBlob = pdf.getContentAsPDF();
        }
        try{
            ContentVersion conVer = new ContentVersion();
            DateTime  dt = System.now();
            
            conVer.ContentLocation = 'S'; // TO USE S specify this document IS IN Salesforce, TO USE E FOR external files
            conVer.PathOnClient = CusQuoteName+'_'+dt.hour()+dt.minute()+dt.second()+'.pdf'; 
            conVer.Title = CusQuoteName+ '_'+dt.hour()+dt.minute()+dt.second()+'.pdf'; 
            conVer.VersionData = pdfBlob;
            insert conVer;  
            
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            
            ContentDocumentLink conDocLink = new ContentDocumentLink();
            conDocLink.LinkedEntityId = quoteId; //parentId
            conDocLink.ContentDocumentId = conDoc; 
            conDocLink.shareType = 'V';
            insert conDocLink;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        return quoteId;
        
    }
    
}