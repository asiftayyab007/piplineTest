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
        helper.createPaymentRecord(component, event, helper);  
       
    },
    showSpinner: function(component, event, helper) {
        component.set("v.spinner", true); 
    },
    hideSpinner : function(component,event,helper){   
        component.set("v.spinner", false);
    }
})