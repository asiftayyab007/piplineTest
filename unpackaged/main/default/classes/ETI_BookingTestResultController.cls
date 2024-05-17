public class ETI_BookingTestResultController{

public String BookingName{get;set;}
public list<serviceLineItem> serviceLineItemWrp{get;set;}
public class serviceLineItem{
public Integer srN{get;set;}
public string chassis{get;set;}
public ETI_Service_Line_Item__c srLineItem{get;set;}
    public string testResult{get;set;}
        public serviceLineItem(Integer srN1,string chassis1,ETI_Service_Line_Item__c srLineItem1,string testResult1){
             srN=srN1;
             chassis=chassis1;
             srLineItem=srLineItem1;
             testResult=testResult1;
        }
    }

    public ETI_BookingTestResultController(){
        Id bkngId=ETI_VehicleController.getDecryptedData(ApexPages.currentPage().getParameters().get('Id').replace(' ','+'));
        serviceLineItemWrp =new list<serviceLineItem>();
        integer i=1;
        if(bkngId!=NULL){
             for(ETI_Service_Line_Item__c item: [Select Id, Name,Booking__r.Name,Booking__r.Chassis_No__c,Booking__r.Vehicle_Number__c,Description__c,
                                                        Booking__r.ET_Location__r.Name,Booking__r.Booking_Date__c,Service_Name__c,Test_Result__c,Plate_No__c,Plate_Color__c
                                                        From ETI_Service_Line_Item__c Where Booking__c =: bkngId]){
                                                        string plateDetails;
                 serviceLineItemWrp.add(new serviceLineItem(i,item.Plate_Color__c!=null && item.Plate_No__c!=null?item.Plate_Color__c+'-'+item.Plate_No__c:item.Booking__r.Chassis_No__c,item,item.Description__c!=null?item.Description__c:item.Test_Result__c));
                 i++;
             }
             if(!serviceLineItemWrp.isEmpty())
                 BookingName=serviceLineItemWrp[0].srLineItem.Booking__r.Name;
        }
    }
    
}