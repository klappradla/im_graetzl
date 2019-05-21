APP.controllers.toolteiler = (function() {

    function init() {
      if ($("section.toolTeiler").exists()) {
        initToolteilerDetail();
      }
    }

    function initToolteilerDetail() {

      $('.starts_at_date').pickadate({
        formatSubmit: 'yyyy-mm-dd',
        hiddenName: true,
        format: 'ddd, dd mmm, yyyy',
        onSet: function(context) {
          if (typeof context.select !== "undefined") {
            var d = moment(context.select).locale('de').format('l');
            console.log(d);
          }

        }
      });

      $('.ends_at_date').pickadate({
        formatSubmit: 'yyyy-mm-dd',
        hiddenName: true,
        format: 'ddd, dd mmm, yyyy',
        //disable: [
          //{ from: -365, to: request_start_date }
        //]
      });
      
    }

    return {
      init: init
    };

})();
