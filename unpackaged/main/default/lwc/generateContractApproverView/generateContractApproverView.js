import { LightningElement, api } from 'lwc';

import getContractDetail from '@salesforce/apex/PRI_customerQuoteController.getContractDetail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningModal from 'lightning/modal';
import { updateRecord } from 'lightning/uiRecordApi';
import { loadStyle } from 'lightning/platformResourceLoader';
import externalCustCode from '@salesforce/resourceUrl/externalCustCode';

export default class GenerateContractApproverView extends LightningElement {
    @api recordId;
    openModel = false;
    contractDetail;

    handleRejectClick(){
        this.updateContractApprovalStatus('Rejected');
        this.openModel = false;
    }

    handleApproveClick(){
        this.updateContractApprovalStatus('Approved');
        this.openModel = false;
    }

    updateContractApprovalStatus(status){
        const fields = {};
        fields.Id = this.recordId;
        fields.Approval_Status__c = status;
        const recordInput = { fields };
        updateRecord(recordInput)
        .then(() => {
            this.showToastNotification('Success', 'Success', 'Contract has been ' + status + ' successfully!');
        });
    }

    handleMoreDetailClick(){
        this.getContractDetail();
    }

    closeModal() {
        this.openModel = false;
    }

    getContractDetail(){
        getContractDetail({recordId: this.recordId }).then((response) => {
            console.log('--getContractDetail--',response);
            this.contractDetail = response;
            this.openModel = true;
        }).catch((error) => {
            console.log('error');
            console.error(error);
        })

    }

    showToastNotification(title, variant, msg){
        this.dispatchEvent(new ShowToastEvent({
            title : title,
            message : msg,
            variant : variant
        }));
    }

 renderedCallback(){
        Promise.all([
			loadStyle(this, externalCustCode)
		])
		.then(() => {
            // console.log("All scripts and CSS are loaded. perform any initialization function.")
        })
        .catch(error => {
            console.log("failed to load the scripts");
        });
        
    }
}