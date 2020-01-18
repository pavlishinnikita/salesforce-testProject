({
	doInit : function (component, event, helper) {
		let action = component.get("c.getMaxParticipants");
		component.set('v.createdQuantity', 0);

		action.setParams({
			'oppId': component.get('v.recordId')
		});
		action.setCallback(this, (res) => {
			if(res.getState() == 'SUCCESS') {
				component.set('v.participantsQuantity', res.getReturnValue());
			} else {
				// handle error
			}
		});

		$A.enqueueAction(action);
	},
	close : function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire(); 
	},
	addItem: function(component, event, helper) {
		component.set('v.createdQuantity', component.get('v.createdQuantity') + 1);
		if(component.get('v.createdQuantity') !== component.get('v.participantsQuantity')) {
			$A.createComponent(
				"c:ContactField",
				{
					'aura:id': 'participant',
					'required': 'false'
				},
				(comp) => {
					let container = component.find("participantsForm");
					if(container.isValid()) {
						let body = container.get('v.body');
						body.push(comp);
						container.set('v.body', body);
					}
				}
			);
		} else {
			component.set('v.isButtonDisabled', true);
		}
	},
	createParticipants: function(component, event, helper) {
		
		const items = component.find('participant');
		const contactsId = [];
		for(let i in items) {
			contactsId.push(items[i].find('contactId').get('v.value'));
			console.log('Test: ' + i);
		}
		// let action = component.get("c.createParticipants");
		let action = component.get("c.test");
		
		action.setParams({
			'contactsId': contactsId,
			'oppId': component.get('v.recordId')
		});

		action.setCallback(this, (res) => {

			if(res.getState() == 'SUCCESS') {
				helper.showToast('Particippants created', 'Operation success', 'success');
			} else {
				console.log(res.getError());
				helper.showToast('Particippants created', 'Operation fail', 'fail');
			}
			$A.get("e.force:closeQuickAction").fire();
		});
		$A.enqueueAction(action);
	}
})