/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-26-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class OpportuniytoLearner 
{
    public static void convertToLearner(List<DLOpportunity__c> opps) {
        List<DLLearner__c> learnersToInsert = new List<DLLearner__c>();
        
        for (DLOpportunity__c opp : opps) {
            if (opp.Opportunity_stage__c =='Closed won') {
                DLLearner__c learner = new DLLearner__c();
                learner.Name = opp.Name;
                //learner.Program__c = 'Training Program'; // Replace with your program name
               // learner.Opportunity__c = opp.Id;
                learnersToInsert.add(learner);
            }
        }
        
        if (!learnersToInsert.isEmpty()) {
            insert learnersToInsert;
        }
    }
}