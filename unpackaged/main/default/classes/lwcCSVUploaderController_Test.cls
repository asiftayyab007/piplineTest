@isTest
public class lwcCSVUploaderController_Test {

	//@isTest
    static testMethod void method1() {


        String str = JSON.serialize('Name,Site,Account Source\nGoogle,https://google.com,Web');        
        lwcCSVUploaderController.saveFile(str);
        
    }
}