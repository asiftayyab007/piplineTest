({
    redirectTo : function(component, page) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": page                            
        });
        urlEvent.fire();
    }
})