({
    doInit: function (component, event, helper){
        
        var action = component.get('c.checkoutRejectedTyres');    
        
        action.setParams({
            "strCollectionCard":component.get("v.recordId")
        });
        
        action.setCallback(this, function(a){
            var state = a.getState(); 
            console.log(state);
            if(state == 'SUCCESS') {
                console.log(a.getReturnValue());
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/' + component.get("v.recordId")
                });
                urlEvent.fire();
            }else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        helper.showErrorToast({
                            "title": "Required",
                            "type": "error",
                            "message": errors[0].message
                        });
                        //return false;
                        var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/' + component.get("v.recordId")
                });
                urlEvent.fire();
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
        });      
        $A.enqueueAction(action);
        
        
    },
})