import { LightningElement, api, wire, track } from 'lwc';

import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import CUSTOMER_QUOTE_OBJECT from '@salesforce/schema/Customer_Quote__c';
import QUOTE_NUMBER from '@salesforce/schema/Customer_Quote__c.Name__c';
import QUOTE_NAME from '@salesforce/schema/Customer_Quote__c.Name';
import GRAND_TOTAL from '@salesforce/schema/Customer_Quote__c.Grand_Total__c';
import TOTAL_AMOUNT from '@salesforce/schema/Customer_Quote__c.Total_Amount__c';
import ACCOUNT_NAME from '@salesforce/schema/Customer_Quote__c.Account_Name__c';
import SECTOR from '@salesforce/schema/Customer_Quote__c.ETSALES_Sector__c';
import OPPO_NUM from '@salesforce/schema/Customer_Quote__c.Opportunity_Number__c';
import CLIENT_TYPE from '@salesforce/schema/Customer_Quote__c.clientType__c';
import QUOTE_TOTAL_INVESTMENT from '@salesforce/schema/Customer_Quote__c.Quote_Total_Investment__c';
import OPPO_NAME from '@salesforce/schema/Customer_Quote__c.Opportunity_Name__c';
import QUOTE from '@salesforce/schema/Customer_Quote__c.Quote__c';
import ACC_NUM from '@salesforce/schema/Customer_Quote__c.AccountNumber__c';
import REC_TYPE from '@salesforce/schema/Customer_Quote__c.RecordType__c';
import FUEL from '@salesforce/schema/Customer_Quote__c.Fuel_Included_Current_Contract__c';
import COMMENT from '@salesforce/schema/Customer_Quote__c.Comments__c';
import CONTRACT_TYPE from '@salesforce/schema/Customer_Quote__c.Contract_Type__c';
import ADDITIONAL_CHARGES from '@salesforce/schema/Customer_Quote__c.Additional_Terms_Charges__c';
import CUSTOMER_NAME from '@salesforce/schema/Customer_Quote__c.CustomerName__c';
import CUSTOMER_TITLE from '@salesforce/schema/Customer_Quote__c.Contact_PersonTitle__c';
import CUSTOMER_QUOTE_DATE from '@salesforce/schema/Customer_Quote__c.Customer_Quote_Date__c';
import ADDITIONAL_NOTES from '@salesforce/schema/Customer_Quote__c.Additional_Notes__c';
import GROUP_BY from '@salesforce/schema/Customer_Quote__c.Group_By__c';
// import CUSTOMER_QUOTE_VEHICLE from '@salesforce/schema/Customer_Vehicle_Quote_Item__c.Customer_Quote__c';


import getQuoteData from '@salesforce/apex/PRI_customerQuoteController.getQuoteData';
// import getQuoteVehicleLineItemData from '@salesforce/apex/PRI_customerQuoteController.getQuoteVehicleLineItemData';
// import getWorkforceQuoteLineItemsData from '@salesforce/apex/PRI_customerQuoteController.getWorkforceQuoteLineItemsData';
import fetchLineItems from '@salesforce/apex/PRI_customerQuoteController.fetchLineItems';
import fetchOppoRelatedQuoteList from '@salesforce/apex/PRI_customerQuoteController.fetchOppoRelatedQuoteList';
import getAllTerms from '@salesforce/apex/PRI_customerQuoteController.getAllTerms';


export default class CustomerQuote extends NavigationMixin(LightningElement)  {
    @api recordId;
    objectName = 'Quote'; // as we have same button in the two obecjcts Quote and opportunity
    isQuote = true;
    quote = null;
    vehicleIds = [];
    isloading = true;
    isContractTypeSelected = false;
    isQuoteSelected = false;
    contractType = 'Monthly';
    customerQuote = CUSTOMER_QUOTE_OBJECT;
    customerQuoteId;
    customerQuoteFields = {
        QUOTE_NAME,
        QUOTE_NUMBER,
        // TOTAL_INVESTMENT,
        GRAND_TOTAL,
        TOTAL_AMOUNT,
        ACCOUNT_NAME,
        SECTOR,
        OPPO_NUM,
        CLIENT_TYPE,
        QUOTE_TOTAL_INVESTMENT,
        OPPO_NAME,
        QUOTE,
        ACC_NUM,
        REC_TYPE,
        COMMENT,
        ADDITIONAL_CHARGES,
        FUEL,
        CONTRACT_TYPE,
        CUSTOMER_NAME,
        CUSTOMER_TITLE,
        CUSTOMER_QUOTE_DATE,
        ADDITIONAL_NOTES,
        GROUP_BY
    };
    workforceIds = {};

