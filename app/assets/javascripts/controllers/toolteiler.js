APP.controllers.toolteiler = (function() {

    function init() {
      if ($("section.toolTeiler").exists()) {
        initToolteilerDetail();
      }
    }

    function initToolteilerDetail() {
      $('.datepicker').pickadate({
        formatSubmit: 'yyyy-mm-dd',
        hiddenName: true,
        format: 'ddd, dd mmm, yyyy',
      });
    }

    return {
      init: init
    };

})();
