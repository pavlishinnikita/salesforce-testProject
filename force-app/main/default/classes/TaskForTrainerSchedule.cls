public with sharing class TaskForTrainerSchedule implements Schedulable {
	public static void execute(System.SchedulableContext ctx) {
		Date d = System.today();
		List<Training__c> trainings = [SELECT id, Trainer__c, Trainer__r.OwnerId FROM Training__c WHERE DAY_ONLY(End_Date__c) = :d];
		if(!trainings.isEmpty()) {
			List<Task> tasks = new List<Task>();
			for(Training__c training :trainings) {
				Task t = new Task();
				t.Subject = 'Fill GPA';
				t.Status = 'Open';
				t.Priority = 'Normal';
				t.WhoId = training.Trainer__c;
				t.OwnerId = training.Trainer__r.OwnerId;
				t.ActivityDate = Date.today() + 2;
				tasks.add(t);
			}
			if(!tasks.isEmpty()) {
				insert tasks;
			}
		}
	}
}