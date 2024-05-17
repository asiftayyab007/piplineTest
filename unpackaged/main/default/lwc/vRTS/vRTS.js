import { LightningElement, wire } from 'lwc';
import ETST_Logo from '@salesforce/resourceUrl/ETLogo'; // Import the static resource URL
import UAE_Logo from '@salesforce/resourceUrl/UAE_Logo'; // Import the static resource UAE_Logo 
import SCHOOL_BUS from '@salesforce/resourceUrl/VRTS_SCHOOL_BUS';
import getdefaultData from '@salesforce/apex/ET_VRTS.getVRTSrecords';


export default class VRTS extends LightningElement {
    VRTSrecords;

    VRTS_ET_Logo = ETST_Logo; // Assign the imported resource URL to a property
    VRTS_UAE_Logo = UAE_Logo; 
    VRTS_SCHOOL_BUS = SCHOOL_BUS;

    VRTS_StartPage = true;
    VRTS_FormPage = false;
    VRTS_CTRSPage = false;
    VRTS_CTR1 = false;
    //
    @wire(getdefaultData)
    RecordsData;

     get defaultData(){
        if (this.RecordsData.data !== undefined) {
            this.VRTSrecords = this.RecordsData.data;
        }
        console.log('VRTSrecords',this.VRTSrecords); 
    }


  /*   get defaultData(){
        getdefaultData({  })
        .then(result=>{
            this.VRTSrecords=result;
            console.log('VRTSrecords',this.VRTSrecords); 
        })
        .catch(Error=>{
            console.log('error'+JSON.stringify(Error)); 
        })
    } */
    //
    VRTS_Start(){
        this.VRTS_StartPage = false;
        this.VRTS_CTRSPage = false;
        this.VRTS_FormPage = true;
    }
    VRTS_FormPage_Back(){
        this.VRTS_StartPage = true;
        this.VRTS_CTRSPage = false;
        this.VRTS_FormPage = false;
    }
    VRTS_FormPage_Next(){
        this.VRTS_StartPage = false;
        this.VRTS_CTRSPage = true;
        this.VRTS_FormPage = false;
    }    
    VRTS_CTRSPage_Back(){
        this.VRTS_StartPage = false;
        this.VRTS_CTRSPage = false;
        this.VRTS_FormPage = true;
        this.VRTS_CTR1 = false;
    }
    VRTS_CTRSPage_Next(){
        this.VRTS_StartPage = false;
        this.VRTS_CTRSPage = false;
        this.VRTS_FormPage = false;
        this.VRTS_CTR1 = true;

    }
    VRTS_VRTS_CTR1_Back(){
        this.VRTS_StartPage = false;
        this.VRTS_CTRSPage = true;
        this.VRTS_FormPage = false;
        this.VRTS_CTR1 = false;
    }
    VRTS_VRTS_CTR1_Next(){
        this.VRTS_StartPage = false;
        this.VRTS_CTRSPage = false;
        this.VRTS_FormPage = false;
        this.VRTS_CTR1 = false;
    }
    VRTSform = {};
    handleonchange(event){
        this.VRTSform[event.target.name] = event.target.value;
    }

}