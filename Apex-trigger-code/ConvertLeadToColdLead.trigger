/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-26-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger ConvertLeadToColdLead on Lead (after update) {
    List<Lead> leadsToUpdate = new List<Lead>();
    List<Opportunity> coldLeadsToInsert = new List<Opportunity>();

    for (Lead lead : Trigger.new) {
        if (lead.Status == 'Cold Lead' && lead.Status != Trigger.oldMap.get(lead.Id).Status) {
            Opportunity coldLead = new Opportunity(
                //RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Cold Leads').getRecordTypeId(),
                Name = lead.Company,
                LeadSource = lead.LeadSource,
                Description = lead.Description
            );
            coldLeadsToInsert.add(coldLead);
 
            //lead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Cold Leads').getRecordTypeId();
            leadsToUpdate.add(lead);
        }
        else if (lead.Status == 'Hot Lead' && lead.Status != Trigger.oldMap.get(lead.Id).Status) {
            
            Task followUpTask = new Task(
                Subject = 'Follow up with hot lead: ' + lead.Company,
                WhoId = lead.Id,
                Priority = 'High'
            );
            insert followUpTask;
        }
    }

    if (!coldLeadsToInsert.isEmpty()) {
        insert coldLeadsToInsert;
    }

    if (!leadsToUpdate.isEmpty()) {
        update leadsToUpdate;
    }
}