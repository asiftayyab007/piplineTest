public class ETIN_EmployeeFamilyObjValidation {
    
    public static void ContactValidation(list<ETIN_Employee_Family__c> conList){
        
        set<id> accIds = new set<id>();
        map<Id,Integer> empIdFamilySpouseCount = new map<Id,Integer>();
        map<Id,Integer> empIdFamilyChildCount = new map<Id,Integer>();
        
        for(ETIN_Employee_Family__c em : conList){
            
            accIds.add(em.Employee__c);
            system.debug('accIds'+accIds);
        }
        
        for(AggregateResult agg : [select count(id) co,Employee__c from ETIN_Employee_Family__c where Relation__c='Spouse' AND Employee__c=:accIds GROUP BY Employee__c ]){
            
            empIdFamilySpouseCount.put((Id)agg.get('Employee__c'),(Integer)agg.get('co'));
        }
        for(AggregateResult agg : [select count(id) co,Employee__c from ETIN_Employee_Family__c where Relation__c='Child' AND Employee__c=:accIds GROUP BY Employee__c ]){
            
            empIdFamilyChildCount.put((Id)agg.get('Employee__c'),(Integer)agg.get('co'));
        }
        
        
        for(ETIN_Employee_Family__c em : conList){
            
            //Added by Arunsarathy on 02.01.2023
            //The system should not accept to add family without the principal 
            List<ETIN_Insurance__c> insList = [select id,EmployeeAcc__c  from ETIN_Insurance__c where Relation__c='Principal' AND EmployeeAcc__c =:accIds ];
            if(insList.isEmpty()){
                em.addError('The system should not accept to add family without the principal  ');
            }
            
            if(empIdFamilySpouseCount.containsKey(em.Employee__c) && empIdFamilySpouseCount.get(em.Employee__c) > 0 && em.Relation__c=='Spouse' && trigger.Isinsert){
                
                em.Id.addError('You cannot create more than 1 spouse to one employee');
            }
            if(empIdFamilyChildCount.containsKey(em.Employee__c) && empIdFamilyChildCount.get(em.Employee__c) > 2 && em.Relation__c=='Child' && trigger.Isinsert){
                
                em.Id.addError('You cannot create more than 3 childs to one employee');
            }
            
            
        }
        
        
    }
    
}