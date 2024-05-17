global class DeactiveTransportReqScheduler implements Schedulable{
    
    global void execute(SchedulableContext sc)  {
        
        ETST_DeactiveTransportRequestsBatch b = new ETST_DeactiveTransportRequestsBatch(); 
        
        database.executeBatch(b);
        
    }
    
}