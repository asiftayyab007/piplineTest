({
    CSVtoJSON : function(component,csv) {
        console.log('Incoming csv = ' + csv);
        
        var arr = []; 
        arr =  csv.split('\n');
        console.log('arr = '+arr);
        arr.pop();
        var jsonObj = [];
        var headers = arr[0].split(',');
        console.log('@@'+headers);
        for(var i = 1; i < arr.length; i++) {
            var data = arr[i].split(',');
            var obj = {};
            for(var j = 0; j < data.length; j++) {
                obj[headers[j].trim()] = data[j].trim();
                console.log('obj headers = ' + obj[headers[j].trim()]);
            }
            jsonObj.push(obj);
        }
        var json = JSON.stringify(jsonObj);
        console.log('json = '+ json);
        return json;
    },
    
    
    UpdateRecord : function(component,jsonstr){
        console.log('jsonstr' + jsonstr);
        var action = component.get('c.updateData');
        action.setParam(
            {
                fileData : jsonstr
            }
        );
        action.setCallback(this,function(response){
            var state = response.getState();
            alert(state);
            
            if (state === "SUCCESS"){
                component.set("v.ShowModule",false);
                var result=response.getReturnValue();
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"Success",
                    "title":"success",
                    "message":'Your data is updated successfully',
                    "mode":"dismissible"
                });
                toastReference.fire();
                $A.get('e.force:refreshView').fire(); 
            }
            else if(state === "Error"){
                component.set();
                var errors = response.getError();
                if(errors){
                    if(errors[0]&& errors[0].message){
                        console.log("Error Message: " + errors[0].message);
                        
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":'Please check with System admin'+errors[0].message,
                            "mode":"sticky"
                        });
                        toastReference.fire();
                        
                        
                    }
                    
                    
                } else{
                    console.log("Unkown error");
                    alert('Unknown');
                }
            }
            
            
            
            
        });
        $A.enqueueAction(action);  
    },
    
})