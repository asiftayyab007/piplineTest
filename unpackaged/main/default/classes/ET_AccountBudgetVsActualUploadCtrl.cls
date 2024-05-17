public  class ET_AccountBudgetVsActualUploadCtrl {
    
    @AuraEnabled
    public static String updateData(String fileData){
        System.debug('Classinside');
        
        String returnresponse ='';
        List<ETSALES_Account_Plan__c> AccoutnListtoInsert = new List<ETSALES_Account_Plan__c>();
        System.debug('listData' + AccoutnListtoInsert);
        system.debug('@@@CSVDATA = ' + fileData);
        List<AccWrapper> datalist = (List<AccWrapper>) JSON.deserialize(fileData, List<AccWrapper>.class);
        system.debug('@@@ datalist = ' + datalist);
        system.debug('@@@ datalistSize = ' + datalist.size());
        Blob blobData = Blob.valueOf(fileData);
        System.debug('Blobdata'+blobData);
        
        String CSVfile = blobData.toString();
        System.debug('sfdc'+CSVfile);
        
        
        for(accWrapper wrapper: datalist){
            ETSALES_Account_Plan__c acc =new  ETSALES_Account_Plan__c();
            if(String.isNotBlank(wrapper.CustomerName)){
                acc.id= wrapper.CustomerName;
            }
            if(string.isNotBlank(wrapper.DocDate)){
                acc.ETSALES_Year__c=wrapper.DocDate;
            }           
            if(string.isNotBlank(wrapper.BusinessLine)){
                acc.Customer_Sector__c= wrapper.BusinessLine;
            }
            
            acc.ETSALES_April_Actual__c=wrapper.ActualAmount;
            acc.ETSALES_April_Budget__c = wrapper.BudgetAmount;
            
            AccoutnListtoInsert.add(acc);
        }
        if(AccoutnListtoInsert.size() > 0)
        {
            try {
                upsert AccoutnListtoInsert;
                returnresponse = 'SUCCESS';
            }
            catch(Exception ex)
            {
                returnresponse = 'ERROR';
                system.debug('-err-'+ex);
                throw new AuraHandledException('Error-- '+ ex.getMessage());  
            }
        }
        
        return returnresponse;
    }
    
    
    public  class accWrapper{ 
        public  String CustomerName;  
        public  String DocDate;        
        public Decimal  ActualAmount;
        public Decimal  BudgetAmount;
        public  String BusinessLine;
    } 
    
    
    
}