({
    
    
    getSchoolVisitFormDetail : function(component, event, helper) {
        component.set('v.mycolumns', [
            
            {label: 'Visit Reference No.', fieldName: 'linkName', type: 'button', typeAttributes: {label: { fieldName: 'Name' }, name: 'view_details', title: 'Click to View Details'}},
            {label: 'Date', fieldName: 'Date__c', type: 'date'},
            {label: 'Account', fieldName: 'linkName1', type: 'text', typeAttributes: {label: { fieldName: 'account' }, target: '_blank'}},
            
            {label: 'School', fieldName: 'Emplink', type: 'text', typeAttributes: {label: { fieldName: 'schoolName' }, target: '_blank'}},
            {label: 'Assigned Resources', fieldName: 'Emplink1', type: 'text', typeAttributes: {label: { fieldName: 'assignedRes' }, target: '_blank'}},
            {label: 'Branch', fieldName: 'Branch__c',type: 'text' },
            {label: 'Station', fieldName: 'Station__c',type: 'text' },
            {label: 'Internal Number', fieldName: 'Internal_Number__c',type: 'text' },
        ]);
            var action = component.get("c.getDriverCheckListDetails");
            action.setParams({
            });
            action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
            var records =response.getReturnValue();
            
            records.forEach(function(record){
            record.linkName = record.Name;
            record.Name = record.Name;
            if(record.School__c){
            record.schoolName = record.School__r.Name;
            record.Emplink = record.School__r.Name;
            console.log("Emplink"+record.School__r.Name);
            }else{
            record.Emplink='';
            }
            if(record.Assigned_Resources__c){
            record.assignedRes = record.Assigned_Resources__r.Name;
            record.Emplink1 = record.Assigned_Resources__r.Name;
            
            }else{
            record.Emplink1='';
            }
            if(record.Account__c){
            record.account = record.Account__r.Name;
            record.linkName1 = record.Account__r.Name;
            
            
            }else{
            record.linkName1='';
            }
            
            
            });
            component.set("v.DriverCheckList", response.getReturnValue());
            }
            else if (state === "ERROR") {
            var errors = response.getError();
            if (errors) {
            if (errors[0] && errors[0].message) {
            console.log("Error message: " + errors[0].message);
            
        }
    } else {
    console.log("Unknown error");
    
}
 }
 });
$A.enqueueAction(action);
},
    
    showRowDetails : function(component, row, action) {
        
        console.log('aaa');
        component.set("v.driverRecord" , row.Id);
        component.set("v.openRow" , true); 
        
    }

})