global class SendEmail  {
    
    //Creating a Schedulable class    
   /* global class SendEmailNotification implements Schedulable {
    
        //Creating a schedule method SendEmailNotification      
     global void execute(SchedulableContext sc) {
    //Fetching list of users to whom email has to be sent            
    List<User> users = [SELECT Email FROM User WHERE Id = '0058E00000A7ZYqQAN'];
         
         //Creating a new instance of Messaging.SingleEmailMessage           
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
     //Iterating over the list of users            
    for(User u: users) {                
    //Creating list of strings to store email addresses               
     List<String> toAddresses = new List<String>();
     //Adding the email address of the user to the list                
     toAddresses.add(u.Email);                 
        //Assign list of email addresses to the Messaging.SingleEmailMessage                
        mail.setToAddresses(toAddresses);  
        }  
         
         //Setting the subject of the email            
         mail.setSubject('Monthly Email Notification');
         //Setting the plain text body of the email            
         mail.setPlainTextBody('This is a monthly notification email.');
         //Setting the HTML body of the email            
         mail.setHtmlBody('<h1>This is a monthly notification email.</h1>');
         
         //Sending the email            
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     }
    }
   
    
    //Creating a Schedulable job    
    /*public class sendEmailNotificationJob(){
        //Creating a new instance of the schedulable class        
        SendEmailNotification scheduledNotification = new SendEmailNotification();
        //Creating a cron expression to run the job every month        
        String cronExpression = '0 25 5 24 * ? ';
        //Creating a cron job        
        System.schedule('Monthly Email Notification', cronExpression, scheduledNotification);    
    }*/
}