APP.controllers.room_rentals = (function() {

    function init() {
      if ($(".room-rental-page.login-screen").exists()) {
        initLoginScreen();
      } else if ($(".room-rental-page.date-screen").exists()) {
        initDateScreen();
      } else if ($(".room-rental-page.address-screen").exists()) {
        initAddressScreen();
      } else if ($(".room-rental-page.payment-screen").exists()) {
        initPaymentScreen();
      } else if ($(".room-rental-page.summary-screen").exists()) {
        initSummaryScreen();
      }
    }

    function initLoginScreen() {
      // Change Wording of Notice Message for RoomRental Registrations
      if ($("#flash .notice").exists()) {
        var flashText = $("#flash .notice").text();
        if (flashText.indexOf('Super, du bist nun registriert!') >= 0){
          // Modifiy Message for RoomRental Registrations
          $("#flash .notice").text(flashText + ' Danach gehts weiter mit deiner Raumbuchungs-Anfrage.');
        }
      }
    }

    function initDateScreen() {
      setTab('step1');

      var dateInput = $('.rental-date-form');
      var days = dateInput.data("days");
      var disabledDays = [true].concat(days);

      $('.date-screen').on('cocoon:after-insert', function(e, insertedItem) {
        $(insertedItem).find('.datepicker').pickadate({
          hiddenName: true,
          min: true,
          formatSubmit: 'yyyy-mm-dd',
          format: 'ddd, dd mmm, yyyy',
          disable: disabledDays,
          onClose: function() {
            $(document.activeElement).blur();
          },
          // Insert Legend (improve ...)
          onRender: function() {
            $(".rental-date-form .picker__box").append( "<div class='picker__legend'><div class='legend_not_availiable'></div><small class='legend_text'> ... an diesen Tagen nicht verfügbar</small></div>" );
          }
        });
      });

      $('.date-screen .datepicker').each(function(i, input) {
        $(input).pickadate({
          hiddenName: true,
          min: true,
          formatSubmit: 'yyyy-mm-dd',
          format: 'ddd, dd mmm, yyyy',
          disable: disabledDays,
          onClose: function() {
            $(document.activeElement).blur();
          },
          // Insert Legend (improve ...)
          onRender: function() {
            $(".rental-date-form .picker__box").append( "<div class='picker__legend'><div class='legend_not_availiable'></div><small class='legend_text'> ... an diesen Tagen nicht verfügbar</small></div>" );
          }
        });
        // pickadate needs help with setting initial value
        $(input).pickadate('picker').set('select', $(input).val(), { format: 'yyyy-mm-dd' });
      });

      $('.date-screen').on('change', '.datepicker', function() {
        $(this).parents(".date-fields").find('.hour-input').attr("disabled", !$(this).val());
      });

      $('.date-screen').on('change', '.datepicker, .hour-from', function() {
        var fieldRow = $(this).parents(".date-fields");
        var hoursUrl = fieldRow.data('hours-url');
        var currentDate = fieldRow.find(".datepicker").pickadate('picker').get('select', 'yyyy-mm-dd');
        var hourFrom = fieldRow.find(".hour-input.hour-from").val();

        $.get(hoursUrl, {rent_date: currentDate, hour_from: hourFrom}, function(data) {
          fieldRow.find(".hour-input.hour-from option").not(':empty').each(function(i, o) {
            var hour = +$(o).val();
            $(o).attr("disabled", data.from.indexOf(hour) == -1);
          });
          fieldRow.find(".hour-input.hour-to option").not(':empty').each(function(i, o) {
            var hour = +$(o).val();
            $(o).attr("disabled", data.to.indexOf(hour) == -1);
          });
        });
      });

      $('.date-screen .datepicker').change();

      $('.date-screen').on('change', '.hour-input', function() {
        $(this).parents('form').submit();
      });

      $('.date-screen').on('cocoon:after-remove', function() {
        $('.rental-date-form').submit();
      });

      $('.date-screen .next-page').on('click', function() {
        location.href = $(this).attr("href") + "?" + $(".rental-date-form").serialize();
        return false;
      });

      // Change Wording of Notice Message for RoomRental Registrations
      if ($("#flash .notice").exists()) {
        var flashText = $("#flash .notice").text();
        if (flashText.indexOf('Vielen Dank für Deine Registrierung.') >= 0){
          // Modifiy Message for RoomRental Registrations
          $("#flash .notice").text('Vielen Dank für Deine Registrierung. Du bist jetzt angemeldet und kannst mit deiner Raumbuchungs-Anfrage fortfahren..');
        }
      }

    }

    function initAddressScreen() {
      setTab('step2');
    }

    function initPaymentScreen() {
      setTab('step3');

      var screen = $(".room-rental-page.payment-screen");
        screen.find(".paymentMethods input").on("click", function() {
        screen.find(".payment-method-container").hide();
        screen.find("." + $(this).val() + "-container").show();
      });

      screen.find(".paymentMethods input:checked").click();

      initCardPayment();
      initEpsPayment();
      initKlarnaPayment();
    }

    function initCardPayment() {
      var cardForm = $(".card-container .card-form");
      APP.components.paymentCard.init(cardForm);
      cardForm.on('payment:complete', function() {
        location.href = $(this).data('success-url');
      });
    }

    function initEpsPayment() {
      var epsForm = $(".eps-container .eps-form");
      APP.components.paymentEps.init(epsForm);
    }

    function initKlarnaPayment() {
      var container = $(".klarna-container");
      var nextButton = container.find(".next-screen");

      container.find(".klarna-source-form").on("ajax:success", function(e, data) {
        location.href = data.redirect_url;
      });

      if ($('#klarna-payment-success').exists()) {
        $(".next-step-form").submit();
      }
    }

    function showFormError(container, error) {
      container.find(".error-message").text(error);
    }

    function hideFormError(container) {
      container.find(".error-message").text("");
    }


    function initSummaryScreen() {

      setTab('step4');

    }


    function openTab(tab) {
      $('.tabs-ctrl').trigger('show', '#tab-' + tab);
      $('.tabs-ctrl').get(0).scrollIntoView();
    }

    function setTab(tab) {
      $('.tabs-ctrl li').removeClass('active');
      $('.tabs-ctrl li#'+tab).addClass('active');
    }

    return {
      init: init
    };

})();
