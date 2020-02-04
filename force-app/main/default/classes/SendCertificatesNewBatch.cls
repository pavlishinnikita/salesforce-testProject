public with sharing class SendCertificatesNewBatch {
    private List<Participant__c> trainings;

    public SendCertificatesNewBatch(List<Training__c> trainings) {
        this.trainings = trainings;
    }
    
    public List<Participant__c> start(Database.BatchableContext bc) {
        return this.trainings;
    }
    
    public void execute(Database.BatchableContext bc, List<Training__c> tr) {
        //List<Messaging.SingleEmailMessage> mails = MailHelper.sendCertificates(ps);
        //Messaging.sendEmail(mails);
        Set<Id> trIds = new Set<Id>();
        for(Training__c t : tr) {
            trIds.add(t.id);
        }
        List<Participant__c> participants = [SELECT id, Contact_Name__c, Contact_Name__r.FirstName, Contact_Name__r.LastName FROM Participant__c WHERE Training__c IN :trIds];
        
        List<ContentVersion> cvs = new List<ContentVersion>();
        
        for(Participant__c p: participants) {

            PageReference pr = Page.Certificate;
            pr.getParameters().put('participantId',  p.id);
            Blob body;
            try {
                body = pr.getContentAsPdf();
            } catch(VisualforceException e) {
                // handle error
                return 'Cannot generate PDF';
            }

            ContentVersion cvP = new ContentVersion();
            cvP.Title = 'Cerifcate_' + p.Contact_Name__r.FirstName + '_' + p.Contact_Name__r.LastName;
            cvP.PathOnClient = 'Certificate_' + p.Contact_Name__r.FirstName + '_' + p.Contact_Name__r.LastName + '.pdf';
            cvP.VersionData = body;
            cvP.FirstPublishLocationId = p.id;
            cvs.add(cvP);
        }
        upsert cvs;
    }
    
    public void finish(Database.BatchableContext bc) {
        
        EmailTemplate et = [SELECT Id, Name, Subject, Body, HtmlValue FROM EmailTemplate WHERE developerName = 'Participant_certificate' LIMIT 1];
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

		List<ContentVersion> generatedCertificates = new List<ContentVersion>();
		List<ContentVersion> certificates = [SELECT id, Title, PathOnClient, VersionData, FirstPublishLocationId FROM ContentVersion WHERE FirstPublishLocationId IN :participants.keySet()];
    }
}
