({
    doInit : function(component, event, helper)  {
        var action = component.get("c.getStudentTripDetails");
        action.setParams({ studentId : component.get("v.requestId") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.tripList",response.getReturnValue());
                console.log("trip list "+ response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                }            }
        });

        $A.enqueueAction(action);
    }
})