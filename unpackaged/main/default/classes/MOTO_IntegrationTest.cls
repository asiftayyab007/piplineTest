/*
 Developer Name - Srihari Koyila
 Developed Date - 20 June 2023
 Apex Class     - MOTO_CICO_GetVehicleDetails,MOTO_CICO_AccountInERP,MOTO_CICO_CreatePrivateVehicle.
 Test Class     - MOTO_IntegrationTest , Oracle_Integration_Mock 
 
****************************************************************************************************************/

@isTest
public class MOTO_IntegrationTest {
    
    @isTest
    private static void testIntegLog(){
      
        Test.setMock(HttpCalloutMock.class, new Oracle_Integration_Mock()); 
        
        string AccNumber='1384772';
        
        Account acc = new Account();
        acc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        acc.lastname = 'tetefewf32';
        acc.FirstName='ytrsdrwe43';
        acc.personemail ='ytrsdrwe43@smaarttt.com';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'New Opportunity';
        opp.AccountId =acc.Id;
        opp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Automotive_Service_CenterBodyShop').getRecordTypeId();
        opp.StageName = 'Service Booking';
        opp.Amount = 10000;
        opp.Chassis_Number__c = 'MMBJNKB509D018612';
        opp.Appointment_Date__c = Date.today().addDays(10);
        opp.CloseDate = Date.today().addDays(10);
        opp.Insurance_Company__c = 'Salama Insurance';
        opp.Insurance__c = true;
        insert opp;
        
        Vehicle_Master__c vm = new Vehicle_Master__c();
        vm.Internal_No__c ='PV101011';
        vm.Name ='PV101011';
        vm.Plate_Number__c = '007';
        vm.Last_KM_Reading__c =1000;
        vm.Chassis_No__c ='1CA4HJXDG6JW312161';
        vm.Plate_Source__c= 'DUBAI';
        vm.Plate_colour_code__c= 'A';
        vm.Plate_Type__c= 'PRIVATE';
        vm.Vehicle_Model__c= '2018';
        vm.Account_Id__c = acc.Id;
        //insert vm;
          Test.StartTest();
        MOTO_CICO_GetVehicleDetails.GetVehicleDetails('MMBJNKB509D018612',opp.Id);     
        test.stoptest();
    }
    @isTest
    private static void testIntegLog2(){
        Test.setMock(HttpCalloutMock.class, new Oracle_Integration_Mock());        
	        
        Account acc = new Account();
        acc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        acc.lastname = 'test';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'New Opportunity';
        opp.AccountId =acc.Id;
        opp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Automotive_Service_CenterBodyShop').getRecordTypeId();
        opp.StageName = 'Service Booking';
        opp.Amount = 10000;
        opp.Chassis_Number__c = 'MMBJNKB509D018612';
        opp.Appointment_Date__c = Date.today().addDays(10);
        opp.CloseDate = Date.today().addDays(10);
        opp.Insurance_Company__c = 'Salama Insurance';
        opp.Insurance__c = true;
        insert opp;
        Test.StartTest();
         MOTO_CICO_AccountInERP.sendAccToERP(acc.Id,opp.Id); 
        
        test.stoptest();
    }
     @isTest
    private static void testIntegLog3(){
        Test.setMock(HttpCalloutMock.class, new Oracle_Integration_Mock());        
	        
        Account acc = new Account();
        acc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        acc.lastname = 'test';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'New Opportunity';
        opp.AccountId =acc.Id;
        opp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Automotive_Service_CenterBodyShop').getRecordTypeId();
        opp.StageName = 'Service Booking';
        opp.Amount = 10000;
        opp.Chassis_Number__c = 'MMBJNKB509D018612';
        opp.Appointment_Date__c = Date.today().addDays(10);
        opp.CloseDate = Date.today().addDays(10);
        opp.Insurance_Company__c = 'Salama Insurance';
        opp.Insurance__c = true;
        insert opp;
        Test.StartTest();
         MOTO_CICO_CreatePrivateVehicle.CreatePrivateVehicle('21323',opp.Id); 
        
        test.stoptest();
    }
    
    
}