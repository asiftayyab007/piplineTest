public class ETDI_HR_Approval_Process {
    
    
    public void submitForApproval(ETDI_Booking_Request__c ETDI){
        // Create an approval request for the ETDI_Booking_Request__c
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval automatically using Trigger');
        req1.setObjectId(ETDI.id);
        
        // Submit the approval request for the ETDI_Booking_Request__c
        Approval.ProcessResult result = Approval.process(req1);
        ETDI_HR_Approval_Process approvalProcess = new ETDI_HR_Approval_Process();
        approvalProcess.approveRecord(ETDI);
    }
    
    /*
* This method will get the getWorkItemId
*/
    public Id getWorkItemId(Id targetObjectId){
        Id retVal = null;
        
        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
                                                 where p.ProcessInstance.TargetObjectId =: targetObjectId]){
                                                     retVal  =  workItem.Id;
                                                 }
        
        return retVal;
    }
    
    
    /*
* This method will Approve the ETDI_Booking_Request__c
*/
    public void approveRecord(ETDI_Booking_Request__c ETDI){
        system.debug('auto approved');
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Approving request using Trigger');
        req.setAction('Approve');
        // req.setNextApproverIds(new Id[] {ETDI.Next_Approver__c});
        Id workItemId = getWorkItemId(ETDI.id); 
        
        if(workItemId == null){
            ETDI.addError('Error Occured in Trigger');
        }else{
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
        }
    }
    
    
    
}