/**
 * Author: Janardhan
 * Created Date:08/12/2021
 * Test Class:ETT_DeliveryNote_AccCtrlTest
 * 
 **/
public class ETT_DeliveryNote_AccCtrl {

    @auraEnabled
    public static list<ETT_Inspection_Card__c> getInsCards(string recordId){
     
       return [select Id,Tyre_Inventory__c,Tyre_Inventory__r.ETT_Brand__r.Name,Tyre_Inventory__r.Serial_Number__c,Tyre_Inventory__r.ETT_Pattern__r.Name,Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name,Name,ETT_Account__r.Party_Type__c,ETT_Status__c,ETT_Collection_Card__r.Name,ETT_Collection_Card__c,ETT_Collection_Card__r.ETT_Phone__c ,ETT_Collection_Card__r.ETT_Vehicle_Detail__r.name,
               (select Id,ETT_Job_Stages__c,ETT_Failed_Stage__c,ETT_Failed_Reason__c from Job_Cards__r where ETT_Job_Stages__c!='Painting') 
                From ETT_Inspection_Card__c where ETT_Collection_Card__r.ETT_Accounts__c =:recordId AND ETT_Status__c='Send Back' AND Id not in (SELECT ETT_Inspection_Card__c FROM ETT_Delivery_Line_Item__c)];
     
	}
    
     @auraEnabled
    public static list<contact> getConRelatedAcc(string recordId){
        
        return [select id,name,mobilePhone,Account.BillingAddress from Contact where AccountId=:recordId];
        
    }
    
    @auraEnabled
    public static string createDeliveryNote(ETT_Delivery_Note__c dn,list<ETT_Delivery_Line_Item__c> dnlines){
         
         Savepoint sp = Database.setSavepoint();
        
        try{
            
            insert dn;
            
            for(ETT_Delivery_Line_Item__c dnl : dnlines){
                dnl.ETT_Delivery_Note__c = dn.Id;
            }
            insert dnlines;
            
        }catch(Exception e) {
            system.debug('---ca'+e.getCause());
            system.debug('----Line'+e.getLineNumber());
            system.debug('---Trac-'+e.getStackTraceString());
            system.debug('---Type-'+e.getTypeName());          
            Database.rollback(sp);
            throw new AuraHandledException(e.getMessage());   
            
        }
        
        return dn.Id;
    }
}