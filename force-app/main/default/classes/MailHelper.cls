public class MailHelper {
	public static void sendInvites(List<Participant__c> participants) {
		EmailTemplate et = [SELECT id FROM EmailTemplate WHERE developerName = 'Invite_to_training' LIMIT 1];
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		List<Id> contacts = new List<Id>();
		List<Id> participantIds = new List<Id>();
		for(Participant__c p :participants) {
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

	public static List<Messaging.SingleEmailMessage> sendParticipantsList(List<Training__c> trainings) {
		EmailTemplate et = [SELECT id FROM EmailTemplate WHERE developerName = 'Participant_List' LIMIT 1];
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		for(Training__c t :trainings) {
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
				mail.setFileAttachments(new Messaging.EmailFileAttachment [] { 
									    attachment});
			} catch(VisualforceException e) {
				// handle error
			}

			Messaging.SingleEmailMessage mailToPlace = mail;
			mailToPlace.saveAsActivity = true;
			mailToPlace.setToAddresses(new List<String>{t.Location__r.Email__c});
			mails.add(mailToPlace);

			if(t.Restaurant__c != null) {
				Messaging.SingleEmailMessage mailToRestaurant = mail;
				mailToRestaurant.saveAsActivity = true;
				mailToRestaurant.setToAddresses(new List<String>{t.Restaurant__r.Email__c});
				mails.add(mailToRestaurant);
			}
			mails.add(mail);
		}
		return mails;
	}

	public static List<Messaging.SingleEmailMessage> sendSurveyInvites(List<Participant__c> participants) {
		EmailTemplate et = [SELECT Id, Name, Subject, Body, HtmlValue FROM EmailTemplate WHERE developerName = 'SurveyTemplate' LIMIT 1];
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		for(Participant__c p :participants) {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setTemplateId(et.id);
			mail.setTargetObjectId(p.Contact_Name__c);
			mail.setWhatId(p.id);
			mail.setSenderDisplayName('Survey');
			mails.add(mail);
		}
        return mails;
	}

	public static List<Messaging.SingleEmailMessage> sendCertificates(List<Participant__c> participants) {
		EmailTemplate et = [SELECT Id, Name, Subject, Body, HtmlValue FROM EmailTemplate WHERE developerName = 'Participant_certificate' LIMIT 1];
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		for(Participant__c p : participants) {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.saveAsActivity = true;
			mail.setTemplateId(et.id);
			mail.setTargetObjectId(p.Contact_Name__c);
			mail.setSenderDisplayName('Certificate');
			////////////////////////
			PageReference pr = Page.Certificate;
            pr.getParameters().put('participantId',  p.id);
            try {
				Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
				attachment.setFileName('certificate.pdf');
				attachment.setContentType('application/pdf');
				attachment.setBody(pr.getContent());
				mail.setFileAttachments(new Messaging.EmailFileAttachment [] {attachment});
            } catch(VisualforceException e) {
                // handle error or send message to admin
            }
			mails.add(mail);
		}
		return mails;
	}
}