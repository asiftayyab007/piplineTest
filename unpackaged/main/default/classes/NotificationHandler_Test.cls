@isTest
public class NotificationHandler_Test {
    
    public static testMethod void testmethodNew(){
        
        Notification__c notification = new Notification__c();
        notification.Name='test';
        notification.Notification_body__c='test body';
        notification.Type__c='Student Attendance';
        insert notification;
        
         List<Notification__c> str = new List<Notification__c>();
        str.add(notification);
        
       /*
        insert p;
        
          */
        
        Test.startTest();
           NotificationHandler.SendNotifiaction(str);
        
        Test.stopTest();
            
        }
}