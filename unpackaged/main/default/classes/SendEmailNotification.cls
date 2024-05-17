global class SendEmailNotification implements Schedulable {
    
        //Creating a schedule method SendEmailNotification      
     global void execute(SchedulableContext sc) {
    //Fetching list of users to whom email has to be sent            
   /*String userName = Label.Passing_User_From_Label;
     List<User> user = [SELECT Email FROM User WHERE Name = :userName];*/
          List<User> user =  [SELECT Email FROM User WHERE Id IN (
					  	  SELECT UserOrGroupId
					  	  FROM GroupMember
					  	  WHERE Group.Name = :'Send mail To Multiple Users'
					    )];
         
         //Creating a new instance of Messaging.SingleEmailMessage           
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         //mail.setTargetObjectId(Null);
         List<String> toAddresses = new List<String>();

     //Iterating over the list of users            
    for(User u: user) {                
    //Creating list of strings to store email addresses               
     //Adding the email address of the user to the list                
     toAddresses.add(u.Email);                 
        //Assign list of email addresses to the Messaging.SingleEmailMessage                
        
        }  
                 mail.setToAddresses(toAddresses);

         //Setting the subject of the email            
        mail.setSubject('Monthly Email Notification');
         //Setting the plain text body of the email            
         mail.setPlainTextBody('This is a monthly notification email.');
         //Setting the HTML body of the email            
         mail.setHtmlBody('<h1>This is a monthly notification email.</h1>');
         //Sending the email 
      /* EmailTemplate emailTemplate = [Select Id,name,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName='Send_Email'];
          mail.setTemplateID(emailTemplate.Id);
         mail.setTargetObjectId('0038E00001Q2BxRQAV');*/
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     }
    }
   
    
    //Creating a Schedulable job    
  /*  public class sendEmailNotificationJob(){
             //Creating a new instance of the schedulable class        
        SendEmailNotification scheduledNotification = new SendEmailNotification();
        //Creating a cron expression to run the job every month        
        String cronExpression = '0 25 5 24 * ? ';
        //Creating a cron job        
        System.schedule('Monthly Email Notification', cronExpression, scheduledNotification);    
       
    } */