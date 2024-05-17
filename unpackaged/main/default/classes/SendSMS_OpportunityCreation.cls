public class SendSMS_OpportunityCreation {
    
    @InvocableMethod 
    public static void sendSMStoOpportunityOwner(list<Id> smsRelRecIds){
        
        for(Opportunity le : [Select id,Owner.name,Name from Opportunity where Id=:smsRelRecIds]){
             string composedMsg ='';                
                composedMsg = 'Dear Ali, following Opportunity '+le.Name+' has been assigned to you.';
            
            
            //if(le.owner.Phone != null && le.owner.Phone.length() >= 9){
                system.debug('SMSAPI');
                //sendSMSAPI(le.owner.Phone,composedMsg,system.label.Moto_SMS_SenderID);
            sendSMSAPI('547738631',composedMsg,'AD-EMOTO');
            //}            
        }
        
    }
    
    @future(callout = true)
    public static void sendSMSAPI(String mobNumber,String msg,String SenderId){
        
        string mobile = '';
        string finalmsg = msg.replace(' ','%20');   
        
        //Check Mobile Number Format
        mobile = mobNumber.replaceAll('[A-Za-z]', '');//remove any alphabets
        mobile = '971'+mobNumber.right(9);//It works for UAE Country only
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(system.label.Moto_SMS_EndpointURL+'senderid='+SenderId+'&mobileno='+mobile+'&msgtext='+finalmsg+'&priority=High&CountryCode=ALL');
        request.setMethod('GET');
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        system.debug(response);
        
    }
    
}