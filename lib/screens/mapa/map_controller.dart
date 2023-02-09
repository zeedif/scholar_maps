import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scholar_maps/utils/map_style.dart';

class MapController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};
  bool dibujado1 = false;
  Map<MarkerId, Marker> get listaMarcadores => _markers;
  List idMarcadores = [];

  Set<Marker> get markers => _markers.values.toSet();
  int _pantallaSig = 1;
  int get pantallaSig => _pantallaSig;
  bool _addMarcadores = false;
  bool get addMarcadores => _addMarcadores;
  String _removeIdMarcador = "";
  String get removeIdMarcador => _removeIdMarcador;
  final _markersController = StreamController<String>.broadcast();
  Stream<String> get onMarkerTap => _markersController.stream;
  GoogleMapController? mapController;
  PageController scrollControl = PageController();

  final posicionInicialCamara = const CameraPosition(
    target: LatLng(18.07472, -93.16653),
    zoom: 19.4,
  );

  Future<void> turnOnGPS() => Geolocator.openLocationSettings();

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(mapStyle);
    if (!dibujado1) {
      mapController = controller;
      idMarcadores.add(
          ['001','Entrada principal', '', const LatLng(18.075549327291892, -93.1661405414343),true]);
      idMarcadores.add(
          ['002','Cafetería de DACyTI', '', const LatLng(18.074639033037865, -93.16696532070637),true]);
      idMarcadores.add(
          ['003','Baños de DACyTI', '', const LatLng(18.074456399903692, -93.16739346832037),true]);
      idMarcadores.add(
          ['004','Edificio E', '', const LatLng(18.07497083201536, -93.16621229052545),true]);
      idMarcadores.add(
          ['005','Baños X', '', const LatLng(18.074565087358952, -93.16831313073634),true]);
      idMarcadores.add(
          ['006','Auditorio Palavicini', '', const LatLng(18.074667081390675, -93.16870003938675),true]);
      idMarcadores.add(
          ['007','Edificio M', '', const LatLng(18.074496878817193, -93.16746119409801),true]);
      idMarcadores.add(
          ['008','Biblioteca', '', const LatLng(18.074992505701974, -93.1685508415103),true]);
      idMarcadores.add(
          ['009','Centro de Investigación', '', const LatLng(18.075651639481254, -93.16899977624415),true]);
      idMarcadores.add(
          ['010','Edificio K', '', const LatLng(18.074306914701356, -93.16745817661285),true]);
      idMarcadores.add(
          ['011','Edificio U', '', const LatLng(18.074352493358624, -93.16754601895809),true]);
      idMarcadores.add(
          ['012','Edificio J', '', const LatLng(18.074549150786147, -93.16718827933074),true]);
      idMarcadores.add(
          ['013','Edificio L', '', const LatLng(18.074190577515513, -93.16746085882187),true]);
      idMarcadores.add(
          ['014','Edificio I', '', const LatLng(18.074744851800038, -93.16767174750566),true]);
      idMarcadores.add(
          ['015','Estacionamiento', '', const LatLng(18.074303408650298, -93.16816728562115),true]);
      idMarcadores.add(
          ['016','Edificio X', '', const LatLng(18.074424208005205, -93.16799461841583),true]);
      idMarcadores.add(
          ['017','Baños Y', '', const LatLng(18.075206692578664, -93.16655460745096),true]);
      idMarcadores.add(
          ['018','Edificio W', '', const LatLng(18.075015135577775, -93.16620524972677),true]);
      idMarcadores.add(
          ['019','Edificio W', '', const LatLng(18.075394743341278, -93.16650565713644),true]);
      idMarcadores.add(
          ['020','Edificio P', '', const LatLng(18.075159201760993, -93.16635310649872),true]);
      idMarcadores.add(
          ['021','Cafetería de DACB', '', const LatLng(18.074719353308957, -93.16807072609663),true]);
      idMarcadores.add(
          ['022','Cafetería de DAIA', '', const LatLng(18.073420837754423, -93.16508240997793),true]);
      idMarcadores.add(
          ['023','Edificio de CELE', '', const LatLng(18.072617627449244, -93.16503312438726),true]);
      idMarcadores.add(
          ['024','Cancha', '', const LatLng(18.075153783344742, -93.16944133490325),true]);
      idMarcadores.add(
          ['025','Edificio Y', '', const LatLng(18.075268207511307, -93.16673867404461),true]);
      idMarcadores.add(
          ['026','Sala audiovisual Y1', '', const LatLng(18.075242709096255, -93.16667463630436),true]);
      idMarcadores.add(
          ['027','Sala audiovisual X1', '', const LatLng(18.074475842532607, -93.1681042537093),true]);
      idMarcadores.add(
          ['028','Sala audiovisual X2', '', const LatLng(18.074484129554097, -93.1681327521801),true]);
      idMarcadores.add(
          ['028','Baños K', '', const LatLng(18.074226594241555, -93.16724393516779),true]);
      idMarcadores.add(
          ['029','Entrada vehicular', '', const LatLng(18.07534884622457, -93.17106373608112),true]);
      idMarcadores.sort((a, b) => a[1].compareTo(b[1]));
      for (var i = 0; i < idMarcadores.length; i++) {
        crearMarcador(idMarcadores[i]);
      }
      dibujado1 = true;
    }
    notifyListeners();
  }

  void crearMarcador(List marcador) {
    _markers[MarkerId(marcador[0])] = Marker(
      markerId: MarkerId(marcador[0]),
      position: marcador[3],
      draggable: marcador[4] ? false : true,
      rotation: 0,
      infoWindow: InfoWindow(title: marcador[1], snippet: marcador[2]),
      onTap: () {
        _markersController.sink.add(marcador[0]);
        _removeIdMarcador = marcador[4] ? "" : marcador[0];
        notifyListeners();
      },
      onDragEnd: (newPosition) {},
    );
  }

  void cambiarPantalla() {
    scrollControl.animateToPage(_pantallaSig,
        duration: const Duration(milliseconds: 350), curve: Curves.linear);
    if (_pantallaSig == 1) {
      _pantallaSig = 0;
    } else {
      _pantallaSig = 1;
    }
    notifyListeners();
  }

  void removeIdMarcadorTo0() {
    _removeIdMarcador = "";
    notifyListeners();
  }

  bool setAddMarcadores() {
    if (!_addMarcadores) {
      _addMarcadores = true;
    } else {
      _addMarcadores = false;
    }
    notifyListeners();
    return _addMarcadores;
  }

  void onTapMarcadores(LatLng position, TextEditingController textMarkTitulo,
      TextEditingController textMarkDescription) async {
        
    print(position);
    final id = Random().nextDouble().toString();
    idMarcadores.add(
        [id, textMarkTitulo.text, textMarkDescription.text, position, false]);
    crearMarcador([id, textMarkTitulo.text, textMarkDescription.text, position, false]);
    notifyListeners();
  }

  void borrarMarcador() {
    if (_removeIdMarcador != "") {
      for (var elem in idMarcadores) {
        if(elem.contains(_removeIdMarcador)){
          idMarcadores.remove(elem);
        }
      }
      idMarcadores.contains(_removeIdMarcador);
      _markers.remove(MarkerId(_removeIdMarcador));
      _removeIdMarcador = "";
      notifyListeners();
    }
  }

  Position? _posicionActual;
  Position? get posicionActual => _posicionActual;
  bool _loading = true;
  bool get loading => _loading;
  late bool _gpsEnabled;
  bool get gpsEnabled => _gpsEnabled;
  StreamSubscription? _gpsSubscription, _positionSubscription;
  MapController() {
    _init();
  }
  Future<void> _init() async {
    _gpsEnabled = await Geolocator.isLocationServiceEnabled();
    _loading = false;
    _gpsSubscription = Geolocator.getServiceStatusStream().listen(
      (status) {
        _gpsEnabled = status == ServiceStatus.enabled;
        if (_gpsEnabled) {
          _initLocationUpdates();
        }
      },
    );
    _initLocationUpdates();
  }

  Future<void> _initLocationUpdates() async {
    bool completado = false;
    await _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream().listen((position) {
      if (!completado) {
        _setPosition(position);
        completado = true;
        notifyListeners();
      }
    }, onError: (e) {
      if (e is LocationServiceDisabledException) {
        _gpsEnabled = false;
        notifyListeners();
      }
    });
  }

  void _setPosition(Position position) {
    if (_gpsEnabled) {
      _posicionActual = position;
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _gpsSubscription?.cancel();
    _markersController.close();
    super.dispose();
  }
}
