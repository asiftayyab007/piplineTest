public class ExchangeRateMock implements HttpCalloutMock {
    
     public HttpResponse respond(HttpRequest req) {
            // You can customize the mock response as needed for your test
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{ "success": true, "timestamp":1707484264, "base": "USD", "date": "2024-02-09", "rates": {"USD": 1, "EUR": 0.9}}');
            return res;
        }

}