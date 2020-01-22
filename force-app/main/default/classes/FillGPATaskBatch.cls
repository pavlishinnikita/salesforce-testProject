public with sharing class FillGPATaskBatch implements Database.Batchable<sObject> {

	public List<Training__c> query;
	private List<Task> tasks;

	public List<Training__c> start(Database.BatchableContext bc) {
		tasks = new List<Task>();
		return query;
	}

	public void execute(Database.BatchableContext bc, List<Training__c> trainings) {
		if(!trainings.isEmpty()) {
			for(Training__c training :trainings) {
				Task t = new Task();
				t.Subject = 'Fill GPA';
				t.Status = 'Open';
				t.Priority = 'Normal';
				t.WhatId = training.Trainer__c;
				t.OwnerId = t.OwnerId;
				tasks.add(t);
			}
		}
	}

	public void finish(Database.BatchableContext bc) {
		if(tasks.isEmpty()) {
			insert tasks;
		}
	}

}