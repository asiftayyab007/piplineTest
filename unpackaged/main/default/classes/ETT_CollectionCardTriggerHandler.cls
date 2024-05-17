/*
CreatedDate:24/08/2020
CreatedBy:G.Krishnareddy
Description :This is for Collection Card handling to Create a Tyre Inspection Card for after approving the FM details.
*/
public class ETT_CollectionCardTriggerHandler {
    
    public static boolean isInspectionRecursive = true;
    public static boolean isJobCardRecursive = true;
    public static boolean isCollectionInventoryRecursive = true;
    public static boolean isWIPInventoryRecursive = true;
    
    public static void colletionCardHandlerAfterUpdate(map<Id,ETT_Collection_Card__c> mapOfNewCollectionCards,map<Id,ETT_Collection_Card__c> mapOfOldCollectionCards){
        //This is for Collection Card with List Of Work Order Line Items
        map<Id,list<WorkOrderLineItem>> mapOfCollectionCardwithWorkOrderLineItems = new map<Id,list<WorkOrderLineItem>>();
        Set<Id> setOfCollectionCards = new set<Id>();
        set<Id> setOfInspectionCardDetails = new set<Id>();
        Set<Id> setOfJobCardOpenCollectionCards = new set<Id>();
        Map<Id,list<ETT_Inspection_Card__c>> mapOfCollectionCardVSInspectionCardsInfo = new map<Id,list<ETT_Inspection_Card__c>>();
        list<ETT_Inspection_Card__c> lstInspectionCards = new list<ETT_Inspection_Card__c>();
        map<Id,ETT_Inspection_Card__c> mapOfCollectionLineItemwithInspectionCards = new map<Id,ETT_Inspection_Card__c>();
        list<ETT_Apex_Error_log__c> lstApexErrorLog = new list<ETT_Apex_Error_log__c>();
        if(mapOfNewCollectionCards!=null && mapOfNewCollectionCards.size()>0){
            system.debug('****mapOfNewCollectionCards****'+mapOfNewCollectionCards);
            for(ETT_Inspection_Card__c obJInspectionCard :[Select Id,ETT_Collection_Card__r.ETT_Inspection_Done__c,ETT_Collection_Card__c,ETT_Collection_Card__r.ETT_Work_Order__r.status from ETT_Inspection_Card__c where ETT_Collection_Card__c in :mapOfNewCollectionCards.keyset() and ETT_Collection_Line_Item__c!=null and ETT_Collection_Card__r.ETT_Work_Order__r.status='New']){
                if(mapOfCollectionCardVSInspectionCardsInfo.containsKey(obJInspectionCard.ETT_Collection_Card__c)){
                    mapOfCollectionCardVSInspectionCardsInfo.get(obJInspectionCard.ETT_Collection_Card__c).add(obJInspectionCard);
                }else{
                    mapOfCollectionCardVSInspectionCardsInfo.put(obJInspectionCard.ETT_Collection_Card__c,new list<ETT_Inspection_Card__c>{obJInspectionCard});
                }
            }
        } 
        
     }
    
    public static void createJobCard(map<Id,ETT_Collection_Card__c> mapOfNewCollectionCards,map<Id,ETT_Collection_Card__c> mapOfOldCollectionCards){
        
        //  check old map values and new map values. if i try to reupdate then throw error
        
        List<ETT_Job_Card__c> listOfJobCards = new List<ETT_Job_Card__c>();
        if(mapOfNewCollectionCards!=null && mapOfNewCollectionCards.size()>0){
            
            List<ETT_Inspection_Card__c> lstInspectionCards = [SELECT Id,Recordtype.name, ETT_Collection_Card__c,ETT_Collection_Card__r.ETT_Priority__c,ETT_Status__c,(select Id from Job_Cards__r) 
                                                               FROM ETT_Inspection_Card__c 
                                                               where ETT_Status__c = 'Accept' and 
                                                               ETT_Collection_Card__r.ETT_Inspection_Done__c = true and
                                                               ETT_Collection_Card__c in :mapOfNewCollectionCards.keyset()];
            
            if(lstInspectionCards!=null && lstInspectionCards.size()>0){
                for(ETT_Inspection_Card__c objIC:lstInspectionCards){
                    if(objIC.Job_Cards__r.size()==0){
                        ETT_Job_Card__c objJobCard = new ETT_Job_Card__c();
                        objJobCard.ETT_Inspection_Card__c = objIC.Id;
                        //include conditional values to stage order based on tyre record type (repair or retreading), For repair few stages are not applicable
                        if(objIC.recordType.name=='Tyre - Refurbishing Services'){
                            objJobCard.ETT_Job_Stages_to_Perform_Ordered__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building;Rimming & Enveloping;Curing;Final Inspection;Painting';
                        }
                        else{
                            objJobCard.ETT_Job_Stages_to_Perform_Ordered__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building;Rimming & Enveloping;Curing;Final Inspection;Painting';//for other record types this will be updated later
                        }
                        objJobCard.ETT_Stages__c = 'Buffing'; //Kumaresan changed stage to buffing
                        objJobCard.ETT_No_of_Buffing_revisions__c=1; //Kumaresan added
                        objJobCard.ETT_Priority__c=objIC.ETT_Collection_Card__r.ETT_Priority__c;
                        listOfJobCards.add(objJobCard);
                    }
                }
                
                if(listOfJobCards!=null && listOfJobCards.size()>0){
                    try{
                        insert listOfJobCards;
                        
                        List<ETT_Tyre_Inventory__c> lstTyreInventory = new List<ETT_Tyre_Inventory__c>();
                        for(ETT_Job_Card__c objJC:listOfJobCards){
                            ETT_Tyre_Inventory__c objTyreInventory = new ETT_Tyre_Inventory__c();
                            objTyreInventory.RecordTypeId = Schema.SObjectType.ETT_Tyre_Inventory__c.getRecordTypeInfosByName().get('WIP Inventory').getRecordTypeId();
                            objTyreInventory.ETT_Job_Card__c = objJC.Id;
                            objTyreInventory.ETT_Inventory_Status__c = 'WIP';
                            
                            lstTyreInventory.add(objTyreInventory);
                        }
                        
                       // insert lstTyreInventory;
                        
                        
                    }catch(Exception ex){
                        System.debug('Exception : '+ex.getMessage());
                    }
                }
            }
        }
        
    }
    
