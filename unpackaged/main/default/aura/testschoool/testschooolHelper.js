({
    addAccountRecord: function(component, event) {
        var stdList = component.get("v.studentDetails"); 
        stdList.push({}); 
        component.set("v.studentDetails", stdList);
    },
      updateFields: function (component,event, helper){
          var lookupId = event.getParam("value")[0];
        var action = component.get('c.getstudentDetails');
        action.setParams({
            StudentId:lookupId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                var studentlist = component.get("v.studentDetails");
                response.getReturnValue()
                var results= response.getReturnValue();
                 console.log("results message: " +JSON.stringify(results));
               studentlist.push(results);
                 component.set("v.studentDetails",studentlist);
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
})