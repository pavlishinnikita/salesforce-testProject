public class FileHelper {
    public static void saveParticipantsList(List<Training__c> trainings) {
        List<ContentVersion> cvs = new List<ContentVersion>();
        for(Training__c t : trainings) {
            ContentVersion cv = new ContentVersion();
            PageReference pr = Page.ParticipantsList;
            pr.getParameters().put('trainingId', t.id);
            cv.VersionData = pr.getContentAsPDF();
            cv.Title = 'List_' + t.Name + '_' + t.id;
            cv.PathOnClient = 'List_' + t.Name + '_' + t.id + '.pdf';
            cvs.add(cv);
        }
        upsert cvs;
    }
}