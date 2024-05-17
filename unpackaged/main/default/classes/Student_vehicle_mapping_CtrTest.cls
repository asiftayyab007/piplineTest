@isTest
public class Student_vehicle_mapping_CtrTest {
    
    @isTest 
    Public static void Studentvehmethod(){
        List<Student_Vehicle_Mapping__c> mapList = New List<Student_Vehicle_Mapping__c>();
        
        ETST_School__c objschool= new ETST_School__c();
        objschool.Name ='Al Shohub School' ;
        insert objschool;
        
        Student_Vehicle_Mapping__c objmapveh = new Student_Vehicle_Mapping__c();
        objmapveh.School__c= 'a1Q8E000002xsQJUAY';
        objmapveh.Student__c= 'a1R8E000002Q12oUAC';
        objmapveh.ET_Vehicle_Master__c= 'a3e8E000000R28QQAS';
        mapList.add(objmapveh);
        Test.startTest();
        Student_vehicle_mapping_Ctr.SavestudentList(mapList); 
        Test.stopTest();
    }

}