@isTest
public class ETI_Batch_Employee_ServiceTest {
    private static testmethod void testmethodInspection(){
    ETI_Batch_Employee_Service etbb = new ETI_Batch_Employee_Service('23232',system.today());
        
       test.startTest();
         System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Database.executeBatch(etbb);
       
        Test.stopTest();
      
    }

}