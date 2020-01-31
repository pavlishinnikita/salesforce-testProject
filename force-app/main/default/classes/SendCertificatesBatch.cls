public with sharing class SendCertificatesBatch implements Database.Batchable<sObject> {
    private List<Participant__c> participants;

    public SendCertificatesBatch(List<Participant__c> participants) {
        this.participants = participants;
    }

    public List<Participant__c> start(Database.BatchableContext bc) {
        System.debug(this.participants);
        return this.participants;
    }

    public void execute(Database.BatchableContext bc, List<Participant__c> ps) {
        List<Messaging.SingleEmailMessage> mails = MailHelper.sendCertificates(ps);
        System.debug(ps);
        Messaging.sendEmail(mails);
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('SEND CERTIFICATES STATUS: OK');
    }
}
