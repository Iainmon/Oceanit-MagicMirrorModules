Module.register("tides",{
	// Default module config.
	defaults: {
        text: "The tide is high today.",
        jsonURL: "http://dev.nexal.net/tides.json"
    },

    moduleVariables: {
        updateCount: 0,
        lastAPIQueryTime: undefined,
        tideJson: undefined,
        error: false
    },

    threads: {

    },

	// Override dom generator.
	getDom: function() {
        var wrapper = document.createElement("div");

        if (!!this.moduleVariables.error) {
            wrapper.innerHTML = this.moduleVariables.error.message;
            return wrapper;
        }

		wrapper.innerHTML = "DOM is working!";
		return wrapper;
    },

    loaded: function(callback) {
        this.finishLoading();
        Log.log(this.name + ' is loaded!');
        callback();
    },
    getScripts: function() {
        return [
            this.file('Thread.js'), // this file will be loaded straight from the module folder.
            this.file('Network.js')
        ]
    },
    getStyles: function() {
        return [
            this.file('main.css'), // this file will be loaded straight from the module folder.
        ]
    },

    start: function() {
        this.mySpecialProperty = "So much wow!";
        Log.log(this.name + ' is started!');

        // this.threads.updateThread = new Thread( () => {
        //     this.update();
        // }, 1000, true);
        console.log("hello");
        Log.log("hello2");
        this.threads.queryJSON = new Thread( ()  => {
            Network.pullJSON(this.config.jsonURL, (status, jsonResponse) => {
                if (status == null) {
                    this.tideJson = jsonResponse;
                    this.error("Loaded with response 200 but no json. :(");
                } else {
                    this.error("Couldn't connect to the API Servers!");
                }
            }, 2000, true);
        });
    },

    error: function (msg) {
        this.moduleVariables.error = {
            message: msg
        }
        console.log(msg);
        Log.log(msg);
        this.updateDom(100);
    },

    update: function () {
        this.updateDom(100);
    }
});