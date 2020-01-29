public with sharing class SendListParticipantsSchedule implements Schedulable {
    public static void execute(System.SchedulableContext ctx) {
        Date d = System.today() + 5;
        List<Training__c> trainings = [SELECT id, Start_Date__c, End_Date__c, Trainer__c, Location__r.Email__c, Restaurant__r.Email__c
                                      FROM Training__c
                                      WHERE DAY_ONLY(Start_Date__c) = :d];
        if(!trainings.isEmpty()) {
            SendListParticipantsBatch slpb = new SendListParticipantsBatch();
            slpb.query = trainings;
            Id listBatchId = Database.executeBatch(slpb);
        }
    }
}