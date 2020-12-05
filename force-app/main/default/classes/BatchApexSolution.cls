/* Author : Ram Padmanabhan
* Description: To ensure asset hierarchy is imported in a single step
*/
public class BatchApexSolution extends CaseStudySolution {
    public override void createExternalId() {
        //Update existing asset records with ExternalId 
        //If necessary, we can turn off the automation process for the below updates
        super.createExternalId();
        createAdditionalField();
    }
    public void createAdditionalField() {
        //Apart from ExternalId, Let's create two more fields, a Boolean and text
        //Boolean - set to true to indicate data loaded in the csv as part of the batch
        //Text - custom ParentId field which holds the ExternalId mapping of parent
    }
    public override void createCSVFile() {
        //no additional mapping needed
        super.createCSVFile();
        //create additional mapping, to set the boolean value and parentId mapping
    }
    public void executeAction() {
        try {
            //Insert the prepared csv using one of the accessible tools
            //If the data is not critical, we can schedule a batch to run daily to set the relationship. If not,
            //After success, navigate back to Assets List view in Salesforce
            //Click on Set Relationship button to invoke the batch Apex for setting the relationship
            //Once the process is done, manager is notified with details
        } catch(Exception ex) {
            //If the user clicks again, he will be displayed a warning message that process is already running 
            //Care will be taken to purge settings records on quarterly or monthly basis
            //Error or success can be logged into a seperate object
        }
    }
    public override void execute() {
        createExternalId();
        createCSVFile();
        executeAction();
    }
}