"use-strict";

/**
    private method : setItemByPlaceholder 
    role:
    creates new HTML element, assigns attributes and prepends to an explicit placeholder

    structure:
    setItemByPlaceholder(placeholder);
    setItemByPlaceholder(placeholder, { tag : 'img', src : 'data-src-img' });

    definition:
    @param {Object} placeholder the HTML placeholder we want to prepend the new tag to
    @param {Object} args the tag name we want to create and the source attribute we want to include 
*/
function setItemByPlaceholder(placeholder, args) {
    if (typeof placeholder === "undefined") {
        console.warn("A placeholder DOM element must be provided.");
        return false;
    }

    if (placeholder.classList.contains("load-item--success")) {
        return false;
    }

    var args = args || {};
    (args.tag = args.tag || "img"),
        (args.src = args.src || "data-src-img"),
        (args.onloadname = args.onloadname || "onload"),
        (args.onerrorname = args.onerrorname || "onerror"),
        (args.ondemand = "ondemand" in args ? args.ondemand : false),
        (elem = document.createElement(args.tag)),
        (source = placeholder.getAttribute(args.src)),
        (attributes = JSON.parse(placeholder.getAttribute("data-attr"))),
        (tagsGroup = JSON.parse(placeholder.getAttribute("data-tag")));

    var setDefault = function() {
            elem.setAttribute("src", source);
            if (args.ondemand) {
                addAttributes(elem, attributes);
                preloadItem(elem);
            } else {
                if ("Promise" in window) {
                    setItem(elem, attributes)
                        .then(preloadItem)
                        .catch(handleError);
                } else {
                    elem[args.onloadname] = preloadItem;
                    elem[args.onerrorname] = handleError;
                }
            }
        },
        handleError = function(elem) {
            placeholder.classList.add("load-item--failure");
            console.warn("Cound not load the resource", elem.target);
        },
        addAttributes = function(elem, attributes) {
            for (var attribute in attributes) {
                elem.setAttribute(attribute, attributes[attribute]);
            }
        },
        setItem = function(elem, attributes) {
            if ("Promise" in window) {
                return new Promise(function(resolve, reject) {
                    addAttributes(elem, attributes);
                    elem[args.onloadname] = resolve;
                    elem[args.onerrorname] = reject;
                });
            }
        },
        preloadItem = function(elem) {
            var elem = elem.target || elem;

            elem.classList.add("load-item__progress");
            placeholder.insertBefore(elem, placeholder.childNodes[0]);
            drawItem(function() {
                placeholder.classList.add("load-item--success");
                elem.classList.add("load-item__success");
            }, 2);
        },
        drawItem = function(callback, count) {
            if (count === drawItemIterator) {
                callback();
            } else {
                drawItemIterator += 1;
                requestAnimationFrame(function() {
                    drawItem(callback, count);
                });
            }
        },
        drawItemIterator = 0;

    placeholder.classList.add("load-item");

    if (tagsGroup) {
        for (var tags in tagsGroup) {
            let tag = tagsGroup[tags];
            if (tag.length > 1) {
                tag.forEach(function(attributes, i) {
                    if ("Promise" in window) {
                        setItem(elem, attributes)
                            .then(preloadItem)
                            .catch(function(error) {
                                if (i == tag.length - 1) setDefault();
                            });
                    } else {
                        elem[args.onloadname] = preloadItem;
                        elem[args.onerrorname] = handleError;
                    }
                });
            }
        }
    } else {
        setDefault();
    }
}