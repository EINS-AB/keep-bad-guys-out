global class ConnectedAppPolicyCondition implements TxnSecurity.PolicyCondition {
    
    public boolean evaluate(TxnSecurity.Event e) {
        system.debug(JSON.serialize(e));
        // if user is already 2FA do not trigger the policy
        if (e.data.get('SessionLevel').equals('HIGH_ASSURANCE')) {
            System.debug('session level is already HIGH_ASSURANCE, do not trigger the policy');
            return false;
        }
        // List of App that need 2FA 
        Set<String> appNames = new Set<String>{'Dataloader Bulk','Dataloader Partner'};
        // get the apps IDs to be able to compare with event's entity
        Map<Id,ConnectedApplication> theAppToBlock = new Map<Id,ConnectedApplication>([SELECT Id, Name FROM ConnectedApplication WHERE Name IN :appNames]);
        // check which app user tries to access
        if (theAppToBlock.containsKey(e.entityId)) {
            System.debug(theAppToBlock.get(e.entityId) + ' is running, trigger the policy');
            return true;
        }
        
        System.debug('app not to be block, do NOT trigger the policy');
        return false; 
    }
}