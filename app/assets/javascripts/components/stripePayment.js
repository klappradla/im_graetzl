APP.components.stripePayment = (function() {

  function init() {
    if($('#stripeForm').exists()) initForm();
    if($('#stripeForm #payment_method_card').exists()) initStripeCheckout();
    if($('#stripeForm #payment_method_sofort').exists()) initStripeSofort();
    if($('#stripeForm #payment_method_sepa').exists()) initStripeSepa();
    if($('.payment-processing').exists()) initStripePaymentPolling();
  }

  function urldecode(str) {
    return decodeURIComponent((str+'').replace(/\+/g, '%20'));
  }

  function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    return vars;
  }

  var amount;
  var name;
  var email;
  var message;
  var form;
  var host = window.location.protocol +'//'+ window.location.host;
  var stripeCompany;
  var stripeAddressName;
  var stripeAddress;
  var stripePostalCode;
  var stripeCity;

  function initForm() {
    // onFocusOut -> Abrunden auf ganzen Betrag, wenn Zahl.
    $('#amount').focusout(function(){
      amount = cleanUpAmount(this.value);
      if (!isNaN(amount)) {
        $(this).val(amount + ',00'); // Display correct Amount
        // Set Amount Value in Pay Buttons
        $('.-amount').each(function(index, obj) {
          $(obj).text('€ ' + amount + ',00 - ');
          $(obj).show();
        });
      } else {
        $('.-amount').each(function(index, obj) {
          $(obj).hide();
        });
      }
    });

    // Set Stripe Description for selected Plan (Subscription)
    $('select#stripePlan').on('change', function() {
      var stripePlan = $(this).find(":selected").text();
      var stripeDescription = $('#stripeForm #stripeDescription').val();
      stripeDescription += ': ' + stripePlan + ' / Monat';
      $('#stripeForm #stripeDescription').val(stripeDescription);
    });

  }

  // Function for CleanUp Amount - Check ob Zahl und Abrunden auf ganzen Betrag
  function cleanUpAmount(amount) {
    amount = amount.replace(/,/g, '.');
    amount = amount.replace(/\$/g, '').replace(/\,/g, '');
    amount = parseFloat(amount);
    amount = Math.floor(amount); // Abrunden auf ganzen Betrag
    return amount;
  }

  // Function for Form Error Handling (Amount, Name, E-Mail)
  var checkFormInputs = function() {
    email = $('#stripeForm #stripeEmail').val();
    name = $('#stripeForm #stripeName').val();
    amount = $('#stripeForm #amount').val();
    amount = cleanUpAmount(amount); // Abrunden auf ganzen Betrag

    // Error Improvement - Set Field Color and Message in Placeholder
    //$('#stripeForm #stripeName').attr("placeholder", "Error Message");

    if (isNaN(amount)) {
      $('#flash').html('<p>Bitte gib einen gültigen Betrag (€) ein.</p>').show();
      document.location.href = '#';
    } else if (amount < 3.00) {
      $('#flash').html('<p>Der Betrag muss mindestens 3 € betragen.</p>').show();
      document.location.href = '#';
    } else if (name == '') {
      $('#flash').html('<p>Bitte gib deinen Vor- & Nachname an.</p>').show();
      document.location.href = '#';
    } else if (email == '') {
      $('#flash').html('<p>Bitte gib deine E-Mail Adresse an.</p>').show();
      document.location.href = '#';
    } else {
      $('#flash').hide();
      return true;
    }
  }

  // Stripe SOFORT Überweisung
  function initStripeSofort() {

    var stripe = Stripe($('#stripeForm #publishable_key').val());
    var errorMessage = document.getElementById('sofort-error-message');

    // Stripe SEPA Submission
    $('.stripe-submit-sofort').on('click', function(event) {

      event.preventDefault();
      //showLoading();

      amount = amount * 1; // Needs to be an integer!
      stripeAmount = amount * 100 // Integer in Cent for Stripe
      email = encodeURI($('#stripeForm #stripeEmail').val());
      name = encodeURI($('#stripeForm #stripeName').val());
      message = encodeURI($('#stripeForm #message').val());
      description = encodeURI($('#stripeForm #stripeDescription').val());
      form = $('#stripeForm').attr('action');

      var sourceData = {
        type: 'sofort',
        amount: Math.round(stripeAmount),
        currency: 'eur',
        redirect: {
          return_url: host + '/payment/processing?' +
          'amount=' + amount +
          '&stripeEmail=' + email +
          '&stripeName=' + name +
          '&stripeDescription=' + description +
          '&message=' + message +
          '&stripeForm=' + form +
          '&stripeToken=&stripeSource=',
        },
        sofort: {
          country: 'AT',
          preferred_language: 'de',
        },
        owner: {
          name: name,
        }
      };

      if (checkFormInputs() == true) {
        // Call `stripe.createSource` with the sourceData and additional options.
        stripe.createSource(sourceData).then(function(result) {
          if (result.error) {
            // Inform the customer that there was an error.
            errorMessage.textContent = result.error.message;
            errorMessage.classList.add('visible');
            //stopLoading();
          } else {
            // Send the Source to your server to create a charge.
            errorMessage.classList.remove('visible');
            console.log(result);
            window.location.replace(result.source.redirect.url);
          }
        });
      }

    });

  }

  // Stripe SEPA Elements
  function initStripeSepa() {

    // Init Stripe Elements
    var stripe = Stripe($('#stripeForm #publishable_key').val());
    var elements = stripe.elements();

    // Basic Style Infos for Stripe Elements
    var style = {
      base: {
        color: '#615454',
        fontSize: '1.2rem',
        fontFamily: '"Lato", sans-serif',
        fontSmoothing: 'antialiased',
        '::placeholder': {
          color: '#83C7BD',
          fontStyle: 'italic',
        },
      },
      invalid: {
        color: '#e5424d',
        ':focus': {
          color: '#303238',
        },
      },
    };

    // Create an instance of the iban Element.
    var iban = elements.create('iban', {
      style,
      supportedCountries: ['SEPA'],
      placeholderCountry: 'AT',
    });

    // Add an instance of the iban Element into the `iban-element` <div>.
    iban.mount('#iban-element');

    var errorMessage = document.getElementById('sepa-error-message');
    var bankName = document.getElementById('bank-name');

    iban.on('change', function(event) {
      // Handle real-time validation errors from the iban Element.
      if (event.error) {
        errorMessage.textContent = event.error.message;
        errorMessage.classList.add('visible');
      } else {
        errorMessage.classList.remove('visible');
      }

      // Display bank name corresponding to IBAN, if available.
      if (event.bankName) {
        bankName.textContent = event.bankName;
        bankName.classList.add('visible');
      } else {
        bankName.classList.remove('visible');
      }
    });

    // Stripe SEPA Submission
    $('.stripe-submit-sepa').on('click', function(event) {

      event.preventDefault();
      //showLoading();

      var sourceData = {
        type: 'sepa_debit',
        currency: 'eur',
        owner: {
          name: $('#stripeForm #stripeName').val(),
          email: $('#stripeForm #stripeEmail').val(),
        },
        mandate: {
          // Automatically send a mandate notification email to your customer
          // once the source is charged.
          notification_method: 'email',
        }
      };

      // Call `stripe.createSource` with the iban Element and additional options.
      stripe.createSource(iban, sourceData).then(function(result) {
        if (result.error) {
          // Inform the customer that there was an error.
          errorMessage.textContent = result.error.message;
          errorMessage.classList.add('visible');
          //stopLoading();
        } else {
          // Send the Source to your server to create a charge.
          errorMessage.classList.remove('visible');
          if (checkFormInputs() == true) {
            stripeSourceHandler(result.source);
          }
        }
      });
    });
  }

  function stripeSourceHandler(source) {
    $('#stripeForm #stripeSource').val(source.id);
    $('#stripeForm').submit();
  }

  function initStripeCheckout() {

    var stripeCheckoutHandler = StripeCheckout.configure({
      key: $('#stripeForm #publishable_key').val(),
      locale: 'de',
      currency: 'eur',
      allowRememberMe: false,
      name: 'imGrätzl.at',
      description: $('#stripeForm #stripeDescription').val(),
      email: $('#stripeForm #stripeEmail').val(),
      image: $('#stripeForm #stripeIcon').val(),
      token: function(response) {
        // Get Stripe response infos and pass to hidden form fields
        $('#stripeForm #stripeToken').val(response.id);
        $('#stripeForm #stripeEmail').val(response.email);
        $('#stripeForm').submit();
      }
    });

    // Submit Stripe Form - Card
    $('.stripe-submit-card').on('click', function(e) {
      e.preventDefault();
      if (checkFormInputs() == true) {
        amount = amount * 100; // Integer in Cent for Stripe
        stripeCheckoutHandler.open({
          amount: Math.round(amount),
          email: $('#stripeForm #stripeEmail').val(),
        })
      }
    });

    // Submit Stripe Form - Subscription
    $('.stripe-submit-subscription').on('click', function(e) {
      e.preventDefault();

      if ($('select#stripePlan :selected').val() == '') {
        $('#flash').html('<p>Bitte wähle einen monatlichen Betrag aus.</p>').show();
        document.location.href = '#';
      } else {
        stripeCheckoutHandler.open({
          panelLabel: "Jetzt untertsützen",
          email: $('#stripeForm #stripeEmail').val(),
          description: $('#stripeForm #stripeDescription').val(),
        });
      }
    });

    // Close Checkout on page navigation
    $(window).on('popstate', function() {
      stripeCheckoutHandler.close();
    });

  }

  function initStripePaymentPolling() {
    var stripe = Stripe($('#publishable_key').val());
    var client_secret = getUrlVars()["client_secret"];
    var source = getUrlVars()["source"];

    // After some amount of time, we should stop trying to resolve the order synchronously:
    var MAX_POLL_COUNT = 5;
    var pollCount = 0;

    function pollForSourceStatus() {

      stripe.retrieveSource({id: source, client_secret: client_secret}).then(function(result) {
        var source = result.source;
        //console.log(source);
        //console.log(source.status);

        if (source.status === 'chargeable') {
          // Make a request to your server to charge the Source.
          // Submit Charge Form
          $("#stripeForm").submit();
        } else if (source.status === 'pending' && pollCount < MAX_POLL_COUNT) {
          // Try again in a second, if the Source is still `pending`:
          pollCount += 1;
          setTimeout(pollForSourceStatus, 1000);
        } else {
          // Depending on the Source status, show your customer the relevant message.
          $("#stripeForm #message").text('Zahlung failed');
        }
      });
    }
    pollForSourceStatus();
  }

  return {
    init: init
  };

})();
