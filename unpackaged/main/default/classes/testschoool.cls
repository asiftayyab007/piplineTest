public class testschoool {
	@AuraEnabled
    
    public static List<ETST_Student__c> getstudentDetails(string StudentId){
        try{
            List<ETST_Student__c> studentName =[Select Id,Name,ETST_Account_Name__c,ETST_Account_Name__r.Name,ETST_Nationality__c,ETST_Primary_Assigned_Vehicle__c,ETST_Primary_Assigned_Vehicle__r.Name 
                                                From ETST_Student__c Where Id=:StudentId ];
            system.debug('studentName'+studentName);
            return studentName;
        }
        catch(exception e){
            System.debug('Message: '+e.getMessage());
            System.debug('line: '+e.getLineNumber());
            throw new AurahandledException('Something went wrong' + e.getMessage());
        }
    }
}