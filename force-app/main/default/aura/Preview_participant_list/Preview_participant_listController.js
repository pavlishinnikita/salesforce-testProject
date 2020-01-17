({
	doInit : function(component, event, helper) {
		component.set("v.url", window.location.hostname.split('.')[0]);
	}
})