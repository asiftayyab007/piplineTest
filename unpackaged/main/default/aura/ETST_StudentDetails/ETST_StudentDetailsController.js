({
    closeactionevt : function(component,event){
        if(event.getParam("actionname") === 'refresh'){
            $A.get('e.force:refreshView').fire();
        }
        
    },
    openChangeSchool: function(component,event,helper){
        var item=event.getSource().get('v.value');
        component.set('v.currentValue',item.ETST_School_Name__r.Name);
        component.set('v.hasService',false);
        if(item.ETST_Transport_Requests__r){
            component.set('v.serviceRecord',item.ETST_Transport_Requests__r[0]);
            if(item.ETST_Transport_Requests__r[0].ETST_Status__c==$A.get("$Label.c.ETST_Payment_success")||
               item.ETST_Transport_Requests__r[0].ETST_Status__c==$A.get("$Label.c.ETST_Payment_Success_In_Review")){
                 helper.getRefundAmountHelper(component,event,helper);
            }
            
        }
        
        component.set('v.selectedStudentId',item.Id);
        component.set('v.changeSchoolModal',true);
        
    },
    openCurrentSection : function(component,event,helper){
        component.set('v.isCurrent',true);
        helper.doInit(component, event, helper,true);
        
    },
    displayLocation: function(component,event,helper){
        component.set('v.showMap',true);        
    },
    closeMap: function(component,event,helper){
        component.set('v.showMap',false);        
    },
    openRenewSection: function(component,event,helper){
        component.set('v.isCurrent',false);
        helper.doInit(component, event, helper,false);
    },
    emailInvoice: function(component, event, helper) {
        var item=event.getSource().get('v.value');
        helper.emailInvoiceHelper(component, event, helper,item.ETST_Transport_Requests__r[0].Id);
    },
    emailInvoiceRenew: function(component, event, helper) {
        var item=event.getSource().get('v.value');
        helper.emailInvoiceHelper(component, event, helper,item.ETST_Transport_Requests__r[1].Id);
    },
    doInit : function(component, event, helper) {
        component.set('v.zoomLevel',4);
        component.set('v.markersTitle', 'Bus Location');
        component.set('v.mapMarkersData',[
        {
            location: {
                Latitude: '25.093312',
                Longitude: '55.162862'
            },
            title: 'School',
        },
        {
            location: {
                Latitude: '25.2651286',
                Longitude: '55.306955'
            },
            title: 'Home',
        },
        {
            location: {
                Latitude: '25.117049',
                Longitude: '55.1864275'
            },
            title: 'Bus',
        }
    ]);
        
        if(screen.width<=480){
            component.set('v.corousalSize', 1);
        }else{
            component.set('v.corousalSize', 3);
        }
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
        var url_string = window.location.href; 
        var url = new URL(url_string);
        console.log('url***'+url);
        var lang1 = url.searchParams.get("lang");
        console.log('lang1***'+lang1);
        var noChildImageURL = $A.get('$Resource.ETST_Dashboard_Add_Child');
        component.set('v.noChildImageURL', noChildImageURL);
        // for Community language ETST_BilingualCommunity component
        helper.setCommunityLanguage(component, event, helper); 
        var lang=component.get('v.clLang');
        console.log('lang***'+lang);
        if(lang=='ar'){
            $A.util.addClass(component.find('mainDiv'), 'slds-modal__bodyrtl');
            $A.util.removeClass(component.find('mainDiv'), 'slds-modal__body');
        }else{
            $A.util.addClass(component.find('mainDiv'), 'slds-modal__body');
            $A.util.removeClass(component.find('mainDiv'), 'slds-modal__bodyrtl');
        } 
        helper.doInit(component, event, helper,true);
        //this.getCurrentLocation(component, event, helper);
        if (navigator.geolocation) {
            console.log("able to retrieve your location");
            navigator.geolocation.getCurrentPosition(function(position) {
                var latit = position.coords.latitude;
                var longit = position.coords.longitude;
                component.set('v.serviceRecord.ETST_Location__Latitude__c',latit);
                component.set('v.serviceRecord.ETST_Location__Longitude__c',longit);
            });
        }else{
            console.log("Unable to retrieve your location");
        }
        var url_string = window.location.href;
        var url = new URL(url_string);
        console.log('url***'+url);
        var lang = url.searchParams.get("lang");
        console.log('lang***'+lang);
        component.set("v.lang", lang); 
    },
    setServiceDates: function(component, event, helper) {
        component.set("v.serviceRecord.ETST_Fare_Charges__c",'');
        component.set("v.serviceRecord.ETST_Fare_Charges__c",'');
        component.set("v.serviceRecord.ETST_Transport_Type__c",'');
        helper.setServiceDates(component, event, helper);
    },
    setCalculatedFare: function(component, event, helper) {
        helper.setCalculatedFare(component, event, helper);
    },
    selectOption:function(component, event, helper) {
        helper.getAddressDetailsByPlaceId(component, event);
    },
    keyPressController: function(component, event, helper) {
        helper.getAddressRecommendations(component,event);
    },
    getCurrentLocation: function(component, event, helper) {
        console.log(event.currentTarget.value);
        if (navigator.geolocation) {
            console.log("able to retrieve your location");
            navigator.geolocation.getCurrentPosition(function(position) {
                var latit = position.coords.latitude;
                var longit = position.coords.longitude;
                component.set('v.serviceRecord.ETST_Location__Latitude__c',latit);
                component.set('v.serviceRecord.ETST_Location__Longitude__c',longit);
            });
        }else{
            console.log("Unable to retrieve your location");
        }
        
        
    },
    getLocationDetails: function(component, event, helper){
        helper.getLocationDetails(component, event, helper,component.get('v.serviceRecord.ETST_Location__Latitude__c'),component.get('v.serviceRecord.ETST_Location__Longitude__c'));
    },    
    gotoStudentDetail: function(component, event, helper) {
        var page='/student-details';
        var item=event.getSource().get('v.value');
        var urlEvent = $A.get("e.force:navigateToURL");
        console.log('url***'+item.ETST_Image_Document_Id__c);
        urlEvent.setParams({
            "url": page+'?recordId='+item.Id+'&requestId='+item.ETST_Transport_Requests__r[0].Id+'&docId='+item.ETST_Image_Document_Id__c
            
        });
        urlEvent.fire();
    },
    gotoPaymentPage: function(component, event, helper) {
        
        var page='/school-transport-payment-page';
        var item=event.getSource().get('v.value');
        var urlEvent = $A.get("e.force:navigateToURL");
        console.log(item)
       
        urlEvent.setParams({
            "url": page+'?recordId='+item.ETST_Transport_Requests__r[0].Id+'&src=etst'+'&lang='+component.get("v.clLang")+'&zone='+item.ETST_Transport_Requests__r[0].ETST_Area_Zone__c
            
        });
        urlEvent.fire();
    },
    gotoPaymentPageRenew: function(component, event, helper) {
        
        var page='/school-transport-payment-page';
        var item=event.getSource().get('v.value');
        var urlEvent = $A.get("e.force:navigateToURL");
       
        urlEvent.setParams({
            "url": page+'?recordId='+item.ETST_Transport_Requests__r[1].Id+'&src=etst'+'&lang='+component.get("v.clLang")
            
        });
        urlEvent.fire();
    },
    viewStudentService: function(component, event, helper) {
        var page='/service-details';
        var item=event.getSource().get('v.value');
        var urlEvent = $A.get("e.force:navigateToURL");
        
        urlEvent.setParams({
            "url": page+'?recordId='+item.ETST_Transport_Requests__r[0].Id+'&src=etst&lang='+component.get("v.lang")
        });
        
        urlEvent.fire();
    }, 
    viewStudentService2: function(component, event, helper) {
        
        var page='/service-details';
        var ctarget = event.currentTarget;
        var item = ctarget.dataset.value;
        
        //var item=event.getSource().get('v.value');
        var urlEvent = $A.get("e.force:navigateToURL");
        
        urlEvent.setParams({
            "url": page+'?recordId='+item+'&src=etst&lang='+component.get("v.lang")
        });
        
        urlEvent.fire(); 
    }, 
    openCancelServiceModal : function(component, event, helper) {
        var item=event.getSource().get('v.value');
        component.set('v.serviceRecord.ETST_Student__c',item.Id);
        component.set('v.serviceRecord',item.ETST_Transport_Requests__r[0]);
        component.set('v.cancelServiceModal',true);
        helper.setCommunityLanguage(component, event, helper); 
        var lang=component.get('v.clLang');
        console.log('lang***'+lang);
        if(lang=='en' || lang=='null' || lang==null|| lang==undefined){
            $A.util.addClass(component.find('mainDiv'), 'slds-modal__body');
            $A.util.removeClass(component.find('mainDiv'), 'slds-modal__bodyrtl');
        }else{
            $A.util.addClass(component.find('mainDiv'), 'slds-modal__bodyrtl');
            $A.util.removeClass(component.find('mainDiv'), 'slds-modal__body');
        }
    },
    openCancelServiceModalRenew : function(component, event, helper) {
        var item=event.getSource().get('v.value');
        component.set('v.serviceRecord.ETST_Student__c',item.Id);
        component.set('v.serviceRecord',item.ETST_Transport_Requests__r[1]);
        component.set('v.cancelServiceModal',true);
        helper.setCommunityLanguage(component, event, helper); 
        var lang=component.get('v.clLang');
        console.log('lang***'+lang);
        if(lang=='en' || lang=='null' || lang==null|| lang==undefined){
            $A.util.addClass(component.find('mainDiv'), 'slds-modal__body');
            $A.util.removeClass(component.find('mainDiv'), 'slds-modal__bodyrtl');
        }else{
            $A.util.addClass(component.find('mainDiv'), 'slds-modal__bodyrtl');
            $A.util.removeClass(component.find('mainDiv'), 'slds-modal__body');
        }
    },
    openDeactivateServiceModal : function(component, event, helper) {
        var item=event.getSource().get('v.value');
        component.set('v.serviceRecord.ETST_Student__c',item.Id);
        component.set('v.serviceRecord',item.ETST_Transport_Requests__r[0]);
        //alert(component.get('v.serviceRecord.ETST_Pick_Up_End_Date__c'));
        component.set('v.deactivateServiceModal',true);
        var startDt=component.get('v.serviceRecord.ETST_Pick_Up_Start_Date__c');
        var today=component.get('v.today');
        var pickStartDt=new Date(startDt.substring(0, 4), 
                                   startDt.substring(5, 7)-1, 
                                   startDt.substring(8));
        var toDate1=new Date(today.substring(0, 4), 
                                   today.substring(5, 7)-1, 
                                   today.substring(8));
          
       if(pickStartDt>toDate1){
           component.set('v.today',startDt);
       } 
        helper.setCommunityLanguage(component, event, helper); 
        var lang=component.get('v.clLang');
        console.log('lang***'+lang);
        if(lang=='en' || lang=='null' || lang==null|| lang==undefined){
            $A.util.addClass(component.find('mainDiv'), 'slds-modal__body');
            $A.util.removeClass(component.find('mainDiv'), 'slds-modal__bodyrtl');
        }else{
            $A.util.addClass(component.find('mainDiv'), 'slds-modal__bodyrtl');
            $A.util.removeClass(component.find('mainDiv'), 'slds-modal__body');
        }
    },  
    openDeactivateServiceModalRenew : function(component, event, helper) {
        var item=event.getSource().get('v.value');
        component.set('v.serviceRecord.ETST_Student__c',item.Id);
        component.set('v.serviceRecord',item.ETST_Transport_Requests__r[1]);
        //alert(component.get('v.serviceRecord.ETST_Pick_Up_End_Date__c'));
        component.set('v.deactivateServiceModal',true);
        helper.setCommunityLanguage(component, event, helper); 
        var lang=component.get('v.clLang');
        console.log('lang***'+lang);
        if(lang=='en' || lang=='null' || lang==null|| lang==undefined){
            $A.util.addClass(component.find('mainDiv'), 'slds-modal__body');
            $A.util.removeClass(component.find('mainDiv'), 'slds-modal__bodyrtl');
        }else{
            $A.util.addClass(component.find('mainDiv'), 'slds-modal__bodyrtl');
            $A.util.removeClass(component.find('mainDiv'), 'slds-modal__body');
        }
    },  
    trimben: function(component){
        var ben=component.get('v.Beneficiary');
        if(ben.length==1)
            component.set('v.Beneficiary',ben.trim());
        
    },
    trimbank: function(component){
        var ben=component.get('v.BankName');
        if(ben.length==1)
            component.set('v.BankName',ben.trim());
        
    },
    trimAccNo: function(component){
        var ben=component.get('v.AccountNo');
        if(ben.length==1)
            component.set('v.AccountNo',ben.trim());
        
    },
    trimBranch: function(component){
        var ben=component.get('v.Branch');
        if(ben.length==1)
            component.set('v.Branch',ben.trim());
        
    },
    trimBankAddress: function(component){
        var ben=component.get('v.BankAddress');
        if(ben.length==1)
            component.set('v.BankAddress',ben.trim());
        
    },
    deactivateStudentController : function(component, event, helper) {
        
        let mandatoryFieldsList;// = component.get("v.cancelMandFields");
        
        if(component.get('v.serviceRecord.ETST_Reason_for_Cancellation__c')== $A.get("$Label.c.ETST_Permanent_Cancellation")||
           component.get('v.serviceRecord.ETST_Reason_for_Cancellation__c')==''||component.get('v.serviceRecord.ETST_Reason_for_Cancellation__c')==null ){
            if(component.get('v.isRefund')){
                
                mandatoryFieldsList = component.get("v.refundMandFields");  
            }else{
                
                mandatoryFieldsList = component.get("v.cancelMandFields"); 
            }
            
        }else if(component.get('v.serviceRecord.ETST_Reason_for_Cancellation__c')== $A.get("$Label.c.ETST_On_Hold_Status")){
            
            mandatoryFieldsList = component.get("v.onHoldMandFields");
        }
        
        var mandatoryFieldsCmps = [];
        for(var id in mandatoryFieldsList){
            mandatoryFieldsCmps.push(component.find(mandatoryFieldsList[id]));
        }
        
        /* var allValid =mandatoryFieldsCmps.reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);*/
        
        
        var allValid =mandatoryFieldsCmps.reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);       
        
        if (allValid) {
            var endDt=component.get('v.serviceRecord.ETST_Pick_Up_End_Date__c');
            var pickendDt=new Date(endDt.substring(0, 4), 
                                   endDt.substring(5, 7)-1, 
                                   endDt.substring(8))
            var effDate=component.get('v.serviceRecord.ETST_Cancellation_Effective_Date__c');
            var pickEffDt=new Date(effDate.substring(0, 4), 
                                   effDate.substring(5, 7)-1, 
                                   effDate.substring(8))
            
            if(pickEffDt>=pickendDt){
                component.set('v.pickerrorMsg','Effective Date should be before the pickup end date');
            }else if((component.get('v.fileNames')=='' || component.get('v.fileNames')==undefined ||
                      component.get('v.fileNames')== null)&& component.get('v.isRefund')){
                component.set('v.errorMsg','Please upload the emirates Id document');
            }else{
                component.set('v.errorMsg','');
                component.set('v.pickerrorMsg','');
                helper.deactivateStudentHelper(component, event, helper); 
            }
            
        }else{
            console.log('enterd else');
        }
    },  
    openCreateSerivceModal : function(component, event, helper) {
        var item=event.getSource().get('v.value');
        component.set('v.serviceRecord.ETST_Student__c',item.Id);
        component.set('v.schoolId',item.ETST_School__c);
        component.set('v.studentRecord',item);
        component.set('v.addServiceModal',true);
        component.set('v.renewServiceModal',false);
    },
    openCreateSerivceModal2 : function(component, event, helper) {
        var ctarget = event.currentTarget;
        var item = ctarget.dataset.value;
        component.set('v.serviceRecord.ETST_Student__c',item);
        component.set('v.addServiceModal',true);
        component.set('v.renewServiceModal',false);
    },
    openRenewSerivceModal  : function(component, event, helper) {
        component.set("v.serviceRecord.ETST_Fare_Charges__c",'');
        var item=event.getSource().get('v.value');
        component.set('v.serviceRecord.ETST_Student__c',item.Id);
        component.set('v.schoolId',item.ETST_School__c);
        component.set('v.studentRecord.ETST_School__c',item.ETST_School__c);
        component.set('v.addServiceModal',false);
        component.set('v.renewServiceModal',true);
    },
    openRenewSerivceModal2  : function(component, event, helper) {
        var ctarget = event.currentTarget;
        var item = ctarget.dataset.value;
        component.set('v.serviceRecord.ETST_Student__c',item);
        component.set('v.addServiceModal',false);
        component.set('v.renewServiceModal',true);
    },
    closeModel: function(component, event, helper) {
        component.set('v.serviceRecord',component.get('v.newService'));
        component.set('v.addServiceModal',false);
        component.set('v.renewServiceModal',false);
        component.set('v.deactivateServiceModal',false);
        component.set('v.cancelServiceModal',false);
        component.set('v.onholdServiceModal',false);
        component.set('v.changeSchoolModal',false);
        
    },
    cancelService: function(component, event, helper) {
        var allValid = component.find('cancelFields').reduce(
            function(validSoFar, inputCmp) 
            {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
        
        if (allValid) {
            helper.cancelServiceHelper(component, event, helper);
        }else{
            console.log('enterd else');
        }
        
    },
    updateSelectedText: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        var searchCompleteEvent = cmp.getEvent("sendDataEvent"); 
        searchCompleteEvent.setParams({
            selectedRecords: selectedRows.length
        }).fire();
        cmp.set('v.selectedRowsCount', selectedRows.length);
    },
    
    
    getPreviousList: function(component, event, helper) {
        var corousalSize=component.get('v.corousalSize'); 
        var start=component.get('v.start'); 
        start-=corousalSize;
        var studentList=component.get('v.studentList'); 
        component.set('v.studentCourosalList',studentList.slice(start,start+corousalSize)); 
        component.set('v.start',start);
        
    },
    getNextList: function(component, event, helper) {
        var corousalSize=component.get('v.corousalSize'); 
        var start=component.get('v.start'); 
        start+=corousalSize;
        var studentList=component.get('v.studentList'); 
        component.set('v.studentCourosalList',studentList.slice(start,start+corousalSize)); 
        component.set('v.start',start); 
    },
    selectChange : function(component, event, helper) {
        var checkbox = event.getSource().get("v.value");
        
        if(checkbox){
            component.set('v.isRefund',true);
            if(component.get('v.Beneficiary')==null || component.get('v.Beneficiary')==''){
                helper.getBankDetailsHelper(component, event, helper);
            }
        }else{
            component.set('v.isRefund',false);
        }
    },
   /* handleUploadFinished: function (cmp, event) {
        var uploadedFiles = event.getParam("files");
        console.log('uploadedFiles'+JSON.stringify(uploadedFiles));
        var documentId = uploadedFiles[0].documentId;
        console.log('documentId'+documentId);
        component.set('v.documentId',documentId);
        helper.getImageContent(component, event, helper);
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        var fileNames='';
        // Get the file name
        uploadedFiles.forEach(file => cmp.set('v.fileNames',file);
        cmp.set('v.fileNames',fileNames.slice(0, -1));
        if(cmp.get('v.fileNames')!='' && cmp.get('v.fileNames')!=undefined &&
           cmp.get('v.fileNames') != null){
            cmp.set('v.errorMsg','');
        }
    },*/
    handleUploadFinished: function (component, event) {
        var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        console.log('documentId'+documentId);
        component.set('v.documentId',documentId);
        component.set('v.fileNames',uploadedFiles[0].name);
        if(documentId!='' && documentId!=undefined && documentId != null){
            component.set('v.errorMsg','');
        }
    },
    deleteFile: function (component, event, helper) {
        helper.deleteFileHelper(component, event, helper);
    },
    getRefundAmountController: function(component, event, helper) {
        var endDt=component.get('v.serviceRecord.ETST_Pick_Up_End_Date__c');
        var pickendDt=new Date(endDt.substring(0, 4), 
                               endDt.substring(5, 7)-1, 
                               endDt.substring(8))
        var effDate=component.get('v.serviceRecord.ETST_Cancellation_Effective_Date__c');
        var pickEffDt=new Date(effDate.substring(0, 4), 
                               effDate.substring(5, 7)-1, 
                               effDate.substring(8))
        
        if(pickEffDt>=pickendDt){
            component.set('v.pickerrorMsg','Effective Date should be before the pickup end date');
        }else{
            component.set('v.pickerrorMsg','');
        }
        if(component.get('v.serviceRecord.ETST_Reason_for_Cancellation__c')== $A.get("$Label.c.ETST_Permanent_Cancellation")){
            helper.getRefundAmountHelper(component, event, helper);
        }
    },
    
    openonholdServiceModal: function(component, event, helper){
        var item=event.getSource().get('v.value');
        component.set('v.serviceRecord.ETST_Student__c',item.Id);
        component.set('v.serviceRecord',item.ETST_Transport_Requests__r[0]);
        component.set('v.onholdServiceModal', true);
    },
    openonholdServiceModalRenew: function(component, event, helper){
        var item=event.getSource().get('v.value');
        component.set('v.serviceRecord.ETST_Student__c',item.Id);
        component.set('v.serviceRecord',item.ETST_Transport_Requests__r[1]);
        component.set('v.onholdServiceModal', true);
    },
    activateOnholdService: function(component, event, helper){
        helper.activateOnholdService(component, event, helper);
    },
    changeSchool: function(component, event, helper){
        let mandatoryFieldsList; 
        var schoolname=component.get("v.selectedRecord.Name");
        if(schoolname!=null&& schoolname!=''&& schoolname!=undefined){
            $A.util.addClass(component.find("schoolname"), "slds-hide"); 
            if(component.get('v.hasService')){
                mandatoryFieldsList = component.get("v.refundMandFieldsSchool");  
                var mandatoryFieldsCmps = [];
                for(var id in mandatoryFieldsList){
                    mandatoryFieldsCmps.push(component.find(mandatoryFieldsList[id]));
                }
                
                var allValid =mandatoryFieldsCmps.reduce(function (validSoFar, inputCmp) {
                    inputCmp.showHelpMessageIfInvalid();
                    return validSoFar && !inputCmp.get('v.validity').valueMissing;
                }, true);       
                
                if (allValid) {
                    if(component.get('v.fileNames')=='' || component.get('v.fileNames')==undefined ||
                       component.get('v.fileNames')== null){
                        component.set('v.errorMsg','Please upload the emirates Id document');
                    }else{
                        component.set('v.errorMsg','');
                        helper.changeSchoolHelper(component, event, helper);
                    }
                }
                
            }else{
                helper.changeSchoolHelper(component, event, helper); 
            }
        }else{
            $A.util.removeClass(component.find("schoolname"), "slds-hide");  
        }
        
    },
})