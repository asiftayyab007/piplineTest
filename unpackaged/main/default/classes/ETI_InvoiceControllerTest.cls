/*
* Class Name:ETI_InvoiceController
* Author : Arunsarathy
* CreatedDate : 25.01.2023
*/


@isTest
public class ETI_InvoiceControllerTest {
    
    private static testmethod void testmethodInspection(){
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Contact con = new Contact();
        con.Email =Label.ETI_TargetObject_Email;
        con.LastName = 'Noor';
        insert con;
        
        ET_Customer_Vehicle__c customerVehicle = new ET_Customer_Vehicle__c();
        customerVehicle.Account__c = acc.Id;
        customerVehicle.Chassis_No__c = '43235';
        insert customerVehicle;
        
        ET_Location__c locationObj = new ET_Location__c();
        locationObj.Name = 'Abu Dhabi';
        insert locationObj;
        
        ET_Service_Request__c serviceRequest = new ET_Service_Request__c();
        serviceRequest.ET_Account__c = acc.Id;
        insert serviceRequest;
        
        ETI_Booking__c objBooking = new ETI_Booking__c();
        objBooking.ET_Location__c = locationObj.Id;
        objBooking.Service_Request__c = serviceRequest.Id;
        objBooking.Booking_Date__c = Date.valueOf('2020-07-21');
        objBooking.Service_Type__c = 'Police Inspection';
        objBooking.Customer_Vehicle__c = customerVehicle.Id;
        objBooking.Booking_Status__c = 'Booked';
        insert objBooking;
        
        PageReference pageRef = Page.ETI_BookingInvoice;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(serviceRequest);
        ApexPages.currentPage().getParameters().put('Id',objBooking.id);
        
    }
    
    static testMethod void testInitValueForETServiceRequest(){
        //Creating test data
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        ET_Service_Request__c testServiceRequest = new ET_Service_Request__c();
        testServiceRequest.ET_Account__c = acc.Id;
        testServiceRequest.ETC_Service_Type__c='Rental Services';
        insert testServiceRequest;
        
        ET_Customer_Vehicle__c cv = new ET_Customer_Vehicle__c();
        cv.Account__c=acc.Id;
        insert cv;
        
        
        ETI_Booking__c testBooking = new ETI_Booking__c();
        testBooking.Service_Request__c = testServiceRequest.Id;
        testBooking.Booking_Status__c = 'Booked';
        testBooking.Customer_Vehicle__c = cv.Id;
        testBooking.Booking_Date__c=System.today() ;
        insert testBooking;
       
        ETI_InvoiceController controller = new ETI_InvoiceController();
        controller.initValueForETServiceRequest(testServiceRequest.Id);
        
    }
    static testMethod void testInitValueForETServiceRequest1(){
        //Creating test data
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        ET_Service_Request__c testServiceRequest = new ET_Service_Request__c();
        testServiceRequest.ET_Account__c = acc.Id;
        testServiceRequest.ETC_Service_Type__c='Rental Services';
        insert testServiceRequest;
        
        ET_Customer_Vehicle__c cv = new ET_Customer_Vehicle__c();
        cv.Account__c=acc.Id;
        insert cv;
        
        
        ETI_Booking__c testBooking = new ETI_Booking__c();
        testBooking.Service_Request__c = testServiceRequest.Id;
        testBooking.Booking_Status__c = 'Booked';
        testBooking.Customer_Vehicle__c = cv.Id;
        testBooking.Booking_Date__c=System.today() ;
        insert testBooking;
        
        ETI_InvoiceController controller = new ETI_InvoiceController();
        
        controller.initValueForETBooking(testBooking.Id);
        
    }
    
}