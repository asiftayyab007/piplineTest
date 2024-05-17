({
    closeModel: function (component, event, helper) {
        component.set('v.newCase',false);
        var actionEvt = $A.get("e.c:ETST_sendDataEvent");
        actionEvt.setParams({
            "actionname": 'refresh' 
        });
        
        actionEvt.fire();
       /* $A.get('e.force:showToast').setParams({
            "title": "Success",
            "message": "Case is created succesfully!",
            "type": "success",
        }).fire();*/
    },
    skipModel:function (component, event, helper) {
        component.set('v.newCase',false);
        var actionEvt = $A.get("e.c:ETST_sendDataEvent");
        actionEvt.setParams({
            "actionname": 'refresh' 
        });
        
        actionEvt.fire();
        $A.get('e.force:showToast').setParams({
            "title": "Success",
            "message": "Case is created succesfully!",
            "type": "success",
        }).fire();
    },
    toggle: function (component, event, helper) {
        var url_string = window.location.href;
        var url = new URL(url_string);
        var lang = url.searchParams.get("lang");
        component.set('v.loadEdirForm',true);
        var nav = component.find("mySelect").get("v.value");
        //var nav = sel.get("v.value");
        console.log('nav----->'+nav);
         $A.util.removeClass(component.find("submit"), "slds-hide");
        console.log('testetdev',component.get('v.clRequestaboardingpassforCompanionHandycamptransportation'));
        if (nav === component.get('v.clNone')){
            helper.resetFlags(component, event, helper);
            component.find('OppMessage').setError(''); 
        }
        else if (nav === component.get('v.clGrowthRequestsforVehicleNannyandCoordinator')) {
            component.find('OppMessage').setError('');
            console.log('--->inside invoice');	           
            helper.resetFlags(component, event, helper); 
            component.set("v.RequestaboardingpassforCompanionHandycamptransportation", true);
            component.set("v.RecordTypeId",$A.get("$Label.c.GrowthReqRecTypeId"));
        }else if(nav === component.get('v.clHandicapServicesTransportationorNannyRequest')){
            component.find('OppMessage').setError('');
            helper.resetFlags(component, event, helper); 
            component.set("v.HandicapService", true);
              component.set("v.RecordTypeId",$A.get("$Label.c.HandicapRecTypeId"));  
        }else if(nav === component.get('v.clTeachersTransportationRequest')){
            component.find('OppMessage').setError('');
            helper.resetFlags(component, event, helper); 
            component.set("v.NewTeacherTransport", true);
            component.set("v.RecordTypeId",$A.get("$Label.c.TeachersRecTypeId"));
        }else if(nav === component.get('v.clAwarenessSessionRequest')){
            component.find('OppMessage').setError('');
            helper.resetFlags(component, event, helper); 
            component.set("v.AwarenessSession", true);
            component.set("v.RecordTypeId",$A.get("$Label.c.AwarenessRecTypeId"));
        }else if(nav === component.get('v.clRequestaboardingpassforCompanionHandycamptransportation')){
            component.find('OppMessage').setError('');
            helper.resetFlags(component, event, helper); 
            component.set("v.RequestaboardingpassforCompanionHandycamptransportation", true);
             console.log('--->inside invoice RequestaboardingpassforCompanionHandycamptransportation true');	
            component.set("v.RecordTypeId",$A.get("$Label.c.Other_Requests"));
        }
            else if(nav === component.get('v.clActivitiesEvents')){
            component.find('OppMessage').setError('');
            helper.resetFlags(component, event, helper); 
            component.set("v.NewTripsRequest", true);
            component.set("v.RecordTypeId",$A.get("$Label.c.ActivitiesRecTypeId"));
            component.set('v.loaded',true);
        }
        
     
    },
    doInit : function(component, event, helper){  
        var test = component.get('v.userParentProfileWrap');
        console.log('test log '+JSON.stringify(test));
        helper.setCommunityLanguage(component, event, helper);
        if (navigator.geolocation) {
            console.log("able to retrieve your location");
            navigator.geolocation.getCurrentPosition(function(position) {
                var latit = position.coords.latitude;
                var longit = position.coords.longitude;
                component.set('v.lat',latit);
                component.set('v.lon',longit);
                component.set('v.vfUrl','/Business/apex/ETST_GoogleMapFinder?lat='+latit+'&long='+longit);
                console.log('vfUrl'+component.get('v.vfUrl'));
            });
        }else{
            console.log("Unable to retrieve your location");
        }     
        
        var urlString=window.location.href;
        var vfOrigin = urlString.substring(0, urlString.indexOf("/Business/s"));
        window.addEventListener("message", $A.getCallback(function(event) {
            
            if (event.origin !== vfOrigin) {
                // Not the expected origin: Reject the message!
                //console.log(event.data);
                return;
            }
            // Handle the message
            console.log(event);
            var message = event.data;
            console.log('message-->'+message);
            /*if(message=='PaymentCancelled'){
                //helper.redirectTo(component, '/etst-home-page');
            }*/
            var res = message.split("~");
            if(res.length > 0){ 
                component.set('v.lat',res[0]);
                component.set('v.lon',res[1]);
                
            }
            
        }), false);
        helper.doInit(component, event, helper);
       // $A.util.addClass(component.find("spinner"), "slds-hide"); 
    },
    handleOnLoad : function(component, event, helper) {
         component.set('v.loaded',true);
        //$A.util.addClass(component.find("spinner"), "slds-hide");    
    },
    handleOnError : function(component, event, helper) {
        console.log("inside error");
        console.log(JSON.stringify(event));
    },
    refresh: function(component, event, helper) {
     helper.doInit(component, event, helper);
    },
    handleUploadFinished: function(component, event, helper) {
         $A.get('e.force:showToast').setParams({
            "title": "Success",
            "message": "Case is created succesfully!",
            "type": "success",
        }).fire();
        component.set('v.newCase',false);
         var actionEvt = $A.get("e.c:ETST_sendDataEvent");
                actionEvt.setParams({
                    "actionname": 'refresh'
                });
                
                actionEvt.fire();
    },
    getLocationDetails: function(component, event, helper){
        component.set('v.openMap',false);
        var lat=component.get('v.lat');
        var long=component.get('v.lon');
        if(lat!=null && lat!='' && lat!=undefined){
            helper.getLocationDetails(component, event, helper,lat,long);
        }
        component.set("v.searchText", '');
    },
    handleOnSuccess : function(component, event, helper) {  
      // debugger;
      console.log('success');
        $A.util.addClass(component.find("submit"), "slds-hide");
        //$A.util.removeClass(component.find("spinner"), "slds-hide");    
        console.log('-----@@@inside success');
        var payload = event.getParams().response;
        console.log('payload '+payload.id);
        component.set('v.newCaseId',payload.id);
        var type = component.find("mySelect").get("v.value");
        if(type==component.get("v.clActivitiesEvents") || type==component.get("v.clAwarenessSessionRequest")){
           // alert('inside if ');
            helper.resetFlags(component, event, helper); 
        		$A.util.removeClass(component.find("uploadImage"), "slds-hide");
           
                
                //$A.util.addClass(component.find("submit"), "slds-hide");
        }else{
           //  alert('inside else  ');
            component.set('v.newCase',false);
            //$A.get("e.force:closeQuickAction").fire();
            $A.get('e.force:showToast').setParams({
                "title": "Success",
                "message": "Case is created succesfully!",
                "type": "success",
            }).fire();
            
            var actionEvt = $A.get("e.c:ETST_sendDataEvent");
                actionEvt.setParams({
                    "actionname": 'refresh'
                });
                
                actionEvt.fire();
        }
        //$A.get('e.force:refreshView').fire();
        //$A.get("e.force:closeQuickAction").fire();
        /*$A.get('e.force:showToast').setParams({
            "title": "Success",
            "message": "Record has been saved!",
            "type": "success",
        }).fire();*/
    },
    
    handleOnSubmit : function(component, event, helper) {      
        console.log('-------inside submit');
        event.preventDefault();
        console.log("startDate***"+component.get("v.startDate"));
        console.log("endDate***"+component.get("v.endDate"));
        var showValidationError = false;
        var validationFailReason='';
        var type = component.find("mySelect").get("v.value");
        var noofpassenger=component.get("v.noofpassenger");    
        var noofattendance=component.get("v.noofattendance");
        var noofstudents=component.get("v.noofstudents");
        var noofteachers=component.get("v.noofteachers");
       // var schoolname=component.get("v.selectedRecord");
        var schoolname = component.get("v.AccountId");
        
        var startDate = component.get("v.startDate");
       // var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD THH:mm:ss");
        var result = new Date();
        result.setDate(result.getDate() + 3);
        var today = $A.localizationService.formatDate(result, "YYYY-MM-DD");
        console.log("today***"+today);
        if(component.get("v.startDate") != '' && component.get("v.startDate") < today){
            showValidationError = true;
            validationFailReason = 'Preferred Start date should be 3 days greater than today';
        }
        if(noofpassenger<=0){
            showValidationError = true;
            // validationFailReason = 'No of passengers should not be less than or equal to 0(zero)';
            component.set('v.noofpassengerError',true);
        }
        
        if(noofattendance<=0){
            showValidationError = true;
            // validationFailReason = 'No of attendance should not be less than or equal to 0(zero)';
            component.set('v.noofattendanceError',true);
        }
        if(noofstudents<=0){
            showValidationError = true;
            //  validationFailReason = 'No of students should not be less than or equal to 0(zero)';
            component.set('v.noofstudentsError',true);
        }
        if(noofteachers<=0){
            showValidationError = true;
            // validationFailReason = 'No of teachers should not be less than or equal to 0(zero)';
            component.set('v.noofteachersError',true);
        }
        /*if(schoolname==undefined){
            showValidationError = true;
          //  validationFailReason = 'Please select School Name';
            component.set('v.schoolnameError',true);
        }*/
        
       
        
        
        if(!showValidationError) {
        component.find('OppMessage').setError('');    
        console.log('-------2----');
        var eventFields = event.getParam("fields"); //get the fields
        //Add Description field Value
        console.log('type***'+type);
            
            var userParentProfileWrap = component.get('v.userParentProfileWrap');
            console.log('userParentProfileWrap '+JSON.stringify(userParentProfileWrap));
            var privateProfileLabel =  $A.get("$Label.c.ET_Private_School_Profile_Name");
            if(userParentProfileWrap.loggedinUserProfileName != privateProfileLabel){
                if(type==component.get("v.clActivitiesEvents")){
                    eventFields["Status"] = 'In Progress';
                    eventFields["Status_Category__c"] = 'Pending with Department Of School Activities';
                }else if(type==component.get("v.clGrowthRequestsforVehicleNannyandCoordinator")){
                    eventFields["Status"] = 'In Progress';
                    eventFields["Status_Category__c"] = 'Pending with Statistics Coordinator';
                }else if(type==component.get("v.clTeachersTransportationRequest")){
                    eventFields["Status"] = 'In Progress';
                    eventFields["Status_Category__c"] = 'Pending with Personnel Management';
                }else if(type==component.get("v.clHandicapServicesTransportationorNannyRequest")){
                    eventFields["Status"] = 'In Progress';
                    eventFields["Status_Category__c"] = 'Pending with Special Education';
                }else if(type==component.get("v.clAwarenessSessionRequest")){
                    eventFields["Status"] = 'In Progress';
                    eventFields["Status_Category__c"] = 'Pending with Head of Safety Unit';
                }else{
                    eventFields["Status"] = 'New';
                }
            }else if(userParentProfileWrap.loggedinUserProfileName == privateProfileLabel){
                if(type==component.get("v.clActivitiesEvents")){
                    eventFields["Status"] = 'In Progress';
                    if(userParentProfileWrap.isParent){
                        eventFields["Status_Category__c"] = 'Pending with Main School';
                    }else{
                        eventFields["Status_Category__c"] = 'Pending with School Transportation Manager'; 
                    }
                }
                else if(type==component.get("v.clHandicapServicesTransportationorNannyRequest")){
                    eventFields["Status"] = 'In Progress';
                    if(userParentProfileWrap.isParent){
                        eventFields["Status_Category__c"] = 'Pending with Main School';
                    }
                }
                 else if(type==component.get("v.clGrowthRequestsforVehicleNannyandCoordinator")){
                    eventFields["Status"] = 'In Progress';
                    if(userParentProfileWrap.isParent){
                        eventFields["Status_Category__c"] = 'Pending with Statistics Coordinator';
                    }
                 }
                else if(type==component.get("v.clTeachersTransportationRequest")){
                         eventFields["Status"] = 'In Progress';
                    if(userParentProfileWrap.isParent){
                         eventFields["Status_Category__c"] = 'Pending with Main School';
                    }     
                   
                     }
                    else if(type==component.get("v.clAwarenessSessionRequest")){
                        eventFields["Status"] = 'In Progress';
                        if(userParentProfileWrap.isParent){
                              eventFields["Status_Category__c"] = 'Pending with Head of Safety Unit';
                        }
                      
                    }
                else{
                    eventFields["Status"] = 'New';
                }
                
            }
            
            eventFields["Origin"] = 'CRM Portal';
         //  alert('acc id'+component.get("v.AccountId"));
            eventFields["AccountId"]=component.get("v.AccountId");
            console.log(component.get("v.AccountId"));
            eventFields["ContactId"]=component.get("v.contactId");
            eventFields["Trip_Destination__c"]=component.get("v.tripLoc");
            console.log('before sub,mit');
            console.log('school name '+component.get("v.AccountName"));
            //return false;
            component.find('caseFormMOE').submit(eventFields); //Submit Form
              console.log('after sub,mit');
        }else {
            console.log('-------3----');
            component.find('OppMessage').setError(validationFailReason, false);
            // $A.util.removeClass(el, "slds-has-error"); 
            //$A.util.addClass(el, "hide-error-message");
        }
    },
    openMapController : function(component, event, helper) {        
        component.set('v.openMap',true);
    },
    closeMapModel: function(component, event, helper) {
        component.set('v.openMap',false); 
        component.set("v.searchText", '');
    },
    
    getSearchResultbyEnter: function(component, event, helper) {  
        window.addEventListener("keyup", function(event) {
            if(event.code == "Enter"){
                component.set('v.mapLoaded',false);
                helper.getAddressRecommendations(component, event,helper, component.get('v.searchText'));
            } 
        }, true);
    },
    getSearchResult: function(component, event, helper) {
        component.set('v.mapLoaded',false);
        helper.getAddressRecommendations(component, event,helper, component.get('v.searchText'));
        
    },
   
})