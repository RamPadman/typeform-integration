/*
@Company :  Wefox Group
@Purpose : Handle UI for LWC components

***************************************** Modification Log *****************************************
Modified By          Modified on          
Ram Padmanabhan      7-04-2020          
*/
public class AccountSearchController {
    
    @AuraEnabled
    public static Map<String,List<QuestionAnswer>> getAccountResponseDetails(String accountId) {
        Map<String,List<QuestionAnswer>> respMap = new Map<String,List<QuestionAnswer>>();
        QuestionAnswer questAns;
        if(String.isNotBlank(accountId)) {
            accountId = accountId.substring(0, 18);
            //getAccount details, query from responses
            for(Responses__c respInst:[SELECT Id,Account__c,Answer__c,Answer_Type__c,Questions__r.Question__c,ResponseId__c from Responses__c where Account__c =:accountId]) {
                questAns = new QuestionAnswer();
                if(!respMap.containsKey(respInst.ResponseId__c)) {
                    questAns.questions = respInst.Questions__r.Question__c;
                    questAns.answers = respInst.Answer__c;
                    respMap.put(respInst.ResponseId__c,new List<QuestionAnswer>{questAns});
                } else {
                    questAns.questions = respInst.Questions__r.Question__c;
                    questAns.answers = respInst.Answer__c;
                    respMap.get(respInst.ResponseId__c).add(questAns);
                }
            }
        }
        return respMap;
    }
    @AuraEnabled
    public static List<Account> getAccountList(String accName) {
        List<Account> accList = new List<Account>();
        String queryTerm = '%'+accName+'%';
        for(Account accIns:[SELECT Id,Name from Account where Name LIKE:queryTerm])  {
            accList.add(accIns);
        }
        return accList; 
    }
    public class QuestionAnswer {
        @AuraEnabled
        public String questions;
        @AuraEnabled
        public String answers;
    }
    
    public class ResultWrapper {
        @AuraEnabled
        public Map<String,List<QuestionAnswer>> respAnsWrapper;
        @AuraEnabled
        public String formId;
    }
}