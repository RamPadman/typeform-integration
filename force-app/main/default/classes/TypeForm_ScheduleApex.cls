/*
@Company :  
@Purpose : Batch to be invoked from Schedule apex for inserting typeforms

***************************************** Modification Log *****************************************
Modified By          Modified on          
Ram Padmanabhan      7-04-2020          
*/
global class TypeForm_ScheduleApex implements Schedulable {
   global void execute(SchedulableContext sc) {
      TypeFormAPIBatch batchInst = new TypeFormAPIBatch(); 
      database.executebatch(batchInst,Constants.BTCH_SIZE);
   } 
}