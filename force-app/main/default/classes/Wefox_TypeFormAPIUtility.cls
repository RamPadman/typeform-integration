/*
@Company :  Wefox Group
@Purpose : Utility class to handle logic related totypeforms

***************************************** Modification Log *****************************************
Modified By          Modified on          
Ram Padmanabhan      7-04-2020          
*/
public class Wefox_TypeFormAPIUtility {
    //record to be inserted after all callouts
    WorkspaceWrapper workspaceWrapInst;
    FormsWrapper formWrapperInst;
    QuestionsWrapper qsntsWrapInst;
    ResponseWrapper respWrapInst;
    static HttpResponse response;
    static Type resultType;
    static Map<String,QuestionsWrapper> frmQstnsWrap = new Map<String,QuestionsWrapper>();
    //Map<String,String> dataTypeMap = new Map<String,String>({''})
    //insert workspaces - callout to get all the workspaces
    public static Map<String,WorkspaceWrapper.items> getWorkspaceDetails() {
        Map<String,WorkspaceWrapper.items> wrkspaceMap = new Map<String,WorkspaceWrapper.items>();
        response = HTTPUtility.get(Constants.NAMED_CREDS+Constants.wspaceEndpoint, null);
        resultType = Type.forName(Constants.WORKSPACE_WRAPPER);
        WorkspaceWrapper deserializeResults = (WorkspaceWrapper)JSON.deserialize(response.getBody(), resultType);
        //if(WorkspaceWrapper.items != null) {
        for(WorkspaceWrapper.items item:deserializeResults.items) {
            wrkspaceMap.put(item.id,item);
        }
        //get form details 
        //getFormsDetails(wrkspaceId);
        return wrkspaceMap;
    }
    //insert forms - callout to get all forms
    public static JSONFormResponseWrapper getFormsDetails(Set<String> wrkspaceIdSet) {
        //id to get list of questions
        Set<String> formIdSet = new Set<String>();
        JSONFormResponseWrapper jFormWrap = new JSONFormResponseWrapper();
        List<FormsWrapper.items> formList = new List<FormsWrapper.items>();
        Map<String,List<FormsWrapper.items>> wrkspaceFormWrap = new Map<String,List<FormsWrapper.items>>();
        FormsWrapper formWrapResults;
        for(String str:wrkspaceIdSet) {
            if(Limits.getCallouts() < Limits.getLimitCallouts()) {
                response = HTTPUtility.get(Constants.NAMED_CREDS+Constants.formEndpoint+str, null);
                resultType = Type.forName(Constants.FORMS_WRAPPER);
                formWrapResults = (FormsWrapper)JSON.deserialize(response.getBody(), resultType);
                formList.addAll(formWrapResults.items);
                wrkspaceFormWrap.put(str,formWrapResults.items);
            } 
        }
        jFormWrap.wrkspaceFormWrap = wrkspaceFormWrap;
        jFormWrap.allFormList = formList;
        return jFormWrap;
    }
    //insert responses - callout to get all responses
    public static List<String> getAllFormIdset(JSONFormResponseWrapper jFormWrap) {
        List<String> allFormIdList = new List<String>();
        for(FormsWrapper.items formInst: jFormWrap.allFormList) {
            allFormIdList.add(formInst.id);
        }
        return allFormIdList;
    }
    //parse response
    public static void parseResponse(JSONFormResponseWrapper jsonWrap) {
        //upsert workspacesId 
        Map<String,String> wrkspaceMap = createWorkspaces(jsonWrap.workspaceAPIMap);
        //upsert formDetails
        Map<String,String> formIdMap = createFormDetails(jsonWrap.wrkspaceFormWrap,wrkspaceMap);
        //upsert questions 
        Map<String,String> qstnMap = createQuestions(jsonWrap.frmQstnsWrap,formIdMap);
        //upsert responses
        createResponses(jsonWrap.respWrapper,qstnMap);
    }
    //create workspace logic
    static Map<String,String> createWorkspaces(Map<String,WorkspaceWrapper.items> wrkspaceMap) {
        List<Workspace__c> workspaceList = new List<Workspace__c>();
        Workspace__c wrkspaceInst;
        Set<Id> insertedWrkspaceId = new Set<Id>();
        Map<String,String> wrkspaceIdMap = new Map<String,String>();
        //parse and insert Workspaces
        if(!wrkspaceMap.isEmpty()) {
            for(String strIns:wrkspaceMap.keySet()) {
                wrkspaceInst = new Workspace__c();
                wrkspaceInst.Workspace_Id__c = strIns;
                wrkspaceInst.Name = wrkspaceMap.get(strIns).name;
                workspaceList.add(wrkspaceInst);
            }
            //make sure the workspace is not duplicate
            Database.UpsertResult[] srResult = Database.upsert(workspaceList, Workspace__c.Workspace_Id__c);
            if(!srResult.isEmpty()) {
                for(Database.UpsertResult srIns:srResult) {
                    if(srIns.isSuccess()){
                        insertedWrkspaceId.add(srIns.getId());                        
                    }
                }
            }
            //prepare map of result and externalID
            for(Workspace__c objIns:[SELECT Id,Workspace_Id__c from Workspace__c where Id IN:insertedWrkspaceId]){
                wrkspaceIdMap.put(objIns.Workspace_Id__c,objIns.Id);
            }
        } 
        return wrkspaceIdMap;
    }
    static Map<String,String> createFormDetails(Map<String,List<FormsWrapper.items>> wrkspaceMap,Map<String,String> wrkspaceId) {
        Map<String,String> formIdMap = new Map<String,String>();
        List<Form__c> formList = new List<Form__c>();
        Set<Id> formIdSet = new Set<Id>();
        Form__c formObj;
        //iterate and populate form objects
        for(String stObj:wrkspaceMap.keySet()) {
            for(FormsWrapper.items formInst:wrkspaceMap.get(stObj)) {
                formObj = new Form__c();
                formObj.Form_Id__c = formInst.id;
                formObj.Name = formInst.title;
                formObj.Workspace__c = wrkspaceId.get(stObj);
                formList.add(formObj);
            }
        }
        //if list is empty insert forms
        if(!formList.isEmpty()) {
            //make sure the workspace is not duplicate
            Database.UpsertResult[] srResult = Database.upsert(formList, Form__c.Form_Id__c);
            if(!srResult.isEmpty()) {
                for(Database.UpsertResult srIns:srResult) {
                    if(srIns.isSuccess()){
                        formIdSet.add(srIns.getId());                        
                    }
                }
            }
            for(Form__c frmInst:[SELECT Id,Form_Id__c from Form__c where Id IN:formIdSet]) {
                formIdMap.put(frmInst.Form_Id__c,frmInst.Id); 
            }
        }
        return formIdMap;
    }
    
