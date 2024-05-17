@isTest
public class ETT_CollectionCardTriggerHandler_test {
    
    @isTest static void myTest(){
        
        map<Id,ETT_Collection_Card__c> mapOfNewCollectionCards = new map<Id,ETT_Collection_Card__c>();
        map<Id,ETT_Collection_Card__c> mapOfOldCollectionCards = new map<Id,ETT_Collection_Card__c>();
        List<ETT_Collection_Card__c> newList = new List<ETT_Collection_Card__c>();
            
        Account objAcc1 = new Account();
        objAcc1.Name = 'First Account';
        insert objAcc1;
        
        Account objAcc2 = new Account();
        objAcc2.Name = 'Second Account';
        insert objAcc2;
        
        /*WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.Status = 'New';
        insert objWorkOrder;
        */
        ETT_Collection_Card__c objCC = new ETT_Collection_Card__c();
        objCC.ETT_Accounts__c = objAcc1.Id;
        objCC.ETT_Inspection_Done__c = true;
        //objCC.ETT_Work_Order__c = objWorkOrder.Id;
        insert objCC;
        
        ETT_Tyre_Rejection_Report__c objRT = new ETT_Tyre_Rejection_Report__c();
        objRT.ETT_Collection_Card__c = objCC.Name;
        insert objRT;
        
        newList.add(objCC);
        
        WorkOrderLineItem obj = new WorkOrderLineItem();
        obj.ETT_Collection_Card__c = objCC.Id;
        //insert obj;
        
        
        
        mapOfOldCollectionCards.put(objCC.Id,objCC);
        
        objCC.ETT_Accounts__c = objAcc2.Id;
        update objCC;
        
        mapOfNewCollectionCards.put(objCC.Id,objCC);
        
        
        ETT_Inspection_Card__c objInspectionCard = new ETT_Inspection_Card__c();
        objInspectionCard.ETT_Status__c = 'Accept';
        objInspectionCard.ETT_Collection_Card__c = objCC.Id;
        insert objInspectionCard;
        
        
        test.startTest();
        
        
        ETT_CollectionCardTriggerHandler.isCollectionInventoryRecursive = true;
        ETT_CollectionCardTriggerHandler.colletionCardHandlerAfterUpdate(mapOfNewCollectionCards, mapOfOldCollectionCards); 
        ETT_CollectionCardTriggerHandler.createJobCard(mapOfNewCollectionCards, mapOfOldCollectionCards);
        ETT_CollectionCardTriggerHandler.sendRejectedTyreDetails(newList);
        ETT_CollectionCardTriggerHandler.updateTyreInventoryStatus(newList, mapOfOldCollectionCards);
        ETT_CollectionCardTriggerHandler.callThisMethod();
        /*
ETT_CollectionCardTriggerHandler WorkOrder = new ETT_CollectionCardTriggerHandler();
ETT_CollectionCardTriggerHandler WorkOrderLineItem = new  ETT_CollectionCardTriggerHandler();
*/
        
        test.stopTest();
        
        
    }
    
    
}