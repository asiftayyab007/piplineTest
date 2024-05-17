({ 
    doInit: function(component, event, helper) {
      helper.addAccountRecord(component, event,helper); 
    },
     addRow: function(component, event, helper) {
        helper.addAccountRecord(component, event);
    },
        removeRow: function(component, event, helper) {
        var studentDetails = component.get("v.studentDetails");
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        studentDetails.splice(index, 1);
        component.set("v.studentDetails", studentDetails);
    },
   
   
    handleChange : function(component, event, helper) { 
        //debugger;
       
        var lookupId = event.getParam("value")[0];
        var target= event.currentTarget;
        //var target = event.target;
       if (target && target.currentTarget.dataset) {
        var index = event.currentTarget.dataset.index;
       }
        //var index = event.currentTarget.dataset.index;
        //alert('Index: ',JSON.stringify(index),' StudentId: ',lookupId);
        console.log('Index: ',JSON.stringify(index),' StudentId: ',lookupId);
       helper.updateFields(component, event, helper);
    },   
})