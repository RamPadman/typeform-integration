@isTest
public class Test_TypeFormUtility {
    @testSetup
    static void createTestData(){
        Account acct = new Account(Name = 'unlinked answers');
        insert acct;
    }
    //positive usecase
    static testMethod void checkTypeFormAPI() {
        createTestData();
        Test.setMock(HttpCalloutMock.class, new MockHTTPRespGenerator());
        Test.startTest();
        TypeFormAPIBatch batchApex = new TypeFormAPIBatch();
        Database.executeBatch(batchApex);
        Test.stopTest();
        List<Workspace__c> wrkspcLst = [SELECT Id from Workspace__c];
        //ensure workspace is inserted
        System.assertEquals(1,wrkspcLst.size());
    }
	//negative usecase logic to follow
    static testMethod void checkScheduler() {
        createTestData();
        Test.setMock(HttpCalloutMock.class, new MockHTTPRespGenerator());
        Test.startTest();
        //peFormAPIBatch batchApex = new TypeFormAPIBatch();
        //abase.executeBatch(batchApex);
        TypeForm_ScheduleApex scheduleApx = new TypeForm_ScheduleApex();
		String sch = '0 0 * * * ?'; 
        system.schedule('TypeFormScheduler', sch, scheduleApx); 
        Test.stopTest();
    }
}