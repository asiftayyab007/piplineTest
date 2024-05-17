import { LightningElement, api } from 'lwc';

import NAME from '@salesforce/schema/Contract_Master__c.Name';
import DESCRIPTION from '@salesforce/schema/Contract_Master__c.Description__c';
import CONTRACT_HEAD from '@salesforce/schema/Contract_Master__c.Contract_Pdf_Header__c';
import MASTER_LINE_NO from '@salesforce/schema/Contract_Master__c.Line_No__c';
import CONTRACT from '@salesforce/schema/Contract_Master__c';

export default class GenerateContractLines extends LightningElement {
    isLoading = true;
    contractLineFields = {
        NAME,
        DESCRIPTION,
        MASTER_LINE_NO,
        CONTRACT_HEAD
    };
    contractLineObject = CONTRACT;

    @api article;

    connectedCallback(){
        console.log('-----GenerateContractLines--connectedCallback----', this.article.subCaluses);
        this.isLoading = false;
    }

    /**
     * @description to save Article related, Sub-Articles records
     */
    handleSuccess(event){
        console.log('-----handleSuccess contract Master----');
        var totalItems = 0
        this.contractMasterId = event.detail.id;
        var contractMasterId = this.contractMasterId;

        let contractSections = this.template.querySelectorAll('c-generate-contract-sub-lines');
        totalItems = contractSections.length;
        contractSections.forEach(child => {
            child.handleContractMasterId(contractMasterId);
        });

        this.totalContractSubLines = totalItems;
        console.log('---Total Lines---'+this.totalContractSubLines);
        // this.navigateToRecordPage(contractHeaderId, 'Contract_Pdf_Header__c');
    }

    handleTermsDelete(){
        console.log('----handleTermsDelete----');
    }

    @api handleContractHeaderId(contractHeaderId){
        console.log('----handleContractHeaderId----');
        this.contractHeaderId = contractHeaderId;
        var contractHeaderIdField = this.template.querySelector('[data-id="contractHeaderId"]');
        contractHeaderIdField.value = contractHeaderId;
        this.template.querySelector('lightning-record-edit-form').submit();
    }

    handleDeleteSubClause(event){
        var subClauseId = event.detail;
        console.log('----handleDeleteSubClause----',this.article.subCaluses);
        var index = this.article.subCaluses.findIndex( x =>  x.Id === subClauseId);
        console.log('------handleDeleteSubClause---index----'+index);
        // this.article.subCaluses.splice(index, 1);
    }
}