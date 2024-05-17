public class AccountPlanController {
    @AuraEnabled
public static Integer  saveFile(String base64Data) {
        String data = JSON.deserializeUntyped(base64Data).toString();
        list<ETSALES_Account_Plan__c> lstCCToInsert = new list<ETSALES_Account_Plan__c>();
        list<String> lstCSVLines = data.split('\n');
		Integer recordNotInserted;
    	lstCSVLines.remove(0);
    	String tempList = lstCSVLines[0] + lstCSVLines[2];
    	lstCSVLines.remove(0);
    lstCSVLines.remove(0);
    lstCSVLines.remove(0);

       
        lstCSVLines.add(tempList);
        System.debug('lstCSVLines 1 === '+lstCSVLines);
    	System.debug('lstCSVLines 2 === '+tempList);
        for(Integer i=0;i<lstCSVLines.size();i++){
            ETSALES_Account_Plan__c AccPlan = new ETSALES_Account_Plan__c();
           	
            String csvLine =lstCSVLines[i];
            String prevLine = csvLine;
            System.debug('csvLine == '+csvLine);
	
            Integer startIndex;
            Integer endIndex;
            
            while(csvLine.indexOf('"') > -1){
            
                if(startIndex == null){
                    startIndex = csvLine.indexOf('"');
                    csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
                }else{
                    if(endIndex == null){
                        endIndex = csvLine.indexOf('"');
                        csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
                    }
                }
                if(startIndex != null && endIndex != null){
                    String sub = csvLine.substring(startIndex, endIndex);
                    sub = sub.replaceAll(',', ':comma:');
                    csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                    startIndex = null;
                    endIndex = null;
                }
            }
            List<String> csvRowData = new List<String>();
            for(String column : csvLine.split(',')){
                column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                csvRowData.add(column);
            }
            System.debug('checking '+ csvRowData );
          //  AccPlan.ETSALES_Account__c = csvRowData[0];
            AccPlan.Customer_Sector__c = csvRowData[1];
            AccPlan.ETSALES_January_Budget__c = Decimal.valueOf(csvRowData[2]);
            AccPlan.ETSALES_January_Actual__c = Decimal.valueOf(csvRowData[3]);
            AccPlan.ETSALES_February_Budget__c = Decimal.valueOf(csvRowData[4]);
            AccPlan.ETSALES_February_Actual__c =  Decimal.valueOf(csvRowData[5]);
            AccPlan.ETSALES_March_Budget__c = Decimal.valueOf(csvRowData[6]); 
            AccPlan.ETSALES_March_Actual__c = Decimal.valueOf(csvRowData[7]); 
            AccPlan.ETSALES_April_Budget__c =  Decimal.valueOf(csvRowData[8]);
            AccPlan.ETSALES_April_Actual__c =  Decimal.valueOf(csvRowData[9]);
            AccPlan.ETSALES_May_Budget__c =  Decimal.valueOf(csvRowData[10]);
            AccPlan.ETSALES_May_Actual__c = Decimal.valueOf(csvRowData[11]);
            AccPlan.ETSALES_June_Budget__c = Decimal.valueOf(csvRowData[12]);
            AccPlan.ETSALES_June_Actual__c = Decimal.valueOf(csvRowData[13]); 
            AccPlan.ETSALES_July_Budget__c	 = Decimal.valueOf(csvRowData[14]); 
            AccPlan.ETSALES_July_Actual__c =  Decimal.valueOf(csvRowData[15]);
            AccPlan.ETSALES_August_Budget__c = Decimal.valueOf(csvRowData[16]); 
            AccPlan.ETSALES_August_Actual__c =  Decimal.valueOf(csvRowData[17]);
            AccPlan.ETSALES_September_Budget__c = Decimal.valueOf(csvRowData[18]);
            AccPlan.ETSALES_September_Actual__c =  Decimal.valueOf(csvRowData[19]);
            AccPlan.ETSALES_October_Budget__c =  Decimal.valueOf(csvRowData[20]);
            AccPlan.ETSALES_October_Actual__c =  Decimal.valueOf(csvRowData[21]);
            AccPlan.ETSALES_November_Budget__c	 = Decimal.valueOf(csvRowData[22]);
            AccPlan.ETSALES_November_Actual__c = Decimal.valueOf(csvRowData[23]); 
            AccPlan.ETSALES_December_Budget__c =  Decimal.valueOf(csvRowData[24]);
            System.debug('csvRowData[25] == '+csvRowData[24]);
            AccPlan.ETSALES_December_Actual__c =  Decimal.valueOf(csvRowData[25]);
            
            List<Account> acc = [Select Id,Name From Account Where Name =: csvRowData[0].replace('\r','') LIMIT 1];
            if(!acc.isEmpty()){
                AccPlan.ETSALES_Account__c = acc[0].Id;
                lstCCToInsert.add(AccPlan);
            }
        }
    	System.debug('lstCSVLines.size() == '+lstCSVLines.size());
    	System.debug('lstCCToInsert.size() == '+lstCCToInsert.size());
    	recordNotInserted = lstCSVLines.size() - lstCCToInsert.size();
        System.debug('recordNotInserted == '+recordNotInserted);

      //  Insert lstCCToInsert;
    Database.upsert((lstCCToInsert),false);
    
        return recordNotInserted;
    }
}