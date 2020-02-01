@ IsTest
public class SendListParticipantsTest {

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
		for(Integer i = 0; i < 10; i ++) {
			Participant__c p = new Participant__c();
			p.Contact_Name__c = c.id;
			p.Training__c = t.id;
			p.Registration_Date_Time__c = Datetime.now();
			ps.add(p);
		}
		insert ps;
	}

	@IsTest
	static void doSendTest() {
		Test.startTest();
		SendListParticipantsBatch slpb = new SendListParticipantsBatch();
		slpb.query = [SELECT id, Trainer__c, Location__r.Email__c, Restaurant__r.Email__c FROM Training__c];
        System.debug(slpb.query.size());
        System.assertEquals(1, slpb.query.size(), 'We expected to find the same number of IT Asset records that we setup in the database.');
		Id batchId = Database.executeBatch(slpb);
		Test.stopTest();
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
								    JobItemsProcessed, 
								    TotalJobItems, CreatedBy.Email
								    FROM AsyncApexJob
								    WHERE Id = :batchId];
        System.assertEquals(0, job.NumberOfErrors, 'BATCH FAIL');
	}
}