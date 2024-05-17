({
	doInit : function(component, event, helper) {
         var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
	helper.getSchoolVisitFormDetail (component,event, helper);
       
	},
    
    openModel : function(component, event, helper){
        component.set("v.openForm",true);
   
  },
    closeModel: function(component, event, helper)  {
        
        component.set("v.openForm",false);
    },
     OnCancel : function(component, event, helper){
      component.set("v.openForm",false);
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
       window.location.reload();
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
    },
    
   handleRowAction: function (component, event, helper) {
       console.log('button');
   
   
      var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'view_details':
           helper.showRowDetails(component, row, action);
                
                break;
        }
   },
    
    closeModal: function(component, event, helper) {
        component.set("v.openRow" , false);
    },
    closeMod: function(component, event, helper) {
        component.set("v.openRow" , false);
    }
    
})