public with sharing class SendSuveyInviteSchedule implements Schedulable {
    public static void execute(System.SchedulableContext ctx) {
        Date d = System.today();
		List<Participant__c> participants = [SELECT Contact_Name__r.FirstName, Training__r.Training_Course__r.Name ,Training__r.End_Date__c, Training__c, Survey_URL__c FROM Participant__c WHERE DAY_ONLY(Training__r.End_Date__c) = :d];
        if(!participants.isEmpty()) {
			List<Messaging.SingleEmailMessage> mails = MailHelper.sendSurveyInvites(participants);
            Messaging.sendEmail(mails);
        }
    }
}