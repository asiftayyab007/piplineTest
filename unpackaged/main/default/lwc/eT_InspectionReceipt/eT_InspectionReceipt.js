import { LightningElement, track, wire, api } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { loadStyle } from 'lightning/platformResourceLoader';
import ET_inspectionExternalStyle from '@salesforce/resourceUrl/ET_inspectionExternalStyle'
import LOGO_LEFT from "@salesforce/resourceUrl/logoleft";
import LOGO_RIGHT from "@salesforce/resourceUrl/logoright";
import getReceiptDetails from '@salesforce/apex/ETI_InspectionReceiptCtrl.searchInspectionReceipt';
import saveReceiptDetails from '@salesforce/apex/ETI_InspectionReceiptCtrl.saveInspectionReceipt';
import getRelatedFilesByRecordId from '@salesforce/apex/ETI_InspectionReceiptCtrl.getRelatedFilesByRecordId';
import uploadFile from '@salesforce/apex/ETI_InspectionReceiptCtrl.uploadFile';
import deleteFile from '@salesforce/apex/ETI_InspectionReceiptCtrl.deleteFile';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from '@salesforce/apex';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id'; 
import NAME_FIELD from '@salesforce/schema/User.Name'; 
import EMPLOYEENUMBER_FIELD from '@salesforce/schema/User.EmployeeNumber';

export default class ET_InspectionReceipt extends NavigationMixin(LightningElement) {
	logoleft = LOGO_LEFT;
	logoright = LOGO_RIGHT;
	showSpinner = false;
	@track error ;
    @track name;
	@track searchInput = '';
	@track searchInputCodes = '';
	@track receiptDetails;
	@track responseWrapper;
	todayDate;
	@track isCodesModalOpen;
	@track activeSection;
	@track activeSections = [];
	@track inspCodes = [];
	@track allCodes = [];
	@track oldCodes = [];
	@track isCodesUpdated = false;
	@track filesList = [];
	@track inspRecId = '';
	@track filterCodes = [];
	@track defectsMap = new Map();
	@track defectsArray = [];
	@track inspectorDetail = [];
	@track testResult = '';
	fileData;
	@track inspRecptFields = 'Id,AMAN_Receipt_No__c,Major_Codes__c,Minor_Codes__c,Bookings__r.Name,Vehicle_Make__c,Vehicle_Model__c,Is_Inspection_Completed__c,Remarks__c,Steering_Type__c,Gear_Type__c,No_Of_Tires__c,No_Of_Seats__c,No_Of_Doors__c,Weight_Loaded__c,Weight_Unloaded__c,Horse_Power__c,No_Of_Cylinders__c,Fuel_Type__c,Engine_No__c,Chasis_No__c,Model_Year__c,Country__c,Vehicle_Type__c,No_Of_Axles__c,Inspector_Name__c,Inspector_Id__c'

	@wire(getRecord, {
         recordId: USER_ID,
         fields: [NAME_FIELD,EMPLOYEENUMBER_FIELD]
     }) wireuser({
         error,
         data
     }) {
         if (error) {
            this.error = error ; 
         } else if (data) {
			console.log('data: '+JSON.stringify(data));
            this.inspectorDetail.push({name:data.fields.Name.value, empNum:data.fields.EmployeeNumber.value});
			console.log('inspectorDetail: '+JSON.stringify(this.inspectorDetail));
         }
     }

	connectedCallback() {
		this.status = 'draft';
		var today = new Date();
		this.todayDate = today;
		console.log(today);
	}

