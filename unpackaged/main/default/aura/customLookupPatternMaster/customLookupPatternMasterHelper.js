({
	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method 
     var action = component.get("c.fetchLookUpValues2");
      // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName")
          });
      // set a callBack  
      
       
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
               
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                console.log(storeResponse)
                component.set("v.listOfSearchRecords", storeResponse);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
    searchHelper2 : function(component,event,getInputkeyWord) {
	  // call the apex class method 
     var action = component.get("c.fetchToolsandMaterial");

      // set param to method  
        action.setParams({
            'itemCode': getInputkeyWord,
          });
    
      // set a callBack    
        action.setCallback(this, function(response) {
           
            var state = response.getState();
            if (state === "SUCCESS") {
          
                var storeResponse = response.getReturnValue();
              
                component.set("v.toolsStockList", storeResponse);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
})