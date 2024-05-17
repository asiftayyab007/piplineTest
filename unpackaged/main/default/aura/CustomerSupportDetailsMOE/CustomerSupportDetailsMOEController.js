({
    doInit: function (component, event, helper) {
        var action = component.get('c.getDashboardData');
        var searchFilterCall= false;
        action.setParams({
            
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                /*component.set('v.caseList', a.getReturnValue());
                var newCasesCounter = 0;
                var escalatedCasesCounter = 0;
                var onHoldCasesCounter = 0;
                var invalidCasesCounter = 0;
                var newClosedCasesCounter = 0;
                
                for (var item in result) {
                    if (result[item].Status == 'New') {
                        newCasesCounter++;
                    }
                   else if (result[item].Status == 'Pending with Special Education' || result[item].Status == 'Pending with Department Of School Services'
                           || result[item].Status == 'Pending with Department Of School Activities') {
                        escalatedCasesCounter++;
                    }
                    
                    else if (result[item].Status == 'On Hold') {
                        onHoldCasesCounter++;
                    }else if (result[item].Status == 'Approved') {
                        invalidCasesCounter++;
                    }else if (result[item].Status == 'Closed') {
                        newClosedCasesCounter++;
                    }
                }*/
                
                component.set('v.newCases', result.newCount);
                component.set('v.escalatedCases', result.inprogressCount);
                component.set('v.onHoldCases', result.rejectedCount);
                component.set('v.invalidCases', result.approvedCount);
                component.set('v.closedCases', result.closedCount);
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
      /*  var modalBody;
        var modalFooter;
        $A.createComponents([
            ["c:CaseB2BPopupMOE",{
                "recordId": '',
            }]
        ],
         function(components, status){
              if (status === "SUCCESS") {
                 modalBody = components[0];
                 component.find('overlayLib').showCustomModal({
                     header: "Customer Care Request",
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
         });*/
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
        /*  var appEvent = $A.get("e.c:MyBusinessDetailPageEvent");
        appEvent.setParams({
            "showIFrame": true,
            "selectedRecordId": recId,
            "selectedRecordType":"case/"
        });
        appEvent.fire();*/
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "case/");
    },
    handleSalesAgreementClick: function (component, event, helper) {
        var recId = event.target.id;
        /*  var appEvent = $A.get("e.c:MyBusinessDetailPageEvent");
        appEvent.setParams({
            "showIFrame": true,
            "selectedRecordId": recId,
            "selectedRecordType":"et-sales-agreement/"
        });
        appEvent.fire*/
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "et-sales-agreement/");
    },
    handleAssignedResourcesClick: function (component, event, helper) {
        
        var recId = event.target.id;
        /*  var appEvent = $A.get("e.c:MyBusinessDetailPageEvent");
        appEvent.setParams({
            "showIFrame": true,
            "selectedRecordId": recId,
            "selectedRecordType":'saline-assigned-resource/'
        });
        appEvent.fire();*/
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "saline-assigned-resource/");
    },
    handleAssignedVehiclesClick: function (component, event, helper) {
        
        var recId = event.target.id;
        /*   var appEvent = $A.get("e.c:MyBusinessDetailPageEvent");
        appEvent.setParams({
            "showIFrame": true,
            "selectedRecordId": recId,
            "selectedRecordType":'saline-assigned-vehicle/'
        });
        appEvent.fire(); */
        component.set("v.showRecordDetailModal", true);
        component.set("v.recordDetailId", recId);
        component.set("v.recordTypeName", "saline-assigned-vehicle/");
    },
    handleStudentClick: function (component, event, helper) {
        
        var recId = event.target.id;
        /*   var appEvent = $A.get("e.c:MyBusinessDetailPageEvent");
        appEvent.setParams({
            "showIFrame": true,
            "selectedRecordId": recId,
            "selectedRecordType":'invoice/'
        });
        appEvent.fire();*/
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
   sortData: function(component, event, helper) {
        var item=event.getSource().get('v.value');
        var currentData=component.get('v.currentData'); 
        currentData.sort((a, b) => (a.item > b.item) ? 1 : -1)
        component.set('v.currentData',currentData); 
    }, 
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
    }
})