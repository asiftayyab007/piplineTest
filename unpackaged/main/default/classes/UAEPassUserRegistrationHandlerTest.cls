@isTest
public class UAEPassUserRegistrationHandlerTest {
    static testmethod void EpgUaetest(){
        
         UAEPassUserRegistrationHandler handler = new UAEPassUserRegistrationHandler();
        Auth.UserData sampleData = new Auth.UserData('testId', 'testFirst', 'testLast',
                                                     'testFirst testLast', 'testuse8888r@example.org', null, 'testuserlong', 'en_US', 'facebook',
                                                     null, new Map<String, String>{'language' => 'en_US'});
        try{
            User u = handler.createUser(null, sampleData);
            sampleData = new Auth.UserData('testNewId', 'testNewFirst', 'testNewLast',
                                           'testNewFirst testNewLast', 'testnewuser@example.org', null, 'testnewuserlong', 'en_US', 'facebook',
                                           null, new Map<String, String>{});
            handler.updateUser(null, null, sampleData);
        }
         catch(Exception e){
            
        }
    }

}