({
    save : function(component, event, helper)
    {       
                              
                               
                               var toastEvent = $A.get("e.force:showToast");
                               toastEvent.setParams
                               ({
                                   'title':'Success',
                                   'type':'Success',
                                   'message':'Request has been submitted successfully.'
                               });
                               toastEvent.fire();
                               $A.get("e.force:closeQuickAction").fire();
                         
    },
    OnCancel : function(component, event, helper){
       
       $A.get("e.force:closeQuickAction").fire();
    },
})