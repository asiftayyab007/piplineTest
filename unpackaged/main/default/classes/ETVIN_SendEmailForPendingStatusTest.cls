@isTest
public class ETVIN_SendEmailForPendingStatusTest {
    
    public static testmethod void sendEmailFunc(){
        
        test.startTest();
        ETSALES_Location__c lo = new ETSALES_Location__c();
        lo.Name ='test';
        lo.Location_Code__c='123';
        lo.GL_Zone__c ='Zone A';
        insert lo;
        
        Vehicle_Master__c ve =  new Vehicle_Master__c();
        ve.name = 'B0017298';
        ve.Internal_No__c = 'B0017298';
        ve.Plate_Type__c = 'Police';
        ve.Activity_Center_code__c='123';
        ve.Department_Code__c = '123';
        ve.Project_Code__c='123';
        ve.Location_Code__c='123';
        ve.Activity_Center__c='Police';
        
        
        insert ve;
        Vehicle_Master__c ve1 =  new Vehicle_Master__c();
        ve1.name = 'B0017298';
        ve1.Internal_No__c = 'B0017298';
        ve1.Plate_Type__c = 'Police';
        ve1.Activity_Center_code__c='123';
        ve1.Department_Code__c = '123';
        ve1.Project_Code__c='123';
        ve1.Location_Code__c='123';
        ve1.Activity_Center__c='Dubai';
        
        
        insert ve1;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name=:System.Label.VIN_ZoneProfileName]; 
        User u = new User(Alias = 'standt', Email='standaxne2256@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, ETSALES_Employee_Zone__c='Zone A',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standaxne2256@testorg.com');
        
        System.runAs(u) {
            Account acc = new Account();
            acc.Name = 'test';
            acc.ETSALES_TaxRegistrationNo__c='234333333333333';
            insert acc;
            
            Veh_Default_Insurance_partner__c veh = new Veh_Default_Insurance_partner__c();
            veh.Name ='tet';
            veh.Account_ID__c = acc.Id;            
            insert veh;
            
            ETVIN_Insurance_Policy_Numbers__c insPolicyNum= new ETVIN_Insurance_Policy_Numbers__c();
            insPolicyNum.Name='009128TT';
            insPolicyNum.Activity_Center__c = 'Police';
            insPolicyNum.Active__c=true;
            insert insPolicyNum;
            ETVIN_Insurance_Policy_Numbers__c insPolicyNum1= new ETVIN_Insurance_Policy_Numbers__c();
            insPolicyNum1.Name='009128TT';
            insPolicyNum1.Activity_Center__c = 'Dubai';
            insPolicyNum1.Active__c=true;
            insert insPolicyNum1;
            
            ETVIN_Vehicle_Insurance__c etv = new ETVIN_Vehicle_Insurance__c();
            etv.Vehicle__c = ve.Id;
            etv.ETVIN_Insurance_Company__c= acc.id;
            etv.ETVIN_Insurance_Status__c = 'Active';
            etv.ETVIN_Request_Status__c  = 'New';
            
            insert etv;
            etv.ETVIN_Request_Status__c  ='Insurance Pending';
            update etv;
            etv.ETVIN_Request_Status__c  ='Insurance Approved';
            update etv;
            etv.ETVIN_Request_Status__c  ='Insurance Rejected';
            update etv;
            
            ETIN_Claim__c cl = new ETIN_Claim__c();
            cl.ETIN_Insurance_Partner__c = acc.Id;
            cl.Vehicle_Master__c = ve.Id;
            cl.RecordTypeId = Schema.SObjectType.ETIN_Claim__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Insurance').getRecordTypeId();
            
            insert cl;
            
            cl.ETIN_Claim_Status__c ='Pending';
            //update cl;
            cl.ETIN_Claim_Status__c ='Rejected';
            update cl;
            cl.ETIN_Claim_Status__c ='Approved';
            update cl;
            
            VehicleInsEmailNotification__c vr = new VehicleInsEmailNotification__c();
            vr.Email__c = 'test@gmail.com';
            vr.Label__c ='PRO';
            vr.Name = 'PRO';
            insert vr;
            
            Correction_Cancel_Request__c co  = new Correction_Cancel_Request__c();
            co.Vehicle_Master__c = ve.id;
            co.Vehicle_Insurance_Policy__c = etv.Id;
            co.Request_Status__c= 'New';
            co.Correction_for__c ='Chassis Number';
            co.Insurance_Company__c = acc.id;
            
            insert co;
            co.Request_Status__c= 'Insurance Pending';
            update co;
            co.Request_Status__c= 'Insurance Approved';
            update co;
            co.Request_Status__c= 'Insurance Rejected';
            update co;
            
            Correction_Cancel_Request__c co1  = new Correction_Cancel_Request__c();
            co1.Vehicle_Master__c = ve.id;
            co1.Vehicle_Insurance_Policy__c = etv.Id;
            co1.Insurance_Company__c = acc.Id;
            co1.Request_Status__c= 'New';
            co1.Reason_for_Cancellation__c = 'Vehicle Theft';
            co1.RecordTypeId = Schema.SObjectType.Correction_Cancel_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Theft_Request').getRecordTypeId();
            insert co1;
            
            co1.Reason_for_Cancellation__c = 'Scrapped Vehicle Theft';
            update co1;
            
            ETIN_Insurance_Transactions__c eit = new ETIN_Insurance_Transactions__c();
            
            eit.ETIN_AP_Type__c = 'Debit Note';
            eit.ETIN_Amount__c = 100;
            insert eit;
            
        }
        
