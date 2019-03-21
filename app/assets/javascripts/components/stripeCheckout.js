APP.components.stripeCheckout = (function() {

  function init() {
    if($('#stripeForm').exists()) initStripe();
    if($('#stripePlan').exists()) initPlan();
  }

  function initPlan() {
    $('select#stripePlan').on('change', function() {
      var stripePlan = $(this).find(":selected").text();
      var stripeDescription = $('#stripeForm #stripeDescription').val();
      stripeDescription += ': ' + stripePlan + ' / Monat';
      $('#stripeForm #stripeDescription').val(stripeDescription);
    });
  }

  function initStripe() {

    var handler = StripeCheckout.configure({
      key: $('#stripeForm #publishable_key').val(),
      locale: 'de',
      currency: 'eur',
      allowRememberMe: false,
      name: 'imGrätzl.at',
      description: $('#stripeForm #stripeDescription').val(),
      email: $('#stripeForm #stripeEmail').val(),
      //billingAddress: $('#stripeForm #stripeBillingAddress').val(),
      token: function(response) {
        // Get Stripe response infos and pass to hidden form fields
        $('#stripeForm #stripeToken').val(response.id);
        $('#stripeForm #stripeEmail').val(response.email);
        $('#stripeForm').submit();
      }
    });

    // Submit Stripe Form
    $('.stripe-submit').on('click', function(e) {
      e.preventDefault();

      var email = $('#stripeForm #stripeEmail').val();
      var amount = $('#stripeForm #amount').val();
      amount = amount.replace(/,/g, '.');
      amount = amount.replace(/\$/g, '').replace(/\,/g, '');
      amount = parseFloat(amount);

      if (isNaN(amount)) {
        $('#flash').html('<p>Bitte gib einen gültigen Betrag (€) ein.</p>').show();
        document.location.href = '#';
      } else if (amount < 3.00) {
        $('#flash').html('<p>Der Betrag muss mindestens 3 € betragen.</p>').show();
        document.location.href = '#';
      } else if (email == '') {
        $('#flash').html('<p>Bitte gib deine E-Mail Adresse an.</p>').show();
        document.location.href = '#';
      } else {
        $('#flash').hide();
        amount = amount * 100; // Needs to be an integer!
        handler.open({
          amount: Math.round(amount),
          email: $('#stripeForm #stripeEmail').val(),
        })
      }
    });

    // Submit Subscription Stripe Form
    $('.stripe-submit-subscription').on('click', function(e) {
      e.preventDefault();

      if ($('select#stripePlan :selected').val() == '') {
        $('#flash').html('<p>Bitte wähle einen monatlichen Betrag aus.</p>').show();
        document.location.href = '#';
      } else {
        handler.open({
          panelLabel: "Jetzt untertsützen",
          email: $('#stripeForm #stripeEmail').val(),
          description: $('#stripeForm #stripeDescription').val(),
        });
      }
    });

    // Close Checkout on page navigation
    $(window).on('popstate', function() {
      handler.close();
    });

  }

  return {
    init: init
  };

})();
