({
    getSObjectName: function(component,RecordId,helper){
        var action = component.get("c.getSObjectNameFromRecordId");
        action.setParams({"RecordId": String(RecordId)});
        component.set('v.loaded', !component.get('v.loaded'));
        action.setCallback(this, function(response){
            console.log('getSObjectName: ',response.getState());
            if(response.getState() == 'SUCCESS'){
                component.set('v.loaded', !component.get('v.loaded'));
                var result = response.getReturnValue();
                console.log('result in doinit of wrapper : ' + JSON.stringify(result));
                if(result != null){
                    
                    if(result == 'Opportunity'){
                        component.set("v.opportunityRecordId",RecordId);
                    }else if(result == 'ET_Pricing_Service_Request__c'){
                        component.set("v.serviceRequestRecordId",RecordId);
                        helper.getServiceReqRelatedInfoHelper(component,RecordId,helper);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getServiceReqRelatedInfoHelper : function(component,RecordId,helper){
        var action = component.get("c.getServiceRelatedInfo");
        action.setParams({"serviceRequestId": RecordId});
        component.set('v.loaded', !component.get('v.loaded'));
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                component.set('v.loaded', !component.get('v.loaded'));
                var result = response.getReturnValue();
                console.log('service Request related info in main Form : ' + JSON.stringify(result));
                if(result != null){
                    component.set("v.quoteId",result.quoteId);
                    component.set("v.totalProjectQuoteId",result.totalProjectQuoteId);
                    component.set("v.opportunityStatus",result.opportunityStatus);
                    component.set("v.quotationStatus",result.quotationStatus);
                    component.set("v.changesAllowedInQuotation",result.changesAllowedInQuotation);
                    console.log('opportunityStatus = '+ result.opportunityStatus);
                }
            }
        });
        $A.enqueueAction(action);
    },
    profilePermissions : function(component, event, helper){
        var action = component.get("c.getProfileInfo");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('getUserPermissions = ' + JSON.stringify(response.getReturnValue()));
                var resObj = response.getReturnValue() ;
                if(resObj.Name=='System Administrator'){ 
                    component.set("v.isSysAdmin" , true);
                    console.log('profile name__q'+resObj.Name);
                }   
            }
            else if (state === "INCOMPLETE") {
                console.log('Network Issue or Server Down');
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message + "Method :" + 'UserPermissions');
                            var toastReference = $A.get("e.force:showToast");
                            toastReference.setParams({
                                "type":"Error",
                                "title":"Error",
                                "message":"Internal Server Error. Please Contact System Admin.",
                                "mode":"sticky"
                            });
                            toastReference.fire();
                            // alert('Internal Server Error. Please Contact System Admin.');
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    
})