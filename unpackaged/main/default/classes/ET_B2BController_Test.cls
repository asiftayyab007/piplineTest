/*
 * 
 * 10/08/2022: Janardhan M:Updated test class and removed fakecode/i++ 
 * */

@isTest(SeeAllData=true)
public class ET_B2BController_Test {
 
    @isTest Public static void wrapperClassesTest(){
        ET_B2BController.MyBusinessWrapper busWrap = new ET_B2BController.MyBusinessWrapper();
        ET_B2BController.CustomerCareWrapper casWrap = new ET_B2BController.CustomerCareWrapper();
        ET_B2BController.getUserDetails('School Transport');     
       
    }
    @isTest 
    Public static void terminateCaseTest(){
        
        String fileData = 'testfilename';
        string jsonstr='[{"strFileName":"Passport.pdf","strFileType":"application/pdf","strBase64Data":"'+fileData+'"}]';
        Account acc = new Account();
        acc.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        acc.Name = 'MINISTRY OF EDUCATION1';
        acc.phone= '01123353';
        acc.billingcity='London';
        acc.billingpostalcode='SW1635HJ';
        acc.billingcountry='United Kingdom uk';
        acc.billingstreet='address 2';
        acc.ETSALES_TaxRegistrationNo__c='123456789876543';
        insert acc;
             
        ET_B2BController.insertTimesheet('test',acc.Id,'test');
        ET_B2BController.getTimesheet('test',acc.Id);
        ET_User_Files__c uf = new ET_User_Files__c();
        uf.Doc_Id__c='test';
        uf.File_Name__c='test';
        insert uf;
            
        ET_B2BController.deleteFile('test');
        
        ET_Sales_Agreement__c etSales = new ET_Sales_Agreement__c();
        etSales.Customer_PO_No__c = 'Test';
        etSales.Salesforce_Customer__c = acc.id;
        etSales.Category__c = 'Transportation';
        insert etSales; 
        
        Customer_PO__c po = new Customer_PO__c(Customer_PO__c='Test'); 
        case cas = new case();
        test.startTest();
        insert po;
       
        ET_B2BController.terminateRequest(cas, 'Test',jsonstr);
         //ET_B2BController.createOffHireRequest(cas,'Test','test desc',jsonstr);
        
        ET_B2BController.getDocId('test','test');
        ET_B2BController.saveUploadedFile(new list<string>{'test'},'test','test',new list<string>{'test'});
        
      
        Test.stopTest();
    }
    @isTest Public static void getTypesTest(){
        List<String> strList = new List<String>();
        strList.add('Leasing');
        ET_B2BController.getTypes();
        ET_B2BController.getServiceTypes(strList);
    }
    @isTest Public static void saveOppTest(){
        
      
      
        Opportunity opp = new Opportunity();
        
        String fileData = 'testfilename';
        string jsonstr='[{"strFileName":"Passport.pdf","strFileType":"application/pdf","strBase64Data":"'+fileData+'"}]';
        
        Test.startTest();
        ET_B2BController.saveOpportunity('Sales opportunity', opp, 'TestPO', 'Dubai',jsonstr);        
       
        Test.stopTest();
    }
    @isTest Public static void getBusinessType(){
        try{
            ET_B2BController.getBusinessType();
        }catch(exception e){
            system.debug('Trace-> '+e);
        }
    }
    @isTest Public static void showVehiclesforMonthTest(){
        Account acc = new Account();
        acc.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        acc.Name = 'MINISTRY OF EDUCATION1';
        acc.phone= '01123353';
        acc.billingcity='america';
        acc.billingpostalcode='SW1635HJ';
        acc.billingcountry='United Kingdom uk';
        acc.billingstreet='address 2';
        insert acc;
        Invoice__c inv1= new Invoice__c(ETST_Active__c=true,Customer__c=acc.id,Payment_Status__c='Paid');
        insert inv1;
        
        Account child = new Account();
        child.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        child.Name = 'MINISTRY 4';
        child.phone= '0112344';
        child.billingcity='London';
        child.billingpostalcode='SW1635HJ';
        child.billingcountry='United Kingdom';
        child.billingstreet='address 21';
        child.ParentId = acc.Id;
        insert child;
        
        Contact c = new Contact(LastName = 'Contact Last Name', AccountId = acc.id);
        insert c; 
        Contact childContact = new Contact(LastName = 'Contact ss Name', AccountId = child.id);
        insert childContact;
		
		id profid=[select id from profile where name='ADNOC Partner Community'].id;
		User user=[select id from user where isactive=true and profileid=:profid limit 1];
        
        /*User user = new User();
        user.ProfileID = [Select Id From Profile Where Name='ADNOC Partner Community'].id;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'first';
        user.LastName = 'last';
        user.Username = 'test12@uniquedomain.com';
        user.CommunityNickname = 'testUser123';
        user.Alias = 't1';
        user.Email = 'no@email.com';
        user.IsActive = true;
        user.ContactId = c.Id;
        insert user; 
        
        User childUser = new User();
        childUser.ProfileID = [Select Id From Profile Where Name='ADNOC Partner Community'].id;
        childUser.EmailEncodingKey = 'ISO-8859-1';
        childUser.LanguageLocaleKey = 'en_US';
        childUser.TimeZoneSidKey = 'America/New_York';
        childUser.LocaleSidKey = 'en_US';
        childUser.FirstName = 'firschildUt';
        childUser.LastName = 'laschildUt';
        childUser.Username = 'test12childU@uniquedomain.com';
        childUser.CommunityNickname = 'tUser123';
        childUser.Alias = 'tchildU';
        childUser.Email = 'childU@email.com';
        childUser.IsActive = true;
        childUser.ContactId = childContact.Id;
        insert childUser; */
        ET_Sales_Agreement__c etSales = new ET_Sales_Agreement__c();
        etSales.Customer_PO_No__c = 'Test';
        etSales.Salesforce_Customer__c = acc.id;
        etSales.Category__c = 'Transportation';
        insert etSales; 
          ET_Sales_Agreement__c etSales2 = new ET_Sales_Agreement__c();
        etSales2.Customer_PO_No__c = 'Test3434';
        etSales2.Salesforce_Customer__c = acc.id;
        etSales2.Category__c = 'Transportation';
        insert etSales2;
        
        ETST_Student__c estud = new ETST_Student__c(ETST_Email__c='abc@xyz.com',ETST_Emirate__c='Dubai',Name='test Student',
                                                    ETST_Nationality__c='India',ETST_Emirates_Id__c='784-2131-3212131-2',
                                                    ETST_ESIS_No__c='2302',ETST_Division__c='5',ETST_Gender__c='Male',ETST_School__c = acc.Id,ETST_Relationship__c='Parent',
                                                    ETST_Student_Id__c='1223',ETST_Date_of_Birth__c=system.today()-1200);
        insert estud;
        
        SALine_Assigned_Vehicle__c vehicle=new SALine_Assigned_Vehicle__c();
        vehicle.Name='vehcle 1';
        vehicle.Account__c = acc.Id;
        vehicle.Sales_Agreement__c = etSales.Id;
        vehicle.Assign_End_Date__c =system.today();
        insert vehicle;
        
        Case cas = new Case(contactId = c.Id);
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Accident/Emergency').getRecordTypeId();
        cas.recordTypeId = caseRecordTypeId;
        insert cas;
        
        ContentVersion fileVar = new ContentVersion();
        fileVar.PathOnClient = 'TestFile';
        fileVar.Title = 'TestFile';
        fileVar.VersionData = Blob.valueOf('sample content');
        insert fileVar;
        //Query the contentDocumentId
        ContentVersion insertedFile = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:fileVar.Id];
        //Link the file with the product
        ContentDocumentLink linkedFile = new ContentDocumentLink(LinkedEntityId=cas.Id, ContentDocumentId=insertedFile.ContentDocumentId);
        insert linkedFile;
        
