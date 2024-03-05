(function (global) {
    const slidePanel = function (toggle) {
        if (typeof toggle === "object") {
            const toArray = function(collection) {
                if (collection !== null && typeof collection !== "undefined") {
                    const store = [];
                    const ar = store.slice.call(collection);
                    return ar;
                }
            };
    
            const setToggleEvent = function (elements) {
                toArray(elements).forEach(function (element) {
                    element.addEventListener("click", setToggle);
                });
            };
    
            const setToggle = function () {
                try {
                    toggle.checked = false;
                } catch (e) {
                    console.warn(e.message);
                    return false;
                }
            };

            return setToggleEvent;
        } else {
            return false;
        }
    };

    const nav = slidePanel(document.querySelector("#nav__toggle"));
    if (nav) {
        nav(document.querySelectorAll(".nav a[href^='#']"));
        nav(document.querySelectorAll(".nav__underlay"));
    }

    Observe({
        selector: "[data-src-img]",
        inRange: setItemByPlaceholder
    });

    Observe({
        selector: "[data-src-iframe]",
        inRange: function (record) {
            setItemByPlaceholder(record, {
                tag: "iframe",
                src: "data-src-iframe",
                ondemand: true
            });
        }
    });

    const header = document.querySelector(".view--header");
    if (header) {
        const headerClass = header.classList;
        if (!headerClass.contains("transition")) {
            headerClass.add("transition");
        }
    }

    Observe({
        selector: ".view--hero h1",
        unObserve: false,
        inRange: function () {
            header.classList.remove("transition--alternate");
            header.classList.add("transition--hero");
        },
        outRange: function () {
            header.classList.remove("transition--hero");
            header.classList.add("transition--alternate");
        },
        options: {
            rootMargin: "-300px 0px 0px 0px"
        }
    });

    const directive = document.querySelector(".ticket__directive");
    if (directive) {
        directive.addEventListener("click", function () {
            directive.classList.add("ticket__directive--dismiss");
        });
    
        Observe({
            selector: ".ticket",
            unObserve: false,
            inRange: function () {
                directive.classList.remove("ticket__directive--dismiss");
                directive.classList.add("ticket__directive--alert");
            },
            outRange: function () {
                directive.classList.add("ticket__directive--dismiss");
            }
        });
    }

    /**
     * creates a new HTML element
     * and goes through each attribute pair and sets the attribute name and value
     * then returns the element
     * @param {string} tag the name of the HTML tag to create
     * @param {object} attributes the object containing the tag's attribute name and value pairs
     */
    const createElement = function (tag, attributes) {
       const element = document.createElement(tag);
       if (typeof attributes === "object") {
           Object.keys(attributes).forEach(function (attribute) {
               element.setAttribute(attribute, attributes[attribute]);
           });
       }
       return element;
    };

    /**
     * creates a new HTML element
     * and appends it to the document body
     * @param {string} tag name of the HTML element to be appended
     * @return {object} list of attributes and values associated with the element
     */
    const appendElement = function (tag, attributes) {
       const element = createElement(tag, attributes);
       document.body.appendChild(element);
       return element;
    };

    /**
     * creates a new HTML element using the value of "ele",
     * sets the src attribute to the value of "src",
     * optionally applies other attributes
     * and appends to the end of the document body
     * @param {string} src representation of a url source
     * @param {string} tag representation of an HTML element to create in the document
     * @param {object} attributes optional object of HTML attribute value pairs to add to the created element
     * @return {node} html element with the resource request attached or false if failure occurs
     */
    const requestResource = function (src, tag, attributes) {
       if (typeof src !== "string") {
           console.warn("Cannot request a resource without a valid URL");
           return false;
       }

       if (typeof tag !== "string") {
           console.warn("Cannot request a resource without a valid element");
           return false;
       }

       if (tag === "link") {
            if (typeof attributes === "object") {
                attributes.href = src;
            } else {
                attributes = { href: src };
            }
       } else {
            if (typeof attributes === "object") {
                attributes.src = src;
            } else {
                attributes = { src: src };
            }
       }

       try {
           return appendElement(tag, attributes);
       } catch (error) {
           console.log(error);
           return false;
       }
    };

    const getFancybox = function () {
        const image = requestResource("/images/seating-chart.svg", "link", { rel : "preload", as : "image" });
        const js = requestResource("/shared/js/fancybox/3.2.10/jquery.fancybox.min.js", "script");
        const css = requestResource("/shared/js/fancybox/3.2.10/jquery.fancybox.min.css", "link", { rel : "stylesheet" });
    };

    if ("requestIdleCallback" in window) {
        requestIdleCallback(getFancybox);
    } else {
        document.addEventListener("DOMContentLoaded", getFancybox);
    }
}(window));