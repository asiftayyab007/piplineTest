({
    doInit : function(component, event, helper) {
        helper.getTodayDate(component, event);
        /*var recId = component.get("v.recordId");
        console.log('@@recId '+recId);
        
        var action = component.get("c.getUserName");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('resl'+result);
                component.set("v.currentUserName", result);
            }
        });
        $A.enqueueAction(action);*/
    
        
    },
   
   
    OnCancel : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    
    handleLoad : function(component, event, helper) {
		console.log('handle handleLoad');
        component.set("v.showSpinner", false);
	},
    handleSubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var fields = event.getParam("fields");
        
        component.find('createAccountForm').submit(fields); // Submit form
		console.log('handle handleSubmit');
	},
	handleSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams
        ({
            'title':'Success',
            'type':'Success',
            'message':'Request has been submitted successfully.'
        });
        toastEvent.fire();
        $A.get("e.force:closeQuickAction").fire();
		console.log('record updated successfully');
        
        
        component.set("v.showSpinner", false);
	},
    checkBrowser: function(component) {
        var device = $A.get("$Browser.formFactor");
        alert("You are using a " + device);
    },
    next : function(component, event, helper) {
        //Get the current selected tab value
        var currentTab = component.get("v.selTabId");
         
        if(currentTab == 'tab1'){
            component.set("v.selTabId" , 'tab2');   
        }else if(currentTab == 'tab2'){
            component.set("v.selTabId" , 'tab3');     
        }
		else if(currentTab == 'tab3'){
            component.set("v.selTabId" , 'tab4');     
        }
    },
    
    
     back : function(component, event, helper) {
        //Get the current selected tab value  
        var currentTab = component.get("v.selTabId");
         
        if(currentTab == 'tab2'){
            component.set("v.selTabId" , 'tab1');     
        } else if(currentTab == 'tab3'){
            component.set("v.selTabId" , 'tab2');     
        }
		else if(currentTab == 'tab4'){
            component.set("v.selTabId" , 'tab3');     
        }
    }
 
   
})