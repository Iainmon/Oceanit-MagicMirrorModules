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
    },

    threads: {

    },

	// Override dom generator.
	getDom: function() {
        var wrapper = document.createElement("div");
        this.buffer.text += this.buffer.text;
		wrapper.innerHTML = this.buffer.text;
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
    // getStyles: function() {
    //     return [
    //         'script.css', // will try to load it from the vendor folder, otherwise it will load is from the module folder.
    //         'font-awesome.css', // this file is available in the vendor folder, so it doesn't need to be avialable in the module folder.
    //         this.file('anotherfile.css'), // this file will be loaded straight from the module folder.
    //         'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css',  // this file will be loaded from the bootstrapcdn servers.
    //     ]
    // },
    start: function() {
        this.mySpecialProperty = "So much wow!";
        Log.log(this.name + ' is started!');

        this.threads.updateThread = new Thread( () => {
            this.update();
        }, 1000, true);
        this.threads.queryJSON = new Thread( ()  => {
            Network.pullJSON(this.config.jsonURL, (status, jsonResponse) => {
                if (status == null) {
                    this.tideJson = jsonResponse;
                    this.update();
                } else {
                    this.error("Couldn't connect to the API Servers!");
                }
            }, 1000 * 60 * 60, true);
        });
    },

    update: function () {
        this.updateDom();
    }
});