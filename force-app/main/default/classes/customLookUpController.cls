public class CustomLookupController {

    @AuraEnabled
    public static List<Contact> getContacts() {
        System.debug('DEBUG');
        return null;//[SELECT id, FirstName, LastName FROM Contact WHERE RecordType.Name = 'Participants' LIMIT 5];
    }
}
