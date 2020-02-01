@IsTest
public with sharing class SurveyController_test {
    @TestSetup
    static void makeData() {
        Training_Course__c trC = new Training_Course__c(Name = 'TEST COURSE', Description__c = 'DESCRIPTION');
		insert trC;

		Location__c l = new Location__c(Name = 'Location', Email__c = 'location@org.com');
		insert l;

		Restaurant__c r = new Restaurant__c(Name = 'Restaurant', Email__c = 'Restaurant@org.com');
		insert r;

		Training__c t = new Training__c();
		t.Training_Course__c = trC.id;
		t.Start_Date__c = Datetime.now();
		t.End_Date__c = Datetime.now();
		t.Status__c = 'Active';
		t.Max_participants_quantity__c = 10;
		t.Restaurant__c = r.id;
		t.Location__c = l.id;
        try {
            insert t;
        } catch(DMLException e) {
            System.debug(e.getMessage());
        }

		Account a = new Account(name = 'Account1', billingcity = 'New York', billingcountry = 'USA');
		insert a;

		Contact c = new Contact(firstname = 'first', lastname = 'last', accountId = a.id, Email = 'contact@test.org');
		insert c;

        List<Participant__c> ps = new List<Participant__c>();
        for(Integer i = 0; i < 10; i++) {
            Participant__c p = new Participant__c();
            p.Contact_Name__c = c.id;
            p.Training__c = t.id;
            p.Registration_Date_Time__c = Datetime.now();
            ps.add(p);
        }
        insert ps;
        
        Survey__c s = new Survey__c();
        s.Training__c = t.id;
        s.Participant__c = ps.get(0).id;
        insert s;
    }

    @IsTest
    static void doTestGetInit(){
        Participant__c p = [SELECT id, Training__c FROM Participant__c LIMIT 1];
        Test.startTest();
        System.assertEquals(SurveyController.getInit(p.id, p.Training__c), 'SUCCESS', 'ERROR OF CONTROLLER INIT');

        try {
            System.assertEquals(SurveyController.getInit(p.Training__c,''), 'INCORRECT SURVEY URL', 'MISSING participant id');
        } catch (ExternalObjectException e) {
            System.assertEquals(e.getMessage(), 'INCORRECT SURVEY URL', 'MISSING participant id');
        }
        
        try {
            System.assertEquals(SurveyController.getInit('', p.id), 'INCORRECT SURVEY URL', 'MISSING training id');
        } catch (ExternalObjectException e) {
            System.assertEquals(e.getMessage(), 'INCORRECT SURVEY URL', 'MISSING training id');
        }

        try {
            System.assertEquals(SurveyController.getInit(p.Training__c, p.id), 'You have already completed the survey', 'Survey apready create');
        } catch (ExternalObjectException e) {
            System.assertEquals(e.getMessage(), 'You have already completed the survey', 'MISSING training id');
        }
        Test.stopTest();
    }

    @IsTest
    static void testSetSurvey() {
        
        List<Participant__c> ps = [SELECT id, Training__c FROM Participant__c];
        Test.startTest();
        Survey__c s = new Survey__c();
        s.Training__c = ps.get(0).id;
        s.Participant__c = ps.get(0).id;
        try {
            SurveyController.setSurvey(s);
        } catch (Exception e) {
            System.assertEquals(e.getMessage(), 'Cannot save survey. Incorrect data', 'No survey creation error');
        }
        
        s.Training__c = ps.get(0).Training__c;
        s.Participant__c = ps.get(0).id;
        SurveyController.setSurvey(s);
        List<Survey__c> ls = [SELECT id FROM Survey__c];
        System.assertNotEquals(ls.size(), 1, 'Survey not created');
        
        Test.stopTest();
        
    }
}
