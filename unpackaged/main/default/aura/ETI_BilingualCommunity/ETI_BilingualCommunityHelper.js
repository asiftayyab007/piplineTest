({
	setCommunityLanguage : function(component, event, helper) {
        console.log('Bilingual Community');
        component.set("v.IsSpinner", true);
        var url_string = window.location.href;
        var url = new URL(url_string);
        var lang = url.searchParams.get("lang");
        if(lang!=null)
        	component.set('v.clLang',lang);
        if(component.get('v.clLang') == 'ar'){
        	component.set("v.Vehicle", $A.get("$Label.c.ETI_Vehicle_AR"));
            component.set("v.Upcoming_Service", $A.get("$Label.c.ETI_Upcoming_Service_AR"));
            component.set("v.Payment_History", $A.get("$Label.c.ETI_Payment_History_AR"));
            component.set("v.History", $A.get("$Label.c.ETI_History_AR"));
            component.set("v.My_Cases", $A.get("$Label.c.ETI_My_Cases_AR"));
            component.set("v.Vehicle_Details", $A.get("$Label.c.ETI_Vehicle_Details_AR"));
            component.set("v.Booking_History", $A.get("$Label.c.ETI_Booking_History_AR"));
            component.set("v.Start_Date", $A.get("$Label.c.Start_Date_AR"));
            component.set("v.End_Date", $A.get("$Label.c.End_Date_AR"));
        }else {
            component.set("v.Vehicle", $A.get("$Label.c.ETI_Vehicle"));
            component.set("v.Upcoming_Service", $A.get("$Label.c.ETI_Upcoming_Service"));
            component.set("v.Payment_History", $A.get("$Label.c.ETI_Payment_History"));
            component.set("v.History", $A.get("$Label.c.ETI_History"));
            component.set("v.My_Cases", $A.get("$Label.c.ETI_My_Cases"));
            component.set("v.Vehicle_Details", $A.get("$Label.c.ETI_Vehicle_Details"));
            component.set("v.Booking_History", $A.get("$Label.c.ETI_Booking_History"));
            component.set("v.Start_Date", $A.get("$Label.c.Start_Date"));
            component.set("v.End_Date", $A.get("$Label.c.End_Date"));
        }
        var action = component.get("c.getBilingualCommunityLabels");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('result bilingual '+JSON.stringify(result));
                var fieldName='English_Name__c';
                if(lang == 'ar')
                    fieldName ='Arabic_Name__c';
                for(var i=0;i<result.length; i++){
                    console.log('fieldName '+fieldName);
                    if(result[i].DeveloperName=='Accept')
                        component.set('v.Accept',result[i][fieldName]);
                    if(result[i].DeveloperName=='Account_Name')
                        component.set('v.Account_Name',result[i][fieldName]);
                    if(result[i].DeveloperName=='Action')
                        component.set('v.Action',result[i][fieldName]);
                    if(result[i].DeveloperName=='Add')
                        component.set('v.Add',result[i][fieldName]);
                    if(result[i].DeveloperName=='Add_to_Cart')
                        component.set('v.Add_to_Cart',result[i][fieldName]);
                    if(result[i].DeveloperName=='Agree_the_Terms_and_Conditions')
                        component.set('v.Agree_the_Terms_and_Conditions',result[i][fieldName]);
                    if(result[i].DeveloperName=='AMOUNT_AED')
                        component.set('v.AMOUNT_AED',result[i][fieldName]);
                    if(result[i].DeveloperName=='Available_Locations')
                        component.set('v.Available_Locations',result[i][fieldName]);
                    if(result[i].DeveloperName=='Available_Slots')
                        component.set('v.Available_Slots',result[i][fieldName]);
                    if(result[i].DeveloperName=='Add_your_Vehicles_Message')
                        component.set('v.Add_your_Vehicles_Message',result[i][fieldName]);
                    if(result[i].DeveloperName=='Account_Management')
                        component.set('v.Account_Management',result[i][fieldName]);
                    if(result[i].DeveloperName=='Add_Vehicle')
                        component.set('v.Add_Vehicle',result[i][fieldName]);
                    if(result[i].DeveloperName=='ADFCA_Type')
                        component.set('v.ADFCA_Type',result[i][fieldName]);
                    if(result[i].DeveloperName=='Alert')
                        component.set('v.Alert',result[i][fieldName]);
                    if(result[i].DeveloperName=='All_fields_are_Mandatory')
                        component.set('v.All_fields_are_Mandatory',result[i][fieldName]);
                    if(result[i].DeveloperName=='Atleast_select_one_Vehicle')
                        component.set('v.Atleast_select_one_Vehicle',result[i][fieldName]);
                    if(result[i].DeveloperName=='Book')
                        component.set('v.Book',result[i][fieldName]);
                    if(result[i].DeveloperName=='Booking_Date')
                        component.set('v.Booking_Date',result[i][fieldName]);
                    if(result[i].DeveloperName=='Booking_Details')
                        component.set('v.Booking_Details',result[i][fieldName]);
                    if(result[i].DeveloperName=='Booking_Id')
                        component.set('v.Booking_Id',result[i][fieldName]);
                    if(result[i].DeveloperName=='Booking_Name')
                        component.set('v.Booking_Name',result[i][fieldName]);
                    if(result[i].DeveloperName=='Book_Service')
                        component.set('v.Book_Service',result[i][fieldName]);
                    if(result[i].DeveloperName=='Booking_Status')
                        component.set('v.Booking_Status',result[i][fieldName]);
                    if(result[i].DeveloperName=='Booking_Police_Inspection_separately')
                        component.set('v.Booking_Police_Inspection_separately',result[i][fieldName]);
                    if(result[i].DeveloperName=='Back')
                        component.set('v.Back',result[i][fieldName]);
                    if(result[i].DeveloperName=='Booking_wont_Reschedule_Message')
                        component.set('v.Booking_wont_Reschedule_Message',result[i][fieldName]);
                    if(result[i].DeveloperName=='Booking_wont_Reschedule_Full_Amount')
                        component.set('v.Booking_wont_Reschedule_Full_Amount',result[i][fieldName]);
                    if(result[i].DeveloperName=='Cancel')
                        component.set('v.Cancel',result[i][fieldName]);
                    if(result[i].DeveloperName=='Card_Details')
                        component.set('v.Card_Details',result[i][fieldName]);
                    if(result[i].DeveloperName=='Case_Created_Message')
                        component.set('v.Case_Created_Message',result[i][fieldName]);
                    if(result[i].DeveloperName=='Cancel_Booking_Message')
                        component.set('v.Cancel_Booking_Message',result[i][fieldName]);
                    if(result[i].DeveloperName=='Case_Type')
                        component.set('v.Case_Type',result[i][fieldName]);
                    if(result[i].DeveloperName=='Change_service_centers')
                        component.set('v.Change_service_centers',result[i][fieldName]);
                    if(result[i].DeveloperName=='Chassis_No')
                        component.set('v.Chassis_No',result[i][fieldName]);
                    if(result[i].DeveloperName=='CHASSIS_NO_PLATE_DETAILS')
                        component.set('v.CHASSIS_NO_PLATE_DETAILS',result[i][fieldName]);
                    if(result[i].DeveloperName=='Click_Here')
                        component.set('v.Click_Here',result[i][fieldName]);
                    if(result[i].DeveloperName=='Click_on_proceed_to_continue')
                        component.set('v.Click_on_proceed_to_continue',result[i][fieldName]);
                    if(result[i].DeveloperName=='Close')
                        component.set('v.Close',result[i][fieldName]);
                    if(result[i].DeveloperName=='Clone')
                        component.set('v.Clone',result[i][fieldName]);
                    if(result[i].DeveloperName=='Close_Popup_Message')
                        component.set('v.Close_Popup_Message',result[i][fieldName]);
                    if(result[i].DeveloperName=='Comments')
                        component.set('v.Comments',result[i][fieldName]);
                    if(result[i].DeveloperName=='Confirm_Next')
                        component.set('v.Confirm_Next',result[i][fieldName]);
                    if(result[i].DeveloperName=='Custom')
                        component.set('v.Custom',result[i][fieldName]);
                    if(result[i].DeveloperName=='Customer_Premises')
                        component.set('v.Customer_Premises',result[i][fieldName]);
                    if(result[i].DeveloperName=='Decline')
                        component.set('v.Decline',result[i][fieldName]);
                    if(result[i].DeveloperName=='Delete')
                        component.set('v.Delete',result[i][fieldName]);
                    if(result[i].DeveloperName=='Delete_Vehicle')
                        component.set('v.Delete_Vehicle',result[i][fieldName]);
                    if(result[i].DeveloperName=='Description')
                        component.set('v.Description',result[i][fieldName]);
                    if(result[i].DeveloperName=='Details_Updated_Successfully')
                        component.set('v.Details_Updated_Successfully',result[i][fieldName]);
                    if(result[i].DeveloperName=='Download')
                        component.set('v.Download',result[i][fieldName]);
                    if(result[i].DeveloperName=='Download_the_template')
                        component.set('v.Download_the_template',result[i][fieldName]);
                    if(result[i].DeveloperName=='Due_for_Retest')
                        component.set('v.Due_for_Retest',result[i][fieldName]);
                    if(result[i].DeveloperName=='Due_To_Test')
                        component.set('v.Due_To_Test',result[i][fieldName]);
                    if(result[i].DeveloperName=='Edit')
                        component.set('v.Edit',result[i][fieldName]);
                    if(result[i].DeveloperName=='Email_Id')
                        component.set('v.Email_Id',result[i][fieldName]);
                    /*if(result[i].DeveloperName=='End_Date')
                        component.set('v.End_Date',result[i][fieldName]);*/
                    if(result[i].DeveloperName=='Enter_only_numbers')
                        component.set('v.Enter_only_numbers',result[i][fieldName]);
                    if(result[i].DeveloperName=='Enter_Valid_Chassis_No')
                        component.set('v.Enter_Valid_Chassis_No',result[i][fieldName]);
                    if(result[i].DeveloperName=='Enter_Valid_Plate_Combination')
                        component.set('v.Enter_Valid_Plate_Combination',result[i][fieldName]);
                    if(result[i].DeveloperName=='Enter_Valid_Year')
                        component.set('v.Enter_Valid_Year',result[i][fieldName]);
                    if(result[i].DeveloperName=='Error')
                        component.set('v.Error',result[i][fieldName]);
                    if(result[i].DeveloperName=='Equipment_Location')
                        component.set('v.Equipment_Location',result[i][fieldName]);
                    if(result[i].DeveloperName=='ET_POLICIES')
                        component.set('v.ET_POLICIES',result[i][fieldName]);
                    if(result[i].DeveloperName=='Feedback_Form')
                        component.set('v.Feedback_Form',result[i][fieldName]);
                    if(result[i].DeveloperName=='Fields_Mandatory_Message')
                        component.set('v.Fields_Mandatory_Message',result[i][fieldName]);
                    if(result[i].DeveloperName=='Field_is_required')
                        component.set('v.Field_is_required',result[i][fieldName]);
                    if(result[i].DeveloperName=='Fill_Required_Details')
                        component.set('v.Fill_Required_Details',result[i][fieldName]);
                    if(result[i].DeveloperName=='First')
                        component.set('v.First',result[i][fieldName]);
                    if(result[i].DeveloperName=='Fix_All_Errors')
                        component.set('v.Fix_All_Errors',result[i][fieldName]);
                    if(result[i].DeveloperName=='Getting_Vehicle_Details')
                        component.set('v.Getting_Vehicle_Details',result[i][fieldName]);
                    if(result[i].DeveloperName=='History')
                        component.set('v.History',result[i][fieldName]);
                    if(result[i].DeveloperName=='Home_Office_Premise')
                        component.set('v.Home_Office_Premise',result[i][fieldName]);
                    if(result[i].DeveloperName=='Info')
                        component.set('v.Info',result[i][fieldName]);
                    if(result[i].DeveloperName=='Inspection_Center')
                        component.set('v.Inspection_Center',result[i][fieldName]);
                    if(result[i].DeveloperName=='Inspection_Centers')
                        component.set('v.Inspection_Centers',result[i][fieldName]);
                    if(result[i].DeveloperName=='Inspection_Premises')
                        component.set('v.Inspection_Premises',result[i][fieldName]);
                    if(result[i].DeveloperName=='Inspection_Result')
                        component.set('v.Inspection_Result',result[i][fieldName]);
                    if(result[i].DeveloperName=='Inspection_Service_availability')
                        component.set('v.Inspection_Service_availability',result[i][fieldName]);
                    if(result[i].DeveloperName=='Invoice')
                        component.set('v.Invoice',result[i][fieldName]);
                    if(result[i].DeveloperName=='Invoice_Sent_to_Email')
                        component.set('v.Invoice_Sent_to_Email',result[i][fieldName]);
                    if(result[i].DeveloperName=='Last')
                        component.set('v.Last',result[i][fieldName]);
                    if(result[i].DeveloperName=='Location')
                        component.set('v.Location',result[i][fieldName]);
                    if(result[i].DeveloperName=='Locations_Not_Available')
                        component.set('v.Locations_Not_Available',result[i][fieldName]);
                    if(result[i].DeveloperName=='Log_out')
                        component.set('v.Log_out',result[i][fieldName]);
                    if(result[i].DeveloperName=='Mobile_No')
                        component.set('v.Mobile_No',result[i][fieldName]);
                    if(result[i].DeveloperName=='Mobile_Number_12')
                        component.set('v.Mobile_Number_12',result[i][fieldName]);
                    if(result[i].DeveloperName=='Mobile_Number_should_be_12_digits')
                        component.set('v.Mobile_Number_should_be_12_digits',result[i][fieldName]);
                    if(result[i].DeveloperName=='Mobile_Number_should_numeric')
                        component.set('v.Mobile_Number_should_numeric',result[i][fieldName]);
                    if(result[i].DeveloperName=='Mobile_Number_should_start_with_971')
                        component.set('v.Mobile_Number_should_start_with_971',result[i][fieldName]);
                    if(result[i].DeveloperName=='Model')
                        component.set('v.Model',result[i][fieldName]);
                    if(result[i].DeveloperName=='Model_Year')
                        component.set('v.Model_Year',result[i][fieldName]);
                    if(result[i].DeveloperName=='My_Cases')
                        component.set('v.My_Cases',result[i][fieldName]);
                    if(result[i].DeveloperName=='My_Cart')
                        component.set('v.My_Cart',result[i][fieldName]);
                    if(result[i].DeveloperName=='Need_to_refill_details')
                        component.set('v.Need_to_refill_details',result[i][fieldName]);
                    if(result[i].DeveloperName=='New_Booking')
                        component.set('v.New_Booking',result[i][fieldName]);
                    if(result[i].DeveloperName=='New_Color')
                        component.set('v.New_Color',result[i][fieldName]);
                    if(result[i].DeveloperName=='New_Vehicle_Type')
                        component.set('v.New_Vehicle_Type',result[i][fieldName]);
                    if(result[i].DeveloperName=='None')
                        component.set('v.None',result[i][fieldName]);
                    if(result[i].DeveloperName=='Note')
                        component.set('v.Note',result[i][fieldName]);
                    if(result[i].DeveloperName=='No_Notifications_Message')
                        component.set('v.No_Notifications_Message',result[i][fieldName]);
                    if(result[i].DeveloperName=='No_Records_to_Display_with_Search')
                        component.set('v.No_Records_to_Display_with_Search',result[i][fieldName]);
                    if(result[i].DeveloperName=='No_Records_Message')
                        component.set('v.No_Records_Message',result[i][fieldName]);
                    if(result[i].DeveloperName=='Not_allowed_to_book_less_than_10')
                        component.set('v.Not_allowed_to_book_less_than_10',result[i][fieldName]);
                    if(result[i].DeveloperName=='Notifications')
                        component.set('v.Notifications',result[i][fieldName]);
                    if(result[i].DeveloperName=='Ocean_Island')
                        component.set('v.Ocean_Island',result[i][fieldName]);
                    if(result[i].DeveloperName=='Ok')
                        component.set('v.Ok',result[i][fieldName]);
                    if(result[i].DeveloperName=='of')
                        component.set('v.of',result[i][fieldName]);
                    if(result[i].DeveloperName=='Page')
                        component.set('v.Page',result[i][fieldName]);
                    if(result[i].DeveloperName=='Pay_by_Card')
                        component.set('v.Pay_by_Card',result[i][fieldName]);
                    if(result[i].DeveloperName=='Pay_Now')
                        component.set('v.Pay_Now',result[i][fieldName]);
                    if(result[i].DeveloperName=='Pay_at_our_office')
                        component.set('v.Pay_at_our_office',result[i][fieldName]);
                    if(result[i].DeveloperName=='Payment_at_Premises')
                        component.set('v.Payment_at_Premises',result[i][fieldName]);
                    if(result[i].DeveloperName=='PAYMENT_DETAILS')
                        component.set('v.PAYMENT_DETAILS',result[i][fieldName]);
                    if(result[i].DeveloperName=='Payment_History')
                        component.set('v.Payment_History',result[i][fieldName]);
                    if(result[i].DeveloperName=='Payment_Mode')
                        component.set('v.Payment_Mode',result[i][fieldName]);
                    if(result[i].DeveloperName=='Payment_Status')
                        component.set('v.Payment_Status',result[i][fieldName]);
                    if(result[i].DeveloperName=='Payment_Type')
                        component.set('v.Payment_Type',result[i][fieldName]);
                    if(result[i].DeveloperName=='Pending_Bookings')
                        component.set('v.Pending_Bookings',result[i][fieldName]);
                    if(result[i].DeveloperName=='Pending_or_Inspection_Completed')
                        component.set('v.Pending_or_Inspection_Completed',result[i][fieldName]);
                    if(result[i].DeveloperName=='Pending_or_Inspection_Completed1')
                        component.set('v.Pending_or_Inspection_Completed1',result[i][fieldName]);
                    if(result[i].DeveloperName=='Plate_Color')
                        component.set('v.Plate_Color',result[i][fieldName]);
                    if(result[i].DeveloperName=='Plate_Combination')
                        component.set('v.Plate_Combination',result[i][fieldName]);
                    if(result[i].DeveloperName=='Plate_Combinations_Values')
                        component.set('v.Plate_Combinations_Values',result[i][fieldName]);
                    if(result[i].DeveloperName=='Plate_Details')
                        component.set('v.Plate_Details',result[i][fieldName]);
                    if(result[i].DeveloperName=='Plate_No')
                        component.set('v.Plate_No',result[i][fieldName]);
                    if(result[i].DeveloperName=='Plate_No_should_be_5_numbers')
                        component.set('v.Plate_No_should_be_5_numbers',result[i][fieldName]);
                    if(result[i].DeveloperName=='Place_of_Service')
                        component.set('v.Place_of_Service',result[i][fieldName]);
                    if(result[i].DeveloperName=='Plate_Source')
                        component.set('v.Plate_Source',result[i][fieldName]);
                    if(result[i].DeveloperName=='Plate_Type')
                        component.set('v.Plate_Type',result[i][fieldName]);
                    if(result[i].DeveloperName=='Preferred_Language')
                        component.set('v.Preferred_Language',result[i][fieldName]);
                    if(result[i].DeveloperName=='Priority')
                        component.set('v.Priority',result[i][fieldName]);
                    if(result[i].DeveloperName=='Problem_Available_Slots')
                        component.set('v.Problem_Available_Slots',result[i][fieldName]);
                    if(result[i].DeveloperName=='Problem_booked_slots')
                        component.set('v.Problem_booked_slots',result[i][fieldName]);
                    if(result[i].DeveloperName=='Problem_Getting_Location')
                        component.set('v.Problem_Getting_Location',result[i][fieldName]);
                    if(result[i].DeveloperName=='Problem_Getting_Service_Types')
                        component.set('v.Problem_Getting_Service_Types',result[i][fieldName]);
                    if(result[i].DeveloperName=='Problem_Vehicle_Types')
                        component.set('v.Problem_Vehicle_Types',result[i][fieldName]);
                    if(result[i].DeveloperName=='Problem_ADFCA_Types')
                        component.set('v.Problem_ADFCA_Types',result[i][fieldName]);
                    if(result[i].DeveloperName=='Problem_Registration_Types')
                        component.set('v.Problem_Registration_Types',result[i][fieldName]);
                    if(result[i].DeveloperName=='Proceed')
                        component.set('v.Proceed',result[i][fieldName]);
                    if(result[i].DeveloperName=='Profile')
                        component.set('v.Profile',result[i][fieldName]);
                    if(result[i].DeveloperName=='Profile')
                        component.set('v.Profile',result[i][fieldName]);
                    if(result[i].DeveloperName=='Provide_Equipment_and_Inspection_Center')
                        component.set('v.Provide_Equipment_and_Inspection_Center',result[i][fieldName]);
                    if(result[i].DeveloperName=='Provide_Inspection_Center')
                        component.set('v.Provide_Inspection_Center',result[i][fieldName]);
                    if(result[i].DeveloperName=='Provide_Location_MobileNo_Service_Type')
                        component.set('v.Provide_Location_MobileNo_Service_Type',result[i][fieldName]);
                    if(result[i].DeveloperName=='Provide_Mobile_No')
                        component.set('v.Provide_Mobile_No',result[i][fieldName]);
                    if(result[i].DeveloperName=='Provide_the_Equipment_Location')
                        component.set('v.Provide_the_Equipment_Location',result[i][fieldName]);
                    if(result[i].DeveloperName=='Purpose_Type')
                        component.set('v.Purpose_Type',result[i][fieldName]);
                    if(result[i].DeveloperName=='Record_Created_Message')
                        component.set('v.Record_Created_Message',result[i][fieldName]);
                    if(result[i].DeveloperName=='Record_Saved_Successfully')
                        component.set('v.Record_Saved_Successfully',result[i][fieldName]);
                    if(result[i].DeveloperName=='Record_Updated_Message')
                        component.set('v.Record_Updated_Message',result[i][fieldName]);
                    if(result[i].DeveloperName=='Refunded_full_Amount_Message')
                        component.set('v.Refunded_full_Amount_Message',result[i][fieldName]);
                    if(result[i].DeveloperName=='Reg_Expiry_Date')
                        component.set('v.Reg_Expiry_Date',result[i][fieldName]);
                    if(result[i].DeveloperName=='Registration_Expiry_Date')
                        component.set('v.Registration_Expiry_Date',result[i][fieldName]);
                    if(result[i].DeveloperName=='Registration_Type')
                        component.set('v.Registration_Type',result[i][fieldName]);
                    if(result[i].DeveloperName=='Registered')
                        component.set('v.Registered',result[i][fieldName]);
                    if(result[i].DeveloperName=='Request_completed_Message')
                        component.set('v.Request_completed_Message',result[i][fieldName]);
                    if(result[i].DeveloperName=='Request_For_Service')
                        component.set('v.Request_For_Service',result[i][fieldName]);
                    if(result[i].DeveloperName=='Required_Details')
                        component.set('v.Required_Details',result[i][fieldName]);
                    if(result[i].DeveloperName=='Required_Documents')
                        component.set('v.Required_Documents',result[i][fieldName]);
                    if(result[i].DeveloperName=='Remove')
                        component.set('v.Remove',result[i][fieldName]);
                    if(result[i].DeveloperName=='Reschedule')
                        component.set('v.Reschedule',result[i][fieldName]);
                    if(result[i].DeveloperName=='Reschedule_Booking')
                        component.set('v.Reschedule_Booking',result[i][fieldName]);
                    if(result[i].DeveloperName=='S_No')
                        component.set('v.S_No',result[i][fieldName]);
                    if(result[i].DeveloperName=='Save')
                        component.set('v.Save',result[i][fieldName]);
                    if(result[i].DeveloperName=='Save_Next')
                        component.set('v.Save_Next',result[i][fieldName]);
                    if(result[i].DeveloperName=='Search')
                        component.set('v.Search',result[i][fieldName]);
                    if(result[i].DeveloperName=='Search_for_location')
                        component.set('v.Search_for_location',result[i][fieldName]);
                    if(result[i].DeveloperName=='Select')
                        component.set('v.Select',result[i][fieldName]);
                    if(result[i].DeveloperName=='Select_Current_Page_Vehicles')
                        component.set('v.Select_Current_Page_Vehicles',result[i][fieldName]);
                    if(result[i].DeveloperName=='Select_a_Location')
                        component.set('v.Select_a_Location',result[i][fieldName]);
                    if(result[i].DeveloperName=='Select_a_Service_Type')
                        component.set('v.Select_a_Service_Type',result[i][fieldName]);
                    if(result[i].DeveloperName=='Select_a_Value')
                        component.set('v.Select_a_Value',result[i][fieldName]);
                    if(result[i].DeveloperName=='Select_Language')
                        component.set('v.Select_Language',result[i][fieldName]);
                    if(result[i].DeveloperName=='Select_atleast_one_Vehicle')
                        component.set('v.Select_atleast_one_Vehicle',result[i][fieldName]);
                    if(result[i].DeveloperName=='Select_Location_and_Mobile_No')
                        component.set('v.Select_Location_and_Mobile_No',result[i][fieldName]);
                    if(result[i].DeveloperName=='Select_Location_and_Service_Type')
                        component.set('v.Select_Location_and_Service_Type',result[i][fieldName]);
                    if(result[i].DeveloperName=='Select_Permit_Type')
                        component.set('v.Select_Permit_Type',result[i][fieldName]);
                    if(result[i].DeveloperName=='Select_Preferred_Time')
                        component.set('v.Select_Preferred_Time',result[i][fieldName]);
                     if(result[i].DeveloperName=='MNVR_Serial_Number')
                        component.set('v.MNVR_Serial_Number',result[i][fieldName]);
                     if(result[i].DeveloperName=='MNVR_Brand')
                        component.set('v.MNVR_Brand',result[i][fieldName]);
                     if(result[i].DeveloperName=='MNVR_Brand_Other')
                        component.set('v.MNVR_Brand_Other',result[i][fieldName]);
                    if(result[i].DeveloperName=='Select_Service')
                        component.set('v.Select_Service',result[i][fieldName]);
                    if(result[i].DeveloperName=='Select_Service_Type')
                        component.set('v.Select_Service_Type',result[i][fieldName]);
                    if(result[i].DeveloperName=='Select_Services')
                        component.set('v.Select_Services',result[i][fieldName]);
                    if(result[i].DeveloperName=='Selected_Slot_Booked')
                        component.set('v.Selected_Slot_Booked',result[i][fieldName]);
                    if(result[i].DeveloperName=='Service')
                        component.set('v.Service',result[i][fieldName]);
                    if(result[i].DeveloperName=='Service_availability')
                        component.set('v.Service_availability',result[i][fieldName]);
                    if(result[i].DeveloperName=='Inspection_Plates_suspended')
                        component.set('v.Inspection_Plates_suspended',result[i][fieldName]);
                    if(result[i].DeveloperName=='Service_availability_Sharjah')
                        component.set('v.Service_availability_Sharjah',result[i][fieldName]);
                    if(result[i].DeveloperName=='Service_Name')
                        component.set('v.Service_Name',result[i][fieldName]);
                    if(result[i].DeveloperName=='Service_No')
                        component.set('v.Service_No',result[i][fieldName]);
                    if(result[i].DeveloperName=='Service_Not_Available')
                        component.set('v.Service_Not_Available',result[i][fieldName]);
                    if(result[i].DeveloperName=='Services_shown_by_location')
                        component.set('v.Services_shown_by_location',result[i][fieldName]);
                    if(result[i].DeveloperName=='Service_Type')
                        component.set('v.Service_Type',result[i][fieldName]);
                    if(result[i].DeveloperName=='Slots_Availability')
                        component.set('v.Slots_Availability',result[i][fieldName]);
                    /*if(result[i].DeveloperName=='Start_Date')
                        component.set('v.Start_Date',result[i][fieldName]);*/
                    if(result[i].DeveloperName=='Start_Date_less_than_End_Date')
                        component.set('v.Start_Date_less_than_End_Date',result[i][fieldName]);
                    if(result[i].DeveloperName=='Status')
                        component.set('v.Status',result[i][fieldName]);
                    if(result[i].DeveloperName=='Submit')
                        component.set('v.Submit',result[i][fieldName]);
                    if(result[i].DeveloperName=='SubTotal_AED')
                        component.set('v.SubTotal_AED',result[i][fieldName]);
                    if(result[i].DeveloperName=='Success')
                        component.set('v.Success',result[i][fieldName]);
                    if(result[i].DeveloperName=='Support')
                        component.set('v.Support',result[i][fieldName]);
                    if(result[i].DeveloperName=='Test_Result')
                        component.set('v.Test_Result',result[i][fieldName]);
                    if(result[i].DeveloperName=='To_book_go_to_Home_Page')
                        component.set('v.To_book_go_to_Home_Page',result[i][fieldName]);
                    if(result[i].DeveloperName=='Thanks_for_your_business')
                        component.set('v.Thanks_for_your_business',result[i][fieldName]);
                    if(result[i].DeveloperName=='Trade_License_Date_should_be_future')
                        component.set('v.Trade_License_Date_should_be_future',result[i][fieldName]);
                    if(result[i].DeveloperName=='Trade_License_Expiry_Date')
                        component.set('v.Trade_License_Expiry_Date',result[i][fieldName]);
                    if(result[i].DeveloperName=='Trade_License_Number')
                        component.set('v.Trade_License_Number',result[i][fieldName]);
                    if(result[i].DeveloperName=='Traffic_Fines')
                        component.set('v.Traffic_Fines',result[i][fieldName]);
                    if(result[i].DeveloperName=='Transfer_Certificate_Number')
                        component.set('v.Transfer_Certificate_Number',result[i][fieldName]);
                    if(result[i].DeveloperName=='Transaction_Date')
                        component.set('v.Transaction_Date',result[i][fieldName]);
                    if(result[i].DeveloperName=='Transaction_Id')
                        component.set('v.Transaction_Id',result[i][fieldName]);
                    if(result[i].DeveloperName=='Transport_policies_and_regulations')
                        component.set('v.Transport_policies_and_regulations',result[i][fieldName]);
                    if(result[i].DeveloperName=='Type')
                        component.set('v.Type',result[i][fieldName]);
                    if(result[i].DeveloperName=='Update')
                        component.set('v.Update',result[i][fieldName]);
                    if(result[i].DeveloperName=='Use_Template_to_Upload_Vehicles')
                        component.set('v.Use_Template_to_Upload_Vehicles',result[i][fieldName]);
                    if(result[i].DeveloperName=='Un_Registered')
                        component.set('v.Un_Registered',result[i][fieldName]);
                    if(result[i].DeveloperName=='Unable_to_Complete_Message')
                        component.set('v.Unable_to_Complete_Message',result[i][fieldName]);
                    if(result[i].DeveloperName=='Unexpected_Error_Message')
                        component.set('v.Unexpected_Error_Message',result[i][fieldName]);
                    if(result[i].DeveloperName=='Upcoming_Service')
                        component.set('v.Upcoming_Service',result[i][fieldName]);
                    if(result[i].DeveloperName=='Upload_all_Required_Documents')
                        component.set('v.Upload_all_Required_Documents',result[i][fieldName]);
                    if(result[i].DeveloperName=='Upload_Bulk_Vehicles')
                        component.set('v.Upload_Bulk_Vehicles',result[i][fieldName]);
                    if(result[i].DeveloperName=='Upload_File')
                        component.set('v.Upload_File',result[i][fieldName]);
                    if(result[i].DeveloperName=='Valid_Email_Address')
                        component.set('v.Valid_Email_Address',result[i][fieldName]);
                    if(result[i].DeveloperName=='Validate_Trade_License_Number')
                        component.set('v.Validate_Trade_License_Number',result[i][fieldName]);
                    if(result[i].DeveloperName=='Vehicle')
                        component.set('v.Vehicle',result[i][fieldName]);
                    if(result[i].DeveloperName=='Vehicle_already_exist')
                        component.set('v.Vehicle_already_exist',result[i][fieldName]);
                    if(result[i].DeveloperName=='Vehicle_already_exist_System')
                        component.set('v.Vehicle_already_exist_System',result[i][fieldName]);
                    if(result[i].DeveloperName=='Vehicle_Deleted_Message')
                        component.set('v.Vehicle_Deleted_Message',result[i][fieldName]);
                    if(result[i].DeveloperName=='Vehicle_Inspection')
                        component.set('v.Vehicle_Inspection',result[i][fieldName]);
                    if(result[i].DeveloperName=='Vehicle_Make')
                        component.set('v.Vehicle_Make',result[i][fieldName]);
                    if(result[i].DeveloperName=='Vehicle_Model')
                        component.set('v.Vehicle_Model',result[i][fieldName]);
                    if(result[i].DeveloperName=='Vehicle_Name')
                        component.set('v.Vehicle_Name',result[i][fieldName]);
                    if(result[i].DeveloperName=='Vehicle_Number')
                        component.set('v.Vehicle_Number',result[i][fieldName]);
                    if(result[i].DeveloperName=='Vehicle_Type')
                        component.set('v.Vehicle_Type',result[i][fieldName]);
                    if(result[i].DeveloperName=='Visit_ET_Premises')
                        component.set('v.Visit_ET_Premises',result[i][fieldName]);
                    if(result[i].DeveloperName=='We_accept_Cheque_or_Credit')
                        component.set('v.We_accept_Cheque_or_Credit',result[i][fieldName]);
                    if(result[i].DeveloperName=='Year')
                        component.set('v.Year',result[i][fieldName]);
                    if(result[i].DeveloperName=='Year_should_be_4_numbers')
                        component.set('v.Year_should_be_4_numbers',result[i][fieldName]);
                    if(result[i].DeveloperName=='Year_4_digits_and_not_future')
                        component.set('v.Year_4_digits_and_not_future',result[i][fieldName]);
                    if(result[i].DeveloperName=='You_cannot_Request_Service_Message')
                        component.set('v.You_cannot_Request_Service_Message',result[i][fieldName]);
                }
                component.set("v.IsSpinner", false);
            }else{
                var msg=component.get("v.Unexpected_Error_Message"); 
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
            }
        });
        $A.enqueueAction(action);
	}
})