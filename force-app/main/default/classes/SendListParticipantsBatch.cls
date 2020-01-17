public class SendListParticipantsBatch implements Database.Batchable<sObject> {
    public List<Training__c> query; 
    private List<Messaging.SingleEmailMessage> mails;

    public List<Training__c> start(Database.BatchableContext bc) {
        return query;
    }

    public void execute(Database.BatchableContext bc, List<Training__c> trainings) {
        mails = MailHelper.sendParticipantsList(trainings);
    }

    public void finish(Database.BatchableContext bc) {
        // Messaging.sendEmail(mails);
    }
}