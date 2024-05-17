/*
 * Name                : Live Notificationtrigger
 * Trigger Name        : NotificationTrigger
 * Object              : Notification__c
 * @last modified on   :
 * @last modified by   : 
 */ 

trigger NotificationTrigger on Notification__c (after insert) {
    if(Trigger.isInsert){
        NotificationHandler.SendNotifiaction(trigger.new);
    }

}