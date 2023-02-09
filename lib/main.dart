import 'package:flutter/material.dart';
import 'package:scholar_maps/rutas/pages.dart';
import 'package:scholar_maps/rutas/rutas.dart';

void main() {
  runApp(
    const ScholarMaps(),
  );
}

class ScholarMaps extends StatelessWidget {
  const ScholarMaps ({Key? key}) :super (key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scholar Maps',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: Rutas.SPLASH,
      routes: appRutas(),
    );
  }
}