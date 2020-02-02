@isTest
public with sharing class CreateTaskForTrainerSchedule_Test {
    @TestSetup
    static void makeData() {

		Account a = new Account(name = 'Account1', billingcity = 'New York', billingcountry = 'USA');
		insert a;

        Contact c = new Contact(firstname = 'Trainer', lastname = 'Trainer surname', accountId = a.id);
        //c.OwnerId = a.id;
        Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Trainers').getRecordTypeId();
        c.RecordTypeId = devRecordTypeId;
		insert c;

        Training_Course__c trC = new Training_Course__c(Name = 'TEST COURSE', Description__c = 'DESCRIPTION');
        insert trC;
        
		Training__c t = new Training__c();
		t.Training_Course__c = trC.id;
		t.Start_Date__c = Datetime.now();
		t.End_Date__c = Datetime.now();
		t.Status__c = 'Active';
		t.Max_participants_quantity__c = 10;
        t.Trainer__c = c.id;
        insert t;
    }
    public final static String CRON_EXP = '0 0 0 ? * * *';

    @IsTest
    static void doTestTaskCreate() {
        
        Test.startTest();
        Date d = System.today();
		List<Training__c> trainings = [SELECT id, Trainer__c, Start_Date__c, End_Date__c, Trainer__r.OwnerId FROM Training__c];
        TaskFortrainerSchedule sh1 = new TaskFortrainerSchedule();
        system.schedule('Test add task', CRON_EXP, sh1); 
        Test.stopTest();

        List<Task> t = [SELECT id, Subject, Status, Priority, WhoId, OwnerId FROM Task];
        System.assertEquals(false, t.isEmpty(), 'Task not created');
        
    }
}
