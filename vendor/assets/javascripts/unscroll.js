// UMD wrapper from https://github.com/umdjs/umd
(function (root, factory) {
  if (typeof define === 'function' && define.amd) {
    define([], factory);
  } else if (typeof module === 'object' && module.exports) {
    module.exports = factory();
  } else {
    root.unscroll = factory();
  }
}(typeof self !== 'undefined' ? self : this, function () {

  // Main function to remove scrollbar and adjust elements
  function unscroll(elements) {

    // Store reusable vars
    this.set = function (id, value) {
      if (!window.unscrollStore) {
        window.unscrollStore = {};
      }
      window.unscrollStore[id] = value;
    };

    // Get reusable vars
    this.get = function (id) {
      return window.unscrollStore ? window.unscrollStore[id] : null;
    };

    // Get the width of the scroll bar in pixel
    this.getScrollbarWidth = function () {
      if (this.get('scrollbarWidth')) {
        return this.get('scrollbarWidth') + 'px';
      }
      var scrollElement = document.createElement('div');
      scrollElement.style.width = '100px';
      scrollElement.style.height = '100px';
      scrollElement.style.overflow = 'scroll';
      scrollElement.style.position = 'absolute';
      scrollElement.style.top = '-10000';

      document.body.appendChild(scrollElement);
      var scrollbarWidth = scrollElement.offsetWidth - scrollElement.clientWidth;
      document.body.removeChild(scrollElement);

      this.set('scrollbarWidth', scrollbarWidth);
      return scrollbarWidth + 'px';
    }

    // Add unscroll class to head
    function addUnscrollClassName() {
      if (document.getElementById('unscroll-class-name')) {
        return;
      }
      var css = '.unscrollable { overflow: hidden !important; }';
      var head = document.head || document.getElementsByTagName('head')[0];
      var style = document.createElement('style');
      style.type = 'text/css';
      style.setAttribute('id', 'unscroll-class-name');
      style.appendChild(document.createTextNode(css));
      head.appendChild(style);
    }

    // Get the elements to adjust, force body element
    this.getElementsToAdjust = function (elements) {
      !elements && (elements = []);

      if (typeof elements === 'string') {
        elements = [
          [elements, 'padding-right']
        ];
      }

      elements.forEach(function (element, index) {
        if (typeof element === 'string') {
          elements[index] = [element, 'padding-right'];
        }
      });

      var bodyFound = false;
      for (var i = 0; i < elements.length; i++) {
        if (elements[i][0].indexOf('body') !== -1) {
          bodyFound = true;
        }
      };

      if (bodyFound === false) {
        elements.push(['body', 'padding-right']);
      }

      return elements;
    }

    this.pageHasScrollbar = function () {
      return this.getScrollbarWidth() && document.body.offsetHeight > window.innerHeight;
    }

    // Clean up elements
    if (this.pageHasScrollbar()) {
      elements = this.getElementsToAdjust(elements);

      // Loop through elements and adjust accordingly
      for (var i = 0; i < elements.length; i++) {
        var elementsDOM = document.querySelectorAll(elements[i][0]);
        for (var j = 0; j < elementsDOM.length; j++) {
          if (elementsDOM[j].getAttribute('data-unscroll')) {
            return;
          }
          var attribute = elements[i][1];
          var computedStyles = window.getComputedStyle(elementsDOM[j]);
          var computedStyle = computedStyles.getPropertyValue(attribute);
          elementsDOM[j].setAttribute('data-unscroll', attribute);
          if (!computedStyle) {
            computedStyle = '0px';
          }
          var operator = attribute == 'padding-right' || attribute == 'right' ? '+' : '-';
          elementsDOM[j].style[attribute] = 'calc(' + computedStyle + ' ' + operator + ' ' + this.getScrollbarWidth() + ')';
        }
      }
    }

    // Make the page unscrollable
    addUnscrollClassName();
    document.body.classList.add('unscrollable');
  }

  // Reset elements and make page scrollable again
  unscroll.reset = function () {
    var elements = document.querySelectorAll('[data-unscroll]');

    for (var i = 0; i < elements.length; i++) {
      var attribute = elements[i].getAttribute('data-unscroll');
      elements[i].style[attribute] = null;
      elements[i].removeAttribute('data-unscroll');
    }
    document.body.classList.remove('unscrollable');
  }

  return unscroll;
}));
