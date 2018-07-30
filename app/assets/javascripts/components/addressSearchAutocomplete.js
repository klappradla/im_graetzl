APP.components.addressSearchAutocomplete = function() {
    var $featureHiddenField = $("#feature");

    function updateFeatureHiddenField(obj) {
        $featureHiddenField.val(JSON.stringify(obj));
    }

    var addressSearch = new Bloodhound({
        datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        limit: 7,
        remote: {
            url:  APP.config.adressSearchOpenGov + '%QUERY' + '&crs=EPSG:4326',
            filter: function(addresses) {
                updateFeatureHiddenField(addresses.features[0]);
                return addresses.features;
            }
        }
    });
    addressSearch.initialize();

    $('#address').typeahead(null, {
        name: 'addresse',
        source: addressSearch.ttAdapter(),
        displayKey: function (data) {
            return data.properties.Adresse;
        },
        templates: {
            suggestion: function(data) {
                return data.properties.Adresse +'<span class="district">Bezirk: ' + data.properties.Bezirk + '</span>'
            }
        }
    }).on('typeahead:selected typeahead:autocompleted', function(event, suggestion) {
        updateFeatureHiddenField(suggestion);
    });

};
