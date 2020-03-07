import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link/calculations/utility.dart';
import 'package:link/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var utility = new Utility();
    utility.search("Adidas");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Locator',
      theme: ThemeData(fontFamily: 'VarelaRound'),
      home: SplashScreen(),
    );
  }
}
