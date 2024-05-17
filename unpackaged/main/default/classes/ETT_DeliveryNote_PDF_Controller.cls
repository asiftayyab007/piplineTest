public class ETT_DeliveryNote_PDF_Controller {
    
    public List<ETT_Delivery_Line_Item__c> dnl { get; set; }
  
    
    public ETT_DeliveryNote_PDF_Controller(ApexPages.StandardController controller){
        
        dnl = [select id,name,ETT_Delivery_Note__r.ETT_Account__r.Name,ETT_Delivery_Note__r.ETT_Account__r.Party_Type__c,ETT_Delivery_Note__r.Name,Tyre_Inventory__c,Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name,Tyre_Inventory__r.ETT_Brand__r.Name,
               ETT_Delivery_Note__r.ETT_Address__c,ETT_Delivery_Note__r.ETT_Collection_Cards__c,ETT_Delivery_Note__r.Contact_Person__c,ETT_Delivery_Note__r.ETT_Date__c,ETT_Delivery_Note__r.ETT_Remark__c,ETT_Delivery_Note__r.ETT_Phone__c,ETT_Delivery_Note__r.ETT_Reference__c,
               ETT_Delivery_Note__r.Approved_By__c,Tyre_Inventory__r.ETT_Pattern__r.Name,Tyre_Inventory__r.Serial_Number__c,ETT_Inspection_Card__r.ETT_Status__c,createdBy.Name from ETT_Delivery_Line_Item__c where ETT_Delivery_Note__c=:ApexPages.currentPage().getParameters().get('id')];
         
      
    }
    
    
}