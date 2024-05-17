({
	 getOpportunities : function(component) {
         var Mnum=component.get('v.MobileNumber');
        var action = component.get("c.getOpportunities");
         action.setParams({
             'MobNum' : Mnum
              });
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