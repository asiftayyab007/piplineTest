({
    setCommunityLanguage : function(component, event, helper) {
        var url_string = window.location.href;
        var url = new URL(url_string);
        var lang = url.searchParams.get("lang");
        if(lang == '' || lang == null || lang == undefined){
           lang='en';
        }
        component.set('v.clLang',lang);
        if(lang == 'ar'){
            component.set("v.clRelationShip", $A.get("$Label.c.Relationship_AR"));
            component.set("v.clDropupLandMark", $A.get("$Label.c.ETST_Dropoff_Land_Mark_AR"));
            component.set("v.clGuardian", $A.get("$Label.c.ETST_Guardian_AR"));
            component.set("v.clBusInformation", $A.get("$Label.c.busInfo_AR"));
            component.set("v.clDisplayLocation", $A.get("$Label.c.ETST_Display_Location_AR"));
            component.set("v.clPickupLandMark", $A.get("$Label.c.ETST_Pickup_Land_Mark_AR"));
            component.set("v.clYourChildren", $A.get("$Label.c.ETST_Your_Children_AR"));
            component.set("v.clServiceInfo", $A.get("$Label.c.ETST_Service_Info_AR"));
            component.set("v.clPersonalInfo", $A.get("$Label.c.ETST_Personal_Info_AR"));
            component.set("v.clAddService", $A.get("$Label.c.ETST_Add_Service_AR")); 
            component.set("v.clRenewService", $A.get("$Label.c.ETST_Add_Service_AR"));
            component.set("v.clServiceType", $A.get("$Label.c.ETST_Service_Type_AR"));
            component.set("v.clTransportType", $A.get("$Label.c.ETST_Transport_Type_AR"));
            component.set("v.clPickupStartDate", $A.get("$Label.c.ETST_Pick_Up_Start_Date_AR"));
            component.set("v.clPickupEndDate", $A.get("$Label.c.ETST_Pick_Up_End_Date_AR"));
            component.set("v.clPickupLocation", $A.get("$Label.c.ETST_Pickup_Location_AR"));
            component.set("v.clDropOffLocation", $A.get("$Label.c.ETST_Drop_Off_Location_AR"))                        
			component.set("v.clSelectLocation", $A.get("$Label.c.ETST_Select_Location_AR"));
            component.set("v.clInvalidAddress", $A.get("$Label.c.ETST_Invalid_Address_AR"));
            component.set("v.clClose", $A.get("$Label.c.ETST_Close_AR"));    ;
            component.set("v.clPaidBy", $A.get("$Label.c.ETST_Paid_By_AR"));
            component.set("v.clBuildingNumber", $A.get("$Label.c.ETST_Building_Number_AR"));
            component.set("v.clEmployerName", $A.get("$Label.c.ETST_Employer_Name_AR"));
            component.set("v.clStreetNumber", $A.get("$Label.c.ETST_Street_Number_AR"));
            component.set("v.clEmployerBillingAddress", $A.get("$Label.c.ETST_Employer_Billing_Address_AR"));
            component.set("v.clCity", $A.get("$Label.c.ETST_City_AR"));
            component.set("v.clCountry", $A.get("$Label.c.ETST_Country_AR"));
            component.set("v.clFare", $A.get("$Label.c.ETST_Fare_AR"));
            component.set("v.clUpdateService", $A.get("$Label.c.ETST_Update_Service_AR"));
            component.set("v.clBack", $A.get("$Label.c.ETST_Back_AR"));
            component.set("v.clDeactivateService", $A.get("$Label.c.ETST_Deactivate_Service_AR"));
            component.set("v.clCancellationType", $A.get("$Label.c.ETST_Reason_for_Cancellation_AR"));
            component.set("v.clCancellationReason", $A.get("$Label.c.ETST_Cancellation_Reason_AR"));
            component.set("v.clCancellationValidationMsg", $A.get("$Label.c.ETST_Cancellation_Validation_Msg_AR"));
            component.set("v.clCancellationEffectiveDateValidationMsg", $A.get("$Label.c.ETST_Cancellation_Effective_Date_Validation_Msg_AR"));
            component.set("v.clCancellationEffectiveDate", $A.get("$Label.c.ETST_Cancellation_Effective_Date_AR"));
            component.set("v.clCancellationEndDate", $A.get("$Label.c.ETST_Cancellation_End_Date_AR"));
            component.set("v.clCancel", $A.get("$Label.c.ETST_Cancel_AR"));
            component.set("v.clDeactivate", $A.get("$Label.c.ETST_Deactivate_AR"));
            component.set("v.clComments", $A.get("$Label.c.ETST_Comments_AR"));
            component.set("v.clOnholdNote", $A.get("$Label.c.ETST_On_Hold_Note_AR"));           
            component.set("v.clAddChild", $A.get("$Label.c.ETST_Add_Child_AR"));
            component.set("v.clSchoolType", $A.get("$Label.c.ETST_School_Type_AR"));           
            component.set("v.clFirstName", $A.get("$Label.c.ETST_First_Name_AR"));
            component.set("v.clMiddleName", $A.get("$Label.c.ETST_Middle_Name_AR"));
            component.set("v.clLastName", $A.get("$Label.c.ETST_Last_Name_AR"));
            component.set("v.clStudentId", $A.get("$Label.c.ETST_Student_Id_AR"));
            component.set("v.clEmail", $A.get("$Label.c.ETST_Email_AR"));            
            component.set("v.clNationality", $A.get("$Label.c.ETST_Nationality_AR"));
            component.set("v.clGender", $A.get("$Label.c.ETST_Gender_AR"));
            component.set("v.clGrade", $A.get("$Label.c.ETST_Grade_AR"));
            component.set("v.clSection", $A.get("$Label.c.ETST_Section_AR"));
            component.set("v.clDateofBirth", $A.get("$Label.c.ETST_Date_of_Birth_AR"));            
            component.set("v.clBloodGroup", $A.get("$Label.c.ETST_Blood_Group_AR"));
            component.set("v.clMedicalCondition", $A.get("$Label.c.ETST_Medical_Condition_AR"));
            component.set("v.clTermsandConditions", $A.get("$Label.c.ETST_Terms_Conditions_AR"));
            component.set("v.clUploadPhoto", $A.get("$Label.c.ETST_Upload_Your_Student_Photo_AR"));
            component.set("v.clSearchSchool", $A.get("$Label.c.ETST_Search_School_AR"));  
            component.set("v.clUpdate", $A.get("$Label.c.ETST_Update_AR"));
            component.set("v.clPayNow", $A.get("$Label.c.ETST_Pay_Now_AR"));
            component.set("v.clRenew", $A.get("$Label.c.ETST_Renew_AR"));  
            component.set("v.clEmailInvoice", $A.get("$Label.c.ETST_Email_Invoice_AR"));
            component.set("v.clActivate", $A.get("$Label.c.ETST_Activate_AR"));
            component.set("v.clAddYourChild", $A.get("$Label.c.ETST_Add_Your_Child_AR"));
            component.set("v.clPersonal", $A.get("$Label.c.ETST_Personal_AR"));
            component.set("v.clOther", $A.get("$Label.c.ETST_Other_AR"));
            component.set("v.clUpload", $A.get("$Label.c.ETST_Upload_AR"));
            component.set("v.clNext", $A.get("$Label.c.ETST_Next_AR"));
            component.set("v.clPrevious", $A.get("$Label.c.ETST_Previous_AR"));
            component.set("v.clSaveChild", $A.get("$Label.c.ETST_Save_Child_AR"));
            component.set("v.clSubmit", $A.get("$Label.c.ETST_Submit_AR"));
            component.set("v.clTermsandConditionsvalidationMsg", $A.get("$Label.c.ETST_Terms_Conditions_Validation_Msg_AR"));
            component.set("v.clHome", $A.get("$Label.c.ETST_Home_AR"));
            component.set("v.clChangeImage", $A.get("$Label.c.ETST_Change_Image_AR"));
            component.set("v.clPayment", $A.get("$Label.c.ETST_Payment_AR"));
            component.set("v.clSupport", $A.get("$Label.c.ETST_Support_AR"));
            component.set("v.clBusInfo", $A.get("$Label.c.ETST_Bus_Info_AR"));
            component.set("v.clSave", $A.get("$Label.c.ETST_Save_AR"));
            component.set("v.clPaymentsInfo", $A.get("$Label.c.ETST_Payments_Info_AR"));
            component.set("v.clNoPayments", $A.get("$Label.c.ETST_No_Payments_AR"));
            component.set("v.clSearchLocation", $A.get("$Label.c.ETST_Search_Location_AR"));
            component.set("v.clFeedbackForm", $A.get("$Label.c.ETST_Feedback_Form_AR"));
            component.set("v.clCaseType", $A.get("$Label.c.ETST_Case_Type_AR"));
            component.set("v.clIssueCategory", $A.get("$Label.c.ETST_Issue_Category_AR"));
            component.set("v.clIssueType", $A.get("$Label.c.ETST_Issue_Type_AR"));
            component.set("v.clCompletethisfield", $A.get("$Label.c.ETST_Complete_this_field_AR"));
            component.set("v.clSameasPickUp", $A.get("$Label.c.ETST_Same_as_Pickup_Location_AR"));
            component.set("v.clUseCurrentLocation", $A.get("$Label.c.ETST_Use_Current_Location_AR"));
            component.set("v.clSearch", $A.get("$Label.c.ETST_Search_AR"));
            component.set("v.clPhone", $A.get("$Label.c.ETST_Phone_AR"));
            component.set("v.clEID", $A.get("$Label.c.ETST_EID_AR"));
            component.set("v.clPaymentMethods", $A.get("$Label.c.ETST_Payment_Methods_AR"));
            component.set("v.clOnpremise", $A.get("$Label.c.ETST_Please_pay_at_our_office_AR"));
            component.set("v.clAcceptchequeorCreditcard", $A.get("$Label.c.ETST_Note_We_only_accept_Cheque_or_Credit_card_AR"));
            component.set("v.clAddress", $A.get("$Label.c.ETST_Address_AR"));
            component.set("v.clVerifyBankTransfer", $A.get("$Label.c.ETST_We_will_verify_the_submitted_bank_transaction_AR"));
            component.set("v.clVerifyChequeDetails", $A.get("$Label.c.ETST_We_will_verify_the_submitted_cheque_details_AR"));             
            component.set("v.clBankTransfer", $A.get("$Label.c.ETST_Bank_Transfer_AR"));
            component.set("v.clChequeDetails", $A.get("$Label.c.ETST_Cheque_Details_AR"));
            component.set("v.clSubmittedBy", $A.get("$Label.c.ETST_Submitted_By_AR"));
            component.set("v.clAddresstoCourier", $A.get("$Label.c.ETST_Address_to_Courier_AR"));
            component.set("v.clTotalInvAmount", $A.get("$Label.c.ETST_Total_Inv_Amount_AR"));
            component.set("v.clETBankIBAN", $A.get("$Label.c.ETST_ET_Bank_IBAN_AR"));
            component.set("v.clETBankACNumber", $A.get("$Label.c.ETST_ET_Bank_A_C_Number_AR"));
            component.set("v.clETBankName", $A.get("$Label.c.ETST_ET_Bank_Name_AR"));
            component.set("v.clHaveyoutransferedamount", $A.get("$Label.c.ETST_Have_you_already_transferred_the_amount_AR"));
            component.set("v.clShow", $A.get("$Label.c.ETST_Show_AR"));
            component.set("v.clHide", $A.get("$Label.c.ETST_Hide_AR"));
            component.set("v.clFileUpload", $A.get("$Label.c.ETST_File_Upload_AR"));
            component.set("v.clEmiratesId", $A.get("$Label.c.ETST_Emirates_Id_AR"));
            component.set("v.clSchoolisMandatory", $A.get("$Label.c.ETST_School_is_Mandatory_AR"));
            component.set("v.clPleaseuseonlyletters", $A.get("$Label.c.ETST_Please_use_only_letters_AR"));
            component.set("v.clFirstNameisMandatory", $A.get("$Label.c.ETST_First_Name_is_Mandatory_AR"));
            component.set("v.clLastNameisMandatory", $A.get("$Label.c.ETST_Last_Name_is_Mandatory_AR"));
            component.set("v.clPleaseuseonlylettersorDigits", $A.get("$Label.c.ETST_Please_use_only_letters_or_Digits_AR"));
            component.set("v.clStudentIdisMandatory", $A.get("$Label.c.ETST_Student_Id_is_Mandatory_AR"));
            component.set("v.clEnteronlydigits", $A.get("$Label.c.ETST_Enter_only_digits_AR"));
            component.set("v.clCompletethispart", $A.get("$Label.c.ETST_Complete_this_part_AR"));
            component.set("v.clPleaseentercorrectmobilenumber", $A.get("$Label.c.ETST_Please_enter_correct_mobile_number_AR"));
            component.set("v.clGradeisMandatory", $A.get("$Label.c.ETST_Grade_is_Mandatory_AR"));
            component.set("v.clSectionisMandatory", $A.get("$Label.c.ETST_Section_is_Mandatory_AR"));
            component.set("v.clPleaseselectCorrectdate", $A.get("$Label.c.ETST_Please_select_Correct_date_AR"));
            component.set("v.clPhoneisMandatory", $A.get("$Label.c.ETST_Phone_is_Mandatory_AR"));
            component.set("v.clNoPricelistisassociatedtoyourschool", $A.get("$Label.c.ETST_No_Price_list_is_associated_to_your_school_AR"));
            component.set("v.clPleasecontactEmiratesTransport", $A.get("$Label.c.ETST_Please_contact_Emirates_Transport_AR"));
            component.set("v.clchooseone", $A.get("$Label.c.ETST_choose_one_AR"));
			component.set("v.clAccept", $A.get("$Label.c.etst_accept_ar"));
            component.set("v.clCancelService", $A.get("$Label.c.ETST_Cancel_Service_AR"));
            component.set("v.clonHoldButton", $A.get("$Label.c.ETST_onhold_button_AR"));
            component.set("v.clGetlocation", $A.get("$Label.c.ETST_Get_location_AR"));
            component.set("v.clCurrent", $A.get("$Label.c.ETST_Current_AR"));
            component.set("v.clRenewed", $A.get("$Label.c.ETST_Renewed_AR"));
            component.set("v.clMyServices", $A.get("$Label.c.ETST_My_Services_AR"));
            component.set("v.clHelp", $A.get("$Label.c.ETST_Help_AR"));
            component.set("v.clPleaseusecurrentlocationorUseMaptogetthelocation", $A.get("$Label.c.ETST_Please_use_current_location_or_Use_Map_to_get_the_location_AR"));
            component.set("v.clSchoolName", $A.get("$Label.c.ETST_School_Name_AR"));
            component.set("v.clNew", $A.get("$Label.c.ETST_New_AR")); 
            component.set("v.clInprogress", $A.get("$Label.c.ETST_In_Progress_AR"));
            component.set("v.clTotal", $A.get("$Label.c.ETST_Total_AR"));
            component.set("v.clClosed", $A.get("$Label.c.ETST_Closed_AR"));
            component.set("v.clOnHold", $A.get("$Label.c.ETST_On_Hold_AR"));
            component.set("v.clCaseNumber", $A.get("$Label.c.ETST_Case_Number_AR")); 
            component.set("v.clDescription", $A.get("$Label.c.ETST_Description_AR"));
            component.set("v.clRaisedDate", $A.get("$Label.c.ETST_Raised_Date_AR"));
            component.set("v.clSolution", $A.get("$Label.c.ETST_Solution_AR"));
            component.set("v.clStatus", $A.get("$Label.c.ETST_Status_AR"));
            component.set("v.clSearchRequests", $A.get("$Label.c.ETST_Search_Requests_AR"));
            component.set("v.clStudent", $A.get("$Label.c.ETST_Student_AR"));
            component.set("v.clSelectStudent", $A.get("$Label.c.ETST_Select_Student_AR"));
            component.set("v.clSelectRequestType", $A.get("$Label.c.ETST_Select_Request_Type_AR"));
            component.set("v.clBeneficiary", $A.get("$Label.c.ETST_Beneficiary_AR")); 
            component.set("v.clBankName", $A.get("$Label.c.ETST_Bank_Name_AR"));
            component.set("v.clAccountNo", $A.get("$Label.c.ETST_Account_No_AR"));
            component.set("v.clIBANCode", $A.get("$Label.c.ETST_IBAN_Code_AR"));
            component.set("v.clBranchName", $A.get("$Label.c.ETST_Branch_Name_AR"));
            component.set("v.clBankAddress", $A.get("$Label.c.ETST_Bank_Address_AR"));
            component.set("v.clPleaseentercorrectBankAddress", $A.get("$Label.c.ETST_Please_enter_correct_Bank_Address_AR"));
            component.set("v.clUploadEmiratesId", $A.get("$Label.c.ETST_Upload_Emirates_Id_AR"));
            component.set("v.clDelete", $A.get("$Label.c.ETST_Delete_AR"));
            component.set("v.clEnterBankDetails", $A.get("$Label.c.ETST_Enter_Bank_Details_AR"));
            component.set("v.clWouldyoulikearefund", $A.get("$Label.c.ETST_Would_you_like_a_refund_AR"));
            component.set("v.clType", $A.get("$Label.c.ETST_Type_AR"));
            component.set("v.clPleasesubscribeaservice", $A.get("$Label.c.ETST_Please_subscribe_a_service_AR"));
            component.set("v.clNote", $A.get("$Label.c.ETST_Note_AR"));
            component.set("v.clChangeSchool", $A.get("$Label.c.ETST_Change_School_AR"));
            component.set("v.clPleaseentercorrectIBAN", $A.get("$Label.c.ETST_Please_enter_correct_IBAN_AR"));
            component.set("v.clPleaseentercorrectBranchName", $A.get("$Label.c.ETST_Please_enter_correct_Branch_Name_AR"));
            component.set("v.clChangeofschoolwillleadtocancellingthecurrentrequestandremaining", $A.get("$Label.c.ETST_Change_of_school_will_lead_to_cancelling_the_current_request_and_remain_AR"))
            component.set("v.clChangeofschoolwillleadtocancellingthecurrentrequestifany", $A.get("$Label.c.ETST_Change_of_school_will_lead_to_cancelling_the_current_request_if_any_AR"));
            component.set("v.clDivision", $A.get("$Label.c.ETST_Division_AR"));     
            component.set("v.clUpdateLocation", $A.get("$Label.c.ETST_Update_Location_AR"));
            component.set("v.clServiceRequest", $A.get("$Label.c.ETST_Service_Request_AR"));
            component.set("v.clPayee", $A.get("$Label.c.ETST_Payee_AR"));
            component.set("v.clFareCharges", $A.get("$Label.c.ETST_Fare_Charges_AR"));
            component.set("v.clPickUpFrom", $A.get("$Label.c.ETST_Pick_Up_From_AR"));
            component.set("v.clDropOffTo", $A.get("$Label.c.ETST_Drop_Off_To_AR"));
            component.set("v.clPaymentFailed", $A.get("$Label.c.ETST_Payment_Failed_AR"));
            component.set("v.clTransactionId", $A.get("$Label.c.ETST_Transaction_ID_AR"));
            component.set("v.clPaymentMode", $A.get("$Label.c.ETST_Payment_Mode_AR"));
            component.set("v.clTransactionDate", $A.get("$Label.c.ETST_Transaction_Date_AR"));
            component.set("v.clSecondaryPhone", $A.get("$Label.c.ETST_Secondary_Phone_AR"));
            component.set("v.clDuration", $A.get("$Label.c.ETST_Duration_AR"));
            component.set("v.clArea", $A.get("$Label.c.ETST_Area_AR"));
            
            
        } else {
            component.set("v.clDisplayLocation", $A.get("$Label.c.ETST_Display_Location"));
            component.set("v.clBusInformation", $A.get("$Label.c.busInfo"));
            component.set("v.clGuardian", $A.get("$Label.c.ETST_Guardian"));
            component.set("v.clonHoldButton", $A.get("$Label.c.ETST_onhold_button"));
            component.set("v.clCancelService", $A.get("$Label.c.ETST_Cancel_Service"));
            component.set("v.clAccept", $A.get("$Label.c.etst_accept"));
            component.set("v.clDropupLandMark", $A.get("$Label.c.ETST_Dropoff_Land_Mark"));
            component.set("v.clPickupLandMark", $A.get("$Label.c.ETST_Pickup_Land_Mark"));
            component.set("v.clchooseone", $A.get("$Label.c.ETST_choose_one"));
            component.set("v.clYourChildren", $A.get("$Label.c.ETST_Your_Children"));
            component.set("v.clServiceInfo", $A.get("$Label.c.ETST_Service_Info"));
            component.set("v.clPersonalInfo", $A.get("$Label.c.ETST_Personal_Info"));
            component.set("v.clAddService", $A.get("$Label.c.ETST_Add_Service"));
            component.set("v.clRenewService", $A.get("$Label.c.ETST_Renew_Service"));
            component.set("v.clServiceType", $A.get("$Label.c.ETST_Service_Type"));
            component.set("v.clRelationShip", $A.get("$Label.c.Relationship"));
            component.set("v.clTransportType", $A.get("$Label.c.ETST_Transport_Type"));
            component.set("v.clPickupStartDate", $A.get("$Label.c.ETST_Pick_Up_Start_Date"));
            component.set("v.clPickupEndDate", $A.get("$Label.c.ETST_Pick_Up_End_Date"));
            component.set("v.clPickupLocation", $A.get("$Label.c.ETST_Pickup_Location"));
            component.set("v.clDropOffLocation", $A.get("$Label.c.ETST_Drop_Off_Location"));
            component.set("v.clSelectLocation", $A.get("$Label.c.ETST_Select_Location"));
            component.set("v.clInvalidAddress", $A.get("$Label.c.ETST_Invalid_Address"));
            component.set("v.clClose", $A.get("$Label.c.ETST_Close"));
            component.set("v.clPaidBy", $A.get("$Label.c.ETST_Paid_By"));
            component.set("v.clBuildingNumber", $A.get("$Label.c.ETST_Building_Number"));
            component.set("v.clEmployerName", $A.get("$Label.c.ETST_Employer_Name"));
            component.set("v.clStreetNumber", $A.get("$Label.c.ETST_Street_Number"));
            component.set("v.clEmployerBillingAddress", $A.get("$Label.c.ETST_Employer_Billing_Address"));
            component.set("v.clCity", $A.get("$Label.c.ETST_City"));
            component.set("v.clCountry", $A.get("$Label.c.ETST_Country"));
            component.set("v.clFare", $A.get("$Label.c.ETST_Fare"));
            component.set("v.clUpdateService", $A.get("$Label.c.ETST_Update_Service"));
            component.set("v.clBack", $A.get("$Label.c.ETST_Back"));
            component.set("v.clDeactivateService", $A.get("$Label.c.ETST_Deactivate_Service"));
            component.set("v.clCancellationType", $A.get("$Label.c.ETST_Reason_for_Cancellation"));
            component.set("v.clCancellationReason", $A.get("$Label.c.ETST_Cancellation_Reason"));
            component.set("v.clCancellationValidationMsg", $A.get("$Label.c.ETST_Cancellation_Validation_Msg"));
            component.set("v.clCancellationEffectiveDateValidationMsg", $A.get("$Label.c.ETST_Cancellation_Effective_Date_Validation_Msg"));
            component.set("v.clCancel", $A.get("$Label.c.ETST_Cancel"));
            component.set("v.clDeactivate", $A.get("$Label.c.ETST_Deactivate"));
            component.set("v.clCancellationEffectiveDate", $A.get("$Label.c.ETST_Cancellation_Effective_Date"));
            component.set("v.clCancellationEndDate", $A.get("$Label.c.ETST_Cancellation_End_Date"));
            component.set("v.clComments", $A.get("$Label.c.ETST_Comments"));
            component.set("v.clOnholdNote", $A.get("$Label.c.ETST_On_Hold_Note"));          
            component.set("v.clAddChild", $A.get("$Label.c.ETST_Add_Child"));
            component.set("v.clSchoolType", $A.get("$Label.c.ETST_School_Type"));           
            component.set("v.clFirstName", $A.get("$Label.c.ETST_First_Name"));
            component.set("v.clMiddleName", $A.get("$Label.c.ETST_Middle_Name"));
            component.set("v.clLastName", $A.get("$Label.c.ETST_Last_Name"));
            component.set("v.clStudentId", $A.get("$Label.c.ETST_Student_Id"));
            component.set("v.clEmail", $A.get("$Label.c.ETST_Email"));            
            component.set("v.clNationality", $A.get("$Label.c.ETST_Nationality"));
            component.set("v.clGender", $A.get("$Label.c.ETST_Gender"));
            component.set("v.clGrade", $A.get("$Label.c.ETST_Grade"));
            component.set("v.clSection", $A.get("$Label.c.ETST_Section"));
            component.set("v.clDateofBirth", $A.get("$Label.c.ETST_Date_of_Birth"));            
            component.set("v.clBloodGroup", $A.get("$Label.c.ETST_Blood_Group"));
            component.set("v.clMedicalCondition", $A.get("$Label.c.ETST_Medical_Condition"));
            component.set("v.clTermsandConditions", $A.get("$Label.c.ETST_Terms_Conditions"));
            component.set("v.clUploadPhoto", $A.get("$Label.c.ETST_Upload_Your_Student_Photo"));
          	component.set("v.clSearchSchool", $A.get("$Label.c.ETST_Search_School"));
            component.set("v.clUpdate", $A.get("$Label.c.ETST_Update"));
            component.set("v.clPayNow", $A.get("$Label.c.ETST_Pay_Now"));
            component.set("v.clRenew", $A.get("$Label.c.ETST_Renew"));  
            component.set("v.clEmailInvoice", $A.get("$Label.c.ETST_Email_Invoice"));
            component.set("v.clActivate", $A.get("$Label.c.ETST_Activate"));
            component.set("v.clAddYourChild", $A.get("$Label.c.ETST_Add_Your_Child"));
            component.set("v.clPersonal", $A.get("$Label.c.ETST_Personal"));
            component.set("v.clOther", $A.get("$Label.c.ETST_Other"));
            component.set("v.clUpload", $A.get("$Label.c.ETST_Upload"));
            component.set("v.clNext", $A.get("$Label.c.ETST_Next"));
            component.set("v.clPrevious", $A.get("$Label.c.ETST_Previous"));
            component.set("v.clSaveChild", $A.get("$Label.c.ETST_Save_Child"));
            component.set("v.clSubmit", $A.get("$Label.c.ETST_Submit"));
            component.set("v.clTermsandConditionsvalidationMsg", $A.get("$Label.c.ETST_Terms_Conditions_Validation_Msg"));
			component.set("v.clHome", $A.get("$Label.c.ETST_Home"));
            component.set("v.clChangeImage", $A.get("$Label.c.ETST_Change_Image"));
            component.set("v.clPayment", $A.get("$Label.c.ETST_Payment"));
            component.set("v.clSupport", $A.get("$Label.c.ETST_Support"));
            component.set("v.clBusInfo", $A.get("$Label.c.ETST_Bus_Info"));
            component.set("v.clSave", $A.get("$Label.c.ETST_Save"));
            component.set("v.clPaymentsInfo", $A.get("$Label.c.ETST_Payments_Info"));
            component.set("v.clNoPayments", $A.get("$Label.c.ETST_No_Payments"));
            component.set("v.clSearchLocation", $A.get("$Label.c.ETST_Search_Location"));
            component.set("v.clFeedbackForm", $A.get("$Label.c.ETST_Feedback_Form"));
            component.set("v.clCaseType", $A.get("$Label.c.ETST_Case_Type"));
            component.set("v.clIssueCategory", $A.get("$Label.c.ETST_Issue_Category"));
            component.set("v.clIssueType", $A.get("$Label.c.ETST_Issue_Type"));
            component.set("v.clCompletethisfield", $A.get("$Label.c.ETST_Complete_this_field"));
            component.set("v.clSameasPickUp", $A.get("$Label.c.ETST_Same_as_Pickup_Location"));
            component.set("v.clUseCurrentLocation", $A.get("$Label.c.ETST_Use_Current_Location"));
            component.set("v.clSearch", $A.get("$Label.c.ETST_Search"));
            component.set("v.clPhone", $A.get("$Label.c.ETST_Phone"));
            component.set("v.clEID", $A.get("$Label.c.ETST_EID"));
            component.set("v.clPaymentMethods", $A.get("$Label.c.ETST_Payment_Methods"));
            component.set("v.clOnpremise", $A.get("$Label.c.ETST_Please_pay_at_our_office"));
            component.set("v.clAcceptchequeorCreditcard", $A.get("$Label.c.ETST_Note_We_only_accept_Cheque_or_Credit_card"));
            component.set("v.clAddress", $A.get("$Label.c.ETST_Address"));
            component.set("v.clVerifyBankTransfer", $A.get("$Label.c.ETST_We_will_verify_the_submitted_bank_transaction"));
            component.set("v.clVerifyChequeDetails", $A.get("$Label.c.ETST_We_will_verify_the_submitted_cheque_details"));            
            component.set("v.clBankTransfer", $A.get("$Label.c.ETST_Bank_Transfer"));
            component.set("v.clChequeDetails", $A.get("$Label.c.ETST_Cheque_Details"));
            component.set("v.clSubmittedBy", $A.get("$Label.c.ETST_Submitted_By"));
            component.set("v.clAddresstoCourier", $A.get("$Label.c.ETST_Address_to_Courier"));
            component.set("v.clTotalInvAmount", $A.get("$Label.c.ETST_Total_Inv_Amount"));
            component.set("v.clETBankIBAN", $A.get("$Label.c.ETST_ET_Bank_IBAN"));
            component.set("v.clETBankACNumber", $A.get("$Label.c.ETST_ET_Bank_A_C_Number"));
            component.set("v.clETBankName", $A.get("$Label.c.ETST_ET_Bank_Name"));
            component.set("v.clHaveyoutransferedamount", $A.get("$Label.c.ETST_Have_you_already_transferred_the_amount"));
            component.set("v.clShow", $A.get("$Label.c.ETST_Show"));
            component.set("v.clHide", $A.get("$Label.c.ETST_Hide"));
            component.set("v.clFileUpload", $A.get("$Label.c.ETST_File_Upload"));
            component.set("v.clEmiratesId", $A.get("$Label.c.ETST_Emirates_Id"));
            component.set("v.clSchoolisMandatory", $A.get("$Label.c.ETST_School_is_Mandatory"));
            component.set("v.clPleaseuseonlyletters", $A.get("$Label.c.ETST_Please_use_only_letters"));
            component.set("v.clFirstNameisMandatory", $A.get("$Label.c.ETST_First_Name_is_Mandatory"));
            component.set("v.clLastNameisMandatory", $A.get("$Label.c.ETST_Last_Name_is_Mandatory"));
            component.set("v.clPleaseuseonlylettersorDigits", $A.get("$Label.c.ETST_Please_use_only_letters_or_Digits"));
            component.set("v.clStudentIdisMandatory", $A.get("$Label.c.ETST_Student_Id_is_Mandatory"));
            component.set("v.clEnteronlydigits", $A.get("$Label.c.ETST_Enter_only_digits"));
            component.set("v.clCompletethispart", $A.get("$Label.c.ETST_Complete_this_part"));
            component.set("v.clPleaseentercorrectmobilenumber", $A.get("$Label.c.ETST_Please_enter_correct_mobile_number"));
            component.set("v.clGradeisMandatory", $A.get("$Label.c.ETST_Grade_is_Mandatory"));
            component.set("v.clSectionisMandatory", $A.get("$Label.c.ETST_Section_is_Mandatory"));
            component.set("v.clPleaseselectCorrectdate", $A.get("$Label.c.ETST_Please_select_Correct_date"));
            component.set("v.clPhoneisMandatory", $A.get("$Label.c.ETST_Phone_is_Mandatory"));
            component.set("v.clNoPricelistisassociatedtoyourschool", $A.get("$Label.c.ETST_No_Price_list_is_associated_to_your_school"));
            component.set("v.clPleasecontactEmiratesTransport", $A.get("$Label.c.ETST_Please_contact_Emirates_Transport"));
            component.set("v.clGetlocation", $A.get("$Label.c.ETST_Get_location"));
            component.set("v.clSecondaryPhone", $A.get("$Label.c.ETST_Secondary_Phone"));
            component.set("v.clCurrent", $A.get("$Label.c.ETST_Current"));
            component.set("v.clRenewed", $A.get("$Label.c.ETST_Renewed"));
            component.set("v.clMyServices", $A.get("$Label.c.ETST_My_Services"));
            component.set("v.clHelp", $A.get("$Label.c.ETST_Help"));
            component.set("v.clPleaseusecurrentlocationorUseMaptogetthelocation", $A.get("$Label.c.ETST_Please_use_current_location_or_Use_Map_to_get_the_location"));
            component.set("v.clSchoolName", $A.get("$Label.c.ETST_School_Name"));
            component.set("v.clNew", $A.get("$Label.c.ETST_New")); 
            component.set("v.clInprogress", $A.get("$Label.c.ETST_In_Progress"));
            component.set("v.clTotal", $A.get("$Label.c.ETST_Total"));
            component.set("v.clClosed", $A.get("$Label.c.ETST_Closed"));
            component.set("v.clOnHold", $A.get("$Label.c.ETST_On_Hold_Status"));
            component.set("v.clCaseNumber", $A.get("$Label.c.ETST_Case_Number")); 
            component.set("v.clDescription", $A.get("$Label.c.ETST_Description"));
            component.set("v.clRaisedDate", $A.get("$Label.c.ETST_Raised_Date"));
            component.set("v.clSolution", $A.get("$Label.c.ETST_Solution"));
            component.set("v.clStatus", $A.get("$Label.c.ETST_Status"));
            component.set("v.clSearchRequests", $A.get("$Label.c.ETST_Search_Requests"));
            component.set("v.clStudent", $A.get("$Label.c.ETST_Student"));
            component.set("v.clSelectStudent", $A.get("$Label.c.ETST_Select_Student"));
            component.set("v.clSelectRequestType", $A.get("$Label.c.ETST_Select_Request_Type"));
            component.set("v.clBeneficiary", $A.get("$Label.c.ETST_Beneficiary")); 
            component.set("v.clBankName", $A.get("$Label.c.ETST_Bank_Name"));
            component.set("v.clAccountNo", $A.get("$Label.c.ETST_Account_No"));
            component.set("v.clIBANCode", $A.get("$Label.c.ETST_IBAN_Code"));
            component.set("v.clBranchName", $A.get("$Label.c.ETST_Branch_Name"));
            component.set("v.clBankAddress", $A.get("$Label.c.ETST_Bank_Address"));
            component.set("v.clPleaseentercorrectBankAddress", $A.get("$Label.c.ETST_Please_enter_correct_Bank_Address"));
            component.set("v.clUploadEmiratesId", $A.get("$Label.c.ETST_Upload_Emirates_Id"));
            component.set("v.clDelete", $A.get("$Label.c.ETST_Delete"));
            component.set("v.clEnterBankDetails", $A.get("$Label.c.ETST_Enter_Bank_Details"));
            component.set("v.clWouldyoulikearefund", $A.get("$Label.c.ETST_Would_you_like_a_refund"));
            component.set("v.clType", $A.get("$Label.c.ETST_Type"));
            component.set("v.clPleasesubscribeaservice", $A.get("$Label.c.ETST_Please_subscribe_a_service"));
            component.set("v.clNote", $A.get("$Label.c.ETST_Note"));
            component.set("v.clChangeSchool", $A.get("$Label.c.ETST_Change_School"));
            component.set("v.clPleaseentercorrectIBAN", $A.get("$Label.c.ETST_Please_enter_correct_IBAN"));
            component.set("v.clPleaseentercorrectBranchName", $A.get("$Label.c.ETST_Please_enter_correct_Branch_Name"));
            component.set("v.clChangeofschoolwillleadtocancellingthecurrentrequestandremaining", $A.get("$Label.c.ETST_Change_of_school_will_lead_to_cancelling_the_current_request_and_remaining"))
            component.set("v.clChangeofschoolwillleadtocancellingthecurrentrequestifany", $A.get("$Label.c.ETST_Change_of_school_will_lead_to_cancelling_the_current_request_if_any"));
            component.set("v.clDivision", $A.get("$Label.c.ETST_Division"));
            component.set("v.clUpdateLocation", $A.get("$Label.c.ETST_Update_Location"));
            component.set("v.clServiceRequest", $A.get("$Label.c.ETST_Service_Request"));
            component.set("v.clPayee", $A.get("$Label.c.ETST_Payee"));
            component.set("v.clFareCharges", $A.get("$Label.c.ETST_Fare_Charges"));
            component.set("v.clPickUpFrom", $A.get("$Label.c.ETST_Pick_Up_From"));
            component.set("v.clDropOffTo", $A.get("$Label.c.ETST_Drop_Off_To"));
            component.set("v.clPaymentFailed", $A.get("$Label.c.ETST_Payment_Failed"));
            component.set("v.clTransactionId", $A.get("$Label.c.ETST_Transaction_ID"));
            component.set("v.clPaymentMode", $A.get("$Label.c.ETST_Payment_Mode"));
            component.set("v.clTransactionDate", $A.get("$Label.c.ETST_Transaction_Date"));
            component.set("v.clDuration", $A.get("$Label.c.ETST_Duration"));
            component.set("v.clArea", "Area");
  
        }
    }
})