/**Author:Janardhan
 * Desc: If appointment approved creating Collection cards
 * CreatedDate: 22/11/2021
 * TestClass:ETT_TyreCollApptTrgHelperTest
 * 
 * */
public class ETT_TyreCollApptTrgHelper {
    
    
    public static void createCollCard(Map<id,Tyre_Collection_Appointment__c> newMap,Map<id,Tyre_Collection_Appointment__c> oldMap)  {
        
        list<ETT_Collection_Card__c> newCollCardList = new  list<ETT_Collection_Card__c>();
        
        for(Tyre_Collection_Appointment__c tc : newMap.values()){
            
            if(tc.Status__c == 'Approved' && tc.Appointment_Type__c =='Collection' && tc.Status__c != oldMap.get(tc.Id).Status__c){
                
                ETT_Collection_Card__c objCollCard = new ETT_Collection_Card__c();
                
                objCollCard.ETT_Accounts__c = tc.Account__c;
                objCollCard.ETT_Opportunity__c = tc.Opportunity__c;
                objCollCard.Collection_Appointment__c = tc.id;
                objCollCard.ETT_Collection_Status__c = 'Scheduled';
                objCollCard.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre Supplier').getRecordTypeId(); 
				
                newCollCardList.add(objCollCard);
            }            
            
        }        
        
        if(newCollCardList.size()>0 && newCollCardList != null){
            
            insert newCollCardList;
        }
        
    }

}