	fetchReceiptData() {
		this.allCodes = [];
		this.inspCodes = [];
		this.activeSection = '';
	    this.activeSections = [];
		this.defectsMap = new Map();
	    this.defectsArray = [];
		this.testResult = '';
		const fieldElement = this.template.querySelector('[data-id="searchIpnutId"]');
		if (fieldElement) {
			this.searchInput = fieldElement.value;
		}
		this.showSpinner = true;
		console.log('search Input >> ' + this.searchInput);
		getReceiptDetails({
			searchStr: this.searchInput,
			inspRecptFields: this.inspRecptFields
		}).then((response) => {
			//console.log('response: ' + JSON.stringify(JSON.parse(response)));
			if (JSON.parse(response) != null && JSON.parse(response) != '') {
				this.responseWrapper = JSON.parse(response);
				//console.log('Taj1: '+JSON.stringify(this.responseWrapper.inspRecpt.Is_Inspection_Completed__c));
				if (this.responseWrapper.isSuccess) {
					this.inspRecId = this.responseWrapper.inspRecpt.Id;
					this.fetchFiles(); //retrieve files
					//alert(this.inspRecId);
					if(this.inspectorDetail.length > 0 && this.responseWrapper.inspRecpt.Is_Inspection_Completed__c == false){
						this.responseWrapper.inspRecpt.Inspector_Name__c = this.inspectorDetail[0].name;
						this.responseWrapper.inspRecpt.Inspector_Id__c = this.inspectorDetail[0].empNum;
		            }
					if(this.responseWrapper.inspRecpt.Is_Inspection_Completed__c == true){
					if(this.responseWrapper.inspRecpt.Major_Codes__c != null && this.responseWrapper.inspRecpt.Major_Codes__c != '')
						this.testResult = 'Fail';
					else
					    this.testResult = 'Pass';
		            }
					console.log('responseWrapper.receiptWrp: '+JSON.stringify(this.responseWrapper.receiptWrp));
					if (this.responseWrapper.receiptWrp != null && this.responseWrapper.receiptWrp != '') {
						this.receiptDetails = this.responseWrapper.receiptWrp.ReceiptDetails;
						console.log('receiptDetails >>> ' + JSON.stringify(this.receiptDetails));
						//console.log('fetchInspectionCodes >>> ' + JSON.stringify(this.responseWrapper.receiptWrp.inspCodeMap));
						var mapCodes = this.responseWrapper.receiptWrp.inspCodeMap;
						for (var key1 in mapCodes) {
							this.inspCodes.push({
								inspCodeDetails: mapCodes[key1].inspCodeDetails,
								defectCount: mapCodes[key1].defectCount,
								label: key1+' ('+mapCodes[key1].defectCount+'/'+mapCodes[key1].inspCodeDetails.length+')',
								key: key1
							});
						}
						console.log('inspCodes >>> ' + JSON.stringify(this.inspCodes));
						var codesNew = this.responseWrapper.inspCodesNew;
						for (var key2 in codesNew) {
							this.allCodes.push({
								code: codesNew[key2].code,
								defect: codesNew[key2].defect,
								record: codesNew[key2].recVDT
							});
						}
						console.log('codesNew: ' + JSON.stringify(codesNew));
						var codesOld = this.responseWrapper.receiptWrp.inspCodesOld;
						for (var key3 in codesOld) {
							this.oldCodes.push({
								code: codesOld[key3].code,
								defect: codesOld[key3].defect,
								record: codesOld[key3].recVDT
							});
						}
						console.log('codesOld: ' + JSON.stringify(codesOld));
						//this.handleCodes(this.allCodes, event.target.dataset.id, event.detail.value, codes[key2].recordVDT);
						if (this.responseWrapper.receiptWrp.Status.toUpperCase() == 'S') {
							this.showToastNotification('Success', this.responseWrapper.receiptWrp.Message, 'success', 'pester');
						}
						else if (this.responseWrapper.receiptWrp.Status.toUpperCase() == 'E')
							this.showToastNotification('Error', this.responseWrapper.receiptWrp.Message, 'error', 'pester');
					} else {
						this.showToastNotification('Error', this.responseWrapper.message, 'error', 'pester');
					}
				} else {
					this.showToastNotification('Error', this.responseWrapper.message, 'error', 'pester');
				}
			} else {
				this.showToastNotification('Error', 'Error. Contact Admin', 'error', 'sticky');
			}
			this.showSpinner = false;
			//console.log('response receiptDetails: ' + JSON.stringify(this.receiptDetails));
		}).catch((error) => {
			console.log('error');
			console.error(error);
			this.showToastNotification('Error', error, 'error', 'sticky');
		})
	}
	
	handleFieldChange(event) {
		var fieldAPI = event.target.name;
		var fieldValue = event.target.value;
		console.log(fieldAPI + ' ' + fieldValue);
		this.responseWrapper.inspRecpt[fieldAPI] = fieldValue;
	}

