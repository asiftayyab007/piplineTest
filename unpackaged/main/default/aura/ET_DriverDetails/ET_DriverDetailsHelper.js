({
    getDriverDetails: function(component, event, helper) {
        var action = component.get("c.getPicklistvalues");
        action.setParams({
                'objectName': "ET_Work_force__c",
                'field_apinames': component.get("v.picklistFields"),
                'workforceType': 'Driver'
            });
        component.set('v.loaded', !component.get('v.loaded'));
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                component.set('v.loaded', !component.get('v.loaded'));
                var response=a.getReturnValue();
                if(response!=null && response!= undefined){
                if(response.workforceCategory!=null && response.workforceCategory!= undefined){
                component.set("v.driverCategory",response.workforceCategory);
                }else{
                    console.log('driverCategory is null');  
                }
                    
				if(response.serviceTypes!=null && response.serviceTypes!=undefined){
                    component.set("v.serviceTypes",response.serviceTypes);
                }
                if(response.Types!=null && response.Types!=undefined){
                    component.set("v.Types",response.Types);
                    // set default Value for Type field
                    component.set("v.workForceRecord.Type__c",'Main');
                }    
                if(response.specRequirement!=null && response.specRequirement!= undefined){
                component.set("v.specRequirement",response.specRequirement);
                }else{
                    console.log('specRequirement is null');  
                }
                if(response.contractPeriods!=null && response.contractPeriods!=undefined){
                    var options=[];
                        for(var period of response.contractPeriods){
                            /*var contract =new Map();
                            contract['label']=period;
                            contract['value']=period;
                            options.push(contract);*/
                            options.push({"label" : period, "value" : period});
                        }  
                        component.set("v.contractPeriods",options);
                    }else{
                        console.log('contractPeriods is null');
                    }
                    if(response.contractTypes!=null && response.contractTypes!=undefined){
                        console.log("v.contractTypes -->"+response.contractTypes);
                        component.set("v.contractTypes",response.contractTypes);
                    }else{
                        console.log('contractTypes is null');
                    }
                    if(response.serviceEmirates!=null && response.serviceEmirates!=undefined){
                        component.set("v.serviceEmirates",response.serviceEmirates);
                    }else{
                        console.log('serviceEmirates is null');
                    }  
                    if(response.pricingMethods!=null && response.pricingMethods!=undefined){
                        component.set("v.pricingMethods",response.pricingMethods);
                    }else{
                        console.log('pricingMethods is null');
                    } 
                    if(response.pricingMethodAndDependentTypeMap!=null && response.pricingMethodAndDependentTypeMap!=undefined){
                        component.set("v.pricingMethodAndDependentTypeMap",response.pricingMethodAndDependentTypeMap);
                         //setting pricing type value by default; to avoid problems while loading data in edit fucntionality.
                         component.set("v.pricingTypes", (response.pricingMethodAndDependentTypeMap)['Comprehensive Price per Quotation']);
                    }else{
                        console.log('pricingMethodAndDependentTypeMap is null');
                    }
                    // set Values for Driver lines...
                    
                    var delayInMilliseconds1 = 100;
                    window.setTimeout(
                        $A.getCallback(function() {
                            helper.getDriverTabDetailsHelper(component, event, helper);
                        }), delayInMilliseconds1
                    );  
                    

                    var delayInMilliseconds2 = 100;
                    window.setTimeout(
                        $A.getCallback(function() {
                            //console.log('myHelperMethod EXECUTING NOW... ');
                            var compEvent = component.getEvent("refreshEvent");
                            compEvent.setParams({"childCmpAuraId": component.getLocalId(), "childTabLineNumber" : component.get("v.lineNumber")});
                            compEvent.fire();
                        }), delayInMilliseconds2
                    );     
                    
                }else{
                    console.log('response is null');
                }
                
             
            }
            else if(state === "ERROR"){
                 component.set('v.loaded', !component.get('v.loaded'));
                var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"warning",
                "title":"warning",
                "message":"Internal Error. Driver Information not populated. Please Try again or Contact System Admin.",
                "mode":"sticky"
            });
            toastReference.fire();
               // alert('Internal Error. Driver Information not populated. Please Try again or Contact System Admin.');
            }
            else{
                 component.set('v.loaded', !component.get('v.loaded'));
                console.log('callback from the server failed'); 
            }
        });
        $A.enqueueAction(action);
    },
    
    handleAddOtherCostHelper: function(component,existingData){
        console.log('existingData__q'+JSON.stringify(existingData));
         $A.createComponent(
                "c:ET_OtherCostPerRequirementCmp",{
                    "aura:id" : "driverOtherCostCmp",
                    "existingData" : existingData,
                    "editableFieldsByPricingTeam" : component.get("v.editableFieldsByPricingTeam"),
                    "isPricingTeam" :component.get("v.isPricingTeam")
                },
                function(newcomponent){
                    if (component.isValid()) {
                        var newCmp = component.find("OtherCostDiv");
                        var body = newCmp.get("v.body");
                        body.push(newcomponent);
                        newCmp.set("v.body", body);             
                    }
                }            
            );
    },
    
    validateOtherCostFieldsPerTab: function(component,event,helper){
        var requiredFieldIdLst;
        var isValid = true;
        var OtherCostCmps = component.find('driverOtherCostCmp');
         if(OtherCostCmps && OtherCostCmps.length == undefined){
            var requiredFieldsLst = [];
            requiredFieldIdLst = OtherCostCmps.get("v.otherCostDetailFieldsToValidate");
            for(var id in requiredFieldIdLst){
                if(OtherCostCmps.find(requiredFieldIdLst[id])){
                    requiredFieldsLst.push(OtherCostCmps.find(requiredFieldIdLst[id]));
                }
            }
            return helper.validateFields(requiredFieldsLst);
        }else if(OtherCostCmps && OtherCostCmps.length > 0){
            requiredFieldIdLst = OtherCostCmps[0].get("v.otherCostDetailFieldsToValidate");
            for(var otherCostCmp of OtherCostCmps){
                var requiredFieldsLst = [];
                for(var id in requiredFieldIdLst){
                    if(otherCostCmp.find(requiredFieldIdLst[id])){
                        requiredFieldsLst.push(otherCostCmp.find(requiredFieldIdLst[id]));
                    }
                }
                
                if(requiredFieldsLst.length!=undefined && requiredFieldsLst.length > 0){
                        
                            if(!helper.validateFields(requiredFieldsLst)){
                                isValid = false;
                            }
                           
                       }   
            }
        }
        return isValid;
    },
    
      validateFields: function(fieldLst){
       
        var allValid = fieldLst.reduce(function (validSoFar, inputCmp) {            
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        return allValid;
    },
    getDriverTabDetailsHelper : function(component, event, helper) {   
        if(component.get('v.workForceRecord.Type__c') == 'Reliever'){
            component.set('v.msgForReliever', 'Note: Kindly add all Main workforce lines first and than add Relievers for each Main workforce.');
        }
        else{
            component.set('v.msgForReliever', '');
        }
        
        var cmpEvent = component.getEvent("getManpowerTabDetails"); 
        cmpEvent.fire(); 
    },
})