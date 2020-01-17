({
    baseUrl: function() {
        let url = location.href;
        return url.substr(0, url.indexOf('/', 'https://'.length));
    }
})