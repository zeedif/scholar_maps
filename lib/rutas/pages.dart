import 'package:flutter/widgets.dart';
import 'package:scholar_maps/rutas/rutas.dart';
import 'package:scholar_maps/screens/screens.dart';

Map<String, Widget Function(BuildContext)> appRutas() {
  return {
    Rutas.SPLASH: (_) => const SplashPage(),
    Rutas.HOME: (_) => const ScreenMapState(),
    Rutas.PERMISSIONS: (_) => const SolicitarPermisosPage(),
  };
}
