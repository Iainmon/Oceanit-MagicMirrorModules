const storageDirectory = '../../storage/';
const queryIndexPath = '../../storage/hosts.json';
const http = require('http');
class QueryController {
    static initialize() {

    }
    static queryAll(callback = function (){}) {

        callback();
    }
}

module.exports = {
    QueryController : QueryController
};