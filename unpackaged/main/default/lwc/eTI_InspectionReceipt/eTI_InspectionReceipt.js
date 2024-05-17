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

export default class ETI_InspectionReceipt extends NavigationMixin(LightningElement) {
   logoleft = LOGO_LEFT;
   logoright = LOGO_RIGHT;
   showSpinner = false;
   @track error;
   @track name;
   @track searchInput = '';
   @track receiptDetails;
   @track responseWrapper;
   todayDate;
   isCodesModalOpen;
   activeSectionsBreak = [];
   activeSectionsVisual = [];
   inspCodesBreak = [];
   inspCodesVisual = [];
   allCodesBreak = [];
   allCodesVisual = [];
   @track oldCodes = [];
   defectsMapBreak = new Map();
   defectsMapVisual = new Map();
   defectsArrayBreak = [];
   defectsArrayVisual = [];
   @track inspectorDetail = [];
   testResult = '';
   tabName = '';
   @track filesList = [];
   fileData;
   @track inspObsrFields = 'Id,Aman_Receipt__c,AMAN_Receipt_No__c,Break_Major_Codes__c,Visual_Major_Codes__c,Break_Minor_Codes__c,Visual_Minor_Codes__c,Vehicle_Make__c,Vehicle_Model__c,Vehicle_Color__c,Is_Break_Inspection_Completed__c,Is_Visual_Inspection_Completed__c,Remarks__c,Steering_Type__c,Gear_Type__c,No_Of_Tires__c,No_Of_Seats__c,No_Of_Doors__c,Weight_Loaded__c,Weight_Unloaded__c,Horse_Power__c,No_Of_Cylinders__c,Fuel_Type__c,Engine_No__c,Chassis_No__c,Model_Year__c,Country__c,Vehicle_Type__c,No_Of_Axles__c,Break_Inspector_Name__c,Visual_Inspector_Name__c,Break_Inspector_Id__c,Visual_Inspector_Id__c'

   @wire(getRecord, {
      recordId: USER_ID,
      fields: [NAME_FIELD, EMPLOYEENUMBER_FIELD]
   }) wireuser({
      error,
      data
   }) {
      if (error) {
         this.error = error;
      } else if (data) {
         //console.log('data: ' + JSON.stringify(data));
         this.inspectorDetail.push({
            name: data.fields.Name.value,
            empNum: data.fields.EmployeeNumber.value
         });
         //console.log('inspectorDetail: ' + JSON.stringify(this.inspectorDetail));
      }
   }

   connectedCallback() {
      var today = new Date();
      this.todayDate = today;
      //console.log(today);
   }

