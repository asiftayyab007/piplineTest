/*  Developer Name : Srihari Koyila
 *  Class purpose  : ERP INTEGRATION GET AND POST METHODS in Opportunity.
 * 
 * */


public class ET_MotoPDF {
    
        Public String internalnos{get;set;}
        Public String status{get;set;} 
        Public String estimateno{get;set;}
        Public String workorderno{get;set;}  
        Public String workdescription{get;set;}
        Public String servicelocation{get;set;}  
        Public String estimator{get;set;}
        Public String isinvoiced{get;set;}  
        Public String isinvoicepaid{get;set;}
        Public String platenumber{get;set;} 
        Public integer serviceno{get;set;}  
        Public integer totallaborcharge{get;set;}  
        Public integer totalmaterialcharge{get;set;}  
        Public integer totalothercharge{get;set;}  
        Public integer netamount{get;set;}  
        Public Decimal vatamount{get;set;}  
        Public Decimal totalamount{get;set;}  
    
    public ET_MotoPDF(ApexPages.StandardController Opportunity){
       try{
         Http httpProtocol = new Http();
        String result = Null;
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization','Basic U2FsZXNGb3JjZTpzYWxlc2ZvcmNlMTIz');
        request.setMethod('GET');
        request.setEndPoint('https://etdevsoa.et.gov.ae/soa-infra/resources/CommonBusinessServices/GetEstimation/Client?estimateNum=1931859');
        system.debug('request'+request);
        request.setTimeout(90000);
        //if(String.isNotBlank(req)){
        request.setHeader('Content-Type', 'application/json');
        // request.setBody(req);
        //}
        response = httpProtocol.send(request);
        system.debug('response'+response);
         system.debug(response.getBody());
        ET_MotoWrapperClass etw = ET_MotoWrapperClass.parse(response.getBody());
        system.debug('--'+etw);
        List<WrapperPayment> lstWrap= new List<WrapperPayment>();
        
           for(ET_MotoWrapperClass.EstimationSQLOutput zone : etw.EstimationSQLOutput){
            WrapperPayment wp= new WrapperPayment();
            internalnos=wp.internalnos=zone.internal_number;
            status=wp.status=zone.current_status;
            estimateno=wp.estimateno=zone.estimate_no;
            workorderno=wp.workorderno=zone.work_order_no;
            workdescription=wp.workdescription=zone.work_description;
            servicelocation=wp.servicelocation=zone.service_location;
            estimator= wp.estimator=zone.estimator;
            isinvoiced=wp.isinvoiced=zone.is_invoiced;
            isinvoicepaid=wp.isinvoicepaid=zone.is_invoice_paid;
            platenumber=wp.platenumber=zone.plate_number;
            serviceno=wp.serviceno=zone.service_no;
            totallaborcharge=wp.totallaborcharge=zone.total_labor_charge;
            totalmaterialcharge=wp.totalmaterialcharge=zone.total_material_charge;
            totalothercharge=wp.totalothercharge=zone.total_other_charge;
            netamount=wp.netamount=zone.net_amount;
            vatamount=wp.vatamount=zone.vat_amount;
            totalamount=wp.totalamount=zone.total_amount;
            
            lstWrap.add(wp);
             system.debug(estimator);
        }
       
      }catch(Exception e){               //throw all other exception message            
          throw new AuraHandledException(e.getMessage());} 
    }
    
    
    @AuraEnabled
    public static string GenerateQuoteDoc(string ServiceEtimationNo,string recordId){
        system.debug(recordId);
        TestJanaCls.creatPdf();
         Opportunity opp=[SELECT Id,Name,OwnerId FROM Opportunity WHERE Id =: recordId];
        PageReference pdf =  Page.ET_MotoPDFVF;
        pdf.getParameters().put('Id',opp.Id);
        pdf.setRedirect(true);
        Blob bdata = pdf.getContent();
        
       
        
         //Insert ContentVersion
        ContentVersion cv = new ContentVersion();
        //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
        cv.ContentLocation = 'S'; 
        //File name with extention
        cv.PathOnClient = opp.Name+'.pdf';
        //C-Content Origin. H-Chatter Origin.
        cv.Origin = 'H';
        //Owner of the file
        //Name of the file
        cv.Title = opp.Name+'.pdf';
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
        cdl.LinkedEntityId = opp.Id;
        //V - Viewer permission. C - Collaborator permission. I - Inferred permission.
        cdl.ShareType = 'V';
        //AllUsers, InternalUsers, SharedUsers
        insert cdl;
         Opportunity Oppnty = new Opportunity();
          Oppnty.id=recordId;
          Oppnty.Service_Estimate_No__c=ServiceEtimationNo;
          Update Oppnty;
        return cv.Id;
    }

