({ 
    
    getBaseData: function(component, event, helper) {
        var isOnLoad=component.get("v.isOnLoad");
        var skillSetGroup = [];
        var reqSkillSets=component.get("v.skillSets");
        if(!$A.util.isUndefinedOrNull(reqSkillSets)){
            for(var i in reqSkillSets){
                var skillDet={};
                skillDet.label=reqSkillSets[i].Name;
                skillDet.value=reqSkillSets[i].Name;
                skillSetGroup.push(skillDet);
            }
        }
             
        var isUsagePresent=false;        
        var toolsListOptions = [];
        var toolUsageListOptions=component.get("v.toolUsageListOptions");//get current usage
        
        var reqtoolSets=component.get("v.stationWrapperTools");
        if(!$A.util.isUndefinedOrNull(reqtoolSets)){
            for(var i in reqtoolSets){                
                var toolDet={};
                var labelStr=reqtoolSets[i].stationTool.ETT_Tools_Master__r.Name;
                if(!$A.util.isUndefinedOrNull(reqtoolSets[i].stationTool.ETT_Tools_Master__r.ETT_Unique_Code__c)){
                    labelStr+=' (Item Code: '+reqtoolSets[i].stationTool.ETT_Tools_Master__r.ETT_Unique_Code__c+') ';
                }
                if(!$A.util.isUndefinedOrNull(reqtoolSets[i].stationTool.ETT_Tools_Master__r.ETT_Serial_No__c)){
                    labelStr+=' (Serial No: '+reqtoolSets[i].stationTool.ETT_Tools_Master__r.ETT_Serial_No__c+') ';
                }
                if(!$A.util.isUndefinedOrNull(reqtoolSets[i].stationTool.Allocation_Status__c)){
                    labelStr+=' (Status: '+reqtoolSets[i].stationTool.Allocation_Status__c+') ';
                }
                if(reqtoolSets[i].stationTool.ETT_Tools_Master__r.ETT_Usage_type__c=='Consumable'){
                    labelStr+=' (Available Stocks : '+reqtoolSets[i].stationTool.ETT_Available_Stocks__c+' '+reqtoolSets[i].stationTool.ETT_Tools_Master__r.Unit_Text__c+') ';
                }
                if(reqtoolSets[i].stationTool.ETT_Tools_Master__r.ETT_Main_Stock_Units__c){
                    labelStr+=' (Main Stock :'+reqtoolSets[i].stationTool.ETT_Tools_Master__r.ETT_Main_Stock_Units__c+')';
                }
                if(reqtoolSets[i].stationTool.ETT_Tools_Master__r.ETT_Allocated_Units__c){
                    labelStr+=' (Factory Stock :'+reqtoolSets[i].stationTool.ETT_Tools_Master__r.ETT_Allocated_Units__c+')';
                }
                
                toolDet.label=labelStr;
                toolDet.value=reqtoolSets[i].stationTool.Id;
                toolDet.isSelected=false;
                toolDet.remarks='';//used to capture comments from user to create new request.
                toolDet.requestedStockUnits=reqtoolSets[i].stationTool.ETT_Allocated_Units_to_Station__c;//default value from current allocation
                toolDet.toolAllocationDet=reqtoolSets[i].stationTool;
                toolDet.toolUsage=reqtoolSets[i].usageRec;  
                toolDet.toolImageLink=reqtoolSets[i].toolImageLink;  
                toolDet.lstFileWrapperDetails=reqtoolSets[i].lstFileWrapperDetails; 
                toolsListOptions.push(toolDet);
                
                if(isOnLoad==true && (reqtoolSets[i].stationTool.Allocation_Status__c=='Approved' || reqtoolSets[i].stationTool.Allocation_Status__c=='Almost Used')){
                    toolUsageListOptions.push(toolDet);
                }
                else{
                    isUsagePresent=false;
                    for(let j in toolUsageListOptions){
                        if(toolUsageListOptions[j].toolAllocationDet.Id == reqtoolSets[i].stationTool.Id){
                            isUsagePresent=true;
                        }
                    }
                    if(!isUsagePresent && (reqtoolSets[i].stationTool.Allocation_Status__c=='Approved' || reqtoolSets[i].stationTool.Allocation_Status__c=='Almost Used')){
                        toolUsageListOptions.push(toolDet);
                    }
                }
                
                
                if(reqtoolSets[i].stationTool.Allocation_Status__c!='Approved' && reqtoolSets[i].stationTool.Allocation_Status__c!='Almost Used' && reqtoolSets[i].stationTool.Allocation_Status__c!='Rejected'){
                    component.set("v.step_error","Some of the requested tools/consumables are not approved/pending approval. Reach out to Supervisor for assistance.");
                }
            }
            
            var mainGroup = [
              /*  {
                'label' : 'Requried Skill Sets',
                'value': '',
               'subitem': skillSetGroup
                },*/
                {
                'label' : 'Tools/Consumables',
                'value': '',
                'subitem': toolsListOptions
                }
            ];       
            component.set('v.options', mainGroup);   
                
            var itemsToRemove=[];
            if(!isOnLoad){
                for(let k in toolUsageListOptions){
                    isUsagePresent=false;
                    for(let l in toolsListOptions){
                        if(toolUsageListOptions[k].toolAllocationDet.Id == toolsListOptions[l].toolAllocationDet.Id){
                            isUsagePresent=true;
                        }
                    }
                    if(!isUsagePresent && (toolUsageListOptions[k].toolUsage.Id==null || $A.util.isUndefinedOrNull(toolUsageListOptions[k].toolUsage.Id))){
                        console.log('***toolUsageListOptions[k].toolUsage: '+toolUsageListOptions[k].toolUsage.ETT_Usage_Value__c+'-'+toolUsageListOptions[k].toolUsage.ETT_Usage_Value__c+'-'+toolUsageListOptions[k].toolUsage.ETT_Track_Depreciable_Item_Usage_at_JC__c);
                        if($A.util.isUndefinedOrNull(toolUsageListOptions[k].toolUsage.ETT_Usage_Value__c) || toolUsageListOptions[k].toolUsage.ETT_Usage_Value__c<=0){
                        	itemsToRemove.push(k);
                            console.log('***inside removal');
                        }
                        else if($A.util.isUndefinedOrNull(toolUsageListOptions[k].toolUsage.ETT_Track_Depreciable_Item_Usage_at_JC__c) || toolUsageListOptions[k].toolUsage.ETT_Track_Depreciable_Item_Usage_at_JC__c!=true){
                    		itemsToRemove.push(k);
                            console.log('***inside removal');
                        }
                    }
                }
                console.log('****itemsToRemove: '+itemsToRemove);
                if(itemsToRemove.length >0){
                    toolUsageListOptions.splice(itemsToRemove[0],itemsToRemove.length);
                    console.log('****toolUsageListOptions: '+toolUsageListOptions.length);
                }
            }
        }
        var toolmainGroup = [
            {
            'label' : 'Tools Required',
            'value': '',
            'subitem': toolsListOptions
        	}
        ];       
        component.set('v.toolsListOptions', toolsListOptions); //toolmainGroup
        component.set("v.toolUsageListOptions",toolUsageListOptions);//tool usage
                
        if(isOnLoad==true){
            component.set("v.isOnLoad",false);
        }
	},
    
    getDatafromParent:function(component,event,helper){
        
       /* var availableStations = [];
        var availableStationsList = component.get("v.availableStations");
        
        availableStations.push({"label":"---Select Work Station---","value":""});
        for(var key in availableStationsList){
            availableStations.push({'label': availableStationsList[key], value: availableStationsList[key]});
        }
        component.set("v.availableStations",availableStations);*/
        
        var goodNotGoodValues = [];
        goodNotGoodValues.push({key: 'Good', value: 'Good'});
        goodNotGoodValues.push({key: 'Not Good', value: 'Not Good'});
        component.set("v.goodNotGoodValues",goodNotGoodValues);
        
        var correctNotcorrectValues = [];
        correctNotcorrectValues.push({key: 'Correct', value: 'Correct'});
        correctNotcorrectValues.push({key: 'Not Correct', value: 'Not Correct'});
        component.set("v.correctNotcorrectValues",correctNotcorrectValues);
        
        var NotCorrectNotcorrectValues = [];
        NotCorrectNotcorrectValues.push({key: 'Not Correct', value: 'Not Correct'});
        NotCorrectNotcorrectValues.push({key: 'Correct', value: 'Correct'});
        component.set("v.NotCorrectNotcorrectValues",NotCorrectNotcorrectValues);
        
        
        var NotGoodAndGoodValues = [];
        NotGoodAndGoodValues.push({key: 'Not Good', value: 'Not Good'});
        NotGoodAndGoodValues.push({key: 'Good', value: 'Good'});        
        component.set("v.NotGoodAndGoodValues",NotGoodAndGoodValues);
        
        var highLowValues = [];
        highLowValues.push({key: 'High', value: 'High'});
        highLowValues.push({key: 'Low', value: 'Low'});
        component.set("v.highLowValues",highLowValues);
        
        var lowHighValues = [];
        lowHighValues.push({key: 'Low', value: 'Low'});
        lowHighValues.push({key: 'High', value: 'High'});  
        component.set("v.lowHighValues",lowHighValues);        
        
        var yesNoValues = [];
        yesNoValues.push({key: 'Yes', value: 'Yes'});
        yesNoValues.push({key: 'No', value: 'No'});  
        component.set("v.yesNoValues",yesNoValues);
        
        var noYesValues = [];
        noYesValues.push({key: 'No', value: 'No'});  
        noYesValues.push({key: 'Yes', value: 'Yes'});        
        component.set("v.noYesValues",noYesValues);
        
        var matchedNotValues = [];
        matchedNotValues.push({key: 'Matched', value: 'Matched'});
        matchedNotValues.push({key: 'Not Matched', value: 'Not Matched'});  
        component.set("v.matchedNotValues",matchedNotValues);
        
        var notMatchedValues = [];
        notMatchedValues.push({key: 'Not Matched', value: 'Not Matched'});  
        notMatchedValues.push({key: 'Matched', value: 'Matched'});    
        component.set("v.notMatchedValues",notMatchedValues);
        
        var sideBufferConditionReasons = [];
        sideBufferConditionReasons.push({key: 'Blade Change', value: 'Blade Change'});  
        sideBufferConditionReasons.push({key: 'Wire Brush Change', value: 'Wire Brush Change'}); 
         sideBufferConditionReasons.push({key: 'Counter Wheel', value: 'Counter Wheel'});
        component.set("v.sideBufferConditionReasons",sideBufferConditionReasons);
        
        var sevenstageReasonValue=[];
         var sevenstageReason = component.get("v.sevenstageReasonValue");
        sevenstageReasonValue.push({key: 'Bag Full', value: 'Bag Full'});  
        sevenstageReasonValue.push({key: 'Bag damage', value: 'Bag damage'});  
        sevenstageReasonValue.push({key: 'Others', value: 'Others'});  
         for(var key in sevenstageReason){
            sevenstageReasonValue.push({key: key, value: sevenstageReason[key]});
        }
        component.set("v.sevenstageReasonValue",sevenstageReasonValue);
        
        var dustCollectorReasonValues = [];
        var dustCollectorReason = component.get("v.dustCollectorReasonValues");
        dustCollectorReasonValues.push({key: 'Check Suction Line', value: 'Check Suction Line'});  
        dustCollectorReasonValues.push({key: 'Repair Suction Pipeline', value: 'Repair Suction Pipeline'});
        dustCollectorReasonValues.push({key: 'Change Suction Filter', value: 'Change Suction Filter'});  
        for(var key in dustCollectorReason){
            dustCollectorReasonValues.push({key: key, value: dustCollectorReason[key]});
        }
        component.set("v.dustCollectorReasonValues",dustCollectorReasonValues);
        
        var buffingSettingsReasonValues = [];
        var buffingSettings = component.get("v.buffingSettingsReasonValues");
        for(var key in buffingSettings){
            buffingSettingsReasonValues.push({key: key, value: buffingSettings[key]});
        }
        component.set("v.buffingSettingsReasonValues",buffingSettingsReasonValues);
        
        var buffingSettingsReasons = [];
        buffingSettingsReasons.push({key: 'Rim Change', value: 'Rim Change'});  
        buffingSettingsReasons.push({key: 'Radius setting', value: 'Radius setting'});
        buffingSettingsReasons.push({key: 'Bead adjustment', value: 'Bead adjustment'});
        component.set("v.buffingSettingsReasons",buffingSettingsReasons);
        
        
        var precuredTreadLineValues = [];
        var precuredTreadLine = component.get("v.precuredTreadLineValues");
        for(var key in precuredTreadLine){
            precuredTreadLineValues.push({key: key, value: precuredTreadLine[key]});
        }
        component.set("v.precuredTreadLineValues",precuredTreadLineValues);   
        
        var statusValues = [];
        statusValues.push({key: '', value: '---Select---'});
        statusValues.push({key: 'Accepted', value: 'Accepted'});
        statusValues.push({key: 'Initial Rejection', value: 'Initial Rejection'});
        component.set("v.statusValues",statusValues);
        
       
    },
    
    getJobDetails : function(component, event, helper,Nextlineitem,nextWorkTracker) {
        
        var action = component.get("c.getValidJobCardLineDetail");
        action.setParams({
            'recordId': component.get("v.recordId"),
            'stageValue': 'Buffing',
            'current_sequence': component.get("v.current_sequence"),
            'readOnlyView': !component.get('v.allowDML'),
            'Nextlineitem' : Nextlineitem,
            'nextWorkTracker' : nextWorkTracker
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") { 
                var respWrapper = response.getReturnValue();
                console.log(JSON.stringify(respWrapper));
                component.set("v.current_sequence",respWrapper.jobLineItem.Sequence__c);
                component.set("v.current_line",respWrapper);
                component.set("v.Nextlineitem",respWrapper.nextJobLineItem);
                component.set("v.nextWorkTracker",respWrapper.nextWorkTracker);
                component.set("v.lineItemForHold",respWrapper.holdLineItem);
                let data = respWrapper.relatedJobWrapper.availableNextStationList;     
                let availableStations = [];
                availableStations.push({"label":"---Select Work Station---","value":""});
                for(var key in data){
                    availableStations.push({'label': data[key], value: data[key]});
                }
                component.set("v.availableStations",availableStations);
                
                var holdReasonValues = [];
                var holdReasons = respWrapper.relatedJobWrapper.holdReasons;
                holdReasonValues.push({key: '', value: '---Select---'});
                for(var key in holdReasons){
                    holdReasonValues.push({key: key, value: holdReasons[key]});
                }
                component.set("v.holdReasonValues",holdReasonValues);
                
                
                var precuredTreadLineValues = [];
                var precuredTreadLine = respWrapper.relatedJobWrapper.buffing_precuredTreadLineValues;
                for(var key in precuredTreadLine){
                    precuredTreadLineValues.push({key: key, value: precuredTreadLine[key]});
                }
                component.set("v.precuredTreadLineValues",precuredTreadLineValues); 
                
                //console.log(component.get("v.availableStations"))
                component.set("v.selectedNextStation",respWrapper.relatedJobWrapper.nextStageValue);
                if(!component.get("v.current_line")) component.set("v.showNoRecordsMessage", true);
                else component.set("v.showNoRecordsMessage", false);
                if(respWrapper.holdLineItem.jobLineItem.Id!=null){
                    component.set("v.isOnHold",true);
                }
                component.set("v.step_error","");
                component.set("v.tyreMaster",respWrapper.relatedJobWrapper.tyreMaster);
                //alert(JSON.stringify(respWrapper.relatedJobWrapper.tyreMaster));
                component.set("v.treadMasterList",respWrapper.relatedJobWrapper.treadMasterList);
                component.set("v.tyreCrownInspection",respWrapper.relatedJobWrapper.tyreRejectionItemCrown);
               
                var width = component.get('v.tyreMaster.ETT_Actual_Width__c');
                component.set('v.current_line.jobLineItem.ETT_Desired_Width__c',width);
                
                var length = component.get('v.tyreMaster.ETT_Length__c');
                component.set('v.current_line.jobLineItem.ETT_Desired_Length__c',length);

                var od = component.get('v.tyreMaster.ETT_Tyre_Outer_Diameter_OD__c');
                component.set('v.current_line.jobLineItem.ETT_Tyre_Desired_OD__c',od);

                var pattern = component.get('v.current_line.relatedJobWrapper.validJobCardList[0].ETT_Tread_Master_Allocation__c');
                component.set('v.current_line.jobLineItem.ETT_Desired_Tread_Pattern__c',pattern);
                
                var treadMasterListValues=[];
                var treadList=respWrapper.relatedJobWrapper.treadMasterList;
                for(var i in treadList){
                	//treadMasterListValues.push({key: treadList[i].Id, value: treadList[i].ETT_Tools_Master__r.ETT_Tread_Width__c});  
                	treadMasterListValues.push({key: treadList[i].Id, value: treadList[i].ETT_Tools_Master__r.ETT_Pattern_Master__r.Name});  
                }
                
                component.set("v.treadMasterListValues",treadMasterListValues);
                var tyreCuts=component.get("v.tyreCrownInspection");
                
                var CutsNTC = [];
                var SelectedCutsNTC = [];
                var SelectedCutsNTCList = [];                
                var cutData_1=
                            {
                                class: "optionClass",
                                label: "Cuts (0 to 10mm)",
                                value: "Cuts (0 to 10mm)",
                                selectedValue: 1
                            };                
                if(tyreCuts.ETT_Number_of_cuts_0_10_mm__c>0){
                    cutData_1.selectedValue=tyreCuts.ETT_Number_of_cuts_0_10_mm__c;
                    SelectedCutsNTC.push('Cuts (0 to 10mm)');
                    SelectedCutsNTCList.push(cutData_1);
                }
                CutsNTC.push(cutData_1);
                
                var cutData_2=
                            {
                                class: "optionClass",
                                label: "Cuts (11 to 25mm)",
                                value: "Cuts (11 to 25mm)",
                                selectedValue: 1
                            };                
                if(tyreCuts.ETT_Number_of_cuts_11_to_25_mm__c>0){
                    cutData_2.selectedValue=tyreCuts.ETT_Number_of_cuts_11_to_25_mm__c;
                    SelectedCutsNTC.push('Cuts (11 to 25mm)');
                    SelectedCutsNTCList.push(cutData_2);
                }
                CutsNTC.push(cutData_2);
                
                var cutData_3=
                            {
                                class: "optionClass",
                                label: "Cuts (26 to 38mm)",
                                value: "Cuts (26 to 38mm)",
                                selectedValue: 1
                            };                
                if(tyreCuts.ETT_Number_of_cuts_26_to_38_mm__c>0){
                    cutData_3.selectedValue=tyreCuts.ETT_Number_of_cuts_26_to_38_mm__c;
                    SelectedCutsNTC.push('Cuts (26 to 38mm)');
                    SelectedCutsNTCList.push(cutData_3);
                }
                CutsNTC.push(cutData_3);
                
                var cutData_4=
                            {
                                class: "optionClass",
                                label: "Cuts (39 to 50mm)",
                                value: "Cuts (39 to 50mm)",
                                selectedValue: 1
                            };                
                if(tyreCuts.ETT_Number_of_cuts_39_to_50_mm__c>0){
                    cutData_4.selectedValue=tyreCuts.ETT_Number_of_cuts_39_to_50_mm__c;
                    SelectedCutsNTC.push('Cuts (39 to 50mm)');
                    SelectedCutsNTCList.push(cutData_4);
                }
                CutsNTC.push(cutData_4);
                
                var cutData_5=
                            {
                                class: "optionClass",
                                label: "Cuts (51mm and above)",
                                value: "Cuts (51mm and above)",
                                selectedValue: 1
                            };                
                if(tyreCuts.ETT_Number_of_cuts_51_mm_and_above__c>0){
                    cutData_5.selectedValue=tyreCuts.ETT_Number_of_cuts_51_mm_and_above__c;
                    SelectedCutsNTC.push('Cuts (51mm and above)');
                    SelectedCutsNTCList.push(cutData_5);
                }
                CutsNTC.push(cutData_5);
                
                component.set("v.selectedCutsNTC",SelectedCutsNTC);
                component.set("v.selectedCutsNTCList",SelectedCutsNTCList);
                component.set("v.tyreCutList", CutsNTC);
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to process your request."
                });
                toastEvent.fire(); 
            }
        });
        $A.enqueueAction(action);
	},
    
    updateJobCardLineItem: function(component, event, helper,line,moveNextstepOnCompletion,trackActivity,updateJobCard,Nextlineitem,nextWorkTracker){
       
        var action = component.get("c.updateJobCardLine");
        action.setParams({
            'jobCardlineWrapper': line,
            'trackActivity': trackActivity,
            'updateJobCard': updateJobCard,
            'selectedNextStation': component.get("v.selectedNextStation")
        });
        console.log('--line---'+JSON.stringify(line))
        console.log('--trackAct---'+JSON.stringify(trackActivity))
        console.log('--updJob---'+JSON.stringify(updateJobCard))
         console.log('--sele---'+component.get("v.selectedNextStation"))
        
        action.setCallback(this, function(response) {            
            if (response.getState() == "SUCCESS") {
                component.set("v.current_line",response.getReturnValue());
                var current_line=component.get("v.current_line");                
                var current_sequence=component.get("v.current_sequence");
                if(current_sequence ==8){
                    component.set("v.seq_8_lineId",current_line.jobLineItem.Id);
                } 
                if(moveNextstepOnCompletion==true){                    
                    var seq_8_initialState=component.get("v.seq_8_initialState");
                    if(current_sequence ==8 && seq_8_initialState =='Good'){
                        component.set("v.current_sequence",(current_sequence+4));
                    }
                    else{
                        component.set("v.current_sequence",(current_sequence+1));
                    }                	
                    this.getJobDetails(component, event, helper,Nextlineitem,nextWorkTracker);
                }          
            }
            else{
                var errors = response.getError();
                console.log('errors '+JSON.stringify(errors));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to process your request."
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);
    },
    getStageRecordtypeId: function(component, event, helper){
    	var action = component.get("c.getObjectRecordTypeIdByNme");
        action.setParams({
            'ObjectName': 'ETT_Job_Card_Line_Item__c',
            'recordTypeDeveloperName': 'Buffing'
        });
        action.setCallback(this, function(response) {            
            if (response.getState() == "SUCCESS") {
                component.set("v.recordTypeIdOfStageName",response.getReturnValue());
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to process your request."
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);	          
    },
    createNewToolRequestInitial: function(component, event, helper,selectedToolsToReplace,line){        
        var action = component.get("c.createToolRequestMethodVersion2");
    
        action.setParams({
            lineItem: line,
            toolAllocationList: selectedToolsToReplace,
            workscheduleStationId: component.get("v.workSheduleInfo.ETT_Work_Station__c")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                
                var respVal = response.getReturnValue();
                component.set("v.newToolRequests",response.getReturnValue());
                console.log(response.getReturnValue());
                //confirmed that request has been placed
                var current_sequence=component.get("v.current_sequence");
                if(current_sequence==1){//first step where user may raise tool request, pre populate the fields for inserting line items.
                    line.jobLineItem.ETT_Activity_Performed__c='Wearing, Workstation, Skills Set & Tools Check';
                    line.jobLineItem.ETT_Final_Activity_State__c='Good/Matched';
                    line.jobLineItem.ETT_Status__c='In-Progress';
                    line.jobLineItem.ETT_Type__c='Pre-Requisite Work';
                }
                line.jobLineItem.ETT_Tool_Material_Request_Raised__c=true;
                
                helper.updateJobCardLineItem(component, event, helper,line,false,false,false,null,null); //parameter usage: line item, gotoNext step, activity update, job card update, next line, next activity
                                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Info!",
                    "type" : "success",
                    "message": "Your request has been submitted for further approval.You can refresh or wait for the request to get approved."
                });
                toastEvent.fire(); 
            }
            else{
                var errors = response.getError();
                console.log(errors)
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to process your request."
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);
    },
    refreshRequestStatus: function(component, event, helper){
        var newToolReq=JSON.stringify(component.get("v.newToolRequests"));
        var action = component.get("c.refreshRequestStatusMethod");
        action.setParams({
            newToolReq: newToolReq
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var respVal = response.getReturnValue();
                component.set("v.newToolRequests",response.getReturnValue());
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to process your request."
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);
    },
    updateTyreDetails: function(component, event, helper){
        var action = component.get("c.updateTyreMasterDetails");
        action.setParams({
            tyreMaster: component.get("v.tyreMaster")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var respVal = response.getReturnValue();
                component.set("v.tyreMaster",response.getReturnValue());
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to process your request."
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);
    },
    updateTyreInspectionDetails: function(component, event, helper){
        var action = component.get("c.updateTyreInspectionDetailsToServer");
        action.setParams({
            tyreCrownInspection: component.get("v.tyreCrownInspection")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var respVal = response.getReturnValue();
                component.set("v.tyreCrownInspection",response.getReturnValue());                
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to process your request."
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);
    },
    updateJobCardLineItemForHold: function(component, event, helper,lineItemForHold,workActivityHold){
        var action = component.get("c.updateJobCardLine");
        action.setParams({
            'jobCardlineWrapper': lineItemForHold,
            'trackActivity': true,
            'updateJobCard': false
        });
        action.setCallback(this, function(response) {            
            if (response.getState() == "SUCCESS") {
                component.set("v.lineItemForHold",response.getReturnValue());
                var lineItemForHold=component.get("v.lineItemForHold");
                if(lineItemForHold.workTracker.ETT_End_time__c!=null){
                    component.set("v.isOnHold",false);
                    lineItemForHold.jobLineItem.Id=null;
                    lineItemForHold.workTracker.Id=null;
                }
                else{
                    component.set("v.isOnHold",true);
                }   
                component.set("v.confirmHoldVar",false);
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to process your request."
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);
    },
    getInitialization : function(component, event, helper) {//Not used as of now
        var action = component.get("c.initializeHoldLineItem");
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") { 
                component.set("v.lineItemForHold",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getStationTools: function(component, event, helper) {
        var action = component.get("c.getStationToolsWithWrapper");
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") { 
                component.set("v.stationWrapperTools",response.getReturnValue());
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to process your request."
                });
                toastEvent.fire();  
            }
            helper.getBaseData(component, event, helper);//call this helper at last so that other variables will be updated.
        });
        $A.enqueueAction(action);
    },
    updateToolMaterialUsage: function(component, event, helper,toolUsageListOptions,line) {
        var action = component.get("c.updateToolsUsageInDB");
        action.setParams({
            toolUsageListOptions: toolUsageListOptions, 
            jobLine: line
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") { 
                component.set("v.toolUsageListOptions",response.getReturnValue());
                var action = component.get("c.backFromUsage");
                $A.enqueueAction(action);
            }
            else{
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Unable to process your request."
                });
                toastEvent.fire();  
            }
            helper.getBaseData(component, event, helper);//call this helper at last so that other variables will be updated.
        });
        $A.enqueueAction(action);
    },
    shiftDiv: function(component, event,lWidth) {
        var changeposition = component.get("v.intervalId");
        var floatElement = document.getElementById('tofloat');	  
        if(changeposition < lWidth){
            floatElement.style.right = changeposition+'px';
            changeposition = changeposition + 1;
            component.set("v.intervalId",changeposition);
        }
        //reset the left to 0
        else{
            component.set("v.intervalId",0);
            floatElement.style.right = "10px";
            changeposition = component.get("v.intervalId");//resetting so as to hit the if block again
        }
    }
})