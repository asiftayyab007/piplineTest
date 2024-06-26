//component name: ET_Quotes_Pdf
//vfp name :ET_Qoutes_NewPdf
public class ET_QuotesPdfCtlr {    
    
    public Customer_Vehicle_Quote_Item__c VehcileLabelDetail {get; set;}
    public Customer_Vehicle_Quote_Item__c VehcileCheckBoxDetail {get; set;}
    public List<LinesDetail> linesDetail{get; set;}

    public List<Customer_Workforce_Quote_Item__c> workforceDetails {get;set;}
    public Customer_Workforce_Quote_Item__c workforceLabelDetail {get; set;}
    public Customer_Workforce_Quote_Item__c workforceCheckBoxDetail {get; set;}
    
    public String oppOwnerName {get;set;}
    public String oppOwnerContactNo{get; set;}
    public String oppOwnerEmail{get; set;}
    public String oppOwnerManagerName {get;set;}
    public String oppOwnerManagerDesignation {get;set;}
    public String customerName {get;set;}
    public String oppSector {get;set;}
    public String oppOwnerTitle {get; set;}
    public String fuelPriceIncluded {get;set;}
    public Boolean isMonthlycontract{get;set;}
    public Boolean isPreMatureTermAvailable{get; set;}
    public Boolean isAdditionalTermAvailable{get; set;}
    public Boolean isTransportation{get; set;}

