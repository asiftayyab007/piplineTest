global class ETST_DeactiveTransportRequestsBatch implements Database.Batchable<sObject> {
    public Date dateValue= System.today().toStartOfMonth();//System.today().adddays(1);
    public Date today = Date.today();
    
    List<string> reqStatus = System.Label.ETST_DeactiveBatchStatus.Split(', '); 
    //List<ETST_DeactiveRequestsBatchParams__mdt> dateMdt = [SELECT Tomorrow_Date__c FROM ETST_DeactiveRequestsBatchParams__mdt];
    //Date dateValue = dateMdt[0].Tomorrow_Date__c;
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('----Start---');
        String query = 'select Id,ETST_Pick_Up_End_Date__c ,ETST_Pick_Up_Start_Date__c,ETST_Status__c,ETST_Is_Active__c,ETST_Student__r.ETST_Account_Name__r.PersonEmail,ETST_Student__r.ETST_Account_Name__r.PersonContactId from ET_Service_Request__c';
        query += ' where (ETST_Pick_Up_Start_Date__c >=:dateValue AND ETST_Is_Active__c=false AND ETST_Status__c NOT IN:reqStatus ) OR (ETST_Pick_Up_End_Date__c<=:dateValue AND ETST_Is_Active__c=true)';
        System.debug('----query---' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute( Database.BatchableContext BC,List<ET_Service_Request__c> scope ) {
        for (ET_Service_Request__c request : scope) {
            if (request.ETST_Pick_Up_Start_Date__c >= dateValue && !request.ETST_Is_Active__c ) {
                request.ETST_Is_Active__c = true;
            } else if (request.ETST_Pick_Up_End_Date__c <= dateValue && request.ETST_Is_Active__c) {
                request.ETST_Status__c = System.Label.AutoDeactivated; //'Auto Deactivated';
                request.ETST_Is_Active__c = false;
            }
        }
        try {
            Database.update(scope, false);
        } catch (DMLException ex) {
            System.debug('--Failed to Update the requests' + ex.getMessage());
        }
        /*   EmailTemplate emailTemplate = [select Id, Body  from EmailTemplate where DeveloperName = 'ETST_Auto_Deactivation_Email'];
OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress 
WHERE DisplayName =:System.Label.orgWideEmail];

Messaging.SingleEmailMessage[] emailList = new list<Messaging.SingleEmailMessage>(); 

for(ET_Service_Request__c request : scope){
Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

if (owea.size() > 0) {
email.setOrgWideEmailAddressId(owea.get(0).Id);
}
email.setToAddresses(new String[] {request.ETST_Student__r.ETST_Account_Name__r.PersonEmail});
email.setSaveAsActivity(true);
email.setTargetObjectId(request.ETST_Student__r.ETST_Account_Name__r.PersonContactId);
email.setTemplateId(emailTemplate.Id);

emailList.add(email);
}
Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList); */
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('----finish---');
            }    
}