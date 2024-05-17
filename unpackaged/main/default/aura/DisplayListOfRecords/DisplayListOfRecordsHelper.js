({
    getOpportunities : function(component) {
        var action = component.get("c.getOpportunities");
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.opportunities", response.getReturnValue());
            } else {
                console.error(response.getError());
            }
        });
        $A.enqueueAction(action);
    }
})