/************************************************************************************************************************
 * Name               : ET_SpeaReconciliationControllerBatchTest                                                        *
 * Description        : Apex Test Class for ET_SpeaReconciliationControllerBatch,ET_FinanceControllerCalloutBatch       *
 * Created Date       : 22/Apr/2024                                                                                     *
 * Created By         : Santosh(SMAARTT)                                                                                *
 * -----------------------------------------------------------------------------------------------                      *
 * VERSION   AUTHOR      DATE                COMMENTS                                                                   *
 * 1.0       Santosh     22/Apr/2024         Initial Draft.                                                             *
 ***********************************************************************************************************************/
@isTest
public class ET_SpeaReconciliationControllerBatchTest {
    @isTest
    static void testBatchExecution() {
        ET_Service_Request__c SRREC = new ET_Service_Request__c();
        SRREC.ETST_Service_Type__c = 'Quarterly';
        SRREC.ETST_Payee__c = 'Parent';
        Insert SRREC;
        
        List<ETST_Payment__c> testPayments = new List<ETST_Payment__c>();
        for (Integer i = 0; i < 3; i++) {
            ETST_Payment__c testPayment = new ETST_Payment__c(
                ET_Service_Request__c = SRREC.Id,
                ETST_Payment_Mode__c = 'Online',
                ETST_Amount__c = 2887.00,
                ETST_Currency__c = 'AED',
                ETST_Payment_State__c = 'CAPTURED',
                ETST_Capture_State__c = 'SUCCESS',
                ETST_AuthorizationCode__c = 'TestAuthCode' + i,
                ETST_Cardholder_Name__c = 'emirates transport'
            );
            testPayments.add(testPayment);
        }
        Insert testPayments;
        
        Test.startTest();
        ET_SpeaReconciliationControllerBatch batchInstance = new ET_SpeaReconciliationControllerBatch();
        batchInstance.givenDateTime = System.now();
        batchInstance.execute(null, testPayments);
        Database.executeBatch(batchInstance,1);
        Test.stopTest();
    }
}