({
    doInit : function(component, event, helper) {
        component.set("v.spinner", true); 
        component.set("v.confirmFlag", true);
        helper.doInit(component, event, helper);
    },
    closeConfirmModal : function(component, event, helper){
       // $A.get("e.force:closeQuickAction").fire();
        component.set("v.confirmFlag",false);
    },
    saveRecord : function(component, event, helper){
        var driverName = component.find("driverName").get("v.value");
        var driverNumber = component.find("driverNumber").get("v.value");
        var validityName = component.find("driverName").get("v.validity");
        var validityNumber = component.find("driverNumber").get("v.validity");
       /* if(isNaN(driverNumber)){
            driverNumber = "";
            validityName.valid = false;
        }
        if(!driverName.match(/[a-z]/i)){
            driverName="";
            validityNumber.valid = false;
        }*/
      	console.log("validityName***"+validityName.valid);
        console.log("validityNumber***"+validityNumber.valid);
        if(driverName == null || driverName == '' || driverName == 'undefined' && driverNumber == null || driverNumber == '' || driverNumber == 'undefined'){
            component.find("driverName").showHelpMessageIfInvalid();
            component.find("driverNumber").showHelpMessageIfInvalid();
            component.set("v.isDisabled", false);
        }
        if(validityName.valid === true && validityNumber.valid === true){
            helper.updateCaseStatus(component, event, helper);  
        }
       /* else{
            helper.updateCaseStatus(component, event, helper);
        } */
        
       /* var allValid = component.find('driverNumber').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
         }, true);
         if (allValid) {
             helper.updateCaseStatus(component, event, helper);  
         } */
    },
    showSpinner: function(component, event, helper) {
      //  component.set("v.spinner", true); 
    },
    hideSpinner : function(component,event,helper){   
        component.set("v.spinner", false);
    }
})