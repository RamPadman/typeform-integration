public class HTTPUtility {
    public static final string REQUEST_TYPE_POST = 'POST';
    public static final string REQUEST_TYPE_GET  = 'GET';
    
    public static HttpResponse post(String endPoint, Map<String,String> requestHeaderMap, String body){
        return send(REQUEST_TYPE_POST, endPoint, requestHeaderMap, body);
    }
    public static HttpResponse get(String endPoint, Map<String,String> requestHeaderMap){
        return send(REQUEST_TYPE_GET, endPoint, requestHeaderMap, null);
    }
    
    public static HttpResponse send(String type, String endPoint, Map<String,String> requestHeaderMap, String body){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPoint);
        req.setMethod(type);
        
        if(requestHeaderMap != null){
            for(String key : requestHeaderMap.keySet()){
                req.setHeader(key,requestHeaderMap.get(key));
            }
        }
        if(String.isNotBlank(body)){
            req.setBody(body);
        }
        
        System.debug('Req '+body);
        // Create a new http object to send the request object
        // A response object is generated as a result of the request         
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        // System.debug('Res '+res.getBody());
        
        return res;
    }
}