	openCodesModal() {
		console.log('Open Popup');
		this.isCodesModalOpen = true;
		this.filterCodes = [];
		this.searchInputCodes = '';
	}

	closeCodesModal() {
		// to close modal set isModalOpen tarck value as false
		this.isCodesModalOpen = false;
	}

	handleToggleSection(event) {
		console.log('openSections >>> ' + event.detail.openSections);
		this.activeSections = event.detail.openSections;
		if (event.detail.openSections.length > 0)
			this.activeSection = event.detail.openSections[0];
		console.log('activeSection >>> ' + this.activeSection);
	}

	searchCodes(event) {
		const fieldElement = this.template.querySelector('[data-id="searchInputCodesId"]');
		if (fieldElement) {
			this.searchInputCodes = fieldElement.value;
		}
		console.log('searchInputCodes: '+this.searchInputCodes);
		if(this.searchInputCodes != '' && this.searchInputCodes != null){
           var allCodesValue = [],allCodes = [];
		   for(var key1 in this.inspCodes){
				//console.log(this.inspCodes[key1].key+' allCodesValue push: '+JSON.stringify(this.inspCodes[key1].inspCodeDetails));
                allCodesValue.push(this.inspCodes[key1].inspCodeDetails);
			}
		//console.log(allCodesValue.length+' - '+JSON.stringify(allCodesValue));	
			for(var key2 in allCodesValue){
				//console.log(key2+' allCodes push: '+JSON.stringify(allCodesValue[key2]));
                allCodes.push.apply(allCodes,allCodesValue[key2]);
			}
		console.log(allCodes.length+' - '+JSON.stringify(allCodes));
        var term = this.searchInputCodes,regex;
			try {
                    regex = new RegExp(term, "i");
					console.log(regex);
                    this.filterCodes = allCodes.filter(
						row => 
						regex.test(row.recordVDT.Id__c) || 
						regex.test(row.recordVDT.Test_Type_Name_En__c.toString())
						);
                 } catch (e) {
					console.log(e);
                    console.log('error in search');
             }
		console.log('filterCodes: '+JSON.stringify(this.filterCodes));
		}
	}

	handleSeverityChange(event) {
		//alert(event.target.dataset.id+' '+event.target.name);
		//if(this.activeSection != ''){
		var secCodes = this.inspCodes;
		//console.log('secCodes : '+JSON.stringify(secCodes));
		console.log('target name : ' + event.target.name);
		var codes;
		for (var key1 in secCodes) {
			if (secCodes[key1].key == event.target.name) {
				codes = secCodes[key1].inspCodeDetails;
				//console.log(key1 + ' key1 >>> ' + JSON.stringify(secCodes[key1].inspCodeDetails));
			}
		}
		//console.log('codes - '+JSON.stringify(codes));
		const defectsMap = this.defectsMap;
		const defectsArray = this.defectsArray;
		for (var key2 in codes) {
			//alert(key2+' - '+JSON.stringify(codes[key2]));
			if (codes[key2].recordVDT.Id__c == event.target.dataset.id) {
				//alert(codes[key2].selectedOption+' - '+event.detail.value);
				if(event.detail.value == 'Major Defect' || event.detail.value == 'Minor Defect'){
                   if(!defectsArray.includes(event.target.dataset.id)){
					defectsArray.push(event.target.dataset.id);
					if(!defectsMap.has(codes[key2].recordVDT.Type__c)){
					defectsMap.set(codes[key2].recordVDT.Type__c, 1);
					//console.log(defectsMap);
					}else{
						//console.log(defectsMap);
					defectsMap.set(codes[key2].recordVDT.Type__c,defectsMap.get(codes[key2].recordVDT.Type__c)+1);
					}
				  }
			    }
				else if(event.detail.value == 'Qualified'){
					if(defectsArray.includes(event.target.dataset.id)){
						if(defectsMap.has(codes[key2].recordVDT.Type__c)){
							const index = defectsArray.indexOf(event.target.dataset.id);
							if (index > -1)
							defectsArray.splice(index, 1); 
						if(defectsMap.get(codes[key2].recordVDT.Type__c)-1 >= 0)
						defectsMap.set(codes[key2].recordVDT.Type__c,defectsMap.get(codes[key2].recordVDT.Type__c)-1);
					}
				}
				}
				codes[key2].selectedOption = event.detail.value;
				this.handleCodes(this.allCodes, event.target.dataset.id, event.detail.value, codes[key2].recordVDT);
				this.isCodesUpdated = true;
				//console.log(key2+' key2 >>> '+JSON.stringify(codes[key2]));
			}
		}
		this.defectsMap = defectsMap;
		console.log(defectsMap.size);
		console.log(defectsMap);
		for (var key3 in secCodes) {
			if (defectsMap.has(secCodes[key3].key)) {
				secCodes[key3].defectCount = defectsMap.get(secCodes[key3].key);
				secCodes[key3].label = secCodes[key3].key+' ('+secCodes[key3].defectCount+'/'+secCodes[key3].inspCodeDetails.length+')';
				//console.log(key3 + ' key3 >>> ' + JSON.stringify(secCodes[key3].inspCodeDetails));
			}
		}
		console.log('isCodesUpdated : ' + this.isCodesUpdated);
		this.inspCodes = secCodes;
		//console.log('udpated inspCodes : '+JSON.stringify(this.inspCodes));
		//}
	}

