({
    onLoad : function(component, event, helper) {
        component.set('v.showSpinner', false);
        var pType = component.get('v.paymentType');
		var element = component.find("DivID5");
        console.log('pType***'+pType);
        console.log('element***'+element);
       // if(pType == '4'){
            $A.util.toggleClass(element, "slds-hide");
       // }
       helper.setCommunityLanguage(component, event, helper); 
        var lang=component.get('v.clLang');
       /* if(lang=='en' || lang=='null' || lang==null|| lang==undefined){
            $A.util.addClass(component.find('mainDiv'), 'slds-modal__body');
            $A.util.removeClass(component.find('mainDiv'), 'slds-modal__bodyrtl');
        }else{
            $A.util.addClass(component.find('mainDiv'), 'slds-modal__bodyrtl');
            $A.util.removeClass(component.find('mainDiv'), 'slds-modal__body');
        } */
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getBankDetails";
        var params = {
            "serviceRecordId" : component.get("v.transportRequest.Id")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                console.log('response***'+JSON.stringify(response));
                component.set('v.bankAccountNumber', response.BankAccountNumber);
                component.set('v.iBAN', response.IBAN);
                component.set('v.bankName', response.BankName);
               // component.set('v.recordId', response.invoice);
                var address=component.get('v.courierAddress');
                if(address!=null && address!=undefined){
                    component.set('v.addresstoCourier', address);
                }else{
                   component.set('v.addresstoCourier', response.Address); 
                }
                
            }),            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )
        onSelectSubmittedBy();
    },
    onSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        console.log(payload.id);
        component.set('v.showSpinner', false);
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "attachmentInsert";
        var params = {
            "fileName" : component.get('v.fileName'), 
            "fileBody" : component.get('v.fileContent'), 
            "parentRecordId" : payload.id
        };
        var promise = utility.executeServerCall(component, backendMethod, params);       
        promise.then (
            $A.getCallback(function(response) {
                utility.showToast("School Tranport", "Invoice Created Successfully!", "success", "dismissible");
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
        $A.get('e.force:refreshView').fire();
    },
    onError : function(component, event, helper) {
        console.log('Inside Error handling');
        var error = event.getParam("error");
        console.log('error***'+JSON.stringify(error)); 
        component.set("v.showSpinner",false);
        component.set("v.disabled",false);
    },
    onSubmit : function(component, event, helper) {
        debugger;
       /* var showValidationError = false;
        var vaildationFailReason = ''; */
        event.preventDefault();
        component.set("v.disabled",true);
        component.set('v.showSpinner', true);
        var paymentMode = component.get('v.selected');
        var submittedBy = component.get('v.selected');
        console.log('submittedBy***'+submittedBy);
        var eventFields = event.getParam("fields");
       /* var termsandconditons = component.find("termsandconditions");
        var isChecked = termsandconditons.doCheck();
        console.log("isChecked***"+isChecked);
        if(!isChecked){
            showValidationError = true;
            vaildationFailReason = "Please agree the terms and conditions before proceed.";
        } */
        eventFields['fromDate__c'] = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        eventFields['ETST_Submitted_By__c'] = component.get('v.selected');
        eventFields['ETST_Active__c'] = true;
        if(paymentMode == 'Direct' || paymentMode == 'Courier'){
            eventFields['ETST_Type__c'] = 'Cheque';
        } else {
            eventFields['ETST_Type__c'] = 'Bank Transfer / Cash Deposit';
        }
       component.find('BankTransferForm').submit(eventFields);
        /*
        if (!showValidationError) {
            component.set('v.showSpinner', true);
            component.find('BankTransferForm').submit(eventFields); 
        } else {
            component.find('displayErrorMessage').setError(vaildationFailReason);
            component.set('v.showSpinner', false); 
        } */
    },
    handleFilesChange : function(component, event, helper) {
        var fileName = 'No File Selected..';
        var fileOutput = {};
        if (event.getSource().get("v.files").length > 0) {
            var file = event.getSource().get("v.files")[0];
            fileName = file['name'];
            var reader = new FileReader();
            reader.onload = $A.getCallback(function() {
                var content = reader.result;
                var base64 = 'base64,';
                var dataStart = content.indexOf(base64) + base64.length;
                content = content.substring(dataStart); 
                component.set('v.fileName', fileName);
                component.set('v.fileType', file.type);
                component.set('v.fileContent',content);
            });
            reader.readAsDataURL(file);
        }
    },
    onSelectSubmittedBy : function(component, event, helper){
        console.log('value***'+component.get('v.submittedBy'));
    },
    cancelSave: function(component, event, helper) {
        helper.redirectTo(component, '/etst-home-page?lang='+component.get("v.clLang"));
    },
    selectChange : function(component, event, helper) {
        // first get the div element. by using aura:id
        var changeElement = component.find("DivID2");
        var changeElement3 = component.find("DivID3");
        var changeElement4 = component.find("DivID4");
        var changeElement5 = component.find("DivID5");
        var changeElement9 = component.find("DivID9");
        // by using $A.util.toggleClass add-remove slds-hide class
        $A.util.toggleClass(changeElement, "slds-hide");
        $A.util.toggleClass(changeElement3, "slds-hide");
        $A.util.toggleClass(changeElement4, "slds-hide");
        $A.util.toggleClass(changeElement5, "slds-hide");
        $A.util.toggleClass(changeElement9, "slds-hide");
    },
})