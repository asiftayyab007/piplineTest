/*
* Author:Janardhan
* CreatedDate:24/11/2021
* TestClass: ETT_TyreCollectionDetailsInCCTest
* Desc: Removed approval process concept,bcz unable to remove approve/reject btns from approval histroy
* */
public class ETT_TyreCollectionDetailsInCC {
    
    @AuraEnabled
    public static list<ETT_Tyre_Inventory__c> getTyreInventoryDetials(string recordId){
        
        return [select Id,ETT_Tyre_Size_Master__c,ETT_Tyre_Size_Master__r.Name,Temp_Size_Name__c,ETT_Brand__c,ETT_Brand__r.Name,Temp_Brand_Name__c,ETT_Pattern__c,ETT_Pattern__r.Name,Temp_Pattern_Name__c,ETT_Country__c,
                ETT_Country__r.Name,Temp_Country_Name__c, ETT_Tyre_Life__c,Serial_Number__c,Job_Type__c,Claim_Process__c,Process_Type__c,Remarks__c from ETT_Tyre_Inventory__c where ETT_Collection_Card__c=:recordId];
    }
    @AuraEnabled
    public static list<ETT_StagingNewTyreCollection__c> getStagTyreDetials(string recordId){
        return [select Id,Size_Name__c,Brand_Name__c,Pattern_Name__c,Country_Name__c,Tyre_Serial_No__c,Job_Type__c,Process_Type__c from ETT_StagingNewTyreCollection__c where Collection_Card__c=:recordId];
    }
    
    @AuraEnabled
    public static user getUserInfo(){
        return [Select id,Name,profile.Name from user where Id=:userinfo.getUserId()];
    }
    
    @AuraEnabled
    public static list<ETT_Tyre_Master__c> getTyreMasterDetails(string recordId){
        return [select id,ETT_Status__c,Name,ETT_Tyre_Size__r.Name,ETT_Brand_Name__r.Name,ETT_Original_Pattern__r.Name,ETT_Country_Name__r.Name from ETT_Tyre_Master__c where recordType.Name='Draft' AND ETT_Collection_Card__c=:recordId];
    }   
    
