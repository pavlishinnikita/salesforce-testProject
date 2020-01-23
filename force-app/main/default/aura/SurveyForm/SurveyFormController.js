({
    doInit : function(component, event, helper) {
        let action = component.get("c.getInit");
        action.setParams({
            'trainingId': component.get('v.trainingId'),
            'participantId': component.get('v.participantId')
        });
        action.setCallback(this, (res) => {
            if(res.getState() == 'SUCCESS') {
                console.log(res.getReturnValue());
            } else {
                console.log(res.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    }
})