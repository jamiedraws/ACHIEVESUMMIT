var CountDownEngine = function () {

    let self = this;

    self.setCountdown = function (args) {
        // set args object
        args = args || {};
        // set date object
        args.date = args.date || new Date(Date.parse(new Date()) + 15 * 24 * 60 * 60 * 1000);
        // set init callback
        args.onInit = args.onInit || function () { };
        // set on count callback
        args.onCount = args.onCount || function () { };

        var getCountdown = {

            // gets remaining time :: @param endtime {date object}
            getTimeRemaining: function (endtime) {
                // get total time
                var t = Date.parse(endtime) - Date.parse(new Date()),
                    d = Math.floor(t / (1000 * 60 * 60 * 24)),
                    h = Math.floor((t / (1000 * 60 * 60)) % 24),
                    m = Math.floor((t / 1000 / 60) % 60),
                    s = Math.floor((t / 1000) % 60);

                // return time object
                return {
                    total: t.toString(),
                    days: d.toString(),
                    hours: ('0' + h).slice(-2),
                    minutes: ('0' + m).slice(-2),
                    seconds: ('0' + s).slice(-2)
                };
            },

            // refreshes clock and returns on count callback
            updateTime: function () {
                this.clock = this.getTimeRemaining(args.date);

                if (this.clock.total <= 0) { clearInterval(this.timer); }

                return args.onCount({
                    watch: this.watch, time: this.clock
                });
            },

            // splits a numeric value into an array
            splitNumbers: function (time) {
                var _ = this;
                this.stringClock = this.getTimeRemaining(args.date);

                $.each(time, function (index, value) {
                    _.stringClock[index] = [];

                    for (var i = 0, len = time[index].length; i < len; i += 1) {
                        _.stringClock[index].push(time[index].toString().charAt(i));
                    }
                });

                return this.stringClock;

            },

            // checks if array is equal
            isArrayEqual: function (arr1, arr2) {
                if (arr1.length !== arr2.length) { return false; }

                for (var i = arr1.length; i--;) {
                    if (arr1[i] !== arr2[i]) { return false; }
                }

                return true;
            },


            init: function () {
                var _ = this;

                this.date = args.date;
                this.watch = this.getTimeRemaining(this.date);

                args.onInit(_);

                this.updateTime();
                this.timer = setInterval(function () { _.updateTime(); }, 1000);

            }

        };

        getCountdown.init();

    };

};

var _countDownEngine = new CountDownEngine();
    
