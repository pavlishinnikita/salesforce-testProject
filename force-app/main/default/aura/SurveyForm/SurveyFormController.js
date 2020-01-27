({
    doInit : function(component, event, helper) {
        let action = component.get("c.getInit");
        action.setParams({
            'trainingId': component.get('v.trainingId'),
            'participantId': component.get('v.participantId')
        });
        action.setCallback(this, (res) => {
            if(res.getState() != 'SUCCESS') {
                component.set('v.alertMessage', res.getError()[0].message);
                component.set('v.isDisabledForm', true);
                component.set('v.showAlert', true);
            } else {
                component.set('v.isDisabledForm', false);
            }
        });
        $A.enqueueAction(action);
    },
    save : function(component, event, helper) {
        let action = component.get("c.setSurvey");
        let survey = component.get('v.newSurvey');
        Object.assign(survey, {
            'Training__c' : component.get('v.trainingId'),
            'Participant__c' : component.get('v.participantId')
        });
        action.setParams({
            'survey' : survey
        });
        action.setCallback(this, (res) => {
            if(res.getState() == 'SUCCESS') {
                helper.showToast('ASDASDASDS', 'dasd', 'info');
            } else {
                component.set('v.alertMessage', res.getError()[0].message);
                component.set('v.showAlert', true);
            }
        });
        $A.enqueueAction(action);
    },
})