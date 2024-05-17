/*
Class Name: SendCaseEmail
Description: Send Email to Account Email once case is closed and on case creation.
Created Date: 30/11/2022
Author: Sreelakshmi SK
*/

public class SendCaseEmail {
    
    /*
    Method Name: SendClosedCaseEmail
	Description: Send an email once case id closed
	*/
    public static void SendClosedCaseEmail(List<Case> trgNew,map<Id,Case> trgOldMap){
        // Get all cases that were closed 
	
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>(); 
        for(Case ca : [select id,casenumber,Account.PersonEmail from case where Id=:trgNew]){
            
            if(ca.status=='Closed' && trgOldMap.get(ca.Id).Status != ca.status){
                
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                String[] toAddresses = new String[] {ca.Account.PersonEmail};
                email.setToAddresses(toAddresses); 
                email.setSubject('Case ' + ca.CaseNumber + ' Closed'); 
                String body = 'Your case ' + ca.CaseNumber + ' has been closed. ' + 'Thanks for contacting us.'; 
                email.setPlainTextBody(body); 
                emails.add(email); 
                
            }
            
        }
	
    try{
        // Send the emails 
        Messaging.sendEmail(emails);
    }catch(Exception e) {
        system.debug(e.getMessage());
    }
    }
    
    
    

}