import { LightningElement, track, api } from 'lwc';

import saveFile from '@salesforce/apex/AccountPlanController.saveFile';

import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';


 

const columns = [

   { label: 'Customer', fieldName: 'Name' },

   { label: 'Customer Sector', fieldName: 'ETSALES_Bid__c' },

   { label: 'Year', fieldName: 'ETSALES_Bid_Bond__c' }

];

 

export default class LwcCSVUploader extends LightningElement {

   @api recordid;
		@track conNotInserted;

   @track columns = columns;

   @track data;

   @track fileName = '';

   @track UploadFile = 'Insert';

   @track showLoadingSpinner = false;

   @track isTrue = false;

   selectedRecords;

   filesUploaded = [];

   file;

   fileContents;

   fileReader;

   content;

   MAX_FILE_SIZE = 1500000;

 

 
   handleClose(event){

    this.dispatchEvent(new CloseActionScreenEvent());
    this.dispatchEvent(
        new ShowToastEvent({
            title: 'Success',
            
            variant: 'success'
        })
    );
}
   handleFilesChange(event) {

       if(event.target.files.length > 0) {

           this.filesUploaded = event.target.files;

           this.fileName = event.target.files[0].name;

       }

   }
   
 

   handleSave() {

       if(this.filesUploaded.length > 0) {

           this.uploadHelper();

       }

       else {

           this.fileName = 'Please select a CSV file to upload!!';

       }

   }

 

   uploadHelper() {

       this.file = this.filesUploaded[0];

      if (this.file.size > this.MAX_FILE_SIZE) {

           window.console.log('File Size is to long');

           return ;

       }

       this.showLoadingSpinner = true;

 

       this.fileReader= new FileReader();

 

       this.fileReader.onloadend = (() => {

           this.fileContents = this.fileReader.result;

           this.saveToFile();

       });

 

       this.fileReader.readAsText(this.file);

   }

 

   saveToFile() {

       saveFile({ base64Data: JSON.stringify(this.fileContents), cdbId: this.recordid})

       .then(result => {

           window.console.log('result ====> ');

           window.console.log(result);

 

           this.data = result;

 
         this.conNotInserted = result;
           this.fileName = this.fileName + ' - Uploaded Successfully';

           this.isTrue = false;

           this.showLoadingSpinner = false;

 

           this.dispatchEvent(

               new ShowToastEvent({

                   title: 'Success!!',

                   message: this.file.name + ' - Uploaded Successfully!!!'+'& The number of contacts not inserted is : '+ this.conNotInserted,

                   variant: 'success',

               }),

           );

       })

       .catch(error => {

 

           window.console.log(error);

           this.dispatchEvent(

               new ShowToastEvent({

                   title: 'Error while uploading File',

                   message: error.message,

                   variant: 'error',

               }),

           );

       });

   }

 

}