    static Map<String,String> createQuestions(Map<String,QuestionsWrapper> qstnWrap,Map<String,String>formMap){
        List<Questions__c> qstnsList = new List<Questions__c>();
        Map<String,String> qIdMap = new Map<String,String>();
        Questions__c qstnInst;
        Set<Id> qstnIdSet = new Set<Id>();
        //create questions
        for(QuestionsWrapper qstWrap:qstnWrap.values()) {
            for(QuestionsWrapper.fields fldInst:qstWrap.fields){
                qstnInst = new Questions__c();
                qstnInst.Form__c = formMap.get(qstWrap.id);
                qstnInst.Question__c = fldInst.title;
                qstnInst.Question_Type__c = fldInst.type;
                qstnInst.Question_Id__c = fldInst.id;
                qstnsList.add(qstnInst);
            }
        }
        if(!qstnsList.isEmpty()) {
            Database.UpsertResult[] srResult = Database.upsert(qstnsList, Questions__c.Question_Id__c);
            if(!srResult.isEmpty()) {
                for(Database.UpsertResult srIns:srResult) {
                    if(srIns.isSuccess()){
                        qstnIdSet.add(srIns.getId());                        
                    }
                }
            }
            for(Questions__c qInst:[SELECT Id,Question_Id__c from Questions__c where Id IN:qstnIdSet]) {
                qIdMap.put(qInst.Question_Id__c,qInst.Id); 
            } 
        }
        return qIdMap;
    }
    
