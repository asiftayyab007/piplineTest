({
    handleOnLoad : function(component, event, helper) {
      
    },
    handleOnSuccess : function(component, event, helper) {
        
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:showToast').setParams({
            "title": "Success",
            "message": "Record has been saved!",
            "type": "success",
        }).fire();
        var actionEvt = $A.get("e.c:ETST_sendDataEvent");
        actionEvt.setParams({
            "actionname": 'refresh'
        });
        
        actionEvt.fire();
    },
    
    handleOnSubmit : function(component, event, helper) {
        console.log('-------inside submit**');
        
        
        
        /* event.preventDefault(); //Prevent default submit
        helper.submitCase(component, event, helper);*/
       var eventFields = event.getParam("fields"); //get the fields
       
        eventFields["Status"] = 'New'; //Add Description field Value
        eventFields["Origin"] = 'CRM Portal';
        eventFields["RecordtypeId"] ='0128E000002554yQAA';
        eventFields["AccountId"]='0018E00001iRZhHQAW';
        eventFields["ContactId"]=component.get("v.contactId")
        component.find('caseForm').submit(eventFields); //Submit Form
    },
    handleOnError: function (cmp, event, helper) {
        // alert('handleOnError errorMessage ');
        var error = event.getParams();
        console.log(JSON.stringify(error));
        
        // Get the error message
        var errorMessage = event.getParam("message");
        console.log(JSON.stringify(errorMessage));
        
       // alert('errorMessage '+errorMessage);
    }
    
})