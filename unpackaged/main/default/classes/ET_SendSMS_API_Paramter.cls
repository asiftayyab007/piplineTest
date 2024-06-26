//Generated by wsdl2apex

public class ET_SendSMS_API_Paramter {
    public class Input {
        public String Sender;
        public String MobileNo;
        public String Message;
        private String[] Sender_type_info = new String[]{'Sender','http://www.et.ae',null,'0','1','false'};
        private String[] MobileNo_type_info = new String[]{'MobileNo','http://www.et.ae',null,'0','1','false'};
        private String[] Message_type_info = new String[]{'Message','http://www.et.ae',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.et.ae','true','false'};
        private String[] field_order_type_info = new String[]{'Sender','MobileNo','Message'};
    }
    public class Control {
        public String ErrorMsg;
        public String SenderId;
        public String Username;
        public String Password;
        private String[] ErrorMsg_type_info = new String[]{'ErrorMsg','http://www.et.ae',null,'0','1','false'};
        private String[] SenderId_type_info = new String[]{'SenderId','http://www.et.ae',null,'0','1','false'};
        private String[] Username_type_info = new String[]{'Username','http://www.et.ae',null,'0','1','false'};
        private String[] Password_type_info = new String[]{'Password','http://www.et.ae',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.et.ae','true','false'};
        private String[] field_order_type_info = new String[]{'ErrorMsg','SenderId','Username','Password'};
    }
    public class Output {
        public String Status;
        public String Message;
        private String[] Status_type_info = new String[]{'Status','http://www.et.ae',null,'0','1','false'};
        private String[] Message_type_info = new String[]{'Message','http://www.et.ae',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.et.ae','true','false'};
        private String[] field_order_type_info = new String[]{'Status','Message'};
    }
}