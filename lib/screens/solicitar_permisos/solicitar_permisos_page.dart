import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scholar_maps/rutas/rutas.dart';
import 'package:scholar_maps/screens/solicitar_permisos/solicitar_permisos_controller.dart';

class SolicitarPermisosPage extends StatefulWidget {
  const SolicitarPermisosPage({Key? key}) : super(key: key);

  @override
  State<SolicitarPermisosPage> createState() => _SolicitarPermisosPageState();
}

class _SolicitarPermisosPageState extends State<SolicitarPermisosPage>
    with WidgetsBindingObserver {
  final _controller = SolicitarPermisosController(Permission.locationWhenInUse);
  late StreamSubscription _subscription;
  bool _fromSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscription = _controller.onStatusChanged.listen(
      (status) {
        switch (status) {
          case PermissionStatus.granted:
            _irAlHome();
            break;
          case PermissionStatus.denied:
          case PermissionStatus.restricted:
          case PermissionStatus.limited:
          case PermissionStatus.permanentlyDenied:
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("INFO"),
                content: const Text("Proporcione permisos de ubicación."),
                actions: [
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      _fromSettings = await openAppSettings();
                    },
                    child: const Text("Ir a a ajustes"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancelar"),
                  ),
                ],
              ),
            );
            break;
        }
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && _fromSettings) {
      final status = await _controller.check();
      if (status == PermissionStatus.granted) {
        _irAlHome();
      }
    }
    _fromSettings = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _irAlHome() {
    Navigator.pushReplacementNamed(context, Rutas.HOME);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schoolar Maps"),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        child: ElevatedButton(
          child: const Text("Permitir acceso a la ubicación"),
          onPressed: () {
            _controller.request();
          },
        ),
      ),
    );
  }
}
