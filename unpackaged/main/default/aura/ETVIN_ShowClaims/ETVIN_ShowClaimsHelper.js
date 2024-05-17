({
	getInsurancedetails : function(component, event, helper) {
		var action = component.get("c.getInsuranceClaimsDetails");
        action.setParams({ 
            //recordId : recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var vehicleInsList = response.getReturnValue();
                
                console.log('@@@@ ' + JSON.stringify(vehicleInsList));
                component.set('v.vehicleInsList', vehicleInsList);
                component.set('v.FilteredData', vehicleInsList);
                //component.set('v.recordId', '');
                //component.set('v.detailPage', false);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
           
        });
        $A.enqueueAction(action);
	},
    updateStatusWithAcceptAndReject : function(component, event, helper, status) {
		var action = component.get("c.updateStatusForClaims");
        var  recordId = component.get('v.recordId');
        action.setParams({ 
            recordId : recordId,
            status : status
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.isModalOpen', false);
                var msg = '';
                if(status == 'Approved'){
                    msg= 'The record has been approved.'; 
                }else{
                    msg= 'The record has been rejected.';
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "dismissible",
                    message: msg,
                    type: 'Success',
                    title: 'Success!'
                });
                toastEvent.fire();
                  component.set('v.recordId', '');
                component.set('v.detailPage', false);
                 this.getInsurancedetails(component, event, helper);
               
                var address = new URL(window.location.origin);
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": address+'partnerportal/s',
                    "isredirect" :false
                });
                urlEvent.fire();
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
           
        });
        $A.enqueueAction(action);
	},
     fetchContentDocument : function(component, event, helper) {
        var action = component.get("c.fetchContentDocument");
        var  recordId = component.get('v.recordId');
        //alert(recordId)
        action.setParams({ 
            recordId : recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
           // alert(state)
            if (state === "SUCCESS") {
                component.set('v.lstContentDoc', response.getReturnValue());
                console.log('---'+JSON.stringify(component.get('v.lstContentDoc')));
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);  
    },
    fetchClaimstranscation : function(component, event, helper) {
        var action = component.get("c.getInsuranceInsuranceTransactions");
        var  recordId = component.get('v.recordId');
        //alert(recordId)
        action.setParams({ 
            claimid : recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
           // alert(state)
            if (state === "SUCCESS") {
                component.set('v.transactionList', response.getReturnValue());
                console.log('---'+JSON.stringify(response.getReturnValue()));
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);  
    },
})