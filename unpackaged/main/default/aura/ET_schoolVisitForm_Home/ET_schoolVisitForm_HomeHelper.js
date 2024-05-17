({
    
    
    getSchoolVisitFormDetail : function(component, event, helper) {
        component.set('v.mycolumns', [
            {label: 'Visit Reference No.', fieldName: 'linkName', type: 'button', typeAttributes: {label: { fieldName: 'Name' }, name: 'view_details', title: 'Click to View Details'}},
            {label: 'Date', fieldName: 'Visit_Date__c', type: 'date'},
            {label: 'School Type', fieldName: 'School_Type__c', type: 'Picklist'},
            {label: 'School Name', fieldName: 'Emplink', type: 'text', typeAttributes: {label: { fieldName: 'schoolName' }, target: '_blank'}},
            {label: 'Action Taken', fieldName: 'Action_Taken__c',type: 'text' },
            {label: 'Notes', fieldName: 'Notes__c',type: 'text' },
        ]);
            var action = component.get("c.getSchoolVisitFormDetails");
            action.setParams({
            });
            action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
            var records =response.getReturnValue();
            console.log("records error"+records);
            records.forEach(function(record){
            record.linkName = record.Name;
            if(record.School_Name__c){
            record.schoolName = record.School_Name__r.Name;
            record.Emplink = record.School_Name__r.Name;
            console.log("Emplink"+record.School_Name__r.Name);
            }else{
            record.Emplink='';
            }
            });
            component.set("v.schoolList", response.getReturnValue());
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
        component.set("v.schoolRecord" , row.Id);
        component.set("v.openRow" , true); 
        
    }


})