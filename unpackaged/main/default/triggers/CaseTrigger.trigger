trigger CaseTrigger on Case (before update,after update,after insert,before insert,before delete) {
    List<Case> csList= new List<Case>();
    List<Case> csEntitlment= new List<Case>();
    List<Case> updateCases= new List<Case>();
    List<Id> cids= new List<Id>();
    
    List<Id> userRemoveList= new List<Id>();
    List<Id> shareCaseIds= new List<Id>();
    
    /* switch on Trigger.operationType{
when BEFORE_INSERT {
/*System.debug('Before Insert');
for(Case cs: Trigger.New){
if(cs.Assigned_To__c != Trigger.oldMap.get(cs.Id).Assigned_To__c && cs.Assigned_To__c != null){
csList.add(cs);
if(Trigger.oldMap.get(cs.Id).Assigned_To__c!=null){
userRemoveList.add(Trigger.oldMap.get(cs.Id).Assigned_To__c);

}

}

}
CaseTriggerHandler.ModifySharing(csList,userRemoveList);


*/   
    
    /*Added by Sreelakshmi SK - Send email to Account email once the case is closed */
    if(trigger.isAfter && trigger.isUpdate){
        CaseTriggerHandler.SendClosedCaseEmail(Trigger.New,Trigger.OldMap);
        CaseTriggerHandler.SendFeedbackEmail(Trigger.New,Trigger.OldMap); //Commented on 14-6-23
    }
    /*--End --*/
    
    /*Added by Sreelakshmi SK - Send email to Account email once the case is created */
    if(trigger.isAfter && trigger.isInsert){
        CaseTriggerHandler.SendCaseCreationEmail(Trigger.New);
    }
    /*--End --*/
    
    /*Added by Janardhan - Send sms on case status -Solution Completed */
    
    if(trigger.isAfter && trigger.isUpdate && system.label.Case_Trigger_Blocker !='TRUE'){
        CaseTrigger_SMS_Handler.sendSMSNotification(trigger.new,trigger.newMap,trigger.oldMap,false);
    }
    
    
    /*--End --*/
    
    /*Added by Akash apex sharing on case objects */
    
      if(trigger.isAfter && trigger.isInsert){
       

        caseSharingHandler.eseCaseSharing(Trigger.NewMap);   
    }
    /*--End --*/
    if(trigger.isUpdate && trigger.isAfter){
          caseSharingHandler.eseCaseSharingAfterUpdateCase(trigger.oldMap,trigger.newMap);
        
    }
    
    
    if(Trigger.isAfter && Trigger.isInsert && system.label.Case_Trigger_Blocker !='TRUE'){
        for(Case cs : Trigger.New){
            csList.add(cs);
            cids.add(cs.id);
        }
      /*  Id profileId= userinfo.getProfileId();
        system.debug('profileId***'+profileId);
        List<Profile> profileName=[Select Id,Name from Profile where Id=:profileId];
        system.debug('ProfileName***'+profileName); 
        List<Case> casesList= new List<Case>{};  
        system.debug('%%%%%%%%%'+csList);
        if(csList.size()>0 && (profileName[0].Name != 'ETS Community Login' || profileName[0].Name != 'OneET Business Partner Login User'||  profileName[0].Name != 'Govt School Partner User Login' )) CaseTriggerHandler.shareDeptofSchoolActivities(csList);
        if(profileName[0].Name=='ETS Community Login' ){
            //  CaseTriggerHandler.AddCaseAssignmentCommunity(cids);
            
        } */
        system.debug('inside after insert');
    }
    
    
    if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert ) && system.label.Case_Trigger_Blocker !='TRUE')
    {
        if(Trigger.isUpdate){
            system.debug('Inside before update###');
            for(Case cs : Trigger.New){
                
                if(cs.Status=='Closed' && cs.Status != Trigger.oldMap.get(cs.Id).Status){
                    system.debug('Inside before Closed###');
                    
                    if ((cs.SlaStartDate <= system.now())&&(cs.SlaExitDate == null)){
                        system.debug('Inside before Closed2###'+updateCases);
                        
                        updateCases.add(cs);
                    }
                    else{
                        csList.add(cs);
                    }
                }
                else if(cs.Priority!=  Trigger.oldMap.get(cs.Id).Priority && cs.Priority=='Emergency - close within 24 hours' || cs.Priority=='Normal - close within 2 working days' 
                        || cs.Priority=='Complicated - close within 11 working days'){
                            system.debug('Inside before priorty###'+csEntitlment);
                            csEntitlment.add(cs);
                        }
                else if(cs.Status!=  Trigger.oldMap.get(cs.Id).Status && cs.Status=='Solution Completed' && cs.Solution__c!=null && cs.Case_Record_Types__c !='IT Complaints'){
                    system.debug('Inside before priorty###'+Label.Queue_CCM);
                    cs.OwnerId=Label.Queue_CCM;
                    cs.Solution_Completed_Date__c=system.now();
                }
            }
            system.debug('Inside before update###'+csList);
        }
        else if (Trigger.isInsert){
            for(Case cs : Trigger.New){
                if(cs.origin == 'Web'){
                    cs.Priority = 'Emergency - close within 24 hours' ;
                }
                if(cs.Priority=='Emergency - close within 24 hours' || cs.Priority=='Normal - close within 2 working days' 
                   || cs.Priority=='Complicated - close within 11 working days' ){
                       system.debug('Inside before priorty###'+csEntitlment);
                       csEntitlment.add(cs);
                   }
                system.debug('$$$$$$$$$$'+cs.Origin); 
            }
           // CaseTriggerHandler.validateDuplicateCase(Trigger.New);
            system.debug('Inside before update###'+csList);
        }
        
        if(csList.size()>0)CaseTriggerHandler.validatePendingActivies(csList);
        if(updateCases.size()>0)CaseTriggerHandler.updateMilestones(updateCases);
        if(csEntitlment.size()>0)CaseTriggerHandler.validateEntitlement(csEntitlment);
    }
    if(trigger.isAfter && trigger.isUpdate && system.label.Case_Trigger_Blocker !='TRUE'){
        if(CaseTriggerHandler.isFirstTime){
            CaseTriggerHandler.isFirstTime = false;
            CaseTriggerHandler.updateCaseManagerEmailfromQueue(trigger.newMap);
           // CaseTriggerHandler.caliculateNoOfDays(trigger.new);
        }
        List<Case> updateArkaniCloseCaseList = new List<Case>();
        for(Case cs:Trigger.New)
        {
            Case oldcase = System.Trigger.oldMap.get(cs.id);
            String newcaseStatus = cs.Status;
			if(cs.Arkani_Incident_ID__c!=null || cs.Arkani_Incident_ID__c!='')
			{
				if((oldcase.Status!= cs.Status) || (oldcase.SiteVisitTimestamp__c!=cs.SiteVisitTimestamp__c) || (oldcase.Solution_Completed_Date__c!=cs.Solution_Completed_Date__c))
				{
					//CloseCaseInArkani.updateArkaniIdUponCaseClosure(cs.id);
					CloseCaseInArkani.updateArkaniIdUponCase(cs.id);
					}
			}
            
        }
        
        if(updateArkaniCloseCaseList.size()>0)
        {
           update updateArkaniCloseCaseList;
        }
        // Created for no of days by vijay
     
    }
    if(trigger.isBefore && trigger.isDelete){
        CaseTriggerHandler.caseDeleteValidation(trigger.old);
    }
}