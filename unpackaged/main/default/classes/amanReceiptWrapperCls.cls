/***
Class       : amanReceiptWrapperCls
Author      : Janardhan Muddana
Description : wrapper class
Main Class: amanReceiptPdfCtrl
TestClass  : 
----------------------------------------------------------------------------------------------------------------
            -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date                Details
1.          V1.0              05/05/23           Initial Version 
****************************************************************************************************************/
public class amanReceiptWrapperCls {
	public List<ReceiptDetails> ReceiptDetails;

	public class Vehicle_Details {
		public String Plate_No;
		public Location Plate_Color;
		public Location Plate_Type;
		public Location Vehicle_Make;
		public Location Vehicle_Model;
		public Location Vehicle_Type;
		public Location Vehicle_Color;
		public Location Country;
		public String Model_Year;
		public Object Body_Number;
		public String Chassis_No;
		public String Engine_No;
		public String Cylinders;
		public String Doors;
		public String Seats;
		public String Axles;
		public String Tires;
		public String Horsepower;
		public Location Weight_Unloaded;
		public Location Weight_Loaded;
		public Location Fuel_Type;
		public Location Gear_Type;
		public Location Steering_Type;
		public String KM_Reading;
	}

	public class ReceiptDetails {
		public Location Location;
		public String Receipt_No;
		public String Receipt_DateTime;
		public Location Lane_Type;
		public Location Test_Type;
		public Location Test_Purpose;
		public String Test_Count;
		public String Amount;
		public String Total_Amount;
		public Test_No_List Test_No_List;
		public Vehicle_Details Vehicle_Details;
	}

	public class Test_No_List {
		public List<String> Test_No;
	}

	public class Location {
		public String EN;
		public String AR;
	}

	
	public static amanReceiptWrapperCls parse(String json) {
		return (amanReceiptWrapperCls) System.JSON.deserialize(json, amanReceiptWrapperCls.class);
	}
}