   fetchReceiptData() {
      this.inspCodesBreak = [];
      this.inspCodesVisual = [];
      this.allCodesBreak = [];
      this.allCodesVisual = [];
      this.oldCodes = [];
      this.activeSectionsBreak = [];
      this.activeSectionsVisual = [];
      this.defectsMapBreak = new Map();
      this.defectsMapVisual = new Map();
      this.defectsArrayBreak = [];
      this.defectsArrayVisual = [];
      this.testResult = '';
      this.receiptDetails = null;
      const fieldElement = this.template.querySelector('[data-id="searchIpnutId"]');
      if (fieldElement) {
         this.searchInput = fieldElement.value.toUpperCase();
      }
      this.showSpinner = true;
      //console.log('search Input >> ' + this.searchInput);
      getReceiptDetails({
         searchStr: this.searchInput,
         inspObsrFields: this.inspObsrFields
      }).then((response) => {
         //console.log('response: ' + JSON.stringify(JSON.parse(response))); 
         if (JSON.parse(response) != null && JSON.parse(response) != '') {
            this.responseWrapper = JSON.parse(response);
            //console.log('response inspRecpt: ' + JSON.stringify(this.responseWrapper.inspRecpt));
            //console.log('response inspObsr: ' + JSON.stringify(this.responseWrapper.inspObsr));
            if (this.responseWrapper.isSuccess) {
               this.fetchFiles(); //retrieve files
               if (!this.responseWrapper.inspObsr.Is_Break_Inspection_Completed__c || !this.responseWrapper.inspObsr.Is_Visual_Inspection_Completed__c)
                  this.initInspObsrRec(this.responseWrapper.inspObsr);
               if (this.inspectorDetail.length > 0 && this.responseWrapper.inspObsr.Is_Break_Inspection_Completed__c == false) {
                  this.responseWrapper.inspObsr.Break_Inspector_Name__c = this.inspectorDetail[0].name;
                  this.responseWrapper.inspObsr.Break_Inspector_Id__c = this.inspectorDetail[0].empNum;
               }
               if (this.inspectorDetail.length > 0 && this.responseWrapper.inspObsr.Is_Visual_Inspection_Completed__c == false) {
                  this.responseWrapper.inspObsr.Visual_Inspector_Name__c = this.inspectorDetail[0].name;
                  this.responseWrapper.inspObsr.Visual_Inspector_Id__c = this.inspectorDetail[0].empNum;
               }
               if (this.responseWrapper.inspObsr.Is_Break_Inspection_Completed__c == true || this.responseWrapper.inspObsr.Is_Visual_Inspection_Completed__c == true) {
                  if ((this.responseWrapper.inspObsr.Break_Major_Codes__c != null && this.responseWrapper.inspObsr.Break_Major_Codes__c != '') ||
                     (this.responseWrapper.inspObsr.Visual_Major_Codes__c != null && this.responseWrapper.inspObsr.Viusal_Major_Codes__c != ''))
                     this.testResult = 'Fail';
                  else
                     this.testResult = 'Pass';
               }
               //console.log('responseWrapper.receiptWrp: ' + JSON.stringify(this.responseWrapper.receiptWrp));
               if (this.responseWrapper.receiptWrp != null && this.responseWrapper.receiptWrp != '') {
                  this.receiptDetails = this.responseWrapper.receiptWrp.ReceiptDetails;
                  //console.log('receiptDetails >>> ' + JSON.stringify(this.receiptDetails));
                  var mapCodes = this.responseWrapper.receiptWrp.inspCodeMap;
                  for (var key1 in mapCodes) {
                     this.inspCodesBreak.push({
                        inspCodeDetails: mapCodes[key1].inspCodeDetails,
                        defectCount: mapCodes[key1].defectCount,
                        label: key1 + ' (' + mapCodes[key1].defectCount + '/' + mapCodes[key1].inspCodeDetails.length + ')',
                        key: key1
                     });
                  }
                  this.inspCodesVisual = this.inspCodesBreak;
                  //console.log('inspCodesBreak >>> ' + JSON.stringify(this.inspCodesBreak));
                  var codesNewBreak = this.responseWrapper.inspCodesNewBreak;
                  for (var key2 in codesNewBreak) {
                     this.allCodesBreak.push({
                        code: codesNewBreak[key2].code,
                        defect: codesNewBreak[key2].defect,
                        record: codesNewBreak[key2].recVDT
                     });
                  }
                  //console.log('codesNew: ' + JSON.stringify(codesNew));
                  var codesNewVisual = this.responseWrapper.inspCodesNewVisual;
                  for (var key3 in codesNewVisual) {
                     this.allCodesVisual.push({
                        code: codesNewVisual[key3].code,
                        defect: codesNewVisual[key3].defect,
                        record: codesNewVisual[key3].recVDT
                     });
                  }
                  //console.log('codesNew: ' + JSON.stringify(codesNew));
                  var codesOld = this.responseWrapper.receiptWrp.inspCodesOld;
                  for (var key4 in codesOld) {
                     this.oldCodes.push({
                        code: codesOld[key4].code,
                        defect: codesOld[key4].defect,
                        record: codesOld[key4].recVDT
                     });
                  }
                  //console.log('codesOld: ' + JSON.stringify(codesOld));
                  this.showToastNotification('Success', this.responseWrapper.message, 'success', 'pester');
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
      }).catch((error) => {
         console.log('error');
         console.error(error);
         this.showToastNotification('Error', error, 'error', 'sticky');
      })
   }

   initInspObsrRec(inspObsr) {
      //inspObsr.Id = '';
      if (!inspObsr.AMAN_Receipt_No__c) inspObsr.AMAN_Receipt_No__c = '';
      if (!inspObsr.Break_Major_Codes__c) inspObsr.Break_Major_Codes__c = '';
      if (!inspObsr.Visual_Major_Codes__c) inspObsr.Visual_Major_Codes__c = '';
      if (!inspObsr.Break_Minor_Codes__c) inspObsr.Break_Minor_Codes__c = '';
      if (!inspObsr.Visual_Minor_Codes__c) inspObsr.Visual_Minor_Codes__c = '';
      if (!inspObsr.Vehicle_Make__c) inspObsr.Vehicle_Make__c = '';
      if (!inspObsr.Vehicle_Model__c) inspObsr.Vehicle_Model__c = '';
      if (!inspObsr.Is_Break_Inspection_Completed__c) inspObsr.Is_Break_Inspection_Completed__c = false;
      if (!inspObsr.Is_Viusal_Inspection_Completed__c) inspObsr.Is_Viusal_Inspection_Completed__c = false;
      if (!inspObsr.Remarks__c) inspObsr.Remarks__c = '';
      if (!inspObsr.Steering_Type__c) inspObsr.Steering_Type__c = '';
      if (!inspObsr.Gear_Type__c) inspObsr.Gear_Type__c = '';
      if (!inspObsr.No_Of_Seats__c) inspObsr.No_Of_Seats__c = null;
      if (!inspObsr.No_Of_Doors__c) inspObsr.No_Of_Doors__c = null;
      if (!inspObsr.Weight_Loaded__c) inspObsr.Weight_Loaded__c = null;
      if (!inspObsr.Weight_Unloaded__c) inspObsr.Weight_Unloaded__c = null;
      if (!inspObsr.Horse_Power__c) inspObsr.Horse_Power__c = null;
      if (!inspObsr.No_Of_Cylinders__c) inspObsr.No_Of_Cylinders__c = null;
      if (!inspObsr.Fuel_Type__c) inspObsr.Fuel_Type__c = '';
      if (!inspObsr.Engine_No__c) inspObsr.Engine_No__c = '';
      if (!inspObsr.Chassis_No__c) inspObsr.Chassis_No__c = '';
      if (!inspObsr.Model_Year__c) inspObsr.Model_Year__c = '';
      if (!inspObsr.Country__c) inspObsr.Country__c = '';
      if (!inspObsr.Vehicle_Type__c) inspObsr.Vehicle_Type__c = '';
      if (!inspObsr.Vehicle_Color__c) inspObsr.Vehicle_Color__c = '';
      if (!inspObsr.No_Of_Axles__c) inspObsr.No_Of_Axles__c = null;
      if (!inspObsr.Break_Inspector_Name__c) inspObsr.Break_Inspector_Name__c = '';
      if (!inspObsr.Visual_Inspector_Name__c) inspObsr.Visual_Inspector_Name__c = '';
      if (!inspObsr.Break_Inspector_Id__c) inspObsr.Break_Inspector_Id__c = '';
      if (!inspObsr.Viusal_Inspector_Id__c) inspObsr.Viusal_Inspector_Id__c = '';
      this.responseWrapper.inspObsr = inspObsr;
      //console.log('inspObsr: '+JSON.stringify(this.responseWrapper.inspObsr))
   }

   handleFieldChange(event) {
      var fieldAPI = event.target.name;
      var fieldValue = event.target.value;
      //console.log(fieldAPI + ' ' + fieldValue);
      this.responseWrapper.inspObsr[fieldAPI] = fieldValue;
   }

   openCodesModal(event) {
      //console.log('Open Popup');
      this.isCodesModalOpen = true;
      this.tabName = event.target.value;
   }

   getSelectedCodes(event) {
      //console.log('event', event.detail.tabName);
      if (event.detail.tabName == 'inspTabBreak') {
         this.inspCodesBreak = event.detail.inspCodes;
         this.allCodesBreak = event.detail.allCodes;
         this.adefectsMapBreak = event.detail.defectsMap;
         this.defectsArrayBreak = event.detail.defectsArray;
         this.activeSectionsBreak = event.detail.activeSections;
      }
      if (event.detail.tabName == 'inspTabVisual') {
         this.inspCodesVisual = event.detail.inspCodes;
         this.allCodesVisual = event.detail.allCodes;
         this.defectsMapVisual = event.detail.defectsMap;
         this.defectsArrayVisual = event.detail.defectsArray;
         this.activeSectionsVisual = event.detail.activeSections;
      }
      var testResultBreak = true;
      var testResultVisual = true;
	  this.testResult = 'Pass';
	  if(this.allCodesBreak.length > 0){
      for (var key2 in this.allCodesBreak) {
         if (this.allCodesBreak[key2].defect == 'Major') {
            testResultBreak = false;
            break;
         }
      }
	 }
	 if(this.allCodesVisual.length > 0){
      for (var key3 in this.allCodesVisual) {
         if (this.allCodesVisual[key3].defect == 'Major') {
            testResultVisual = false;
            break;
         }
      }
	}
      if (!testResultBreak || !testResultVisual)
         this.testResult = 'Fail';
   }

   getCloseModal(event) {
      //console.log('event', event.detail.isCodesModalOpen);
      this.isCodesModalOpen = event.detail.isCodesModalOpen;
   }

   getToggleSection(event) {
      //console.log('event', event.detail.activeSections);
      if (event.detail.tabName == 'inspTabBreak') {
         this.activeSectionsBreak = event.detail.activeSections;
      }
      if (event.detail.tabName == 'inspTabVisual') {
         this.activeSectionsVisual = event.detail.activeSections;
      }
   }

   get isBreakInsp() {
      //console.log('disableSave');
      if (this.tabName == 'inspTabBreak')
         return true;
      else
         return false;
   }

   get isInspectionCompleted() {
      //console.log('disableCancel');
      var inspObsr = this.responseWrapper.inspObsr;
      if (inspObsr.Is_Break_Inspection_Completed__c == true && inspObsr.Is_Visual_Inspection_Completed__c == true)
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
            'recordId': this.responseWrapper.inspObsr.Id
         }
         //console.log('fileData: '+JSON.stringify(this.fileData));
         this.handleUpload();
      }
      reader.readAsDataURL(file);
   }

   handleUpload() {
      this.showSpinner = true;
      //console.log('filename: ' + this.fileData.filename);
      const {
         base64,
         filename,
         recordId
      } = this.fileData;
      uploadFile({
         base64: base64,
         filename: filename,
         recordId: recordId
      }).then(result => {
         //console.log('result: ' + result);
         if (result != null && result != '') {
            let title = this.fileData.filename + ' uploaded successfully!';
            this.showToastNotification('Success', title, 'success', 'pester');
            this.showSpinner = false;
            this.fileData = null;
            this.fetchFiles();
         }
      })
   }

   fetchFiles() {
      //console.log('fetchFiles');
      getRelatedFilesByRecordId({
         recordId: this.responseWrapper.inspObsr.Id
      }).then((response) => {
         //console.log('fetchFiles >>> ' + JSON.stringify(response));
         if (response != null && response != '') {
            this.filesList = Object.keys(response).map(item => ({
               "label": response[item],
               "value": item,
               "url": `/sfc/servlet.shepherd/document/download/${item}`
            }))
            //console.log(this.filesList)
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
      //console.log(event.target.dataset.id);
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
      //console.log(event.target.dataset.id);
      deleteFile({
         ContentDocId: event.target.dataset.id
      }).then((response) => {
         //console.log('deleteFile response >>> ' + response);
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
      //console.log(event.target.dataset.id);
      window.open(event.target.dataset.id);
   }

   saveReceiptData() {
      //debugger;
      this.showSpinner = true;
      //console.log('inspObsr: ' + JSON.stringify(this.responseWrapper.inspObsr));
      var inspObsr = this.responseWrapper.inspObsr;
      if (this.responseWrapper.inspRecpt.Id)
         inspObsr.Aman_Receipt__c = this.responseWrapper.inspRecpt.Id;
      delete inspObsr.attributes;
      var allCodesBreak = this.allCodesBreak;
      var allCodesVisual = this.allCodesVisual;
      var majorStrBreak = '';
      var majorStrVisual = '';
      var minorStrBreak = '';
      var minorStrVisual = '';
      for (var key1 in allCodesBreak) {
         //console.log('ABC ' + allCodesBreak[key].code + ' ' + allCodesBreak[key].defect);
         if (allCodesBreak[key1].defect == 'Major') {
            if (majorStrBreak == '')
               majorStrBreak = allCodesBreak[key1].code;
            else
               majorStrBreak = majorStrBreak + ';' + allCodesBreak[key1].code;
         }
         if (allCodesBreak[key1].defect == 'Minor') {
            if (minorStrBreak == '')
               minorStrBreak = allCodesBreak[key1].code;
            else
               minorStrBreak = minorStrBreak + ';' + allCodesBreak[key1].code;
         }
      }
      for (var key2 in allCodesVisual) {
         //console.log('ABC ' + allCodes[key].code + ' ' + allCodes[key].defect);
         if (allCodesVisual[key2].defect == 'Major') {
            if (majorStrVisual == '')
               majorStrVisual = allCodesVisual[key2].code;
            else
               majorStrVisual = majorStrVisual + ';' + allCodesVisual[key2].code;
         }
         if (allCodesVisual[key2].defect == 'Minor') {
            if (minorStrVisual == '')
               minorStrVisual = allCodesVisual[key2].code;
            else
               minorStrVisual = minorStrVisual + ';' + allCodesVisual[key2].code;
         }
      }
      inspObsr.Break_Major_Codes__c = majorStrBreak;
      inspObsr.Visual_Major_Codes__c = majorStrVisual;
      inspObsr.Break_Minor_Codes__c = minorStrBreak;
      inspObsr.Visual_Minor_Codes__c = minorStrVisual;
      if (inspObsr.Break_Major_Codes__c != '' || inspObsr.Break_Minor_Codes__c != '')
         inspObsr.Is_Break_Inspection_Completed__c = true;
      if (inspObsr.Visual_Major_Codes__c != '' || inspObsr.Visual_Minor_Codes__c != '')
         inspObsr.Is_Visual_Inspection_Completed__c = true;
      saveReceiptDetails({
         inspObsr: inspObsr,
         inspObsrFields: this.inspObsrFields
      }).then((response) => {
         //console.log('response final: ' + JSON.stringify(JSON.parse(response)));
         this.showSpinner = false;
         if (JSON.parse(response) != null && JSON.parse(response) != '') {
            this.responseWrapper.inspObsr = JSON.parse(response);
            refreshApex(this.responseWrapper.inspObsr);
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
      //console.log(message);
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
            //console.log("All scripts and CSS are loaded. perform any initialization function.")
         })
         .catch(error => {
            //console.log("failed to load the scripts");
         });
   }

}