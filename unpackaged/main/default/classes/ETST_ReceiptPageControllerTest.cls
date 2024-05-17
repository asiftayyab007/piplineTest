/***
Class       : ETST_ReceiptPageontrollerTest
Author      : Sreelakshmi SK
CreatedDate : 19.05.2023
Description : 
***/
@IsTest
public class ETST_ReceiptPageControllerTest {
    @IsTest
    static void testLoadInvoices() {
        // Create test data
        ET_Service_Request__c serviceRequest = new ET_Service_Request__c();
        insert serviceRequest;
        
        ET_Receipt__c receipt = new ET_Receipt__c(
            ET_Service_Request__c = serviceRequest.Id
        );
        insert receipt;
        
        // Create an instance of the controller
        ETST_ReceiptPageController controller = new ETST_ReceiptPageController();
        controller.recordId = serviceRequest.Id;
        
        // Call the loadInvoices method
        Test.startTest();
        controller.loadInvoices();
        Test.stopTest();
        
        // Assert the results
        List<ET_Receipt__c> receiptList = controller.receiptList;
    }
    
    @IsTest
    static void testConstructorWithNoReceipts() {
        // Create test data
        ET_Service_Request__c serviceRequest = new ET_Service_Request__c();
        insert serviceRequest;
        
        // Create an instance of the controller
        ETST_ReceiptPageController controller = new ETST_ReceiptPageController();
        controller.recordId = serviceRequest.Id;
        
        // Assert that receiptList is empty
        List<ET_Receipt__c> receiptList = controller.receiptList;
        System.assertEquals(0, receiptList.size());
    }
}