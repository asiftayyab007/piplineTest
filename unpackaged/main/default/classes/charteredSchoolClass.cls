public class charteredSchoolClass {
  
    
    @AuraEnabled
    public static void savestudentList(List<Student_Vehicle_Mapping__c> studentList) 
	{        
        system.debug('accountsinside'); 
        Insert studentList;
    }

}