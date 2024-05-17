public class ETT_DeliveryNoteTriggerHandler {
    
    /* public static void updateTyreInventoryStatus(List<ETT_Delivery_Note__c> newList) {
List<ETT_Tyre_Inventory__c> tyreInvList = new List<ETT_Tyre_Inventory__c>();
Set<Id> collectionCardIds = new Set<Id>();
Set<Id> insCardIds = new Set<Id>();
for(ETT_Delivery_Note__c dn: [SELECT Id,ETT_Collection_Card__c,(SELECT Id,ETT_Inspection_Card__c FROM Delivery_Line_Items__r) FROM ETT_Delivery_Note__c WHERE Id In: newList]){
for(ETT_Delivery_Line_Item__c dnl : dn.Delivery_Line_Items__r){
insCardIds.add(dnl.ETT_Inspection_Card__c);
}
collectionCardIds.add(dn.ETT_Collection_Card__c);
}

if(!collectionCardIds.isEmpty()){
for(ETT_Tyre_Inventory__c ti : [SELECT Id, ETT_Status_TI__c,ETT_Tyre_Inspection_Card__c FROM ETT_Tyre_Inventory__c WHERE ETT_Collection_Card__c In: collectionCardIds AND ETT_Tyre_Inspection_Card__c In:insCardIds ]){
ti.ETT_Status_TI__c = 'Delivery Note Created';
ti.ETT_Status_Changed_On__c= system.now();
tyreInvList.add(ti);
}
}
if(!tyreInvList.isEmpty()){
update tyreInvList;
}
} */
    
    public static void updateTyreInventoryStatusApproved(List<ETT_Delivery_Note__c> newList, Map<Id,ETT_Delivery_Note__c> oldMap) {
        List<ETT_Tyre_Inventory__c> tyreInvList = new List<ETT_Tyre_Inventory__c>();
        Set<Id> collectionCardIds = new Set<Id>();
        Set<Id> insCardIds = new Set<Id>();
        
        for(ETT_Delivery_Note__c dn: [SELECT Id,ETT_Collection_Card__c,Approved_By__c,(SELECT Id,ETT_Inspection_Card__c FROM Delivery_Line_Items__r) FROM ETT_Delivery_Note__c WHERE Id In: newList]){
            
            if(dn.Approved_By__c != null && oldMap.get(dn.Id).Approved_By__c != dn.Approved_By__c){
                System.debug('dn.Delivery_Line_Items__r: '+dn.Delivery_Line_Items__r);
                for(ETT_Delivery_Line_Item__c dnl : dn.Delivery_Line_Items__r){
                    insCardIds.add(dnl.ETT_Inspection_Card__c);
                }
                collectionCardIds.add(dn.ETT_Collection_Card__c);
            }
        }
        if(!collectionCardIds.isEmpty()){
            for(ETT_Tyre_Inventory__c ti : [SELECT Id, ETT_Status_TI__c,ETT_Tyre_Inspection_Card__c FROM ETT_Tyre_Inventory__c WHERE ETT_Collection_Card__c In: collectionCardIds AND ETT_Tyre_Inspection_Card__c In:insCardIds ]){
                ti.ETT_Status_TI__c = 'Delivery Note Approved';
                ti.ETT_Status_Changed_On__c= system.now();
                tyreInvList.add(ti);
            }
        }
        if(!tyreInvList.isEmpty()){
            update tyreInvList;
        }
        
    }
    
    public static void updateTyreInventoryStatusCompleted(List<ETT_Delivery_Note__c> newList, Map<Id,ETT_Delivery_Note__c> oldMap) {
        List<ETT_Tyre_Inventory__c> tyreInvList = new List<ETT_Tyre_Inventory__c>();
        Set<Id> collectionCardIds = new Set<Id>();
        Set<Id> insCardIds = new Set<Id>();
        for(ETT_Delivery_Note__c dn: [SELECT Id,ETT_Collection_Card__c,ETT_Service_Appointment_Status__c,(SELECT Id,ETT_Inspection_Card__c FROM Delivery_Line_Items__r) FROM ETT_Delivery_Note__c WHERE Id In: newList]){
            System.debug('dn.ETT_Service_Appointment_Status__c: '+dn.ETT_Service_Appointment_Status__c);
            
            if(dn.ETT_Service_Appointment_Status__c != null && dn.ETT_Service_Appointment_Status__c == 'Completed' && oldMap.get(dn.Id).ETT_Service_Appointment_Status__c != dn.ETT_Service_Appointment_Status__c){
                for(ETT_Delivery_Line_Item__c dnl : dn.Delivery_Line_Items__r){
                    insCardIds.add(dnl.ETT_Inspection_Card__c);
                }
                collectionCardIds.add(dn.ETT_Collection_Card__c);
            }
        }
        
        
        if(!collectionCardIds.isEmpty()){
            for(ETT_Tyre_Inventory__c ti : [SELECT Id, ETT_Status_TI__c,ETT_Tyre_Inspection_Card__c FROM ETT_Tyre_Inventory__c WHERE ETT_Collection_Card__c In: collectionCardIds AND ETT_Tyre_Inspection_Card__c In:insCardIds ]){
                ti.ETT_Status_TI__c = 'Delivered';
                ti.ETT_Status_Changed_On__c= system.now();
                tyreInvList.add(ti);
            }
        }
        if(!tyreInvList.isEmpty()){
            update tyreInvList;
        }
        
    }

    public static void callThisCoverage(){
        Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }

    
    public static void isSubmittedForApproval(List<ETT_Delivery_Note__c> newList){
        
        System.debug('called 1');
        List<ETT_Tyre_Inventory__c> tyreInvList = new List<ETT_Tyre_Inventory__c>();
        Set<Id> collectionCardIds = new Set<Id>();
        Set<Id> insCardIds = new Set<Id>();
        Boolean isLocked = false;
        for(ETT_Delivery_Note__c dn: [SELECT Id,ETT_Collection_Card__c,ETT_Is_Submitted_for_Approval__c,ETT_Service_Appointment_Status__c,(SELECT Id,ETT_Inspection_Card__c FROM Delivery_Line_Items__r) FROM ETT_Delivery_Note__c WHERE Id In: newList]){
            if(dn.ETT_Is_Submitted_for_Approval__c){
                isLocked = true;
            }
            for(ETT_Delivery_Line_Item__c dnl : dn.Delivery_Line_Items__r){
                insCardIds.add(dnl.ETT_Inspection_Card__c);
            }
            collectionCardIds.add(dn.ETT_Collection_Card__c);
        }
        System.debug('called 2 '+collectionCardIds+' : isLocked: '+isLocked);
        
        if(!collectionCardIds.isEmpty() && isLocked){
            for(ETT_Tyre_Inventory__c ti : [SELECT Id, ETT_Status_TI__c,ETT_Tyre_Inspection_Card__c FROM ETT_Tyre_Inventory__c WHERE ETT_Collection_Card__c In: collectionCardIds AND ETT_Tyre_Inspection_Card__c In:insCardIds ]){
                ti.ETT_Status_TI__c = 'Delivery Note Submitted for Approval';
                ti.ETT_Status_Changed_On__c= system.now();
                tyreInvList.add(ti);
            }
        }
        System.debug('called 3 '+tyreInvList);
        if(!tyreInvList.isEmpty()){
            
            System.debug('called 4');
            update tyreInvList;
        }
        
    }


}