	handleCodes(allCodes, datasetId, value, record) {
		console.log(datasetId + ' removeElement ' + value);
		if (value == 'Major Defect')
			allCodes.push({
				code: datasetId,
				defect: 'Major',
				record: record
			});
		if (value == 'Minor Defect')
			allCodes.push({
				code: datasetId,
				defect: 'Minor',
				record: record
			});
		for (var key in allCodes) {
			console.log('key >> ' + key + ' code >> ' + allCodes[key]);
			if (value == 'Major Defect') {
				if (allCodes[key].code == datasetId && allCodes[key].defect == 'Minor') {
					if (key != -1)
						allCodes.splice(key, 1);
				}
			} else if (value == 'Minor Defect') {
				if (allCodes[key].code == datasetId && allCodes[key].defect == 'Major') {
					if (key != -1)
						allCodes.splice(key, 1);
				}
			} else if (value == 'Qualified') {
				if (allCodes[key].code == datasetId && (allCodes[key].defect == 'Major' || allCodes[key].defect == 'Minor')) {
					if (key != -1)
						allCodes.splice(key, 1);
				}
			}
		}
		this.testResult = 'Pass';
		for (var key2 in allCodes) {
			if (allCodes[key2].defect == 'Major'){
             this.testResult = 'Fail';
			 break;
			}
		}
		this.allCodes = allCodes;
		console.log('allCodes : ' + this.allCodes);
	}

	get disableSave() {
		console.log('disableSave');
		if (this.allCodes.length > 0 && this.isCodesUpdated == true)
			return false;
		else
			return true;
	}

	get disableCancel() {
		console.log('disableCancel');
		if (this.allCodes.length > 0 && this.isCodesUpdated == true)
			return true;
		else
			return false;
	}

	openfileUpload(event) {
		const file = event.target.files[0];
		if (!file) {
			this.showToastNotification('warning', 'Please select a file', '', 'pester');
			return;
		}
		var reader = new FileReader();
		reader.onload = () => {
			var base64 = reader.result.split(',')[1];
			this.fileData = {
				'filename': file.name,
				'base64': base64,
				'recordId': this.inspRecId
			}
			//console.log('fileData: '+JSON.stringify(this.fileData));
			this.handleUpload();
		}
		reader.readAsDataURL(file);
	}

	handleUpload() {
		this.showSpinner = true;
		console.log('filename: ' + this.fileData.filename);
		const { base64, filename, recordId } = this.fileData;
		uploadFile({ base64: base64, filename: filename, recordId: recordId }).then(result => {
			console.log('result: ' + result);
			if (result != null && result != '') {
				let title = this.fileData.filename + ' uploaded successfully!';
				this.showToastNotification('Success', title, 'success', 'pester');
				this.fileData = null;
				this.fetchFiles();
			}
		})
		this.showSpinner = false;
	}

