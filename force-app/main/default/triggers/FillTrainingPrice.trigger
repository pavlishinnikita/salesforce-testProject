trigger FillTrainingPrice on Training__c (before insert, before update) {

    Set<Id> productIds = new Set<Id>();

    for(Training__c training : Trigger.New) {
       productIds.add(training.Product__c);
    }

    List<PriceBookEntry> pbs = [SELECT Product2Id, UnitPrice FROM PriceBookEntry WHERE Product2Id IN :productIds];
    Map<Id, PriceBookEntry> currentPBSmap = new Map<Id, PriceBookEntry>();

    // create map for get price PBS without Query
    for(PriceBookEntry p: pbs) {
        currentPBSmap.put(p.Product2Id, p);
    }

    for(Training__c training : Trigger.New) {
        PriceBookEntry pbs = currentPBSmap.get(training.Product__c);
        if(pbs.UnitPrice != null) { // if product not set for training
        	training.List_Price__c = pbs.UnitPrice;   
        }
    }
}