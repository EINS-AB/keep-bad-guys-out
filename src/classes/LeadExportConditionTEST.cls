@isTest(isParallel=true)
public class LeadExportConditionTEST {

    public static final Integer MAX_ROWS = 200;
    public static final Integer MAX_EXECUTION_TIME = 1000;
    
    @isTest
    public static void overRowLimitPolicyFired() {
        LeadExportCondition exportCondition = new LeadExportCondition();
        // check that policy is fired
        System.assertEquals(true, exportCondition.evaluate(prepareTestEvent(MAX_ROWS+1, MAX_EXECUTION_TIME-1, 'Lead')));
    }

    @isTest
    public static void overTimeLimitPolicyFired() {
        LeadExportCondition exportCondition = new LeadExportCondition();
        // check that policy is fired
        System.assertEquals(true, exportCondition.evaluate(prepareTestEvent(MAX_ROWS-1, MAX_EXECUTION_TIME+1, 'Lead')));
    }
    
    @isTest
    public static void underLimitPolicyNOTFired() {
        LeadExportCondition exportCondition = new LeadExportCondition();
        // check that policy is fired
        System.assertEquals(false, exportCondition.evaluate(prepareTestEvent(MAX_ROWS-1, MAX_EXECUTION_TIME-1, 'Lead')));
    }
    
	// support method to create Event for testing transaction security policy condition    
    private static TxnSecurity.Event prepareTestEvent(Integer nbrOrRecords, Integer execTime, String resourceType) {
        /* We’re not going to cause a real event in the org.
			Instead, we’re going to create a Transaction Security
			event object and “feed” it to the Policy Engine. */
        Map<String, String> eventData = new Map<String, String>();
        eventData.put('NumberOfRecords', String.valueOf(nbrOrRecords));
        eventData.put('ExecutionTime', String.valueOf(execTime));
        eventData.put('EntityName', resourceType);
        eventData.put('URI', 'testing');
        
        TxnSecurity.Event e = new TxnSecurity.Event(
            UserInfo.getOrganizationId(), /* organizationId */
            UserInfo.getUserId(), /* userId */
            null, /* entityName */
            'DataExport', /* action */
            resourceType, /* resourceType */
            null, /* entityId */
            Datetime.newInstance(2018, 3, 20), /* timeStamp */
            eventData ); /* data - Map with info about this event. */
        /* The only info in the map is the Number of Records. */  
        return e;
    }
    
}