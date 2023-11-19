@isTest
public class NPSApiServiceTest {

    @isTest
    static void testSendToNPS_Success() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NPSApiServiceMock(200, ''));
        NPSApiService.sendToNPS('123', 'test@example.com');
        Test.stopTest();
    }
    @isTest
    static void testSendToNPS_Fail() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NPSApiServiceMock(400, ''));
        NPSApiService.sendToNPS('123', 'testexample.com');
        Test.stopTest();
    }
}