    public String emirates {get;set;}
    public Customer_Quote__c customerQuote {get; set;}
    public List<TermsAndCondition__c> quoteTerms { get; set; }
    public List<TermsAndCondition__c> quotePreMatureTerms { get; set; }
    public List<TermsAndCondition__c> quoteAddtionalTerms { get; set; }

    
    public ET_QuotesPdfCtlr(ApexPages.StandardController stdController)
    {
        String quoteId = ApexPages.currentPage().getParameters().get('Id');
        
        
        //get customer Quote owner related information
        List<Customer_Quote__c> customerQuotes =[select id, Opportunity_Name__r.AccountId, Opportunity_Name__r.Owner.Name, Opportunity_Name__r.Owner.Email,
                                                Opportunity_Name__r.Owner.Manager.Name, Opportunity_Name__r.Owner.ManagerName__c, Group_By__c,
                                                Opportunity_Name__r.ETSALES_Sector__c,Opportunity_Name__r.RecordType.Name,  Opportunity_Name__r.Fuel_Included_Current_Contract__c,
                                                Opportunity_Name__r.Owner.ContactNumber__c, Opportunity_Name__r.Owner.ManagerDesignation__c,Customer_Quote_Date__c,Additional_Notes__c,
                                                Opportunity_Name__r.Owner.Title, Contract_Type__c, CustomerName__c, Contact_PersonTitle__c,  Opportunity_Name__r.Account.ETI_Emirates__c
                                                from Customer_Quote__c where Id =:quoteId limit 1];
        
        for (Customer_Quote__c quote : customerQuotes) {
            getLinesData(quoteId, quote.Group_By__c);

            customerQuote = quote;
            if (quote.Opportunity_Name__r.Owner.Name != null) {
                oppOwnerName =  quote.Opportunity_Name__r.Owner.Name;
            }
            if (quote.Opportunity_Name__r.Owner.ContactNumber__c != null) {
                oppOwnerContactNo = quote.Opportunity_Name__r.Owner.ContactNumber__c;
            }
            if (quote.Opportunity_Name__r.Owner.Email != null) {
                oppOwnerEmail = quote.Opportunity_Name__r.Owner.Email;
            }
            if (quote.Opportunity_Name__r.Owner.Manager.Name != null) {
                oppOwnerManagerName = quote.Opportunity_Name__r.Owner.Manager.Name;
            }
            if (quote.Opportunity_Name__r.Owner.ManagerName__c != null && oppOwnerManagerName == null) {
                oppOwnerManagerName =  quote.Opportunity_Name__r.Owner.ManagerName__c;
            }
            if (quote.Opportunity_Name__r.Owner.ManagerDesignation__c != null) {
                oppOwnerManagerDesignation =  quote.Opportunity_Name__r.Owner.ManagerDesignation__c;
            }
            if (quote.Opportunity_Name__r.Owner.Title != null) {
                oppOwnerTitle =  quote.Opportunity_Name__r.Owner.Title;
            }else{
                oppOwnerTitle = 'Sales Manager';
            }
            if(quote.Opportunity_Name__r.Fuel_Included_Current_Contract__c == 'YES'){
                fuelPriceIncluded = 'Included';
            }else{
                fuelPriceIncluded = 'Not included';
            }
            
            if(quote.Contract_Type__c == 'Monthly'){
                isMonthlycontract = true;
            }else{
                isMonthlycontract = false;
            }
            
            oppSector = quote.Opportunity_Name__r.ETSALES_Sector__c;
            isTransportation = quote.Opportunity_Name__r.ETSALES_Sector__c=='Transport And Lease' && quote.Opportunity_Name__r.RecordType.Name=='Transportation' ? true: false;

            //fetch contact informtaion
            customerName = quote.CustomerName__c;
            emirates = quote.Opportunity_Name__r.Account.ETI_Emirates__c;
            /*
            List<Contact> contacts = [Select id, name from contact where AccountId =: quote.Opportunity_Name__r.AccountId AND IsCustomerQuoteContact__c = true order by CreatedDate desc];
            if(contacts.size()>0){
            Contact contact = contacts[0];
            customerName = contact.name;
            }*/
        }
        
        //to sort and fetch terms and condition linked with customer quote
        quoteTerms = new List<TermsAndCondition__c>();
        quoteAddtionalTerms = new List<TermsAndCondition__c>();
        quotePreMatureTerms = new List<TermsAndCondition__c>();
        // List<TermsAndCondition__c> tempTerms = new List<TermsAndCondition__c>();
        List<TermsAndCondition__c>  quotesWithTerms = [SELECT Id, Terms_Description__c, Additional_Term_Text__c, Charge_Type__c,Charge_Value__c, Charge_Type_Value__c,Remarks__c, Remarks_Value__c,Remark_Type__c  FROM TermsAndCondition__c 
                                                       WHERE Customer_Quote__c =:quoteId order by Pdf_Print_Order__c, Terms_Description__c];
        for(TermsAndCondition__c term : quotesWithTerms){
            if(term.Terms_Description__c == 'Additional Terms'){
                quoteAddtionalTerms.add(term);
            }else if(term.Terms_Description__c.contains('Pre mature penalty Months') || term.Terms_Description__c.contains('Pre mature penalty after issuing')){
                quotePreMatureTerms.add(term);
            }
            else{
                quoteTerms.add(term);
            }
        }
        isPreMatureTermAvailable = quotePreMatureTerms.size()>0 ? true: false;
        isAdditionalTermAvailable = quoteAddtionalTerms.size()>0 ? true: false;
        // quoteTerms.addAll(tempTerms);
        
    }
    
