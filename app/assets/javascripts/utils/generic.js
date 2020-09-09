APP.utils = (function() {

    /**
     * @return {boolean}
     */
    function URLcontains(find) {
        return document.URL.indexOf(find) !== -1;
    }

    /**
     * @return {boolean}
     */
    function URLendsWith(suffix) {
        var str = document.URL;
        return str.indexOf(suffix, str.length - suffix.length) !== -1;
    }

    function isLoggedIn() {
        return $("body").hasClass("signed-in");
    }

    return {
        URLcontains: URLcontains,
        URLendsWith: URLendsWith,
        isLoggedIn: isLoggedIn
    }

})();


//micro jQuery plugin to check if a given element exists
$.fn.exists = function(){
    return this.length;
};
