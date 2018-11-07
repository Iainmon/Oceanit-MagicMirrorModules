class Network {}

Network.pullJSON = function(url, callback) {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);
    xhr.responseType = 'json';
    xhr.onload = function() {
        callback(status, xhr.response);
        callback(status, xhr.response);
    };
    xhr.send();
};