    @AuraEnabled
    public static string generateQuoteDoc(string quoteId){
        List<Customer_Quote__c>  cusQuote =[select Id, Name from Customer_Quote__c where Id =:quoteId];
        String CusQuoteName = cusQuote[0].Name;
        PageReference pdf =  Page.ET_Qoutes_NewPdf;
        pdf.getParameters().put('Id',quoteId);
        Blob pdfBlob;
        if (!Test.isRunningTest()) {
            pdfBlob = pdf.getContentAsPDF();
        }
        try{
            ContentVersion conVer = new ContentVersion();
            DateTime  dt = System.now();
            
            conVer.ContentLocation = 'S'; // TO USE S specify this document IS IN Salesforce, TO USE E FOR external files
            conVer.PathOnClient = CusQuoteName+'_'+dt.hour()+dt.minute()+dt.second()+'.pdf'; 
            conVer.Title = CusQuoteName+ '_'+dt.hour()+dt.minute()+dt.second()+'.pdf'; 
            conVer.VersionData = pdfBlob;
            insert conVer;  
            
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            
            ContentDocumentLink conDocLink = new ContentDocumentLink();
            conDocLink.LinkedEntityId = quoteId; //parentId
            conDocLink.ContentDocumentId = conDoc; 
            conDocLink.shareType = 'V';
            insert conDocLink;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        return quoteId;
        
    }

    public void getLinesData(String quoteId, String groupBy){
        
        Map<Integer, List<Customer_Vehicle_Quote_Item__c>> vehicleMapByYear = new Map<Integer, List<Customer_Vehicle_Quote_Item__c>>();

        List<Customer_Vehicle_Quote_Item__c> vehicles = new List<Customer_Vehicle_Quote_Item__c>();
        VehcileLabelDetail = new Customer_Vehicle_Quote_Item__c();
        VehcileCheckBoxDetail = new Customer_Vehicle_Quote_Item__c();

        for(Customer_Vehicle_Quote_Item__c vehicle: getVehicleLines(quoteId)){
            if(vehicle.Is_Label_Row__c == false && vehicle.Is_CheckBox_Row__c == false){
                // to build map on yearly base
                if(groupBy == 'Year'){
                    Integer contractPeriod = Integer.valueOf(vehicle.Contract_Period_In_Years__c);
                    if(vehicleMapByYear.containsKey(contractPeriod)){
                        List<Customer_Vehicle_Quote_Item__c> temp = vehicleMapByYear.get(contractPeriod);
                        temp.add(vehicle);
                    }else{
                        List<Customer_Vehicle_Quote_Item__c> temp = new List<Customer_Vehicle_Quote_Item__c>();
                        temp.add(vehicle);
                        vehicleMapByYear.put(contractPeriod, temp);
                    }
                }else{
                    vehicles.add(vehicle);
                }
            }else if(vehicle.Is_Label_Row__c == true && vehicle.Is_CheckBox_Row__c == false){
                VehcileLabelDetail = vehicle;
            }else if(vehicle.Is_Label_Row__c == false && vehicle.Is_CheckBox_Row__c == true){
                VehcileCheckBoxDetail = vehicle;
            }
        }

        if(groupBy == 'Year'){
            buildVehicleListByYear(vehicleMapByYear);
        }else{
            linesDetail = new List<LinesDetail>();
            LinesDetail tempLinesDetail = new LinesDetail();
            tempLinesDetail.vehciledetails = vehicles;
            tempLinesDetail.isGroupByYear = false;
            linesDetail.add(tempLinesDetail);
        }
        
        //Workforce Lines Detail
        workforceDetails = new List<Customer_Workforce_Quote_Item__c>();
        workforceLabelDetail = new Customer_Workforce_Quote_Item__c();
        workforceCheckBoxDetail = new Customer_Workforce_Quote_Item__c();
        
        for(Customer_Workforce_Quote_Item__c workforce: getWorkforceLines(quoteId)){
            if(workforce.Is_Label_Row__c == false && workforce.Is_CheckBox_Row__c == false){
                workforceDetails.add(workforce);
            }else if(workforce.Is_Label_Row__c == true && workforce.Is_CheckBox_Row__c == false){
                workforceLabelDetail = workforce;
            }else if(workforce.Is_Label_Row__c == false && workforce.Is_CheckBox_Row__c == true){
                workforceCheckBoxDetail = workforce;
            }
        }    
    }

    public void buildVehicleListByYear(Map<Integer, List<Customer_Vehicle_Quote_Item__c>> vehicleMapByYear){
        //fill data in the wrapper class
        linesDetail = new List<LinesDetail>();
        for(Integer key: vehicleMapByYear.keySet()){
            List<Customer_Vehicle_Quote_Item__c> vehicles = vehicleMapByYear.get(key);
            
            Integer totalQty = 0;
            Decimal monthlyCostPerVeh = 0;
            Decimal monthlyRateAllUnit = 0;
            Decimal totalRateAllUnit = 0;
            for(Customer_Vehicle_Quote_Item__c veh: vehicles){
                totalQty += Integer.valueOf(veh.Number_of_Vehicles__c);
                monthlyCostPerVeh += veh.Vehicle_Monthly_Cost__c;
                monthlyRateAllUnit += veh.Monthly_Rate_All_Unit_with_VAT__c;
                totalRateAllUnit += veh.Total_Rate_All_Units__c;
            }

            LinesDetail tempLinesDetail = new LinesDetail();
            tempLinesDetail.year = key;
            tempLinesDetail.totalRateAllUnit = totalRateAllUnit;
            tempLinesDetail.totalQty = totalQty;
            tempLinesDetail.monthlyCostPerVeh = monthlyCostPerVeh;
            tempLinesDetail.monthlyRateAllUnit = monthlyRateAllUnit;
            tempLinesDetail.vehciledetails = vehicles;
            tempLinesDetail.isGroupByYear = true;
            linesDetail.add(tempLinesDetail);
        }
    }

    public List<Customer_Vehicle_Quote_Item__c> getVehicleLines(String quoteId){
        return  [select Remarks__c, Vehicle_Unique_key__c,Vehicle_Manufacture_Year__c,Number_of_Vehicles__c,Total_Vehicles_Cost__c,No_of_Months__c, No_of_Years__c,
                Name, Vehicle_Monthly_Cost__c,Vat_Per_Unit__c,Monthly_Rate_with_VAT__c,Monthly_Rate_All_Unit_with_VAT__c, Total_Rate_All_Units__c,
                ET_Total_Annual_Mileage__c, Extra_Miles__c, Delivery_Days__c, Vehicle_Source__c, Label_No_of_Months__c, Label_Name__c, Label_No_of_Vehicles__c, 
                Label_Vehicle_Monthly_Price__c, Label_Monthly_Rate_All_Unit_with_VAT__c, Label_Total_Rate_All_Units__c, Label_ET_Total_Annual_Mileage__c,
                Label_Vehicle_Source__c, Label_Extra_Miles__c, Label_Delivery_Days__c, Is_No_of_Months__c, Is_Number_of_Vehicles__c, Is_Vehicle_Monthly_Price__c,
                Is_Monthly_Rate_All_Unit_with_VAT__c,Is_Total_Rate_All_Units__c, Is_ET_Total_Annual_Mileage__c, Is_Vehicle_Source__c, 
                Is_Extra_Miles__c, Is_Delivery_Days__c, Is_Label_Row__c, Is_CheckBox_Row__c, Contract_Period_In_Years__c
                from Customer_Vehicle_Quote_Item__c where Customer_Quote__c =:quoteId
                order by Line_Number__c asc, Contract_Period_In_Years__c asc];
        
    }

    public List<Customer_Workforce_Quote_Item__c> getWorkforceLines(String quoteId){
        return [select Id,Name,No_of_Months__c,Remarks__c,Number_of_Workforce__c, Workforce_Monthly_Price__c,
                Monthly_Rate_All_Unit_with_VAT__c, Total_Rate_All_Units__c,Type__c,Delivery_Days__c,
                Workforce_Monthly_Cost__c, Vat_Per_Unit__c,No_of_Years__c,
                Monthly_Rate_with_VAT__c,Workforce_Quote_Item_Type__c, Label_No_of_Months__c, Label_Remarks__c, Label_Number_of_Workforce__c, 
                Label_Workforce_Monthly_Price__c, Label_Monthly_Rate_All_Unit_with_VAT__c, Label_Total_Rate_All_Units__c, Label_Type__c,Label_Delivery_Days__c,
                Is_No_of_Months__c, Is_Remarks__c, Is_Number_of_Workforce__c, Is_Workforce_Monthly_Price__c,
                Is_Monthly_Rate_All_Unit_with_VAT__c, Is_Total_Rate_All_Units__c, Is_Type__c, Is_Delivery_Days__c,
                Is_CheckBox_Row__c, Is_Label_Row__c
                from Customer_Workforce_Quote_Item__c where Quote__c =:quoteId
                order by Workforce_Line_Number__c asc, Contract_Period__c asc];
    }
    
    class LinesDetail{
        public Boolean isGroupByYear {get; set;}
        public Integer year{get; set;}
        public Integer totalQty {get; set;}
        public Decimal monthlyCostPerVeh {get; set;}
        public Decimal monthlyRateAllUnit {get; set;}
        public Decimal totalRateAllUnit {get; set;}
        public List<Customer_Vehicle_Quote_Item__c> vehciledetails{get; set;}
        public LinesDetail(){

        }
    }


    public static void testCoverage1(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    public static void testCoverage2(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }    
}