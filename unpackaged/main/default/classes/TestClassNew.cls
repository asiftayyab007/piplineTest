public class TestClassNew{
   /* @AuraEnabled
   public static List<sectionWrapper> getAllVRTSrecords(){
       List<sectionWrapper> sectionWrpList = New List<sectionWrapper>();
       List<VRTS__c> vrtsList = [SELECT Id,Sequence__c,Version__c,Question_En__c,Question_Ar__c,Category_En__c,Category_Ar__c FROM VRTS__c ORDER BY Sequence__c ASC NULLS LAST];
       Map<String, List<VRTS__c>> mapVRTS = New Map<String, List<VRTS__c>>();
       Map<String, List<secOptionWrapper>> mapOPtionsVRTS = New Map<String, List<secOptionWrapper>>();
       for(VRTS__c rec: vrtsList){
           if(!mapVRTS.containsKey(rec.Category_En__c))
               mapVRTS.put(rec.Category_En__c,New List<VRTS__c>{rec});
           if(mapVRTS.containsKey(rec.Category_En__c))
               mapVRTS.get(rec.Category_En__c).add(rec);
           secOptionWrapper secOptionWrp = New secOptionWrapper();
           secOptionWrp.questionNameEn = rec.Question_En__c;
           secOptionWrp.questionNameAr = rec.Question_Ar__c;
           secOptionWrp.response = '';
           if(!mapOPtionsVRTS.containsKey(rec.Category_En__c))
               mapOPtionsVRTS.put(rec.Category_En__c,New List<secOptionWrapper>{secOptionWrp});
           if(mapOPtionsVRTS.containsKey(rec.Category_En__c))
               mapOPtionsVRTS.get(rec.Category_En__c).add(secOptionWrp);
       }
       for(String sec: mapVRTS.KeySet()){
           sectionWrapper sectionWrp = New sectionWrapper();
           sectionWrp.secNameEn = sec;
           if(mapVRTS.containsKey(sec))
               sectionWrp.secNameAr = mapVRTS.get(sec)[0].Category_Ar__c;
           if(sec == 'Automatic Fire Suppression System' || sec == 'Cable Connections')
               sectionWrp.comment = null;
           else
               sectionWrp.comment = '';
           sectionWrp.secOptions = mapOPtionsVRTS.get(sec);
           sectionWrpList.add(sectionWrp);
       }
       System.debug('sectionWrpList: '+sectionWrpList);
       return sectionWrpList;
   }
   
   Public class sectionWrapper{
       @AuraEnabled Public String secNameEn;
       @AuraEnabled Public String secNameAr;
       @AuraEnabled Public String comment;
       @AuraEnabled Public String result;
       @AuraEnabled Public List<secOptionWrapper> secOptions;
       Public sectionWrapper(){
          secOptions = New List<secOptionWrapper>();
       }
   }
   Public class secOptionWrapper{
       @AuraEnabled Public String questionNameEn;
       @AuraEnabled Public String questionNameAr;
       @AuraEnabled Public String response;
   }*/
}