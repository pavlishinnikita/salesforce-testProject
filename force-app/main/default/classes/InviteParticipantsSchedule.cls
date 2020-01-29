public with sharing class InviteParticipantsSchedule implements Schedulable {
    public static void execute(System.SchedulableContext ctx) {
        Date d = System.today() + 2;
		List<Participant__c> participants = [SELECT Training__r.Start_Date__c, Training__r.End_Date__c, Training__r.Location__r.Billing_Street__c, Training__r.Location__r.Postal_Code__c, Training__r.Location__r.Billing_City__c, Training__r.Location__r.Billing_Country__c, Contact_Name__r.FirstName FROM Participant__c WHERE DAY_ONLY(Training__r.Start_Date__c) = :d];
        if(!participants.isEmpty()) {
        	MailHelper.sendInvites(participants);    
        }
        
    }
}