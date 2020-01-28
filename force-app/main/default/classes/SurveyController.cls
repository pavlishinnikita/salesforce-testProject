public with sharing class SurveyController {
    
    @AuraEnabled
    public static string getInit(String trainingId, String participantId) {
        if(trainingId == '' || participantId == '') {
            throw new ExternalObjectException('INCORRECT SURVEY URL');
        }
        List<Survey__c> sl = [SELECT id FROM Survey__c WHERE Training__c = :trainingId AND Participant__c = :participantId LIMIT 1];
        if(sl == null || !sl.isEmpty()) {
            throw new ExternalObjectException('You have already completed the survey');
        }
        return 'SUCCESS';
    }

    @AuraEnabled
    public static void setSurvey(Survey__c survey) {
        try {
            insert survey;
        } catch (DMLException e) {
            throw new DmlException('Cannot save survey. Incorrect data');
        }
    }
}