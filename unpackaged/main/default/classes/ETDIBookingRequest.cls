/***
Class       : ETDIBookingRequest
Author      : Sreelakshmi SK
Test class  : ETDIBookingRequestTest
CreatedDate : 
Description : Controller for ETDI components
TestClass  : 
----------------------------------------------------------------------------------------------------------------
-- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date      Author          Details
1.          V1.0              			          	 Initial Version 
2.        
****************************************************************************************************************/

public without sharing class ETDIBookingRequest {
    
    /*
Method      : getRelatedBRDetails
Author      : Sreelakshmi SK
CreatedDate : 16.06.2023
*/  
    
    @AuraEnabled
    public static List<ETDI_Booking_Request__c> getRelatedBRDetails(String bkreqId) {
        
        return [select id,Name,CreatedDate,Status__c,Requested_Date__c,Language__c,Trainer__c,Trainer__r.Name, Trainer_Name__c, Branch__c,Branch__r.Name, Depot__c,Depot__r.Name,Program_Name__c,Program_Name__r.Name,Exam_Required__c from ETDI_Booking_Request__c where Id=:bkreqId];
    }    
    
    /*
Method      : addTrainee
Author      : Sreelakshmi SK
CreatedDate : 16.06.2023
*/    
    
    @AuraEnabled
    public static string addTrainee(list<Account> empList,string bkreqId) {
        String retStr = 'ERROR';
        Savepoint sp = Database.setSavepoint();
        list<ETDI_Trainees__c> traineeList = new list<ETDI_Trainees__c>();
        
        for(Account emp : empList){
            ETDI_Trainees__c tr = new ETDI_Trainees__c();
            tr.Employee__c= emp.Id;
            tr.ETDI_Booking_Request__c = bkreqId;
            traineeList.add(tr);
        }
        
        if(traineeList.size()>0){
            try{
                insert traineeList;
                retStr = 'SUCCESS';
                
            }catch(Exception e) {
                Database.rollback(sp);
                
            }               
        }
        
        return retStr;
        
    }    
    
    /*
Method      : getAvailableOptions
Author      : Sreelakshmi SK
CreatedDate : 16.06.2023
*/ 
    
    @AuraEnabled
    public static List<String> getAvailableOptions(){
        List<String> AvailableOptions= new List<String>();
        Schema.DescribeFieldResult fieldResult = ETDI_Booking_Request__c.Exam_Required__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            AvailableOptions.add(pickListVal.getLabel());
        }     
        return AvailableOptions;
    }
    
    
    
    /*
Method      : getSlotValues
Author      : Sreelakshmi SK
CreatedDate : 29.05.2023
*/ 
    
    @AuraEnabled
    public static List<String> getSlotValues(){
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = ETDI_Booking_Request__c.Slot__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    
    /*
Method      : getProgramNames
Author      : Sreelakshmi SK
CreatedDate : 22.05.2023
*/ 
    
    @AuraEnabled  
    public static List<ETDI_Programs__c> getProgramNames(){
        list<ETDI_Programs__c> ProgramList= new list<ETDI_Programs__c>();
        ProgramList=[select Name from ETDI_Programs__c];
        return ProgramList;
    }    
    
    /*
Method      : getBranches
Author      : Sreelakshmi SK
CreatedDate : 18.05.2023
*/ 
    
    @AuraEnabled  
    public static List<ETDI_Branches__c> getBranches(){
        list<ETDI_Branches__c> branchList= new list<ETDI_Branches__c>();
        //branchList=[select id,Name from ETDI_Branches__c];
        branchList=[select Name,(select Name,Capacity__c from ETDI_Training_Centers__r) from ETDI_Branches__c];
        return branchList;
    }
    
    /*
Method      : deleteFiles
Author      : Sreelakshmi SK
CreatedDate : 17.05.2023
*/        
    
    @AuraEnabled  
    public static void deleteFiles(string contentDocId){ 
        
        ContentDocument deleteContent = new ContentDocument(Id=contentDocId);
        
        try {
            delete deleteContent;
            
        }
        catch (Exception e) {
            
            throw new AuraHandledException('Something went wrong: '+ e.getMessage()); 
        }
        
    } 
    
    /*
Method      : getTraineeList
Author      : Sreelakshmi SK
CreatedDate : 27.04.2023
*/    
    @AuraEnabled
    public static List<ETDI_Trainees__c> getTraineeList(String BookingId){
        System.debug('BookingId:'+BookingId);
        return [select id,name,Employee__r.Name,ETDI_Booking_Request__c,Employee__r.ETIN_Employee_Id__c,CreatedDate,ETDI_Booking_Request__r.Exam_Required__c,Practical_Marks__c,Remarks__c,Theoretical_Marks__c from ETDI_Trainees__c where ETDI_Booking_Request__c=:BookingId order by Employee__r.ETIN_Employee_Id__c LIMIT 500];
    }  
    @AuraEnabled
    public static List<ETDI_Trainees__c> getTraineeForCertificate(String BookingId){
        System.debug('BookingId:'+BookingId);
        return [select id,name,Employee__r.Name,ETDI_Booking_Request__c,Employee__r.ETIN_Employee_Id__c,CreatedDate,ETDI_Booking_Request__r.Exam_Required__c from ETDI_Trainees__c where ETDI_Booking_Request__c=:BookingId AND Attended__c=true order by Employee__r.ETIN_Employee_Id__c LIMIT 500];
    }  
    
    @AuraEnabled
    public static void updateTraineeList(List<ETDI_Trainees__c> TraineeList,string bookingId){
        
        
        update TraineeList;
        
        system.debug('bookingId:'+bookingId);
        ETDI_Booking_Request__c bookingRequest=new ETDI_Booking_Request__c();
        bookingRequest.Id=bookingId;
        system.debug('bookingRequest.Id:'+bookingRequest.Id);
        bookingRequest.Status__c='Completed';
        bookingRequest.Completed_Date__c=date.today();
        update bookingRequest;
    }
    
    /*
Method      : getTrainerSchedules
Author      : Sreelakshmi SK
CreatedDate : 24.04.2023
*/    
    @AuraEnabled
    public static List<ETDI_Trainer_Schedules__c> getTrainerSchedules(){
        Id currentUserId=UserInfo.getUserId();
        User currentUser = [SELECT Username,email FROM User WHERE Id = :currentUserId];
        String userName = currentUser.Username;
        String email=currentUser.email;
        system.debug('email:'+email);
        return  [select id, name,Booking_Request__c,Booking_Request__r.Name,Booking_Request__r.Language__c,Booking_Request__r.Number_of_Trainees__c,Schedule_Date_Time__c,Trainer__c,Booking_Request__r.Status__c,CreatedDate from ETDI_Trainer_Schedules__c where Status__c='Booked' and Booking_Request__c!=null /*and Booking_Request__r.Status__c!='Completed'*/ and Trainer__r.Account__r.PersonEmail=:email order by name desc LIMIT 100];
    }
    
    @AuraEnabled
    public static List<ETDI_Booking_Request__c> getBRRecords() {
        Id currentUserId=UserInfo.getUserId();
        System.debug('currentUserId >>> '+currentUserId);
        return [select id,Name,CreatedDate,Status__c,Requested_Date__c,Language__c,Trainer__c,Trainer__r.Name, Trainer_Name__c, Branch__c,Branch__r.Name, Depot__c,Depot__r.Name,Program_Name__c,Program_Name__r.Name from ETDI_Booking_Request__c where OwnerId=:currentUserId order by createdDate Desc LIMIT 100];
    }
    
    @AuraEnabled
    public static list<Account> getEmployeeList(string searchKey) {
        string query = 'SELECT Id,Name,ETIN_Employee_Id__c from Account where (Name LIKE  \'%'+ searchKey +'%\' OR ETIN_Employee_Id__c LIKE  \'%'+ searchKey +'%\') AND Type= \'Employee\' limit 5';
        return Database.Query(query);
    } 
    @AuraEnabled
    public static string createBookingReq(ETDI_Booking_Request__c bkngReq,list<Account> empList,string empData) {
        String retStr = 'ERROR';       
        Savepoint sp = Database.setSavepoint();
        insert bkngReq;
        if(bkngReq.Id != null){
            list<ETDI_Trainees__c> trainessList = new list<ETDI_Trainees__c>();
            if(empData != null){
                list<empDataWrapper> empDataList = (List<empDataWrapper>) System.JSON.deserialize(empData, List<empDataWrapper>.class);
                for(empDataWrapper emp : empDataList){
                    if(emp.EmployeeNumber!= null){                    
                        ETDI_Trainees__c tr = new ETDI_Trainees__c();
                        tr.Employee__r=  new Account(ETIN_Employee_Id__c=emp.EmployeeNumber);   
                        tr.ETDI_Booking_Request__c = bkngReq.Id;
                        trainessList.add(tr);
                    }
                    
                }
            }            
            for(Account emp : empList){
                ETDI_Trainees__c tr = new ETDI_Trainees__c();
                tr.Employee__c= emp.Id;
                tr.ETDI_Booking_Request__c = bkngReq.Id;
                trainessList.add(tr);
            }
            system.debug('TraineesListSize:'+trainessList.size());
            if(trainessList.size()>0){
                try{
                    insert trainessList;
                    ETDI_Booking_Request__c etdiQuery =[select id,Name,Trainer__c,Program_Name__r.Department__c from ETDI_Booking_Request__c where Id=:bkngReq.Id];
            		system.debug(etdiQuery.Program_Name__r.Department__c);
                   
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Automatically submitted for approval.');
                    req1.setObjectId(bkngReq.Id);
                    req1.setSubmitterId(UserInfo.getUserId()); 
                    req1.setProcessDefinitionNameOrId('ETDI_Booking_Request_Approval_Process');
                    req1.setSkipEntryCriteria(true);
                    Approval.ProcessResult result = Approval.process(req1);
                    
                     retStr = 'SUCCESS';
                   
                   
                }catch(Exception e) {
                    Database.rollback(sp);
                    
                }               
            }   
        }
        
        return retStr;
        
    }
    public class empDataWrapper{
        public String EmployeeName;
        public String EmployeeNumber;
        
    }
    
    
}