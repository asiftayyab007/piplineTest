global class ETST_SRActivationBatch implements Database.Batchable<sObject>, schedulable{
    global string queryString ='';
    global Date today=system.today();
    global ETST_SRActivationBatch(){
        queryString +='Select Id,ETST_Prev_Status__c,ETST_Status__c,ETST_Reason_for_Cancellation__c,ETST_Cancellation_End_Date__c,';
        queryString +='ETST_Activation_Effective_Date__c,ETST_Cancellation_Effective_Date__c from ET_Service_Request__c ';
        queryString +='WHERE ETST_Cancellation_Effective_Date__c >=:today OR ETST_Cancellation_End_Date__c =: today'; //ETST_Reason_for_Cancellation__c=\'On Hold\'
        system.debug('queryString '+queryString);
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){        
        return Database.getQueryLocator(queryString);
    }
    
    global void execute(Database.BatchableContext bc, List<ET_Service_Request__c> scope){
        List<ET_Service_Request__c> lstTransportRequestUpdate = new List<ET_Service_Request__c>();
        for(ET_Service_Request__c service : scope){
            if(service.ETST_Cancellation_Effective_Date__c == today){
                service.ETST_Status__c = service.ETST_Reason_for_Cancellation__c=='Permanent Cancellation' 
                    ? 'Parent Cancelled' : 'On Hold';
                service.ETST_Is_Active__c = service.ETST_Reason_for_Cancellation__c=='Permanent Cancellation' 
                    ? false : true; 
                service.ETST_Prev_Status__c = service.ETST_Status__c;
            } else if(service.ETST_Cancellation_End_Date__c == System.today() &&
                      service.ETST_Reason_for_Cancellation__c == 'On Hold'){
                          service.ETST_Activation_Effective_Date__c = System.today();
                          service.ETST_Status__c = service.ETST_Prev_Status__c;
                          service.ETST_Is_Active__c =true; 
                      }
            
            lstTransportRequestUpdate.add(service);
        }
        if(!lstTransportRequestUpdate.isEmpty()){
            if(!system.Test.isRunningTest())
                update lstTransportRequestUpdate;
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new ETST_SRActivationBatch());
    }
}