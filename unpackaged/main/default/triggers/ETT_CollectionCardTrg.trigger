/*
Created By:Shweta Shinde
Created Date:09/29/2020
Description :This is for Collection Card Process 
*/
trigger ETT_CollectionCardTrg on ETT_Collection_Card__c (After update) {
    
    
    if(trigger.isAfter && trigger.isUpdate) {
        List<ETT_ORG_Setting__mdt> ettOrgSettingLst = [SELECT MasterLabel,DeveloperName FROM ETT_ORG_Setting__mdt where MasterLabel=:UserInfo.getProfileId()];
        if(ettOrgSettingLst!=null && ettOrgSettingLst.size()>0 && ETT_CollectionCardTriggerHandler.isInspectionRecursive){
            //ETT_CollectionCardTriggerHandler.colletionCardHandlerAfterUpdate(trigger.newmap,trigger.oldmap);
        }
        
        for (ETT_Collection_Card__c objCC : Trigger.new) {
            
            ETT_Collection_Card__c oldCC = Trigger.oldMap.get(objCC.ID);
            
            if(objCC.ETT_Create_Job_Card__c!=oldCC.ETT_Create_Job_Card__c && objCC.ETT_Create_Job_Card__c==true){
                ETT_CollectionCardTriggerHandler.createJobCard(trigger.newmap,trigger.oldmap);
            }else if(objCC.ETT_Inspection_Done__c!=oldCC.ETT_Inspection_Done__c && objCC.ETT_Inspection_Done__c==true && objCC.ETT_Create_Job_Card__c == true){
                ETT_CollectionCardTriggerHandler.createJobCard(trigger.newmap,trigger.oldmap);
            }
            
        }
        

    }
}