var APP = {

    config: {
        notificationPollInterval: 30*1000,
        adressSearchOpenGov: 'https://data.wien.gv.at/daten/OGDAddressService.svc/GetAddressInfo?Address=',
        majorBreakpoints: {
            //breakpoints should be the same like in the file include_media.scss
            //TODO: maybe use one shared JSON config for JS and SASS breakpoints
            small: 320,
            medium: 650,
            large: 1015
        }
    },

    utils: {},
    components: {},
    controllers: {},

    init: function() {
        APP.controllers.application.init();
        var pageToInit = $("body").attr("data-controller");
        APP.controllers[pageToInit] && APP.controllers[pageToInit].init();
    }
};
