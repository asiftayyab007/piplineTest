({
    doInit: function (component, event, helper) {
        
        
        helper.getPrivateuserdata(component, event);
        component.set('v.isSchoolActivitiesDepartment', false);
        component.set('v.isSchoolServicesDepartment', false);
        component.set('v.isSpecialEducationDepartment', false);
        component.set('v.isPersonnelManagementDepartment', false);
        component.set('v.isMainSchoolContact', false);
        var action = component.get('c.getDashboardData');
        var searchFilterCall= false;
        
        action.setParams({
            
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue(); 
                // component.set('v.newCases', result.newCount);
                // var allRequests=result.newCount;
                
                component.set('v.escalatedCases', result.inprogressCount);
                console.log('result.inprogressCount '+result.inprogressCount);
                //var allRequests=0;
                var allRequests=result.inprogressCount;
                console.log('allRequests '+allRequests);
                component.set('v.onHoldCases', result.rejectedCount);
                console.log('result.rejectedCount '+result.rejectedCount);
                allRequests+=result.rejectedCount;
                component.set('v.closedCases', result.closedCount);
                console.log('result.closedCount'+result.closedCount);
                console.log('result.NewCount'+result.newCount);
                console.log('result.ApprovedCount'+result.approvedCount);
                allRequests+=result.closedCount;
                allRequests+=result.approvedCount;
                allRequests+=result.newCount;
                component.set('v.allRequestsCount', allRequests);
                
                var userParentProfileWrap = component.get('v.userParentProfileWrap');
                console.log('userParentProfileWrap '+JSON.stringify(userParentProfileWrap));
                var privateProfileLabel =  $A.get("$Label.c.ET_Private_School_Profile_Name");
                if(userParentProfileWrap.loggedinUserProfileName == privateProfileLabel && userParentProfileWrap.isParent==false)
                {
                    console.log('inside test');
                    component.set('v.isMainSchoolContact', true);
                }
                else if(result.loggedinUserProfileName == 'P-MOE - Department Of School Activities'){
                    component.set('v.isSchoolActivitiesDepartment', true);
                }else if(result.loggedinUserProfileName == 'P-MOE - Department Of School Services'){
                    component.set('v.isSchoolServicesDepartment', true);
                }else if(result.loggedinUserProfileName == 'P-MOE - Special Education'){
                    component.set('v.isSpecialEducationDepartment', true);
                }else if(result.loggedinUserProfileName == 'P-MOE - Personnel Management'){
                    component.set('v.isPersonnelManagementDepartment', true);
                }
                helper.setCommunityLanguage(component, event, helper); 
            }
        });
        $A.enqueueAction(action);
    },
    createCasePopup : function(component, event, helper) {
        var modalBody;
        var modalFooter;
        $A.createComponents([
            ["c:CaseB2BPopup",{
                "recordId": '',
            }]
        ],
                            function(components, status){
                                if (status === "SUCCESS") {
                                    modalBody = components[0];
                                    console.log('&&&&&&&&&&&3');
                                    component.find('overlayLib').showCustomModal({
                                        header: "Create MOE Request",
                                        body: modalBody,
                                        footer: modalFooter,
                                        showCloseButton: true,
                                        cssClass: "my-modal,my-custom-class,my-other-class",
                                        closeCallback: function() {
                                            //alert('You closed the alert!');
                                            $A.get('e.force:refreshView').fire();
                                        }
                                    });
                                }
                            });
    },
    closeactionevt : function(component,event){
        
        if(event.getParam("actionname") === 'refresh'){
            $A.get('e.force:refreshView').fire();
        }
        
    },
    createCasePopupMoE : function(component, event, helper) {
        component.set('v.newCase',true);
    },
    handleApplicationEvent : function(component, event) {
        var request = event.getParam("createRequest");
        var history = event.getParam("reqHistory");
        var escalation = event.getParam("escalation");
        var feedback = event.getParam("feedback");
        
        component.set("v.createRequest", request);
        component.set("v.reqHistory", history);
        component.set("v.escalation", escalation);
        component.set("v.feedback", feedback);
    },
    
    //method to show all cases table and hiding the case dashboards
    showAllCasesAction: function (component, event, helper) {
        
        var status = component.get("v.clAll");
        component.set('v.status', status);
        component.set('v.showCaseTable',true);
        component.set('v.clickedDashboard','All'); 
        helper.getCaseData(component, event, helper,'All');
    },
    
    //methods to handle dashboard clicks
    handleNewCasesClick: function (component, event, helper) {
        component.set("v.status", '');
        //var status = component.get("v.new");
        var status = component.get("v.clNew");
        component.set("v.status", status);
        component.set('v.showCaseTable',true);
        helper.getCaseData(component, event, helper,'New');
    },
    handleApprovalCasesClick: function (component, event, helper) {
        
        component.set("v.status", '');
        // var status = component.get("v.inProgress");
        var status = component.get("v.clPendingApproval");
        component.set("v.status", status);
        component.set('v.showCaseTable',true);
        helper.getCaseData(component, event, helper,'In Progress');
    },
    
    handleOnHoldCasesClick: function (component, event, helper) {
        component.set("v.status", '');
        //var status = component.get("v.rejected");
        var status = component.get("v.clRejected");
        component.set("v.status", status);
        component.set('v.showCaseTable',true);
        helper.getCaseData(component, event, helper,'Rejected');
    },
    handleInvalidCasesClick: function (component, event, helper) {
        component.set("v.status", '');
        //var status = component.get("v.approved");
        var status = component.get("v.clApproved");
        component.set("v.status", status);
        component.set('v.showCaseTable',true);
        helper.getCaseData(component, event, helper,'Approved');
    },
    handleClosedCasesClick: function (component, event, helper) {
        component.set("v.status", '');
        //var status = component.get("v.closed");
        var status = component.get("v.clClosed");
        component.set("v.status", status);
        component.set('v.showCaseTable',true);
        helper.getCaseData(component, event, helper,'Closed');
    },
    
    // methods to handle record clicks
    handleCaseClick: function (component, event, helper) {
        var recId = event.target.id;
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "case/");
    },
    handleCaseClickNew: function (component, event, helper) {
        var recId = event.target.id;
        component.set("v.recordDetailId", recId);
        component.set("v.objectApiName", "Case");
        component.set("v.ObjectName", "Case");
        component.set("v.recordName", "CaseNumber");
        
        component.set("v.fieldApiName1", "Subject");
        component.set("v.fieldApiName4", "Type");
        component.set("v.fieldApiName2", "Status");
        component.set("v.fieldApiName3", "Priority");
        
        component.set("v.field1Label", "Subject");
        component.set("v.field4Label", "Type");
        component.set("v.field2Label", "Status");
        component.set("v.field3Label", "Priority");
        component.set("v.showDetailCmp", true);
    },
    handleSalesAgreementClick: function (component, event, helper) {
        var recId = event.target.id;
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "et-sales-agreement/");
    },
    handleAssignedResourcesClick: function (component, event, helper) {
        
        var recId = event.target.id;
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "saline-assigned-resource/");
    },
    handleAssignedVehiclesClick: function (component, event, helper) {
        
        var recId = event.target.id;
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "saline-assigned-vehicle/");
    },
    handleStudentClick: function (component, event, helper) {
        
        var recId = event.target.id;
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "etst-student/");
    },
    
    handleSectionToggle: function (component, event) {
        var openSections = event.getParam('openSections');
    },
    handleSearch: function (component, event) {
        
        var caseWarapperList = component.get('v.customerCaseWrapper');
        
        var statusFilter = component.get('v.statusFilter');
        var caseNumber = component.get('v.caseNumber');
        var salesAgreementFilter=component.get("v.selectedLookUpSalesAgreementRecord.Id");
        var resourceFilter = component.get("v.selectedLookUpResourcesRecord.Id");
        var vehicleFilter = component.get("v.selectedLookUpVehiclesRecord.Id");
        var studentFilter = component.get("v.selectedLookUpStudentRecord.Id");
        
        console.log('statusFilter = ',statusFilter);
        console.log('caseNumber = ',caseNumber);
        console.log('salesAgreementFilter = ',salesAgreementFilter);
        console.log('resourceFilter = ',resourceFilter);
        console.log('vehicleFilter = ',vehicleFilter);
        console.log('studentFilter = ',studentFilter);
        
        var action = component.get('c.getCustomerCareDetailsGovt');
        action.setParams({
            caseNumber : caseNumber,
            Status : statusFilter,
            salesAgId : salesAgreementFilter,
            assignedResId : resourceFilter,
            assignedVehId : vehicleFilter,
            stdId : studentFilter
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                
                //alert('resp = '+JSON.stringify(a.getReturnValue()));
                component.set('v.caseList',result);
            }
        });
        $A.enqueueAction(action);
        
    },
    handleSortSRCase: function(component,event,helper){
        //alert('inside sort');
        var item=event.target.id;
        console.log('item'+item);
        var currentData=component.get('v.currentData'); 
        var sortDirection = component.get("v.sortDirection");
        if(sortDirection == 'asc')
            component.set("v.sortDirection","desc");
        else
            component.set("v.sortDirection","asc");
        console.log('sortDirection--------'+sortDirection);
        if(item=='caseNumber')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.CaseNumber > b.CaseNumber) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.CaseNumber > b.CaseNumber) ? -1 : 1);
        }
        if(item=='caseType')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.RecordType.Name > b.RecordType.Name) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.RecordType.Name > b.RecordType.Name) ? -1 : 1);
        }
        if(item=='nextAct')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Status_Category__c > b.Status_Category__c) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Status_Category__c > b.Status_Category__c) ? -1 : 1);
        }
        if(item=='preAct')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Sub_Status__c > b.Sub_Status__c) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Sub_Status__c > b.Sub_Status__c) ? -1 : 1);
        }
        if(item=='caseRes')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Assigned_Resource__r.Name > b.Assigned_Resource__r.Name) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Assigned_Resource__r.Name > b.Assigned_Resource__r.Name) ? -1 : 1);
        }
        if(item=='caseVec')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.Assigned_Vehicle__r.Name > b.Assigned_Vehicle__r.Name) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.Assigned_Vehicle__r.Name > b.Assigned_Vehicle__r.Name) ? -1 : 1);
        }
        if(item=='caseStudent')
        {
            if(sortDirection == 'asc')
                currentData.sort((a, b) => (a.ETST_Student__r.Name > b.ETST_Student__r.Name) ? 1 : -1);
            else
                currentData.sort((a, b) => (a.ETST_Student__r.Name > b.ETST_Student__r.Name) ? -1 : 1);
        }
        component.set('v.currentData',currentData); 
    },
    /* sortData: function(component, event, helper) {
        var item=event.getSource().get('v.value');
        var currentData=component.get('v.currentData'); 
        currentData.sort((a, b) => (a.item > b.item) ? 1 : -1)
        component.set('v.currentData',currentData); 
    }, */
    searchRequest: function(component, event, helper) {
        var searchKey=component.get('v.searchText');
        console.log('searchKey-->'+searchKey);
        if(searchKey.length>2){
            var deliveryData = component.get('v.caseList');
            var fileredData =  deliveryData.filter(function(item) {
                return (item.CaseNumber.indexOf(searchKey) !== -1);
                // ||(item.Status.toLowerCase().indexOf(searchKey) !== -1);
            });
            
            component.set('v.currentData',fileredData);
            //component.set('v.totalRecords',fileredData.size); 
        }else{
            //component.set('v.start',0);
            //var start=component.get('v.start'); 
            //var corousalSize=component.get('v.corousalSize'); 
            //var deliveryData=component.get('v.deliveryData'); 
            component.set('v.currentData',component.get('v.caseList')); 
            //component.set('v.totalRecords',component.get("v.RecordsCount"));
        }
        
    },
    downloadCases :function(component, event, helper){
        var allCases=component.get("v.caseList");
        component.set("v.finalListToAdd",allCases);
        var finalListToDownload=component.get("v.finalListToAdd");
        var csv=helper.convertArrayOfObjectsToCSV(component,finalListToDownload); 
        if(csv==null)
        {
            return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='CaseExportData.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        $A.get('e.force:refreshView').fire();   
    },
    downloadCasesNew :function(component, event, helper){
        var allCases=component.get("v.currentData");
        component.set("v.finalListToAdd",allCases);
        var finalListToDownload=component.get("v.finalListToAdd");
        var csv=helper.convertArrayOfObjectsToCSV(component,finalListToDownload); 
        if(csv==null)
        {
            return ;
        }                         
        var elementLink=document.createElement('a');
        elementLink.href='data:text/csv;charset=utf-8,'+encodeURI(csv);
        elementLink.target='_self';
        elementLink.download='CaseExportData.csv';
        document.body.appendChild(elementLink);
        elementLink.click();
        $A.get('e.force:refreshView').fire();   
    },
    openConfirmModal: function(component,event,helper){
        
        var recId=event.getSource().get('v.value');
        console.log('recId 33 '+recId);
        var status=event.getSource().get('v.label');
        console.log('status '+status);
        component.set("v.status",status);  
        component.set("v.caseId",recId);
        component.set("v.caseCommentsRequired", false);
        var reject = component.get('v.clReject');
        var reply = component.get('v.clReply');
        console.log('status***'+status);
        if(status === reject || status === reply){
            component.set("v.caseCommentsRequired", true);
        }
        component.set("v.confirmFlag",true);
    },
    closeConfirmModal: function(component,event,helper){
        
        component.set("v.confirmFlag",false);
    },
    updateCase: function(component, event,helper){
        
        component.set("v.isDisabled", true);
        var recId = component.get("v.caseId");
        console.log('recId385 '+recId);
        var status = component.get("v.status");
        
        var caseComments = component.get("v.comments");
        var approve = component.get('v.clApprove');
        var reject = component.get('v.clReject');
        var close = component.get('v.clComplete');
        console.log('status value'+status);
        console.log('close value'+close);
        console.log('approve value'+approve);
        console.log('reject value'+reject);
        var val = component.find("comment").get("v.value");
        console.log('val '+val);
        if(status == approve){
            console.log('inside approve');
            helper.approveCaseHelper(component, event,helper,recId);
        }else if(status == reject){
            console.log('inside reject');
            if(val == null || val == '' || val== 'undefined'){
                component.find("comment").showHelpMessageIfInvalid();
                component.set("v.isDisabled", false);
            }else{
                helper.rejectCaseHelper(component, event,helper,recId);
            }
        }else if(status == close){
            console.log('inside close');
            helper.closeCaseHelper(component, event,helper,recId);
        }else{
            console.log('outside if');
        }
    },
    openCloseCaseModal : function(component, event, helper) {
        var ticketId = event.getSource().get('v.value');
        console.log('ticketId  = '+ ticketId);
        component.set('v.ticketId',ticketId);        
        component.set('v.isCancelModal',true);
    },
    
    openAddCommentsModal : function(component, event, helper) {
        var ticket = event.getSource().get('v.value');
        console.log('ticket  = '+ ticket);
        component.set('v.ticketId',ticket);        
        component.set('v.isAddCommentModal',true);
    },
    
    openViewCommentsModal : function(component, event, helper) {
        var ticket = event.getSource().get('v.value');
        console.log('ticket  = '+ ticket);
        component.set('v.ticketId',ticket);        
        component.set('v.isViewCommentsModal',true);
    },
    
})