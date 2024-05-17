/*******************************************************************************************************************
Class       : UAEPassUserRegistrationHandler
Author      : Janardhan Muddana
Description : registration and linking handler for UAE PASS SSO 
TestClass  :  UAEPassUserRegistrationHandlerTest
----------------------------------------------------------------------------------------------------------------
            -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date                Details
1.           V1.0_SH          Sep 15th, 2022    Initial Version
*******************************************************************************************************************/

global class UAEPassUserRegistrationHandler implements Auth.RegistrationHandler, Auth.ConfirmUserRegistrationHandler {
    
    global User createUser(Id portalId, Auth.UserData data){
       
        return getUser(data);
    }
    
    
    public User getUser(Auth.UserData data){
        
            
        if(String.isNotBlank(data.identifier)) {
            List<User> confirmedUser = [SELECT Id, email, MobilePhone, isActive FROM user WHERE FederationIdentifier=:data.identifier ];
            
            if(confirmedUser!=null && confirmedUser.size()>0) {

                // return null if user is inactive or email is different
                if(!confirmedUser[0].isActive || confirmedUser[0].email!=data.email){
                    return null;
                }
                
                return confirmedUser[0];
            }
        }
        
        Boolean isSandbox = [SELECT Id, IsSandbox FROM Organization].isSandbox;
        
        if(!isSandbox){
            return null;
        }
        // register new portal user only if new user, i.e. only if uuid is not present in the system 
        Account acc = New Account();
       
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        acc.LastName = data.lastName;
        acc.FirstName = data.firstName;
        acc.PersonEmail = data.email;        
        
        Insert acc;
        
        /*Contact con = new Contact(AccountID=acc.Id, FirstName=data.firstName, LastName=data.lastName, Email=data.email);
        insert con;*/
         
        String random       = string.valueOf(math.random()).substring(0,4);
        Profile portalProfile   = [SELECT Id FROM Profile WHERE Name='ETS Community Login' Limit 1];
        Account acc2=[Select Id, PersonContactId from Account where Id=: acc.Id];
        User u           = new User();
        u.ProfileId       = portalProfile.Id;
        u.FirstName       = data.firstName; 
        u.LastName         = data.lastName; 
        u.Email         = data.email;
        u.ContactID       = acc2.PersonContactId; 
        u.TimeZoneSidKey     = 'Asia/Dubai';
        u.LocaleSidKey       = 'en_AE';
        u.LanguageLocaleKey   = 'en_US';
        u.CommunityNickname   = data.lastName+string.valueOf(math.random()).substring(0,6);
        u.EmailEncodingKey     = 'UTF-8';            
        u.FederationIdentifier  = data.identifier; 
        List<String> emailSplit = data.email.split('@');
        u.Alias         = emailSplit[0].substring(0,2) + Integer.valueof((Math.random() * 10000));
        u.Username         = emailSplit[0];
        u.Username         += (isSandbox ? '.'+Integer.valueof((Math.random() * 1000)) : '') + '@et.ae'; 
        
        if(data.attributeMap!=null && data.attributeMap.containsKey('mobile')){
            u.MobilePhone     = data.attributeMap.get('mobile');  
        }
        
        return u;
    }
    
    
    
    global void updateUser(Id userId, Id portalId, Auth.UserData data) {
        
        System.debug('<updateUser>:: userId' + userId + ' ===:: Data ===' + data);
        User u = new User(id=userId);
        /*u.username = data.username + '@salesforce.com';
        u.email = data.email;
    */

        u.firstName       = data.firstName;
        u.lastName         = data.lastName;
        u.alias         = data.username;
        u.FederationIdentifier   = data.identifier; 
        u.MobilePhone = data.attributeMap.get('mobile');
        
        if(u.alias.length() > 8) {
            u.alias       = u.alias.substring(0, 8);
        }
        
        update(u);
    }
    
    
    global Id confirmUser(Id userId, Id tpalId, Id portalId, Auth.UserData data) {
        
        System.debug('<confirmUser >:: userId' + userId + ' ===:: Data ===' + data);
        
        List<User> confirmedUser = [
            SELECT Id, Name, MobilePhone, Email 
            FROM user 
            WHERE isActive=true and (FederationIdentifier = :data.identifier OR id = :userId)
        ];  
        
        if(confirmedUser!=null && confirmedUser.size()>0) {
            
            String strUId = String.valueOf(userId); String strQueryUId = String.valueOf(confirmedUser[0].Id); 
            
            if(strUId.containsIgnoreCase(confirmedUser[0].Id) || strQueryUId.containsIgnoreCase(strUId)) { 
                return confirmedUser[0].Id;
            }
        }
         
        return null;
        /*if (data.email.contains(data.lastName)) { return userId;} else { return confirmedUser.Id; }*/
    }
}