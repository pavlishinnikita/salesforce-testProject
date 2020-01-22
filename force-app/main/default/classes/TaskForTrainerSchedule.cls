public with sharing class TaskForTrainerSchedule implements Schedulable {
    public static void execute(System.SchedulableContext ctx) {
        Date d = System.today();
        List<Training__c> trainings = [SELECT id, Trainer__c, Trainer__r.OwnerId FROM Training__c WHERE DAY_ONLY(End_Date__c) = :d];
        FillGPATaskBatch fillGPABatch = new FillGPATaskBatch();
        fillGPABatch.query = trainings;
        Id fillGPAJob = Database.executeBatch(fillGPABatch);
    }
}
