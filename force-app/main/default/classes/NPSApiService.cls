public class NPSApiService {
    private static final Integer TIMEOUT = 10000;
	
    @future(callout=true)
    public static void sendToNPS(String orderNumber, String emailAddress) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://salesforce-coding-challenge.herokuapp.com/orders');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf('tmondo:Noy84LRpYvMZuETB')));
        req.setTimeout(TIMEOUT);

        String requestBody = '[{"sfId": "' + orderNumber + '", "orderNumber": "' + orderNumber + '", "customerEmail": "' + emailAddress + '"}]';
        req.setBody(requestBody);

        Http http = new Http();
        HttpResponse res;

        try {
            res = http.send(req);
            handleHttpResponse(res);
        } catch (Exception ex) {
            // Handle exceptions
            logError('Error occurred while sending data to NPS API: ' + ex.getMessage());
            throw new NPSIntegrationException('Error sending data to NPS API');
        }
    }

    private static void handleHttpResponse(HttpResponse res) {
        if (res.getStatusCode() != 200) {
            logError('NPS API Error - Status Code: ' + res.getStatusCode() + ', Body: ' + res.getBody());
            throw new NPSIntegrationException('Error from NPS API');
        }
    }

    private static void logError(String errorMessage) {
        System.debug(errorMessage);
    }
}