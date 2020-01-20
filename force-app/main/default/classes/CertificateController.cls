public class CertificateController {
    
    private boolean isSignatureReceived;
    private String trainingId;
    private String trainerSignature;
    
    public CertificateController () {
    }
	
    public boolean getIsSignaturePresent() {
        return !(trainerSignature == '' || trainerSignature == null);
    }
    
    @AuraEnabled
    public static String getUrl() {
        return System.URL.getSalesforceBaseUrl().toExternalForm();
    }
    
    @AuraEnabled
    public static String generatePDF(String trainingId) {
        List<Participant__c> participants = [SELECT id, Contact_Name__c, Contact_Name__r.FirstName, Contact_Name__r.LastName FROM Participant__c WHERE Training__c = :trainingId];
        List<ContentVersion> cvs = new List<ContentVersion>();
        
        for(Participant__c p: participants) {
            ContentVersion cv = new ContentVersion();

            PageReference pr = Page.Certificate;
            pr.getParameters().put('participantId',  p.id);
            Blob body;
            try {
                body = pr.getContentAsPdf();
            } catch(VisualforceException e) {
                // handle error
                return 'Cannot generate PDF';
            }
            cv.Title = 'Cerifcate_' + p.Contact_Name__r.FirstName + '_' + p.Contact_Name__r.LastName;
            cv.PathOnClient = 'Certificate_' + p.Contact_Name__r.FirstName + '_' + p.Contact_Name__r.LastName + '.pdf';
            cv.VersionData = body;
            cv.FirstPublishLocationId = p.Contact_Name__c;
            cvs.add(cv);
        }
        upsert cvs;
        return 'Success';
    }

    public List<Participant__c> getParticipants() {       
		String participantId = ApexPages.currentPage().getParameters().get('participantId');
        String trainingId = ApexPages.currentPage().getParameters().get('trainingId');
        List<Participant__c> participants;

        // get signature
        List<Training__c> t = [SELECT Trainer__c, Trainer__r.FirstName, Trainer__r.LastName FROM Training__c WHERE id = :trainingId];       
        if(!t.isEmpty()) {

            ContentWorkspace ws = [SELECT Id, RootContentFolderId FROM ContentWorkspace WHERE Name = 'Signatures' LIMIT 1];
                String filename = t.get(0).Trainer__r.FirstName + '_' + t.get(0).Trainer__r.LastName;
                List<ContentDocumentLink> cdLink = [SELECT id, ContentDocument.LatestPublishedVersionID
                                                FROM ContentDocumentLink
                                                WHERE linkedEntityId = :ws.Id AND ContentDocument.Title = :filename LIMIT 1];
                if(!cdLink.isEmpty()) {
                    trainerSignature = cdLink.get(0).ContentDocument.LatestPublishedVersionID;                                                    
                }
        }
        // get signature
        
        if(participantId == null) {
           participants = [
            SELECT Contact_Name__r.FirstName, Contact_Name__r.LastName, 
            Training__r.Start_Date__c, Training__r.End_Date__c,
            GPA__c,
            Training__r.Training_Course__r.Name,
            Training__r.Training_Course__r.Description__c,
            Training__r.Location__r.Billing_City__c,
            Training__r.CreatedById,
            Training__r.Trainer__r.FirstName,
            Training__r.Trainer__r.LastName   
            FROM Participant__c WHERE Training__c = :trainingId];
        } 
        else {
            participants = [
            SELECT Contact_Name__r.FirstName, Contact_Name__r.LastName, 
            Training__r.Start_Date__c, Training__r.End_Date__c,
            GPA__c,
            Training__r.Training_Course__r.Name,
            Training__r.Training_Course__r.Description__c,
            Training__r.Location__r.Billing_City__c,
            Training__r.CreatedById,
            Training__r.Trainer__r.FirstName,
            Training__r.Trainer__r.LastName 
            FROM Participant__c WHERE Id = :participantId];
        }
        return participants;
    }
    
	@AuraEnabled
    public static List<Participant__c> getGpa(String trId) {
		List<Participant__c> participants;
        if(trId != null) {
        	participants = [
			SELECT Contact_Name__r.FirstName, Contact_Name__r.LastName, 
			Training__r.Start_Date__c, Training__r.End_Date__c,
			GPA__c
			FROM Participant__c WHERE Training__c = :trId];
        }
		return participants;
    }
    
    @AuraEnabled
    public static String setGpa(Participant__c[] participants) {
        if(participants != null) {
			update participants;
            return 'Successfuly';
        }
        return 'Fail';
    }
        
    public String getSignature() {
        return System.URL.getSalesforceBaseUrl().toExternalForm() + '/sfc/servlet.shepherd/version/download/' + trainerSignature;
    }
}