public with sharing class SurveyController {
    
    @AuraEnabled
    public static string getInit() {
        String a = ApexPages.currentPage().getParameters().get('a');
        System.debug(a);
        return 'TEST: ' + a;
    }
}
