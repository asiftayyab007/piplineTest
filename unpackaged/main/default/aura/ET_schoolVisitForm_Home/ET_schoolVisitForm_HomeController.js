({
    doInit : function(component, event, helper) {
         var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
    component.set('v.today', today);
        console.log(today+'today');
        helper.getSchoolVisitFormDetail (component,event, helper);
        
    },
    
    openModel : function(component, event, helper){
        component.set("v.openForm",true);
        
    },
    closeModel: function(component, event, helper)  {
        
        component.set("v.openForm",false);
    },
   save : function(component, event, helper){ 
        
        component.find("schoolVisitForm").submit();
        
       

    },
    OnCancel : function(component, event, helper){
        component.set("v.openForm",false);
               
    },  
     
      
    handleOnSubmit : function(component, event, helper) {
         
    },
      
    handleOnSuccess : function(component, event, helper) {
         var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams
        ({
            'title':'Success',
            'type':'Success',
            'message':'Request has been submitted successfully.'
        });
        toastEvent.fire();
        component.set("v.openForm",false);
           window.location.reload();
        component.set("v.openForm",false);
       
    },
      
    handleOnError : function(component, event, helper) {
          alert(error);
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