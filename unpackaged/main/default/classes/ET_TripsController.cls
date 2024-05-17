public class ET_TripsController {

 public List<Trip__c> lstTrips {get; set;}
    
    public ET_TripsController(){
        lstTrips = [SELECT Id, Bus__c, Driver__c, Supervisor__c, Boarded_Students__c, Direction__c, Trip__c FROM Trip__c limit 10];
    }
    
    
   
    
}