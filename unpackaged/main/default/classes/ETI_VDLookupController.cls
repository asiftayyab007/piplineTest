public class ETI_VDLookupController {
    //This method retrieves the data from database table. It search input is '*', then retrieve all records
    @AuraEnabled (cacheable=true)
    public static List<SObjectQueryResult> retrieveRecords(String objectName, 
                                                    String fieldAPINames,
                                                    String filterFieldAPIName,
                                                    String strInput){
        List<SObjectQueryResult> lstReturnResult = new List<SObjectQueryResult>();
        System.debug('objectName: '+objectName+' fieldAPINames: '+fieldAPINames+' filterFieldAPIName: '+filterFieldAPIName+' strInput: '+strInput);
        if(strInput.equals('*')){
            strInput = '';
        }
        String str = strInput + '%';
        String strQueryField = '';
        List<String> fieldList = fieldAPINames.split(',');
        //check if Id is already been passed
        if(!fieldList.contains('Id')){
            fieldList.add('Id');
            strQueryField = String.join(fieldList, ',');
        }else {
            strQueryField = fieldAPINames;
        }
        String strQuery = 'SELECT ' + String.escapeSingleQuotes(strQueryField) 
                        + ' FROM ' 
                        + String.escapeSingleQuotes(objectName) 
                        + ' WHERE ' + filterFieldAPIName + '  LIKE \'' + str + '%\''
                        + ' ORDER BY ' + filterFieldAPIName + ' ASC'
                        + ' LIMIT 50';
        System.debug('strQuery=' + strQuery);
        List<SObject> lstResult = database.query(strQuery);
        //create list of records that can be easily be parsable at js controller.
            for(SObject sobj:lstResult){  
                    SObjectQueryResult result = new SObjectQueryResult();
                    result.recordId = sobj.Id;
                    result.recordObj = sobj;
                    System.debug('result >> '+result);
                    lstReturnResult.add(result);
            }
        return lstReturnResult;
    }
    
    public class SObjectQueryResult {
        @AuraEnabled
        public String recordId;
        @AuraEnabled
        public SObject recordObj;
    }
}