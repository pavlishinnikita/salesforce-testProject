public class ParticipantController {
    public List < Participant__c > getParticipants() {
        String trainingId = ApexPages.currentPage().getParameters().get('trainingId');
        System.debug(trainingId);
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
}