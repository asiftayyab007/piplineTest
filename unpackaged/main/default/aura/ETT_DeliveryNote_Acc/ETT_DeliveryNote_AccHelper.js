({
	getInsCardDetails : function(component, event, helper) {
		
        var action = component.get('c.getInsCards');
      
        action.setParams({
            recordId : component.get("v.recordId")            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
               let data = response.getReturnValue();
               let collCardSet = new Set();
                data.forEach(function(item){
                    item.isChecked = false;
                    item.link = '/'+item.Id;
                    collCardSet.add(item.ETT_Collection_Card__r.Name);
                });
                component.set("v.insCardList",data);
                    component.set("v.tempCollCards",[...collCardSet].join(','));
                //console.log(component.get("v.insCardList"))
            }
            else if (state === "ERROR") {
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
	},
    
    getContactDetails: function(component, event, helper) {
		
        var action = component.get('c.getConRelatedAcc');
      
        action.setParams({
            recordId : component.get("v.recordId")            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
               let data = response.getReturnValue();
                
              component.set("v.tempName",data[0].Name); 
              component.set("v.tempMobNum",data[0].MobilePhone); 
              //console.log(data[0].Account.BillingAddress)
              let address = data[0].Account.BillingAddress.street+'\n'+data[0].Account.BillingAddress.city+'\n'+data[0].Account.BillingAddress.country;
              component.set("v.address",address);
            }
            else if (state === "ERROR") {
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
	},
    
    showErrorToast : function(params) {
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
})