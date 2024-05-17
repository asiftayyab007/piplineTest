@isTest
public class ET_InspectionReceiptCtrl_Test {

    @TestSetup
    static void setup() {
        // Create test data as needed for your tests
        Account acc = new Account(Name = 'Test', ETSALES_Status__c = 'A',
                                  ETSALES_Customer_Type__c = 'individual', ETSALES_Profile_Class__c = 'Individual');
        insert acc;

        ET_Customer_Vehicle__c et = new ET_Customer_Vehicle__c(Status__c = 'Active', Account__c = acc.Id);
        insert et;

        ET_Service_Request__c esr = new ET_Service_Request__c(ET_Account__c = acc.Id, ETC_Service_Type__c= 'Rental Services');
        insert esr;

        ETI_Booking__c book = new ETI_Booking__c(User__c = acc.Id, 
                                                 Customer_Vehicle__c = et.Id,
                                                 Service_Request__c = esr.Id,
                                                 Booking_Status__c = 'Booked');
        insert book;

        ETI_Inspection_Receipt__c eti = new ETI_Inspection_Receipt__c();
        eti.ETI_Account__c = acc.Id; 
        eti.AMAN_Receipt_No__c = '12322';
        eti.ETI_Amount__c = 100.99;
        insert eti;
    }

    @isTest
    public static void testSearchInspectionReceipt() {
        String inspRecptFields = 'AMAN_Receipt_No__c';
        
          Account acc = new Account(Name = 'Test1', ETSALES_Status__c = 'A',
                                  ETSALES_Customer_Type__c = 'individual', ETSALES_Profile_Class__c = 'Individual');
        insert acc;
  ETI_Inspection_Receipt__c eti = new ETI_Inspection_Receipt__c();
        eti.ETI_Account__c = acc.Id; 
        eti.AMAN_Receipt_No__c = '12322';
        eti.ETI_Amount__c = 100.99;
        insert eti;
        // Create a mock response for the web service callout
        Test.setMock(HttpCalloutMock.class, new ET_InspectionReceiptMockCallout());
      
        Test.startTest();
       // String result = ET_InspectionReceiptCtrl.searchInspectionReceipt('12322', inspRecptFields);
       ET_InspectionReceiptCtrl.searchInspectionReceipt(eti.Name,'ETI_Account__c');   
        Test.stopTest();

        // Add assertions to verify the result or check database records
       // System.assertNotEquals(null, result);
    }
    
    
    

    @isTest
    public static void testSaveInspectionReceipt() {
        ETI_Inspection_Receipt__c eti = [SELECT Id FROM ETI_Inspection_Receipt__c LIMIT 1];

        if (eti != null) {
            String inspRecptFields = 'AMAN_Receipt_No__c';

            Test.startTest();
            String result = ET_InspectionReceiptCtrl.saveInspectionReceipt(eti, inspRecptFields);
            Test.stopTest();

            // Add assertions to verify the result or check database records
            System.assertNotEquals(null, result);
        } else {
            System.debug('No ETI_Inspection_Receipt__c record found for testing.');
        }
    }
    
    
    

    @isTest
    public static void testUploadFile() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        String sampleBase64 = EncodingUtil.base64Encode(Blob.valueOf('Sample file content'));
        String contentLinkId = ET_InspectionReceiptCtrl.uploadFile(sampleBase64, 'SampleFile.txt', testAccount.Id);
        ET_InspectionReceiptCtrl.getRelatedFilesByRecordId(testAccount.Id);
        ContentDocumentLink cdl = [SELECT Id FROM ContentDocumentLink WHERE Id = :contentLinkId];
        delete testAccount;
    }
		
    
    
    
}