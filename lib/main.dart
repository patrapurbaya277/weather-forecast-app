import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ui/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xff000918),
        statusBarColor: Color(0xff82DAF4),
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return MaterialApp(
      title: 'Weather Forecast',
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DashboardPage(),
    );
  }
}
