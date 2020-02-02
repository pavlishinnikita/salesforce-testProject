({
    doInit: function (component, event, helper) {

        let action = component.get("c.getGpa");
        action.setParams({
            'trId': component.get('v.recordId')
        });

        action.setCallback(this, (res) => {
            let state = res.getState();
            if (state == 'SUCCESS') {
                component.set("v.participants", res.getReturnValue());
            } else {
				helper.showToast('Init', "Sorry, man. Server error", 'error');
            }
        });
        $A.enqueueAction(action);
    },
    updateGpa: function (component, event, helper) {
        let action = component.get("c.setGpa");
        action.setParams({
            "participants": component.get("v.participants")
        });
        action.setCallback(this, (res) => {
            if (res.getState() == 'SUCCESS') {
                helper.showToast('GPA', 'GPA updated successfully!', 'success');
                $A.get('e.force:refreshView').fire();
            } else {
                helper.showToast('GPA', `GPA not updated: ${res.getError()[0].pageErrors[0].message}`, 'error');
            }
			$A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
    },
	close: function(component, event, helper) {
    	$A.get("e.force:closeQuickAction").fire();        
	} 
})