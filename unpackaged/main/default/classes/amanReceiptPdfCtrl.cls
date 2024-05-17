/***
Class       : amanReceiptPdfCtrl
Author      : Janardhan Muddana
Description : get data from ERP and show in Pdf
Wrapper Class: amanReceiptWrapperCls
TestClass  : 
----------------------------------------------------------------------------------------------------------------
            -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date                Details
1.          V1.0              05/05/23           Initial Version 
****************************************************************************************************************/
public class amanReceiptPdfCtrl {
    
    public amanReceiptWrapperCls wrpdata {get;set;}
    public string heavyVehInsAr {get;set;}
    public string insCentNameEn {get;set;}
    public string insCentNameAr {get;set;}
    public string recptAr {get;set;}
    public amanReceiptPdfCtrl(ApexPages.StandardController controller){
       
        String recpNo = ApexPages.currentPage().getParameters().get('recpNo');
        heavyVehInsAr = 'مركز الفحص الفني للمركبات الثقيلة'.reverse();
        recptAr = 'إيصال'.reverse();
        getAmanInfo(recpNo);
        
    }
  
    public void getAmanInfo(string recpNo) {
         
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('amanReceiptDetails');
        Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        
         HttpRequest request = new HttpRequest();
        
        if(ET_REST_Authorize_Helper.runningInASandbox()){
            request.setEndpoint(connection.Dev_Endpoint__c+'?ReceiptNo='+recpNo);           
        }else{
            request.setEndpoint(connection.LiveEndpoint_c__c+'?ReceiptNo='+recpNo);
        }  
        
        request.setMethod('GET');
        request.setTimeout(120000);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization','Basic '+paramvalue);   
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            wrpdata = amanReceiptWrapperCls.parse(response.getBody());
            
            insCentNameEn= wrpdata.ReceiptDetails[0].Location.EN;
            insCentNameAr=wrpdata.ReceiptDetails[0].Location.AR.reverse();
            system.debug(wrpdata.ReceiptDetails[0].Amount); 
        }
    }
  
}