    @AuraEnabled
    public static list<ETT_Pricing_Information__c> getPricingConfirmDetails(string recordId){
        Id accId = [select id,ETT_Accounts__c from ETT_Collection_Card__c where id=:recordId].ETT_Accounts__c;
        Id priceMasterId = [select id from ETT_Price_Master__c where ETT_Party_Name__c=:accId].Id;
        
        return [select id,ETT_Tyre_Size__r.Name,ETT_Brand__r.Name,ETT_Country_of_Origin__r.Name,ETT_Pattern__r.Name,ETT_Minimum_Price__c,ETT_Maximum_Price__c,ETT_Purchase_Price__c from ETT_Pricing_Information__c where (ETT_Approval_Status__c='New' OR ETT_Approval_Status__c='In Progress') AND ETT_Price__c=:priceMasterId];
    }
    
    
    @AuraEnabled
    public static void updateTyreMasterDetails(list<ETT_Tyre_Master__c> tyreList,string recordId){
        
        Savepoint sp = Database.setSavepoint();
        list<ETT_Pricing_Information__c> newPriceConList = new list<ETT_Pricing_Information__c>(); 
        Id accId = [select id,ETT_Accounts__c from ETT_Collection_Card__c where id=:recordId].ETT_Accounts__c;
        Id priceMasterId = [select id from ETT_Price_Master__c where ETT_Party_Name__c=:accId].Id;
        set<id> brandIds = new set<id>();
        set<id> sizeIds = new set<id>();
        set<id> patternIds = new set<id>();
        set<id> countryIds = new set<id>();
        list<ETT_Brand_Master__c> brandMasterUpdate = new list<ETT_Brand_Master__c>();
        list<ETT_Tyre_Size_Master__c> tyreMasterUpdate = new list<ETT_Tyre_Size_Master__c>();
        list<ETT_Pattern_Master__c> patterMasterUpdate = new  list<ETT_Pattern_Master__c>();
        list<ETT_Country_Master__c> countryMasterUpdate = new  list<ETT_Country_Master__c>();
        
        for(ETT_Tyre_Master__c tm : tyreList){
            
            tm.recordTypeId = Schema.SObjectType.ETT_Tyre_Master__c.getRecordTypeInfosByName().get('Approved').getRecordTypeId();
            ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();	
            epi.ETT_Price__c = priceMasterId;
            epi.ETT_Approval_Status__c ='New';
            epi.RecordTypeId =   Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
            epi.ETT_Brand__c = tm.ETT_Brand_Name__c;
            epi.ETT_Pattern__c = tm.ETT_Original_Pattern__c;
            epi.ETT_Country_of_Origin__c = tm.ETT_Country_Name__c;
            epi.ETT_Tyre_Size__c = tm.ETT_Tyre_Size__c;
            epi.ETT_Purchase_Price__c = 0;
            newPriceConList.add(epi);
            brandIds.add(tm.ETT_Brand_Name__c);
            sizeIds.add(tm.ETT_Tyre_Size__c);
            patternIds.add(tm.ETT_Original_Pattern__c);
            countryIds.add(tm.ETT_Country_Name__c);
        }
        for(string str : brandIds){
            
            ETT_Brand_Master__c br = new ETT_Brand_Master__c();
            br.Id = str;
            br.ETT_Status__c = true;
            brandMasterUpdate.add(br);
        }
         for(string str : sizeIds){
            
            ETT_Tyre_Size_Master__c tr = new ETT_Tyre_Size_Master__c();
            tr.Id = str;
            tr.ETT_Status__c = true;
            tyreMasterUpdate.add(tr);
        }
         for(string str : patternIds){
            
            ETT_Pattern_Master__c tr = new ETT_Pattern_Master__c();
            tr.Id = str;
            tr.ETT_Status__c = true;
            patterMasterUpdate.add(tr);
        }
        for(string str : countryIds){
            
            ETT_Country_Master__c tr = new ETT_Country_Master__c();
            tr.Id = str;
            tr.ETT_Status__c = true;
            countryMasterUpdate.add(tr);
        }
        
        try{
           
            update tyreList;
            insert newPriceConList;
            update countryMasterUpdate;
            update patterMasterUpdate;
            update tyreMasterUpdate;
            update brandMasterUpdate;
            
        }catch(Exception e) {
            Database.rollback(sp);
            system.debug('---ca'+e.getCause());
            system.debug('----Line'+e.getLineNumber());
            system.debug('---Trac-'+e.getStackTraceString());
            system.debug('---Type-'+e.getTypeName());
            throw new AuraHandledException(e.getMessage());   
            
        }
        
    }
    @AuraEnabled
    public static void updatePricingConfirmDetails(list<ETT_Pricing_Information__c> priceList,string recordId){
        
        User objUser = [SELECT Id,Name,Username,Profile.Name FROM User where Id = :UserInfo.getUserId()]; 
        Id AccId  = [select id,ETT_Accounts__c from ETT_Collection_Card__c where id=:recordId].ETT_Accounts__c; 
        
        list<ETT_Tyre_Inventory__c> newTyreInvList = new list<ETT_Tyre_Inventory__c>();
        
        string remarks ='';
        Savepoint sp = Database.setSavepoint();
        try{
            for(ETT_Pricing_Information__c pr: priceList){
                
                if(objUser.Profile.Name=='ETT_Head of Operations' || objUser.Profile.Name == 'System Administrator'){ 
                    pr.ETT_Buying_Price_Comments__c ='Updated by HOO';
                }else {
                    pr.ETT_Buying_Price_Comments__c ='Updated by FM';
                }
                         
            }
            update priceList;
           
            
            if(objUser.Profile.Name=='ETT_Head of Operations' || objUser.Profile.Name == 'System Administrator'){
                
                ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
                cc.Id = recordId;
                cc.Approval_Status__c='Pending with FM';
                
                update cc;
              /*  //approval process
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments('Approved by HOO');
                req.setAction('Approve');
                Id workItemId  = getWorkItemId(recordId); //CollecCard Id
                req.setWorkitemId(workItemId);
                Approval.ProcessResult result =  Approval.process(req);*/
                
            }
            
            if(objUser.Profile.Name=='ETT_Factory Manager'  || objUser.Profile.Name == 'System Administrator'){
                
             
                for(ETT_StagingNewTyreCollection__c stg : [select id,Job_Type__c,Process_Type__c,Tyre_Serial_No__c,Tyre_Life__c,Brand__c,Pattern__c,Tyre_Size__c,Country__c,Collection_Card__c from ETT_StagingNewTyreCollection__c where Collection_Card__c=:recordId]){
                    
                    ETT_Tyre_Inventory__c tyre = new ETT_Tyre_Inventory__c();
                    tyre.ETT_Collection_Card__c = stg.Collection_Card__c;
                    tyre.ETT_Account__c = AccId;
                    tyre.ETT_Brand__c = stg.Brand__c;
                    tyre.ETT_Country__c = stg.Country__c;
                    tyre.ETT_Tyre_Size_Master__c = stg.Tyre_Size__c;
                    tyre.ETT_Pattern__c = stg.Pattern__c;
                    tyre.ETT_Inventory_Status__c ='Approved by Receptionist';
                    tyre.Process_Type__c = stg.Process_Type__c;
                    tyre.ETT_Tyre_Life__c = stg.Tyre_Life__c;
                    tyre.Serial_Number__c = stg.Tyre_Serial_No__c;
                    tyre.Job_Type__c = stg.Job_Type__c;
                    tyre.Stockable__c = true;
                    tyre.Tyre_Type__c = 'Used';
                    
                    newTyreInvList.add(tyre);
                }
                
                insert newTyreInvList;
                
                list<ETT_Tyre_Inventory__c> updateTyreInv = new list<ETT_Tyre_Inventory__c>();
                for(ETT_Tyre_Inventory__c ty : [select Id,Name,ETT_Inventory_Status__c from ETT_Tyre_Inventory__c where ETT_Collection_Card__c=:recordId AND ETT_Inventory_Status__c='Draft' ]){
                    
                    ty.ETT_Inventory_Status__c ='Approved by Receptionist';
                    updateTyreInv.add(ty);
                }
                update updateTyreInv;
                
                ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
                cc.Id = recordId;
                cc.Approval_Status__c='Approved';
                cc.ETT_Collection_Status__c ='Accepted';
                
                update cc;
                
                //approval process
               /* Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments('Approved by FM');
                req.setAction('Approve');
                Id workItemId  = getWorkItemId(recordId); //CollecCard Id
                req.setWorkitemId(workItemId);
                Approval.ProcessResult result =  Approval.process(req);*/
            }
            
          
            
        }catch(Exception e) {
            Database.rollback(sp);
            throw new AuraHandledException(e.getMessage());   
            
        }
        
    }
    
