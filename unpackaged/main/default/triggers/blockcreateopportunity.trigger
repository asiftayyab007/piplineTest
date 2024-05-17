trigger blockcreateopportunity on Opportunity (before insert) {
    
   OpportunityTriggerHandler.blockOpportunityCreation(Trigger.new);


}