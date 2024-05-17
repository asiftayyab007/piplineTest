/**
 * Author:Janardhan
 * CreatedDate: 02-01-2022
 * TestClass: ETT_createJobCardsFromTyreInventTest
 * */
public class ETT_createJobCardsFromTyreInvent {
    
    @auraEnabled 
    public static list<ETT_Tyre_Inventory__c> getTyreDetails(){
        
        
        return [SELECT Id,Name,ETT_Tyre_Size_Master__r.Name,Serial_Number__c,ETT_Brand__r.Name,ETT_Pattern__r.Name,Party_Type__c,ETT_Country__r.Name from ETT_Tyre_Inventory__c where ETT_Inventory_Status__c='Inspected - Approved'  LIMIT 30000];
    }
    
    @auraEnabled 
    public static list<ETT_Job_Card__c> createJobCards(list<ETT_Tyre_Inventory__c> selectedTyres,String customerId){
        
        Savepoint sp = Database.setSavepoint();
        
        List<ETT_Job_Card__c> listOfJobCards = new List<ETT_Job_Card__c>();
        try{
            
            List<ETT_Inspection_Card__c> lstInspectionCards = [SELECT Id,Recordtype.name,Tyre_Inventory__c, ETT_Collection_Card__c, ETT_Status__c,(select Id from Job_Cards__r)
                                                               FROM ETT_Inspection_Card__c 
                                                               where ETT_Status__c = 'Accept' AND Tyre_Inventory__c=:selectedTyres];
             system.debug('---'+lstInspectionCards);
            for(ETT_Inspection_Card__c objIC:lstInspectionCards){
                if(objIC.Job_Cards__r.size()==0){
                    system.debug('entered');
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
                    objJobCard.ETT_Stages__c = 'Buffing'; 
                    objJobCard.ETT_No_of_Buffing_revisions__c=1; 
                    objJobCard.ETT_Priority__c='Medium';
                    objJobCard.Customer__c = customerId;
                    listOfJobCards.add(objJobCard);
                }else{
                     throw new AuraHandledException('Job Card is created already.');
                }
            }
            insert listOfJobCards;
            
           
                     
            for(ETT_Tyre_Inventory__c tyre : selectedTyres){
                tyre.ETT_Inventory_Status__c = 'Job Card Created';
            }
            if(listOfJobCards.size()>0){
                update selectedTyres;
            }
           return listOfJobCards;
            
        }catch(Exception e){
            system.debug('---ca'+e.getCause());
            system.debug('----Line'+e.getLineNumber());
            system.debug('---Trac-'+e.getStackTraceString());
            system.debug('---Type-'+e.getTypeName());
            system.debug('---err-'+e.getMessage());
             Database.rollback(sp);
            throw new AuraHandledException(e.getMessage()+'--'+e.getCause()+'--'+e.getStackTraceString()); 
        }    
    }
}