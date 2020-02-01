@IsTest
public with sharing class CreateParticipantTrigger_test {

    @TestSetup
    static void setup() {
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
        insert t;

		Account a = new Account(name = 'Account1', billingcity = 'New York', billingcountry = 'USA');
		insert a;

		Contact c = new Contact(firstname = 'first', lastname = 'last', accountId = a.id, Email = 'contact@test.org');
		insert c;

        Participant__c p = new Participant__c();
        p.Contact_Name__c = c.id;
        p.Training__c = t.id;
        p.Registration_Date_Time__c = Datetime.now();
		insert p;
    }

    @IsTest
    static void fillSurveyURL(){
        
        Test.startTest();
        List<Site> site = [SELECT id, Subdomain, GuestUserId, UrlPathPrefix FROM Site WHERE Name = 'Survey'];
        SiteDetail sd = [SELECT SecureURL FROM SiteDetail where DurableId = :site.get(0).id LIMIT 1];
        String url = sd.SecureURL;
        Participant__c p = [SELECT id, Survey_URL__c FROM Participant__c LIMIT 1];
        System.assertEquals(url, p.Survey_URL__c, 'Survey URL wrong');
        Test.stopTest();
        
    }
}
