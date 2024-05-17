public class student_cntrlr {
    public ETST_Student__c student{get;set;}
    public student_cntrlr(ApexPages.StandardController stdController){
        student = (ETST_Student__c) stdController.getRecord();
    }

}