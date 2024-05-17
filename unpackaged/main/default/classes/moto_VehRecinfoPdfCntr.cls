public class moto_VehRecinfoPdfCntr {
    public Boolean windows { get; set; }
    public Boolean Seats { get; set; }
    public Boolean Seatbelts { get; set; }
    public Boolean Dashboard { get; set; }
    public Boolean Infotainment { get; set; }
    public Boolean ACFunctionality { get; set; }
    public Boolean RadioKnobsPanel { get; set; }
    public Boolean MarkedDiagram { get; set; }
    public Boolean AdvisorSignature { get; set; }
	public Boolean CustomerSignature { get; set; }
    public Boolean noImages { get; set; }
    Public String customerNum {get; set;}
    Public Boolean CanvasImage {get; set;}
    
    public map<string,list<string>> imageData{get;set;}
    
    public moto_VehRecinfoPdfCntr(ApexPages.StandardController controller) {
        noImages = false;
        windows = false;
        Seats = false;
        Seatbelts = false;
        Dashboard = false;
        Infotainment = false;
        ACFunctionality = false;
        RadioKnobsPanel = false;
        MarkedDiagram = false;
        AdvisorSignature = false;
        CustomerSignature = false;
        CanvasImage = false;
        String recId = Apexpages.currentPage().getParameters().get('id');
        imageData = new Map<String, List<String>>();
        for(ContentDocumentLink  cd : [SELECT id,ContentDocument.Title, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE id != null AND LinkedEntityId=:recId ]){
            system.debug('--'+cd.ContentDocument.Title);
            if(cd.ContentDocument.Title.contains('MarkedDiagram')){
                if(!imageData.containsKey('MarkedDiagram')){
                    imageData.put('MarkedDiagram',new list<string>());
                }
                imageData.get('MarkedDiagram').add(cd.ContentDocument.LatestPublishedVersionId);
                MarkedDiagram = true;
            }
            if(cd.ContentDocument.Title.contains('CanvasFiles_images')){
                if(!imageData.containsKey('CanvasFiles_images')){
                    imageData.put('CanvasFiles_images',new list<string>());
                }
                imageData.get('CanvasFiles_images').add(cd.ContentDocument.LatestPublishedVersionId);
                CanvasImage = true;
            }
            if(cd.ContentDocument.Title.contains('AdvisorSignature')){
                if(!imageData.containsKey('AdvisorSignature')){
                    imageData.put('AdvisorSignature',new list<string>());
                }
                imageData.get('AdvisorSignature').add(cd.ContentDocument.LatestPublishedVersionId);
                AdvisorSignature = true;
            }
            if(cd.ContentDocument.Title.contains('CustomerSignature')){
                if(!imageData.containsKey('CustomerSignature')){
                    imageData.put('CustomerSignature',new list<string>());
                }
                imageData.get('CustomerSignature').add(cd.ContentDocument.LatestPublishedVersionId);
                CustomerSignature = true;
            }
            if(cd.ContentDocument.Title.contains('windows')){
                if(!imageData.containsKey('windows')){
                    imageData.put('windows',new list<string>());
                }
                imageData.get('windows').add(cd.ContentDocument.LatestPublishedVersionId);
                windows = true; 
            }
            if(cd.ContentDocument.Title.contains('Seats')){
                if(!imageData.containsKey('Seats')){
                    imageData.put('Seats',new list<string>());
                }
                imageData.get('Seats').add(cd.ContentDocument.LatestPublishedVersionId);
                Seats = true; 
            }
            if(cd.ContentDocument.Title.contains('Seat belts')){
                if(!imageData.containsKey('Seat belts')){
                    imageData.put('Seat belts',new list<string>());
                }
                imageData.get('Seat belts').add(cd.ContentDocument.LatestPublishedVersionId);
                Seatbelts = true; 
            }
            if(cd.ContentDocument.Title.contains('Dashboard')){
                if(!imageData.containsKey('Dashboard')){
                    imageData.put('Dashboard',new list<string>());
                }
                imageData.get('Dashboard').add(cd.ContentDocument.LatestPublishedVersionId);
                Dashboard = true; 
            }
            if(cd.ContentDocument.Title.contains('Infotainment System Screen')){
                if(!imageData.containsKey('Infotainment System Screen')){
                    imageData.put('Infotainment System Screen',new list<string>());
                }
                imageData.get('Infotainment System Screen').add(cd.ContentDocument.LatestPublishedVersionId);
                Infotainment = true; 
            }
            if(cd.ContentDocument.Title.contains('AC Functionality')){
                if(!imageData.containsKey('AC Functionality')){
                    imageData.put('AC Functionality',new list<string>());
                }
                imageData.get('AC Functionality').add(cd.ContentDocument.LatestPublishedVersionId);
                ACFunctionality= true; 
            }
            if(cd.ContentDocument.Title.contains('RadioKnobsPanel')){
                if(!imageData.containsKey('RadioKnobsPanel')){
                    imageData.put('RadioKnobsPanel',new list<string>());
                }
                imageData.get('RadioKnobsPanel').add(cd.ContentDocument.LatestPublishedVersionId);
                RadioKnobsPanel = true; 
                
            }
            
        }
        	system.debug('CanvasImage>>>>>>>' + CanvasImage);
            if(RadioKnobsPanel == false && ACFunctionality == false && Infotainment == false && Dashboard == false && Seatbelts == false && Seats == false && windows == false && CanvasImage == false)
            {
                noImages = true;
            }
        List<Vehicle_Receiving_Info__c> veh = [Select id, Name, Opportunity__r.Symptom_Type__c, Opportunity__r.Symptoms__c, Opportunity__r.Possible_cause__c, Opportunity__r.Vehicle_Plate_Number__c,Opportunity__r.Chassis_Number__c, Opportunity__r.Vehicle_Internal_Number__c, Opportunity__r.Account.PersonMobilePhone, Opportunity__r.Driver_s_Mobile__c, Opportunity__r.Workshop_Location__r.Name, Opportunity__r.Service_Number__c from Vehicle_Receiving_Info__c where id =: recId Limit 1];
        if(veh[0].Opportunity__r.Driver_s_Mobile__c != NULL)
        {
            customerNum = veh[0].Opportunity__r.Driver_s_Mobile__c;
        }
        else
        {
            customerNum = veh[0].Opportunity__r.Account.PersonMobilePhone;
        }
        
    }
    
}