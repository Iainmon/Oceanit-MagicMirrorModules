Module.register("tides",{
	// Default module config.
	defaults: {
		text: "The tide is high today."
	},

	// Override dom generator.
	getDom: function() {
		var wrapper = document.createElement("div");
		wrapper.innerHTML = this.config.text;
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
        this.updateThread = new Thread( () => {
            this.update();
        }, 1000, true);
    },
    update: function() {
        this.updateDom(300);
    }

});