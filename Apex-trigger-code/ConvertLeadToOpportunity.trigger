/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-26-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger ConvertLeadToOpportunity on Lead (after insert) 
{
    List<Opportunity> opportunitiesToInsert = new List<Opportunity>();
    List<Task> tasksToInsert = new List<Task>();
    List<ContentDocumentLink> fileLinksToInsert = new List<ContentDocumentLink>();
    
    for (Lead lead : Trigger.new) {
        if (lead.IsConverted) {
            // Create a new Opportunity record with the Standard record type
            Opportunity opportunity = new Opportunity(
                Name = lead.Company,
                CloseDate = Date.today().addMonths(1),
                StageName = 'Prospecting',
                Amount = lead.AnnualRevenue,
                LeadSource = lead.LeadSource,
                Description = lead.Description
            );
            opportunitiesToInsert.add(opportunity);
            
            // Create a new Task for the Opportunity
            Task task = new Task(
                Subject = 'Follow up with ' + lead.FirstName + ' ' + lead.LastName,
                WhoId = opportunity.Id,
                Status = 'Not Started',
                Priority = 'Normal',
                ActivityDate = Date.today().addDays(7)
            );
            tasksToInsert.add(task);
            
            // Copy over any related Files from the Lead to the new Opportunity
            for (ContentDocumentLink link : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :lead.Id]) {
                ContentDocumentLink fileLink = new ContentDocumentLink(
                    ContentDocumentId = link.ContentDocumentId,
                    LinkedEntityId = opportunity.Id,
                    ShareType = 'V'
                );
                fileLinksToInsert.add(fileLink);
            }
        }
    }
    
    if (!opportunitiesToInsert.isEmpty()) {
        insert opportunitiesToInsert;
    }
    
    if (!tasksToInsert.isEmpty()) {
        insert tasksToInsert;
    }
    
    if (!fileLinksToInsert.isEmpty()) {
        insert fileLinksToInsert;
    }
}