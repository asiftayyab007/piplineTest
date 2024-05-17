({    
   doInit: function(component, event, helper) {
      helper.addAccountRecord(component, event,helper); 
    },
     addRow: function(component, event, helper) {
        helper.addRecord(component, event);
    },
        removeRow: function(component, event, helper) {
        var students = component.get("v.studentDetails");
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        students.splice(index, 1);
        component.set("v.studentDetails", students);
    },
    
 
     saveAccounts:function (component,event, helper){

        var action = component.get("c.SavestudentList");
        action.setParams({
            "studentList": component.get("v.studentDetails"),
        });
        action.setCallback(this, function(response) {
            //get response status 
            var state = response.getState();
            if (state === "SUCCESS") {
                $A.get('e.force:showToast').setParams({
                    "title": "SUCCESS",
                    "message": "saved successfully",
                    "type": "SUCCESS",
                }).fire();
                
                
                //set empty account list
                component.set("v.studentDetails", []);
                $A.get("e.force:closeQuickAction").fire(); 
                
            }
        }); 
        $A.enqueueAction(action);
    }
    
    
})