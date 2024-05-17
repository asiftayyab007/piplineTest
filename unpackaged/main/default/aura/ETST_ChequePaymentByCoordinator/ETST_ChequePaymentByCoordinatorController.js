({
    doInit : function(component, event, helper) {
        console.log('onload');
        component.set("v.isOpen", true);
        helper.doInit(component, event, helper);		
    },
    closeModel : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    saveRecord : function(component, event, helper){
         var allValid = component.find('fieldId').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(allValid) {
             helper.createPaymentRecord(component, event, helper);
        }
     
            // Calling saveContacts if the button is save
           
        
    },
    showSpinner: function(component, event, helper) {
        component.set("v.spinner", true); 
    },
    hideSpinner : function(component,event,helper){   
        component.set("v.spinner", false);
    },
   
    
})