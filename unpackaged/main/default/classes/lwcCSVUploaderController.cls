public class lwcCSVUploaderController {
    
    @AuraEnabled
    public static List<ETSALES_Account_Plan__c> saveFile(String base64Data) {


        String data    = JSON.deserializeUntyped(base64Data).toString();


        list<ETSALES_Account_Plan__c> lstCCToInsert = new list<ETSALES_Account_Plan__c>();


        list<String> lstCSVLines = data.split('\n');



        for(Integer i = 1; i < lstCSVLines.size(); i++){


            ETSALES_Account_Plan__c	 accPlan = new ETSALES_Account_Plan__c();


            String csvLine = lstCSVLines[i];


            String prevLine = csvLine;
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


            accPlan	.ETSALES_Account__c                = csvRowData[0];
            accPlan	.Customer_Sector__c                = csvRowData[1];
            accPlan	.ETSALES_Year__c                     = csvRowData[2];

            lstCCToInsert.add(accPlan);
        }


        
        insert lstCCToInsert;



        return [Select id , ETSALES_Account__c , Customer_Sector__c , ETSALES_January_Budget__c from ETSALES_Account_Plan__c ];
    }



}