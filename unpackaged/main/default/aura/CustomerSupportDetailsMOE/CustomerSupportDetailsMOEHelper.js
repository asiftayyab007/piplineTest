({
    getCaseData : function(component, event, helper,status) {
        var action = component.get('c.getCaseDetails');
        action.setParams({
            "status" : status
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            
            if (state == 'SUCCESS') {
                var respose=a.getReturnValue();
                component.set('v.caseList', respose);
                component.set('v.currentData', respose);             
                //console.log('a.getReturnValue() '+JSON.stringify(component.get('v.currentData'))); 
            }
        });
        $A.enqueueAction(action);
    },
    convertArrayOfObjectsToCSV : function(component,objRecords) {
        var csvStringResult,counter,keys,lineDivider,columnDivider;
        if(objRecords==null || !objRecords.length)
        {
            return null;         
        }
        columnDivider=',';
        lineDivider='\n';
        keys=['CaseNumber','RecordType','Status_Category__c','Sub_Status__c','Assigned_Resource__r','Assigned_Vehicle__r','ETST_Student__r'];
        csvStringResult='';
        csvStringResult+=keys.join(columnDivider);
        csvStringResult+=lineDivider;
        for(var i=0;i<objRecords.length;i++)
        {
            counter=0;
            for(var tempKey in keys)
            {
                var skey=keys[tempKey];
                if(counter>0)
                {
                    csvStringResult+=columnDivider;
                }
                // Querying standard related object field
                if(typeof objRecords[i][skey]==='object' && skey==='RecordType'){
                    csvStringResult+='"'+objRecords[i][skey].Name+'"';
                    counter ++;
                }
                // Querying custom related object field
                else if(typeof objRecords[i][skey]==='object' && (skey==='Assigned_Resource__r' || skey==='Assigned_Vehicle__r' || skey==='ETST_Student__r')){
                    csvStringResult+='"'+objRecords[i][skey].Name+'"';
                    counter ++;
                }
                // Querying same object field
                    else{
                        csvStringResult+='"'+objRecords[i][skey]+'"';
                        counter ++;
                    }
                
            }
            csvStringResult+=lineDivider;
            
        }
        
        return csvStringResult
    }
})