	fetchFiles() {
		console.log('fetchFiles');
		getRelatedFilesByRecordId({
			recordId: this.responseWrapper.inspRecpt.Id
		}).then((response) => {
			console.log('fetchFiles >>> ' + JSON.stringify(response));
			if (response != null && response != '') {
				this.filesList = Object.keys(response).map(item => ({
					"label": response[item],
					"value": item,
					"url": `/sfc/servlet.shepherd/document/download/${item}`
				}))
				console.log(this.filesList)
			} else {
				this.filesList = [];
			}
		}).catch((error) => {
			console.log('error');
			console.error(error);
			this.showToastNotification('Error', error, 'error', 'sticky');
		})
	}

	get uploadDisabled() {
		var filesList = this.filesList;
		if (filesList.length >= 5) {
			return true;
		} else {
			return false;
		}
	}

	previewHandler(event) {
		console.log(event.target.dataset.id);
		this[NavigationMixin.Navigate]({
			type: 'standard__namedPage',
			attributes: {
				pageName: 'filePreview'
			},
			state: {
				selectedRecordId: event.target.dataset.id
			}
		})
	}

	deleteHandler(event) {
		console.log(event.target.dataset.id);
		deleteFile({
			ContentDocId: event.target.dataset.id
		}).then((response) => {
			console.log('deleteFile response >>> ' + response);
			if (response != null && response != '') {
				if (response == true)
					this.showToastNotification('Success', 'File deleted Successfully!', 'success', 'pester');
				else
					this.showToastNotification('Error', 'File not deleted', 'error', 'sticky');
				this.fetchFiles();
			}
		}).catch((error) => {
			console.log('error');
			console.error(error);
			this.showToastNotification('Error', error, 'error', 'sticky');
		})
	}

	downloadHandler(event) {
		console.log(event.target.dataset.id);
		window.open(event.target.dataset.id);
	}

	saveReceiptData() {
		this.showSpinner = true;
		console.log('inspRecpt: ' + JSON.stringify(this.responseWrapper.inspRecpt));
		var inspRecpt = this.responseWrapper.inspRecpt;
		inspRecpt.Is_Inspection_Completed__c = true;
		delete inspRecpt.attributes;
		delete inspRecpt.Bookings__r;
		var allCodes = this.allCodes;
		var majorStr = '';
		var minorStr = '';
		for (var key in allCodes) {
			console.log('ABC ' + allCodes[key].code + ' ' + allCodes[key].defect);
			if (allCodes[key].defect == 'Major') {
				if (majorStr == '')
					majorStr = allCodes[key].code;
				else
					majorStr = majorStr + ';' + allCodes[key].code;
			}
			if (allCodes[key].defect == 'Minor') {
				if (minorStr == '')
					minorStr = allCodes[key].code;
				else
					minorStr = minorStr + ';' + allCodes[key].code;
			}
		}
		inspRecpt.Major_Codes__c = majorStr;
		inspRecpt.Minor_Codes__c = minorStr;
		console.log('majorStr: ' + majorStr + ' minorStr: ' + minorStr);
		console.log('inspRecpt: ' + JSON.stringify(inspRecpt));
		saveReceiptDetails({
			inspRecpt: inspRecpt,
			inspRecptFields: this.inspRecptFields
		}).then((response) => {
			console.log('response final: ' + JSON.stringify(JSON.parse(response)));
			this.showSpinner = false;
			//this.fetchReceiptData();
			if (JSON.parse(response) != null && JSON.parse(response) != '') {
				this.responseWrapper.inspRecpt = JSON.parse(response);
				this.status = 'submitted';
				refreshApex(this.responseWrapper.inspRecpt);
				this.showToastNotification('Success', 'Saved succussfully', 'success', 'pester');
			} else
				this.showToastNotification('Error', 'Issue while saving. Pleae contact admin', 'error', 'sticky');
		}).catch((error) => {
			console.log('error');
			console.error(error);
			this.showToastNotification('Error', error, 'error', 'sticky');
		})
	}

	showToastNotification(title, message, variant, mode) {
		console.log(message);
		const evt = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant, //info (default), success, warning, and error
			mode: mode //dismissible (default), pester, sticky
		});
		this.dispatchEvent(evt);
	}

	renderedCallback() {
		Promise.all([
			loadStyle(this, ET_inspectionExternalStyle)
		])
			.then(() => {
				console.log("All scripts and CSS are loaded. perform any initialization function.")
			})
			.catch(error => {
				console.log("failed to load the scripts");
			});
	}

}