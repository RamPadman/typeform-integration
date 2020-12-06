/*
@Company :  
@Purpose : Batch to be process typeforms insertion

***************************************** Modification Log *****************************************
Modified By          Modified on          
Ram Padmanabhan      7-04-2020          
*/
global class TypeFormAPIBatch implements Database.Batchable<String>,Database.Stateful,Database.AllowsCallouts  {
	Map<String,WorkspaceWrapper.items> workspaceAPIMap = new Map<String,WorkspaceWrapper.items>();
	JSONFormResponseWrapper jsonTotalWrapper = new JSONFormResponseWrapper();
    Map<String,QuestionsWrapper> frmQstnsWrap = new Map<String,QuestionsWrapper>();
    Map<String,List<ResponseWrapper.items>> respWrapper = new Map<String,List<ResponseWrapper.items>>();
    
    global Iterable<String> start(Database.BatchableContext info){
        JSONFormResponseWrapper jFormWrapper = new JSONFormResponseWrapper();
        List<String> formList = new List<String>();
        try{
        //get workspace and form details and pass the form Id for iteration in execute method
        jsonTotalWrapper.workspaceAPIMap = TypeFormAPIUtility.getWorkspaceDetails();
        //get form details for each workspace
        jFormWrapper = TypeFormAPIUtility.getFormsDetails(jsonTotalWrapper.workspaceAPIMap.keySet());
        jsonTotalWrapper.wrkspaceFormWrap = jFormWrapper.wrkspaceFormWrap;
        //iterate scope using formlist
        formList.addAll(TypeFormAPIUtility.getAllFormIdset(jFormWrapper));
        } catch(Exception ex) {
            //insert exceptions into custom log object
            //logic to follow
            System.debug('Catch Exception'+ex.getMessage());
        }
        return formList;
    }
    global void execute(Database.BatchableContext info, List<String> scope){
        HttpResponse response;
        Type resultType;
        QuestionsWrapper qstnResults;
        ResponseWrapper respWrap;
        String replacedBody;
        try{
        for(String formId:scope) {
            if(String.isNotBlank(formId)) {
            response = HTTPUtility.get(Constants.NAMED_CREDS+Constants.questEndpoint+formId, null);  
            resultType = Type.forName(cONSTANTS.QUESTION_WRAPPER);
            qstnResults = (QuestionsWrapper)JSON.deserialize(response.getBody(), resultType);
            frmQstnsWrap.put(formId, qstnResults);
            //get form responses
            resultType = Type.forName(Constants.RESPONSE_WRAPPER);
            response = HTTPUtility.get(Constants.NAMED_CREDS+Constants.questEndpoint+formId+Constants.ENDPOINT_RESP, null);
            replacedBody = response.getBody().replace(Constants.BOOL_KEY,Constants.BOOL_KEY_REP).replace(Constants.NUM_KEY,Constants.NUM_KEY_REP); 
            respWrap = (ResponseWrapper)JSON.deserialize(replacedBody, resultType);
            respWrapper.put(formId, respWrap.items);
            }
        }
        jsonTotalWrapper.frmQstnsWrap = frmQstnsWrap;
        jsonTotalWrapper.respWrapper = respWrapper;
        } catch(Exception ex) {
            //insert exceptions into custom log object
            //logic to follow
            System.debug('Catch Exception'+ex.getMessage());
        }
    }
    global void finish(Database.BatchableContext info){
        //response parsing 
        try{
        TypeFormAPIUtility.parseResponse(jsonTotalWrapper);
        } catch(Exception ex) {
            //insert exceptions into custom log object
            //logic to follow
            System.debug('Catch Exception');
        }
    }
    
    
    
}