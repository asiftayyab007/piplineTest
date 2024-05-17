/*
 * Class		: ETDIBookingRequestTest
 * Description  : Test class for ETDIBookingRequest
 * Author		: Sreelakshmi SK
 * Date			: 19/6/23
*/


@isTest
public class ETDIBookingRequestTest {
    
    
    @isTest
    private static void bookngRequesTest(){
        
        Account emp = new Account();
        emp.LastName='test';
        insert emp;
        
        ETDI_Booking_Request__c bkreq = new ETDI_Booking_Request__c();
        bkreq.Language__c='English';
        insert bkreq;
        
        ETDI_Booking_Request__c bkreq2 = new ETDI_Booking_Request__c();
        bkreq2.Language__c='English';
        
        ETDI_Trainees__c trainee= new ETDI_Trainees__c();
        trainee.ETDI_Booking_Request__c=bkreq.Id;
        insert trainee;
        
       ETDIBookingRequest.getBRRecords();    
       ETDIBookingRequest.addTrainee(new list<account>{emp},bkreq.Id);
       ETDIBookingRequest.getRelatedBRDetails(bkreq.Id);
       ETDIBookingRequest.getAvailableOptions();
       ETDIBookingRequest.getSlotValues();
       ETDIBookingRequest.getProgramNames();
       ETDIBookingRequest.getBranches();
       ETDIBookingRequest.getTrainerSchedules();
       ETDIBookingRequest.getTraineeList(bkreq.Id);
       ETDIBookingRequest.getEmployeeList('test');
       ETDIBookingRequest.getTraineeForCertificate(bkreq.Id);
       ETDIBookingRequest.updateTraineeList(new list<ETDI_Trainees__c>{trainee},bkreq.Id);
       ETDIBookingRequest.createBookingReq(bkreq2,new list<account>{emp},null);
    }
      @isTest
    private static void bookngRequesTest2(){
        ETDI_Booking_Request__c bkreq2 = new ETDI_Booking_Request__c();
        bkreq2.Language__c='English';
        
        Account emp = new Account();
        emp.LastName='test';
        insert emp;
        
        string str = '[{"EmployeeName":"tesrt","EmployeeNumber":"test"}]';
        ETDIBookingRequest.createBookingReq(bkreq2,new list<account>{emp},str);
    }
}