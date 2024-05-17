public class insertMultpleRecords {
    
    public void m1(){
        List<Disposition_Code__c> lstTesting = new List<Disposition_Code__c>();
        Disposition_Code__c objTest;
        objTest = new Disposition_Code__c(name='AGEN',Remark__c='Agency Case',Action__c='No Action');
        lstTesting.add(objTest);
        objTest = new Disposition_Code__c(name='BPTP',Remark__c='Broken Promise',Action__c='Follow Up required ');
        lstTesting.add(objTest);
        objTest = new Disposition_Code__c(name='CALL',Remark__c='Call Back Request',Action__c='Follow Up required ');
        lstTesting.add(objTest);
        objTest = new Disposition_Code__c(name='CHQB',Remark__c='Cheque Return / Bounce',Action__c='Follow Up required');
        lstTesting.add(objTest);
        objTest = new Disposition_Code__c(name='DEC',Remark__c='Deceased',Action__c='Goto Islam');
        lstTesting.add(objTest);
        objTest = new Disposition_Code__c(name='DISP',Remark__c='Dispute Case',Action__c='Go to Wedad for investigating');
        lstTesting.add(objTest);
        objTest = new Disposition_Code__c(name='DL1',Remark__c='Dunning Letter 1',Action__c='Follow Up required');
        lstTesting.add(objTest);
        objTest = new Disposition_Code__c(name='DL2',Remark__c='Dunning Letter 2',Action__c='Follow Up required');
        lstTesting.add(objTest);
        objTest = new Disposition_Code__c(name='DL3',Remark__c='Dunning Letter 3',Action__c='Follow Up required');
        lstTesting.add(objTest);
        objTest = new Disposition_Code__c(name='ESCL',Remark__c='Escalation Case',Action__c='Follow Up required');
        lstTesting.add(objTest);
        objTest = new Disposition_Code__c(name='FRD',Remark__c='Fraud Suspicion',Action__c='Goto Islam');
        lstTesting.add(objTest);
        objTest = new Disposition_Code__c(name='INR',Remark__c='Invoice Not Received',Action__c='Go to Wedad for issuing Invoice');
        lstTesting.add(objTest); 
        objTest = new Disposition_Code__c(name='IR',Remark__c='Invoice Received',Action__c='Follow Up required');
        lstTesting.add(objTest); 
        objTest = new Disposition_Code__c(name='KPTP',Remark__c='Kept Promise',Action__c='No Action');
        lstTesting.add(objTest);
        objTest = new Disposition_Code__c(name='LEAV',Remark__c='Customer on Leave',Action__c='Follow Up required');
        lstTesting.add(objTest);
        objTest = new Disposition_Code__c(name='LEGL',Remark__c='Legal Case',Action__c='No Action');
        lstTesting.add(objTest);
        objTest = new Disposition_Code__c(name='MNC',Remark__c='Mobile Not Contactable',Action__c='Follow Up required');
        lstTesting.add(objTest);
        objTest = new Disposition_Code__c(name='MSG',Remark__c='Left Message',Action__c='Follow Up required');
        lstTesting.add(objTest);
        objTest = new Disposition_Code__c(name='MSO',Remark__c='Mobile Switched Off',Action__c='Follow Up required');
        lstTesting.add(objTest);
        objTest = new Disposition_Code__c(name='PAID',Remark__c='Invoice Paid',Action__c='No Action');
        lstTesting.add(objTest);          
        objTest = new Disposition_Code__c(name='PTP',Remark__c='Promise To Pay',Action__c='Follow Up required');
        lstTesting.add(objTest);          
        objTest = new Disposition_Code__c(name='RNEW',Remark__c='Contract Under Renewal',Action__c='Follow Up required');
        lstTesting.add(objTest);          
        objTest = new Disposition_Code__c(name='RNR',Remark__c='Ringing No Response',Action__c='Follow Up required');
        lstTesting.add(objTest);          
        objTest = new Disposition_Code__c(name='RTP',Remark__c='Refuse to Pay',Action__c='Goto Islam');
        lstTesting.add(objTest);          
        objTest = new Disposition_Code__c(name='SETL',Remark__c='Settlement',Action__c='Follow Up required');
        lstTesting.add(objTest);          
        objTest = new Disposition_Code__c(name='SKIP',Remark__c='Skip Case',Action__c='Follow Up required');
        lstTesting.add(objTest);          
        objTest = new Disposition_Code__c(name='SUPR',Remark__c='Supervisory Review',Action__c='Goto Islam');
        lstTesting.add(objTest);          
        objTest = new Disposition_Code__c(name='SUSP',Remark__c='Suspension Request',Action__c='Follow Up required');
        lstTesting.add(objTest);          
        objTest = new Disposition_Code__c(name='UPAY',Remark__c='Unapplied Payment',Action__c='Follow Up required');
        lstTesting.add(objTest);          
        objTest = new Disposition_Code__c(name='VIST',Remark__c='Visit Required',Action__c='Follow Up required');
        lstTesting.add(objTest);          
        
        insert lstTesting;
    }
    
    
    
}