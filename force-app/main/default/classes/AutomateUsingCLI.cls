/* Author : Ram Padmanabhan
* Description: To ensure asset hierarchy is imported in a single step
*/
public class AutomateUsingCLI extends CaseStudySolution { 
    public override void createExternalId() {
        super.createExternalId();
        //Update existing asset records with ExternalId 
        //If necessary, we can turn off the automation process for the below updates
    }
    public override void createCSVFile() {
        //no additional mapping needed
        super.createCSVFile(); 
    }
    public void executeAction() {
        try{
        //Assuming the user will use Windows OS
        //Install Data loader and other pre-requisites
        //Create a mapping(.sdl) and process config file for insert and upsert operation
        //Create a windows batch file to invoke insert and upsert process configured earlier
        //Process Manager prepares file and put it in the destined folder with both parent and child mappings
        //Execute the batch file from command prompt
        //Once the operation is done, success and error files will be stored in a seperate folder
        } catch(Exception ex) {
            //since this is an additional update operation, triggers to be modified to bypass this operation
            //Also, validation rules and other automations , if any to be bypassed for the particular user
        }
    }
    public override void execute() {
        createExternalId();
        createCSVFile();
        executeAction();
    }
}