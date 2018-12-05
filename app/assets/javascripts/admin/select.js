//= require jquery.sumoselect

$(document).ready(function() {
  $('select.admin-filter-select').SumoSelect({
    search: true,
    csvDispCount: 5
  });

  $(document).on('has_many_add:after', '.has_many_container', function() {
    $(this).find('select.admin-filter-select').SumoSelect({
      search: true,
      csvDispCount: 5
    });
  });
});
