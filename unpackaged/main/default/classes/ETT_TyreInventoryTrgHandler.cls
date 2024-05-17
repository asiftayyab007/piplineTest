/**
* Author: Janardhan
* Created Date: 28/11/2021
* TestClass:ETT_TyreCollectionDetailsInCCTest
* DESC: 
* */
public class ETT_TyreInventoryTrgHandler {
    
    
    public static void createInspectionCards(list<ETT_Tyre_Inventory__c> trgNew,Map<Id,ETT_Tyre_Inventory__c> trgoldMap){
        
        list<ETT_Inspection_Card__c> newInspeCardList = new list<ETT_Inspection_Card__c>();
        
        if(trigger.isInsert){
            for(ETT_Tyre_Inventory__c ti : trgNew){
                
                if(ti.ETT_Inventory_Status__c == 'Approved by Receptionist'){
                    
                    ETT_Inspection_Card__c ic = new ETT_Inspection_Card__c();
                    if(ti.Party_Type__c == 'Supplier'){
                        ic.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre Supplier').getRecordTypeId(); 
                    }else{
                        ic.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
                    }
                    
                    ic.ETT_Collection_Card__c = ti.ETT_Collection_Card__c;
                    ic.Tyre_Inventory__c = ti.Id;
                    ic.ETT_Country__c = ti.ETT_Country__c;
                    ic.ETT_Brand__c = ti.ETT_Brand__c;
                    ic.ETT_Pattern__c = ti.ETT_Pattern__c;
                    ic.ETT_Tyre_Size__c = ti.ETT_Tyre_Size_Master__c;
                    ic.ETT_Tyre_Serial_Number__c = ti.Serial_Number__c; 
                    ic.ETT_Tyre_Life__c =ti.ETT_Tyre_Life__c;
                    
                    newInspeCardList.add(ic);
                }
            }
        }
        if(trigger.isUpdate){
            for(ETT_Tyre_Inventory__c ti : trgNew){
                
                if(ti.ETT_Inventory_Status__c == 'Approved by Receptionist' && ti.ETT_Inventory_Status__c != trgoldMap.get(ti.Id).ETT_Inventory_Status__c){
                    
                    ETT_Inspection_Card__c ic = new ETT_Inspection_Card__c();
                    if(ti.Party_Type__c == 'Supplier'){
                        ic.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre Supplier').getRecordTypeId(); 
                    }else{
                        ic.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Refurbishing Services').getRecordTypeId();
                    }  
                    ic.ETT_Collection_Card__c = ti.ETT_Collection_Card__c;
                    ic.Tyre_Inventory__c = ti.Id;
                    ic.ETT_Country__c = ti.ETT_Country__c;
                    ic.ETT_Brand__c = ti.ETT_Brand__c;
                    ic.ETT_Pattern__c = ti.ETT_Pattern__c;
                    ic.ETT_Tyre_Size__c = ti.ETT_Tyre_Size_Master__c;
                    ic.ETT_Tyre_Serial_Number__c = ti.Serial_Number__c; 
                    ic.ETT_Tyre_Life__c =ti.ETT_Tyre_Life__c;
                    
                    newInspeCardList.add(ic);
                }
            }
            
        }
        insert newInspeCardList;
        
    }
    public static void updatePriceInfoOnInsert(list<ETT_Tyre_Inventory__c> trgNew){//Whie Tyre Inventory Inserting
        
        set<id> accIds = new set<id>();
        map<string,double> keyVsPrice = new  map<string,double>();
        map<string,String> keyVsPricInfoId = new  map<string,string>();
        list<ETT_Collection_Card__c> ccUpdateList = new list<ETT_Collection_Card__c>();    
        map<id,id> accIdVsPriceMasId = new map<id,id>();
        list<ETT_Pricing_Information__c> insertPirceInfoList = new  list<ETT_Pricing_Information__c>();
        Map<id,boolean> collCCIdVshasNewTyrewoPrice = new map<id,boolean>();
        map<string,id> keyVsTyreMasterId = new map<string,id>();
        map<string,id> newPricingInfoVsPriceMasId = new map<string,id>();//to remove duplicate pricing information
        
        for(ETT_Tyre_Inventory__c ti : trgNew){
            
            accIds.add(ti.ETT_Account__c);
        }
        for(ETT_Price_Master__c pm : [select id,ETT_Party_Name__c from ETT_Price_Master__c where ETT_Party_Name__c=:accIds]){
            
            accIdVsPriceMasId.put(pm.ETT_Party_Name__c,pm.Id);
        }       
        
        for(ETT_Tyre_Master__c tm : [select id,ETT_Brand_Name__c,ETT_Tyre_Size__c,ETT_Original_Pattern__c,ETT_Country_Name__c from ETT_Tyre_Master__c where recordType.Name='Approved']){
            string keyval = tm.ETT_Tyre_Size__c+'-'+tm.ETT_Brand_Name__c+'-'+tm.ETT_Original_Pattern__c+'-'+tm.ETT_Country_Name__c;
            keyVsTyreMasterId.put(keyval,tm.Id);
            
        }
        
        for(ETT_Pricing_Information__c pc : [select id,ETT_Price__c, ETT_Price__r.ETT_Party_Name__c,ETT_Tyre_Size__c,ETT_Brand__c,ETT_Pattern__c,ETT_Country_of_Origin__c,ETT_Purchase_Price__c from ETT_Pricing_Information__c where ETT_Price__r.ETT_Party_Name__c=:accIds]){
            string keyVal = pc.ETT_Tyre_Size__c+'-'+pc.ETT_Brand__c+'-'+pc.ETT_Pattern__c+'-'+pc.ETT_Country_of_Origin__c;
            keyVsPrice.put( keyVal,pc.ETT_Purchase_Price__c);
            keyVsPricInfoId.put(keyVal,pc.Id);
            
        }
        
        for(ETT_Tyre_Inventory__c ti : trgNew){
            
            string keyVal = ti.ETT_Tyre_Size_Master__c+'-'+ti.ETT_Brand__c+'-'+ti.ETT_Pattern__c+'-'+ti.ETT_Country__c;
            
            if(keyVsTyreMasterId.containskey(keyVal)){
                // system.debug('--val--'+keyVsTyreMasterId.get(keyVal));
                ti.ETT_Tyre_Master__c = keyVsTyreMasterId.get(keyVal);
            }
            
            if(ti.Party_Type__c == 'Supplier'){
                ti.Stockable__c = true;
                ti.Tyre_Type__c ='Used';
            }
            
            if(keyVsPrice.containsKey(keyVal)){
                ti.Pricing_Information__c = keyVsPricInfoId.get(keyVal);
                ti.Purchase_Price__c = keyVsPrice.get(keyVal);
                collCCIdVshasNewTyrewoPrice.put(ti.ETT_Collection_Card__c,false); 
            }else{
                ti.Pricing_Information__c = null;
                ti.Purchase_Price__c = 0;
                collCCIdVshasNewTyrewoPrice.put(ti.ETT_Collection_Card__c,true); 
                
                
                if(ti.ETT_Inventory_Status__c != 'Approved by Receptionist'){
                    
                    newPricingInfoVsPriceMasId.put(keyVal, accIdVsPriceMasId.get(ti.ETT_Account__c));
                    
                }
                system.debug('--'+newPricingInfoVsPriceMasId);
                
            }
            
        }
        
        //make list of new pricing information from set
        for(string st : newPricingInfoVsPriceMasId.keySet()){
            system.debug('-priceId-'+newPricingInfoVsPriceMasId.get(st));
            List<String> tempList = st.split('-');
            //Create Pricing information that is not there in supplier price master
            ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();	
            epi.ETT_Price__c = newPricingInfoVsPriceMasId.get(st);
            epi.ETT_Approval_Status__c ='New';
            epi.RecordTypeId =   Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
            epi.ETT_Brand__c = tempList[1];
            epi.ETT_Pattern__c = tempList[2];
            epi.ETT_Country_of_Origin__c = tempList[3];
            epi.ETT_Tyre_Size__c = tempList[0];
            epi.ETT_Purchase_Price__c = 0;
            insertPirceInfoList.add(epi);
        }
        for(id idval : collCCIdVshasNewTyrewoPrice.keyset() ){
            if(idval != null){
                ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
                cc.Id = idval;
                cc.HasTyresWithoutPrice__c = collCCIdVshasNewTyrewoPrice.get(idval);
                ccUpdateList.add(cc);   
            }
        }
        update ccUpdateList;
        insert insertPirceInfoList;
    }
    public static void updatePriceInUpdate(Map<Id,ETT_Tyre_Inventory__c> trgNewMap,Map<Id,ETT_Tyre_Inventory__c> trgOldMap){
       
            set<id> accIds = new set<id>();
            map<string,double> keyVsPrice = new  map<string,double>();
            map<string,String> keyVsPricInfoId = new  map<string,string>();
            list<ETT_Collection_Card__c> ccUpdateList = new list<ETT_Collection_Card__c>();
            map<id,id> accIdVsPriceMasId = new map<id,id>();
            list<ETT_Pricing_Information__c> insertPirceInfoList = new  list<ETT_Pricing_Information__c>();
            Map<id,boolean> collCCIdVshasNewTyrewoPrice = new map<id,boolean>();
            map<string,id> keyVsTyreMasterId = new map<string,id>();
            map<string,id> newPricingInfoVsPriceMasId = new map<string,id>();//to remove duplicate pricing information
            
            for(ETT_Tyre_Inventory__c ti : trgNewMap.values()){
                
                accIds.add(ti.ETT_Account__c);
            }
       
            for(ETT_Price_Master__c pm : [select id,ETT_Party_Name__c from ETT_Price_Master__c where ETT_Party_Name__c=:accIds]){
                
                accIdVsPriceMasId.put(pm.ETT_Party_Name__c,pm.Id);
            }
            for(ETT_Pricing_Information__c pc : [select id,ETT_Price__r.ETT_Party_Name__c,ETT_Price__c,ETT_Tyre_Size__c,ETT_Brand__c,ETT_Pattern__c,ETT_Country_of_Origin__c,ETT_Purchase_Price__c from ETT_Pricing_Information__c where ETT_Price__r.ETT_Party_Name__c=:accIds]){
                string keyVal = pc.ETT_Tyre_Size__c+'-'+pc.ETT_Brand__c+'-'+pc.ETT_Pattern__c+'-'+pc.ETT_Country_of_Origin__c;
                keyVsPrice.put( keyVal,pc.ETT_Purchase_Price__c);
                keyVsPricInfoId.put(keyVal,pc.Id);
                
            }
            for(ETT_Tyre_Master__c tm : [select id,ETT_Brand_Name__c,ETT_Tyre_Size__c,ETT_Original_Pattern__c,ETT_Country_Name__c from ETT_Tyre_Master__c where recordType.Name='Approved']){
                string keyval = tm.ETT_Tyre_Size__c+'-'+tm.ETT_Brand_Name__c+'-'+tm.ETT_Original_Pattern__c+'-'+tm.ETT_Country_Name__c;
                keyVsTyreMasterId.put(keyval,tm.Id);
                
            }
       
            for(ETT_Tyre_Inventory__c ti : trgNewMap.values()){
                
                
                if(ti.ETT_Tyre_Size_Master__c!= trgOldMap.get(ti.id).ETT_Tyre_Size_Master__c || ti.ETT_Pattern__c!= trgOldMap.get(ti.id).ETT_Pattern__c ||
                   ti.ETT_Brand__c!= trgOldMap.get(ti.id).ETT_Brand__c || ti.ETT_Country__c!= trgOldMap.get(ti.id).ETT_Country__c || ti.Purchase_Price__c == 0 || ti.Pricing_Information__c == null){
                       
                       string keyVal = ti.ETT_Tyre_Size_Master__c+'-'+ti.ETT_Brand__c+'-'+ti.ETT_Pattern__c+'-'+ti.ETT_Country__c;
                       if(keyVsTyreMasterId.containskey(keyVal)){
                           ti.ETT_Tyre_Master__c = keyVsTyreMasterId.get(keyVal);
                       }
                       
                       if(keyVsPrice.containsKey(keyVal)){
                           ti.Pricing_Information__c = keyVsPricInfoId.get(keyVal);
                           ti.Purchase_Price__c = keyVsPrice.get(keyVal);
                           collCCIdVshasNewTyrewoPrice.put(ti.ETT_Collection_Card__c,false); 
                           
                       }else{
                           ti.Pricing_Information__c = null;
                           ti.Purchase_Price__c = 0;
                           collCCIdVshasNewTyrewoPrice.put(ti.ETT_Collection_Card__c,true); 
                           
                           newPricingInfoVsPriceMasId.put(keyVal, accIdVsPriceMasId.get(ti.ETT_Account__c));
                           
                       }
                       
                   }
                
            }
              
            //make list of new pricing information from set
            for(string st : newPricingInfoVsPriceMasId.keySet()){
                
                List<String> tempList = st.split('-');
                //Create Pricing information that is not there in supplier price master
                ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();	
                epi.ETT_Price__c = newPricingInfoVsPriceMasId.get(st);
                epi.ETT_Approval_Status__c ='New';
                epi.RecordTypeId =   Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
                epi.ETT_Brand__c = tempList[1];
                epi.ETT_Pattern__c = tempList[2];
                epi.ETT_Country_of_Origin__c = tempList[3];
                epi.ETT_Tyre_Size__c = tempList[0];
                epi.ETT_Purchase_Price__c = 0;
                insertPirceInfoList.add(epi);
            }
            for(id idval : collCCIdVshasNewTyrewoPrice.keyset() ){
                ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
                if(idval != null){
                    cc.Id = idval;
                    cc.HasTyresWithoutPrice__c = collCCIdVshasNewTyrewoPrice.get(idval);
                    ccUpdateList.add(cc);   
                }
            }
            if(ccUpdateList.size()>0 && ccUpdateList != null){
                update ccUpdateList;
            }
            
            insert insertPirceInfoList;
        
    }
    
