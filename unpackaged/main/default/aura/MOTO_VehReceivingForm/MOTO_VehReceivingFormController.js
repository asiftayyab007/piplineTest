({
    doInit : function (component, event, helper) {
        try{
            let oppInfo= component.get("v.selectedOpp");      
            let vehRecInfo= component.get("v.VehReceivingRec");
            let vehObj= {sobjectType:'Vehicle_Receiving_Info__c'};                     
            vehObj.Opportunity__c=oppInfo.Id;    
            vehRecInfo.push(vehObj);
            component.set("v.VehReceivingRec",vehRecInfo);
            
        }catch(e){
            console.log(e.message)
        }
    },
    handleSave : function(component, event, helper) {
        alert('handleSave')
        
    },
    previousButton : function(component, event, helper) {
        alert('previousButton')
        component.set("v.vehSearchPage",true);
        component.set("v.vehInspectionForm",false);
        
        
    },
    handleYesClick : function (component,event) {
        
        let vehRecInfo= component.get("v.VehReceivingRec");        
        let fieldName = event.getSource().get("v.name");
        vehRecInfo[0][fieldName] = true;
        component.set("v.VehReceivingRec",vehRecInfo);
        
    },
    handleNoClick : function (component,event) {
        let vehRecInfo= component.get("v.VehReceivingRec");        
        let fieldName = event.getSource().get("v.name");
        vehRecInfo[0][fieldName] = false;       
        component.set("v.VehReceivingRec",vehRecInfo);
        
    },
    saveHandler2 :function(component, event, helper){
        console.log(component.get("v.VehReceivingRec"))
        
        
        
        
    },
    saveHandler:function (component,event, helper){
        console.log(component.get("v.VehReceivingRec"))
        
        alert('save')
        var action = component.get("c.VehReceivingCtr");
        action.setParams({
            "vehicleInspectionList": component.get("v.VehReceivingRec"),
        });
        action.setCallback(this, function(response) {
            //get response status 
            var state = response.getState();
            alert(state)

            if (state === "SUCCESS") {
                $A.get('e.force:showToast').setParams({
                    "title": "SUCCESS",
                    "message": "saved successfully",
                    "type": "SUCCESS",
                }).fire();
                
                
                //set empty account list
                component.set("v.VehReceivingRec", []);
                component.set("v.SelectedType", []);
                component.set("v.MobileNumber", []);

                $A.get("e.force:closeQuickAction").fire(); 
                component.set("v.vehSearchPage",true);
                component.set("v.vehInspectionForm",false);
                
            }
        }); 
        $A.enqueueAction(action);
        
        
    }
    
    
    
})