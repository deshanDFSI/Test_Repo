@isTest
public class ApplicationLog_Test {
    public static void setLoggingSettings(){
        insert new LMT_System_Settings__c(
            Name='Test',LMT_Debug__c=true,LMT_Error__c=true,LMT_Info__c=true,LMT_Warning__c=true
        );
    }
    @isTest
    static void testSingleLog(){
        setLoggingSettings();
        TestException te;
        try{
            throw new TestException();
        }catch(TestException t){
            te=t;
        }

        ApplicationLogUtility.logMessage('Debug',
                                            'ApplicationLog_Test',
                                            'testSingleLog',
                                            'test log message',
                                            'test payload',
                                            te,
                                            1.0.longValue(),
                                            'CUSTOM_TEST_EXCEPTION',
                                            'abcdefghijklmnopqr',
                                            'reference info');
        ApplicationLog__c alog=[SELECT Age__c,DebugLevel__c,Id,IntegrationPayload__c,LogCode__c,Message__c,Name,OwnerId,ReferenceId__c,ReferenceInfo__c,SourceFunction__c,Source__c,StackTrace__c,Timer__c FROM ApplicationLog__c];
        system.assert(alog!=null);
    }

    @isTest
    static void testSingleLogMandatoryFieldMissing(){
        setLoggingSettings();
        TestException te;
        try{
            throw new TestException();
        }catch(TestException t){
            te=t;
        }
        try{
            ApplicationLogUtility.logMessage('Debug',
                                                null,
                                                null,
                                                'test log message',
                                                'test payload',
                                                te,
                                                1.0.longValue(),
                                                'CUSTOM_TEST_EXCEPTION',
                                                'abcdefghijklmnopqr',
                                                'reference info');
        }
        catch(DMLException dml){

            system.assertEquals(dml.getDmlType(0),StatusCode.REQUIRED_FIELD_MISSING);
        }

    }
    @isTest
    static void testBatchLog(){
        setLoggingSettings();
        TestException te;
        try{
            throw new TestException();
        }catch(TestException t){
            te=t;
        }
        List<ApplicationLogMessage> messages =new List<ApplicationLogMessage>();

        for(integer count=0; count<100;count++){
            ApplicationLogMessage message= new ApplicationLogMessage();
            message.source='ApplicationLog_Test';
            message.sourceFunction='testBatchLog';
            message.referenceId='abcdefghijklmnopqr';
            message.referenceInfo=''+count;
            message.logMessage='test log message';
            message.payLoad='test payload';
            message.ex=te;
            message.debugLevel='Debug';
            message.logCode='CUSTOM_TEST_EXCEPTION';
            message.timer=1.0.longValue();
            messages.add(message);
        }
        ApplicationLogUtility.logMessage(messages);
        List<ApplicationLog__c> alogs=[SELECT Age__c,DebugLevel__c,Id,IntegrationPayload__c,LogCode__c,Message__c,Name,OwnerId,ReferenceId__c,ReferenceInfo__c,SourceFunction__c,Source__c,StackTrace__c,Timer__c FROM ApplicationLog__c];
        system.assertEquals(100,alogs.size());
    }
    
    @isTest
    static void testBatchLog1(){
        setLoggingSettings();
        TestException te;
        try{
            throw new TestException();
        }catch(TestException t){
            te=t;
        }
        List<ApplicationLogMessage> messages =new List<ApplicationLogMessage>();

        for(integer count=0; count<100;count++){
            ApplicationLogMessage message= new ApplicationLogMessage(
            'ApplicationLog_Test',
            'testBatchLog',
            'test log message',
            'Debug');
            messages.add(message);
        }
        ApplicationLogUtility.logMessage(messages);
        List<ApplicationLog__c> alogs=[SELECT Age__c,DebugLevel__c,Id,IntegrationPayload__c,LogCode__c,Message__c,Name,OwnerId,ReferenceId__c,ReferenceInfo__c,SourceFunction__c,Source__c,StackTrace__c,Timer__c FROM ApplicationLog__c];
        system.assertEquals(100,alogs.size());
    }
    
    public class TestException extends Exception {}
}