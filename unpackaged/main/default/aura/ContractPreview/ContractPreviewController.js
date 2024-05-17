({  
    doInit : function(component, event, helper) {
        
    },
    
    onForceLoad : function(component, event, helper) {
        
        let data = component.get("v.record");
        if(data){
            console.log(data.ETSALES_Opportunity__r.RecordType.DeveloperName)
            component.set("v.templateType",data.ETSALES_Opportunity__r.RecordType.DeveloperName);
            if(data.ETSALES_Opportunity__r.RecordType.DeveloperName=='ETSALES_Leasing'){
                component.set("v.vfUrl", '/apex/LeaseContractPreview?Id='+component.get("v.recordId"));
            }
            
            if(data.ETSALES_Opportunity__r.RecordType.DeveloperName=='ETSALES_Transportation'){
                component.set("v.vfUrl", '/apex/TransportationContractPreview?Id='+component.get("v.recordId"));
            }
            
            if(data.ETSALES_Opportunity__r.RecordType.DeveloperName=='ETSALES_Driving_School_B2B'){
                component.set("v.vfUrl", '/apex/SchoolTransportContractPreview?Id='+component.get("v.recordId"));
            }
		}
    },
    createContractDocHandler : function(component, event, helper) {
        
        try{
            var action = component.get('c.contractDocument');
            
            component.set("v.disabled",true);
            action.setParams({
                salesAgreementId:component.get("v.recordId"),
                recordTypeName:component.get("v.templateType"),
                
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                    let data =  response.getReturnValue();                
                    console.log(data)
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"success",
                        "message": "The Contract document has been created successfully."
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }
                else if (state === "ERROR") {
                     component.set("v.disabled",false);
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                            
                        }
                    } else {
                        console.log("Unknown error");
                        
                    }
                }
            }); 
            
            $A.enqueueAction(action);  
        }catch(e){
            console.log(e.message)
        }
    },
    
    
})