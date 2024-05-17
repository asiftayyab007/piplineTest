({
    doInit : function(component, event, helper) {
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getProfileDetails";
        
        var params = {
            
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                
                component.set('v.EID',response.ET_Emirates_Id__c);
                component.set('v.Phone',response.PersonMobilePhone);
                if(response.ET_Emirates_Id__c==null|| response.ET_Emirates_Id__c==undefined
                  || response.ET_Emirates_Id__c==''){
                    component.set('v.needMoreInfo',true);
                    component.set('v.isEID',true);
                }
                if(response.PersonMobilePhone == null || response.PersonMobilePhone==''){
                    component.set('v.needMoreInfo',true);
                    component.set('v.isPhone',true);
                    
                }
                component.set('v.userId',response.Id);
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("School Tranport", errorToShow, "error", "dismissible");
            })
        )	

    },
    updateProfile: function(component, event, helper) {
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "updateProfile";
        
        var params = {
            'eid':component.get('v.EID'),
            'Phone':component.get('v.Phone'),
            'userId':component.get('v.userId'),
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                component.set('v.needMoreInfo',false);                
                           
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	

    },
})