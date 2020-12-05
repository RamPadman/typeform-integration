public class Asset_Hierar_Batch {
    
    public void processBatch() {
        //Assuming we have all the records inserted and parent records to be mapped
        //create a map of existing parentIds and salesforceIds where the update needs to happen
        //where some flag is set to true
        Map<String,String> externalIdMap =  new Map<String,String>();
        List<Asset> assetList = new List<Asset>();
        for(Asset assObj:[SELECT Id,ExternalId__c,ParentExt__c,ParentId from Asset WHERE ParentExt__c != null]) {
            externalIdMap.put(assObj.ExternalId__c,assObj.Id);
            assetList.add(assObj);
        }
        for(Asset assInst:assetList) {
            assInst.ParentId = externalIdMap.get(assInst.ParentExt__c);
        }
        update assetList;
    }

}