({
    doInit : function(component, event, helper) {
        // Fetch opportunity records

        helper.getOpportunities(component);
    },
    
    handleSelect : function(component, event, helper) {
        // Get selected opportunities
        alert('handleSelect')
        component.set("v.Showpagedetails",true);

        var selectedOpportunities = [];
        var checkboxes = component.find("checkbox");
        if (checkboxes) {
            if (checkboxes.length) {
                // Multiple checkboxes selected
                checkboxes.forEach(function(checkbox) {
                    if (checkbox.get("v.checked")) {
                        component.set("v.Showpagedetails",false); 
                        var opp = component.get("v.opportunities").find(function(o) {
                            return o.Id === checkbox.get("v.value");
                        });
                        selectedOpportunities.push(opp);
                        console.log(selectedOpportunities);

                    }
                });
            } else {
                // Single checkbox selected
                if (checkboxes.get("v.checked")) {
                                alert('Single checkboxes')

                    var opp = component.get("v.opportunities").find(function(o) {
                        return o.Id === checkboxes.get("v.value");
                        
                    });
                    selectedOpportunities.push(opp);
                }
            }
        }
        
        // Set selected opportunities
        component.set("v.selectedOpportunities", selectedOpportunities);
    }
})