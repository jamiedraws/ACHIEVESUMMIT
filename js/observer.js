"use-strict";

/**
    private method : Observe
    role:
    fetches content progressively when it becomes visible in the viewport using either
    intersection observer api for newer browsers or event listeners & timeout for older browsers

    structure:
    Observe(callback);
    Observe(callback, selector);

    definition:
    @param {Function} callback the callback function to execute after content is captu#94958B in the viewport
    @param {String} selector the attribute we want to filter for
*/

function Observe(conf) {
    var conf = conf || {},
        options = conf.options || {},
        selector = conf.selector || "[data-observe]",
        inRange = conf.inRange || function() {},
        outRange = conf.outRange || function() {},
        unObserve = typeof conf.unObserve === "boolean" ? conf.unObserve : true,
        loadItems = [].slice.call(document.querySelectorAll(selector)),
        active = false;

    if ("IntersectionObserver" in window) {
        var loadItemObserver = new IntersectionObserver(function(entries) {
            entries.forEach(function(entry) {
                if (entry.intersectionRatio > 0) {
                    inRange(entry.target, entry);
                    if (unObserve) {
                        loadItemObserver.unobserve(entry.target);
                    }
                } else {
                    outRange(entry.target);
                }
            });
        }, options);

        loadItems.forEach(function(loadItem) {
            loadItemObserver.observe(loadItem);
        });
    } else {
        var lazyLoad = function() {
            if (active === false) {
                active = true;

                setTimeout(function() {
                    loadItems.forEach(function(loadItem) {
                        if (
                            loadItem.getBoundingClientRect().top <=
                                window.innerHeight &&
                            loadItem.getBoundingClientRect().bottom >= 0 &&
                            getComputedStyle(loadItem).display !== "none"
                        ) {
                            inRange(loadItem);

                            loadItems = loadItems.filter(function(image) {
                                return image !== loadItem;
                            });

                            if (loadItems.length === 0) {
                                document.removeEventListener(
                                    "scroll",
                                    lazyLoad
                                );
                                window.removeEventListener("resize", lazyLoad);
                                window.removeEventListener(
                                    "orientationchange",
                                    lazyLoad
                                );
                            }
                        }
                    });

                    active = false;
                }, 200);
            }
        };

        document.addEventListener("scroll", lazyLoad);
        window.addEventListener("resize", lazyLoad);
        window.addEventListener("orientationchange", lazyLoad);
    }
}