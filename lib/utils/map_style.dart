import 'dart:convert';

const _mapStyle = [
  //Paisajes
  {
    "featureType": "landscape",
    "elementType": "geometry.fill",
    "stylers": [
      {"color": "#abce83"},
      {"visibility": "on"}
    ]
  },
  //Áreas públicas: parques, escuelas
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {"color": "#769E72"},
      {"visibility": "on"}
    ]
  },
  //Remueve marcadores de áreas públicas
  {
    "featureType": "poi",
    "elementType": "labels",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  //Autopista
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {"color": "#EBF4A4"},
      {"visibility": "on"}
    ]
  }
];

final mapStyle = jsonEncode(_mapStyle);
