({
    doInit: function(component, event, helper){
        var action = component.get('c.getUserAccountDetails');
        
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.AccountId', result.accRecord);
                component.set('v.AccountName', result.accRecordName);
                component.set('v.AccountARName', result.accRecordARName);
                component.set('v.contactId', result.cntRecord);
            }
        });
        $A.enqueueAction(action);
    },
    getLocationDetails: function(component, event, helper,latit,longit,isPick){
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getLocationDetails";
        var params = {
            "latitude" : latit,
            "longitude" : longit
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                component.set('v.tripLoc',response);  
                $A.util.addClass(component.find("invalidpickup"), "slds-hide");
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
                utility.showToast("ET MOE", "Please try again later or contact ET Support", "error", "dismissible");
            })
        )	
    },
    getAddressRecommendations: function(component, event,helper,searchText){
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getAddressSet";
        var params = {
            "SearchText" : searchText
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                var addressResponse = JSON.parse(response);
                var predictions = addressResponse.predictions;
                var addresses = [];
                if (predictions.length > 0) {
                    var placeId=predictions[0].place_id;
                    helper.getAddressDetailsByPlaceId(component,event,helper,placeId);
                    $A.util.addClass(component.find("invalidLoc"), "slds-hide");   
                    
                }else{
                    
                    $A.util.removeClass(component.find("invalidLoc"), "slds-hide"); 
                    component.set('v.mapLoaded',true);
                    
                }
                
                component.set("v.AddressList", addresses);
                console.log('AddressList'+component.get("v.AddressList"));
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
                utility.showToast("ET MOE", "Please try again later or contact ET Support", "error", "dismissible");
            })
        )	
        
    },
    resetFlags: function(component,event,helper){
        component.set("v.HandicapService", false);
        component.set("v.NewTeacherTransport", false);
        component.set("v.AwarenessSession", false);
        component.set("v.NewTripsRequest", false);
        component.set("v.GrowthRequest", false);
        component.set("v.RequestaboardingpassforCompanionHandycamptransportation", false);
    },
    //get address details by place Id from google API 
    getAddressDetailsByPlaceId: function(component,event,helper,placeId){
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getAddressDetailsByPlaceId";
        var params = {
            PlaceID:placeId 
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                console.log('response'+response);
                var addressResponse = JSON.parse(response);
                component.set('v.lat',addressResponse.result.geometry.location.lat);
                component.set('v.lon',addressResponse.result.geometry.location.lng);
                component.set('v.mapLoaded',true);
                component.set('v.vfUrl','/Business/apex/ETST_GoogleMapFinder?lat='+addressResponse.result.geometry.location.lat+'&long='+addressResponse.result.geometry.location.lng);
                
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
                utility.showToast("ET MOE", "Please try again later or contact ET Support", "error", "dismissible");
            })
        )	 
    },
    
})