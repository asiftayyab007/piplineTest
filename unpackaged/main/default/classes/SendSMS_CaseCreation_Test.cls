@isTest
public class SendSMS_CaseCreation_Test {
    private static testmethod void sendSMS(){
        Case le = new Case();
        le.Subject = 'test';
        le.ownerid=userinfo.getUserId();
        insert le;
        Opportunity op= new opportunity();
        op.name='Test';
        op.StageName='TEST';
        op.CloseDate=system.today()+30;
        insert op;
            
        test.starttest();
        
        Test.setMock(HttpCalloutMock.class, new Moto_SMS_MockHttpResponseGenerator());
        SendSMS_CaseCreation.sendSMStoCaseOwner(new list<id>{le.Id});
        SendSMS_OpportunityCreation.sendSMStoOpportunityOwner(new list<id>{op.Id});
        Test.stoptest();
    }

}