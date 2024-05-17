import { LightningElement } from 'lwc';

import TERMS from '@salesforce/schema/TermsAndCondition__c';
import NAME from '@salesforce/schema/TermsAndCondition__c.Name';
import TERMS_CODE from '@salesforce/schema/TermsAndCondition__c.Term_Code__c';
import CHARGEABLE from '@salesforce/schema/TermsAndCondition__c.Chargeable_to_Customer__c';
import CHARGE_TYPE from '@salesforce/schema/TermsAndCondition__c.Charge_Type__c';
import CHARGE_TYPE_VALUE from '@salesforce/schema/TermsAndCondition__c.Charge_Type_Value__c';
import START_DATE from '@salesforce/schema/TermsAndCondition__c.Start_Date__c';
import END_DATE from '@salesforce/schema/TermsAndCondition__c.End_Date__c';

export default class PRI_termsAndCondition extends LightningElement {
    termsAndCondition = TERMS;

    terms = {
        NAME,
        TERMS_CODE,
        CHARGEABLE,
        CHARGE_TYPE,
        CHARGE_TYPE_VALUE,
        START_DATE,
        END_DATE
    };
    
}