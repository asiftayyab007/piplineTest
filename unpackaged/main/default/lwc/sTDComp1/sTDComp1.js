import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class STDComp1 extends LightningElement {

    formfields = {};

    newchange(event) {
        this.formfields[event.target.name] = event.target.value;
    }
    handleSaveClick() {
        const formrc = this.formfields;
        console.log(formrc);
    }


}