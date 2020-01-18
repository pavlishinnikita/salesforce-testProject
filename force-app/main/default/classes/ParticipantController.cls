public class ParticipantController {
    public List < Participant__c > getParticipants() {
        String trainingId = ApexPages.currentPage().getParameters().get('trainingId');
        List < Participant__c > participants;

        participants = [
            SELECT Contact_Name__r.FirstName, Contact_Name__r.LastName,
            Training__r.Start_Date__c, Training__r.End_Date__c,
            Training__r.Training_Course__r.Name,
            Training__r.Training_Course__r.Description__c,
            Training__r.Location__r.Billing_City__c,
            Training__r.CreatedById,
            Training__r.Trainer__r.FirstName,
            Training__r.Trainer__r.LastName
            FROM Participant__c WHERE Training__c =: trainingId
        ];
        System.debug(participants);
        return participants;
    }
    
    public Training__c getTraining() {
        String trainingId = ApexPages.currentPage().getParameters().get('trainingId');
        return [
            SELECT Start_Date__c, End_Date__c,
            Training_Course__r.Name,
            Training_Course__r.Description__c,
            Location__r.Billing_City__c,
            CreatedById,
            Trainer__r.FirstName,
            Trainer__r.LastName,
            Participants__c
            FROM Training__c WHERE id =: trainingId
            LIMIT 1
        ];
    }

    @AuraEnabled
    public static Integer getMaxParticipants(String oppId) {
        Opportunity o = [SELECT Training__r.Max_participants_quantity__c FROM Opportunity WHERE id = :oppId];
        return Integer.valueOf(o.Training__r.Max_participants_quantity__c);
    }

    @AuraEnabled
    public static void test(String oppId, List<String> contactsId) {
        Opportunity opp = [SELECT id, Training__c FROM Opportunity WHERE id = :oppId LIMIT 1];
        List<Participant__c> participants = new List<Participant__c>();
        for(String id : contactsId) {
            Participant__c p = new Participant__c();
            p.Contact_Name__c = id;
            p.Opportunity_Name__c = opp.id;
            p.Training__c = opp.Training__c;
            participants.add(p);
        }
        try {
            insert participants;
        } catch(DMLException e) {
            System.debug(e);
        }
        
    }

    // @AuraEnabled
    // public static void createParticipants(String trainingId, List<String> contactsId) {
    //     System.debug(contactsId);
    //     System.debug(trainingId);
    // }
}