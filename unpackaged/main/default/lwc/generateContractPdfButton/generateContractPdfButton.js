import { LightningElement,api,track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import NAME from '@salesforce/schema/Contract_Pdf_Header__c.Name';
import APPROVAL_STATUS from '@salesforce/schema/Contract_Pdf_Header__c.Approval_Status__c';
import APPROVAL_STAGE from '@salesforce/schema/Contract_Pdf_Header__c.Approval_Stage__c';
import ALL_APPROVAL from '@salesforce/schema/Contract_Pdf_Header__c.All_Approval_Finished__c';
import PDFSector from '@salesforce/schema/Contract_Pdf_Header__c.Sector__c';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';


export default class GenerateContractPdfButton extends LightningElement {
    @api recordId;
    isSubmitted = false;
    @track vfpageUrl;
    @track showPdfPage = false;
    url = false;
    objvar = {
        RecordId : '',
    };
    @wire(getRecord, { recordId: '$recordId', fields: [NAME, APPROVAL_STATUS, APPROVAL_STAGE, ALL_APPROVAL, PDFSector] })
    wiredContact({ error, data }) {
        if (data) {
            console.log('---data---',data);
            this.contract = data;
            if(!this.isSubmitted){
                this.checkApprovalStatus();
            }
        }
    }
    get computedVfPageUrl(){
        //window.open(this.vfPageUrl);
        console.log('this.vfpageUrl in get'+this.vfpageUrl);
        return this.vfpageUrl;
     }

    checkApprovalStatus(){
        this.objvar.RecordId= this.recordId;
        console.log('--status--'+this.contract.fields.Approval_Status__c.value);
        if(this.contract.fields.Approval_Status__c.value == 'Submitted'){
            this.showToastNotification('Warning', 'Warning', 'Contract has already been Submitted and waiting for approval from '+ this.contract.fields.Approval_Stage__c.value +'!');
        }else if(this.contract.fields.Approval_Status__c.value == 'Rejected'){
            this.showToastNotification('Warning', 'Error', 'Contract has already been rejected by '+ this.contract.fields.Approval_Stage__c.value +'!');
        }else if(this.contract.fields.Approval_Status__c.value == 'Approved' && this.contract.fields.All_Approval_Finished__c.value != true){
            this.showToastNotification('Success', 'Success', 'Wiating for Approval from '+ this.contract.fields.Approval_Stage__c.value +'!');
        }else if(this.contract.fields.Approval_Status__c.value == 'Approved' && this.contract.fields.All_Approval_Finished__c.value == true){
            this.showToastNotification('Success', 'Success', 'Contract has already been Approved!');
           
            if (this.contract.fields.Sector__c.value =='School') {
                this.vfpageUrl = '/apex/ET_generateContractPdf_School?Id=' + this.objvar.RecordId;
                this.showPdfPage = true;
            }else if (this.contract.fields.Sector__c.value =='Transport And Lease') {
                this.vfpageUrl = '/apex/ET_generateContractPdf_TL?Id=' + this.objvar.RecordId;
                this.showPdfPage = true;
            }else{
                this.showToastNotification('Warning', 'Warning', 'Sector is Null');
            }
        }
    }
    showToastNotification(title, variant, msg){
        //this.dispatchEvent(new CloseActionScreenEvent());
        this.dispatchEvent(new ShowToastEvent({
            title : title,
            message : msg,
            variant : variant
        }));
    }
}