    public static void updateCollCard(list<ETT_Tyre_Inventory__c> trgNew,Map<Id,ETT_Tyre_Inventory__c> trgOldMap){
        
        Set<Id> collCardIdset = new Set<Id>();
        
        if(Trigger.isInsert || Trigger.isUndelete){
            for(ETT_Tyre_Inventory__c tyre :trgNew)
            {
                collCardIdset.add(tyre.ETT_Collection_Card__c);
            }
        }
        if(Trigger.isUpdate){
            for(ETT_Tyre_Inventory__c tyre :trgNew)
            {
                if(tyre.ETT_Collection_Card__c !=trgOldMap.get(tyre.Id).ETT_Collection_Card__c){
                    collCardIdset.add(tyre.ETT_Collection_Card__c);  
                }
            }
            
        }
        
        if(Trigger.isDelete){
            
            for(ETT_Tyre_Inventory__c tyre :trgOldMap.values())
            {
                collCardIdset.add(tyre.ETT_Collection_Card__c);
            }
        }
        
        list<ETT_Collection_Card__c> ccList = [select id,name,(select id from Tyre_Inventory__r) from ETT_Collection_Card__c where Id=:collCardIdset];
        
        for(ETT_Collection_Card__c cc : ccList){
            
            cc.No_of_Tyres__c = cc.Tyre_Inventory__r.size();
        }
        update ccList;
    }
    
}