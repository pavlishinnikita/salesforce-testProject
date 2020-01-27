public class SendListParticipantsBatch implements Database.Batchable<sObject>, Database.Stateful {
    public List<Training__c> query; 

    public List<Training__c> start(Database.BatchableContext bc) {
        return query;
    }

    public void execute(Database.BatchableContext bc, List<Training__c> trainings) {
        List<Messaging.SingleEmailMessage> mails = MailHelper.sendParticipantsList(trainings);
        Messaging.sendEmail(mails);
    }

    public void finish(Database.BatchableContext bc) {
    }
}