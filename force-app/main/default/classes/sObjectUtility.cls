public class sObjectUtility {
	
    public static void createRecords(List<sobject> objectList) {
        if(!objectList.isEmpty()) {
            Database.SaveResult[] dbRslt = Database.insert(objectList);
        }
    }
}