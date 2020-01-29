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
				if(maxAndCurr[0] == maxAndCurr[1]) {
					component.set('v.createdParticipants', maxAndCurr[1]);
				} else {
					component.set('v.createdParticipants', maxAndCurr[1] + 1); // 1 is standart one field
				}
				component.set('v.renderField', !(maxAndCurr[0] == maxAndCurr[1]) );
			} else {
				helper.showToast('Server answer', res.getError()[0].getMessage(), 'fail'); // get errors from server here
			}
		});

		$A.enqueueAction(action);
	},
	close : function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire(); 
	},
	addItem: function(component, event, helper) {
		if(component.get('v.createdParticipants') < component.get('v.participantsQuantity')) {
			$A.createComponent(
				"c:ContactField",
				{
					'aura:id': 'participant',
				},
				(comp) => {
					let container = component.find("participantsContainer");
					if(container.isValid()) {
						let body = container.get('v.body');
						body.push(comp);
						container.set('v.body', body);
					}
				}
			);
			component.set('v.createdParticipants', component.get('v.createdParticipants') + 1);
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
				$A.get('e.force:refreshView').fire();
			} else {
				console.log(res.getError());
				helper.showToast('Particippants created', 'Operation fail', 'fail');
			}
		});
		$A.enqueueAction(action);
	}
})