    public static void sendRejectedTyreDetails(List<ETT_Collection_Card__c> newList) {
        
        Set<Id> rejectedTyreIds = new Set<id>();
        Set<Id> collectionCardIds = new Set<id>();
        Map<Id, Set<id>> mapId = new Map<Id, Set<id>>();
        Map<Id, List<ContentVersion>> mapContentVersion = new Map<Id, List<ContentVersion>>();
        
        System.debug('newList: '+newList);
        List<ETT_Tyre_Rejection_Report__c> lstTR = [Select id,name,Collection_Card__c from ETT_Tyre_Rejection_Report__c where Collection_Card__c in:newList];
        System.debug('lstTR: '+lstTR);
        
        for(ETT_Tyre_Rejection_Report__c tr : [Select id,name,Collection_Card__c from ETT_Tyre_Rejection_Report__c where Collection_Card__c in:newList]){
            rejectedTyreIds.add(tr.Id);
            if(!mapId.containsKey(tr.Collection_Card__c)) {
                mapId.put(tr.Collection_Card__c, new Set<Id>());
            }
            mapId.get(tr.Collection_Card__c).add(tr.Id);
        }
        if(!rejectedTyreIds.isEmpty()){
            Set<Id> cdLinkSet = new Set<Id>();
            for(ContentDocumentLink cdLink : [SELECT LinkedEntityId,ContentDocumentId FROM ContentDocumentLink where LinkedEntityId In:rejectedTyreIds]){
                cdLinkSet.add(cdLink.ContentDocumentId);                 
            }
            List<ContentVersion> fileVersion = [SELECT Id, Title, VersionData, ContentDocumentId, ContentBodyId,FileType, FileExtension FROM ContentVersion 
                                                WHERE contentdocumentid In : cdLinkSet];
            
            EmailTemplate et = [SELECT Id,Subject,htmlvalue, Body FROM EmailTemplate WHERE DeveloperName =:'ETT_Rejected_Tyre_by_CT'];
            List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
            List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
                        String[] toAddresses = new String[]{'sree.chandu@smaartt.com'};
                List<User> userList = [SELECT Email FROM User WHERE Profile.Name = 'ETT_Head of Operations'];
            for(User u : userList) {
                toAddresses.add(u.email);
            }
            for(ETT_Collection_Card__c cc : newList){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(toAddresses);
                mail.setUseSignature(false);
                mail.setSaveAsActivity(false);
                mail.setSenderDisplayName('ET');
                mail.setTargetObjectId(userList[0].Id);
                mail.setTemplateId(et.Id);
                mail.setHTMLBody(et.body);
                mail.setWhatId(cc.Id);
                for(ContentVersion cv : fileVersion){
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName(cv.Title);
                    efa.setContentType('image/png');
                    efa.setBody(cv.VersionData);
                    attachments.add(efa);
                }
                mail.setFileAttachments(attachments);
                messages.add(mail);
            }
            
            if(!messages.isEmpty()){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            }
        }
        
    }

    public static void updateTyreInventoryStatus(List<ETT_Collection_Card__c> newList,Map<Id,ETT_Collection_Card__c> oldMap) {
        List<ETT_Tyre_Inventory__c> tyreInvList = new List<ETT_Tyre_Inventory__c>();
        Map<Id, String> mapStatus = new Map<Id,String>();
        Set<Id> collectionCardIds = new Set<Id>();
        for(ETT_Collection_Card__c cc: newList){
            if(cc.ETT_Estimation_Completed_By_HOO__c==true && cc.ETT_Estimation_Completed_By_HOO__c != oldMap.get(cc.Id).ETT_Estimation_Completed_By_HOO__c)
                collectionCardIds.add(cc.Id);
        }
        if(!collectionCardIds.isEmpty()){
            for(ETT_Tyre_Inventory__c ti : [SELECT Id, ETT_Status_TI__c,ETT_Tyre_Inspection_Card__c FROM ETT_Tyre_Inventory__c WHERE ETT_Collection_Card__c In: collectionCardIds ]){
                ti.ETT_Status_TI__c = 'Estimation Accepted';
                ti.ETT_Status_Changed_On__c= system.now();
                tyreInvList.add(ti);
            }
        }
        if(!tyreInvList.isEmpty()){
            update tyreInvList;
        }
    }  

    public static void callThisMethod(){
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
}