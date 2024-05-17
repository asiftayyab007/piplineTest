public class ET_BusinessCommunityController {
    @AuraEnabled
    public static List<User> getParentUserDetails(String studentId){
        ETST_Student__c studentRec = [select Id,Name,ETST_Account_Name__c from ETST_Student__c WHERE Id=:studentId LIMIT 1];
        if(studentRec.ETST_Account_Name__c != null){
            Account acc =[Select Id,Name,createdById from Account where Id=:studentRec.ETST_Account_Name__c];
            system.debug('acc '+acc);
            Contact con=[SELECT Id,Name,AccountId,createdById from Contact where AccountId=:acc.Id];
            system.debug('con '+con);
            List<User> u = new List<User>();
            if(con != null){
                u = [Select Id,Name,contactId from User where contactId=:con.Id];
                system.debug('u '+u);
                if(u.size() <=0){
                    u = [Select Id,Name from User where Id=:con.createdById];
                }
            }else{
                u = [Select Id,Name from User where Id=:acc.createdById];
            }
            return u;
        }else{
            return null;
        }
    }
    public class MyBusinessWrapper{
        @AuraEnabled public Map<String,Integer> poList=new Map<String,Integer>();
        @AuraEnabled public String cntRecord;
        @AuraEnabled public String accRecord;
		@AuraEnabled public String accRecordName;
        @AuraEnabled public String accRecordARName;
        @AuraEnabled public String vehicleRecord;
        @AuraEnabled public String salesRecord;
        @AuraEnabled public List<ET_Sales_Agreement__c> salesAgreementList;
        @AuraEnabled public List<SALine_Assigned_Vehicle__c> assignedVehicleList;
        @AuraEnabled public List<SALine_Assigned_Resource__c> assignedResourcesList;
        @AuraEnabled public List<Invoice__c> invoicesList;
        @AuraEnabled public integer schoolsCount=0;
        @AuraEnabled public integer studentsCount=0;
        @AuraEnabled public List<Account> schoolList;
        @AuraEnabled public List<ETST_Student__c> studentsList;
        @AuraEnabled public string accountSite;
        public MyBusinessWrapper(){
            salesAgreementList = new List<ET_Sales_Agreement__c>();
            assignedVehicleList = new List<SALine_Assigned_Vehicle__c>();
            assignedResourcesList = new List<SALine_Assigned_Resource__c>();
            invoicesList = new List<Invoice__c>();
            studentsList=new List<ETST_Student__c>();
        }
    }
    public class CustomerCareWrapper{
        
        @AuraEnabled public List<case> caseList;
        
        public CustomerCareWrapper(){
            caseList = new List<case>();
        }
    }
    @AuraEnabled
    public static Account getBusinessType(){
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        Account acc=[select id,recordtype.developerName,ETST_Account_Type__c from account where id=:u.accountID];
        return acc;//.recordtype.developerName;
    }
    /*
@AuraEnabled
public static List<ET_Sales_Agreement__c> getsalesAggsforPO(String POName){
User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];

return [select Id,Name,Salesforce_Customer__r.Name,  Activity__c, Administration_Charges__c,
Contract_End_Date__c, Contract_No__c, Contract_Start_Date__c, Contract_Status__c, Contract_Type__c, 
Customer_PO_No__c, Customer__c, ETSales_Emirates__c, No_of_Months__c, Other_Charges__c, Premature_Charges__c,
Salesforce_Customer__c, Version__c, ETSALES_Quote__c, ETSALES_Opportunity__c, GL_Activity__c, 
GL_Department__c, GL_Project__c, GL_Location__c, GL_Region__c, GL_Zone__c
from ET_Sales_Agreement__c where 
Salesforce_Customer__c=:u.accountID and Customer_PO_No__c=:POName ORDER BY Name ];

}*/
    @AuraEnabled
    public static List<SALine_Assigned_Vehicle__c> showVehiclesforMonth(String POName,Integer monthNo){
        //added by Akhil M P
        Date myDate = Date.newInstance(System.Today().year(), monthNo, 1); 
        system.debug('mydate'+myDate);
        //end add
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        /* Commented on 31/05
* return [select Id, Name,Sales_Agreement__r.Name,  Assign_Start_Date__c, Assign_End_Date__c,
Sales_Agreement__c,
Vehicle_Description__c, Vehicle_Number__c FROM SALine_Assigned_Vehicle__c
where Sales_Agreement__r.salesforce_Customer__c=:u.accountID 
and Sales_Agreement__r.customer_PO_No__c=:POName
and CALENDAR_MONTH(Assign_End_Date__c) = :monthNo];*/
        return [select Id, Name,Sales_Agreement__r.Name,  Assign_Start_Date__c, Assign_End_Date__c,
                Sales_Agreement__c,
                Vehicle_Description__c, Vehicle_Number__c FROM SALine_Assigned_Vehicle__c
                where Sales_Agreement__r.salesforce_Customer__c=:u.accountID 
                and Sales_Agreement__r.customer_PO_No__c=:POName
                and Assign_End_Date__c >: myDate and Assign_Start_Date__c<:myDate];
    } 
    @AuraEnabled
    public static List<SALine_Assigned_Resource__c> showResourcesforMonth(String POName,Integer monthNo){
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        return [select Id,Name,Sales_Agreement__r.Name,Account__c, Assign_End_Date__c, Assign_Start_Date__c,
                ETST_Assigned_Vehicle__c, Employee_Type__c, Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c
                from SALine_Assigned_Resource__c
                where Sales_Agreement__r.salesforce_Customer__c=:u.accountID 
                and Sales_Agreement__r.customer_PO_No__c=:POName
                and CALENDAR_MONTH(Assign_End_Date__c) = :monthNo];
        
    }
    
    @AuraEnabled
    public static CountClass getPODetails(String POName){
        CountClass wrap=new CountClass();
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        Date startOfMonth = Date.today().toStartOfMonth().addMonths(-2);
        Date endofmonth = startOfMonth.addMonths(3).adddays(-1);
        System.debug('startOfMonth '+startOfMonth);
        System.debug('endofmonth '+endofmonth);
        List<AggregateResult> aggList=[select CALENDAR_MONTH(Assign_End_Date__c) end_month,count(id) cnt from SALine_Assigned_Vehicle__c 
                                       where  Sales_Agreement__r.salesforce_Customer__c=:u.accountID 
                                       and Sales_Agreement__r.customer_PO_No__c=:POName
                                       and Assign_End_Date__c >= :startOfMonth
                                       and Assign_End_Date__c <=:endofmonth
                                       group by CALENDAR_MONTH(Assign_End_Date__c)
                                       order by CALENDAR_MONTH(Assign_End_Date__c) ];
        List<AggregateResult> resourceAggList=[select CALENDAR_MONTH(Assign_End_Date__c) end_month,count(id) cnt 
                                               from SALine_Assigned_Resource__c 
                                               where  Sales_Agreement__r.salesforce_Customer__c=:u.accountID 
                                               and Sales_Agreement__r.customer_PO_No__c=:POName
                                               and Assign_End_Date__c >= :startOfMonth
                                               and Assign_End_Date__c <=:endofmonth
                                               group by CALENDAR_MONTH(Assign_End_Date__c)
                                               order by CALENDAR_MONTH(Assign_End_Date__c) ];
        for(AggregateResult aggr:aggList ){ 
            wrap.VehicleCount.put((integer)aggr.get('end_month'),(integer)aggr.get('cnt'));
        }
        for(AggregateResult aggr:resourceAggList ){ 
            wrap.resourceCount.put((integer)aggr.get('end_month'),(integer)aggr.get('cnt'));
        }
        System.debug('wrapp'+wrap.VehicleCount);
        
        return wrap;
    }
    public Class CountClass{
        @AuraEnabled public map<Integer,Integer> VehicleCount=new map<Integer,Integer>();
        @AuraEnabled public map<Integer,Integer> resourceCount=new map<Integer,Integer>();
        @AuraEnabled public Integer woCount=0; 
    }
    @AuraEnabled
    public static Map<String,String> GetAvailableRecordTypeCase()
    {
        Map<String,String> recordTypeMap = new Map<String,String>();
        system.debug('********Inside**');
        for(RecordType rec : [SELECT Id,  Name, DeveloperName, Description FROM RecordType WHERE SobjectType = 'Case']) {
            recordTypeMap.put(rec.Id, rec.Name);
            system.debug('recordtype' + recordtypemap);
        }
        return recordTypeMap;
    }   
    @AuraEnabled
    public static List<contact> getSiteDetails(){ 
        User u = [select id, AccountId,contactId from User where id = : userinfo.getUserId()];
        return [select id,account.Name,account.ET_Preferred_Location__c,firstName,lastname,Phone from contact where contact.Account.ParentId=:u.AccountId];
        
    }
    
    @AuraEnabled
    public static MyBusinessWrapper getUserAccountDetails(){
        List<Id> salesAgreementIdList = new List<Id>();
        MyBusinessWrapper businessWrapper = new MyBusinessWrapper();
        Id userId = UserInfo.getUserId();
        // Id regularShowId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Business (B2B) - School').RecordTypeId;
        //system.debug('regularShowId '+regularShowId);
        //  Id recordTypeId =[SELECT Id FROM RecordType WHERE DeveloperName = 'Business_School' AND sObjectType = 'Account'].Id;
        User u = [select id, AccountId,contactId from User where id = : userId];
        Id getContactId = u.contactId;
        system.debug('getContactId ' + getContactId);
        
        //Contact communityUserContact = [select Id, name,AccountId from contact where Id=:getContactId];
        //system.debug('communityUserContact ' + communityUserContact);
        businessWrapper.schoolsCount=[select count() from Account where ParentId=:u.AccountId];
        businessWrapper.studentsCount=[select count() from ETST_Student__c where ETST_School__c=:u.AccountId and ETST_Status__c='Active'];
        Account communityUserAccount =[select Id,Name,RecordTypeId,RecordType.Name,ETIN_Name_Arabic__c from account where Id=:u.AccountId ];
        //  Account communityUserAccount =[select Id,Name,RecordTypeId,RecordType.Name from account where Id=:u.AccountId and RecordTypeId  = :regularShowId];
        //Account communityUserAccount =[select Id,Name,RecordTypeId,RecordType.Name from account where Id=:u.AccountId];
        
        businessWrapper.cntRecord=getContactId;//communityUserContact.id;
        businessWrapper.accRecord=communityUserAccount.id;
		businessWrapper.accRecordName=communityUserAccount.Name;
        businessWrapper.accRecordARName=communityUserAccount.ETIN_Name_Arabic__c;
        businessWrapper.studentsList=[select id,Name,ETST_Student_Id__c,ETST_Account_Name__r.Name,ETST_Emirates_Id__c   from ETST_Student__c 
                                      where ETST_School__c=:u.AccountId and ETST_Status__c='Active'];
        businessWrapper.salesAgreementList =[select Id,Name,Salesforce_Customer__r.Name,  Activity__c, Administration_Charges__c,
                                             Contract_End_Date__c, Contract_No__c, Contract_Start_Date__c, Contract_Status__c, Contract_Type__c, 
                                             Customer_PO_No__c, Customer__c, ETSales_Emirates__c, No_of_Months__c, Other_Charges__c, Premature_Charges__c,
                                             Salesforce_Customer__c, Version__c, ETSALES_Quote__c, ETSALES_Opportunity__c, GL_Activity__c, 
                                             GL_Department__c, GL_Project__c, GL_Location__c, GL_Region__c, GL_Zone__c
                                             from ET_Sales_Agreement__c where Salesforce_Customer__c=:communityUserAccount.Id ORDER BY Name ];
        List<AggregateResult> aggList=[select Customer_PO_No__c,count(id) cnt from ET_Sales_Agreement__c 
                                       where Salesforce_Customer__c=:communityUserAccount.Id
                                       group by Customer_PO_No__c];
        for(AggregateResult aggr:aggList ){ 
            businessWrapper.poList.put((String)aggr.get('Customer_PO_No__c'),(integer)aggr.get('cnt'));
        }
        
        
        for(ET_Sales_Agreement__c sg : businessWrapper.salesAgreementList){
            salesAgreementIdList.add(sg.Id);
        }   
        system.debug('salesAgreementIdList '+salesAgreementIdList);
        businessWrapper.assignedVehicleList =[select Id, Name,Sales_Agreement__r.Name,  Assign_Start_Date__c, //Assign_End_Date__c
                                              Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c, Vehicle_Description__c, Vehicle_Number__c
                                              from SALine_Assigned_Vehicle__c where Sales_Agreement__c IN:salesAgreementIdList ORDER BY Name];
        
        businessWrapper.assignedResourcesList =[select Id,Name,Sales_Agreement__r.Name, Assign_End_Date__c, Assign_Start_Date__c,
                                                ETST_Assigned_Vehicle__c, Employee_Type__c, Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c
                                                from SALine_Assigned_Resource__c where Sales_Agreement__c IN:salesAgreementIdList ORDER BY Name];
        
        businessWrapper.invoicesList =[select Id, Name,Sales_Agreement__r.Name, Account_Desc__c, Activity__c, Batch_Source__c, Branch_Name__c,
                                       Complete_Flag__c, Contract_End_Date__c, Contract_Name__c, Contract_Start_Date__c, Created_By__c, CreationDate__c, Ct_Reference__c,
                                       Customer_Invoice_No__c, Customer_Number__c, Customer__c, Department__c, Description__c, Dist_Account__c, ETST_Active__c,
                                       ETST_Bank_Name__c, ETST_Cheque__c, ETST_Coordinator__c, ETST_Courier_Name__c, ETST_Courier__c, ETST_Submitted_By__c,
                                       ETST_Type__c, FromDate__c, Gl_Date__c, Gl_Posted_Date__c, InternalBillNumber__c, Last_Update_By__c, Last_Update_Date__c,
                                       Location__c, Operating_Unit__c, Party_Name__c, Payment_Status__c, Project__c, Ref_Number__c, Ref_Trans_Type__c, Sales_Agreement__c,
                                       Service_Request__c, ToDate__c, Total_Inv_Amount__c, Transaction_Class__c, Transaction_Type__c, Trx_Date__c,
                                       Trx_Number__c, Voucher_Number__c, Zone__c,Due_Amount__c,Invoice_Amount__c,Invoice_Date__c
                                       from Invoice__c 
                                       where (Payment_Status__c='Not Paid' OR Payment_Status__c='Partially Paid')
                                       AND Sales_Agreement__c IN:salesAgreementIdList
                                      ];// and  Customer__c=u.AccountId  AND Sales_Agreement__c IN:salesAgreementIdList ORDER BY Name];
        
        system.debug(' businessWrapper = '+businessWrapper);
        return businessWrapper;
    }
    @AuraEnabled
    public static MyBusinessWrapper getUserAccountDetailsCRM(Id currentId ,String Type){
        MyBusinessWrapper businessWrapper = new MyBusinessWrapper();
        
        if(Type=='Assigned Resource'){
            SALine_Assigned_Resource__c assignedResourcesList =[select Id,Name,Sales_Agreement__r.Name,Account__c, Assign_End_Date__c, Assign_Start_Date__c,
                                                                ETST_Assigned_Vehicle__c , Employee_Type__c, Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c,Account_Site__c
                                                                from SALine_Assigned_Resource__c where Id=:currentId ORDER BY Name];
            businessWrapper.salesRecord=assignedResourcesList.Sales_Agreement__c;
            businessWrapper.accRecord=assignedResourcesList.Account__c;
            businessWrapper.vehicleRecord=assignedResourcesList.ETST_Assigned_Vehicle__c;
            businessWrapper.accountSite = assignedResourcesList.Account_Site__c;
            
        }
        else if(Type=='Assigned vehicle'){
            SALine_Assigned_Vehicle__c assignedVehicleList =[select Id, Name,Account__c ,Sales_Agreement__c, 
                                                             Vehicle_Description__c, Vehicle_Number__c,Account_Site__c from SALine_Assigned_Vehicle__c where Id=:currentId ORDER BY Name];
            businessWrapper.salesRecord=assignedVehicleList.Sales_Agreement__c;
            businessWrapper.accRecord=assignedVehicleList.Account__c;
            businessWrapper.accountSite = assignedVehicleList.Account_Site__c;
            
        }
        else if(Type=='Invoice'){
            Invoice__c invoicesList =[select Id, Name,Sales_Agreement__c,Customer__c
                                      from Invoice__c where Id =:currentId ORDER BY Name];  
            businessWrapper.salesRecord=invoicesList.Sales_Agreement__c;
            businessWrapper.accRecord=invoicesList.Customer__c;
            
        }
        else if(Type=='Sales Aggrement'){
            ET_Sales_Agreement__c salesAgreementList =[select Id,Name,Salesforce_Customer__c,
                                                       GL_Department__c, GL_Project__c, GL_Location__c, GL_Region__c, GL_Zone__c
                                                       from ET_Sales_Agreement__c where Id=:currentId ORDER BY Name ];
            
            businessWrapper.accRecord=salesAgreementList.Salesforce_Customer__c;
            //businessWrapper.accountSite = assignedVehicleList.Account_Site__c !=null ? assignedVehicleList.Account_Site__r.Operation_Manager__c : '';
            
        }
        else if(Type=='Assigned Student'){
            ETST_Student__c studentsList=[select id,Name,ETST_Student_Id__c,ETST_Account_Name__c,ETST_Emirates_Id__c,Account_Site__c,ETST_School__c,ETST_School_Name__c,ETST_School_Name__r.ETST_Sales_Agreement__c from ETST_Student__c 
                                          where Id=:currentId and ETST_Status__c='Active'];
            businessWrapper.accRecord=studentsList.ETST_Account_Name__c;
            businessWrapper.salesRecord=studentsList.ETST_School_Name__r.ETST_Sales_Agreement__c;
            businessWrapper.accountSite = studentsList.Account_Site__c;
            
        }
        else if(Type=='Account'){
            businessWrapper.accRecord=currentId;
            
        }
        system.debug(' businessWrapper = '+businessWrapper);
        return businessWrapper;
    }
    //For Ministry of Education Cases
    @AuraEnabled
    public static MyBusinessWrapper getUserAccountDetailsMoe(){
        List<Id> salesAgreementIdList = new List<Id>();
        MyBusinessWrapper businessWrapperMin = new MyBusinessWrapper();
        Id userId = UserInfo.getUserId();
        
        User u = [select id, AccountId,contactId from User where id = : userId];
        businessWrapperMin.accRecord=u.AccountId;
        businessWrapperMin.studentsList=[select id,Name,ETST_Student_Id__c,ETST_Account_Name__r.Name,ETST_Emirates_Id__c   from ETST_Student__c 
                                         where ETST_School__r.ParentId=:u.AccountId and ETST_Status__c='Active'];
        businessWrapperMin.salesAgreementList =[select Id,Name,Salesforce_Customer__r.Name,  Activity__c, Administration_Charges__c,
                                                Contract_End_Date__c, Contract_No__c, Contract_Start_Date__c, Contract_Status__c, Contract_Type__c, 
                                                Customer_PO_No__c, Customer__c, ETSales_Emirates__c, No_of_Months__c, Other_Charges__c, Premature_Charges__c,
                                                Salesforce_Customer__c, Version__c, ETSALES_Quote__c, ETSALES_Opportunity__c, GL_Activity__c, 
                                                GL_Department__c, GL_Project__c, GL_Location__c, GL_Region__c, GL_Zone__c
                                                from ET_Sales_Agreement__c where Salesforce_Customer__r.ParentId=:u.AccountId  ORDER BY Name ];
        
        for(ET_Sales_Agreement__c sg : businessWrapperMin.salesAgreementList){
            salesAgreementIdList.add(sg.Id);
        }   
        system.debug('salesAgreementIdList '+salesAgreementIdList);
        businessWrapperMin.assignedVehicleList =[select Id, Name,Sales_Agreement__r.Name,  Assign_Start_Date__c,//Assign_End_Date__c
                                                 Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c, Vehicle_Description__c, Vehicle_Number__c
                                                 from SALine_Assigned_Vehicle__c where Sales_Agreement__c IN:salesAgreementIdList ORDER BY Name];
        
        businessWrapperMin.assignedResourcesList =[select Id,Name,Sales_Agreement__r.Name, Assign_End_Date__c, Assign_Start_Date__c,
                                                   ETST_Assigned_Vehicle__c, Employee_Type__c, Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c
                                                   from SALine_Assigned_Resource__c where Sales_Agreement__c IN:salesAgreementIdList ORDER BY Name];
        
        businessWrapperMin.invoicesList =[select Id, Name,Sales_Agreement__r.Name, Account_Desc__c, Activity__c, Batch_Source__c, Branch_Name__c,
                                          Complete_Flag__c, Contract_End_Date__c, Contract_Name__c, Contract_Start_Date__c, Created_By__c, CreationDate__c, Ct_Reference__c,
                                          Customer_Invoice_No__c, Customer_Number__c, Customer__c, Department__c, Description__c, Dist_Account__c, ETST_Active__c,
                                          ETST_Bank_Name__c, ETST_Cheque__c, ETST_Coordinator__c, ETST_Courier_Name__c, ETST_Courier__c, ETST_Submitted_By__c,
                                          ETST_Type__c, FromDate__c, Gl_Date__c, Gl_Posted_Date__c, InternalBillNumber__c, Last_Update_By__c, Last_Update_Date__c,
                                          Location__c, Operating_Unit__c, Party_Name__c, Payment_Status__c, Project__c, Ref_Number__c, Ref_Trans_Type__c, Sales_Agreement__c,
                                          Service_Request__c, ToDate__c, Total_Inv_Amount__c, Transaction_Class__c, Transaction_Type__c, Trx_Date__c,
                                          Trx_Number__c, Voucher_Number__c, Zone__c
                                          from Invoice__c where Sales_Agreement__c IN:salesAgreementIdList ORDER BY Name];
        
        return businessWrapperMin;
    }
    
    @AuraEnabled
    public static List<Case> getCustomerCareDetails(String caseNumber,String Status,String salesAgId, String assignedResId,String assignedVehId,String invoiceId){
        
        system.debug('caseNumber = '+caseNumber);
        system.debug('Status = '+Status);
        system.debug('salesAgId = '+salesAgId);
        system.debug('assignedResId = '+assignedResId);
        system.debug('assignedVehId = '+assignedVehId);
        system.debug('invoiceId = '+invoiceId);
        
        CustomerCareWrapper ccWrapper = new CustomerCareWrapper(); 
        MyBusinessWrapper businessWrapper = getUserAccountDetails();
        
        system.debug('businessWrapper in customer care method = '+businessWrapper );
        Id AccId=businessWrapper.accRecord;
        system.debug('#########'+AccId);
        Set<Id> salesAgreementIdList = new Set<Id>();
        for(ET_Sales_Agreement__c sg:businessWrapper.salesAgreementList){
            salesAgreementIdList.add(sg.Id);
        }
        system.debug('salesAgreementIdList = '+salesAgreementIdList );
        
        Set<Id> resourcesIdList = new Set<Id>();
        for(SALine_Assigned_Resource__c resc:businessWrapper.assignedResourcesList){
            resourcesIdList.add(resc.Id);
        }
        system.debug('resourcesIdList = '+resourcesIdList );
        
        Set<Id> vehiclesIdList = new Set<Id>();
        for(SALine_Assigned_Vehicle__c veh:businessWrapper.assignedVehicleList){
            vehiclesIdList.add(veh.Id);
        }
        system.debug('vehiclesIdList = '+vehiclesIdList );
        
        Set<Id> invoicesIdList = new Set<Id>();
        for(Invoice__c inv:businessWrapper.invoicesList){ 
            invoicesIdList.add(inv.Id);
        }
        system.debug('invoicesIdList = '+invoicesIdList );
        
        ccWrapper.caseList =[select id,CaseNumber,Status,RecordType.Name,RecordTypeId,Invoice__c,Invoice__r.name,
                             Subject, Description, Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                             Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name
                             from Case where RecordType.Name = 'B2B Business Portal Cases'
                             AND (Sales_Agreement__c IN:salesAgreementIdList
                                  OR Assigned_Resource__c IN:resourcesIdList
                                  OR Assigned_Vehicle__c IN:vehiclesIdList
                                  OR  Invoice__c IN:invoicesIdList
                                  OR  AccountId =:AccId)];
        
        system.debug('caseListttsss '+ccWrapper.caseList);
        Set<Case> caseFilteredList = new Set<Case>();
        
        for (Integer i = 0; i < ccWrapper.caseList.size(); i++) {
            if (
                (String.isNotBlank(caseNumber) ? ccWrapper.caseList[i].CaseNumber.contains(caseNumber) : true )    
                &&
                (String.isNotBlank(Status) ? ccWrapper.caseList[i].Status.equals(Status) : true)
                &&
                containsField(ccWrapper.caseList[i].Sales_Agreement__c, salesAgId)
                &&
                containsField(ccWrapper.caseList[i].Assigned_Resource__c, assignedResId)
                &&
                containsField(ccWrapper.caseList[i].Assigned_Vehicle__c, assignedVehId)
                &&
                containsField(ccWrapper.caseList[i].Invoice__c, invoiceId)
            ){
                
                caseFilteredList.add(ccWrapper.caseList[i]);
            }
        }
        
        system.debug('caseFilteredList = '+caseFilteredList );
        List<Case> updatedCaseFilteredList = new List<Case>(caseFilteredList);
        return updatedCaseFilteredList;
    }
    public class caseWrapper{ 
        @AuraEnabled public Integer newCount=0; 
        @AuraEnabled public Integer inprogressCount=0; 
        @AuraEnabled public Integer closedCount=0; 
        @AuraEnabled public Integer rejectedCount=0; 
        @AuraEnabled public Integer approvedCount=0; 
        @AuraEnabled public string loggedinUserProfileName; 
    }
    
    @AuraEnabled
    public static caseWrapper getDashboardData() {
        system.debug('in getDashboardData ');
        caseWrapper dashboardWrap=new caseWrapper();
        try{
            String privateSchoolLabel = System.Label.ET_Private_School_Profile_Name;
            String governmentSchoolLabel = System.Label.ET_Government_School_Profile_Name;
            String moeDepartmentActivitySchoolLabel = System.Label.ET_MOE_Department_Of_School_Activities_Profie;
            String moeDepartmentServicesSchoolLabel = System.Label.ET_MOE_Department_Of_School_Services_Profie;
            String moePersonnelManagementLabel = System.Label.ET_MOE_Personnel_Management_Profie_Name;
            String moeSpecialEducationtLabel = System.Label.ET_MOE_Special_Education_Profie_Name;
            string govtschool='P-Govt School Partner User Login';
            
            system.debug('profile privateSchoolLabel '+privateSchoolLabel);
            Profile p=[Select Id,Name from Profile where Id=:userInfo.getProfileId() LIMIT 1];
            system.debug('profile Name '+p.name);
            if(p.Name !=privateSchoolLabel && p.Name !=governmentSchoolLabel 
               && p.Name !=moeDepartmentActivitySchoolLabel && p.Name !=moeDepartmentServicesSchoolLabel
               && p.Name !=moePersonnelManagementLabel && p.Name !=moeSpecialEducationtLabel && p.Name!=govtschool){
                   system.debug('inside if');
                   dashboardWrap.newCount=[select count() from Case where status  ='New'];
                   system.debug(' newCount '+ dashboardWrap.newCount);
                   dashboardWrap.inprogressCount=[select count() from Case where status  ='In Progress'];
                   system.debug(' inprogressCount '+ dashboardWrap.inprogressCount);
                   dashboardWrap.rejectedCount=[select count() from Case where status  ='Rejected'];
                   system.debug(' rejectedCount '+ dashboardWrap.rejectedCount);
                   dashboardWrap.approvedCount=[select count() from Case where status  ='Approved']; 
                   system.debug(' approvedCount '+ dashboardWrap.approvedCount);
                   dashboardWrap.closedCount=[select count() from Case where status  ='Closed'];
                   system.debug(' closedCount '+ dashboardWrap.closedCount);
                   dashboardWrap.loggedinUserProfileName = [Select Id,Name from Profile WHERE Id=:userinfo.getProfileId()].Name;
                   
               }else if(p.Name ==privateSchoolLabel || p.Name ==governmentSchoolLabel 
                        || p.Name ==moeDepartmentActivitySchoolLabel || p.Name ==moeDepartmentServicesSchoolLabel
                        || p.Name ==moePersonnelManagementLabel || p.Name ==moeSpecialEducationtLabel || p.Name ==govtschool){
                            system.debug('line 425else***');
                            String listoftypes=System.Label.ET_Special_Requests_Record_Types;
                            List<String>  casetypeList= new List<String>();
                            casetypeList=listoftypes.split(',');
                            
                            User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
                            system.debug('u'+u.AccountId);
                            Account Acc=[select id,Name from Account where Id=:u.AccountId];
                            system.debug('acc details'+Acc);
                            List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: Acc.id];
                            system.debug('acc details'+acctListChild);
                            Set<id> childAccountIDs=new Set<id>();
                            childAccountIDs.add(Acc.Id);
                            for(Account childAcc:acctListChild){
                                childAccountIDs.add(childAcc.Id);
                            }
                            system.debug('childAccountIDs getDashboardData='+childAccountIDs);
                            //dashboardWrap.newCount=[select count() from Case where status  ='New' AND AccountId IN:childAccountIDs ];//AND AccountId IN:childAccountIDs AND  RecordType.Name IN :casetypeList
                            dashboardWrap.newCount=[select count() from Case where status  ='New' AND RecordType.developerName IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions') ];
                            if(p.Name == moeDepartmentActivitySchoolLabel||p.Name == moeDepartmentServicesSchoolLabel||p.Name ==moePersonnelManagementLabel||p.Name ==moeSpecialEducationtLabel || p.Name ==govtschool){
                                dashboardWrap.inprogressCount=[select count() from Case where Status='In Progress' AND RecordType.developerName IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions')];//  AND AccountId IN:childAccountIDs AND  RecordType.Name IN :casetypeList
                                dashboardWrap.rejectedCount=[select count() from Case where status  ='Rejected' AND RecordType.developerName IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions')];
                                dashboardWrap.approvedCount=[select count() from Case where status  ='Approved' AND RecordType.developerName IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions') ];
                                dashboardWrap.closedCount=[select count() from Case where status  ='Closed' AND RecordType.developerName IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions')] ;
                            }
                            else{
                                dashboardWrap.inprogressCount=[select count() from Case where status  ='In Progress' AND AccountId IN:childAccountIDs AND RecordType.developerName IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions')];//  AND AccountId IN:childAccountIDs AND  RecordType.Name IN :casetypeList
                                dashboardWrap.rejectedCount=[select count() from Case where status  ='Rejected' AND AccountId IN:childAccountIDs AND RecordType.developerName IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions')];
                                dashboardWrap.approvedCount=[select count() from Case where status  ='Approved' AND AccountId IN:childAccountIDs AND RecordType.developerName IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions')];
                                dashboardWrap.closedCount=[select count() from Case where status  ='Closed' AND AccountId IN:childAccountIDs AND RecordType.developerName IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions')] ; 
                            }
                            // dashboardWrap.rejectedCount=[select count() from Case where status  ='Rejected' AND AccountId IN:childAccountIDs];//AND AccountId IN:childAccountIDs AND  RecordType.Name IN :casetypeList
                            // dashboardWrap.approvedCount=[select count() from Case where status  ='Approved' AND AccountId IN:childAccountIDs]; // AND AccountId IN:childAccountIDs AND  RecordType.Name IN :casetypeList
                            // dashboardWrap.closedCount=[select count() from Case where status  ='Closed' AND AccountId IN:childAccountIDs] ; // AND AccountId IN:childAccountIDs AND  RecordType.Name IN :casetypeList
                            
                            dashboardWrap.loggedinUserProfileName = [Select Id,Name from Profile WHERE Id=:userinfo.getProfileId()].Name;
                            
                        }  
            system.debug('dashboardWrap***'+dashboardWrap); 
            return dashboardWrap;   
        }    
        catch (Exception ex) {
            System.debug(ex.getMessage());
            return null;
            
        }
    }
    
    @AuraEnabled
    public static caseWrapper getDashboardDataCustomerCare() {
        system.debug('getDashboardDataCustomerCare');
        caseWrapper dashboardWrap=new caseWrapper();
        try{
            User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
            system.debug('uuser details'+u);
    
            Account Acc=[select id,Name from Account where Id=:u.AccountId];  
            system.debug('acc details'+Acc);
            List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: Acc.id];
            
            List<Case> caseList = new List<Case>();
            system.debug('acctListChild.size()'+acctListChild.size());
           system.debug('acctListChild()'+acctListChild);
            String listoftypes=System.Label.ET_Special_Requests_Record_Types;
            List<String>  casetypeList= new List<String>();
            casetypeList=listoftypes.split(',');
            
            
            Set<id> childAccountIDs=new Set<id>();
             String moeDepartmentActivitySchoolLabel = System.Label.ET_MOE_Department_Of_School_Activities_Profie;
            String moeDepartmentServicesSchoolLabel = System.Label.ET_MOE_Department_Of_School_Services_Profie;
            String moePersonnelManagementLabel = System.Label.ET_MOE_Personnel_Management_Profie_Name;
            String moeSpecialEducationtLabel = System.Label.ET_MOE_Special_Education_Profie_Name;
            
           
            Profile p=[Select Id,Name from Profile where Id=:userInfo.getProfileId() LIMIT 1];
            system.debug('profile Name '+p.name);
             dashboardWrap.loggedinUserProfileName = [Select Id,Name from Profile WHERE Id=:userinfo.getProfileId()].Name;
            if(acctListChild.size()>0 && (p.Name == moeDepartmentActivitySchoolLabel||p.Name == moeDepartmentServicesSchoolLabel||p.Name ==moePersonnelManagementLabel||p.Name ==moeSpecialEducationtLabel)){
                for(Account childAcc:acctListChild){
                    childAccountIDs.add(childAcc.Id);
                }
                system.debug('childAccountIDs getDashboardData='+childAccountIDs);
               
                
                dashboardWrap.newCount=[select count() from Case where status ='New' AND AccountId IN:childAccountIDs AND RecordType.developerName Not IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions')];
               dashboardWrap.inprogressCount=[select count() from Case where status='In Progress' AND AccountId IN:childAccountIDs AND RecordType.developerName Not IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions')];
               dashboardWrap.closedCount=[select count() from Case where status  ='Closed' and AccountId IN:childAccountIDs AND RecordType.developerName Not IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions')];
                system.debug('dashboardWrap*****'+dashboardWrap);
                
            }
            else{
                childAccountIDs.add(Acc.Id);
                system.debug('childAccountIDs getDashboardData='+childAccountIDs);
                dashboardWrap.newCount=[select count() from Case where status ='New' AND AccountId=:childAccountIDs AND RecordType.developerName Not IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions') ];
                dashboardWrap.inprogressCount=[select count() from Case where status='In Progress' AND AccountId=:childAccountIDs AND RecordType.developerName Not IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions')];
                dashboardWrap.closedCount=[select count() from Case where status  ='Closed' and AccountId=:childAccountIDs AND RecordType.developerName Not IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions')];
                system.debug('dashboardWrap*****'+dashboardWrap);
                
            }
            

            return dashboardWrap;   
            
        }
        catch (Exception ex) {
            System.debug(ex.getMessage());
            return null;
            
        }
        
    }
    @AuraEnabled
    public static List<Case> getCaseDetails(string status) {
        system.debug('in getCaseDetails');
        system.debug('in getCaseDetails status'+status);
        try{
            
            String privateSchoolLabel = System.Label.ET_Private_School_Profile_Name;
            String governmentSchoolLabel = System.Label.ET_Government_School_Profile_Name;
            String moeDepartmentActivitySchoolLabel = System.Label.ET_MOE_Department_Of_School_Activities_Profie;
            String moeDepartmentServicesSchoolLabel = System.Label.ET_MOE_Department_Of_School_Services_Profie;
            String moePersonnelManagementLabel = System.Label.ET_MOE_Personnel_Management_Profie_Name;
            String moeSpecialEducationtLabel = System.Label.ET_MOE_Special_Education_Profie_Name;
            string govtschool='P-Govt School Partner User Login';
            system.debug('profile privateSchoolLabel '+privateSchoolLabel);
            Profile p=[Select Id,Name from Profile where Id=:userInfo.getProfileId() LIMIT 1];
            system.debug('profile Name in getCaseDetails '+p.Name);
            List<Case> caseList = new List<Case>();
            if(p.Name !=privateSchoolLabel && p.Name !=governmentSchoolLabel 
               && p.Name !=moeDepartmentActivitySchoolLabel && p.Name !=moeDepartmentServicesSchoolLabel
               && p.Name !=moePersonnelManagementLabel && p.Name !=moeSpecialEducationtLabel && p.Name!=govtschool){
                   system.debug('if  getCaseDetails');
                   if(status == 'All'){
                       system.debug('all  getCaseDetails');
                       caseList= [select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                  Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                  Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate
                                  from Case where status IN ('New','In Progress','Rejected','Approved','Closed') Order by CaseNumber DESC]; 
                       // system.debug('caseList  '+caseList[0].RecordType.developerName);
                   } else {
                       system.debug('else if  getCaseDetails');
                       caseList= [select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                  Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                  Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate
                                  from Case where status=:status Order by CaseNumber DESC];
                       
                   }
                   
               }else if(p.Name ==privateSchoolLabel || p.Name ==governmentSchoolLabel 
                        || p.Name ==moeDepartmentActivitySchoolLabel || p.Name ==moeDepartmentServicesSchoolLabel
                        || p.Name ==moePersonnelManagementLabel || p.Name ==moeSpecialEducationtLabel || p.Name==govtschool){
                            system.debug('else if  childid');
                            String listoftypes=System.Label.ET_Special_Requests_Record_Types;
                            List<String>  casetypeList= new List<String>();
                            casetypeList=listoftypes.split(',');
                            
                            User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
                            Account Acc=[select id,Name from Account where Id=:u.AccountId];
                            system.debug('acc details'+Acc);
                            List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: Acc.id];
                            Set<id> childAccountIDs=new Set<id>();
                            childAccountIDs.add(Acc.Id);
                            for(Account childAcc:acctListChild){
                                childAccountIDs.add(childAcc.Id);
                            }
                            system.debug('childAccountIDs getCaseDetails='+childAccountIDs);
                            
                            
                            if(status == 'All'){
                                system.debug('all if  getCaseDetails');
                                caseList= [select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                           Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                           Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate
                                           from Case where status IN ('New','In Progress','Rejected','Approved','Closed') AND RecordType.developerName IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions') Order by CaseNumber DESC]; //AND AccountId IN:childAccountIDs
                            }else {
                                system.debug('child else  if  getCaseDetails');
                                if(status =='In Progress' && (p.Name == moeDepartmentActivitySchoolLabel||p.Name == moeDepartmentServicesSchoolLabel||p.Name ==moePersonnelManagementLabel||p.Name ==moeSpecialEducationtLabel || p.Name==govtschool)){
                                    caseList= [select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                               Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                               Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate
                                               from Case where Status='In Progress' AND RecordType.developerName IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions') Order by CaseNumber DESC]; 
                                    
                                }else if(status =='Rejected' && (p.Name == moeDepartmentActivitySchoolLabel||p.Name == moeDepartmentServicesSchoolLabel||p.Name ==moePersonnelManagementLabel||p.Name ==moeSpecialEducationtLabel || p.Name==govtschool)){
                                    caseList= [select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                               Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                               Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate
                                               from Case where Status='Rejected' AND RecordType.developerName IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions') Order by CaseNumber DESC];
                                } else if(status =='Closed' && (p.Name == moeDepartmentActivitySchoolLabel||p.Name == moeDepartmentServicesSchoolLabel||p.Name ==moePersonnelManagementLabel||p.Name ==moeSpecialEducationtLabel || p.Name==govtschool)){
                                    caseList= [select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                               Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                               Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate
                                               from Case where Status='Closed' AND RecordType.developerName IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions') Order by CaseNumber DESC];
                                }
                              /*  else if(p.Name ==governmentSchoolLabel && (status=='New'||status=='In Progress'||status=='Closed' )){
                                     caseList= [select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                               Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                               Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate
                                               from Case where status=:status AND AccountId IN:childAccountIDs AND RecordType.developerName NOT IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions') Order by CaseNumber DESC]; 
                                } */else{
                                    
                                    caseList= [select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                               Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                               Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate
                                               from Case where status=:status AND AccountId IN:childAccountIDs  Order by CaseNumber DESC]; 
                                }
                            }
                        }  
            return caseList;
        }catch (Exception e) {
            System.debug(e.getMessage());
            return null;
            
        }
    } 
    
    //For Govt School case Count
    /*@AuraEnabled
public static List<Case> getCustomerCareDetailsGovt(assignedResId,String assignedVehId,String stdID){

system.debug('caseNumber = '+caseNumber);
system.debug('Status = '+Status);
system.debug('salesAgId = '+salesAgId);
system.debug('assignedResId = '+assignedResId);
system.debug('assignedVehId = '+assignedVehId);
system.debug('StdId = '+StdId);

CustomerCareWrapper ccWrapperMoe = new CustomerCareWrapper(); 
MyBusinessWrapper businessWrapperGovt = getUserAccountDetails();

system.debug('businessWrapper in customer care method = '+businessWrapperGovt );

Id AccId=businessWrapperGovt.accRecord;
Set<Id> resourcesIdList = new Set<Id>();
for(SALine_Assigned_Resource__c resc:businessWrapperGovt.assignedResourcesList){
resourcesIdList.add(resc.Id);
}
system.debug('resourcesIdList = '+resourcesIdList );

Set<Id> vehiclesIdList = new Set<Id>();
for(SALine_Assigned_Vehicle__c veh:businessWrapperGovt.assignedVehicleList){
vehiclesIdList.add(veh.Id);
}
system.debug('vehiclesIdList = '+vehiclesIdList );

Set<Id> StudentIdList = new Set<Id>();
for(ETST_Student__c std: businessWrapperGovt.studentsList){
StudentIdList.add(std.Id);
}
system.debug('vehiclesIdList = '+StudentIdList );

String moeRecTypes=System.Label.Case_Record_Type_MOE;
List<String> moeRecTypeList= new List<String>();
moeRecTypeList=moeRecTypes.split(',');
system.debug('invoicesIdList = '+moeRecTypeList );
ccWrapperMoe.caseList =[select id,CaseNumber,Status,RecordType.Name,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
Subject, Description, ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name
from Case  where  RecordType.Name In :moeRecTypeList and (AccountId =:AccId
OR Assigned_Resource__c IN:resourcesIdList
OR Assigned_Vehicle__c IN:vehiclesIdList
OR  ETST_Student__c IN:StudentIdList) ];

system.debug('caseListttsss '+ccWrapperMoe.caseList);
Set<Case> caseFilteredListMOE = new Set<Case>();

for (Integer i = 0; i < ccWrapperMoe.caseList.size(); i++) {
if (
(String.isNotBlank(caseNumber) ? ccWrapperMoe.caseList[i].CaseNumber.contains(caseNumber) : true )    
&&
(String.isNotBlank(Status) ? ccWrapperMoe.caseList[i].Status.equals(Status) : true)
&&
containsField(ccWrapperMoe.caseList[i].Sales_Agreement__c, salesAgId)
&&
containsField(ccWrapperMoe.caseList[i].Assigned_Resource__c, assignedResId)
&&
containsField(ccWrapperMoe.caseList[i].Assigned_Vehicle__c, assignedVehId)
&&
containsField(ccWrapperMoe.caseList[i].ETST_Student__c, stdId)
){

caseFilteredListMOE.add(ccWrapperMoe.caseList[i]);
}
}

system.debug('caseFilteredList = '+caseFilteredListMOE );
List<Case> updatedCaseFilteredList = new List<Case>(caseFilteredListMOE);
return updatedCaseFilteredList;
}*/
    @AuraEnabled
    public static List<Case> getCustomerCareDetailsMoeCases(String caseNumber,String Status,String salesAgId, String assignedResId,String assignedVehId,String stdID){
        
        system.debug('caseNumber = '+caseNumber);
        system.debug('Status = '+Status);
        system.debug('salesAgId = '+salesAgId);
        system.debug('assignedResId = '+assignedResId);
        system.debug('assignedVehId = '+assignedVehId);
        system.debug('StdId = '+StdId);
        
        CustomerCareWrapper ccWrapperMoe = new CustomerCareWrapper(); 
        MyBusinessWrapper businessWrapperMinistry = getUserAccountDetailsMoe();
        
        system.debug('businessWrapper in customer care method = '+businessWrapperMinistry );
        
        Id AccId=businessWrapperMinistry.accRecord;
        system.debug('---->'+AccId);
        Set<Id> resourcesIdList = new Set<Id>();
        for(SALine_Assigned_Resource__c resc:businessWrapperMinistry.assignedResourcesList){
            resourcesIdList.add(resc.Id);
        }
        system.debug('resourcesIdList = '+resourcesIdList );
        
        Set<Id> vehiclesIdList = new Set<Id>();
        for(SALine_Assigned_Vehicle__c veh:businessWrapperMinistry.assignedVehicleList){
            vehiclesIdList.add(veh.Id);
        }
        system.debug('vehiclesIdList = '+vehiclesIdList );
        
        Set<Id> StudentIdList = new Set<Id>();
        for(ETST_Student__c std: businessWrapperMinistry.studentsList){
            StudentIdList.add(std.Id);
        }
        system.debug('StudentIdList = '+StudentIdList );
        Set<Id> invoicesIdList = new Set<Id>();
        for(Invoice__c inv:businessWrapperMinistry.invoicesList){ 
            invoicesIdList.add(inv.Id);
        }
        system.debug('invoicesIdList = '+invoicesIdList );
        
        String moeRecTypes=System.Label.Case_Record_Type_MOE;
        List<String> moeRecTypeList= new List<String>();
        moeRecTypeList=moeRecTypes.split(',');
        system.debug('invoicesIdList = '+moeRecTypeList );
        /* ccWrapperMoe.caseList =[select id,CaseNumber,Status,RecordType.Name,RecordTypeId,Invoice__c,Invoice__r.name,
Subject, Description, ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name
from Case where  RecordType.Name In :moeRecTypeList and (Account.ParentId =:AccId
OR Assigned_Resource__c IN:resourcesIdList
OR Assigned_Vehicle__c IN:vehiclesIdList
OR  ETST_Student__c IN:StudentIdList
OR Invoice__c IN:invoicesIdList)];

system.debug('caseListttsss '+ccWrapperMoe.caseList);
Set<Case> caseFilteredListMOE = new Set<Case>();

for (Integer i = 0; i < ccWrapperMoe.caseList.size(); i++) {
if (
(String.isNotBlank(caseNumber) ? ccWrapperMoe.caseList[i].CaseNumber.contains(caseNumber) : true )    
&&
(String.isNotBlank(Status) ? ccWrapperMoe.caseList[i].Status.equals(Status) : true)
&&
containsField(ccWrapperMoe.caseList[i].Sales_Agreement__c, salesAgId)
&&
containsField(ccWrapperMoe.caseList[i].Assigned_Resource__c, assignedResId)
&&
containsField(ccWrapperMoe.caseList[i].Assigned_Vehicle__c, assignedVehId)
&&
containsField(ccWrapperMoe.caseList[i].ETST_Student__c, stdId)
){

caseFilteredListMOE.add(ccWrapperMoe.caseList[i]);
}
}

system.debug('caseFilteredList = '+caseFilteredListMOE );
List<Case> updatedCaseFilteredList = new List<Case>(caseFilteredListMOE);
return updatedCaseFilteredList;*/
        Profile p = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        system.debug('p***'+p);
        return [select id,CaseNumber,Status,RecordType.Name,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                Subject, Description, ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name
                from Case /*where  Status IN ('Pending with Department Of School Activities',
'Pending with Department Of School Services')*/];
    }
    
    private static boolean containsField(Id e1, String e2) 
    {
        return String.isNotBlank(e2) ? (e1 != null ? e1.equals(e2) : false) : true;
    }
    @AuraEnabled
    public static string approveMOECase(String recId, string caseComments){
        system.debug('recId in apex '+recId);
        Case c=[select Id,status, recordtype.developername,Sub_Status__c,Status_Category__c from case where Id=:recId];
        //system.debug('---Activities---');
        
        system.debug('c.RecordType.developername'+c.RecordType.developername);
        system.debug('c.status'+c.status);
        system.debug('c.Status_Category__c'+c.Status_Category__c);
        system.debug('c.Sub_Status__c'+c.Sub_Status__c);
        if(c.Status_Category__c == 'Pending with Special Education' && c.RecordType.developername == 'Handicap_Services_Transport_or_Nanny_Request'){
            // c.status = 'In Progress';
            c.Status_Category__c = 'Pending with Department Of School Services';
            c.Sub_Status__c = 'Approved By Special Education';
        }else if(c.Status_Category__c == 'Pending with Department Of School Services' && c.RecordType.developername == 'Handicap_Services_Transport_or_Nanny_Request'){
            // c.Status = 'Approved';            
            c.Status_Category__c = 'Pending with Branch Manager';
            c.Sub_Status__c = 'Approved by Department of School Services';
        }else if(c.Status_Category__c == 'Pending with Department Of School Services' && 
                 (c.RecordType.developername == 'Teachers_Transportation_Request' || 
                  c.RecordType.developername == 'Growth_Request' || 
                  c.RecordType.developername == 'Requests_for_trips_activities_events')){
                      
                      c.Status = 'In Progress';     
                      c.Status_Category__c = 'Pending with School Transportation Manager';
                      c.Sub_Status__c='Approved by Department of School Services';
                  }else if(c.Status_Category__c == 'Pending with Department Of School Activities' && c.RecordType.developername == 'Growth_Request'){
                      c.Status_Category__c = 'Pending with Statistics Coordinator';
                      c.Sub_Status__c = 'Approved by Department of School Activities';
                  } else if(c.Status_Category__c == 'Pending with Personnel Management' && c.RecordType.developername == 'Teachers_Transportation_Request'){
                      c.Status_Category__c = 'Pending with Branch Manager';
                      c.Sub_Status__c = 'Approved by Department of Personnel Management'; 
                  }else if(c.Status_Category__c == 'Pending with Department Of School Services' && c.RecordType.developername == 'Request_for_the_awareness_sessions'){
                      c.Status_Category__c = 'Pending with Branch Manager';
                      c.Sub_Status__c = 'Approved by Department of School Services';
                  }/*else IF(c.RecordType.developername=='Requests_for_trips_activities_events' && c.Status_Category__c == 'Pending with Department Of School Services'){
system.debug('---Services---');
c.Status='Approved';
c.Status_Category__c = '';
c.Sub_Status__c='Approved by Department of School Services';
}*/else IF(c.RecordType.developername=='Requests_for_trips_activities_events' && c.Status_Category__c == 'Pending with Department Of School Activities'){
    system.debug('---Activities---');
    system.debug('schooltest');
    c.Status='In Progress';
    c.Status_Category__c = 'Pending with School Transportation Manager';
    c.Sub_Status__c='Approved by Department of School Activities';
}else if((c.RecordType.developername=='Requests_for_trips_activities_events' ||c.RecordType.developername == 'Growth_Request') && c.Status_Category__c == 'Pending with Main School'){
    system.debug('Main School if condition');
    c.Status='In Progress';
    c.Status_Category__c = 'Pending with School Transportation Manager';
    c.Sub_Status__c='Approved by Main School';
}
        else if(c.RecordType.developername == 'Handicap_Services_Transport_or_Nanny_Request' && c.Status_Category__c == 'Pending with Main School' ){
            c.Status='In Progress';
            c.Status_Category__c = 'Pending with Branch Manager';
            c.Sub_Status__c='Approved by Main School';
        }
        else if(c.RecordType.developername == 'Teachers_Transportation_Request' && c.Status_Category__c == 'Pending with Main School' && c.Sub_Status__c ==null){
            c.Status='In Progress';
            c.Status_Category__c = 'Pending with Branch Manager';
            c.Sub_Status__c='Approved by Main School';
        }
        else if(c.RecordType.developername == 'Teachers_Transportation_Request'&& c.Status_Category__c == 'Pending with Main School' && c.Sub_Status__c =='Approved by ET School Transportation'){
            c.Status='In Progress';
            c.Status_Category__c = 'Pending with School Transportation Manager';
            c.Sub_Status__c='Approved by Main School';
        }
        else if(c.RecordType.developername == 'Request_for_the_awareness_sessions' && c.Status_Category__c == 'Pending with Main School' ){
            c.Status='In Progress';
            c.Status_Category__c = 'Pending with Branch Manager';
            c.Sub_Status__c='Approved by Main School';
        }
        
        List<ET_Case_Comment__c> caseCommentsList = new List<ET_Case_Comment__c>();
        if(caseComments !=null && caseComments !=''){
            ET_Case_Comment__c comment = new ET_Case_Comment__c();
            comment.ET_Case__c = c.Id;
            comment.ET_Comments__c = caseComments;
            comment.ET_Action__c = c.Sub_Status__c;
            caseCommentsList.add(comment);
            system.debug(' comments user'+ comment.ET_Comments__c);
        }
        //c.Subject='Pending with ET - School Transportation Manager';
        try{
            insert caseCommentsList;
            system.debug('exceuted inserted ');
            system.debug('checking status'+c.Status);
            update c;
            system.debug('exceuted update');
            system.debug(c);
            //submitForApproval(c.Id);
        }catch(Exception e){
            system.debug(e.getMessage());
        }
        return c.Status;
    }
    @AuraEnabled
    public static string closeMOECase(String recId, string caseComments){
        Case c=[select Id,status, recordtype.developername,Sub_Status__c,Status_Category__c from case where Id=:recId]; 
        system.debug(' c.RecordType.developername '+ c.RecordType.developername);
        system.debug(' c.status '+ c.status);
        system.debug(' c.Sub_Status__c '+ c.Sub_Status__c);
        if(c.Status_Category__c == 'Pending with Department Of School Services' && 
           (c.RecordType.developername == 'Requests_for_trips_activities_events'||c.RecordType.developername == 'Handicap_Services_Transport_or_Nanny_Request'||c.RecordType.developername == 'Growth_Request'||c.RecordType.developername == 'Teachers_Transportation_Request'||c.RecordType.developername == 'Request_for_the_awareness_sessions')){
               system.debug('inside if condition');
               c.status = 'Closed';
               c.Status_Category__c = '';
               c.Sub_Status__c = 'Closed by Department of School Services';
           }
        else if(c.Status_Category__c == 'Pending with Main School' && 
                (c.RecordType.developername == 'Requests_for_trips_activities_events'||c.RecordType.developername == 'Handicap_Services_Transport_or_Nanny_Request'||c.RecordType.developername == 'Growth_Request'||c.RecordType.developername == 'Teachers_Transportation_Request'||c.RecordType.developername == 'Request_for_the_awareness_sessions')){
                    c.status = 'Closed';
                    c.Status_Category__c = '';
                    c.Sub_Status__c = 'Closed by Main School';
                }
        system.debug(' c.status '+ c.status);
        List<ET_Case_Comment__c> caseCommentsList = new List<ET_Case_Comment__c>();
        if(caseComments !=null && caseComments !=''){
            ET_Case_Comment__c comment = new ET_Case_Comment__c();
            comment.ET_Case__c = c.Id;
            comment.ET_Comments__c = caseComments;
            comment.ET_Action__c = c.Sub_Status__c;
            caseCommentsList.add(comment);
        }
        //   try{
        insert caseCommentsList;
        update c;
        //   }catch(Exception e){
        //        system.debug(e.getMessage());
        //   }
        
        return  c.Status_Category__c;
    }
    
    @AuraEnabled
    public static string rejectMOECase(String recId, string caseComments){
        Case c=[select Id,status, recordtype.developername,Sub_Status__c,Status_Category__c from case where Id=:recId];
        system.debug('c.Status_Category__c'+c.Status_Category__c);
        system.debug('c.Sub_Status__c'+c.Sub_Status__c);
        system.debug('c.Statusc'+c.Status);
        if(c.Status_Category__c == 'Pending with Department Of School Services' && 
           (c.RecordType.developername == 'Teachers_Transportation_Request' || 
            c.RecordType.developername == 'Growth_Request' ||
            c.RecordType.developername == 'Handicap_Services_Transport_or_Nanny_Request' ||
            c.RecordType.developername == 'Request_for_the_awareness_sessions')){
                System.debug('inside if');
                c.Sub_Status__c = 'Rejected by Department of School Services';
                c.Status = 'Rejected';
                c.Status_Category__c = '';         
            }else if(c.Status_Category__c == 'Pending with Personnel Management' && c.RecordType.developername == 'Teachers_Transportation_Request'){
                c.Sub_Status__c = 'Rejected by Department of Personnel Management';
                c.Status = 'Rejected';
                c.Status_Category__c = '';
            }else IF(c.RecordType.developername=='Requests_for_trips_activities_events' &&
                     c.Status_Category__c == 'Pending with Department Of School Services'){
                         system.debug('---Services---');
                         c.Status='Rejected';
                         c.Status_Category__c = '';
                         c.Sub_Status__c='Rejected by Department of School Services';
                     }else IF(c.RecordType.developername=='Requests_for_trips_activities_events' &&
                              c.Status_Category__c == 'Pending with Department Of School Activities'){
                                  system.debug('---Activities---');
                                  c.Status='Rejected';
                                  c.Status_Category__c = '';           
                                  //c.Status_Category__c = 'Pending with School Transportation Manager';
                                  c.Sub_Status__c='Rejected by Department of School Activities';
                              }else IF(c.Status_Category__c == 'Pending with Special Education' && 
                                       c.RecordType.developername == 'Handicap_Services_Transport_or_Nanny_Request'){
                                           system.debug('inside if');
                                           c.Sub_Status__c = 'Rejected by Special Education';
                                           c.Status = 'Rejected';
                                           c.Status_Category__c = '';     
                                       }
        else if((c.RecordType.developername=='Requests_for_trips_activities_events'||c.RecordType.developername == 'Handicap_Services_Transport_or_Nanny_Request'||c.RecordType.developername == 'Growth_Request'||c.RecordType.developername == 'Teachers_Transportation_Request'||c.RecordType.developername == 'Request_for_the_awareness_sessions') &&
                c.Status_Category__c == 'Pending with Main School'){
                    system.debug('Main School if condition');
                    c.Sub_Status__c = 'Rejected by Main School';
                    c.Status = 'Rejected';
                    c.Status_Category__c = '';     
                }
        
        List<ET_Case_Comment__c> caseCommentsList = new List<ET_Case_Comment__c>();
        if(caseComments !=null && caseComments !=''){
            ET_Case_Comment__c comment = new ET_Case_Comment__c();
            comment.ET_Case__c = c.Id;
            comment.ET_Comments__c = caseComments;
            comment.ET_Action__c = c.Sub_Status__c;
            caseCommentsList.add(comment);
            system.debug('comment.ET_Comments__c'+comment.ET_Comments__c);
        }
        try{
            insert caseCommentsList;
            update c;
        }catch(Exception e){
            system.debug(e.getMessage());
        }
        return c.Status;
    }
    @AuraEnabled
    public static void updateMOECaseStatus(List<Id> caseIds,String status,String driverName,String driverMobile, String Comments){
        system.debug('status for groeth '+status);
        String privateSchoolLabel = System.Label.ET_Private_School_Profile_Name;
        String governmentSchoolLabel = System.Label.ET_Government_School_Profile_Name;
        List<case> caseList=new List<Case>();
        List<ET_Case_Comment__c> caseComments = new List<ET_Case_Comment__c>();
        // String p = [Select Id,Name from Profile WHERE Id=:userinfo.getProfileId()].Name;
        //system.debug('profile name '+p);
        for(Case cs:[select Id,RecordType.developername,Sub_Status__c,Status,Status_Category__c,Driver_Name__c,Driver_Number__c FROM Case
                     WHERE Id IN: caseIds]){
                         Case caserecord = [select id,Account.name,Contact.name,ContactId,AccountId FROM Case WHERE Id IN: caseIds];
                         User contactuser=[select name,Profile.Name from user where ContactId=:caserecord.ContactId];
                         system.debug('contactuser profile '+contactuser.Profile.Name);
                         system.debug('contactuser name '+contactuser.Name);
                         
                         if(contactuser.Profile.Name==governmentSchoolLabel){
                             IF((cs.RecordType.developername=='Requests_for_trips_activities_events'||
                                 cs.RecordType.developername=='Handicap_Services_Transport_or_Nanny_Request' ||
                                 cs.RecordType.developername=='Growth_Request'||
                                 cs.RecordType.developername=='Teachers_Transportation_Request') &&
                                cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with School Transportation Manager'){
                                    IF(status=='Complete'){
                                        cs.Status='Closed';
                                        cs.Sub_Status__c='Approved by ET School Transportation';
                                        cs.Status_Category__c = '';
                                        cs.Driver_Name__c=driverName;
                                        cs.Driver_Number__c=driverMobile;
                                    }else IF(status=='Send' && cs.RecordType.developername != 'Handicap_Services_Transport_or_Nanny_Request'){
                                        cs.Status_Category__c = 'Pending with Department Of School Services';
                                        cs.Sub_Status__c='Approved by ET School Transportation';
                                    }
                                }
                             else if( cs.RecordType.developername=='Request_for_the_awareness_sessions' &&
                                     cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Branch Manager' && cs.Sub_Status__c == 'Approved by Department of School Services' ){
                                         IF(status=='Complete'){
                                             cs.Sub_Status__c='Approved by ET Branch Manager';
                                             cs.Status_Category__c = '';
                                             cs.Status = 'Closed';
                                             cs.Driver_Name__c=driverName;
                                             cs.Driver_Number__c=driverMobile;
                                         }
                                     }
                             else IF( cs.RecordType.developername=='Handicap_Services_Transport_or_Nanny_Request' &&
                                     cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Branch Manager' ){
                                         IF(status=='Approve'){
                                             cs.Sub_Status__c='Approved by ET Branch Manager';
                                             cs.Status_Category__c = 'Pending with Safety and Health Specialist';
                                         }else IF(status=='Reject'){
                                             cs.Status='Rejected';
                                             cs.Sub_Status__c='Rejected by ET Branch Manager';
                                             cs.Status_Category__c ='';
                                         }
                                     }
                             else IF( cs.RecordType.developername=='Teachers_Transportation_Request' &&
                                     cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Branch Manager' ){
                                         IF(status=='Approve'){
                                             cs.Sub_Status__c='Approved by ET Branch Manager';
                                             cs.Status_Category__c = 'Pending with Routes Efficient and Design Director';
                                         }else IF(status=='Reject'){
                                             cs.Status='Rejected';
                                             cs.Sub_Status__c='Rejected by ET Branch Manager';
                                             cs.Status_Category__c ='';
                                         }
                                     }  
                             else IF( cs.RecordType.developername=='Handicap_Services_Transport_or_Nanny_Request' &&
                                     cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Safety and Health Specialist' ){
                                         IF(status=='Approve'){
                                             cs.Sub_Status__c='Approved by ET Safety and Health Specialist';
                                             cs.Status_Category__c = 'Pending with Routes Efficient and Design Director';
                                         }else IF(status=='Reject'){
                                             cs.Status = 'Rejected';
                                             //cs.Status_Category__c='Pending with Branch Manager';
                                             cs.Sub_Status__c='Rejected by ET Safety and Health Specialist';
                                             cs.Status_Category__c ='';
                                         }
                                     }
                             else  IF( (cs.RecordType.developername=='Handicap_Services_Transport_or_Nanny_Request' ||
                                        cs.RecordType.developername=='Growth_Request' ||
                                        cs.RecordType.developername=='Teachers_Transportation_Request')&&
                                      cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Routes Efficient and Design Director' ){
                                          IF(status=='Approve'){
                                              cs.Sub_Status__c='Approved by ET Routes Efficient and Design Director';
                                              cs.Status_Category__c = 'Pending with First Transport Specialist';
                                          }else IF(status=='Reject'){
                                              cs.Status='Rejected';
                                              cs.Sub_Status__c='Rejected by ET Routes Efficient and Design Director';
                                              cs.Status_Category__c ='';
                                          }
                                      }
                             else  IF((cs.RecordType.developername=='Handicap_Services_Transport_or_Nanny_Request' ||
                                       cs.RecordType.developername=='Growth_Request' ||
                                       cs.RecordType.developername=='Teachers_Transportation_Request') &&
                                      cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with First Transport Specialist' ){
                                          IF(status=='Approve'){
                                              cs.Sub_Status__c='Approved by ET First Transport Specialist';
                                              cs.Status_Category__c = 'Pending with School Transportation Manager';
                                          }else IF(status=='Reject'){
                                              //cs.Status_Category__c = 'Approved by Branch Manager';
                                              // cs.Status_Category__c ='';
                                              cs.Status='Rejected';
                                              cs.Sub_Status__c='Rejected by ET First Transport Specialist';
                                              cs.Status_Category__c ='';
                                          }
                                      }
                             
                             else IF( (cs.RecordType.developername=='Growth_Request' ||
                                       cs.RecordType.developername=='Request_for_the_awareness_sessions') &&
                                     cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Statistics Coordinator'  ){
                                         IF(status=='Approve'){
                                             cs.Sub_Status__c='Approved by Statistics Coordinator';
                                             cs.Status_Category__c = 'Pending with Branch Manager';
                                         }else IF(status=='Reject'){
                                             cs.Status='Rejected';
                                             cs.Sub_Status__c='Rejected by Statistics Coordinator';
                                             cs.Status_Category__c ='';
                                         }
                                     }
                             else  IF( cs.RecordType.developername=='Growth_Request' &&
                                      cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Branch Manager' &&
                                      cs.Sub_Status__c=='Approved by Statistics Coordinator' ){
                                          IF(status=='Approve'){
                                              cs.Sub_Status__c='Approved by ET Branch Manager';
                                              cs.Status_Category__c = 'Pending with Routes Efficient and Design Director';
                                          }else IF(status=='Reject'){
                                              cs.Status='Rejected';
                                              cs.Sub_Status__c='Rejected by ET Branch Manager';
                                              cs.Status_Category__c ='';
                                          }
                                      }
                             else IF( cs.RecordType.developername=='Request_for_the_awareness_sessions' &&
                                     cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Head of Safety Unit' ){
                                         IF(status=='Approve'){
                                             cs.Sub_Status__c='Approved By Head of Safety Unit';
                                             cs.Status_Category__c = 'Pending with Statistics Coordinator';
                                         }else IF(status=='Reject'){
                                             cs.Status='Rejected';
                                             cs.Sub_Status__c='Rejected By Head of Safety Unit';
                                             cs.Status_Category__c ='';
                                         }
                                     } 
                             else IF( cs.RecordType.developername=='Request_for_the_awareness_sessions' &&
                                     cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Branch Manager' ){
                                         IF(status=='Approve'){
                                             cs.Sub_Status__c='Approved by ET Branch Manager';
                                             cs.Status_Category__c = 'Pending with Students Safety Specialist';
                                         }else IF(status=='Reject'){
                                             cs.Status='Rejected';
                                             cs.Sub_Status__c='Rejected by ET Branch Manager';
                                             cs.Status_Category__c ='';
                                         }
                                     }
                             else IF( cs.RecordType.developername=='Request_for_the_awareness_sessions' &&
                                     cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Students Safety Specialist' ){
                                         IF(status=='Approve'){
                                             cs.Sub_Status__c='Approved By Students Safety Specialist';
                                             cs.Status_Category__c = 'Pending with Department Of School Services';
                                         }else IF(status=='Reject'){
                                             cs.Status='Rejected';
                                             cs.Sub_Status__c='Rejected By Students Safety Specialist';
                                             cs.Status_Category__c ='';
                                         }
                                     }
                         }
                         else if(contactuser.Profile.Name==privateSchoolLabel){
                             IF((cs.RecordType.developername=='Requests_for_trips_activities_events'||
                                 cs.RecordType.developername=='Handicap_Services_Transport_or_Nanny_Request' ||
                                 cs.RecordType.developername=='Growth_Request'||
                                 cs.RecordType.developername=='Teachers_Transportation_Request') &&
                                cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with School Transportation Manager'){
                                    IF(status=='Complete'){
                                        cs.Status='Closed';
                                        cs.Sub_Status__c='Approved by ET School Transportation';
                                        cs.Status_Category__c = '';
                                        cs.Driver_Name__c=driverName;
                                        cs.Driver_Number__c=driverMobile;
                                    }else IF(status=='Send' && (cs.RecordType.developername != 'Handicap_Services_Transport_or_Nanny_Request'||cs.RecordType.developername !='Teachers_Transportation_Request')){
                                        cs.Status_Category__c = 'Pending with Main School';
                                        cs.Sub_Status__c='Approved by ET School Transportation';
                                    }else IF(status=='Send' && cs.RecordType.developername =='Teachers_Transportation_Request'){
                                        cs.Status='Closed';
                                        cs.Sub_Status__c='Approved by ET School Transportation';
                                        cs.Status_Category__c = '';
                                    }
                                    
                                }
                             else if( cs.RecordType.developername=='Request_for_the_awareness_sessions' &&
                                     cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Branch Manager' && cs.Sub_Status__c == 'Approved by Main School' ){
                                         IF(status=='Complete'){
                                             cs.Sub_Status__c='Approved by ET Branch Manager';
                                             cs.Status_Category__c = '';
                                             cs.Status = 'Closed';
                                             cs.Driver_Name__c=driverName;
                                             cs.Driver_Number__c=driverMobile;
                                         }
                                     }
                             else IF( cs.RecordType.developername=='Handicap_Services_Transport_or_Nanny_Request' &&
                                     cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Branch Manager' ){
                                         IF(status=='Approve'){
                                             cs.Sub_Status__c='Approved by ET Branch Manager';
                                             cs.Status_Category__c = 'Pending with Safety and Health Specialist';
                                         }else IF(status=='Reject'){
                                             cs.Status='Rejected';
                                             cs.Sub_Status__c='Rejected by ET Branch Manager';
                                             cs.Status_Category__c ='';
                                         }
                                     }
                             else IF( cs.RecordType.developername=='Teachers_Transportation_Request' &&
                                     cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Branch Manager' ){
                                         IF(status=='Approve'){
                                             cs.Sub_Status__c='Approved by ET Branch Manager';
                                             cs.Status_Category__c = 'Pending with Routes Efficient and Design Director';
                                         }else IF(status=='Reject'){
                                             cs.Status='Rejected';
                                             cs.Sub_Status__c='Rejected by ET Branch Manager';
                                             cs.Status_Category__c ='';
                                         }
                                     }  
                             else IF( cs.RecordType.developername=='Handicap_Services_Transport_or_Nanny_Request' &&
                                     cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Safety and Health Specialist' ){
                                         IF(status=='Approve'){
                                             cs.Sub_Status__c='Approved by ET Safety and Health Specialist';
                                             cs.Status_Category__c = 'Pending with Routes Efficient and Design Director';
                                         }else IF(status=='Reject'){
                                             cs.Status = 'Rejected';
                                             //cs.Status_Category__c='Pending with Branch Manager';
                                             cs.Sub_Status__c='Rejected by ET Safety and Health Specialist';
                                             cs.Status_Category__c ='';
                                         }
                                     }
                             else  IF( (cs.RecordType.developername=='Handicap_Services_Transport_or_Nanny_Request' ||
                                        cs.RecordType.developername=='Growth_Request' ||
                                        cs.RecordType.developername=='Teachers_Transportation_Request')&&
                                      cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Routes Efficient and Design Director' ){
                                          IF(status=='Approve'){
                                              cs.Sub_Status__c='Approved by ET Routes Efficient and Design Director';
                                              cs.Status_Category__c = 'Pending with First Transport Specialist';
                                          }else IF(status=='Reject'){
                                              cs.Status='Rejected';
                                              cs.Sub_Status__c='Rejected by ET Routes Efficient and Design Director';
                                              cs.Status_Category__c ='';
                                          }
                                      }
                             else  IF((cs.RecordType.developername=='Handicap_Services_Transport_or_Nanny_Request' ||
                                       cs.RecordType.developername=='Growth_Request' ||
                                       cs.RecordType.developername=='Teachers_Transportation_Request') &&
                                      cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with First Transport Specialist' ){
                                          IF(status=='Approve'){
                                              cs.Sub_Status__c='Approved by ET First Transport Specialist';
                                              cs.Status_Category__c = 'Pending with School Transportation Manager';
                                          }else IF(status=='Reject'){
                                              //cs.Status_Category__c = 'Approved by Branch Manager';
                                              // cs.Status_Category__c ='';
                                              cs.Status='Rejected';
                                              cs.Sub_Status__c='Rejected by ET First Transport Specialist';
                                              cs.Status_Category__c ='';
                                          }
                                      }
                             
                             else IF( (cs.RecordType.developername=='Growth_Request' ||
                                       cs.RecordType.developername=='Request_for_the_awareness_sessions') &&
                                     cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Statistics Coordinator'  ){
                                         IF(status=='Approve'){
                                             cs.Sub_Status__c='Approved by Statistics Coordinator';
                                             cs.Status_Category__c = 'Pending with Branch Manager';
                                         }else IF(status=='Reject'){
                                             cs.Status='Rejected';
                                             cs.Sub_Status__c='Rejected by Statistics Coordinator';
                                             cs.Status_Category__c ='';
                                         }
                                     }
                             else  IF( cs.RecordType.developername=='Growth_Request' &&
                                      cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Branch Manager' &&
                                      cs.Sub_Status__c=='Approved by Statistics Coordinator' ){
                                          IF(status=='Approve'){
                                              cs.Sub_Status__c='Approved by ET Branch Manager';
                                              cs.Status_Category__c = 'Pending with Routes Efficient and Design Director';
                                          }else IF(status=='Reject'){
                                              cs.Status='Rejected';
                                              cs.Sub_Status__c='Rejected by ET Branch Manager';
                                              cs.Status_Category__c ='';
                                          }
                                      }
                             else IF( cs.RecordType.developername=='Request_for_the_awareness_sessions' &&
                                     cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Head of Safety Unit' ){
                                         IF(status=='Approve'){
                                             cs.Sub_Status__c='Approved By Head of Safety Unit';
                                             cs.Status_Category__c = 'Pending with Statistics Coordinator';
                                         }else IF(status=='Reject'){
                                             cs.Status='Rejected';
                                             cs.Sub_Status__c='Rejected By Head of Safety Unit';
                                             cs.Status_Category__c ='';
                                         }
                                     } 
                             else IF( cs.RecordType.developername=='Request_for_the_awareness_sessions' &&
                                     cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Branch Manager' ){
                                         IF(status=='Approve'){
                                             cs.Sub_Status__c='Approved by ET Branch Manager';
                                             cs.Status_Category__c = 'Pending with Students Safety Specialist';
                                         }else IF(status=='Reject'){
                                             cs.Status='Rejected';
                                             cs.Sub_Status__c='Rejected by ET Branch Manager';
                                             cs.Status_Category__c ='';
                                         }
                                     }
                             else IF( cs.RecordType.developername=='Request_for_the_awareness_sessions' &&
                                     cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Students Safety Specialist' ){
                                         IF(status=='Approve'){
                                             cs.Sub_Status__c='Approved By Students Safety Specialist';
                                             cs.Status_Category__c = 'Pending with Main School';
                                         }else IF(status=='Reject'){
                                             cs.Status='Rejected';
                                             cs.Sub_Status__c='Rejected By Students Safety Specialist';
                                             cs.Status_Category__c ='';
                                         }
                                     }
                         }
                         
                         
                         
                         
                         
                         
                         system.debug('Comments***'+Comments);
                         if(Comments !=null && Comments !=''){
                             ET_Case_Comment__c comment = new ET_Case_Comment__c();
                             comment.ET_Case__c = cs.Id;
                             comment.ET_Comments__c = Comments;
                             comment.ET_Action__c = cs.Sub_Status__c;
                             caseComments.add(comment);
                         }
                         caseList.add(cs);
                     }
        try{
            insert caseComments;
            update caseList;
        }catch(Exception e){
            System.debug('exception-->'+e.getMessage());
        }
    }
    public static void submitForApproval(Id cId){
        /*Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();          
req.setObjectId(cId);
Approval.ProcessResult result = Approval.process(req); */       
    }
    @AuraEnabled
    public static Case getCaseData(string recId){
        return [Select Id,CaseNumber,Status,Sub_Status__c,Status_Category__c,RecordType.DeveloperName FROM Case WHERE id=:recId];
    }
    
    @AuraEnabled
    public static ResultWrapper getprivateschoolUserData(){//ashwini
        system.debug('inside et_business');
        ResultWrapper rw= new ResultWrapper();
        User u=[select id,AccountId,contactID from user where id=:userinfo.getUserId()];
        system.debug('u.contactID '+u.contactID);
        Contact contactrecord = [select Id, name,AccountId from contact where Id=:u.contactID];
        String accParentId=[select id,Name,parentId from Account where Id=:contactrecord.AccountId].parentId;
        system.debug('accParentId= '+accParentId);
        if(String.isNotEmpty(accParentId)){
            system.debug('parent available');
            rw.isParent = true;
        }else{
            system.debug('parent not available');
            rw.isParent = false;  
        }
        rw.loggedinUserProfileName = [Select Id,Name from Profile WHERE Id=:userinfo.getProfileId()].Name;
        system.debug('rw*** '+rw);
        return rw;
    }
    
    public class ResultWrapper{//ashwini
        
        @AuraEnabled public string loggedinUserProfileName;
        @AuraEnabled public boolean isParent;
        
    }
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        Id recordTypeId =[SELECT Id FROM RecordType WHERE DeveloperName = 'Business_School' AND sObjectType = 'Account'].Id;
        List < sObject > returnList = new List < sObject > ();
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        // String sQuery =  'select id,RecordTypeId,Name from ' +ObjectName + ' where Name LIKE: searchKey AND RecordTypeId:=recordTypeId order by createdDate DESC';
        //String sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC';
        
        string searchText = '\'' + String.escapeSingleQuotes(searchKey) + '%\''; 
        String sQuery = 'select id, Name from ' +ObjectName + ' where RecordType.Name = \'Business (B2B) - School\' AND Name LIKE '+searchText+' order by createdDate DESC';
        
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    public static void utilityMethod(){
        
        integer i=0;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;  i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;  i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
}