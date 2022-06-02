import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:weather_forecast_app/ui/main_page/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final Location _location = Location();
  PermissionStatus? _permissionGranted;

  initLocation() async {
    bool _serviceEnabled;
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Cannot running app without location", style: TextStyle(color: Colors.white)),
        ));
        SystemNavigator.pop();
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.deniedForever) {
      // _alert();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Cannot running app without location, Please grant access location manually from your app settings", style: TextStyle(color: Colors.white)),
      ));
      SystemNavigator.pop();
    } else if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Cannot running app without location", style: TextStyle(color: Colors.white)),
        ));
        SystemNavigator.pop();
      }
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainPage()));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initLocation();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xff000918),
        statusBarColor: Color(0xff000918),
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      backgroundColor: const Color(0xff000918),
      body: Center(
        child: Image.asset(
          "assets/images/appIcon.png",
          height: 100,
          width: 100,
        ),
      ),
    );
  }
}
