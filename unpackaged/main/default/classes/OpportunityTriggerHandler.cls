public class OpportunityTriggerHandler {
public static void blockOpportunityCreation(List<Opportunity> newOpportunities) {
        Set<Id> accountIds = new Set<Id>();

        for (Opportunity opp : newOpportunities) {
            accountIds.add(opp.AccountId);
        }

        Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id, ETSALES_Status__c FROM Account WHERE Id IN :accountIds]);

        for (Opportunity opp : newOpportunities) {
            if (accounts.containsKey(opp.AccountId) && accounts.get(opp.AccountId).ETSALES_Status__c == 'I') {
                opp.addError('Opportunity creation is blocked for inactive accounts.');
            }
        }
    }
}