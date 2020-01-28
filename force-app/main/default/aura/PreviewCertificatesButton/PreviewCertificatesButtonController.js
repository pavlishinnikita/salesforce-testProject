({
	generateCertificates : function(component, event, helper) {
        let action = component.get("c.generatePDF");
        component.set("v.generated", false);
        action.setParams({
            "trainingId": component.get("v.recordId")    
        });
        action.setCallback(this, (res) => {
            $A.get("e.force:closeQuickAction").fire();
            if(res.getState() == "SUCCESS") {
        		helper.showToast('PDF', 'Generation was successful', 'success');
            } else {
				helper.showToast('PDF', res.getError()[0].message, 'error');
            }
    		component.set("v.generated", true);
        });
        $A.enqueueAction(action);
	},
	close: function(component, event, helper) {
    	$A.get("e.force:closeQuickAction").fire();        
  },
  doInit: function(component, event, helper) {
    component.set('v.url', helper.baseUrl());
  }
})