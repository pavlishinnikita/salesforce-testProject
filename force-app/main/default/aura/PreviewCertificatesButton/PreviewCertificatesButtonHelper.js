({
    showToast: function(title, text, type) {
        let toastEvent = $A.get("e.force:showToast");
    	toastEvent.setParams({
            "title": title,
            "message": text,
            "type": type
    	});
    	toastEvent.fire();
    }
})