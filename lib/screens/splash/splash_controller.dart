import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:permission_handler/permission_handler.dart';
import 'package:scholar_maps/rutas/rutas.dart';

class SplashController extends ChangeNotifier {
  final Permission _locationPermission;
  String? _routeName;
  String? get routeName => _routeName;

  SplashController(this._locationPermission);

  Future<void> checkPermission() async {
    final isGranted = await _locationPermission.isGranted;
    _routeName = isGranted ? Rutas.HOME : Rutas.PERMISSIONS;
    notifyListeners();
  }
}