    quoteDetail = {};
    @track quoteWorkforce = [];
    @track quoteVehicleLines = [];
    @track quoteWorkforceLines = [];
    quoteVehicleLinesExist = false;
    quoteWorkforceLinesExist = false;
    vehicleUniqueKeys = [];//to calculate total investment
    get options() {
        return [
            // { label: 'Select Quote', value: '', selected: true },
            { label: 'Monthly', value: 'Monthly', selected: true },
            { label: 'Yearly', value: 'Yearly' },
        ];
    }

    @track quoteListOption = [];
    totalInvestment = 0;
    
    lineNo = 1;
    @track termsDetail = [];
    allTerms;
    totalLineItems = 0; 

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;
        this.recordId = this.currentPageReference.state.c__recordId;
        if(this.currentPageReference.state.c__objectName != undefined){
            this.objectName = this.currentPageReference.state.c__objectName;
            this.isQuote = this.objectName == 'Quote'? true: false;
        }
        console.log("----recordId----"+this.recordId);
    }

    connectedCallback(){
        if(this.objectName == 'Quote'){
            this.fetchQuoteData();
            this.fetchLines();
        }else{
            this.fetchOppoRelatedQuoteList();
        }
        this.fetchAllTerms();
        // this.fetchQuoteVehicleLineData();
        // this.fetchWorkforceQuoteLineItemsData();
    }

    handleQuoteSelection(event){
        this.isQuoteSelected = true;
        console.log('---handleQuoteSelection---'+event.detail.value);
        this.recordId = event.detail.value;
        this.fetchQuoteData();
        this.fetchLines();
    }

    handleContractTypeChange(event){
        var contractTypeField =this.template.querySelector('[data-id="contractType"]');
        this.contractType = contractTypeField.value;
        this.quoteDetail.contractVal = this.contractType;
        // contractTypeField.disabled = true;
        this.isContractTypeSelected = true;

        //upon contract Type change fetch lines data again
        if(this.isQuoteSelected){
            this.quoteVehicleLines = [];
            this.quoteWorkforceLines = [];
            this.fetchLines();
            this.passContractTypeToChild();
        }
    }

    fetchQuoteData(){
        getQuoteData({recordId: this.recordId }).then((response) => {
            console.log('--fetchQuoteData--');
            console.log(response);
            if(response != null){
                this.mapQuoteToCustomerQuote(response.quote, response.customerQuoteCount);
            }
        }).catch((error) => {
            console.log('error');
            console.error(error);
        })
    }

    fetchLines(){
        fetchLineItems({quoteId: this.recordId, contractType: this.contractType}).then((response) => {
            console.log('--fetchLineItems--');
            console.log(response);
            if(response != null){
                this.isLoading = false;
                this.quoteVehicleLines = response.vehicleLines;
                console.log('--quoteVehicleLines--length-'+this.quoteVehicleLines.length);
                this.quoteVehicleLinesExist = this.quoteVehicleLines.length > 0? true: false;
                this.quoteWorkforceLines = response.workforceLines;
                this.quoteWorkforceLinesExist = this.quoteWorkforceLines.length > 0? true: false;
                //to calculate total investment, we need to keep track of unique vehicles list
                var uniqueKeys = [];
                this.quoteVehicleLines.forEach(vehicle => {
                    uniqueKeys.push(vehicle.Name);
                });
                this.vehicleUniqueKeys = uniqueKeys;
            }
            
        }).catch((error) => {
            console.log('error');
            console.error(error);
        })
    }

    /*
    fetchQuoteVehicleLineData(){
        getQuoteVehicleLineItemData({quoteId: this.recordId }).then((response) => {
            console.log('--getQuoteVehicleLineItemData--');
            console.log(response);
            if(response != null){
                this.isLoading = false;
                // this.mapQuoteVehicleToCustomerQuoteVehicle(response);
                this.quoteVehicleLines = response;
            }
        }).catch((error) => {
            console.log('error');
            console.error(error);
        })
    }

    fetchWorkforceQuoteLineItemsData(){
        getWorkforceQuoteLineItemsData({quoteId: this.recordId }).then((response) => {
            console.log('--getQuoteVehicleLineItemData--');
            console.log(response);
            if(response != null){
                this.isLoading = false;
                this.quoteWorkforceLines = response;
            }
        }).catch((error) => {
            console.log('error');
            console.error(error);
        })
    }
    */
   
    mapQuoteToCustomerQuote(response, customerQuoteCount){
        if(response.Status !='Approved'){
        //    this.showWarningToast();
        }
        // this.quoteDetail.zone = response.GL_Zone__c;
        this.quoteDetail.sector = response.Opportunity.ETSALES_Sector__c;
        this.quoteDetail.QuoteNumber = response.QuoteNumber;
        this.quoteDetail.AccountId = response.AccountId;
        this.quoteDetail.opp_num = response.Opportunity.ETSALES_Opportunity_Number__c;
        this.quoteDetail.opp_Type = response.Opportunity.Type;
        this.quoteDetail.clientType = response.Account.ETSALES_Profile_Class__c;
        this.quoteDetail.totalInvestment = response.Quote_Total_Investment__c;
        this.quoteDetail.customerQuoteName = 'CQ '+response.QuoteNumber+ '_' + customerQuoteCount;
        this.quoteDetail.oppoId = response.Opportunity.Id;
        this.quoteDetail.quoteId = response.Id;
        this.quoteDetail.acc_num = response.Account.AccountNumber;
        this.quoteDetail.recordType = response.Opportunity.RecordType.Name;
        this.quoteDetail.fuel = response.Opportunity.Fuel_Included_Current_Contract__c;
        this.totalInvestment = response.Quote_Total_Investment__c;
    }
    // function to save customer quote related records
    handleSuccess(event){
        var totalItems = 0
        this.customerQuoteId = event.detail.id;
        var customerQuote = this.customerQuoteId;

        let childWorkForceItems = this.template.querySelectorAll('c-customer-quote-workforce-line-item');
        totalItems = childWorkForceItems.length;
        childWorkForceItems.forEach(child => {
            child.handleCustomerQuoteId(customerQuote);
        });

        let childVehicles = this.template.querySelectorAll('c-cutsomer-quote-line-item');        
        totalItems = totalItems + childVehicles.length;
        childVehicles.forEach(child => {
            child.handleCustomerQuoteIdForVehicle(customerQuote);
        });

        let terms = this.template.querySelectorAll('c-terms-and-condition');
        totalItems = totalItems + terms.length;
        terms.forEach(term => {
            term.handleCustomerQuoteIdAndSaving(customerQuote);
        });
        this.totalLineItems = totalItems;
        console.log('---Total Lines---'+this.totalLineItems);
        this.navigateToRecordPage(customerQuote, 'Customer_Quote__c');
    }

    lineItemSaveHandler(event){
        // console.log('--lineItemSaveHandler---');
        this.totalLineItems--;
        if(this.totalLineItems == 0){
            this.navigateToRecordPage(this.customerQuote, 'Customer_Quote__c');
        }
    }

    handleLineItemsSaving(temp){

        var childFields = this.template.querySelectorAll('lightning-input-field[data-id="customerQuoteId"]');
        console.log('-----childFields---',childFields);
        var childForms = this.template.querySelectorAll('lightning-record-edit-form[data-id="vehicles"]');
        console.log('-----childForms---',childForms);
        this.template.querySelectorAll('lightning-input-field[data-id="customerQuoteId"]').forEach( (field) => {
            field.value = temp;
        });

        this.template.querySelectorAll('lightning-record-edit-form[data-id="vehicles"]').forEach( (form) => {
            form.submit();
        });
        



        // this.customerQuoteId = temp;
        // const inputFields = {};
        // inputFields[CUSTOMER_QUOTE_VEHICLE.fieldApiName] = temp;
        // const childInputFields = this.template.querySelectorAll('lightning-record-edit-form[data-id="vehicles"] lightning-input-field');
        // for (const field of childInputFields) {
        //     if (field.value) {
        //         inputFields[field.fieldName] = field.value;
        //     }
        // }
        // console.log('inputFields', inputFields);
        // const vehicles = this.template.querySelectorAll('lightning-record-edit-form[data-id="vehicles"]').submit(inputFields);
        // for (const field of childInputFields) {
        //     if (field.value) {
        //         inputFields[field.fieldName] = field.value;
        //     }
        // }

    }

    navigateToRecordPage(customerQuote, obj){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: customerQuote,
                objectApiName: obj,
                actionName: 'view'
            }
        });
    }

    handleOnSubmit(event){
    }

    handleError(event){
        console.log("handleError event");
        console.log(JSON.stringify(event.detail));
    }

    handleCancel(event){
        this.navigateToRecordPage(this.recordId, "Quote");
    }

    handleSaveClick(event){
        console.log('---handleSaveClick----', this.template.querySelector('lightning-record-edit-form'));
        var form1 = this.template.querySelector('[data-id="customerQuote"]');
        console.log('---handleSaveClick--form1--', form1);
        form1.submit();
    }

    deleteVehicleLine(event){
        var vehicleId = event.detail;
        var index = this.quoteVehicleLines.findIndex( x =>  x.vehicleLineId === vehicleId);
        this.reCalculateTotalInvestment(index);
        this.quoteVehicleLines.splice(index, 1);
    }

    reCalculateTotalInvestment(index){
        var itemToDelete = this.quoteVehicleLines[index];
        var vehicleUniqueKeyIndex = this.vehicleUniqueKeys.indexOf(itemToDelete.Name);
        if(vehicleUniqueKeyIndex != -1){
            this.vehicleUniqueKeys.splice(vehicleUniqueKeyIndex,1);
        }
         //As we have multiple enteries for each vehicle, we will only subtract 
        //it from total investment unless no entry of specific vehilce exist.
        if(!(this.vehicleUniqueKeys.includes(itemToDelete.Name))){
            if(itemToDelete.NumberOfVehicles && itemToDelete.purchasePrice){
                this.totalInvestment -=  itemToDelete.NumberOfVehicles *  itemToDelete.purchasePrice;
            }
        }
    }

    deleteWorkForceLine(event){
        var workforceId = event.detail;
        var index = this.quoteWorkforceLines.findIndex( x =>  x.workForceId === workforceId);
        this.quoteWorkforceLines.splice(index, 1);
    }

    showWarningToast() {
        const evt = new ShowToastEvent({
            title: 'No Quotation Found',
            message: 'Please Create Quotation First before creating Customer Quote',
            variant: 'warning',
            mode: 'sticky'
        });
        this.dispatchEvent(evt);
        this.navigateToRecordPage(this.recordId, "Quote");
    }

    fetchOppoRelatedQuoteList(){
        fetchOppoRelatedQuoteList({oppId: this.recordId }).then((response) => {
            console.log('-Quotes--', Object.keys(response).length);
            if(response && Object.keys(response).length != 0){
                var listOptions = [];
                for (let key in response) {
                    listOptions.push({label:response[key], value:key});
                }
                this.quoteListOption = listOptions;
            }else{
                this.showWarningToast();
            }

        }).catch((error) => {
            console.log('error');
            console.error(error);
        })
    }

    fetchAllTerms(){
        console.log('--fetchAllTerms--');
        getAllTerms({oppoId: this.recordId}).then((response) => {
            if(response != null){
                this.allTerms = response.allTerms;
                this.buildAllTermsArray(response.defaultTerms);
            }
        }).catch((error) => {
            console.log('error');
            console.error(error);
        })
    }

    buildAllTermsArray(defaultTerms){
        defaultTerms.forEach(defaultTerm => {
            this.lineNo++;
            this.termsDetail.push({lineNo: this.lineNo, termItem: defaultTerm, allTerms: "", isTermDisabled: "true"});
        });
        console.log('----buildAllTermsArray--',this.termsDetail);
    }

    addTermsAndConsitionRow(event){
        console.log('---addTermsAndConsitionRow---');
        this.lineNo++;
        
        this.termsDetail.push({lineNo: this.lineNo, termItem: {}, allTerms: this.allTerms, isTermDisabled: false});
    }

    removeTermsAndConsitionRow(event){
        console.log('--removeTermsAndConsitionRow--');
        var lineNo = event.detail;
        var index = this.termsDetail.findIndex( x =>  x.lineNo === lineNo);
        this.termsDetail.splice(index, 1);
        this.lineNo--;
    }

    passContractTypeToChild(){
        if(this.quoteWorkforceLinesExist){
            console.log('--contract Type Change--'+this.contractType);
            var workforceLabelComponent = this.template.querySelector('[data-id="labelLine"]');
            if(workforceLabelComponent != undefined ){
                workforceLabelComponent.changeContractType(this.contractType);
            }
            var workforceCheckBoxComponent = this.template.querySelector('[data-id="checkboxLine"]');
            if(workforceCheckBoxComponent != undefined ){
                workforceCheckBoxComponent.changeContractType(this.contractType);
            }
        }
    }
}