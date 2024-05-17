@isTest
public class ET_InspectionReceiptMockCallout implements HttpCalloutMock {

    public HTTPResponse respond(HTTPRequest req) {
        // Create a mock response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"receiptWrp": {"Status": "Success", "Message": "Mock response"}}');
        res.setStatusCode(200);
        return res;
    }
}