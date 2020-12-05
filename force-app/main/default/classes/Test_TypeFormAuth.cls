@isTest
public class Test_TypeFormAuth {
private static final String OAUTH_TOKEN = 'testToken'; 
        private static final String STATE = 'mocktestState'; 
        private static final String REFRESH_TOKEN = 'refreshToken'; 
        private static final String LOGIN_ID = 'testLoginId'; 
        private static final String USERNAME = 'testUsername'; 
        private static final String FIRST_NAME = 'testFirstName'; 
        private static final String LAST_NAME = 'testLastName'; 
        private static final String EMAIL_ADDRESS = 'testEmailAddress'; 
        private static final String LOCALE_NAME = 'testLocalName'; 
        private static final String FULL_NAME = FIRST_NAME + ' ' + LAST_NAME; 
        private static final String PROVIDER = 'TypeForm'; 
        private static final String REDIRECT_URL = 
        'http://localhost/services/authcallback/orgId/TypeForm'; 
        private static final String KEY = 'testKey'; 
        private static final String SECRET = 'testSecret'; 
        private static final String STATE_TO_PROPOGATE = 'testState'; 
        private static final String ACCESS_TOKEN_URL = 
        'http://www.dummyhost.com/accessTokenUri'; 
        private static final String API_USER_VERSION_URL = 
        'http://www.dummyhost.com/user/20/1'; 
        private static final String AUTH_URL = 
        'http://www.dummy.com/authurl'; 
        private static final String API_USER_URL = 
        'www.typeform.com/user/api'; 
    
    // In the real world scenario, the key and value would be read 
    // from the (custom fields in) custom metadata type record. 
    private static Map<String,String> setupAuthProviderConfig () 
    { 
        Map<String,String> authProviderConfiguration = new Map<String,String>(); 
        authProviderConfiguration.put('Consumer_Key__c', KEY); 
        authProviderConfiguration.put('Authorization_URL__c', AUTH_URL); 
        authProviderConfiguration.put('Consumer_Secret__c', SECRET); 
        authProviderConfiguration.put('Access_Token_URL__c', ACCESS_TOKEN_URL); 
        authProviderConfiguration.put('API_User_Url__c',API_USER_URL); 
        authProviderConfiguration.put('Redirect_URI__c',REDIRECT_URL); 
        authProviderConfiguration.put('State_c',STATE); 
        return authProviderConfiguration; 
    
    } 
    
    static testMethod void testInitiateMethod() 
    { 
        String stateToPropogate = 'mocktestState'; 
        Map<String,String> authProviderConfiguration = setupAuthProviderConfig(); 
        TypeFormAuth typeFormCls = new TypeFormAuth(); 
        typeFormCls.redirectUri = authProviderConfiguration.get('Redirect_URI__c'); 
    PageReference expectedUrl = new PageReference(authProviderConfiguration.get('Authorization_URL__c') + '?client_id='+ 
    authProviderConfiguration.get('Consumer_Key__c') +'&scope=null&redirect_uri='+ 
    authProviderConfiguration.get('Redirect_URI__c') + '&state=' + 
    STATE_TO_PROPOGATE); 
        PageReference actualUrl = typeFormCls.initiate(authProviderConfiguration, STATE_TO_PROPOGATE); 
        //chec if value matches
        System.assertEquals(expectedUrl.getUrl(), actualUrl.getUrl());
    } 
    
    static testMethod void testHandleCallback() 
    { 
        Map<String,String> authProviderConfiguration = setupAuthProviderConfig(); 
        TypeFormAuth typeFormCls = new TypeFormAuth();  
        typeFormCls.redirectUri = authProviderConfiguration.get('Redirect_URI__c'); 
        Test.setMock(HttpCalloutMock.class, new TypeFormMockHttpResponseGenerator());
        Map<String,String> queryParams = new Map<String,String>(); 
        queryParams.put('code','code'); 
        queryParams.put('state',authProviderConfiguration.get('State_c')); 
        String body = 'grant_type=authorization_code&client_id='+authProviderConfiguration.get('Consumer_Key__c')+'&client_secret='+authProviderConfiguration.get('Consumer_Secret__c')+'&code=code&redirect_uri='+authProviderConfiguration.get('Redirect_URI__c');
        Auth.AuthProviderCallbackState cbState = 
        new Auth.AuthProviderCallbackState(new Map<String,String>{'Accept'=>'application/json'},body,queryParams); 
        System.debug('**************'+cbState);
        System.debug('**************authProviderConfiguration'+authProviderConfiguration);
        Auth.AuthProviderTokenResponse actualAuthProvResponse = typeFormCls.handleCallback(authProviderConfiguration, cbState); 
        Auth.AuthProviderTokenResponse expectedAuthProvResponse = new Auth.AuthProviderTokenResponse('TypeFormAuth', OAUTH_TOKEN, REFRESH_TOKEN, null);
        System.assertEquals(expectedAuthProvResponse.provider, actualAuthProvResponse.provider); 
         
    } 
     
    static testMethod void testGetUserInfo() 
    { 
        Map<String,String> authProviderConfiguration = 
        setupAuthProviderConfig(); 
        TypeFormAuth typeFormCls = new TypeFormAuth(); 
    
        Test.setMock(HttpCalloutMock.class, new 
        TypeFormMockHttpResponseGenerator()); 
    
        Auth.AuthProviderTokenResponse response = 
        new Auth.AuthProviderTokenResponse(
        PROVIDER, OAUTH_TOKEN ,'sampleOauthSecret', STATE); 
        Auth.UserData actualUserData = typeFormCls.getUserInfo(
        authProviderConfiguration, response) ; 
    
        Map<String,String> provMap = new Map<String,String>(); 
        provMap.put('key1', 'value1'); 
        provMap.put('key2', 'value2'); 
    
        Auth.UserData expectedUserData = new Auth.UserData(LOGIN_ID, 
        FIRST_NAME, LAST_NAME, FULL_NAME, EMAIL_ADDRESS, 
        null, LOCALE_NAME, null, PROVIDER, null, provMap); 
    
        System.assertNotEquals(expectedUserData,null); 
    } 
    
    
    // Implement a mock http response generator for typeform
    public class TypeFormMockHttpResponseGenerator implements HttpCalloutMock 
    { 
        public HTTPResponse respond(HTTPRequest req) 
        { 
            String namespace = API_USER_VERSION_URL; 
            String prefix = 'mockPrefix'; 
            String strBody = '{}';
            // Create a fake response 
            HttpResponse res = new HttpResponse(); 
            res.setHeader('Content-Type', 'application/xml'); 
            res.setBody(strBody); 
            res.setStatusCode(200); 
            return res; 
        } 
    } 
}