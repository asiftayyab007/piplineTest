({
    addAccountRecord: function(component, event) {
              
        
        var recid=component.get('v.recordId');
       
        var stdList = component.get("v.studentDetails"); 
        stdList.push({
            'School__c': recid,
        }); 
        component.set("v.studentDetails", stdList);
    },
    
    addRecord: function(component, event) {
        var recid=component.get('v.recordId');
        var stdList = component.get("v.studentDetails"); 
        stdList.push({
            'School__c': recid,
        }); 
        component.set("v.studentDetails", stdList);
    }
    
   
    

    
})