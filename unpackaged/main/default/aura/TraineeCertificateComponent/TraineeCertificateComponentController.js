({
	doInit: function(component, event, helper) {
        let bookingReqId=component.get("v.recordId");
        var action = component.get("c.getTraineeForCertificate");
        action.setParams({
            "BookingId": bookingReqId
        });
        action.setCallback(this, function(a) {
            component.set("v.accounts", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    showTraineeCertificate : function(component, event, helper) {
        //var currentTargetEvent = event.currentTarget;
		//var currentValue = currentTargetEvent.getAttribute("name");
        
        var traineeId = event.currentTarget.dataset.id;
        console.log('traineeId:'+traineeId);
        
        var exmReq=event.currentTarget.dataset.exm;
        console.log('exmReq:'+exmReq);
        
        if(exmReq=='Yes'){
            var url = '/apex/Trainee_Professional_Certificate?id=' + traineeId;
        	window.open(url, "_blank");
        }else{
            
        var url = '/apex/Trainee_Certificate?id=' + traineeId;
        window.open(url, "_blank");
            
        }
        
    }
})