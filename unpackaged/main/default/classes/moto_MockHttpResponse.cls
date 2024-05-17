@isTest
global class moto_MockHttpResponse implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        System.debug('getendpotnis ='+req.getEndpoint());
        String endpoint = req.getEndpoint();
        if(endpoint.contains('https://etsoa.et.ae/soa-infra/resources/CommonBusinessServices/GetVehicleInfo')){  
            
            res.setBody('{"Status": "S","VehicleCollection": {"XxetVehicleMasterDetailV": [{"internalNo": "ETL96","vehMode": "PVT","fleetType": "Non-ET Vehicle","description": "MITSUBISHI--2009", "activityCenter": "Emirates Technical Service Centre","activityCenterCode": "345","segActivityCenter": "Emirates Technical Service Centre","segActivityCenterCode": "213001", "sector": null,"plateNumber": "21303","plateColour": "NINTH CATEGORY", "plateType": "PRIVATE", "plateIssue": "ABU DHABI", "chassisNumber": "MMBJNKB509D018612", "engineNumber": "4G64AD9546", "customerNumber": "11566", "customerId": "409051","contractNo": 50001, "oldInternalNo": "AUH414" }]}}');
        }
        
        res.setStatusCode(200);
        return res;
    }
    
}