(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
"use strict";var translate=require("cs-i18n").translate,message=translate("Sorry, Coin Space Wallet did not load.")+"<br/><br/>"+translate("Try updating your browser, or switching out of private browsing mode. If all else fails, download Chrome for your device.");document.getElementById("loader-message").innerHTML=message;
},{"cs-i18n":17}],2:[function(require,module,exports){
function EventEmitter(){this._events=this._events||{},this._maxListeners=this._maxListeners||void 0}function isFunction(e){return"function"==typeof e}function isNumber(e){return"number"==typeof e}function isObject(e){return"object"==typeof e&&null!==e}function isUndefined(e){return void 0===e}module.exports=EventEmitter,EventEmitter.EventEmitter=EventEmitter,EventEmitter.prototype._events=void 0,EventEmitter.prototype._maxListeners=void 0,EventEmitter.defaultMaxListeners=10,EventEmitter.prototype.setMaxListeners=function(e){if(!isNumber(e)||0>e||isNaN(e))throw TypeError("n must be a positive number");return this._maxListeners=e,this},EventEmitter.prototype.emit=function(e){var t,n,s,i,r,o;if(this._events||(this._events={}),"error"===e&&(!this._events.error||isObject(this._events.error)&&!this._events.error.length)){if(t=arguments[1],t instanceof Error)throw t;throw TypeError('Uncaught, unspecified "error" event.')}if(n=this._events[e],isUndefined(n))return!1;if(isFunction(n))switch(arguments.length){case 1:n.call(this);break;case 2:n.call(this,arguments[1]);break;case 3:n.call(this,arguments[1],arguments[2]);break;default:for(s=arguments.length,i=new Array(s-1),r=1;s>r;r++)i[r-1]=arguments[r];n.apply(this,i)}else if(isObject(n)){for(s=arguments.length,i=new Array(s-1),r=1;s>r;r++)i[r-1]=arguments[r];for(o=n.slice(),s=o.length,r=0;s>r;r++)o[r].apply(this,i)}return!0},EventEmitter.prototype.addListener=function(e,t){var n;if(!isFunction(t))throw TypeError("listener must be a function");if(this._events||(this._events={}),this._events.newListener&&this.emit("newListener",e,isFunction(t.listener)?t.listener:t),this._events[e]?isObject(this._events[e])?this._events[e].push(t):this._events[e]=[this._events[e],t]:this._events[e]=t,isObject(this._events[e])&&!this._events[e].warned){var n;n=isUndefined(this._maxListeners)?EventEmitter.defaultMaxListeners:this._maxListeners,n&&n>0&&this._events[e].length>n&&(this._events[e].warned=!0,console.error("(node) warning: possible EventEmitter memory leak detected. %d listeners added. Use emitter.setMaxListeners() to increase limit.",this._events[e].length),"function"==typeof console.trace&&console.trace())}return this},EventEmitter.prototype.on=EventEmitter.prototype.addListener,EventEmitter.prototype.once=function(e,t){function n(){this.removeListener(e,n),s||(s=!0,t.apply(this,arguments))}if(!isFunction(t))throw TypeError("listener must be a function");var s=!1;return n.listener=t,this.on(e,n),this},EventEmitter.prototype.removeListener=function(e,t){var n,s,i,r;if(!isFunction(t))throw TypeError("listener must be a function");if(!this._events||!this._events[e])return this;if(n=this._events[e],i=n.length,s=-1,n===t||isFunction(n.listener)&&n.listener===t)delete this._events[e],this._events.removeListener&&this.emit("removeListener",e,t);else if(isObject(n)){for(r=i;r-- >0;)if(n[r]===t||n[r].listener&&n[r].listener===t){s=r;break}if(0>s)return this;1===n.length?(n.length=0,delete this._events[e]):n.splice(s,1),this._events.removeListener&&this.emit("removeListener",e,t)}return this},EventEmitter.prototype.removeAllListeners=function(e){var t,n;if(!this._events)return this;if(!this._events.removeListener)return 0===arguments.length?this._events={}:this._events[e]&&delete this._events[e],this;if(0===arguments.length){for(t in this._events)"removeListener"!==t&&this.removeAllListeners(t);return this.removeAllListeners("removeListener"),this._events={},this}if(n=this._events[e],isFunction(n))this.removeListener(e,n);else for(;n.length;)this.removeListener(e,n[n.length-1]);return delete this._events[e],this},EventEmitter.prototype.listeners=function(e){var t;return t=this._events&&this._events[e]?isFunction(this._events[e])?[this._events[e]]:this._events[e].slice():[]},EventEmitter.listenerCount=function(e,t){var n;return n=e._events&&e._events[t]?isFunction(e._events[t])?1:e._events[t].length:0};
},{}],3:[function(require,module,exports){
"function"==typeof Object.create?module.exports=function(t,e){t.super_=e,t.prototype=Object.create(e.prototype,{constructor:{value:t,enumerable:!1,writable:!0,configurable:!0}})}:module.exports=function(t,e){t.super_=e;var o=function(){};o.prototype=e.prototype,t.prototype=new o,t.prototype.constructor=t};
},{}],4:[function(require,module,exports){
function noop(){}var process=module.exports={};process.nextTick=function(){var e="undefined"!=typeof window&&window.setImmediate,o="undefined"!=typeof window&&window.MutationObserver,n="undefined"!=typeof window&&window.postMessage&&window.addEventListener;if(e)return function(e){return window.setImmediate(e)};var s=[];if(o){var r=document.createElement("div"),t=new MutationObserver(function(){var e=s.slice();s.length=0,e.forEach(function(e){e()})});return t.observe(r,{attributes:!0}),function(e){s.length||r.setAttribute("yes","no"),s.push(e)}}return n?(window.addEventListener("message",function(e){var o=e.source;if((o===window||null===o)&&"process-tick"===e.data&&(e.stopPropagation(),s.length>0)){var n=s.shift();n()}},!0),function(e){s.push(e),window.postMessage("process-tick","*")}):function(e){setTimeout(e,0)}}(),process.title="browser",process.browser=!0,process.env={},process.argv=[],process.on=noop,process.addListener=noop,process.once=noop,process.off=noop,process.removeListener=noop,process.removeAllListeners=noop,process.emit=noop,process.binding=function(e){throw new Error("process.binding is not supported")},process.cwd=function(){return"/"},process.chdir=function(e){throw new Error("process.chdir is not supported")};
},{}],5:[function(require,module,exports){
module.exports=function(o){return o&&"object"==typeof o&&"function"==typeof o.copy&&"function"==typeof o.fill&&"function"==typeof o.readUInt8};
},{}],6:[function(require,module,exports){
(function (process,global){
function inspect(e,r){var t={seen:[],stylize:stylizeNoColor};return arguments.length>=3&&(t.depth=arguments[2]),arguments.length>=4&&(t.colors=arguments[3]),isBoolean(r)?t.showHidden=r:r&&exports._extend(t,r),isUndefined(t.showHidden)&&(t.showHidden=!1),isUndefined(t.depth)&&(t.depth=2),isUndefined(t.colors)&&(t.colors=!1),isUndefined(t.customInspect)&&(t.customInspect=!0),t.colors&&(t.stylize=stylizeWithColor),formatValue(t,e,t.depth)}function stylizeWithColor(e,r){var t=inspect.styles[r];return t?"["+inspect.colors[t][0]+"m"+e+"["+inspect.colors[t][1]+"m":e}function stylizeNoColor(e,r){return e}function arrayToHash(e){var r={};return e.forEach(function(e,t){r[e]=!0}),r}function formatValue(e,r,t){if(e.customInspect&&r&&isFunction(r.inspect)&&r.inspect!==exports.inspect&&(!r.constructor||r.constructor.prototype!==r)){var n=r.inspect(t,e);return isString(n)||(n=formatValue(e,n,t)),n}var i=formatPrimitive(e,r);if(i)return i;var o=Object.keys(r),s=arrayToHash(o);if(e.showHidden&&(o=Object.getOwnPropertyNames(r)),isError(r)&&(o.indexOf("message")>=0||o.indexOf("description")>=0))return formatError(r);if(0===o.length){if(isFunction(r)){var u=r.name?": "+r.name:"";return e.stylize("[Function"+u+"]","special")}if(isRegExp(r))return e.stylize(RegExp.prototype.toString.call(r),"regexp");if(isDate(r))return e.stylize(Date.prototype.toString.call(r),"date");if(isError(r))return formatError(r)}var a="",c=!1,l=["{","}"];if(isArray(r)&&(c=!0,l=["[","]"]),isFunction(r)){var p=r.name?": "+r.name:"";a=" [Function"+p+"]"}if(isRegExp(r)&&(a=" "+RegExp.prototype.toString.call(r)),isDate(r)&&(a=" "+Date.prototype.toUTCString.call(r)),isError(r)&&(a=" "+formatError(r)),0===o.length&&(!c||0==r.length))return l[0]+a+l[1];if(0>t)return isRegExp(r)?e.stylize(RegExp.prototype.toString.call(r),"regexp"):e.stylize("[Object]","special");e.seen.push(r);var f;return f=c?formatArray(e,r,t,s,o):o.map(function(n){return formatProperty(e,r,t,s,n,c)}),e.seen.pop(),reduceToSingleString(f,a,l)}function formatPrimitive(e,r){if(isUndefined(r))return e.stylize("undefined","undefined");if(isString(r)){var t="'"+JSON.stringify(r).replace(/^"|"$/g,"").replace(/'/g,"\\'").replace(/\\"/g,'"')+"'";return e.stylize(t,"string")}return isNumber(r)?e.stylize(""+r,"number"):isBoolean(r)?e.stylize(""+r,"boolean"):isNull(r)?e.stylize("null","null"):void 0}function formatError(e){return"["+Error.prototype.toString.call(e)+"]"}function formatArray(e,r,t,n,i){for(var o=[],s=0,u=r.length;u>s;++s)hasOwnProperty(r,String(s))?o.push(formatProperty(e,r,t,n,String(s),!0)):o.push("");return i.forEach(function(i){i.match(/^\d+$/)||o.push(formatProperty(e,r,t,n,i,!0))}),o}function formatProperty(e,r,t,n,i,o){var s,u,a;if(a=Object.getOwnPropertyDescriptor(r,i)||{value:r[i]},a.get?u=a.set?e.stylize("[Getter/Setter]","special"):e.stylize("[Getter]","special"):a.set&&(u=e.stylize("[Setter]","special")),hasOwnProperty(n,i)||(s="["+i+"]"),u||(e.seen.indexOf(a.value)<0?(u=isNull(t)?formatValue(e,a.value,null):formatValue(e,a.value,t-1),u.indexOf("\n")>-1&&(u=o?u.split("\n").map(function(e){return"  "+e}).join("\n").substr(2):"\n"+u.split("\n").map(function(e){return"   "+e}).join("\n"))):u=e.stylize("[Circular]","special")),isUndefined(s)){if(o&&i.match(/^\d+$/))return u;s=JSON.stringify(""+i),s.match(/^"([a-zA-Z_][a-zA-Z_0-9]*)"$/)?(s=s.substr(1,s.length-2),s=e.stylize(s,"name")):(s=s.replace(/'/g,"\\'").replace(/\\"/g,'"').replace(/(^"|"$)/g,"'"),s=e.stylize(s,"string"))}return s+": "+u}function reduceToSingleString(e,r,t){var n=0,i=e.reduce(function(e,r){return n++,r.indexOf("\n")>=0&&n++,e+r.replace(/\u001b\[\d\d?m/g,"").length+1},0);return i>60?t[0]+(""===r?"":r+"\n ")+" "+e.join(",\n  ")+" "+t[1]:t[0]+r+" "+e.join(", ")+" "+t[1]}function isArray(e){return Array.isArray(e)}function isBoolean(e){return"boolean"==typeof e}function isNull(e){return null===e}function isNullOrUndefined(e){return null==e}function isNumber(e){return"number"==typeof e}function isString(e){return"string"==typeof e}function isSymbol(e){return"symbol"==typeof e}function isUndefined(e){return void 0===e}function isRegExp(e){return isObject(e)&&"[object RegExp]"===objectToString(e)}function isObject(e){return"object"==typeof e&&null!==e}function isDate(e){return isObject(e)&&"[object Date]"===objectToString(e)}function isError(e){return isObject(e)&&("[object Error]"===objectToString(e)||e instanceof Error)}function isFunction(e){return"function"==typeof e}function isPrimitive(e){return null===e||"boolean"==typeof e||"number"==typeof e||"string"==typeof e||"symbol"==typeof e||"undefined"==typeof e}function objectToString(e){return Object.prototype.toString.call(e)}function pad(e){return 10>e?"0"+e.toString(10):e.toString(10)}function timestamp(){var e=new Date,r=[pad(e.getHours()),pad(e.getMinutes()),pad(e.getSeconds())].join(":");return[e.getDate(),months[e.getMonth()],r].join(" ")}function hasOwnProperty(e,r){return Object.prototype.hasOwnProperty.call(e,r)}var formatRegExp=/%[sdj%]/g;exports.format=function(e){if(!isString(e)){for(var r=[],t=0;t<arguments.length;t++)r.push(inspect(arguments[t]));return r.join(" ")}for(var t=1,n=arguments,i=n.length,o=String(e).replace(formatRegExp,function(e){if("%%"===e)return"%";if(t>=i)return e;switch(e){case"%s":return String(n[t++]);case"%d":return Number(n[t++]);case"%j":try{return JSON.stringify(n[t++])}catch(r){return"[Circular]"}default:return e}}),s=n[t];i>t;s=n[++t])o+=isNull(s)||!isObject(s)?" "+s:" "+inspect(s);return o},exports.deprecate=function(e,r){function t(){if(!n){if(process.throwDeprecation)throw new Error(r);process.traceDeprecation?console.trace(r):console.error(r),n=!0}return e.apply(this,arguments)}if(isUndefined(global.process))return function(){return exports.deprecate(e,r).apply(this,arguments)};if(process.noDeprecation===!0)return e;var n=!1;return t};var debugs={},debugEnviron;exports.debuglog=function(e){if(isUndefined(debugEnviron)&&(debugEnviron=process.env.NODE_DEBUG||""),e=e.toUpperCase(),!debugs[e])if(new RegExp("\\b"+e+"\\b","i").test(debugEnviron)){var r=process.pid;debugs[e]=function(){var t=exports.format.apply(exports,arguments);console.error("%s %d: %s",e,r,t)}}else debugs[e]=function(){};return debugs[e]},exports.inspect=inspect,inspect.colors={bold:[1,22],italic:[3,23],underline:[4,24],inverse:[7,27],white:[37,39],grey:[90,39],black:[30,39],blue:[34,39],cyan:[36,39],green:[32,39],magenta:[35,39],red:[31,39],yellow:[33,39]},inspect.styles={special:"cyan",number:"yellow","boolean":"yellow",undefined:"grey","null":"bold",string:"green",date:"magenta",regexp:"red"},exports.isArray=isArray,exports.isBoolean=isBoolean,exports.isNull=isNull,exports.isNullOrUndefined=isNullOrUndefined,exports.isNumber=isNumber,exports.isString=isString,exports.isSymbol=isSymbol,exports.isUndefined=isUndefined,exports.isRegExp=isRegExp,exports.isObject=isObject,exports.isDate=isDate,exports.isError=isError,exports.isFunction=isFunction,exports.isPrimitive=isPrimitive,exports.isBuffer=require("./support/isBuffer");var months=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];exports.log=function(){console.log("%s - %s",timestamp(),exports.format.apply(exports,arguments))},exports.inherits=require("inherits"),exports._extend=function(e,r){if(!r||!isObject(r))return e;for(var t=Object.keys(r),n=t.length;n--;)e[t[n]]=r[t[n]];return e};
}).call(this,require('_process'),typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./support/isBuffer":5,"_process":4,"inherits":3}],7:[function(require,module,exports){
"use strict";function isString(t){return"string"==typeof t||"[object String]"===Object.prototype.toString.call(t)}function isFunction(t){return"function"==typeof t||"[object Function]"===Object.prototype.toString.call(t)}function isPlainObject(t){return null===t?!1:"[object Object]"===Object.prototype.toString.call(t)}function isSymbol(t){return isString(t)&&":"===t[0]}function hasOwnProp(t,e){return Object.prototype.hasOwnProperty.call(t,e)}function getEntry(t,e){return e.reduce(function(t,e){return isPlainObject(t)&&hasOwnProp(t,e)?t[e]:null},t)}function Counterpart(){this._registry={locale:"en",interpolate:!0,fallbackLocale:null,scope:null,translations:{},interpolations:{},normalizedKeys:{},separator:"."},this.registerTranslations("en",require("./locales/en")),this.setMaxListeners(0)}function translate(){return instance.translate.apply(instance,arguments)}var extend=require("extend"),isArray=require("util").isArray,isDate=require("util").isDate,sprintf=require("sprintf").sprintf,events=require("events"),except=require("except"),strftime=require("./strftime"),translationScope="counterpart";extend(Counterpart.prototype,events.EventEmitter.prototype),Counterpart.prototype.getLocale=function(){return this._registry.locale},Counterpart.prototype.setLocale=function(t){var e=this._registry.locale;return e!=t&&(this._registry.locale=t,this.emit("localechange",t,e)),e},Counterpart.prototype.getFallbackLocale=function(){return this._registry.fallbackLocale},Counterpart.prototype.setFallbackLocale=function(t){var e=this._registry.fallbackLocale;return this._registry.fallbackLocale=t,e},Counterpart.prototype.getAvailableLocales=function(){return this._registry.availableLocales||Object.keys(this._registry.translations)},Counterpart.prototype.setAvailableLocales=function(t){var e=this.getAvailableLocales();return this._registry.availableLocales=t,e},Counterpart.prototype.getSeparator=function(){return this._registry.separator},Counterpart.prototype.setSeparator=function(t){var e=this._registry.separator;return this._registry.separator=t,e},Counterpart.prototype.setInterpolate=function(t){var e=this._registry.interpolate;return this._registry.interpolate=t,e},Counterpart.prototype.getInterpolate=function(){return this._registry.interpolate},Counterpart.prototype.registerTranslations=function(t,e){var r={};return r[t]=e,extend(!0,this._registry.translations,r),r},Counterpart.prototype.registerInterpolations=function(t){return extend(!0,this._registry.interpolations,t)},Counterpart.prototype.onLocaleChange=Counterpart.prototype.addLocaleChangeListener=function(t){this.addListener("localechange",t)},Counterpart.prototype.offLocaleChange=Counterpart.prototype.removeLocaleChangeListener=function(t){this.removeListener("localechange",t)},Counterpart.prototype.onTranslationNotFound=Counterpart.prototype.addTranslationNotFoundListener=function(t){this.addListener("translationnotfound",t)},Counterpart.prototype.offTranslationNotFound=Counterpart.prototype.removeTranslationNotFoundListener=function(t){this.removeListener("translationnotfound",t)},Counterpart.prototype.translate=function(t,e){if(!isArray(t)&&!isString(t)||!t.length)throw new Error("invalid argument: key");isSymbol(t)&&(t=t.substr(1)),e=extend(!0,{},e);var r=e.locale||this._registry.locale;delete e.locale;var n=e.scope||this._registry.scope;delete e.scope;var o=e.separator||this._registry.separator;delete e.separator;var a=e.fallbackLocale||this._registry.fallbackLocale;delete e.fallbackLocale;var i=this._normalizeKeys(r,n,t,o),s=getEntry(this._registry.translations,i);if(null===s&&e.fallback&&(this.emit("translationnotfound",r,t,e.fallback),s=this._fallback(r,n,t,e.fallback,e)),null===s&&a&&r!==a){var l=this._normalizeKeys(a,n,t,o);s=getEntry(this._registry.translations,l),s&&(r=a)}return null===s&&(s="missing translation: "+i.join(o)),s=this._pluralize(r,s,e.count),this._registry.interpolate!==!1&&e.interpolate!==!1&&(s=this._interpolate(s,e)),s},Counterpart.prototype.localize=function(t,e){if(!isDate(t))throw new Error("invalid argument: object must be a date");e=extend(!0,{},e);var r=e.locale||this._registry.locale,n=e.scope||translationScope,o=e.type||"datetime",a=e.format||"default";return e={locale:r,scope:n,interpolate:!1},a=this.translate(["formats",o,a],extend(!0,{},e)),strftime(t,a,this.translate("names",e))},Counterpart.prototype._pluralize=function(t,e,r){if("object"!=typeof e||null===e||"number"!=typeof r)return e;var n=this.translate("pluralize",{locale:t,scope:translationScope});return"[object Function]"!==Object.prototype.toString.call(n)?n:n(e,r)},Counterpart.prototype.withLocale=function(t,e,r){var n=this._registry.locale;this._registry.locale=t;var o=e.call(r);return this._registry.locale=n,o},Counterpart.prototype.withScope=function(t,e,r){var n=this._registry.scope;this._registry.scope=t;var o=e.call(r);return this._registry.scope=n,o},Counterpart.prototype.withSeparator=function(t,e,r){var n=this.setSeparator(t),o=e.call(r);return this.setSeparator(n),o},Counterpart.prototype._normalizeKeys=function(t,e,r,n){var o=[];return o=o.concat(this._normalizeKey(t,n)),o=o.concat(this._normalizeKey(e,n)),o=o.concat(this._normalizeKey(r,n))},Counterpart.prototype._normalizeKey=function(t,e){return this._registry.normalizedKeys[e]=this._registry.normalizedKeys[e]||{},this._registry.normalizedKeys[e][t]=this._registry.normalizedKeys[e][t]||function(t){if(isArray(t)){var r=t.map(function(t){return this._normalizeKey(t,e)}.bind(this));return[].concat.apply([],r)}if("undefined"==typeof t||null===t)return[];for(var n=t.split(e),o=n.length-1;o>=0;o--)""===n[o]&&n.splice(o,1);return n}.bind(this)(t),this._registry.normalizedKeys[e][t]},Counterpart.prototype._interpolate=function(t,e){return"string"!=typeof t?t:sprintf(t,extend({},this._registry.interpolations,e))},Counterpart.prototype._resolve=function(t,e,r,n,o){if(o=o||{},o.resolve===!1)return n;var a;if(isSymbol(n))a=this.translate(n,extend({},o,{locale:t,scope:e}));else if(isFunction(n)){var i;o.object?(i=o.object,delete o.object):i=r,a=this._resolve(t,e,r,n(i,o))}else a=n;return/^missing translation:/.test(a)?null:a},Counterpart.prototype._fallback=function(t,e,r,n,o){if(o=except(o,"fallback"),isArray(n)){for(var a=0,i=n.length;i>a;a++){var s=this._resolve(t,e,r,n[a],o);if(s)return s}return null}return this._resolve(t,e,r,n,o)};var instance=new Counterpart;extend(translate,instance,{Instance:Counterpart}),module.exports=translate;
},{"./locales/en":8,"./strftime":16,"events":2,"except":11,"extend":13,"sprintf":15,"util":6}],8:[function(require,module,exports){
module.exports={counterpart:{names:require("date-names/en"),pluralize:require("pluralizers/en"),formats:{date:{"default":"%a, %e %b %Y","long":"%A, %B %o, %Y","short":"%b %e"},time:{"default":"%H:%M","long":"%H:%M:%S %z","short":"%H:%M"},datetime:{"default":"%a, %e %b %Y %H:%M","long":"%A, %B %o, %Y %H:%M:%S %z","short":"%e %b %H:%M"}}}};
},{"date-names/en":9,"pluralizers/en":14}],9:[function(require,module,exports){
module.exports={__locale:"en",days:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],abbreviated_days:["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],months:["January","February","March","April","May","June","July","August","September","October","November","December"],abbreviated_months:["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],am:"AM",pm:"PM"};
},{}],10:[function(require,module,exports){
module.exports=require("./en");
},{"./en":9}],11:[function(require,module,exports){
"use strict";function except(e){var a={},c=concat.apply(ap,slice.call(arguments,1));for(var r in e)-1===indexOf(c,r)&&(a[r]=e[r]);return a}var ap=Array.prototype,concat=ap.concat,slice=ap.slice,indexOf=require("indexof");module.exports=except;
},{"indexof":12}],12:[function(require,module,exports){
var indexOf=[].indexOf;module.exports=function(e,n){if(indexOf)return e.indexOf(n);for(var r=0;r<e.length;++r)if(e[r]===n)return r;return-1};
},{}],13:[function(require,module,exports){
"use strict";var hasOwn=Object.prototype.hasOwnProperty,toStr=Object.prototype.toString,isArray=function(t){return"function"==typeof Array.isArray?Array.isArray(t):"[object Array]"===toStr.call(t)},isPlainObject=function(t){if(!t||"[object Object]"!==toStr.call(t))return!1;var r=hasOwn.call(t,"constructor"),o=t.constructor&&t.constructor.prototype&&hasOwn.call(t.constructor.prototype,"isPrototypeOf");if(t.constructor&&!r&&!o)return!1;var n;for(n in t);return"undefined"==typeof n||hasOwn.call(t,n)};module.exports=function t(){var r,o,n,e,a,c,i=arguments[0],s=1,u=arguments.length,f=!1;for("boolean"==typeof i?(f=i,i=arguments[1]||{},s=2):("object"!=typeof i&&"function"!=typeof i||null==i)&&(i={});u>s;++s)if(r=arguments[s],null!=r)for(o in r)n=i[o],e=r[o],i!==e&&(f&&e&&(isPlainObject(e)||(a=isArray(e)))?(a?(a=!1,c=n&&isArray(n)?n:[]):c=n&&isPlainObject(n)?n:{},i[o]=t(f,c,e)):"undefined"!=typeof e&&(i[o]=e));return i};
},{}],14:[function(require,module,exports){
"use strict";module.exports=function(e,r){var o;return 0===r&&"zero"in e&&(o="zero"),o=o||(1===r?"one":"other"),e[o]};
},{}],15:[function(require,module,exports){
var sprintf=function(){function r(r){return Object.prototype.toString.call(r).slice(8,-1).toLowerCase()}function e(r,e){for(var t=[];e>0;t[--e]=r);return t.join("")}var t=function(){return t.cache.hasOwnProperty(arguments[0])||(t.cache[arguments[0]]=t.parse(arguments[0])),t.format.call(null,t.cache[arguments[0]],arguments)};return t.object_stringify=function(r,e,n,s){var i="";if(null!=r)switch(typeof r){case"function":return"[Function"+(r.name?": "+r.name:"")+"]";case"object":if(r instanceof Error)return"["+r.toString()+"]";if(e>=n)return"[Object]";if(s&&(s=s.slice(0),s.push(r)),null!=r.length){i+="[";var a=[];for(var o in r)s&&s.indexOf(r[o])>=0?a.push("[Circular]"):a.push(t.object_stringify(r[o],e+1,n,s));i+=a.join(", ")+"]"}else{if("getMonth"in r)return"Date("+r+")";i+="{";var a=[];for(var f in r)r.hasOwnProperty(f)&&(s&&s.indexOf(r[f])>=0?a.push(f+": [Circular]"):a.push(f+": "+t.object_stringify(r[f],e+1,n,s)));i+=a.join(", ")+"}"}return i;case"string":return'"'+r+'"'}return""+r},t.format=function(n,s){var i,a,o,f,u,c,p,l=1,h=n.length,g="",b=[];for(a=0;h>a;a++)if(g=r(n[a]),"string"===g)b.push(n[a]);else if("array"===g){if(f=n[a],f[2])for(i=s[l],o=0;o<f[2].length;o++){if(!i.hasOwnProperty(f[2][o]))throw new Error(sprintf('[sprintf] property "%s" does not exist',f[2][o]));i=i[f[2][o]]}else i=f[1]?s[f[1]]:s[l++];if(/[^sO]/.test(f[8])&&"number"!=r(i))throw new Error(sprintf('[sprintf] expecting number but found %s "'+i+'"',r(i)));switch(f[8]){case"b":i=i.toString(2);break;case"c":i=String.fromCharCode(i);break;case"d":i=parseInt(i,10);break;case"e":i=f[7]?i.toExponential(f[7]):i.toExponential();break;case"f":i=f[7]?parseFloat(i).toFixed(f[7]):parseFloat(i);break;case"O":i=t.object_stringify(i,0,parseInt(f[7])||5);break;case"o":i=i.toString(8);break;case"s":i=(i=String(i))&&f[7]?i.substring(0,f[7]):i;break;case"u":i=Math.abs(i);break;case"x":i=i.toString(16);break;case"X":i=i.toString(16).toUpperCase()}i=/[def]/.test(f[8])&&f[3]&&i>=0?"+"+i:i,c=f[4]?"0"==f[4]?"0":f[4].charAt(1):" ",p=f[6]-String(i).length,u=f[6]?e(c,p):"",b.push(f[5]?i+u:u+i)}return b.join("")},t.cache={},t.parse=function(r){for(var e=r,t=[],n=[],s=0;e;){if(null!==(t=/^[^\x25]+/.exec(e)))n.push(t[0]);else if(null!==(t=/^\x25{2}/.exec(e)))n.push("%");else{if(null===(t=/^\x25(?:([1-9]\d*)\$|\(([^\)]+)\))?(\+)?(0|'[^$])?(-)?(\d+)?(?:\.(\d+))?([b-fosOuxX])/.exec(e)))throw new Error("[sprintf] "+e);if(t[2]){s|=1;var i=[],a=t[2],o=[];if(null===(o=/^([a-z_][a-z_\d]*)/i.exec(a)))throw new Error("[sprintf] "+a);for(i.push(o[1]);""!==(a=a.substring(o[0].length));)if(null!==(o=/^\.([a-z_][a-z_\d]*)/i.exec(a)))i.push(o[1]);else{if(null===(o=/^\[(\d+)\]/.exec(a)))throw new Error("[sprintf] "+a);i.push(o[1])}t[2]=i}else s|=2;if(3===s)throw new Error("[sprintf] mixing positional and named placeholders is not (yet) supported");n.push(t)}e=e.substring(t[0].length)}return n},t}(),vsprintf=function(r,e){var t=e.slice();return t.unshift(r),sprintf.apply(null,t)};module.exports=sprintf,sprintf.sprintf=sprintf,sprintf.vsprintf=vsprintf;
},{}],16:[function(require,module,exports){
"use strict";function strftime(e,r,t){var a=e.getTime();return t=t||dateNames,r.replace(/%([-_0]?.)/g,function(r,n){var s=null;if(2==n.length){switch(n[0]){case"-":s="";break;case"_":s=" ";break;case"0":s="0";break;default:return r}n=n[1]}switch(n){case"A":return t.days[e.getDay()];case"a":return t.abbreviated_days[e.getDay()];case"B":return t.months[e.getMonth()];case"b":return t.abbreviated_months[e.getMonth()];case"C":return pad(Math.floor(e.getFullYear()/100),s);case"D":return strftime(e,"%m/%d/%y");case"d":return pad(e.getDate(),s);case"e":return e.getDate();case"F":return strftime(e,"%Y-%m-%d");case"H":return pad(e.getHours(),s);case"h":return t.abbreviated_months[e.getMonth()];case"I":return pad(hours12(e),s);case"j":return pad(Math.ceil((e.getTime()-new Date(e.getFullYear(),0,1).getTime())/864e5),3);case"k":return pad(e.getHours(),null===s?" ":s);case"L":return pad(Math.floor(a%1e3),3);case"l":return pad(hours12(e),null===s?" ":s);case"M":return pad(e.getMinutes(),s);case"m":return pad(e.getMonth()+1,s);case"n":return"\n";case"o":return String(e.getDate())+ordinal(e.getDate());case"P":return e.getHours()<12?t.am.toLowerCase():t.pm.toLowerCase();case"p":return e.getHours()<12?t.am.toUpperCase():t.pm.toUpperCase();case"R":return strftime(e,"%H:%M");case"r":return strftime(e,"%I:%M:%S %p");case"S":return pad(e.getSeconds(),s);case"s":return Math.floor(a/1e3);case"T":return strftime(e,"%H:%M:%S");case"t":return"	";case"U":return pad(weekNumber(e,"sunday"),s);case"u":return 0===e.getDay()?7:e.getDay();case"v":return strftime(e,"%e-%b-%Y");case"W":return pad(weekNumber(e,"monday"),s);case"w":return e.getDay();case"Y":return e.getFullYear();case"y":var u=String(e.getFullYear());return u.slice(u.length-2);case"Z":var c=e.toString().match(/\((\w+)\)/);return c&&c[1]||"";case"z":var o=e.getTimezoneOffset();return(o>0?"-":"+")+pad(Math.round(Math.abs(o/60)),2)+":"+pad(o%60,2);default:return n}})}function pad(e,r,t){"number"==typeof r&&(t=r,r="0"),null===r&&(r="0"),t=t||2;var a=String(e);if(r)for(;a.length<t;)a=r+a;return a}function hours12(e){var r=e.getHours();return 0===r?r=12:r>12&&(r-=12),r}function ordinal(e){var r=e%10,t=e%100;if(t>=11&&13>=t||0===r||r>=4)return"th";switch(r){case 1:return"st";case 2:return"nd";case 3:return"rd"}}function weekNumber(e,r){r=r||"sunday";var t=e.getDay();"monday"==r&&(0===t?t=6:t--);var a=new Date(e.getFullYear(),0,1),n=(e-a)/864e5,s=(n+7-t)/7;return Math.floor(s)}var dateNames=require("date-names");module.exports=strftime;
},{"date-names":10}],17:[function(require,module,exports){
"use strict";var translate=require("counterpart");translate.setSeparator("*");var translation='{\n    "Back to coin.space": "Terug naar coin.space",\n    "Create new wallet": "Maak nieuwe portemonnee",\n    "Open existing wallet": "Open bestaande portemonnee",\n    "We are about to generate your very own passphrase": "We staan ​​op het punt om uw eigen wachtwoordzin te genereren",\n    "This keeps your account secure, and lets you open your wallet on multiple devices.": "Dit houdt uw account veilig en zorgt ervoor dat u uw portemonnee op meerdere apparaten kunt openen.",\n    "It is very important you write this down.": "Het is erg belangrijk om dit op te schrijven.",\n    "Generate passphrase": "Genereer wachtwoordzin",\n    "Go back": "Ga terug",\n    "Generating": "Generen",\n    "Decoding passphrase": "Decoding passphrase",\n    "Synchronizing Wallet": "Synchroniseren van de portemonnee",\n    "Set your PIN": "Stel uw pincode in",\n    "Your passphrase": "Uw wachtwoordzin",\n    "Your passphrase will not be shown again.": "Uw wachtwoordzin zal niet meer worden weergeven.",\n    "Without it you will lose access to your wallet.": "Zonder deze zin verlies je de toegang tot je portemonnee. ",\n    "I have written down or otherwise securely stored my passphrase": "Ik heb mijn wachtwoordzin opgeschreven of anderszins veilig opgeslagen.",\n    "Open wallet": "Portemonnee openen",\n    "Checking passphrase": "Controleren van de wachtwoordzin",\n    "Enter Passphrase": "Voer je wachtwoordzin in",\n    "Invalid passphrase": "Incorrecte wachtwoordzin",\n    "Enter your PIN": "Voer je Pincode in",\n    "Set a PIN for quick access": "Stel een Pincode in voor snelle toegang",\n    "Review passphrase again": "Bekijk uw wachtwoordzin opnieuw",\n    "Open a different wallet": "Open een andere portemonnee",\n    "Forgot PIN": "Forgot PIN",\n    "PIN must be a 4-digit number": "Je pincode moet een 4-cijferig getal zijn",\n    "Verifying PIN": "Pincode verifiëren",\n    "Setting PIN": "Pincode instellen",\n    "This might take some time,": "Dit kan even duren,",\n    "please be patient.": "wees a.u.b. geduldig.",\n    "Your PIN is incorrect": "Uw pincode is onjuist. ",\n    "Request timeout. Please check your internet connection.": "Verzoek time-out. Controleer uw internetverbinding.",\n    "Could not save your details": "Kon uw gegevens niet opslaan",\n    "We could not connect you to Mecto, please check your internet connection.": "We konden geen verbinding maken met Mecto, controleer alstublieft uw internetverbinding.",\n    "Please enter a valid address to send to": "Vul alsjeblieft een geldig adres in om iets naar te versturen",\n    "Please enter an amount above": "Vul een bedrag in boven %(dust)s",\n    "Some funds are temporarily unavailable. To send this transaction, you will need to wait for your pending transactions to be confirmed first (this should not take more than a few minutes).": "Een gedeelte van uw geld is tijdelijk niet beschikbaar. Om deze transactie te versturen, moet u eerst wachten totdat de nog niet bevestigde transacties bevestigd zijn (dit zou niet meer dan een paar minuten mogen duren).",\n    "What does this mean?": "Wat betekent dit?",\n    "It seems like you are trying to empty your wallet. Taking transaction fee into account, we estimated that the max amount you can send is. We have amended the value in the amount field for you": "Het lijkt erop dat u een portemonnee probeert leeg te maken. Als men rekening houdt met de transactiekosten, schatten we dat het maximale bedrag dat u kunt versturen %(sendableBalance)s is. We hebben deze waarde voor u ingesteld.",\n    "You do not have enough funds in your wallet": "U hebt niet genoeg geld in uw portemonnee",\n    "A name is required to set your profile on Coin Space": "Een naam is vereist om uw profiel in te stellen op Coin Space",\n    "Uh Oh...": "Uh Oh...",\n    "Whoops!": "Oeps!",\n    "Just saying...": "Just saying...",\n    "Your browser does not support geolocation": "Uw browser ondersteunt geen geolocatie",\n    "Unable to retrieve your location": "We kunnen uw locatie niet vaststellen",\n    "Without a name, the payer would not be able to identify you on Mecto.": "Zonder een naam kan de betaler u niet identificeren op Mecto.",\n    "cannot be blank": "%(blankField)s kan niet leeg zijn",\n    "name": "naam",\n    "email": "email",\n    "description": "beschrijving",\n    "Change your details": "Wijzig uw gegevens",\n    "Your username": "Uw gebruikersnaam",\n    "Gravatar email": "Gravatar email",\n    "Submit": "Versturen",\n    "Gravatar (globally recognised avatar) is a service that lets you re-use the same avatar across websites and apps by specifying an email address.": "Gravatar (wereldwijd erkende avatar) is een service waarmee u opnieuw gebruik kunt maken van dezelfde avatar op websites en apps door middel van het opgeven van een e-mailadres.",\n    "Create a gravatar": "Maak een gravatar",\n    "Logout": "Uitloggen",\n    "Support": "Ondersteuning  ",\n    "Send": "Versturen",\n    "Receive": "Ontvangen",\n    "History": "Geschiedenis",\n    "Tokens": "Tokens",\n    "Mecto lets you broadcast your wallet address to other nearby Coin Space users by comparing GPS data. This data is deleted once you turn Mecto off.": "Mecto zorgt ervoor dat u uw portemonnee adres naar andere nabijgelegen Coin Space gebruikers kunt versturen. Dit gebeurt door GPS-gegevens te vergelijken. Deze gegevens worden verwijderd zodra u Mecto uitschakeld. ",\n    "Having problems?": "Heeft u problemen?",\n    "Description": "Omschrijving",\n    "Your email address": "Uw email adres",\n    "Nevermind": "Laat maar",\n    "Before you start using Mecto, you need to enter a name that will help others identify you.": "Voordat u Mecto kunt gebruiken moet u een naam opgeven waarmee anderen u kunnen identificeren.\\n",\n    "Save": "Opslaan",\n    "Loading transactions...": "Loading transactions...",\n    "Your transaction history": "Uw transactie geschiedenis",\n    "pending confirmation": "in afwachting van een bevestiging",\n    "Received": "Ontvangen",\n    "You do not have any transactions yet": "Je hebt nog geen transacties",\n    "Transaction Id:": "Transactie ID:",\n    "Transaction Fee:": "Transaction Fee:",\n    "Inputs:": "Inputs:",\n    "Outputs:": "Outputs:",\n    "Sent to:": "Verstuurd naar:",\n    "Your wallet address": "Uw portemonnee adres",\n    "Mecto": "Mecto",\n    "Turn Mecto on": "Schakel Mecto in",\n    "Turn Mecto off": "Schakel Mecto uit",\n    "Checking your location": "Controleren van uw locatie",\n    "Broadcasting your location...": "Uitzenden van uw locatie...",\n    "Wallet address": "Portemonnee adres",\n    "Amount": "Hoeveelheid",\n    "Exchange rate unavailable for the selected currency": "Wisselkoers niet beschikbaar voor de geselecteerde valuta",\n    "Confirm": "Bevestig",\n    "No Coin Space users found nearby": "Geen Coin Space gebruikers in de buurt gevonden",\n    "Search Again": "Opnieuw zoeken",\n    "Searching...": "Searching...",\n    "Searching your area for other Coin Space users": "Bezig met het doorzoeken van uw gebied voor andere Coin Space gebruikers",\n    "Confirm transaction": "Bevestig transactie",\n    "transaction fee": "transactiekosten",\n    "Cancel": "Annuleren",\n    "Transaction Successful": "Transactie Succesvol",\n    "Your transaction will appear in your history tab shortly.": "Uw transactie zal binnenkort verschijnen in uw geschiedenis tab. ",\n    "Close": "Sluiten",\n    "Report": "Report",\n    "Transaction Failed": "Transactie is mislukt",\n    "Please make sure you are connected to the internet.": "Zorg ervoor dat u verbonden bent met het internet.",\n    "Please describe what happened above. Below are network error logs that could help us identify your issue.": "Please describe what happened above. Below are network error logs that could help us identify your issue.",\n    "Sorry, Coin Space Wallet did not load.": "Sorry, Coin Space Wallet kon niet worden geladen.",\n    "Try updating your browser, or switching out of private browsing mode. If all else fails, download Chrome for your device.": "Probeer uw browser bij te werken, of schakel de private browsing mode uit. Als niets lukt, download dan Chrome voor uw apparaat.",\n    "Send this Passphrase to my phone": "Deze Passphrase naar mijn telefoon verzenden",\n    "Enter mobile number": "Voer mobiele nummer",\n    "Current Bitcoin Price": "Huidige Bitcoin prijs",\n    "Your Alias address": "Uw Alias adres",\n    "Username not available": "Gebruikersnaam niet beschikbaar",\n    "Allow for payments with OpenAlias addresses. Supported wallets only.": "Voor betalingen met OpenAlias adressen toestaan. Alleen ondersteunde portefeuilles.",\n    "Enter PIN": "Voer PIN",\n    "Scan your fingerprint please": "Scan uw vingerafdruk aub",\n    "I Agree To The Terms & Conditions": "I Agree To The Terms & Conditions",\n    "Terms of Use": "Terms of Use"\n}';translate.registerTranslations("nl",JSON.parse(translation)),translate.setLocale("nl");var languages=["cs-cz.json","de.json","en.json","es.json","fil.json","fr.json","hu.json","id.json","it.json","ja.json","nb.json","nl.json","pl.json","ru.json","sr-latn-rs.json","sr.json","th.json","uk.json","zh-cn.json"].map(function(e){return e.replace(".json","")});module.exports={translate:translate,languages:languages};
},{"counterpart":7}]},{},[1]);
