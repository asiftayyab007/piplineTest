/**
* Author:Janardhan
* CreatedDate: 16/12/2021
* Desc:
*testClass:ETT_createJobCardTest
* */
public class ETT_createJobCard {
    
    @auraEnabled
    public static void createJobCard(string recordId,string actionVal){
        
        Savepoint sp = Database.setSavepoint();
        
        List<ETT_Job_Card__c> listOfJobCards = new List<ETT_Job_Card__c>();
        set<id> tyreInventoryIds = new set<id>();
        try{
            ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
            cc.Id = recordId;
            if(actionVal == 'Job Card Created'){
            List<ETT_Inspection_Card__c> lstInspectionCards = [SELECT Id,Recordtype.name,Tyre_Inventory__c,ETT_Collection_Card__r.ETT_Priority__c, ETT_Collection_Card__c, ETT_Status__c,(select Id from Job_Cards__r) 
                                                               FROM ETT_Inspection_Card__c 
                                                               where ETT_Status__c = 'Accept' and 
                                                               ETT_Collection_Card__r.ETT_Inspection_Done__c = true and
                                                               ETT_Collection_Card__c=:recordId];
            
            for(ETT_Inspection_Card__c objIC:lstInspectionCards){
                if(objIC.Job_Cards__r.size()==0){
                    ETT_Job_Card__c objJobCard = new ETT_Job_Card__c();
                    objJobCard.ETT_Inspection_Card__c = objIC.Id;
                    //include conditional values to stage order based on tyre record type (repair or retreading), For repair few stages are not applicable
                    if(objIC.recordType.name=='Tyre - Refurbishing Services'){
                        objJobCard.ETT_Job_Stages_to_Perform_Ordered__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building;Rimming & Enveloping;Curing;Removal of RIM Tube Flap;Final Inspection;Painting;Quality Control';
                    }
                    else{
                        objJobCard.ETT_Job_Stages_to_Perform_Ordered__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building;Rimming & Enveloping;Curing;Removal of RIM Tube Flap;Final Inspection;Painting;Quality Control';//for other record types this will be updated later
                    }
                    objJobCard.Tyre_Inventory__c=objIC.Tyre_Inventory__c;
                    tyreInventoryIds.add(objIC.Tyre_Inventory__c);
                    objJobCard.ETT_Stages__c = 'Buffing'; 
                    objJobCard.ETT_No_of_Buffing_revisions__c=1; 
                    objJobCard.ETT_Priority__c=objIC.ETT_Collection_Card__r.ETT_Priority__c;
                    objJobCard.Collection_Card__c = recordId;
                    listOfJobCards.add(objJobCard);
                }
            }
            insert listOfJobCards;
            
            list<ETT_Tyre_Inventory__c> tyreList  = [select id,ETT_Inventory_Status__c from ETT_Tyre_Inventory__c where Id=:tyreInventoryIds];
            
            for(ETT_Tyre_Inventory__c tyre : tyreList){
                tyre.ETT_Inventory_Status__c = 'Job Card Created';
            }
           
            cc.ETT_Job_Card_Done__c = true;
            cc.ETT_Collection_Status__c='Job Card Created';
            }else if(actionVal == 'Check and Report'){
            cc.ETT_Collection_Status__c=actionVal;   
            }
            update cc;
            
        }catch(Exception e){
            system.debug('---ca'+e.getCause());
            system.debug('----Line'+e.getLineNumber());
            system.debug('---Trac-'+e.getStackTraceString());
            system.debug('---Type-'+e.getTypeName());
            system.debug('---err-'+e.getMessage());
            Database.rollback(sp);            
            throw new AuraHandledException(e.getMessage()); 
        }    
    }
    
}