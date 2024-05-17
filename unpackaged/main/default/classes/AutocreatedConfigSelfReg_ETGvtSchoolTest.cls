@isTest(seeAllData=true)
public class AutocreatedConfigSelfReg_ETGvtSchoolTest {
    
    private static testmethod void testselfRegister(){
        
       AutocreatedDiscLoginHandler1661621198861 csd = new AutocreatedDiscLoginHandler1661621198861();
        map<string,string> mp = new map<string,string>();
                  
        csd.login('nidhin.sasidharan@smaartt.com','/testone/s',new Map<String, String>());
        
       
        //SelfRegistrationCls
        AutocreatedConfigSelfReg_ETGvtSchool selfRef = new AutocreatedConfigSelfReg_ETGvtSchool();
        
        Map<SObjectField, String> Regfields = new Map<SObjectField, String>();
        
        Schema.DescribeFieldResult fn = user.firstname.getDescribe();
        Schema.sObjectField fname = fn.getSObjectField();
        
        Schema.DescribeFieldResult ln = user.lastname.getDescribe();
        Schema.sObjectField lname = ln.getSObjectField();
        
        Schema.DescribeFieldResult em = user.email.getDescribe();
        Schema.sObjectField uemail = em.getSObjectField();
        test.startTest();
        
        Account acc  = new Account();
        acc.lastName ='Janaa';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        insert acc;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'ETS Community Login' LIMIT 1];
            
        Regfields.put(fname,'Jana');
        Regfields.put(lname,'Muddana');
        Regfields.put(uemail,'jana.mud@at.com');
       
        selfRef.createUser(acc.Id,profileId.Id, Regfields, '');
        test.stopTest();       
        
    }

}