public class viewpdf {
    public Attachment att {
        get {
            if (att == null) {
                att = [SELECT Body, ContentType, Name FROM Attachment WHERE ID = '00P8E00000Dm6SKUAZ'];
            }
            return att;
        }
        private set;
    }
    public String pdf { 
        get {
            return EncodingUtil.Base64Encode(att.body);
        }
    }
}