    static void createResponses(Map<String,List<ResponseWrapper.items>> respWrapper,Map<String,String> qstnMap) {
        //responseId and actual answers
        Map<String,List<ResponseWrapper.answers>> formAnswers = new Map<String,List<ResponseWrapper.answers>>();
        //responseId formIdMap
        Map<String,String> respFormMap = new Map<String,String>();
        List<Responses__c> respList = new List<Responses__c>();
        //tempAnswerMap
        Map<String,Object> tempAnsMap = new Map<String,Object>();
        Responses__c respInst;
        Map<String,Responses__c> respMap = new Map<String,Responses__c>();
        //email Set
        Set<String> emailAddrSet = new Set<String>();
        Map<String,String> formAccountMap = new Map<String,String>();
        Map<String,String> accEmailMap = new Map<String,String>();
        //Get accountid details unlinked accounts
        Account acctRec = [Select Id from Account where Name =:Constants.DEFAULT_ACCT LIMIT 1];
        //parse responses
        for(String strInst:respWrapper.keySet()) {
            //str insert
            for(ResponseWrapper.items resItems:respWrapper.get(strInst)) {
                formAnswers.put(resItems.response_id,resItems.answers);
                respFormMap.put(resItems.response_id,strInst);
            }
        }
        //parse answers
        for(String stIns:formAnswers.keySet()) {
            //get questions details from map
            for(ResponseWrapper.answers respAns:formAnswers.get(stIns)) {
                tempAnsMap =  (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(respAns));
                respInst = new Responses__c();
                respInst.ResponseId__c = stIns;
                respInst.Answer__c = String.valueOf(tempAnsMap.get(respAns.type));
                respInst.Questions__c = qstnMap.get(respAns.field.id);
                respInst.Answer_Type__c = respAns.type;
                //if email is empty link it to unlinked account
                if(respAns.type.equalsIgnoreCase(Constants.CONST_EMAIL)) {
                    //if answer is blank
                    if(String.isBlank(respInst.Answer__c)) {
                        respInst.Account__c = acctRec.Id; 
                        respList.add(respInst);
                    } else {
                        //even if the email has multiple values , it will still be matched with this logic
                        emailAddrSet.add(respInst.Answer__c);
                        respMap.put(respInst.Answer__c,respInst);
                    }
                    //if answer is email
                } else {
                    respList.add(respInst); 
                }
            }
        }
        //query account details
        if(!respMap.isEmpty()) {
            //need tohandle if there are duplicate accounts with same email address
            for(Account acct:[SELECT Id,Email__c from Account where Email__c IN:respMap.keySet()]) {
                accEmailMap.put(acct.Email__c,acct.Id);
            }
            //prepare final response insertion list
            for(String str:respMap.keySet()){
                if(accEmailMap.containsKey(str)) {
                    respMap.get(str).Account__c = accEmailMap.get(str);
                    formAccountMap.put(respMap.get(str).ResponseId__c,accEmailMap.get(str));
                } else {
                    respMap.get(str).Account__c = acctRec.Id;
                    formAccountMap.put(respMap.get(str).ResponseId__c,acctRec.Id);
                }
                respList.add(respMap.get(str));
            }
        }
        for(Responses__c respIn:respList) {
            if(formAccountMap.containsKey(respIn.ResponseId__c) && respIn.Answer_Type__c != 'email') {
                respIn.Account__c = formAccountMap.get(respIn.ResponseId__c);
            }
        }
        //finally, insert response list , should be updated to prevent duplicates
        if(!respList.isEmpty()) {
            insert respList;
        }
    }
}