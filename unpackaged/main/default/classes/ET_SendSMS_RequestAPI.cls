//Generated by wsdl2apex

public class ET_SendSMS_RequestAPI{
    public class execute_pt {
        public String endpoint_x = 'https://etsoa.et.gov.ae:443/soa-infra/services/CommonServices/SendSMS/SoapClient';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public String username_x;
        public String password_x;
        
        private String[] ns_map_type_info = new String[]{'http://www.et.ae', 'ET_SendSMS_API_Paramter', 'http://oracle.com/sca/soapservice/CommonBusinessServices/SendSMS/SoapClient', 'oracleComScaSoap'};
        
        public OasisOpenOrgWssSecuritySecext.SecurityHeaderType Security;
        private String Security_hns = 'Security=http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';                          
        
        public execute_pt(){
            ET_Lookup.SecurityInfo authInfo =  ET_SOA_Authorize.initializeDynamicSecurity(ET_SOA_Authorize.CREATE_SERVICE_TYPE);
            //endpoint_x = ET_SOA_Authorize.endpointURL;
            //username_x = authInfo.Username;
            //password_x = authInfo.Password;
            Security = new OasisOpenOrgWssSecuritySecext.SecurityHeaderType('SalesForce', 'S4K#$@BDWK');
        }      

        public ET_SendSMS_API_Paramter.Output execute(String Sender,String MobileNo,String Message) {
            ET_SendSMS_API_Paramter.Input request_x = new ET_SendSMS_API_Paramter.Input();
            request_x.Sender = Sender;
            request_x.MobileNo = MobileNo;
            request_x.Message = Message;
            ET_SendSMS_API_Paramter.Output response_x;
            Map<String, ET_SendSMS_API_Paramter.Output> response_map_x = new Map<String, ET_SendSMS_API_Paramter.Output>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'execute',
              'http://www.et.ae',
              'Input',
              'http://www.et.ae',
              'Output',
              'ET_SendSMS_API_Paramter.Output'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
}