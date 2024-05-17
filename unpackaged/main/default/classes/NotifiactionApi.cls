@RestResource(urlMapping='/showNotifiaction/*')
global class NotifiactionApi {
    
    
    @HttpGet
    global static List<Notification__c> getDetails() {
        List<Notification__c> lst;
        
        try {
            lst = [SELECT Name,Notification_body__c,Type__c,User__c FROM Notification__c];
            return lst;
        } catch (Exception ex) {
            System.debug('error'+ex.getMessage());
            
        }
        return lst;
        
    }
    
  
}