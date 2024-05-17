@isTest
public class CurrencyExchangeRateTest {
    
    @isTest
    public static void testUpdateBikePrice()
    {
        Bike__c bike = new Bike__c(Name='Test Bike', Price__c=1,  Currency__c='USD');
        insert bike;
        
        // Mock the HTTP response
        Test.setMock(HttpCalloutMock.class, new ExchangeRateMock());

        // Test the updateBikePrice method
        Test.startTest();
        	CurrencyExchangeRate.updateBikePrice(bike.Id, 'EUR');
        Test.stopTest();
        
        // Retrieve the updated bike record
        bike = [SELECT Id, Name, Price__c, Currency__c FROM Bike__c WHERE Id = :bike.Id];

        // Assert that the bike's currency and price have been updated
        System.assertEquals('EUR', bike.Currency__c);
        System.assertEquals(0.9, bike.Price__c);
    }
    
    	
}