        test.stopTest();
        
    }
    
    private static testmethod void testCorrectionReq(){
        test.startTest();
        ETSALES_Location__c lo = new ETSALES_Location__c();
        lo.Name ='test';
        lo.Location_Code__c='123';
        lo.GL_Zone__c ='Zone A';
        insert lo;
        
        Vehicle_Master__c ve =  new Vehicle_Master__c();
        ve.name = 'B0017298';
        ve.Internal_No__c = 'B0017298';
        ve.Plate_Type__c = 'Police';
        ve.Activity_Center_code__c='123';
        ve.Department_Code__c = '123';
        ve.Project_Code__c='123';
        ve.Location_Code__c='123';
        ve.Activity_Center__c='Police';
        
        
        insert ve;
        Vehicle_Master__c ve1 =  new Vehicle_Master__c();
        ve1.name = 'B0017298';
        ve1.Internal_No__c = 'B0017298';
        ve1.Plate_Type__c = 'Police';
        ve1.Activity_Center_code__c='123';
        ve1.Department_Code__c = '123';
        ve1.Project_Code__c='123';
        ve1.Location_Code__c='123';
        ve1.Activity_Center__c='Dubai';
        
        
        insert ve1;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name=:System.Label.VIN_ZoneProfileName]; 
        User u = new User(Alias = 'standt', Email='standaxne2256@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, ETSALES_Employee_Zone__c='Zone A',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standaxne2256@testorg.com');
        
        System.runAs(u) {
            Account acc = new Account();
            acc.Name = 'test';
            acc.ETSALES_TaxRegistrationNo__c='234333333333333';
            insert acc;
            
            Veh_Default_Insurance_partner__c veh = new Veh_Default_Insurance_partner__c();
            veh.Name ='tet';
            veh.Account_ID__c = acc.Id;            
            insert veh;
            
            ETVIN_Insurance_Policy_Numbers__c insPolicyNum= new ETVIN_Insurance_Policy_Numbers__c();
            insPolicyNum.Name='009128TT';
            insPolicyNum.Activity_Center__c = 'Police';
            insPolicyNum.Active__c=true;
            insert insPolicyNum;
            ETVIN_Insurance_Policy_Numbers__c insPolicyNum1= new ETVIN_Insurance_Policy_Numbers__c();
            insPolicyNum1.Name='009128TT';
            insPolicyNum1.Activity_Center__c = 'Dubai';
            insPolicyNum1.Active__c=true;
            insert insPolicyNum1;
            
            ETVIN_Vehicle_Insurance__c etv = new ETVIN_Vehicle_Insurance__c();
            etv.Vehicle__c = ve.Id;
            etv.ETVIN_Insurance_Company__c= acc.id;
            etv.ETVIN_Insurance_Status__c = 'Active';
            etv.ETVIN_Request_Status__c  = 'New';
            
            insert etv;
            ETVIN_Vehicle_Insurance__c etv1 = new ETVIN_Vehicle_Insurance__c();
            etv1.Vehicle__c = ve1.Id;
            etv1.ETVIN_Insurance_Company__c= acc.id;
            etv1.ETVIN_Insurance_Status__c = 'Active';
            etv1.ETVIN_Request_Status__c  = 'New';
            
            insert etv1;
            
            // Change the TC_Number__c to simulate an update scenario
            ve.TC_Number__c = 002;
            List<Vehicle_Master__c> updatedVehicles = new List<Vehicle_Master__c>{ve};
                
                Correction_Cancel_Request__c mulReq = new Correction_Cancel_Request__c();
            mulReq.Vehicle_Master__c = ve.id;
            mulReq.Vehicle_Insurance_Policy__c = etv.Id;
            mulReq.Request_Status__c= 'Insurance Pending';
            mulReq.Insurance_Company__c = acc.id;
            mulReq.RecordTypeId =  Schema.SObjectType.Correction_Cancel_Request__c.getRecordTypeInfosByDeveloperName().get('Available_for_Mulkiya').getRecordTypeId();
            insert mulReq;       
            
            test.stopTest();
        }
    }
    
    @isTest
    static void testSendEmailForMulkiya() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account',  ETSALES_TaxRegistrationNo__c='234333333333333');
        insert testAccount;
        
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'test@example.com', AccountId = testAccount.Id, ETVIN_Insurance_Portal_User__c = true);
        insert testContact;
        
        // Retrieve existing Organization Wide Email Address
        OrgWideEmailAddress[] existingOWEAs = [SELECT Id, Address FROM OrgWideEmailAddress LIMIT 1];
        
        if (existingOWEAs.size() > 0) {
            Test.startTest();
            
            ETVIN_SendEmailForPendingStatus.sendEmailForMulkiya(new Map<Id, Correction_Cancel_Request__c>());
            
            
            Test.stopTest();
        } else {
            System.assert(false, 'No Organization Wide Email Address found. Please configure one for the test.');
        }
    }
    
}