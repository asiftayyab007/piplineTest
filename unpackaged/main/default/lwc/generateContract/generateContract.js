import { LightningElement, track, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import generatepdf from '@salesforce/apex/ContractPreviewController.GenerateQuoteDoc';
import CUSTOMER_QUOTE_NAME_FIELD from '@salesforce/schema/Customer_Quote__c.Name';
import OPP_SECTOR_FIELD from '@salesforce/schema/Customer_Quote__c.Opportunity_Name__r.ETSALES_Sector__c';
import STATUS from '@salesforce/schema/Customer_Quote__c.Quote__r.Status';
import OPP_RECORDTYPE_FIELD from '@salesforce/schema/Customer_Quote__c.Opportunity_Name__r.RecordTypeId';

import ET_Rep_Solitation from '@salesforce/schema/Contract_Pdf_Header__c.ET_Rep_Solitation__c';
import ET_Representative from '@salesforce/schema/Contract_Pdf_Header__c.ET_Representative__c';
import ET_Rep_Designation from '@salesforce/schema/Contract_Pdf_Header__c.ET_Rep_Designation__c';
import Lessee_Solitation from '@salesforce/schema/Contract_Pdf_Header__c.Lessee_Solitation__c';
import Lessee_Rep from '@salesforce/schema/Contract_Pdf_Header__c.Lessee_Rep__c';
import Lessee_Rep_Designation from '@salesforce/schema/Contract_Pdf_Header__c.Lessee_Rep_Designation__c';
import CUSTOMER_QUOTE from '@salesforce/schema/Contract_Pdf_Header__c.Customer_Quote__c';
import SECTOR from '@salesforce/schema/Contract_Pdf_Header__c.Sector__c';
import Contract_Pdf_Header from '@salesforce/schema/Contract_Pdf_Header__c';

import getAllContractLines from '@salesforce/apex/PRI_customerQuoteController.getAllContractLines';

import { loadStyle } from 'lightning/platformResourceLoader';
import externalCustCode from '@salesforce/resourceUrl/externalCustCode';

export default class GenerateContract extends NavigationMixin(LightningElement) {
    SPNR = true;
    @api recordId;
    totalContractLines = 0;
    @track vfpageUrl;
    url = false;
    contractHeaderObject = Contract_Pdf_Header;
    contractHeader = {
        ET_Rep_Solitation,
        ET_Representative,
        ET_Rep_Designation,
        Lessee_Solitation,
        Lessee_Rep,
        Lessee_Rep_Designation,
        CUSTOMER_QUOTE,
        SECTOR
    };

    objvar = {
        PDFType : '',
        RecordId : '',
        QuoteName : ''
    };
    isFirstPage = true; 
    //oppfields
    LeasingRECType
    TranspostRECType;
    SchoolTranspostREC;
    @track contractLines = [];
    //
    //  @wire(getRecord, { recordId: '$recordId', fields: [CUSTOMER_QUOTE_NAME_FIELD,OPP_SECTOR_FIELD,OPP_RECORDTYPE_FIELD, STATUS] })
    // RecordsData;

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;
        this.recordId = this.currentPageReference.state.c__recordId;
        console.log("----recordId----"+this.recordId);
    }

    connectedCallback(){
        console.log('-----connectedCallBack------');
        this.fetchContractMasterData();
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

    async fetchContractMasterData(){
        console.log('----fetchContractMasterData---');
        await getAllContractLines({recordId: this.recordId}).then((response) => {
            console.log('----response---',response);
            this.contractLines = response.articlesDetail;
            this.RecordsData = response.customerQuote;
            this.SPNR = false;
        }).catch((error) => {
            console.log('error');
            console.error(error);
        })
        console.log('---contractLines--',this.contractLines);
        this.setDefaultData();
    }

    getRecordData(){

    }

    handlechangeinput(event) {
        this.objvar[event.target.name] = event.target.value;
    }

    handleNext(){
        console.log('----handleNext------');
        // if (this.validationrule()) {
            this.isFirstPage = false;
            this.buildContractURL();

        // }
    }
    handleBack(){
        this.isFirstPage = true;
    }

    buildContractURL() {
        console.log(this.objvar);
        
        if (this.LeasingRECType) {
            this.vfpageUrl = '/apex/LeaseContractPreview?Id=' + this.objvar.RecordId + '&ET_Solitation=' + this.objvar.ET_Solitation + '&ET_ETRepresentative=' + this.objvar.ET_ETRepresentative + '&ET_Designation=' + this.objvar.ET_Designation + '&LA_Solitation=' + this.objvar.LA_Solitation + '&LA_LARepresentative=' + this.objvar.LA_LARepresentative + '&LA_Designation=' + this.objvar.LA_Designation + '&LA_AgreementDate=' + this.objvar.LA_AgreementDate + '&LA_POBusiness=' + this.objvar.LA_POBusiness + '&LA_PostOfBox=' + this.objvar.LA_PostOfBox + '&LA_ALMPYear=' + this.objvar.LA_ALMPYear + '&LA_InCAccident=' + this.objvar.LA_InCAccident + '&LA_CMCost=' + this.objvar.LA_CMCost + '&LA_TVNExceed=' + this.objvar.LA_TVNExceed + '&LA_LAKilometer=' + this.objvar.LA_LAKilometer;
            console.log(this.vfpageUrl);
            this.url = true;
        }

        if (this.TranspostRECType) {
            this.vfpageUrl = '/apex/TransportationContractPreview?Id=' + this.objvar.RecordId + '&ET_Solitation=' + this.objvar.ET_Solitation + '&ET_ETRepresentative=' + this.objvar.ET_ETRepresentative + '&ET_Designation=' + this.objvar.ET_Designation + '&LA_Solitation=' + this.objvar.LA_Solitation + '&LA_LARepresentative=' + this.objvar.LA_LARepresentative + '&LA_Designation=' + this.objvar.LA_Designation + '&LA_AgreementDate=' + this.objvar.LA_AgreementDate + '&LA_POBusiness=' + this.objvar.LA_POBusiness + '&LA_PostOfBox=' + this.objvar.LA_PostOfBox + '&LA_FAllowance=' + this.objvar.LA_FAllowance + '&LA_DOAgreement=' + this.objvar.LA_DOAgreement;
            console.log(this.vfpageUrl);
            this.url = true;

        }
        if (this.SchoolTranspostREC) {
            this.vfpageUrl = '/apex/SchoolTransportContractPreview?Id=' + this.objvar.RecordId + '&ET_Solitation=' + this.objvar.ET_Solitation + '&ET_ETRepresentative=' + this.objvar.ET_ETRepresentative + '&ET_Designation=' + this.objvar.ET_Designation + '&LA_Solitation=' + this.objvar.LA_Solitation + '&LA_LARepresentative=' + this.objvar.LA_LARepresentative + '&LA_Designation=' + this.objvar.LA_Designation + '&LA_AgreementDate=' + this.objvar.LA_AgreementDate + '&LA_POBusiness=' + this.objvar.LA_POBusiness + '&LA_PostOfBox=' + this.objvar.LA_PostOfBox + '&LA_FAllowance=' + this.objvar.LA_FAllowance + '&LA_VOSCheque=' + this.objvar.LA_VOSCheque;
            console.log(this.vfpageUrl);
            this.url = true;
        }
    }

    /* toast message */
    showToastSuccessEvent(result){
        this.dispatchEvent(new ShowToastEvent({
            title : 'Success',
            message : 'Pdf Saved Successfully',
            variant : 'Success'
        }))
    //window.location.reload()
    }

    showToastErrorEvent(error){
        this.dispatchEvent(new ShowToastEvent({
            title : 'error',
            message : 'pdf not saved',
            variant : 'error'
        }))
    }

    /* save PDF */
    handleSave(event){
        this.SPNR = true;
        const CustomerquoteREC = this.objvar;
        console.log(CustomerquoteREC);

        generatepdf({ CustomerquoteREC })
        .then(result=>{
            this.SPNR = false;
            this.showToastSuccessEvent(result);
            this.navigateToRecord(event);

        })
        .catch(error=>{
            this.SPNR = false;
            this.showToastErrorEvent(error);
        })


    }
    
    /* validating */
    validationrule() {
        let isvalid = true;
        let listforms = this.template.querySelectorAll('.validate')
        listforms.forEach(singleform => {
            if (!singleform.checkValidity()) {
                singleform.reportValidity();
                singleform.scrollIntoView({ behavior: 'smooth', block: 'center' });
                isvalid = false;

            }
        })
        return isvalid;
    }
    //-----close standard action--//
    
    /* closeQuickAction() {
        const closeQA = new CustomEvent('close');
        // Dispatches the event.
        this.dispatchEvent(closeQA);
    } */

    navigateToRecord(event) {
        const recordId = this.recordId;
        
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                ObjectApiName :'Customer_Quote__c',
                recordId: recordId,
                actionName: 'view'
            }
        });
    }

    showWarningToast(quoteId) {
        const evt = new ShowToastEvent({
            title: 'Quote Approval Required',
            message: 'You can not create Contract unless Quote is not Approved',
            variant: 'warning',
            mode: 'sticky'
        });
        this.dispatchEvent(evt);
        this.navigateToRecord();
        // this.navigateToRecordPage(quoteId, "Quote");
    }

    get getTodayDate() {
        // Initialize currentDate with the current date in "YYYY-MM-DD" format
        const today = new Date();
        const year = today.getFullYear();
        const month = String(today.getMonth() + 1).padStart(2, '0'); // Add 1 because months are 0-based
        const day = String(today.getDate()).padStart(2, '0');

        // Format the date as "YYYY-MM-DD"
        this.objvar.LA_AgreementDate = `${year}-${month}-${day}`;
        return `${year}-${month}-${day}`;
    
    }
    get getmrmsOptions() {
        return [
            { label: 'Mr.', value: 'Mr.' },
            { label: 'Ms.', value: 'Ms.' }
        ]
    }

    setDefaultData() {
        console.log('-----setDefaultData-----',this.RecordsData);
        if (this.RecordsData !== undefined) {
            // console.log('this.RecordsData----',this.RecordsData.fields.Quote__r.value.fields.Status.value);
            // if(this.RecordsData.fields.Quote__r.value.fields.Status.value !='Approved'){
            //        this.showWarningToast();
            // }
            if (this.RecordsData.Opportunity_Name__r.ETSALES_Sector__c != 'School') {
                if (this.RecordsData.Opportunity_Name__r.RecordType.Name == 'Leasing/ Rental') {
                    this.LeasingRECType = true;
                    this.objvar.PDFType= 'Leasing/ Rental';
                }
                if (this.RecordsData.Opportunity_Name__r.RecordType.Name == 'Transportation') {
                    this.TranspostRECType = true;
                    this.objvar.PDFType= 'Transportation';
                }
            }else{
                    this.SchoolTranspostREC = true;
                    this.objvar.PDFType= 'SchoolTransportation';
            }
            this.objvar.RecordId= this.recordId;
            this.objvar.QuoteName= this.RecordsData.Name;
            
        /*  if (this.RecordsData.fields.Opportunity_Name__r.value.recordTypeInfo.name == 'SchoolTransportation') {
                this.SchoolTranspostREC = true;
            } */
        }
    }

    handleSaveClick(){
        console.log('---handleSaveClick--');
        var headerForm = this.template.querySelector('[data-id="contractHeaderSection"]');
        console.log('---handleSaveClick--headerForm--', headerForm);
        headerForm.submit();
    }

    handleCancel(){
        console.log('---handleCancel--');
    }

    /**
     * @description to save contract related, Articles records
     */
    handleSuccess(event){
        console.log('-----handleSuccess header----');
        var totalItems = 0
        this.contractHeaderId = event.detail.id;
        var contractHeaderId = this.contractHeaderId;

        let contractSections = this.template.querySelectorAll('c-generate-contract-lines');
        totalItems = contractSections.length;
        contractSections.forEach(child => {
            child.handleContractHeaderId(contractHeaderId);
        });

        this.totalContractLines = totalItems;
        console.log('---Total Lines---'+this.totalContractLines);
        // this.navigateToRecordPage(contractHeaderId, 'Contract_Pdf_Header__c');
    }
        
}