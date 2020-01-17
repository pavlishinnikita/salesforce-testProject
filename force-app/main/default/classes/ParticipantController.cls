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
}