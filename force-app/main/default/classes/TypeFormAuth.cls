global class TypeFormAuth extends Auth.AuthProviderPluginClass {

    public String clientId;
    public String clientSecret;
    public String accessTokenUrl;
    public String authorizationUrl;
    public String scope;
    public String redirectUri;
    public String httpBody;
    
    // This method is responsible for returning the custom metadata storing the api credentials and other details
    global String getCustomMetadataType() {
        return 'TypeForm_Details__mdt';
    }
    
     // This method is responsible to initiate the authorization code flow
    global PageReference initiate(Map<String, String> authProviderConfiguration, String stateToPropagate) {
        clientId = authProviderConfiguration.get('Consumer_Key__c');
        authorizationUrl = authProviderConfiguration.get('Authorization_URL__c');
        scope = authProviderConfiguration.get('Scope__c');
        redirectUri = authProviderConfiguration.get('Redirect_URI__c');
        String url = authorizationUrl + '?scope='+scope+'&client_id='+clientId+'&redirect_uri='+redirectUri+'&state='+stateToPropagate;
        return new PageReference(url);
    }
    
    /*   
      This method is responsible to handle the callback from authorization code flow
      set the access token, refresh token and other parameters
    */
    global Auth.AuthProviderTokenResponse handleCallback(Map<String, String> authProviderConfiguration, Auth.AuthProviderCallbackState state) {

       clientId = authProviderConfiguration.get('Consumer_Key__c');
       clientSecret = authProviderConfiguration.get('Consumer_Secret__c');
       scope = authProviderConfiguration.get('Scope__c');
       redirectUri = authProviderConfiguration.get('Redirect_URI__c');
       accessTokenUrl = authProviderConfiguration.get('Access_Token_URL__c');
       Map<String,String> queryParams = state.queryParameters;
       String code = queryParams.get('code');
       String sfdcState = queryParams.get('state');
       httpBody = 'grant_type=authorization_code&client_id='+clientId+'&client_secret='+clientSecret+'&code='+code+'&redirect_uri='+redirectUri;
       HTTPResponse res = HTTPUtility.post(accessTokenURL,new Map<String,String>{'Accept'=>'application/json'},httpBody);
       String responseBody = res.getBody();
       TypeFormResponse response = (TypeFormResponse) JSON.deserialize(responseBody, TypeFormResponse.class);
       System.debug('************'+response);
       return new Auth.AuthProviderTokenResponse('TypeFormAuth', response.access_token, response.refresh_token, sfdcState);
    }
    // This method is responsible to get the user information used for authentication from the external api
    global Auth.UserData getUserInfo(Map<String, String> authProviderConfiguration, Auth.AuthProviderTokenResponse response) {
        //to be replaced with *** admin url endpoint
         return new Auth.UserData(
        'Id',
        'FirstName',
        'LirstName',
        'FullName',
        null,
        null, 
        'Admin',
        'locale',
        'TypeForm',
        'loginURL',
        null
      );
    }
     // Wrapper class to handle Access Token API response
    public class TypeFormResponse {
      public String access_token;
      public String token_type;
      public String scope;
      public String expires_in;
      public String refresh_token;
    }

}