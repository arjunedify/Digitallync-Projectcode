/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-26-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger ConvertOpportunityToColdLead on DLOpportunity__c (before insert) 
{
    List<DLOpportunity__c> coldLeadsToUpdate = new List<DLOpportunity__c>();
    List<DLOpportunity__c> coldLeadsToInsert = new List<DLOpportunity__c>();
    for (DLOpportunity__c opp : Trigger.new) 
    {
        if (opp.Opportunity_stage__c == 'Cold Lead' && opp.Opportunity_stage__c != Trigger.oldMap.get(opp.Id).Opportunity_stage__c) {
            // Create a new Opportunity record with the Cold Leads record type
            DLOpportunity__c coldLead = new DLOpportunity__c();
            coldLeadsToInsert.add(coldLead);
            // Update the original Opportunity with the new Cold Leads record type
            //opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Cold Leads').getRecordTypeId();
            coldLeadsToUpdate.add(opp);
        }
    }
    
    if (!coldLeadsToInsert.isEmpty()) {
        insert coldLeadsToInsert;
    }
    
    if (!coldLeadsToUpdate.isEmpty()) {
        update coldLeadsToUpdate;
    }
}