import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scholar_maps/screens/splash/splash_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _controller = SplashController(Permission.locationWhenInUse);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.checkPermission();
    });
    _controller.addListener(() {
      if (_controller.routeName != null) {
        Navigator.pushReplacementNamed(context, _controller.routeName!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green.shade600,
        alignment: Alignment.center,
        child: const Icon(
          CupertinoIcons.placemark_fill,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}
