function handler(event) {
    var request = event.request;
    var uri = request.uri;

    // Check whether the URI is missing a file name.
    if (uri.endsWith('/')) {
        request.uri += 'index.html';
    } else if (uri.endsWith('/en')){
        request.uri += '.html';
    } else if (uri.endsWith('/vi')) {
        request.uri += '.html';
    }

    return request;
}
