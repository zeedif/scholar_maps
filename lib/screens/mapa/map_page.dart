import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scholar_maps/screens/mapa/map_controller.dart';

class ScreenMapState extends StatelessWidget {
  const ScreenMapState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapController>(
      create: (_) {
        final controller = MapController();
        controller.onMarkerTap.listen((String id) {});
        return controller;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Schoolar Maps"),
        ),
        resizeToAvoidBottomInset: false,
        floatingActionButton: Consumer<MapController>(
          builder: (_, controller, __) {
            Color fondoR = Colors.green.shade400;
            Color fondoBorrar = Colors.red.shade200;
            Widget iconP = const Icon(Icons.chevron_right);
            if (controller.addMarcadores) {
              fondoR = Colors.green.shade800;
            }
            if (controller.pantallaSig == 0) {
              iconP = const Icon(Icons.chevron_left);
            }
            if (controller.removeIdMarcador != "") {
              fondoBorrar = Colors.red.shade800;
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.green.shade400,
                  onPressed: controller.cambiarPantalla,
                  child: iconP,
                ),
                const SizedBox(
                  height: 20,
                ),
                FloatingActionButton(
                  backgroundColor: fondoR,
                  onPressed: () {
                    controller.setAddMarcadores();
                  },
                  child: const Icon(Icons.add_location_alt_outlined),
                ),
                const SizedBox(
                  height: 20,
                ),
                FloatingActionButton(
                  backgroundColor: fondoBorrar,
                  onPressed: () {
                    controller.borrarMarcador();
                  },
                  child: const Icon(Icons.delete),
                ),
              ],
            );
          },
        ),
        body: Selector<MapController, bool>(
          selector: (_, controller) => controller.loading,
          builder: (context, loading, loadingWidget) {
            if (loading) {
              return loadingWidget!;
            }
            return Consumer<MapController>(
              builder: (_, controller, gpsMessageWidget) {
                if (!controller.gpsEnabled) {
                  return gpsMessageWidget!;
                }
                return PageView(
                  controller: controller.scrollControl,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    GoogleMapWidget(),
                    ListaMarcadores(),
                  ],
                );
              },
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        "Para utiliza la aplicación debe habilitar el GPS"),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        final controller = context.read<MapController>();
                        controller.turnOnGPS();
                      },
                      child: const Text(
                        "Activar GPS",
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class ListaMarcadores extends StatelessWidget {
  const ListaMarcadores({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MapController>(builder: (_, controller, __) {
      return ListView.builder(
        itemCount: controller.idMarcadores.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.green.shade400)),
            child: InkWell(
              highlightColor: Colors.green.shade300,
              onTap: () {
                controller.cambiarPantalla();
                controller.mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                        target: controller.idMarcadores[index][3], zoom: 50)));
              },
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      controller.idMarcadores[index][1],
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({Key? key}) : super(key: key);

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Consumer<MapController>(
      builder: (_, controller, __) {
        return GoogleMap(
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          trafficEnabled: false,
          rotateGesturesEnabled: false,
          initialCameraPosition: controller.posicionInicialCamara,
          onMapCreated: controller.onMapCreated,
          markers: controller.markers,
          onTap: (LatLng position) {
            if (controller.addMarcadores) {
              controller.removeIdMarcadorTo0();
              TextEditingController _textMarkTitulo = TextEditingController();
              TextEditingController _textMarkDescription =
                  TextEditingController();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Nuevo marcador:"),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          onChanged: (value) {},
                          controller: _textMarkTitulo,
                          decoration: const InputDecoration(
                              hintText: "Ingrese un título:"),
                        ),
                        TextField(
                          onChanged: (value) {},
                          controller: _textMarkDescription,
                          decoration: const InputDecoration(
                              hintText: "Ingrese una descripción:"),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      MaterialButton(
                        color: Colors.red,
                        textColor: Colors.white,
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      MaterialButton(
                        color: Colors.green,
                        textColor: Colors.white,
                        child: const Text('Guardar'),
                        onPressed: () {
                          if (_textMarkTitulo.text.isNotEmpty) {
                            controller.onTapMarcadores(position,
                                _textMarkTitulo, _textMarkDescription);
                            Navigator.pop(context);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Advertencia"),
                                  content: const Text(
                                      "Coloque un título al marcador"),
                                  actions: <Widget>[
                                    MaterialButton(
                                      color: Colors.red,
                                      textColor: Colors.white,
                                      child: const Text('Aceptar'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          minMaxZoomPreference: const MinMaxZoomPreference(17.4, 50),
          cameraTargetBounds: CameraTargetBounds(
            LatLngBounds(
              northeast: const LatLng(18.077530, -93.164023),
              southwest: const LatLng(18.072634, -93.171166),
            ),
          ),
        );
      },
    );
  }
}