        ET_User_Files__c newFile = new ET_User_Files__c();
        newFile.File_Name__c ='test file';
        newFile.Doc_Id__c =linkedFile.Id;
        insert newFile;
        

        system.runAs(user){
            ET_B2BController.showVehiclesforMonth('Test', 12,2019);
            ET_B2BController.showActiveMaintenanceWoforMonth('test',1,2019);
             ET_B2BController.getMaintenancePODetails('test');
             ET_B2BController.getprivateschoolUserData();
        }

        
        Test.startTest();
        system.runAs(user){
            //ET_B2BController.showVehiclesforMonth('Test', 12,2019);
            ET_B2BController.showResourcesforMonth('Test', 12,2019);
            ET_B2BController.getPODetails('Test');
            ET_B2BController.getSiteDetails(acc.Id);
            ET_B2BController.getInvDetails(acc.Id);
            ET_B2BController.getUserAccountDetails();
            //ET_B2BController.getUserAccountDetailsbyAccount(acc.Id);
            ET_B2BController.getStudentList();
            ET_B2BController.caseWrapper.getDashboardData();
            ET_B2BController.getCaseDetails('All');
            ET_B2BController.getCaseDetails('In Progress');
            ET_B2BController.getCaseDetails('Closed');
            ET_B2BController.showStudents('Test');
            ET_B2BController.getPOCategory('Test3434');
            ET_B2BController.getProfileDetails();
            ET_B2BController.getPickListValues('Case','Status');
            //ET_B2BController.getQueryDetails();
            ET_B2BController.getCaseDetailsBasedOnFilter('Accident/Emergency',acc.id,'New',true,system.today(),system.today().addDays(20));
           //  ET_B2BController.deleteFile(linkedFile.Id);
            ET_B2BController.getProfileName();
            
            
       
        }
        Test.stopTest();
    }
    @isTest Public static void codeCoverage2(){
        Account acc = new Account();
        acc.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        acc.Name = 'MINISTRY OF EDUCATION1';
        acc.phone= '01123353';
        acc.billingcity='London';
        acc.billingpostalcode='SW1635HJ';
        acc.billingcountry='United Kingdom';
        acc.billingstreet='address 1';
        id profid=[select id from profile where name='ADNOC Partner Community'].id;
		User user=[select id from user where isactive=true and profileid=:profid limit 1];
        system.runAs(user)
        {
            insert acc;
        }
        
        Account acc2 = new Account();
        acc2.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Account').getRecordTypeId();
        acc2.Name='TestAcc24232';
        acc2.phone= '01123353';
        acc2.ETSALES_TaxRegistrationNo__c='123456789876543';
        acc2.ParentId = acc.Id;
        insert acc2;       
        
        Invoice__c inv1= new Invoice__c(ETST_Active__c=true,Customer__c=acc.id,Payment_Status__c='Paid');
        insert inv1;
        Contact c = new Contact(LastName = 'Contact Last Name', AccountId = acc.id);
        insert c; 
		
        
       /* User user = new User();
        user.ProfileID = [Select Id From Profile Where Name='ADNOC Partner Community'].id;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'first';
        user.LastName = 'last';
        user.Username = 'test12@uniquedomain.com';
        user.CommunityNickname = 'testUser123';
        user.Alias = 't1';
        user.Email = 'no@email.com';
        user.IsActive = true;
        user.ContactId = c.Id;
        //user.UserRoleId=userinfo.getUserRoleId();
        insert user; */
        ET_Sales_Agreement__c etSales = new ET_Sales_Agreement__c();
        etSales.Customer_PO_No__c = 'Test';
        etSales.Salesforce_Customer__c = acc.id;
        etSales.Category__c = 'Transportation';
        insert etSales;
       
        
        Vehicle_Master__c vm = new Vehicle_Master__c();
        vm.Name ='B00123456';
        vm.Internal_No__c='B00123456';
        insert vm;
        
        Traffic_Fine__c tf = new Traffic_Fine__c();
        tf.Account__c = acc.Id;
        tf.Vehicle_Master__c = vm.Id;
        insert tf;
        Account_Visit__c avis = new Account_Visit__c();
        avis.Account__c = acc.Id;
        //avis.Purpose_of_Visit__c='test';
        avis.Date_of_Visit__c= system.today();
        insert avis;
        
        ETST_Student__c estud = new ETST_Student__c(ETST_Email__c='abc@xyz.com',ETST_Emirate__c='Dubai',Name='test Student',
                                                    ETST_Nationality__c='India',ETST_Emirates_Id__c='784-2131-3212131-2',
                                                    ETST_ESIS_No__c='2302',ETST_Division__c='5',ETST_Gender__c='Male',ETST_School__c = acc.Id,ETST_Relationship__c='Parent',
                                                    ETST_Student_Id__c='1223',ETST_Date_of_Birth__c=system.today()-1200);
        insert estud;
        
        SALine_Assigned_Vehicle__c vehicle=new SALine_Assigned_Vehicle__c();
        vehicle.Name='vehcle 1';
        vehicle.Account__c = acc.Id;
        vehicle.Sales_Agreement__c = etSales.Id;
        vehicle.Assign_End_Date__c =system.today();
        insert vehicle;
        
        Vehicle_Accident__c va = new Vehicle_Accident__c();
        va.Vehicle__c= vm.id;
        va.Account__c=acc.Id;
        insert va;
                
        Case cas = new Case(contactId = c.Id);
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Accident/Emergency').getRecordTypeId();
        cas.recordTypeId = caseRecordTypeId;
        insert cas;
        
        ContentVersion fileVar = new ContentVersion();
        fileVar.PathOnClient = 'TestFile';
        fileVar.Title = 'TestFile';
        fileVar.VersionData = Blob.valueOf('sample content');
        insert fileVar;
        //Query the contentDocumentId
        ContentVersion insertedFile = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:fileVar.Id];
        //Link the file with the product
        ContentDocumentLink linkedFile = new ContentDocumentLink(LinkedEntityId=cas.Id, ContentDocumentId=insertedFile.ContentDocumentId);
        insert linkedFile;
        
        ET_User_Files__c newFile = new ET_User_Files__c();
        newFile.File_Name__c ='test file';
        newFile.Doc_Id__c =linkedFile.Id;
        insert newFile;
        list<string> doc = new list<string>();
       
        
        Test.startTest();
        system.runAs(user){
            //ET_B2BController.showVehiclesforMonth('Test', 12,2019);
            ET_B2BController.showResourcesforMonth('Test', 12,2019);
            ET_B2BController.showMaintenanceVehiclesforMonth('Test', 12,2019);
            ET_B2BController.showMaintenanceWoforMonth('Test', 12,2019);
            ET_B2BController.showEstimationforMonth('Test', 12,2019);
            ET_B2BController.getPODetails('Test');
            ET_B2BController.getSiteDetails(''+acc.Id);
            ET_B2BController.getInvDetails(''+acc.Id);
            ET_B2BController.getUserAccountDetails();
            ET_B2BController.getUserAccountDetailsbyAccount(acc.Id);
            ET_B2BController.getStudentList();
            ET_B2BController.caseWrapper.getDashboardData();
            ET_B2BController.getCaseDetails('All');
            ET_B2BController.getCaseDetails('In Progress');
            ET_B2BController.getCaseDetails('Closed');
            ET_B2BController.showStudents('Test');
            //ET_B2BController.getPOCategory('Test');
            ET_B2BController.getProfileDetails();
            ET_B2BController.getPickListValues('Case','Status');
            //ET_B2BController.getCaseDetailsBasedOnFilter('Accident/Emergency',acc.id,'New',true,system.today(),system.today().addDays(20));
           //  ET_B2BController.deleteFile(linkedFile.Id);
            ET_B2BController.getProfileName();
           // ET_B2BController.getprivateschoolUserData();
           ET_B2BController.getSaleAgreementInfo(acc.id,true);
           ET_B2BController.getTrafficFineDetails(acc.id,true);
           ET_B2BController.getAccVisitsInfo(acc.id,true);
          
          
        }
        Test.stopTest();
        
       
        
    }
    @isTest Public static void b2bControllerTest(){
        
        Account acc2 = new Account();
        acc2.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Account').getRecordTypeId();
        acc2.Name='TestAcc24232';
        acc2.phone= '01123353';
        acc2.AccountNumber ='12124';
        acc2.ETSALES_TaxRegistrationNo__c='123456789876543';
        insert acc2;  
        CICO_Workshop_Location__c wl = new CICO_Workshop_Location__c();
        wl.name = 'test workshop';
        wl.Location_Code__c ='XYZ-124';
        insert wl;
        
         Vehicle_Master__c vm = new Vehicle_Master__c();
        vm.Name ='B00123456';
        vm.Internal_No__c='B00123456';
        insert vm;
        
        Vehicle_Accident__c va = new Vehicle_Accident__c();
        va.Vehicle__c= vm.id;
        va.Account__c=acc2.Id;
        insert va;
       
        Account_Workshop_Master__c awm = new Account_Workshop_Master__c();
        awm.Account__c=acc2.Id;
        insert awm;
        
        ET_B2BController.getVehicleAccidentInfo(acc2.id,true);
        ET_B2BController.getFleetServiceRequest(acc2.id,true);
        ET_B2BController.getAccVsWorkShopMaster(acc2.Id);        
        ET_B2BController.getHSEInfo(acc2.id,true);
    }    
    @isTest Public static void codeCoverage4(){
        try{
             ET_B2BController.getMaintenancePODetails('test');
        } 
        catch(exception e){}
       
    }
}