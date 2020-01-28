trigger CreateParticipant on Participant__c (before insert) {

    List<Site> site = [SELECT id, Subdomain, GuestUserId, UrlPathPrefix FROM Site WHERE Name = 'Survey'];
	SiteDetail sd = [SELECT SecureURL FROM SiteDetail where DurableId = :site.get(0).id LIMIT 1];
    String url = sd.SecureURL;
    for(Participant__c p : Trigger.New) {
		p.Survey_URL__c = url;
    }
}