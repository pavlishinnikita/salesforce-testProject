@IsTest
public with sharing class CertificateController_test {
    @TestSetup
    static void makeData() {

		Account a = new Account(name = 'Account1', billingcity = 'New York', billingcountry = 'USA');
		insert a;
        
        Contact trainer = new Contact(firstname = 'Mark', lastname = 'Benioff', accountId = a.id);
        //c.OwnerId = a.id;
        Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Trainers').getRecordTypeId();
        trainer.RecordTypeId = devRecordTypeId;
		insert trainer;
        
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
        t.Trainer__c = trainer.id;
        insert t;

		Contact c = new Contact(firstname = 'first', lastname = 'last', accountId = a.id, Email = 'contact@test.org');
		insert c;

        List<Participant__c> lp = new List<Participant__c>();
        for(Integer i = 0; i < 10; i++) {
            Participant__c p = new Participant__c();
            p.Contact_Name__c = c.id;
            p.Training__c = t.id;
            p.Registration_Date_Time__c = Datetime.now();
            lp.add(p);
        }
		insert lp;
    }

    @IsTest
    static void isSignaturePresentTest() {
        CertificateController c = new CertificateController();
        System.assertEquals(false, c.getIsSignaturePresent(), 'Signature file not upload');
    }

    @IsTest
    static void getUrlTest() {
        System.assertEquals(System.URL.getSalesforceBaseUrl().toExternalForm(), CertificateController.getUrl(), 'URLs not equals');      
    }

    @IsTest
    static void getGPATest(){
        Training__c t = [SELECT id FROM Training__c LIMIT 1];
        List<Participant__c> lp = CertificateController.getGPA(t.id);
        System.assertEquals(10, lp.size(), 'get GPA error');    
    }

    @IsTest
    static void setGPATest() {
        List<Participant__c> lp1;
        System.assertEquals('Fail', CertificateController.setGPA(lp1), 'Logic of code error');
        List<Participant__c> lp2 = new List<Participant__c>();
        for(Participant__c p : [SELECT id, Status__c FROM Participant__c]) {
            p.GPA__c = 5;
            lp2.add(p);
        }
        System.assertEquals('Successfuly', CertificateController.setGPA(lp2), 'Update GPA DML exception');     
    }

    @IsTest
    static void getParticipantsTest() {
        Test.startTest();
        Training__c t = [SELECT id, Trainer__c FROM Training__c LIMIT 1];
        Participant__c p = [SELECT id FROM Participant__c WHERE Training__c = :t.id LIMIT 1];

        PageReference myVfPage = Page.Certificate;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('trainingId', t.Id);
    
        CertificateController c = new CertificateController();
        List<Participant__c> part1 = c.getParticipants();
        System.assertEquals(10, part1.size(), 'Get participants assert error');

        ApexPages.currentPage().getParameters().put('participantId', p.Id);
        List<Participant__c> part2 = c.getParticipants();
        System.assertEquals(1, part2.size(), 'Get participants assert error');

        Test.stopTest();
    }
}
