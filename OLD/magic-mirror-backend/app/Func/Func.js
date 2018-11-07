const input = require('readline-sync');
const Thread = require('async-threading');
const fs = require('fs');
const micros = require('microseconds');
const http = require('http');

class Func {
    /**
     * Gets input from the command line
     * @param {*} question
     * @param {boolean} yesno
     * @returns {boolean, string}
     */
    static ask(question, yesno = false) {
        if (yesno) {
            let input = input.question(question + ' (yes/no)');
            if (input == 'yes') return true;
            if (input == 'no') return false;
        }
        return input.question(question + ' ');
    }
    static print(input) {
        console.log(input);
    }
    static calcTime(callback) {
        let stime = micros.now();
        callback();
        return micros.now() - stime;
    }
    static reportTime(callback, name = 'Process') {
        let stime = micros.now();
        callback();
        Func.print(`${name} took ${micros.parse(micros.now() - stime)}.`);
    }
    static line() {
        Func.print('------------------------');
    }
}
Func.Prompt = class {
    constructor(message, callback, recursive = true) {
        this.message = message;
        this.callback = callback;
        this.recursive = recursive;
    }
    start() {
        this.on = true;
        this.execute();
    }
    execute() {
        if (!this.on) return false;
        let prompt = Func.ask(this.message);
        this.callback(prompt);
        this.execute();
    }
    stop() {
        this.on = false;
    }
};
Func.Server = class {
    constructor(getContent) {
        this.memcached = [];
        this.getContent = getContent;
        this.http = http.createServer( (req, res) => {
            res.writeHead(200, {'Content-Type': 'text/html'});
            console.log(res);
            res.end('hello');
            //res.end(this.getContent());
        });
    }
    start() {
        this.http.listen(9000);
    }
    stop() {
        let memcachedLength = this.memcached.length;
        for (let i = 0; i < memcachedLength; i++) {
            Func.print(`Saving file ${i+1} of ${memcachedLength}.`);
            this.memcached[i].save();
            this.memcached[i].dump();
        }
        this.http.close();
    }
};

Func.Server.Memorycache = class {
    open(filepath, decodeToJson = false) {
        this.filepath = filepath;
        this.decodeToJson = decodeToJson;
        if (decodeToJson) {
            this.data = JSON.parse(fs.readFileSync(this.filepath));
        } else {
            this.data = fs.readFileSync(this.filepath);
        }
        return this;
    }
    save() {
        let data = (this.decodeToJson) ? JSON.stringify(this.data) : this.data ;
        fs.writeFileSync(this.filepath, data);
    }
    dump() {

    }
};

module.exports = {
    Func : Func
};