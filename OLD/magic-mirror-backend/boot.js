const Thread = require('async-threading');
const micros = require('microseconds');
const http = require('http');
const readline = require("readline-async");

// Custom imports
const imports = require('./app/import');
const {Func, Query, Request} = imports;

// Starts server
const serverStartTime = micros.now();
let server;
Func.reportTime( () => {
    Func.line();
    Func.print('Starting server...');
    server = new Func.Server();
    server.start();
}, 'Starting server');

// Starts the query
Func.reportTime( () => {
    Func.print('Initializing query controller...');
    Query.initialize();
    global.lastQuery = null;
    global.queryThread = new Thread( function () {
        Query.queryAll( function () {
            global.lastQuery = micros.now();
        });
    }, 10 * (1000 * 60 * 60)); //every 10 minutes
}, 'Initializing query controller');

Func.line();

// Starts console
global.requestInput = async function () {
    Func.print('Enter command: ');
    readline()
        .then( line => {
            global.prompt(line);
        });
};
global.prompt = async function (input) {
    switch (input) {
        case 'q':
        case 'quit':
        case 'stop':
            Func.print('Stopping server...');
            server.stop();
            Func.print(`Server stopped. Lifetime: ${micros.parse(micros.now() - serverStartTime)}`);
            Func.line();
            process.exit();
            break;

        case 'query':
            global.queryThread.execute();
            break;

        case 'log':
            if (!!global.lastQuery) Func.print('No queries have been completed successfully!');
            Func.print(`Last query cycle was completed ${micros.parse(micros.now() - global.lastQuery)} ago.`);
            break;

        default:
            Func.print('Invalid command!');

    }
    Thread.do( async () => { // do without waiting
        global.requestInput();
    });
};

global.requestInput();