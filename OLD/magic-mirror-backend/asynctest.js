var Thread = require('async-threading');


var promise = new Promise(function () {
    let thread = new Thread(async function () {
        console.log('fired');
    }, 100);
});

var promise1 = new Promise(function () {
    for (let i = 1; i > 0; i++) {

    }
});

