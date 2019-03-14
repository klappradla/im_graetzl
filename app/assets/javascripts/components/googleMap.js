APP.components.googleMap = (function() {

  function init(lng, lat, zoom, popup, icon, iconopen) {

    var map;
    var coordinates = {lat: lat, lng: lng};

    map = new google.maps.Map(document.getElementById('map'), {
      center: coordinates,
      zoom: zoom,
      styles :
      [
          {
              "featureType": "road",
              "elementType": "geometry",
              "stylers": [
                  {
                      "visibility": "simplified"
                  }
              ]
          },
          {
              "featureType": "road.arterial",
              "stylers": [
                  {
                      "hue": 149
                  },
                  {
                      "saturation": -78
                  },
                  {
                      "lightness": 0
                  }
              ]
          },
          {
              "featureType": "road.highway",
              "stylers": [
                  {
                      "hue": -31
                  },
                  {
                      "saturation": -40
                  },
                  {
                      "lightness": 2.8
                  }
              ]
          },
          {
              "featureType": "poi",
              "stylers": [
                  {
                      "visibility": "off"
                  }
              ]
          },
          {
              "featureType": "landscape",
              "stylers": [
                  {
                      "hue": 163
                  },
                  {
                      "saturation": -26
                  },
                  {
                      "lightness": -1.1
                  }
              ]
          },
          {
              "featureType": "transit",
              "stylers": [
                  {
                      "visibility": "off"
                  }
              ]
          },
          {
              "featureType": "water",
              "stylers": [
                  {
                      "hue": 3
                  },
                  {
                      "saturation": -24.24
                  },
                  {
                      "lightness": 0
                  }
              ]
          }
      ]

    });

    var image = {
      url: icon,
      size: new google.maps.Size(110, 110),
      origin: new google.maps.Point(0, 0),
      anchor: new google.maps.Point(25, 50),
      scaledSize: new google.maps.Size(50, 50)
    };
    var marker = new google.maps.Marker({
      position: coordinates,
      map: map,
      icon: image
    });

    if (typeof popup !== "undefined") {
      var infowindow = new google.maps.InfoWindow({
        content: popup,
        maxWidth: 250,
        pixelOffset: new google.maps.Size(-31, 20)
      });
      marker.addListener('click', function() {
        infowindow.open(map, marker);
      });
      if (typeof iconopen !== "undefined" && iconopen == true) {
        infowindow.open(map,marker);
      }
    }

  }

  return {
      init: init
  }

})();
