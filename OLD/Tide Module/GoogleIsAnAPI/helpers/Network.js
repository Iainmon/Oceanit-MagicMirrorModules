const fetch = require('node-fetch');

class Network {}

Network.pullJSON = function (url, callback) {
    fetch(url)
        .then( function(response) {
            return response.json();
        })
        .then(function (myJson) {
            callback(myJson);
        });
};

module.exports = {
    Network: Network
};