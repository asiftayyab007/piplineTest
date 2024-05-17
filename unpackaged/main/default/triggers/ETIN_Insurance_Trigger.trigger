trigger ETIN_Insurance_Trigger on ETIN_Insurance__c (after insert,after update,before insert,before update) {
    
  
    if((trigger.IsUpdate || trigger.IsInsert)  && trigger.IsBefore){
        
        //ETIN_UpdateEmailId.updateEmailIdInInsurance(trigger.new);
        //ETIN_InsuranceHelper.CardNumberValidation(trigger.new);
       
        
    }
    
    if(trigger.IsInsert  && trigger.IsBefore){
        
        ETIN_InsuranceHelper.duplicateAdditions(trigger.new);
        ETIN_InsuranceHelper.OldInsuranceStatusUpdate(trigger.new);
        //ETIN_InsuranceHelper.UserAccessCheck(trigger.new); business requested to stop on 08/03/2023
    }
    
    
   
      
 }