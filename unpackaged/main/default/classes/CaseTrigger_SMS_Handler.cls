/**************
*Handler for sending SMS when case is closed or created
*Test Class: CaseTrigger_SMS_Handler_Test
Desc: Modified by Janardhan:28-10-21 : Send sms all cases when case status is Solution Completed
*************/
public class CaseTrigger_SMS_Handler{
    //Method to send SMS when Case created and closed
    public static void sendSMSNotification(List<Case> newCases,Map<Id,Case>newMap, Map<Id,Case>oldMap,Boolean isInsert){
     system.debug('Case trigger after Update Send sms on case status -Solution Completed');

        Map<String,String> mapAccountCaseID = new Map<String,String>();
        Map<String,String> mapContactCaseID = new Map<String,String>();
        
        for(Case c : newCases){    
           // If (c.Origin == 'Phone Call'){
                if(isInsert){ 
                    mapAccountCaseID.put(c.AccountId,c.Id);
                    if(c.ContactId != NULL)
                        mapContactCaseID.put(c.ContactId,c.Id);
                }else{
                    if(newMap.get(c.Id).Status != oldMap.get(c.Id).Status &&  newMap.get(c.Id).Status == 'Solution Completed'){
                          mapAccountCaseID.put(c.AccountId,c.Id);
                        if(c.ContactId != NULL)
                            mapContactCaseID.put(c.ContactId,c.Id);   
                    }
                }
            
        }
        
        Map<String,String> mapCaseMobileNumber = getCaseContactNumbers(mapAccountCaseID,mapContactCaseID);
        system.debug('--caseVsMobNo.--'+mapCaseMobileNumber);
        for(String cs :mapCaseMobileNumber.keySet()){    
            String templateName = (isInsert ? 'ET_SMS_Template_For_Case_Creation': 'ET_SMS_Template_For_Case_Closed');
            system.debug('--msg--Params--'+cs+'-'+mapCaseMobileNumber.get(cs)+'-'+templateName);
            ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
         }
    }
    
    Public static Map<String,String> getCaseContactNumbers(Map<String,String> mapAccountCaseID,Map<String,String> mapContactCaseID){
        Map<String,String> mapCaseMobileNumber = new Map<String,String>();
        for(Contact c: [SELECT ID,AccountId,ETSALES_Mob_Country_Code__c,MobilePhone FROM Contact WHERE Id=: mapContactCaseID.keySet() AND MobilePhone != NULL]){
               String caseID = mapContactCaseID.get(c.Id);
               mapCaseMobileNumber.put(caseID,formatMobileNumber(c.MobilePhone,c.ETSALES_Mob_Country_Code__c)); 
               if(mapAccountCaseID.containsKey(c.AccountID))
                    mapAccountCaseID.remove(c.AccountID);
        }
        if(!mapAccountCaseID.isEmpty()){
            for(Account a :[SELECT ID,PersonMobilePhone,ETSALES_Mob_Country_Code__pc FROM Account WHERE ID=: mapAccountCaseID.keySet() AND PersonMobilePhone != NULL])
            {
                String caseID = mapAccountCaseID.get(a.Id);
                mapCaseMobileNumber.put(caseID,formatMobileNumber(a.PersonMobilePhone,a.ETSALES_Mob_Country_Code__pc)); 
            }
        }
        return mapCaseMobileNumber;
    }
    
    Public Static String formatMobileNumber(String mobileNumber, String CountryCode){
        String mobile;
        if(mobileNumber.contains('+'))
            mobile =  mobileNumber.replaceAll('[A-Za-z]', '');//remove alphabets if present
        else
            mobile =  (CountryCode +''+ mobileNumber).replaceAll('[A-Za-z]', ''); //remove alphabets(country name) if present
        if(mobile.contains('(')){
             mobile = mobile.replace('(',''); 
             mobile  = mobile.replace(')','');    
        }     
        return mobile;
    }
}