global class ProfanityFilterPolicyCondition implements TxnSecurity.PolicyCondition {
  public boolean evaluate(TxnSecurity.Event e) {
    String body = e.data.get('Body');

    //Create HTTPRequest and specify its type and properties.
    HttpRequest request = new HttpRequest();
    request.setMethod('GET');
    request.setHeader('content-type', 'text/plain');
    request.setHeader('Connection', 'keep-alive');
    request.setEndpoint('http://www.purgomalum.com/service/containsprofanity?text=' +
                        EncodingUtil.urlEncode(body,'UTF-8'));

    Http http = new Http();
    HTTPResponse response = http.send(request);

    if (response.getStatusCode() == 200 && response.getBody().equals('true')) {
      return true; // Callout succeeded and found profanity in the message.
    }
    return false;  // Callout failed or no profanity was found.
  }
}