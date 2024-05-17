@isTest
private class TestET_FinanceControllerBatch {

    @isTest
    static void testBatchExecution() {
       
        ET_FinanceControllerBatch batchInstance = new ET_FinanceControllerBatch();
        batchInstance.givenDateTime = Datetime.now(); 
        batchInstance.paymentType = 'Online'; 

        // Start the batch
        Test.startTest();
        Database.executeBatch(batchInstance);
        Test.stopTest();

      
    }

  
}