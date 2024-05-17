public class ET_DailyTripInspectionForm_Contoller {
    @AuraEnabled 
    public static String getUserName() {
        system.debug('User info'+userinfo.getName());
        return userinfo.getName();
        
        
    }
    
   
    
}