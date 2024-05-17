trigger ETDI_AutomateApprove on ETDI_Booking_Request__c (before insert, After insert, After update) {
		system.debug(trigger.new);
    
    //     
    
    //
    /*if(trigger.isAfter && trigger.isInsert){
        list<ETDI_Booking_Request__c> ETDIList = new list<ETDI_Booking_Request__c>();
        for(ETDI_Booking_Request__c ETDI: trigger.new){
            ETDI_Booking_Request__c etdiQuery =[select id,Name,Trainer__c,Program_Name__r.Department__c from ETDI_Booking_Request__c where Id=:ETDI.Id];
            system.debug(etdiQuery.Program_Name__r.Department__c);
            
            if(etdiQuery.Program_Name__r.Department__c == 'HR'){
                etdiQuery.Trainer__c = 'a7m8E0000005yIjQAI';
                ETDIList.add(etdiQuery);
                ETDI_HR_Approval_Process approvalProcess = new ETDI_HR_Approval_Process();
                approvalProcess.submitForApproval(ETDI);
            }
        }
        update ETDIList;
    }
    //*/
         
    
    
         
         
         
}