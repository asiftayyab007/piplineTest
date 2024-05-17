public class TestUAEPassAuthPrvdr extends Auth.AuthProviderPluginClass{
    public String redirectUrl; 
    private String key;
    private String secret;    
    private String authUrl;
    private String accessTokenUrl;
    private String customMetadataTypeApiName;
    private String userAPIUrl;
    
    public String getCustomMetadataType() {
       return 'UPass_SSO_Settings__mdt';
    } 
    
    public PageReference initiate(Map<string,string> config, String stateToPropagate) {
        
        authUrl     = config.get('Auth_URL__c');
        key       = config.get('key__c'); 
        redirectUrl   = System.label.UpassRedirectURL_1;
        String url     = authUrl + '?response_type=code&client_id='+ key ;
        url       += '&scope=urn:uae:digitalid:profile:general&acr_values=urn:safelayer:tws:policies:authentication:level:low&redirect_uri='+ redirectUrl;
        url       += '&state=' + stateToPropagate;
       
        return new PageReference(url);
        
    }
    public Auth.AuthProviderTokenResponse handleCallback(Map<string,string> config, Auth.AuthProviderCallbackState state ) {
        
         key         = config.get('key__c');
        secret         = config.get('Secret__c');
        accessTokenUrl     = config.get('Access_Token_Url__c');
        String code     = state.queryParameters.get('code');
        String sfdcState   = state.queryParameters.get('state'); 
        HttpRequest req   = new HttpRequest();
        String url       = accessTokenUrl + '?code=' + code + '&client_id=' + key + '&client_secret=' + secret; 
        url         += '&grant_type=authorization_code&redirect_uri='+ System.label.UpassRedirectURL_1;
        
        req.setEndpoint(url);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setMethod('GET');
        Http http       = new Http();
        HTTPResponse res   = http.send(req);
        CB_Response cbResp   = (CB_Response)JSON.deserialize(res.getBody(), CB_Response.class);
               
        return new Auth.AuthProviderTokenResponse('uaepass', cbResp.access_token, 'refreshToken', sfdcState);
    }
    
    public Auth.UserData getUserInfo(Map<string,string> config, Auth.AuthProviderTokenResponse response) {
        String token   = response.oauthToken;
        userAPIUrl     = config.get('API_User_Url__c');
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + response.oauthToken); 
        req.setEndpoint(userAPIUrl);
        req.setMethod('GET');
       
        Http http         = new Http();
        HTTPResponse res     = http.send(req);
        String responseBody    = res.getBody();
        UAEPassUser userData   = (UAEPassUser)JSON.deserialize(responseBody, UAEPassUser.class);
       
        Map<String,String> mapAttributes = new Map<String,String>();
        mapAttributes.put('mobile',userData.mobile);
        
        return new Auth.UserData(
            userData.uuid, userData.firstnameEN, userData.lastnameEN, userData.fullnameEN, 
            userData.email, 'what', userData.email, null, 'uaepass', null, mapAttributes
        );
    }
    
     public class CB_Response {
        public String   access_token   { get; set; }
        public String   scope       { get; set; }
        public String   token_type     { get; set; }
        public Integer   expires_in     { get; set; }
    }
    public class UAEPassUser {
        
        public String   sub       { get; set; } 
        public String   email       { get; set; } 
        public String   gender       { get; set; }
        public String   nationalityEN   { get; set; }
        public String   firstnameEN   { get; set; }  
        public String   lastnameEN     { get; set; }  
        public String   fullnameEN     { get; set; }  
        public String   userType     { get; set; }  
        public String   uuid       { get; set; } 
        public String   mobile       { get; set; } 
    }

}