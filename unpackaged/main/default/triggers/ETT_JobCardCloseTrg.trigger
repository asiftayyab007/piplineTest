trigger ETT_JobCardCloseTrg on ETT_Job_Card_Close__c (after Update) {
    
    ETT_JobCardCloseTrgHelper.updateToolsItemMaster(trigger.NewMap,trigger.OldMap);

}