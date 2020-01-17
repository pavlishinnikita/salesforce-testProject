public class MailHelper {
    public static void sendInvites(List<Participant__c> participants) {
        EmailTemplate et = [SELECT id FROM EmailTemplate WHERE developerName = 'Invite_to_training' LIMIT 1];
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<Id> contacts = new List<Id>();
        List<Id> participantIds = new List<Id>();
        for(Participant__c p : participants) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        	mail.saveAsActivity = true;
        	mail.setTemplateId(et.id);
        	mail.setTargetObjectId(p.Contact_Name__c);
        	mail.setWhatId(p.id);
        	mail.setSenderDisplayName('Trainer');
            mails.add(mail);
        }
        Messaging.sendEmail(mails);
    }
    /*
    public static void sendParticipantsList(List<Training__c> trainings) {
        EmailTemplate et = [SELECT id FROM EmailTemplate WHERE developerName = 'Participant_List' LIMIT 1];
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(Training__c t : trainings) {
        	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        	mail.saveAsActivity = true;
           	mail.setTemplateId(et.id);
        	mail.setTargetObjectId(t.Trainer__c);
           	//mail.setWhatId(t.id);
            mail.setSenderDisplayName('Training event');
            PageReference pr = Page.ParticipantsList;
            pr.getParameters().put('trainingId', t.id);
            try {
				Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                attachment.setFileName('participants.pdf');
            	attachment.setContentType('application/pdf');
				//attachment.setFileName('participant list');
				attachment.setBody(pr.getContent());
                mail.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment});
            } catch(VisualforceException e) {
                // handle error
            }
            mails.add(mail);
        }
        Messaging.sendEmail(mails);
    } */
    
    public static List<Messaging.SingleEmailMessage> sendParticipantsList(List<Training__c> trainings) {
        EmailTemplate et = [SELECT id FROM EmailTemplate WHERE developerName = 'Participant_List' LIMIT 1];
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(Training__c t : trainings) {
        	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        	mail.saveAsActivity = true;
           	mail.setTemplateId(et.id);
        	mail.setTargetObjectId(t.Trainer__c);
           	//mail.setWhatId(t.id);
            mail.setSenderDisplayName('Training event');
            PageReference pr = Page.ParticipantsList;
            pr.getParameters().put('trainingId', t.id);
            try {
				Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                attachment.setFileName('participants.pdf');
            	attachment.setContentType('application/pdf');
				//attachment.setFileName('participant list');
				attachment.setBody(pr.getContent());
                mail.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment});
            } catch(VisualforceException e) {
                // handle error
            }
            mails.add(mail);
        }
        return mails;
    }
}