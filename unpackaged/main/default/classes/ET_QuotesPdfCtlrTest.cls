@isTest
public class ET_QuotesPdfCtlrTest {

    @isTest 
   Public static void GenerateQuotemethod(){
       
        Account acc= new Account();
        acc.Name='oil and gas';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name='emirates oils ltd';
        opp.StageName='Closed Lost';
        opp.CloseDate=system.today()+5;
        opp.AccountId=acc.Id;
        opp.Amount=1500;
        opp.ETSALES_Loss_Reason__c='Lost to Competitor';
        insert opp;
        
        Quote Quot= new Quote();
        Quot.Name='sample purchase';
       
        Quot.OpportunityId=opp.Id;
        insert Quot;
       
        ET_QuotesPdfCtlr.GenerateQuoteDoc(Quot.id, 'oil and gas','100','150','20','150','12','15' );
      
    
         
    }
    
   @isTest 
   Public static void Vehicletest(){
       
        Account acc= new Account();
        acc.Name='oil and gas';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name='emirates oils ltd';
        opp.StageName='Closed Lost';
        opp.CloseDate=system.today()+5;
        opp.AccountId=acc.Id;
        opp.Amount=1500;
        opp.ETSALES_Loss_Reason__c='Lost to Competitor';
        insert opp;
        
        Quote Quot= new Quote();
        Quot.Name='sample purchase';
       
        Quot.OpportunityId=opp.Id;
        insert Quot;
       
     PageReference pageRef = Page.ET_Qoutes_NewPdf;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', Quot.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(Quot);
        ET_QuotesPdfCtlr testpdf = new ET_QuotesPdfCtlr(sc);
   }
}