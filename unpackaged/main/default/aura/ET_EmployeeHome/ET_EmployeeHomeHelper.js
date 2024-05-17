({
    getUserDetails: function(component, event, helper) {
        
        var action = component.get("c.getCurrentUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.currentUser", data.userInfo);
                component.set("v.currentUserInsurance", data.insuranceInfo[0]);
                /***added by Janardhan on 25/04/23 **/
                console.log(data);
                if(data.userInfo && data.userInfo.Profile.Name === 'System Administrator'){  
                    component.set("v.showNoTaskMsg", false);
                    component.set("v.showEtdiBkngReq", true);
                    component.set("v.showEtdiTrainerSch", true);
                    component.set("v.showVRTSCREEN", true);
                    component.set("v.showQHSECREEN", true);
                }
                try{
                    let tabInfo = data.userInfo.Account.Employee_Tabs__c;
                    if(tabInfo){
                        if(tabInfo.includes("ETDI Booking Request")){
                            component.set("v.showEtdiBkngReq", true);
                        }
                        if(tabInfo.includes("ETDI Trainer Schedules")){
                            component.set("v.showEtdiTrainerSch", true);
                            component.set("v.selectedTab", 'Trainer'); 
                        }
                        if(tabInfo.includes("VRTS")){
                            component.set("v.showVRTSCREEN", true);
                            component.set("v.selectedTab", 'VRTS'); 
                        }
                        if(tabInfo.includes("QHSE")){
                            component.set("v.showQHSECREEN", true);
                            component.set("v.selectedTab", 'QHSE'); 
                        }
                        
                    }else{
                        component.set("v.showNoTaskMsg", true);
                    }
                }catch(e){   
                    if(data.userInfo.Profile.Name != 'System Administrator')
                        component.set("v.showNoTaskMsg", true);
                    console.log(e.message);
                }
                
                /*  component.set("v.FormVisibility", user.Account.Employee_Task__c);
               // component.set("v.FormVisibility", user);
                 let selTab = component.get('v.FormVisibility');
                  if (selTab.includes('Driver Checklist Form')) {
                      component.set("v.showDriverForm",true);
                  }
                else if(selTab.includes('ETDI Booking Request')){
                    component.set("v.showETDIRequestForm",true);
                }*/
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        helper.showToast('error','error','Error-'+errors[0].message);  
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        });
        $A.enqueueAction(action);
    }
})