public with sharing class SurveyController {
    
    @AuraEnabled
    public static string getInit(String trainingId, String participantId) {
        if(trainingId == '' || participantId == '') {
            throw new ExternalObjectException('INCORRECT SURVEY URL');
        }
        // List<Survey__c> current = [];
        List<Participant__c> ps = [SELECT id FROM Participant__c]; 
        return 'MEGA';
    }
}
