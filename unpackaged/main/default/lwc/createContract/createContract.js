import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CloseActionScreenEvent } from "lightning/actions";
import { getRecordNotifyChange } from 'lightning/uiRecordApi';

import updateBikePrice from '@salesforce/apex/CurrencyExchangeRate.updateBikePrice';

export default class CreateContract extends LightningElement {
    @api recordId;

    handleUpdateCurrency(){
        if(this.isInputValid()){
            this.updatedPrice();
        }
    }
    
    /**
     * @description to validate the currency enerted by user 
     * @return Boolean
     */
    isInputValid() {
        let isValid = true;
        let inputField = this.template.querySelector('[data-id="newCurrency"]');
        if(!inputField.checkValidity()) {
            inputField.reportValidity();
            isValid = false;
        }
        return isValid;
    }

     /**
     * @description to update the price according to new currency
     */
    updatedPrice(){
        let currency = this.template.querySelector('[data-id="newCurrency"]').value;
        updateBikePrice({recordId: this.recordId, newCurrency:currency}).then((response) => {
            console.log(response);
            if(response != null){
                if(response.isSuccess){
                    this.showToastMessage('success', response.message);
                    this.dispatchEvent(new CloseActionScreenEvent());
                    getRecordNotifyChange([{ recordId: this.recordId }]);
                }else{
                    this.showToastMessage('error', response.message);
                }
            }
        }).catch((error) => {
            this.showToastMessage('error', error);
        })
    }

    showToastMessage(type, messsage) {
        const evt = new ShowToastEvent({
            title: type,
            message: messsage,
            variant: type,
            mode: 'sticky'
        });
        this.dispatchEvent(evt);
    }
}