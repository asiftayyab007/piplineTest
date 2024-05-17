({
    submitCase: function(component, event, helper){
        
        var action = component.get('c.MROgetUserDetails');
        var eventFields = event.getParam("fields"); //get the fields
        //alert(eventFields["ETST_Complaint_Type__c"]);
        eventFields["Status"] = 'New'; //Add Description field Value
        eventFields["Origin"] = 'CRM Portal';
        var recName1="0018E00001iRZhHQAW";
        var type=component.get('v.complaintAgainstType');
        
        console.log('recName1: '+recName1);
        console.log('type: '+type);
        
        //return false;
        
       
        action.setParams({
            "recName1" : recName1
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            console.log('state: '+state);
            console.log('result: '+JSON.stringify(result));

            if (state === "SUCCESS") {
                console.log('inside success');
                eventFields["RecordTypeId"] = result.recId;
                eventFields["AccountId"]=result.u.AccountID;
                eventFields["ContactId"]=result.u.ContactId;
            
                console.log('---->'+JSON.stringify(eventFields));
                
                console.log('inside success before SUBMIT');
                component.find('caseForm').submit(eventFields); //Submit Form
                
                console.log('inside success after SUBMIT');       
                
            }else if(state === "ERROR"){
                //alert('inside error');
                
            }
        });
        $A.enqueueAction(action);
    },
})