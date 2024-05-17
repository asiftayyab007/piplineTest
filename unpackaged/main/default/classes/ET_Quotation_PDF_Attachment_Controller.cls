global class ET_Quotation_PDF_Attachment_Controller {
    
    global String PagePDFContentWithoutTotalSummary{ get; set; }
    global String PagePDFContentWithTotalSummary{ get; set; }
    global String QuoteId{ 
        get; 
        set {
            UpdatePDFContent(value);
        } 
    }
    
    public void UpdatePDFContent(String QuoteId) {
        try {
            Quote q = [Select id,ET_Pricing_Service_Request__c from Quote where id=:QuoteId];
            ID WithoutSummaryQuoteID = null;
            ID WithSummaryQuoteID = null;
            if(q.ET_Pricing_Service_Request__c!=null)
            {
                ET_Pricing_Service_Request__c psr = [Select id,(Select id,ET_Type__c from Quotes__r)
                                                     from ET_Pricing_Service_Request__c where id = :q.ET_Pricing_Service_Request__c];
                
                for(Quote childquote:psr.Quotes__r)   
                {
                    
                    if(childquote.ET_Type__c=='Quote for Approval')
                    {
                        WithoutSummaryQuoteID = childquote.id;
                    }
                    if(childquote.ET_Type__c=='Total Project Summary')
                    {
                        WithSummaryQuoteID = childquote.id;
                    }
                }
                
            }
            if(WithoutSummaryQuoteID!=null)
            {
                PageReference pageRef = Page.ET_Quotation_Pricing_Attachment_PDF;
                pageRef.getParameters().put('quoteId', WithoutSummaryQuoteID);
                PagePDFContentWithoutTotalSummary = pageRef.getContent().toString().replace('<html style="display:none !important;">', '<html>');    
            }
            if(WithSummaryQuoteID!=null)
            {
                PageReference pageRef = Page.ET_Quotation_Pricing_Attachment_PDF;
                pageRef.getParameters().put('quoteId', WithSummaryQuoteID);
                PagePDFContentWithTotalSummary = pageRef.getContent().toString().replace('<html style="display:none !important;">', '<html>');    
            }
            
        }catch(System.Exception ex){}
    }
}