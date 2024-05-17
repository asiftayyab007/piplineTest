public class ET_driverCheckLisFormCntrl {
     @AuraEnabled    
    public static list<Driver_Daily_Check_List__c> getDriverCheckListDetails() {
        list<Driver_Daily_Check_List__c> checkList = [Select Id, Name,Date__c,Account__c, Account__r.Name, Assigned_Resources__c, Assigned_Resources__r.Name, School__c,Internal_Number__c, School__r.Name, Branch__c, Station__c From Driver_Daily_Check_List__c Order by CreatedDate asc];
       
        return checkList;
    }

}