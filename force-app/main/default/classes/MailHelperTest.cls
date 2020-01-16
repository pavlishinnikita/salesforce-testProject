public class MailHelperTest {
    public static void sendMessages(List<Participant__c> participants) {
        EmailTemplate et = [SELECT id FROM EmailTemplate WHERE developerName = 'Invite_to_training' LIMIT 1];
        //Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<Id> contacts = new List<Id>();
        List<Id> participantIds = new List<Id>();
        for(Participant__c p : participants) {
            //contacts.add(p.Contact_Name__c);
            //participantIds.add(p.id);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        	mail.saveAsActivity = TRUE;
        	mail.setTemplateId(et.id);
        	mail.setTargetObjectId(p.Contact_Name__c);
        	mail.setWhatId(p.id);
        	mail.setSenderDisplayName('Trainer');
            mails.add(mail);
        }
        //mail.saveAsActivity = TRUE;
        //mail.setTemplateId(et.id);
        //mail.setTargetObjectIds(contacts);
        //mail.setWhatIds(participantIds);
        //mail.setSenderDisplayName('Trainer');
        Messaging.sendEmail(mails);
        //Messaging.sendEmail(new Messaging.MassEmailMessage[]{mail});
    } 
}