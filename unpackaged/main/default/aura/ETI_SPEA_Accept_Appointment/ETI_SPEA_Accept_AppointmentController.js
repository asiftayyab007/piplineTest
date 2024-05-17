({
	
    onForceLoad : function(component, event, helper) {
        let serApp = component.get("v.record");       
        console.log(serApp.ETI_Accepted__c +'---'+serApp.RecordType.Name)
        let dateVal = new Date(serApp.SchedStartTime);
        var today = new Date();
            
        if(dateVal.getDate() == today.getDate() && dateVal.getMonth()==today.getMonth() && dateVal.getFullYear()==today.getFullYear()){
           
            
        }else{
            component.set("v.hasError",true);
        }
        
    },
    closeModel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    acceptRequest : function(component, event, helper) {
         component.set("v.showSpinner",true);
        component.find("servApp").submit();
    },
    handleOnSuccess:function(component, event, helper) {
       var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Success",
                "title":"Success",
                "message":"Request has been accepeted successfully.",
                "mode":"dismissible"
            });
            toastReference.fire();
        $A.get("e.force:closeQuickAction").fire();
    },
    handleOnError : function(component, event, helper) {
        component.set("v.showSpinner",false);
       var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Error",
                "title":"Error",
                "message":"Please check with Admin",
                "mode":"dismissible"
            });
            toastReference.fire();
    }
})