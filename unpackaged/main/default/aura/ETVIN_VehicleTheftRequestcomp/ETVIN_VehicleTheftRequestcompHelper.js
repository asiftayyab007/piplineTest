({
    serverSideCall : function(component,action) {
        
        return new Promise(function(resolve, reject) { 
            action.setCallback(this, 
                               function(response) {
                                   
                                   var state = response.getState();
                                    console.log(state);
                                   if (state === "SUCCESS") {
                                       resolve(response.getReturnValue());
                                   } else {
                                       reject(new Error(response.getError()));
                                   }
                               }); 
            $A.enqueueAction(action);
        });
    },
   
     getAllDocs : function(component, event, helper){ 
        
    var action = component.get("c.getFiles");
         
         console.log(action);
         console.log('action');
     action.setParams({  
       "recordId":component.get("v.recordId")  
     });      
     action.setCallback(this,function(response){
         
       var state = response.getState();

       if(state=='SUCCESS'){  
         var result = response.getReturnValue();  
         
         component.set("v.files",result);  
       }  
     });  
     $A.enqueueAction(action); 
        
         
    },
    
    UpdateDocument : function(component,event,helper,Id) {  
        var docName = component.get("v.selectedDocValue");
       var exeAction = component.get("c.UpdateFiles");  
       exeAction.setParams({
           "documentId":Id,  
           "title": docName,  
           "recordId": component.get("v.recordId") 
           
       });  
       helper.getAllDocs(component, event, helper);
      helper.handlerShowToastMsgUploade('Success','File is Uploaded successfully','success');
   }, 
    handlerShowToastMsgUploade : function(Title,Msg,Type){
         
          var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type": Type,
                    "title":Title,
                    "message":Msg,
                    "mode":"dismissible"
                });
                toastReference.fire();
                
               $A.get('e.force:refreshView').fire();
    },
    
      deleteDocumentRecord : function(component, event, helper){
       
        var selectedPillId =event.target.id;  
        
         var docLabel = selectedPillId.substring(selectedPillId.lastIndexOf("_")+1); //to get Last word
          
         var docID = selectedPillId.substring(0,selectedPillId.lastIndexOf("_"));  //to get first part 
       
        var exeAction = component.get("c.deleteRecord");
          
        exeAction.setParams({
            "RecID": docID  
        }); 
        
        helper.serverSideCall(component,exeAction).then(
            function(res) { 
                
                if(res == 'success'){
                      helper.handlerShowToastMsg('Success','File is deleted successfully','success');
                     helper.getAllDocs(component, event, helper);
                     helper.updateCancelRecord(component, event, helper,docLabel,false);
                }
            });
    },
     handlerShowToastMsg : function(Title,Msg,Type){
         
          var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type": Type,
                    "title":Title,
                    "message":Msg,
                    "mode":"dismissible"
                });
                toastReference.fire();
                
               $A.get('e.force:refreshView').fire();
    },
     updateCancelRecord : function(component, event, helper,docLabel, statusVal){
     
         var exeAction = component.get("c.updateRecord");
        exeAction.setParams({
            "RecID": component.get("v.recordId"),
            "DocLabel":docLabel,
            "status": statusVal
        }); 
        
        helper.serverSideCall(component,exeAction).then(
            function(res) { 
               
            });
    },
    
	getInsurancedetails : function(component, event, helper) {
        
        
		var action = component.get("c.VehicleTheftRequest");
        action.setParams({ 
            recordtypeName : 'Vehicle Theft Request'
        });
      
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               
                var vehicleInsList = response.getReturnValue();
                console.log(vehicleInsList);
                 component.set('v.vehicleInsList', vehicleInsList);
                 component.set('v.FilteredData', vehicleInsList);
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
           
        });
        $A.enqueueAction(action);
	},
    updateStatusWithAcceptAndReject : function(component, event, helper, status) {
		var action = component.get("c.updateStatusForCorrectionRequest");
        var  recordId = component.get('v.recordId');
        action.setParams({ 
            recordId : recordId,
            status : status
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.isModalOpen", false);
                var msg = '';
                if(status == 'Approved'){
                    msg= 'The record has been approved.'; 
                }else{
                    msg= 'The record has been rejected.';
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "dismissible",
                    message: msg,
                    type: 'Success',
                    title: 'Success!'
                });
                toastEvent.fire();
                
                  component.set('v.recordId', '');
                component.set('v.detailPage', false);
                this.getInsurancedetails(component, event, helper);
                
                var address = new URL(window.location.origin);
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": address+'partnerportal/s',
                    "isredirect" :false
                });
                urlEvent.fire();
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
           
        });
        $A.enqueueAction(action);
      }
    
})