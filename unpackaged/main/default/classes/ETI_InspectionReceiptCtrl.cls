/***********************************************************************************************************************
* Name               : ETI_InspectionReceiptCtrl                                                                       *
* Test Class		 : ETI_InspectionReceiptCtrl_Test                                                                  *
* Description        : Apex Class to fetch Aman receipt and update in Salesforce                                       * 
* Created Date       : 06/Sep/2023                                                                                     *
* Created By         : Taj Shaik (SMAARTT)                                                                             *
* -----------------------------------------------------------------------------------------------                      *
* VERSION   AUTHOR      DATE                COMMENTS                                                                   *
* 1.0       Taj Shaik   06/Sep/2023         Initial Draft.                                                             *
***********************************************************************************************************************/
public with sharing class ETI_InspectionReceiptCtrl {
    
    @auraEnabled
    public static String searchInspectionReceipt(String searchStr, String inspObsrFields) {
        responseWrapper respWrp = New responseWrapper(); 
        List<ETI_Inspection_Receipt__c> inspRecptList = New List<ETI_Inspection_Receipt__c>();
        List<ETI_Booking__c> bookingList = New List<ETI_Booking__c>();
        List<ETI_Inspection_Observation__c> inspObsrList = New List<ETI_Inspection_Observation__c>();
        Boolean createInspObsr = false;
        String ReceiptNo = '';
        //System.debug('inspObsrFields: '+inspObsrFields);
        if(searchStr != null && searchStr != '' && inspObsrFields != null){
            if(searchStr.startsWithIgnoreCase('B-')){
                String queryStr = 'SELECT Id,(SELECT Id,AMAN_Receipt_No__c FROM Receipts__r LIMIT 1) FROM ETI_Booking__c WHERE Name =: searchStr LIMIT 1';
                bookingList = Database.query(queryStr);
                if(bookingList.size()>0){
                    if(bookingList[0]?.Receipts__r.size()>0)
                        inspRecptList = bookingList[0]?.Receipts__r;
                }else{
                    respWrp.receiptWrp = null;
                    respWrp.isSuccess = true;
                    respWrp.message = 'Booking Id is not available in CRM';
                } 
                if(inspRecptList.size()>0){
                    if(inspRecptList[0].AMAN_Receipt_No__c == null || inspRecptList[0].AMAN_Receipt_No__c == ''){
                        respWrp.receiptWrp = null;
                        respWrp.isSuccess = true;
                        respWrp.message = 'Aman Receipt Number not available in CRM';
                    }else{
                        inspObsrList = queryInspObsrList(inspRecptList[0]?.AMAN_Receipt_No__c,inspObsrFields); 
                        createInspObsr = true;
                        respWrp.receiptWrp = getInspectionReceipt(inspRecptList[0]?.AMAN_Receipt_No__c);
                        ReceiptNo = inspRecptList[0]?.AMAN_Receipt_No__c;
                        respWrp.isSuccess = true;
                        respWrp.message = respWrp.receiptWrp.Message; 
                        respWrp.inspRecpt = inspRecptList[0];
                    }
                }else{
                    respWrp.receiptWrp = null;
                    respWrp.isSuccess = true;
                    respWrp.message = 'Aman Receipt Number not available in CRM';
                }  
            }
            else {
                respWrp.receiptWrp = getInspectionReceipt(searchStr);
                if(respWrp.receiptWrp.Status == 'S' && respWrp.receiptWrp.Message == 'Inspection Receipt Exists'){
                    String queryStr = 'SELECT Id,AMAN_Receipt_No__c FROM ETI_Inspection_Receipt__c WHERE AMAN_Receipt_No__c =: searchStr LIMIT 1';
                    inspRecptList = Database.query(queryStr);
                    respWrp.isSuccess = true;
                    respWrp.message = respWrp.receiptWrp.Message; 
                    if(inspRecptList.size()>0)
                        respWrp.inspRecpt = inspRecptList[0];
                    inspObsrList = queryInspObsrList(searchStr,inspObsrFields); 
                    createInspObsr = true;
                }else if(respWrp.receiptWrp.Status == 'E'){
                    respWrp.receiptWrp = null;
                    respWrp.isSuccess = true;
                    respWrp.message = 'Inspection receipt not found in Aman system'; 
                }
            }
            if(createInspObsr == true && inspObsrList.size() == 0){
                ETI_Inspection_Observation__c inspObsr = New ETI_Inspection_Observation__c();
                if(ReceiptNo != '')
                    inspObsr.AMAN_Receipt_No__c = ReceiptNo;
                else
                    inspObsr.AMAN_Receipt_No__c = searchStr;   
                if(inspRecptList.size()>0)
                    inspObsr.Aman_Receipt__c = inspRecptList[0]?.Id;
                Insert inspObsr;
                inspObsrList.add(inspObsr); 
            }
            if(inspObsrList.size()>0){
                respWrp.inspObsr = inspObsrList[0];
                respWrp.inspCodesNewBreak = getInspectionCodesSelected(inspObsrList[0]?.Break_Major_Codes__c?.split(';'),inspObsrList[0]?.Break_Minor_Codes__c?.split(';'));
                respWrp.inspCodesNewVisual = getInspectionCodesSelected(inspObsrList[0]?.Visual_Major_Codes__c?.split(';'),inspObsrList[0]?.Visual_Minor_Codes__c?.split(';'));
            }
        }
        return JSON.serialize(respWrp);
    }
    
    @auraEnabled
    public static List<ETI_Inspection_Observation__c> queryInspObsrList(string searchStr, String inspObsrFields) {
        String queryStr = 'SELECT '+inspObsrFields+' FROM ETI_Inspection_Observation__c WHERE AMAN_Receipt_No__c =: searchStr LIMIT 1';
        return (List<ETI_Inspection_Observation__c>)(database.query(queryStr));
    }
    
    @auraEnabled
    public static ReceiptWrapper getInspectionReceipt(string recpNo) {
        //System.debug('recpNo >>> '+recpNo);
        ReceiptWrapper receiptWrp = New ReceiptWrapper();
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('amanReceiptDetails');
        Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        HttpRequest request = new HttpRequest();
        if(ET_REST_Authorize_Helper.runningInASandbox()){
            request.setEndpoint(connection.Dev_Endpoint__c+'?ReceiptNo='+recpNo);           
        }else{
            request.setEndpoint(connection.LiveEndpoint_c__c+'?ReceiptNo='+recpNo);
        } 
        request.setMethod('GET');
        request.setTimeout(120000);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization','Basic '+paramvalue);   
        Http http = new Http();
        HttpResponse response = http.send(request);
        //system.debug('response Body >>> '+response.getBody()); 
        if (response.getStatusCode() == 200) {
            receiptWrp = (ReceiptWrapper) JSON.deserialize(response.getBody(), ReceiptWrapper.class);
            List<PreviousTestWrapper> Test_No_List = New List<PreviousTestWrapper>();
            List<String> codes = New List<String>();
            if(receiptWrp.Status == 'S' && receiptWrp.Message == 'Inspection Receipt Exists'){
                //system.debug('En test : '+receiptWrp.ReceiptDetails.Test_Type.EN);
                if(receiptWrp.ReceiptDetails.Test_Type.EN == 'Retest' && receiptWrp.ReceiptDetails.Test_No_List != null){
                    Test_No_List = receiptWrp.ReceiptDetails.Test_No_List;
                    if(Test_No_List.size() > 0){
                        for(PreviousTestWrapper test: Test_No_List){
                            codes.add(test.Code.removeStartIgnoreCase('0'));
                        }
                        if(codes.Size() > 0){
                            receiptWrp.inspCodeMap = getInspectionCodes(codes);
                            receiptWrp.inspCodesOld = getInspectionCodesSelected(codes, New List<String>());
                        }
                    }
                }else{
                    receiptWrp.inspCodeMap = getInspectionCodes(codes);
                }
                receiptWrp.ReceiptDetails.Test_No_List = Test_No_List;
                //system.debug('ReceiptDetails >>> '+receiptWrp.ReceiptDetails); 
            }
        }
        return receiptWrp;
    }
    
    @auraEnabled(cacheable=true)
    public static Map<String,inspCodeWrapper> getInspectionCodes(List<String> codes) {
        Map<String,inspCodeWrapper> inspCodeMap = New Map<String,inspCodeWrapper>();
        Map<String,ETI_Visual_Defect_Test__c> mapVDT = New Map<String,ETI_Visual_Defect_Test__c>();
        List<ETI_Visual_Defect_Test__c> recVDTList = New List<ETI_Visual_Defect_Test__c>();
        if(codes.Size()>0){
            recVDTList = [SELECT Id,Name,Id__c,Ord_No__c,Refer_Id__c,Test_Type_Name_En__c,Prof_Id__c,Type_Level__c,Test_Type_Id__c,Test_Type_Name_Ar__c,Type__c
                          FROM ETI_Visual_Defect_Test__c WHERE Type__c != '' AND Id__c IN: codes ORDER BY Id__c ASC];
        }else{
            recVDTList = [SELECT Id,Name,Id__c,Ord_No__c,Refer_Id__c,Test_Type_Name_En__c,Prof_Id__c,Type_Level__c,Test_Type_Id__c,Test_Type_Name_Ar__c,Type__c
                          FROM ETI_Visual_Defect_Test__c WHERE Type__c != '' ORDER BY Id__c ASC];
        }
        if(recVDTList.Size()>0){										
            for(ETI_Visual_Defect_Test__c recVDT: recVDTList){
                inspCodeDetailWrapper inspCode = New inspCodeDetailWrapper();
                inspCode.recordVDT = recVDT;
                if(!inspCodeMap.containsKey(recVDT.Type__c)){
                    inspCodeWrapper inspCodeWrp = New inspCodeWrapper();
                    inspCodeWrp.defectCount = 0;
                    inspCodeWrp.inspCodeDetails = New List<inspCodeDetailWrapper>{inspCode};
                        inspCodeMap.put(recVDT.Type__c, inspCodeWrp);
                }
                else if(inspCodeMap.containsKey(recVDT.Type__c)){
                    inspCodeMap.get(recVDT.Type__c).inspCodeDetails.add(inspCode);
                }
            }
        }
        //System.debug('inspCodeMap size >>> '+inspCodeMap.size());	
        if(inspCodeMap.Size()>0)
            return inspCodeMap; 	
        else 			   
            return null;								   
    }
    
    @auraEnabled(cacheable=true)
    public static List<inspectionCode> getInspectionCodesSelected(List<String> codesMajor,List<String> codesMinor) {
        List<ETI_Visual_Defect_Test__c> recVDTList = New List<ETI_Visual_Defect_Test__c>();
        List<inspectionCode> inspCodes = New List<inspectionCode>();
        Map<String,String> codesMap = New Map<String,String>();
        if(codesMajor != null){
            if(codesMajor.Size()>0){
                for(String code: codesMajor){
                    codesMap.put(code,'Major');
                }
            }
        }
        if(codesMinor != null){
            if(codesMinor.Size()>0){
                for(String code: codesMinor){
                    codesMap.put(code,'Minor');
                }
            }
        }
        if(codesMap.Size()>0){
            recVDTList = [SELECT Id,Name,Id__c,Ord_No__c,Refer_Id__c,Test_Type_Name_En__c,Prof_Id__c,Type_Level__c,Test_Type_Id__c,Test_Type_Name_Ar__c,Type__c
                          FROM ETI_Visual_Defect_Test__c WHERE Type__c != '' AND Id__c IN: codesMap.keySet() ORDER BY Id__c ASC];
        }
        //System.debug('recVDTList size >>> '+recVDTList.size());	
        if(recVDTList.Size()>0){
            for(ETI_Visual_Defect_Test__c recVDT: recVDTList){
                inspectionCode inspCode = New inspectionCode();
                inspCode.code = recVDT.Id__c;
                if(codesMap.containsKey(recVDT.Id__c))
                    inspCode.defect = codesMap.get(recVDT.Id__c);
                inspCode.recVDT = recVDT;
                inspCodes.add(inspCode);
            }
        }
        
        if(inspCodes.Size()>0)
            return inspCodes; 	
        else 			   
            return null;								   
    }
    
    @auraEnabled
    public static String saveInspectionReceipt(ETI_Inspection_Observation__c inspObsr, String inspObsrFields) {
        //System.debug('inspObsr : '+inspObsr);
        Savepoint sp = Database.setSavepoint();
        List<ETI_Inspection_Observation__c> inspObsrList = New List<ETI_Inspection_Observation__c>();
        if(inspObsr != null && inspObsrFields != null){
            try{
                Upsert inspObsr;
                String inspObsrId = inspObsr.Id;
                String queryStr = 'SELECT '+inspObsrFields+' FROM ETI_Inspection_Observation__c WHERE Id =: inspObsrId LIMIT 1';
                inspObsrList = Database.query(queryStr);
            }catch(exception ex){
                System.debug('Ex Message: '+ex.getmessage());
                Database.rollback(sp);
            }
        }
        //System.debug('inspObsrList Size : '+inspObsrList.Size());
        if(inspObsrList.size()>0)
            return JSON.serialize(inspObsrList[0]);
        else
            return null;
    }
    
    @AuraEnabled
    public static String uploadFile(String base64, String filename, String recordId) {
        ContentVersion cv = createContentVersion(base64, filename);
        ContentDocumentLink cdl = createContentLink(cv.Id, recordId);
        if (cv == null || cdl == null)
        { 
            return null; 
        }
        return cdl.Id;
    }
    
    private static ContentVersion createContentVersion(String base64, String filename) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        try {
            insert cv;
            return cv;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
    
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) { return null; }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id =: contentVersionId
        ].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        // ShareType is either 'V', 'C', or 'I'
        // V = Viewer, C = Collaborator, I = Inferred
        cdl.ShareType = 'V';
        try {
            insert cdl;
            return cdl;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static Map<ID, String> getRelatedFilesByRecordId(String recordId) {
        List<ContentDocumentLink> files = New List<ContentDocumentLink> (); 
        Map<ID, String> mapIdTitle = new Map<ID, String>(); 
        if(!String.isEmpty(recordId))    
            files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
        List<ID> fileIDs = new List<ID>();
        if(files.Size()>0){
            for (ContentDocumentLink docLink : files) {
                fileIDs.add(docLink.ContentDocumentId);
            }
            List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
                                         FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];
            for (ContentVersion docLink : docs) {
                mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
            }
        }
        //System.debug('mapIdTitle Size: '+mapIdTitle.Size());
        if(mapIdTitle.Size()>0)
            return mapIdTitle;
        else return null;
    }
    
    @AuraEnabled
    public static Boolean deleteFile(String ContentDocId) {
        Boolean isSuccess;
        //System.debug('ContentDocId: '+ContentDocId);
        try{
            delete new ContentDocument(Id = ContentDocId);
            isSuccess = true;
        }catch(Exception e){
            System.debug(e);
            isSuccess = false;
        }
        return isSuccess;
    }
    
    public class ReceiptWrapper {
        public String Status;
        public String Message;
        public ReceiptDetailWrapper ReceiptDetails;
        Map<String,inspCodeWrapper> inspCodeMap;
        public List<inspectionCode> inspCodesOld;
    }
    
    public class ReceiptDetailWrapper {
        public LanguageWrapper Location;
        public String Receipt_No;
        public String Receipt_DateTime;
        public String Reference_No;
        public String Pay_type;
        public LanguageWrapper Lane_Type;
        public LanguageWrapper Test_Type;
        public LanguageWrapper Test_Purpose;
        public String Test_Count;
        public String Amount;
        public String Total_Amount;
        public String Cashier;
        public List<PreviousTestWrapper> Test_No_List;
        public String Test_Violation_No_List;
        public VehicleDetailWrapper Vehicle_Details;
    }
    
    public class VehicleDetailWrapper {
        public String Plate_No;
        public LanguageWrapper Plate_Color;
        public LanguageWrapper Plate_Type;
        public LanguageWrapper Plate_Source;
        public LanguageWrapper Vehicle_Make;
        public LanguageWrapper Vehicle_Model;
        public LanguageWrapper Vehicle_Type;
        public LanguageWrapper Vehicle_Color;
        public LanguageWrapper Country;
        public String Model_Year;
        public String Body_Number;
        public String Chassis_No;
        public String Act_Chassis_No;
        public String Engine_No;
        public String Cylinders;
        public String Doors;
        public String Seats;
        public String Axles;
        public String Tires;
        public String Horsepower;
        public LanguageWrapper Weight_Unloaded;
        public LanguageWrapper Weight_Loaded;
        public LanguageWrapper Fuel_Type;
        public LanguageWrapper Gear_Type;
        public LanguageWrapper Steering_Type;
        public String KM_Reading;
    }
    
    public class PreviousTestWrapper {
        public String Code;
        public LanguageWrapper Name;
        public String Type;
        public String Defect;
    }
    
    public class LanguageWrapper {
        public String EN;
        public String AR;
    }
    
    public class inspCodeWrapper {
        public List<inspCodeDetailWrapper> inspCodeDetails;
        public Integer defectCount;
    }
    
    public class inspCodeDetailWrapper {
        public ETI_Visual_Defect_Test__c recordVDT;
        public List<optionWrapper> options;
        public String selectedOption;
        Public inspCodeDetailWrapper(){
            recordVDT = New ETI_Visual_Defect_Test__c();
            options = New List<optionWrapper>{new optionWrapper('Qualified','Qualified'),new optionWrapper('Minor Defect','Minor Defect'),new optionWrapper('Major Defect','Major Defect')}; //{'Qualified','Minor Defect','Major Defect','Extreme Defect'}
                selectedOption = 'Qualified';
        }
    }
    public class optionWrapper {
        public String label;
        public String value;
        public optionWrapper(String label, String value){
            this.label = label;
            this.value = value;
        }
    }
    
    public class responseWrapper {
        public Boolean isSuccess;
        public String message;
        public ReceiptWrapper receiptWrp;
        public ETI_Inspection_Receipt__c inspRecpt;
        public ETI_Inspection_Observation__c inspObsr;
        public List<inspectionCode> inspCodesNewBreak;
        public List<inspectionCode> inspCodesNewVisual;
        responseWrapper(){
            isSuccess = false;
            message = '';
            receiptWrp = New ReceiptWrapper();
            inspRecpt = New ETI_Inspection_Receipt__c();
            inspObsr = New ETI_Inspection_Observation__c();
            inspCodesNewBreak = New List<inspectionCode>();
            inspCodesNewVisual = New List<inspectionCode>();
        }
    }
    
    public class inspectionCode {
        public String code;
        public String defect;
        public ETI_Visual_Defect_Test__c recVDT;
    }
    
}