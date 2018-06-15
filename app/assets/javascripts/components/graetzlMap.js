APP.components.graetzlMap = (function() {
    var map,
        //mainLayer =  L.tileLayer.provider('Stamen.Watercolor'),
        mainLayer = L.tileLayer.provider('MapBox', { id: 'peckomingo.lb8m2cga', accessToken: 'pk.eyJ1IjoicGVja29taW5nbyIsImEiOiJoVHNQM29zIn0.AVmpyDYApR5mryMCJB1ryw'}),

        styles = {
            mint: {
                color: '#93CFC6',
                fill: '#93CFC6',
                opacity: 1,
                weight: 2,
                fillOpacity: 0.1
            },
            over: {
                fillOpacity: 0.8
            },
            rose: {
                color: '#F37468',
                fill: '#F37468',
                opacity: 1,
                weight: 2,
                fillOpacity: 0.1
            }
        },

        defaults = {
            interactive: false,
            zoomAfterRender: true,
            style: styles.rose
        };

    function init(callback, options) {
        var interactive = (options && options.interactive) || false;
        map = L.map('graetzlMapWidget', {
            layers: [mainLayer],
            dragging: interactive,
            touchZoom: interactive,
            scrollWheelZoom: interactive,
            doubleClickZoom: interactive,
            boxZoom: false,
            tap: false
        }).setActiveArea('activeArea');
        callback();
    }


    function highlightMapNav(k) {
        $(".navBlock .links").find('a[href*="'+ k + '"]').addClass('is-highlighted');
    }
    function unhighlightMapNav(k) {
        $(".navBlock .links").find('a[href*="'+ k + '"]').removeClass('is-highlighted');
    }
    function handlehighlightMapPoly(layer, k) {
        $(".navBlock .links").find('a[href*="'+  k + '"]')
            .on("mouseover", function() { layer.setStyle(styles.over) })
            .on("mouseout", function() { layer.setStyle(styles.rose) })
    }

    function showMapDistrict(districts, options) {
        var config = $.extend({}, defaults, options);
        var districtMap = L.geoJson(districts, {
            style: function () {
                return config.style
            },
            onEachFeature: function (feature, layer) {
                handlehighlightMapPoly(layer, feature.properties.targetURL);
                if (config.interactive) {
                    layer.on('click', function () {
                        window.location.href = feature.properties.targetURL;
                    });
                    layer.on('mouseover', function () {
                        this.setStyle(styles.over);
                        highlightMapNav(feature.properties.targetURL);
                    });
                    layer.on('mouseout', function () {
                        districtMap.resetStyle(layer);
                        unhighlightMapNav(feature.properties.targetURL);
                    });
                }
            }
        });

        map.addLayer(districtMap, true);
        if(config.zoomAfterRender) {
            map.fitBounds(districtMap.getBounds());
        }
        return this;
    }

    function showMapGraetzl(graetzls, options) { // Array or String
        var config = $.extend({}, defaults, options);
        var graetzlMap = L.geoJson(graetzls, {
            style: function() {
                return config.style;
            },
            onEachFeature: function (feature, layer) {
                handlehighlightMapPoly(layer, feature.properties.targetURL);
                if (config.interactive) {
                    layer.on('click', function () {
                        window.location.href = feature.properties.targetURL;
                    });
                    layer.on('mouseover', function () {
                        this.setStyle(styles.over);
                        highlightMapNav(feature.properties.targetURL);
                    });
                    layer.on('mouseout', function () {
                        graetzlMap.resetStyle(layer);
                        unhighlightMapNav(feature.properties.targetURL);

                    });
                }
            }
        });

        map.addLayer(graetzlMap);
        if(config.zoomAfterRender == true) {
            map.fitBounds(graetzlMap.getBounds());
        }
        return this;
    }
    
    function showMapAddress(addresses, graetzls, options) { // Array or String
        var config = $.extend({}, defaults, options);
        var addressesMap = L.geoJson(addresses, {
            style: function() {
                return config.style;
            },
            onEachFeature: function (feature, layer) {
                handlehighlightMapPoly(layer, feature.properties.targetURL);
                if (config.interactive) {
                    layer.on('click', function () {
                        window.location.href = feature.properties.targetURL;
                    });
                    layer.on('mouseover', function () {
                        this.setStyle(styles.over);
                        highlightMapNav(feature.properties.targetURL);
                    });
                    layer.on('mouseout', function () {
                        graetzlMap.resetStyle(layer);
                        unhighlightMapNav(feature.properties.targetURL);

                    });
                }
            }
        });
        var graetzlMap = L.geoJson(graetzls);

        map.addLayer(addressesMap);
        if(config.zoomAfterRender == true) {
          var coords = L.latLng(addresses.features[0].geometry.coordinates);
          map.fitBounds(graetzlMap.getBounds()).panTo(addressesMap.getBounds().getCenter()).zoomIn(1);
        }
        return this;
    }


    function getMap() {
        return map;
    }



    //show single grätzl in header
    function showSingleGraetzlHeader() {
        var mapvisible= $('#graetzlMapWidget').data('mapvisible');
        init(function() {
                showMapGraetzl(mapvisible.graetzls, null, {
                    style: $.extend(styles.rose, {
                        weight: 4,
                        fillOpacity: 0.2
                    })
                });

            }
        );
    }

    return {
        styles: styles,
        init: init,
        showMapGraetzl: showMapGraetzl,
        showMapDistrict: showMapDistrict,
        showMapAddress: showMapAddress,
        getMap: getMap,
        showSingleGraetzlHeader: showSingleGraetzlHeader
    }


})();


