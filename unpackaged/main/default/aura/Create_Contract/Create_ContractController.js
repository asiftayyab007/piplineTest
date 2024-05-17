({
    doInit : function(component, event, helper) {
        if(component.get("v.quoteId") != undefined && component.get("v.quoteId") != null){
            window.open("/apex/Create_Contract_Pdf?quoteId="+component.get('v.quoteId'));				
        }else{
            window.open("/apex/Create_Contract_Pdf?Id="+component.get('v.recordId'));				
        }
        //to close popup
        var action = component.get('c.closeAction');
      	$A.enqueueAction(action);
    },
    closeAction :function(component, event, helper){
    	$A.get("e.force:closeQuickAction").fire();
 	},
    
})