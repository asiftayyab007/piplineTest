global class CurrencyExchangeRate {
    
    /**
     * @description function to be called from the lwc to update price according to the new currency
     */
    @auraEnabled
    public static ApiReponse updateBikePrice(String recordId, String newCurrency){
        ApiReponse apiResponse = new ApiReponse();
        try{
            Bike__c bike = getBike(recordId);
            if(String.isNotEmpty(bike.Currency__c) && bike.Price__c > 0){
                if(bike.Currency__c != newCurrency){
                    CurrencyRates  currencyRates = fetchCurrencyRate(bike.Currency__c, newCurrency);
                    if(currencyRates.success != null && currencyRates.success == true){
                        apiResponse.isSuccess = true;
                        Boolean isCurreniesExist = checkCurrencyExistence(bike.Currency__c, newCurrency, currencyRates);
                        //check if new and existing currency rate are present in the response
                        if(isCurreniesExist){
                            Decimal newPrice = convertPriceCurrency(bike.Price__c ,bike.Currency__c, newCurrency, currencyRates);
                            
                            //update only if there is price
                            if(bike.Price__c != newPrice){
                                bike.Price__c = newPrice;
                                bike.Currency__c = newCurrency;
                                update bike;
                                apiResponse.isSuccess = true;
                                apiResponse.message = 'Price has been successfully updated..!';
                            }else{
                                apiResponse.isSuccess = true;
                                apiResponse.message = 'Price in Both Currency is Same..!';
                            }
                        }else{
                            apiResponse.isSuccess = false;
                            apiResponse.message = 'You have provided one or more invalid Currency Codes..!';
                        }
                    }
                    else{
                        apiResponse.isSuccess = false;
                        apiResponse.message = currencyRates.error.message;
                    }
                }else{
                    apiResponse.isSuccess = false;
                    apiResponse.message = 'Same Currency has been Entered..!';
                }
            }else{
                apiResponse.isSuccess = false;
                apiResponse.message = 'Currency or Price of the Bike is invalid..!';
            }
            
        }catch(Exception e){
            apiResponse.isSuccess = false;
            apiResponse.message = e.getMessage();
        }
        return apiResponse;
    }

    /**
     * @description convert price from one currency to another currency
     */
    public static Decimal convertPriceCurrency(Decimal existingPrice, String existingCurrency, String newCurrency, CurrencyRates currencyRates){
        Decimal existingCurrencyRate = currencyRates.rates.get(existingCurrency);
        Decimal newCurrencyRate = currencyRates.rates.get(newCurrency);
        Decimal newPrice = (existingPrice / existingCurrencyRate) * newCurrencyRate;
        return newPrice;
    }

    /**
     * @description to check api response whether we recieved desired currenies rates or not
     */
    public static Boolean checkCurrencyExistence(String existingCurrency, String newCurrency, CurrencyRates currencyRates){
        return currencyRates.rates.containsKey(existingCurrency) && currencyRates.rates.containsKey(newCurrency);
    }


    /**
     * @description function to make callout to the exhange api
     */
    public static CurrencyRates fetchCurrencyRate(String existingCurrency, String newCurrency){
        CurrencyRates currencyRates = new CurrencyRates();
        String desiredCurrency = existingCurrency+','+newCurrency;
        
        //to get api detail from custom metadata
        Exchange_rate__mdt exchangeRateApi = Exchange_rate__mdt.getInstance('Latest_Exchange_Rate_Api');
        String apiKey = exchangeRateApi.Access_API_Key__c;
        String baseUrl = exchangeRateApi.Base_Url__c;
        String requestUrl = baseUrl+'?'+'access_key='+apiKey+'&symbols='+desiredCurrency;
        
        //callout to api exchange
        HttpRequest request = new HttpRequest();
        request.setEndpoint(requestUrl);
        request.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(request);
        // if (res.getStatusCode() == 200) {
            currencyRates = (CurrencyRates)JSON.deserialize(res.getBody(), CurrencyRates.class);          
        // }
        return currencyRates;
    }

    public static Bike__c getBike(String recordId){
        return [Select Name, Price__c, Currency__c from Bike__c where id=:recordId];
    }

    /**
     * @description class used for parsing JSON 
     */
    public class CurrencyRates {
        public String base {get; set;}
        public Boolean success {get; set;}
        public Map<String, Decimal> rates;
        public Error error;
    }

    public class Error {
        public String code {get; set;}
        public String message {get; set;}
    }

    public class ApiReponse{
        @AuraEnabled public String message{get; set;}
        @AuraEnabled public Boolean isSuccess{get; set;}
    }
}