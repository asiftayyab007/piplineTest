({
    
    doInit : function(component, event, helper) {
     
    },
    

	handleForm : function(component, event, helper) {
    var modalBody;
       var modalFooter;
        $A.createComponents([
            ["c:ET_Daily_PreTripInspecctionForm",]
    ],
                            function(components, status){
                                if (status === "SUCCESS") {
                                    modalBody = components[0];
                                    console.log('&&&&&&&&&&&3');
                                    component.find('overlayLib').showCustomModal({
                                        header: "  نموذج تفقد الحافلة قبل الرحلة اليومية / Daily Pre - Trip Inspection Form / روزانہ قبل ازسفر معائنہ کا فارم",
                                        body: modalBody,
                                        footer: modalFooter,
                                        showCloseButton: true,
                                        cssClass: "slds-modal_small",
                                        closeCallback: function() {
                                            //  alert('You closed the alert!');
                                            $A.get('e.force:refreshView').fire();
                                            console.log('popoclose');
                                        }
                                    });
                                }
                            });
  }
        
})