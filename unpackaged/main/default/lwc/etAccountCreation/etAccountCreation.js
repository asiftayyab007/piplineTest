import { LightningElement, track, wire } from 'lwc';
//import { refreshApex } from '<a class="bp-suggestions-mention" href="https://www.forcetalks.com/salesforceintegration/" rel="nofollow">@salesforce</a>/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import insertAcc from '<a class="bp-suggestions-mention" href="https://www.forcetalks.com/salesforceintegration/" rel="nofollow">@salesforce</a>/apex/accountInsert.insertAcc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
//import ACCOUNT_OBJINFO from '<a class="bp-suggestions-mention" href="https://www.forcetalks.com/salesforceintegration/" rel="nofollow">@salesforce</a>/schema/Account';
//import RATING  from '<a class="bp-suggestions-mention" href="https://www.forcetalks.com/salesforceintegration/" rel="nofollow">@salesforce</a>/schema/Account.Rating';
//import INDUSTRY_FIELD from '<a class="bp-suggestions-mention" href="https://www.forcetalks.com/salesforceintegration/" rel="nofollow">@salesforce</a>/schema/Account.Industry';
export default class EtAccountCreation extends LightningElement {
    
    spinnerStatus = false;

    @track account ={};
    onSubmitHandler(event){
        event.preventDefault();
        console.log('-onSubmitHandler--');
    }
    nameVal;
    emailVal;
    mobileVal;
    EidVal;


    handleNameChange(event){
        this.nameVal = event.target.value;
    } 

    handleEmailChange(event){
        this.mobilevalue = event.target.value;
    }
    
    handleMobileChange(event){
        this.mobilevalue = event.target.value;
    }

    handleEIDChange(event){
        this.mobilevalue = event.target.value;
    }

    handleNext() {

        alert('email '+ this.emailvalue);
        alert('Mobile '+ this.mobilevalue);
        
    }

}