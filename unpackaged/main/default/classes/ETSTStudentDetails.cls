public class ETSTStudentDetails {
	@AuraEnabled
    public static List<ETST_Scheduled_Trips__c> getStudentTripDetails(String studentId) {
        return [SELECT Id, Name, ETST_Student__c, ETST_Date__c, ETST_Direction__c, ETST_Schedule_pickup_time__c, 
                ETST_Schedule_drop_off_time__c, ETST_Bus_Number__c, ETST_Driver__c FROM ETST_Scheduled_Trips__c
                WHERE ETST_Student__c =:studentId];
    }
}