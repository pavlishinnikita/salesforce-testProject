({
	showToast: function(title, text, type) {
        let toastEvent = $A.get("e.force:showToast");
        console.log(toastEvent);
    	toastEvent.setParams({
            "title": title,
            "message": text,
            "type": type
    	});
    	toastEvent.fire();
    },
})