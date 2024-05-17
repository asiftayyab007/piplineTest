/* Author: Janardhan
 * Class: ETT_JobCardCloseTrgHelper
 * CreatedDate: 14/11/2021
 * Desc:
 * TestClass:ETT_JobCardCloseTrgHelperTest
 * */
public class ETT_JobCardCloseTrgHelper {
    
    public static void updateToolsItemMaster(Map<id,ETT_Job_Card_Close__c> trgNewMap,Map<id,ETT_Job_Card_Close__c> trgOldMap){
        
        set<Id> approvedJobCardIds = new set<Id>();
        Map<Id,Decimal> toolMasIDVsIssuedQty = new  Map<Id,Decimal>();
        List<ETT_Tools_Master__c> updatedToolsMaster = new  List<ETT_Tools_Master__c>();
        
        for(ETT_Job_Card_Close__c jc : trgNewMap.values()){
            
            if(jc.Status__c != trgOldMap.get(jc.Id).Status__c && jc.Status__c == 'Approved'){
                
                approvedJobCardIds.add(jc.Id);
            }
        }
        
        for(ETT_Job_Card_Close_Lines__c jcl : [select id,Item_Name__c,Issued_Quantity__c from ETT_Job_Card_Close_Lines__c where Issued_Quantity__c!=null AND Job_Card_Close__c=:approvedJobCardIds]){
            
            if(!toolMasIDVsIssuedQty.containsKey(jcl.Item_Name__c) ){
                toolMasIDVsIssuedQty.put(jcl.Item_Name__c,jcl.Issued_Quantity__c);
            }else{
               if(jcl.Issued_Quantity__c!=null)
               toolMasIDVsIssuedQty.put(jcl.Item_Name__c,toolMasIDVsIssuedQty.get(jcl.Item_Name__c)+jcl.Issued_Quantity__c);
            }
            
        }
        
        for(ETT_Tools_Master__c tool : [select id,ETT_Allocated_Units__c from ETT_Tools_Master__c where Id=:toolMasIDVsIssuedQty.keyset()]){
            
            tool.ETT_Allocated_Units__c = tool.ETT_Allocated_Units__c - toolMasIDVsIssuedQty.get(tool.id);
            
            updatedToolsMaster.add(tool);
        }
        
        update updatedToolsMaster;
        
    }

}