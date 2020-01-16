public class InviteParticipantsSchedule implements Schedulable {
    public static void execute(System.SchedulableContext ctx) {
        Date d = System.today() + 2;
		List<Participant__c> participants = [SELECT Training__r.Start_Date__c FROM Participant__c WHERE DAY_ONLY(Training__r.Start_Date__c) = :d];
        if(!participants.isEmpty()) {
        	MailHelper.sendInvites(participants);    
        }
    }
}