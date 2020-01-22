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
    public static Messaging.SingleEmailMessage clone(Messaging.SingleEmailMessage source) {
        Messaging.SingleEmailMessage dest = new Messaging.SingleEmailMessage();
        dest.saveAsActivity = source.saveAsActivity;
        dest.setTemplateId(source.getTemplateId());
        dest.setTargetObjectId(source.getTargetObjectId());
        dest.setSenderDisplayName(source.getSenderDisplayName());
        dest.setFileAttachments(source.getFileAttachments());
        return dest;
    }

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
				attachment.setBody(pr.getContent());
                mail.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment});
            } catch(VisualforceException e) {
                // handle error
            }

            Messaging.SingleEmailMessage mailToPlace = mail;
            mailToPlace.saveAsActivity = false;
            mailToPlace.setTargetObjectId(t.Location__c);
            mails.add(mailToPlace);
            
            if(t.Restaurant__c != null) {
                Messaging.SingleEmailMessage mailToRestaurant = mail;
                mailToRestaurant.saveAsActivity = false;
                mailToRestaurant.setTargetObjectId(t.Restaurant__c);
                mails.add(mailToRestaurant);
            }
            mails.add(mail);
        }
        return mails;
    }
}