class Thread {
    constructor(execute, dtime = 0, startNow = true) {
        this.execute = execute;
        this.dtime = dtime;
        this.stop = false;
        this.fireTimes = 0;
        if (startNow) {
            this.fireTimes++;
            execute();
        }
        this.main();
    }
    main() {
        this.loop = setInterval(() => {
            this.fireTimes++;
            this.execute();
        }, this.dtime);
    }
    toggle() {
        this.stop = !this.stop;
        if (this.stop) {
            clearInterval(this.loop);
        } else {
            this.main();
        }
    }
    kill() {
        clearInterval(this.loop);
        this.main = this.toggle = this.dtime = this.stop = this.execute = this.loop = undefined;
        this.kill = null;
    }
}
Thread.spawn = function (execute, dtime = 0) {
    setTimeout(execute, dtime);
};
Thread.do = function (execute) {
    setTimeout(execute, 0);
};