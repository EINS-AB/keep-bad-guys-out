global class BlockAccessFromNKPolicyCondition implements TxnSecurity.PolicyCondition {
  public boolean evaluate(TxnSecurity.Event e) {
    //system.debug(JSON.serialize(e));
    // Get the login history.
    LoginHistory loginAttempt =
      [SELECT LoginGeoId FROM LoginHistory WHERE Id = :e.data.get('LoginHistoryId')];
    // Get the login's geographical info.
    String loginGeoId = String.valueOf(loginAttempt.LoginGeoId);
    LoginGeo loginGeo = [SELECT Country FROM LoginGeo WHERE Id = :loginGeoId];
    // Get the country at that location.
    String country = String.valueOf(loginGeo.Country);
    system.debug('user "' + e.data.get('UserName') + '" is trying to login from: ' + country);
    // Trigger policy and block access for any user trying to log in from North Korea.
    if(country.equals('North Korea')) {
        return true;
    }
    return false;
  }
}