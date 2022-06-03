import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart';
import 'package:weather_forecast_app/ui/main_page/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  handlePermission() async {
    final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
    bool serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    LocationPermission permission;

    if (!serviceEnabled) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text("Attention"),
            content: const Text("This app need location access"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close")),
              TextButton(
                onPressed: () {
                  _geolocatorPlatform.openLocationSettings();
                },
                child: const Text("Open Location Settings"),
              ),
            ],
          ),
        ),
      );
      serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text("Attention"),
            content: const Text(
                "This app need location access, please allow from app settings"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close")),
              TextButton(
                onPressed: () {
                  _geolocatorPlatform.openAppSettings();
                  Navigator.pop(context);
                },
                child: const Text("Open Application Settings"),
              ),
            ],
          ),
        ),
      );
      // SystemNavigator.pop();
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return true;

    // final Location _location = Location();
    // bool? _serviceEnabled = await _location.serviceEnabled();
    // if (_serviceEnabled) {
    //   _serviceEnabled = await _location.requestService();
    //   if (!_serviceEnabled) {
    //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text("Cannot running app without location",
    //           style: TextStyle(color: Colors.white)),
    //     ));
    //     SystemNavigator.pop();
    //   }
    // }

    // PermissionStatus? _permissionGranted = await _location.hasPermission();
    // if (_permissionGranted == PermissionStatus.deniedForever) {
    //   // _alert();
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text(
    //         "Cannot running app without location, Please grant access location manually from your app settings",
    //         style: TextStyle(color: Colors.white)),
    //   ));
    //   SystemNavigator.pop();
    // } else if (_permissionGranted == PermissionStatus.denied) {
    //   _permissionGranted = await _location.requestPermission();
    //   if (_permissionGranted != PermissionStatus.granted) {
    //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text("Cannot running app without location",
    //           style: TextStyle(color: Colors.white)),
    //     ));
    //     SystemNavigator.pop();
    //   }
    // }
    // Future.delayed(const Duration(seconds: 2), () {
    //   Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (context) => const MainPage()));
    // });
  }

  initLocation() async {
    final hasPermission = await handlePermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Cannot running app without location",
            style: TextStyle(color: Colors.white)),
      ));
      SystemNavigator.pop();
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainPage()));
    }
  }

  @override
  void initState() {
    initLocation();
    super.initState();
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
