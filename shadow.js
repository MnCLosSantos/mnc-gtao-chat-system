// ============================================================================
// AGGRESSIVE NUI MESSAGE BLOCKER - Block ALL external chat messages
// ============================================================================
(function() {
    
    // Method 1: Intercept window message events
    const originalAddEventListener = window.addEventListener;
    window.addEventListener = function(type, listener, options) {
        if (type === 'message') {
            const wrappedListener = function(event) {
                const data = event.data || {};
                
                // Block ALL ON_MESSAGE unless marked as allowed
                if (data.type === 'ON_MESSAGE' && !data.__fromOurResource) {
                    event.stopImmediatePropagation();
                    event.preventDefault();
                    return false;
                }
                
                return listener.call(this, event);
            };
            
            return originalAddEventListener.call(this, type, wrappedListener, options);
        }
        
        return originalAddEventListener.call(this, type, listener, options);
    };
    
    // Method 2: Override postMessage to intercept direct posts
    const originalPostMessage = window.postMessage.bind(window);
    window.postMessage = function(message, targetOrigin, transfer) {
        if (message && message.type === 'ON_MESSAGE' && !message.__fromOurResource) {
            return;
        }
        return originalPostMessage(message, targetOrigin, transfer);
    };
    
    // Method 3: Intercept at document level too
    if (document.addEventListener) {
        const origDocListener = document.addEventListener.bind(document);
        document.addEventListener = function(type, listener, options) {
            if (type === 'message') {
                const wrappedListener = function(event) {
                    const data = event.data || {};
                    if (data.type === 'ON_MESSAGE' && !data.__fromOurResource) {
                        return false;
                    }
                    return listener.call(this, event);
                };
                return origDocListener(type, wrappedListener, options);
            }
            return origDocListener(type, listener, options);
        };
    }
    
})();

// ============================================================================
// ORIGINAL SHADOW FILTER CODE
// ============================================================================
(function() {
var Filters = {}

var svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
svg.setAttribute("style", "display:block;width:0px;height:0px");
var defs = document.createElementNS("http://www.w3.org/2000/svg", "defs");

var blurFilter = document.createElementNS("http://www.w3.org/2000/svg", "filter");
blurFilter.setAttribute("id", "svgBlurFilter");
var feGaussianFilter = document.createElementNS("http://www.w3.org/2000/svg", "feGaussianBlur");
feGaussianFilter.setAttribute("stdDeviation", "0 0");
blurFilter.appendChild(feGaussianFilter);
defs.appendChild(blurFilter);
Filters._svgBlurFilter = feGaussianFilter;

// Drop Shadow Filter
var dropShadowFilter = document.createElementNS("http://www.w3.org/2000/svg", "filter");
dropShadowFilter.setAttribute("id", "svgDropShadowFilter");
var feGaussianFilter = document.createElementNS("http://www.w3.org/2000/svg", "feGaussianBlur");
feGaussianFilter.setAttribute("in", "SourceAlpha");
feGaussianFilter.setAttribute("stdDeviation", "3");
dropShadowFilter.appendChild(feGaussianFilter);
Filters._svgDropshadowFilterBlur = feGaussianFilter;

var feOffset = document.createElementNS("http://www.w3.org/2000/svg", "feOffset");
feOffset.setAttribute("dx", "0");
feOffset.setAttribute("dy", "0");
feOffset.setAttribute("result", "offsetblur");
dropShadowFilter.appendChild(feOffset);
Filters._svgDropshadowFilterOffset = feOffset;

var feFlood = document.createElementNS("http://www.w3.org/2000/svg", "feFlood");
feFlood.setAttribute("flood-color", "rgba(0,0,0,1)");
dropShadowFilter.appendChild(feFlood);
Filters._svgDropshadowFilterFlood = feFlood;

var feComposite = document.createElementNS("http://www.w3.org/2000/svg", "feComposite");
feComposite.setAttribute("in2", "offsetblur");
feComposite.setAttribute("operator", "in");
dropShadowFilter.appendChild(feComposite);
var feComposite = document.createElementNS("http://www.w3.org/2000/svg", "feComposite");
feComposite.setAttribute("in2", "SourceAlpha");
feComposite.setAttribute("operator", "out");
feComposite.setAttribute("result", "outer");
dropShadowFilter.appendChild(feComposite);

var feMerge = document.createElementNS("http://www.w3.org/2000/svg", "feMerge");
var feMergeNode = document.createElementNS("http://www.w3.org/2000/svg", "feMergeNode");
feMerge.appendChild(feMergeNode);
var feMergeNode = document.createElementNS("http://www.w3.org/2000/svg", "feMergeNode");
feMerge.appendChild(feMergeNode);
Filters._svgDropshadowMergeNode = feMergeNode;
dropShadowFilter.appendChild(feMerge);
defs.appendChild(dropShadowFilter);
svg.appendChild(defs);
document.documentElement.appendChild(svg);

const blurScale = 1;
const scale = (document.body.clientWidth / 1280);

Filters._svgDropshadowFilterBlur.setAttribute("stdDeviation",
    1 * blurScale + " " +
    1 * blurScale
);
Filters._svgDropshadowFilterOffset.setAttribute("dx",
    String(Math.cos(45 * Math.PI / 180) * 1 * scale));
Filters._svgDropshadowFilterOffset.setAttribute("dy",
    String(Math.sin(45 * Math.PI / 180) * 1 * scale));
Filters._svgDropshadowFilterFlood.setAttribute("flood-color",
    'rgba(0, 0, 0, 1)');
Filters._svgDropshadowMergeNode.setAttribute("in",
    "SourceGraphic");

})();
