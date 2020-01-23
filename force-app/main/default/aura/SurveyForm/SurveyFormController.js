({
    doInit : function(component, event, helper) {
        let action = component.get("c.getInit");
        action.setCallback(this, (res) => {
            if(res.getState() == 'SUCCESS') {
                console.log(res.getReturnValue());
                component.set('v.trainingId', res.getReturnValue());
            } else {
                // handle error
                console.log('ERROR');
            }
        });
        $A.enqueueAction(action);
    }
})