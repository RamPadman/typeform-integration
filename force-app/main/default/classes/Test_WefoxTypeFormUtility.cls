@isTest
public class Test_WefoxTypeFormUtility {
    @testSetup
    static void createTestData(){
        Account acct = new Account(Name = 'unlinked answers');
        insert acct;
    }
    //positive usecase
    static testMethod void checkTypeFormAPI() {
        createTestData();
        Test.setMock(HttpCalloutMock.class, new WeFoxMockHTTPRespGenerator());
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
        Test.setMock(HttpCalloutMock.class, new WeFoxMockHTTPRespGenerator());
        Test.startTest();
        //peFormAPIBatch batchApex = new TypeFormAPIBatch();
        //abase.executeBatch(batchApex);
        WeFox_ScheduleApex scheduleApx = new WeFox_ScheduleApex();
		String sch = '0 0 * * * ?'; 
        system.schedule('TypeFormScheduler', sch, scheduleApx); 
        Test.stopTest();
    }
}