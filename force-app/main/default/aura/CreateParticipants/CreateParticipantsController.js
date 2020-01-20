({
	doInit : function (component, event, helper) {
		let action = component.get("c.getParticipantsCount");

		action.setParams({
			'oppId': component.get('v.recordId')
		});
		action.setCallback(this, (res) => {
			if(res.getState() == 'SUCCESS') {
				let maxAndCurr = res.getReturnValue();
				component.set('v.participantsQuantity', maxAndCurr[0]);
				component.set('v.createdQuantity', maxAndCurr[1]);
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
		if(component.get('v.createdQuantity') !== component.get('v.participantsQuantity')) {
			$A.createComponent(
				"c:ContactField",
				{
					'aura:id': 'participant',
					'required': 'false'
				},
				(comp) => {
					let container = component.find("participantsContainer");
					if(container.isValid()) {
						let body = container.get('v.body');
						body.push(comp);
						//component.set('v.body', body);
						container.set('v.body', body);
					}
				}
			);
			component.set('v.createdQuantity', component.get('v.createdQuantity') + 1);
		}
	},
	createParticipants: function(component, event, helper) {
		const items = component.find('participant');
		const contactsId = [];
		
		if(Array.isArray(items)) {
			for(let i in items) {
				contactsId.push(items[i].find('contactId').get('v.value'));
			}
		} else {
			contactsId.push(items.find('contactId').get('v.value'));
		}

		let action = component.get("c.setParticipants");
		console.log(contactsId);
		console.log(component.get('v.recordId'));
		action.setParams({
			'oppId': component.get('v.recordId'),
			'contactsId': contactsId,
		});

		action.setCallback(this, (res) => {

			if(res.getState() == 'SUCCESS') {
				helper.showToast('Particippants created', 'Operation success', 'success');
				$A.get("e.force:closeQuickAction").fire();
			} else {
				console.log(res.getError());
				helper.showToast('Particippants created', 'Operation fail', 'fail');
			}
		});
		$A.enqueueAction(action);
	}
})