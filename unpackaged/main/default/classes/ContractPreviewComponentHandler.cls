/*
Name: ContractPreviewComponentHandler
Test Class: 
Author: Sreelakshmi SK
Created Date: 26 May 2023
Description: class to create contract doc and attach to sales agreement
*/

public class ContractPreviewComponentHandler {
    @AuraEnabled
    public static string contractDocument(string salesAgreementId,String recordTypeName){
        System.debug('salesAgreementId:'+salesAgreementId);
        	
        TestJanaCls.creatPdf();
        ContentVersion cv = new ContentVersion();
        if(recordTypeName=='ETSALES_Leasing'){
            PageReference pdf =  Page.LeaseContractPreview;
            
            pdf.getParameters().put('Id',salesAgreementId);
            pdf.setRedirect(true);
            Blob bdata = pdf.getContent();
            
            
            
            //Insert ContentVersion
            
            //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
            cv.ContentLocation = 'S'; 
            //File name with extention
            cv.PathOnClient = 'LeaseContract.pdf';
            //C-Content Origin. H-Chatter Origin.
            cv.Origin = 'H';
            //Owner of the file
            //Name of the file
            cv.Title ='LeaseContract.pdf';
            //File content
            cv.VersionData = bdata;
            insert cv;
            //get the ContentDocumentId
            Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
            
            
            //Insert ContentDocumentLink
            ContentDocumentLink cdl = new ContentDocumentLink();
            //Add ContentDocumentId
            cdl.ContentDocumentId = conDocId;
            //salesforce record Id
            cdl.LinkedEntityId = salesAgreementId;
            //V - Viewer permission. C - Collaborator permission. I - Inferred permission.
            cdl.ShareType = 'V';
            //AllUsers, InternalUsers, SharedUsers
            insert cdl;
            
        }
       
        if(recordTypeName=='ETSALES_Transportation'){
            PageReference pdf =  Page.LeaseContractPreview;
            
            pdf.getParameters().put('Id',salesAgreementId);
            pdf.setRedirect(true);
            Blob bdata = pdf.getContent();
            
            
            
            //Insert ContentVersion
            
            //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
            cv.ContentLocation = 'S'; 
            //File name with extention
            cv.PathOnClient = 'TransportationContract.pdf';
            //C-Content Origin. H-Chatter Origin.
            cv.Origin = 'H';
            //Owner of the file
            //Name of the file
            cv.Title ='TransportationContract.pdf';
            //File content
            cv.VersionData = bdata;
            insert cv;
            //get the ContentDocumentId
            Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
            
            
            //Insert ContentDocumentLink
            ContentDocumentLink cdl = new ContentDocumentLink();
            //Add ContentDocumentId
            cdl.ContentDocumentId = conDocId;
            //salesforce record Id
            cdl.LinkedEntityId = salesAgreementId;
            //V - Viewer permission. C - Collaborator permission. I - Inferred permission.
            cdl.ShareType = 'V';
            //AllUsers, InternalUsers, SharedUsers
            insert cdl;
            
        }
        
        return cv.Id;
    }
}