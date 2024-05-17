public class Student_vehicle_mapping_Ctr {
    
    @AuraEnabled
    public static void SavestudentList(List<Student_Vehicle_Mapping__c> studentList) 
    {        
        Insert studentList;
    }
    @AuraEnabled
    public static List<ETST_Student__c> studentRecordsList(string SchoolId) 
    {        
        system.debug(SchoolId);
        
        List<ETST_Student__c> STDList=[select id, Name,ETST_School_Name__c, ETST_School__r.Name,ETST_School__c, ETST_School_Name__r.Name, ETST_School_Name__r.Id from ETST_Student__c where ETST_School_Name__r.Id =: SchoolId];
        system.debug(STDList);
        return STDList;
    }
    
    @AuraEnabled
    public static ETST_Student__c getstudentDetails(string SchoolId){
        
        return [Select Id,ETST_School_Name__c,Name,ETST_Grade__c,ETST_Division__c,ETST_Student_Id__c,ETST_Account_Name__c,ETST_Account_Name__r.FirstName FROM ETST_Student__c WHERE id=:SchoolId];
    }
    
    
    @AuraEnabled
    public static List<RecordsData> fetchRecords(String objectName, String filterField, String searchString, String value,string SchoolId) {
        system.debug(objectName);
        system.debug(filterField);
        system.debug(value);
        system.debug(searchString);
        try {
            List<RecordsData> recordsDataList = new List<RecordsData>();
            String query = 'SELECT Id, ' + filterField + ' FROM '+objectName;
            if(String.isNotBlank(value)) {
                query += ' WHERE Id = \''+ value + '\' LIMIT 49999';
            } else {
                query += ' WHERE '+filterField+
                		' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\' LIMIT 49999';
            }
	        for(SObject s : Database.query(query)) {
	            recordsDataList.add( new RecordsData((String)s.get(filterField), (String)s.get('id')) );
	        }
            system.debug(recordsDataList);
            return recordsDataList;
	    } catch (Exception err) {
	    	if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
	    }
    }
     public class RecordsData {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        public RecordsData(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }

    
    @AuraEnabled
    public static List<SObJectResult> getResults(String ObjectName, String fieldName, String value) {
         system.debug(objectName);
        system.debug(fieldName);
        system.debug(value);
        
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        for(sObject so : Database.Query('Select Id,'+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value + '%\'')) {
            String fieldvalue = (String)so.get(fieldName);
            sObjectResultList.add(new SObjectResult(fieldvalue, so.Id));
        }
                    system.debug(sObjectResultList);

        return sObjectResultList;
    }
     public class SObJectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        
        public SObJectResult(String recNameTemp, Id recIdTemp) {
            recName = recNameTemp;
            recId = recIdTemp;
        }
    }
}