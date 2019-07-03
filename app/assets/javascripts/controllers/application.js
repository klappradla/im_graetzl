APP.controllers.application = (function() {



  function init() {

    APP.components.mainNavigation.init();
    APP.components.stream.init();
    APP.components.notificatonCenter.init();

    FastClick.attach(document.body);

    window.cookieconsent_options = {
      "message":"Diese Website verwendet Cookies. Indem Sie weiter auf dieser Website navigieren, stimmen Sie unserer Verwendung von Cookies zu.",
      "dismiss":"OK!","learnMore":"Mehr Information",
      "link":"https://www.imgraetzl.at/info/datenschutz",
      "theme": false
    };

    //injectSponsorCard();

  }


  // TODO: this is a hack! stuff should come from DB
  function injectSponsorCard() {

    var $markup = $('<div class="cardBox -sponsor sponsorstuwerviertel">' +
      '<div class="cardBoxHeader">' +
      '<img src="/assets/img/stuwerlogo.png" width="248" height="315" alt="">' +
      '<div class="sideflag -R">Partner von imGrätzl</div>' +
      '</div>' +
      '<div class="cardBoxContent">' +
      '<img class="eks" src="/assets/img/ek_strassen_logo.jpg" width="118" height="125" alt="">' +
      '<div class="txt">' +
      '<p>Die Wiener Einkaufsstraßen sind eine Aktion der Wirtschaftskammer Wien.</p>' +
      '<p>Gefördert aus den Mitteln der Stadt Wien durch die Wirtschaftsagentur Wien. Ein Fonds der Stadt Wien.</p>' +
      '</div>' +
      '<img class="wko" src="/assets/img/wko_wa_logo.jpg" width="253" height="65" alt="">' +
      '</div>' +
      '</div>');

    if(APP.utils.URLendsWith('/stuwerviertel') && APP.utils.isLoggedIn()) {
      $('.card-grid .cardBox').eq(2).after($markup);
    }
    if(APP.utils.URLendsWith('/stuwerviertel') && !APP.utils.isLoggedIn()) {
      $('main').append($markup);
    }
  }



  // ---------------------------------------------------------------------- Returns

  return {
    init: init
  }

})();