    Public class WrapperPayment{
        @AuraEnabled
        Public String internalnos{get;set;}
        @AuraEnabled
        Public String status{get;set;} 
        @AuraEnabled
        Public String estimateno{get;set;}
        @AuraEnabled
        Public String workorderno{get;set;}  
        @AuraEnabled
        Public String workdescription{get;set;}
        @AuraEnabled
        Public String servicelocation{get;set;}  
        @AuraEnabled
        Public String estimator{get;set;}
        @AuraEnabled
        Public String isinvoiced{get;set;}  
        @AuraEnabled
        Public String isinvoicepaid{get;set;}
        @AuraEnabled
        Public String platenumber{get;set;} 
        @AuraEnabled
        Public integer serviceno{get;set;}  
        @AuraEnabled
        Public integer totallaborcharge{get;set;}  
        @AuraEnabled
        Public integer totalmaterialcharge{get;set;}  
        @AuraEnabled
        Public integer totalothercharge{get;set;}  
        @AuraEnabled
        Public integer netamount{get;set;}  
        @AuraEnabled
        Public Decimal vatamount{get;set;}  
        @AuraEnabled
        Public Decimal totalamount{get;set;}  
    }
    
    
     @AuraEnabled
    public static List<WrapperPayment> makeGetCallout(string ServiceEtimationNo,string recordId){
       system.debug(ServiceEtimationNo);
        system.debug(recordId);
      try{
         Http httpProtocol = new Http();
        String result = Null;
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization','Basic U2FsZXNGb3JjZTpzYWxlc2ZvcmNlMTIz');
        request.setMethod('GET');
        request.setEndPoint('https://etdevsoa.et.gov.ae/soa-infra/resources/CommonBusinessServices/GetEstimation/Client?estimateNum='+ServiceEtimationNo);
        system.debug('request'+request);
        request.setTimeout(90000);
        //if(String.isNotBlank(req)){
        request.setHeader('Content-Type', 'application/json');
        // request.setBody(req);
        //}
        response = httpProtocol.send(request);
        system.debug('response'+response);
         system.debug(response.getBody());
        ET_MotoWrapperClass etw = ET_MotoWrapperClass.parse(response.getBody());
        system.debug('--'+etw);
      
        List<WrapperPayment> lstWrap= new List<WrapperPayment>();
        
        for(ET_MotoWrapperClass.EstimationSQLOutput zone : etw.EstimationSQLOutput){
            WrapperPayment wp= new WrapperPayment();
            wp.internalnos=zone.internal_number;
            wp.status=zone.current_status;
            wp.estimateno=zone.estimate_no;
            wp.workorderno=zone.work_order_no;
            wp.workdescription=zone.work_description;
            wp.servicelocation=zone.service_location;
            wp.estimator=zone.estimator;
            wp.isinvoiced=zone.is_invoiced;
            wp.isinvoicepaid=zone.is_invoice_paid;
            wp.platenumber=zone.plate_number;
            wp.serviceno=zone.service_no;
            wp.totallaborcharge=zone.total_labor_charge;
            wp.totalmaterialcharge=zone.total_material_charge;
            wp.totalothercharge=zone.total_other_charge;
            wp.netamount=zone.net_amount;
            wp.vatamount=zone.vat_amount;
            wp.totalamount=zone.total_amount;
            
            lstWrap.add(wp);
        }
       
        return lstWrap;
      }catch(Exception e){               //throw all other exception message            
          throw new AuraHandledException(e.getMessage());}
         }
    
    
    
}