    @AuraEnabled
    public static Map<String, String> getselectOptions(string fld) {
        
        List < String > allOpts = new list < String > ();
        Map<String, String> options = new Map<String, String>();
        
        Schema.sObjectType objType = ETT_Tyre_Inventory__c.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
            options.put(a.getValue(), a.getLabel());
        }
        
        allOpts.sort();
        System.debug(options);
        return options;
    }
    @AuraEnabled
    public static void updateCollectionCard(string recordId,String fieldName){
        
        ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
        cc.Id = recordId;
        if(fieldName == 'ETT_Check_In__c'){
            cc.ETT_Check_In__c = system.now();
        }
        if(fieldName == 'ETT_Check_Out__c'){
            cc.ETT_Check_Out__c = system.now();
            cc.Approval_Status__c = 'Pending with Reception';
            cc.ETT_Collection_Status__c ='Accepted';
        }
        
        try { 
           
              update cc;
              
               /* Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Collection Team request');
                req1.setObjectId(recordId);
                req1.setSubmitterId(userinfo.getuserid());
                
                Approval.ProcessResult result = Approval.process(req1);*/
         
            
        }catch(Exception e) {
            throw new AuraHandledException( e.getMessage());    
        }
    }
    @AuraEnabled
    public static void insertNewStagNewTyreInven(list<ETT_Tyre_Inventory__c> newTyreInvent,List<ETT_StagingNewTyreCollection__c> stagTyre,List<ETT_StagingNewTyreCollection__c> updateStagTyre,list<ETT_Tyre_Inventory__c> updateTyreInventory,Id recordId){
        //ETT_StagingNewTyreCollection__c will have all the tyres not we have in tyremaster
        ETT_Collection_Card__c cc  = [select id,ETT_Accounts__c,ETT_Accounts__r.Party_Type__c,ETT_Opportunity__c from ETT_Collection_Card__c where id=:recordId ]; 
        
        list<ETT_Price_Master__c> priceMas = [select id,ETT_Party_Name__c from ETT_Price_Master__c where ETT_Party_Name__c=:cc.ETT_Accounts__c];
         
      
        
        Savepoint sp = Database.setSavepoint();
        
        try{
            if(priceMas.size() == 0){
                
                ETT_Price_Master__c ep = new ETT_Price_Master__c();
                ep.Opportunity__c = cc.ETT_Opportunity__c;
                ep.ETT_Party_Name__c = cc.ETT_Accounts__c;
                // ep.RecordTypeId = Schema.SObjectType.ETT_Price_Master__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
                ep.ETT_Price_Information_External_Id__c =  cc.ETT_Accounts__c+cc.ETT_Accounts__r.Party_Type__c;
                ep.ETT_Party_Type__c = cc.ETT_Accounts__r.Party_Type__c;
                insert ep;
            }
            
            if(updateStagTyre.size()>0 && updateStagTyre != null){
                
                update updateStagTyre;
            } 
            if(updateTyreInventory.size()>0 && updateTyreInventory != null){
                
                update updateTyreInventory;
            } 
            
            if(newTyreInvent.size()>0 && newTyreInvent != null){
                for(ETT_Tyre_Inventory__c tin : newTyreInvent){
                    if(cc.ETT_Accounts__c != null)
                        tin.ETT_Account__c = cc.ETT_Accounts__c;
                }
                
                insert newTyreInvent;
            }
            if(stagTyre.size()>0 && stagTyre != null){
                
                insert stagTyre;
            }
        }catch(Exception e) {
            Database.rollback(sp);
            throw new AuraHandledException(e.getMessage());   
            
        }
        
    }
    
    @AuraEnabled
    public static void deleteRecord(string recordId){
        Database.delete(recordId);
    }
    
    
    @AuraEnabled
    public static void approvalProcess (string recordId){ //ByClicking Approve by Recp
        
        User objUser = [SELECT Id,Name,Username,Profile.Name FROM User where Id = :UserInfo.getUserId()];
        boolean hasTyreWOPrice = [Select id,HasTyresWithoutPrice__c from ETT_Collection_Card__c where id=:recordId].HasTyresWithoutPrice__c;
        
        if(objUser.Profile.Name == 'ETT_Receptionist' || objUser.Profile.Name == 'System Administrator'){
            
            ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
            cc.Id = recordId;
            
            if(hasTyreWOPrice ==  false){
                //Get all draft tyre details
               cc.Approval_Status__c = 'Approved';
                
                list<ETT_Tyre_Inventory__c> updateTyreInv = new list<ETT_Tyre_Inventory__c>();
                for(ETT_Tyre_Inventory__c ty : [select Id,Name,ETT_Inventory_Status__c from ETT_Tyre_Inventory__c where ETT_Collection_Card__c=:recordId AND ETT_Inventory_Status__c='Draft' ]){
                    
                    ty.ETT_Inventory_Status__c ='Approved by Receptionist';
                    updateTyreInv.add(ty);
                }
                
                update updateTyreInv;
            }else{
                cc.Approval_Status__c = 'Pending with HOO';
            }
           
           update cc;
            
            //approval process
           /* Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Approved by Receptionist');
            req.setAction('Approve');
            Id workItemId  = getWorkItemId(recordId); //CollecCard Id
            req.setWorkitemId(workItemId);
            Approval.ProcessResult result =  Approval.process(req);*/
            
            
        }
        
    }  
   /* public static Id getWorkItemId(Id targetObjectId) {
        
        Id retVal = null;
        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p 
                                                 where p.ProcessInstance.TargetObjectId =: targetObjectId])
        {
            retVal  =  workItem.Id;
        }
        return retVal;
    }*/
}