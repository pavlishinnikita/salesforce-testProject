({
    showToast: function(title, text, type) {
        let toastEvent = $A.get("e.force:showToast");
    	toastEvent.setParams({
            "title": title,
            "message": text,
            "type": type
    	});
    	toastEvent.fire();
    },
    baseUrl: function() {
        let url = location.href;
        return url.substr(0, url.indexOf('/', 'https://'.length));
    }
})