public with sharing class ETST_UtilityMethods {

    // Method to retrieve service details based on a recordId
    @AuraEnabled
    public static ET_Service_Request__c getServiceDetails(String recordId) {
        try {
            // Query for the service request based on the provided recordId
            return [SELECT Id, Name, ET_Account__r.Name, Bank_Account_No__c
                    FROM ET_Service_Request__c
                    WHERE Id = :recordId
                    LIMIT 1];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching service details: ' + e.getMessage());
        }
    }

    // Method to create a payment record
    @AuraEnabled
    public static void createPayment(ETST_Payment__c newPayment, ET_Service_Request__c serviceRequest, String mode) {
        try {
            // Perform any necessary validations or processing before creating the payment record
            // Assign related fields from serviceRequest to newPayment
            newPayment.ETST_Bank_Name__c = serviceRequest.Bank_Account_No__c;

            // Insert the payment record
            insert newPayment;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating payment: ' + e.getMessage());
        }
    }
}