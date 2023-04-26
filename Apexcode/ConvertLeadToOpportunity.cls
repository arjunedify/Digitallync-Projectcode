/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-26-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class ConvertLeadToOpportunity 
{
    public static void convertLeadToOpportunity(List<Lead> leads)
    {
        List<Opportunity> oppsToInsert = new List<Opportunity>();
        for (Lead lead : leads) 
        {
            if (lead.IsConverted == false) 
            {
                Opportunity opp = new Opportunity();
                opp.Name = lead.Company;
                opp.CloseDate = Date.today();
                opp.StageName = 'Prospecting';
                opp.LeadSource = lead.LeadSource;
                opp.Amount = lead.AnnualRevenue;
                opp.Description = lead.Description;
                oppsToInsert.add(opp);
            }
        }
        
        if (!oppsToInsert.isEmpty()) 
        {
            insert oppsToInsert;
        }
    }
}