/* Author : Ram Padmanabhan
* Description: To ensure asset hierarchy is imported in a single step
* Abstract implementation to support the solution
*/
public abstract class CaseStudySolution implements SolutionSetupInterface {
    public virtual void createCSVFile() {
        //populate the externalId field in CSV
        //create and map child with Parents through externalId in the Asset's ParentId field
        System.debug('Creating CSV File');
    }
    public virtual void createExternalId() {
        //create an External Id field preferably text type in Asset object.
        System.debug('Creating ExternalId');
    }
    //the solution execution is different, hence determined by each solution
    public abstract void execute();
}