/************************************************************************************************************************
 * Name               : ET_FinanceControllerBatchTest                                                                   *
 * Description        : Apex Test Class for ET_FinanceControllerBatch,ET_FinanceControllerCalloutBatch                  *
 * Created Date       : 02/Feb/2024                                                                                     *
 * Created By         : Taj Shaik(SMAARTT)                                                                              *
 * -----------------------------------------------------------------------------------------------                      *
 * VERSION   AUTHOR      DATE                COMMENTS                                                                   *
 * 1.0       Taj Shaik   02/Feb/2024         Initial Draft.                                                             *
 ***********************************************************************************************************************/
@isTest
public class ET_FinanceControllerBatchTest {
    @isTest
    static void testBatchExecution() {
        ET_Service_Request__c SRREC = new ET_Service_Request__c();
        SRREC.ETST_Service_Type__c ='Quarterly';
        SRREC.ETST_Payee__c ='Parent';
        Insert SRREC;
        
        Id ET_Coordinator = [Select id,Name,Profile.Name,IsActive,lastLoginDate, UserRoleId, UserRole.Name,Profile.UserLicense.Name  from User where  isActive=true and Profile.Name ='School Coordinator(Platform)' limit 1].Id;
        String RecTypeId =  [select Id from RecordType where (Name='ET School Transport') and (SobjectType='ET_Receipt__c')].Id;
        
        ET_Receipt__c RCREC = new ET_Receipt__c();
        RCREC.ET_Amount__c = 100500;
        RCREC.ET_Finance_Document__c=null;
        RCREC.ET_Service_Request__c =SRREC.Id;
        RCREC.ET_Coordinator__c=ET_Coordinator;
        RCREC.Payment_Mode__c='Online';
        RCREC.RecordTypeId =RecTypeId;
        Insert RCREC; 
        
        Test.startTest();
        ET_FinanceControllerBatch batchInstance = new ET_FinanceControllerBatch();
        batchInstance.givenDateTime = System.now();
        batchInstance.paymentType = 'Online';
        Database.executeBatch(batchInstance,1);
        Test.stopTest();
    }
}