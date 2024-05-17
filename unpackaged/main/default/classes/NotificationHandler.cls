/**
 * @className         : NotificationHandler
 * @description       : Trigger class
 * @author            : 
 * @group             : 
 * @last modified on  :
 * @last modified by  : 
**/
public class NotificationHandler {
    public static void SendNotifiaction(List<Notification__c> NotifyList){
        CustomNotificationType closedWonNotification = [SELECT Id, 
                                                        DeveloperName  
                                                        FROM CustomNotificationType  
                                                        WHERE DeveloperName='Live_Notification_of_Student_Attendance' 
                                                        LIMIT 1]; 

        
        for(Notification__c notify : NotifyList){
            if(notify.Type__c=='Student Attendance'){
                String body = 'Notification' +notify.Name +' Missing ';
                Messaging.CustomNotification Notification = new Messaging.CustomNotification(); 
                Notification.setNotificationTypeId(closedWonNotification.id); 
                Notification.setSenderId(Userinfo.getUserId()); 
                Notification.setBody(body); 
                Notification.setTitle('StudentStatus'); 
                Notification.setTargetId(notify.Id); 
                Notification.send(new Set<String>{userinfo.getUserId()});
            }
            
        
}
    }
}